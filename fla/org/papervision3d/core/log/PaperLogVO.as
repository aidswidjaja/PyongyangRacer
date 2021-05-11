package org.papervision3d.core.log
{
   public class PaperLogVO
   {
       
      
      public var level:int;
      
      public var msg:String;
      
      public var object:Object;
      
      public var arg:Array;
      
      public function PaperLogVO(param1:int, param2:String, param3:Object, param4:Array)
      {
         super();
         this.level = param1;
         this.msg = param2;
         this.object = param3;
         this.arg = param4;
      }
   }
}
