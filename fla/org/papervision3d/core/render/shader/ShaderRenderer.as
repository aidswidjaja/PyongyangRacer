package org.papervision3d.core.render.shader
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.shaders.Shader;
   
   public class ShaderRenderer extends EventDispatcher implements IShaderRenderer
   {
       
      
      public var resizedInput:Boolean = false;
      
      public var bitmapLayer:Sprite;
      
      public var container:Sprite;
      
      public var bitmapContainer:Bitmap;
      
      public var shadeLayers:Dictionary;
      
      public var outputBitmap:BitmapData;
      
      private var _inputBitmapData:BitmapData;
      
      public function ShaderRenderer()
      {
         super();
         this.container = new Sprite();
         this.bitmapLayer = new Sprite();
         this.bitmapContainer = new Bitmap();
         this.bitmapLayer.addChild(this.bitmapContainer);
         this.bitmapLayer.blendMode = BlendMode.NORMAL;
         this.shadeLayers = new Dictionary();
         this.container.addChild(this.bitmapLayer);
      }
      
      public function render(param1:RenderSessionData) : void
      {
         if(this.outputBitmap)
         {
            this.outputBitmap.fillRect(this.outputBitmap.rect,0);
            this.bitmapContainer.bitmapData = this.inputBitmap;
            this.outputBitmap.draw(this.container,null,null,null,this.outputBitmap.rect,false);
            if(this.outputBitmap.transparent)
            {
               this.outputBitmap.copyChannel(this.inputBitmap,this.outputBitmap.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
            }
         }
      }
      
      public function clear() : void
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in this.shadeLayers)
         {
            if(this.inputBitmap && this.inputBitmap.width > 0 && this.inputBitmap.height > 0)
            {
               _loc1_.graphics.clear();
               _loc1_.graphics.beginFill(0,1);
               _loc1_.graphics.drawRect(0,0,this.inputBitmap.width,this.inputBitmap.height);
               _loc1_.graphics.endFill();
            }
         }
      }
      
      public function destroy() : void
      {
         this.bitmapLayer = null;
         this.outputBitmap.dispose();
      }
      
      public function getLayerForShader(param1:Shader) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         this.shadeLayers[param1] = _loc2_;
         var _loc3_:Sprite = new Sprite();
         _loc2_.addChild(_loc3_);
         if(this.inputBitmap != null)
         {
            _loc3_.graphics.beginFill(0,0);
            _loc3_.graphics.drawRect(0,0,this.inputBitmap.width,this.inputBitmap.height);
            _loc3_.graphics.endFill();
         }
         this.container.addChild(_loc2_);
         _loc2_.blendMode = param1.layerBlendMode;
         return _loc2_;
      }
      
      public function set inputBitmap(param1:BitmapData) : void
      {
         if(param1 != null)
         {
            if(this._inputBitmapData != param1)
            {
               this._inputBitmapData = param1;
               if(this.outputBitmap)
               {
                  if(this._inputBitmapData.width != this.outputBitmap.width || this._inputBitmapData.height != this.outputBitmap.height)
                  {
                     this.resizedInput = true;
                     this.outputBitmap.dispose();
                     this.outputBitmap = this._inputBitmapData.clone();
                  }
               }
               else
               {
                  this.resizedInput = true;
                  this.outputBitmap = this._inputBitmapData.clone();
               }
            }
         }
      }
      
      public function get inputBitmap() : BitmapData
      {
         return this._inputBitmapData;
      }
   }
}
