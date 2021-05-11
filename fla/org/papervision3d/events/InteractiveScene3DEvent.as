package org.papervision3d.events
{
   import flash.display.Sprite;
   import flash.events.Event;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class InteractiveScene3DEvent extends Event
   {
      
      public static const OBJECT_CLICK:String = "mouseClick";
      
      public static const OBJECT_DOUBLE_CLICK:String = "mouseDoubleClick";
      
      public static const OBJECT_OVER:String = "mouseOver";
      
      public static const OBJECT_OUT:String = "mouseOut";
      
      public static const OBJECT_MOVE:String = "mouseMove";
      
      public static const OBJECT_PRESS:String = "mousePress";
      
      public static const OBJECT_RELEASE:String = "mouseRelease";
      
      public static const OBJECT_RELEASE_OUTSIDE:String = "mouseReleaseOutside";
      
      public static const OBJECT_ADDED:String = "objectAdded";
       
      
      public var displayObject3D:DisplayObject3D = null;
      
      public var sprite:Sprite = null;
      
      public var face3d:Triangle3D = null;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var renderHitData:RenderHitData;
      
      public function InteractiveScene3DEvent(param1:String, param2:DisplayObject3D = null, param3:Sprite = null, param4:Triangle3D = null, param5:Number = 0, param6:Number = 0, param7:RenderHitData = null, param8:Boolean = false, param9:Boolean = false)
      {
         super(param1,param8,param9);
         this.displayObject3D = param2;
         this.sprite = param3;
         this.face3d = param4;
         this.x = param5;
         this.y = param6;
         this.renderHitData = param7;
      }
      
      override public function toString() : String
      {
         return "Type : " + type + ", DO3D : " + this.displayObject3D + " Sprite : " + this.sprite + " Face : " + this.face3d;
      }
   }
}
