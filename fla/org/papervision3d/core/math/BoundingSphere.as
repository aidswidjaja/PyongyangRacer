package org.papervision3d.core.math
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class BoundingSphere
   {
       
      
      public var maxDistance:Number;
      
      public var radius:Number;
      
      public function BoundingSphere(param1:Number)
      {
         super();
         this.maxDistance = param1;
         this.radius = Math.sqrt(param1);
      }
      
      public static function getFromVertices(param1:Array) : BoundingSphere
      {
         var _loc3_:Number = NaN;
         var _loc4_:Vertex3D = null;
         var _loc2_:Number = 0;
         for each(_loc4_ in param1)
         {
            _loc3_ = _loc4_.x * _loc4_.x + _loc4_.y * _loc4_.y + _loc4_.z * _loc4_.z;
            _loc2_ = _loc3_ > _loc2_ ? Number(_loc3_) : Number(_loc2_);
         }
         return new BoundingSphere(_loc2_);
      }
   }
}
