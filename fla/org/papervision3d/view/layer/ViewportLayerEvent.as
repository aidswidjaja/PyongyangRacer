package org.papervision3d.view.layer
{
   import flash.events.Event;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class ViewportLayerEvent extends Event
   {
      
      public static const CHILD_ADDED:String = "childAdded";
      
      public static const CHILD_REMOVED:String = "childRemoved";
       
      
      public var do3d:DisplayObject3D;
      
      public var layer:ViewportLayer;
      
      public function ViewportLayerEvent(param1:String, param2:DisplayObject3D = null, param3:ViewportLayer = null)
      {
         super(param1,false,false);
         this.do3d = param2;
         this.layer = param3;
      }
   }
}
