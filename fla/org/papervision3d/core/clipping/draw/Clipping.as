package org.papervision3d.core.clipping.draw
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.geom.Point;
   import org.papervision3d.core.render.command.RenderableListItem;
   
   public class Clipping
   {
       
      
      private var rectangleClipping:RectangleClipping;
      
      private var zeroPoint:Point;
      
      private var globalPoint:Point;
      
      public var minX:Number = -100000000;
      
      public var minY:Number = -1000000;
      
      public var maxX:Number = 1000000;
      
      public var maxY:Number = 1000000;
      
      public function Clipping()
      {
         this.zeroPoint = new Point(0,0);
         super();
      }
      
      public function check(param1:RenderableListItem) : Boolean
      {
         return true;
      }
      
      public function rect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         return true;
      }
      
      public function asRectangleClipping() : RectangleClipping
      {
         if(!this.rectangleClipping)
         {
            this.rectangleClipping = new RectangleClipping();
         }
         this.rectangleClipping.minX = -1000000;
         this.rectangleClipping.minY = -1000000;
         this.rectangleClipping.maxX = 1000000;
         this.rectangleClipping.maxY = 1000000;
         return this.rectangleClipping;
      }
      
      public function screen(param1:Sprite) : Clipping
      {
         if(!this.rectangleClipping)
         {
            this.rectangleClipping = new RectangleClipping();
         }
         switch(param1.stage.align)
         {
            case StageAlign.TOP_LEFT:
               this.zeroPoint.x = 0;
               this.zeroPoint.y = 0;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.maxX = (this.rectangleClipping.minX = this.globalPoint.x) + param1.stage.stageWidth;
               this.rectangleClipping.maxY = (this.rectangleClipping.minY = this.globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.TOP_RIGHT:
               this.zeroPoint.x = param1.stage.stageWidth;
               this.zeroPoint.y = 0;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = (this.rectangleClipping.maxX = this.globalPoint.x) - param1.stage.stageWidth;
               this.rectangleClipping.maxY = (this.rectangleClipping.minY = this.globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.zeroPoint.x = 0;
               this.zeroPoint.y = param1.stage.stageHeight;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.maxX = (this.rectangleClipping.minX = this.globalPoint.x) + param1.stage.stageWidth;
               this.rectangleClipping.minY = (this.rectangleClipping.maxY = this.globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.zeroPoint.x = param1.stage.stageWidth;
               this.zeroPoint.y = param1.stage.stageHeight;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = (this.rectangleClipping.maxX = this.globalPoint.x) - param1.stage.stageWidth;
               this.rectangleClipping.minY = (this.rectangleClipping.maxY = this.globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.TOP:
               this.zeroPoint.x = param1.stage.stageWidth / 2;
               this.zeroPoint.y = 0;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = this.globalPoint.x - param1.stage.stageWidth / 2;
               this.rectangleClipping.maxX = this.globalPoint.x + param1.stage.stageWidth / 2;
               this.rectangleClipping.maxY = (this.rectangleClipping.minY = this.globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM:
               this.zeroPoint.x = param1.stage.stageWidth / 2;
               this.zeroPoint.y = param1.stage.stageHeight;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = this.globalPoint.x - param1.stage.stageWidth / 2;
               this.rectangleClipping.maxX = this.globalPoint.x + param1.stage.stageWidth / 2;
               this.rectangleClipping.minY = (this.rectangleClipping.maxY = this.globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.LEFT:
               this.zeroPoint.x = 0;
               this.zeroPoint.y = param1.stage.stageHeight / 2;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.maxX = (this.rectangleClipping.minX = this.globalPoint.x) + param1.stage.stageWidth;
               this.rectangleClipping.minY = this.globalPoint.y - param1.stage.stageHeight / 2;
               this.rectangleClipping.maxY = this.globalPoint.y + param1.stage.stageHeight / 2;
               break;
            case StageAlign.RIGHT:
               this.zeroPoint.x = param1.stage.stageWidth;
               this.zeroPoint.y = param1.stage.stageHeight / 2;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = (this.rectangleClipping.maxX = this.globalPoint.x) - param1.stage.stageWidth;
               this.rectangleClipping.minY = this.globalPoint.y - param1.stage.stageHeight / 2;
               this.rectangleClipping.maxY = this.globalPoint.y + param1.stage.stageHeight / 2;
               break;
            default:
               this.zeroPoint.x = param1.stage.stageWidth / 2;
               this.zeroPoint.y = param1.stage.stageHeight / 2;
               this.globalPoint = param1.globalToLocal(this.zeroPoint);
               this.rectangleClipping.minX = this.globalPoint.x - param1.stage.stageWidth / 2;
               this.rectangleClipping.maxX = this.globalPoint.x + param1.stage.stageWidth / 2;
               this.rectangleClipping.minY = this.globalPoint.y - param1.stage.stageHeight / 2;
               this.rectangleClipping.maxY = this.globalPoint.y + param1.stage.stageHeight / 2;
         }
         return this.rectangleClipping;
      }
   }
}
