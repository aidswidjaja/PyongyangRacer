package org.papervision3d.materials.special
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.log.PaperLogger;
   
   public class ParticleBitmap
   {
      
      private static var drawMatrix:Matrix = new Matrix();
      
      private static var tempSprite:Sprite = new Sprite();
       
      
      public var offsetX:Number;
      
      public var offsetY:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      public var bitmap:BitmapData;
      
      public var width:int;
      
      public var height:int;
      
      public function ParticleBitmap(param1:* = null, param2:Number = 1, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         this.offsetX = 0;
         this.offsetY = 0;
         this.scaleX = param2;
         this.scaleY = param2;
         if(param1 is BitmapData)
         {
            this.bitmap = param1 as BitmapData;
            this.width = this.bitmap.width;
            this.height = this.bitmap.height;
         }
         else if(param1 is DisplayObject)
         {
            this.create(param1 as DisplayObject,param2);
         }
      }
      
      public function create(param1:DisplayObject, param2:Number = 1) : BitmapData
      {
         var _loc3_:Rectangle = param1.getBounds(param1);
         if(param2 != 1)
         {
            _loc3_.left = Math.floor(_loc3_.left * param2);
            _loc3_.right = Math.ceil(_loc3_.right * param2);
            _loc3_.top = Math.floor(_loc3_.top * param2);
            _loc3_.bottom = Math.ceil(_loc3_.bottom * param2);
            this.scaleX = this.scaleY = 1 / param2;
         }
         else
         {
            this.scaleX = this.scaleY = 1;
         }
         this.width = _loc3_.width;
         this.height = _loc3_.height;
         this.offsetX = _loc3_.left / param2;
         this.offsetY = _loc3_.top / param2;
         drawMatrix.identity();
         drawMatrix.translate(-this.offsetX,-this.offsetY);
         drawMatrix.scale(1 / this.scaleX,1 / this.scaleY);
         this.width = this.width == 0 ? 1 : int(this.width);
         this.height = this.height == 0 ? 1 : int(this.height);
         var _loc4_:int = this.roundUpToMipMap(this.width);
         var _loc5_:int = this.roundUpToMipMap(this.height);
         if(_loc4_ < this.width)
         {
            this.scaleX = this.width / _loc4_;
         }
         if(_loc5_ < this.height)
         {
            this.scaleY = this.height / _loc5_;
         }
         if(!this.bitmap || this.bitmap.width < _loc4_ || this.bitmap.height < _loc5_ || this.bitmap.height >> 1 >= _loc5_ || this.bitmap.width >> 1 >= _loc4_)
         {
            this.bitmap = new BitmapData(_loc4_,_loc5_,true,0);
         }
         else
         {
            _loc3_.x = 0;
            _loc3_.y = 0;
            this.bitmap.fillRect(_loc3_,0);
         }
         this.bitmap.draw(param1,drawMatrix,null,null,null,true);
         return this.bitmap;
      }
      
      public function createExact(param1:DisplayObject, param2:Number = 1, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 0) : BitmapData
      {
         this.scaleX = param4;
         this.scaleY = param5;
         if(param1.parent)
         {
            PaperLogger.warning("ParticleBitmap.createExact - particle movie shouldn\'t be a child of anything else ");
         }
         tempSprite.addChild(param1);
         param1.x = param2;
         param1.y = param3;
         param1.rotation = param6;
         param1.scaleX = param4;
         param1.scaleY = param5;
         var _loc7_:Rectangle = param1.getBounds(tempSprite);
         tempSprite.removeChild(param1);
         _loc7_.left = Math.floor(_loc7_.left);
         _loc7_.right = Math.ceil(_loc7_.right);
         _loc7_.top = Math.floor(_loc7_.top);
         _loc7_.bottom = Math.ceil(_loc7_.bottom);
         this.width = _loc7_.width;
         this.height = _loc7_.height;
         this.offsetX = _loc7_.left / param4;
         this.offsetY = _loc7_.top / param5;
         drawMatrix.identity();
         drawMatrix.translate(-this.offsetX,-this.offsetY);
         drawMatrix.scale(1 / param4,1 / param5);
         this.width = this.width == 0 ? 1 : int(this.width);
         this.height = this.height == 0 ? 1 : int(this.height);
         if(!this.bitmap || this.bitmap.width < this.width || this.bitmap.height < this.height)
         {
            this.bitmap = new BitmapData(this.width,this.height,true,0);
         }
         else
         {
            this.bitmap.fillRect(this.bitmap.rect,0);
         }
         this.bitmap.draw(param1,drawMatrix,null,null,null,true);
         return this.bitmap;
      }
      
      protected function roundUpToMipMap(param1:Number) : uint
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = Math.ceil(param1);
         var _loc3_:uint = 0;
         var _loc5_:Boolean = false;
         if(_loc2_ == 0 || _loc2_ == 1)
         {
            _loc5_ = true;
            _loc4_ = _loc2_;
         }
         while(!_loc5_)
         {
            if(_loc2_ == 2 || _loc2_ == 3)
            {
               _loc5_ = true;
               _loc4_ = Math.pow(2,_loc3_ + 2);
            }
            else
            {
               _loc3_++;
               _loc2_ >>= 1;
               if(_loc3_ >= 10)
               {
                  _loc4_ = 2048;
                  _loc5_ = true;
               }
            }
         }
         return _loc4_;
      }
      
      protected function getNearestMipMapSize(param1:Number) : uint
      {
         var _loc4_:uint = 0;
         var _loc2_:uint = Math.ceil(param1);
         var _loc3_:uint = 0;
         var _loc5_:Boolean = false;
         if(_loc2_ == 0 || _loc2_ == 1)
         {
            _loc5_ = true;
            _loc4_ = _loc2_;
         }
         while(!_loc5_)
         {
            if(_loc2_ == 2)
            {
               _loc5_ = true;
               _loc4_ = Math.pow(2,_loc3_ + 1);
            }
            else if(_loc2_ == 3)
            {
               _loc5_ = true;
               _loc4_ = Math.pow(2,_loc3_ + 2);
            }
            else
            {
               _loc3_++;
               _loc2_ >>= 1;
               if(_loc3_ >= 10)
               {
                  _loc4_ = 2048;
                  _loc5_ = true;
               }
            }
         }
         return _loc4_;
      }
   }
}
