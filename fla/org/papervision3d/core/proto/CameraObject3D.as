package org.papervision3d.core.proto
{
   import flash.geom.Rectangle;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.culling.IObjectCuller;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CameraObject3D extends DisplayObject3D
   {
      
      public static var DEFAULT_POS:Number3D = new Number3D(0,0,-1000);
      
      public static var DEFAULT_UP:Number3D = new Number3D(0,1,0);
      
      public static var DEFAULT_VIEWPORT:Rectangle = new Rectangle(0,0,550,400);
      
      private static var _flipY:Matrix3D = Matrix3D.scaleMatrix(1,-1,1);
       
      
      public var zoom:Number;
      
      public var focus:Number;
      
      public var sort:Boolean;
      
      public var eye:Matrix3D;
      
      public var viewport:Rectangle;
      
      public var culler:IObjectCuller;
      
      public var yUP:Boolean;
      
      protected var _useCulling:Boolean;
      
      protected var _useProjectionMatrix:Boolean;
      
      protected var _ortho:Boolean;
      
      protected var _orthoScale:Number = 1;
      
      protected var _orthoScaleMatrix:Matrix3D;
      
      protected var _target:DisplayObject3D;
      
      protected var _far:Number;
      
      public function CameraObject3D(param1:Number = 500, param2:Number = 3)
      {
         super();
         this.x = DEFAULT_POS.x;
         this.y = DEFAULT_POS.y;
         this.z = DEFAULT_POS.z;
         this.zoom = param2;
         this.focus = param1;
         this.eye = Matrix3D.IDENTITY;
         this.viewport = DEFAULT_VIEWPORT;
         this.sort = true;
         this._ortho = false;
         this._orthoScaleMatrix = Matrix3D.scaleMatrix(1,1,1);
         if(Papervision3D.useRIGHTHANDED)
         {
            DEFAULT_UP.y = -1;
            this.yUP = false;
            this.lookAt(DisplayObject3D.ZERO);
         }
         else
         {
            this.yUP = true;
         }
      }
      
      override public function lookAt(param1:DisplayObject3D, param2:Number3D = null) : void
      {
         if(this.yUP)
         {
            super.lookAt(param1,param2);
         }
         else
         {
            super.lookAt(param1,param2 || DEFAULT_UP);
         }
      }
      
      public function orbit(param1:Number, param2:Number, param3:Boolean = true, param4:DisplayObject3D = null) : void
      {
      }
      
      public function projectVertices(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         return 0;
      }
      
      public function projectVertex(param1:Vertex3D, param2:DisplayObject3D, param3:RenderSessionData, param4:NumberUV) : Number
      {
         return 0;
      }
      
      public function projectFaces(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         return 0;
      }
      
      public function transformView(param1:Matrix3D = null) : void
      {
         if(this.yUP)
         {
            this.eye.calculateMultiply(param1 || this.transform,_flipY);
            this.eye.invert();
         }
         else
         {
            this.eye.calculateInverse(param1 || this.transform);
         }
      }
      
      public function tilt(param1:Number) : void
      {
      }
      
      public function pan(param1:Number) : void
      {
      }
      
      public function unproject(param1:Number, param2:Number) : Number3D
      {
         var _loc3_:Number = this.focus * this.zoom / this.focus;
         var _loc4_:Number3D = new Number3D(param1 / _loc3_,-param2 / _loc3_,this.focus);
         Matrix3D.multiplyVector3x3(transform,_loc4_);
         return _loc4_;
      }
      
      public function set fov(param1:Number) : void
      {
         if(!this.viewport || this.viewport.isEmpty())
         {
            PaperLogger.warning("CameraObject3D#viewport not set, can\'t set fov!");
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(this._target)
         {
            _loc2_ = this._target.world.n14;
            _loc3_ = this._target.world.n24;
            _loc4_ = this._target.world.n34;
         }
         var _loc5_:Number = this.viewport.height / 2;
         var _loc6_:Number = param1 / 2 * (Math.PI / 180);
         this.focus = _loc5_ / Math.tan(_loc6_) / this.zoom;
      }
      
      public function get fov() : Number
      {
         if(!this.viewport || this.viewport.isEmpty())
         {
            PaperLogger.warning("CameraObject3D#viewport not set, can\'t calculate fov!");
            return NaN;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this._target)
         {
            _loc1_ = this._target.world.n14;
            _loc2_ = this._target.world.n24;
            _loc3_ = this._target.world.n34;
         }
         var _loc4_:Number = this.x - _loc1_;
         var _loc5_:Number = this.y - _loc2_;
         var _loc6_:Number = this.z - _loc3_;
         var _loc7_:Number = this.focus;
         var _loc8_:Number = this.zoom;
         var _loc9_:Number = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_) + _loc7_;
         var _loc10_:Number = this.viewport.height / 2;
         var _loc11_:Number = 180 / Math.PI;
         return Math.atan(_loc9_ / _loc7_ / _loc8_ * _loc10_ / _loc9_) * _loc11_ * 2;
      }
      
      public function get far() : Number
      {
         return this._far;
      }
      
      public function set far(param1:Number) : void
      {
         if(param1 > this.focus)
         {
            this._far = param1;
         }
      }
      
      public function get near() : Number
      {
         return this.focus;
      }
      
      public function set near(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.focus = param1;
         }
      }
      
      public function get target() : DisplayObject3D
      {
         return this._target;
      }
      
      public function set target(param1:DisplayObject3D) : void
      {
         this._target = param1;
      }
      
      public function get useCulling() : Boolean
      {
         return this._useCulling;
      }
      
      public function set useCulling(param1:Boolean) : void
      {
         this._useCulling = param1;
      }
      
      public function get useProjectionMatrix() : Boolean
      {
         return this._useProjectionMatrix;
      }
      
      public function set useProjectionMatrix(param1:Boolean) : void
      {
         this._useProjectionMatrix = param1;
      }
      
      public function get ortho() : Boolean
      {
         return this._ortho;
      }
      
      public function set ortho(param1:Boolean) : void
      {
         this._ortho = param1;
      }
      
      public function get orthoScale() : Number
      {
         return this._orthoScale;
      }
      
      public function set orthoScale(param1:Number) : void
      {
         this._orthoScale = param1 > 0 ? Number(param1) : Number(0.0001);
         this._orthoScaleMatrix.n11 = this._orthoScale;
         this._orthoScaleMatrix.n22 = this._orthoScale;
         this._orthoScaleMatrix.n33 = this._orthoScale;
      }
   }
}
