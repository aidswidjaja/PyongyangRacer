package org.papervision3d.core.math
{
   import org.papervision3d.Papervision3D;
   
   public class Number2D
   {
      
      public static const RADTODEG:Number = 180 / Math.PI;
      
      public static const DEGTORAD:Number = Math.PI / 180;
       
      
      public var x:Number;
      
      public var y:Number;
      
      public function Number2D(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function add(param1:Number2D, param2:Number2D) : Number2D
      {
         return new Number2D(param1.x = param1.x + param2.x,param1.y + param2.y);
      }
      
      public static function subtract(param1:Number2D, param2:Number2D) : Number2D
      {
         return new Number2D(param1.x - param2.x,param1.y - param2.y);
      }
      
      public static function multiplyScalar(param1:Number2D, param2:Number) : Number2D
      {
         return new Number2D(param1.x * param2,param1.y * param2);
      }
      
      public static function dot(param1:Number2D, param2:Number2D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public function toString() : String
      {
         var _loc1_:Number = Math.round(this.x * 1000) / 1000;
         var _loc2_:Number = Math.round(this.y * 1000) / 1000;
         return "[" + _loc1_ + ", " + _loc2_ + "]";
      }
      
      public function clone() : Number2D
      {
         return new Number2D(this.x,this.y);
      }
      
      public function copyTo(param1:Number2D) : void
      {
         param1.x = this.x;
         param1.y = this.y;
      }
      
      public function copyFrom(param1:Number2D) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      public function normalise() : void
      {
         var _loc1_:Number = this.modulo;
         this.x /= _loc1_;
         this.y /= _loc1_;
      }
      
      public function reverse() : void
      {
         this.x = -this.x;
         this.y = -this.y;
      }
      
      public function plusEq(param1:Number2D) : void
      {
         this.x += param1.x;
         this.y += param1.y;
      }
      
      public function minusEq(param1:Number2D) : void
      {
         this.x -= param1.x;
         this.y -= param1.y;
      }
      
      public function divideEq(param1:Number) : void
      {
         this.x /= param1;
         this.y /= param1;
      }
      
      public function multiplyEq(param1:Number) : void
      {
         this.x *= param1;
         this.y *= param1;
      }
      
      public function angle() : Number
      {
         if(Papervision3D.useDEGREES)
         {
            return RADTODEG * Math.atan2(this.y,this.x);
         }
         return Math.atan2(this.y,this.x);
      }
      
      public function rotate(param1:Number) : void
      {
         var _loc4_:Number2D = null;
         if(Papervision3D.useDEGREES)
         {
            param1 *= DEGTORAD;
         }
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         _loc4_ = this.clone();
         this.x = _loc4_.x * _loc2_ - _loc4_.y * _loc3_;
         this.y = _loc4_.x * _loc3_ + _loc4_.y * _loc2_;
      }
      
      public function reset(param1:Number = 0, param2:Number = 0) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function isModuloLessThan(param1:Number) : Boolean
      {
         return this.moduloSquared < param1 * param1;
      }
      
      public function isModuloGreaterThan(param1:Number) : Boolean
      {
         return this.moduloSquared > param1 * param1;
      }
      
      public function isModuloEqualTo(param1:Number) : Boolean
      {
         return this.moduloSquared == param1 * param1;
      }
      
      public function get moduloSquared() : Number
      {
         return this.x * this.x + this.y * this.y;
      }
   }
}
