package org.papervision3d.core.geom
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Triangle3DInstance;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class TriangleMesh3D extends Vertices3D
   {
       
      
      public var m_delta:Number = 0;
      
      private var _dtStore:Array;
      
      private var _dtActive:Array;
      
      private var _tri:RenderTriangle;
      
      public function TriangleMesh3D(param1:MaterialObject3D, param2:Array, param3:Array, param4:String = null)
      {
         this._dtStore = new Array();
         this._dtActive = new Array();
         super(param2,param4);
         this.geometry.faces = param3 || new Array();
         this.material = param1 || MaterialObject3D.DEFAULT;
      }
      
      override public function clone() : DisplayObject3D
      {
         var _loc1_:DisplayObject3D = super.clone();
         var _loc2_:TriangleMesh3D = new TriangleMesh3D(this.material,[],[],_loc1_.name);
         if(this.materials)
         {
            _loc2_.materials = this.materials.clone();
         }
         if(_loc1_.geometry)
         {
            _loc2_.geometry = _loc1_.geometry.clone(_loc2_);
         }
         _loc2_.copyTransform(this.transform);
         return _loc2_;
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc5_:Triangle3D = null;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:ITriangleCuller = null;
         var _loc10_:Vertex3DInstance = null;
         var _loc11_:Vertex3DInstance = null;
         var _loc12_:Vertex3DInstance = null;
         var _loc13_:Triangle3DInstance = null;
         var _loc14_:Triangle3D = null;
         var _loc15_:MaterialObject3D = null;
         var _loc16_:RenderTriangle = null;
         var _loc17_:Array = null;
         var _loc18_:Triangle3D = null;
         this._dtStore = [];
         this._dtActive = new Array();
         var _loc3_:int = this.geometry.vertices.length;
         var _loc4_:Array = [];
         if(param2.clipping && this.useClipping && !this.culled && (!!param2.camera.useCulling ? Boolean(cullTest == 0) : Boolean(true)))
         {
            super.projectEmpty(param1,param2);
            param2.clipping.setDisplayObject(this,param2);
            for each(_loc5_ in this.geometry.faces)
            {
               if(param2.clipping.testFace(_loc5_,this,param2))
               {
                  param2.clipping.clipFace(_loc5_,this,_loc15_,param2,_loc4_);
               }
               else
               {
                  _loc4_.push(_loc5_);
               }
            }
            super.project(param1,param2);
            param2.camera.projectFaces(_loc4_,this,param2);
         }
         else
         {
            super.project(param1,param2);
            _loc4_ = this.geometry.faces;
         }
         if(this.useClipping)
         {
            param2.TerrainClip.setDisplayObject(this,param2);
         }
         if(!this.culled)
         {
            _loc6_ = this.geometry.faces;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = param2.triangleCuller;
            for each(_loc14_ in _loc4_)
            {
               _loc15_ = !!_loc14_.material ? _loc14_.material : material;
               _loc10_ = _loc14_.v0.vertex3DInstance;
               _loc11_ = _loc14_.v1.vertex3DInstance;
               _loc12_ = _loc14_.v2.vertex3DInstance;
               if(_loc9_.testFace(_loc14_,_loc10_,_loc11_,_loc12_))
               {
                  (_loc16_ = _loc14_.renderCommand).screenZ = this.setScreenZ(meshSort,_loc10_,_loc11_,_loc12_);
                  _loc16_.screenZ += this.m_delta;
                  _loc7_ += _loc16_.screenZ;
                  _loc8_++;
                  _loc16_.renderer = _loc15_ as ITriangleDrawer;
                  _loc16_.v0 = _loc10_;
                  _loc16_.v1 = _loc11_;
                  _loc16_.v2 = _loc12_;
                  if(this.useClipping)
                  {
                     _loc16_.uvt[0] = _loc14_.v0.uvt[0];
                     _loc16_.uvt[1] = 1 - _loc14_.v0.uvt[1];
                     _loc16_.uvt[2] = _loc14_.v0.uvt[2];
                     _loc16_.uvt[3] = _loc14_.v1.uvt[0];
                     _loc16_.uvt[4] = 1 - _loc14_.v1.uvt[1];
                     _loc16_.uvt[5] = _loc14_.v1.uvt[2];
                     _loc16_.uvt[6] = _loc14_.v2.uvt[0];
                     _loc16_.uvt[7] = 1 - _loc14_.v2.uvt[1];
                     _loc16_.uvt[8] = _loc14_.v2.uvt[2];
                     _loc16_.isDrawTriangle = true;
                  }
                  else
                  {
                     _loc16_.uv0 = _loc14_.uv0;
                     _loc16_.uv1 = _loc14_.uv1;
                     _loc16_.uv2 = _loc14_.uv2;
                  }
                  if(param2.quadrantTree)
                  {
                     if(_loc16_.create == null)
                     {
                        _loc16_.create = this.createRenderTriangle;
                     }
                     _loc16_.update();
                     if(_loc16_.area < 0 && (_loc14_.material.doubleSided || _loc14_.material.oneSide && _loc14_.material.opposite))
                     {
                        _loc16_.area = -_loc16_.area;
                     }
                  }
                  param2.renderer.addToRenderList(_loc16_);
               }
               else
               {
                  if(this.useClipping && (_loc10_.visible || _loc11_.visible || _loc12_.visible))
                  {
                     _loc17_ = [];
                     if(param2.TerrainClip.testTerrainFace(_loc14_,this,param2))
                     {
                        param2.TerrainClip.clipTerrainFace(_loc14_,this,_loc15_,param2,_loc17_);
                        for each(_loc18_ in _loc17_)
                        {
                           _loc15_ = !!_loc18_.material ? _loc18_.material : material;
                           _loc10_ = _loc18_.v0.vertex3DInstance;
                           _loc11_ = _loc18_.v1.vertex3DInstance;
                           _loc12_ = _loc18_.v2.vertex3DInstance;
                           (_loc16_ = _loc18_.renderCommand).screenZ = this.setScreenZ(meshSort,_loc10_,_loc11_,_loc12_);
                           _loc16_.screenZ += this.m_delta;
                           _loc7_ += _loc16_.screenZ;
                           _loc8_++;
                           _loc16_.renderer = _loc15_ as ITriangleDrawer;
                           _loc16_.uvt[0] = _loc18_.v0.uvt[0];
                           _loc16_.uvt[1] = 1 - _loc18_.v0.uvt[1];
                           _loc16_.uvt[2] = _loc18_.v0.uvt[2];
                           _loc16_.uvt[3] = _loc18_.v1.uvt[0];
                           _loc16_.uvt[4] = 1 - _loc18_.v1.uvt[1];
                           _loc16_.uvt[5] = _loc18_.v1.uvt[2];
                           _loc16_.uvt[6] = _loc18_.v2.uvt[0];
                           _loc16_.uvt[7] = 1 - _loc18_.v2.uvt[1];
                           _loc16_.uvt[8] = _loc18_.v2.uvt[2];
                           _loc16_.isDrawTriangle = true;
                           _loc16_.v0 = _loc10_;
                           _loc16_.v1 = _loc11_;
                           _loc16_.v2 = _loc12_;
                           if(param2.quadrantTree)
                           {
                              if(_loc16_.create == null)
                              {
                                 _loc16_.create = this.createRenderTriangle;
                              }
                              _loc16_.update();
                              if(_loc16_.area < 0 && (_loc14_.material.doubleSided || _loc14_.material.oneSide && _loc14_.material.opposite))
                              {
                                 _loc16_.area = -_loc16_.area;
                              }
                           }
                           param2.renderer.addToRenderList(_loc16_);
                        }
                     }
                  }
                  ++param2.renderStatistics.culledTriangles;
               }
            }
            if(_loc3_)
            {
               while(this.geometry.vertices.length > _loc3_)
               {
                  this.geometry.vertices.pop();
               }
            }
            return this.screenZ = _loc7_ / _loc8_;
         }
         ++param2.renderStatistics.culledObjects;
         return 0;
      }
      
      protected function setScreenZ(param1:uint, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Number
      {
         switch(param1)
         {
            case DisplayObject3D.MESH_SORT_CENTER:
               return (param2.z + param3.z + param4.z) / 3;
            case DisplayObject3D.MESH_SORT_FAR:
               return Math.max(param2.z,param3.z,param4.z);
            case DisplayObject3D.MESH_SORT_CLOSE:
               return Math.min(param2.z,param3.z,param4.z);
            default:
               return 0;
         }
      }
      
      public function projectTexture(param1:String = "x", param2:String = "y") : void
      {
         var _loc10_:* = null;
         var _loc11_:Triangle3D = null;
         var _loc12_:Array = null;
         var _loc13_:Vertex3D = null;
         var _loc14_:Vertex3D = null;
         var _loc15_:Vertex3D = null;
         var _loc16_:NumberUV = null;
         var _loc17_:NumberUV = null;
         var _loc18_:NumberUV = null;
         var _loc3_:Array = this.geometry.faces;
         var _loc4_:Object;
         var _loc5_:Number = (_loc4_ = this.boundingBox()).min[param1];
         var _loc6_:Number = _loc4_.size[param1];
         var _loc7_:Number = _loc4_.min[param2];
         var _loc8_:Number = _loc4_.size[param2];
         var _loc9_:MaterialObject3D = this.material;
         for(_loc10_ in _loc3_)
         {
            _loc13_ = (_loc12_ = (_loc11_ = _loc3_[Number(_loc10_)]).vertices)[0];
            _loc14_ = _loc12_[1];
            _loc15_ = _loc12_[2];
            _loc16_ = new NumberUV((_loc13_[param1] - _loc5_) / _loc6_,(_loc13_[param2] - _loc7_) / _loc8_);
            _loc17_ = new NumberUV((_loc14_[param1] - _loc5_) / _loc6_,(_loc14_[param2] - _loc7_) / _loc8_);
            _loc18_ = new NumberUV((_loc15_[param1] - _loc5_) / _loc6_,(_loc15_[param2] - _loc7_) / _loc8_);
            _loc11_.uv = [_loc16_,_loc17_,_loc18_];
         }
      }
      
      public function quarterFaces() : void
      {
         var _loc4_:Triangle3D = null;
         var _loc6_:Vertex3D = null;
         var _loc7_:Vertex3D = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:Vertex3D = null;
         var _loc11_:Vertex3D = null;
         var _loc12_:NumberUV = null;
         var _loc13_:NumberUV = null;
         var _loc14_:NumberUV = null;
         var _loc15_:NumberUV = null;
         var _loc16_:NumberUV = null;
         var _loc17_:NumberUV = null;
         var _loc18_:Triangle3D = null;
         var _loc19_:Triangle3D = null;
         var _loc20_:Triangle3D = null;
         var _loc21_:Triangle3D = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = this.geometry.faces;
         var _loc5_:int = _loc3_.length;
         while(_loc4_ = _loc3_[--_loc5_])
         {
            _loc6_ = _loc4_.v0;
            _loc7_ = _loc4_.v1;
            _loc8_ = _loc4_.v2;
            _loc9_ = new Vertex3D((_loc6_.x + _loc7_.x) / 2,(_loc6_.y + _loc7_.y) / 2,(_loc6_.z + _loc7_.z) / 2);
            _loc10_ = new Vertex3D((_loc7_.x + _loc8_.x) / 2,(_loc7_.y + _loc8_.y) / 2,(_loc7_.z + _loc8_.z) / 2);
            _loc11_ = new Vertex3D((_loc8_.x + _loc6_.x) / 2,(_loc8_.y + _loc6_.y) / 2,(_loc8_.z + _loc6_.z) / 2);
            this.geometry.vertices.push(_loc9_,_loc10_,_loc11_);
            _loc12_ = _loc4_.uv[0];
            _loc13_ = _loc4_.uv[1];
            _loc14_ = _loc4_.uv[2];
            _loc15_ = new NumberUV((_loc12_.u + _loc13_.u) / 2,(_loc12_.v + _loc13_.v) / 2);
            _loc16_ = new NumberUV((_loc13_.u + _loc14_.u) / 2,(_loc13_.v + _loc14_.v) / 2);
            _loc17_ = new NumberUV((_loc14_.u + _loc12_.u) / 2,(_loc14_.v + _loc12_.v) / 2);
            _loc18_ = new Triangle3D(this,[_loc6_,_loc9_,_loc11_],_loc4_.material,[_loc12_,_loc15_,_loc17_]);
            _loc19_ = new Triangle3D(this,[_loc9_,_loc7_,_loc10_],_loc4_.material,[_loc15_,_loc13_,_loc16_]);
            _loc20_ = new Triangle3D(this,[_loc11_,_loc10_,_loc8_],_loc4_.material,[_loc17_,_loc16_,_loc14_]);
            _loc21_ = new Triangle3D(this,[_loc9_,_loc10_,_loc11_],_loc4_.material,[_loc15_,_loc16_,_loc17_]);
            _loc2_.push(_loc18_,_loc19_,_loc20_,_loc21_);
         }
         this.geometry.faces = _loc2_;
         this.mergeVertices();
         this.geometry.ready = true;
      }
      
      public function mergeVertices() : void
      {
         var _loc3_:Vertex3D = null;
         var _loc4_:Triangle3D = null;
         var _loc5_:Vertex3D = null;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.geometry.vertices)
         {
            for each(_loc5_ in _loc1_)
            {
               if(_loc3_.x == _loc5_.x && _loc3_.y == _loc5_.y && _loc3_.z == _loc5_.z)
               {
                  _loc1_[_loc3_] = _loc5_;
                  break;
               }
            }
            if(!_loc1_[_loc3_])
            {
               _loc1_[_loc3_] = _loc3_;
               _loc2_.push(_loc3_);
            }
         }
         this.geometry.vertices = _loc2_;
         for each(_loc4_ in geometry.faces)
         {
            _loc4_.v0 = _loc4_.vertices[0] = _loc1_[_loc4_.v0];
            _loc4_.v1 = _loc4_.vertices[1] = _loc1_[_loc4_.v1];
            _loc4_.v2 = _loc4_.vertices[2] = _loc1_[_loc4_.v2];
         }
      }
      
      override public function set material(param1:MaterialObject3D) : void
      {
         var _loc2_:Triangle3D = null;
         super.material = param1;
         for each(_loc2_ in geometry.faces)
         {
            _loc2_.material = param1;
         }
      }
      
      public function createRenderTriangle(param1:Triangle3D, param2:MaterialObject3D, param3:Vertex3DInstance, param4:Vertex3DInstance, param5:Vertex3DInstance, param6:NumberUV, param7:NumberUV, param8:NumberUV) : RenderTriangle
      {
         if(this._dtStore.length)
         {
            this._dtActive.push(this._tri = this._dtStore.pop());
         }
         else
         {
            this._dtActive.push(this._tri = new RenderTriangle(param1));
         }
         this._tri.instance = this;
         this._tri.triangle = param1;
         this._tri.renderableInstance = param1;
         this._tri.renderer = param2;
         this._tri.create = this.createRenderTriangle;
         this._tri.v0 = param3;
         this._tri.v1 = param4;
         this._tri.v2 = param5;
         this._tri.uv0 = param6;
         this._tri.uv1 = param7;
         this._tri.uv2 = param8;
         this._tri.update();
         return this._tri;
      }
   }
}
