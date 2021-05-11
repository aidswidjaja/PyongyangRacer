package resourcemgr
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RResourceCar
   {
       
      
      public var m_CarNum:int;
      
      public var m_CarProperty:Array;
      
      public function RResourceCar()
      {
         super();
         this.m_CarProperty = new Array();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadCarProperty(param1);
      }
      
      protected function ReadCarProperty(param1:ByteArray) : void
      {
         var _loc3_:Object = null;
         this.m_CarNum = param1.readInt();
         var _loc2_:int = 0;
         while(_loc2_ < this.m_CarNum)
         {
            _loc3_ = {
               "accel":param1.readFloat(),
               "mass":param1.readFloat(),
               "rollfric":param1.readFloat(),
               "dragfric":param1.readFloat(),
               "steer":param1.readFloat(),
               "rfact":param1.readFloat(),
               "maxvel":param1.readFloat(),
               "minvel":param1.readFloat(),
               "maxhandle":param1.readFloat(),
               "centfact":param1.readFloat(),
               "turnfact":param1.readFloat()
            };
            this.m_CarProperty.push(_loc3_);
            _loc2_++;
         }
      }
   }
}
