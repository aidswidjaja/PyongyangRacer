package object
{
   import flash.geom.Vector3D;
   
   public class RBSphere3
   {
       
      
      public var m_radius:Number;
      
      public var m_loc:Vector3D;
      
      public function RBSphere3(param1:Number, param2:Vector3D)
      {
         this.m_loc = new Vector3D();
         super();
         this.m_radius = param1;
         this.m_loc = param2.clone();
      }
      
      public static function Intersect(param1:RBSphere3, param2:RBSphere3) : Boolean
      {
         var _loc3_:Vector3D = param2.m_loc.subtract(param1.m_loc);
         if(_loc3_.length > param1.m_radius + param2.m_radius)
         {
            return false;
         }
         return true;
      }
      
      public function ReSet(param1:Number, param2:Vector3D) : void
      {
         this.m_radius = param1;
         this.m_loc = param2.clone();
      }
   }
}
