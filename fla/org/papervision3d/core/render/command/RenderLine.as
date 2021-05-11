package org.papervision3d.core.render.command
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.LineMaterial;
   
   public class RenderLine extends RenderableListItem implements IRenderListItem
   {
      
      private static var lineVector:Number3D = Number3D.ZERO;
      
      private static var mouseVector:Number3D = Number3D.ZERO;
       
      
      public var line:Line3D;
      
      public var renderer:LineMaterial;
      
      private var p:Number2D;
      
      private var l1:Number2D;
      
      private var l2:Number2D;
      
      private var v:Number2D;
      
      private var cp3d:Number3D;
      
      public var v0:Vertex3DInstance;
      
      public var v1:Vertex3DInstance;
      
      public var cV:Vertex3DInstance;
      
      public var size:Number;
      
      public var length:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var azf:Number;
      
      private var bzf:Number;
      
      private var faz:Number;
      
      private var fbz:Number;
      
      private var xfocus:Number;
      
      private var yfocus:Number;
      
      private var axf:Number;
      
      private var bxf:Number;
      
      private var ayf:Number;
      
      private var byf:Number;
      
      private var det:Number;
      
      private var db:Number;
      
      private var da:Number;
      
      public function RenderLine(param1:Line3D)
      {
         super();
         this.renderable = Line3D;
         this.renderableInstance = param1;
         this.line = param1;
         this.instance = param1.instance;
         this.v0 = param1.v0.vertex3DInstance;
         this.v1 = param1.v1.vertex3DInstance;
         this.cV = param1.cV.vertex3DInstance;
         this.p = new Number2D();
         this.l1 = new Number2D();
         this.l2 = new Number2D();
         this.v = new Number2D();
         this.cp3d = new Number3D();
      }
      
      override public function render(param1:RenderSessionData, param2:Graphics) : void
      {
         this.renderer.drawLine(this,param2,param1);
      }
      
      override public function hitTestPoint2D(param1:Point, param2:RenderHitData) : RenderHitData
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.renderer.interactive)
         {
            _loc3_ = this.line.size;
            this.p.reset(param1.x,param1.y);
            this.l1.reset(this.line.v0.vertex3DInstance.x,this.line.v0.vertex3DInstance.y);
            this.l2.reset(this.line.v1.vertex3DInstance.x,this.line.v1.vertex3DInstance.y);
            this.v.copyFrom(this.l2);
            this.v.minusEq(this.l1);
            if((_loc4_ = ((this.p.x - this.l1.x) * (this.l2.x - this.l1.x) + (this.p.y - this.l1.y) * (this.l2.y - this.l1.y)) / (this.v.x * this.v.x + this.v.y * this.v.y)) > 0 && _loc4_ < 1)
            {
               this.v.multiplyEq(_loc4_);
               this.v.plusEq(this.l1);
               this.v.minusEq(this.p);
               if((_loc5_ = this.v.x * this.v.x + this.v.y * this.v.y) < _loc3_ * _loc3_)
               {
                  param2.displayObject3D = this.line.instance;
                  param2.material = this.renderer;
                  param2.renderable = this.line;
                  param2.hasHit = true;
                  this.cp3d.reset(this.line.v1.x - this.line.v0.x,this.line.v1.y - this.line.v0.y,this.line.v1.x - this.line.v0.x);
                  this.cp3d.x *= _loc4_;
                  this.cp3d.y *= _loc4_;
                  this.cp3d.z *= _loc4_;
                  this.cp3d.x += this.line.v0.x;
                  this.cp3d.y += this.line.v0.y;
                  this.cp3d.z += this.line.v0.z;
                  param2.x = this.cp3d.x;
                  param2.y = this.cp3d.y;
                  param2.z = this.cp3d.z;
                  param2.u = 0;
                  param2.v = 0;
                  return param2;
               }
            }
         }
         return param2;
      }
      
      override public function getZ(param1:Number, param2:Number, param3:Number) : Number
      {
         this.ax = this.v0.x;
         this.ay = this.v0.y;
         this.az = this.v0.z;
         this.bx = this.v1.x;
         this.by = this.v1.y;
         this.bz = this.v1.z;
         if(this.ax == param1 && this.ay == param2)
         {
            return this.az;
         }
         if(this.bx == param1 && this.by == param2)
         {
            return this.bz;
         }
         this.dx = this.bx - this.ax;
         this.dy = this.by - this.ay;
         this.azf = this.az / param3;
         this.bzf = this.bz / param3;
         this.faz = 1 + this.azf;
         this.fbz = 1 + this.bzf;
         this.xfocus = param1;
         this.yfocus = param2;
         this.axf = this.ax * this.faz - param1 * this.azf;
         this.bxf = this.bx * this.fbz - param1 * this.bzf;
         this.ayf = this.ay * this.faz - param2 * this.azf;
         this.byf = this.by * this.fbz - param2 * this.bzf;
         this.det = this.dx * (this.axf - this.bxf) + this.dy * (this.ayf - this.byf);
         this.db = this.dx * (this.axf - param1) + this.dy * (this.ayf - param2);
         this.da = this.dx * (param1 - this.bxf) + this.dy * (param2 - this.byf);
         return (this.da * this.az + this.db * this.bz) / this.det;
      }
   }
}
