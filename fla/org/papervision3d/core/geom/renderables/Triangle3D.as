package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.special.CompositeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Triangle3D extends AbstractRenderable implements IRenderable
   {
      
      private static var _totalFaces:Number = 0;
       
      
      public var vertices:Array;
      
      public var _materialName:String;
      
      public var uv0:NumberUV;
      
      public var uv1:NumberUV;
      
      public var uv2:NumberUV;
      
      public var _uvArray:Array;
      
      public var screenZ:Number;
      
      public var visible:Boolean;
      
      public var id:Number;
      
      public var v0:Vertex3D;
      
      public var v1:Vertex3D;
      
      public var v2:Vertex3D;
      
      public var faceNormal:Number3D;
      
      public var material:MaterialObject3D;
      
      public var renderCommand:RenderTriangle;
      
      public function Triangle3D(param1:DisplayObject3D, param2:Array, param3:MaterialObject3D = null, param4:Array = null, param5:Boolean = false)
      {
         var _loc6_:Vector.<Number> = null;
         var _loc7_:int = 0;
         super();
         this.instance = param1;
         this.faceNormal = new Number3D();
         if(param2 && param2.length == 3)
         {
            this.vertices = param2;
            this.v0 = param2[0];
            this.v1 = param2[1];
            this.v2 = param2[2];
            this.createNormal();
         }
         else
         {
            param2 = new Array();
            this.v0 = param2[0] = new Vertex3D();
            this.v1 = param2[1] = new Vertex3D();
            this.v2 = param2[2] = new Vertex3D();
         }
         this.material = param3;
         this.uv = param4;
         this.id = _totalFaces++;
         this.renderCommand = new RenderTriangle(this);
         if(param5 == true)
         {
            _loc6_ = new Vector.<Number>();
            _loc7_ = 0;
            while(_loc7_ < 9)
            {
               _loc6_.push(0);
               _loc7_++;
            }
            this.renderCommand.uvt = _loc6_;
         }
      }
      
      public function reset(param1:DisplayObject3D, param2:Array, param3:MaterialObject3D, param4:Array) : void
      {
         var _loc5_:MaterialObject3D = null;
         this.instance = param1;
         this.renderCommand.instance = param1;
         this.renderCommand.renderer = param3;
         this.vertices = param2;
         this.updateVertices();
         this.material = param3;
         this.uv = param4;
         if(param3 is BitmapMaterial)
         {
            BitmapMaterial(param3).uvMatrices[this.renderCommand] = null;
         }
         if(param3 is CompositeMaterial)
         {
            for each(_loc5_ in CompositeMaterial(param3).materials)
            {
               if(_loc5_ is BitmapMaterial)
               {
                  BitmapMaterial(_loc5_).uvMatrices[this.renderCommand] = null;
               }
            }
         }
      }
      
      public function createNormal() : void
      {
         var _loc1_:Number3D = this.v0.getPosition();
         var _loc2_:Number3D = this.v1.getPosition();
         var _loc3_:Number3D = this.v2.getPosition();
         _loc2_.minusEq(_loc1_);
         _loc3_.minusEq(_loc1_);
         this.faceNormal = Number3D.cross(_loc2_,_loc3_,this.faceNormal);
         this.faceNormal.normalize();
      }
      
      override public function getRenderListItem() : IRenderListItem
      {
         return this.renderCommand;
      }
      
      public function updateVertices() : void
      {
         this.v0 = this.vertices[0];
         this.v1 = this.vertices[1];
         this.v2 = this.vertices[2];
      }
      
      public function set uv(param1:Array) : void
      {
         if(param1 && param1.length == 3)
         {
            this.uv0 = NumberUV(param1[0]);
            this.uv1 = NumberUV(param1[1]);
            this.uv2 = NumberUV(param1[2]);
         }
         this._uvArray = param1;
      }
      
      public function get uv() : Array
      {
         return this._uvArray;
      }
   }
}
