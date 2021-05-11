package org.papervision3d.core.proto
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.AxisAlignedBoundingBox;
   import org.papervision3d.core.math.BoundingSphere;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class GeometryObject3D extends EventDispatcher
   {
       
      
      protected var _boundingSphere:BoundingSphere;
      
      protected var _boundingSphereDirty:Boolean = true;
      
      protected var _aabb:AxisAlignedBoundingBox;
      
      protected var _aabbDirty:Boolean = true;
      
      private var _numInstances:uint = 0;
      
      public var dirty:Boolean;
      
      public var faces:Array;
      
      public var vertices:Array;
      
      public var _ready:Boolean = false;
      
      public function GeometryObject3D()
      {
         super();
         this.dirty = true;
      }
      
      public function transformVertices(param1:Matrix3D) : void
      {
         var _loc15_:Vertex3D = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc2_:Number = param1.n11;
         var _loc3_:Number = param1.n12;
         var _loc4_:Number = param1.n13;
         var _loc5_:Number = param1.n21;
         var _loc6_:Number = param1.n22;
         var _loc7_:Number = param1.n23;
         var _loc8_:Number = param1.n31;
         var _loc9_:Number = param1.n32;
         var _loc10_:Number = param1.n33;
         var _loc11_:Number = param1.n14;
         var _loc12_:Number = param1.n24;
         var _loc13_:Number = param1.n34;
         var _loc14_:int = this.vertices.length;
         while(_loc15_ = this.vertices[--_loc14_])
         {
            _loc16_ = _loc15_.x;
            _loc17_ = _loc15_.y;
            _loc18_ = _loc15_.z;
            _loc19_ = _loc16_ * _loc2_ + _loc17_ * _loc3_ + _loc18_ * _loc4_ + _loc11_;
            _loc20_ = _loc16_ * _loc5_ + _loc17_ * _loc6_ + _loc18_ * _loc7_ + _loc12_;
            _loc21_ = _loc16_ * _loc8_ + _loc17_ * _loc9_ + _loc18_ * _loc10_ + _loc13_;
            _loc15_.x = _loc19_;
            _loc15_.y = _loc20_;
            _loc15_.z = _loc21_;
         }
      }
      
      private function createVertexNormals() : void
      {
         var _loc2_:Triangle3D = null;
         var _loc3_:Vertex3D = null;
         var _loc1_:Dictionary = new Dictionary(true);
         for each(_loc2_ in this.faces)
         {
            _loc2_.v0.connectedFaces[_loc2_] = _loc2_;
            _loc2_.v1.connectedFaces[_loc2_] = _loc2_;
            _loc2_.v2.connectedFaces[_loc2_] = _loc2_;
            _loc1_[_loc2_.v0] = _loc2_.v0;
            _loc1_[_loc2_.v1] = _loc2_.v1;
            _loc1_[_loc2_.v2] = _loc2_.v2;
         }
         for each(_loc3_ in _loc1_)
         {
            _loc3_.calculateNormal();
         }
      }
      
      public function set ready(param1:Boolean) : void
      {
         if(param1)
         {
            this.createVertexNormals();
            this.dirty = false;
         }
         this._ready = param1;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function get boundingSphere() : BoundingSphere
      {
         if(this._boundingSphereDirty)
         {
            this._boundingSphere = BoundingSphere.getFromVertices(this.vertices);
            this._boundingSphereDirty = false;
         }
         return this._boundingSphere;
      }
      
      public function get aabb() : AxisAlignedBoundingBox
      {
         if(this._aabbDirty)
         {
            this._aabb = AxisAlignedBoundingBox.createFromVertices(this.vertices);
            this._aabbDirty = false;
         }
         return this._aabb;
      }
      
      public function clone(param1:DisplayObject3D = null) : GeometryObject3D
      {
         var _loc5_:int = 0;
         var _loc6_:MaterialObject3D = null;
         var _loc7_:Vertex3D = null;
         var _loc8_:Triangle3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:Vertex3D = null;
         var _loc11_:Vertex3D = null;
         var _loc2_:Dictionary = new Dictionary(true);
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:GeometryObject3D;
         (_loc4_ = new GeometryObject3D()).vertices = new Array();
         _loc4_.faces = new Array();
         _loc5_ = 0;
         while(_loc5_ < this.vertices.length)
         {
            _loc7_ = this.vertices[_loc5_];
            _loc3_[_loc7_] = _loc7_.clone();
            _loc4_.vertices.push(_loc3_[_loc7_]);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.faces.length)
         {
            _loc8_ = this.faces[_loc5_];
            _loc9_ = _loc3_[_loc8_.v0];
            _loc10_ = _loc3_[_loc8_.v1];
            _loc11_ = _loc3_[_loc8_.v2];
            _loc4_.faces.push(new Triangle3D(param1,[_loc9_,_loc10_,_loc11_],_loc8_.material,_loc8_.uv));
            _loc2_[_loc8_.material] = _loc8_.material;
            _loc5_++;
         }
         for each(_loc6_ in _loc2_)
         {
            if(_loc6_)
            {
               _loc6_.registerObject(param1);
            }
         }
         return _loc4_;
      }
      
      public function flipFaces() : void
      {
         var _loc1_:Triangle3D = null;
         var _loc2_:Vertex3D = null;
         for each(_loc1_ in this.faces)
         {
            _loc2_ = _loc1_.v0;
            _loc1_.v0 = _loc1_.v2;
            _loc1_.v2 = _loc2_;
            _loc1_.uv = [_loc1_.uv2,_loc1_.uv1,_loc1_.uv0];
            _loc1_.createNormal();
         }
         this.ready = true;
      }
   }
}
