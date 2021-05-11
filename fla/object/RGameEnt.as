package object
{
   import AI.RAI;
   import Const.RObjectStateType;
   import Const.RPlayerAnimState;
   import common.ROBJECTINFO;
   import flash.geom.Vector3D;
   import org.papervision3d.core.geom.TriangleMesh3D;
   
   public class RGameEnt
   {
       
      
      public var m_ObjID:int;
      
      public var m_ResID:int;
      
      public var m_ObjType:int;
      
      public var m_friction:Number;
      
      public var m_Rollfriction:Number;
      
      public var m_renderObject:TriangleMesh3D;
      
      public var m_cellId:int;
      
      public var currState:EntState;
      
      public var preState:EntState;
      
      public var m_FrameNum:int;
      
      public var m_DestPath:int = 1;
      
      public var m_CurrStatus:int;
      
      public var m_Direction:Vector3D;
      
      public var m_CollisionType:Boolean = false;
      
      public var m_AI:RAI;
      
      private var _hit:Boolean = true;
      
      public function RGameEnt(param1:ROBJECTINFO)
      {
         this.m_friction = new Number(0.05);
         this.m_Direction = new Vector3D();
         super();
         this.currState = new EntState();
         this.preState = new EntState();
         this.m_ObjID = param1.m_ObjectID;
         this.m_ObjType = param1.m_ObjectType;
         this.currState.pose = param1.m_CurrPose;
         this.currState.loc = param1.m_CurrLoc;
         this.m_CurrStatus = param1.m_CurrState;
         this.currState.animState = RPlayerAnimState.CarIsIdle;
         this.preState.animState = -1;
      }
      
      public function set hit(param1:Boolean) : void
      {
         this._hit = param1;
      }
      
      public function get hit() : Boolean
      {
         return this._hit;
      }
      
      public function Animation(param1:int) : void
      {
      }
      
      public function BuildGeom() : void
      {
      }
      
      public function UpdateObjInfo(param1:ROBJECTINFO) : void
      {
         this.m_ObjID = param1.m_ObjectID;
         this.m_ObjType = param1.m_ObjectType;
         this.currState.pose = param1.m_CurrPose;
         this.currState.loc = param1.m_CurrLoc;
      }
      
      public function DeleteObject() : void
      {
         this.hit = false;
         RockRacer.GameCommon.g_ObjectInfo[RockRacer.GameCommon.GetObjectID(this.m_ObjID)].m_CurrState = RObjectStateType.DELETEOBJECT;
      }
      
      public function SetAnimState(param1:int) : void
      {
      }
      
      public function SetLoc(param1:Number, param2:Number, param3:Number) : void
      {
         this.currState.loc.x = param1;
         this.currState.loc.y = param2;
         this.currState.loc.z = param3;
         this.currState.bSphere.m_loc.x = param1;
         this.currState.bSphere.m_loc.y = param2;
         this.currState.bSphere.m_loc.z = param3;
      }
      
      public function VectorSquareDistance(param1:Vector3D, param2:Vector3D) : Number
      {
         return (param1.x - param2.x) * (param1.x - param2.x) + (param1.z - param2.z) * (param1.z - param2.z);
      }
      
      public function SetPreState() : void
      {
         this.preState.loc.x = this.currState.loc.x;
         this.preState.loc.y = this.currState.loc.y;
         this.preState.loc.z = this.currState.loc.z;
         this.preState.pose.x = this.currState.pose.x;
         this.preState.pose.y = this.currState.pose.y;
         this.preState.mass = this.currState.mass;
         this.preState.vel.x = this.currState.vel.x;
         this.preState.vel.y = this.currState.vel.y;
         this.preState.vel.z = this.currState.vel.z;
         this.preState.actionState = this.currState.actionState;
         this.preState.animState = this.currState.animState;
         this.preState.curFrame = this.currState.curFrame;
      }
      
      public function Tick() : void
      {
         this.SetPreState();
      }
      
      public function CollisionTest(param1:RGameEnt) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         if(!this.m_CollisionType || !param1.m_CollisionType)
         {
            return false;
         }
         if(!this.hit)
         {
            return false;
         }
         var _loc2_:RBSphere3 = new RBSphere3(this.currState.bSphere.m_radius + this.currState.vel.length,this.currState.loc);
         var _loc3_:RBSphere3 = new RBSphere3(param1.currState.bSphere.m_radius + param1.currState.vel.length,param1.currState.loc);
         if(!RBSphere3.Intersect(_loc2_,_loc3_))
         {
            return false;
         }
         _loc2_.m_radius = this.currState.bSphere.m_radius;
         _loc3_.m_radius = param1.currState.bSphere.m_radius;
         var _loc4_:Vector3D = this.currState.vel.clone();
         var _loc5_:Vector3D = param1.currState.vel.clone();
         if(_loc7_ = (_loc7_ = int(Math.max(Math.floor(_loc4_.length / _loc2_.m_radius),Math.floor(_loc5_.length / _loc3_.m_radius)))) + 1)
         {
            _loc4_.scaleBy(1 / _loc7_);
            _loc5_.scaleBy(1 / _loc7_);
         }
         _loc6_ = 0;
         while(_loc6_ <= _loc7_)
         {
            if(RBSphere3.Intersect(_loc2_,_loc3_))
            {
               return true;
            }
            _loc2_.m_loc.incrementBy(_loc4_);
            _loc3_.m_loc.incrementBy(_loc5_);
            _loc6_++;
         }
         return false;
      }
      
      public function CollisionProc(param1:RGameEnt) : void
      {
      }
   }
}
