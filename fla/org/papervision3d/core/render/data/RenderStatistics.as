package org.papervision3d.core.render.data
{
   public class RenderStatistics
   {
       
      
      public var projectionTime:int = 0;
      
      public var renderTime:int = 0;
      
      public var rendered:int = 0;
      
      public var triangles:int = 0;
      
      public var culledTriangles:int = 0;
      
      public var particles:int = 0;
      
      public var culledParticles:int = 0;
      
      public var lines:int = 0;
      
      public var shadedTriangles:int = 0;
      
      public var filteredObjects:int = 0;
      
      public var culledObjects:int = 0;
      
      public function RenderStatistics()
      {
         super();
      }
      
      public function clear() : void
      {
         this.projectionTime = 0;
         this.renderTime = 0;
         this.rendered = 0;
         this.particles = 0;
         this.triangles = 0;
         this.culledTriangles = 0;
         this.culledParticles = 0;
         this.lines = 0;
         this.shadedTriangles = 0;
         this.filteredObjects = 0;
         this.culledObjects = 0;
      }
      
      public function clone() : RenderStatistics
      {
         var _loc1_:RenderStatistics = new RenderStatistics();
         _loc1_.projectionTime = this.projectionTime;
         _loc1_.renderTime = this.renderTime;
         _loc1_.rendered = this.rendered;
         _loc1_.particles = this.particles;
         _loc1_.triangles = this.triangles;
         _loc1_.culledTriangles = this.culledTriangles;
         _loc1_.lines = this.lines;
         _loc1_.shadedTriangles = this.shadedTriangles;
         _loc1_.filteredObjects = this.filteredObjects;
         _loc1_.culledObjects = this.culledObjects;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return new String("ProjectionTime:" + this.projectionTime + " RenderTime:" + this.renderTime + " Particles:" + this.particles + " CulledParticles :" + this.culledParticles + " Triangles:" + this.triangles + " ShadedTriangles :" + this.shadedTriangles + " CulledTriangles:" + this.culledTriangles + " FilteredObjects:" + this.filteredObjects + " CulledObjects:" + this.culledObjects + "");
      }
   }
}
