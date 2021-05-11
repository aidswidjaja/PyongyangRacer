package org.papervision3d.objects
{
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.data.UserData;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.material.AbstractLightShadeMaterial;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.Quaternion;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.DisplayObjectContainer3D;
   import org.papervision3d.core.proto.GeometryObject3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.shaders.ShadedMaterial;
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class DisplayObject3D extends DisplayObjectContainer3D
   {
      
      public static const MESH_SORT_CENTER:uint = 1;
      
      public static const MESH_SORT_FAR:uint = 2;
      
      public static const MESH_SORT_CLOSE:uint = 3;
      
      public static var faceLevelMode:Boolean;
      
      public static var sortedArray:Array = new Array();
      
      private static const FORWARD:Number3D = new Number3D(0,0,1);
      
      private static const BACKWARD:Number3D = new Number3D(0,0,-1);
      
      private static const LEFT:Number3D = new Number3D(-1,0,0);
      
      private static const RIGHT:Number3D = new Number3D(1,0,0);
      
      private static const UP:Number3D = new Number3D(0,1,0);
      
      private static const DOWN:Number3D = new Number3D(0,-1,0);
      
      private static var _tempMatrix:Matrix3D = Matrix3D.IDENTITY;
      
      private static var _tempQuat:Quaternion = new Quaternion();
      
      private static var _newID:int = 0;
      
      private static var toDEGREES:Number = 180 / Math.PI;
      
      private static var toRADIANS:Number = Math.PI / 180;
      
      private static var entry_count:uint = 0;
       
      
      public var transform:Matrix3D;
      
      public var view:Matrix3D;
      
      public var world:Matrix3D;
      
      public var faces:Array;
      
      public var geometry:GeometryObject3D;
      
      public var screenZ:Number;
      
      public var culled:Boolean;
      
      public var materials:MaterialsList;
      
      public var meshSort:uint = 2;
      
      public var container:ViewportLayer;
      
      public var alpha:Number = 1;
      
      public var blendMode:String = "normal";
      
      public var filters:Array;
      
      public var parentContainer:DisplayObject3D;
      
      public var flipLightDirection:Boolean = false;
      
      public var frustumTestMethod:int = 0;
      
      public var parent:DisplayObjectContainer3D;
      
      public var screen:Number3D;
      
      public var visible:Boolean;
      
      public var resId:int;
      
      public var name:String;
      
      public var id:int;
      
      public var extra:Object;
      
      public var cullTest:Number = 0;
      
      public var useClipping:Boolean = false;
      
      public var testQuad:Boolean = true;
      
      protected var _transformDirty:Boolean = false;
      
      protected var _sorted:Array;
      
      protected var _useOwnContainer:Boolean = false;
      
      protected var _userData:UserData;
      
      protected var _scene:SceneObject3D = null;
      
      private var _position:Number3D;
      
      private var _lookatTarget:Number3D;
      
      private var _zAxis:Number3D;
      
      private var _xAxis:Number3D;
      
      private var _yAxis:Number3D;
      
      private var _rotation:Number3D;
      
      private var _rotationDirty:Boolean = false;
      
      private var _rotationX:Number;
      
      public var _rotationY:Number;
      
      private var _rotationZ:Number;
      
      private var _scaleX:Number;
      
      private var _scaleY:Number;
      
      private var _scaleZ:Number;
      
      private var _scaleDirty:Boolean = false;
      
      private var _tempScale:Number3D;
      
      private var _numClones:uint = 0;
      
      private var _material:MaterialObject3D;
      
      private var _rot:Quaternion;
      
      private var _qPitch:Quaternion;
      
      private var _qYaw:Quaternion;
      
      private var _qRoll:Quaternion;
      
      private var _localRotationX:Number = 0;
      
      private var _localRotationY:Number = 0;
      
      private var _localRotationZ:Number = 0;
      
      private var _autoCalcScreenCoords:Boolean = false;
      
      public function DisplayObject3D(param1:String = null, param2:GeometryObject3D = null)
      {
         this.faces = new Array();
         this.filters = [];
         this.screen = new Number3D();
         this._position = Number3D.ZERO;
         this._lookatTarget = Number3D.ZERO;
         this._zAxis = Number3D.ZERO;
         this._xAxis = Number3D.ZERO;
         this._yAxis = Number3D.ZERO;
         this._rotation = Number3D.ZERO;
         this._rot = new Quaternion();
         this._qPitch = new Quaternion();
         this._qYaw = new Quaternion();
         this._qRoll = new Quaternion();
         super();
         if(param1 != null)
         {
            PaperLogger.info("DisplayObject3D: " + param1);
         }
         this.culled = false;
         this.transform = Matrix3D.IDENTITY;
         this.world = Matrix3D.IDENTITY;
         this.view = Matrix3D.IDENTITY;
         this.x = 0;
         this.y = 0;
         this.z = 0;
         this.rotationX = 0;
         this.rotationY = 0;
         this.rotationZ = 0;
         this._localRotationX = this._localRotationY = this._localRotationZ = 0;
         var _loc3_:Number = !!Papervision3D.usePERCENT ? Number(100) : Number(1);
         this.scaleX = _loc3_;
         this.scaleY = _loc3_;
         this.scaleZ = _loc3_;
         this._tempScale = new Number3D();
         this.visible = true;
         this.id = _newID++;
         this.name = param1 || String(this.id);
         this._numClones = 0;
         if(param2)
         {
            this.addGeometry(param2);
         }
      }
      
      public static function get ZERO() : DisplayObject3D
      {
         return new DisplayObject3D();
      }
      
      public function set useOwnContainer(param1:Boolean) : void
      {
         this._useOwnContainer = param1;
         this.setParentContainer(this,true);
      }
      
      public function get useOwnContainer() : Boolean
      {
         return this._useOwnContainer;
      }
      
      public function set userData(param1:UserData) : void
      {
         this._userData = param1;
      }
      
      public function get userData() : UserData
      {
         return this._userData;
      }
      
      public function get x() : Number
      {
         return this.transform.n14;
      }
      
      public function set x(param1:Number) : void
      {
         this.transform.n14 = param1;
      }
      
      public function get y() : Number
      {
         return this.transform.n24;
      }
      
      public function set y(param1:Number) : void
      {
         this.transform.n24 = param1;
      }
      
      public function get z() : Number
      {
         return this.transform.n34;
      }
      
      public function set z(param1:Number) : void
      {
         this.transform.n34 = param1;
      }
      
      public function get position() : Number3D
      {
         this._position.reset(this.x,this.y,this.z);
         return this._position;
      }
      
      public function set position(param1:Number3D) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
      }
      
      public function get rotationX() : Number
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         return !!Papervision3D.useDEGREES ? Number(this._rotationX * toDEGREES) : Number(this._rotationX);
      }
      
      public function set rotationX(param1:Number) : void
      {
         this._rotationX = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         this._transformDirty = true;
      }
      
      public function get rotationY() : Number
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         return !!Papervision3D.useDEGREES ? Number(this._rotationY * toDEGREES) : Number(this._rotationY);
      }
      
      public function set rotationY(param1:Number) : void
      {
         this._rotationY = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         this._transformDirty = true;
      }
      
      public function get rotationZ() : Number
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         return !!Papervision3D.useDEGREES ? Number(this._rotationZ * toDEGREES) : Number(this._rotationZ);
      }
      
      public function set rotationZ(param1:Number) : void
      {
         this._rotationZ = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         this._transformDirty = true;
      }
      
      public function get scale() : Number
      {
         if(this._scaleX == this._scaleY && this._scaleX == this._scaleZ)
         {
            if(Papervision3D.usePERCENT)
            {
               return this._scaleX * 100;
            }
            return this._scaleX;
         }
         return NaN;
      }
      
      public function set scale(param1:Number) : void
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         if(Papervision3D.usePERCENT)
         {
            param1 /= 100;
         }
         this._scaleX = this._scaleY = this._scaleZ = param1;
         this._transformDirty = true;
      }
      
      public function get scaleX() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleX * 100;
         }
         return this._scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         if(Papervision3D.usePERCENT)
         {
            this._scaleX = param1 / 100;
         }
         else
         {
            this._scaleX = param1;
         }
         this._transformDirty = true;
      }
      
      public function get scaleY() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleY * 100;
         }
         return this._scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         if(Papervision3D.usePERCENT)
         {
            this._scaleY = param1 / 100;
         }
         else
         {
            this._scaleY = param1;
         }
         this._transformDirty = true;
      }
      
      public function get scaleZ() : Number
      {
         if(Papervision3D.usePERCENT)
         {
            return this._scaleZ * 100;
         }
         return this._scaleZ;
      }
      
      public function set scaleZ(param1:Number) : void
      {
         if(this._rotationDirty)
         {
            this.updateRotation();
         }
         if(Papervision3D.usePERCENT)
         {
            this._scaleZ = param1 / 100;
         }
         else
         {
            this._scaleZ = param1;
         }
         this._transformDirty = true;
      }
      
      public function get sceneX() : Number
      {
         return this.world.n14;
      }
      
      public function get sceneY() : Number
      {
         return this.world.n24;
      }
      
      public function get sceneZ() : Number
      {
         return this.world.n34;
      }
      
      public function set material(param1:MaterialObject3D) : void
      {
         if(this._material)
         {
            this._material.unregisterObject(this);
         }
         this._material = param1;
         if(this._material)
         {
            this._material.registerObject(this);
         }
      }
      
      public function get material() : MaterialObject3D
      {
         return this._material;
      }
      
      public function set scene(param1:SceneObject3D) : void
      {
         var _loc2_:DisplayObject3D = null;
         this._scene = param1;
         for each(_loc2_ in this._childrenByName)
         {
            if(_loc2_.scene == null)
            {
               _loc2_.scene = this._scene;
            }
         }
      }
      
      public function get scene() : SceneObject3D
      {
         return this._scene;
      }
      
      public function set autoCalcScreenCoords(param1:Boolean) : void
      {
         this._autoCalcScreenCoords = param1;
      }
      
      public function get autoCalcScreenCoords() : Boolean
      {
         return this._autoCalcScreenCoords;
      }
      
      override public function addChild(param1:DisplayObject3D, param2:String = null) : DisplayObject3D
      {
         param1 = super.addChild(param1,param2);
         if(param1.scene == null)
         {
            param1.scene = this.scene;
         }
         if(this.useOwnContainer)
         {
            param1.parentContainer = this;
         }
         return param1;
      }
      
      public function addGeometry(param1:GeometryObject3D = null) : void
      {
         if(param1)
         {
            this.geometry = param1;
         }
      }
      
      public function clone() : DisplayObject3D
      {
         var _loc3_:DisplayObject3D = null;
         var _loc1_:String = this.name + "_" + this._numClones++;
         var _loc2_:DisplayObject3D = new DisplayObject3D(_loc1_);
         if(this.material)
         {
            _loc2_.material = this.material;
         }
         if(this.materials)
         {
            _loc2_.materials = this.materials.clone();
         }
         if(this.geometry)
         {
            _loc2_.geometry = this.geometry.clone(_loc2_);
            _loc2_.geometry.ready = true;
         }
         _loc2_.copyTransform(this.transform);
         for each(_loc3_ in this.children)
         {
            _loc2_.addChild(_loc3_.clone());
         }
         return _loc2_;
      }
      
      public function distanceTo(param1:DisplayObject3D) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         var _loc4_:Number = this.z - param1.z;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function hitTestPoint(param1:Number, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:Number = this.x - param1;
         var _loc5_:Number = this.y - param2;
         var _loc6_:Number = this.z - param3;
         var _loc7_:Number = _loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_;
         var _loc8_:Number;
         return (_loc8_ = !!this.geometry ? Number(this.geometry.boundingSphere.maxDistance) : Number(0)) > _loc7_;
      }
      
      public function hitTestObject(param1:DisplayObject3D, param2:Number = 1) : Boolean
      {
         var _loc3_:Number = this.x - param1.x;
         var _loc4_:Number = this.y - param1.y;
         var _loc5_:Number = this.z - param1.z;
         var _loc6_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_;
         var _loc7_:Number = !!this.geometry ? Number(this.geometry.boundingSphere.maxDistance) : Number(0);
         var _loc8_:Number = !!param1.geometry ? Number(param1.geometry.boundingSphere.maxDistance) : Number(0);
         return (_loc7_ *= param2) + _loc8_ > _loc6_;
      }
      
      public function getMaterialByName(param1:String) : MaterialObject3D
      {
         var _loc3_:DisplayObject3D = null;
         var _loc2_:MaterialObject3D = !!this.materials ? this.materials.getMaterialByName(param1) : null;
         if(_loc2_)
         {
            return _loc2_;
         }
         for each(_loc3_ in this._childrenByName)
         {
            _loc2_ = _loc3_.getMaterialByName(param1);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function materialsList() : String
      {
         var _loc2_:* = null;
         var _loc3_:DisplayObject3D = null;
         var _loc1_:String = "";
         for(_loc2_ in this.materials)
         {
            _loc1_ += _loc2_ + "\n";
         }
         for each(_loc3_ in this._childrenByName)
         {
            for(_loc2_ in _loc3_.materials.materialsByName)
            {
               _loc1_ += "+ " + _loc2_ + "\n";
            }
         }
         return _loc1_;
      }
      
      public function replaceMaterialByName(param1:MaterialObject3D, param2:String) : void
      {
         if(!this.materials)
         {
            return;
         }
         var _loc3_:MaterialObject3D = this.materials.getMaterialByName(param2);
         if(!_loc3_)
         {
            return;
         }
         if(this.material === _loc3_)
         {
            this.material = param1;
         }
         _loc3_ = this.materials.removeMaterial(_loc3_);
         param1 = this.materials.addMaterial(param1,param2);
         this.updateMaterials(this,_loc3_,param1);
      }
      
      public function setChildMaterial(param1:DisplayObject3D, param2:MaterialObject3D, param3:MaterialObject3D = null) : void
      {
         var _loc4_:Triangle3D = null;
         if(!param1)
         {
            return;
         }
         if(!param3 || param1.material === param3)
         {
            param1.material = param2;
         }
         if(param1.geometry && param1.geometry.faces)
         {
            for each(_loc4_ in param1.geometry.faces)
            {
               if(!param3 || _loc4_.material === param3)
               {
                  _loc4_.material = param2;
               }
            }
         }
      }
      
      public function setChildMaterialByName(param1:String, param2:MaterialObject3D) : void
      {
         this.setChildMaterial(getChildByName(param1,true),param2);
      }
      
      private function updateMaterials(param1:DisplayObject3D, param2:MaterialObject3D, param3:MaterialObject3D) : void
      {
         var _loc4_:DisplayObject3D = null;
         var _loc5_:Triangle3D = null;
         param2.unregisterObject(param1);
         if(param3 is AbstractLightShadeMaterial || param3 is ShadedMaterial)
         {
            param3.registerObject(param1);
         }
         if(param1.material === param2)
         {
            param1.material = param3;
         }
         if(param1.geometry && param1.geometry.faces && param1.geometry.faces.length)
         {
            for each(_loc5_ in param1.geometry.faces)
            {
               if(_loc5_.material === param2)
               {
                  _loc5_.material = param3;
               }
            }
         }
         for each(_loc4_ in param1.children)
         {
            this.updateMaterials(_loc4_,param2,param3);
         }
      }
      
      public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc5_:DisplayObject3D = null;
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this.world.calculateMultiply(param1.world,this.transform);
         if(param2.camera.culler)
         {
            if(this === param2.camera)
            {
               this.culled = true;
            }
            else
            {
               this.culled = param2.camera.culler.testObject(this) < 0;
            }
            if(this.culled)
            {
               ++param2.renderStatistics.culledObjects;
               return 0;
            }
         }
         else
         {
            this.culled = false;
         }
         if(param1 !== param2.camera)
         {
            if(param2.camera.useProjectionMatrix)
            {
               this.view.calculateMultiply4x4(param1.view,this.transform);
            }
            else
            {
               this.view.calculateMultiply(param1.view,this.transform);
            }
         }
         else if(param2.camera.useProjectionMatrix)
         {
            this.view.calculateMultiply4x4(param2.camera.eye,this.transform);
         }
         else
         {
            this.view.calculateMultiply(param2.camera.eye,this.transform);
         }
         if(this._autoCalcScreenCoords)
         {
            this.calculateScreenCoords(param2.camera);
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         for each(_loc5_ in this._childrenByName)
         {
            if(_loc5_.visible)
            {
               _loc3_ += _loc5_.project(this,param2);
               _loc4_++;
            }
         }
         return this.screenZ = _loc3_ / _loc4_;
      }
      
      public function UpdateMatrix(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc5_:DisplayObject3D = null;
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this.world.calculateMultiply(param1.world,this.transform);
         if(param2.camera.culler)
         {
            if(this === param2.camera)
            {
               this.culled = true;
            }
            else
            {
               this.culled = param2.camera.culler.testObject(this) < 0;
            }
            if(this.culled)
            {
               ++param2.renderStatistics.culledObjects;
               return 0;
            }
         }
         else
         {
            this.culled = false;
         }
         if(param1 !== param2.camera)
         {
            if(param2.camera.useProjectionMatrix)
            {
               this.view.calculateMultiply4x4(param1.view,this.transform);
            }
            else
            {
               this.view.calculateMultiply(param1.view,this.transform);
            }
         }
         else if(param2.camera.useProjectionMatrix)
         {
            this.view.calculateMultiply4x4(param2.camera.eye,this.transform);
         }
         else
         {
            this.view.calculateMultiply(param2.camera.eye,this.transform);
         }
         if(this._autoCalcScreenCoords)
         {
            this.calculateScreenCoords(param2.camera);
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         for each(_loc5_ in this._childrenByName)
         {
            if(_loc5_.visible)
            {
               _loc3_ += _loc5_.UpdateMatrix(this,param2);
               _loc4_++;
            }
         }
         return this.screenZ = _loc3_ / _loc4_;
      }
      
      public function calculateScreenCoords(param1:CameraObject3D) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param1.useProjectionMatrix)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = _loc2_ * this.view.n41 + _loc3_ * this.view.n42 + _loc4_ * this.view.n43 + this.view.n44;
            _loc6_ = param1.viewport.width / 2;
            _loc7_ = param1.viewport.height / 2;
            this.screen.x = (_loc2_ * this.view.n11 + _loc3_ * this.view.n12 + _loc4_ * this.view.n13 + this.view.n14) / _loc5_;
            this.screen.y = (_loc2_ * this.view.n21 + _loc3_ * this.view.n22 + _loc4_ * this.view.n23 + this.view.n24) / _loc5_;
            this.screen.z = _loc2_ * this.view.n31 + _loc3_ * this.view.n32 + _loc4_ * this.view.n33 + this.view.n34;
            this.screen.x *= _loc6_;
            this.screen.y *= _loc7_;
         }
         else
         {
            _loc8_ = param1.focus * param1.zoom / (param1.focus + this.view.n34);
            this.screen.x = this.view.n14 * _loc8_;
            this.screen.y = this.view.n24 * _loc8_;
            this.screen.z = this.view.n34;
         }
      }
      
      public function moveForward(param1:Number) : void
      {
         this.translate(param1,FORWARD);
      }
      
      public function moveBackward(param1:Number) : void
      {
         this.translate(param1,BACKWARD);
      }
      
      public function moveLeft(param1:Number) : void
      {
         this.translate(param1,LEFT);
      }
      
      public function moveRight(param1:Number) : void
      {
         this.translate(param1,RIGHT);
      }
      
      public function moveUp(param1:Number) : void
      {
         this.translate(param1,UP);
      }
      
      public function moveDown(param1:Number) : void
      {
         this.translate(param1,DOWN);
      }
      
      public function translate(param1:Number, param2:Number3D) : void
      {
         var _loc3_:Number3D = param2.clone();
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         Matrix3D.rotateAxis(this.transform,_loc3_);
         this.x += param1 * _loc3_.x;
         this.y += param1 * _loc3_.y;
         this.z += param1 * _loc3_.z;
      }
      
      public function set localRotationX(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qPitch.setFromAxisAngle(this.transform.n11,this.transform.n21,this.transform.n31,this._localRotationX - param1);
         this.transform.calculateMultiply3x3(this._qPitch.matrix,this.transform);
         this._localRotationX = param1;
         this._rotationDirty = true;
      }
      
      public function get localRotationX() : Number
      {
         return !!Papervision3D.useDEGREES ? Number(this._localRotationX * toDEGREES) : Number(this._localRotationX);
      }
      
      public function set localRotationY(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qYaw.setFromAxisAngle(this.transform.n12,this.transform.n22,this.transform.n32,this._localRotationY - param1);
         this.transform.calculateMultiply3x3(this._qYaw.matrix,this.transform);
         this._localRotationY = param1;
         this._rotationDirty = true;
      }
      
      public function get localRotationY() : Number
      {
         return !!Papervision3D.useDEGREES ? Number(this._localRotationY * toDEGREES) : Number(this._localRotationY);
      }
      
      public function set localRotationZ(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qRoll.setFromAxisAngle(this.transform.n13,this.transform.n23,this.transform.n33,this._localRotationZ - param1);
         this.transform.calculateMultiply3x3(this._qRoll.matrix,this.transform);
         this._localRotationZ = param1;
         this._rotationDirty = true;
      }
      
      public function get localRotationZ() : Number
      {
         return !!Papervision3D.useDEGREES ? Number(this._localRotationZ * toDEGREES) : Number(this._localRotationZ);
      }
      
      public function pitch(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qPitch.setFromAxisAngle(this.transform.n11,this.transform.n21,this.transform.n31,param1);
         this.transform.calculateMultiply3x3(this._qPitch.matrix,this.transform);
         this._localRotationX += param1;
         this._rotationDirty = true;
      }
      
      public function yaw(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qYaw.setFromAxisAngle(this.transform.n12,this.transform.n22,this.transform.n32,param1);
         this.transform.calculateMultiply3x3(this._qYaw.matrix,this.transform);
         this._localRotationY += param1;
         this._rotationDirty = true;
      }
      
      public function roll(param1:Number) : void
      {
         param1 = !!Papervision3D.useDEGREES ? Number(param1 * toRADIANS) : Number(param1);
         if(this._transformDirty)
         {
            this.updateTransform();
         }
         this._qRoll.setFromAxisAngle(this.transform.n13,this.transform.n23,this.transform.n33,param1);
         this.transform.calculateMultiply3x3(this._qRoll.matrix,this.transform);
         this._localRotationZ += param1;
         this._rotationDirty = true;
      }
      
      public function lookAt(param1:DisplayObject3D, param2:Number3D = null) : void
      {
         var _loc3_:DisplayObject3D = null;
         var _loc4_:Matrix3D = null;
         if(this is CameraObject3D)
         {
            this._position.reset(this.x,this.y,this.z);
         }
         else
         {
            _loc3_ = this.parent as DisplayObject3D;
            if(_loc3_)
            {
               this.world.calculateMultiply(_loc3_.world,this.transform);
            }
            else
            {
               this.world.copy(this.transform);
            }
            this._position.reset(this.world.n14,this.world.n24,this.world.n34);
         }
         if(param1 is CameraObject3D)
         {
            this._lookatTarget.reset(param1.x,param1.y,param1.z);
         }
         else
         {
            _loc3_ = param1.parent as DisplayObject3D;
            if(_loc3_)
            {
               param1.world.calculateMultiply(_loc3_.world,param1.transform);
            }
            else
            {
               param1.world.copy(param1.transform);
            }
            this._lookatTarget.reset(param1.world.n14,param1.world.n24,param1.world.n34);
         }
         this._zAxis.copyFrom(this._lookatTarget);
         this._zAxis.minusEq(this._position);
         this._zAxis.normalize();
         if(this._zAxis.modulo > 0.1)
         {
            this._xAxis = Number3D.cross(this._zAxis,param2 || UP,this._xAxis);
            this._xAxis.normalize();
            this._yAxis = Number3D.cross(this._zAxis,this._xAxis,this._yAxis);
            this._yAxis.normalize();
            (_loc4_ = this.transform).n11 = this._xAxis.x * this._scaleX;
            _loc4_.n21 = this._xAxis.y * this._scaleX;
            _loc4_.n31 = this._xAxis.z * this._scaleX;
            _loc4_.n12 = -this._yAxis.x * this._scaleY;
            _loc4_.n22 = -this._yAxis.y * this._scaleY;
            _loc4_.n32 = -this._yAxis.z * this._scaleY;
            _loc4_.n13 = this._zAxis.x * this._scaleZ;
            _loc4_.n23 = this._zAxis.y * this._scaleZ;
            _loc4_.n33 = this._zAxis.z * this._scaleZ;
            this._localRotationX = this._localRotationY = this._localRotationZ = 0;
            this._transformDirty = false;
            this._rotationDirty = true;
         }
         else
         {
            PaperLogger.error("lookAt error");
         }
      }
      
      public function copyPosition(param1:*) : void
      {
         var _loc2_:Matrix3D = this.transform;
         var _loc3_:Matrix3D = param1 is DisplayObject3D ? param1.transform : param1;
         _loc2_.n14 = _loc3_.n14;
         _loc2_.n24 = _loc3_.n24;
         _loc2_.n34 = _loc3_.n34;
      }
      
      public function copyTransform(param1:*) : void
      {
         var _loc4_:DisplayObject3D = null;
         if(param1 is DisplayObject3D)
         {
            if((_loc4_ = DisplayObject3D(param1))._transformDirty)
            {
               _loc4_.updateTransform();
            }
         }
         var _loc2_:Matrix3D = this.transform;
         var _loc3_:Matrix3D = param1 is DisplayObject3D ? param1.transform : param1;
         _loc2_.n11 = _loc3_.n11;
         _loc2_.n12 = _loc3_.n12;
         _loc2_.n13 = _loc3_.n13;
         _loc2_.n14 = _loc3_.n14;
         _loc2_.n21 = _loc3_.n21;
         _loc2_.n22 = _loc3_.n22;
         _loc2_.n23 = _loc3_.n23;
         _loc2_.n24 = _loc3_.n24;
         _loc2_.n31 = _loc3_.n31;
         _loc2_.n32 = _loc3_.n32;
         _loc2_.n33 = _loc3_.n33;
         _loc2_.n34 = _loc3_.n34;
         this._transformDirty = false;
         this._rotationDirty = true;
      }
      
      override public function toString() : String
      {
         return this.name + ": x:" + Math.round(this.x) + " y:" + Math.round(this.y) + " z:" + Math.round(this.z);
      }
      
      public function createViewportLayer(param1:Viewport3D, param2:Boolean = true) : ViewportLayer
      {
         var _loc3_:ViewportLayer = param1.getChildLayer(this,true);
         if(param2)
         {
            this.addChildrenToLayer(this,_loc3_);
         }
         return _loc3_;
      }
      
      public function addChildrenToLayer(param1:DisplayObject3D, param2:ViewportLayer) : void
      {
         var _loc3_:DisplayObject3D = null;
         for each(_loc3_ in param1.children)
         {
            param2.addDisplayObject3D(_loc3_);
            _loc3_.addChildrenToLayer(_loc3_,param2);
         }
      }
      
      protected function setParentContainer(param1:DisplayObject3D, param2:Boolean = true) : void
      {
         var _loc3_:DisplayObject3D = null;
         if(param2 && param1 != this)
         {
            this.parentContainer = param1;
         }
         for each(_loc3_ in children)
         {
            _loc3_.setParentContainer(param1,param2);
         }
      }
      
      public function updateTransform() : void
      {
         this._rot.setFromEuler(this._rotationY,this._rotationZ,this._rotationX);
         this.transform.copy3x3(this._rot.matrix);
         _tempMatrix.reset();
         _tempMatrix.n11 = this._scaleX;
         _tempMatrix.n22 = this._scaleY;
         _tempMatrix.n33 = this._scaleZ;
         this.transform.calculateMultiply(this.transform,_tempMatrix);
         this._transformDirty = false;
      }
      
      private function updateRotation() : void
      {
         this._tempScale.x = !!Papervision3D.usePERCENT ? Number(this._scaleX * 100) : Number(this._scaleX);
         this._tempScale.y = !!Papervision3D.usePERCENT ? Number(this._scaleY * 100) : Number(this._scaleY);
         this._tempScale.z = !!Papervision3D.usePERCENT ? Number(this._scaleZ * 100) : Number(this._scaleZ);
         this._rotation = Matrix3D.matrix2euler(this.transform,this._rotation,this._tempScale);
         this._rotationX = this._rotation.x * toRADIANS;
         this._rotationY = this._rotation.y * toRADIANS;
         this._rotationZ = this._rotation.z * toRADIANS;
         this._rotationDirty = false;
      }
   }
}
