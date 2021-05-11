package org.papervision3d.cameras
{
   import flash.geom.*;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class ProjectUV
   {
       
      
      public var projmat:Matrix3D;
      
      public var projectedvtx:Vector.<Number>;
      
      public var projectvtx:Vector3D;
      
      public var vert:Vector3D;
      
      public var vertex:Vector.<Number>;
      
      public function ProjectUV()
      {
         this.projectedvtx = new Vector.<Number>();
         this.projectvtx = new Vector3D();
         this.vert = new Vector3D();
         this.vertex = new Vector.<Number>();
         super();
         var _loc1_:PerspectiveProjection = new PerspectiveProjection();
         this.projmat = _loc1_.toMatrix3D();
         this.projmat.prependTranslation(0,0,60);
         this.vertex.push(0);
         this.vertex.push(0);
         this.vertex.push(0);
      }
      
      public function projectUV(param1:Number, param2:Number, param3:Number, param4:Vertex3D) : void
      {
         this.vertex[0] = param1;
         this.vertex[1] = param2;
         this.vertex[2] = param3;
         Utils3D.projectVectors(this.projmat,this.vertex,this.projectedvtx,param4.uvt);
         param4.vertex3DInstance.x = this.projectedvtx[0];
         param4.vertex3DInstance.y = this.projectedvtx[1];
      }
      
      public function projectVtx(param1:Number, param2:Number, param3:Number, param4:Vertex3D) : void
      {
         this.vert.x = param1;
         this.vert.y = param2;
         this.vert.z = param3;
         this.projectvtx = Utils3D.projectVector(this.projmat,this.vert);
         param4.vertex3DInstance.x = this.projectvtx.x;
         param4.vertex3DInstance.y = this.projectvtx.y;
         param4.vertex3DInstance.z = this.projectvtx.z;
      }
      
      public function projectZ(param1:Number, param2:Number, param3:Number) : Number
      {
         this.vert.x = param1;
         this.vert.y = param2;
         this.vert.z = param3;
         this.projectvtx = Utils3D.projectVector(this.projmat,this.vert);
         return this.projectvtx.z;
      }
   }
}
