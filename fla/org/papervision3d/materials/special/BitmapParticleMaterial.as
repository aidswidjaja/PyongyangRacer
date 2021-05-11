package org.papervision3d.materials.special
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.util.FastRectangleTools;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.IParticleDrawer;
   
   public class BitmapParticleMaterial extends ParticleMaterial implements IParticleDrawer
   {
       
      
      private var renderRect:Rectangle;
      
      public var particleBitmap:ParticleBitmap;
      
      public function BitmapParticleMaterial(param1:*, param2:Number = 1, param3:Number = 0, param4:Number = 0)
      {
         super(0,0);
         this.renderRect = new Rectangle();
         if(param1 is BitmapData)
         {
            this.particleBitmap = new ParticleBitmap(param1 as BitmapData);
            this.particleBitmap.scaleX = this.particleBitmap.scaleY = param2;
            this.particleBitmap.offsetX = param3;
            this.particleBitmap.offsetY = param4;
         }
         else if(param1 is ParticleBitmap)
         {
            this.particleBitmap = param1 as ParticleBitmap;
         }
      }
      
      override public function drawParticle(param1:Particle, param2:Graphics, param3:RenderSessionData) : void
      {
         var _loc6_:Number2D = null;
         var _loc7_:Number2D = null;
         var _loc8_:Number2D = null;
         var _loc9_:Number2D = null;
         var _loc10_:Number2D = null;
         var _loc4_:Number = param1.renderScale * param1.size;
         var _loc5_:Rectangle = param3.viewPort.cullingRectangle;
         this.renderRect = FastRectangleTools.intersection(_loc5_,param1.renderRect,this.renderRect);
         param2.beginBitmapFill(this.particleBitmap.bitmap,param1.drawMatrix,false,smooth);
         if(param1.rotationZ == 0)
         {
            param2.drawRect(this.renderRect.x,this.renderRect.y,this.renderRect.width,this.renderRect.height);
         }
         else
         {
            _loc6_ = new Number2D(this.particleBitmap.offsetX,this.particleBitmap.offsetY);
            _loc7_ = new Number2D(this.particleBitmap.offsetX + this.particleBitmap.width,this.particleBitmap.offsetY);
            _loc8_ = new Number2D(this.particleBitmap.offsetX + this.particleBitmap.width,this.particleBitmap.offsetY + this.particleBitmap.height);
            _loc9_ = new Number2D(this.particleBitmap.offsetX,this.particleBitmap.offsetY + this.particleBitmap.height);
            _loc6_.multiplyEq(_loc4_);
            _loc7_.multiplyEq(_loc4_);
            _loc8_.multiplyEq(_loc4_);
            _loc9_.multiplyEq(_loc4_);
            _loc6_.rotate(param1.rotationZ);
            _loc7_.rotate(param1.rotationZ);
            _loc8_.rotate(param1.rotationZ);
            _loc9_.rotate(param1.rotationZ);
            _loc10_ = new Number2D(param1.vertex3D.vertex3DInstance.x,param1.vertex3D.vertex3DInstance.y);
            _loc6_.plusEq(_loc10_);
            _loc7_.plusEq(_loc10_);
            _loc8_.plusEq(_loc10_);
            _loc9_.plusEq(_loc10_);
            param2.moveTo(_loc6_.x,_loc6_.y);
            param2.lineTo(_loc7_.x,_loc7_.y);
            param2.lineTo(_loc8_.x,_loc8_.y);
            param2.lineTo(_loc9_.x,_loc9_.y);
         }
         param2.endFill();
         ++param3.renderStatistics.particles;
      }
      
      override public function updateRenderRect(param1:Particle) : void
      {
         var _loc2_:Rectangle = param1.renderRect;
         var _loc3_:Number = param1.renderScale * param1.size;
         var _loc4_:Number = this.particleBitmap.offsetX * _loc3_;
         var _loc5_:Number = this.particleBitmap.offsetY * _loc3_;
         var _loc6_:Vertex3DInstance = param1.vertex3D.vertex3DInstance;
         _loc2_.x = _loc6_.x + _loc4_;
         _loc2_.y = _loc6_.y + _loc5_;
         _loc2_.width = this.particleBitmap.width * this.particleBitmap.scaleX * _loc3_;
         _loc2_.height = this.particleBitmap.height * this.particleBitmap.scaleY * _loc3_;
         var _loc7_:Matrix;
         (_loc7_ = param1.drawMatrix).identity();
         if(param1.rotationZ != 0)
         {
            _loc7_.scale(_loc2_.width / this.particleBitmap.width,_loc2_.height / this.particleBitmap.height);
            _loc7_.translate(_loc4_,_loc5_);
            _loc7_.rotate(param1.rotationZ * Number3D.toRADIANS);
            _loc7_.translate(_loc6_.x,_loc6_.y);
         }
         else
         {
            _loc7_.scale(_loc2_.width / this.particleBitmap.width,_loc2_.height / this.particleBitmap.height);
            _loc7_.translate(_loc2_.left,_loc2_.top);
         }
      }
   }
}
