package org.papervision3d.core.log
{
   import flash.events.EventDispatcher;
   import org.papervision3d.core.log.event.PaperLoggerEvent;
   
   public class PaperLogger extends EventDispatcher
   {
      
      private static var instance:PaperLogger;
       
      
      public var traceLogger:PaperTraceLogger;
      
      public function PaperLogger()
      {
         super();
         if(instance)
         {
            throw new Error("Don\'t call the PaperLogger constructor directly");
         }
         this.traceLogger = new PaperTraceLogger();
         this.registerLogger(this.traceLogger);
      }
      
      public static function log(param1:String, param2:Object = null, ... rest) : void
      {
         getInstance()._log(param1);
      }
      
      public static function warning(param1:String, param2:Object = null, ... rest) : void
      {
         getInstance()._warning(param1);
      }
      
      public static function info(param1:String, param2:Object = null, ... rest) : void
      {
         getInstance()._info(param1);
      }
      
      public static function error(param1:String, param2:Object = null, ... rest) : void
      {
         getInstance()._error(param1);
      }
      
      public static function debug(param1:String, param2:Object = null, ... rest) : void
      {
         getInstance()._debug(param1);
      }
      
      public static function getInstance() : PaperLogger
      {
         if(!instance)
         {
            instance = new PaperLogger();
         }
         return instance;
      }
      
      public function _log(param1:String, param2:Object = null, ... rest) : void
      {
         var _loc4_:PaperLogVO = new PaperLogVO(LogLevel.LOG,param1,param2,rest);
         var _loc5_:PaperLoggerEvent = new PaperLoggerEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      public function _info(param1:String, param2:Object = null, ... rest) : void
      {
         var _loc4_:PaperLogVO = new PaperLogVO(LogLevel.INFO,param1,param2,rest);
         var _loc5_:PaperLoggerEvent = new PaperLoggerEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      public function _debug(param1:String, param2:Object = null, ... rest) : void
      {
         var _loc4_:PaperLogVO = new PaperLogVO(LogLevel.DEBUG,param1,param2,rest);
         var _loc5_:PaperLoggerEvent = new PaperLoggerEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      public function _error(param1:String, param2:Object = null, ... rest) : void
      {
         var _loc4_:PaperLogVO = new PaperLogVO(LogLevel.ERROR,param1,param2,rest);
         var _loc5_:PaperLoggerEvent = new PaperLoggerEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      public function _warning(param1:String, param2:Object = null, ... rest) : void
      {
         var _loc4_:PaperLogVO = new PaperLogVO(LogLevel.WARNING,param1,param2,rest);
         var _loc5_:PaperLoggerEvent = new PaperLoggerEvent(_loc4_);
         dispatchEvent(_loc5_);
      }
      
      public function registerLogger(param1:AbstractPaperLogger) : void
      {
         param1.registerWithPaperLogger(this);
      }
      
      public function unregisterLogger(param1:AbstractPaperLogger) : void
      {
         param1.unregisterFromPaperLogger(this);
      }
   }
}
