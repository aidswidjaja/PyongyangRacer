package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Stage;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.core.render.material.IUpdateAfterMaterial;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   
   public class MovieMaterial extends BitmapMaterial implements ITriangleDrawer, IUpdateBeforeMaterial, IUpdateAfterMaterial
   {
       
      
      protected var recreateBitmapInSuper:Boolean;
      
      private var materialIsUsed:Boolean = false;
      
      public var movie:DisplayObject;
      
      public var movieTransparent:Boolean;
      
      public var allowAutoResize:Boolean = false;
      
      private var userClipRect:Rectangle;
      
      private var autoClipRect:Rectangle;
      
      private var movieAnimated:Boolean;
      
      private var quality:String;
      
      private var stage:Stage;
      
      public function MovieMaterial(param1:DisplayObject = null, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Rectangle = null)
      {
         super();
         this.movieTransparent = param2;
         this.animated = param3;
         this.precise = param4;
         this.userClipRect = param5;
         if(param1)
         {
            this.texture = param1;
         }
      }
      
      public function get animated() : Boolean
      {
         return this.movieAnimated;
      }
      
      public function set animated(param1:Boolean) : void
      {
         this.movieAnimated = param1;
      }
      
      override public function get texture() : Object
      {
         return this._texture;
      }
      
      override public function set texture(param1:Object) : void
      {
         if(param1 is DisplayObject == false)
         {
            PaperLogger.error("MovieMaterial.texture requires a Sprite to be passed as the object");
            return;
         }
         bitmap = this.createBitmapFromSprite(DisplayObject(param1));
         _texture = param1;
      }
      
      public function get rect() : Rectangle
      {
         var _loc1_:Rectangle = this.userClipRect || this.autoClipRect;
         if(!_loc1_ && this.movie)
         {
            _loc1_ = this.movie.getBounds(this.movie);
         }
         return _loc1_;
      }
      
      public function set rect(param1:Rectangle) : void
      {
         this.userClipRect = param1;
         this.createBitmapFromSprite(this.movie);
      }
      
      protected function createBitmapFromSprite(param1:DisplayObject) : BitmapData
      {
         this.movie = param1;
         this.initBitmap(this.movie);
         this.drawBitmap();
         bitmap = super.createBitmap(bitmap);
         return bitmap;
      }
      
      protected function initBitmap(param1:DisplayObject) : void
      {
         if(bitmap)
         {
            bitmap.dispose();
         }
         if(this.userClipRect)
         {
            bitmap = new BitmapData(int(this.userClipRect.width + 0.5),int(this.userClipRect.height + 0.5),this.movieTransparent,fillColor);
         }
         else if(param1.width == 0 || param1.height == 0)
         {
            bitmap = new BitmapData(256,256,this.movieTransparent,fillColor);
         }
         else
         {
            bitmap = new BitmapData(int(param1.width + 0.5),int(param1.height + 0.5),this.movieTransparent,fillColor);
         }
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         this.materialIsUsed = true;
         super.drawTriangle(param1,param2,param3,param4,param5);
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.materialIsUsed = false;
         if(this.movieAnimated)
         {
            if(this.userClipRect)
            {
               _loc2_ = int(this.userClipRect.width + 0.5);
               _loc3_ = int(this.userClipRect.height + 0.5);
            }
            else
            {
               _loc2_ = int(this.movie.width + 0.5);
               _loc3_ = int(this.movie.height + 0.5);
            }
            if(this.allowAutoResize && (_loc2_ != bitmap.width || _loc3_ != bitmap.height))
            {
               this.initBitmap(this.movie);
               this.recreateBitmapInSuper = true;
            }
         }
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
         if(this.movieAnimated == true && this.materialIsUsed == true)
         {
            this.drawBitmap();
            if(this.recreateBitmapInSuper)
            {
               bitmap = super.createBitmap(bitmap);
               this.recreateBitmapInSuper = false;
            }
         }
      }
      
      public function drawBitmap() : void
      {
         var _loc3_:String = null;
         bitmap.fillRect(bitmap.rect,fillColor);
         if(this.stage && this.quality)
         {
            _loc3_ = this.stage.quality;
            this.stage.quality = this.quality;
         }
         var _loc1_:Rectangle = this.rect;
         var _loc2_:Matrix = new Matrix(1,0,0,1,-_loc1_.x,-_loc1_.y);
         bitmap.draw(this.movie,_loc2_,this.movie.transform.colorTransform,null);
         if(!this.userClipRect)
         {
            this.autoClipRect = this.movie.getBounds(this.movie);
         }
         if(this.stage && this.quality)
         {
            this.stage.quality = _loc3_;
         }
      }
      
      public function setQuality(param1:String, param2:Stage, param3:Boolean = true) : void
      {
         this.quality = param1;
         this.stage = param2;
         if(param3)
         {
            this.createBitmapFromSprite(this.movie);
         }
      }
   }
}
