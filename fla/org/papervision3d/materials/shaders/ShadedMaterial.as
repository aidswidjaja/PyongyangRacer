package org.papervision3d.materials.shaders
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.core.render.material.IUpdateAfterMaterial;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   import org.papervision3d.core.render.shader.ShaderObjectData;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ShadedMaterial extends TriangleMaterial implements ITriangleDrawer, IUpdateBeforeMaterial, IUpdateAfterMaterial
   {
      
      private static var bmp:BitmapData;
       
      
      private var _shaderCompositeMode:int;
      
      public var shader:Shader;
      
      public var material:BitmapMaterial;
      
      public var shaderObjectData:Dictionary;
      
      public function ShadedMaterial(param1:BitmapMaterial, param2:Shader, param3:int = 0)
      {
         super();
         this.shader = param2;
         this.material = param1;
         this.shaderCompositeMode = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.shaderObjectData = new Dictionary();
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:ShaderObjectData = ShaderObjectData(this.shaderObjectData[param1.renderableInstance.instance]);
         if(this.shaderCompositeMode == ShaderCompositeModes.PER_LAYER)
         {
            this.material.drawTriangle(param1,param2,param3,_loc6_.shaderRenderer.outputBitmap);
            this.shader.renderLayer(param1.triangle,param3,_loc6_);
         }
         else if(this.shaderCompositeMode == ShaderCompositeModes.PER_TRIANGLE_IN_BITMAP)
         {
            bmp = _loc6_.getOutputBitmapFor(param1.triangle);
            this.material.drawTriangle(param1,param2,param3,bmp,!!_loc6_.triangleUVS[param1.triangle] ? _loc6_.triangleUVS[param1.triangle] : _loc6_.getPerTriUVForDraw(param1.triangle));
            this.shader.renderTri(param1.triangle,param3,_loc6_,bmp);
         }
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:ShaderObjectData = null;
         var _loc3_:ILightShader = null;
         for each(_loc2_ in this.shaderObjectData)
         {
            _loc2_.shaderRenderer.inputBitmap = this.material.bitmap;
            if(this.shaderCompositeMode == ShaderCompositeModes.PER_LAYER)
            {
               if(_loc2_.shaderRenderer.resizedInput)
               {
                  _loc2_.shaderRenderer.resizedInput = false;
                  _loc2_.uvMatrices = new Dictionary();
               }
               _loc2_.shaderRenderer.clear();
            }
            if(this.shader is ILightShader)
            {
               _loc3_ = this.shader as ILightShader;
               _loc3_.updateLightMatrix(_loc2_,param1);
            }
         }
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
         var _loc2_:ShaderObjectData = null;
         for each(_loc2_ in this.shaderObjectData)
         {
            this.shader.updateAfterRender(param1,_loc2_);
            if(this.shaderCompositeMode == ShaderCompositeModes.PER_LAYER)
            {
               _loc2_.shaderRenderer.render(param1);
            }
         }
      }
      
      override public function registerObject(param1:DisplayObject3D) : void
      {
         super.registerObject(param1);
         var _loc2_:ShaderObjectData = this.shaderObjectData[param1] = new ShaderObjectData(param1,this.material,this);
         _loc2_.shaderRenderer.inputBitmap = this.material.bitmap;
         this.shader.setContainerForObject(param1,_loc2_.shaderRenderer.getLayerForShader(this.shader));
      }
      
      override public function unregisterObject(param1:DisplayObject3D) : void
      {
         super.unregisterObject(param1);
         var _loc2_:ShaderObjectData = this.shaderObjectData[param1];
         _loc2_.destroy();
         delete this.shaderObjectData[param1];
      }
      
      public function set shaderCompositeMode(param1:int) : void
      {
         this._shaderCompositeMode = param1;
      }
      
      public function get shaderCompositeMode() : int
      {
         return this._shaderCompositeMode;
      }
      
      public function getOutputBitmapDataFor(param1:DisplayObject3D) : BitmapData
      {
         var _loc2_:ShaderObjectData = null;
         if(this.shaderCompositeMode == ShaderCompositeModes.PER_LAYER)
         {
            if(this.shaderObjectData[param1])
            {
               _loc2_ = ShaderObjectData(this.shaderObjectData[param1]);
               return _loc2_.shaderRenderer.outputBitmap;
            }
            PaperLogger.warning("object not registered with shaded material");
         }
         else
         {
            PaperLogger.warning("getOutputBitmapDataFor only works on per layer mode");
         }
         return null;
      }
      
      override public function destroy() : void
      {
         var _loc1_:ShaderObjectData = null;
         super.destroy();
         for each(_loc1_ in this.shaderObjectData)
         {
            _loc1_.destroy();
         }
         this.material = null;
         this.shader = null;
      }
   }
}
