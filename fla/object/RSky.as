package object
{
   import flash.geom.Vector3D;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.materials.utils.MaterialsList;
   import player.RTerrain;
   import resourcemgr.RResourceObj;
   
   public class RSky extends TriangleMesh3D
   {
       
      
      public var m_ResID:int;
      
      public var m_loc:Vector3D;
      
      public function RSky()
      {
         this.m_loc = new Vector3D();
         super(null,new Array(),new Array());
         this.materials = new MaterialsList();
         this.useClipping = true;
      }
      
      public function InitSky() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Triangle3D = null;
         this.materials = new MaterialsList();
         this.useClipping = true;
         this.geometry.faces = new Array();
         faces = new Array();
         this.m_ResID = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("sky");
         var _loc2_:RResourceObj = new RResourceObj(false);
         _loc2_ = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[this.m_ResID];
         _loc1_ = 0;
         while(_loc1_ < _loc2_.m_MaterialsNum)
         {
            this.materials.addMaterial(_loc2_.m_MaterialBuf[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_.m_Geometryfaces.length)
         {
            _loc12_ = new Triangle3D(this,[_loc2_.m_Geometryfaces[_loc1_].v2,_loc2_.m_Geometryfaces[_loc1_].v0,_loc2_.m_Geometryfaces[_loc1_].v1],_loc2_.m_Geometryfaces[_loc1_].material,[_loc2_.m_Geometryfaces[_loc1_].uv2,_loc2_.m_Geometryfaces[_loc1_].uv0,_loc2_.m_Geometryfaces[_loc1_].uv1],true);
            this.geometry.faces.push(_loc12_);
            _loc1_++;
         }
         var _loc5_:RTerrain;
         (_loc5_ = RockRacer.GameCommon.GameClient.m_Terrain).m_MaxLoc = new Vector3D(230835.078,12601.82,245637.15);
         _loc5_.m_MinLoc = new Vector3D(-175018.75,-3376.08,-235746.125);
         (_loc4_ = _loc5_.m_MaxLoc.subtract(_loc5_.m_MinLoc)).scaleBy(0.5);
         _loc3_ = _loc4_.add(_loc5_.m_MinLoc);
         (_loc7_ = _loc2_.m_Max.subtract(_loc2_.m_Min)).scaleBy(0.5);
         _loc6_ = _loc7_.add(_loc2_.m_Min);
         var _loc8_:Vector3D = new Vector3D(_loc4_.x / _loc7_.x * 4,1,_loc4_.z / _loc7_.z * 4);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.m_VtxsNum)
         {
            _loc9_ = _loc2_.m_VtxBuf[_loc1_].x;
            _loc10_ = _loc2_.m_VtxBuf[_loc1_].y;
            _loc11_ = _loc2_.m_VtxBuf[_loc1_].z;
            _loc9_ = (_loc9_ - _loc6_.x) * _loc8_.x + _loc6_.x;
            _loc10_ = (_loc10_ - _loc6_.y) * _loc8_.z + _loc6_.y;
            _loc11_ = (_loc11_ - _loc6_.z) * _loc8_.z + _loc6_.z;
            _loc2_.m_VtxBuf[_loc1_].x = _loc9_;
            _loc2_.m_VtxBuf[_loc1_].y = _loc10_;
            _loc2_.m_VtxBuf[_loc1_].z = _loc11_;
            geometry.vertices.push(_loc2_.m_VtxBuf[_loc1_]);
            _loc1_++;
         }
         this.y = 160;
      }
      
      public function UVAnimation() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.geometry.vertices.length)
         {
            this.geometry.vertices[_loc1_].uvt[0] += 0.0001;
            _loc1_++;
         }
      }
   }
}
