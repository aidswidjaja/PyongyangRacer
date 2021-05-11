package org.papervision3d.core.render.command
{
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.AbstractRenderable;
   import org.papervision3d.core.render.data.QuadTreeNode;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class RenderableListItem extends AbstractRenderListItem
   {
       
      
      public var renderable:Class;
      
      public var renderableInstance:AbstractRenderable;
      
      public var instance:DisplayObject3D;
      
      public var area:Number;
      
      public var minX:Number;
      
      public var maxX:Number;
      
      public var minY:Number;
      
      public var maxY:Number;
      
      public var minZ:Number;
      
      public var maxZ:Number;
      
      public var quadrant:QuadTreeNode;
      
      public function RenderableListItem()
      {
         super();
      }
      
      public function getZ(param1:Number, param2:Number, param3:Number) : Number
      {
         return screenZ;
      }
      
      public function hitTestPoint2D(param1:Point, param2:RenderHitData) : RenderHitData
      {
         return param2;
      }
      
      public function update() : void
      {
      }
      
      public function quarter(param1:Number) : Array
      {
         return [];
      }
   }
}
