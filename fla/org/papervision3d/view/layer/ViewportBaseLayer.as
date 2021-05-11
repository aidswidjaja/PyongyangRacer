package org.papervision3d.view.layer
{
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   
   public class ViewportBaseLayer extends ViewportLayer
   {
       
      
      public function ViewportBaseLayer(param1:Viewport3D)
      {
         super(param1,null);
      }
      
      override public function getChildLayer(param1:DisplayObject3D, param2:Boolean = true, param3:Boolean = false) : ViewportLayer
      {
         if(layers[param1])
         {
            return layers[param1];
         }
         if(param2 || param1.useOwnContainer)
         {
            return getChildLayerFor(param1,param3);
         }
         return this;
      }
      
      override public function updateBeforeRender() : void
      {
         clear();
         var _loc1_:int = childLayers.length - 1;
         while(_loc1_ >= 0)
         {
            if(childLayers[_loc1_].dynamicLayer)
            {
               removeLayerAt(_loc1_);
            }
            _loc1_--;
         }
         super.updateBeforeRender();
      }
   }
}
