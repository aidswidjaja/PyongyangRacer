package org.papervision3d.core.log
{
   public interface IPaperLogger
   {
       
      
      function log(param1:String, param2:Object = null, param3:Array = null) : void;
      
      function info(param1:String, param2:Object = null, param3:Array = null) : void;
      
      function debug(param1:String, param2:Object = null, param3:Array = null) : void;
      
      function warning(param1:String, param2:Object = null, param3:Array = null) : void;
      
      function error(param1:String, param2:Object = null, param3:Array = null) : void;
      
      function fatal(param1:String, param2:Object = null, param3:Array = null) : void;
   }
}
