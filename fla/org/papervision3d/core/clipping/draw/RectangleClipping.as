package org.papervision3d.core.clipping.draw
{
   import org.papervision3d.core.render.command.RenderableListItem;
   
   public class RectangleClipping extends Clipping
   {
       
      
      public function RectangleClipping(param1:Number = -1000000, param2:Number = -1000000, param3:Number = 1000000, param4:Number = 1000000)
      {
         super();
         this.minX = param1;
         this.maxX = param3;
         this.minY = param2;
         this.maxY = param4;
      }
      
      override public function asRectangleClipping() : RectangleClipping
      {
         return this;
      }
      
      override public function check(param1:RenderableListItem) : Boolean
      {
         if(param1.maxX < minX)
         {
            return false;
         }
         if(param1.minX > maxX)
         {
            return false;
         }
         if(param1.maxY < minY)
         {
            return false;
         }
         if(param1.minY > maxY)
         {
            return false;
         }
         return true;
      }
      
      override public function rect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         if(this.maxX < param1)
         {
            return false;
         }
         if(this.minX > param3)
         {
            return false;
         }
         if(this.maxY < param2)
         {
            return false;
         }
         if(this.minY > param4)
         {
            return false;
         }
         return true;
      }
      
      public function toString() : String
      {
         return "{minX:" + minX + " maxX:" + maxX + " minY:" + minY + " maxY:" + maxY + "}";
      }
   }
}
