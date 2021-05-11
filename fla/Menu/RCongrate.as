package Menu
{
   import common.RGameCommon;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RCongrate extends RCommonUI
   {
       
      
      protected var _logo:LogoMark;
      
      public function RCongrate(param1:RGameCommon)
      {
         this._logo = new LogoMark();
         super(param1);
      }
      
      override protected function init() : void
      {
         super.init();
         setMC(Congrate);
         this._logo.x = 650;
         this._logo.y = 8;
         this._logo.gotoAndStop(3);
         addChild(this._logo);
         var _loc1_:Date = new Date(_manager.m_CarsList[0].m_LapTimes[_manager.m_CarsList[0].m_Lap] - _manager.m_CarsList[0].m_LapTimes[0]);
         if(_loc1_.minutes < 8 && _loc1_.seconds < 40)
         {
            _mc.gotoAndStop(4);
            _mc.txt_Title.text = "SUPERB!";
            _mc.txt_Text.text = "You have driven with courage!\rYour ";
            _manager.PlayBackSound(RGameCommon.SND_WINGAME);
         }
         else if(_loc1_.minutes < 9)
         {
            _mc.gotoAndStop(1);
            _mc.txt_Title.text = "CONGRATULATIONS!";
            _mc.txt_Text.text = "Rather slow, but getting there ";
            _manager.PlayBackSound(RGameCommon.SND_FAILGAME);
         }
         else
         {
            _mc.gotoAndStop(1);
            _mc.txt_Title.text = "YOU MADE IT!";
            _mc.txt_Text.text = "Not the fastest time but you got here!\rYour ";
            _manager.PlayBackSound(RGameCommon.SND_FAILGAME);
         }
         _mc.txt_Text.text += "time was " + _loc1_.minutes.toString() + " mins " + _loc1_.seconds.toString() + " secs.";
         _mc.txt_score.text = "You saw: " + _manager.GameClient.mc_InfoWnd.mc_iCounter.text;
         _mc.txt_score.text += " / " + _manager.GameClient.mc_InfoWnd.mc_iNum.text;
         _mc.txt_score.text += " sights | You were warned " + _manager.GameClient.mc_InfoWnd.mc_iHit.text;
         _mc.txt_score.text += " / 3 times | You collected  " + _manager.GameClient.mc_InfoWnd.mc_iCounter1.text;
         _mc.txt_score.text += " / " + _manager.GameClient.mc_InfoWnd.mc_iNum1.text + " Petrol drums";
         addEventListener(Event.ENTER_FRAME,this.Loop);
         _mc.bt_Back.addEventListener(MouseEvent.CLICK,this.GoToNext);
      }
      
      private function Loop(param1:Event) : void
      {
      }
      
      protected function GoToNext(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.Loop);
         _manager.createPage(MainMenu);
         _manager.PlayBackSound(RGameCommon.SND_PREGAME);
      }
   }
}
