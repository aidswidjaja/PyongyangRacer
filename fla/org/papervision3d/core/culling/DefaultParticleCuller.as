package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Particle;
   
   public class DefaultParticleCuller implements IParticleCuller
   {
       
      
      public function DefaultParticleCuller()
      {
         super();
      }
      
      public function testParticle(param1:Particle) : Boolean
      {
         if(param1.material.invisible == false)
         {
            if(param1.vertex3D.vertex3DInstance.visible == true)
            {
               return true;
            }
         }
         return false;
      }
   }
}
