package Menu
{
   import Facebook.FaceMgr;
   import common.RGameCommon;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class MainMenu extends RCommonUI
   {
      
      public static var _self:Object;
      
      public static var _dlgArray:Array = [StartDlg];
      
      public static var _dlgCount:int;
      
      public static var _multiMode:Boolean;
       
      
      protected var _nextPage:Class;
      
      protected var _logo:LogoMark;
      
      protected var _Banner:MovieClip;
      
      protected var _isSetEvent:Boolean = false;
      
      private var _dialog:AbstractDlg;
      
      public function MainMenu(param1:RGameCommon)
      {
         this._logo = new LogoMark();
         _self = this;
         super(param1);
         _dlgCount = 0;
      }
      
      override protected function init() : void
      {
         super.init();
         setMC(MainScreen);
         this._logo.x = 650;
         this._logo.gotoAndStop(3);
         this._Banner = new MovieClip();
         if(RockRacer.parameters.lang == "de")
         {
            this._Banner.gotoAndStop(2);
         }
         this._Banner.x = 160;
         this._Banner.y = 26;
         this._logo.y = 8;
         addChild(this._logo);
         _mc.addEventListener("PausedScreen1",this.PausedScreen1);
         _mc.gotoAndPlay(1);
         this.SetMCText();
      }
      
      protected function PausedScreen1(param1:Event) : void
      {
         this.SetEvent();
         this.SetEvent1();
         if(!_manager.m_SoundOnOff)
         {
         }
         if(this._dialog == null)
         {
            _dlgCount = -1;
            this.dialog = StartDlg;
         }
         else
         {
            this.currentDialog.init();
         }
      }
      
      public function removeDlg() : void
      {
         if(this._dialog == null)
         {
            return;
         }
         this._dialog.removeObject();
         this._dialog = null;
      }
      
      public function set dialog(param1:Class) : void
      {
         var _loc2_:int = _dlgCount;
         _dlgCount = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _dlgArray.length)
         {
            if(_dlgArray[_loc3_] == param1)
            {
               _dlgCount = _loc3_;
               break;
            }
            _loc3_++;
         }
         this._Banner.visible = false;
         if(_loc2_ == _dlgCount)
         {
            return;
         }
         this.removeDlg();
         this._dialog = new _dlgArray[_dlgCount]();
      }
      
      public function get currentDialog() : AbstractDlg
      {
         return this._dialog;
      }
      
      public function set page(param1:Class) : void
      {
         removeChild(this._logo);
         this._nextPage = param1;
         _manager.setPrev(MainMenu);
         _manager.createPage(this._nextPage);
      }
      
      public function get currentPage() : Class
      {
         return this._nextPage;
      }
      
      public function get banner() : MovieClip
      {
         return this._Banner;
      }
      
      protected function SetEvent() : void
      {
         if(this._isSetEvent)
         {
            return;
         }
         this._isSetEvent = true;
         addChild(this._Banner);
         _mc.addEventListener(Event.ENTER_FRAME,this.loop);
         _mc.addEventListener(MouseEvent.CLICK,this.MouseClickFunc);
         this.setLeftText();
      }
      
      protected function setLeftText() : void
      {
      }
      
      protected function SetMCText() : void
      {
         if(FaceMgr.waitResult)
         {
            setTimeout(this.SetMCText,100);
            return;
         }
      }
      
      protected function SetEvent1() : void
      {
      }
      
      protected function ToBack(param1:Event) : void
      {
         this.backDialog();
      }
      
      public function backDialog() : void
      {
         if(_dlgCount < 1)
         {
            return;
         }
         this.dialog = _dlgArray[_dlgCount - 1];
      }
      
      protected function SoundFunc(param1:Event) : void
      {
      }
      
      private function RemoveEvents() : void
      {
      }
      
      protected function ClearedScreen(param1:Event) : void
      {
         _mc.removeEventListener("PausedScreen1",this.PausedScreen1);
         _mc.removeEventListener(MouseEvent.CLICK,this.MouseClickFunc);
         _mc.removeEventListener(Event.ENTER_FRAME,this.loop1);
         removeChild(this._logo);
         _manager.setPrev(MainMenu);
         _manager.createPage(this._nextPage);
      }
      
      protected function loop(param1:Event) : void
      {
         if(_manager.m_SoundOnOff)
         {
            _manager.SetBackSoundVolume(1);
         }
         else
         {
            _manager.SetBackSoundVolume(0);
         }
         if(RockRacer.GameCommon.m_boolGetFirst)
         {
            _mc.removeEventListener(Event.ENTER_FRAME,this.loop);
            _mc.addEventListener(Event.ENTER_FRAME,this.loop1);
         }
      }
      
      protected function loop1(param1:Event) : void
      {
         if(_manager.m_SoundOnOff)
         {
            _manager.SetBackSoundVolume(1);
         }
         else
         {
            _manager.SetBackSoundVolume(0);
         }
      }
      
      protected function LoadFacebookData() : void
      {
         var _loc1_:Object = _manager.GetTopFriendPlayerObject();
         var _loc2_:Number = RGameCommon.g_UserInfo.uid;
         if(_loc1_.uid == _loc2_)
         {
            _mc.Face_1.SelectMy.visible = false;
         }
         _mc.Face_1.TXT_Name.text = _loc1_.firstname;
         _mc.Face_1.uilPic.source = _loc1_.picsquare;
         _mc.Face_1.TXT_Score.text = _manager.intToStr(_loc1_.totalpoint);
         _mc.Face_1.TXT_Team.text = _loc1_.teammates + _manager.GetTextFunc("$TEAMMATES");
      }
      
      protected function ToProfile(param1:Event) : void
      {
      }
      
      public function ToRace(param1:Event) : void
      {
         RockRacer.GameCommon.g_SingleGame = true;
         _multiMode = false;
         this.page = RLoadingCourse;
         _manager.BackSoundStop();
      }
      
      protected function ToBrag(param1:Event) : void
      {
         this.removeDlg();
         this.publishStory();
      }
      
      protected function MouseClickFunc(param1:Event) : void
      {
         if(param1.target.name == "Image_invite")
         {
         }
      }
      
      protected function publishStory() : void
      {
         var _loc1_:Object = {
            "images":[{
               "src":_manager.GetTextFunc("$F_BRAG_IMGSRC"),
               "href":_manager.GetTextFunc("$F_BRAG_LINK_EN")
            }],
            "oneliner":"",
            "feedtitle":_manager.GetTextFunc("$F_BRAG_TITLE_EN"),
            "feedbody":_manager.GetTextFunc("$F_BRAG_BODY_EN"),
            "alink":_manager.GetTextFunc("$F_BRAG_LINK_EN"),
            "alinktext":"Play Rock Racer"
         };
      }
   }
}
