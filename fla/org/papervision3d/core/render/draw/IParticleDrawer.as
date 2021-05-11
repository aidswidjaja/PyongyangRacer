package org.papervision3d.core.render.draw
{
   import flash.display.Graphics;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface IParticleDrawer
   {
       
      
      function drawParticle(param1:Particle, param2:Graphics, param3:RenderSessionData) : void;
      
      function updateRenderRect(param1:Particle) : void;
   }
}
