package common
{
   import Facebook.FaceMgr;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   import it.gotoandplay.smartfoxserver.data.User;
   
   public class Client
   {
      
      private static const ZONE_NAME:String = "zrr";
      
      private static const LOBBY_NAME:String = "lrr";
      
      private static const EXT_NAME:String = "grr";
      
      public static const CMD_LOBBY_JOIN:String = "ljoin";
      
      public static const CMD_ADDFRIENDS:String = "addfriends";
      
      public static const CMD_JOIN:String = "join";
      
      public static const CMD_JOIN_PARAM_RANDOM:String = "r";
      
      public static const CMD_JOIN_PARAM_FRIEND:String = "f";
      
      public static const CMD_READY:String = "ready";
      
      public static const CMD_START:String = "start";
      
      public static const CMD_MOVE:String = "mv";
      
      public static const CMD_GET_ITEM:String = "atm";
      
      public static const CMD_ADD_ITEM:String = "ati";
      
      public static const CMD_SET_LAP:String = "sl";
      
      public static const CMD_SYNC:String = "sync";
      
      public static const CMD_MANAGER:String = "mng";
      
      public static const CMD_MOVE_NEWTILE:String = "nt";
      
      public static const CMD_MOVE_STATE:Array = ["s","m"];
      
      public static const CMD_SETBOMB:String = "sb";
      
      public static const CMD_KILL_PLAYER:String = "kip";
      
      public static const CMD_GAME_OVER:String = "go";
      
      public static const CMD_GAME_END:String = "ge";
      
      public static const CMD_BOMB:String = "bst";
      
      public static const CMD_BOMB_STATE:Array = ["s","m","e"];
      
      public static const CMD_UFO:String = "ufo";
      
      public static const CMD_UFO_STATE:String = "ufos";
      
      public static const CMD_HAND:String = "hd";
      
      public static const CMD_NEW_PLAYER:String = "np";
      
      public static const CMD_REMOVE_ITEM:String = "los";
      
      private static var _sfs:SmartFoxClient;
      
      private static var _userInfo:Object;
      
      public static var multiInfo:Object;
      
      public static var funcs:Object = {};
      
      public static var isLogin:Boolean = false;
      
      public static var isRoomListUpdate:Boolean = false;
      
      private static var _calledAddFriends:Boolean;
       
      
      private var totalPingTime:Number = 0;
      
      private var pingCount:int = 0;
      
      public function Client()
      {
         super();
         _sfs = new SmartFoxClient(false);
         _sfs.addEventListener(SFSEvent.onConnection,this.onConnection);
         _sfs.addEventListener(SFSEvent.onConnectionLost,this.onConnectionLost);
         _sfs.addEventListener(SFSEvent.onLogin,this.onLogin);
         _sfs.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListUpdate);
         _sfs.addEventListener(SFSEvent.onJoinRoom,this.onJoinRoom);
         _sfs.addEventListener(SFSEvent.onUserEnterRoom,this.onUserEnterRoom);
         _sfs.addEventListener(SFSEvent.onUserLeaveRoom,this.onUserLeaveRoom);
         _sfs.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponse);
         _sfs.addEventListener(SFSEvent.onRoundTripResponse,this.onRoundTripResponseHandler);
      }
      
      public static function roundTrip() : void
      {
         _sfs.roundTripBench();
      }
      
      public static function login() : void
      {
         var _loc1_:Object = null;
         if(!_sfs.isConnected)
         {
            _sfs.connect(RGameCommon.g_sfsIp);
            return;
         }
         if(!isLogin)
         {
            _userInfo = null;
            _loc1_ = RGameCommon.g_UserInfo;
            _sfs.login(ZONE_NAME,RGameCommon.g_UserInfo.uid.toString(),"");
         }
      }
      
      public static function connect() : Boolean
      {
         if(_sfs.isConnected)
         {
            if(_sfs.activeRoomId != -1)
            {
               if(funcs.join != null)
               {
                  funcs.join();
               }
            }
            return true;
         }
         _sfs.connect(RGameCommon.g_sfsIp);
         return false;
      }
      
      public static function add_friends(param1:String) : void
      {
         if(_sfs.isConnected)
         {
            _sfs.sendXtMessage(EXT_NAME,CMD_ADDFRIENDS,[param1],SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
         }
         else
         {
            _sfs.connect(RGameCommon.g_sfsIp);
         }
      }
      
      public static function join_friend() : void
      {
         if(_sfs.isConnected)
         {
            _sfs.sendXtMessage(EXT_NAME,CMD_JOIN,["fb",CMD_JOIN_PARAM_FRIEND],SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
         }
         else
         {
            _sfs.connect(RGameCommon.g_sfsIp);
         }
      }
      
      public static function join_random() : void
      {
         if(_sfs.isConnected)
         {
            _sfs.sendXtMessage(EXT_NAME,CMD_JOIN,["fb",CMD_JOIN_PARAM_RANDOM],SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
         }
         else
         {
            _sfs.connect(RGameCommon.g_sfsIp);
         }
      }
      
      public static function leave_game() : void
      {
         if(!_sfs.isConnected)
         {
            _sfs.connect(RGameCommon.g_sfsIp);
            return;
         }
         if(_sfs.getActiveRoom().getName() == LOBBY_NAME)
         {
            return;
         }
         Client.funcs = {};
         _sfs.sendXtMessage(EXT_NAME,CMD_LOBBY_JOIN,"",SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function isRobbyRoom() : Boolean
      {
         if(_sfs.getActiveRoom().getName() == LOBBY_NAME)
         {
            return true;
         }
         return false;
      }
      
      public static function ready(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_READY,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function setLap(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_SET_LAP,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function start() : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_START,"",SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function sync(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_SYNC,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function addItem(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_ADD_ITEM,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function sendState(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_MOVE,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function setupBomb(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_SETBOMB,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function killPlayer(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_KILL_PLAYER,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function getItem(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_GET_ITEM,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function gameOver(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_GAME_OVER,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function bombState(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_BOMB,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function ufo(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_UFO,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function ufoState(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_UFO_STATE,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function hand(param1:Array) : void
      {
         _sfs.sendXtMessage(EXT_NAME,CMD_HAND,param1,SmartFoxClient.XTMSG_TYPE_STR,_sfs.activeRoomId);
      }
      
      public static function get myUserId() : int
      {
         return _sfs.myUserId;
      }
      
      public static function getUserInfoList() : Array
      {
         var _loc3_:* = null;
         var _loc4_:User = null;
         var _loc5_:Array = null;
         var _loc1_:Array = _sfs.getActiveRoom().getUserList();
         var _loc2_:Array = [];
         for(_loc3_ in _loc1_)
         {
            (_loc5_ = (_loc4_ = _loc1_[_loc3_]).getVariables())["uid"] = _loc4_.getId();
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      public static function getUserInfo(param1:int) : Array
      {
         var _loc2_:User = _sfs.getActiveRoom().getUser(param1);
         var _loc3_:Array = _loc2_.getVariables();
         _loc3_.pId = param1;
         return _loc3_;
      }
      
      private function onRoundTripResponseHandler(param1:SFSEvent) : void
      {
         var _loc2_:int = param1.params.elapsed;
         this.totalPingTime += _loc2_ / 2;
         ++this.pingCount;
         var _loc3_:int = Math.round(this.totalPingTime / this.pingCount);
      }
      
      private function onConnection(param1:SFSEvent) : void
      {
         var _loc2_:Boolean = param1.params.success;
         isLogin = false;
         if(_loc2_)
         {
            trace("Connection successfull!");
            login();
         }
         else
         {
            trace("Connection failed!");
         }
      }
      
      private function onConnectionLost(param1:SFSEvent) : void
      {
         trace("Connection lost!");
      }
      
      private function onLogin(param1:SFSEvent) : void
      {
         if(param1.params.success)
         {
            trace("Successfully logged in");
            _calledAddFriends = false;
            isLogin = true;
            isRoomListUpdate = false;
         }
         else
         {
            trace("Login failed. Reason: " + param1.params.error);
         }
      }
      
      private function onRoomListUpdate(param1:SFSEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         trace("Room list received");
         isRoomListUpdate = true;
         if(isLogin)
         {
            isLogin = false;
            _sfs.autoJoin();
            if(!_calledAddFriends)
            {
               _loc2_ = FaceMgr.Users;
               if(_loc2_ != null)
               {
                  _loc3_ = "";
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.length)
                  {
                     _loc3_ = _loc3_ + _loc2_[_loc4_].uid + ",";
                     if(_loc3_.length > 2048)
                     {
                        Client.add_friends(_loc3_);
                        _loc3_ = "";
                     }
                     _loc4_++;
                  }
                  if(_loc3_.length > 0)
                  {
                     Client.add_friends(_loc3_);
                  }
               }
               _calledAddFriends = true;
            }
         }
      }
      
      private function onJoinRoom(param1:SFSEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         trace("Successfully joined room: " + param1.params.room.getName());
         if(!_userInfo)
         {
            _userInfo = RGameCommon.g_UserInfo;
            _loc2_ = {};
            _loc2_.firstname = RGameCommon.g_UserInfo.firstName;
            _loc2_.lastname = RGameCommon.g_UserInfo.lastName;
            _loc2_.picsquare = RGameCommon.g_UserInfo.picsquare;
            _loc2_.totalpoint = RGameCommon.g_UserInfo.coins;
            _loc3_ = int(RGameCommon.g_UserInfo.maps[0].personalbest);
            if(_loc3_ != 0)
            {
               _loc4_ = (_loc4_ = int(_loc3_ / 60) + " : ") + int(_loc3_ - int(_loc3_ / 60) * 60);
            }
            else
            {
               _loc4_ = "--:--";
            }
            _loc2_.level1time = _loc4_;
            _loc3_ = int(RGameCommon.g_UserInfo.maps[1].personalbest);
            if(_loc3_ != 0)
            {
               _loc4_ = (_loc4_ = int(_loc3_ / 60) + " : ") + int(_loc3_ - int(_loc3_ / 60) * 60);
            }
            else
            {
               _loc4_ = "--:--";
            }
            _loc2_.level2time = _loc4_;
            _loc3_ = int(RGameCommon.g_UserInfo.maps[2].personalbest);
            if(_loc3_ != 0)
            {
               _loc4_ = (_loc4_ = int(_loc3_ / 60) + " : ") + int(_loc3_ - int(_loc3_ / 60) * 60);
            }
            else
            {
               _loc4_ = "--:--";
            }
            _loc2_.level3time = _loc4_;
            _loc3_ = int(RGameCommon.g_UserInfo.maps[3].personalbest);
            if(_loc3_ != 0)
            {
               _loc4_ = (_loc4_ = int(_loc3_ / 60) + " : ") + int(_loc3_ - int(_loc3_ / 60) * 60);
            }
            else
            {
               _loc4_ = "--:--";
            }
            _loc2_.level4time = _loc4_;
            _loc3_ = int(RGameCommon.g_UserInfo.maps[4].personalbest);
            if(_loc3_ != 0)
            {
               _loc4_ = (_loc4_ = int(_loc3_ / 60) + " : ") + int(_loc3_ - int(_loc3_ / 60) * 60);
            }
            else
            {
               _loc4_ = "--:--";
            }
            _loc2_.level5time = _loc4_;
            _sfs.setUserVariables(_loc2_);
         }
         multiInfo = null;
         if(funcs.join != null)
         {
            funcs.join();
         }
      }
      
      private function onUserEnterRoom(param1:SFSEvent) : void
      {
         if(funcs.enter != null)
         {
            funcs.enter();
         }
      }
      
      private function onUserLeaveRoom(param1:SFSEvent) : void
      {
         if(funcs.leave != null)
         {
            funcs.leave(param1.params.userId);
         }
      }
      
      private function onExtensionResponse(param1:SFSEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:* = param1.params.dataObj;
         var _loc4_:uint = _sfs.myUserId;
         if(param1.params.type == "xml")
         {
            _loc3_ = _loc2_.re;
         }
         else
         {
            _loc3_ = _loc2_[0];
         }
         switch(_loc3_)
         {
            case CMD_READY:
               multiInfo = _loc2_;
         }
         if(funcs[_loc3_] != null)
         {
            funcs[_loc3_](_loc2_);
         }
      }
   }
}
