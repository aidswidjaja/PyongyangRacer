package player
{
   import AI.*;
   import Const.*;
   import Effect.*;
   import Menu.*;
   import common.*;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.SoundTransform;
   import flash.net.*;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.*;
   import flash.ui.Keyboard;
   import flash.utils.*;
   import object.*;
   import org.papervision3d.cameras.*;
   import org.papervision3d.core.math.*;
   import org.papervision3d.core.render.data.*;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.render.*;
   import org.papervision3d.view.BasicView;
   import resourcemgr.*;
   import ui.*;
   
   public class RGameClient extends Sprite
   {
      
      public static const CARCOUNT:int = 1;
      
      public static var userTotal:int;
      
      public static const RENDER_LOADING:int = 0;
      
      public static const RENDER_READY:int = 1;
      
      public static const RENDER_PLAYING:int = 2;
      
      public static const RENDER_SCORE:int = 3;
      
      public static const RENDER_END:int = 4;
      
      public static const RENDER_ABORT:int = 5;
      
      public static var m_ViewportWidth:int = 760;
      
      public static var m_ViewportHeight:int = 500;
      
      public static const KEY_UP:Number = 1;
      
      public static const KEY_DOWN:Number = 2;
      
      public static const KEY_LEFT:Number = 4;
      
      public static const KEY_RIGHT:Number = 8;
      
      public static const KEY_SPACE:Number = 16;
      
      public static const READY:int = 0;
      
      public static const GO:int = 1;
      
      public static const FALLING:int = 2;
      
      public static var m_sendTime:Number;
       
      
      private var preticktime:int = 0;
      
      private const FPS:int = 12;
      
      private const TIMEPERFRAME:int = int(1000 / this.FPS);
      
      public var m_ReadyCounter:MovieClip;
      
      private var m_CloseButton:MovieClip;
      
      private var m_RankView:MovieClip;
      
      public var m_LapView:RLapView;
      
      public var m_TimerView:RTimerView;
      
      public var m_mudman:MovieClip;
      
      public var m_lightman:MovieClip;
      
      public var cellID:int = 0;
      
      public var m_RenderMode:int = 0;
      
      private var m_FadeEndScreen:int = 0;
      
      public var f_angle:Number;
      
      public var f_elas:Number;
      
      public var o_elas:Number;
      
      public var o_fric:Number;
      
      public var o_limvel:Number;
      
      public var m_StartFlag:Boolean = false;
      
      public var m_View:BasicView;
      
      public var m_scMask:MovieClip;
      
      public var m_TrackID:int;
      
      public var m_PlayerID:int;
      
      public var m_PlayerObjID:int;
      
      public var KeyMask:Number = 0;
      
      private var preKeyMask:Number = 0;
      
      public var m_LevelRsr:RResourceMgr;
      
      public var m_Object:Array;
      
      public var m_CarList:Array;
      
      public var m_Terrain:RTerrain;
      
      public var m_Boundary:RBoundary;
      
      public var m_Sky:RSky;
      
      public var m_CollisionWall:RCollisionWall;
      
      public var m_Sea:RSea;
      
      public var m_CurrCellID:int;
      
      public var m_CurrViewCells:Array;
      
      public var outputTri_txt:TextField;
      
      public var outputCollision_txt:TextField;
      
      public var Str:String;
      
      public var m_CameraMode:int = 0;
      
      protected var m_CameraRate:Number = 1.3;
      
      public var miniCars:Array;
      
      public var weaponView:RWeaponView;
      
      public var BonusUseFlag:Boolean = false;
      
      public var Squirrel:MovieClip;
      
      public var m_LoadFile:FileReference;
      
      public var m_SpecialEffect:RSpecialEffect;
      
      protected var MiddleDist:Number = 500;
      
      protected var LowDist:Number = 3000;
      
      public var m_GameSWfLoader:Loader;
      
      public var m_DeletePage:Boolean = false;
      
      public var m_miniMap:RMinimap;
      
      protected var m_minMapWidth:int;
      
      protected var m_minMapHeight:int;
      
      public var m_QuitWindow:QuitWindow;
      
      public var m_QuitWindowEnable:Boolean = false;
      
      private var _pause:Boolean = false;
      
      public var Tutorial_Space:MovieClip;
      
      public var Tutorial_Box:MovieClip;
      
      public var m_TutorialSpace:Array;
      
      public var timeoutTime:int = -1;
      
      private var timeoutFunction:Function;
      
      private var timeoutArg:Boolean;
      
      private var m_isQuitEnable:Boolean;
      
      public var aa:int = 0;
      
      public var mc_MarkDirection:mc_MarkDir;
      
      public var mc_GuideWnd:RGuideWindow;
      
      public var mc_InfoWnd:RInfoWindow;
      
      private var oil:Number;
      
      private const maxOil:Number = 1000;
      
      private const minOil:Number = 100;
      
      public function RGameClient()
      {
         this.f_angle = new Number(20);
         this.f_elas = new Number(0.3);
         this.o_elas = new Number(0.75);
         this.o_fric = new Number(0.8);
         this.o_limvel = new Number(5);
         this.outputTri_txt = new TextField();
         this.outputCollision_txt = new TextField();
         this.Str = new String("");
         this.miniCars = new Array();
         this.m_LoadFile = new FileReference();
         this.m_GameSWfLoader = new Loader();
         this.m_miniMap = new RMinimap();
         this.m_QuitWindow = new QuitWindow();
         this.m_TutorialSpace = new Array();
         this.timeoutFunction = new Function();
         this.mc_MarkDirection = new mc_MarkDir();
         this.mc_GuideWnd = new RGuideWindow();
         this.mc_InfoWnd = new RInfoWindow();
         super();
         this.m_LevelRsr = new RResourceMgr();
         this.m_Object = new Array();
         this.m_CarList = new Array();
         this.m_Terrain = new RTerrain();
         this.m_Boundary = new RBoundary();
         this.m_CollisionWall = new RCollisionWall();
         this.m_Sky = new RSky();
         RBonusType.CreateInstance();
         RPlayerType.CreateInstance();
         this.LoadSWF("symbol.dat");
      }
      
      public static function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public static function MsgNum(param1:Number) : Number
      {
         return Number(int(param1 * 100)) / 100;
      }
      
      public function set pause(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._pause = param1;
         if(this._pause)
         {
            this.m_TimerView.pauseTime();
            this.weaponView.pause = true;
            this.m_mudman.stop();
            this.m_lightman.stop();
            this.Squirrel.stop();
            this.m_ReadyCounter.stop();
            this.m_RankView.stop();
            this.m_LapView.pause = true;
         }
         else
         {
            _loc4_ = this.m_TimerView.resumeTime();
            _loc2_ = 0;
            while(_loc2_ < this.m_CarList.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.m_CarList[_loc2_].m_LapTimes.length)
               {
                  this.m_CarList[_loc2_].m_LapTimes[_loc3_] += _loc4_;
                  _loc3_++;
               }
               _loc2_++;
            }
            this.m_LapView.pause = false;
            this.weaponView.pause = false;
            if(this.m_mudman.visible)
            {
               this.m_mudman.play();
            }
            if(this.m_lightman.visible)
            {
               this.m_lightman.play();
            }
            if(this.Squirrel.visible)
            {
               this.Squirrel.play();
            }
            if(this.m_ReadyCounter.parent)
            {
               this.m_ReadyCounter.play();
            }
         }
      }
      
      public function get pause() : Boolean
      {
         return this._pause;
      }
      
      public function addItem(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1[2];
         param1.splice(0,3);
         _loc3_ = 0;
         while(_loc3_ < this.m_CarList.length)
         {
            if(this.m_CarList[_loc3_].m_userId == _loc2_)
            {
               this.m_CarList[_loc3_].m_BonusID = int(param1[0]);
               this.m_CarList[_loc3_].UseBonus({"m_CurrLoc":{
                  "x":int(param1[1]),
                  "y":int(param1[2]),
                  "z":int(param1[3])
               }});
            }
            _loc3_++;
         }
      }
      
      public function getItem(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1[2];
         param1.splice(0,3);
         if(_loc2_ != Client.myUserId)
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_CarList.length)
            {
               if(this.m_CarList[_loc3_].m_userId == _loc2_)
               {
                  if(this.m_Object[int(param1[0])] != null)
                  {
                     this.m_CarList[_loc3_].CollisionProc(this.m_Object[int(param1[0])]);
                     this.m_Object[int(param1[0])].CollisionProc(this.m_CarList[_loc3_]);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function setLap(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1[2];
         param1.splice(0,3);
         if(_loc2_ != Client.myUserId)
         {
            _loc3_ = 0;
            while(_loc3_ < this.m_CarList.length)
            {
               if(this.m_CarList[_loc3_].m_userId == _loc2_)
               {
                  this.m_CarList[_loc3_].m_Lap = int(param1[0]);
               }
               _loc3_++;
            }
         }
      }
      
      public function setMoveState(param1:Array) : void
      {
         var _loc8_:int = 0;
         var _loc2_:int = param1[2];
         param1.splice(0,3);
         var _loc3_:Object = {
            "x":Number(param1[0]),
            "y":Number(param1[1]),
            "z":Number(param1[2])
         };
         var _loc4_:Object = {
            "x":Number(param1[3]),
            "y":Number(param1[4]),
            "z":Number(param1[5])
         };
         var _loc5_:Object = {
            "x":Number(param1[10]),
            "y":Number(param1[11]),
            "z":Number(param1[12])
         };
         var _loc6_:int = Number(param1[2]);
         var _loc7_:Object = {
            "id":_loc2_,
            "count":int(param1[9]),
            "keyMask":Number(param1[8]),
            "loc":_loc3_,
            "pose":_loc4_,
            "vel":_loc5_,
            "actionState":Number(param1[6]),
            "animState":Number(param1[7]),
            "destPath":int(param1[14])
         };
         if(_loc2_ != Client.myUserId)
         {
            _loc8_ = 0;
            while(_loc8_ < this.m_CarList.length)
            {
               if(this.m_CarList[_loc8_].m_userId == _loc2_)
               {
                  if(this.m_CarList[_loc8_].m_msgCount <= int(param1[9]))
                  {
                     this.otherHandleInputLoop(Number(param1[8]),_loc8_);
                     this.m_CarList[_loc8_].SetAction(RActionState.NONE);
                     this.m_CarList[_loc8_].SetCarPose(_loc7_);
                     this.m_CarList[_loc8_].m_msgCount = int(param1[9]);
                  }
                  return;
               }
               _loc8_++;
            }
         }
      }
      
      public function LoadSWF(param1:String) : void
      {
         var _loc2_:URLRequest = new URLRequest(RockRacer.base + param1);
         var _loc3_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.m_GameSWfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSWFLoadComplete);
         this.m_GameSWfLoader.load(_loc2_,_loc3_);
      }
      
      public function onSWFLoadComplete(param1:Event) : void
      {
         var _loc2_:Class = GetClassInSWF("ScreenMask");
         this.m_scMask = MovieClip(new _loc2_());
         _loc2_ = GetClassInSWF("Squirrel_inc");
         this.Squirrel = MovieClip(new _loc2_());
         this.m_SpecialEffect = new RSpecialEffect();
         this.weaponView = new RWeaponView();
         _loc2_ = GetClassInSWF("ReadyCounter");
         this.m_ReadyCounter = MovieClip(new _loc2_());
         _loc2_ = GetClassInSWF("PlayerRankView");
         this.m_RankView = MovieClip(new _loc2_());
         _loc2_ = GetClassInSWF("CloseButton");
         this.m_CloseButton = MovieClip(new _loc2_());
         _loc2_ = GetClassInSWF("Wrongway_Character");
         _loc2_ = GetClassInSWF("Lighteman");
         this.m_lightman = MovieClip(new _loc2_());
         _loc2_ = GetClassInSWF("Mudman");
         this.m_mudman = MovieClip(new _loc2_());
         this.m_LapView = new RLapView();
         this.m_TimerView = new RTimerView();
      }
      
      public function Initialize() : void
      {
         this.m_LevelRsr.LoadLevel(this.m_TrackID);
         this.aa = 0;
         this.m_View = new BasicView(m_ViewportWidth,m_ViewportHeight,false,true,CameraType.FREE);
         this.m_View.camera.zoom = 10;
         this.m_View.camera.focus = 50;
         this.m_View.scene.addChild(this.m_Terrain);
         this.m_View.scene.addChild(this.m_Boundary);
         this.m_Sea = new RSea();
         this.m_View.scene.addChild(this.m_Sea);
         this.m_View.scene.addChild(this.m_Sky);
         this.m_View.scene.addChild(this.m_SpecialEffect.m_ParticleManager);
         with(this.outputTri_txt)
         {
            text = "*\n\n";
            width = 200;
            height = outputTri_txt.textHeight;
            textColor = 255;
            x = 20;
            y = 10;
            visible = true;
         }
         this.m_RenderMode = RENDER_LOADING;
         this.m_FadeEndScreen = 0;
         this.m_LevelRsr.addEventListener("LOAD_COMPLETE",this.LoadRsrComplete);
         this.m_isQuitEnable = false;
      }
      
      public function DestroyScene() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = this.m_View.scene.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.m_View.scene.removeChild(this.m_View.scene.objects[0]);
            _loc2_++;
         }
         this.m_Object.splice(0);
         this.m_CarList.splice(0);
         this.miniCars.splice(0);
         this.m_TimerView.stopTime();
         this.m_TimerView.time = 0;
         this.m_LapView.setPlayerLab(1);
         while(this.m_miniMap.numChildren > 0)
         {
            this.m_miniMap.removeChildAt(0);
         }
         _loc1_ = this.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            removeChildAt(0);
            _loc2_++;
         }
         if(RockRacer.GameCommon.g_SingleGame)
         {
            removeEventListener(Event.ENTER_FRAME,this.Loop);
         }
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.KeyDownHandler);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.KeyUpHandler);
         stage.removeEventListener(Event.DEACTIVATE,this.Deactive);
         this.m_ReadyCounter.gotoAndStop(1);
      }
      
      public function SetTrack(param1:int) : void
      {
         this.m_TrackID = param1;
      }
      
      public function SetPlayer(param1:int) : void
      {
         this.m_PlayerID = param1;
      }
      
      public function LoadRsrComplete(param1:Event) : void
      {
         addEventListener("INIT_COMPLATE",this.initTerrain);
         addEventListener(Event.ENTER_FRAME,this.initTerrainLoop);
         this.m_Terrain.startInitTerrain();
      }
      
      public function initTerrainLoop(param1:Event) : void
      {
         this.m_Terrain.loopInit(param1);
         dispatchEvent(new ProgressEvent("progress",false,false,int(this.m_Terrain.getInitProgress() * 40 / 100),100));
      }
      
      public function initTerrain(param1:Event) : void
      {
         this.m_Boundary.InitBoundary();
         this.m_Sky.InitSky();
         this.m_Sea.InitSea();
         this.m_CollisionWall.InitCollisionWall();
         this.InitCarObject();
         removeEventListener(Event.ENTER_FRAME,this.initTerrainLoop);
         removeEventListener("INIT_COMPLATE",this.initTerrain);
         dispatchEvent(new Event("LOAD_FINISH"));
      }
      
      public function InitGo() : void
      {
         var _loc1_:MovieClip = null;
         var _loc3_:RMinicar = null;
         var _loc4_:int = 0;
         var _loc5_:SoundTransform = null;
         addChild(this.m_View);
         this.Squirrel.visible = false;
         this.Squirrel.x = 350;
         this.Squirrel.y = 150;
         this.Squirrel.stop();
         addChild(this.Squirrel);
         addChild(this.m_SpecialEffect);
         this.mc_MarkDirection.x = 348;
         this.mc_MarkDirection.y = 80;
         this.mc_MarkDirection.gotoAndStop("blank");
         addChild(this.mc_MarkDirection);
         this.mc_GuideWnd.x = 0;
         this.mc_GuideWnd.y = 0;
         this.mc_GuideWnd.gotoAndStop(1);
         addChild(this.mc_GuideWnd);
         this.mc_InfoWnd.x = 0;
         this.mc_InfoWnd.y = 0;
         this.mc_InfoWnd.gotoAndStop(1);
         this.mc_InfoWnd.initCounter();
         addChild(this.mc_InfoWnd);
         var _loc2_:Class = getDefinitionByName("mini_mapPY") as Class;
         _loc1_ = MovieClip(new _loc2_());
         _loc1_.x = 0;
         _loc1_.y = 50;
         this.m_minMapWidth = _loc1_.width;
         this.m_minMapHeight = _loc1_.height;
         this.m_miniMap.Init();
         this.m_miniMap.addChild(_loc1_);
         _loc3_ = new RMinicar(RMinicar.TYPE_PYCAR);
         this.miniCars.push(_loc3_);
         this.m_miniMap.addChild(_loc3_);
         addChild(this.m_miniMap);
         addChild(this.m_scMask);
         this.m_scMask.visible = true;
         this.m_scMask.gotoAndStop(0);
         this.m_CloseButton.x = m_ViewportWidth - this.m_CloseButton.width - 25;
         this.m_CloseButton.y = 0;
         this.m_RankView.x = m_ViewportWidth - this.m_RankView.width - 10;
         this.m_RankView.y = m_ViewportHeight - this.m_RankView.height - 10;
         this.m_LapView.setPlayerLab(1);
         this.m_TimerView.time = 0;
         addChild(this.m_CloseButton);
         addChild(this.m_TimerView);
         this.m_mudman.x = 370;
         this.m_mudman.y = 150;
         this.m_mudman.visible = false;
         addChild(this.m_mudman);
         this.m_lightman.x = 370;
         this.m_lightman.y = 150;
         this.m_lightman.visible = false;
         addChild(this.m_lightman);
         addChild(this.m_ReadyCounter);
         this.m_ReadyCounter.x = m_ViewportWidth / 2;
         this.m_ReadyCounter.y = m_ViewportHeight / 2;
         setTimeout(this.startReadyCount,3000);
         if(!RockRacer.GameCommon.m_SoundOnOff)
         {
            (_loc5_ = this.m_ReadyCounter.soundTransform).volume = 0;
            this.m_ReadyCounter.soundTransform = _loc5_;
         }
         this.m_RenderMode = RENDER_READY;
         this.m_DeletePage = true;
         this.preticktime = getTimer();
         this.weaponView.stopSelecting();
         this.m_CameraMode = READY;
         this.oil = this.maxOil;
         addEventListener(Event.ENTER_FRAME,this.Loop);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.KeyDownHandler);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.KeyUpHandler);
         stage.addEventListener(Event.DEACTIVATE,this.Deactive);
         this.m_CloseButton.addEventListener(MouseEvent.CLICK,this.EscapeFunc);
         this._pause = false;
         this.m_QuitWindowEnable = false;
      }
      
      private function startReadyCount() : void
      {
         if(!this.pause)
         {
            this.m_ReadyCounter.gotoAndStop(2);
         }
      }
      
      protected function Deactive(param1:Event) : void
      {
         this.KeyMask = 0;
         this.preKeyMask = this.KeyMask;
         if(RockRacer.GameCommon.g_SingleGame)
         {
            this.QuitWindowFunc();
         }
         else
         {
            Client.sendState([MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.z),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.z),this.m_CarList[this.m_PlayerID].currState.actionState,this.m_CarList[this.m_PlayerID].currState.animState,this.KeyMask,this.m_CarList[this.m_PlayerID].m_msgCount++,MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.z),this.m_CarList[this.m_PlayerID].m_bBA,this.m_CarList[this.m_PlayerID].m_DestPath]);
            m_sendTime = getTimer();
         }
      }
      
      public function InitCarObject() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Vector3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:ROBJECTINFO = null;
         if(RockRacer.GameCommon.g_SingleGame)
         {
            _loc1_ = 0;
            while(_loc1_ < CARCOUNT)
            {
               _loc8_ = new ROBJECTINFO();
               _loc4_ = new Vector3D();
               _loc4_ = this.m_Terrain.m_path.m_lPath[1].subtract(this.m_Terrain.m_path.m_lPath[0]);
               _loc5_ = Math.atan(_loc4_.x / _loc4_.z);
               _loc6_ = Math.cos(_loc5_);
               _loc7_ = Math.sin(_loc5_);
               _loc5_ = _loc5_ * 180 / Math.PI;
               if(_loc4_.z < 0)
               {
                  _loc5_ += 180;
               }
               if(_loc5_ < 0)
               {
                  _loc5_ += 360;
                  _loc6_ = -_loc6_;
                  _loc7_ = -_loc7_;
               }
               _loc8_.m_CurrLoc = new Vector3D(this.m_Terrain.m_path.m_lPath[0].x + (_loc1_ - 2) * 150 * (_loc7_ + _loc6_),this.m_Terrain.GetHeightInfo(this.m_Terrain.m_path.m_lPath[0].x,this.m_Terrain.m_path.m_lPath[0].z),this.m_Terrain.m_path.m_lPath[0].z + _loc1_ * 150 * (_loc6_ - _loc7_));
               _loc8_.m_CurrPose = new Vector3D(0,_loc5_,0);
               _loc8_.m_CurrState = RObjectStateType.NEWOBJECT;
               if(_loc1_ == this.m_PlayerID)
               {
                  _loc8_.m_ObjectType = RObjectType.PLAYERCAR;
                  _loc8_.m_ObjectProperty = 2;
               }
               else
               {
                  _loc8_.m_ObjectType = RObjectType.AICAR;
                  _loc8_.m_ObjectProperty = _loc1_;
               }
               RockRacer.GameCommon.AddObject(_loc8_);
               _loc1_++;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < Client.multiInfo.ps.length)
            {
               _loc8_ = new ROBJECTINFO();
               _loc4_ = new Vector3D();
               _loc4_ = this.m_Terrain.m_path.m_lPath[1].subtract(this.m_Terrain.m_path.m_lPath[0]);
               _loc5_ = Math.atan(_loc4_.x / _loc4_.z);
               _loc6_ = Math.cos(_loc5_);
               _loc7_ = Math.sin(_loc5_);
               _loc5_ = _loc5_ * 180 / Math.PI;
               if(_loc4_.z < 0)
               {
                  _loc5_ += 180;
               }
               if(_loc5_ < 0)
               {
                  _loc5_ += 360;
                  _loc6_ = -_loc6_;
                  _loc7_ = -_loc7_;
               }
               _loc8_.m_CurrLoc = new Vector3D(this.m_Terrain.m_path.m_lPath[0].x + (_loc1_ - 2) * 150 * (_loc7_ + _loc6_),this.m_Terrain.GetHeightInfo(this.m_Terrain.m_path.m_lPath[0].x,this.m_Terrain.m_path.m_lPath[0].z),this.m_Terrain.m_path.m_lPath[0].z + _loc1_ * 150 * (_loc6_ - _loc7_));
               _loc8_.m_CurrPose = new Vector3D(0,_loc5_,0);
               _loc8_.m_CurrState = RObjectStateType.NEWOBJECT;
               if(Client.multiInfo.ps[_loc1_] == Client.myUserId)
               {
                  _loc8_.m_ObjectType = RObjectType.PLAYERCAR;
                  _loc8_.m_ObjectProperty = int(Client.multiInfo["p_" + Client.multiInfo.ps[_loc1_]].dt);
                  _loc8_.m_userId = Client.multiInfo.ps[_loc1_];
               }
               else
               {
                  _loc8_.m_ObjectType = RObjectType.AICAR;
                  _loc8_.m_ObjectProperty = int(Client.multiInfo["p_" + Client.multiInfo.ps[_loc1_]].dt);
                  _loc8_.m_userId = Client.multiInfo.ps[_loc1_];
               }
               RockRacer.GameCommon.AddObject(_loc8_);
               _loc1_++;
            }
         }
         this.RenderObjectLoop();
      }
      
      public function RenderObjectLoop() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = RockRacer.GameCommon.g_ObjectInfo;
         var _loc2_:int = RGameCommon.g_ObjectCount;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            switch(_loc1_[_loc3_].m_CurrState)
            {
               case RObjectStateType.NEWOBJECT:
                  this.CreateObject(_loc1_[_loc3_]);
                  _loc1_[_loc3_].m_CurrState = RObjectStateType.USEOBJECT;
                  break;
               case RObjectStateType.USEOBJECT:
                  this.UpdateObject(_loc1_[_loc3_]);
                  break;
               case RObjectStateType.DELETEOBJECT:
                  this.DeleteObject(_loc1_[_loc3_]);
                  RockRacer.GameCommon.RemoveObject(_loc1_[_loc3_].m_ObjectID);
                  break;
            }
            _loc3_++;
         }
      }
      
      public function CreateObject(param1:ROBJECTINFO) : void
      {
         var _loc2_:DisplayObject3D = null;
         var _loc3_:RPlayerCar = null;
         var _loc4_:RAICar = null;
         var _loc5_:RTreasure = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         switch(param1.m_ObjectType)
         {
            case RObjectType.PLAYERCAR:
               _loc3_ = new RPlayerCar(param1);
               _loc3_.BuildGeom();
               _loc3_.m_CollisionType = true;
               this.m_View.scene.addChild(_loc3_.m_renderObject);
               this.m_View.scene.addChild(_loc3_.m_FLWheelObject);
               this.m_View.scene.addChild(_loc3_.m_FRWheelObject);
               this.m_View.scene.addChild(_loc3_.m_BLWheelObject);
               this.m_View.scene.addChild(_loc3_.m_BRWheelObject);
               this.m_Object.push(_loc3_);
               this.m_CarList.push(_loc3_);
               this.m_PlayerID = this.m_CarList.length - 1;
               this.m_PlayerObjID = _loc3_.m_ObjID;
               _loc3_.m_Rank = this.m_CarList.length;
               break;
            case RObjectType.AICAR:
               (_loc4_ = new RAICar(param1)).BuildGeom();
               _loc4_.m_CollisionType = true;
               this.m_View.scene.addChild(_loc4_.m_renderObject);
               this.m_View.scene.addChild(_loc4_.m_FLWheelObject);
               this.m_View.scene.addChild(_loc4_.m_FRWheelObject);
               this.m_View.scene.addChild(_loc4_.m_BLWheelObject);
               this.m_View.scene.addChild(_loc4_.m_BRWheelObject);
               if(!RockRacer.GameCommon.g_SingleGame)
               {
                  _loc7_ = 0;
                  while(_loc7_ < RLoadingCourse.m_multiUsers.length)
                  {
                     if(RLoadingCourse.m_multiUsers[_loc7_].uid == param1.m_userId)
                     {
                        _loc6_ = RLoadingCourse.m_multiUsers[_loc7_];
                     }
                     _loc7_++;
                  }
                  _loc8_ = 0;
                  while(_loc8_ < RockRacer.GameCommon.m_PlayerPictureMgr.Pic.length)
                  {
                     if(_loc6_.picsquare == RockRacer.GameCommon.m_PlayerPictureMgr.Pic[_loc8_].url)
                     {
                        _loc4_.SetPicture(RockRacer.GameCommon.m_PlayerPictureMgr.Pic[_loc8_].material);
                        this.m_View.scene.addChild(_loc4_.m_PlayerPicture);
                        break;
                     }
                     _loc8_++;
                  }
                  this.m_View.scene.addChild(_loc4_.m_photoFrame1);
                  this.m_View.scene.addChild(_loc4_.m_photoFrame2);
                  this.m_View.scene.addChild(_loc4_.m_photoFrame3);
                  this.m_View.scene.addChild(_loc4_.m_photoFrame4);
               }
               this.m_Object.push(_loc4_);
               this.m_CarList.push(_loc4_);
               _loc4_.m_Rank = this.m_CarList.length;
               break;
            case RObjectType.TREE1:
            case RObjectType.TREE2:
            case RObjectType.TREE3:
               (_loc5_ = new RTreasure(param1)).BuildGeom();
               _loc5_.m_CollisionType = true;
               this.m_View.scene.addChild(_loc5_.m_renderObject);
               this.m_Object.push(_loc5_);
         }
      }
      
      public function UpdateObject(param1:ROBJECTINFO) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Object.length)
         {
            if(this.m_Object[_loc2_].m_ObjID == param1.m_ObjectID)
            {
               this.m_Object[_loc2_].UpdateObjInfo(param1);
            }
            _loc2_++;
         }
      }
      
      public function DeleteObject(param1:ROBJECTINFO) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Object.length)
         {
            if(this.m_Object[_loc2_].m_ObjID == param1.m_ObjectID)
            {
               this.m_View.scene.removeChild(this.m_Object[_loc2_].m_renderObject);
               this.m_Object.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function GetObjectID(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Object.length)
         {
            if(this.m_Object[_loc2_].m_ObjID == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function KeyDownHandler(param1:KeyboardEvent) : void
      {
         this.preKeyMask = this.KeyMask;
         switch(param1.keyCode)
         {
            case Keyboard.UP:
               this.KeyMask |= KEY_UP;
               break;
            case Keyboard.DOWN:
               this.KeyMask |= KEY_DOWN;
               break;
            case Keyboard.LEFT:
               this.KeyMask |= KEY_LEFT;
               break;
            case Keyboard.RIGHT:
               this.KeyMask |= KEY_RIGHT;
               break;
            case Keyboard.SPACE:
               if(this.weaponView.currentState != RWeaponView.STATE_COMPLETVIEW && this.m_RenderMode == RENDER_PLAYING)
               {
                  this.m_CarList[this.m_PlayerID].PlayHornkSound();
               }
         }
      }
      
      public function KeyUpHandler(param1:KeyboardEvent) : void
      {
         this.preKeyMask = this.KeyMask;
         switch(param1.keyCode)
         {
            case Keyboard.UP:
               this.KeyMask &= ~KEY_UP;
               break;
            case Keyboard.DOWN:
               this.KeyMask &= ~KEY_DOWN;
               break;
            case Keyboard.LEFT:
               this.KeyMask &= ~KEY_LEFT;
               break;
            case Keyboard.RIGHT:
               this.KeyMask &= ~KEY_RIGHT;
               break;
            case Keyboard.SPACE:
               if(!this.pause)
               {
                  if(this.weaponView.currentState == RWeaponView.STATE_COMPLETVIEW)
                  {
                     if(!this.m_CarList[this.m_PlayerID].UseBonus())
                     {
                        return;
                     }
                     this.BonusUseFlag = true;
                     this.weaponView.stopSelecting();
                  }
               }
               break;
            case Keyboard.ESCAPE:
               if(this.m_isQuitEnable == true)
               {
                  if(RockRacer.GameCommon.g_SingleGame)
                  {
                     if(!this.m_QuitWindowEnable)
                     {
                        if(this.m_RenderMode != RENDER_READY)
                        {
                           this.QuitWindowFunc();
                        }
                     }
                     else
                     {
                        this.CancelFunc(param1);
                     }
                     break;
                  }
               }
         }
      }
      
      public function HandleInputLoop() : void
      {
         if(this.m_RenderMode != RENDER_PLAYING || this.m_CarList[this.m_PlayerID].m_AI.m_CurState != RAI.AI_IDLE)
         {
            return;
         }
         if(this.m_RenderMode == RENDER_SCORE)
         {
            return;
         }
         if(this.oil < 1)
         {
            this.m_CarList[this.m_PlayerID].StopAccel();
            if(this.m_CarList[this.m_PlayerID].currState.vel.length < 10)
            {
               this.QuitWindowFunc(2);
            }
            return;
         }
         if(this.preKeyMask != this.KeyMask && !RockRacer.GameCommon.g_SingleGame && this.m_CarList[this.m_PlayerID].isCarStop == false && this.m_CarList[this.m_PlayerID].isCarOut == false)
         {
            Client.sendState([MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.z),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.z),this.m_CarList[this.m_PlayerID].currState.actionState,this.m_CarList[this.m_PlayerID].currState.animState,this.KeyMask,this.m_CarList[this.m_PlayerID].m_msgCount++,MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.z),this.m_CarList[this.m_PlayerID].m_bBA,this.m_CarList[this.m_PlayerID].m_DestPath]);
            m_sendTime = getTimer();
         }
         this.preKeyMask = this.KeyMask;
         if(this.KeyMask & KEY_UP && !(this.KeyMask & KEY_DOWN))
         {
            this.m_CarList[this.m_PlayerID].SpeedUp();
            this.m_StartFlag = true;
            --this.oil;
            this.mc_InfoWnd.mc_Oil.gotoAndStop(Math.round(this.oil / this.maxOil * 100));
         }
         if(this.KeyMask & KEY_DOWN && !(this.KeyMask & KEY_UP))
         {
            this.m_CarList[this.m_PlayerID].SpeedDown();
            this.m_StartFlag = true;
            --this.oil;
            this.mc_InfoWnd.mc_Oil.gotoAndStop(Math.round(this.oil / this.maxOil * 100));
         }
         if(this.KeyMask & KEY_LEFT && !(this.KeyMask & KEY_RIGHT))
         {
            this.m_CarList[this.m_PlayerID].TurnLeft();
            this.m_StartFlag = true;
         }
         if(this.KeyMask & KEY_RIGHT && !(this.KeyMask & KEY_LEFT))
         {
            this.m_CarList[this.m_PlayerID].TurnRight();
            this.m_StartFlag = true;
         }
         if(!(this.KeyMask & (KEY_UP | KEY_DOWN)))
         {
            this.m_CarList[this.m_PlayerID].StopAccel();
         }
         if(!(this.KeyMask & (KEY_LEFT | KEY_RIGHT)))
         {
            this.m_CarList[this.m_PlayerID].ReturnCenter();
         }
         if(!(this.KeyMask & (KEY_LEFT | KEY_RIGHT | KEY_UP | KEY_DOWN)))
         {
            this.m_CarList[this.m_PlayerID].Idle();
         }
      }
      
      public function otherHandleInputLoop(param1:Number, param2:int) : void
      {
         if(param1 & KEY_UP && !(param1 & KEY_DOWN))
         {
            this.m_CarList[param2].SpeedUp();
         }
         if(param1 & KEY_DOWN && !(param1 & KEY_UP))
         {
            this.m_CarList[param2].SpeedDown();
         }
         if(param1 & KEY_LEFT && !(param1 & KEY_RIGHT))
         {
            this.m_CarList[param2].TurnLeft();
         }
         if(param1 & KEY_RIGHT && !(param1 & KEY_LEFT))
         {
            this.m_CarList[param2].TurnRight();
         }
         if(!(param1 & (KEY_UP | KEY_DOWN)))
         {
            this.m_CarList[param2].StopAccel();
         }
         if(!(param1 & (KEY_LEFT | KEY_RIGHT)))
         {
            this.m_CarList[param2].ReturnCenter();
         }
         if(!(param1 & (KEY_LEFT | KEY_RIGHT | KEY_UP | KEY_DOWN)))
         {
            this.m_CarList[param2].Idle();
         }
      }
      
      protected function AllTickLoop() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.m_Object.length)
         {
            this.m_Object[_loc1_].Tick();
            _loc1_++;
         }
         this.m_SpecialEffect.m_ParticleManager.Tick();
      }
      
      protected function CollisionLoop() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Vector3D = null;
         var _loc8_:REffectData = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_Object.length - 1)
         {
            _loc4_ = _loc3_ + 1;
            while(_loc4_ < this.m_Object.length)
            {
               if(!RockRacer.GameCommon.g_SingleGame && this.m_Object[_loc2_].m_AI != null && this.m_Object[_loc4_].m_AI != null)
               {
                  if(this.m_Object[_loc2_] is RPlayerCar && this.m_Object[_loc4_].m_AI.m_Hit)
                  {
                     if(this.m_Object[_loc2_] == this.m_Object[_loc4_].m_AI.m_DestObject)
                     {
                        this.m_Object[_loc4_].currState.loc.x = this.m_Object[_loc2_].currState.loc.x;
                        this.m_Object[_loc4_].currState.loc.y = this.m_Object[_loc2_].currState.loc.y;
                        this.m_Object[_loc4_].currState.loc.z = this.m_Object[_loc2_].currState.loc.z;
                        this.m_Object[_loc2_].CollisionProc(this.m_Object[_loc4_]);
                        this.m_Object[_loc4_].CollisionProc(this.m_Object[_loc2_]);
                        this.DeleteObject(this.m_Object[_loc4_]);
                        _loc1_ = true;
                     }
                  }
               }
               if(_loc1_)
               {
                  break;
               }
               _loc4_++;
            }
            if(_loc1_)
            {
               break;
            }
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_Object.length - 1)
         {
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < this.m_Object.length)
            {
               if(this.m_Object[_loc3_].CollisionTest(this.m_Object[_loc5_]) && this.m_Object[_loc5_].CollisionTest(this.m_Object[_loc3_]))
               {
                  if(!(RockRacer.GameCommon.g_SingleGame == false && !(this.m_Object[_loc3_] is RPlayerCar) && !(this.m_Object[_loc5_] is RPlayerCar)))
                  {
                     if(RockRacer.GameCommon.g_SingleGame == false)
                     {
                        if(!(this.m_Object[_loc3_] is RPlayerCar) && !(this.m_Object[_loc3_] is RAICar))
                        {
                           Client.getItem([_loc3_]);
                        }
                        if(!(this.m_Object[_loc5_] is RPlayerCar) && !(this.m_Object[_loc5_] is RAICar))
                        {
                           Client.getItem([_loc5_]);
                        }
                     }
                     this.m_Object[_loc3_].CollisionProc(this.m_Object[_loc5_]);
                     this.m_Object[_loc5_].CollisionProc(this.m_Object[_loc3_]);
                  }
               }
               _loc5_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_Object.length)
         {
            if(this.m_Object[_loc3_].m_ObjType == RObjectType.AICAR || this.m_Object[_loc3_].m_ObjType == RObjectType.PLAYERCAR)
            {
               if((_loc7_ = this.m_CollisionWall.CollisionProc(this.m_Object[_loc3_],0)) != null)
               {
                  this.m_Object[_loc3_].SetAction(RActionState.COLLISION_WALL);
                  (_loc8_ = new REffectData(RSpecialEffectType.OBJECT_COLLISION_EFFECT,this.m_Object[_loc3_].currState,null)).m_car = this.m_Object[_loc3_];
                  _loc8_.collpos = _loc7_;
                  this.m_SpecialEffect.EffectProcess(_loc8_);
               }
            }
            else
            {
               _loc7_ = this.m_CollisionWall.CollisionProc(this.m_Object[_loc3_],1);
            }
            _loc3_++;
         }
      }
      
      protected function UpdateSceneLoop() : void
      {
         this.m_Terrain.UpdateScene(0,this.m_CarList[this.m_PlayerID].currState.loc.x,this.m_CarList[this.m_PlayerID].currState.loc.z);
         this.m_Boundary.UpdateScene(0,this.m_CarList[this.m_PlayerID].currState.loc.x,this.m_CarList[this.m_PlayerID].currState.loc.z);
         if(this.m_Sea != null)
         {
            this.m_Sea.UpdateScene(0,this.m_CarList[this.m_PlayerID].currState.loc.x,this.m_CarList[this.m_PlayerID].currState.loc.z);
         }
         this.m_Sky.UVAnimation();
      }
      
      protected function CameraControlLoop() : void
      {
         var _loc1_:RCar = null;
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Number = NaN;
         _loc1_ = this.m_CarList[this.m_PlayerID];
         switch(this.m_CameraMode)
         {
            case READY:
               _loc2_ = new Vector3D(_loc1_.m_renderObject.transform.n13,_loc1_.m_renderObject.transform.n23,_loc1_.m_renderObject.transform.n33);
               _loc2_.y = 0;
               _loc2_.scaleBy(-(200 + _loc1_.currState.vel.length * 3));
               _loc2_ = _loc2_.add(_loc1_.currState.loc);
               this.m_View.camera.x = _loc2_.x;
               this.m_View.camera.y = _loc1_.currState.loc.y + 200;
               this.m_View.camera.z = _loc2_.z;
               _loc1_.m_renderObject.y += 150;
               this.m_View.camera.lookAt(_loc1_.m_renderObject);
               _loc1_.m_renderObject.y -= 150;
               break;
            case FALLING:
               _loc2_ = new Vector3D(_loc1_.m_renderObject.transform.n13,_loc1_.m_renderObject.transform.n23,_loc1_.m_renderObject.transform.n33);
               _loc2_.y = 0;
               _loc2_.scaleBy(-(500 + _loc1_.currState.vel.length * 3));
               _loc2_ = _loc2_.add(_loc1_.currState.loc);
               this.m_View.camera.x = _loc2_.x;
               this.m_View.camera.y = _loc1_.currState.loc.y + 200;
               this.m_View.camera.z = _loc2_.z;
               _loc1_.m_renderObject.y += 150;
               this.m_View.camera.lookAt(_loc1_.m_renderObject);
               _loc1_.m_renderObject.y -= 150;
               break;
            case GO:
               _loc3_ = new Vector3D();
               _loc3_.x = this.m_View.camera.x;
               _loc3_.y = _loc1_.currState.loc.y;
               _loc3_.z = this.m_View.camera.z;
               _loc3_ = _loc1_.currState.loc.subtract(_loc3_);
               if((_loc4_ = _loc3_.length) < (150 + _loc1_.currState.vel.length) * this.m_CameraRate)
               {
                  _loc1_.m_renderObject.y += 150;
                  this.m_View.camera.lookAt(_loc1_.m_renderObject);
                  _loc1_.m_renderObject.y -= 150;
                  return;
               }
               if(_loc4_ != 0)
               {
                  _loc3_.scaleBy((_loc4_ - (150 + _loc1_.currState.vel.length) * this.m_CameraRate) / _loc4_);
               }
               this.m_View.camera.x += _loc3_.x;
               this.m_View.camera.z += _loc3_.z;
               this.m_View.camera.y = _loc1_.preState.loc.y + 200;
               _loc1_.m_renderObject.y += 150;
               this.m_View.camera.lookAt(_loc1_.m_renderObject);
               _loc1_.m_renderObject.y -= 150;
               break;
         }
      }
      
      protected function ParticleRefreshLoop() : void
      {
         this.m_SpecialEffect.m_ParticleManager.removeAllParticles();
      }
      
      public function VisibleLoop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.m_CarList[this.m_PlayerID].currState.loc.x;
         _loc2_ = this.m_CarList[this.m_PlayerID].currState.loc.z;
         if(_loc1_ < this.m_Terrain.m_MinLoc.x || _loc1_ > this.m_Terrain.m_MaxLoc.x || _loc2_ < this.m_Terrain.m_MinLoc.z || _loc2_ > this.m_Terrain.m_MaxLoc.z)
         {
            return;
         }
         _loc3_ = Math.abs(_loc1_ - this.m_Terrain.m_resMap.m_GridMin.x) / this.m_Terrain.m_resMap.m_GrideSpaceX;
         _loc4_ = Math.abs(_loc2_ - this.m_Terrain.m_resMap.m_GridMin.z) / this.m_Terrain.m_resMap.m_GrideSpaceZ;
         this.cellID = _loc4_ * this.m_Terrain.m_resMap.m_GrideDivision + _loc3_;
         var _loc5_:int = 0;
         while(_loc5_ < this.m_Object.length)
         {
            this.m_Object[_loc5_].SetVisibleState(this.m_Terrain.m_resMap,this.cellID);
            _loc5_++;
         }
      }
      
      public function RefreshGame() : void
      {
         this.HandleInputLoop();
         this.AllTickLoop();
         this.CollisionLoop();
      }
      
      public function Loop(param1:Event) : void
      {
         var i:int = 0;
         var e:Event = param1;
         if(getTimer() - m_sendTime >= 500 && this.m_RenderMode == RENDER_PLAYING)
         {
            if(this.m_CarList[this.m_PlayerID].currState.actionState != RActionState.AUTOPILOT_PLAY && this.m_CarList[this.m_PlayerID].isCarStop == false && this.m_CarList[this.m_PlayerID].isCarOut == false)
            {
               Client.sendState([MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.z),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.z),this.m_CarList[this.m_PlayerID].currState.actionState,this.m_CarList[this.m_PlayerID].currState.animState,this.KeyMask,this.m_CarList[this.m_PlayerID].m_msgCount++,MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.z),this.m_CarList[this.m_PlayerID].m_bBA,this.m_CarList[this.m_PlayerID].m_DestPath]);
               m_sendTime = getTimer();
            }
         }
         try
         {
            this.RenderObjectLoop();
            while(getTimer() - this.preticktime > this.TIMEPERFRAME)
            {
               if(!this.pause)
               {
                  this.RefreshGame();
               }
               this.preticktime += this.TIMEPERFRAME;
            }
            this.CameraControlLoop();
            this.UpdateSceneLoop();
            this.VisibleLoop();
            if(!this.pause)
            {
               this.decidePosInMap();
            }
            this.LODLoop();
         }
         catch(err:Error)
         {
            trace("RGameClient->" + err);
         }
         var rs2:RenderStatistics = this.m_View.renderer.renderScene(this.m_View.scene,this.m_View.camera,this.m_View.viewport);
         var rs3:Number = rs2.triangles;
         var curTime:int = getTimer();
         var tTime:int = curTime - RLoadingCourse.gameStartTime - RLoadingCourse.gameReadyTime;
         var totalTime:int = 5000;
         this.m_ReadyCounter.gotoAndStop(2 + int(65 * tTime / totalTime));
         if(this.m_RenderMode == RENDER_READY && this.m_ReadyCounter.currentFrame >= 65)
         {
            i = 0;
            while(i < this.m_CarList.length)
            {
               this.m_CarList[i].m_LapTimes.splice(0);
               this.m_CarList[i].m_LapTimes.push(getTimer());
               this.m_CarList[i].hit = true;
               if(this.m_CarList[i].m_ObjType == RObjectType.AICAR)
               {
                  this.m_CarList[i].SetAIState(RAI.AI_FOLLOWPATH);
               }
               i++;
            }
            this.m_RenderMode = RENDER_PLAYING;
            if(!RockRacer.GameCommon.g_SingleGame && this.m_CarList[this.m_PlayerID].isCarStop == false && this.m_CarList[this.m_PlayerID].isCarOut == false)
            {
               Client.sendState([MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.loc.z),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.pose.z),this.m_CarList[this.m_PlayerID].currState.actionState,this.m_CarList[this.m_PlayerID].currState.animState,this.KeyMask,this.m_CarList[this.m_PlayerID].m_msgCount++,MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.x),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.y),MsgNum(this.m_CarList[this.m_PlayerID].currState.vel.z),this.m_CarList[this.m_PlayerID].m_bBA,this.m_CarList[this.m_PlayerID].m_DestPath]);
               m_sendTime = getTimer();
            }
            setTimeout(this.rmvObj,3000,this.m_ReadyCounter);
            this.m_TimerView.startTime();
            this.m_CameraMode = GO;
            this.m_LapView.setPlayerLab(1,true);
         }
         else if(this.m_RenderMode != RENDER_PLAYING)
         {
            if(this.m_RenderMode == RENDER_SCORE)
            {
               this.m_TimerView.stopTime();
               this.timeoutTime = -1;
               this.m_scMask.play();
               ++this.m_FadeEndScreen;
               if(this.m_scMask.currentFrame > 10)
               {
                  this.m_scMask.stop();
                  this.m_RenderMode = RENDER_END;
                  RockRacer.GameCommon.createPage(RCongrate);
                  this.DestroyScene();
                  if(!RockRacer.GameCommon.g_SingleGame)
                  {
                     removeEventListener(Event.ENTER_FRAME,this.Loop);
                  }
               }
            }
            else if(this.m_RenderMode == RENDER_END)
            {
               this.m_CarList[this.m_PlayerID].StopEngineSound();
            }
         }
         if(this.timeoutTime > 0 && this.timeoutTime < this.m_TimerView.time)
         {
            this.timeoutTime = -1;
            this.timeoutFunction(this.timeoutArg);
         }
      }
      
      private function rmvObj(param1:MovieClip) : void
      {
         removeChild(param1);
         this.m_isQuitEnable = true;
      }
      
      protected function LODLoop() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_CarList.length)
         {
            if(this.m_CarList[_loc1_].m_isDelete == false)
            {
               if(this.m_CarList[_loc1_].currState.actionState != RActionState.AUTOPILOT_PLAY)
               {
                  _loc2_ = Vector3D.distance(this.m_CarList[_loc1_].currState.loc,this.m_CarList[this.m_PlayerID].currState.loc);
                  if(this.MiddleDist > _loc2_)
                  {
                     this.m_CarList[_loc1_].VisibleHighModel();
                  }
                  else if(this.LowDist > _loc2_)
                  {
                     this.m_CarList[_loc1_].VisibleMiddleModel();
                  }
                  else
                  {
                     this.m_CarList[_loc1_].VisibleLowModel();
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function decidePosInMap() : void
      {
         var _loc1_:Number = Math.abs(this.m_Terrain.m_gridMinLoc.x);
         var _loc2_:Number = Math.abs(this.m_Terrain.m_gridMinLoc.z);
         var _loc3_:int = 0;
         while(_loc3_ < this.m_CarList.length)
         {
            RMinicar(this.miniCars[_loc3_]).x = (this.m_CarList[_loc3_].currState.loc.x + _loc1_) / 2809;
            RMinicar(this.miniCars[_loc3_]).y = this.m_minMapHeight - (this.m_CarList[_loc3_].currState.loc.z + _loc2_) / 2809 + 50;
            if(this.m_CarList[_loc3_].currState.actionState == RActionState.BEATEN)
            {
               RMinicar(this.miniCars[_loc3_]).character.play();
            }
            else if(_loc3_ == this.m_PlayerID)
            {
               RMinicar(this.miniCars[_loc3_]).character.gotoAndStop(6);
            }
            else
            {
               RMinicar(this.miniCars[_loc3_]).character.gotoAndStop(1);
            }
            _loc3_++;
         }
      }
      
      public function Snap(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            param1 = param2;
         }
         if(param1 > param3)
         {
            param1 = param3;
         }
         return param1;
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:String = null;
         if(this.m_CarList.length > this.m_PlayerID)
         {
            _loc1_ = "$GAME_RANK_INGAME" + String(this.m_CarList[this.m_PlayerID].m_Rank);
            this.m_RankView.txtText.htmlText = RockRacer.GameCommon.GetTextFunc(_loc1_);
         }
      }
      
      protected function EscapeFunc(param1:Event) : void
      {
         if(this.m_isQuitEnable == true)
         {
            if(RockRacer.GameCommon.g_SingleGame)
            {
               if(this.m_RenderMode != RENDER_READY)
               {
                  this.QuitWindowFunc();
               }
            }
            else
            {
               this.QuitFunc(new Event("quit"));
               removeEventListener(Event.ENTER_FRAME,this.Loop);
               Client.gameOver([]);
               Client.funcs = {};
            }
         }
      }
      
      public function QuitWindowFunc(param1:int = 1) : void
      {
         var flag:int = param1;
         if(this.m_RenderMode == RGameClient.RENDER_SCORE || this.m_RenderMode == RGameClient.RENDER_END)
         {
            return;
         }
         if(this.pause)
         {
            return;
         }
         this.pause = true;
         if(!this.m_QuitWindowEnable)
         {
            RockRacer.GameCommon.SetBackSoundVolume(0);
            this.StopEngineSound();
            with(this.m_QuitWindow)
            {
               
               x = 0;
               y = 0;
            }
            this.m_QuitWindow.gotoAndStop(flag);
            addChild(this.m_QuitWindow);
            this.m_QuitWindow.BTT_Cancel.addEventListener(MouseEvent.CLICK,this.CancelFunc);
            this.m_QuitWindow.BTT_Quit.addEventListener(MouseEvent.CLICK,this.QuitFunc);
            this.m_QuitWindow.BTT_Restart.addEventListener(MouseEvent.CLICK,this.RestartFunc);
            this.m_QuitWindowEnable = true;
         }
      }
      
      protected function QuitFunc(param1:Event) : void
      {
         this.timeoutTime = -1;
         this.m_TutorialSpace.splice(0);
         RockRacer.GameCommon.EmptyScores();
         this.m_LapView.setPlayerLab(1);
         this.CancelFunc(null);
         this.DestroyScene();
         this.m_RenderMode = RENDER_ABORT;
         this.m_ReadyCounter.gotoAndStop(1);
      }
      
      protected function RestartFunc(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         RockRacer.GameCommon.EmptyScores();
         _loc2_ = 0;
         while(_loc2_ < this.m_CarList.length)
         {
            _loc5_ = new Vector3D();
            _loc5_ = this.m_Terrain.m_path.m_lPath[1].subtract(this.m_Terrain.m_path.m_lPath[0]);
            _loc6_ = Math.atan(_loc5_.x / _loc5_.z);
            _loc7_ = Math.cos(_loc6_);
            _loc8_ = Math.sin(_loc6_);
            _loc6_ = _loc6_ * 180 / Math.PI;
            if(_loc5_.z < 0)
            {
               _loc6_ += 180;
            }
            if(_loc6_ < 0)
            {
               _loc6_ += 360;
               _loc7_ = -_loc7_;
               _loc8_ = -_loc8_;
            }
            this.m_CarList[_loc2_].currState.pose.x = 0;
            this.m_CarList[_loc2_].currState.pose.y = _loc6_;
            this.m_CarList[_loc2_].currState.pose.z = 0;
            this.m_CarList[_loc2_].m_BonusID = RObjectType.NONE_BONUS;
            this.m_CarList[_loc2_].m_Lap = 0;
            this.m_CarList[_loc2_].m_LapTimes.splice(0);
            this.m_CarList[_loc2_].m_DestPath = 1;
            this.m_CarList[_loc2_].m_passPath = false;
            this.m_CarList[_loc2_].isCarStop = false;
            this.m_CarList[_loc2_].SetLoc(this.m_Terrain.m_path.m_lPath[0].x + (_loc2_ - 2) * 150 * (_loc8_ + _loc7_),this.m_Terrain.GetHeightInfo(this.m_Terrain.m_path.m_lPath[0].x,this.m_Terrain.m_path.m_lPath[0].z),this.m_Terrain.m_path.m_lPath[0].z + _loc2_ * 150 * (_loc7_ - _loc8_));
            this.m_CarList[_loc2_].ReleaseAction();
            this.m_CarList[_loc2_].StopAccel();
            this.m_CarList[_loc2_].m_BonusAcc = 0;
            this.m_CarList[_loc2_].m_BoosterAcc = 0;
            this.m_CarList[_loc2_].m_AIAcc = 0;
            this.m_CarList[_loc2_].currState.vel.scaleBy(0);
            this.m_CarList[_loc2_].currState.actionState = RActionState.NONE;
            this.m_CarList[_loc2_].currState.animState = RPlayerAnimState.CarIsIdle;
            this.m_CarList[_loc2_].SetAIState(RAI.AI_IDLE);
            this.m_CarList[_loc2_].m_bGuideDir = false;
            this.m_CarList[_loc2_].m_bGuideWrong = false;
            this.m_CarList[_loc2_].m_bInfo = false;
            _loc2_++;
         }
         var _loc3_:int = this.m_CarList[this.m_CarList.length - 1].m_ObjID + 1;
         var _loc4_:int = this.m_Object.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            switch(this.m_Object[_loc2_].m_ObjType)
            {
               case RObjectType.TREE1:
               case RObjectType.TREE2:
               case RObjectType.TREE3:
               case RObjectType.HOUSE1:
                  this.m_Object[_loc2_].hit = true;
                  break;
            }
            _loc2_++;
         }
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            this.m_Object[_loc2_].DeleteObject();
            _loc2_++;
         }
         this.m_CameraMode = READY;
         this.oil = this.maxOil;
         this.m_scMask.gotoAndStop(0);
         this.m_mudman.visible = false;
         this.m_mudman.gotoAndStop(0);
         this.m_lightman.visible = false;
         this.m_lightman.gotoAndStop(0);
         this.Squirrel.visible = false;
         this.Squirrel.gotoAndStop(0);
         this.weaponView.stopSelecting();
         this.m_TimerView.stopTime();
         this.m_TimerView.time = 0;
         this.m_LapView.setPlayerLab(1);
         addChild(this.m_ReadyCounter);
         this.m_ReadyCounter.x = m_ViewportWidth / 2;
         this.m_ReadyCounter.y = m_ViewportHeight / 2;
         setTimeout(this.m_ReadyCounter.gotoAndPlay,40,2);
         this.m_RenderMode = RENDER_READY;
         this.m_ReadyCounter.gotoAndStop(1);
         this.mc_GuideWnd.gotoAndStop(1);
         this.mc_InfoWnd.initCounter();
         this.mc_InfoWnd.gotoAndStop(1);
         this.timeoutTime = -1;
         this.CancelFunc(null);
         RLoadingCourse.gameStartTime = getTimer() - RLoadingCourse.gameReadyTime;
         this.m_isQuitEnable = false;
      }
      
      protected function CancelFunc(param1:Event) : void
      {
         if(RockRacer.GameCommon.m_SoundOnOff)
         {
            RockRacer.GameCommon.SetBackSoundVolume(1);
         }
         if(RockRacer.GameCommon.g_SingleGame)
         {
            removeChild(this.m_QuitWindow);
            this.m_QuitWindowEnable = false;
            this.m_QuitWindow.BTT_Cancel.removeEventListener(MouseEvent.CLICK,this.CancelFunc);
            this.m_QuitWindow.BTT_Quit.removeEventListener(MouseEvent.CLICK,this.QuitFunc);
            this.m_QuitWindow.BTT_Restart.removeEventListener(MouseEvent.CLICK,this.RestartFunc);
            this.pause = false;
         }
      }
      
      protected function StopEngineSound() : void
      {
         if(this.m_CarList.length > this.m_PlayerID)
         {
            this.m_CarList[this.m_PlayerID].StopEngineSound();
         }
      }
      
      public function setTimeoutFunction(param1:Function, param2:int, param3:Boolean) : void
      {
         this.timeoutTime = this.m_TimerView.time + param2;
         this.timeoutFunction = param1;
         this.timeoutArg = param3;
      }
      
      public function addOil() : void
      {
         this.oil += 300;
         if(this.oil > this.maxOil)
         {
            this.oil = this.maxOil;
         }
      }
   }
}
