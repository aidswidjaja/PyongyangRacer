package org.papervision3d.core.math
{
   public class NumberUV
   {
       
      
      public var u:Number;
      
      public var v:Number;
      
      public function NumberUV(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.u = param1;
         this.v = param2;
      }
      
      public static function get ZERO() : NumberUV
      {
         return new NumberUV(0,0);
      }
      
      public static function weighted(param1:NumberUV, param2:NumberUV, param3:Number, param4:Number) : NumberUV
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 == null)
         {
            return null;
         }
         var _loc5_:Number = param3 + param4;
         var _loc6_:Number = param3 / _loc5_;
         var _loc7_:Number = param4 / _loc5_;
         return new NumberUV(param1.u * _loc6_ + param2.u * _loc7_,param1.v * _loc6_ + param2.v * _loc7_);
      }
      
      public static function median(param1:NumberUV, param2:NumberUV) : NumberUV
      {
         if(param1 == null)
         {
            return null;
         }
         if(param2 == null)
         {
            return null;
         }
         return new NumberUV((param1.u + param2.u) / 2,(param1.v + param2.v) / 2);
      }
      
      public function clone() : NumberUV
      {
         return new NumberUV(this.u,this.v);
      }
      
      public function toString() : String
      {
         return "u:" + this.u + " v:" + this.v;
      }
   }
}
