package org.papervision3d.core.view
{
   public interface IView
   {
       
      
      function singleRender() : void;
      
      function startRendering() : void;
      
      function stopRendering(param1:Boolean = false, param2:Boolean = false) : void;
   }
}
