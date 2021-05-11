package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   
   public interface ITriangleCuller
   {
       
      
      function testFace(param1:Triangle3D, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Boolean;
   }
}
