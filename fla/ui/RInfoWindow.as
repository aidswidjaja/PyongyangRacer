package ui
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class RInfoWindow extends InfoWindow
   {
       
      
      public var info:Object;
      
      private var infoDic:Dictionary;
      
      private var delayframe:int = -1;
      
      public var m_nTreasures:int;
      
      public function RInfoWindow()
      {
         this.info = new Object();
         this.infoDic = RockRacer.GameCommon.CommonRsrMgr.m_Infofile.m_InfoDic;
         super();
         addEventListener("buttonScreen",this.onButtonScreen);
         addEventListener("popupScreen",this.onPopupScreen);
         addEventListener("exitScreen",this.onExitScreen);
      }
      
      protected function loop(param1:Event) : void
      {
         if(!RockRacer.GameCommon.GameClient.pause)
         {
            if(this.delayframe > 0)
            {
               --this.delayframe;
            }
            else
            {
               removeEventListener(Event.ENTER_FRAME,this.loop);
               this.onExitScreen(null);
            }
         }
      }
      
      public function onButtonScreen(param1:Event) : void
      {
      }
      
      public function onPopupScreen(param1:Event) : void
      {
         mc_Tiltle.text = this.info.title;
         mc_Text.text = this.info.text;
         mcPic.uilPic.source = this.info.pic;
         mc_Pin.gotoAndStop("release");
         mc_Pin.addEventListener(MouseEvent.CLICK,this.fixPin);
      }
      
      private function fixPin(param1:MouseEvent) : void
      {
         RockRacer.GameCommon.GameClient.pause = !RockRacer.GameCommon.GameClient.pause;
         mc_Pin.gotoAndStop(3 - mc_Pin.currentFrame);
      }
      
      public function onExitScreen(param1:Event) : void
      {
         gotoAndStop("outro");
      }
      
      public function onInfo(param1:Event) : void
      {
         RockRacer.GameCommon.GameClient.pause = true;
         gotoAndStop("popup");
      }
      
      public function onStart(param1:Object) : void
      {
         var _loc3_:Object = null;
         RockRacer.GameCommon.GameClient.mc_GuideWnd.onEnd();
         this.info = param1;
         this.infoDic[this.info.index].check = 1;
         var _loc2_:int = 0;
         for each(_loc3_ in this.infoDic)
         {
            _loc2_ += _loc3_.check;
         }
         mc_iCounter.text = _loc2_.toString();
         if(currentFrame < 2)
         {
            gotoAndPlay("intro");
         }
         this.delayframe = 60;
         addEventListener(Event.ENTER_FRAME,this.loop);
      }
      
      public function initCounter() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.infoDic)
         {
            _loc1_++;
            _loc2_.check = 0;
         }
         mc_iNum.text = _loc1_.toString();
         mc_iCounter.text = "0";
         this.m_nTreasures = 0;
         mc_iNum1.text = RockRacer.GameCommon.GameClient.m_Terrain.m_ObjectCount.toString();
         mc_iCounter1.text = this.m_nTreasures.toString();
         mc_iHit.text = "0";
         mc_Oil.gotoAndStop(100);
         mc_Health.gotoAndStop(100);
      }
      
      public function incCounter1() : void
      {
         ++this.m_nTreasures;
         mc_iCounter1.text = this.m_nTreasures.toString();
      }
   }
}
