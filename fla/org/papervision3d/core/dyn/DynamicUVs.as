package org.papervision3d.core.dyn
{
   import org.papervision3d.core.math.NumberUV;
   
   public class DynamicUVs
   {
      
      private static const GROW_SIZE:int = 300;
      
      private static const INIT_SIZE:int = 100;
      
      private static var UVCounter:int;
      
      private static var UVPool:Array;
       
      
      public function DynamicUVs()
      {
         super();
         init();
      }
      
      private static function init() : void
      {
         var _loc2_:NumberUV = null;
         UVPool = new Array(INIT_SIZE);
         var _loc1_:int = INIT_SIZE;
         while(--_loc1_ > -1)
         {
            _loc2_ = new NumberUV();
            UVPool[_loc1_] = _loc2_;
         }
         UVCounter = INIT_SIZE;
      }
      
      public static function init_index() : void
      {
         UVCounter = INIT_SIZE;
      }
      
      public function getUV() : NumberUV
      {
         var _loc1_:int = 0;
         var _loc2_:NumberUV = null;
         var _loc3_:NumberUV = null;
         if(UVCounter == 0)
         {
            _loc1_ = GROW_SIZE;
            while(--_loc1_ > -1)
            {
               _loc2_ = new NumberUV();
               UVPool.unshift(_loc2_);
            }
            UVCounter = GROW_SIZE;
            return this.getUV();
         }
         return NumberUV(UVPool[--UVCounter]);
      }
      
      public function releaseAll() : void
      {
         this.returnAllVertices();
      }
      
      public function returnTriangle(param1:NumberUV) : void
      {
         var _loc2_:* = UVCounter++;
         UVPool[_loc2_] = param1;
      }
      
      public function returnAllVertices() : void
      {
         UVCounter = UVPool.length;
      }
   }
}
