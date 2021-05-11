package org.papervision3d.events
{
   import flash.events.Event;
   
   public class FileLoadEvent extends Event
   {
      
      public static const LOAD_COMPLETE:String = "loadComplete";
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const SECURITY_LOAD_ERROR:String = "securityLoadError";
      
      public static const COLLADA_MATERIALS_DONE:String = "colladaMaterialsDone";
      
      public static const LOAD_PROGRESS:String = "loadProgress";
      
      public static const ANIMATIONS_COMPLETE:String = "animationsComplete";
      
      public static const ANIMATIONS_PROGRESS:String = "animationsProgress";
       
      
      public var file:String = "";
      
      public var bytesLoaded:Number = -1;
      
      public var bytesTotal:Number = -1;
      
      public var message:String = "";
      
      public var dataObj:Object = null;
      
      public function FileLoadEvent(param1:String, param2:String = "", param3:Number = -1, param4:Number = -1, param5:String = "", param6:Object = null, param7:Boolean = false, param8:Boolean = false)
      {
         super(param1,param7,param8);
         this.file = param2;
         this.bytesLoaded = param3;
         this.bytesTotal = param4;
         this.message = param5;
         this.dataObj = param6;
      }
      
      override public function clone() : Event
      {
         return new FileLoadEvent(type,this.file,this.bytesLoaded,this.bytesTotal,this.message,this.dataObj,bubbles,cancelable);
      }
   }
}
