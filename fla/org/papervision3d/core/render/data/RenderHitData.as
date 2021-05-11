package org.papervision3d.core.render.data
{
   import org.papervision3d.core.geom.renderables.IRenderable;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class RenderHitData
   {
       
      
      public var startTime:int = 0;
      
      public var endTime:int = 0;
      
      public var hasHit:Boolean = false;
      
      public var displayObject3D:DisplayObject3D;
      
      public var material:MaterialObject3D;
      
      public var renderable:IRenderable;
      
      public var u:Number;
      
      public var v:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function RenderHitData()
      {
         super();
      }
      
      public function toString() : String
      {
         return this.displayObject3D + " " + this.renderable;
      }
      
      public function clear() : void
      {
         this.startTime = 0;
         this.endTime = 0;
         this.hasHit = false;
         this.displayObject3D = null;
         this.material = null;
         this.renderable = null;
         this.u = 0;
         this.v = 0;
         this.x = 0;
         this.y = 0;
         this.z = 0;
      }
      
      public function clone() : RenderHitData
      {
         var _loc1_:RenderHitData = new RenderHitData();
         _loc1_.startTime = this.startTime;
         _loc1_.endTime = this.endTime;
         _loc1_.hasHit = this.hasHit;
         _loc1_.displayObject3D = this.displayObject3D;
         _loc1_.material = this.material;
         _loc1_.renderable = this.renderable;
         _loc1_.u = this.u;
         _loc1_.v = this.v;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.z = this.z;
         return _loc1_;
      }
   }
}
