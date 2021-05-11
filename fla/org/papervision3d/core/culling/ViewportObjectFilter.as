package org.papervision3d.core.culling
{
   import flash.utils.Dictionary;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ViewportObjectFilter implements IObjectCuller
   {
       
      
      protected var _mode:int;
      
      protected var objects:Dictionary;
      
      public function ViewportObjectFilter(param1:int)
      {
         super();
         this.mode = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.objects = new Dictionary(true);
      }
      
      public function testObject(param1:DisplayObject3D) : int
      {
         if(this.objects[param1])
         {
            return 1 - this._mode;
         }
         return this.mode;
      }
      
      public function addObject(param1:DisplayObject3D) : void
      {
         this.objects[param1] = param1;
      }
      
      public function removeObject(param1:DisplayObject3D) : void
      {
         delete this.objects[param1];
      }
      
      public function set mode(param1:int) : void
      {
         this._mode = param1;
      }
      
      public function get mode() : int
      {
         return this._mode;
      }
      
      public function destroy() : void
      {
         this.objects = null;
      }
   }
}
