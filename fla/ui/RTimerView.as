package ui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import player.RGameClient;
   
   public class RTimerView extends MovieClip
   {
       
      
      private const STATE_STOP:uint = 0;
      
      private const STATE_PAUSE:uint = 1;
      
      private const STATE_START:uint = 2;
      
      private var currentState:uint = 0;
      
      private var mcTimerView:MovieClip;
      
      private var m1:MovieClip;
      
      private var m2:MovieClip;
      
      private var s1:MovieClip;
      
      private var s2:MovieClip;
      
      private var ms1:MovieClip;
      
      private var ms2:MovieClip;
      
      private var ms3:MovieClip;
      
      private var date:Date;
      
      private var _stime:int = 0;
      
      private var _ctime:int = 0;
      
      private var _ptime:int = 0;
      
      public function RTimerView()
      {
         this.date = new Date();
         super();
         var _loc1_:Class = this.GetClassInSWF("TimerView");
         this.mcTimerView = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.m1 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.m2 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.s1 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.s2 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.ms1 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.ms2 = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("Counter");
         this.ms3 = MovieClip(new _loc1_());
         this.init();
      }
      
      public function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public function init() : void
      {
         this.mcTimerView.x = RGameClient.m_ViewportWidth - this.mcTimerView.width - 65;
         this.mcTimerView.y = 12;
         addChild(this.mcTimerView);
         this.mcTimerView.addChild(this.m1);
         this.mcTimerView.addChild(this.m2);
         this.mcTimerView.addChild(this.s1);
         this.mcTimerView.addChild(this.s2);
         this.mcTimerView.addChild(this.ms1);
         this.mcTimerView.addChild(this.ms2);
         this.m1.x = 18;
         this.m2.x = 35;
         this.s1.x = 65;
         this.s2.x = 82;
         this.ms1.x = 110;
         this.ms2.x = 125;
         this.m2.y = 0;
         this.s1.y = 0;
         this.s2.y = 0;
         this.ms1.y = 0;
         this.ms2.y = 0;
         this.time = 0;
         this.currentState = this.STATE_STOP;
      }
      
      public function set time(param1:int) : void
      {
         this.date.setTime(param1);
         this.setMinutes(this.date.getMinutes());
         this.setSeconds(this.date.getSeconds());
         this.setMilliseconds(this.date.getMilliseconds());
         this._ctime = param1;
      }
      
      public function get time() : int
      {
         return this._ctime;
      }
      
      private function setMinutes(param1:Number) : void
      {
         this.m1.gotoAndStop(Math.floor(param1 / 10) + 1);
         this.m2.gotoAndStop(param1 % 10 + 1);
      }
      
      private function setSeconds(param1:Number) : void
      {
         this.s1.gotoAndStop(Math.floor(param1 / 10) + 1);
         this.s2.gotoAndStop(param1 % 10 + 1);
      }
      
      private function setMilliseconds(param1:Number) : void
      {
         this.ms1.gotoAndStop(Math.floor(param1 / 100) + 1);
         this.ms2.gotoAndStop(Math.floor(param1 / 10) % 10 + 1);
         this.ms3.gotoAndStop(param1 % 10 + 1);
      }
      
      public function startTime() : void
      {
         this._stime = getTimer();
         this.currentState = this.STATE_START;
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function stopTime() : void
      {
         this.currentState = this.STATE_STOP;
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._stime = 0;
      }
      
      public function pauseTime() : void
      {
         if(this.currentState != this.STATE_START)
         {
            return;
         }
         this.currentState = this.STATE_PAUSE;
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._ptime = getTimer();
      }
      
      public function resumeTime() : int
      {
         if(this.currentState != this.STATE_PAUSE)
         {
            return 0;
         }
         this.currentState = this.STATE_START;
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var _loc1_:int = getTimer() - this._ptime;
         this._stime += _loc1_;
         return _loc1_;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.time = getTimer() - this._stime;
      }
      
      public function flickerTime(param1:int = 8) : void
      {
         if(param1 <= 0)
         {
            if(this.currentState == this.STATE_PAUSE)
            {
               this.resumeTime();
            }
            visible = true;
            return;
         }
         if(this.currentState == this.STATE_START)
         {
            this.pauseTime();
         }
         if(param1 % 2 == 0)
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
         param1--;
         setTimeout(this.flickerTime,500,param1);
      }
   }
}
