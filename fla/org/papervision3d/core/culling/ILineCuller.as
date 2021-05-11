package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Line3D;
   
   public interface ILineCuller
   {
       
      
      function testLine(param1:Line3D) : Boolean;
   }
}
