package org.papervision3d.core.render.draw
{
   import flash.display.Graphics;
   import org.papervision3d.core.render.command.RenderLine;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface ILineDrawer
   {
       
      
      function drawLine(param1:RenderLine, param2:Graphics, param3:RenderSessionData) : void;
   }
}
