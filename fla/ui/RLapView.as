package ui
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import player.RCar;
   import player.RGameClient;
   
   public class RLapView extends MovieClip
   {
       
      
      private var mcPlayerLabView:MovieClip;
      
      private var mcInspector2:MovieClip;
      
      private var m_finallap_view:MovieClip;
      
      private var m_Winner_Mark:MovieClip;
      
      private var m_currInspector:MovieClip;
      
      private var m_currLap:int;
      
      public function RLapView(param1:Number = 1)
      {
         super();
         var _loc2_:Class = this.GetClassInSWF("PlayerLabView");
         this.mcPlayerLabView = MovieClip(new _loc2_());
         _loc2_ = this.GetClassInSWF("Inspector2");
         this.mcInspector2 = MovieClip(new _loc2_());
         _loc2_ = this.GetClassInSWF("FinalLapNotifier");
         this.m_finallap_view = MovieClip(new _loc2_());
         _loc2_ = this.GetClassInSWF("RateSymbol");
         this.m_Winner_Mark = MovieClip(new _loc2_());
         this.mcPlayerLabView.x = RGameClient.m_ViewportWidth - this.mcPlayerLabView.width - 70;
         this.mcPlayerLabView.y = 40;
         this.mcInspector2.x = 320;
         this.mcInspector2.y = 120;
         this.m_finallap_view.x = 380;
         this.m_finallap_view.y = 250;
         this.m_Winner_Mark.x = 380;
         this.m_Winner_Mark.y = 250;
         this.m_Winner_Mark.visible = false;
         this.m_finallap_view.mc_Final.txtText.text = RockRacer.GameCommon.GetTextFunc("$GAME_FINAL");
         this.addChild(this.mcPlayerLabView);
         this.addChild(this.m_finallap_view);
         this.addChild(this.m_Winner_Mark);
         this.m_currInspector = null;
         this.setPlayerLab(param1);
      }
      
      public function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public function setPlayerLab(param1:uint, param2:Boolean = false) : void
      {
         var tLap:int = 0;
         var labNum:uint = param1;
         var bflick:Boolean = param2;
         if(bflick)
         {
            this.flickerLabNum();
         }
         if(labNum > RCar.LASTLAP + 1)
         {
            return;
         }
         if(this.m_currLap == labNum)
         {
            return;
         }
         this.m_currLap = labNum;
         if(labNum >= RCar.LASTLAP)
         {
            tLap = RCar.LASTLAP;
         }
         else
         {
            tLap = labNum;
         }
         this.mcPlayerLabView.txtText.text = RockRacer.GameCommon.GetTextFunc("$GAME_LAPVIEW_TEXT1") + " " + String(tLap) + "/" + String(RCar.LASTLAP);
         switch(RCar.LASTLAP - labNum)
         {
            case 0:
               this.m_finallap_view.gotoAndPlay(2);
               this.flickerLabNum();
               break;
            case -1:
               this.m_Winner_Mark.visible = true;
               with(RockRacer.GameCommon.GameClient)
               {
                  
                  m_Winner_Mark.txtText.text = RockRacer.GameCommon.GetTextFunc("$GAME_RANK_TEXT" + String(m_CarList[m_PlayerID].m_Rank));
               }
               break;
            default:
               this.m_finallap_view.gotoAndStop(0);
               this.m_Winner_Mark.visible = false;
               this.flickerLabNum();
         }
      }
      
      private function flickerLabNum(param1:int = 8) : void
      {
         if(param1 <= 0)
         {
            this.mcPlayerLabView.visible = true;
            return;
         }
         if(param1 % 2 == 0)
         {
            this.mcPlayerLabView.visible = false;
         }
         else
         {
            this.mcPlayerLabView.visible = true;
         }
         param1--;
         setTimeout(this.flickerLabNum,500,param1);
      }
      
      public function set pause(param1:Boolean) : void
      {
         if(this.m_currLap == 2 && this.m_finallap_view.currentFrame > 1)
         {
            if(param1)
            {
               this.m_finallap_view.stop();
            }
            else
            {
               this.m_finallap_view.play();
            }
         }
      }
   }
}
