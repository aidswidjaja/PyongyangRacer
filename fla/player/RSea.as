package player
{
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.materials.utils.MaterialsList;
   import resourcemgr.RResourceMap;
   
   public class RSea extends TriangleMesh3D
   {
       
      
      public var m_resMap:RResourceMap;
      
      public var m_Split:int;
      
      public var m_deltaX:int;
      
      public var m_deltaZ:int;
      
      public var m_cellGeomData:Array;
      
      public var m_cell:int;
      
      public var m_row:int;
      
      public var m_cellID:int;
      
      public var m_drawVtxs:Number;
      
      public var m_drawFaces:Number;
      
      public function RSea()
      {
         super(null,new Array(),new Array());
         this.materials = new MaterialsList();
         this.useClipping = true;
         this.m_delta = 100000;
         this.m_cellGeomData = new Array();
      }
      
      public function InitSea() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:int = 0;
         var _loc10_:Triangle3D = null;
         this.materials = new MaterialsList();
         this.useClipping = true;
         this.m_cellGeomData = new Array();
         this.geometry.faces = new Array();
         faces = new Array();
         var _loc1_:int = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("sea");
         this.m_resMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc1_];
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_lMaterialBuf.length)
         {
            this.materials.addMaterial(this.m_resMap.m_lMaterialBuf[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_GrideDivision * this.m_resMap.m_GrideDivision)
         {
            _loc6_ = new Array();
            _loc7_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.m_resMap.m_lCellInfoList[_loc2_].numuv)
            {
               _loc8_ = Vertex3D(this.m_resMap.m_lVtxBuf[this.m_resMap.m_lCellInfoList[_loc2_].uvIdxbuf[_loc3_]]);
               _loc6_.push(_loc8_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.m_resMap.m_lCellInfoList[_loc2_].numtri)
            {
               _loc9_ = 0;
               while(_loc9_ < this.m_resMap.m_lGeomFaceIndexBuffer.length)
               {
                  if(this.m_resMap.m_lCellInfoList[_loc2_].triIdxbuf[_loc3_] == this.m_resMap.m_lGeomFaceIndexBuffer[_loc9_])
                  {
                     _loc10_ = new Triangle3D(this,[this.m_resMap.m_lGeometryfaces[_loc9_]._v2,this.m_resMap.m_lGeometryfaces[_loc9_]._v1,this.m_resMap.m_lGeometryfaces[_loc9_]._v0],this.m_resMap.m_lGeometryfaces[_loc9_]._mtl,null,true);
                     _loc7_.push(_loc10_);
                     break;
                  }
                  _loc9_++;
               }
               _loc3_++;
            }
            _loc5_ = {
               "vtxs":_loc6_,
               "fs":_loc7_
            };
            this.m_cellGeomData.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function UpdateScene(param1:Number, param2:Number, param3:Number) : void
      {
         this.UVAnimation();
         this.UpdateGeometry(param2,param3);
      }
      
      public function UpdateGeometry(param1:Number, param2:Number) : void
      {
         this.m_cell = Math.abs(param1 - this.m_resMap.m_GridMin.x) / this.m_resMap.m_GrideSpaceX;
         this.m_row = Math.abs(param2 - this.m_resMap.m_GridMin.z) / this.m_resMap.m_GrideSpaceZ;
         this.m_cellID = this.m_row * this.m_resMap.m_GrideDivision + this.m_cell;
         this.m_cellID = 8;
         geometry.vertices = this.m_cellGeomData[this.m_cellID].vtxs;
         geometry.faces = this.m_cellGeomData[this.m_cellID].fs;
         this.m_drawVtxs = geometry.vertices.length;
         this.m_drawFaces = geometry.faces.length;
      }
      
      public function UVAnimation() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.geometry.vertices.length)
         {
            this.geometry.vertices[_loc1_].uvt[1] += 0.001;
            _loc1_++;
         }
      }
   }
}
