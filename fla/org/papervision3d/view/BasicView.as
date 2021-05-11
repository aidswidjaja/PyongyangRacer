package org.papervision3d.view
{
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.cameras.CameraType;
   import org.papervision3d.cameras.DebugCamera3D;
   import org.papervision3d.cameras.SpringCamera3D;
   import org.papervision3d.core.view.IView;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.render.BasicRenderEngine;
   import org.papervision3d.scenes.Scene3D;
   
   public class BasicView extends AbstractView implements IView
   {
       
      
      public function BasicView(param1:Number = 640, param2:Number = 480, param3:Boolean = true, param4:Boolean = false, param5:String = "Target")
      {
         super();
         scene = new Scene3D();
         viewport = new Viewport3D(param1,param2,param3,param4);
         addChild(viewport);
         renderer = new BasicRenderEngine();
         switch(param5)
         {
            case CameraType.DEBUG:
               _camera = new DebugCamera3D(viewport);
               break;
            case CameraType.TARGET:
               _camera = new Camera3D(60);
               _camera.target = DisplayObject3D.ZERO;
               break;
            case CameraType.SPRING:
               _camera = new SpringCamera3D();
               _camera.target = DisplayObject3D.ZERO;
               break;
            case CameraType.FREE:
            default:
               _camera = new Camera3D(60);
         }
         this.cameraAsCamera3D.update(viewport.sizeRectangle);
      }
      
      public function get cameraAsCamera3D() : Camera3D
      {
         return _camera as Camera3D;
      }
      
      public function get cameraAsDebugCamera3D() : DebugCamera3D
      {
         return _camera as DebugCamera3D;
      }
   }
}
