package org.papervision3d.core.culling
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class DefaultTriangleCuller implements ITriangleCuller
   {
      
      protected static var x0:Number;
      
      protected static var y0:Number;
      
      protected static var x1:Number;
      
      protected static var y1:Number;
      
      protected static var x2:Number;
      
      protected static var y2:Number;
       
      
      public function DefaultTriangleCuller()
      {
         super();
      }
      
      public function testFace(param1:Triangle3D, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Boolean
      {
         var _loc5_:MaterialObject3D = null;
         if(param2.visible && param3.visible && param4.visible)
         {
            if((_loc5_ = !!param1.material ? param1.material : param1.instance.material).invisible)
            {
               return false;
            }
            x0 = param2.x;
            y0 = param2.y;
            x1 = param3.x;
            y1 = param3.y;
            x2 = param4.x;
            y2 = param4.y;
            if(_loc5_.oneSide)
            {
               if(_loc5_.opposite)
               {
                  if((x2 - x0) * (y1 - y0) - (y2 - y0) * (x1 - x0) > 0)
                  {
                     return false;
                  }
               }
               else if((x2 - x0) * (y1 - y0) - (y2 - y0) * (x1 - x0) < 0)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
   }
}
