package object
{
   import Const.RObjectType;
   import common.ROBJECTINFO;
   import flash.geom.Vector3D;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.materials.MovieMaterial;
   import resourcemgr.RResourceBox;
   import resourcemgr.RResourceMap;
   
   public class RTreasure extends RGameEnt
   {
       
      
      public var m_type:int = 0;
      
      public function RTreasure(param1:ROBJECTINFO)
      {
         param1.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(param1.m_CurrLoc.x,param1.m_CurrLoc.z) + 50;
         super(param1);
         this.currState.bSphere.ReSet(100,new Vector3D(this.currState.loc.x,this.currState.loc.y,this.currState.loc.z));
         this.m_type = param1.m_ObjectType;
         m_DestPath = param1.m_reserve;
      }
      
      override public function UpdateObjInfo(param1:ROBJECTINFO) : void
      {
      }
      
      override public function Tick() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Vector3D = new Vector3D();
         _loc1_.x = RockRacer.GameCommon.GameClient.m_View.camera.x - this.currState.loc.x;
         _loc1_.y = RockRacer.GameCommon.GameClient.m_View.camera.y - this.currState.loc.y;
         _loc1_.z = RockRacer.GameCommon.GameClient.m_View.camera.z - this.currState.loc.z;
         _loc1_.normalize();
         _loc1_.dotProduct(Vector3D.Z_AXIS);
         _loc2_ = Vector3D.angleBetween(_loc1_,Vector3D.Z_AXIS) * 180 / Math.PI;
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         if(_loc1_.x < 0)
         {
            this.m_renderObject.rotationY = -_loc2_ - 180;
         }
         else
         {
            this.m_renderObject.rotationY = _loc2_ + 180;
         }
         super.Tick();
      }
      
      override public function BuildGeom() : void
      {
         var _loc1_:MovieMaterial = null;
         var _loc2_:int = 0;
         var _loc5_:Vertex3D = null;
         var _loc6_:Vertex3D = null;
         var _loc7_:Vertex3D = null;
         var _loc8_:NumberUV = null;
         var _loc9_:NumberUV = null;
         var _loc10_:NumberUV = null;
         switch(this.m_type)
         {
            case RObjectType.TREE1:
               this.m_ResID = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("postcard");
               _loc1_ = new MovieMaterial(new matPostcard(),true,true,false);
               break;
            case RObjectType.TREE2:
               this.m_ResID = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("Coffee");
               _loc1_ = new MovieMaterial(new matCoffee(),true,true,false);
               break;
            case RObjectType.TREE3:
               this.m_ResID = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("Oil");
               _loc1_ = new MovieMaterial(new matOil(),true,true,false);
         }
         _loc1_.doubleSided = true;
         var _loc3_:RResourceBox = new RResourceBox();
         _loc3_ = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[this.m_ResID];
         m_renderObject = new TriangleMesh3D(null,new Array(),new Array());
         m_renderObject.meshSort = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_VtxNum)
         {
            m_renderObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         var _loc4_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_TriNum)
         {
            _loc5_ = m_renderObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc6_ = m_renderObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc7_ = m_renderObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc10_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            m_renderObject.geometry.faces.push(new Triangle3D(m_renderObject,[_loc7_,_loc6_,_loc5_],_loc1_,[_loc10_,_loc9_,_loc8_]));
            _loc2_++;
         }
         m_renderObject.x = this.currState.loc.x;
         m_renderObject.y = this.currState.loc.y;
         m_renderObject.z = this.currState.loc.z;
         m_renderObject.m_delta = -1000;
      }
      
      public function SetVisibleState(param1:RResourceMap, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         if(!hit)
         {
            m_renderObject.visible = false;
            return;
         }
         _loc6_ = Math.abs(this.currState.loc.x - param1.m_GridMin.x) / param1.m_GrideSpaceX;
         if((_loc8_ = (_loc7_ = Math.abs(this.currState.loc.z - param1.m_GridMin.z) / param1.m_GrideSpaceZ) * param1.m_GrideDivision + _loc6_) == param2)
         {
            if(hit)
            {
               m_renderObject.visible = true;
            }
            return;
         }
         _loc3_ = param1.m_lCellInfoList[param2].pvscell;
         var _loc10_:int = 0;
         while(_loc10_ < _loc3_.length)
         {
            if(_loc3_[_loc10_] == _loc8_)
            {
               if(hit)
               {
                  m_renderObject.visible = true;
               }
               return;
            }
            _loc10_++;
         }
         if(hit)
         {
            m_renderObject.visible = false;
         }
      }
      
      override public function CollisionProc(param1:RGameEnt) : void
      {
         if(RObjectType.TREE2 == this.m_type)
         {
            return;
         }
         if(param1.m_ObjType == RObjectType.AICAR || param1.m_ObjType == RObjectType.PLAYERCAR)
         {
            hit = false;
            m_renderObject.visible = false;
         }
      }
   }
}
