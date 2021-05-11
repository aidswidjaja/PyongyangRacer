package org.papervision3d.core.log
{
   import org.papervision3d.core.log.event.PaperLoggerEvent;
   
   public class AbstractPaperLogger implements IPaperLogger
   {
       
      
      public function AbstractPaperLogger()
      {
         super();
      }
      
      protected function onLogEvent(param1:PaperLoggerEvent) : void
      {
         var _loc2_:PaperLogVO = param1.paperLogVO;
         switch(_loc2_.level)
         {
            case LogLevel.LOG:
               this.log(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.INFO:
               this.info(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.ERROR:
               this.error(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.DEBUG:
               this.debug(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.WARNING:
               this.warning(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            case LogLevel.FATAL:
               this.fatal(_loc2_.msg,_loc2_.object,_loc2_.arg);
               break;
            default:
               this.log(_loc2_.msg,_loc2_.object,_loc2_.arg);
         }
      }
      
      public function log(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function info(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function debug(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function warning(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function error(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function fatal(param1:String, param2:Object = null, param3:Array = null) : void
      {
      }
      
      public function registerWithPaperLogger(param1:PaperLogger) : void
      {
         param1.addEventListener(PaperLoggerEvent.TYPE_LOGEVENT,this.onLogEvent);
      }
      
      public function unregisterFromPaperLogger(param1:PaperLogger) : void
      {
         param1.removeEventListener(PaperLoggerEvent.TYPE_LOGEVENT,this.onLogEvent);
      }
   }
}
