package it.gotoandplay.smartfoxserver
{
   import com.adobe.serialization.json.JSON;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.Socket;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import it.gotoandplay.smartfoxserver.data.Room;
   import it.gotoandplay.smartfoxserver.data.User;
   import it.gotoandplay.smartfoxserver.handlers.ExtHandler;
   import it.gotoandplay.smartfoxserver.handlers.IMessageHandler;
   import it.gotoandplay.smartfoxserver.handlers.SysHandler;
   import it.gotoandplay.smartfoxserver.http.HttpConnection;
   import it.gotoandplay.smartfoxserver.http.HttpEvent;
   import it.gotoandplay.smartfoxserver.util.Entities;
   import it.gotoandplay.smartfoxserver.util.ObjectSerializer;
   
   public class SmartFoxClient extends EventDispatcher
   {
      
      private static const EOM:int = 0;
      
      private static const MSG_XML:String = "<";
      
      private static const MSG_JSON:String = "{";
      
      private static var MSG_STR:String = "%";
      
      private static var MIN_POLL_SPEED:Number = 0;
      
      private static var DEFAULT_POLL_SPEED:Number = 750;
      
      private static var MAX_POLL_SPEED:Number = 10000;
      
      private static var HTTP_POLL_REQUEST:String = "poll";
      
      public static const MODMSG_TO_USER:String = "u";
      
      public static const MODMSG_TO_ROOM:String = "r";
      
      public static const MODMSG_TO_ZONE:String = "z";
      
      public static const XTMSG_TYPE_XML:String = "xml";
      
      public static const XTMSG_TYPE_STR:String = "str";
      
      public static const XTMSG_TYPE_JSON:String = "json";
      
      public static const CONNECTION_MODE_DISCONNECTED:String = "disconnected";
      
      public static const CONNECTION_MODE_SOCKET:String = "socket";
      
      public static const CONNECTION_MODE_HTTP:String = "http";
       
      
      private var roomList:Array;
      
      private var connected:Boolean;
      
      private var benchStartTime:int;
      
      private var sysHandler:SysHandler;
      
      private var extHandler:ExtHandler;
      
      private var majVersion:Number;
      
      private var minVersion:Number;
      
      private var subVersion:Number;
      
      private var messageHandlers:Array;
      
      private var socketConnection:Socket;
      
      private var byteBuffer:ByteArray;
      
      private var autoConnectOnConfigSuccess:Boolean = false;
      
      public var ipAddress:String;
      
      public var port:int = 9339;
      
      public var defaultZone:String;
      
      private var isHttpMode:Boolean = false;
      
      private var _httpPollSpeed:int;
      
      private var httpConnection:HttpConnection;
      
      public var blueBoxIpAddress:String;
      
      public var blueBoxPort:Number = 0;
      
      public var smartConnect:Boolean = true;
      
      public var buddyList:Array;
      
      public var myBuddyVars:Array;
      
      public var debug:Boolean;
      
      public var myUserId:int;
      
      public var myUserName:String;
      
      public var playerId:int;
      
      public var amIModerator:Boolean;
      
      public var activeRoomId:int;
      
      public var changingRoom:Boolean;
      
      public var httpPort:int = 8080;
      
      public var properties:Object = null;
      
      public function SmartFoxClient(param1:Boolean = false)
      {
         this._httpPollSpeed = DEFAULT_POLL_SPEED;
         super();
         this.majVersion = 1;
         this.minVersion = 5;
         this.subVersion = 8;
         this.activeRoomId = -1;
         this.debug = param1;
         this.messageHandlers = [];
         this.setupMessageHandlers();
         this.socketConnection = new Socket();
         this.socketConnection.addEventListener(Event.CONNECT,this.handleSocketConnection);
         this.socketConnection.addEventListener(Event.CLOSE,this.handleSocketDisconnection);
         this.socketConnection.addEventListener(ProgressEvent.SOCKET_DATA,this.handleSocketData);
         this.socketConnection.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIOError);
         this.socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError);
         this.httpConnection = new HttpConnection();
         this.httpConnection.addEventListener(HttpEvent.onHttpConnect,this.handleHttpConnect);
         this.httpConnection.addEventListener(HttpEvent.onHttpClose,this.handleHttpClose);
         this.httpConnection.addEventListener(HttpEvent.onHttpData,this.handleHttpData);
         this.httpConnection.addEventListener(HttpEvent.onHttpError,this.handleHttpError);
         this.byteBuffer = new ByteArray();
      }
      
      public function get rawProtocolSeparator() : String
      {
         return MSG_STR;
      }
      
      public function set rawProtocolSeparator(param1:String) : void
      {
         if(param1 != "<" && param1 != "{")
         {
            MSG_STR = param1;
         }
      }
      
      public function get isConnected() : Boolean
      {
         return this.connected;
      }
      
      public function set isConnected(param1:Boolean) : void
      {
         this.connected = param1;
      }
      
      public function get httpPollSpeed() : int
      {
         return this._httpPollSpeed;
      }
      
      public function set httpPollSpeed(param1:int) : void
      {
         if(param1 >= 0 && param1 <= 10000)
         {
            this._httpPollSpeed = param1;
         }
      }
      
      public function loadConfig(param1:String = "config.xml", param2:Boolean = true) : void
      {
         this.autoConnectOnConfigSuccess = param2;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.onConfigLoadSuccess);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.onConfigLoadFailure);
         _loc3_.load(new URLRequest(param1));
      }
      
      public function getConnectionMode() : String
      {
         var _loc1_:String = CONNECTION_MODE_DISCONNECTED;
         if(this.isConnected)
         {
            if(this.isHttpMode)
            {
               _loc1_ = CONNECTION_MODE_HTTP;
            }
            else
            {
               _loc1_ = CONNECTION_MODE_SOCKET;
            }
         }
         return _loc1_;
      }
      
      public function connect(param1:String, param2:int = 9339) : void
      {
         if(!this.connected)
         {
            this.initialize();
            this.ipAddress = param1;
            this.port = param2;
            this.socketConnection.connect(param1,param2);
         }
         else
         {
            this.debugMessage("*** ALREADY CONNECTED ***");
         }
      }
      
      public function disconnect() : void
      {
         this.connected = false;
         if(!this.isHttpMode)
         {
            this.socketConnection.close();
         }
         else
         {
            this.httpConnection.close();
         }
         this.sysHandler.dispatchDisconnection();
      }
      
      public function addBuddy(param1:String) : void
      {
         var _loc2_:* = null;
         if(param1 != this.myUserName && !this.checkBuddyDuplicates(param1))
         {
            _loc2_ = "<n>" + param1 + "</n>";
            this.send({"t":"sys"},"addB",-1,_loc2_);
         }
      }
      
      public function autoJoin() : void
      {
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"autoJoin",!!this.activeRoomId ? Number(this.activeRoomId) : Number(-1),"");
      }
      
      public function clearBuddyList() : void
      {
         this.buddyList = [];
         this.send({"t":"sys"},"clearB",-1,"");
         var _loc1_:Object = {};
         _loc1_.list = this.buddyList;
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onBuddyList,_loc1_);
         dispatchEvent(_loc2_);
      }
      
      public function createRoom(param1:Object, param2:int = -1) : void
      {
         var _loc10_:* = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc3_:Object = {"t":"sys"};
         var _loc4_:String = !!param1.isGame ? "1" : "0";
         var _loc5_:String = "1";
         var _loc6_:String = param1.maxUsers == null ? "0" : String(param1.maxUsers);
         var _loc7_:String = param1.maxSpectators == null ? "0" : String(param1.maxSpectators);
         var _loc8_:String = !!param1.joinAsSpectator ? "1" : "0";
         if(param1.isGame && param1.exitCurrentRoom != null)
         {
            _loc5_ = !!param1.exitCurrentRoom ? "1" : "0";
         }
         var _loc9_:* = (_loc9_ = (_loc9_ = (_loc9_ = "<room tmp=\'1\' gam=\'" + _loc4_ + "\' spec=\'" + _loc7_ + "\' exit=\'" + _loc5_ + "\' jas=\'" + _loc8_ + "\'>") + ("<name><![CDATA[" + (param1.name == null ? "" : param1.name) + "]]></name>")) + ("<pwd><![CDATA[" + (param1.password == null ? "" : param1.password) + "]]></pwd>")) + ("<max>" + _loc6_ + "</max>");
         if(param1.uCount != null)
         {
            _loc9_ += "<uCnt>" + (!!param1.uCount ? "1" : "0") + "</uCnt>";
         }
         if(param1.extension != null)
         {
            _loc9_ = (_loc9_ += "<xt n=\'" + param1.extension.name) + ("\' s=\'" + param1.extension.script + "\' />");
         }
         if(param1.vars == null)
         {
            _loc9_ += "<vars></vars>";
         }
         else
         {
            _loc9_ += "<vars>";
            for(_loc10_ in param1.vars)
            {
               _loc9_ += this.getXmlRoomVariable(param1.vars[_loc10_]);
            }
            _loc9_ += "</vars>";
         }
         _loc9_ += "</room>";
         this.send(_loc3_,"createRoom",param2,_loc9_);
      }
      
      public function getAllRooms() : Array
      {
         return this.roomList;
      }
      
      public function getBuddyByName(param1:String) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.buddyList)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getBuddyById(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.buddyList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getBuddyRoom(param1:Object) : void
      {
         if(param1.id != -1)
         {
            this.send({"t":"sys"},"roomB",-1,"<b id=\'" + param1.id + "\' />");
         }
      }
      
      public function getRoom(param1:int) : Room
      {
         if(!this.checkRoomList())
         {
            return null;
         }
         return this.roomList[param1];
      }
      
      public function getRoomByName(param1:String) : Room
      {
         var _loc3_:Room = null;
         if(!this.checkRoomList())
         {
            return null;
         }
         var _loc2_:Room = null;
         for each(_loc3_ in this.roomList)
         {
            if(_loc3_.getName() == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function getRoomList() : void
      {
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"getRmList",this.activeRoomId,"");
      }
      
      public function getActiveRoom() : Room
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return null;
         }
         return this.roomList[this.activeRoomId];
      }
      
      public function getRandomKey() : void
      {
         this.send({"t":"sys"},"rndK",-1,"");
      }
      
      public function getUploadPath() : String
      {
         return "http://" + this.ipAddress + ":" + this.httpPort + "/default/uploads/";
      }
      
      public function getVersion() : String
      {
         return this.majVersion + "." + this.minVersion + "." + this.subVersion;
      }
      
      public function joinRoom(param1:*, param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:int = -1) : void
      {
         var _loc8_:Room = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:* = null;
         if(!this.checkRoomList())
         {
            return;
         }
         var _loc6_:int = -1;
         var _loc7_:int = !!param3 ? 1 : 0;
         if(!this.changingRoom)
         {
            if(typeof param1 == "number")
            {
               _loc6_ = int(param1);
            }
            else if(typeof param1 == "string")
            {
               for each(_loc8_ in this.roomList)
               {
                  if(_loc8_.getName() == param1)
                  {
                     _loc6_ = _loc8_.getId();
                     break;
                  }
               }
            }
            if(_loc6_ != -1)
            {
               _loc9_ = {"t":"sys"};
               _loc10_ = !!param4 ? "0" : "1";
               _loc11_ = param5 > -1 ? int(param5) : int(this.activeRoomId);
               if(this.activeRoomId == -1)
               {
                  _loc10_ = "0";
                  _loc11_ = -1;
               }
               _loc12_ = "<room id=\'" + _loc6_ + "\' pwd=\'" + param2 + "\' spec=\'" + _loc7_ + "\' leave=\'" + _loc10_ + "\' old=\'" + _loc11_ + "\' />";
               this.send(_loc9_,"joinRoom",this.activeRoomId,_loc12_);
               this.changingRoom = true;
            }
            else
            {
               this.debugMessage("SmartFoxError: requested room to join does not exist!");
            }
         }
      }
      
      public function leaveRoom(param1:int) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         var _loc2_:Object = {"t":"sys"};
         var _loc3_:* = "<rm id=\'" + param1 + "\' />";
         this.send(_loc2_,"leaveRoom",param1,_loc3_);
      }
      
      public function loadBuddyList() : void
      {
         this.send({"t":"sys"},"loadB",-1,"");
      }
      
      public function login(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:* = "<login z=\'" + param1 + "\'><nick><![CDATA[" + param2 + "]]></nick><pword><![CDATA[" + param3 + "]]></pword></login>";
         this.send(_loc4_,"login",0,_loc5_);
      }
      
      public function logout() : void
      {
         var _loc1_:Object = {"t":"sys"};
         this.send(_loc1_,"logout",-1,"");
      }
      
      public function removeBuddy(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:Object = null;
         var _loc8_:SFSEvent = null;
         var _loc2_:Boolean = false;
         for(_loc4_ in this.buddyList)
         {
            _loc3_ = this.buddyList[_loc4_];
            if(_loc3_.name == param1)
            {
               delete this.buddyList[_loc4_];
               _loc2_ = true;
               break;
            }
         }
         if(_loc2_)
         {
            _loc5_ = {"t":"sys"};
            _loc6_ = "<n>" + param1 + "</n>";
            this.send(_loc5_,"remB",-1,_loc6_);
            (_loc7_ = {}).list = this.buddyList;
            _loc8_ = new SFSEvent(SFSEvent.onBuddyList,_loc7_);
            dispatchEvent(_loc8_);
         }
      }
      
      public function roundTripBench() : void
      {
         this.benchStartTime = getTimer();
         this.send({"t":"sys"},"roundTrip",this.activeRoomId,"");
      }
      
      public function sendBuddyPermissionResponse(param1:Boolean, param2:String) : void
      {
         var _loc3_:Object = {"t":"sys"};
         var _loc4_:* = "<n res=\'" + (!!param1 ? "g" : "r") + "\'>" + param2 + "</n>";
         this.send(_loc3_,"bPrm",-1,_loc4_);
      }
      
      public function sendPublicMessage(param1:String, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc3_:Object = {"t":"sys"};
         var _loc4_:* = "<txt><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc3_,"pubMsg",param2,_loc4_);
      }
      
      public function sendPrivateMessage(param1:String, param2:int, param3:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param3 == -1)
         {
            param3 = this.activeRoomId;
         }
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:* = "<txt rcp=\'" + param2 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc4_,"prvMsg",param3,_loc5_);
      }
      
      public function sendModeratorMessage(param1:String, param2:String, param3:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         var _loc4_:Object = {"t":"sys"};
         var _loc5_:* = "<txt t=\'" + param2 + "\' id=\'" + param3 + "\'><![CDATA[" + Entities.encodeEntities(param1) + "]]></txt>";
         this.send(_loc4_,"modMsg",this.activeRoomId,_loc5_);
      }
      
      public function sendObject(param1:Object, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc3_:* = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         var _loc4_:Object = {"t":"sys"};
         this.send(_loc4_,"asObj",param2,_loc3_);
      }
      
      public function sendObjectToGroup(param1:Object, param2:Array, param3:int = -1) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         var _loc7_:* = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param3 == -1)
         {
            param3 = this.activeRoomId;
         }
         var _loc4_:String = "";
         for(_loc5_ in param2)
         {
            if(!isNaN(param2[_loc5_]))
            {
               _loc4_ += param2[_loc5_] + ",";
            }
         }
         _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
         param1._$$_ = _loc4_;
         _loc6_ = {"t":"sys"};
         _loc7_ = "<![CDATA[" + ObjectSerializer.getInstance().serialize(param1) + "]]>";
         this.send(_loc6_,"asObjG",param3,_loc7_);
      }
      
      public function sendXtMessage(param1:String, param2:String, param3:*, param4:String = "xml", param5:int = -1) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:* = null;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         if(!this.checkRoomList())
         {
            return;
         }
         if(param5 == -1)
         {
            param5 = this.activeRoomId;
         }
         if(param4 == XTMSG_TYPE_XML)
         {
            _loc6_ = {"t":"xt"};
            _loc7_ = {
               "name":param1,
               "cmd":param2,
               "param":param3
            };
            _loc8_ = "<![CDATA[" + ObjectSerializer.getInstance().serialize(_loc7_) + "]]>";
            this.send(_loc6_,"xtReq",param5,_loc8_);
         }
         else if(param4 == XTMSG_TYPE_STR)
         {
            _loc9_ = MSG_STR + "xt" + MSG_STR + param1 + MSG_STR + param2 + MSG_STR + param5 + MSG_STR;
            _loc10_ = 0;
            while(_loc10_ < param3.length)
            {
               _loc9_ += param3[_loc10_].toString() + MSG_STR;
               _loc10_++;
            }
            this.sendString(_loc9_);
         }
         else if(param4 == XTMSG_TYPE_JSON)
         {
            (_loc11_ = {}).x = param1;
            _loc11_.c = param2;
            _loc11_.r = param5;
            _loc11_.p = param3;
            (_loc12_ = {}).t = "xt";
            _loc12_.b = _loc11_;
            _loc13_ = com.adobe.serialization.json.JSON.encode(_loc12_);
            this.sendJson(_loc13_);
         }
      }
      
      public function setBuddyBlockStatus(param1:String, param2:Boolean) : void
      {
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:SFSEvent = null;
         var _loc3_:Object = this.getBuddyByName(param1);
         if(_loc3_ != null)
         {
            if(_loc3_.isBlocked != param2)
            {
               _loc3_.isBlocked = param2;
               _loc4_ = "<n x=\'" + (!!param2 ? "1" : "0") + "\'>" + param1 + "</n>";
               this.send({"t":"sys"},"setB",-1,_loc4_);
               (_loc5_ = {}).buddy = _loc3_;
               _loc6_ = new SFSEvent(SFSEvent.onBuddyListUpdate,_loc5_);
               dispatchEvent(_loc6_);
            }
         }
      }
      
      public function setBuddyVariables(param1:Array) : void
      {
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc2_:Object = {"t":"sys"};
         var _loc3_:* = "<vars>";
         for(_loc4_ in param1)
         {
            _loc5_ = param1[_loc4_];
            if(this.myBuddyVars[_loc4_] != _loc5_)
            {
               this.myBuddyVars[_loc4_] = _loc5_;
               _loc3_ += "<var n=\'" + _loc4_ + "\'><![CDATA[" + _loc5_ + "]]></var>";
            }
         }
         _loc3_ += "</vars>";
         this.send(_loc2_,"setBvars",-1,_loc3_);
      }
      
      public function setRoomVariables(param1:Array, param2:int = -1, param3:Boolean = true) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc4_:Object = {"t":"sys"};
         if(param3)
         {
            _loc5_ = "<vars>";
         }
         else
         {
            _loc5_ = "<vars so=\'0\'>";
         }
         for each(_loc6_ in param1)
         {
            _loc5_ += this.getXmlRoomVariable(_loc6_);
         }
         _loc5_ += "</vars>";
         this.send(_loc4_,"setRvars",param2,_loc5_);
      }
      
      public function setUserVariables(param1:Object, param2:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = this.activeRoomId;
         }
         var _loc3_:Object = {"t":"sys"};
         var _loc5_:User;
         var _loc4_:Room;
         (_loc5_ = (_loc4_ = this.getActiveRoom()).getUser(this.myUserId)).setVariables(param1);
         var _loc6_:String = this.getXmlUserVariable(param1);
         this.send(_loc3_,"setUvars",param2,_loc6_);
      }
      
      public function switchSpectator(param1:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param1 == -1)
         {
            param1 = this.activeRoomId;
         }
         this.send({"t":"sys"},"swSpec",param1,"");
      }
      
      public function switchPlayer(param1:int = -1) : void
      {
         if(!this.checkRoomList() || !this.checkJoin())
         {
            return;
         }
         if(param1 == -1)
         {
            param1 = this.activeRoomId;
         }
         this.send({"t":"sys"},"swPl",param1,"");
      }
      
      public function uploadFile(param1:FileReference, param2:int = -1, param3:String = "", param4:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = this.myUserId;
         }
         if(param3 == "")
         {
            param3 = this.myUserName;
         }
         if(param4 == -1)
         {
            param4 = this.httpPort;
         }
         param1.upload(new URLRequest("http://" + this.ipAddress + ":" + param4 + "/default/Upload.py?id=" + param2 + "&nick=" + param3));
         this.debugMessage("[UPLOAD]: http://" + this.ipAddress + ":" + param4 + "/default/Upload.py?id=" + param2 + "&nick=" + param3);
      }
      
      public function __logout() : void
      {
         this.initialize(true);
      }
      
      public function sendString(param1:String) : void
      {
         this.debugMessage("[Sending - STR]: " + param1 + "\n");
         if(this.isHttpMode)
         {
            this.httpConnection.send(param1);
         }
         else
         {
            this.writeToSocket(param1);
         }
      }
      
      public function sendJson(param1:String) : void
      {
         this.debugMessage("[Sending - JSON]: " + param1 + "\n");
         if(this.isHttpMode)
         {
            this.httpConnection.send(param1);
         }
         else
         {
            this.writeToSocket(param1);
         }
      }
      
      public function getBenchStartTime() : int
      {
         return this.benchStartTime;
      }
      
      public function clearRoomList() : void
      {
         this.roomList = [];
      }
      
      private function initialize(param1:Boolean = false) : void
      {
         this.changingRoom = false;
         this.amIModerator = false;
         this.playerId = -1;
         this.activeRoomId = -1;
         this.myUserId = -1;
         this.myUserName = "";
         this.roomList = [];
         this.buddyList = [];
         this.myBuddyVars = [];
         if(!param1)
         {
            this.connected = false;
            this.isHttpMode = false;
         }
      }
      
      private function onConfigLoadSuccess(param1:Event) : void
      {
         var _loc4_:SFSEvent = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:XML = new XML(_loc2_.data);
         this.ipAddress = this.blueBoxIpAddress = _loc3_.ip;
         this.port = int(_loc3_.port);
         this.defaultZone = _loc3_.zone;
         if(_loc3_.blueBoxIpAddress != undefined)
         {
            this.blueBoxIpAddress = _loc3_.blueBoxIpAddress;
         }
         if(_loc3_.blueBoxPort != undefined)
         {
            this.blueBoxPort = _loc3_.blueBoxPort;
         }
         if(_loc3_.debug != undefined)
         {
            this.debug = _loc3_.debug.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.smartConnect != undefined)
         {
            this.smartConnect = _loc3_.smartConnect.toLowerCase() == "true" ? true : false;
         }
         if(_loc3_.httpPort != undefined)
         {
            this.httpPort = int(_loc3_.httpPort);
         }
         if(_loc3_.httpPollSpeed != undefined)
         {
            this.httpPollSpeed = int(_loc3_.httpPollSpeed);
         }
         if(_loc3_.rawProtocolSeparator != undefined)
         {
            this.rawProtocolSeparator = _loc3_.rawProtocolSeparator;
         }
         if(this.autoConnectOnConfigSuccess)
         {
            this.connect(this.ipAddress,this.port);
         }
         else
         {
            _loc4_ = new SFSEvent(SFSEvent.onConfigLoadSuccess,{});
            dispatchEvent(_loc4_);
         }
      }
      
      private function onConfigLoadFailure(param1:IOErrorEvent) : void
      {
         var _loc2_:Object = {"message":param1.text};
         var _loc3_:SFSEvent = new SFSEvent(SFSEvent.onConfigLoadFailure,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      private function setupMessageHandlers() : void
      {
         this.sysHandler = new SysHandler(this);
         this.extHandler = new ExtHandler(this);
         this.addMessageHandler("sys",this.sysHandler);
         this.addMessageHandler("xt",this.extHandler);
      }
      
      private function addMessageHandler(param1:String, param2:IMessageHandler) : void
      {
         if(this.messageHandlers[param1] == null)
         {
            this.messageHandlers[param1] = param2;
         }
         else
         {
            this.debugMessage("Warning, message handler called: " + param1 + " already exist!");
         }
      }
      
      private function debugMessage(param1:String) : void
      {
         var _loc2_:SFSEvent = null;
         if(this.debug)
         {
            trace(param1);
            _loc2_ = new SFSEvent(SFSEvent.onDebugMessage,{"message":param1});
            dispatchEvent(_loc2_);
         }
      }
      
      private function send(param1:Object, param2:String, param3:Number, param4:String) : void
      {
         var _loc5_:String = (_loc5_ = this.makeXmlHeader(param1)) + ("<body action=\'" + param2 + "\' r=\'" + param3 + "\'>" + param4 + "</body>" + this.closeHeader());
         this.debugMessage("[Sending]: " + _loc5_ + "\n");
         if(this.isHttpMode)
         {
            this.httpConnection.send(_loc5_);
         }
         else
         {
            this.writeToSocket(_loc5_);
         }
      }
      
      private function writeToSocket(param1:String) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeMultiByte(param1,"utf-8");
         _loc2_.writeByte(0);
         this.socketConnection.writeBytes(_loc2_);
         this.socketConnection.flush();
      }
      
      private function makeXmlHeader(param1:Object) : String
      {
         var _loc3_:* = null;
         var _loc2_:String = "<msg";
         for(_loc3_ in param1)
         {
            _loc2_ += " " + _loc3_ + "=\'" + param1[_loc3_] + "\'";
         }
         return _loc2_ + ">";
      }
      
      private function closeHeader() : String
      {
         return "</msg>";
      }
      
      private function checkBuddyDuplicates(param1:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.buddyList)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      private function xmlReceived(param1:String) : void
      {
         var _loc2_:XML = new XML(param1);
         var _loc3_:String = _loc2_.@t;
         var _loc4_:String = _loc2_.body.@action;
         var _loc5_:int = _loc2_.body.@r;
         var _loc6_:IMessageHandler;
         if((_loc6_ = this.messageHandlers[_loc3_]) != null)
         {
            _loc6_.handleMessage(_loc2_,XTMSG_TYPE_XML);
         }
      }
      
      private function jsonReceived(param1:String) : void
      {
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(param1);
         var _loc3_:String = _loc2_["t"];
         var _loc4_:IMessageHandler;
         if((_loc4_ = this.messageHandlers[_loc3_]) != null)
         {
            _loc4_.handleMessage(_loc2_["b"],XTMSG_TYPE_JSON);
         }
      }
      
      private function strReceived(param1:String) : void
      {
         var _loc2_:Array = param1.substr(1,param1.length - 2).split(MSG_STR);
         var _loc3_:String = _loc2_[0];
         var _loc4_:IMessageHandler;
         if((_loc4_ = this.messageHandlers[_loc3_]) != null)
         {
            _loc4_.handleMessage(_loc2_.splice(1,_loc2_.length - 1),XTMSG_TYPE_STR);
         }
      }
      
      private function getXmlRoomVariable(param1:Object) : String
      {
         var _loc2_:String = param1.name.toString();
         var _loc3_:* = param1.val;
         var _loc4_:String = !!param1.priv ? "1" : "0";
         var _loc5_:String = !!param1.persistent ? "1" : "0";
         var _loc6_:String = null;
         var _loc7_:*;
         if((_loc7_ = typeof _loc3_) == "boolean")
         {
            _loc6_ = "b";
            _loc3_ = !!_loc3_ ? "1" : "0";
         }
         else if(_loc7_ == "number")
         {
            _loc6_ = "n";
         }
         else if(_loc7_ == "string")
         {
            _loc6_ = "s";
         }
         else if(_loc3_ == null && _loc7_ == "object" || _loc7_ == "undefined")
         {
            _loc6_ = "x";
            _loc3_ = "";
         }
         if(_loc6_ != null)
         {
            return "<var n=\'" + _loc2_ + "\' t=\'" + _loc6_ + "\' pr=\'" + _loc4_ + "\' pe=\'" + _loc5_ + "\'><![CDATA[" + _loc3_ + "]]></var>";
         }
         return "";
      }
      
      private function getXmlUserVariable(param1:Object) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:String = "<vars>";
         for(_loc6_ in param1)
         {
            _loc3_ = param1[_loc6_];
            _loc5_ = typeof _loc3_;
            _loc4_ = null;
            if(_loc5_ == "boolean")
            {
               _loc4_ = "b";
               _loc3_ = !!_loc3_ ? "1" : "0";
            }
            else if(_loc5_ == "number")
            {
               _loc4_ = "n";
            }
            else if(_loc5_ == "string")
            {
               _loc4_ = "s";
            }
            else if(_loc3_ == null && _loc5_ == "object" || _loc5_ == "undefined")
            {
               _loc4_ = "x";
               _loc3_ = "";
            }
            if(_loc4_ != null)
            {
               _loc2_ += "<var n=\'" + _loc6_ + "\' t=\'" + _loc4_ + "\'><![CDATA[" + _loc3_ + "]]></var>";
            }
         }
         return _loc2_ + "</vars>";
      }
      
      private function checkRoomList() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.roomList == null || this.roomList.length == 0)
         {
            _loc1_ = false;
            this.errorTrace("The room list is empty!\nThe client API cannot function properly until the room list is populated.\nPlease consult the documentation for more infos.");
         }
         return _loc1_;
      }
      
      private function checkJoin() : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.activeRoomId < 0)
         {
            _loc1_ = false;
            this.errorTrace("You haven\'t joined any rooms!\nIn order to interact with the server you should join at least one room.\nPlease consult the documentation for more infos.");
         }
         return _loc1_;
      }
      
      private function errorTrace(param1:String) : void
      {
         trace("\n****************************************************************");
         trace("Warning:");
         trace(param1);
         trace("****************************************************************");
      }
      
      private function handleHttpConnect(param1:HttpEvent) : void
      {
         this.handleSocketConnection(null);
         this.connected = true;
         this.httpConnection.send(HTTP_POLL_REQUEST);
      }
      
      private function handleHttpClose(param1:HttpEvent) : void
      {
         this.initialize();
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{});
         dispatchEvent(_loc2_);
      }
      
      private function handleHttpData(param1:HttpEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc2_:String = param1.params.data as String;
         var _loc3_:Array = _loc2_.split("\n");
         if(_loc3_[0] != "")
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length - 1)
            {
               if((_loc4_ = _loc3_[_loc5_]).length > 0)
               {
                  this.handleMessage(_loc4_);
               }
               _loc5_++;
            }
            if(this._httpPollSpeed > 0)
            {
               setTimeout(this.handleDelayedPoll,this._httpPollSpeed);
            }
            else
            {
               this.handleDelayedPoll();
            }
         }
      }
      
      private function handleDelayedPoll() : void
      {
         this.httpConnection.send(HTTP_POLL_REQUEST);
      }
      
      private function handleHttpError(param1:HttpEvent) : void
      {
         trace("HttpError");
         if(!this.connected)
         {
            this.dispatchConnectionError();
         }
      }
      
      private function handleSocketConnection(param1:Event) : void
      {
         var _loc2_:Object = {"t":"sys"};
         var _loc3_:* = "<ver v=\'" + this.majVersion.toString() + this.minVersion.toString() + this.subVersion.toString() + "\' />";
         this.send(_loc2_,"verChk",0,_loc3_);
      }
      
      private function handleSocketDisconnection(param1:Event) : void
      {
         this.initialize();
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConnectionLost,{});
         dispatchEvent(_loc2_);
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         this.tryBlueBoxConnection(param1);
      }
      
      private function tryBlueBoxConnection(param1:ErrorEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(!this.connected)
         {
            if(this.smartConnect)
            {
               this.debugMessage("Socket connection failed. Trying BlueBox");
               this.isHttpMode = true;
               _loc2_ = this.blueBoxIpAddress != null ? this.blueBoxIpAddress : this.ipAddress;
               _loc3_ = this.blueBoxPort != 0 ? int(this.blueBoxPort) : int(this.httpPort);
               this.httpConnection.connect(_loc2_,_loc3_);
            }
            else
            {
               this.dispatchConnectionError();
            }
         }
         else
         {
            dispatchEvent(param1);
            this.debugMessage("[WARN] Connection error: " + param1.text);
         }
      }
      
      private function handleSocketError(param1:SecurityErrorEvent) : void
      {
         this.debugMessage("Socket Error: " + param1.text);
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         this.tryBlueBoxConnection(param1);
      }
      
      private function handleSocketData(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.socketConnection.bytesAvailable;
         while(--_loc2_ >= 0)
         {
            _loc3_ = this.socketConnection.readByte();
            if(_loc3_ != 0)
            {
               this.byteBuffer.writeByte(_loc3_);
            }
            else
            {
               this.handleMessage(this.byteBuffer.toString());
               this.byteBuffer = new ByteArray();
            }
         }
      }
      
      private function handleMessage(param1:String) : void
      {
         if(param1 != "ok")
         {
            this.debugMessage("[ RECEIVED ]: " + param1 + ", (len: " + param1.length + ")");
         }
         var _loc2_:String = param1.charAt(0);
         if(_loc2_ == MSG_XML)
         {
            this.xmlReceived(param1);
         }
         else if(_loc2_ == MSG_STR)
         {
            this.strReceived(param1);
         }
         else if(_loc2_ == MSG_JSON)
         {
            this.jsonReceived(param1);
         }
      }
      
      private function dispatchConnectionError() : void
      {
         var _loc1_:Object = {};
         _loc1_.success = false;
         _loc1_.error = "I/O Error";
         var _loc2_:SFSEvent = new SFSEvent(SFSEvent.onConnection,_loc1_);
         dispatchEvent(_loc2_);
      }
   }
}
