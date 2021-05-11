package org.papervision3d.core.geom
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Particles extends Vertices3D
   {
      
      private static var _newID:int = 0;
       
      
      private var vertices:Array;
      
      public var particles:Array;
      
      public function Particles(param1:String = "Particles")
      {
         param1 += _newID++;
         this.vertices = new Array();
         this.particles = new Array();
         super(this.vertices,param1);
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc4_:Particle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.project(param1,param2);
         var _loc3_:Rectangle = param2.camera.viewport;
         if(this.culled)
         {
            return 0;
         }
         for each(_loc4_ in this.particles)
         {
            _loc5_ = param2.camera.focus * param2.camera.zoom;
            _loc6_ = param2.camera.focus;
            _loc4_.renderScale = _loc5_ / (_loc6_ + _loc4_.vertex3D.vertex3DInstance.particle_z);
            _loc4_.updateRenderRect();
            if(param2.viewPort.particleCuller.testParticle(_loc4_) && _loc4_.vertex3D.vertex3DInstance.particle_z > 0)
            {
               _loc4_.renderCommand.screenZ = _loc4_.vertex3D.vertex3DInstance.z + _loc4_.m_delta;
               param2.renderer.addToRenderList(_loc4_.renderCommand);
            }
            else
            {
               ++param2.renderStatistics.culledParticles;
            }
         }
         return 1;
      }
      
      public function addParticle(param1:Particle) : void
      {
         param1.instance = this;
         this.particles.push(param1);
         this.vertices.push(param1.vertex3D);
      }
      
      public function removeParticle(param1:Particle) : void
      {
         param1.instance = null;
         this.particles.splice(this.particles.indexOf(param1,0),1);
         this.vertices.splice(this.vertices.indexOf(param1.vertex3D,0),1);
      }
      
      public function removeDelayParticle(param1:int) : void
      {
         if(this.particles.length > param1)
         {
            this.particles.splice(0,1);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.particles.length)
         {
            this.particles[_loc2_].rotationZ = Math.random() % 180;
            _loc2_++;
         }
         if(this.vertices.length > param1)
         {
            this.vertices.splice(0,1);
            geometry.vertices = this.vertices;
         }
      }
      
      public function removeAllParticles() : void
      {
         this.particles = new Array();
         this.vertices = new Array();
         geometry.vertices = this.vertices;
      }
   }
}
