package org.papervision3d.core.material
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   
   public class TriangleMaterial extends MaterialObject3D implements ITriangleDrawer
   {
       
      
      public function TriangleMaterial()
      {
         super();
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
      }
      
      override public function drawRT(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData) : void
      {
      }
   }
}
