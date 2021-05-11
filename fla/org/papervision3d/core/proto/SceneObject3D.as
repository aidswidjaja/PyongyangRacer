package org.papervision3d.core.proto
{
   import org.papervision3d.materials.utils.MaterialsList;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class SceneObject3D extends DisplayObjectContainer3D
   {
       
      
      public var objects:Array;
      
      public var materials:MaterialsList;
      
      public function SceneObject3D()
      {
         super();
         this.objects = new Array();
         this.materials = new MaterialsList();
         this.root = this;
      }
      
      override public function addChild(param1:DisplayObject3D, param2:String = null) : DisplayObject3D
      {
         var _loc3_:DisplayObject3D = super.addChild(param1,!!param2 ? param2 : param1.name);
         param1.scene = this;
         param1.parent = null;
         this.objects.push(_loc3_);
         return _loc3_;
      }
      
      override public function removeChild(param1:DisplayObject3D) : DisplayObject3D
      {
         super.removeChild(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.objects.length)
         {
            if(this.objects[_loc2_] === param1)
            {
               this.objects.splice(_loc2_,1);
               return param1;
            }
            _loc2_++;
         }
         return param1;
      }
   }
}
