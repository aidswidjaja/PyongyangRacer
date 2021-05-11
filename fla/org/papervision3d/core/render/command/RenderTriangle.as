package org.papervision3d.core.render.command
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.MovieMaterial;
   
   public class RenderTriangle extends RenderableListItem implements IRenderListItem
   {
      
      protected static var resBA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var resPA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var resRA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var vPoint:Vertex3DInstance = new Vertex3DInstance();
       
      
      private var position:Number3D;
      
      public var triangle:Triangle3D;
      
      public var container:Sprite;
      
      public var renderer:ITriangleDrawer;
      
      public var renderMat:MaterialObject3D;
      
      public var v0:Vertex3DInstance;
      
      public var v1:Vertex3DInstance;
      
      public var v2:Vertex3DInstance;
      
      public var uv0:NumberUV;
      
      public var uv1:NumberUV;
      
      public var uv2:NumberUV;
      
      public var create:Function;
      
      public var isDrawTriangle:Boolean;
      
      public var uvt:Vector.<Number>;
      
      protected var vPointL:Vertex3DInstance;
      
      protected var vx0:Vertex3DInstance;
      
      protected var vx1:Vertex3DInstance;
      
      protected var vx2:Vertex3DInstance;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      private var cx:Number;
      
      private var cy:Number;
      
      private var cz:Number;
      
      private var azf:Number;
      
      private var bzf:Number;
      
      private var czf:Number;
      
      private var faz:Number;
      
      private var fbz:Number;
      
      private var fcz:Number;
      
      private var axf:Number;
      
      private var bxf:Number;
      
      private var cxf:Number;
      
      private var ayf:Number;
      
      private var byf:Number;
      
      private var cyf:Number;
      
      private var det:Number;
      
      private var da:Number;
      
      private var db:Number;
      
      private var dc:Number;
      
      private var au:Number;
      
      private var av:Number;
      
      private var bu:Number;
      
      private var bv:Number;
      
      private var cu:Number;
      
      private var cv:Number;
      
      private var v01:Vertex3DInstance;
      
      private var v12:Vertex3DInstance;
      
      private var v20:Vertex3DInstance;
      
      private var uv01:NumberUV;
      
      private var uv12:NumberUV;
      
      private var uv20:NumberUV;
      
      public function RenderTriangle(param1:Triangle3D)
      {
         this.position = new Number3D();
         super();
         this.triangle = param1;
         this.instance = param1.instance;
         renderableInstance = param1;
         renderable = Triangle3D;
         this.v0 = param1.v0.vertex3DInstance;
         this.v1 = param1.v1.vertex3DInstance;
         this.v2 = param1.v2.vertex3DInstance;
         this.uv0 = param1.uv0;
         this.uv1 = param1.uv1;
         this.uv2 = param1.uv2;
         this.renderer = param1.material;
         this.isDrawTriangle = false;
         this.update();
      }
      
      override public function render(param1:RenderSessionData, param2:Graphics) : void
      {
         this.renderer.drawTriangle(this,param2,param1);
      }
      
      override public function hitTestPoint2D(param1:Point, param2:RenderHitData) : RenderHitData
      {
         this.renderMat = this.triangle.material;
         if(!this.renderMat)
         {
            this.renderMat = this.triangle.instance.material;
         }
         if(this.renderMat && this.renderMat.interactive)
         {
            this.vPointL = RenderTriangle.vPoint;
            this.vPointL.x = param1.x;
            this.vPointL.y = param1.y;
            this.vx0 = this.triangle.v0.vertex3DInstance;
            this.vx1 = this.triangle.v1.vertex3DInstance;
            this.vx2 = this.triangle.v2.vertex3DInstance;
            if(this.sameSide(this.vPointL,this.vx0,this.vx1,this.vx2))
            {
               if(this.sameSide(this.vPointL,this.vx1,this.vx0,this.vx2))
               {
                  if(this.sameSide(this.vPointL,this.vx2,this.vx0,this.vx1))
                  {
                     return this.deepHitTest(this.triangle,this.vPointL,param2);
                  }
               }
            }
         }
         return param2;
      }
      
      public function sameSide(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Boolean
      {
         Vertex3DInstance.subTo(param4,param3,resBA);
         Vertex3DInstance.subTo(param1,param3,resPA);
         Vertex3DInstance.subTo(param2,param3,resRA);
         return Vertex3DInstance.cross(resBA,resPA) * Vertex3DInstance.cross(resBA,resRA) >= 0;
      }
      
      private function deepHitTest(param1:Triangle3D, param2:Vertex3DInstance, param3:RenderHitData) : RenderHitData
      {
         var _loc44_:MovieMaterial = null;
         var _loc45_:Rectangle = null;
         var _loc4_:Vertex3DInstance = param1.v0.vertex3DInstance;
         var _loc5_:Vertex3DInstance = param1.v1.vertex3DInstance;
         var _loc6_:Vertex3DInstance;
         var _loc7_:Number = (_loc6_ = param1.v2.vertex3DInstance).x - _loc4_.x;
         var _loc8_:Number = _loc6_.y - _loc4_.y;
         var _loc9_:Number = _loc5_.x - _loc4_.x;
         var _loc10_:Number = _loc5_.y - _loc4_.y;
         var _loc11_:Number = param2.x - _loc4_.x;
         var _loc12_:Number = param2.y - _loc4_.y;
         var _loc13_:Number = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc14_:Number = _loc7_ * _loc9_ + _loc8_ * _loc10_;
         var _loc15_:Number = _loc7_ * _loc11_ + _loc8_ * _loc12_;
         var _loc16_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_;
         var _loc17_:Number = _loc9_ * _loc11_ + _loc10_ * _loc12_;
         var _loc18_:Number = 1 / (_loc13_ * _loc16_ - _loc14_ * _loc14_);
         var _loc19_:Number = (_loc16_ * _loc15_ - _loc14_ * _loc17_) * _loc18_;
         var _loc20_:Number = (_loc13_ * _loc17_ - _loc14_ * _loc15_) * _loc18_;
         var _loc21_:Number = param1.v2.x - param1.v0.x;
         var _loc22_:Number = param1.v2.y - param1.v0.y;
         var _loc23_:Number = param1.v2.z - param1.v0.z;
         var _loc24_:Number = param1.v1.x - param1.v0.x;
         var _loc25_:Number = param1.v1.y - param1.v0.y;
         var _loc26_:Number = param1.v1.z - param1.v0.z;
         var _loc27_:Number = param1.v0.x + _loc21_ * _loc19_ + _loc24_ * _loc20_;
         var _loc28_:Number = param1.v0.y + _loc22_ * _loc19_ + _loc25_ * _loc20_;
         var _loc29_:Number = param1.v0.z + _loc23_ * _loc19_ + _loc26_ * _loc20_;
         var _loc30_:Array;
         var _loc31_:Number = (_loc30_ = param1.uv)[0].u;
         var _loc32_:Number = _loc30_[1].u;
         var _loc33_:Number = _loc30_[2].u;
         var _loc34_:Number = _loc30_[0].v;
         var _loc35_:Number = _loc30_[1].v;
         var _loc36_:Number = _loc30_[2].v;
         var _loc37_:Number = (_loc32_ - _loc31_) * _loc20_ + (_loc33_ - _loc31_) * _loc19_ + _loc31_;
         var _loc38_:Number = (_loc35_ - _loc34_) * _loc20_ + (_loc36_ - _loc34_) * _loc19_ + _loc34_;
         if(this.triangle.material)
         {
            this.renderMat = param1.material;
         }
         else
         {
            this.renderMat = param1.instance.material;
         }
         var _loc39_:BitmapData = this.renderMat.bitmap;
         var _loc40_:Number = 1;
         var _loc41_:Number = 1;
         var _loc42_:Number = 0;
         var _loc43_:Number = 0;
         if(this.renderMat is MovieMaterial)
         {
            if(_loc45_ = (_loc44_ = this.renderMat as MovieMaterial).rect)
            {
               _loc42_ = _loc45_.x;
               _loc43_ = _loc45_.y;
               _loc40_ = _loc45_.width;
               _loc41_ = _loc45_.height;
            }
         }
         else if(_loc39_)
         {
            _loc40_ = !!BitmapMaterial.AUTO_MIP_MAPPING ? Number(this.renderMat.widthOffset) : Number(_loc39_.width);
            _loc41_ = !!BitmapMaterial.AUTO_MIP_MAPPING ? Number(this.renderMat.heightOffset) : Number(_loc39_.height);
         }
         param3.displayObject3D = param1.instance;
         param3.material = this.renderMat;
         param3.renderable = param1;
         param3.hasHit = true;
         this.position.x = _loc27_;
         this.position.y = _loc28_;
         this.position.z = _loc29_;
         Matrix3D.multiplyVector(param1.instance.world,this.position);
         param3.x = this.position.x;
         param3.y = this.position.y;
         param3.z = this.position.z;
         param3.u = _loc37_ * _loc40_ + _loc42_;
         param3.v = _loc41_ - _loc38_ * _loc41_ + _loc43_;
         return param3;
      }
      
      override public function update() : void
      {
         if(this.v0.x > this.v1.x)
         {
            if(this.v0.x > this.v2.x)
            {
               maxX = this.v0.x;
            }
            else
            {
               maxX = this.v2.x;
            }
         }
         else if(this.v1.x > this.v2.x)
         {
            maxX = this.v1.x;
         }
         else
         {
            maxX = this.v2.x;
         }
         if(this.v0.x < this.v1.x)
         {
            if(this.v0.x < this.v2.x)
            {
               minX = this.v0.x;
            }
            else
            {
               minX = this.v2.x;
            }
         }
         else if(this.v1.x < this.v2.x)
         {
            minX = this.v1.x;
         }
         else
         {
            minX = this.v2.x;
         }
         if(this.v0.y > this.v1.y)
         {
            if(this.v0.y > this.v2.y)
            {
               maxY = this.v0.y;
            }
            else
            {
               maxY = this.v2.y;
            }
         }
         else if(this.v1.y > this.v2.y)
         {
            maxY = this.v1.y;
         }
         else
         {
            maxY = this.v2.y;
         }
         if(this.v0.y < this.v1.y)
         {
            if(this.v0.y < this.v2.y)
            {
               minY = this.v0.y;
            }
            else
            {
               minY = this.v2.y;
            }
         }
         else if(this.v1.y < this.v2.y)
         {
            minY = this.v1.y;
         }
         else
         {
            minY = this.v2.y;
         }
         if(this.v0.z > this.v1.z)
         {
            if(this.v0.z > this.v2.z)
            {
               maxZ = this.v0.z;
            }
            else
            {
               maxZ = this.v2.z;
            }
         }
         else if(this.v1.z > this.v2.z)
         {
            maxZ = this.v1.z;
         }
         else
         {
            maxZ = this.v2.z;
         }
         if(this.v0.z < this.v1.z)
         {
            if(this.v0.z < this.v2.z)
            {
               minZ = this.v0.z;
            }
            else
            {
               minZ = this.v2.z;
            }
         }
         else if(this.v1.z < this.v2.z)
         {
            minZ = this.v1.z;
         }
         else
         {
            minZ = this.v2.z;
         }
         screenZ = (this.v0.z + this.v1.z + this.v2.z) / 3;
         area = 0.5 * (this.v0.x * (this.v2.y - this.v1.y) + this.v1.x * (this.v0.y - this.v2.y) + this.v2.x * (this.v1.y - this.v0.y));
      }
      
      public function fivepointcut(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance, param5:Vertex3DInstance, param6:NumberUV, param7:NumberUV, param8:NumberUV, param9:NumberUV, param10:NumberUV) : Array
      {
         if(param1.distanceSqr(param4) < param2.distanceSqr(param5))
         {
            return [this.create(renderableInstance,this.renderer,param1,param2,param4,param6,param7,param9),this.create(renderableInstance,this.renderer,param2,param3,param4,param7,param8,param9),this.create(renderableInstance,this.renderer,param1,param4,param5,param6,param9,param10)];
         }
         return [this.create(renderableInstance,this.renderer,param1,param2,param5,param6,param7,param10),this.create(renderableInstance,this.renderer,param2,param3,param4,param7,param8,param9),this.create(renderableInstance,this.renderer,param2,param4,param5,param7,param9,param10)];
      }
      
      override public final function getZ(param1:Number, param2:Number, param3:Number) : Number
      {
         this.ax = this.v0.x;
         this.ay = this.v0.y;
         this.az = this.v0.z;
         this.bx = this.v1.x;
         this.by = this.v1.y;
         this.bz = this.v1.z;
         this.cx = this.v2.x;
         this.cy = this.v2.y;
         this.cz = this.v2.z;
         if(this.ax == param1 && this.ay == param2)
         {
            return this.az;
         }
         if(this.bx == param1 && this.by == param2)
         {
            return this.bz;
         }
         if(this.cx == param1 && this.cy == param2)
         {
            return this.cz;
         }
         this.azf = this.az / param3;
         this.bzf = this.bz / param3;
         this.czf = this.cz / param3;
         this.faz = 1 + this.azf;
         this.fbz = 1 + this.bzf;
         this.fcz = 1 + this.czf;
         this.axf = this.ax * this.faz - param1 * this.azf;
         this.bxf = this.bx * this.fbz - param1 * this.bzf;
         this.cxf = this.cx * this.fcz - param1 * this.czf;
         this.ayf = this.ay * this.faz - param2 * this.azf;
         this.byf = this.by * this.fbz - param2 * this.bzf;
         this.cyf = this.cy * this.fcz - param2 * this.czf;
         this.det = this.axf * (this.byf - this.cyf) + this.bxf * (this.cyf - this.ayf) + this.cxf * (this.ayf - this.byf);
         this.da = param1 * (this.byf - this.cyf) + this.bxf * (this.cyf - param2) + this.cxf * (param2 - this.byf);
         this.db = this.axf * (param2 - this.cyf) + param1 * (this.cyf - this.ayf) + this.cxf * (this.ayf - param2);
         this.dc = this.axf * (this.byf - param2) + this.bxf * (param2 - this.ayf) + param1 * (this.ayf - this.byf);
         return (this.da * this.az + this.db * this.bz + this.dc * this.cz) / this.det;
      }
      
      override public final function quarter(param1:Number) : Array
      {
         if(area < 20)
         {
            return null;
         }
         this.v01 = Vertex3DInstance.median(this.v0,this.v1,param1);
         this.v12 = Vertex3DInstance.median(this.v1,this.v2,param1);
         this.v20 = Vertex3DInstance.median(this.v2,this.v0,param1);
         this.uv01 = NumberUV.median(this.uv0,this.uv1);
         this.uv12 = NumberUV.median(this.uv1,this.uv2);
         this.uv20 = NumberUV.median(this.uv2,this.uv0);
         return [this.create(renderableInstance,this.renderer,this.v0,this.v01,this.v20,this.uv0,this.uv01,this.uv20),this.create(renderableInstance,this.renderer,this.v1,this.v12,this.v01,this.uv1,this.uv12,this.uv01),this.create(renderableInstance,this.renderer,this.v2,this.v20,this.v12,this.uv2,this.uv20,this.uv12),this.create(renderableInstance,this.renderer,this.v01,this.v12,this.v20,this.uv01,this.uv12,this.uv20)];
      }
   }
}
