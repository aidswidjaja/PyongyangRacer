package Effect
{
   import Const.RActionState;
   import Const.RSpecialEffectType;
   import flash.geom.Vector3D;
   import object.EntState;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.materials.special.ParticleMaterial;
   import player.RCar;
   
   public class GameParticle extends Particle
   {
       
      
      public var started_time:int;
      
      public var during_time:int;
      
      public var curframe:int = 0;
      
      public var startframe:int;
      
      public var frame_num:int = 1;
      
      public var particle_class:int;
      
      public var owner:RCar;
      
      public var offset:Vector3D;
      
      public var vel:Vector3D;
      
      public var wheelindex:int;
      
      public var acc:Vector3D;
      
      public var initpos:Number3D;
      
      public var isRight:Boolean;
      
      public var curpos:int = 0;
      
      public function GameParticle(param1:int, param2:ParticleMaterial, param3:Number = 1, param4:Number = 0, param5:Number = 0, param6:Number = 0)
      {
         this.offset = new Vector3D();
         this.initpos = new Number3D();
         this.particle_class = param1;
         super(param2,param3,param4,param5,param6);
      }
      
      public function Tick(param1:* = null, param2:* = null) : Boolean
      {
         var _loc3_:EntState = null;
         var _loc4_:Vector3D = null;
         switch(this.particle_class)
         {
            case RSpecialEffectType.SHIELD_EFFECT:
               if(this.curframe == this.frame_num || this.owner.currState.actionState != RActionState.SHIELD_USE)
               {
                  return true;
               }
               _loc3_ = this.owner.currState;
               x = _loc3_.loc.x;
               y = _loc3_.loc.y + 70;
               z = _loc3_.loc.z;
               rotationZ = -_loc3_.pose.x;
               material = RSpecialEffect.m_lParticleMaterials[this.startframe + this.curframe];
               ++this.curframe;
               break;
            case RSpecialEffectType.BONUS_BREAK_EFFECT:
               if(this.curframe == this.frame_num)
               {
                  return true;
               }
               _loc3_ = this.owner.currState;
               size += 0.4;
               x = _loc3_.loc.x;
               y = _loc3_.loc.y + 110;
               z = _loc3_.loc.z;
               material = RSpecialEffect.m_lParticleMaterials[this.startframe + this.curframe];
               ++this.curframe;
               break;
            case RSpecialEffectType.LIGHTING_EFFECT:
               if(this.curframe == this.frame_num)
               {
                  return true;
               }
               _loc3_ = this.owner.currState;
               x = _loc3_.loc.x;
               y = _loc3_.loc.y + 110;
               z = _loc3_.loc.z;
               material = RSpecialEffect.m_lParticleMaterials[this.startframe + this.curframe];
               ++this.curframe;
               break;
            case RSpecialEffectType.OBJECT_COLLISION_EFFECT:
               if(this.curframe == this.frame_num)
               {
                  return true;
               }
               size *= 2;
               rotationZ = Math.random() * 360;
               ++this.curframe;
               break;
            case RSpecialEffectType.AUTOPILOT_EFFECT:
               if(size > 2)
               {
                  return true;
               }
               size += 0.2;
               rotationZ += 15;
               this.curpos += 80;
               if((_loc4_ = this.owner.currState.vel.clone()).length != 0)
               {
                  _loc4_.scaleBy(-this.curpos / _loc4_.length);
               }
               x = this.owner.currState.loc.x + _loc4_.x;
               y = this.owner.currState.loc.y + _loc4_.y + 160 + Math.sqrt(this.curpos / 20) * 20;
               z = this.owner.currState.loc.z + _loc4_.z;
               break;
            case RSpecialEffectType.GRASS_BLOW_EFFECT:
               if(this.offset.y < 0)
               {
                  return true;
               }
               if(!this.isRight)
               {
                  rotationZ += Math.random() * Math.abs(this.vel.y) + 20;
               }
               else
               {
                  rotationZ -= Math.random() * Math.abs(this.vel.y) + 20;
               }
               if(this.vel.x * this.vel.x + this.vel.z * this.vel.z < this.acc.x * this.acc.x + this.acc.z * this.acc.z)
               {
                  this.vel.x = 0;
                  this.vel.z = 0;
                  this.vel.y += this.acc.y;
               }
               else
               {
                  this.vel = this.vel.add(this.acc);
               }
               this.offset = this.offset.add(this.vel);
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
            case RSpecialEffectType.DUST_BLOW_EFFECT:
               if(size > 1)
               {
                  return true;
               }
               size += 0.1;
               rotationZ += Math.random() * 10 + 5;
               this.offset = this.offset.add(this.vel);
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
            case RSpecialEffectType.BOOST_EFFECT:
               if(size > 1)
               {
                  return true;
               }
               size += 0.1;
               rotationZ += Math.random() * 10 + 5;
               if(this.isRight)
               {
                  this.offset.x = (this.owner.m_BLWheelLoc.x * 2 + this.owner.m_BRWheelLoc.x) / 3;
                  this.offset.y = (this.owner.m_BLWheelLoc.y * 2 + this.owner.m_BRWheelLoc.y) / 3 + 10;
                  this.offset.z = (this.owner.m_BLWheelLoc.z * 2 + this.owner.m_BRWheelLoc.z) / 3;
               }
               else
               {
                  this.offset.x = (this.owner.m_BRWheelLoc.x * 2 + this.owner.m_BLWheelLoc.x) / 3;
                  this.offset.y = (this.owner.m_BRWheelLoc.y * 2 + this.owner.m_BLWheelLoc.y) / 3 + 10;
                  this.offset.z = (this.owner.m_BRWheelLoc.z * 2 + this.owner.m_BLWheelLoc.z) / 3;
               }
               if(this.curpos < -70)
               {
                  material = RSpecialEffect.m_lParticleMaterials[4];
               }
               this.curpos -= 20;
               if((_loc4_ = this.owner.currState.vel.clone()).length != 0)
               {
                  _loc4_.scaleBy(this.curpos / _loc4_.length);
               }
               x = _loc4_.x + this.offset.x;
               y = _loc4_.y + this.offset.y;
               z = _loc4_.z + this.offset.z;
               break;
            case RSpecialEffectType.WATER_BLOW_EFFECT:
               if(this.offset.y < -50)
               {
                  return true;
               }
               if(this.vel.x * this.vel.x + this.vel.z * this.vel.z < this.acc.x * this.acc.x + this.acc.z * this.acc.z)
               {
                  this.vel.x = 0;
                  this.vel.z = 0;
                  this.vel.y += this.acc.y;
               }
               else
               {
                  this.vel = this.vel.add(this.acc);
               }
               this.offset = this.offset.add(this.vel);
               size += 0.2;
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
            case RSpecialEffectType.OIL_BLOW_EFFECT:
               if(this.offset.y < 0)
               {
                  return true;
               }
               if(this.vel.x * this.vel.x + this.vel.z * this.vel.z < this.acc.x * this.acc.x + this.acc.z * this.acc.z)
               {
                  this.vel.x = 0;
                  this.vel.z = 0;
                  this.vel.y += this.acc.y;
               }
               else
               {
                  this.vel = this.vel.add(this.acc);
               }
               this.offset = this.offset.add(this.vel);
               size += 0.2;
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
            case RSpecialEffectType.MUD_BLOW_EFFECT:
               if(this.offset.y < 0)
               {
                  return true;
               }
               if(this.vel.x * this.vel.x + this.vel.z * this.vel.z < this.acc.x * this.acc.x + this.acc.z * this.acc.z)
               {
                  this.vel.x = 0;
                  this.vel.z = 0;
                  this.vel.y += this.acc.y;
               }
               else
               {
                  this.vel = this.vel.add(this.acc);
               }
               this.offset = this.offset.add(this.vel);
               size += 0.2;
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
            case RSpecialEffectType.MOUNT_BLOW_EFFECT:
               if(this.offset.y < 0)
               {
                  return true;
               }
               if(this.vel.x * this.vel.x + this.vel.z * this.vel.z < this.acc.x * this.acc.x + this.acc.z * this.acc.z)
               {
                  this.vel.x = 0;
                  this.vel.z = 0;
                  this.vel.y += this.acc.y;
               }
               else
               {
                  this.vel = this.vel.add(this.acc);
               }
               this.offset = this.offset.add(this.vel);
               size += 0.2;
               x = this.initpos.x + this.offset.x;
               y = this.initpos.y + this.offset.y;
               z = this.initpos.z + this.offset.z;
               break;
         }
         return false;
      }
   }
}
