package org.papervision3d.core.culling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.util.FastRectangleTools;
   
   public class RectangleParticleCuller implements IParticleCuller
   {
      
      private static var vInstance:Vertex3DInstance;
      
      private static var testPoint:Point;
       
      
      public var cullingRectangle:Rectangle;
      
      public function RectangleParticleCuller(param1:Rectangle = null)
      {
         super();
         this.cullingRectangle = param1;
         testPoint = new Point();
      }
      
      public function testParticle(param1:Particle) : Boolean
      {
         vInstance = param1.vertex3D.vertex3DInstance;
         if(param1.material.invisible == false)
         {
            if(vInstance.visible)
            {
               if(FastRectangleTools.intersects(param1.renderRect,this.cullingRectangle))
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}
