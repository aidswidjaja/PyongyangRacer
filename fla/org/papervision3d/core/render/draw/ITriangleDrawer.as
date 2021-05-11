package org.papervision3d.core.render.draw
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface ITriangleDrawer
   {
       
      
      function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void;
      
      function drawRT(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData) : void;
   }
}
