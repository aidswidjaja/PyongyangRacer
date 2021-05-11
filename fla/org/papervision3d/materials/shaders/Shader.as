package org.papervision3d.materials.shaders
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.filters.BitmapFilter;
   import flash.utils.Dictionary;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.shader.ShaderObjectData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Shader extends EventDispatcher implements IShader
   {
       
      
      protected var _filter:BitmapFilter;
      
      protected var _blendMode:String = "multiply";
      
      protected var _object:DisplayObject3D;
      
      protected var layers:Dictionary;
      
      public function Shader()
      {
         super();
         this.layers = new Dictionary(true);
      }
      
      public function renderLayer(param1:Triangle3D, param2:RenderSessionData, param3:ShaderObjectData) : void
      {
      }
      
      public function renderTri(param1:Triangle3D, param2:RenderSessionData, param3:ShaderObjectData, param4:BitmapData) : void
      {
      }
      
      public function destroy() : void
      {
      }
      
      public function setContainerForObject(param1:DisplayObject3D, param2:Sprite) : void
      {
         this.layers[param1] = param2;
      }
      
      public function set filter(param1:BitmapFilter) : void
      {
         this._filter = param1;
      }
      
      public function get filter() : BitmapFilter
      {
         return this._filter;
      }
      
      public function set layerBlendMode(param1:String) : void
      {
         this._blendMode = param1;
      }
      
      public function get layerBlendMode() : String
      {
         return this._blendMode;
      }
      
      public function updateAfterRender(param1:RenderSessionData, param2:ShaderObjectData) : void
      {
      }
   }
}
