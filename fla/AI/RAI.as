package AI
{
   import flash.geom.Vector3D;
   import object.RGameEnt;
   
   public class RAI
   {
      
      public static const AI_UNKNOWN:int = 0;
      
      public static const AI_IDLE:int = 1;
      
      public static const AI_FOLLOWPATH:int = 2;
      
      public static const AI_FOLLOWOBJECT:int = 3;
      
      public static const AI_AUTOPILOT:int = 4;
      
      public static const AI_ROAM:int = 5;
      
      public static const AI_FLUSTRATE:int = 6;
      
      public static const UNKNOWN:int = 0;
      
      public static const CHANGERANK:int = 1;
      
      public static const COLLISION:int = 2;
      
      public static const CHANGEAISTATE:int = 3;
      
      public static const GETBONUS:int = 4;
      
      public static const LIMITDIST:Number = 300;
      
      public static const ZEROANGLE:Number = 0.5;
       
      
      public var m_GameObject:RGameEnt;
      
      public var m_DestObject:RGameEnt;
      
      public var m_CurState:int;
      
      public var m_FlastrateVal:Number = 0;
      
      public var m_Hit:Boolean = false;
      
      public function RAI(param1:RGameEnt, param2:int = 1)
      {
         super();
         this.m_GameObject = param1;
         this.m_CurState = param2;
         this.m_Hit = false;
      }
      
      public static function DistanceXZ(param1:Vector3D, param2:Vector3D) : Number
      {
         return Math.sqrt((param1.x - param2.x) * (param1.x - param2.x) + (param1.z - param2.z) * (param1.z - param2.z));
      }
      
      public function OnMessage(param1:int, param2:Number, param3:Object) : Boolean
      {
         switch(param1)
         {
            case CHANGEAISTATE:
               this.m_CurState = param2;
               if(this.m_CurState == AI_FOLLOWOBJECT)
               {
                  this.m_DestObject = RGameEnt(param3);
               }
               this.m_FlastrateVal = 0;
               return true;
            case COLLISION:
               return true;
            default:
               return false;
         }
      }
      
      public function SetAIState(param1:int) : void
      {
         this.m_CurState = param1;
         if(this.m_CurState == AI_FLUSTRATE)
         {
            this.m_FlastrateVal = Math.random() * Math.PI;
         }
         else
         {
            this.m_FlastrateVal = 0;
         }
      }
      
      public function OnRefresh() : void
      {
         switch(this.m_CurState)
         {
            case AI_AUTOPILOT:
            case AI_FOLLOWPATH:
               this.FollowPath();
               break;
            case AI_FOLLOWOBJECT:
               this.FollowObject();
               break;
            case AI_ROAM:
               break;
            case AI_IDLE:
               this.UpdatePath();
               break;
            case AI_FLUSTRATE:
               this.FollowPath();
               this.m_FlastrateVal += Math.PI / 12;
               break;
            case AI_UNKNOWN:
         }
      }
      
      public function UpdatePath() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
         _loc1_ = DistanceXZ(this.m_GameObject.currState.loc,_loc2_[this.m_GameObject.m_DestPath]);
         if(_loc1_ < LIMITDIST * 2)
         {
            ++this.m_GameObject.m_DestPath;
            if(this.m_GameObject.m_DestPath >= _loc2_.length)
            {
               this.m_GameObject.m_DestPath = 1;
            }
            return true;
         }
         return false;
      }
      
      public function FollowPath() : void
      {
         var _loc1_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
         this.UpdatePath();
         this.FollowPoint(_loc1_[this.m_GameObject.m_DestPath]);
      }
      
      public function FollowObject() : void
      {
         var _loc1_:Number = NaN;
         if(this.m_DestObject)
         {
            _loc1_ = DistanceXZ(this.m_GameObject.currState.loc,this.m_DestObject.currState.loc);
         }
         else
         {
            _loc1_ = LIMITDIST * 4;
         }
         if(this.m_DestObject.hit && (_loc1_ < LIMITDIST * 3 || this.m_GameObject.m_DestPath >= this.m_DestObject.m_DestPath))
         {
            this.FollowPoint(this.m_DestObject.currState.loc);
         }
         else
         {
            this.FollowPath();
         }
      }
      
      public function FollowPoint(param1:Vector3D) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc2_ = param1.subtract(this.m_GameObject.currState.loc);
         if(this.m_DestObject == null)
         {
            return;
         }
         _loc3_ = DistanceXZ(this.m_GameObject.currState.loc,this.m_DestObject.currState.loc);
         if(_loc3_ < Math.sqrt(Math.pow(this.m_DestObject.currState.vel.x,2) + Math.pow(this.m_DestObject.currState.vel.z,2)))
         {
            this.m_GameObject.currState.loc.x = param1.x;
            this.m_GameObject.currState.loc.y = param1.y;
            this.m_GameObject.currState.loc.z = param1.z;
            this.m_DestObject.CollisionProc(this.m_GameObject);
            return;
         }
         var _loc4_:Number = this.m_GameObject.currState.vel.length;
         _loc2_.normalize();
         _loc2_.scaleBy(_loc4_);
         this.m_GameObject.currState.vel = _loc2_;
         if(_loc2_.z == 0)
         {
            _loc5_ = 90;
         }
         else
         {
            _loc5_ = (_loc5_ = Math.atan(_loc2_.x / _loc2_.z)) * 180 / Math.PI;
         }
         if(_loc2_.z < 0)
         {
            _loc5_ += 180;
         }
         if(_loc5_ < 0)
         {
            _loc5_ += 360;
         }
         this.m_GameObject.currState.pose.y = _loc5_;
      }
   }
}
