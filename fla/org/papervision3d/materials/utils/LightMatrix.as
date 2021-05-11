package org.papervision3d.materials.utils
{
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.proto.LightObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.lights.PointLight3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class LightMatrix
   {
      
      private static var lightMatrix:Matrix3D = Matrix3D.IDENTITY;
      
      private static var invMatrix:Matrix3D = Matrix3D.IDENTITY;
      
      private static var _targetPos:Number3D = new Number3D();
      
      private static var _lightPos:Number3D = new Number3D();
      
      private static var _lightDir:Number3D = new Number3D();
      
      private static var _lightUp:Number3D = new Number3D();
      
      private static var _lightSide:Number3D = new Number3D();
      
      protected static var UP:Number3D = new Number3D(0,1,0);
       
      
      public function LightMatrix()
      {
         super();
      }
      
      public static function getLightMatrix(param1:LightObject3D, param2:DisplayObject3D, param3:RenderSessionData, param4:Matrix3D) : Matrix3D
      {
         var _loc6_:Matrix3D = null;
         var _loc7_:Matrix3D = null;
         var _loc5_:Matrix3D = !!param4 ? param4 : Matrix3D.IDENTITY;
         if(param1 == null)
         {
            param1 = new PointLight3D();
            param1.copyPosition(param3.camera);
         }
         _targetPos.reset();
         _lightPos.reset();
         _lightDir.reset();
         _lightUp.reset();
         _lightSide.reset();
         _loc6_ = param1.transform;
         _loc7_ = param2.world;
         _lightPos.x = -_loc6_.n14;
         _lightPos.y = -_loc6_.n24;
         _lightPos.z = -_loc6_.n34;
         _targetPos.x = -_loc7_.n14;
         _targetPos.y = -_loc7_.n24;
         _targetPos.z = -_loc7_.n34;
         _lightDir.x = _targetPos.x - _lightPos.x;
         _lightDir.y = _targetPos.y - _lightPos.y;
         _lightDir.z = _targetPos.z - _lightPos.z;
         invMatrix.calculateInverse(param2.world);
         Matrix3D.multiplyVector3x3(invMatrix,_lightDir);
         _lightDir.normalize();
         _lightSide.x = _lightDir.y * UP.z - _lightDir.z * UP.y;
         _lightSide.y = _lightDir.z * UP.x - _lightDir.x * UP.z;
         _lightSide.z = _lightDir.x * UP.y - _lightDir.y * UP.x;
         _lightSide.normalize();
         _lightUp.x = _lightSide.y * _lightDir.z - _lightSide.z * _lightDir.y;
         _lightUp.y = _lightSide.z * _lightDir.x - _lightSide.x * _lightDir.z;
         _lightUp.z = _lightSide.x * _lightDir.y - _lightSide.y * _lightDir.x;
         _lightUp.normalize();
         if(Papervision3D.useRIGHTHANDED || param2.flipLightDirection)
         {
            _lightDir.x = -_lightDir.x;
            _lightDir.y = -_lightDir.y;
            _lightDir.z = -_lightDir.z;
         }
         _loc5_.n11 = _lightSide.x;
         _loc5_.n12 = _lightSide.y;
         _loc5_.n13 = _lightSide.z;
         _loc5_.n21 = _lightUp.x;
         _loc5_.n22 = _lightUp.y;
         _loc5_.n23 = _lightUp.z;
         _loc5_.n31 = _lightDir.x;
         _loc5_.n32 = _lightDir.y;
         _loc5_.n33 = _lightDir.z;
         return _loc5_;
      }
   }
}
