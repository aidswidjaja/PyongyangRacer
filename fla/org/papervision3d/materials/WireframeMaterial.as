package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   
   public class WireframeMaterial extends TriangleMaterial implements ITriangleDrawer
   {
       
      
      public function WireframeMaterial(param1:Number = 16711935, param2:Number = 100, param3:Number = 0)
      {
         super();
         this.lineColor = param1;
         this.lineAlpha = param2;
         this.lineThickness = param3;
         this.doubleSided = false;
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:Number = param1.v0.x;
         var _loc7_:Number = param1.v0.y;
         if(lineAlpha)
         {
            param2.lineStyle(lineThickness,lineColor,lineAlpha);
            param2.moveTo(_loc6_,_loc7_);
            param2.lineTo(param1.v1.x,param1.v1.y);
            param2.lineTo(param1.v2.x,param1.v2.y);
            param2.lineTo(_loc6_,_loc7_);
            param2.lineStyle();
            ++param3.renderStatistics.triangles;
         }
      }
      
      override public function toString() : String
      {
         return "WireframeMaterial - color:" + this.lineColor + " alpha:" + this.lineAlpha;
      }
   }
}
