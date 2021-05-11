package org.papervision3d.lights
{
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.LightObject3D;
   
   public class PointLight3D extends LightObject3D
   {
      
      public static var DEFAULT_POS:Number3D = new Number3D(0,0,-1000);
       
      
      public function PointLight3D(param1:Boolean = false, param2:Boolean = false)
      {
         super(param1,param2);
         x = DEFAULT_POS.x;
         y = DEFAULT_POS.y;
         z = DEFAULT_POS.z;
      }
   }
}
