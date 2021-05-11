package org.papervision3d.core.utils
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Mouse3D extends DisplayObject3D
   {
      
      private static var UP:Number3D = new Number3D(0,1,0);
      
      public static var enabled:Boolean = false;
       
      
      private var target:Number3D;
      
      public function Mouse3D()
      {
         this.target = new Number3D();
         super();
      }
      
      public function updatePosition(param1:RenderHitData) : void
      {
         var _loc5_:Number3D = null;
         var _loc6_:Number3D = null;
         var _loc7_:Matrix3D = null;
         var _loc2_:Triangle3D = param1.renderable as Triangle3D;
         this.target.x = _loc2_.faceNormal.x;
         this.target.y = _loc2_.faceNormal.y;
         this.target.z = _loc2_.faceNormal.z;
         var _loc3_:Number3D = Number3D.sub(this.target,position);
         _loc3_.normalize();
         if(_loc3_.modulo > 0.1)
         {
            (_loc5_ = Number3D.cross(_loc3_,UP)).normalize();
            (_loc6_ = Number3D.cross(_loc3_,_loc5_)).normalize();
            (_loc7_ = this.transform).n11 = _loc5_.x;
            _loc7_.n21 = _loc5_.y;
            _loc7_.n31 = _loc5_.z;
            _loc7_.n12 = -_loc6_.x;
            _loc7_.n22 = -_loc6_.y;
            _loc7_.n32 = -_loc6_.z;
            _loc7_.n13 = _loc3_.x;
            _loc7_.n23 = _loc3_.y;
            _loc7_.n33 = _loc3_.z;
         }
         var _loc4_:Matrix3D = Matrix3D.IDENTITY;
         this.transform = Matrix3D.multiply(_loc2_.instance.world,_loc7_);
         x = param1.x;
         y = param1.y;
         z = param1.z;
      }
   }
}
