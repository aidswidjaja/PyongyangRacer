package org.papervision3d.core.math
{
   import org.papervision3d.Papervision3D;
   
   public class Matrix3D
   {
      
      private static var temp:Matrix3D = Matrix3D.IDENTITY;
      
      private static var n3Di:Number3D = Number3D.ZERO;
      
      private static var n3Dj:Number3D = Number3D.ZERO;
      
      private static var n3Dk:Number3D = Number3D.ZERO;
      
      private static var toDEGREES:Number = 180 / Math.PI;
      
      private static var toRADIANS:Number = Math.PI / 180;
      
      private static var _sin:Function = Math.sin;
      
      private static var _cos:Function = Math.cos;
       
      
      public var n11:Number;
      
      public var n12:Number;
      
      public var n13:Number;
      
      public var n14:Number;
      
      public var n21:Number;
      
      public var n22:Number;
      
      public var n23:Number;
      
      public var n24:Number;
      
      public var n31:Number;
      
      public var n32:Number;
      
      public var n33:Number;
      
      public var n34:Number;
      
      public var n41:Number;
      
      public var n42:Number;
      
      public var n43:Number;
      
      public var n44:Number;
      
      public function Matrix3D(param1:Array = null)
      {
         super();
         this.reset(param1);
      }
      
      public static function get IDENTITY() : Matrix3D
      {
         return new Matrix3D([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]);
      }
      
      public static function multiply(param1:Matrix3D, param2:Matrix3D) : Matrix3D
      {
         var _loc3_:Matrix3D = new Matrix3D();
         _loc3_.calculateMultiply(param1,param2);
         return _loc3_;
      }
      
      public static function multiply3x3(param1:Matrix3D, param2:Matrix3D) : Matrix3D
      {
         var _loc3_:Matrix3D = new Matrix3D();
         _loc3_.calculateMultiply3x3(param1,param2);
         return _loc3_;
      }
      
      public static function add(param1:Matrix3D, param2:Matrix3D) : Matrix3D
      {
         var _loc3_:Matrix3D = new Matrix3D();
         _loc3_.calculateAdd(param1,param2);
         return _loc3_;
      }
      
      public static function inverse(param1:Matrix3D) : Matrix3D
      {
         var _loc2_:Matrix3D = new Matrix3D();
         _loc2_.calculateInverse(param1);
         return _loc2_;
      }
      
      public static function clone(param1:Matrix3D) : Matrix3D
      {
         return new Matrix3D([param1.n11,param1.n12,param1.n13,param1.n14,param1.n21,param1.n22,param1.n23,param1.n24,param1.n31,param1.n32,param1.n33,param1.n34]);
      }
      
      public static function multiplyVector(param1:Matrix3D, param2:Number3D) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = param2.x;
         _loc4_ = param2.y;
         _loc5_ = param2.z;
         param2.x = _loc3_ * param1.n11 + _loc4_ * param1.n12 + _loc5_ * param1.n13 + param1.n14;
         param2.y = _loc3_ * param1.n21 + _loc4_ * param1.n22 + _loc5_ * param1.n23 + param1.n24;
         param2.z = _loc3_ * param1.n31 + _loc4_ * param1.n32 + _loc5_ * param1.n33 + param1.n34;
      }
      
      public static function multiplyVector3x3(param1:Matrix3D, param2:Number3D) : void
      {
         var _loc3_:Number = param2.x;
         var _loc4_:Number = param2.y;
         var _loc5_:Number = param2.z;
         param2.x = _loc3_ * param1.n11 + _loc4_ * param1.n12 + _loc5_ * param1.n13;
         param2.y = _loc3_ * param1.n21 + _loc4_ * param1.n22 + _loc5_ * param1.n23;
         param2.z = _loc3_ * param1.n31 + _loc4_ * param1.n32 + _loc5_ * param1.n33;
      }
      
      public static function multiplyVector4x4(param1:Matrix3D, param2:Number3D) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc3_ = param2.x;
         _loc4_ = param2.y;
         var _loc5_:Number = param2.z;
         _loc6_ = 1 / (_loc3_ * param1.n41 + _loc4_ * param1.n42 + _loc5_ * param1.n43 + param1.n44);
         param2.x = _loc3_ * param1.n11 + _loc4_ * param1.n12 + _loc5_ * param1.n13 + param1.n14;
         param2.y = _loc3_ * param1.n21 + _loc4_ * param1.n22 + _loc5_ * param1.n23 + param1.n24;
         param2.z = _loc3_ * param1.n31 + _loc4_ * param1.n32 + _loc5_ * param1.n33 + param1.n34;
         param2.x *= _loc6_;
         param2.y *= _loc6_;
         param2.z *= _loc6_;
      }
      
      public static function rotateAxis(param1:Matrix3D, param2:Number3D) : void
      {
         var _loc3_:Number = param2.x;
         var _loc4_:Number = param2.y;
         var _loc5_:Number = param2.z;
         param2.x = _loc3_ * param1.n11 + _loc4_ * param1.n12 + _loc5_ * param1.n13;
         param2.y = _loc3_ * param1.n21 + _loc4_ * param1.n22 + _loc5_ * param1.n23;
         param2.z = _loc3_ * param1.n31 + _loc4_ * param1.n32 + _loc5_ * param1.n33;
         param2.normalize();
      }
      
      public static function matrix2euler(param1:Matrix3D, param2:Number3D = null, param3:Number3D = null) : Number3D
      {
         param2 = param2 || new Number3D();
         var _loc4_:Number = param3 && param3.x == 1 ? Number(1) : Number(Math.sqrt(param1.n11 * param1.n11 + param1.n21 * param1.n21 + param1.n31 * param1.n31));
         var _loc5_:Number = param3 && param3.y == 1 ? Number(1) : Number(Math.sqrt(param1.n12 * param1.n12 + param1.n22 * param1.n22 + param1.n32 * param1.n32));
         var _loc6_:Number = param3 && param3.z == 1 ? Number(1) : Number(Math.sqrt(param1.n13 * param1.n13 + param1.n23 * param1.n23 + param1.n33 * param1.n33));
         var _loc7_:Number = param1.n11 / _loc4_;
         var _loc8_:Number = param1.n21 / _loc5_;
         var _loc9_:Number = param1.n31 / _loc6_;
         var _loc10_:Number = param1.n32 / _loc6_;
         var _loc11_:Number = param1.n33 / _loc6_;
         _loc9_ = (_loc9_ = Number(_loc9_ > 1 ? Number(1) : Number(_loc9_))) < -1 ? Number(-1) : Number(_loc9_);
         param2.y = Math.asin(-_loc9_);
         param2.z = Math.atan2(_loc8_,_loc7_);
         param2.x = Math.atan2(_loc10_,_loc11_);
         if(Papervision3D.useDEGREES)
         {
            param2.x *= toDEGREES;
            param2.y *= toDEGREES;
            param2.z *= toDEGREES;
         }
         return param2;
      }
      
      public static function euler2matrix(param1:Number3D) : Matrix3D
      {
         temp.reset();
         var _loc2_:Matrix3D = temp;
         _loc2_ = temp;
         var _loc3_:Number = param1.x * toRADIANS;
         var _loc4_:Number = param1.y * toRADIANS;
         var _loc5_:Number = param1.z * toRADIANS;
         var _loc6_:Number = Math.cos(_loc3_);
         var _loc7_:Number = Math.sin(_loc3_);
         var _loc8_:Number = Math.cos(_loc4_);
         var _loc9_:Number = Math.sin(_loc4_);
         var _loc10_:Number = Math.cos(_loc5_);
         var _loc11_:Number = Math.sin(_loc5_);
         var _loc12_:Number = _loc6_ * _loc9_;
         var _loc13_:Number = _loc7_ * _loc9_;
         _loc2_.n11 = _loc8_ * _loc10_;
         _loc2_.n12 = -_loc8_ * _loc11_;
         _loc2_.n13 = _loc9_;
         _loc2_.n21 = _loc13_ * _loc10_ + _loc6_ * _loc11_;
         _loc2_.n22 = -_loc13_ * _loc11_ + _loc6_ * _loc10_;
         _loc2_.n23 = -_loc7_ * _loc8_;
         _loc2_.n31 = -_loc12_ * _loc10_ + _loc7_ * _loc11_;
         _loc2_.n32 = _loc12_ * _loc11_ + _loc7_ * _loc10_;
         _loc2_.n33 = _loc6_ * _loc8_;
         return _loc2_;
      }
      
      public static function rotationX(param1:Number) : Matrix3D
      {
         var _loc2_:Matrix3D = IDENTITY;
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         _loc2_.n22 = _loc3_;
         _loc2_.n23 = -_loc4_;
         _loc2_.n32 = _loc4_;
         _loc2_.n33 = _loc3_;
         return _loc2_;
      }
      
      public static function rotationY(param1:Number) : Matrix3D
      {
         var _loc2_:Matrix3D = IDENTITY;
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         _loc2_.n11 = _loc3_;
         _loc2_.n13 = -_loc4_;
         _loc2_.n31 = _loc4_;
         _loc2_.n33 = _loc3_;
         return _loc2_;
      }
      
      public static function rotationZ(param1:Number) : Matrix3D
      {
         var _loc2_:Matrix3D = IDENTITY;
         var _loc3_:Number = Math.cos(param1);
         var _loc4_:Number = Math.sin(param1);
         _loc2_.n11 = _loc3_;
         _loc2_.n12 = -_loc4_;
         _loc2_.n21 = _loc4_;
         _loc2_.n22 = _loc3_;
         return _loc2_;
      }
      
      public static function rotationMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Matrix3D = null) : Matrix3D
      {
         var _loc6_:Matrix3D = null;
         if(!param5)
         {
            _loc6_ = IDENTITY;
         }
         else
         {
            _loc6_ = param5;
         }
         var _loc7_:Number = Math.cos(param4);
         var _loc8_:Number = Math.sin(param4);
         var _loc9_:Number = 1 - _loc7_;
         var _loc10_:Number = param1 * param2 * _loc9_;
         var _loc11_:Number = param2 * param3 * _loc9_;
         var _loc12_:Number = param1 * param3 * _loc9_;
         var _loc13_:Number = _loc8_ * param3;
         var _loc14_:Number = _loc8_ * param2;
         var _loc15_:Number = _loc8_ * param1;
         _loc6_.n11 = _loc7_ + param1 * param1 * _loc9_;
         _loc6_.n12 = -_loc13_ + _loc10_;
         _loc6_.n13 = _loc14_ + _loc12_;
         _loc6_.n14 = 0;
         _loc6_.n21 = _loc13_ + _loc10_;
         _loc6_.n22 = _loc7_ + param2 * param2 * _loc9_;
         _loc6_.n23 = -_loc15_ + _loc11_;
         _loc6_.n24 = 0;
         _loc6_.n31 = -_loc14_ + _loc12_;
         _loc6_.n32 = _loc15_ + _loc11_;
         _loc6_.n33 = _loc7_ + param3 * param3 * _loc9_;
         _loc6_.n34 = 0;
         return _loc6_;
      }
      
      public static function rotationMatrixWithReference(param1:Number3D, param2:Number, param3:Number3D) : Matrix3D
      {
         var _loc4_:Matrix3D = Matrix3D.translationMatrix(param3.x,-param3.y,param3.z);
         _loc4_.calculateMultiply(_loc4_,Matrix3D.rotationMatrix(param1.x,param1.y,param1.z,param2));
         _loc4_.calculateMultiply(_loc4_,Matrix3D.translationMatrix(-param3.x,param3.y,-param3.z));
         return _loc4_;
      }
      
      public static function translationMatrix(param1:Number, param2:Number, param3:Number) : Matrix3D
      {
         var _loc4_:Matrix3D;
         (_loc4_ = IDENTITY).n14 = param1;
         _loc4_.n24 = param2;
         _loc4_.n34 = param3;
         return _loc4_;
      }
      
      public static function scaleMatrix(param1:Number, param2:Number, param3:Number) : Matrix3D
      {
         var _loc4_:Matrix3D;
         (_loc4_ = IDENTITY).n11 = param1;
         _loc4_.n22 = param2;
         _loc4_.n33 = param3;
         return _loc4_;
      }
      
      public static function magnitudeQuaternion(param1:Object) : Number
      {
         return Math.sqrt(param1.w * param1.w + param1.x * param1.x + param1.y * param1.y + param1.z * param1.z);
      }
      
      public static function normalizeQuaternion(param1:Object) : Object
      {
         var _loc2_:Number = magnitudeQuaternion(param1);
         param1.x /= _loc2_;
         param1.y /= _loc2_;
         param1.z /= _loc2_;
         param1.w /= _loc2_;
         return param1;
      }
      
      public static function axis2quaternion(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc5_:Number = Math.sin(param4 / 2);
         var _loc6_:Number = Math.cos(param4 / 2);
         var _loc7_:Object;
         (_loc7_ = new Object()).x = param1 * _loc5_;
         _loc7_.y = param2 * _loc5_;
         _loc7_.z = param3 * _loc5_;
         _loc7_.w = _loc6_;
         return normalizeQuaternion(_loc7_);
      }
      
      public static function euler2quaternion(param1:Number, param2:Number, param3:Number, param4:Quaternion = null) : Quaternion
      {
         var _loc13_:Quaternion = null;
         var _loc5_:Number = Math.sin(param1 * 0.5);
         var _loc6_:Number = Math.cos(param1 * 0.5);
         var _loc7_:Number = Math.sin(param2 * 0.5);
         var _loc8_:Number = Math.cos(param2 * 0.5);
         var _loc9_:Number = Math.sin(param3 * 0.5);
         var _loc10_:Number = Math.cos(param3 * 0.5);
         var _loc11_:Number = _loc6_ * _loc8_;
         var _loc12_:Number = _loc5_ * _loc7_;
         if(!param4)
         {
            _loc13_ = new Quaternion();
         }
         else
         {
            _loc13_ = param4;
         }
         _loc13_.x = _loc9_ * _loc11_ - _loc10_ * _loc12_;
         _loc13_.y = _loc10_ * _loc5_ * _loc8_ + _loc9_ * _loc6_ * _loc7_;
         _loc13_.z = _loc10_ * _loc6_ * _loc7_ - _loc9_ * _loc5_ * _loc8_;
         _loc13_.w = _loc10_ * _loc11_ + _loc9_ * _loc12_;
         return _loc13_;
      }
      
      public static function quaternion2matrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Matrix3D = null) : Matrix3D
      {
         var _loc15_:Matrix3D = null;
         var _loc6_:Number = param1 * param1;
         var _loc7_:Number = param1 * param2;
         var _loc8_:Number = param1 * param3;
         var _loc9_:Number = param1 * param4;
         var _loc10_:Number = param2 * param2;
         var _loc11_:Number = param2 * param3;
         var _loc12_:Number = param2 * param4;
         var _loc13_:Number = param3 * param3;
         var _loc14_:Number = param3 * param4;
         if(!param5)
         {
            _loc15_ = IDENTITY;
         }
         else
         {
            _loc15_ = param5;
         }
         _loc15_.n11 = 1 - 2 * (_loc10_ + _loc13_);
         _loc15_.n12 = 2 * (_loc7_ - _loc14_);
         _loc15_.n13 = 2 * (_loc8_ + _loc12_);
         _loc15_.n21 = 2 * (_loc7_ + _loc14_);
         _loc15_.n22 = 1 - 2 * (_loc6_ + _loc13_);
         _loc15_.n23 = 2 * (_loc11_ - _loc9_);
         _loc15_.n31 = 2 * (_loc8_ - _loc12_);
         _loc15_.n32 = 2 * (_loc11_ + _loc9_);
         _loc15_.n33 = 1 - 2 * (_loc6_ + _loc10_);
         return _loc15_;
      }
      
      public static function multiplyQuaternion(param1:Object, param2:Object) : Object
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = param1.z;
         var _loc6_:Number = param1.w;
         var _loc7_:Number = param2.x;
         var _loc8_:Number = param2.y;
         var _loc9_:Number = param2.z;
         var _loc10_:Number = param2.w;
         var _loc11_:Object;
         (_loc11_ = new Object()).x = _loc6_ * _loc7_ + _loc3_ * _loc10_ + _loc4_ * _loc9_ - _loc5_ * _loc8_;
         _loc11_.y = _loc6_ * _loc8_ + _loc4_ * _loc10_ + _loc5_ * _loc7_ - _loc3_ * _loc9_;
         _loc11_.z = _loc6_ * _loc9_ + _loc5_ * _loc10_ + _loc3_ * _loc8_ - _loc4_ * _loc7_;
         _loc11_.w = _loc6_ * _loc10_ - _loc3_ * _loc7_ - _loc4_ * _loc8_ - _loc5_ * _loc9_;
         return _loc11_;
      }
      
      public function reset(param1:Array = null) : void
      {
         if(!param1 || param1.length < 12)
         {
            this.n11 = this.n22 = this.n33 = this.n44 = 1;
            this.n12 = this.n13 = this.n14 = this.n21 = this.n23 = this.n24 = this.n31 = this.n32 = this.n34 = this.n41 = this.n42 = this.n43 = 0;
         }
         else
         {
            this.n11 = param1[0];
            this.n12 = param1[1];
            this.n13 = param1[2];
            this.n14 = param1[3];
            this.n21 = param1[4];
            this.n22 = param1[5];
            this.n23 = param1[6];
            this.n24 = param1[7];
            this.n31 = param1[8];
            this.n32 = param1[9];
            this.n33 = param1[10];
            this.n34 = param1[11];
            if(param1.length == 16)
            {
               this.n41 = param1[12];
               this.n42 = param1[13];
               this.n43 = param1[14];
               this.n44 = param1[15];
            }
            else
            {
               this.n41 = this.n42 = this.n43 = 0;
               this.n44 = 1;
            }
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += int(this.n11 * 1000) / 1000 + "\t\t" + int(this.n12 * 1000) / 1000 + "\t\t" + int(this.n13 * 1000) / 1000 + "\t\t" + int(this.n14 * 1000) / 1000 + "\n";
         _loc1_ += int(this.n21 * 1000) / 1000 + "\t\t" + int(this.n22 * 1000) / 1000 + "\t\t" + int(this.n23 * 1000) / 1000 + "\t\t" + int(this.n24 * 1000) / 1000 + "\n";
         _loc1_ += int(this.n31 * 1000) / 1000 + "\t\t" + int(this.n32 * 1000) / 1000 + "\t\t" + int(this.n33 * 1000) / 1000 + "\t\t" + int(this.n34 * 1000) / 1000 + "\n";
         return _loc1_ + (int(this.n41 * 1000) / 1000 + "\t\t" + int(this.n42 * 1000) / 1000 + "\t\t" + int(this.n43 * 1000) / 1000 + "\t\t" + int(this.n44 * 1000) / 1000 + "\n");
      }
      
      public function calculateMultiply(param1:Matrix3D, param2:Matrix3D) : void
      {
         var _loc3_:Number = param1.n11;
         var _loc4_:Number = param2.n11;
         var _loc5_:Number = param1.n21;
         var _loc6_:Number = param2.n21;
         var _loc7_:Number = param1.n31;
         var _loc8_:Number = param2.n31;
         var _loc9_:Number = param1.n12;
         var _loc10_:Number = param2.n12;
         var _loc11_:Number = param1.n22;
         var _loc12_:Number = param2.n22;
         var _loc13_:Number = param1.n32;
         var _loc14_:Number = param2.n32;
         var _loc15_:Number = param1.n13;
         var _loc16_:Number = param2.n13;
         var _loc17_:Number = param1.n23;
         var _loc18_:Number = param2.n23;
         var _loc19_:Number = param1.n33;
         var _loc20_:Number = param2.n33;
         var _loc21_:Number = param1.n14;
         var _loc22_:Number = param2.n14;
         var _loc23_:Number = param1.n24;
         var _loc24_:Number = param2.n24;
         var _loc25_:Number = param1.n34;
         var _loc26_:Number = param2.n34;
         this.n11 = _loc3_ * _loc4_ + _loc9_ * _loc6_ + _loc15_ * _loc8_;
         this.n12 = _loc3_ * _loc10_ + _loc9_ * _loc12_ + _loc15_ * _loc14_;
         this.n13 = _loc3_ * _loc16_ + _loc9_ * _loc18_ + _loc15_ * _loc20_;
         this.n14 = _loc3_ * _loc22_ + _loc9_ * _loc24_ + _loc15_ * _loc26_ + _loc21_;
         this.n21 = _loc5_ * _loc4_ + _loc11_ * _loc6_ + _loc17_ * _loc8_;
         this.n22 = _loc5_ * _loc10_ + _loc11_ * _loc12_ + _loc17_ * _loc14_;
         this.n23 = _loc5_ * _loc16_ + _loc11_ * _loc18_ + _loc17_ * _loc20_;
         this.n24 = _loc5_ * _loc22_ + _loc11_ * _loc24_ + _loc17_ * _loc26_ + _loc23_;
         this.n31 = _loc7_ * _loc4_ + _loc13_ * _loc6_ + _loc19_ * _loc8_;
         this.n32 = _loc7_ * _loc10_ + _loc13_ * _loc12_ + _loc19_ * _loc14_;
         this.n33 = _loc7_ * _loc16_ + _loc13_ * _loc18_ + _loc19_ * _loc20_;
         this.n34 = _loc7_ * _loc22_ + _loc13_ * _loc24_ + _loc19_ * _loc26_ + _loc25_;
      }
      
      public function calculateMultiply3x3(param1:Matrix3D, param2:Matrix3D) : void
      {
         var _loc3_:Number = param1.n11;
         var _loc4_:Number = param2.n11;
         var _loc5_:Number = param1.n21;
         var _loc6_:Number = param2.n21;
         var _loc7_:Number = param1.n31;
         var _loc8_:Number = param2.n31;
         var _loc9_:Number = param1.n12;
         var _loc10_:Number = param2.n12;
         var _loc11_:Number = param1.n22;
         var _loc12_:Number = param2.n22;
         var _loc13_:Number = param1.n32;
         var _loc14_:Number = param2.n32;
         var _loc15_:Number = param1.n13;
         var _loc16_:Number = param2.n13;
         var _loc17_:Number = param1.n23;
         var _loc18_:Number = param2.n23;
         var _loc19_:Number = param1.n33;
         var _loc20_:Number = param2.n33;
         this.n11 = _loc3_ * _loc4_ + _loc9_ * _loc6_ + _loc15_ * _loc8_;
         this.n12 = _loc3_ * _loc10_ + _loc9_ * _loc12_ + _loc15_ * _loc14_;
         this.n13 = _loc3_ * _loc16_ + _loc9_ * _loc18_ + _loc15_ * _loc20_;
         this.n21 = _loc5_ * _loc4_ + _loc11_ * _loc6_ + _loc17_ * _loc8_;
         this.n22 = _loc5_ * _loc10_ + _loc11_ * _loc12_ + _loc17_ * _loc14_;
         this.n23 = _loc5_ * _loc16_ + _loc11_ * _loc18_ + _loc17_ * _loc20_;
         this.n31 = _loc7_ * _loc4_ + _loc13_ * _loc6_ + _loc19_ * _loc8_;
         this.n32 = _loc7_ * _loc10_ + _loc13_ * _loc12_ + _loc19_ * _loc14_;
         this.n33 = _loc7_ * _loc16_ + _loc13_ * _loc18_ + _loc19_ * _loc20_;
      }
      
      public function calculateMultiply4x4(param1:Matrix3D, param2:Matrix3D) : void
      {
         var _loc3_:Number = param1.n11;
         var _loc4_:Number = param2.n11;
         var _loc5_:Number = param1.n21;
         var _loc6_:Number = param2.n21;
         var _loc7_:Number = param1.n31;
         var _loc8_:Number = param2.n31;
         var _loc9_:Number = param1.n41;
         var _loc10_:Number = param2.n41;
         var _loc11_:Number = param1.n12;
         var _loc12_:Number = param2.n12;
         var _loc13_:Number = param1.n22;
         var _loc14_:Number = param2.n22;
         var _loc15_:Number = param1.n32;
         var _loc16_:Number = param2.n32;
         var _loc17_:Number = param1.n42;
         var _loc18_:Number = param2.n42;
         var _loc19_:Number = param1.n13;
         var _loc20_:Number = param2.n13;
         var _loc21_:Number = param1.n23;
         var _loc22_:Number = param2.n23;
         var _loc23_:Number = param1.n33;
         var _loc24_:Number = param2.n33;
         var _loc25_:Number = param1.n43;
         var _loc26_:Number = param2.n43;
         var _loc27_:Number = param1.n14;
         var _loc28_:Number = param2.n14;
         var _loc29_:Number = param1.n24;
         var _loc30_:Number = param2.n24;
         var _loc31_:Number = param1.n34;
         var _loc32_:Number = param2.n34;
         var _loc33_:Number = param1.n44;
         var _loc34_:Number = param2.n44;
         this.n11 = _loc3_ * _loc4_ + _loc11_ * _loc6_ + _loc19_ * _loc8_;
         this.n12 = _loc3_ * _loc12_ + _loc11_ * _loc14_ + _loc19_ * _loc16_;
         this.n13 = _loc3_ * _loc20_ + _loc11_ * _loc22_ + _loc19_ * _loc24_;
         this.n14 = _loc3_ * _loc28_ + _loc11_ * _loc30_ + _loc19_ * _loc32_ + _loc27_;
         this.n21 = _loc5_ * _loc4_ + _loc13_ * _loc6_ + _loc21_ * _loc8_;
         this.n22 = _loc5_ * _loc12_ + _loc13_ * _loc14_ + _loc21_ * _loc16_;
         this.n23 = _loc5_ * _loc20_ + _loc13_ * _loc22_ + _loc21_ * _loc24_;
         this.n24 = _loc5_ * _loc28_ + _loc13_ * _loc30_ + _loc21_ * _loc32_ + _loc29_;
         this.n31 = _loc7_ * _loc4_ + _loc15_ * _loc6_ + _loc23_ * _loc8_;
         this.n32 = _loc7_ * _loc12_ + _loc15_ * _loc14_ + _loc23_ * _loc16_;
         this.n33 = _loc7_ * _loc20_ + _loc15_ * _loc22_ + _loc23_ * _loc24_;
         this.n34 = _loc7_ * _loc28_ + _loc15_ * _loc30_ + _loc23_ * _loc32_ + _loc31_;
         this.n41 = _loc9_ * _loc4_ + _loc17_ * _loc6_ + _loc25_ * _loc8_;
         this.n42 = _loc9_ * _loc12_ + _loc17_ * _loc14_ + _loc25_ * _loc16_;
         this.n43 = _loc9_ * _loc20_ + _loc17_ * _loc22_ + _loc25_ * _loc24_;
         this.n44 = _loc9_ * _loc28_ + _loc17_ * _loc30_ + _loc25_ * _loc32_ + _loc33_;
      }
      
      public function calculateSkewSymmetric(param1:Number3D) : void
      {
         this.n11 = 0;
         this.n12 = -param1.z;
         this.n13 = param1.y;
         this.n21 = param1.z;
         this.n22 = 0;
         this.n23 = -param1.x;
         this.n31 = -param1.y;
         this.n32 = param1.x;
         this.n33 = 0;
      }
      
      public function calculateAdd(param1:Matrix3D, param2:Matrix3D) : void
      {
         this.n11 = param1.n11 + param2.n11;
         this.n12 = param1.n12 + param2.n12;
         this.n13 = param1.n13 + param2.n13;
         this.n14 = param1.n14 + param2.n14;
         this.n21 = param1.n21 + param2.n21;
         this.n22 = param1.n22 + param2.n22;
         this.n23 = param1.n23 + param2.n23;
         this.n24 = param1.n24 + param2.n24;
         this.n31 = param1.n31 + param2.n31;
         this.n32 = param1.n32 + param2.n32;
         this.n33 = param1.n33 + param2.n33;
         this.n34 = param1.n34 + param2.n34;
      }
      
      public function calculateInverse(param1:Matrix3D) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc2_:Number = param1.det;
         if(Math.abs(_loc2_) > 0.001)
         {
            _loc2_ = 1 / _loc2_;
            _loc3_ = param1.n11;
            _loc4_ = param1.n21;
            _loc5_ = param1.n31;
            _loc6_ = param1.n12;
            _loc7_ = param1.n22;
            _loc8_ = param1.n32;
            _loc9_ = param1.n13;
            _loc10_ = param1.n23;
            _loc11_ = param1.n33;
            _loc12_ = param1.n14;
            _loc13_ = param1.n24;
            _loc14_ = param1.n34;
            this.n11 = _loc2_ * (_loc7_ * _loc11_ - _loc8_ * _loc10_);
            this.n12 = -_loc2_ * (_loc6_ * _loc11_ - _loc8_ * _loc9_);
            this.n13 = _loc2_ * (_loc6_ * _loc10_ - _loc7_ * _loc9_);
            this.n14 = -_loc2_ * (_loc6_ * (_loc10_ * _loc14_ - _loc11_ * _loc13_) - _loc7_ * (_loc9_ * _loc14_ - _loc11_ * _loc12_) + _loc8_ * (_loc9_ * _loc13_ - _loc10_ * _loc12_));
            this.n21 = -_loc2_ * (_loc4_ * _loc11_ - _loc5_ * _loc10_);
            this.n22 = _loc2_ * (_loc3_ * _loc11_ - _loc5_ * _loc9_);
            this.n23 = -_loc2_ * (_loc3_ * _loc10_ - _loc4_ * _loc9_);
            this.n24 = _loc2_ * (_loc3_ * (_loc10_ * _loc14_ - _loc11_ * _loc13_) - _loc4_ * (_loc9_ * _loc14_ - _loc11_ * _loc12_) + _loc5_ * (_loc9_ * _loc13_ - _loc10_ * _loc12_));
            this.n31 = _loc2_ * (_loc4_ * _loc8_ - _loc5_ * _loc7_);
            this.n32 = -_loc2_ * (_loc3_ * _loc8_ - _loc5_ * _loc6_);
            this.n33 = _loc2_ * (_loc3_ * _loc7_ - _loc4_ * _loc6_);
            this.n34 = -_loc2_ * (_loc3_ * (_loc7_ * _loc14_ - _loc8_ * _loc13_) - _loc4_ * (_loc6_ * _loc14_ - _loc8_ * _loc12_) + _loc5_ * (_loc6_ * _loc13_ - _loc7_ * _loc12_));
         }
      }
      
      public function calculateTranspose() : void
      {
         var _loc1_:Number = this.n11;
         var _loc2_:Number = this.n21;
         var _loc3_:Number = this.n31;
         var _loc4_:Number = this.n41;
         var _loc5_:Number = this.n12;
         var _loc6_:Number = this.n22;
         var _loc7_:Number = this.n32;
         var _loc8_:Number = this.n42;
         var _loc9_:Number = this.n13;
         var _loc10_:Number = this.n23;
         var _loc11_:Number = this.n33;
         var _loc12_:Number = this.n43;
         var _loc13_:Number = this.n14;
         var _loc14_:Number = this.n24;
         var _loc15_:Number = this.n34;
         var _loc16_:Number = this.n44;
         this.n11 = _loc1_;
         this.n12 = _loc2_;
         this.n13 = _loc3_;
         this.n14 = _loc4_;
         this.n21 = _loc5_;
         this.n22 = _loc6_;
         this.n23 = _loc7_;
         this.n24 = _loc8_;
         this.n31 = _loc9_;
         this.n32 = _loc10_;
         this.n33 = _loc11_;
         this.n34 = _loc12_;
         this.n41 = _loc13_;
         this.n42 = _loc14_;
         this.n43 = _loc15_;
         this.n44 = _loc16_;
      }
      
      public function invert() : void
      {
         temp.copy(this);
         this.calculateInverse(temp);
      }
      
      public function get det() : Number
      {
         return (this.n11 * this.n22 - this.n21 * this.n12) * this.n33 - (this.n11 * this.n32 - this.n31 * this.n12) * this.n23 + (this.n21 * this.n32 - this.n31 * this.n22) * this.n13;
      }
      
      public function copy(param1:Matrix3D) : Matrix3D
      {
         this.n11 = param1.n11;
         this.n12 = param1.n12;
         this.n13 = param1.n13;
         this.n14 = param1.n14;
         this.n21 = param1.n21;
         this.n22 = param1.n22;
         this.n23 = param1.n23;
         this.n24 = param1.n24;
         this.n31 = param1.n31;
         this.n32 = param1.n32;
         this.n33 = param1.n33;
         this.n34 = param1.n34;
         return this;
      }
      
      public function copy3x3(param1:Matrix3D) : Matrix3D
      {
         this.n11 = param1.n11;
         this.n12 = param1.n12;
         this.n13 = param1.n13;
         this.n21 = param1.n21;
         this.n22 = param1.n22;
         this.n23 = param1.n23;
         this.n31 = param1.n31;
         this.n32 = param1.n32;
         this.n33 = param1.n33;
         return this;
      }
   }
}
