package org.papervision3d.core.clipping
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class DefaultClipping
   {
       
      
      public function DefaultClipping()
      {
         super();
      }
      
      public function reset(param1:RenderSessionData) : void
      {
      }
      
      public function setDisplayObject(param1:DisplayObject3D, param2:RenderSessionData) : void
      {
      }
      
      public function testFace(param1:Triangle3D, param2:DisplayObject3D, param3:RenderSessionData) : Boolean
      {
         return false;
      }
      
      public function testTerrainFace(param1:Triangle3D, param2:DisplayObject3D, param3:RenderSessionData) : Boolean
      {
         return false;
      }
      
      public function clipFace(param1:Triangle3D, param2:DisplayObject3D, param3:MaterialObject3D, param4:RenderSessionData, param5:Array) : Number
      {
         return 0;
      }
      
      public function clipTerrainFace(param1:Triangle3D, param2:DisplayObject3D, param3:MaterialObject3D, param4:RenderSessionData, param5:Array) : Number
      {
         return 0;
      }
   }
}
