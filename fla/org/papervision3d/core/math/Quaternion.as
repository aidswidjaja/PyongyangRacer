package org.papervision3d.core.math
{
   public class Quaternion
   {
      
      public static const EPSILON:Number = 0.000001;
      
      public static const DEGTORAD:Number = Math.PI / 180;
      
      public static const RADTODEG:Number = 180 / Math.PI;
       
      
      private var _matrix:Matrix3D;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var w:Number;
      
      public function Quaternion(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.w = param4;
         this._matrix = Matrix3D.IDENTITY;
      }
      
      public static function conjugate(param1:Quaternion) : Quaternion
      {
         var _loc2_:Quaternion = new Quaternion();
         _loc2_.x = -param1.x;
         _loc2_.y = -param1.y;
         _loc2_.z = -param1.z;
         _loc2_.w = param1.w;
         return _loc2_;
      }
      
      public static function createFromAxisAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Quaternion
      {
         var _loc5_:Quaternion;
         (_loc5_ = new Quaternion()).setFromAxisAngle(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public static function createFromEuler(param1:Number, param2:Number, param3:Number, param4:Boolean = false) : Quaternion
      {
         if(param4)
         {
            param1 *= DEGTORAD;
            param2 *= DEGTORAD;
            param3 *= DEGTORAD;
         }
         var _loc5_:Number = Math.sin(param1 * 0.5);
         var _loc6_:Number = Math.cos(param1 * 0.5);
         var _loc7_:Number = Math.sin(param2 * 0.5);
         var _loc8_:Number = Math.cos(param2 * 0.5);
         var _loc9_:Number = Math.sin(param3 * 0.5);
         var _loc10_:Number = Math.cos(param3 * 0.5);
         var _loc11_:Number = _loc6_ * _loc8_;
         var _loc12_:Number = _loc5_ * _loc7_;
         var _loc13_:Quaternion;
         (_loc13_ = new Quaternion()).x = _loc9_ * _loc11_ - _loc10_ * _loc12_;
         _loc13_.y = _loc10_ * _loc5_ * _loc8_ + _loc9_ * _loc6_ * _loc7_;
         _loc13_.z = _loc10_ * _loc6_ * _loc7_ - _loc9_ * _loc5_ * _loc8_;
         _loc13_.w = _loc10_ * _loc11_ + _loc9_ * _loc12_;
         return _loc13_;
      }
      
      public static function createFromMatrix(param1:Matrix3D) : Quaternion
      {
         var _loc3_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc2_:Quaternion = new Quaternion();
         var _loc4_:Array = new Array(4);
         var _loc8_:Number;
         if((_loc8_ = param1.n11 + param1.n22 + param1.n33) > 0)
         {
            _loc3_ = Math.sqrt(_loc8_ + 1);
            _loc2_.w = _loc3_ / 2;
            _loc3_ = 0.5 / _loc3_;
            _loc2_.x = (param1.n32 - param1.n23) * _loc3_;
            _loc2_.y = (param1.n13 - param1.n31) * _loc3_;
            _loc2_.z = (param1.n21 - param1.n12) * _loc3_;
         }
         else
         {
            _loc9_ = [1,2,0];
            _loc10_ = [[param1.n11,param1.n12,param1.n13,param1.n14],[param1.n21,param1.n22,param1.n23,param1.n24],[param1.n31,param1.n32,param1.n33,param1.n34]];
            _loc5_ = 0;
            if(_loc10_[1][1] > _loc10_[0][0])
            {
               _loc5_ = 1;
            }
            if(_loc10_[2][2] > _loc10_[_loc5_][_loc5_])
            {
               _loc5_ = 2;
            }
            _loc6_ = _loc9_[_loc5_];
            _loc7_ = _loc9_[_loc6_];
            _loc3_ = Math.sqrt(_loc10_[_loc5_][_loc5_] - (_loc10_[_loc6_][_loc6_] + _loc10_[_loc7_][_loc7_]) + 1);
            _loc4_[_loc5_] = _loc3_ * 0.5;
            if(_loc3_ != 0)
            {
               _loc3_ = 0.5 / _loc3_;
            }
            _loc4_[3] = (_loc10_[_loc7_][_loc6_] - _loc10_[_loc6_][_loc7_]) * _loc3_;
            _loc4_[_loc6_] = (_loc10_[_loc6_][_loc5_] + _loc10_[_loc5_][_loc6_]) * _loc3_;
            _loc4_[_loc7_] = (_loc10_[_loc7_][_loc5_] + _loc10_[_loc5_][_loc7_]) * _loc3_;
            _loc2_.x = _loc4_[0];
            _loc2_.y = _loc4_[1];
            _loc2_.z = _loc4_[2];
            _loc2_.w = _loc4_[3];
         }
         return _loc2_;
      }
      
      public static function createFromOrthoMatrix(param1:Matrix3D) : Quaternion
      {
         var _loc2_:Quaternion = new Quaternion();
         _loc2_.w = Math.sqrt(Math.max(0,1 + param1.n11 + param1.n22 + param1.n33)) / 2;
         _loc2_.x = Math.sqrt(Math.max(0,1 + param1.n11 - param1.n22 - param1.n33)) / 2;
         _loc2_.y = Math.sqrt(Math.max(0,1 - param1.n11 + param1.n22 - param1.n33)) / 2;
         _loc2_.z = Math.sqrt(Math.max(0,1 - param1.n11 - param1.n22 + param1.n33)) / 2;
         _loc2_.x = param1.n32 - param1.n23 < 0 ? (_loc2_.x < 0 ? Number(_loc2_.x) : Number(-_loc2_.x)) : (_loc2_.x < 0 ? Number(-_loc2_.x) : Number(_loc2_.x));
         _loc2_.y = param1.n13 - param1.n31 < 0 ? (_loc2_.y < 0 ? Number(_loc2_.y) : Number(-_loc2_.y)) : (_loc2_.y < 0 ? Number(-_loc2_.y) : Number(_loc2_.y));
         _loc2_.z = param1.n21 - param1.n12 < 0 ? (_loc2_.z < 0 ? Number(_loc2_.z) : Number(-_loc2_.z)) : (_loc2_.z < 0 ? Number(-_loc2_.z) : Number(_loc2_.z));
         return _loc2_;
      }
      
      public static function dot(param1:Quaternion, param2:Quaternion) : Number
      {
         return param1.x * param2.x + param1.y * param2.y + param1.z * param2.z + param1.w * param2.w;
      }
      
      public static function multiply(param1:Quaternion, param2:Quaternion) : Quaternion
      {
         var _loc3_:Quaternion = new Quaternion();
         _loc3_.x = param1.w * param2.x + param1.x * param2.w + param1.y * param2.z - param1.z * param2.y;
         _loc3_.y = param1.w * param2.y - param1.x * param2.z + param1.y * param2.w + param1.z * param2.x;
         _loc3_.z = param1.w * param2.z + param1.x * param2.y - param1.y * param2.x + param1.z * param2.w;
         _loc3_.w = param1.w * param2.w - param1.x * param2.x - param1.y * param2.y - param1.z * param2.z;
         return _loc3_;
      }
      
      public static function slerp(param1:Quaternion, param2:Quaternion, param3:Number) : Quaternion
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc4_:Number;
         if((_loc4_ = param1.w * param2.w + param1.x * param2.x + param1.y * param2.y + param1.z * param2.z) < 0)
         {
            param1.x *= -1;
            param1.y *= -1;
            param1.z *= -1;
            param1.w *= -1;
            _loc4_ *= -1;
         }
         if(_loc4_ + 1 > EPSILON)
         {
            if(1 - _loc4_ >= EPSILON)
            {
               _loc7_ = Math.acos(_loc4_);
               _loc8_ = 1 / Math.sin(_loc7_);
               _loc5_ = Math.sin(_loc7_ * (1 - param3)) * _loc8_;
               _loc6_ = Math.sin(_loc7_ * param3) * _loc8_;
            }
            else
            {
               _loc5_ = 1 - param3;
               _loc6_ = param3;
            }
         }
         else
         {
            param2.y = -param1.y;
            param2.x = param1.x;
            param2.w = -param1.w;
            param2.z = param1.z;
            _loc5_ = Math.sin(Math.PI * (0.5 - param3));
            _loc6_ = Math.sin(Math.PI * param3);
         }
         return new Quaternion(_loc5_ * param1.x + _loc6_ * param2.x,_loc5_ * param1.y + _loc6_ * param2.y,_loc5_ * param1.z + _loc6_ * param2.z,_loc5_ * param1.w + _loc6_ * param2.w);
      }
      
      public static function slerpOld(param1:Quaternion, param2:Quaternion, param3:Number) : Quaternion
      {
         var _loc4_:Quaternion = new Quaternion();
         var _loc5_:Number = param1.w * param2.w + param1.x * param2.x + param1.y * param2.y + param1.z * param2.z;
         if(Math.abs(_loc5_) >= 1)
         {
            _loc4_.w = param1.w;
            _loc4_.x = param1.x;
            _loc4_.y = param1.y;
            _loc4_.z = param1.z;
            return _loc4_;
         }
         var _loc6_:Number = Math.acos(_loc5_);
         var _loc7_:Number = Math.sqrt(1 - _loc5_ * _loc5_);
         if(Math.abs(_loc7_) < 0.001)
         {
            _loc4_.w = param1.w * 0.5 + param2.w * 0.5;
            _loc4_.x = param1.x * 0.5 + param2.x * 0.5;
            _loc4_.y = param1.y * 0.5 + param2.y * 0.5;
            _loc4_.z = param1.z * 0.5 + param2.z * 0.5;
            return _loc4_;
         }
         var _loc8_:Number = Math.sin((1 - param3) * _loc6_) / _loc7_;
         var _loc9_:Number = Math.sin(param3 * _loc6_) / _loc7_;
         _loc4_.w = param1.w * _loc8_ + param2.w * _loc9_;
         _loc4_.x = param1.x * _loc8_ + param2.x * _loc9_;
         _loc4_.y = param1.y * _loc8_ + param2.y * _loc9_;
         _loc4_.z = param1.z * _loc8_ + param2.z * _loc9_;
         return _loc4_;
      }
      
      public static function sub(param1:Quaternion, param2:Quaternion) : Quaternion
      {
         return new Quaternion(param1.x - param2.x,param1.y - param2.y,param1.z - param2.z,param1.w - param2.w);
      }
      
      public static function add(param1:Quaternion, param2:Quaternion) : Quaternion
      {
         return new Quaternion(param1.x + param2.x,param1.y + param2.y,param1.z + param2.z,param1.w + param2.w);
      }
      
      public function clone() : Quaternion
      {
         return new Quaternion(this.x,this.y,this.z,this.w);
      }
      
      public function calculateMultiply(param1:Quaternion, param2:Quaternion) : void
      {
         this.x = param1.w * param2.x + param1.x * param2.w + param1.y * param2.z - param1.z * param2.y;
         this.y = param1.w * param2.y - param1.x * param2.z + param1.y * param2.w + param1.z * param2.x;
         this.z = param1.w * param2.z + param1.x * param2.y - param1.y * param2.x + param1.z * param2.w;
         this.w = param1.w * param2.w - param1.x * param2.x - param1.y * param2.y - param1.z * param2.z;
      }
      
      public function setFromAxisAngle(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = Math.sin(param4 / 2);
         var _loc6_:Number = Math.cos(param4 / 2);
         this.x = param1 * _loc5_;
         this.y = param2 * _loc5_;
         this.z = param3 * _loc5_;
         this.w = _loc6_;
         this.normalize();
      }
      
      public function setFromEuler(param1:Number, param2:Number, param3:Number, param4:Boolean = false) : void
      {
         if(param4)
         {
            param1 *= DEGTORAD;
            param2 *= DEGTORAD;
            param3 *= DEGTORAD;
         }
         var _loc5_:Number = Math.sin(param1 * 0.5);
         var _loc6_:Number = Math.cos(param1 * 0.5);
         var _loc7_:Number = Math.sin(param2 * 0.5);
         var _loc8_:Number = Math.cos(param2 * 0.5);
         var _loc9_:Number = Math.sin(param3 * 0.5);
         var _loc10_:Number = Math.cos(param3 * 0.5);
         var _loc11_:Number = _loc6_ * _loc8_;
         var _loc12_:Number = _loc5_ * _loc7_;
         this.x = _loc9_ * _loc11_ - _loc10_ * _loc12_;
         this.y = _loc10_ * _loc5_ * _loc8_ + _loc9_ * _loc6_ * _loc7_;
         this.z = _loc10_ * _loc6_ * _loc7_ - _loc9_ * _loc5_ * _loc8_;
         this.w = _loc10_ * _loc11_ + _loc9_ * _loc12_;
      }
      
      public function get modulo() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
      }
      
      public function mult(param1:Quaternion) : void
      {
         var _loc2_:Number = this.w;
         var _loc3_:Number = this.x;
         var _loc4_:Number = this.y;
         var _loc5_:Number = this.z;
         this.x = _loc2_ * param1.x + _loc3_ * param1.w + _loc4_ * param1.z - _loc5_ * param1.y;
         this.y = _loc2_ * param1.y - _loc3_ * param1.z + _loc4_ * param1.w + _loc5_ * param1.x;
         this.z = _loc2_ * param1.z + _loc3_ * param1.y - _loc4_ * param1.x + _loc5_ * param1.w;
         this.w = _loc2_ * param1.w - _loc3_ * param1.x - _loc4_ * param1.y - _loc5_ * param1.z;
      }
      
      public function toString() : String
      {
         return "Quaternion: x:" + this.x + " y:" + this.y + " z:" + this.z + " w:" + this.w;
      }
      
      public function normalize() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = this.modulo;
         if(Math.abs(_loc1_) < EPSILON)
         {
            this.x = this.y = this.z = 0;
            this.w = 1;
         }
         else
         {
            _loc2_ = 1 / _loc1_;
            this.x *= _loc2_;
            this.y *= _loc2_;
            this.z *= _loc2_;
            this.w *= _loc2_;
         }
      }
      
      public function toEuler() : Number3D
      {
         var _loc1_:Number3D = new Number3D();
         var _loc2_:Quaternion = this;
         var _loc3_:Number = _loc2_.x * _loc2_.y + _loc2_.z * _loc2_.w;
         if(_loc3_ > 0.499)
         {
            _loc1_.x = 2 * Math.atan2(_loc2_.x,_loc2_.w);
            _loc1_.y = Math.PI / 2;
            _loc1_.z = 0;
            return _loc1_;
         }
         if(_loc3_ < -0.499)
         {
            _loc1_.x = -2 * Math.atan2(_loc2_.x,_loc2_.w);
            _loc1_.y = -Math.PI / 2;
            _loc1_.z = 0;
            return _loc1_;
         }
         var _loc4_:Number = _loc2_.x * _loc2_.x;
         var _loc5_:Number = _loc2_.y * _loc2_.y;
         var _loc6_:Number = _loc2_.z * _loc2_.z;
         _loc1_.x = Math.atan2(2 * _loc2_.y * _loc2_.w - 2 * _loc2_.x * _loc2_.z,1 - 2 * _loc5_ - 2 * _loc6_);
         _loc1_.y = Math.asin(2 * _loc3_);
         _loc1_.z = Math.atan2(2 * _loc2_.x * _loc2_.w - 2 * _loc2_.y * _loc2_.z,1 - 2 * _loc4_ - 2 * _loc6_);
         return _loc1_;
      }
      
      public function get matrix() : Matrix3D
      {
         var _loc1_:Number = this.x * this.x;
         var _loc2_:Number = this.x * this.y;
         var _loc3_:Number = this.x * this.z;
         var _loc4_:Number = this.x * this.w;
         var _loc5_:Number = this.y * this.y;
         var _loc6_:Number = this.y * this.z;
         var _loc7_:Number = this.y * this.w;
         var _loc8_:Number = this.z * this.z;
         var _loc9_:Number = this.z * this.w;
         this._matrix.n11 = 1 - 2 * (_loc5_ + _loc8_);
         this._matrix.n12 = 2 * (_loc2_ - _loc9_);
         this._matrix.n13 = 2 * (_loc3_ + _loc7_);
         this._matrix.n21 = 2 * (_loc2_ + _loc9_);
         this._matrix.n22 = 1 - 2 * (_loc1_ + _loc8_);
         this._matrix.n23 = 2 * (_loc6_ - _loc4_);
         this._matrix.n31 = 2 * (_loc3_ - _loc7_);
         this._matrix.n32 = 2 * (_loc6_ + _loc4_);
         this._matrix.n33 = 1 - 2 * (_loc1_ + _loc5_);
         return this._matrix;
      }
   }
}
