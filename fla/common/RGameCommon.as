package common
{
   import Facebook.*;
   import Menu.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.*;
   import flash.utils.*;
   import object.*;
   import org.papervision3d.core.math.*;
   import player.*;
   import resourcemgr.*;
   
   public class RGameCommon extends Sprite
   {
      
      public static var g_LodingFlag:Boolean = false;
      
      public static var g_TrackName:String;
      
      public static var g_PlayerID:int = 1;
      
      public static var g_TrackID:int = 1;
      
      public static var g_CarCount:int = 4;
      
      public static var isStart:int = 0;
      
      public static var isGO:Boolean = false;
      
      public static var g_CommonData:RCommonData;
      
      public static var g_UserInfo:RUserInfo;
      
      public static var g_sfsIp:String;
      
      public static var m_CurrObjID:int;
      
      public static var g_ObjectCount:int;
      
      public static var m_MenuTextArr:Array;
      
      public static var m_StringTbl:Dictionary = new Dictionary(true);
      
      public static const SND_INGAME:int = 1;
      
      public static const SND_PREGAME:int = 2;
      
      public static const SND_WINGAME:int = 3;
      
      public static const SND_FAILGAME:int = 4;
       
      
      public var g_SingleGame:Boolean;
      
      public var g_ObjectInfo:Array;
      
      public var ChangeLevel:Boolean = false;
      
      public var GameClient:RGameClient;
      
      public var CommonRsrMgr:RResourceMgr;
      
      private var _page:RCommonUI;
      
      public var m_FaceBook:FaceMgr;
      
      public var m_IsLog:Boolean = false;
      
      public var m_scoreArr:Array;
      
      public var m_targetTrack:Array;
      
      public var m_targetRank:Array;
      
      public var m_cases:int = 0;
      
      public var m_CarsList:Array;
      
      public var m_LastList:Array;
      
      public var m_LastRank:int = 0;
      
      public var m_boolGetFirst:Boolean = false;
      
      public var m_boolGetSecond:Boolean = false;
      
      public var m_boolInviteFirst:Boolean = false;
      
      protected var m_MenuText:URLLoader;
      
      public var m_WorldRankArr:Array;
      
      protected var m_BackSoundChannel:SoundChannel;
      
      protected var m_EngineSoundChannel:SoundChannel;
      
      protected var m_PreGameSnd:Sound;
      
      protected var StartFlag:Boolean = false;
      
      public var levelArray:Array;
      
      public var m_SoundOnOff:Boolean = true;
      
      public var _Prev_Page:Class;
      
      public var m_search_Text:String;
      
      private var m_Delimiter:String;
      
      public var m_PlayerPictureMgr:RPlayerPicture;
      
      public function RGameCommon()
      {
         this.m_scoreArr = new Array();
         this.m_targetTrack = new Array();
         this.m_targetRank = new Array();
         this.m_CarsList = new Array();
         this.m_LastList = new Array();
         this.m_MenuText = new URLLoader();
         this.levelArray = new Array("1010","1020","1030","1040","1050");
         super();
         this.m_PlayerPictureMgr = new RPlayerPicture();
         RSoundMgr.LoadSWF("sound.dat");
         this.CommonRsrMgr = new RResourceMgr();
         this.g_ObjectInfo = new Array();
         this.m_BackSoundChannel = new SoundChannel();
         this.m_EngineSoundChannel = new SoundChannel();
      }
      
      public function Initialize() : void
      {
         var _loc1_:String = new String();
         if(RockRacer.parameters.lang)
         {
            _loc1_ = "common_";
            _loc1_ += RockRacer.parameters.lang + ".txt";
         }
         else
         {
            _loc1_ = "common.txt";
         }
         this.g_ObjectInfo = new Array();
         g_ObjectCount = 0;
         this.m_MenuText.dataFormat = URLLoaderDataFormat.TEXT;
         this.m_MenuText.load(new URLRequest(RockRacer.base + _loc1_));
         this.m_MenuText.addEventListener(Event.COMPLETE,this.onMenuTextLoad);
         g_CommonData = new RCommonData();
         this.GameClient = new RGameClient();
         addChild(this.GameClient);
         this.InitScore();
      }
      
      public function InitUserInfo(param1:Object) : void
      {
         var _uInfo:Object = param1;
         g_UserInfo = new RUserInfo();
         with(g_UserInfo)
         {
            uid = _uInfo.uid;
            firstName = _uInfo.firstname;
            lastName = _uInfo.lastname;
            init = _uInfo.init;
            picsquare = _uInfo.picsquare;
            picbig = _uInfo.picbig;
            points = _uInfo.points;
            level = _uInfo.level;
            experience = _uInfo.experience;
            winratio = _uInfo.winratio;
            worldrank = _uInfo.worldrank;
            driver = _uInfo.driver;
            maps = _uInfo.maps;
            coins = _uInfo.coins;
            pfriends = _uInfo.pfriends;
            fcoins = _uInfo.fcoins;
            nextcoins = _uInfo.nextcoins;
            nextfriends = _uInfo.nextfriends;
            races = _uInfo.races;
            level1time = _uInfo.level1time;
            level2time = _uInfo.level2time;
            level3time = _uInfo.level3time;
            level4time = _uInfo.level4time;
            level5time = _uInfo.level5time;
         }
      }
      
      public function UpdateUserInfo(param1:int, param2:int, param3:int) : void
      {
         if(g_UserInfo.level == param2)
         {
            g_UserInfo.points += this.m_scoreArr[param1][param2 - 1];
            g_UserInfo.points += param3;
         }
         else
         {
            g_UserInfo.points += this.m_scoreArr[param1][param2 - 1];
            g_UserInfo.points += param3;
         }
      }
      
      public function LogInComplete(param1:Event) : void
      {
         var _loc2_:Object = this.m_FaceBook.user();
         this.InitUserInfo(_loc2_);
         if(_loc2_.init)
         {
            this.m_IsLog = false;
         }
         else
         {
            this.m_IsLog = true;
         }
         this.CommonRsrMgr.LoadLevel(0);
         this.m_FaceBook.removeEventListener("logUser",this.LogInComplete);
      }
      
      public function UpdateData(param1:Event) : void
      {
         var _loc2_:Object = this.m_FaceBook.user();
         this.UpdateFacebookInfo();
      }
      
      public function UpdateFacebookInfo() : void
      {
         var _uInfo:Object = this.m_FaceBook.user();
         with(g_UserInfo)
         {
            firstName = _uInfo.firstname;
            lastName = _uInfo.lastname;
            init = _uInfo.init;
            picsquare = _uInfo.picsquare;
            picbig = _uInfo.picbig;
            points = _uInfo.points;
            level = _uInfo.level;
            experience = _uInfo.experience;
            winratio = _uInfo.winratio;
            worldrank = _uInfo.worldrank;
            driver = _uInfo.driver;
            maps = _uInfo.maps;
            coins = _uInfo.coins;
            pfriends = _uInfo.pfriends;
            fcoins = _uInfo.fcoins;
            nextcoins = _uInfo.nextcoins;
            nextfriends = _uInfo.nextfriends;
            races = _uInfo.races;
         }
      }
      
      public function PlayBackSound(param1:int) : void
      {
         if(!this.m_SoundOnOff)
         {
            return;
         }
         if(this.m_BackSoundChannel != null)
         {
            this.m_BackSoundChannel.stop();
         }
         switch(param1)
         {
            case SND_WINGAME:
               this.m_BackSoundChannel = RSoundMgr.GetSound("win").play(0,1);
               break;
            case SND_FAILGAME:
               this.m_BackSoundChannel = RSoundMgr.GetSound("fail").play(0,1);
               break;
            case SND_INGAME:
               this.m_BackSoundChannel = RSoundMgr.GetSound("InGame").play(0,100000);
               break;
            case SND_PREGAME:
               this.m_BackSoundChannel = this.m_PreGameSnd.play(0,100000);
         }
      }
      
      protected function WorldRankSort(param1:Event) : void
      {
         this.m_WorldRankArr = FaceMgr.worlds;
      }
      
      public function GetNextFriendInfo() : Object
      {
         var _loc1_:Array = FaceMgr.friends;
         var _loc2_:int = FaceMgr.myRank;
         var _loc3_:Object = null;
         if(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
         }
         return _loc3_;
      }
      
      public function GetPrevFriendInfo() : Object
      {
         var _loc1_:Array = FaceMgr.friends;
         var _loc2_:int = FaceMgr.myRank;
         var _loc3_:Object = null;
         if(_loc2_ > 1)
         {
            _loc3_ = _loc1_[_loc2_ - 2];
         }
         return _loc3_;
      }
      
      public function ResourceLoadComplete(param1:Event) : void
      {
         if(FaceMgr.waitResult)
         {
            setTimeout(this.CommonRsrMgr.dispatchEvent,50,new Event("LOAD_COMPLETE"));
            return;
         }
         this.m_search_Text = this.GetTextFunc("$NAME_OF_FRIEND");
         this.m_Delimiter = this.GetTextFunc("$THOUSANDS_DELIMITER");
         var _loc2_:URLRequest = new URLRequest(RockRacer.base + "PreGame.mp3");
         this.m_PreGameSnd = new Sound();
         this.m_PreGameSnd.load(_loc2_);
         this.PlayBackSound(SND_PREGAME);
         if(this.m_IsLog)
         {
            this.createPage(MainMenu);
            g_PlayerID = g_UserInfo.driver;
            g_TrackID = g_UserInfo.level;
         }
         RockRacer.DeleteBackImage();
         this.CommonRsrMgr.removeEventListener("LOAD_COMPLETE",this.ResourceLoadComplete);
         this.addEventListener(Event.ENTER_FRAME,this.loop);
      }
      
      public function InitScore() : void
      {
         var _loc1_:int = 6;
         var _loc2_:int = 3;
         var _loc3_:Array = new Array(_loc1_);
         _loc3_[0] = 500;
         _loc3_[1] = 1000;
         _loc3_[2] = 1500;
         _loc3_[3] = 2000;
         _loc3_[4] = 2500;
         _loc3_[5] = 3000;
         this.m_scoreArr.push(_loc3_);
         _loc3_ = new Array(_loc1_);
         _loc3_[0] = 250;
         _loc3_[1] = 500;
         _loc3_[2] = 750;
         _loc3_[3] = 1000;
         _loc3_[4] = 1250;
         _loc3_[5] = 1500;
         this.m_scoreArr.push(_loc3_);
         _loc3_ = new Array(_loc1_);
         _loc3_[0] = 100;
         _loc3_[1] = 200;
         _loc3_[2] = 300;
         _loc3_[3] = 400;
         _loc3_[4] = 500;
         _loc3_[5] = 600;
         this.m_scoreArr.push(_loc3_);
         _loc3_ = new Array(_loc1_);
         _loc3_[0] = 0;
         _loc3_[1] = 0;
         _loc3_[2] = 0;
         _loc3_[3] = 0;
         _loc3_[4] = 0;
         _loc3_[5] = 0;
         this.m_scoreArr.push(_loc3_);
      }
      
      protected function CalcScore() : void
      {
         var _loc7_:int = 0;
         var _loc1_:Object = this.m_FaceBook.user();
         var _loc2_:Object = this.GetPrevFriendInfo();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = _loc2_.points - _loc1_.points;
         this.m_cases = 0;
         var _loc4_:int = 6;
         var _loc5_:int = 3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               if(_loc3_ < this.m_scoreArr[_loc6_][_loc7_])
               {
                  this.m_targetTrack[this.m_cases] = _loc7_;
                  this.m_targetRank[this.m_cases] = _loc6_ + 1;
                  ++this.m_cases;
                  break;
               }
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      protected function InitData() : void
      {
         m_CurrObjID = 0;
         this.m_LastList = new Array();
         this.m_CarsList = new Array();
         this.m_targetTrack = new Array();
         this.m_targetRank = new Array();
         g_ObjectCount = 0;
         this.g_ObjectInfo = new Array();
         this.m_LastRank = 0;
         this.m_cases = 0;
         this.m_scoreArr = new Array();
         this.InitScore();
      }
      
      protected function loop(param1:Event) : void
      {
         if(isStart == 1)
         {
            this.InitData();
            this.GameClient.SetTrack(g_TrackID);
            this.GameClient.SetPlayer(g_PlayerID);
            this.GameClient.Initialize();
            isStart = 2;
            this.StartFlag = false;
         }
         if(!this.StartFlag && !this.GameClient.m_QuitWindowEnable)
         {
            if(this.GameClient.m_ReadyCounter.currentFrame > 35)
            {
               this.StartFlag = true;
               this.PlayBackSound(SND_INGAME);
            }
         }
         if(isGO)
         {
            this.GameClient.InitGo();
            isGO = false;
            this.GameClient.stage.focus = null;
         }
         if(this.GameClient.m_DeletePage)
         {
            this.createPage();
            this.GameClient.m_DeletePage = false;
            isStart = 0;
            this.StartFlag = false;
         }
         if(RockRacer.GameCommon.GameClient.m_RenderMode == RGameClient.RENDER_ABORT)
         {
            if(RockRacer.GameCommon.g_SingleGame)
            {
               MainMenu._multiMode = false;
               this.createPage(MainMenu);
            }
            else
            {
               MainMenu._multiMode = true;
            }
            RockRacer.GameCommon.GameClient.m_RenderMode = RGameClient.RENDER_LOADING;
            this.PlayBackSound(SND_PREGAME);
            this.StartFlag = false;
         }
      }
      
      public function createPage(param1:Class = null) : void
      {
         if(param1 == null)
         {
            this._page.display = true;
            return;
         }
         if(this._page != null)
         {
            this._page.display = false;
         }
         this._page = new param1(this);
      }
      
      public function AddObject(param1:ROBJECTINFO) : int
      {
         param1.m_ObjectID = m_CurrObjID;
         this.g_ObjectInfo.push(param1);
         ++m_CurrObjID;
         ++g_ObjectCount;
         return param1.m_ObjectID;
      }
      
      public function RemoveObject(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < g_ObjectCount)
         {
            if(this.g_ObjectInfo[_loc2_].m_ObjectID == param1)
            {
               this.g_ObjectInfo.splice(_loc2_,1);
               --g_ObjectCount;
               return;
            }
            _loc2_++;
         }
      }
      
      public function GetObjectID(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < g_ObjectCount)
         {
            if(this.g_ObjectInfo[_loc2_].m_ObjectID == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function GetScoreFunc(param1:RCar) : void
      {
         this.m_CarsList.push(param1);
         ++this.m_LastRank;
         this.m_LastList.push(this.m_LastRank);
      }
      
      public function EmptyScores() : void
      {
         this.m_CarsList.splice(0);
         this.m_LastRank = 0;
         this.m_LastList.splice(0);
      }
      
      private function onMenuTextLoad(param1:Event) : void
      {
         var _loc5_:Array = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data;
         var _loc4_:Array = _loc3_.split("\r\n");
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_].split("#");
            m_StringTbl[_loc5_[0]] = _loc5_[1];
            _loc6_++;
         }
         this.m_FaceBook = new FaceMgr();
         this.LogInComplete(null);
         this.UpdateData(null);
      }
      
      private function getPersonalBestTime() : String
      {
         if(this.GameClient.m_TrackID < 1)
         {
            return "-- : --";
         }
         var _loc1_:int = g_UserInfo.maps[this.GameClient.m_TrackID - 1].personalbest;
         var _loc2_:int = _loc1_ / 60;
         var _loc3_:int = _loc1_ % 60;
         var _loc4_:* = "";
         if(_loc2_ <= 9)
         {
            _loc4_ = "0";
         }
         _loc4_ = (_loc4_ += String(_loc2_)) + " : ";
         if(_loc3_ <= 9)
         {
            _loc4_ += "0";
         }
         return _loc4_ + String(_loc3_);
      }
      
      private function TranslateString(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         if(param1 == null)
         {
            return "";
         }
         if(param1.search("%") >= 0)
         {
            param1 = param1.replace("%mapname",m_StringTbl["$MAPNAME" + this.GameClient.m_TrackID]);
            param1 = param1.replace("%personalbest",this.getPersonalBestTime());
            param1 = param1.replace("%map",g_TrackID);
            _loc4_ = FaceMgr.friends;
            _loc5_ = FaceMgr.myRank;
            _loc6_ = 0;
            if(_loc5_ > 1 && _loc5_ <= _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_ - 2].totalpoint - _loc4_[_loc5_ - 1].totalpoint;
            }
            param1 = param1.replace("%passpnt",this.intToStr(_loc6_));
            if(_loc5_ > 0 && _loc5_ <= _loc4_.length)
            {
               param1 = param1.replace("%points",this.intToStr(_loc4_[_loc5_ - 1].totalpoint));
            }
            _loc3_ = "";
            _loc3_ = g_UserInfo.firstName;
            if(param2)
            {
               _loc3_ += " " + g_UserInfo.lastName;
            }
            param1 = param1.replace("%name",_loc3_);
            _loc3_ = "";
            if(_loc7_ = this.GetPrevFriendInfo())
            {
               _loc3_ = _loc7_.firstname;
               if(param2)
               {
                  _loc3_ += " " + _loc7_.lastname;
               }
            }
            param1 = param1.replace("%prevname",_loc3_);
            _loc3_ = "";
            if(_loc8_ = this.GetPrevFriendInfo())
            {
               _loc3_ = _loc8_.firstname;
               if(param2)
               {
                  _loc3_ += " " + _loc8_.lastname;
               }
            }
            param1 = param1.replace("%othername",_loc3_);
         }
         return param1;
      }
      
      public function GetMenuText(param1:String) : String
      {
         this.CalcScore();
         return this.TranslateString(m_StringTbl[param1]);
      }
      
      public function intToStr(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         var _loc3_:String = "";
         var _loc5_:int;
         var _loc4_:int;
         if(_loc5_ = (_loc4_ = _loc2_.length) % 3)
         {
            _loc3_ = _loc2_.substr(0,_loc5_);
         }
         while(_loc5_ < _loc4_ - 1)
         {
            if(_loc5_)
            {
               _loc3_ += this.m_Delimiter;
            }
            _loc3_ += _loc2_.substr(_loc5_,3);
            _loc5_ += 3;
         }
         return _loc3_;
      }
      
      public function GetTextFunc(param1:String) : String
      {
         return this.TranslateString(m_StringTbl[param1]);
      }
      
      public function GetTextFunc1(param1:String) : String
      {
         return this.TranslateString(m_StringTbl[param1],true);
      }
      
      public function GetTopFriendPlayerObject() : Object
      {
         return FaceMgr.friends[0];
      }
      
      public function SetBackSoundVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         if(this.m_BackSoundChannel != null)
         {
            _loc2_ = this.m_BackSoundChannel.soundTransform;
            _loc2_.volume = param1;
            this.m_BackSoundChannel.soundTransform = _loc2_;
         }
      }
      
      public function SetEngineSoundVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         if(this.m_EngineSoundChannel != null)
         {
            _loc2_ = this.m_EngineSoundChannel.soundTransform;
            _loc2_.volume = param1;
            this.m_EngineSoundChannel.soundTransform = _loc2_;
         }
      }
      
      public function EngineSoundStop() : void
      {
         if(this.m_EngineSoundChannel != null)
         {
            this.m_EngineSoundChannel.stop();
         }
      }
      
      public function BackSoundStop() : void
      {
         if(this.m_BackSoundChannel != null)
         {
            this.m_BackSoundChannel.stop();
         }
      }
      
      public function GetTopWorldPlayerObject() : Object
      {
         return this.m_WorldRankArr[0];
      }
      
      public function GetRankText(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case 1:
               _loc2_ = "1st";
               break;
            case 2:
               _loc2_ = "2nd";
               break;
            case 3:
               _loc2_ = "3rd";
               break;
            case 4:
               _loc2_ = "4th";
         }
         return _loc2_;
      }
      
      public function setPrev(param1:Class) : void
      {
         this._Prev_Page = param1;
      }
      
      public function getPrev() : Class
      {
         return this._Prev_Page;
      }
   }
}
