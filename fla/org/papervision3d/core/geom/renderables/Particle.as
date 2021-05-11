package org.papervision3d.core.geom.renderables
{
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderParticle;
   import org.papervision3d.materials.special.ParticleMaterial;
   
   public class Particle extends AbstractRenderable implements IRenderable
   {
       
      
      public var size:Number;
      
      public var vertex3D:Vertex3D;
      
      public var material:ParticleMaterial;
      
      public var renderCommand:RenderParticle;
      
      public var renderScale:Number;
      
      public var drawMatrix:Matrix;
      
      public var rotationZ:Number = 0;
      
      public var m_delta:Number = 0;
      
      public var renderRect:Rectangle;
      
      public function Particle(param1:ParticleMaterial, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:Number = 0)
      {
         super();
         this.material = param1;
         this.size = param2;
         this.renderCommand = new RenderParticle(this);
         this.renderRect = new Rectangle();
         this.vertex3D = new Vertex3D(param3,param4,param5);
         this.drawMatrix = new Matrix();
      }
      
      public function updateRenderRect() : void
      {
         this.material.updateRenderRect(this);
      }
      
      public function set x(param1:Number) : void
      {
         this.vertex3D.x = param1;
      }
      
      public function get x() : Number
      {
         return this.vertex3D.x;
      }
      
      public function set y(param1:Number) : void
      {
         this.vertex3D.y = param1;
      }
      
      public function get y() : Number
      {
         return this.vertex3D.y;
      }
      
      public function set z(param1:Number) : void
      {
         this.vertex3D.z = param1;
      }
      
      public function get z() : Number
      {
         return this.vertex3D.z;
      }
      
      override public function getRenderListItem() : IRenderListItem
      {
         return this.renderCommand;
      }
   }
}
