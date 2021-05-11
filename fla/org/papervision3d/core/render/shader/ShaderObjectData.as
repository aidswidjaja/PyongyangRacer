package org.papervision3d.core.render.shader
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.shaders.ShadedMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ShaderObjectData
   {
       
      
      private var origin:Point;
      
      public var shaderRenderer:ShaderRenderer;
      
      public var uvMatrices:Dictionary;
      
      public var lightMatrices:Dictionary;
      
      public var object:DisplayObject3D;
      
      public var material:BitmapMaterial;
      
      public var shadedMaterial:ShadedMaterial;
      
      public var triangleUVS:Dictionary;
      
      public var renderTriangleUVS:Dictionary;
      
      protected var triangleBitmaps:Dictionary;
      
      public var triangleRects:Dictionary;
      
      public function ShaderObjectData(param1:DisplayObject3D, param2:BitmapMaterial, param3:ShadedMaterial)
      {
         this.origin = new Point(0,0);
         super();
         this.shaderRenderer = new ShaderRenderer();
         this.lightMatrices = new Dictionary();
         this.uvMatrices = new Dictionary();
         this.object = param1;
         this.material = param2;
         this.shadedMaterial = param3;
         this.triangleUVS = new Dictionary();
         this.renderTriangleUVS = new Dictionary();
         this.triangleBitmaps = new Dictionary();
         this.triangleRects = new Dictionary();
      }
      
      public function getUVMatrixForTriangle(param1:Triangle3D, param2:Boolean = false) : Matrix
      {
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(!(_loc3_ = this.uvMatrices[param1]))
         {
            _loc3_ = new Matrix();
            if(param2)
            {
               this.perturbUVMatrix(_loc3_,param1,2);
            }
            else if(this.material.bitmap)
            {
               _loc4_ = this.material.bitmap.width;
               _loc5_ = this.material.bitmap.height;
               _loc6_ = param1.uv[0].u * _loc4_;
               _loc7_ = (1 - param1.uv[0].v) * _loc5_;
               _loc8_ = param1.uv[1].u * _loc4_;
               _loc9_ = (1 - param1.uv[1].v) * _loc5_;
               _loc10_ = param1.uv[2].u * _loc4_;
               _loc11_ = (1 - param1.uv[2].v) * _loc5_;
               _loc3_.tx = _loc6_;
               _loc3_.ty = _loc7_;
               _loc3_.a = _loc8_ - _loc6_;
               _loc3_.b = _loc9_ - _loc7_;
               _loc3_.c = _loc10_ - _loc6_;
               _loc3_.d = _loc11_ - _loc7_;
            }
            if(this.material.bitmap)
            {
               this.uvMatrices[param1] = _loc3_;
            }
         }
         return _loc3_;
      }
      
      public function getOutputBitmapFor(param1:Triangle3D) : BitmapData
      {
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         var _loc4_:Rectangle = null;
         if(!this.triangleBitmaps[param1])
         {
            _loc2_ = this.getRectFor(param1);
            _loc3_ = this.triangleBitmaps[param1] = new BitmapData(Math.ceil(_loc2_.width),Math.ceil(_loc2_.height),false,0);
            _loc4_ = new Rectangle(0,0,_loc3_.width,_loc3_.height);
            _loc3_.copyPixels(this.material.bitmap,_loc4_,this.origin);
         }
         else
         {
            _loc2_ = this.getRectFor(param1);
         }
         if(this.material.bitmap && _loc2_)
         {
            this.triangleBitmaps[param1].copyPixels(this.material.bitmap,_loc2_,this.origin);
         }
         return this.triangleBitmaps[param1];
      }
      
      public function getPerTriUVForDraw(param1:Triangle3D) : Matrix
      {
         var _loc2_:Matrix = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Rectangle = null;
         if(!this.triangleUVS[param1])
         {
            _loc2_ = this.triangleUVS[param1] = new Matrix();
            _loc3_ = this.material.bitmap.width;
            _loc4_ = this.material.bitmap.height;
            _loc5_ = param1.uv[0].u * _loc3_;
            _loc6_ = (1 - param1.uv[0].v) * _loc4_;
            _loc7_ = param1.uv[1].u * _loc3_;
            _loc8_ = (1 - param1.uv[1].v) * _loc4_;
            _loc9_ = param1.uv[2].u * _loc3_;
            _loc10_ = (1 - param1.uv[2].v) * _loc4_;
            _loc11_ = this.getRectFor(param1);
            _loc2_.tx = _loc5_ - _loc11_.x;
            _loc2_.ty = _loc6_ - _loc11_.y;
            _loc2_.a = _loc7_ - _loc5_;
            _loc2_.b = _loc8_ - _loc6_;
            _loc2_.c = _loc9_ - _loc5_;
            _loc2_.d = _loc10_ - _loc6_;
            _loc2_.invert();
         }
         return this.triangleUVS[param1];
      }
      
      public function getPerTriUVForShader(param1:Triangle3D) : Matrix
      {
         var _loc2_:Matrix = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Rectangle = null;
         if(!this.renderTriangleUVS[param1])
         {
            _loc2_ = this.renderTriangleUVS[param1] = new Matrix();
            _loc3_ = this.material.bitmap.width;
            _loc4_ = this.material.bitmap.height;
            _loc5_ = param1.uv[0].u * _loc3_;
            _loc6_ = (1 - param1.uv[0].v) * _loc4_;
            _loc7_ = param1.uv[1].u * _loc3_;
            _loc8_ = (1 - param1.uv[1].v) * _loc4_;
            _loc9_ = param1.uv[2].u * _loc3_;
            _loc10_ = (1 - param1.uv[2].v) * _loc4_;
            _loc11_ = this.getRectFor(param1);
            _loc2_.tx = _loc5_ - _loc11_.x;
            _loc2_.ty = _loc6_ - _loc11_.y;
            _loc2_.a = _loc7_ - _loc5_;
            _loc2_.b = _loc8_ - _loc6_;
            _loc2_.c = _loc9_ - _loc5_;
            _loc2_.d = _loc10_ - _loc6_;
         }
         return this.renderTriangleUVS[param1];
      }
      
      public function getRectFor(param1:Triangle3D) : Rectangle
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
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         if(!this.triangleRects[param1])
         {
            _loc2_ = this.material.bitmap.width;
            _loc3_ = this.material.bitmap.height;
            _loc4_ = param1.uv[0].u * _loc2_;
            _loc5_ = (1 - param1.uv[0].v) * _loc3_;
            _loc6_ = param1.uv[1].u * _loc2_;
            _loc7_ = (1 - param1.uv[1].v) * _loc3_;
            _loc8_ = param1.uv[2].u * _loc2_;
            _loc9_ = (1 - param1.uv[2].v) * _loc3_;
            _loc10_ = Math.min(Math.min(_loc4_,_loc6_),_loc8_);
            _loc11_ = Math.min(Math.min(_loc5_,_loc7_),_loc9_);
            _loc12_ = Math.max(Math.max(_loc4_,_loc6_),_loc8_);
            _loc13_ = Math.max(Math.max(_loc5_,_loc7_),_loc9_);
            _loc14_ = _loc12_ - _loc10_;
            _loc15_ = _loc13_ - _loc11_;
            if(_loc14_ <= 0)
            {
               _loc14_ = 1;
            }
            if(_loc15_ <= 0)
            {
               _loc15_ = 1;
            }
            return this.triangleRects[param1] = new Rectangle(_loc10_,_loc11_,_loc14_,_loc15_);
         }
         return this.triangleRects[param1];
      }
      
      public function updateBeforeRender() : void
      {
      }
      
      public function destroy() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.uvMatrices)
         {
            this.uvMatrices[_loc1_] = null;
         }
         this.uvMatrices = null;
         this.shaderRenderer.destroy();
         this.shaderRenderer = null;
         this.lightMatrices = null;
      }
      
      private function perturbUVMatrix(param1:Matrix, param2:Triangle3D, param3:Number = 2) : void
      {
         var _loc4_:Number = this.material.bitmap.width;
         var _loc5_:Number = this.material.bitmap.height;
         var _loc6_:Number = param2.uv[0].u;
         var _loc7_:Number = 1 - param2.uv[0].v;
         var _loc8_:Number = param2.uv[1].u;
         var _loc9_:Number = 1 - param2.uv[1].v;
         var _loc10_:Number = param2.uv[2].u;
         var _loc11_:Number = 1 - param2.uv[2].v;
         var _loc12_:Number = _loc6_ * _loc4_;
         var _loc13_:Number = _loc7_ * _loc5_;
         var _loc14_:Number = _loc8_ * _loc4_;
         var _loc15_:Number = _loc9_ * _loc5_;
         var _loc16_:Number = _loc10_ * _loc4_;
         var _loc17_:Number = _loc11_ * _loc5_;
         var _loc18_:Number = (_loc10_ + _loc8_ + _loc6_) / 3;
         var _loc19_:Number = (_loc11_ + _loc9_ + _loc7_) / 3;
         var _loc20_:Number = _loc6_ - _loc18_;
         var _loc21_:Number = _loc7_ - _loc19_;
         var _loc22_:Number = _loc8_ - _loc18_;
         var _loc23_:Number = _loc9_ - _loc19_;
         var _loc24_:Number = _loc10_ - _loc18_;
         var _loc25_:Number = _loc11_ - _loc19_;
         var _loc26_:Number = _loc20_ < 0 ? Number(-_loc20_) : Number(_loc20_);
         var _loc27_:Number = _loc21_ < 0 ? Number(-_loc21_) : Number(_loc21_);
         var _loc28_:Number = _loc22_ < 0 ? Number(-_loc22_) : Number(_loc22_);
         var _loc29_:Number = _loc23_ < 0 ? Number(-_loc23_) : Number(_loc23_);
         var _loc30_:Number = _loc24_ < 0 ? Number(-_loc24_) : Number(_loc24_);
         var _loc31_:Number = _loc25_ < 0 ? Number(-_loc25_) : Number(_loc25_);
         var _loc32_:Number = _loc26_ > _loc27_ ? Number(1 / _loc26_) : Number(1 / _loc27_);
         var _loc33_:Number = _loc28_ > _loc29_ ? Number(1 / _loc28_) : Number(1 / _loc29_);
         var _loc34_:Number = _loc30_ > _loc31_ ? Number(1 / _loc30_) : Number(1 / _loc31_);
         _loc12_ -= -_loc20_ * _loc32_ * param3;
         _loc13_ -= -_loc21_ * _loc32_ * param3;
         _loc14_ -= -_loc22_ * _loc33_ * param3;
         _loc15_ -= -_loc23_ * _loc33_ * param3;
         _loc16_ -= -_loc24_ * _loc34_ * param3;
         _loc17_ -= -_loc25_ * _loc34_ * param3;
         param1.tx = _loc12_;
         param1.ty = _loc13_;
         param1.a = _loc14_ - _loc12_;
         param1.b = _loc15_ - _loc13_;
         param1.c = _loc16_ - _loc12_;
         param1.d = _loc17_ - _loc13_;
      }
   }
}
