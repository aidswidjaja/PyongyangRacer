package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class MainScreen extends MovieClip
   {
       
      
      public function MainScreen()
      {
         super();
      }
      
      public function exitFrame1(param1:Event) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = new Event("PausedScreen1");
         removeEventListener(Event.EXIT_FRAME,this.exitFrame1);
         stop();
         dispatchEvent(_loc2_);
      }
   }
}
