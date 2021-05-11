package org.papervision3d.core.culling
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.util.FastRectangleTools;
   
   public class RectangleTriangleCuller extends DefaultTriangleCuller implements ITriangleCuller
   {
      
      private static const DEFAULT_RECT_W:Number = 640;
      
      private static const DEFAULT_RECT_H:Number = 480;
      
      private static const DEFAULT_RECT_X:Number = -(DEFAULT_RECT_W / 2);
      
      private static const DEFAULT_RECT_Y:Number = -(DEFAULT_RECT_H / 2);
      
      private static var hitRect:Rectangle = new Rectangle();
       
      
      public var cullingRectangle:Rectangle;
      
      public function RectangleTriangleCuller(param1:Rectangle = null)
      {
         this.cullingRectangle = new Rectangle(DEFAULT_RECT_X,DEFAULT_RECT_Y,DEFAULT_RECT_W,DEFAULT_RECT_H);
         super();
         if(param1)
         {
            this.cullingRectangle = param1;
         }
      }
      
      override public function testFace(param1:Triangle3D, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Boolean
      {
         if(super.testFace(param1,param2,param3,param4))
         {
            hitRect.x = Math.min(param4.x,Math.min(param3.x,param2.x));
            hitRect.width = Math.max(param4.x,Math.max(param3.x,param2.x)) + Math.abs(hitRect.x);
            hitRect.y = Math.min(param4.y,Math.min(param3.y,param2.y));
            hitRect.height = Math.max(param4.y,Math.max(param3.y,param2.y)) + Math.abs(hitRect.y);
            return FastRectangleTools.intersects(this.cullingRectangle,hitRect);
         }
         return false;
      }
   }
}
