package org.papervision3d.core.geom
{
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.command.RenderLine;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ILineDrawer;
   import org.papervision3d.materials.special.LineMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Lines3D extends Vertices3D
   {
       
      
      public var lines:Array;
      
      private var _material:ILineDrawer;
      
      public function Lines3D(param1:LineMaterial = null, param2:String = null)
      {
         super(null,param2);
         if(!param1)
         {
            this.material = new LineMaterial();
         }
         else
         {
            this.material = param1;
         }
         this.init();
      }
      
      private function init() : void
      {
         this.lines = new Array();
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc3_:Line3D = null;
         var _loc4_:Number = NaN;
         var _loc5_:RenderLine = null;
         super.project(param1,param2);
         for each(_loc3_ in this.lines)
         {
            if(param2.viewPort.lineCuller.testLine(_loc3_))
            {
               (_loc5_ = _loc3_.renderCommand).renderer = _loc3_.material;
               _loc5_.size = _loc3_.size;
               _loc4_ += _loc5_.screenZ = (_loc3_.v0.vertex3DInstance.z + _loc3_.v1.vertex3DInstance.z) / 2;
               _loc5_.v0 = _loc3_.v0.vertex3DInstance;
               _loc5_.v1 = _loc3_.v1.vertex3DInstance;
               param2.renderer.addToRenderList(_loc5_);
            }
         }
         return _loc4_ / (this.lines.length + 1);
      }
      
      public function addLine(param1:Line3D) : void
      {
         this.lines.push(param1);
         param1.instance = this;
         if(geometry.vertices.indexOf(param1.v0) == -1)
         {
            geometry.vertices.push(param1.v0);
         }
         if(geometry.vertices.indexOf(param1.v1) == -1)
         {
            geometry.vertices.push(param1.v1);
         }
         if(param1.cV)
         {
            if(geometry.vertices.indexOf(param1.cV) == -1)
            {
               geometry.vertices.push(param1.cV);
            }
         }
      }
      
      public function addNewLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Line3D
      {
         var _loc8_:Line3D = new Line3D(this,material as LineMaterial,param1,new Vertex3D(param2,param3,param4),new Vertex3D(param5,param6,param7));
         this.addLine(_loc8_);
         return _loc8_;
      }
      
      public function addNewSegmentedLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Array
      {
         var _loc13_:Line3D = null;
         var _loc15_:Vertex3D = null;
         var _loc9_:Number = (param6 - param3) / param2;
         var _loc10_:Number = (param7 - param4) / param2;
         var _loc11_:Number = (param8 - param5) / param2;
         var _loc12_:Array = new Array();
         var _loc14_:Vertex3D = new Vertex3D(param3,param4,param5);
         var _loc16_:Number = 0;
         while(_loc16_ <= param2)
         {
            _loc15_ = new Vertex3D(param3 + _loc9_ * _loc16_,param4 + _loc10_ * _loc16_,param5 + _loc11_ * _loc16_);
            _loc13_ = new Line3D(this,material as LineMaterial,param1,_loc14_,_loc15_);
            this.addLine(_loc13_);
            _loc12_.push(_loc13_);
            _loc14_ = _loc15_;
            _loc16_++;
         }
         return _loc12_;
      }
      
      public function removeLine(param1:Line3D) : void
      {
         var _loc2_:int = this.lines.indexOf(param1);
         if(_loc2_ > -1)
         {
            this.lines.splice(_loc2_,1);
         }
         else
         {
            PaperLogger.warning("Papervision3D Lines3D.removeLine : WARNING removal of non-existant line attempted. ");
         }
      }
      
      public function removeAllLines() : void
      {
         while(this.lines.length > 0)
         {
            this.removeLine(this.lines[0]);
         }
      }
   }
}
