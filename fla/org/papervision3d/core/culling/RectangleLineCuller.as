package org.papervision3d.core.culling
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.math.util.FastRectangleTools;
   
   public class RectangleLineCuller implements ILineCuller
   {
       
      
      private var cullingRectangle:Rectangle;
      
      private var lineBoundsRect:Rectangle;
      
      private var rectIntersection:Rectangle;
      
      public function RectangleLineCuller(param1:Rectangle = null)
      {
         super();
         if(param1)
         {
            this.cullingRectangle = param1;
         }
         this.lineBoundsRect = new Rectangle();
         this.rectIntersection = new Rectangle();
      }
      
      public function testLine(param1:Line3D) : Boolean
      {
         if(!param1.v0.vertex3DInstance.visible || !param1.v1.vertex3DInstance.visible)
         {
            return false;
         }
         var _loc2_:Number = param1.v0.vertex3DInstance.x;
         var _loc3_:Number = param1.v0.vertex3DInstance.y;
         var _loc4_:Number = param1.v1.vertex3DInstance.x;
         var _loc5_:Number = param1.v1.vertex3DInstance.y;
         this.lineBoundsRect.width = Math.abs(_loc4_ - _loc2_);
         this.lineBoundsRect.height = Math.abs(_loc5_ - _loc3_);
         if(_loc2_ < _loc4_)
         {
            this.lineBoundsRect.x = _loc2_;
         }
         else
         {
            this.lineBoundsRect.x = _loc4_;
         }
         if(_loc3_ < _loc5_)
         {
            this.lineBoundsRect.y = _loc3_;
         }
         else
         {
            this.lineBoundsRect.y = _loc5_;
         }
         if(this.cullingRectangle.containsRect(this.lineBoundsRect))
         {
            return true;
         }
         if(!FastRectangleTools.intersects(this.lineBoundsRect,this.cullingRectangle))
         {
            return false;
         }
         this.rectIntersection = FastRectangleTools.intersection(this.lineBoundsRect,this.cullingRectangle);
         var _loc6_:Number = (_loc5_ - _loc3_) / (_loc4_ - _loc2_);
         var _loc7_:Number = _loc3_ - _loc6_ * _loc2_;
         var _loc8_:Number;
         if((_loc8_ = (this.cullingRectangle.top - _loc7_) / _loc6_) > this.rectIntersection.left && _loc8_ < this.rectIntersection.right)
         {
            return true;
         }
         if((_loc8_ = (this.cullingRectangle.bottom - _loc7_) / _loc6_) > this.rectIntersection.left && _loc8_ < this.rectIntersection.right)
         {
            return true;
         }
         var _loc9_:Number;
         if((_loc9_ = _loc6_ * this.cullingRectangle.left + _loc7_) > this.rectIntersection.top && _loc9_ < this.rectIntersection.bottom)
         {
            return true;
         }
         if((_loc9_ = _loc6_ * this.cullingRectangle.right + _loc7_) > this.rectIntersection.top && _loc9_ < this.rectIntersection.bottom)
         {
            return true;
         }
         return false;
      }
   }
}
