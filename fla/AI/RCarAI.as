package AI
{
   import Const.RActionState;
   import Const.RObjectType;
   import flash.geom.Vector3D;
   import flash.utils.getTimer;
   import player.RCar;
   
   public class RCarAI extends RAI
   {
       
      
      public var m_CarObject:RCar;
      
      public var m_deltaDest:Vector3D;
      
      public var m_selectTime:int = 0;
      
      public var m_useTime:int = 0;
      
      public function RCarAI(param1:RCar, param2:int = 1)
      {
         this.m_deltaDest = new Vector3D(0,0,0);
         this.m_CarObject = param1;
         super(param1,param2);
      }
      
      override public function OnMessage(param1:int, param2:Number, param3:Object) : Boolean
      {
         switch(param1)
         {
            case CHANGERANK:
               this.m_CarObject.m_Rank = param2;
               return true;
            case GETBONUS:
               this.m_CarObject.SelectBonus();
               this.m_selectTime = getTimer();
               this.m_useTime = (Math.random() + 1) * 3000;
               return true;
            default:
               return super.OnMessage(param1,param2,param3);
         }
      }
      
      override public function OnRefresh() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.m_CarObject.m_Rank > 1)
         {
            _loc1_ = RockRacer.GameCommon.GameClient.m_CarList;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].m_Rank == this.m_CarObject.m_Rank - 1)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ >= _loc1_.length)
            {
               _loc2_ = 0;
            }
            _loc3_ = DistanceXZ(this.m_CarObject.currState.loc,_loc1_[_loc2_].currState.loc);
            if(_loc3_ > 10000)
            {
               this.m_CarObject.m_AIAcc = this.m_CarObject.m_Accel / 20 * this.m_CarObject.m_Rank;
            }
         }
         else
         {
            this.m_CarObject.m_AIAcc = 0;
         }
         if(this.m_selectTime && getTimer() - this.m_selectTime > this.m_useTime)
         {
            this.m_CarObject.UseBonus();
         }
         super.OnRefresh();
      }
      
      override public function UpdatePath() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Vector3D = null;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc2_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
         var _loc3_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lCurveInfo;
         _loc1_ = DistanceXZ(this.m_CarObject.currState.loc,_loc2_[this.m_CarObject.m_DestPath].add(this.m_deltaDest));
         var _loc5_:int = 1;
         var _loc6_:int;
         if((_loc6_ = this.m_CarObject.m_DestPath - 1) < 0)
         {
            _loc6_ = _loc2_.length - 2;
         }
         var _loc7_:Vector3D = _loc2_[this.m_CarObject.m_DestPath].subtract(_loc2_[_loc6_]);
         var _loc8_:Vector3D = _loc2_[this.m_CarObject.m_DestPath].subtract(this.m_CarObject.currState.loc);
         var _loc9_:Vector3D = this.m_CarObject.currState.vel.clone();
         _loc7_.y = 0;
         _loc8_.y = 0;
         _loc9_.y = 0;
         if(_loc9_.length == 0)
         {
            (_loc9_ = _loc7_.clone()).normalize();
            _loc9_.scaleBy(11);
         }
         _loc7_.y = 1;
         if(Vector3D.angleBetween(_loc7_,_loc9_) > Math.PI / 2 && this.m_CarObject.currState.actionState != RActionState.AUTOPILOT_PLAY)
         {
            _loc5_ = -1;
         }
         if(_loc9_.length < 10)
         {
            return false;
         }
         if(_loc5_ == 1)
         {
            if(Vector3D.angleBetween(_loc8_,_loc7_) > Math.PI / 2)
            {
               ++this.m_CarObject.m_DestPath;
               if(this.m_CarObject.m_DestPath >= _loc2_.length)
               {
                  this.m_CarObject.m_DestPath = 1;
                  this.m_CarObject.UpdateLap();
               }
            }
            else
            {
               if((_loc11_ = this.m_CarObject.m_DestPath + 1) >= _loc2_.length)
               {
                  _loc11_ = 1;
               }
               _loc12_ = DistanceXZ(_loc2_[_loc11_],this.m_CarObject.currState.loc);
               _loc13_ = DistanceXZ(_loc2_[this.m_CarObject.m_DestPath],this.m_CarObject.currState.loc);
               if(_loc12_ < _loc13_)
               {
                  ++this.m_CarObject.m_DestPath;
                  if(this.m_CarObject.m_DestPath >= _loc2_.length)
                  {
                     this.m_CarObject.m_DestPath = 1;
                     this.m_CarObject.UpdateLap();
                  }
               }
            }
         }
         else
         {
            _loc14_ = _loc2_[_loc6_].subtract(this.m_CarObject.currState.loc);
            if(Vector3D.angleBetween(_loc14_,_loc7_) < Math.PI / 2)
            {
               this.m_CarObject.m_DestPath = _loc6_;
            }
         }
         if(this.m_CarObject.m_DestPath > _loc2_.length / 2 - 3 && this.m_CarObject.m_DestPath < _loc2_.length / 2 + 2)
         {
            this.m_CarObject.m_passPath = true;
         }
         if((_loc6_ = this.m_CarObject.m_DestPath - 1) < 0)
         {
            _loc6_ = _loc2_.length - 2;
         }
         _loc7_ = _loc2_[this.m_CarObject.m_DestPath].subtract(_loc2_[_loc6_]);
         var _loc10_:Number = Vector3D.angleBetween(_loc7_,this.m_CarObject.m_Direction);
         if(isNaN(_loc10_))
         {
            _loc10_ = 0;
         }
         if(_loc10_ > Math.PI * 0.5 && !this.m_CarObject.m_bWrongway)
         {
            if((_loc15_ = this.m_CarObject.m_DestPath + 1) >= _loc2_.length)
            {
               _loc15_ = 1;
            }
            if((_loc16_ = Vector3D.angleBetween(_loc2_[_loc15_].subtract(_loc2_[_loc6_]),this.m_CarObject.m_Direction)) < Math.PI / 2)
            {
               ++this.m_CarObject.m_DestPath;
               return true;
            }
            this.m_CarObject.m_bWrongway = true;
         }
         else if(_loc10_ < Math.PI * 0.25 && this.m_CarObject.m_bWrongway)
         {
            this.m_CarObject.m_bWrongway = false;
         }
         return false;
      }
      
      override public function FollowPath() : void
      {
         var _loc1_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
         var _loc2_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lCurveInfo;
         if(this.UpdatePath() && this.m_CarObject.m_ObjType == RObjectType.AICAR)
         {
            switch(_loc2_[this.m_CarObject.m_DestPath])
            {
               case 1:
               case 2:
                  this.m_CarObject.m_AIAcc = -this.m_CarObject.m_Accel / 10 * (4 - this.m_CarObject.m_Rank);
            }
         }
         this.FollowPoint(_loc1_[this.m_CarObject.m_DestPath].add(this.m_deltaDest));
      }
      
      override public function FollowPoint(param1:Vector3D) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Number = NaN;
         _loc2_ = param1.subtract(m_GameObject.currState.loc);
         if(_loc2_.z == 0)
         {
            _loc3_ = 90;
         }
         else
         {
            _loc3_ = Math.atan(_loc2_.x / _loc2_.z);
            _loc3_ = _loc3_ * 180 / Math.PI;
         }
         if(_loc2_.z < 0)
         {
            _loc3_ += 180;
         }
         if(_loc3_ < 0)
         {
            _loc3_ += 360;
         }
         var _loc4_:Vector3D;
         (_loc4_ = this.m_CarObject.m_Direction.clone()).y = 0;
         _loc4_.y = 0;
         _loc3_ = Vector3D.angleBetween(_loc4_,_loc2_) * 180 / Math.PI;
         if(isNaN(_loc3_))
         {
            _loc3_ = 0;
         }
         var _loc5_:Vector3D;
         (_loc5_ = _loc4_.crossProduct(_loc2_)).normalize();
         if(_loc5_.y < -0.5)
         {
            _loc3_ = 0 - _loc3_;
         }
         else if(_loc5_.y <= 0.5)
         {
            _loc3_ = 0;
         }
         _loc3_ += Math.sin(m_FlastrateVal) * 40;
         m_GameObject.currState.pose.y += _loc3_ * 0.3;
         this.m_CarObject.SpeedUp();
      }
   }
}
