package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Line3D;
   
   public class DefaultLineCuller implements ILineCuller
   {
       
      
      public function DefaultLineCuller()
      {
         super();
      }
      
      public function testLine(param1:Line3D) : Boolean
      {
         return param1.v0.vertex3DInstance.visible && param1.v1.vertex3DInstance.visible;
      }
   }
}
