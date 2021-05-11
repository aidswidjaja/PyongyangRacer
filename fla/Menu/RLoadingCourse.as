package Menu
{
   import Facebook.FaceMgr;
   import common.Client;
   import common.RGameCommon;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import player.RGameClient;
   
   public class RLoadingCourse extends RCommonUI
   {
      
      public static var m_multiUsers:Array;
      
      private static var loadingprog:int = 0;
      
      public static var gameStartTime:int;
      
      public static var gameReadyTime:int = 10000;
       
      
      protected var btnEnable:Boolean = false;
      
      protected var _logo:LogoMark;
      
      private var timer:Timer;
      
      private var fdel:Boolean = false;
      
      private var _isGo:Boolean;
      
      public function RLoadingCourse(param1:RGameCommon)
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         this._logo = new LogoMark();
         if(!RockRacer.GameCommon.g_SingleGame)
         {
            m_multiUsers = Client.getUserInfoList();
         }
         super(param1);
         RockRacer.GameCommon.m_PlayerPictureMgr.Init();
         if(!RockRacer.GameCommon.g_SingleGame)
         {
            _loc2_ = m_multiUsers;
            _loc3_ = _loc2_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if((_loc5_ = _loc2_[_loc4_]).uid != Client.myUserId)
               {
                  RockRacer.GameCommon.m_PlayerPictureMgr.LoadPictureFromUrl(_loc5_.picsquare);
               }
               _loc4_++;
            }
         }
      }
      
      private static function userOut(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = Client.getUserInfoList();
         RGameClient.userTotal = _loc2_.length;
         if(RockRacer.GameCommon.GameClient.m_RenderMode == RGameClient.RENDER_PLAYING)
         {
            _loc3_ = 0;
            while(_loc3_ < RockRacer.GameCommon.GameClient.m_CarList.length)
            {
               if(param1 == RockRacer.GameCommon.GameClient.m_CarList[_loc3_].m_userId)
               {
                  RockRacer.GameCommon.GameClient.m_CarList[_loc3_].StopAccel();
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      override protected function init() : void
      {
         super.init();
         setMC(TrackLoading);
         this._logo.gotoAndStop(3);
         this._logo.x = 650;
         this._logo.y = 8;
         addChild(this._logo);
         this.SetText();
         this.SetEvent();
         _mc.MC_MapImage.gotoAndStop(RGameCommon.g_TrackID + 1);
         this.fdel = false;
         if(!RockRacer.GameCommon.g_SingleGame)
         {
            Client.funcs = {};
            Client.funcs[Client.CMD_START] = this.gameStart;
            Client.funcs["leave"] = userOut;
         }
      }
      
      protected function SetText() : void
      {
      }
      
      protected function levelLoadComplete(param1:Event) : void
      {
         this.btnEnable = true;
         this.timer = new Timer(5000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.GoToPlay);
         this.timer.start();
      }
      
      protected function SetEvent() : void
      {
         this._isGo = false;
         _mc.addEventListener(Event.ENTER_FRAME,this.loop);
         _manager.GameClient.addEventListener("LOAD_FINISH",this.loadFinish);
         _manager.GameClient.addEventListener("progress",this.initProgress);
      }
      
      protected function loadFinish(param1:Event) : void
      {
         _manager.GameClient.removeEventListener("LOAD_FINISH",this.loadFinish);
         _manager.GameClient.removeEventListener("progress",this.initProgress);
         this.btnEnable = true;
         this.GoToPlay(null);
      }
      
      protected function initProgress(param1:ProgressEvent) : void
      {
         loadingprog = 80;
         _mc.CHT_Loading.gotoAndStop(30 + param1.bytesLoaded);
      }
      
      protected function ViewInfoFunc() : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc1_:Array = FaceMgr.mapInfo;
         var _loc2_:Object = _loc1_[RGameCommon.g_TrackID - 1];
         if(RockRacer.GameCommon.g_SingleGame)
         {
            _mc.VS_Single.F_Personal.uilPic.source = RGameCommon.g_UserInfo.picsquare;
            _mc.VS_Single.F_Personal.txtName.text = RGameCommon.g_UserInfo.firstName;
            _mc.VS_Single.F_Personal.txtScore.text = "";
            _mc.VS_Single.T_Personal.text = this.TimetoText(RGameCommon.g_UserInfo.maps[RGameCommon.g_TrackID - 1].personalbest / 60,RGameCommon.g_UserInfo.maps[RGameCommon.g_TrackID - 1].personalbest % 60);
            _mc.VS_Single.F_Personal.mcRankBG.visible = false;
            _mc.VS_Single.F_Friend.uilPic.source = _loc2_.fbpic;
            if(_loc2_.fbtime > 0 && _loc2_.fbtime < 600)
            {
               _mc.VS_Single.F_Friend.txtName.text = _loc2_.fbname;
            }
            else
            {
               _mc.VS_Single.F_Friend.txtName.text = "N / A";
            }
            _mc.VS_Single.F_Friend.txtScore.text = "";
            _mc.VS_Single.T_Friend.text = this.TimetoText(_loc2_.fbtime / 60,_loc2_.fbtime % 60);
            _mc.VS_Single.F_World.uilPic.source = _loc2_.wbpic;
            if(_loc2_.wbtime > 0 && _loc2_.wbtime < 600)
            {
               _mc.VS_Single.F_World.txtName.text = _loc2_.wbname;
            }
            else
            {
               _mc.VS_Single.F_World.txtName.text = "N / A";
            }
            _mc.VS_Single.F_World.txtScore.text = "";
            _mc.VS_Single.T_World.text = this.TimetoText(_loc2_.wbtime / 60,_loc2_.wbtime % 60);
         }
         else
         {
            _loc3_ = new Array();
            _mc.VS_Multi.TXT_VS1.visible = true;
            _mc.VS_Multi.TXT_VS2.visible = true;
            _mc.VS_Multi.TXT_VS3.visible = true;
            switch(Client.multiInfo.ps.length)
            {
               case 2:
                  _mc.VS_Multi.User1.visible = false;
                  _mc.VS_Multi.User4.visible = false;
                  _mc.VS_Multi.TXT_VS1.visible = false;
                  _mc.VS_Multi.TXT_VS3.visible = false;
                  _loc3_.push(_mc.VS_Multi.User2);
                  _loc3_.push(_mc.VS_Multi.User3);
                  break;
               case 3:
                  _mc.VS_Multi.User4.visible = false;
                  _mc.VS_Multi.TXT_VS3.visible = false;
                  _loc3_.push(_mc.VS_Multi.User1);
                  _loc3_.push(_mc.VS_Multi.User2);
                  _loc3_.push(_mc.VS_Multi.User3);
                  break;
               case 4:
                  _loc3_.push(_mc.VS_Multi.User1);
                  _loc3_.push(_mc.VS_Multi.User2);
                  _loc3_.push(_mc.VS_Multi.User3);
                  _loc3_.push(_mc.VS_Multi.User4);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc3_[_loc5_].visible = true;
               if(Client.multiInfo.ps[_loc5_] == Client.myUserId)
               {
                  _loc3_[_loc5_].myBack.visible = true;
               }
               else
               {
                  _loc3_[_loc5_].myBack.visible = false;
               }
               _loc6_ = 0;
               while(_loc6_ < m_multiUsers.length)
               {
                  if(m_multiUsers[_loc6_].uid == Client.multiInfo.ps[_loc5_])
                  {
                     _loc4_ = m_multiUsers[_loc6_];
                  }
                  _loc6_++;
               }
               _loc3_[_loc5_].uilPic.source = _loc4_.picsquare;
               _loc3_[_loc5_].TXT_Name.text = _loc4_.firstname;
               _loc7_ = "";
               switch(RGameCommon.g_TrackID)
               {
                  case 1:
                     _loc7_ = _loc4_.level1time;
                     break;
                  case 2:
                     _loc7_ = _loc4_.level2time;
                     break;
                  case 3:
                     _loc7_ = _loc4_.level3time;
                     break;
                  case 4:
                     _loc7_ = _loc4_.level4time;
                     break;
                  case 5:
                     _loc7_ = _loc4_.level5time;
                     break;
               }
               if(_loc7_ != "")
               {
                  _loc3_[_loc5_].TXT_Time.text = _loc7_;
               }
               else
               {
                  _loc3_[_loc5_].TXT_Time.text = "--:--";
               }
               _loc5_++;
            }
         }
      }
      
      protected function TimetoText(param1:int, param2:int) : String
      {
         var _loc3_:* = "";
         if(param1 < 0 || param1 > 9)
         {
            return "-- : --";
         }
         if(param1 <= 9)
         {
            _loc3_ = "0";
         }
         _loc3_ += String(param1);
         _loc3_ += " : ";
         if(param2 <= 9)
         {
            _loc3_ += "0";
         }
         return _loc3_ + String(param2);
      }
      
      protected function updateProgress(param1:Event) : void
      {
         if(_mc.CHT_Loading.currentFrame < 50)
         {
            ++loadingprog;
            _mc.CHT_Loading.gotoAndStop(loadingprog * 50 / 140);
         }
      }
      
      protected function GoToPlay(param1:TimerEvent) : void
      {
         var _loc2_:Array = null;
         if(this.btnEnable)
         {
            if(RockRacer.GameCommon.g_SingleGame)
            {
               this.gameStart();
            }
            else
            {
               Client.funcs[Client.CMD_MOVE] = RockRacer.GameCommon.GameClient.setMoveState;
               Client.funcs[Client.CMD_GET_ITEM] = RockRacer.GameCommon.GameClient.getItem;
               Client.funcs[Client.CMD_ADD_ITEM] = RockRacer.GameCommon.GameClient.addItem;
               Client.funcs[Client.CMD_SET_LAP] = RockRacer.GameCommon.GameClient.setLap;
               _loc2_ = m_multiUsers;
               RGameClient.userTotal = _loc2_.length;
               Client.start();
            }
         }
      }
      
      private function gameStart(param1:Object = null) : void
      {
         gameStartTime = getTimer();
         this.btnEnable = true;
         this.fdel = true;
         _mc.CHT_Loading.gotoAndStop(70);
         loadingprog = 0;
      }
      
      protected function loop(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = gameReadyTime - 2000;
         parent.setChildIndex(this,parent.numChildren - 1);
         if(this.fdel)
         {
            _loc3_ = getTimer();
            _loc4_ = 30;
            _mc.CHT_Loading.gotoAndStop(70 + int(_loc4_ * (_loc3_ - gameStartTime) / _loc2_));
            if(_loc3_ - gameStartTime >= 7000 && this._isGo == false)
            {
               RGameCommon.isGO = true;
               this._isGo = true;
            }
            if(_loc3_ - gameStartTime >= _loc2_)
            {
               this.fdel = false;
               this.visible = false;
               _mc.removeEventListener(Event.ENTER_FRAME,this.loop);
            }
         }
         else if(RGameCommon.isStart == 0)
         {
            RGameCommon.isStart = 1;
         }
         else if(loadingprog < 80)
         {
            ++loadingprog;
            _mc.CHT_Loading.gotoAndStop(int(loadingprog * 3 / 8));
         }
      }
   }
}
