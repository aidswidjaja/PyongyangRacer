package org.papervision3d.cameras
{
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class SpringCamera3D extends Camera3D
   {
       
      
      public var _camTarget:DisplayObject3D;
      
      public var stiffness:Number = 1;
      
      public var damping:Number = 4;
      
      public var mass:Number = 40;
      
      public var positionOffset:Number3D;
      
      public var lookOffset:Number3D;
      
      private var _zrot:Number = 0;
      
      private var _velocity:Number3D;
      
      private var _dv:Number3D;
      
      private var _stretch:Number3D;
      
      private var _force:Number3D;
      
      private var _acceleration:Number3D;
      
      private var _desiredPosition:Number3D;
      
      private var _lookAtPosition:Number3D;
      
      private var _targetTransform:Matrix3D;
      
      private var _xPositionOffset:Number3D;
      
      private var _xLookOffset:Number3D;
      
      private var _xPosition:Number3D;
      
      private var _xLookAtObject:DisplayObject3D;
      
      public function SpringCamera3D(param1:Number = 60, param2:Number = 10, param3:Number = 5000, param4:Boolean = false, param5:Boolean = false)
      {
         this.positionOffset = new Number3D(0,5,-50);
         this.lookOffset = new Number3D(0,2,10);
         this._velocity = new Number3D();
         this._dv = new Number3D();
         this._stretch = new Number3D();
         this._force = new Number3D();
         this._acceleration = new Number3D();
         this._desiredPosition = new Number3D();
         this._lookAtPosition = new Number3D();
         this._targetTransform = new Matrix3D();
         this._xPositionOffset = new Number3D();
         this._xLookOffset = new Number3D();
         this._xPosition = new Number3D();
         this._xLookAtObject = new DisplayObject3D();
         super(param1,param2,param3,param4,param5);
      }
      
      override public function set target(param1:DisplayObject3D) : void
      {
         this._camTarget = param1;
      }
      
      override public function get target() : DisplayObject3D
      {
         return this._camTarget;
      }
      
      public function set zrot(param1:Number) : void
      {
         this._zrot = param1;
         if(this._zrot < 0.001)
         {
            param1 = 0;
         }
      }
      
      public function get zrot() : Number
      {
         return this._zrot;
      }
      
      override public function transformView(param1:Matrix3D = null) : void
      {
         if(this._camTarget != null)
         {
            this._targetTransform.n31 = this._camTarget.transform.n31;
            this._targetTransform.n32 = this._camTarget.transform.n32;
            this._targetTransform.n33 = this._camTarget.transform.n33;
            this._targetTransform.n21 = this._camTarget.transform.n21;
            this._targetTransform.n22 = this._camTarget.transform.n22;
            this._targetTransform.n23 = this._camTarget.transform.n23;
            this._targetTransform.n11 = this._camTarget.transform.n11;
            this._targetTransform.n12 = this._camTarget.transform.n12;
            this._targetTransform.n13 = this._camTarget.transform.n13;
            this._xPositionOffset.x = this.positionOffset.x;
            this._xPositionOffset.y = this.positionOffset.y;
            this._xPositionOffset.z = this.positionOffset.z;
            Matrix3D.multiplyVector(this._targetTransform,this._xPositionOffset);
            this._xLookOffset.x = this.lookOffset.x;
            this._xLookOffset.y = this.lookOffset.y;
            this._xLookOffset.z = this.lookOffset.z;
            Matrix3D.multiplyVector(this._targetTransform,this._xLookOffset);
            this._desiredPosition.x = this._camTarget.x + this._xPositionOffset.x;
            this._desiredPosition.y = this._camTarget.y + this._xPositionOffset.y;
            this._desiredPosition.z = this._camTarget.z + this._xPositionOffset.z;
            this._lookAtPosition.x = this._camTarget.x + this._xLookOffset.x;
            this._lookAtPosition.y = this._camTarget.y + this._xLookOffset.y;
            this._lookAtPosition.z = this._camTarget.z + this._xLookOffset.z;
            this._stretch.x = (x - this._desiredPosition.x) * -this.stiffness;
            this._stretch.y = (y - this._desiredPosition.y) * -this.stiffness;
            this._stretch.z = (z - this._desiredPosition.z) * -this.stiffness;
            this._dv.x = this._velocity.x * this.damping;
            this._dv.y = this._velocity.y * this.damping;
            this._dv.z = this._velocity.z * this.damping;
            this._force.x = this._stretch.x - this._dv.x;
            this._force.y = this._stretch.y - this._dv.y;
            this._force.z = this._stretch.z - this._dv.z;
            this._acceleration.x = this._force.x * (1 / this.mass);
            this._acceleration.y = this._force.y * (1 / this.mass);
            this._acceleration.z = this._force.z * (1 / this.mass);
            this._velocity.plusEq(this._acceleration);
            this._xPosition.x = x + this._velocity.x;
            this._xPosition.y = y + this._velocity.y;
            this._xPosition.z = z + this._velocity.z;
            x = this._xPosition.x;
            y = this._xPosition.y;
            z = this._xPosition.z;
            this._xLookAtObject.x = this._lookAtPosition.x;
            this._xLookAtObject.y = this._lookAtPosition.y;
            this._xLookAtObject.z = this._lookAtPosition.z;
            lookAt(this._xLookAtObject);
            if(Math.abs(this._zrot) > 0)
            {
               this.rotationZ = this._zrot;
            }
         }
         super.transformView(param1);
      }
   }
}
