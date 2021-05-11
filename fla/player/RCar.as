package player
{
   import AI.*;
   import Const.*;
   import Effect.*;
   import Menu.RLoadingCourse;
   import common.Client;
   import common.ROBJECTINFO;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   import object.*;
   import org.papervision3d.core.geom.*;
   import org.papervision3d.core.geom.renderables.*;
   import org.papervision3d.core.math.*;
   import org.papervision3d.materials.BitmapFileMaterial;
   import org.papervision3d.materials.special.LineMaterial;
   import org.papervision3d.objects.primitives.Plane;
   import resourcemgr.*;
   
   public class RCar extends RGameEnt
   {
      
      public static const LASTLAP:int = 1;
      
      public static const FORWARD:Number = 1;
      
      public static const BACKWARD:Number = 2;
      
      public static const TURNLEFT:Number = 4;
      
      public static const TURNRIGHT:Number = 8;
      
      public static const WheelOffset:Array = new Array();
      
      public static var m_preRoadLength:int = 100;
      
      public static var prev_path:int = 0;
       
      
      public var m_CarStyle:int;
      
      public var m_CarType:int;
      
      public var m_resObj:RResourceBox;
      
      public var m_autopilotResObj:RResourceBox;
      
      public var m_maskTime:int = 5;
      
      public var m_Accel:Number;
      
      public var m_RollFric:Number;
      
      public var m_DragFric:Number;
      
      public var m_Steer:Number;
      
      public var m_RFact:Number;
      
      public var m_MinVel:Number;
      
      public var m_MaxVel:Number;
      
      public var m_MaxHandle:Number;
      
      public var m_CentFact:Number;
      
      public var m_TurnFact:Number;
      
      public var m_bAccel:int = 0;
      
      public var m_Handle:Number;
      
      private var m_bFlying:Boolean = false;
      
      private var m_FlyingVal:Number;
      
      public var m_passPath:Boolean = false;
      
      public var m_bDirect:Boolean = false;
      
      public var m_Rank:int;
      
      public var m_BonusID:int = 110;
      
      public var m_bWrongway:Boolean = false;
      
      public var m_Lap:int = 0;
      
      public var m_LapTimes:Array;
      
      public var m_BonusAcc:Number;
      
      public var m_BoosterAcc:Number;
      
      public var m_AIAcc:Number;
      
      public var m_BonusVel:Number;
      
      public var m_bHandleMark:Number;
      
      protected const PHOTO_WIDTH:int = 70;
      
      protected const PHOTO_HEIGHT:int = 70;
      
      protected const PHOTO_FRAME_SIZE:int = 2;
      
      protected const PHOTO_FRAME_COLOR:int = 65280;
      
      protected const PHOTO_Y:int = 200;
      
      public var m_AnimFrame:RResourceAnim;
      
      public var m_Carproperty:RResourceCar;
      
      private var ActionTime:int = 0;
      
      public var AccelLoadTime:int = 0;
      
      public var m_FLWheelObject:TriangleMesh3D;
      
      public var m_FRWheelObject:TriangleMesh3D;
      
      public var m_BLWheelObject:TriangleMesh3D;
      
      public var m_BRWheelObject:TriangleMesh3D;
      
      public var m_FLWheelLoc:Number3D;
      
      public var m_FRWheelLoc:Number3D;
      
      public var m_BLWheelLoc:Number3D;
      
      public var m_BRWheelLoc:Number3D;
      
      protected var wheel_roll_angle:int = 0;
      
      public var m_autopilot:TriangleMesh3D;
      
      public var m_lowRndrObject:TriangleMesh3D;
      
      public var m_middleRndrObject:TriangleMesh3D;
      
      public var m_highRndrObject:TriangleMesh3D;
      
      protected var m_TerrainType:int;
      
      public var m_yaw:Number = 0;
      
      public var m_roll:Number = 0;
      
      public var m_pitch:Number = 0;
      
      public var m_Squirrel_visible:Boolean = false;
      
      public var m_isForward:int = 0;
      
      public var m_UseBonusTime:int;
      
      public var m_visiblelevel:int = 0;
      
      protected var isautopilotbegin:Boolean = false;
      
      public var isCarStop:Boolean = false;
      
      public var isCarOut:Boolean = false;
      
      protected var delta_y:Number = 0;
      
      protected var m_Sound:Sound;
      
      protected var m_EngineSndChannel:SoundChannel;
      
      protected var m_CarSndChannel:SoundChannel;
      
      protected var m_TerrainSndChannel:SoundChannel;
      
      protected var m_EffectSndChannel:SoundChannel;
      
      public var m_userId:int;
      
      public var m_PlayerPicture:Plane;
      
      public var m_msgCount:int;
      
      public var m_photoFrame1:Lines3D;
      
      public var m_photoFrame2:Lines3D;
      
      public var m_photoFrame3:Lines3D;
      
      public var m_photoFrame4:Lines3D;
      
      public var m_isDelete:Boolean;
      
      public var m_bBA:int;
      
      public var m_autoState:Boolean;
      
      private var m_targetLoc:Vector3D;
      
      private var m_targetPose:Vector3D;
      
      private var m_targetVel:Vector3D;
      
      public var m_bGuideDir:Boolean = false;
      
      public var m_bGuideWrong:Boolean = false;
      
      public var m_bInfo:Boolean = false;
      
      public var m_isAutoPilot:Boolean = false;
      
      public function RCar(param1:ROBJECTINFO)
      {
         this.m_Accel = new Number(10);
         this.m_RollFric = new Number(0.05);
         this.m_DragFric = new Number(0.8);
         this.m_Steer = new Number(10);
         this.m_RFact = new Number(8);
         this.m_MinVel = new Number(2);
         this.m_MaxVel = new Number(this.m_Accel * (1 - this.m_RollFric) / this.m_RollFric);
         this.m_MaxHandle = new Number(45);
         this.m_CentFact = new Number(1);
         this.m_TurnFact = new Number(0.3);
         this.m_Handle = new Number(0);
         this.m_FlyingVal = new Number(0);
         this.m_LapTimes = new Array();
         this.m_BonusAcc = new Number(0);
         this.m_BoosterAcc = new Number(0);
         this.m_AIAcc = new Number(0);
         this.m_BonusVel = new Number(0);
         this.m_FLWheelLoc = new Number3D(-54,22,28);
         this.m_FRWheelLoc = new Number3D(54,22,28);
         this.m_BLWheelLoc = new Number3D(-65,23,-70);
         this.m_BRWheelLoc = new Number3D(65,23,-70);
         this.m_autopilot = new TriangleMesh3D(null,new Array(),new Array());
         this.m_lowRndrObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_middleRndrObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_highRndrObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_targetLoc = new Vector3D();
         this.m_targetPose = new Vector3D();
         this.m_targetVel = new Vector3D();
         if(!RockRacer.GameCommon.g_SingleGame)
         {
            this.m_userId = param1.m_userId;
            this.m_PlayerPicture = new Plane(null,this.PHOTO_WIDTH,this.PHOTO_WIDTH,8,8);
            this.m_photoFrame1 = new Lines3D(new LineMaterial(this.PHOTO_FRAME_COLOR,1));
            this.m_photoFrame1.addNewLine(this.PHOTO_FRAME_SIZE,-this.PHOTO_WIDTH / 2,-this.PHOTO_HEIGHT / 2,0,this.PHOTO_WIDTH / 2,-this.PHOTO_HEIGHT / 2,0);
            this.m_photoFrame2 = new Lines3D(new LineMaterial(this.PHOTO_FRAME_COLOR,1));
            this.m_photoFrame2.addNewLine(this.PHOTO_FRAME_SIZE,this.PHOTO_WIDTH / 2,-this.PHOTO_HEIGHT / 2,0,this.PHOTO_WIDTH / 2,this.PHOTO_HEIGHT / 2,0);
            this.m_photoFrame3 = new Lines3D(new LineMaterial(this.PHOTO_FRAME_COLOR,1));
            this.m_photoFrame3.addNewLine(this.PHOTO_FRAME_SIZE,this.PHOTO_WIDTH / 2,this.PHOTO_HEIGHT / 2,0,-this.PHOTO_WIDTH / 2,this.PHOTO_HEIGHT / 2,0);
            this.m_photoFrame4 = new Lines3D(new LineMaterial(this.PHOTO_FRAME_COLOR,1));
            this.m_photoFrame4.addNewLine(this.PHOTO_FRAME_SIZE,-this.PHOTO_WIDTH / 2,this.PHOTO_HEIGHT / 2,0,-this.PHOTO_WIDTH / 2,-this.PHOTO_HEIGHT / 2,0);
         }
         super(param1);
         this.currState.pose.y = param1.m_CurrPose.y;
         if(param1.m_ObjectType == RObjectType.PLAYERCAR)
         {
            this.m_Sound = new Sound();
            this.m_EngineSndChannel = new SoundChannel();
            this.m_CarSndChannel = new SoundChannel();
            this.m_EffectSndChannel = new SoundChannel();
            this.m_TerrainSndChannel = new SoundChannel();
         }
         m_renderObject = new TriangleMesh3D(null,new Array(),new Array());
         m_renderObject.meshSort = 1;
         this.m_BonusID = RObjectType.NONE_BONUS;
         this.m_FLWheelObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_FRWheelObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_BLWheelObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_BRWheelObject = new TriangleMesh3D(null,new Array(),new Array());
         this.m_FLWheelObject.meshSort = 1;
         this.m_FRWheelObject.meshSort = 1;
         this.m_BLWheelObject.meshSort = 1;
         this.m_BRWheelObject.meshSort = 1;
         this.m_CarType = super.m_ObjType;
         this.m_CarStyle = param1.m_ObjectProperty;
         this.m_resObj = new RResourceBox();
         var _loc2_:int = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("animate");
         this.m_AnimFrame = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc2_];
         m_AI = new RCarAI(this);
         _loc2_ = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("carproperty");
         this.m_Carproperty = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc2_];
         this.m_RollFric = this.m_Carproperty.m_CarProperty[this.m_CarStyle].rollfric;
         this.m_DragFric = this.m_Carproperty.m_CarProperty[this.m_CarStyle].dragfric;
         this.m_MinVel = this.m_Carproperty.m_CarProperty[this.m_CarStyle].minvel;
         this.m_MaxHandle = this.m_Carproperty.m_CarProperty[this.m_CarStyle].maxhandle;
         this.m_CentFact = this.m_Carproperty.m_CarProperty[this.m_CarStyle].centfact;
         this.m_TurnFact = this.m_Carproperty.m_CarProperty[this.m_CarStyle].turnfact;
         currState.mass = this.m_Carproperty.m_CarProperty[this.m_CarStyle].mass;
         this.m_Accel = 20;
         this.m_MaxHandle = 70;
         this.m_Steer = 10;
         this.m_RFact = 8;
         this.m_MaxVel = 300;
         this.m_FlyingVal = 3;
         this.m_msgCount = 0;
         this.m_autoState = false;
         this.m_isDelete = false;
         this.m_bBA = 1;
      }
      
      public function SetPicture(param1:BitmapFileMaterial) : void
      {
         this.m_PlayerPicture = new Plane(param1,this.PHOTO_WIDTH,this.PHOTO_HEIGHT,8,8);
      }
      
      override public function BuildGeom() : void
      {
         this.BuildHighGeom();
         this.BuildWheelGeom();
      }
      
      public function BuildAutoPilot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vertex3D = null;
         var _loc4_:Vertex3D = null;
         var _loc5_:Vertex3D = null;
         var _loc6_:NumberUV = null;
         var _loc7_:NumberUV = null;
         var _loc8_:NumberUV = null;
         _loc1_ = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("autopilot");
         this.m_autopilotResObj = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc1_];
         this.m_autopilot = new TriangleMesh3D(null,new Array(),new Array());
         _loc2_ = 0;
         while(_loc2_ < this.m_autopilotResObj.m_VtxNum)
         {
            this.m_autopilot.geometry.vertices.push(new Vertex3D(this.m_autopilotResObj.m_lFrameBuf[0][_loc2_].x,this.m_autopilotResObj.m_lFrameBuf[0][_loc2_].y,this.m_autopilotResObj.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         var _loc9_:Array = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.m_autopilotResObj.m_TriNum)
         {
            _loc3_ = this.m_autopilot.geometry.vertices[this.m_autopilotResObj.m_lTrisBuf[_loc2_].a];
            _loc4_ = this.m_autopilot.geometry.vertices[this.m_autopilotResObj.m_lTrisBuf[_loc2_].b];
            _loc5_ = this.m_autopilot.geometry.vertices[this.m_autopilotResObj.m_lTrisBuf[_loc2_].c];
            _loc6_ = this.m_autopilotResObj.m_lUvsBuf[this.m_autopilotResObj.m_lTrisBuf[_loc2_].ta];
            _loc7_ = this.m_autopilotResObj.m_lUvsBuf[this.m_autopilotResObj.m_lTrisBuf[_loc2_].tb];
            _loc8_ = this.m_autopilotResObj.m_lUvsBuf[this.m_autopilotResObj.m_lTrisBuf[_loc2_].tc];
            this.m_autopilot.geometry.faces.push(new Triangle3D(this.m_autopilot,[_loc5_,_loc4_,_loc3_],this.m_autopilotResObj.m_Material,[_loc8_,_loc7_,_loc6_]));
            _loc2_++;
         }
         this.m_autopilot.x = this.currState.loc.x;
         this.m_autopilot.y = this.currState.loc.y;
         this.m_autopilot.z = this.currState.loc.z;
         this.m_autopilot.visible = false;
      }
      
      public function BuildLowGeom() : void
      {
         var _loc2_:int = 0;
         var _loc4_:Vertex3D = null;
         var _loc5_:Vertex3D = null;
         var _loc6_:Vertex3D = null;
         var _loc7_:NumberUV = null;
         var _loc8_:NumberUV = null;
         var _loc9_:NumberUV = null;
         var _loc1_:int = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName(this.GetCarName(this.m_CarStyle,RPlayerType.LOWMODEL));
         var _loc3_:RResourceBox = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc1_];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_VtxNum)
         {
            this.m_lowRndrObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_TriNum)
         {
            _loc4_ = this.m_lowRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_lowRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_lowRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_lowRndrObject.geometry.faces.push(new Triangle3D(this.m_lowRndrObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            _loc2_++;
         }
         this.m_lowRndrObject.visible = false;
         this.m_lowRndrObject.meshSort = 1;
      }
      
      public function BuildMiddleGeom() : void
      {
         var _loc2_:int = 0;
         var _loc4_:Vertex3D = null;
         var _loc5_:Vertex3D = null;
         var _loc6_:Vertex3D = null;
         var _loc7_:NumberUV = null;
         var _loc8_:NumberUV = null;
         var _loc9_:NumberUV = null;
         var _loc1_:int = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName(this.GetCarName(this.m_CarStyle,RPlayerType.MIDDLEMODEL));
         var _loc3_:RResourceBox = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc1_];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_VtxNum)
         {
            this.m_middleRndrObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_TriNum)
         {
            _loc4_ = this.m_middleRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_middleRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_middleRndrObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_middleRndrObject.geometry.faces.push(new Triangle3D(this.m_middleRndrObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            _loc2_++;
         }
         this.m_middleRndrObject.visible = false;
         this.m_middleRndrObject.meshSort = 1;
      }
      
      public function BuildHighGeom() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vertex3D = null;
         var _loc3_:Vertex3D = null;
         var _loc4_:Vertex3D = null;
         var _loc5_:NumberUV = null;
         var _loc6_:NumberUV = null;
         var _loc7_:NumberUV = null;
         m_ResID = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName(this.GetCarName(this.m_CarStyle,RPlayerType.HIGHMODEL));
         this.m_resObj = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[this.m_ResID];
         _loc1_ = 0;
         while(_loc1_ < this.m_resObj.m_VtxNum)
         {
            this.m_highRndrObject.geometry.vertices.push(new Vertex3D(this.m_resObj.m_lFrameBuf[0][_loc1_].x,this.m_resObj.m_lFrameBuf[0][_loc1_].y,this.m_resObj.m_lFrameBuf[0][_loc1_].z));
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.m_resObj.m_TriNum)
         {
            _loc2_ = this.m_highRndrObject.geometry.vertices[this.m_resObj.m_lTrisBuf[_loc1_].a];
            _loc3_ = this.m_highRndrObject.geometry.vertices[this.m_resObj.m_lTrisBuf[_loc1_].b];
            _loc4_ = this.m_highRndrObject.geometry.vertices[this.m_resObj.m_lTrisBuf[_loc1_].c];
            _loc5_ = this.m_resObj.m_lUvsBuf[this.m_resObj.m_lTrisBuf[_loc1_].ta];
            _loc6_ = this.m_resObj.m_lUvsBuf[this.m_resObj.m_lTrisBuf[_loc1_].tb];
            _loc7_ = this.m_resObj.m_lUvsBuf[this.m_resObj.m_lTrisBuf[_loc1_].tc];
            this.m_highRndrObject.geometry.faces.push(new Triangle3D(this.m_highRndrObject,[_loc4_,_loc3_,_loc2_],this.m_resObj.m_Material,[_loc7_,_loc6_,_loc5_]));
            _loc1_++;
         }
         m_renderObject.geometry.vertices = this.m_highRndrObject.geometry.vertices;
         m_renderObject.geometry.faces = this.m_highRndrObject.geometry.faces;
      }
      
      public function BuildWheelGeom() : void
      {
         var _loc2_:int = 0;
         var _loc4_:Vertex3D = null;
         var _loc5_:Vertex3D = null;
         var _loc6_:Vertex3D = null;
         var _loc7_:NumberUV = null;
         var _loc8_:NumberUV = null;
         var _loc9_:NumberUV = null;
         var _loc1_:int = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("wheel_back");
         var _loc3_:RResourceBox = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc1_];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_VtxNum)
         {
            this.m_FLWheelObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            this.m_FRWheelObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_TriNum)
         {
            _loc4_ = this.m_FLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_FLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_FLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_FLWheelObject.geometry.faces.push(new Triangle3D(this.m_FLWheelObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            _loc4_ = this.m_FRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_FRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_FRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_FRWheelObject.geometry.faces.push(new Triangle3D(this.m_FRWheelObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            _loc2_++;
         }
         _loc1_ = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName("wheel_back");
         _loc3_ = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc1_];
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_VtxNum)
         {
            this.m_BLWheelObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            this.m_BRWheelObject.geometry.vertices.push(new Vertex3D(_loc3_.m_lFrameBuf[0][_loc2_].x,_loc3_.m_lFrameBuf[0][_loc2_].y,_loc3_.m_lFrameBuf[0][_loc2_].z));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.m_TriNum)
         {
            _loc4_ = this.m_BLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_BLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_BLWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_BLWheelObject.geometry.faces.push(new Triangle3D(this.m_BLWheelObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            _loc4_ = this.m_BRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].a];
            _loc5_ = this.m_BRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].b];
            _loc6_ = this.m_BRWheelObject.geometry.vertices[_loc3_.m_lTrisBuf[_loc2_].c];
            _loc7_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].ta];
            _loc8_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tb];
            _loc9_ = _loc3_.m_lUvsBuf[_loc3_.m_lTrisBuf[_loc2_].tc];
            this.m_BRWheelObject.geometry.faces.push(new Triangle3D(this.m_BRWheelObject,[_loc6_,_loc5_,_loc4_],_loc3_.m_Material,[_loc9_,_loc8_,_loc7_]));
            this.m_BLWheelObject.scale = RPlayerType.WheelOffset[this.m_CarStyle][2];
            this.m_BRWheelObject.scale = RPlayerType.WheelOffset[this.m_CarStyle][2];
            _loc2_++;
         }
      }
      
      override public function Animation(param1:int) : void
      {
         var _loc2_:int = 0;
         if(m_renderObject.visible)
         {
            if(param1 >= this.m_resObj.m_FrameNum)
            {
               return;
            }
            _loc2_ = 0;
            while(_loc2_ < this.m_resObj.m_VtxNum)
            {
               m_renderObject.geometry.vertices[_loc2_].x = this.m_resObj.m_lFrameBuf[param1][_loc2_].x;
               m_renderObject.geometry.vertices[_loc2_].y = this.m_resObj.m_lFrameBuf[param1][_loc2_].y;
               m_renderObject.geometry.vertices[_loc2_].z = this.m_resObj.m_lFrameBuf[param1][_loc2_].z;
               _loc2_++;
            }
         }
      }
      
      public function GetCarName(param1:int, param2:int) : String
      {
         var _loc3_:String = new String();
         switch(param2)
         {
            case RPlayerType.HIGHMODEL:
               switch(this.m_CarStyle)
               {
                  case RPlayerType.DUCK:
                     _loc3_ = "duck";
                     break;
                  case RPlayerType.ELEPHANT:
                     _loc3_ = "elephant";
                     break;
                  case RPlayerType.MAN:
                     _loc3_ = "man";
                     break;
                  case RPlayerType.WOMAN:
                     _loc3_ = "woman";
               }
               break;
            case RPlayerType.MIDDLEMODEL:
               switch(this.m_CarStyle)
               {
                  case RPlayerType.DUCK:
                     _loc3_ = "duck_middle";
                     break;
                  case RPlayerType.ELEPHANT:
                     _loc3_ = "elephant_middle";
                     break;
                  case RPlayerType.MAN:
                     _loc3_ = "man_middle";
                     break;
                  case RPlayerType.WOMAN:
                     _loc3_ = "woman_middle";
               }
               break;
            case RPlayerType.LOWMODEL:
               switch(this.m_CarStyle)
               {
                  case RPlayerType.DUCK:
                     _loc3_ = "duck_low";
                     break;
                  case RPlayerType.ELEPHANT:
                     _loc3_ = "elephant_low";
                     break;
                  case RPlayerType.MAN:
                     _loc3_ = "man_low";
                     break;
                  case RPlayerType.WOMAN:
                     _loc3_ = "woman_low";
               }
         }
         return _loc3_;
      }
      
      protected function trans(param1:Number2D, param2:Number2D, param3:Number) : Number3D
      {
         var _loc4_:Number3D = new Number3D(0,0,0);
         var _loc5_:Number = Math.sin(param3);
         var _loc6_:Number = Math.cos(param3);
         _loc4_.x = (param2.y - param1.y) * _loc5_ + (param2.x - param1.x) * _loc6_;
         _loc4_.z = (param2.y - param1.y) * _loc6_ - (param2.x - param1.x) * _loc5_;
         _loc4_.x += param1.x;
         _loc4_.z += param1.y;
         return _loc4_;
      }
      
      public function SetCarPose(param1:Object = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc2_:Vector3D = new Vector3D();
         if(param1 != null)
         {
            this.m_autoState = true;
            _loc2_.x = param1.loc.x - currState.loc.x;
            _loc2_.y = param1.loc.y - currState.loc.y;
            _loc2_.z = param1.loc.z - currState.loc.z;
            currState.loc.x = param1.loc.x;
            currState.loc.y = param1.loc.y;
            currState.loc.z = param1.loc.z;
            currState.pose.x = param1.pose.x;
            currState.pose.y = param1.pose.y;
            currState.pose.z = param1.pose.z;
            currState.vel.x = param1.vel.x;
            currState.vel.y = param1.vel.y;
            currState.vel.z = param1.vel.z;
            m_DestPath = param1.destPath;
            currState.actionState = param1.actionState;
            currState.animState = param1.animState;
            return;
         }
         var _loc4_:Number = this.currState.pose.y / 180 * Math.PI;
         var _loc5_:Number = this.currState.loc.y;
         this.currState.loc.x += this.currState.vel.x;
         this.currState.loc.z += this.currState.vel.z;
         currState.loc.y += currState.vel.y;
         var _loc6_:Number = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(currState.loc.x,currState.loc.z);
         if(currState.loc.y <= _loc6_)
         {
            currState.loc.y = _loc6_;
            this.m_bFlying = false;
         }
         else
         {
            this.m_bFlying = true;
            currState.vel.y -= 5 * this.m_FlyingVal;
         }
         _loc3_ = this.currState.pose.y * Math.PI / 180;
         var _loc7_:Object = RockRacer.GameCommon.GameClient.m_Terrain.GetTerrainInfo(currState.loc.x,currState.loc.z);
         var _loc8_:Number = Math.cos(_loc3_);
         var _loc9_:Number = Math.sin(_loc3_);
         var _loc10_:Number3D = new Number3D(0,0,0);
         if(_loc7_)
         {
            _loc10_.x = _loc7_.A * _loc8_ - _loc7_.C * _loc9_;
            _loc10_.y = _loc7_.A * _loc9_ + _loc7_.C * _loc8_;
            _loc10_.z = _loc7_.B;
            _loc11_ = new Number();
            _loc12_ = new Number();
            _loc12_ = -Math.atan(_loc10_.x / _loc10_.z);
            _loc11_ = Math.atan(_loc10_.y / _loc10_.z);
            this.m_roll = _loc12_;
            this.m_pitch = _loc11_;
            this.SetRenderObjectPose(_loc12_ * 180 / Math.PI,this.currState.pose.y,_loc11_ * 180 / Math.PI);
            if(!RockRacer.GameCommon.g_SingleGame)
            {
               this.m_PlayerPicture.x = this.currState.loc.x;
               this.m_PlayerPicture.y = this.currState.loc.y + this.PHOTO_Y;
               this.m_PlayerPicture.z = this.currState.loc.z;
               this.m_PlayerPicture.rotationY = this.currState.pose.y;
               this.m_photoFrame1.x = this.currState.loc.x;
               this.m_photoFrame1.y = this.currState.loc.y + this.PHOTO_Y;
               this.m_photoFrame1.z = this.currState.loc.z;
               this.m_photoFrame1.rotationY = this.currState.pose.y;
               this.m_photoFrame2.x = this.currState.loc.x;
               this.m_photoFrame2.y = this.currState.loc.y + this.PHOTO_Y;
               this.m_photoFrame2.z = this.currState.loc.z;
               this.m_photoFrame2.rotationY = this.currState.pose.y;
               this.m_photoFrame3.x = this.currState.loc.x;
               this.m_photoFrame3.y = this.currState.loc.y + this.PHOTO_Y;
               this.m_photoFrame3.z = this.currState.loc.z;
               this.m_photoFrame3.rotationY = this.currState.pose.y;
               this.m_photoFrame4.x = this.currState.loc.x;
               this.m_photoFrame4.y = this.currState.loc.y + this.PHOTO_Y;
               this.m_photoFrame4.z = this.currState.loc.z;
               this.m_photoFrame4.rotationY = this.currState.pose.y;
            }
            this.SetRenderObjectLoc();
         }
         if(isNaN(m_renderObject.transform.n13) || isNaN(m_renderObject.transform.n23) || isNaN(m_renderObject.transform.n33))
         {
            m_renderObject.transform.n13 = 0;
            m_renderObject.transform.n23 = 0;
            m_renderObject.transform.n33 = 0;
         }
      }
      
      protected function SetRenderObjectLoc() : void
      {
         m_renderObject.x = this.currState.loc.x;
         m_renderObject.y = this.currState.loc.y;
         m_renderObject.z = this.currState.loc.z;
         this.m_FLWheelLoc.x = -RPlayerType.WheelOffset[this.m_CarStyle][0].x;
         this.m_FLWheelLoc.y = RPlayerType.WheelOffset[this.m_CarStyle][0].y;
         this.m_FLWheelLoc.z = RPlayerType.WheelOffset[this.m_CarStyle][0].z;
         this.m_FRWheelLoc.x = RPlayerType.WheelOffset[this.m_CarStyle][0].x;
         this.m_FRWheelLoc.y = RPlayerType.WheelOffset[this.m_CarStyle][0].y;
         this.m_FRWheelLoc.z = RPlayerType.WheelOffset[this.m_CarStyle][0].z;
         this.m_BLWheelLoc.x = -RPlayerType.WheelOffset[this.m_CarStyle][1].x;
         this.m_BLWheelLoc.y = RPlayerType.WheelOffset[this.m_CarStyle][1].y;
         this.m_BLWheelLoc.z = RPlayerType.WheelOffset[this.m_CarStyle][1].z;
         this.m_BRWheelLoc.x = RPlayerType.WheelOffset[this.m_CarStyle][1].x;
         this.m_BRWheelLoc.y = RPlayerType.WheelOffset[this.m_CarStyle][1].y;
         this.m_BRWheelLoc.z = RPlayerType.WheelOffset[this.m_CarStyle][1].z;
         Matrix3D.multiplyVector(m_renderObject.transform,this.m_FLWheelLoc);
         Matrix3D.multiplyVector(m_renderObject.transform,this.m_FRWheelLoc);
         Matrix3D.multiplyVector(m_renderObject.transform,this.m_BLWheelLoc);
         Matrix3D.multiplyVector(m_renderObject.transform,this.m_BRWheelLoc);
         this.m_FLWheelObject.x = this.m_FLWheelLoc.x;
         this.m_FLWheelObject.y = this.m_FLWheelLoc.y;
         this.m_FLWheelObject.z = this.m_FLWheelLoc.z;
         this.m_FRWheelObject.x = this.m_FRWheelLoc.x;
         this.m_FRWheelObject.y = this.m_FRWheelLoc.y;
         this.m_FRWheelObject.z = this.m_FRWheelLoc.z;
         this.m_BRWheelObject.x = this.m_BRWheelLoc.x;
         this.m_BRWheelObject.y = this.m_BRWheelLoc.y;
         this.m_BRWheelObject.z = this.m_BRWheelLoc.z;
         this.m_BLWheelObject.x = this.m_BLWheelLoc.x;
         this.m_BLWheelObject.y = this.m_BLWheelLoc.y;
         this.m_BLWheelObject.z = this.m_BLWheelLoc.z;
         this.m_autopilot.x = m_renderObject.x;
         this.m_autopilot.y = m_renderObject.y;
         this.m_autopilot.z = m_renderObject.z;
      }
      
      protected function SetRenderObjectPose(param1:Number, param2:Number, param3:Number) : void
      {
         m_renderObject.rotationY = param2;
         m_renderObject.pitch(param3);
         m_renderObject.roll(param1);
         this.currState.pose.x = param1;
         this.currState.pose.z = param3;
         this.m_FLWheelObject.rotationY = param2 + this.m_Handle * 0.7;
         this.m_FRWheelObject.rotationY = param2 + this.m_Handle * 0.7;
         this.m_BRWheelObject.rotationY = param2;
         this.m_BLWheelObject.rotationY = param2;
         this.m_FLWheelObject.pitch(param3);
         this.m_FRWheelObject.pitch(param3);
         this.m_BRWheelObject.pitch(param3);
         this.m_BLWheelObject.pitch(param3);
         this.m_FLWheelObject.roll(param1);
         this.m_FRWheelObject.roll(param1);
         this.m_BRWheelObject.roll(param1);
         this.m_BLWheelObject.roll(param1);
         this.wheel_roll_angle += 1.5 * currState.vel.length;
         this.wheel_roll_angle %= 360;
         this.m_FLWheelObject.pitch(this.wheel_roll_angle);
         this.m_FRWheelObject.pitch(this.wheel_roll_angle);
         this.m_BLWheelObject.pitch(this.wheel_roll_angle);
         this.m_BRWheelObject.pitch(this.wheel_roll_angle);
      }
      
      public function Idle() : void
      {
         this.m_bHandleMark = 0;
      }
      
      public function TurnLeft() : void
      {
         var _loc1_:SoundTransform = null;
         this.m_bHandleMark &= ~TURNRIGHT;
         this.m_bHandleMark |= TURNLEFT;
         if(this.m_Handle > -this.m_MaxHandle)
         {
            this.m_Handle -= this.m_Steer;
         }
         if(RockRacer.GameCommon.m_SoundOnOff)
         {
            if(this.m_ObjType == RObjectType.PLAYERCAR)
            {
               _loc1_ = new SoundTransform(currState.vel.length * this.m_Handle / (this.m_MaxHandle * this.m_MaxVel * 10));
               this.m_Sound = RSoundMgr.GetSound("brake");
               this.m_CarSndChannel = this.m_Sound.play(0,0,_loc1_);
            }
         }
      }
      
      public function TurnRight() : void
      {
         var _loc1_:SoundTransform = null;
         this.m_bHandleMark &= ~TURNLEFT;
         this.m_bHandleMark |= TURNRIGHT;
         if(this.m_Handle < this.m_MaxHandle)
         {
            this.m_Handle += this.m_Steer;
         }
         if(RockRacer.GameCommon.m_SoundOnOff)
         {
            if(this.m_ObjType == RObjectType.PLAYERCAR)
            {
               _loc1_ = new SoundTransform(currState.vel.length * this.m_Handle / (this.m_MaxHandle * this.m_MaxVel * 10));
               this.m_Sound = RSoundMgr.GetSound("brake");
               this.m_CarSndChannel = this.m_Sound.play(0,0,_loc1_);
            }
         }
      }
      
      public function ReturnCenter() : void
      {
         this.m_bHandleMark &= ~(TURNLEFT | TURNRIGHT);
      }
      
      public function SpeedUp() : void
      {
         if(this.m_maskTime != 5)
         {
            return;
         }
         this.m_bHandleMark &= ~BACKWARD;
         this.m_bHandleMark |= FORWARD;
         this.m_bBA = 1;
         this.m_bAccel = 1;
      }
      
      public function SpeedDown() : void
      {
         this.m_bHandleMark &= ~FORWARD;
         this.m_bHandleMark |= BACKWARD;
         this.m_bBA = 0;
         this.m_bAccel = -1;
      }
      
      public function StopAccel() : void
      {
         this.m_bHandleMark &= ~(FORWARD | BACKWARD);
         this.m_bAccel = 0;
      }
      
      public function VelocityControl() : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc10_:Number = NaN;
         var _loc1_:Vector3D = m_Direction.clone();
         this.m_AIAcc = 0;
         if(this.m_bAccel == 1)
         {
            _loc1_.scaleBy(this.m_Accel + this.m_BonusAcc + this.m_AIAcc);
         }
         else if(this.m_bAccel == -1)
         {
            _loc1_.scaleBy(-this.m_Accel * 0.5);
         }
         else if(this.m_BoosterAcc == 0)
         {
            _loc1_.scaleBy(0);
         }
         if(this.m_BoosterAcc > 0)
         {
            _loc10_ = _loc1_.length;
            _loc1_.normalize();
            _loc1_.scaleBy(_loc10_ + this.m_BoosterAcc);
         }
         if(this.m_bFlying)
         {
            _loc1_.scaleBy(0);
         }
         _loc2_ = _loc1_.add(currState.vel);
         _loc3_ = m_Direction.clone();
         var _loc5_:Number = _loc2_.dotProduct(m_Direction);
         _loc3_.scaleBy(_loc5_);
         _loc4_ = _loc2_.subtract(_loc3_);
         if(!this.m_bFlying)
         {
            _loc3_.scaleBy(1 - this.m_RollFric);
            _loc4_.scaleBy((1 - this.m_DragFric) * this.m_CentFact);
         }
         currState.vel = _loc3_.add(_loc4_);
         var _loc6_:Number = new Number(currState.vel.length);
         var _loc7_:Number = new Number(this.m_BonusAcc * 20);
         var _loc8_:Number = new Number(this.m_AIAcc * 20);
         var _loc9_:Number = new Number(this.m_BoosterAcc * 20);
         if(this.AccelLoadTime)
         {
            _loc6_ += this.m_BonusVel;
            _loc7_ = this.m_BonusVel;
         }
         currState.vel.normalize();
         if(_loc6_ > this.m_MaxVel + _loc7_ + _loc8_ + _loc9_)
         {
            currState.vel.scaleBy(this.m_MaxVel + _loc7_ + _loc8_ + _loc9_);
         }
         else
         {
            currState.vel.scaleBy(_loc6_);
         }
         if(currState.vel.length < this.m_MinVel)
         {
            currState.vel.x = 0;
            currState.vel.z = 0;
         }
      }
      
      override public function Tick() : void
      {
         var _loc2_:Number = NaN;
         var _loc5_:REffectData = null;
         var _loc7_:SoundTransform = null;
         var _loc8_:SoundTransform = null;
         if(RockRacer.GameCommon.GameClient.m_RenderMode != RGameClient.RENDER_READY)
         {
            m_AI.OnRefresh();
         }
         var _loc1_:int = this.m_maskTime;
         if(this.m_maskTime < 5)
         {
            ++this.m_maskTime;
         }
         if(this.m_maskTime == 5 && _loc1_ == 4)
         {
            if(this.m_ObjType == RObjectType.PLAYERCAR)
            {
               RockRacer.GameCommon.GameClient.m_scMask.gotoAndPlay(2);
            }
         }
         if(this.isCarStop)
         {
            if(this.delta_y > 10)
            {
               currState.loc.y -= 10;
               this.delta_y -= 10;
               RockRacer.GameCommon.GameClient.m_CameraMode = RGameClient.FALLING;
            }
            else
            {
               this.delta_y = 0;
               this.isCarStop = false;
               hit = true;
               RockRacer.GameCommon.GameClient.m_scMask.gotoAndPlay(41);
               RockRacer.GameCommon.GameClient.m_CameraMode = RGameClient.GO;
            }
            this.StopAccel();
            currState.vel.scaleBy(0);
            this.m_Handle = 0;
            this.ReleaseAction();
         }
         if(currState.vel.length > this.m_MaxVel)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = currState.vel.length / this.m_MaxVel;
         }
         _loc2_ = Math.pow(_loc2_,0.5);
         if(Math.abs(this.m_Handle) < this.m_RFact / 2 + 0.1)
         {
            this.m_Handle = 0;
         }
         else if(this.m_Handle > 0)
         {
            this.m_Handle -= this.m_RFact * _loc2_;
         }
         else
         {
            this.m_Handle += this.m_RFact * _loc2_;
         }
         var _loc3_:Number = Vector3D.angleBetween(currState.vel,m_Direction);
         if(isNaN(_loc3_))
         {
            _loc3_ = 0;
         }
         if(_loc3_ < Math.PI / 2)
         {
            this.m_isForward = 1;
            currState.pose.y += this.m_Handle * _loc2_ * this.m_TurnFact;
         }
         else if(_loc3_ >= Math.PI / 2)
         {
            this.m_isForward = -1;
            currState.pose.y -= this.m_Handle * _loc2_ * this.m_TurnFact;
         }
         if(currState.vel.lengthSquared == 0)
         {
            this.m_isForward = 0;
         }
         this.SetCarPose();
         var _loc4_:RResourcePath = RockRacer.GameCommon.GameClient.m_Terrain.m_path;
         if(this.m_BonusID != RObjectType.NONE_BONUS)
         {
            --this.m_UseBonusTime;
            if(RockRacer.GameCommon.g_SingleGame == true)
            {
               if(this.m_UseBonusTime == 0)
               {
                  this.UseBonus();
               }
            }
         }
         this.UpdateAction();
         if(this.currState.actionState != RActionState.BEATEN)
         {
            m_Direction.x = m_renderObject.transform.n13;
            m_Direction.y = m_renderObject.transform.n23;
            m_Direction.z = m_renderObject.transform.n33;
            m_Direction.normalize();
         }
         this.VelocityControl();
         if(this.m_ObjType == RObjectType.PLAYERCAR)
         {
            this.PlayEngineSound();
         }
         this.FrameControl();
         this.currState.bSphere.m_loc.x = this.currState.loc.x;
         this.currState.bSphere.m_loc.y = this.currState.loc.y;
         this.currState.bSphere.m_loc.z = this.currState.loc.z;
         this.m_TerrainType = RockRacer.GameCommon.GameClient.m_Terrain.GetTerrainType(currState.loc.x,currState.loc.z);
         var _loc6_:Object = RTerrainType.GetFriction(this.m_TerrainType);
         this.m_RollFric = _loc6_.f1;
         this.m_DragFric = _loc6_.f2;
         currState.terrainType = this.m_TerrainType;
         switch(this.m_TerrainType)
         {
            case RTerrainType.START_LINE:
               this.UpdateLap();
               break;
            case RTerrainType.MUD_ROAD:
               if(currState.vel.lengthSquared > 900 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.MUD_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.MOUNT:
               if(currState.vel.lengthSquared > 900 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.MOUNT_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.ASPHALT_ROAD:
               break;
            case RTerrainType.SAND_ROAD:
               if(currState.vel.lengthSquared > 900 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.DUST_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.OIL_ROAD:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     _loc7_ = new SoundTransform(currState.vel.length / this.m_MaxVel);
                     this.m_Sound = RSoundMgr.GetSound("oil");
                     this.m_TerrainSndChannel = this.m_Sound.play(0,0,_loc7_);
                  }
               }
               if(currState.vel.lengthSquared > 900 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.MUD_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.GRASS:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     _loc8_ = new SoundTransform(currState.vel.length / this.m_MaxVel);
                     this.m_Sound = RSoundMgr.GetSound("grass");
                     this.m_TerrainSndChannel = this.m_Sound.play(0,0,_loc8_);
                  }
               }
               if(currState.vel.lengthSquared > 100 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.GRASS_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.WATER:
               if(currState.vel.lengthSquared > 900 && currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  (_loc5_ = new REffectData(RSpecialEffectType.WATER_BLOW_EFFECT,this.currState,null)).m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc5_);
               }
               break;
            case RTerrainType.OUT:
               this.ReturnToTrack();
               break;
            case -1:
               this.ReturnToTrack();
               break;
            case RTerrainType.ACCELENT_ROAD:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR && !this.isCarStop)
                  {
                     this.m_Sound = RSoundMgr.GetSound("accelboard");
                     this.m_TerrainSndChannel = this.m_Sound.play();
                  }
               }
               this.m_BonusVel = 160;
               this.AccelLoadTime = 20;
               break;
            default:
               this.ReturnToTrack();
         }
         if(this.AccelLoadTime > 0)
         {
            --this.AccelLoadTime;
            this.m_BonusVel -= 160 / 20;
         }
         if(this.AccelLoadTime == 0)
         {
            this.m_BonusVel = 0;
         }
         if(this.m_ObjType == RObjectType.PLAYERCAR)
         {
            preState.terrainType = this.m_TerrainType;
         }
         this.SetRank();
         this.CheckUpdatePath();
         super.Tick();
      }
      
      private function CheckUpdatePath() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         if(m_ObjType == RObjectType.PLAYERCAR)
         {
            _loc1_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lCurveInfo;
            if(prev_path != m_DestPath && this.m_bGuideDir)
            {
               RockRacer.GameCommon.GameClient.mc_GuideWnd.onEnd();
               this.m_bGuideDir = false;
            }
            if(prev_path != m_DestPath && this.m_bInfo)
            {
            }
            if(prev_path < m_DestPath)
            {
               _loc2_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
               _loc3_ = RockRacer.GameCommon.CommonRsrMgr.m_Infofile.m_InfoDic;
               this.m_bGuideDir = false;
               this.m_bGuideWrong = false;
               switch(_loc1_[m_DestPath - 1])
               {
                  case 0:
                     switch(m_DestPath)
                     {
                        case 5:
                        case 29:
                        case 36:
                        case 54:
                           RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(2,RockRacer.GameCommon.GetTextFunc("$TURN_FORWARD"));
                           this.m_bGuideDir = true;
                     }
                     break;
                  case 1:
                     RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(1,RockRacer.GameCommon.GetTextFunc("$TURN_RIGHT"));
                     this.m_bGuideDir = true;
                     break;
                  case 2:
                     RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(0,RockRacer.GameCommon.GetTextFunc("$TURN_LEFT"));
                     this.m_bGuideDir = true;
               }
            }
            else if(this.m_bGuideDir && this.m_bWrongway && !this.m_bGuideWrong)
            {
               this.m_Sound = RSoundMgr.GetSound("whistle");
               this.m_EffectSndChannel = this.m_Sound.play();
               RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(3,RockRacer.GameCommon.GetTextFunc("$TURN_WARRING"));
               this.m_bGuideWrong = true;
            }
            else if(this.m_bGuideDir && !this.m_bWrongway && this.m_bGuideWrong)
            {
               switch(_loc1_[m_DestPath - 1])
               {
                  case 0:
                     switch(m_DestPath)
                     {
                        case 5:
                        case 29:
                        case 36:
                        case 54:
                           RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(2,RockRacer.GameCommon.GetTextFunc("$TURN_FORWARD"));
                     }
                     break;
                  case 1:
                     RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(1,RockRacer.GameCommon.GetTextFunc("$TURN_RIGHT"));
                     break;
                  case 2:
                     RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(0,RockRacer.GameCommon.GetTextFunc("$TURN_LEFT"));
               }
            }
            prev_path = m_DestPath;
         }
      }
      
      public function UpdateLap() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this.m_passPath && this.m_Lap < LASTLAP)
         {
            if(RockRacer.GameCommon.m_SoundOnOff)
            {
               if(this.m_ObjType == RObjectType.PLAYERCAR)
               {
                  this.m_Sound = RSoundMgr.GetSound("passlap");
                  this.m_TerrainSndChannel = this.m_Sound.play();
               }
            }
            if(!(RockRacer.GameCommon.g_SingleGame == true || this is RPlayerCar))
            {
               return;
            }
            ++this.m_Lap;
            if(RockRacer.GameCommon.g_SingleGame == false && this is RPlayerCar)
            {
               Client.setLap([this.m_Lap]);
            }
            m_DestPath = 1;
            this.m_LapTimes.push(getTimer());
            this.m_passPath = false;
            if(this.m_Lap >= LASTLAP)
            {
               m_AI.SetAIState(RAI.AI_IDLE);
               this.StopAccel();
               RockRacer.GameCommon.GetScoreFunc(this);
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  this.m_Rank = RockRacer.GameCommon.m_LastRank;
                  if(RockRacer.GameCommon.g_SingleGame)
                  {
                     RockRacer.GameCommon.GameClient.m_LapView.setPlayerLab(this.m_Lap + 1);
                  }
                  RockRacer.GameCommon.GameClient.m_RenderMode = RGameClient.RENDER_SCORE;
                  if(!RockRacer.GameCommon.g_SingleGame)
                  {
                     _loc1_ = new Date(this.m_LapTimes[this.m_Lap] - this.m_LapTimes[0]);
                     _loc3_ = 0;
                     while(_loc3_ < RLoadingCourse.m_multiUsers.length)
                     {
                        if(RLoadingCourse.m_multiUsers[_loc3_].uid == Client.myUserId)
                        {
                           _loc2_ = RLoadingCourse.m_multiUsers[_loc3_];
                        }
                        _loc3_++;
                     }
                     Client.sendState([RGameClient.MsgNum(currState.loc.x),RGameClient.MsgNum(currState.loc.y),RGameClient.MsgNum(currState.loc.z),RGameClient.MsgNum(currState.pose.x),RGameClient.MsgNum(currState.pose.y),RGameClient.MsgNum(currState.pose.z),currState.actionState,currState.animState,0,this.m_msgCount++,RGameClient.MsgNum(currState.vel.x),RGameClient.MsgNum(currState.vel.y),RGameClient.MsgNum(currState.vel.z),this.m_bBA,m_DestPath]);
                     RGameClient.m_sendTime = getTimer();
                     Client.gameOver([_loc1_.minutes,_loc1_.seconds,_loc1_.milliseconds,_loc2_.picsquare,_loc2_.firstname]);
                  }
               }
            }
            else if(m_ObjType == RObjectType.PLAYERCAR)
            {
               RockRacer.GameCommon.GameClient.m_LapView.setPlayerLab(this.m_Lap + 1);
            }
         }
      }
      
      public function SetAction(param1:int) : void
      {
         var _loc2_:REffectData = null;
         switch(param1)
         {
            case RActionState.AUTOPILOT_PLAY:
               if(currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("autopilot");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               this.ReleaseAction();
               currState.actionState = param1;
               this.m_BonusAcc = 15;
               this.ActionTime = 75;
               m_AI.SetAIState(RAI.AI_FOLLOWPATH);
               this.VisibleWheel(false);
               m_renderObject.geometry.vertices = this.m_autopilot.geometry.vertices;
               m_renderObject.geometry.faces = this.m_autopilot.geometry.faces;
               break;
            case RActionState.BOOSTER_USE:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("booster");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               this.ReleaseAction();
               currState.actionState = param1;
               this.m_BoosterAcc = this.m_Accel;
               this.ActionTime = 60;
               break;
            case RActionState.SHIELD_USE:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("shield1");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               this.ReleaseAction();
               currState.actionState = param1;
               this.m_BonusAcc = this.m_Accel * 0.5;
               this.ActionTime = 40;
               break;
            case RActionState.MUD_USE:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               this.ReleaseAction();
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  if(RockRacer.GameCommon.m_SoundOnOff)
                  {
                     this.m_Sound = RSoundMgr.GetSound("fire_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
                  RockRacer.GameCommon.GameClient.m_mudman.visible = true;
                  RockRacer.GameCommon.GameClient.m_mudman.gotoAndPlay(2);
               }
               currState.actionState = param1;
               this.ActionTime = 20;
               break;
            case RActionState.MUD_BEATEN:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.MUD_BEATEN || currState.actionState == RActionState.SHIELD_USE)
               {
                  break;
               }
               if(currState.actionState == RActionState.BOOSTER_USE)
               {
                  if(m_ObjType == RObjectType.PLAYERCAR && RockRacer.GameCommon.GameClient.Squirrel.visible == false)
                  {
                     if(RockRacer.GameCommon.m_SoundOnOff)
                     {
                        this.m_Sound = RSoundMgr.GetSound("mud_beaten");
                        this.m_EffectSndChannel = this.m_Sound.play();
                     }
                     RockRacer.GameCommon.GameClient.Squirrel.alpha = 1;
                     RockRacer.GameCommon.GameClient.Squirrel.visible = true;
                     RockRacer.GameCommon.GameClient.Squirrel.gotoAndPlay(77);
                  }
               }
               else
               {
                  if(currState.actionState == RActionState.FAKE_BEATEN || currState.actionState == RActionState.CAKE_BEATEN || currState.actionState == RActionState.JELLY_BEATEN || currState.actionState == RActionState.BEATEN)
                  {
                     this.BeatenProccess();
                  }
                  this.ReleaseAction();
                  if(m_ObjType == RObjectType.PLAYERCAR)
                  {
                     RockRacer.GameCommon.GameClient.Squirrel.alpha = 1;
                     RockRacer.GameCommon.GameClient.Squirrel.visible = true;
                     RockRacer.GameCommon.GameClient.Squirrel.gotoAndPlay(2);
                     this.m_BonusAcc = -this.m_Accel * 0.2;
                  }
                  else
                  {
                     this.m_BonusAcc = -this.m_Accel * 0.4;
                     if(RockRacer.GameCommon.g_SingleGame)
                     {
                        m_AI.SetAIState(RAI.AI_FLUSTRATE);
                     }
                  }
                  this.ActionTime = 67;
                  currState.actionState = param1;
               }
               break;
            case RActionState.LIGHT_USE:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               this.ReleaseAction();
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  if(RockRacer.GameCommon.m_SoundOnOff)
                  {
                     this.m_Sound = RSoundMgr.GetSound("fire_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
                  RockRacer.GameCommon.GameClient.m_lightman.visible = true;
                  RockRacer.GameCommon.GameClient.m_lightman.gotoAndPlay(2);
               }
               currState.actionState = param1;
               this.ActionTime = 20;
               break;
            case RActionState.LIGHT_BEATEN:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.SHIELD_USE || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               if(currState.actionState != RActionState.BEATEN)
               {
                  this.ReleaseAction();
               }
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("light_beaten");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               _loc2_ = new REffectData(RSpecialEffectType.LIGHTING_EFFECT,currState,null);
               _loc2_.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc2_);
            case RActionState.CAKE_BEATEN:
            case RActionState.FAKE_BEATEN:
            case RActionState.JELLY_BEATEN:
            case RActionState.BEATEN:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.SHIELD_USE || currState.actionState == RActionState.BEATEN)
               {
                  break;
               }
               if(currState.actionState != RActionState.BEATEN)
               {
                  this.ReleaseAction();
                  currState.actionState = RActionState.BEATEN;
                  this.ActionTime = 30;
               }
               break;
            case RActionState.COLLISION_CAR:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.SHIELD_USE)
               {
                  break;
               }
               this.SetAnimState(RPlayerAnimState.CarIsCollisionCar);
               break;
            case RActionState.COLLISION_WALL:
               if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.SHIELD_USE)
               {
                  break;
               }
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("collision_wall");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               RockRacer.GameCommon.GameClient.mc_GuideWnd.onStart(4,"");
               break;
         }
      }
      
      protected function BeatenProccess() : void
      {
         currState.vel.scaleBy(0);
         var _loc1_:Vector3D = new Vector3D();
         var _loc2_:int = m_DestPath - 1;
         if(_loc2_ < 0)
         {
            _loc2_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath.length - 2;
         }
         _loc1_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[m_DestPath].subtract(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc2_]);
         var _loc3_:Number = Math.atan(_loc1_.x / _loc1_.z);
         _loc3_ = _loc3_ * 180 / Math.PI;
         if(_loc1_.z < 0)
         {
            _loc3_ += 180;
         }
         if(_loc3_ < 0)
         {
            _loc3_ += 360;
         }
         this.currState.pose.y = _loc3_;
      }
      
      public function UpdateAction() : void
      {
         var effectdata:REffectData = null;
         var dir:Vector3D = null;
         var prev:int = 0;
         var angle:Number = NaN;
         if(this.ActionTime == 0)
         {
            this.m_isAutoPilot = false;
            this.ReleaseAction();
            return;
         }
         switch(currState.actionState)
         {
            case RActionState.AUTOPILOT_PLAY:
               effectdata = new REffectData(RSpecialEffectType.AUTOPILOT_EFFECT,currState,null);
               effectdata.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(effectdata);
               break;
            case RActionState.BOOSTER_USE:
               effectdata = new REffectData(RSpecialEffectType.BOOST_EFFECT,currState,null);
               effectdata.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(effectdata);
               break;
            case RActionState.SHIELD_USE:
               if(this.ActionTime % 10 == 0)
               {
                  effectdata = new REffectData(RSpecialEffectType.SHIELD_EFFECT,currState,null);
                  effectdata.m_car = this;
                  RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(effectdata);
               }
               break;
            case RActionState.MUD_BEATEN:
               break;
            case RActionState.LIGHT_BEATEN:
            case RActionState.CAKE_BEATEN:
            case RActionState.FAKE_BEATEN:
            case RActionState.JELLY_BEATEN:
            case RActionState.BEATEN:
               this.StopAccel();
               this.AccelLoadTime = 0;
               this.m_BonusVel = 0;
               if(this.ActionTime > 10)
               {
                  currState.vel.scaleBy(0.8);
                  currState.pose.y += 36;
                  this.SetAnimState(RPlayerAnimState.CarIsDizzy);
               }
               else
               {
                  currState.vel.scaleBy(0);
                  dir = new Vector3D();
                  prev = m_DestPath - 1;
                  if(prev < 0)
                  {
                     prev = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath.length - 2;
                  }
                  dir = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[m_DestPath].subtract(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev]);
                  angle = Math.atan(dir.x / dir.z);
                  angle = angle * 180 / Math.PI;
                  if(dir.z < 0)
                  {
                     angle += 180;
                  }
                  if(angle < 0)
                  {
                     angle += 360;
                  }
                  this.currState.pose.y = angle;
               }
               break;
            case RActionState.COLLISION_CAR:
               break;
            case RActionState.COLLISION_WALL:
         }
         if(m_ObjType == RObjectType.PLAYERCAR)
         {
            with(RockRacer.GameCommon.GameClient.Squirrel)
            {
               
               if((currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BOOSTER_USE || currState.actionState == RActionState.SHIELD_USE) && visible)
               {
                  alpha -= 0.05;
                  if(alpha <= 0)
                  {
                     visible = false;
                     alpha = 1;
                  }
               }
            }
         }
         --this.ActionTime;
      }
      
      public function ReleaseAction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(m_ObjType == RObjectType.AICAR)
         {
            if(!RockRacer.GameCommon.g_SingleGame)
            {
               m_AI.SetAIState(RAI.AI_IDLE);
            }
         }
         else if(m_ObjType == RObjectType.PLAYERCAR)
         {
            m_AI.SetAIState(RAI.AI_IDLE);
         }
         switch(currState.actionState)
         {
            case RActionState.NONE:
               return;
            case RActionState.AUTOPILOT_PLAY:
               if(m_ObjType == RObjectType.AICAR)
               {
                  if(RockRacer.GameCommon.g_SingleGame)
                  {
                     m_AI.SetAIState(RAI.AI_FOLLOWPATH);
                  }
                  else
                  {
                     m_AI.SetAIState(RAI.AI_IDLE);
                  }
               }
               else if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  m_AI.SetAIState(RAI.AI_IDLE);
               }
               this.VisibleWheel(true);
               m_renderObject.geometry.vertices = this.m_highRndrObject.geometry.vertices;
               m_renderObject.geometry.faces = this.m_highRndrObject.geometry.faces;
               break;
            case RActionState.LIGHT_USE:
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  RockRacer.GameCommon.GameClient.m_lightman.visible = false;
                  RockRacer.GameCommon.GameClient.m_lightman.stop();
               }
               if(RockRacer.GameCommon.g_SingleGame)
               {
                  _loc2_ = RGameClient.CARCOUNT;
               }
               else
               {
                  _loc2_ = RGameClient.userTotal;
               }
               if(this.ActionTime <= 0)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc2_)
                  {
                     if(this.m_Rank > RockRacer.GameCommon.GameClient.m_CarList[_loc1_].m_Rank)
                     {
                        RockRacer.GameCommon.GameClient.m_CarList[_loc1_].SetAction(RActionState.LIGHT_BEATEN);
                     }
                     _loc1_++;
                  }
               }
               break;
            case RActionState.MUD_USE:
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  RockRacer.GameCommon.GameClient.m_mudman.visible = false;
                  RockRacer.GameCommon.GameClient.m_mudman.stop();
               }
               if(RockRacer.GameCommon.g_SingleGame)
               {
                  _loc2_ = RGameClient.CARCOUNT;
               }
               else
               {
                  _loc2_ = RGameClient.userTotal;
               }
               if(this.ActionTime <= 0)
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc2_)
                  {
                     if(m_ObjID != RockRacer.GameCommon.GameClient.m_CarList[_loc1_].m_ObjID)
                     {
                        RockRacer.GameCommon.GameClient.m_CarList[_loc1_].SetAction(RActionState.MUD_BEATEN);
                     }
                     _loc1_++;
                  }
               }
               break;
            case RActionState.MUD_BEATEN:
               if(m_ObjType == RObjectType.PLAYERCAR)
               {
                  if(this.ActionTime <= 0)
                  {
                     RockRacer.GameCommon.GameClient.Squirrel.visible = false;
                     RockRacer.GameCommon.GameClient.Squirrel.stop();
                  }
               }
               else if(RockRacer.GameCommon.g_SingleGame)
               {
                  m_AI.SetAIState(RAI.AI_FOLLOWPATH);
               }
         }
         this.m_BoosterAcc = 0;
         this.m_BonusAcc = 0;
         this.ActionTime = 0;
         currState.actionState = RActionState.NONE;
      }
      
      public function FallCarOnTrack(param1:Event) : void
      {
         var _loc2_:Vector3D = new Vector3D();
         var _loc3_:int = m_DestPath - 1;
         if(_loc3_ < 0)
         {
            _loc3_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath.length - 2;
         }
         _loc2_ = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[m_DestPath].subtract(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc3_]);
         var _loc4_:Number = (_loc4_ = Math.atan(_loc2_.x / _loc2_.z)) * 180 / Math.PI;
         if(_loc2_.z < 0)
         {
            _loc4_ += 180;
         }
         if(_loc4_ < 0)
         {
            _loc4_ += 360;
         }
         this.currState.pose.y = _loc4_;
         this.delta_y = 21;
         RockRacer.GameCommon.GameClient.m_CameraMode = RGameClient.FALLING;
         this.SetLoc(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc3_].x,RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc3_].x,RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc3_].z) + this.delta_y,RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[_loc3_].z);
         this.isCarStop = true;
         this.isCarOut = false;
         this.m_bWrongway = false;
         if(prev_path == m_DestPath)
         {
            --prev_path;
         }
         RockRacer.GameCommon.GameClient.m_scMask.removeEventListener("DarkScreen",this.FallCarOnTrack);
         this.ReleaseAction();
         if(this.m_ObjType == RObjectType.PLAYERCAR)
         {
            RockRacer.GameCommon.GameClient.Squirrel.visible = false;
            RockRacer.GameCommon.GameClient.Squirrel.stop();
         }
         this.m_bHandleMark = 0;
         if(RockRacer.GameCommon.g_SingleGame == false && this is RPlayerCar && this.isCarStop == false && this.isCarOut == false)
         {
            Client.sendState([RGameClient.MsgNum(currState.loc.x),RGameClient.MsgNum(currState.loc.y),RGameClient.MsgNum(currState.loc.z),RGameClient.MsgNum(currState.pose.x),RGameClient.MsgNum(currState.pose.y),RGameClient.MsgNum(currState.pose.z),currState.actionState,currState.animState,RockRacer.GameCommon.GameClient.KeyMask,this.m_msgCount++,RGameClient.MsgNum(currState.vel.x),RGameClient.MsgNum(currState.vel.y),RGameClient.MsgNum(currState.vel.z),this.m_bBA,m_DestPath]);
            RGameClient.m_sendTime = getTimer();
         }
      }
      
      public function ReturnToTrack() : void
      {
         var dir:Vector3D = null;
         var prev:int = 0;
         var angle:Number = NaN;
         if(m_ObjType == RObjectType.AICAR)
         {
            return;
         }
         this.m_BonusID = RObjectType.NONE_BONUS;
         currState.vel.scaleBy(0);
         this.StopAccel();
         if(this.isCarOut)
         {
            return;
         }
         this.isCarOut = true;
         if(this.m_ObjType == RObjectType.PLAYERCAR)
         {
            hit = false;
            with(RockRacer.GameCommon.GameClient)
            {
               
               weaponView.stopSelecting();
               m_scMask.addEventListener("DarkScreen",FallCarOnTrack);
               m_scMask.gotoAndPlay(2);
               timeoutTime = -1;
            }
         }
         if(this.m_ObjType == RObjectType.AICAR)
         {
            dir = new Vector3D();
            prev = m_DestPath - 1;
            if(prev < 0)
            {
               prev = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath.length - 2;
            }
            dir = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[m_DestPath].subtract(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev]);
            angle = Math.atan(dir.x / dir.z);
            angle = angle * 180 / Math.PI;
            if(dir.z < 0)
            {
               angle += 180;
            }
            if(angle < 0)
            {
               angle += 360;
            }
            this.currState.pose.y = angle;
            this.SetLoc(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev].x,RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev].x,RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev].z) + this.delta_y,RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath[prev].z);
            this.isCarOut = false;
            if(RockRacer.GameCommon.g_SingleGame)
            {
               m_AI.SetAIState(RAI.AI_FOLLOWPATH);
            }
         }
         if(RockRacer.GameCommon.g_SingleGame == false && this is RPlayerCar && this.isCarStop == false && this.isCarOut == false)
         {
            Client.sendState([RGameClient.MsgNum(currState.loc.x),RGameClient.MsgNum(currState.loc.y),RGameClient.MsgNum(currState.loc.z),RGameClient.MsgNum(currState.pose.x),RGameClient.MsgNum(currState.pose.y),RGameClient.MsgNum(currState.pose.z),currState.actionState,currState.animState,0,this.m_msgCount++,RGameClient.MsgNum(currState.vel.x),RGameClient.MsgNum(currState.vel.y),RGameClient.MsgNum(currState.vel.z),this.m_bBA,m_DestPath]);
            RGameClient.m_sendTime = getTimer();
         }
      }
      
      public function GetCurFrame() : int
      {
         return this.currState.curFrame;
      }
      
      public function SetCurFrame(param1:int) : void
      {
         this.currState.curFrame = param1;
      }
      
      public function SetNextFrame() : void
      {
         ++this.currState.curFrame;
      }
      
      override public function SetAnimState(param1:int) : void
      {
         currState.animState = param1;
      }
      
      public function FrameControl() : void
      {
         var _loc1_:int = 0;
         if(currState.actionState == RActionState.AUTOPILOT_PLAY)
         {
            this.SetAnimState(RPlayerAnimState.CarIsIdle);
            if(currState.curFrame >= this.m_autopilotResObj.m_FrameNum)
            {
               currState.curFrame = 0;
            }
            _loc1_ = 0;
            while(_loc1_ < this.m_autopilotResObj.m_VtxNum)
            {
               m_renderObject.geometry.vertices[_loc1_].x = this.m_autopilotResObj.m_lFrameBuf[currState.curFrame][_loc1_].x;
               m_renderObject.geometry.vertices[_loc1_].y = this.m_autopilotResObj.m_lFrameBuf[currState.curFrame][_loc1_].y;
               m_renderObject.geometry.vertices[_loc1_].z = this.m_autopilotResObj.m_lFrameBuf[currState.curFrame][_loc1_].z;
               _loc1_++;
            }
            currState.curFrame += 2;
            return;
         }
         if(!(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN) && !(currState.animState == RPlayerAnimState.CarIsCollisionCar || currState.animState == RPlayerAnimState.CarIsCollisionWall))
         {
            switch(this.m_bHandleMark)
            {
               case 0:
                  this.SetAnimState(RPlayerAnimState.CarIsIdle);
                  break;
               case FORWARD:
                  this.SetAnimState(RPlayerAnimState.CarIsForward);
                  break;
               case FORWARD | TURNLEFT:
                  this.SetAnimState(RPlayerAnimState.CarIsLeftForward);
                  break;
               case FORWARD | TURNRIGHT:
                  this.SetAnimState(RPlayerAnimState.CarIsRightForward);
                  break;
               case BACKWARD:
                  if(currState.animState == RPlayerAnimState.CarIsRightBack || currState.animState == RPlayerAnimState.CarIsLeftBack)
                  {
                     this.SetAnimState(RPlayerAnimState.CarIsBack);
                     preState.animState = RPlayerAnimState.CarIsBack;
                     currState.curFrame = this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState);
                  }
                  else if(currState.animState != RPlayerAnimState.CarIsBack)
                  {
                     this.SetAnimState(RPlayerAnimState.CarIsBack);
                  }
                  break;
               case BACKWARD | TURNLEFT:
                  this.SetAnimState(RPlayerAnimState.CarIsRightBack);
                  break;
               case BACKWARD | TURNRIGHT:
                  this.SetAnimState(RPlayerAnimState.CarIsLeftBack);
                  break;
               case TURNLEFT:
                  if(Math.abs(this.m_Handle) < this.m_MaxHandle)
                  {
                     if(currState.animState == RPlayerAnimState.CarIsBack || currState.animState == RPlayerAnimState.CarIsLeftBack || currState.animState == RPlayerAnimState.CarIsRightBack)
                     {
                        this.SetAnimState(RPlayerAnimState.CarIsLeftBack);
                     }
                     else
                     {
                        this.SetAnimState(RPlayerAnimState.CarIsLeftForward);
                     }
                  }
                  break;
               case TURNRIGHT:
                  if(Math.abs(this.m_Handle) < this.m_MaxHandle)
                  {
                     if(currState.animState == RPlayerAnimState.CarIsBack || currState.animState == RPlayerAnimState.CarIsLeftBack || currState.animState == RPlayerAnimState.CarIsRightBack)
                     {
                        this.SetAnimState(RPlayerAnimState.CarIsRightBack);
                     }
                     else
                     {
                        this.SetAnimState(RPlayerAnimState.CarIsRightForward);
                     }
                  }
            }
            if(this.m_Lap >= LASTLAP)
            {
               if(this.m_Rank <= 1)
               {
                  this.SetAnimState(RPlayerAnimState.CarIsWin);
               }
               else
               {
                  this.SetAnimState(RPlayerAnimState.CarIsFail);
               }
            }
         }
         if(this.currState.animState != this.preState.animState)
         {
            this.currState.curFrame = this.m_AnimFrame.GetAnimStartFrame(this.m_CarStyle,this.currState.animState);
         }
         else
         {
            switch(this.currState.animState)
            {
               case RPlayerAnimState.CarIsIdle:
               case RPlayerAnimState.CarIsForward:
               case RPlayerAnimState.CarIsFail:
               case RPlayerAnimState.CarIsWin:
                  if(this.currState.curFrame == this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState))
                  {
                     this.currState.curFrame = this.m_AnimFrame.GetAnimStartFrame(this.m_CarStyle,this.currState.animState);
                  }
                  else
                  {
                     ++this.currState.curFrame;
                  }
                  break;
               case RPlayerAnimState.CarIsCollisionCar:
               case RPlayerAnimState.CarIsCollisionWall:
               case RPlayerAnimState.CarIsDizzy:
                  if(this.currState.curFrame == this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState))
                  {
                     this.SetAnimState(RPlayerAnimState.CarIsIdle);
                     currState.curFrame = this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState);
                  }
                  else
                  {
                     ++this.currState.curFrame;
                  }
                  break;
               case RPlayerAnimState.CarIsBack:
               case RPlayerAnimState.CarIsLeftBack:
               case RPlayerAnimState.CarIsRightForward:
               case RPlayerAnimState.CarIsLeftForward:
               case RPlayerAnimState.CarIsRightBack:
                  if(this.currState.curFrame == this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState))
                  {
                     this.currState.curFrame = this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState);
                  }
                  else
                  {
                     ++this.currState.curFrame;
                  }
                  break;
               case RPlayerAnimState.CarIsThrowGrenade:
                  if(this.currState.curFrame == this.m_AnimFrame.GetAnimEndFrame(this.m_CarStyle,this.currState.animState))
                  {
                     this.SetAnimState(RPlayerAnimState.CarIsForward);
                  }
            }
         }
         if(this.m_visiblelevel == 0)
         {
            this.Animation(this.currState.curFrame);
         }
      }
      
      public function SetAIState(param1:int) : void
      {
         if(RockRacer.GameCommon.g_SingleGame)
         {
            m_AI.SetAIState(param1);
         }
      }
      
      public function SelectBonus() : void
      {
         this.m_BonusID = RBonusType.GetBonusType(this.m_Rank - 1);
         if(RockRacer.GameCommon.m_SoundOnOff)
         {
            if(this.m_ObjType == RObjectType.PLAYERCAR)
            {
               this.m_Sound = RSoundMgr.GetSound("selectweapon");
               this.m_EffectSndChannel = this.m_Sound.play();
            }
         }
      }
      
      public function PlayHornkSound() : void
      {
         if(RockRacer.GameCommon.m_SoundOnOff)
         {
            if(this.m_BonusID == RObjectType.NONE_BONUS && currState.actionState != RActionState.AUTOPILOT_PLAY && currState.actionState != RActionState.BOOSTER_USE && currState.actionState != RActionState.BEATEN && !this.isCarStop && currState.terrainType != RTerrainType.OUT)
            {
               this.m_Sound = RSoundMgr.GetSound("honk");
               this.m_EffectSndChannel = this.m_Sound.play();
            }
         }
      }
      
      public function UseBonus(param1:Object = null) : Boolean
      {
         var _obj:ROBJECTINFO = null;
         var delta:Vector3D = null;
         var i:int = 0;
         var v_obj:Object = param1;
         if(m_ObjType == RObjectType.PLAYERCAR)
         {
            with(RockRacer.GameCommon.GameClient)
            {
               
               timeoutTime = -1;
               ViewTutorialSpaceBox(false);
            }
         }
         if(this.m_Lap >= LASTLAP)
         {
            return false;
         }
         if(RockRacer.GameCommon.g_SingleGame == false && this is RPlayerCar && v_obj == null)
         {
            if(this.m_BonusID != RObjectType.NONE_BONUS)
            {
               _obj = new ROBJECTINFO();
               switch(this.m_BonusID)
               {
                  case RObjectType.FAKE:
                  case RObjectType.JELLY:
                     delta = m_Direction.clone();
                     delta.scaleBy(currState.bSphere.m_radius + 100 - currState.vel.length);
                     _obj.m_CurrLoc = currState.loc.subtract(delta);
                     _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
                     Client.addItem([this.m_BonusID,_obj.m_CurrLoc.x,_obj.m_CurrLoc.y,_obj.m_CurrLoc.z]);
                     this.m_BonusID = RObjectType.NONE_BONUS;
                     return true;
                  case RObjectType.WHITE_CUPCAKE:
                  case RObjectType.BROWN_CUPCAKE:
                  case RObjectType.PINK_CUPCAKE:
                     delta = m_Direction.clone();
                     delta.scaleBy(currState.bSphere.m_radius + 1000);
                     _obj.m_CurrLoc = currState.loc.add(delta);
                     _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
                     Client.addItem([this.m_BonusID,_obj.m_CurrLoc.x,_obj.m_CurrLoc.y,_obj.m_CurrLoc.z]);
                     this.m_BonusID = RObjectType.NONE_BONUS;
                     return true;
                  case RObjectType.AUTOPILOT:
                     if(currState.actionState == RActionState.BEATEN)
                     {
                        return false;
                     }
                     Client.addItem([this.m_BonusID,_obj.m_CurrLoc.x,_obj.m_CurrLoc.y,_obj.m_CurrLoc.z]);
                     this.m_BonusID = RObjectType.NONE_BONUS;
                     return true;
                     break;
                  case RObjectType.BOOSTER:
                  case RObjectType.LIGHT:
                  case RObjectType.MUD_DEVIL:
                  case RObjectType.SHIELD:
                     if(currState.actionState == RActionState.AUTOPILOT_PLAY || currState.actionState == RActionState.BEATEN)
                     {
                        return false;
                     }
                     Client.addItem([this.m_BonusID,_obj.m_CurrLoc.x,_obj.m_CurrLoc.y,_obj.m_CurrLoc.z]);
                     this.m_BonusID = RObjectType.NONE_BONUS;
                     return true;
               }
            }
            return false;
         }
         switch(this.m_BonusID)
         {
            case RObjectType.FAKE:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("lay_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               delta = m_Direction.clone();
               delta.scaleBy(currState.bSphere.m_radius + 100 - currState.vel.length);
               _obj = new ROBJECTINFO();
               if(v_obj == null)
               {
                  _obj.m_CurrLoc = currState.loc.subtract(delta);
                  _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
               }
               else
               {
                  _obj.m_CurrLoc.x = v_obj.m_CurrLoc.x;
                  _obj.m_CurrLoc.y = v_obj.m_CurrLoc.y;
                  _obj.m_CurrLoc.z = v_obj.m_CurrLoc.z;
               }
               _obj.m_CurrPose = new Vector3D(0,0,0);
               _obj.m_CurrState = RObjectStateType.NEWOBJECT;
               _obj.m_ObjectType = RObjectType.FAKE;
               RockRacer.GameCommon.AddObject(_obj);
               this.m_BonusID = RObjectType.NONE_BONUS;
               break;
            case RObjectType.JELLY:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("lay_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               delta = m_Direction.clone();
               delta.scaleBy(currState.bSphere.m_radius + 100 - currState.vel.length);
               _obj = new ROBJECTINFO();
               if(v_obj == null)
               {
                  _obj.m_CurrLoc = currState.loc.subtract(delta);
                  _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
               }
               else
               {
                  _obj.m_CurrLoc.x = v_obj.m_CurrLoc.x;
                  _obj.m_CurrLoc.y = v_obj.m_CurrLoc.y;
                  _obj.m_CurrLoc.z = v_obj.m_CurrLoc.z;
               }
               _obj.m_CurrPose = new Vector3D(0,0,0);
               _obj.m_CurrState = RObjectStateType.NEWOBJECT;
               _obj.m_ObjectType = RObjectType.JELLY;
               RockRacer.GameCommon.AddObject(_obj);
               this.m_BonusID = RObjectType.NONE_BONUS;
               break;
            case RObjectType.WHITE_CUPCAKE:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("fire_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               delta = m_Direction.clone();
               delta.scaleBy(currState.bSphere.m_radius + 100);
               _obj = new ROBJECTINFO();
               if(v_obj == null)
               {
                  _obj.m_CurrLoc = currState.loc.add(delta);
                  _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
               }
               else
               {
                  _obj.m_CurrLoc.x = v_obj.m_CurrLoc.x;
                  _obj.m_CurrLoc.y = v_obj.m_CurrLoc.y;
                  _obj.m_CurrLoc.z = v_obj.m_CurrLoc.z;
               }
               _obj.m_CurrPose = new Vector3D(0,0,0);
               _obj.m_CurrState = RObjectStateType.NEWOBJECT;
               _obj.m_ObjectType = RObjectType.WHITE_CUPCAKE;
               _obj.m_ParentObject = this;
               RockRacer.GameCommon.AddObject(_obj);
               this.m_BonusID = RObjectType.NONE_BONUS;
               break;
            case RObjectType.BROWN_CUPCAKE:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("fire_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               delta = m_Direction.clone();
               delta.scaleBy(currState.bSphere.m_radius + 100);
               _obj = new ROBJECTINFO();
               if(v_obj == null)
               {
                  _obj.m_CurrLoc = currState.loc.add(delta);
                  _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
               }
               else
               {
                  _obj.m_CurrLoc.x = v_obj.m_CurrLoc.x;
                  _obj.m_CurrLoc.y = v_obj.m_CurrLoc.y;
                  _obj.m_CurrLoc.z = v_obj.m_CurrLoc.z;
               }
               _obj.m_CurrPose = new Vector3D(0,0,0);
               _obj.m_CurrState = RObjectStateType.NEWOBJECT;
               _obj.m_ObjectType = RObjectType.BROWN_CUPCAKE;
               _obj.m_ParentObject = this;
               RockRacer.GameCommon.AddObject(_obj);
               this.m_BonusID = RObjectType.NONE_BONUS;
               break;
            case RObjectType.PINK_CUPCAKE:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("fire_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               delta = m_Direction.clone();
               delta.scaleBy(currState.bSphere.m_radius + 100);
               _obj = new ROBJECTINFO();
               if(v_obj == null)
               {
                  _obj.m_CurrLoc = currState.loc.add(delta);
                  _obj.m_CurrLoc.y = RockRacer.GameCommon.GameClient.m_Terrain.GetHeightInfo(_obj.m_CurrLoc.x,_obj.m_CurrLoc.z) + 20;
               }
               else
               {
                  _obj.m_CurrLoc.x = v_obj.m_CurrLoc.x;
                  _obj.m_CurrLoc.y = v_obj.m_CurrLoc.y;
                  _obj.m_CurrLoc.z = v_obj.m_CurrLoc.z;
               }
               _obj.m_CurrPose = new Vector3D(0,0,0);
               _obj.m_CurrState = RObjectStateType.NEWOBJECT;
               _obj.m_ObjectType = RObjectType.PINK_CUPCAKE;
               _obj.m_ParentObject = this;
               RockRacer.GameCommon.AddObject(_obj);
               this.m_BonusID = RObjectType.NONE_BONUS;
               break;
            case RObjectType.AUTOPILOT:
               this.SetAction(RActionState.AUTOPILOT_PLAY);
               this.m_isAutoPilot = true;
               break;
            case RObjectType.BOOSTER:
               this.SetAction(RActionState.BOOSTER_USE);
               break;
            case RObjectType.LIGHT:
               this.SetAction(RActionState.LIGHT_USE);
               break;
            case RObjectType.MUD_DEVIL:
               this.SetAction(RActionState.MUD_USE);
               break;
            case RObjectType.SHIELD:
               this.SetAction(RActionState.SHIELD_USE);
         }
         if(currState.actionState != preState.actionState)
         {
            this.m_BonusID = RObjectType.NONE_BONUS;
         }
         if(this.m_BonusID == RObjectType.NONE_BONUS)
         {
            return true;
         }
         return false;
      }
      
      override public function CollisionProc(param1:RGameEnt) : void
      {
         var _loc2_:REffectData = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vector3D = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         switch(param1.m_ObjType)
         {
            case RObjectType.AICAR:
            case RObjectType.PLAYERCAR:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(this.m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("collision_car");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               _loc2_ = new REffectData(RSpecialEffectType.OBJECT_COLLISION_EFFECT,this.currState,param1.currState);
               _loc2_.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc2_);
               if(this.currState.actionState == RActionState.AUTOPILOT_PLAY || this.currState.actionState == RActionState.SHIELD_USE)
               {
                  break;
               }
               if(param1.currState.actionState == RActionState.AUTOPILOT_PLAY || param1.currState.actionState == RActionState.SHIELD_USE)
               {
                  this.SetAction(RActionState.BEATEN);
                  _loc3_ = currState.loc.subtract(param1.currState.loc);
                  (_loc6_ = m_Direction.clone()).normalize();
                  _loc6_.scaleBy(_loc3_.dotProduct(_loc6_));
                  _loc3_.decrementBy(_loc6_);
                  _loc3_.normalize();
                  _loc3_.scaleBy(param1.currState.vel.length);
                  currState.vel = _loc3_.clone();
                  break;
               }
               _loc3_ = currState.loc.subtract(param1.currState.loc);
               _loc3_.normalize();
               _loc4_ = currState.mass * currState.vel.length;
               _loc5_ = param1.currState.mass * param1.preState.vel.length;
               if(_loc4_ + _loc5_ == 0)
               {
                  _loc3_.scaleBy(0);
               }
               else
               {
                  _loc3_.scaleBy((currState.vel.length + param1.currState.vel.length) * 0.5 * _loc5_ / (_loc4_ + _loc5_));
               }
               currState.vel.incrementBy(_loc3_);
               break;
            case RObjectType.TREE3:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("collision_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               _loc2_ = new REffectData(RSpecialEffectType.BONUS_BREAK_EFFECT,this.currState,param1.currState);
               _loc2_.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc2_);
               RockRacer.GameCommon.GameClient.mc_InfoWnd.incCounter1();
               RockRacer.GameCommon.GameClient.addOil();
               break;
            case RObjectType.TREE1:
               if(RockRacer.GameCommon.m_SoundOnOff)
               {
                  if(m_ObjType == RObjectType.PLAYERCAR)
                  {
                     this.m_Sound = RSoundMgr.GetSound("collision_item");
                     this.m_EffectSndChannel = this.m_Sound.play();
                  }
               }
               _loc2_ = new REffectData(RSpecialEffectType.BONUS_BREAK_EFFECT,this.currState,param1.currState);
               _loc2_.m_car = this;
               RockRacer.GameCommon.GameClient.m_SpecialEffect.EffectProcess(_loc2_);
               if((_loc7_ = RockRacer.GameCommon.CommonRsrMgr.m_Infofile.m_InfoDic)[param1.m_DestPath] != null)
               {
                  _loc8_ = _loc7_[param1.m_DestPath];
                  RockRacer.GameCommon.GameClient.mc_InfoWnd.onStart(_loc8_);
                  this.m_bInfo = true;
               }
         }
      }
      
      public function SetRank() : void
      {
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc1_:Array = RockRacer.GameCommon.GameClient.m_CarList;
         var _loc2_:int = 1;
         if(this.m_Lap >= LASTLAP)
         {
            m_AI.SetAIState(RAI.AI_IDLE);
            this.StopAccel();
            return;
         }
         var _loc3_:Array = RockRacer.GameCommon.GameClient.m_Terrain.m_path.m_lPath;
         var _loc4_:int = m_DestPath + this.m_Lap * _loc3_.length;
         var _loc6_:Number = RAI.DistanceXZ(currState.loc,_loc3_[m_DestPath]);
         _loc7_ = 0;
         while(_loc7_ < _loc1_.length)
         {
            if(this.m_ObjID != _loc1_[_loc7_].m_ObjID)
            {
               if(_loc1_[_loc7_].m_Lap >= LASTLAP)
               {
                  _loc2_++;
               }
               else
               {
                  _loc5_ = _loc1_[_loc7_].m_DestPath + _loc1_[_loc7_].m_Lap * _loc3_.length;
                  if(_loc4_ < _loc5_)
                  {
                     _loc2_++;
                  }
                  if(_loc4_ == _loc5_)
                  {
                     _loc8_ = RAI.DistanceXZ(_loc1_[_loc7_].currState.loc,_loc3_[_loc1_[_loc7_].m_DestPath]);
                     if(_loc6_ > _loc8_)
                     {
                        _loc2_++;
                     }
                  }
               }
            }
            _loc7_++;
         }
         this.m_Rank = _loc2_;
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
         _loc6_ = Math.abs(this.currState.loc.x - param1.m_GridMin.x) / param1.m_GrideSpaceX;
         _loc8_ = (_loc7_ = Math.abs(this.currState.loc.z - param1.m_GridMin.z) / param1.m_GrideSpaceZ) * param1.m_GrideDivision + _loc6_;
         m_renderObject.visible = true;
         if(_loc8_ == param2)
         {
            return;
         }
         _loc3_ = param1.m_lCellInfoList[param2].pvscell;
         var _loc10_:int = 0;
         while(_loc10_ < _loc3_.length)
         {
            if(_loc3_[_loc10_] == _loc8_)
            {
               return;
            }
            _loc10_++;
         }
         m_renderObject.visible = false;
         this.m_visiblelevel = 3;
         if(this.m_ObjType == RObjectType.PLAYERCAR)
         {
            return;
         }
      }
      
      public function VisibleLodModel(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.m_highRndrObject.visible = param1;
         this.m_middleRndrObject.visible = param2;
         this.m_lowRndrObject.visible = param3;
      }
      
      public function VisibleWheel(param1:Boolean) : void
      {
         this.m_FLWheelObject.visible = param1;
         this.m_FRWheelObject.visible = param1;
         this.m_BLWheelObject.visible = param1;
         this.m_BRWheelObject.visible = param1;
         this.m_FLWheelObject.m_delta = -900;
         this.m_FRWheelObject.m_delta = -900;
         this.m_BLWheelObject.m_delta = -900;
         this.m_BRWheelObject.m_delta = -900;
      }
      
      public function VisibleHighModel() : void
      {
         if(currState.actionState == RActionState.AUTOPILOT_PLAY)
         {
            this.VisibleWheel(false);
            m_renderObject.geometry.vertices = this.m_autopilot.geometry.vertices;
            m_renderObject.geometry.faces = this.m_autopilot.geometry.faces;
         }
         else
         {
            this.VisibleWheel(true);
            m_renderObject.geometry.vertices = this.m_highRndrObject.geometry.vertices;
            m_renderObject.geometry.faces = this.m_highRndrObject.geometry.faces;
         }
         m_renderObject.m_delta = -1000;
         this.m_visiblelevel = 0;
      }
      
      public function VisibleMiddleModel() : void
      {
         this.VisibleWheel(false);
         if(currState.actionState == RActionState.AUTOPILOT_PLAY)
         {
            m_renderObject.geometry.vertices = this.m_autopilot.geometry.vertices;
            m_renderObject.geometry.faces = this.m_autopilot.geometry.faces;
         }
         else
         {
            m_renderObject.geometry.vertices = this.m_middleRndrObject.geometry.vertices;
            m_renderObject.geometry.faces = this.m_middleRndrObject.geometry.faces;
         }
         this.m_visiblelevel = 1;
         m_renderObject.m_delta = -1000;
      }
      
      public function VisibleLowModel() : void
      {
         this.VisibleWheel(false);
         if(currState.actionState == RActionState.AUTOPILOT_PLAY)
         {
            m_renderObject.geometry.vertices = this.m_autopilot.geometry.vertices;
            m_renderObject.geometry.faces = this.m_autopilot.geometry.faces;
         }
         else
         {
            m_renderObject.geometry.vertices = this.m_lowRndrObject.geometry.vertices;
            m_renderObject.geometry.faces = this.m_lowRndrObject.geometry.faces;
         }
         m_renderObject.m_delta = 0;
         this.m_visiblelevel = 2;
      }
      
      public function CarTerrainSoundStop() : void
      {
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            return;
         }
         if(this.m_TerrainSndChannel != null)
         {
            this.m_TerrainSndChannel.stop();
         }
      }
      
      public function SoundStop() : void
      {
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            return;
         }
         if(this.m_TerrainSndChannel != null)
         {
            this.m_TerrainSndChannel.stop();
         }
         if(this.m_CarSndChannel != null)
         {
            this.m_CarSndChannel.stop();
         }
         if(this.m_EffectSndChannel != null)
         {
            this.m_EffectSndChannel.stop();
         }
      }
      
      public function PlayEngineSound() : void
      {
         var transform:SoundTransform = null;
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            return;
         }
         try
         {
            if(this.m_EngineSndChannel != null)
            {
               transform = this.m_EngineSndChannel.soundTransform;
               transform.volume = 0.5;
            }
            else
            {
               transform = new SoundTransform(0.5);
            }
            if(!this.m_bDirect && this.m_bAccel == 1)
            {
               this.m_Sound = RSoundMgr.GetSound("engine_accel");
               this.m_EngineSndChannel = this.m_Sound.play(0.1,1,transform);
               this.m_bDirect = true;
               if(this.m_EngineSndChannel != null)
               {
                  this.m_EngineSndChannel.addEventListener(Event.SOUND_COMPLETE,this.PlayBackEngineSound);
               }
            }
            if(this.m_bDirect && this.m_bAccel == 0)
            {
               this.m_EngineSndChannel.stop();
               this.m_Sound = RSoundMgr.GetSound("engine_down");
               this.m_EngineSndChannel = this.m_Sound.play(0.1,1,transform);
               this.m_bDirect = false;
               if(this.m_EngineSndChannel != null)
               {
                  this.m_EngineSndChannel.addEventListener(Event.SOUND_COMPLETE,this.downComplete);
               }
            }
         }
         catch(err:Error)
         {
            trace("RCar->" + err);
         }
      }
      
      public function downComplete(param1:Event) : void
      {
         if(this.m_EngineSndChannel != null)
         {
            this.m_EngineSndChannel.removeEventListener(Event.SOUND_COMPLETE,this.EndEngineSound);
         }
      }
      
      public function PlayBackEngineSound(param1:Event) : void
      {
         var _loc2_:SoundTransform = null;
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            return;
         }
         if(this.m_EngineSndChannel != null)
         {
            this.m_EngineSndChannel.removeEventListener(Event.SOUND_COMPLETE,this.EndEngineSound);
         }
         if(this.m_EngineSndChannel != null)
         {
            _loc2_ = this.m_EngineSndChannel.soundTransform;
            _loc2_.volume = 0.5;
         }
         else
         {
            _loc2_ = new SoundTransform(0.5);
         }
         this.m_Sound = RSoundMgr.GetSound("engine");
         this.m_EngineSndChannel = this.m_Sound.play(0.1,10000,_loc2_);
      }
      
      public function EndEngineSound(param1:Event) : void
      {
      }
      
      public function StopEngineSound() : void
      {
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            return;
         }
         if(this.m_EngineSndChannel != null)
         {
            this.m_EngineSndChannel.stop();
         }
         if(this.m_CarSndChannel != null)
         {
            this.m_CarSndChannel.stop();
         }
         if(this.m_TerrainSndChannel != null)
         {
            this.m_TerrainSndChannel.stop();
         }
         if(this.m_EffectSndChannel != null)
         {
            this.m_EffectSndChannel.stop();
         }
      }
   }
}
