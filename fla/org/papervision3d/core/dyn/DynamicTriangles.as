package org.papervision3d.core.dyn
{
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.special.CompositeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class DynamicTriangles
   {
      
      private static const GROW_SIZE:int = 300;
      
      private static const INIT_SIZE:int = 100;
      
      private static var triangleCounter:int;
      
      private static var trianglePool:Array;
       
      
      public function DynamicTriangles()
      {
         super();
         init();
      }
      
      private static function init() : void
      {
         trianglePool = new Array(INIT_SIZE);
         var _loc1_:int = INIT_SIZE;
         while(--_loc1_ > -1)
         {
            trianglePool[_loc1_] = new Triangle3D(null,null,null,null,true);
         }
         triangleCounter = INIT_SIZE;
      }
      
      public function getTriangle(param1:DisplayObject3D = null, param2:MaterialObject3D = null, param3:Vertex3D = null, param4:Vertex3D = null, param5:Vertex3D = null, param6:NumberUV = null, param7:NumberUV = null, param8:NumberUV = null) : Triangle3D
      {
         var _loc9_:int = 0;
         var _loc10_:Triangle3D = null;
         var _loc11_:MaterialObject3D = null;
         if(triangleCounter == 0)
         {
            _loc9_ = GROW_SIZE;
            while(--_loc9_ > -1)
            {
               trianglePool.unshift(new Triangle3D(null,null,null,null,true));
            }
            triangleCounter = GROW_SIZE;
            return this.getTriangle(param1,param2,param3,param4,param5,param6,param7,param8);
         }
         if((_loc10_ = Triangle3D(trianglePool[--triangleCounter])).material)
         {
            if(_loc10_.material is BitmapMaterial && BitmapMaterial(_loc10_.material).uvMatrices)
            {
               BitmapMaterial(_loc10_.material).uvMatrices[_loc10_.renderCommand] = null;
            }
            if(_loc10_.material is CompositeMaterial)
            {
               for each(_loc11_ in CompositeMaterial(_loc10_.material).materials)
               {
                  if(_loc11_ is BitmapMaterial && BitmapMaterial(_loc11_).uvMatrices)
                  {
                     BitmapMaterial(_loc11_).uvMatrices[_loc10_.renderCommand] = null;
                  }
               }
            }
         }
         _loc10_.instance = param1;
         _loc10_.vertices = [param3,param4,param5];
         _loc10_.uv = [param6,param7,param8];
         _loc10_.updateVertices();
         _loc10_.createNormal();
         _loc10_.material = param2;
         return _loc10_;
      }
      
      public function releaseAll() : void
      {
         this.returnAllTriangles();
      }
      
      public function returnTriangle(param1:Triangle3D) : void
      {
         var _loc2_:* = triangleCounter++;
         trianglePool[_loc2_] = param1;
      }
      
      public function returnAllTriangles() : void
      {
         triangleCounter = trianglePool.length;
      }
   }
}
