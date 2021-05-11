package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.materials.utils.PrecisionMode;
   import org.papervision3d.materials.utils.RenderRecStorage;
   
   public class BitmapMaterial extends TriangleMaterial implements ITriangleDrawer
   {
      
      protected static const DEFAULT_FOCUS:Number = 200;
      
      protected static var hitRect:Rectangle = new Rectangle();
      
      public static var AUTO_MIP_MAPPING:Boolean = false;
      
      public static var MIP_MAP_DEPTH:Number = 8;
      
      protected static var _triMatrix:Matrix = new Matrix();
      
      protected static var _triMap:Matrix;
      
      protected static var _localMatrix:Matrix = new Matrix();
       
      
      protected var renderRecStorage:Array;
      
      protected var focus:Number = 200;
      
      protected var _precise:Boolean;
      
      protected var _precision:int = 8;
      
      protected var _perPixelPrecision:int = 8;
      
      public var minimumRenderSize:Number = 4;
      
      public var dSided:Boolean = false;
      
      protected var _texture:Object;
      
      public var precisionMode:int;
      
      public var uvMatrices:Dictionary;
      
      private var x0:Number;
      
      private var y0:Number;
      
      private var x1:Number;
      
      private var y1:Number;
      
      private var x2:Number;
      
      private var y2:Number;
      
      protected var ax:Number;
      
      protected var ay:Number;
      
      protected var az:Number;
      
      protected var bx:Number;
      
      protected var by:Number;
      
      protected var bz:Number;
      
      protected var cx:Number;
      
      protected var cy:Number;
      
      protected var cz:Number;
      
      protected var faz:Number;
      
      protected var fbz:Number;
      
      protected var fcz:Number;
      
      protected var mabz:Number;
      
      protected var mbcz:Number;
      
      protected var mcaz:Number;
      
      protected var mabx:Number;
      
      protected var maby:Number;
      
      protected var mbcx:Number;
      
      protected var mbcy:Number;
      
      protected var mcax:Number;
      
      protected var mcay:Number;
      
      protected var dabx:Number;
      
      protected var daby:Number;
      
      protected var dbcx:Number;
      
      protected var dbcy:Number;
      
      protected var dcax:Number;
      
      protected var dcay:Number;
      
      protected var dsab:Number;
      
      protected var dsbc:Number;
      
      protected var dsca:Number;
      
      protected var dmax:Number;
      
      protected var cullRect:Rectangle;
      
      protected var tempPreGrp:Graphics;
      
      protected var tempPreBmp:BitmapData;
      
      protected var tempPreRSD:RenderSessionData;
      
      protected var tempTriangleMatrix:Matrix;
      
      private var a2:Number;
      
      private var b2:Number;
      
      private var c2:Number;
      
      private var d2:Number;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var d2ab:Number;
      
      private var d2bc:Number;
      
      private var d2ca:Number;
      
      public function BitmapMaterial(param1:BitmapData = null, param2:Boolean = false)
      {
         this.precisionMode = PrecisionMode.ORIGINAL;
         this.uvMatrices = new Dictionary();
         this.tempTriangleMatrix = new Matrix();
         super();
         if(param1)
         {
            this.texture = param1;
         }
         this.precise = param2;
         this.createRenderRecStorage();
      }
      
      protected function createRenderRecStorage() : void
      {
         this.renderRecStorage = new Array();
         var _loc1_:int = 0;
         while(_loc1_ <= 100)
         {
            this.renderRecStorage[_loc1_] = new RenderRecStorage();
            _loc1_++;
         }
      }
      
      public function resetMapping() : void
      {
         this.uvMatrices = new Dictionary();
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:Vector.<Number> = null;
         if(param1.isDrawTriangle)
         {
            _loc6_ = new Vector.<Number>();
            this.x0 = param1.v0.x;
            this.y0 = param1.v0.y;
            this.x1 = param1.v1.x;
            this.y1 = param1.v1.y;
            this.x2 = param1.v2.x;
            this.y2 = param1.v2.y;
            _loc6_.push(this.x0);
            _loc6_.push(this.y0);
            _loc6_.push(this.x1);
            _loc6_.push(this.y1);
            _loc6_.push(this.x2);
            _loc6_.push(this.y2);
            param2.beginBitmapFill(bitmap,null,true,true);
            if(this.dSided)
            {
               param2.drawTriangles(_loc6_,null,param1.uvt);
            }
            else
            {
               param2.drawTriangles(_loc6_,null,param1.uvt,"positive");
            }
            param2.endFill();
         }
         else
         {
            _triMap = !!param5 ? param5 : this.uvMatrices[param1] || this.transformUVRT(param1);
            if(!this._precise || !_triMap)
            {
               if(lineAlpha)
               {
                  param2.lineStyle(lineThickness,lineColor,lineAlpha);
               }
               if(bitmap)
               {
                  this.x0 = param1.v0.x;
                  this.y0 = param1.v0.y;
                  this.x1 = param1.v1.x;
                  this.y1 = param1.v1.y;
                  this.x2 = param1.v2.x;
                  this.y2 = param1.v2.y;
                  _triMatrix.a = this.x1 - this.x0;
                  _triMatrix.b = this.y1 - this.y0;
                  _triMatrix.c = this.x2 - this.x0;
                  _triMatrix.d = this.y2 - this.y0;
                  _triMatrix.tx = this.x0;
                  _triMatrix.ty = this.y0;
                  _localMatrix.a = _triMap.a;
                  _localMatrix.b = _triMap.b;
                  _localMatrix.c = _triMap.c;
                  _localMatrix.d = _triMap.d;
                  _localMatrix.tx = _triMap.tx;
                  _localMatrix.ty = _triMap.ty;
                  _localMatrix.concat(_triMatrix);
                  param2.beginBitmapFill(!!param4 ? param4 : bitmap,_localMatrix,true,true);
               }
               param2.moveTo(this.x0,this.y0);
               param2.lineTo(this.x1,this.y1);
               param2.lineTo(this.x2,this.y2);
               param2.lineTo(this.x0,this.y0);
               if(bitmap)
               {
                  param2.endFill();
               }
               if(lineAlpha)
               {
                  param2.lineStyle();
               }
               ++param3.renderStatistics.triangles;
            }
            else if(bitmap)
            {
               this.focus = param3.camera.focus;
               this.tempPreBmp = !!param4 ? param4 : bitmap;
               this.tempPreRSD = param3;
               this.tempPreGrp = param2;
               this.cullRect = param3.viewPort.cullingRectangle;
               this.renderRec(_triMap,param1.v0,param1.v1,param1.v2,0);
            }
         }
      }
      
      public function transformUV(param1:Triangle3D) : Matrix
      {
         var _loc2_:Array = null;
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
         var _loc15_:Matrix = null;
         var _loc16_:Matrix = null;
         if(!param1.uv)
         {
            PaperLogger.error("MaterialObject3D: transformUV() uv not found!");
         }
         else if(bitmap)
         {
            _loc2_ = param1.uv;
            _loc3_ = bitmap.width * maxU;
            _loc4_ = bitmap.height * maxV;
            _loc5_ = _loc3_ * param1.uv0.u;
            _loc6_ = _loc4_ * (1 - param1.uv0.v);
            _loc7_ = _loc3_ * param1.uv1.u;
            _loc8_ = _loc4_ * (1 - param1.uv1.v);
            _loc9_ = _loc3_ * param1.uv2.u;
            _loc10_ = _loc4_ * (1 - param1.uv2.v);
            if(_loc5_ == _loc7_ && _loc6_ == _loc8_ || _loc5_ == _loc9_ && _loc6_ == _loc10_)
            {
               _loc5_ -= _loc5_ > 0.05 ? 0.05 : -0.05;
               _loc6_ -= _loc6_ > 0.07 ? 0.07 : -0.07;
            }
            if(_loc9_ == _loc7_ && _loc10_ == _loc8_)
            {
               _loc9_ -= _loc9_ > 0.05 ? 0.04 : -0.04;
               _loc10_ -= _loc10_ > 0.06 ? 0.06 : -0.06;
            }
            _loc11_ = _loc7_ - _loc5_;
            _loc12_ = _loc8_ - _loc6_;
            _loc13_ = _loc9_ - _loc5_;
            _loc14_ = _loc10_ - _loc6_;
            _loc15_ = new Matrix(_loc11_,_loc12_,_loc13_,_loc14_,_loc5_,_loc6_);
            if(Papervision3D.useRIGHTHANDED)
            {
               _loc15_.scale(-1,1);
               _loc15_.translate(_loc3_,0);
            }
            _loc15_.invert();
            (_loc16_ = this.uvMatrices[param1] = _loc15_.clone()).a = _loc15_.a;
            _loc16_.b = _loc15_.b;
            _loc16_.c = _loc15_.c;
            _loc16_.d = _loc15_.d;
            _loc16_.tx = _loc15_.tx;
            _loc16_.ty = _loc15_.ty;
         }
         else
         {
            PaperLogger.error("MaterialObject3D: transformUV() material.bitmap not found!");
         }
         return _loc16_;
      }
      
      public function transformUVRT(param1:RenderTriangle) : Matrix
      {
         var _loc2_:Number = NaN;
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
         var _loc14_:Matrix = null;
         var _loc15_:Matrix = null;
         if(bitmap)
         {
            _loc2_ = bitmap.width * maxU;
            _loc3_ = bitmap.height * maxV;
            _loc4_ = _loc2_ * param1.uv0.u;
            _loc5_ = _loc3_ * (1 - param1.uv0.v);
            _loc6_ = _loc2_ * param1.uv1.u;
            _loc7_ = _loc3_ * (1 - param1.uv1.v);
            _loc8_ = _loc2_ * param1.uv2.u;
            _loc9_ = _loc3_ * (1 - param1.uv2.v);
            if(_loc4_ == _loc6_ && _loc5_ == _loc7_ || _loc4_ == _loc8_ && _loc5_ == _loc9_)
            {
               _loc4_ -= _loc4_ > 0.05 ? 0.05 : -0.05;
               _loc5_ -= _loc5_ > 0.07 ? 0.07 : -0.07;
            }
            if(_loc8_ == _loc6_ && _loc9_ == _loc7_)
            {
               _loc8_ -= _loc8_ > 0.05 ? 0.04 : -0.04;
               _loc9_ -= _loc9_ > 0.06 ? 0.06 : -0.06;
            }
            _loc10_ = _loc6_ - _loc4_;
            _loc11_ = _loc7_ - _loc5_;
            _loc12_ = _loc8_ - _loc4_;
            _loc13_ = _loc9_ - _loc5_;
            _loc14_ = new Matrix(_loc10_,_loc11_,_loc12_,_loc13_,_loc4_,_loc5_);
            if(Papervision3D.useRIGHTHANDED)
            {
               _loc14_.scale(-1,1);
               _loc14_.translate(_loc2_,0);
            }
            _loc14_.invert();
            (_loc15_ = this.uvMatrices[param1] = _loc14_.clone()).a = _loc14_.a;
            _loc15_.b = _loc14_.b;
            _loc15_.c = _loc14_.c;
            _loc15_.d = _loc14_.d;
            _loc15_.tx = _loc14_.tx;
            _loc15_.ty = _loc14_.ty;
         }
         else
         {
            PaperLogger.error("MaterialObject3D: transformUV() material.bitmap not found!");
         }
         return _loc15_;
      }
      
      protected function renderRec(param1:Matrix, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance, param5:Number) : void
      {
         this.az = param2.z;
         this.bz = param3.z;
         this.cz = param4.z;
         if(this.az <= 0 && this.bz <= 0 && this.cz <= 0)
         {
            return;
         }
         this.cx = param4.x;
         this.cy = param4.y;
         this.bx = param3.x;
         this.by = param3.y;
         this.ax = param2.x;
         this.ay = param2.y;
         if(this.cullRect)
         {
            hitRect.x = this.bx < this.ax ? (this.bx < this.cx ? Number(this.bx) : Number(this.cx)) : (this.ax < this.cx ? Number(this.ax) : Number(this.cx));
            hitRect.width = (this.bx > this.ax ? (this.bx > this.cx ? this.bx : this.cx) : (this.ax > this.cx ? this.ax : this.cx)) + (hitRect.x < 0 ? -hitRect.x : hitRect.x);
            hitRect.y = this.by < this.ay ? (this.by < this.cy ? Number(this.by) : Number(this.cy)) : (this.ay < this.cy ? Number(this.ay) : Number(this.cy));
            hitRect.height = (this.by > this.ay ? (this.by > this.cy ? this.by : this.cy) : (this.ay > this.cy ? this.ay : this.cy)) + (hitRect.y < 0 ? -hitRect.y : hitRect.y);
            if(hitRect.right < this.cullRect.left || hitRect.left > this.cullRect.right)
            {
               return;
            }
            if(hitRect.bottom < this.cullRect.top || hitRect.top > this.cullRect.bottom)
            {
               return;
            }
         }
         if(param5 >= 100 || hitRect.width < this.minimumRenderSize || hitRect.height < this.minimumRenderSize || this.focus == Infinity)
         {
            this.a2 = param3.x - param2.x;
            this.b2 = param3.y - param2.y;
            this.c2 = param4.x - param2.x;
            this.d2 = param4.y - param2.y;
            this.tempTriangleMatrix.a = param1.a * this.a2 + param1.b * this.c2;
            this.tempTriangleMatrix.b = param1.a * this.b2 + param1.b * this.d2;
            this.tempTriangleMatrix.c = param1.c * this.a2 + param1.d * this.c2;
            this.tempTriangleMatrix.d = param1.c * this.b2 + param1.d * this.d2;
            this.tempTriangleMatrix.tx = param1.tx * this.a2 + param1.ty * this.c2 + param2.x;
            this.tempTriangleMatrix.ty = param1.tx * this.b2 + param1.ty * this.d2 + param2.y;
            if(lineAlpha)
            {
               this.tempPreGrp.lineStyle(lineThickness,lineColor,lineAlpha);
            }
            this.tempPreGrp.beginBitmapFill(this.tempPreBmp,this.tempTriangleMatrix,tiled,smooth);
            this.tempPreGrp.moveTo(param2.x,param2.y);
            this.tempPreGrp.lineTo(param3.x,param3.y);
            this.tempPreGrp.lineTo(param4.x,param4.y);
            this.tempPreGrp.endFill();
            if(lineAlpha)
            {
               this.tempPreGrp.lineStyle();
            }
            ++this.tempPreRSD.renderStatistics.triangles;
            return;
         }
         this.faz = this.focus + this.az;
         this.fbz = this.focus + this.bz;
         this.fcz = this.focus + this.cz;
         this.mabz = 2 / (this.faz + this.fbz);
         this.mbcz = 2 / (this.fbz + this.fcz);
         this.mcaz = 2 / (this.fcz + this.faz);
         this.mabx = (this.ax * this.faz + this.bx * this.fbz) * this.mabz;
         this.maby = (this.ay * this.faz + this.by * this.fbz) * this.mabz;
         this.mbcx = (this.bx * this.fbz + this.cx * this.fcz) * this.mbcz;
         this.mbcy = (this.by * this.fbz + this.cy * this.fcz) * this.mbcz;
         this.mcax = (this.cx * this.fcz + this.ax * this.faz) * this.mcaz;
         this.mcay = (this.cy * this.fcz + this.ay * this.faz) * this.mcaz;
         this.dabx = this.ax + this.bx - this.mabx;
         this.daby = this.ay + this.by - this.maby;
         this.dbcx = this.bx + this.cx - this.mbcx;
         this.dbcy = this.by + this.cy - this.mbcy;
         this.dcax = this.cx + this.ax - this.mcax;
         this.dcay = this.cy + this.ay - this.mcay;
         this.dsab = this.dabx * this.dabx + this.daby * this.daby;
         this.dsbc = this.dbcx * this.dbcx + this.dbcy * this.dbcy;
         this.dsca = this.dcax * this.dcax + this.dcay * this.dcay;
         var _loc6_:int = param5 + 1;
         var _loc7_:RenderRecStorage;
         var _loc8_:Matrix = (_loc7_ = RenderRecStorage(this.renderRecStorage[int(param5)])).mat;
         if(this.dsab <= this._precision && this.dsca <= this._precision && this.dsbc <= this._precision)
         {
            this.a2 = param3.x - param2.x;
            this.b2 = param3.y - param2.y;
            this.c2 = param4.x - param2.x;
            this.d2 = param4.y - param2.y;
            this.tempTriangleMatrix.a = param1.a * this.a2 + param1.b * this.c2;
            this.tempTriangleMatrix.b = param1.a * this.b2 + param1.b * this.d2;
            this.tempTriangleMatrix.c = param1.c * this.a2 + param1.d * this.c2;
            this.tempTriangleMatrix.d = param1.c * this.b2 + param1.d * this.d2;
            this.tempTriangleMatrix.tx = param1.tx * this.a2 + param1.ty * this.c2 + param2.x;
            this.tempTriangleMatrix.ty = param1.tx * this.b2 + param1.ty * this.d2 + param2.y;
            if(lineAlpha)
            {
               this.tempPreGrp.lineStyle(lineThickness,lineColor,lineAlpha);
            }
            this.tempPreGrp.beginBitmapFill(this.tempPreBmp,this.tempTriangleMatrix,tiled,smooth);
            this.tempPreGrp.moveTo(param2.x,param2.y);
            this.tempPreGrp.lineTo(param3.x,param3.y);
            this.tempPreGrp.lineTo(param4.x,param4.y);
            this.tempPreGrp.endFill();
            if(lineAlpha)
            {
               this.tempPreGrp.lineStyle();
            }
            ++this.tempPreRSD.renderStatistics.triangles;
            return;
         }
         if(this.dsab > this._precision && this.dsca > this._precision && this.dsbc > this._precision)
         {
            _loc8_.a = param1.a * 2;
            _loc8_.b = param1.b * 2;
            _loc8_.c = param1.c * 2;
            _loc8_.d = param1.d * 2;
            _loc8_.tx = param1.tx * 2;
            _loc8_.ty = param1.ty * 2;
            _loc7_.v0.x = this.mabx * 0.5;
            _loc7_.v0.y = this.maby * 0.5;
            _loc7_.v0.z = (this.az + this.bz) * 0.5;
            _loc7_.v1.x = this.mbcx * 0.5;
            _loc7_.v1.y = this.mbcy * 0.5;
            _loc7_.v1.z = (this.bz + this.cz) * 0.5;
            _loc7_.v2.x = this.mcax * 0.5;
            _loc7_.v2.y = this.mcay * 0.5;
            _loc7_.v2.z = (this.cz + this.az) * 0.5;
            this.renderRec(_loc8_,param2,_loc7_.v0,_loc7_.v2,_loc6_);
            --_loc8_.tx;
            this.renderRec(_loc8_,_loc7_.v0,param3,_loc7_.v1,_loc6_);
            --_loc8_.ty;
            _loc8_.tx = param1.tx * 2;
            this.renderRec(_loc8_,_loc7_.v2,_loc7_.v1,param4,_loc6_);
            _loc8_.a = -param1.a * 2;
            _loc8_.b = -param1.b * 2;
            _loc8_.c = -param1.c * 2;
            _loc8_.d = -param1.d * 2;
            _loc8_.tx = -param1.tx * 2 + 1;
            _loc8_.ty = -param1.ty * 2 + 1;
            this.renderRec(_loc8_,_loc7_.v1,_loc7_.v2,_loc7_.v0,_loc6_);
            return;
         }
         if(this.precisionMode == PrecisionMode.ORIGINAL)
         {
            this.d2ab = this.dsab;
            this.d2bc = this.dsbc;
            this.d2ca = this.dsca;
            this.dmax = this.dsca > this.dsbc ? (this.dsca > this.dsab ? Number(this.dsca) : Number(this.dsab)) : (this.dsbc > this.dsab ? Number(this.dsbc) : Number(this.dsab));
         }
         else
         {
            this.dx = param2.x - param3.x;
            this.dy = param2.y - param3.y;
            this.d2ab = this.dx * this.dx + this.dy * this.dy;
            this.dx = param3.x - param4.x;
            this.dy = param3.y - param4.y;
            this.d2bc = this.dx * this.dx + this.dy * this.dy;
            this.dx = param4.x - param2.x;
            this.dy = param4.y - param2.y;
            this.d2ca = this.dx * this.dx + this.dy * this.dy;
            this.dmax = this.d2ca > this.d2bc ? (this.d2ca > this.d2ab ? Number(this.d2ca) : Number(this.d2ab)) : (this.d2bc > this.d2ab ? Number(this.d2bc) : Number(this.d2ab));
         }
         if(this.d2ab == this.dmax)
         {
            _loc8_.a = param1.a * 2;
            _loc8_.b = param1.b;
            _loc8_.c = param1.c * 2;
            _loc8_.d = param1.d;
            _loc8_.tx = param1.tx * 2;
            _loc8_.ty = param1.ty;
            _loc7_.v0.x = this.mabx * 0.5;
            _loc7_.v0.y = this.maby * 0.5;
            _loc7_.v0.z = (this.az + this.bz) * 0.5;
            this.renderRec(_loc8_,param2,_loc7_.v0,param4,_loc6_);
            _loc8_.a = param1.a * 2 + param1.b;
            _loc8_.c = 2 * param1.c + param1.d;
            _loc8_.tx = param1.tx * 2 + param1.ty - 1;
            this.renderRec(_loc8_,_loc7_.v0,param3,param4,_loc6_);
            return;
         }
         if(this.d2ca == this.dmax)
         {
            _loc8_.a = param1.a;
            _loc8_.b = param1.b * 2;
            _loc8_.c = param1.c;
            _loc8_.d = param1.d * 2;
            _loc8_.tx = param1.tx;
            _loc8_.ty = param1.ty * 2;
            _loc7_.v2.x = this.mcax * 0.5;
            _loc7_.v2.y = this.mcay * 0.5;
            _loc7_.v2.z = (this.cz + this.az) * 0.5;
            this.renderRec(_loc8_,param2,param3,_loc7_.v2,_loc6_);
            _loc8_.b += param1.a;
            _loc8_.d += param1.c;
            _loc8_.ty += param1.tx - 1;
            this.renderRec(_loc8_,_loc7_.v2,param3,param4,_loc6_);
            return;
         }
         _loc8_.a = param1.a - param1.b;
         _loc8_.b = param1.b * 2;
         _loc8_.c = param1.c - param1.d;
         _loc8_.d = param1.d * 2;
         _loc8_.tx = param1.tx - param1.ty;
         _loc8_.ty = param1.ty * 2;
         _loc7_.v1.x = this.mbcx * 0.5;
         _loc7_.v1.y = this.mbcy * 0.5;
         _loc7_.v1.z = (this.bz + this.cz) * 0.5;
         this.renderRec(_loc8_,param2,param3,_loc7_.v1,_loc6_);
         _loc8_.a = param1.a * 2;
         _loc8_.b = param1.b - param1.a;
         _loc8_.c = param1.c * 2;
         _loc8_.d = param1.d - param1.c;
         _loc8_.tx = param1.tx * 2;
         _loc8_.ty = param1.ty - param1.tx;
         this.renderRec(_loc8_,param2,_loc7_.v1,param4,_loc6_);
      }
      
      override public function toString() : String
      {
         return "Texture:" + this.texture + " lineColor:" + this.lineColor + " lineAlpha:" + this.lineAlpha;
      }
      
      protected function createBitmap(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = null;
         this.resetMapping();
         if(AUTO_MIP_MAPPING)
         {
            _loc2_ = this.correctBitmap(param1);
         }
         else
         {
            this.maxU = this.maxV = 1;
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      protected function correctBitmap(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Number = 1 << MIP_MAP_DEPTH;
         var _loc4_:Number = (_loc4_ = Number(param1.width / _loc3_)) == uint(_loc4_) ? Number(_loc4_) : Number(uint(_loc4_) + 1);
         var _loc5_:Number = (_loc5_ = Number(param1.height / _loc3_)) == uint(_loc5_) ? Number(_loc5_) : Number(uint(_loc5_) + 1);
         var _loc6_:Number = _loc3_ * _loc4_;
         var _loc7_:Number = _loc3_ * _loc5_;
         var _loc8_:Boolean = true;
         if(_loc6_ > 2880)
         {
            _loc6_ = param1.width;
            _loc8_ = false;
         }
         if(_loc7_ > 2880)
         {
            _loc7_ = param1.height;
            _loc8_ = false;
         }
         if(!_loc8_)
         {
            PaperLogger.warning("Material " + this.name + ": Texture too big for mip mapping. Resizing recommended for better performance and quality.");
         }
         if(param1 && (param1.width % _loc3_ != 0 || param1.height % _loc3_ != 0))
         {
            _loc2_ = new BitmapData(_loc6_,_loc7_,param1.transparent,0);
            widthOffset = param1.width;
            heightOffset = param1.height;
            this.maxU = param1.width / _loc6_;
            this.maxV = param1.height / _loc7_;
            _loc2_.draw(param1);
            this.extendBitmapEdges(_loc2_,param1.width,param1.height);
         }
         else
         {
            this.maxU = this.maxV = 1;
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      protected function extendBitmapEdges(param1:BitmapData, param2:Number, param3:Number) : void
      {
         var _loc6_:int = 0;
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Point = new Point();
         if(param1.width > param2)
         {
            _loc4_.x = param2 - 1;
            _loc4_.y = 0;
            _loc4_.width = 1;
            _loc4_.height = param3;
            _loc5_.y = 0;
            _loc6_ = param2;
            while(_loc6_ < param1.width)
            {
               _loc5_.x = _loc6_;
               param1.copyPixels(param1,_loc4_,_loc5_);
               _loc6_++;
            }
         }
         if(param1.height > param3)
         {
            _loc4_.x = 0;
            _loc4_.y = param3 - 1;
            _loc4_.width = param1.width;
            _loc4_.height = 1;
            _loc5_.x = 0;
            _loc6_ = param3;
            while(_loc6_ < param1.height)
            {
               _loc5_.y = _loc6_;
               param1.copyPixels(param1,_loc4_,_loc5_);
               _loc6_++;
            }
         }
      }
      
      public function resetUVS() : void
      {
         this.uvMatrices = new Dictionary(false);
      }
      
      override public function copy(param1:MaterialObject3D) : void
      {
         super.copy(param1);
         this.maxU = param1.maxU;
         this.maxV = param1.maxV;
      }
      
      override public function clone() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = super.clone();
         _loc1_.maxU = this.maxU;
         _loc1_.maxV = this.maxV;
         return _loc1_;
      }
      
      public function set precise(param1:Boolean) : void
      {
         this._precise = param1;
      }
      
      public function get precise() : Boolean
      {
         return this._precise;
      }
      
      public function set precision(param1:int) : void
      {
         this._precision = param1;
      }
      
      public function get precision() : int
      {
         return this._precision;
      }
      
      public function set pixelPrecision(param1:int) : void
      {
         this._precision = param1 * param1 * 1.4;
         this._perPixelPrecision = param1;
      }
      
      public function get pixelPrecision() : int
      {
         return this._perPixelPrecision;
      }
      
      public function get texture() : Object
      {
         return this._texture;
      }
      
      public function set texture(param1:Object) : void
      {
         if(param1 is BitmapData == false)
         {
            PaperLogger.error("BitmapMaterial.texture requires a BitmapData object for the texture");
            return;
         }
         bitmap = this.createBitmap(BitmapData(param1));
         this._texture = param1;
      }
      
      public function LoadTextureInMemory(param1:String, param2:ByteArray) : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.uvMatrices)
         {
            this.uvMatrices = null;
         }
         if(bitmap)
         {
            bitmap.dispose();
         }
         this.renderRecStorage = null;
      }
   }
}
