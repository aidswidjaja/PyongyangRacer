package resourcemgr
{
   import flash.geom.*;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.materials.BitmapFileMaterial;
   
   public class RResourceObj
   {
       
      
      protected var m_ident:int;
      
      protected var m_version:int;
      
      public var m_VtxsNum:int;
      
      public var m_UvsNum:int;
      
      public var m_TrisNum:int;
      
      public var m_UvsBuf:Array;
      
      public var m_TrisBuf:Array;
      
      public var m_VtxBuf:Array;
      
      public var m_MaterialsNum:int;
      
      public var m_MaterialOfs:int;
      
      public var m_GeomOfs:int;
      
      public var m_MaterialBuf:Array;
      
      public var m_Max:Vector3D;
      
      public var m_Min:Vector3D;
      
      public var m_Geometryfaces:Array;
      
      protected var m_type:Boolean;
      
      public function RResourceObj(param1:Boolean)
      {
         super();
         this.m_UvsBuf = new Array();
         this.m_TrisBuf = new Array();
         this.m_VtxBuf = new Array();
         this.m_Max = new Vector3D();
         this.m_Min = new Vector3D();
         this.m_Geometryfaces = new Array();
         this.m_MaterialBuf = new Array();
         this.m_type = param1;
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadHeader(param1);
         this.ReadGeomData(param1,this.m_GeomOfs);
         this.ReadMaterials(param1,this.m_MaterialsNum,this.m_MaterialOfs);
      }
      
      protected function ReadHeader(param1:ByteArray) : void
      {
         this.m_ident = param1.readInt();
         this.m_version = param1.readInt();
         if(this.m_ident == 1245859584 && this.m_version == 16777216)
         {
            this.m_GeomOfs = param1.readInt();
            this.m_VtxsNum = param1.readInt();
            this.m_UvsNum = param1.readInt();
            this.m_TrisNum = param1.readInt();
            this.m_Max.x = param1.readFloat();
            this.m_Max.y = param1.readFloat();
            this.m_Max.z = param1.readFloat();
            this.m_Min.x = param1.readFloat();
            this.m_Min.y = param1.readFloat();
            this.m_Min.z = param1.readFloat();
            this.m_MaterialsNum = param1.readInt();
            this.m_MaterialOfs = param1.readInt();
            return;
         }
         throw new Error("error loading Obj file (" + "obj" + "): Not a valid Obj file/bad version");
      }
      
      public function ReadGeomData(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param1.position = param2;
         _loc3_ = 0;
         while(_loc3_ < this.m_VtxsNum)
         {
            this.m_VtxBuf.push(new Vertex3D(param1.readFloat(),param1.readFloat(),param1.readFloat()));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_TrisNum)
         {
            _loc4_ = {
               "v0":param1.readUnsignedShort(),
               "v1":param1.readUnsignedShort(),
               "v2":param1.readUnsignedShort()
            };
            this.m_TrisBuf.push(_loc4_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_UvsNum)
         {
            _loc5_ = param1.readFloat();
            _loc6_ = 1 - param1.readFloat();
            this.m_UvsBuf.push(new NumberUV(_loc5_,_loc6_));
            this.m_VtxBuf[_loc3_].uvt = new Vector.<Number>();
            this.m_VtxBuf[_loc3_].uvt.push(_loc5_);
            this.m_VtxBuf[_loc3_].uvt.push(_loc6_);
            this.m_VtxBuf[_loc3_].uvt.push(0);
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
         var _loc10_:int = 0;
         var _loc11_:RResourceImg = null;
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
            (_loc9_ = new BitmapFileMaterial()).doubleSided = false;
            _loc11_ = new RResourceImg();
            if(this.m_type)
            {
               _loc10_ = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName(_loc8_);
               _loc11_ = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc10_];
            }
            else
            {
               _loc10_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName(_loc8_);
               _loc11_ = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc10_];
            }
            _loc9_.LoadTextureInMemory(_loc8_,_loc11_.m_lTexture);
            this.m_MaterialBuf.push(_loc9_);
            this.ReadPolyData(param1,_loc9_,_loc6_,_loc5_);
            _loc4_++;
         }
      }
      
      public function ReadPolyData(param1:ByteArray, param2:BitmapFileMaterial, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vertex3D = null;
         var _loc8_:Vertex3D = null;
         var _loc9_:Vertex3D = null;
         var _loc10_:NumberUV = null;
         var _loc11_:NumberUV = null;
         var _loc12_:NumberUV = null;
         param1.position = param4;
         _loc5_ = 0;
         while(_loc5_ < param3)
         {
            _loc6_ = param1.readUnsignedShort();
            _loc7_ = this.m_VtxBuf[this.m_TrisBuf[_loc6_].v0];
            _loc8_ = this.m_VtxBuf[this.m_TrisBuf[_loc6_].v1];
            _loc9_ = this.m_VtxBuf[this.m_TrisBuf[_loc6_].v2];
            _loc10_ = this.m_UvsBuf[this.m_TrisBuf[_loc6_].v0];
            _loc11_ = this.m_UvsBuf[this.m_TrisBuf[_loc6_].v1];
            _loc12_ = this.m_UvsBuf[this.m_TrisBuf[_loc6_].v2];
            this.m_Geometryfaces.push(new Triangle3D(null,[_loc9_,_loc8_,_loc7_],param2,[_loc12_,_loc11_,_loc10_]));
            _loc5_++;
         }
      }
   }
}
