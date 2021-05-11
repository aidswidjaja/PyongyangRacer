package player
{
   import flash.geom.Vector3D;
   import object.RGameEnt;
   import resourcemgr.RResourceMap;
   
   public class RCollisionWall
   {
       
      
      public var m_resMap:RResourceMap;
      
      public var m_cellGeomData:Array;
      
      public var m_Cell:int;
      
      public var m_Row:int;
      
      public var m_cellID:int;
      
      public var m_CollisionNormal:Vector3D;
      
      public var m_MaxLoc:Vector3D;
      
      public var m_MinLoc:Vector3D;
      
      public function RCollisionWall()
      {
         this.m_CollisionNormal = new Vector3D();
         super();
         this.m_cellGeomData = new Array();
      }
      
      public function InitCollisionWall() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Vector3D = null;
         var _loc12_:Vector3D = null;
         var _loc13_:Vector3D = null;
         this.m_cellGeomData = new Array();
         var _loc1_:int = RockRacer.GameCommon.GameClient.m_LevelRsr.GetIDFromName("collision");
         this.m_resMap = RockRacer.GameCommon.GameClient.m_LevelRsr.m_lrsObj[_loc1_];
         this.m_MaxLoc = this.m_resMap.m_Max;
         this.m_MinLoc = this.m_resMap.m_Min;
         _loc2_ = 0;
         while(_loc2_ < this.m_resMap.m_GrideDivision * this.m_resMap.m_GrideDivision)
         {
            _loc4_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.m_resMap.m_lCellInfoList[_loc2_].triIdxbuf.length)
            {
               _loc7_ = this.m_resMap.m_lCellInfoList[_loc2_].triIdxbuf[_loc3_];
               _loc8_ = this.m_resMap.m_lTrisBuf[_loc7_].v0;
               _loc9_ = this.m_resMap.m_lTrisBuf[_loc7_].v1;
               _loc10_ = this.m_resMap.m_lTrisBuf[_loc7_].v2;
               _loc11_ = new Vector3D(this.m_resMap.m_lVtxBuf[_loc8_].x,this.m_resMap.m_lVtxBuf[_loc8_].y,this.m_resMap.m_lVtxBuf[_loc8_].z);
               _loc12_ = new Vector3D(this.m_resMap.m_lVtxBuf[_loc9_].x,this.m_resMap.m_lVtxBuf[_loc9_].y,this.m_resMap.m_lVtxBuf[_loc9_].z);
               _loc13_ = new Vector3D(this.m_resMap.m_lVtxBuf[_loc10_].x,this.m_resMap.m_lVtxBuf[_loc10_].y,this.m_resMap.m_lVtxBuf[_loc10_].z);
               _loc6_ = {
                  "a":_loc11_,
                  "b":_loc12_,
                  "c":_loc13_
               };
               _loc4_.push(_loc6_);
               _loc3_++;
            }
            _loc5_ = {"faces":_loc4_};
            this.m_cellGeomData.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function CollisionProc(param1:RGameEnt, param2:int) : Vector3D
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc10_:Vector3D = null;
         var _loc11_:Vector3D = null;
         var _loc12_:Vector3D = null;
         var _loc13_:Number = NaN;
         var _loc14_:Vector3D = null;
         var _loc15_:Number = NaN;
         var _loc16_:Vector3D = null;
         var _loc17_:Number = NaN;
         var _loc18_:Vector3D = null;
         var _loc19_:Number = NaN;
         var _loc20_:Vector3D = null;
         var _loc21_:Vector3D = null;
         var _loc22_:Vector3D = null;
         var _loc23_:Vector3D = null;
         var _loc24_:Vector3D = null;
         var _loc25_:Vector3D = null;
         var _loc26_:Vector3D = null;
         var _loc27_:RGameClient = null;
         if(param1.currState.vel.length < 0.1)
         {
            return null;
         }
         _loc3_ = Math.abs(param1.currState.loc.x - this.m_resMap.m_GridMin.x) / this.m_resMap.m_GrideSpaceX;
         _loc4_ = Math.abs(param1.currState.loc.z - this.m_resMap.m_GridMin.z) / this.m_resMap.m_GrideSpaceZ;
         if(_loc3_ >= this.m_resMap.m_GrideDivision || _loc4_ >= this.m_resMap.m_GrideDivision)
         {
            return null;
         }
         var _loc5_:int = _loc4_ * this.m_resMap.m_GrideDivision + _loc3_;
         var _loc6_:Array = new Array();
         var _loc8_:Vector3D;
         var _loc9_:Vector3D = (_loc8_ = new Vector3D(_loc3_ * this.m_resMap.m_GrideSpaceX + this.m_resMap.m_GridMin.x,0,_loc4_ * this.m_resMap.m_GrideSpaceZ + this.m_resMap.m_GridMin.z)).add(new Vector3D(this.m_resMap.m_GrideSpaceX,0,this.m_resMap.m_GrideSpaceZ));
         _loc6_.push(_loc5_);
         if(Math.abs(_loc8_.x - param1.currState.loc.x) < 300 && _loc3_ > 0)
         {
            _loc6_.push(_loc5_ - 1);
         }
         if(Math.abs(_loc9_.x - param1.currState.loc.x) < 300 && _loc3_ < this.m_resMap.m_GrideDivision - 1)
         {
            _loc6_.push(_loc5_ + 1);
         }
         if(Math.abs(_loc8_.z - param1.currState.loc.z) < 300 && _loc4_ > 0)
         {
            _loc6_.push(_loc5_ - this.m_resMap.m_GrideDivision);
         }
         if(Math.abs(_loc9_.z - param1.currState.loc.z) < 300 && _loc4_ < this.m_resMap.m_GrideDivision - 1)
         {
            _loc6_.push(_loc5_ + this.m_resMap.m_GrideDivision);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < this.m_cellGeomData[_loc6_[_loc3_]].faces.length)
            {
               _loc10_ = this.m_cellGeomData[_loc6_[_loc3_]].faces[_loc7_].a;
               _loc11_ = this.m_cellGeomData[_loc6_[_loc3_]].faces[_loc7_].b;
               _loc12_ = this.m_cellGeomData[_loc6_[_loc3_]].faces[_loc7_].c;
               (_loc14_ = _loc11_.subtract(_loc10_).crossProduct(_loc12_.subtract(_loc10_))).normalize();
               _loc13_ = -_loc10_.dotProduct(_loc14_);
               if(!((_loc15_ = param1.currState.loc.add(param1.currState.vel).dotProduct(_loc14_) + _loc13_) > param1.currState.bSphere.m_radius || _loc15_ < -param1.currState.vel.length))
               {
                  _loc16_ = new Vector3D();
                  _loc17_ = -param1.currState.vel.dotProduct(_loc14_);
                  _loc18_ = param1.currState.vel.clone();
                  if(_loc17_ < 0.1)
                  {
                     _loc17_ = 0.1;
                  }
                  _loc19_ = (_loc17_ + _loc15_ - param1.currState.bSphere.m_radius) / _loc17_;
                  if(Math.abs(_loc19_) > 1)
                  {
                     (_loc18_ = _loc14_.clone()).scaleBy(param1.currState.bSphere.m_radius - _loc15_ - _loc17_);
                     _loc16_ = param1.currState.loc.add(_loc18_);
                     _loc18_.scaleBy(0);
                  }
                  else
                  {
                     _loc18_.scaleBy(_loc19_);
                     _loc16_ = param1.currState.loc.add(_loc18_);
                  }
                  _loc20_ = new Vector3D();
                  (_loc21_ = _loc14_.clone()).scaleBy(param1.currState.bSphere.m_radius);
                  _loc20_ = _loc16_.subtract(_loc21_);
                  _loc20_.y += 22;
                  (_loc22_ = _loc11_.subtract(_loc10_).crossProduct(_loc20_.subtract(_loc10_))).normalize();
                  (_loc23_ = _loc12_.subtract(_loc11_).crossProduct(_loc20_.subtract(_loc11_))).normalize();
                  (_loc24_ = _loc10_.subtract(_loc12_).crossProduct(_loc20_.subtract(_loc12_))).normalize();
                  if((_loc22_.length < 0.1 || _loc22_.nearEquals(_loc14_,0.01)) && (_loc23_.length < 0.1 || _loc23_.nearEquals(_loc14_,0.01)) && (_loc24_.length < 0.1 || _loc24_.nearEquals(_loc14_,0.01)))
                  {
                     if(Math.abs(_loc19_) > 1)
                     {
                        param1.currState.loc = _loc16_.clone();
                     }
                     _loc25_ = new Vector3D();
                     _loc26_ = _loc14_.clone();
                     _loc27_ = RockRacer.GameCommon.GameClient;
                     switch(param2)
                     {
                        case 0:
                           _loc25_ = param1.currState.vel.subtract(_loc18_);
                           if(Vector3D.angleBetween(_loc26_,_loc25_) > Math.PI * ((180 - _loc27_.f_angle) / 180))
                           {
                              _loc26_.scaleBy(-_loc25_.dotProduct(_loc14_) * (1 + _loc27_.f_elas));
                           }
                           else if(_loc25_.length > _loc27_.o_limvel)
                           {
                              _loc25_.scaleBy(_loc27_.o_fric);
                              if(_loc25_.crossProduct(_loc26_).y < 0)
                              {
                                 param1.currState.pose.y -= 2;
                              }
                              else
                              {
                                 param1.currState.pose.y += 2;
                              }
                              _loc26_.scaleBy(-_loc25_.dotProduct(_loc14_) * (1 + _loc27_.o_elas));
                           }
                           param1.currState.vel = _loc18_.add(_loc26_.add(_loc25_));
                           break;
                        case 1:
                           _loc26_.scaleBy(-2 * param1.currState.vel.dotProduct(_loc14_));
                           param1.currState.vel.incrementBy(_loc26_);
                     }
                     _loc20_.y -= 22;
                     return _loc20_;
                  }
               }
               _loc7_++;
            }
            _loc3_++;
         }
         return null;
      }
   }
}
