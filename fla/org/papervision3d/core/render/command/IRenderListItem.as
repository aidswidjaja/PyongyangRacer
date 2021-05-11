package org.papervision3d.core.render.command
{
   import flash.display.Graphics;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public interface IRenderListItem
   {
       
      
      function render(param1:RenderSessionData, param2:Graphics) : void;
   }
}
