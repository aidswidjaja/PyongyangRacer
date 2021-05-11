package mx.rpc
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AsyncDispatcher
   {
       
      
      private var _method:Function;
      
      private var _timer:Timer;
      
      private var _args:Array;
      
      public function AsyncDispatcher(param1:Function, param2:Array, param3:Number)
      {
         super();
         _method = param1;
         _args = param2;
         _timer = new Timer(param3);
         _timer.addEventListener(TimerEvent.TIMER,timerEventHandler);
         _timer.start();
      }
      
      private function timerEventHandler(param1:TimerEvent) : void
      {
         _timer.stop();
         _timer.removeEventListener(TimerEvent.TIMER,timerEventHandler);
         _method.apply(null,_args);
      }
   }
}
