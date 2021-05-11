package resourcemgr
{
   import flash.geom.*;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import org.papervision3d.core.geom.*;
   import org.papervision3d.core.geom.renderables.*;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.*;
   import org.papervision3d.materials.BitmapFileMaterial;
   
   public class RResourceMap
   {
       
      
      protected var m_ident:int;
      
      protected var m_version:int;
      
      public var m_NumVtxs:int;
      
      public var m_NumUvs:int;
      
      public var m_NumTris:int;
      
      public var m_NumMtls:int;
      
      public var m_MtlOfs:int;
      
      public var m_GeomOfs:int;
      
      public var m_Max:Vector3D;
      
      public var m_Min:Vector3D;
      
      public var m_split:int;
      
      public var m_HeiOfs:int;
      
      public var m_spaceX:Number;
      
      public var m_spaceZ:Number;
      
      public var m_faceId:int;
      
      public var m_GridMax:Vector3D;
      
      public var m_GridMin:Vector3D;
      
      public var m_GrideSpaceX:Number;
      
      public var m_GrideSpaceZ:Number;
      
      public var m_GrideDivision:int;
      
      public var m_CellNums:int;
      
      public var m_CellDataofs:int;
      
      public var m_lGeometryfaces:Array;
      
      public var m_lGameObjectPosArray:Array;
      
      public var m_lUvAnimationArray:Array;
      
      public var m_lTextureAnimationArray:Array;
      
      public var m_lGeomFaceIndexBuffer:Array;
      
      public var m_lGameObjectArray:Array;
      
      public var m_lCellList:Array;
      
      public var m_lCellInfoList:Array;
      
      public var m_lUvsBuf:Array;
      
      public var m_lTrisBuf:Array;
      
      public var m_lVtxBuf:Array;
      
      public var m_lMaterialBuf:Array;
      
      public var m_GameObjectNums:int;
      
      public var m_ObjPosOfs:int;
      
      public var m_UvAnimationNums:int;
      
      public var m_TextureAnimationNums:int;
      
      public var m_UvAnimofs:int;
      
      public var m_TextureAnimofs:int;
      
      public function RResourceMap()
      {
         this.m_GridMax = new Vector3D();
         this.m_GridMin = new Vector3D();
         super();
         this.m_spaceX = new Number();
         this.m_spaceZ = new Number();
         this.m_Max = new Vector3D();
         this.m_Min = new Vector3D();
         this.m_lTrisBuf = new Array();
         this.m_lVtxBuf = new Array();
         this.m_lUvsBuf = new Array();
         this.m_lCellInfoList = new Array();
         this.m_lCellList = new Array();
         this.m_lGameObjectArray = new Array();
         this.m_lGeomFaceIndexBuffer = new Array();
         this.m_lTextureAnimationArray = new Array();
         this.m_lUvAnimationArray = new Array();
         this.m_lGameObjectPosArray = new Array();
         this.m_lGeometryfaces = new Array();
         this.m_lMaterialBuf = new Array();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadHeader(param1);
         this.ReadGeomData(param1,this.m_GeomOfs);
         this.ReadMaterials(param1,this.m_NumMtls,this.m_MtlOfs);
         this.ReadObjPosInfo(param1,this.m_ObjPosOfs);
         this.ReadPVS(param1,this.m_CellDataofs);
         var _loc2_:int = 0;
         while(_loc2_ < this.m_CellNums)
         {
            this.ReadCellData(param1,this.m_lCellList[_loc2_]);
            _loc2_++;
         }
         this.ReadUVAnimInfo(param1,this.m_UvAnimofs);
         this.ReadTextureAnimInfo(param1,this.m_TextureAnimofs);
      }
      
      public function ReadHeader(param1:ByteArray) : void
      {
         this.m_ident = param1.readInt();
         this.m_version = param1.readInt();
         if(this.m_ident == 1245859584 && this.m_version == 16777216)
         {
            this.m_GeomOfs = param1.readInt();
            this.m_split = param1.readInt();
            this.m_NumVtxs = param1.readInt();
            this.m_NumUvs = param1.readInt();
            this.m_NumTris = param1.readInt();
            this.m_Max.x = param1.readFloat();
            this.m_Max.y = param1.readFloat();
            this.m_Max.z = param1.readFloat();
            this.m_Min.x = param1.readFloat();
            this.m_Min.y = param1.readFloat();
            this.m_Min.z = param1.readFloat();
            this.m_NumMtls = param1.readInt();
            this.m_MtlOfs = param1.readInt();
            this.m_HeiOfs = param1.readInt();
            this.m_GameObjectNums = param1.readInt();
            this.m_ObjPosOfs = param1.readInt();
            this.m_CellNums = param1.readInt();
            this.m_CellDataofs = param1.readInt();
            this.m_GridMax.x = param1.readFloat();
            this.m_GridMax.y = param1.readFloat();
            this.m_GridMax.z = param1.readFloat();
            this.m_GridMin.x = param1.readFloat();
            this.m_GridMin.y = param1.readFloat();
            this.m_GridMin.z = param1.readFloat();
            this.m_UvAnimationNums = param1.readInt();
            this.m_TextureAnimationNums = param1.readInt();
            this.m_UvAnimofs = param1.readInt();
            this.m_TextureAnimofs = param1.readInt();
            this.m_GrideDivision = Math.sqrt(this.m_CellNums);
            this.m_GrideSpaceX = (this.m_GridMax.x - this.m_GridMin.x) / this.m_GrideDivision;
            this.m_GrideSpaceZ = (this.m_GridMax.z - this.m_GridMin.z) / this.m_GrideDivision;
            return;
         }
         throw new Error("error loading Map file (" + "terrain" + "): Not a valid Map file/bad version");
      }
      
      public function ReadGeomData(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param1.position = param2;
         _loc3_ = 0;
         while(_loc3_ < this.m_NumVtxs)
         {
            this.m_lVtxBuf.push(new Vertex3D(param1.readFloat(),param1.readFloat(),param1.readFloat()));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_NumTris)
         {
            _loc4_ = {
               "v0":param1.readUnsignedShort(),
               "v1":param1.readUnsignedShort(),
               "v2":param1.readUnsignedShort()
            };
            this.m_lTrisBuf.push(_loc4_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_NumUvs)
         {
            _loc5_ = param1.readFloat();
            _loc6_ = 1 - param1.readFloat();
            this.m_lUvsBuf.push(new NumberUV(_loc5_,_loc6_));
            this.m_lVtxBuf[_loc3_].uvt = new Vector.<Number>();
            this.m_lVtxBuf[_loc3_].uvt.push(_loc5_);
            this.m_lVtxBuf[_loc3_].uvt.push(_loc6_);
            this.m_lVtxBuf[_loc3_].uvt.push(0);
            _loc3_++;
         }
      }
      
      public function ReadMaterials(param1:ByteArray, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:BitmapFileMaterial = null;
         var _loc10_:RResourceImg = null;
         var _loc11_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            param1.position = param3;
            _loc5_ = param1.readInt();
            _loc6_ = param1.readInt();
            _loc7_ = param1.readInt();
            _loc8_ = param1.readMultiByte(100,"0");
            param1.readUnsignedShort();
            param1.readUnsignedShort();
            param3 = param1.position;
            (_loc9_ = new BitmapFileMaterial()).doubleSided = true;
            _loc10_ = new RResourceImg();
            if((_loc11_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName(_loc8_)) == -1)
            {
               trace("no image filename.");
            }
            _loc10_ = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc11_];
            _loc9_.LoadTextureInMemory(_loc8_,_loc10_.m_lTexture);
            this.m_lMaterialBuf.push(_loc9_);
            this.ReadPolyData(param1,_loc9_,_loc6_,_loc5_);
            _loc4_++;
         }
      }
      
      public function ReadPolyData(param1:ByteArray, param2:BitmapFileMaterial, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:Vertex3D = null;
         param1.position = param4;
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            _loc6_ = param1.readUnsignedShort();
            this.m_lGeomFaceIndexBuffer.push(_loc6_);
            _loc8_ = this.m_lVtxBuf[this.m_lTrisBuf[_loc6_].v0];
            _loc9_ = this.m_lVtxBuf[this.m_lTrisBuf[_loc6_].v1];
            _loc10_ = this.m_lVtxBuf[this.m_lTrisBuf[_loc6_].v2];
            _loc7_ = {
               "_v2":_loc10_,
               "_v1":_loc9_,
               "_v0":_loc8_,
               "_mtl":param2
            };
            this.m_lGeometryfaces.push(_loc7_);
            _loc5_++;
         }
      }
      
      public function ReadObjPosInfo(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         param1.position = param2;
         _loc3_ = 0;
         while(_loc3_ < this.m_GameObjectNums)
         {
            _loc4_ = {
               "x":param1.readFloat(),
               "y":param1.readFloat(),
               "z":param1.readFloat(),
               "angle":-param1.readFloat(),
               "type":param1.readInt()
            };
            this.m_lGameObjectPosArray.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function ReadPVS(param1:ByteArray, param2:int) : void
      {
         var _loc4_:Object = null;
         param1.position = param2;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_CellNums)
         {
            _loc4_ = {
               "numcells":param1.readInt(),
               "numtri":param1.readInt(),
               "numuv":param1.readInt(),
               "triofs":param1.readInt(),
               "uvofs":param1.readInt(),
               "cellofs":param1.readInt()
            };
            this.m_lCellList.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function ReadCellData(param1:ByteArray, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc7_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         param1.position = param2.cellofs;
         _loc7_ = 0;
         while(_loc7_ < param2.numcells)
         {
            _loc4_.push(param1.readInt());
            _loc7_++;
         }
         param1.position = param2.triofs;
         _loc7_ = 0;
         while(_loc7_ < param2.numtri)
         {
            _loc5_.push(param1.readInt());
            _loc7_++;
         }
         param1.position = param2.uvofs;
         _loc7_ = 0;
         while(_loc7_ < param2.numuv)
         {
            _loc6_.push(param1.readInt());
            _loc7_++;
         }
         _loc3_ = {
            "triIdxbuf":_loc5_,
            "uvIdxbuf":_loc6_,
            "pvscell":_loc4_,
            "numtri":param2.numtri,
            "numuv":param2.numuv,
            "numcell":param2.numcells
         };
         this.m_lCellInfoList.push(_loc3_);
      }
      
      public function ReadUVAnimInfo(param1:ByteArray, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_UvAnimationNums)
         {
            param1.position = param2;
            _loc3_ = {
               "flowU":param1.readFloat(),
               "flowV":param1.readFloat(),
               "uvIndexNums":param1.readInt(),
               "ofs":param1.readInt()
            };
            param2 = param1.position;
            this.ReadUVIndexInfo(param1,_loc3_);
            _loc4_++;
         }
      }
      
      public function ReadUVIndexInfo(param1:ByteArray, param2:Object) : void
      {
         var _loc3_:Array = new Array();
         param1.position = param2.ofs;
         var _loc4_:int = 0;
         while(_loc4_ < param2.uvIndexNums)
         {
            _loc3_.push(param1.readInt());
            _loc4_++;
         }
         this.m_lUvAnimationArray.push({
            "flowU":param2.flowU,
            "flowV":param2.flowV,
            "UVIndexArray":_loc3_
         });
      }
      
      public function ReadTextureAnimInfo(param1:ByteArray, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.m_TextureAnimationNums)
         {
            param1.position = param2;
            _loc3_ = {
               "type":param1.readInt(),
               "ofs":param1.readInt(),
               "uvIndexNums":param1.readInt()
            };
            param2 = param1.position;
            this.ReadTextureUVIndexInfo(param1,_loc3_);
            _loc4_++;
         }
      }
      
      public function ReadTextureUVIndexInfo(param1:ByteArray, param2:Object) : void
      {
         var _loc3_:Array = new Array();
         param1.position = param2.ofs;
         var _loc4_:int = 0;
         while(_loc4_ < param2.uvIndexNums)
         {
            _loc3_.push(param1.readUnsignedShort());
            _loc4_++;
         }
         this.m_lTextureAnimationArray.push({
            "type":param2.type,
            "UVIndexArray":_loc3_
         });
      }
   }
}
