package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.AxisAlignedBoundingBox;
   import org.papervision3d.core.math.BoundingSphere;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class FrustumCuller implements IObjectCuller
   {
      
      public static const INSIDE:int = 1;
      
      public static const OUTSIDE:int = -1;
      
      public static const INTERSECT:int = 0;
       
      
      public var transform:Matrix3D;
      
      private var _fov:Number;
      
      private var _far:Number;
      
      private var _near:Number;
      
      private var _nw:Number;
      
      private var _nh:Number;
      
      private var _fw:Number;
      
      private var _fh:Number;
      
      private var _tang:Number;
      
      private var _ratio:Number;
      
      private var _sphereX:Number;
      
      private var _sphereY:Number;
      
      public function FrustumCuller()
      {
         super();
         this.transform = Matrix3D.IDENTITY;
         this.initialize();
      }
      
      public function initialize(param1:Number = 60, param2:Number = 1.333, param3:Number = 1, param4:Number = 5000) : void
      {
         this._fov = param1;
         this._ratio = param2;
         this._near = param3;
         this._far = param4;
         var _loc5_:Number = Math.PI / 180 * this._fov * 0.5;
         this._tang = Math.tan(_loc5_);
         this._nh = this._near * this._tang;
         this._nw = this._nh * this._ratio;
         this._fh = this._far * this._tang;
         this._fw = this._fh * this._ratio;
         var _loc6_:Number = Math.atan(this._tang * this._ratio);
         this._sphereX = 1 / Math.cos(_loc6_);
         this._sphereY = 1 / Math.cos(_loc5_);
      }
      
      public function aabbInFrustum(param1:DisplayObject3D, param2:AxisAlignedBoundingBox, param3:Boolean = true) : int
      {
         var _loc4_:Vertex3D = null;
         var _loc5_:Number3D = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = param2.getBoxVertices();
         for each(_loc4_ in _loc8_)
         {
            _loc5_ = _loc4_.toNumber3D();
            Matrix3D.multiplyVector(param1.world,_loc5_);
            if(this.pointInFrustum(_loc5_.x,_loc5_.y,_loc5_.z) == INSIDE)
            {
               _loc6_++;
               if(param3)
               {
                  return INSIDE;
               }
            }
            else
            {
               _loc7_++;
            }
            if(_loc6_ && _loc7_)
            {
               return INTERSECT;
            }
         }
         if(_loc6_)
         {
            return _loc6_ < 8 ? int(INTERSECT) : int(INSIDE);
         }
         return OUTSIDE;
      }
      
      public function pointInFrustum(param1:Number, param2:Number, param3:Number) : int
      {
         var _loc4_:Matrix3D = this.transform;
         var _loc5_:Number = param1 - _loc4_.n14;
         var _loc6_:Number = param2 - _loc4_.n24;
         var _loc7_:Number = param3 - _loc4_.n34;
         var _loc8_:Number;
         if((_loc8_ = _loc5_ * _loc4_.n13 + _loc6_ * _loc4_.n23 + _loc7_ * _loc4_.n33) > this._far || _loc8_ < this._near)
         {
            return OUTSIDE;
         }
         var _loc9_:Number = _loc5_ * _loc4_.n12 + _loc6_ * _loc4_.n22 + _loc7_ * _loc4_.n32;
         var _loc10_:Number = _loc8_ * this._tang;
         if(_loc9_ > _loc10_ || _loc9_ < -_loc10_)
         {
            return OUTSIDE;
         }
         var _loc11_:Number = _loc5_ * _loc4_.n11 + _loc6_ * _loc4_.n21 + _loc7_ * _loc4_.n31;
         _loc10_ *= this._ratio;
         if(_loc11_ > _loc10_ || _loc11_ < -_loc10_)
         {
            return OUTSIDE;
         }
         return INSIDE;
      }
      
      public function sphereInFrustum(param1:DisplayObject3D, param2:BoundingSphere) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = param2.radius * Math.max(param1.scaleX,Math.max(param1.scaleY,param1.scaleZ));
         var _loc8_:int = INSIDE;
         var _loc9_:Matrix3D = this.transform;
         var _loc10_:Number = param1.world.n14 - _loc9_.n14;
         var _loc11_:Number = param1.world.n24 - _loc9_.n24;
         var _loc12_:Number = param1.world.n34 - _loc9_.n34;
         if((_loc7_ = _loc10_ * _loc9_.n13 + _loc11_ * _loc9_.n23 + _loc12_ * _loc9_.n33) < this._near - _loc3_)
         {
            return OUTSIDE;
         }
         if(_loc7_ > this._far - _loc3_ || _loc7_ < this._near + _loc3_)
         {
            _loc8_ = INTERSECT;
         }
         _loc6_ = _loc10_ * _loc9_.n12 + _loc11_ * _loc9_.n22 + _loc12_ * _loc9_.n32;
         _loc4_ = this._sphereY * _loc3_;
         _loc7_ *= this._tang;
         if(_loc6_ > _loc7_ + _loc4_ || _loc6_ < -_loc7_ - _loc4_)
         {
            return OUTSIDE;
         }
         if(_loc6_ > _loc7_ - _loc4_ || _loc6_ < -_loc7_ + _loc4_)
         {
            _loc8_ = INTERSECT;
         }
         _loc5_ = _loc10_ * _loc9_.n11 + _loc11_ * _loc9_.n21 + _loc12_ * _loc9_.n31;
         _loc7_ *= this._ratio;
         _loc4_ = this._sphereX * _loc3_;
         if(_loc5_ > _loc7_ + _loc4_ || _loc5_ < -_loc7_ - _loc4_)
         {
            return OUTSIDE;
         }
         if(_loc5_ > _loc7_ - _loc4_ || _loc5_ < -_loc7_ + _loc4_)
         {
            _loc8_ = INTERSECT;
         }
         return _loc8_;
      }
      
      public function testObject(param1:DisplayObject3D) : int
      {
         var _loc2_:int = INSIDE;
         if(!param1.geometry || !param1.geometry.vertices || !param1.geometry.vertices.length)
         {
            return _loc2_;
         }
         switch(param1.frustumTestMethod)
         {
            case FrustumTestMethod.BOUNDING_SPHERE:
               _loc2_ = this.sphereInFrustum(param1,param1.geometry.boundingSphere);
               break;
            case FrustumTestMethod.BOUNDING_BOX:
               _loc2_ = this.aabbInFrustum(param1,param1.geometry.aabb);
               break;
            case FrustumTestMethod.NO_TESTING:
         }
         return _loc2_;
      }
      
      public function set far(param1:Number) : void
      {
         this.initialize(this._fov,this._ratio,this._near,param1);
      }
      
      public function get far() : Number
      {
         return this._far;
      }
      
      public function set fov(param1:Number) : void
      {
         this.initialize(param1,this._ratio,this._near,this._far);
      }
      
      public function get fov() : Number
      {
         return this._fov;
      }
      
      public function set near(param1:Number) : void
      {
         this.initialize(this._fov,this._ratio,param1,this._far);
      }
      
      public function get near() : Number
      {
         return this._near;
      }
      
      public function set ratio(param1:Number) : void
      {
         this.initialize(this._fov,param1,this._near,this._far);
      }
      
      public function get ratio() : Number
      {
         return this._ratio;
      }
   }
}
