package org.papervision3d.core.render.sort
{
   public class BasicRenderSorter implements IRenderSorter
   {
       
      
      public function BasicRenderSorter()
      {
         super();
      }
      
      public function sort(param1:Array) : void
      {
         param1.sortOn("screenZ",Array.NUMERIC);
      }
   }
}
