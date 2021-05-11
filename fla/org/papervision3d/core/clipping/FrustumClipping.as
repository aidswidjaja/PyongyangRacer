package org.papervision3d.core.clipping
{
   import org.papervision3d.core.dyn.DynamicTriangles;
   import org.papervision3d.core.dyn.DynamicUVs;
   import org.papervision3d.core.dyn.DynamicVertices;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.math.Plane3D;
   import org.papervision3d.core.math.util.ClassificationUtil;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class FrustumClipping extends DefaultClipping
   {
      
      public static const NONE:int = 0;
      
      public static const NEAR:int = 1;
      
      public static const LEFT:int = 2;
      
      public static const RIGHT:int = 4;
      
      public static const TOP:int = 8;
      
      public static const BOTTOM:int = 16;
      
      public static const FAR:int = 32;
      
      public static const DEFAULT:int = NEAR + LEFT + RIGHT + TOP + BOTTOM;
      
      public static const ALL:int = DEFAULT + FAR;
      
      private static const OUTSIDE:uint = 0;
      
      private static const INSIDE:uint = 1;
      
      private static const OUT_IN:uint = 2;
      
      private static const IN_OUT:uint = 3;
      
      private static const TO_DEGREES:Number = 180 / Math.PI;
      
      private static const TO_RADIANS:Number = Math.PI / 180;
       
      
      public var vertex_buffer:DynamicVertices;
      
      public var uv_buffer:DynamicUVs;
      
      private var _planes:int;
      
      private var _cnear:Plane3D;
      
      private var _cfar:Plane3D;
      
      private var _ctop:Plane3D;
      
      private var _cbottom:Plane3D;
      
      private var _cleft:Plane3D;
      
      private var _cright:Plane3D;
      
      private var _wnear:Plane3D;
      
      private var _wfar:Plane3D;
      
      private var _wtop:Plane3D;
      
      private var _wbottom:Plane3D;
      
      private var _wleft:Plane3D;
      
      private var _wright:Plane3D;
      
      private var _nc:Number3D;
      
      private var _fc:Number3D;
      
      private var _ntl:Number3D;
      
      private var _ntr:Number3D;
      
      private var _nbr:Number3D;
      
      private var _nbl:Number3D;
      
      private var _ftl:Number3D;
      
      private var _ftr:Number3D;
      
      private var _fbr:Number3D;
      
      private var _fbl:Number3D;
      
      private var _camPos:Number3D;
      
      private var _axisX:Number3D;
      
      private var _axisY:Number3D;
      
      private var _axisZ:Number3D;
      
      private var _axisZi:Number3D;
      
      private var _cplanes:Array;
      
      private var _wplanes:Array;
      
      private var _matrix:Matrix3D;
      
      private var _world:Matrix3D;
      
      private var _planePoints:Array;
      
      private var _dynTriangles:DynamicTriangles;
      
      public function FrustumClipping(param1:int = -1)
      {
         this.vertex_buffer = new DynamicVertices();
         this.uv_buffer = new DynamicUVs();
         super();
         this._cleft = Plane3D.fromCoefficients(0,1,0,0);
         this._cright = Plane3D.fromCoefficients(0,1,0,0);
         this._ctop = Plane3D.fromCoefficients(0,1,0,0);
         this._cbottom = Plane3D.fromCoefficients(0,1,0,0);
         this._cnear = Plane3D.fromCoefficients(0,1,0,0);
         this._cfar = Plane3D.fromCoefficients(0,1,0,0);
         this._wleft = Plane3D.fromCoefficients(0,1,0,0);
         this._wright = Plane3D.fromCoefficients(0,1,0,0);
         this._wtop = Plane3D.fromCoefficients(0,1,0,0);
         this._wbottom = Plane3D.fromCoefficients(0,1,0,0);
         this._wnear = Plane3D.fromCoefficients(0,1,0,0);
         this._wfar = Plane3D.fromCoefficients(0,1,0,0);
         this._nc = new Number3D();
         this._fc = new Number3D();
         this._ntl = new Number3D();
         this._ntr = new Number3D();
         this._nbr = new Number3D();
         this._nbl = new Number3D();
         this._ftl = new Number3D();
         this._ftr = new Number3D();
         this._fbr = new Number3D();
         this._fbl = new Number3D();
         this._camPos = new Number3D();
         this._axisX = new Number3D();
         this._axisY = new Number3D();
         this._axisZ = new Number3D();
         this._axisZi = new Number3D();
         this._matrix = Matrix3D.IDENTITY;
         this._world = Matrix3D.IDENTITY;
         this._dynTriangles = new DynamicTriangles();
         this.planes = param1 < 0 ? int(DEFAULT) : int(param1);
      }
      
      public function get planes() : int
      {
         return this._planes;
      }
      
      public function set planes(param1:int) : void
      {
         this._planes = param1;
         this._cplanes = new Array();
         this._wplanes = new Array();
         this._planePoints = new Array();
         if(this._planes & NEAR)
         {
            this._cplanes.push(this._cnear);
            this._wplanes.push(this._wnear);
            this._planePoints.push(this._nc);
         }
         if(this._planes & FAR)
         {
            this._cplanes.push(this._cfar);
            this._wplanes.push(this._wfar);
            this._planePoints.push(this._fc);
         }
         if(this._planes & LEFT)
         {
            this._cplanes.push(this._cleft);
            this._wplanes.push(this._wleft);
            this._planePoints.push(this._camPos);
         }
         if(this._planes & RIGHT)
         {
            this._cplanes.push(this._cright);
            this._wplanes.push(this._wright);
            this._planePoints.push(this._camPos);
         }
         if(this._planes & TOP)
         {
            this._cplanes.push(this._ctop);
            this._wplanes.push(this._wtop);
            this._planePoints.push(this._camPos);
         }
         if(this._planes & BOTTOM)
         {
            this._cplanes.push(this._cbottom);
            this._wplanes.push(this._wbottom);
            this._planePoints.push(this._camPos);
         }
      }
      
      override public function reset(param1:RenderSessionData) : void
      {
         var _loc2_:CameraObject3D = param1.camera;
         var _loc3_:Number = param1.viewPort.viewportWidth;
         var _loc4_:Number = param1.viewPort.viewportHeight;
         var _loc5_:Number = Math.tan(_loc2_.fov / 2 * TO_RADIANS);
         var _loc6_:Number = 0.001;
         this._matrix.copy(param1.camera.transform);
         this._axisX.reset(this._matrix.n11,this._matrix.n21,this._matrix.n31);
         this._axisY.reset(this._matrix.n12,this._matrix.n22,this._matrix.n32);
         this._axisZ.reset(this._matrix.n13,this._matrix.n23,this._matrix.n33);
         this._axisZi.reset(-this._axisZ.x,-this._axisZ.y,-this._axisZ.z);
         var _loc7_:Number;
         var _loc8_:Number = (_loc7_ = 2 * _loc5_ * _loc6_) * (_loc3_ / _loc4_);
         this._camPos.reset(_loc2_.x,_loc2_.y,_loc2_.z);
         this._nc.x = this._camPos.x + _loc6_ * this._axisZ.x;
         this._nc.y = this._camPos.y + _loc6_ * this._axisZ.y;
         this._nc.z = this._camPos.z + _loc6_ * this._axisZ.z;
         this._fc.x = this._camPos.x + _loc2_.far * this._axisZ.x;
         this._fc.y = this._camPos.y + _loc2_.far * this._axisZ.y;
         this._fc.z = this._camPos.z + _loc2_.far * this._axisZ.z;
         this._ntl.copyFrom(this._nc);
         this._nbl.copyFrom(this._nc);
         this._ntr.copyFrom(this._nc);
         this._nbr.copyFrom(this._nc);
         _loc7_ /= 2;
         _loc8_ /= 2;
         this._ntl.x -= _loc8_ * this._axisX.x;
         this._ntl.y -= _loc8_ * this._axisX.y;
         this._ntl.z -= _loc8_ * this._axisX.z;
         this._ntl.x += _loc7_ * this._axisY.x;
         this._ntl.y += _loc7_ * this._axisY.y;
         this._ntl.z += _loc7_ * this._axisY.z;
         this._nbl.x -= _loc8_ * this._axisX.x;
         this._nbl.y -= _loc8_ * this._axisX.y;
         this._nbl.z -= _loc8_ * this._axisX.z;
         this._nbl.x -= _loc7_ * this._axisY.x;
         this._nbl.y -= _loc7_ * this._axisY.y;
         this._nbl.z -= _loc7_ * this._axisY.z;
         this._nbr.x += _loc8_ * this._axisX.x;
         this._nbr.y += _loc8_ * this._axisX.y;
         this._nbr.z += _loc8_ * this._axisX.z;
         this._nbr.x -= _loc7_ * this._axisY.x;
         this._nbr.y -= _loc7_ * this._axisY.y;
         this._nbr.z -= _loc7_ * this._axisY.z;
         this._ntr.x += _loc8_ * this._axisX.x;
         this._ntr.y += _loc8_ * this._axisX.y;
         this._ntr.z += _loc8_ * this._axisX.z;
         this._ntr.x += _loc7_ * this._axisY.x;
         this._ntr.y += _loc7_ * this._axisY.y;
         this._ntr.z += _loc7_ * this._axisY.z;
         if(this._planes & NEAR)
         {
            this._cnear.setNormalAndPoint(this._axisZ,this._nc);
         }
         if(this._planes & FAR)
         {
            this._cfar.setNormalAndPoint(this._axisZi,this._fc);
         }
         if(this._planes & LEFT)
         {
            this._cleft.setThreePoints(this._camPos,this._nbl,this._ntl);
         }
         if(this._planes & RIGHT)
         {
            this._cright.setThreePoints(this._camPos,this._ntr,this._nbr);
         }
         if(this._planes & TOP)
         {
            this._ctop.setThreePoints(this._camPos,this._ntl,this._ntr);
         }
         if(this._planes & BOTTOM)
         {
            this._cbottom.setThreePoints(this._camPos,this._nbr,this._nbl);
         }
         this._dynTriangles.releaseAll();
         this.vertex_buffer.releaseAll();
         this.uv_buffer.releaseAll();
      }
      
      override public function setDisplayObject(param1:DisplayObject3D, param2:RenderSessionData) : void
      {
         var _loc5_:Plane3D = null;
         var _loc6_:Plane3D = null;
         this._world.copy(param1.world);
         this._world.invert();
         var _loc3_:Number3D = new Number3D();
         var _loc4_:int = 0;
         while(_loc4_ < this._cplanes.length)
         {
            _loc5_ = this._cplanes[_loc4_];
            _loc6_ = this._wplanes[_loc4_];
            _loc3_.copyFrom(this._planePoints[_loc4_]);
            _loc6_.normal.copyFrom(_loc5_.normal);
            Matrix3D.multiplyVector3x3(this._world,_loc6_.normal);
            Matrix3D.multiplyVector(this._world,_loc3_);
            _loc6_.setNormalAndPoint(_loc6_.normal,_loc3_);
            _loc4_++;
         }
      }
      
      override public function testFace(param1:Triangle3D, param2:DisplayObject3D, param3:RenderSessionData) : Boolean
      {
         var _loc5_:Plane3D = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this._wplanes.length)
         {
            _loc5_ = this._wplanes[_loc4_];
            if((_loc6_ = ClassificationUtil.classifyTriangle(param1,_loc5_)) == ClassificationUtil.BACK || _loc6_ == ClassificationUtil.COINCIDING)
            {
               return false;
            }
            if(_loc6_ == ClassificationUtil.STRADDLE)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      override public function testTerrainFace(param1:Triangle3D, param2:DisplayObject3D, param3:RenderSessionData) : Boolean
      {
         var _loc5_:Plane3D = null;
         var _loc6_:int = 0;
         var _loc4_:int = 1;
         while(_loc4_ < this._wplanes.length)
         {
            _loc5_ = this._wplanes[_loc4_];
            if((_loc6_ = ClassificationUtil.classifyTriangle(param1,_loc5_)) == ClassificationUtil.BACK || _loc6_ == ClassificationUtil.COINCIDING)
            {
               return false;
            }
            if(_loc6_ == ClassificationUtil.STRADDLE)
            {
               return true;
            }
            _loc4_++;
         }
         return true;
      }
      
      override public function clipFace(param1:Triangle3D, param2:DisplayObject3D, param3:MaterialObject3D, param4:RenderSessionData, param5:Array) : Number
      {
         var plane:Plane3D = null;
         var side:int = 0;
         var k:int = 0;
         var v1:Vertex3D = null;
         var v2:Vertex3D = null;
         var t1:NumberUV = null;
         var t2:NumberUV = null;
         var tri:Triangle3D = null;
         var triangle:Triangle3D = param1;
         var object:DisplayObject3D = param2;
         var material:MaterialObject3D = param3;
         var renderSessionData:RenderSessionData = param4;
         var outputArray:Array = param5;
         var points:Array = [triangle.v0,triangle.v1,triangle.v2];
         var uvs:Array = [triangle.uv0,triangle.uv1,triangle.uv2];
         var clipped:Boolean = false;
         var i:int = 0;
         for(; i < this._wplanes.length; i++)
         {
            plane = this._wplanes[i];
            side = ClassificationUtil.classifyPoints(points,plane);
            try
            {
               if(side == ClassificationUtil.STRADDLE)
               {
                  points = this.clipPointsToPlane(triangle.instance,points,uvs,plane);
                  clipped = true;
               }
            }
            catch(e:Error)
            {
               PaperLogger.error("FrustumClipping#clipFace : " + e.message);
               continue;
            }
         }
         if(!clipped)
         {
            outputArray.push(triangle);
            return 1;
         }
         var v0:Vertex3D = points[0];
         var t0:NumberUV = uvs[0];
         var j:int = 1;
         while(j < points.length)
         {
            k = (j + 1) % points.length;
            v1 = points[j];
            v2 = points[k];
            t1 = uvs[j];
            t2 = uvs[k];
            tri = this._dynTriangles.getTriangle(triangle.instance,triangle.material,v0,v1,v2,t0,t1,t2);
            if(tri.faceNormal.modulo)
            {
               outputArray.push(tri);
            }
            j++;
         }
         return outputArray.length;
      }
      
      public function clipPointsToPlane(param1:DisplayObject3D, param2:Array, param3:Array, param4:Plane3D) : Array
      {
         var _loc10_:int = 0;
         var _loc11_:Vertex3D = null;
         var _loc12_:Vertex3D = null;
         var _loc13_:NumberUV = null;
         var _loc14_:NumberUV = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Vertex3D = null;
         var _loc18_:NumberUV = null;
         var _loc19_:uint = 0;
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Number = param4.distance(param2[0]);
         var _loc8_:int = 0;
         while(_loc8_ < param2.length)
         {
            _loc10_ = (_loc8_ + 1) % param2.length;
            _loc11_ = param2[_loc8_];
            _loc12_ = param2[_loc10_];
            _loc13_ = param3[_loc8_];
            _loc14_ = param3[_loc10_];
            _loc15_ = param4.distance(_loc12_);
            _loc16_ = _loc7_ / (_loc7_ - _loc15_);
            _loc19_ = this.compareDistances(_loc7_,_loc15_);
            switch(_loc19_)
            {
               case INSIDE:
                  _loc5_.push(_loc12_);
                  _loc6_.push(_loc14_);
                  break;
               case IN_OUT:
                  (_loc17_ = this.vertex_buffer.getVertex()).x = _loc11_.x + (_loc12_.x - _loc11_.x) * _loc16_;
                  _loc17_.y = _loc11_.y + (_loc12_.y - _loc11_.y) * _loc16_;
                  _loc17_.z = _loc11_.z + (_loc12_.z - _loc11_.z) * _loc16_;
                  (_loc18_ = this.uv_buffer.getUV()).u = _loc13_.u + (_loc14_.u - _loc13_.u) * _loc16_;
                  _loc18_.v = _loc13_.v + (_loc14_.v - _loc13_.v) * _loc16_;
                  _loc6_.push(_loc18_);
                  _loc5_.push(_loc17_);
                  param1.geometry.vertices.push(_loc17_);
                  break;
               case OUT_IN:
                  (_loc18_ = this.uv_buffer.getUV()).u = _loc13_.u + (_loc14_.u - _loc13_.u) * _loc16_;
                  _loc18_.v = _loc13_.v + (_loc14_.v - _loc13_.v) * _loc16_;
                  _loc6_.push(_loc18_);
                  _loc6_.push(_loc14_);
                  (_loc17_ = this.vertex_buffer.getVertex()).x = _loc11_.x + (_loc12_.x - _loc11_.x) * _loc16_;
                  _loc17_.y = _loc11_.y + (_loc12_.y - _loc11_.y) * _loc16_;
                  _loc17_.z = _loc11_.z + (_loc12_.z - _loc11_.z) * _loc16_;
                  _loc5_.push(_loc17_);
                  _loc5_.push(_loc12_);
                  param1.geometry.vertices.push(_loc17_);
                  break;
            }
            _loc7_ = _loc15_;
            _loc8_++;
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_.length)
         {
            param3[_loc9_] = _loc6_[_loc9_];
            _loc9_++;
         }
         return _loc5_;
      }
      
      override public function clipTerrainFace(param1:Triangle3D, param2:DisplayObject3D, param3:MaterialObject3D, param4:RenderSessionData, param5:Array) : Number
      {
         var plane:Plane3D = null;
         var side:int = 0;
         var k:int = 0;
         var v1:Vertex3D = null;
         var v2:Vertex3D = null;
         var t1:NumberUV = null;
         var t2:NumberUV = null;
         var tri:Triangle3D = null;
         var triangle:Triangle3D = param1;
         var object:DisplayObject3D = param2;
         var material:MaterialObject3D = param3;
         var renderSessionData:RenderSessionData = param4;
         var outputArray:Array = param5;
         var points:Array = [triangle.v0,triangle.v1,triangle.v2];
         var uvs:Array = [triangle.uv0,triangle.uv1,triangle.uv2];
         var clipped:Boolean = false;
         var i:int = 0;
         for(; i < 1; i++)
         {
            plane = this._wplanes[i];
            side = ClassificationUtil.classifyPoints(points,plane);
            try
            {
               if(side == ClassificationUtil.STRADDLE)
               {
                  points = this.clipPointsToPlanes(triangle.instance,points,uvs,plane,renderSessionData);
                  clipped = true;
               }
            }
            catch(e:Error)
            {
               PaperLogger.error("FrustumClipping#clipFace : " + e.message);
               continue;
            }
         }
         if(!clipped)
         {
            outputArray.push(triangle);
            return 1;
         }
         var v0:Vertex3D = points[0];
         var t0:NumberUV = uvs[0];
         var j:int = 1;
         while(j < points.length)
         {
            k = (j + 1) % points.length;
            v1 = points[j];
            v2 = points[k];
            t1 = uvs[j];
            t2 = uvs[k];
            tri = this._dynTriangles.getTriangle(triangle.instance,triangle.material,v0,v1,v2,t0,t1,t2);
            if(tri.faceNormal.modulo)
            {
               outputArray.push(tri);
            }
            j++;
         }
         return outputArray.length;
      }
      
      public function clipPointsToPlanes(param1:DisplayObject3D, param2:Array, param3:Array, param4:Plane3D, param5:RenderSessionData) : Array
      {
         var _loc11_:int = 0;
         var _loc12_:Vertex3D = null;
         var _loc13_:Vertex3D = null;
         var _loc14_:NumberUV = null;
         var _loc15_:NumberUV = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Vertex3D = null;
         var _loc19_:NumberUV = null;
         var _loc20_:uint = 0;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Number = param4.distance(param2[0]);
         var _loc9_:int = 0;
         while(_loc9_ < param2.length)
         {
            _loc11_ = (_loc9_ + 1) % param2.length;
            _loc12_ = param2[_loc9_];
            _loc13_ = param2[_loc11_];
            _loc14_ = param3[_loc9_];
            _loc15_ = param3[_loc11_];
            _loc16_ = param4.distance(_loc13_);
            _loc17_ = _loc8_ / (_loc8_ - _loc16_);
            _loc20_ = this.compareDistances(_loc8_,_loc16_);
            switch(_loc20_)
            {
               case INSIDE:
                  _loc6_.push(_loc13_);
                  _loc7_.push(_loc15_);
                  break;
               case IN_OUT:
                  (_loc18_ = this.vertex_buffer.getVertex()).x = _loc12_.x + (_loc13_.x - _loc12_.x) * _loc17_;
                  _loc18_.y = _loc12_.y + (_loc13_.y - _loc12_.y) * _loc17_;
                  _loc18_.z = _loc12_.z + (_loc13_.z - _loc12_.z) * _loc17_;
                  (_loc19_ = new NumberUV()).u = _loc12_.uvt[0] + (_loc13_.uvt[0] - _loc12_.uvt[0]) * _loc17_;
                  _loc19_.v = _loc12_.uvt[1] + (_loc13_.uvt[1] - _loc12_.uvt[1]) * _loc17_;
                  _loc7_.push(_loc19_);
                  _loc6_.push(_loc18_);
                  param5.camera.projectVertex(_loc18_,param1,param5,_loc19_);
                  param1.geometry.vertices.push(_loc18_);
                  break;
               case OUT_IN:
                  (_loc19_ = this.uv_buffer.getUV()).u = _loc12_.uvt[0] + (_loc13_.uvt[0] - _loc12_.uvt[0]) * _loc17_;
                  _loc19_.v = _loc12_.uvt[1] + (_loc13_.uvt[1] - _loc12_.uvt[1]) * _loc17_;
                  _loc7_.push(_loc19_);
                  _loc7_.push(_loc15_);
                  (_loc18_ = this.vertex_buffer.getVertex()).x = _loc12_.x + (_loc13_.x - _loc12_.x) * _loc17_;
                  _loc18_.y = _loc12_.y + (_loc13_.y - _loc12_.y) * _loc17_;
                  _loc18_.z = _loc12_.z + (_loc13_.z - _loc12_.z) * _loc17_;
                  _loc6_.push(_loc18_);
                  _loc6_.push(_loc13_);
                  param5.camera.projectVertex(_loc18_,param1,param5,_loc19_);
                  param1.geometry.vertices.push(_loc18_);
                  break;
            }
            _loc8_ = _loc16_;
            _loc9_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_.length)
         {
            param3[_loc10_] = _loc7_[_loc10_];
            _loc10_++;
         }
         return _loc6_;
      }
      
      private function compareDistances(param1:Number, param2:Number) : uint
      {
         if(param1 < 0 && param2 < 0)
         {
            return OUTSIDE;
         }
         if(param1 > 0 && param2 > 0)
         {
            return INSIDE;
         }
         if(param1 > 0 && param2 < 0)
         {
            return IN_OUT;
         }
         return OUT_IN;
      }
   }
}
