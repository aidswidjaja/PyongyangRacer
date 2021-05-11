package ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import player.RSoundMgr;
   
   public class RGuideWindow extends GuideWindow
   {
      
      public static const LEFT:int = 0;
      
      public static const RIGHT:int = 1;
      
      public static const FORWARD:int = 2;
      
      public static const WRONG:int = 3;
      
      public static const COLLISION:int = 4;
       
      
      public var direction:int = 0;
      
      public var guideString:String;
      
      private var time:int;
      
      public function RGuideWindow()
      {
         this.guideString = new String();
         super();
         addEventListener("pauseScreen",this.onPauseScreen);
         addEventListener(Event.ENTER_FRAME,this.loop);
         this.time = -1;
      }
      
      public function loop(param1:Event) : void
      {
         if(this.time == 0)
         {
            this.onEnd();
         }
         if(this.time >= 0)
         {
            --this.time;
         }
      }
      
      public function onPauseScreen(param1:Event) : void
      {
         var _loc2_:Sound = null;
         var _loc3_:Number = NaN;
         var _loc4_:MovieClip = null;
         switch(this.direction)
         {
            case LEFT:
               gotoAndStop("left");
               break;
            case RIGHT:
               gotoAndStop("right");
               break;
            case FORWARD:
               gotoAndStop("forward");
               break;
            case WRONG:
               gotoAndStop("warring");
               break;
            case COLLISION:
               gotoAndStop("collision");
               if(this.time < 50)
               {
                  _loc2_ = RSoundMgr.GetSound("whistle");
                  _loc2_.play();
                  _loc3_ = (_loc4_ = RockRacer.GameCommon.GameClient.mc_InfoWnd.mc_Health).currentFrame - 40;
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  _loc4_.gotoAndStop(_loc3_);
                  RockRacer.GameCommon.GameClient.mc_InfoWnd.mc_iHit.text = int((100 - _loc3_) / 40).toString();
                  if(_loc3_ <= 0)
                  {
                     RockRacer.GameCommon.GameClient.QuitWindowFunc(3);
                  }
               }
               this.time = 60;
               return;
         }
         this.time = -1;
         txt_Content.text = this.guideString;
      }
      
      public function onStart(param1:int, param2:String) : void
      {
         RockRacer.GameCommon.GameClient.mc_InfoWnd.onExitScreen(null);
         this.direction = param1;
         if(param2 != "")
         {
            this.guideString = param2;
         }
         if(currentFrame < 2)
         {
            gotoAndPlay("intro");
         }
         else if(currentFrame > 4)
         {
            this.onPauseScreen(null);
         }
      }
      
      public function onEnd() : void
      {
         if(currentFrame > 1)
         {
            gotoAndPlay("outro");
         }
      }
   }
}
