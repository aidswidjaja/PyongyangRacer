package player
{
   import Const.RItemInfo;
   import Const.RObjectStateType;
   import Const.RObjectType;
   import common.ROBJECTINFO;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.materials.utils.MaterialsList;
   import resourcemgr.RResourceHeightmap;
   import resourcemgr.RResourceMap;
   import resourcemgr.RResourcePath;
   
   public class RTerrain extends TriangleMesh3D
   {
      
      public static const _BONUS:int = 0;
      
      public static const _TREE:int = 1;
      
      public static const _HOUSE:int = 2;
      
      public static const _MARK:int = 4;
      
      public static const _MOVINGWALL:int = 3;
      
      private static var _i:int;
       
      
      public var m_resMap:RResourceMap;
      
      public var m_heightMap:RResourceHeightmap;
      
      public var m_path:RResourcePath;
      
      public var m_ObjectCount:int;
      
      public var m_MaxLoc:Vector3D;
      
      public var m_MinLoc:Vector3D;
      
      public var m_gridMaxLoc:Vector3D;
      
      public var m_gridMinLoc:Vector3D;
      
      public var m_Split:int;
      
      public var m_deltaX:Number;
      
      public var m_deltaZ:Number;
      
      public var m_cellGeomData:Array;
      
      public var m_cell:int;
      
      public var m_row:int;
      
      public var m_cellID:int;
      
      public var m_drawVtxs:Number;
      
      public var m_drawFaces:Number;
      
      private var _initState:int;
      
      public function RTerrain()
      {
         this.m_deltaX = new Number(1);
         this.m_deltaZ = new Number(1);
         super(null,new Array(),new Array());
         this.materials = new MaterialsList();
         this.useClipping = true;
         this.m_cellGeomData = new Array();
      }
      
      public function startInitTerrain() : void
      {
         this._initState = 0;
      }
      
      public function getInitProgress() : int
      {
         switch(this._initState)
         {
            case 0:
               return 5;
            case 1:
               return int(_i * 10 / this.m_resMap.m_GameObjectNums) + 5;
            case 2:
               return 15;
            case 3:
               return int(_i * 80 / this.m_resMap.m_GrideDivision / this.m_resMap.m_GrideDivision) + 15;
            case 4:
               return 100;
            default:
               return 100;
         }
      }
      
      public function loopInit(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Dictionary = null;
         var _loc7_:ROBJECTINFO = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Vertex3D = null;
         var _loc12_:int = 0;
         var _loc13_:Triangle3D = null;
         var _loc14_:Object = null;
         switch(this._initState)
         {
            case 0:
               _loc9_ = new Array();
               faces = new Array();
               this.useClipping = true;
               this.materials = new MaterialsList();
               this.m_cellGeomData = new Array();
               _loc2_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("terrain");
               this.m_resMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc2_];
               this.m_ObjectCount = 0;
               this.m_MaxLoc = this.m_resMap.m_Max;
               this.m_MinLoc = this.m_resMap.m_Min;
               this.m_gridMaxLoc = this.m_resMap.m_GridMax;
               this.m_gridMinLoc = this.m_resMap.m_GridMin;
               ++this._initState;
               _i = 0;
               break;
            case 1:
               _loc3_ = getTimer();
               while(_i < this.m_resMap.m_GameObjectNums)
               {
                  (_loc7_ = new ROBJECTINFO()).m_CurrLoc = new Vector3D(this.m_resMap.m_lGameObjectPosArray[_i].x,this.m_resMap.m_lGameObjectPosArray[_i].y,this.m_resMap.m_lGameObjectPosArray[_i].z);
                  _loc7_.m_CurrPose = new Vector3D(0,this.m_resMap.m_lGameObjectPosArray[_i].angle,0);
                  _loc7_.m_CurrState = RObjectStateType.NEWOBJECT;
                  switch(this.m_resMap.m_lGameObjectPosArray[_i].type)
                  {
                     case RItemInfo.BONUS:
                        _loc7_.m_ObjectType = RObjectType.BONUS;
                        break;
                     case RItemInfo.TREE1:
                        _loc7_.m_ObjectType = RObjectType.TREE1;
                        break;
                     case RItemInfo.TREE2:
                        _loc7_.m_ObjectType = RObjectType.TREE2;
                        break;
                     case RItemInfo.TREE3:
                        _loc7_.m_ObjectType = RObjectType.TREE3;
                        ++this.m_ObjectCount;
                        break;
                     case RItemInfo.HOUSE1:
                        _loc7_.m_ObjectType = RObjectType.HOUSE1;
                        break;
                     case RItemInfo.HOUSE2:
                        _loc7_.m_ObjectType = RObjectType.HOUSE2;
                        break;
                     case RItemInfo.HOUSE3:
                        _loc7_.m_ObjectType = RObjectType.HOUSE3;
                        break;
                     case RItemInfo.UMBRELLA1:
                        _loc7_.m_ObjectType = RObjectType.UMBRELLA1;
                        break;
                     case RItemInfo.UMBRELLA2:
                        _loc7_.m_ObjectType = RObjectType.UMBRELLA2;
                        break;
                     case RItemInfo.UMBRELLA3:
                        _loc7_.m_ObjectType = RObjectType.UMBRELLA3;
                        break;
                     case RItemInfo.SHELLFISH1:
                        _loc7_.m_ObjectType = RObjectType.SHELLFISH1;
                        break;
                     case RItemInfo.SHELLFISH2:
                        _loc7_.m_ObjectType = RObjectType.SHELLFISH2;
                        break;
                     case RItemInfo.STARFISH:
                        _loc7_.m_ObjectType = RObjectType.STARFISH;
                        break;
                     case RItemInfo.CRAB:
                        _loc7_.m_ObjectType = RObjectType.CRAB;
                        break;
                     case RItemInfo.MOVINGWALL:
                        _loc7_.m_ObjectType = RObjectType.MOVINGWALL;
                        break;
                     case RItemInfo.BUS2:
                        _loc7_.m_ObjectType = RObjectType.BUS2;
                  }
                  ++_i;
                  RockRacer.GameCommon.AddObject(_loc7_);
                  if(getTimer() - _loc3_ > 50)
                  {
                     break;
                  }
               }
               if(_i >= this.m_resMap.m_GameObjectNums)
               {
                  _i = 0;
                  ++this._initState;
               }
               break;
            case 2:
               _loc2_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("heightmap");
               this.m_heightMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc2_];
               this.m_Split = this.m_heightMap.m_spilt;
               this.m_deltaX = (this.m_heightMap.m_max.x - this.m_heightMap.m_min.x) / this.m_Split;
               this.m_deltaZ = (this.m_heightMap.m_max.z - this.m_heightMap.m_min.z) / this.m_Split;
               _loc2_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("path");
               this.m_path = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc2_];
               _loc8_ = 0;
               while(_loc8_ < this.m_resMap.m_lMaterialBuf.length)
               {
                  this.materials.addMaterial(this.m_resMap.m_lMaterialBuf[_loc8_]);
                  _loc8_++;
               }
               ++this._initState;
               break;
            case 3:
               _loc3_ = getTimer();
               while(_i < this.m_resMap.m_GrideDivision * this.m_resMap.m_GrideDivision)
               {
                  _loc9_ = new Array();
                  _loc10_ = new Array();
                  _loc5_ = 0;
                  while(_loc5_ < this.m_resMap.m_lCellInfoList[_i].numuv)
                  {
                     _loc11_ = Vertex3D(this.m_resMap.m_lVtxBuf[this.m_resMap.m_lCellInfoList[_i].uvIdxbuf[_loc5_]]);
                     _loc9_.push(_loc11_);
                     _loc5_++;
                  }
                  _loc5_ = 0;
                  while(_loc5_ < this.m_resMap.m_lCellInfoList[_i].numtri)
                  {
                     _loc12_ = 0;
                     while(_loc12_ < this.m_resMap.m_lGeomFaceIndexBuffer.length)
                     {
                        if(this.m_resMap.m_lCellInfoList[_i].triIdxbuf[_loc5_] == this.m_resMap.m_lGeomFaceIndexBuffer[_loc12_])
                        {
                           _loc13_ = new Triangle3D(this,[this.m_resMap.m_lGeometryfaces[_loc12_]._v2,this.m_resMap.m_lGeometryfaces[_loc12_]._v1,this.m_resMap.m_lGeometryfaces[_loc12_]._v0],this.m_resMap.m_lGeometryfaces[_loc12_]._mtl,null,true);
                           _loc10_.push(_loc13_);
                           break;
                        }
                        _loc12_++;
                     }
                     _loc5_++;
                  }
                  ++_i;
                  _loc4_ = {
                     "vtxs":_loc9_,
                     "fs":_loc10_
                  };
                  this.m_cellGeomData.push(_loc4_);
                  if(getTimer() - _loc3_ > 50)
                  {
                     break;
                  }
               }
               if(_i >= this.m_resMap.m_GrideDivision * this.m_resMap.m_GrideDivision)
               {
                  _i = 0;
                  ++this._initState;
               }
               break;
            case 4:
               _loc6_ = RockRacer.GameCommon.CommonRsrMgr.m_Infofile.m_InfoDic;
               for each(_loc14_ in _loc6_)
               {
                  (_loc7_ = new ROBJECTINFO()).m_CurrLoc = new Vector3D(this.m_path.m_lPath[_loc14_.index].x + Math.random() * 200 - 100,0,this.m_path.m_lPath[_loc14_.index].z + Math.random() * 200 - 100);
                  _loc7_.m_CurrPose = new Vector3D(0,0,0);
                  _loc7_.m_CurrState = RObjectStateType.NEWOBJECT;
                  _loc7_.m_ObjectType = RObjectType.TREE1;
                  _loc7_.m_reserve = _loc14_.index;
                  RockRacer.GameCommon.AddObject(_loc7_);
               }
               ++this._initState;
               RockRacer.GameCommon.GameClient.dispatchEvent(new Event("INIT_COMPLATE"));
         }
      }
      
      public function InitTerrain() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:ROBJECTINFO = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Vertex3D = null;
         var _loc11_:int = 0;
         var _loc12_:Triangle3D = null;
         _loc8_ = new Array();
         faces = new Array();
         this.useClipping = true;
         this.materials = new MaterialsList();
         this.m_cellGeomData = new Array();
         var _loc1_:int = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("terrain");
         this.m_resMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc1_];
         this.m_MaxLoc = this.m_resMap.m_Max;
         this.m_MinLoc = this.m_resMap.m_Min;
         this.m_gridMaxLoc = this.m_resMap.m_GridMax;
         this.m_gridMinLoc = this.m_resMap.m_GridMin;
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_GameObjectNums)
         {
            (_loc7_ = new ROBJECTINFO()).m_CurrLoc = new Vector3D(this.m_resMap.m_lGameObjectPosArray[_loc2_].x,this.m_resMap.m_lGameObjectPosArray[_loc2_].y,this.m_resMap.m_lGameObjectPosArray[_loc2_].z);
            _loc7_.m_CurrPose = new Vector3D(0,this.m_resMap.m_lGameObjectPosArray[_loc2_].angle,0);
            _loc7_.m_CurrState = RObjectStateType.NEWOBJECT;
            switch(this.m_resMap.m_lGameObjectPosArray[_loc2_].type)
            {
               case RItemInfo.BONUS:
                  _loc7_.m_ObjectType = RObjectType.BONUS;
                  break;
               case RItemInfo.TREE1:
                  _loc7_.m_ObjectType = RObjectType.TREE1;
                  break;
               case RItemInfo.TREE2:
                  _loc7_.m_ObjectType = RObjectType.TREE2;
                  break;
               case RItemInfo.TREE3:
                  _loc7_.m_ObjectType = RObjectType.TREE3;
                  break;
               case RItemInfo.HOUSE1:
                  _loc7_.m_ObjectType = RObjectType.HOUSE1;
                  break;
               case RItemInfo.HOUSE2:
                  _loc7_.m_ObjectType = RObjectType.HOUSE2;
                  break;
               case RItemInfo.HOUSE3:
                  _loc7_.m_ObjectType = RObjectType.HOUSE3;
                  break;
               case RItemInfo.UMBRELLA1:
                  _loc7_.m_ObjectType = RObjectType.UMBRELLA1;
                  break;
               case RItemInfo.UMBRELLA2:
                  _loc7_.m_ObjectType = RObjectType.UMBRELLA2;
                  break;
               case RItemInfo.UMBRELLA3:
                  _loc7_.m_ObjectType = RObjectType.UMBRELLA3;
                  break;
               case RItemInfo.SHELLFISH1:
                  _loc7_.m_ObjectType = RObjectType.SHELLFISH1;
                  break;
               case RItemInfo.SHELLFISH2:
                  _loc7_.m_ObjectType = RObjectType.SHELLFISH2;
                  break;
               case RItemInfo.STARFISH:
                  _loc7_.m_ObjectType = RObjectType.STARFISH;
                  break;
               case RItemInfo.CRAB:
                  _loc7_.m_ObjectType = RObjectType.CRAB;
                  break;
               case RItemInfo.MOVINGWALL:
                  _loc7_.m_ObjectType = RObjectType.MOVINGWALL;
                  break;
            }
            RockRacer.GameCommon.AddObject(_loc7_);
            _loc2_++;
         }
         _loc1_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("heightmap");
         this.m_heightMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc1_];
         this.m_Split = this.m_heightMap.m_spilt;
         this.m_deltaX = (this.m_heightMap.m_max.x - this.m_heightMap.m_min.x) / this.m_Split;
         this.m_deltaZ = (this.m_heightMap.m_max.z - this.m_heightMap.m_min.z) / this.m_Split;
         _loc1_ = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("path");
         this.m_path = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc1_];
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_lMaterialBuf.length)
         {
            this.materials.addMaterial(this.m_resMap.m_lMaterialBuf[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_GrideDivision * this.m_resMap.m_GrideDivision)
         {
            _loc8_ = new Array();
            _loc9_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.m_resMap.m_lCellInfoList[_loc2_].numuv)
            {
               _loc10_ = Vertex3D(this.m_resMap.m_lVtxBuf[this.m_resMap.m_lCellInfoList[_loc2_].uvIdxbuf[_loc3_]]);
               _loc8_.push(_loc10_);
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this.m_resMap.m_lCellInfoList[_loc2_].numtri)
            {
               _loc11_ = 0;
               while(_loc11_ < this.m_resMap.m_lGeomFaceIndexBuffer.length)
               {
                  if(this.m_resMap.m_lCellInfoList[_loc2_].triIdxbuf[_loc3_] == this.m_resMap.m_lGeomFaceIndexBuffer[_loc11_])
                  {
                     _loc12_ = new Triangle3D(this,[this.m_resMap.m_lGeometryfaces[_loc11_]._v2,this.m_resMap.m_lGeometryfaces[_loc11_]._v1,this.m_resMap.m_lGeometryfaces[_loc11_]._v0],this.m_resMap.m_lGeometryfaces[_loc11_]._mtl,null,true);
                     _loc9_.push(_loc12_);
                     break;
                  }
                  _loc11_++;
               }
               _loc3_++;
            }
            _loc4_ = {
               "vtxs":_loc8_,
               "fs":_loc9_
            };
            this.m_cellGeomData.push(_loc4_);
            _loc2_++;
         }
         var _loc5_:Dictionary = RockRacer.GameCommon.CommonRsrMgr.m_Infofile.m_InfoDic;
         for each(_loc6_ in _loc5_)
         {
            (_loc7_ = new ROBJECTINFO()).m_CurrLoc = new Vector3D(this.m_path.m_lPath[_loc6_.index].x + Math.random() * 200 - 100,0,this.m_path.m_lPath[_loc6_.index].z + Math.random() * 200 - 100);
            _loc7_.m_CurrPose = new Vector3D(0,0,0);
            _loc7_.m_CurrState = RObjectStateType.NEWOBJECT;
            _loc7_.m_ObjectType = RObjectType.TREE1;
            _loc7_.m_reserve = _loc6_.index;
            RockRacer.GameCommon.AddObject(_loc7_);
         }
      }
      
      public function UpdateScene(param1:Number, param2:Number, param3:Number) : void
      {
         this.UVAnimation();
         this.UpdateGeometry(param2,param3);
      }
      
      public function UVAnimation() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_resMap.m_UvAnimationNums)
         {
            _loc2_ = 0;
            while(_loc2_ < this.m_resMap.m_lUvAnimationArray[_loc1_].UVIndexArray.length)
            {
               this.m_resMap.m_lVtxBuf[this.m_resMap.m_lUvAnimationArray[_loc1_].UVIndexArray[_loc2_]].uvt[0] += this.m_resMap.m_lUvAnimationArray[_loc1_].flowU;
               this.m_resMap.m_lVtxBuf[this.m_resMap.m_lUvAnimationArray[_loc1_].UVIndexArray[_loc2_]].uvt[1] += this.m_resMap.m_lUvAnimationArray[_loc1_].flowV;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function UpdateGeometry(param1:Number, param2:Number) : void
      {
         if(param1 < this.m_gridMinLoc.x || param1 > this.m_gridMaxLoc.x || param2 < this.m_gridMinLoc.z || param2 > this.m_gridMaxLoc.z)
         {
            return;
         }
         this.m_cell = Math.abs(param1 - this.m_resMap.m_GridMin.x) / this.m_resMap.m_GrideSpaceX;
         this.m_row = Math.abs(param2 - this.m_resMap.m_GridMin.z) / this.m_resMap.m_GrideSpaceZ;
         this.m_cellID = this.m_row * this.m_resMap.m_GrideDivision + this.m_cell;
         geometry.vertices = this.m_cellGeomData[this.m_cellID].vtxs;
         geometry.faces = this.m_cellGeomData[this.m_cellID].fs;
         this.m_drawVtxs = geometry.vertices.length;
         this.m_drawFaces = geometry.faces.length;
      }
      
      public function GetTerrainType(param1:Number, param2:Number) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = Math.abs(param1 - this.m_heightMap.m_min.x) / this.m_deltaX;
         _loc4_ = Math.abs(param2 - this.m_heightMap.m_min.z) / this.m_deltaZ;
         _loc5_ = this.m_Split * _loc4_ + _loc3_;
         if(_loc3_ >= this.m_Split || _loc4_ >= this.m_Split)
         {
            return -1;
         }
         if((_loc5_ = this.m_heightMap.m_lHeightInfo[_loc5_]) < 0 || _loc5_ >= this.m_heightMap.m_lFaceInfo.length)
         {
            return -1;
         }
         return this.m_heightMap.m_lFaceInfo[_loc5_].type;
      }
      
      public function GetHeightInfo(param1:Number, param2:Number) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc3_ = Math.abs(param1 - this.m_heightMap.m_min.x) / this.m_deltaX;
         _loc4_ = Math.abs(param2 - this.m_heightMap.m_min.z) / this.m_deltaZ;
         _loc5_ = this.m_Split * _loc4_ + _loc3_;
         if(_loc3_ >= this.m_Split || _loc4_ >= this.m_Split)
         {
            return -1;
         }
         if((_loc5_ = this.m_heightMap.m_lHeightInfo[_loc5_]) < 0 || _loc5_ >= this.m_heightMap.m_lFaceInfo.length)
         {
            return -1;
         }
         if(this.m_heightMap.m_lFaceInfo[_loc5_].type == -1)
         {
            return 0;
         }
         _loc6_ = this.m_heightMap.m_lFaceInfo[_loc5_].A;
         _loc7_ = this.m_heightMap.m_lFaceInfo[_loc5_].B;
         _loc8_ = this.m_heightMap.m_lFaceInfo[_loc5_].C;
         _loc9_ = this.m_heightMap.m_lFaceInfo[_loc5_].D;
         return Number(-(_loc6_ * param1 + _loc8_ * param2 + _loc9_) / _loc7_);
      }
      
      public function GetTerrainInfo(param1:Number, param2:Number) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc3_ = Math.abs(param1 - this.m_heightMap.m_min.x) / this.m_deltaX;
         _loc4_ = Math.abs(param2 - this.m_heightMap.m_min.z) / this.m_deltaZ;
         _loc5_ = this.m_Split * _loc4_ + _loc3_;
         var _loc7_:Number = 1;
         _loc5_ = this.m_heightMap.m_lHeightInfo[_loc5_];
         if(!(_loc3_ >= this.m_Split || _loc4_ >= this.m_Split))
         {
            if(!(_loc5_ < 0 || _loc5_ >= this.m_heightMap.m_lFaceInfo.length))
            {
               if(this.m_heightMap.m_lFaceInfo[_loc5_].type != -1)
               {
                  _loc6_ = this.m_heightMap.m_lFaceInfo[_loc5_].A;
                  _loc7_ = this.m_heightMap.m_lFaceInfo[_loc5_].B;
                  _loc8_ = this.m_heightMap.m_lFaceInfo[_loc5_].C;
                  _loc9_ = this.m_heightMap.m_lFaceInfo[_loc5_].D;
                  _loc10_ = -(_loc6_ * param1 + _loc8_ * param2 + _loc9_) / _loc7_;
               }
            }
         }
         return {
            "A":_loc6_,
            "B":_loc7_,
            "C":_loc8_,
            "D":_loc9_,
            "H":_loc10_
         };
      }
   }
}
