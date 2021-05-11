package org.papervision3d.core.log.event
{
   import flash.events.Event;
   import org.papervision3d.core.log.PaperLogVO;
   
   public class PaperLoggerEvent extends Event
   {
      
      public static const TYPE_LOGEVENT:String = "logEvent";
       
      
      public var paperLogVO:PaperLogVO;
      
      public function PaperLoggerEvent(param1:PaperLogVO)
      {
         super(TYPE_LOGEVENT);
         this.paperLogVO = param1;
      }
   }
}
