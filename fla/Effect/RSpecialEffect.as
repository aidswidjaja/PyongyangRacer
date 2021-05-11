package Effect
{
   import Const.RSpecialEffectType;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import flash.utils.getDefinitionByName;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.materials.special.BitmapParticleMaterial;
   
   public class RSpecialEffect extends MovieClip
   {
      
      public static var m_lParticleMaterials:Array;
       
      
      private const SCREEN_WIDTH:int = 760;
      
      private const SCREEN_HEIGHT:int = 500;
      
      private const SHELD_EFFECT:int = 1;
      
      private const LIGHTING_EFFECT:int = 2;
      
      private const EXPLODE_EFFECT:int = 4;
      
      private const BONUS_EFFECT:int = 8;
      
      private var ParticleState:int = 0;
      
      private var m_playerLapCount:int = 0;
      
      private var m_EffectData:REffectData;
      
      public var m_ParticleManager:GameParticles;
      
      public var m_FrameCnt:int;
      
      public var m_ActionType:int = -1;
      
      public function RSpecialEffect()
      {
         var _loc1_:Class = null;
         this.m_EffectData = new REffectData(0,null,null);
         super();
         this.m_ParticleManager = new GameParticles();
         m_lParticleMaterials = new Array(42);
         _loc1_ = this.GetClassInSWF("LeafBitmap1");
         m_lParticleMaterials[0] = new BitmapParticleMaterial(new _loc1_(30,48));
         _loc1_ = this.GetClassInSWF("dust_image");
         m_lParticleMaterials[1] = new BitmapParticleMaterial(new _loc1_(100,100),1,-50,-50);
         _loc1_ = this.GetClassInSWF("white_smog");
         m_lParticleMaterials[2] = new BitmapParticleMaterial(new _loc1_(100,100),1,-50,-50);
         _loc1_ = this.GetClassInSWF("red_smog");
         m_lParticleMaterials[3] = new BitmapParticleMaterial(new _loc1_(100,100),1,-50,-50);
         _loc1_ = this.GetClassInSWF("black_smog");
         m_lParticleMaterials[4] = new BitmapParticleMaterial(new _loc1_(100,100),1,-50,-50);
         _loc1_ = this.GetClassInSWF("eneMap0");
         m_lParticleMaterials[10] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap1");
         m_lParticleMaterials[11] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap2");
         m_lParticleMaterials[12] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap3");
         m_lParticleMaterials[13] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap4");
         m_lParticleMaterials[14] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap5");
         m_lParticleMaterials[15] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap6");
         m_lParticleMaterials[16] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap7");
         m_lParticleMaterials[17] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap8");
         m_lParticleMaterials[18] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("eneMap9");
         m_lParticleMaterials[19] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("electricMap0");
         m_lParticleMaterials[20] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap1");
         m_lParticleMaterials[21] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap2");
         m_lParticleMaterials[22] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap3");
         m_lParticleMaterials[23] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap4");
         m_lParticleMaterials[24] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap5");
         m_lParticleMaterials[25] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap7");
         m_lParticleMaterials[26] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap8");
         m_lParticleMaterials[27] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap9");
         m_lParticleMaterials[28] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap10");
         m_lParticleMaterials[29] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap11");
         m_lParticleMaterials[30] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap12");
         m_lParticleMaterials[31] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap13");
         m_lParticleMaterials[32] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("electricMap14");
         m_lParticleMaterials[33] = new BitmapParticleMaterial(new _loc1_(320,240),1,-150,-180);
         _loc1_ = this.GetClassInSWF("bonusMap0");
         m_lParticleMaterials[34] = new BitmapParticleMaterial(new _loc1_(320,240),1,-140,-120);
         _loc1_ = this.GetClassInSWF("bonusMap1");
         m_lParticleMaterials[35] = new BitmapParticleMaterial(new _loc1_(320,240),1,-140,-120);
         _loc1_ = this.GetClassInSWF("bonusMap2");
         m_lParticleMaterials[36] = new BitmapParticleMaterial(new _loc1_(215,175),1,-106,-118);
         _loc1_ = this.GetClassInSWF("bonusMap3");
         m_lParticleMaterials[37] = new BitmapParticleMaterial(new _loc1_(233,137),1,-120,-107);
         _loc1_ = this.GetClassInSWF("bonusMap4");
         m_lParticleMaterials[38] = new BitmapParticleMaterial(new _loc1_(216,130),1,-119,-94);
         _loc1_ = this.GetClassInSWF("bonusMap5");
         m_lParticleMaterials[39] = new BitmapParticleMaterial(new _loc1_(191,173),1,-101,-126);
         _loc1_ = this.GetClassInSWF("bonusMap6");
         m_lParticleMaterials[40] = new BitmapParticleMaterial(new _loc1_(264,174),1,-131,-106);
         _loc1_ = this.GetClassInSWF("shield_back");
         m_lParticleMaterials[41] = new BitmapParticleMaterial(new _loc1_(200,200),1,-100,-100);
         _loc1_ = this.GetClassInSWF("water_bubble");
         m_lParticleMaterials[42] = new BitmapParticleMaterial(new _loc1_(128,128),1,-64,-64);
         _loc1_ = this.GetClassInSWF("collision_flash2");
         m_lParticleMaterials[43] = new BitmapParticleMaterial(new _loc1_(120,126),1,-60,-63);
         _loc1_ = this.GetClassInSWF("Mud_Image");
         m_lParticleMaterials[45] = new BitmapParticleMaterial(new _loc1_(128,128),1,-64,-64);
         _loc1_ = this.GetClassInSWF("Mount_Image");
         m_lParticleMaterials[46] = new BitmapParticleMaterial(new _loc1_(128,128),1,-64,-64);
      }
      
      public function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public function EffectProcess(param1:REffectData) : void
      {
         if(param1.m_EffectType == -1)
         {
            return;
         }
         this.m_EffectData = param1;
         switch(this.m_EffectData.m_EffectType)
         {
            case RSpecialEffectType.SQUID_EFFECT:
            case RSpecialEffectType.WRONGWAY_EFFECT:
            case RSpecialEffectType.ACCEL_EFFECT:
            case RSpecialEffectType.CARRY_EFFECT:
            case RSpecialEffectType.GAME_END_EFFECT:
            case RSpecialEffectType.LAPSVIEW_EFFECT:
               this.ProcessMovieClip();
               break;
            case RSpecialEffectType.BONUS_BREAK_EFFECT:
            case RSpecialEffectType.OBJECT_COLLISION_EFFECT:
            case RSpecialEffectType.GRASS_BLOW_EFFECT:
            case RSpecialEffectType.MUD_BLOW_EFFECT:
            case RSpecialEffectType.OIL_BLOW_EFFECT:
            case RSpecialEffectType.MOUNT_BLOW_EFFECT:
            case RSpecialEffectType.WATER_BLOW_EFFECT:
            case RSpecialEffectType.BOOST_EFFECT:
            case RSpecialEffectType.DUST_BLOW_EFFECT:
               if(this.m_EffectData.m_car != null && this.m_EffectData.m_car.m_visiblelevel > 1)
               {
                  return;
               }
            case RSpecialEffectType.LIGHTING_EFFECT:
            case RSpecialEffectType.SHIELD_EFFECT:
            case RSpecialEffectType.AUTOPILOT_EFFECT:
               this.ProcessParticle();
         }
      }
      
      protected function ProcessMovieClip() : void
      {
         switch(this.m_EffectData.m_EffectType)
         {
            case RSpecialEffectType.SQUID_EFFECT:
               break;
            case RSpecialEffectType.WRONGWAY_EFFECT:
               break;
            case RSpecialEffectType.ACCEL_EFFECT:
               break;
            case RSpecialEffectType.CARRY_EFFECT:
               break;
            case RSpecialEffectType.GAME_END_EFFECT:
               break;
            case RSpecialEffectType.LAPSVIEW_EFFECT:
         }
      }
      
      protected function ProcessParticle() : void
      {
         var _loc1_:Particle = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Vector3D = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Vector3D = new Vector3D();
         if(this.m_EffectData.m_ObjEnt2 == null)
         {
            if(this.m_EffectData.collpos != null)
            {
               _loc2_.x = this.m_EffectData.collpos.x;
               _loc2_.y = this.m_EffectData.collpos.y;
               _loc2_.z = this.m_EffectData.collpos.z;
            }
            else
            {
               _loc2_.x = this.m_EffectData.m_ObjEnt1.loc.x;
               _loc2_.y = this.m_EffectData.m_ObjEnt1.loc.y;
               _loc2_.z = this.m_EffectData.m_ObjEnt1.loc.z;
            }
         }
         else
         {
            _loc2_.x = (this.m_EffectData.m_ObjEnt1.loc.x + this.m_EffectData.m_ObjEnt2.loc.x) / 2;
            _loc2_.y = (this.m_EffectData.m_ObjEnt1.loc.y + this.m_EffectData.m_ObjEnt2.loc.y) / 2;
            _loc2_.z = (this.m_EffectData.m_ObjEnt1.loc.z + this.m_EffectData.m_ObjEnt2.loc.z) / 2;
         }
         switch(this.m_EffectData.m_EffectType)
         {
            case RSpecialEffectType.SHIELD_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.SHIELD_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.AUTOPILOT_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.AUTOPILOT_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.BONUS_BREAK_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.BONUS_BREAK_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.LIGHTING_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.LIGHTING_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.OBJECT_COLLISION_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.OBJECT_COLLISION_EFFECT,_loc2_,this.m_EffectData);
               break;
            case RSpecialEffectType.BOOST_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.BOOST_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.DUST_BLOW_EFFECT:
               this.m_ParticleManager.Add(RSpecialEffectType.DUST_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
               break;
            case RSpecialEffectType.GRASS_BLOW_EFFECT:
               _loc9_ = Math.floor(Math.random() * 6.9 * this.m_EffectData.m_ObjEnt1.vel.length / this.m_EffectData.m_car.m_MaxVel);
               _loc3_ = 0;
               while(_loc3_ < _loc9_)
               {
                  this.m_ParticleManager.Add(RSpecialEffectType.GRASS_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
                  _loc3_++;
               }
               break;
            case RSpecialEffectType.WATER_BLOW_EFFECT:
               _loc9_ = Math.floor(Math.random() * 2.9);
               _loc3_ = 0;
               while(_loc3_ < _loc9_)
               {
                  this.m_ParticleManager.Add(RSpecialEffectType.WATER_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
                  _loc3_++;
               }
               break;
            case RSpecialEffectType.OIL_BLOW_EFFECT:
               _loc9_ = Math.floor(Math.random() * 3.9);
               _loc3_ = 0;
               while(_loc3_ < _loc9_)
               {
                  this.m_ParticleManager.Add(RSpecialEffectType.OIL_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
                  _loc3_++;
               }
               break;
            case RSpecialEffectType.MUD_BLOW_EFFECT:
               _loc3_ = 0;
               while(_loc3_ < 2)
               {
                  this.m_ParticleManager.Add(RSpecialEffectType.MUD_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
                  _loc3_++;
               }
               break;
            case RSpecialEffectType.MOUNT_BLOW_EFFECT:
               _loc3_ = 0;
               while(_loc3_ < 2)
               {
                  this.m_ParticleManager.Add(RSpecialEffectType.MOUNT_BLOW_EFFECT,this.m_EffectData.m_ObjEnt1,this.m_EffectData.m_car);
                  _loc3_++;
               }
         }
      }
   }
}
