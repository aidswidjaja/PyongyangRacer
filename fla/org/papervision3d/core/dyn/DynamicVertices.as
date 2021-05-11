package org.papervision3d.core.dyn
{
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class DynamicVertices
   {
      
      private static const GROW_SIZE:int = 300;
      
      private static const INIT_SIZE:int = 200;
      
      private static var VertexCounter:int;
      
      private static var VertexPool:Array;
       
      
      public function DynamicVertices()
      {
         super();
         init();
      }
      
      private static function init() : void
      {
         var _loc2_:Vertex3D = null;
         VertexPool = new Array(INIT_SIZE);
         var _loc1_:int = INIT_SIZE;
         while(--_loc1_ > -1)
         {
            _loc2_ = new Vertex3D();
            _loc2_.uvt = new Vector.<Number>();
            _loc2_.uvt.push(0);
            _loc2_.uvt.push(0);
            _loc2_.uvt.push(0);
            VertexPool[_loc1_] = _loc2_;
         }
         VertexCounter = INIT_SIZE;
      }
      
      public static function init_index() : void
      {
         VertexCounter = INIT_SIZE;
      }
      
      public function getVertex() : Vertex3D
      {
         var _loc1_:int = 0;
         var _loc2_:Vertex3D = null;
         var _loc3_:Vertex3D = null;
         if(VertexCounter == 0)
         {
            _loc1_ = GROW_SIZE;
            while(--_loc1_ > -1)
            {
               _loc2_ = new Vertex3D();
               _loc2_.uvt = new Vector.<Number>();
               _loc2_.uvt.push(0);
               _loc2_.uvt.push(0);
               _loc2_.uvt.push(0);
               VertexPool.unshift(_loc2_);
            }
            VertexCounter = GROW_SIZE;
            return this.getVertex();
         }
         return Vertex3D(VertexPool[--VertexCounter]);
      }
      
      public function releaseAll() : void
      {
         this.returnAllVertices();
      }
      
      public function returnTriangle(param1:Vertex3D) : void
      {
         var _loc2_:* = VertexCounter++;
         VertexPool[_loc2_] = param1;
      }
      
      public function returnAllVertices() : void
      {
         VertexCounter = VertexPool.length;
      }
   }
}
