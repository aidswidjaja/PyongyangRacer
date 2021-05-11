package org.papervision3d.core.utils
{
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class StopWatch extends EventDispatcher
   {
       
      
      private var startTime:int;
      
      private var stopTime:int;
      
      private var elapsedTime:int;
      
      private var isRunning:Boolean;
      
      public function StopWatch()
      {
         super();
      }
      
      public function start() : void
      {
         if(!this.isRunning)
         {
            this.startTime = getTimer();
            this.isRunning = true;
         }
      }
      
      public function stop() : int
      {
         if(this.isRunning)
         {
            this.stopTime = getTimer();
            this.elapsedTime = this.stopTime - this.startTime;
            this.isRunning = false;
            return this.elapsedTime;
         }
         return 0;
      }
      
      public function reset() : void
      {
         this.isRunning = false;
      }
   }
}
