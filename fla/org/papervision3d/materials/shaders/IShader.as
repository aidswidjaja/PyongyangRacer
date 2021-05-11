package org.papervision3d.materials.shaders
{
   import flash.display.BitmapData;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.shader.ShaderObjectData;
   
   public interface IShader
   {
       
      
      function renderLayer(param1:Triangle3D, param2:RenderSessionData, param3:ShaderObjectData) : void;
      
      function renderTri(param1:Triangle3D, param2:RenderSessionData, param3:ShaderObjectData, param4:BitmapData) : void;
      
      function updateAfterRender(param1:RenderSessionData, param2:ShaderObjectData) : void;
      
      function destroy() : void;
   }
}
