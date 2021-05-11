package Effect
{
   import Const.RSpecialEffectType;
   import flash.geom.Vector3D;
   import object.EntState;
   import org.papervision3d.core.geom.Particles;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import player.RCar;
   
   public class GameParticles extends Particles
   {
       
      
      public function GameParticles(param1:String = "Particles")
      {
         super(param1);
      }
      
      public function Tick(param1:* = null, param2:* = null) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < particles.length)
         {
            if(particles[_loc3_].Tick(param1,param2))
            {
               removeParticle(particles[_loc3_]);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      public function Add(param1:uint, param2:* = null, param3:* = null) : void
      {
         var _loc4_:GameParticle = null;
         var _loc5_:EntState = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Vector3D = null;
         var _loc10_:REffectData = null;
         var _loc11_:Vector3D = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number3D = null;
         var _loc15_:int = 0;
         var _loc16_:Vector3D = null;
         switch(param1)
         {
            case RSpecialEffectType.SHIELD_EFFECT:
               _loc5_ = EntState(param2);
               _loc15_ = 0;
               while(_loc15_ < 2)
               {
                  _loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[10],1);
                  if(_loc15_ > 0)
                  {
                     _loc4_.startframe = 41;
                     _loc4_.frame_num = 1;
                     _loc4_.m_delta = -980;
                  }
                  else
                  {
                     _loc4_.startframe = 10;
                     _loc4_.frame_num = 10;
                     _loc4_.m_delta = -1100;
                  }
                  _loc4_.size = 2.4;
                  _loc4_.owner = RCar(param3);
                  addParticle(_loc4_);
                  _loc15_++;
               }
               break;
            case RSpecialEffectType.BONUS_BREAK_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[34],1)).startframe = 34;
               _loc4_.frame_num = 7;
               _loc4_.m_delta = -1020;
               _loc4_.size = 0.5;
               _loc4_.owner = RCar(param3);
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.LIGHTING_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[20],1)).startframe = 20;
               _loc4_.frame_num = 15;
               _loc4_.m_delta = -1000;
               _loc4_.size = 2;
               _loc4_.owner = RCar(param3);
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.OBJECT_COLLISION_EFFECT:
               _loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[43],1);
               _loc10_ = REffectData(param3);
               _loc9_ = Vector3D(param2);
               _loc4_.startframe = 43;
               _loc4_.frame_num = 2;
               _loc4_.x = _loc9_.x;
               _loc4_.y = _loc9_.y + 50;
               _loc4_.z = _loc9_.z;
               _loc4_.m_delta = -1000;
               (_loc11_ = _loc10_.m_ObjEnt1.vel.clone()).scaleBy(_loc10_.m_ObjEnt1.mass);
               if(_loc10_.m_ObjEnt2 != null)
               {
                  (_loc16_ = _loc10_.m_ObjEnt2.vel.clone()).scaleBy(_loc10_.m_ObjEnt2.mass);
                  _loc11_ = _loc11_.subtract(_loc16_);
                  _loc4_.size = _loc11_.length / 2000;
               }
               else
               {
                  _loc4_.size = _loc11_.length / 600;
               }
               if(isNaN(_loc4_.size))
               {
                  _loc4_.size = 0;
               }
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.AUTOPILOT_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[2],1)).rotationZ = Math.random() * 360;
               _loc4_.size = 0.6;
               _loc4_.m_delta = -1000;
               _loc4_.owner = RCar(param3);
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.BOOST_EFFECT:
               _loc5_ = EntState(param2);
               _loc15_ = 0;
               while(_loc15_ < 2)
               {
                  (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[3],1)).owner = RCar(param3);
                  _loc4_.isRight = _loc15_ == 0;
                  _loc4_.size = 0.3;
                  _loc4_.m_delta = -1000;
                  _loc4_.rotationZ = Math.random() * 360;
                  _loc4_.curpos = Math.random() * 20;
                  addParticle(_loc4_);
                  _loc15_++;
               }
               break;
            case RSpecialEffectType.DUST_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[1],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  if(_loc4_.owner.m_isForward)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc4_.vel = _loc5_.vel.clone();
               if(_loc4_.vel.length != 0)
               {
                  _loc4_.vel.scaleBy(-40 / _loc4_.vel.length);
               }
               _loc4_.size = 0;
               _loc4_.m_delta = -1000;
               _loc4_.rotationZ = Math.random() * 360;
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.GRASS_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[0],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  _loc4_.isRight = true;
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  _loc4_.isRight = false;
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc12_ = Math.PI * (Math.random() / 3 + 5 / 6);
               _loc13_ = _loc5_.vel.length * 0.8;
               if(_loc4_.owner.m_isForward == -1)
               {
                  _loc13_ = -_loc13_;
               }
               _loc14_ = new Number3D(_loc13_ * Math.sin(_loc12_),20 * Math.random() + 10,_loc13_ * Math.cos(_loc12_));
               Matrix3D.multiplyVector3x3(_loc4_.owner.m_renderObject.transform,_loc14_);
               _loc4_.vel = new Vector3D(_loc14_.x,_loc14_.y,_loc14_.z);
               _loc4_.acc = _loc4_.vel.clone();
               _loc4_.acc.scaleBy(-8 / _loc4_.acc.length);
               _loc4_.acc.y = -2;
               _loc4_.size = Math.random() * 0.3 + 0.4;
               _loc4_.m_delta = -1000;
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.OIL_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[45],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc4_.vel = new Vector3D(_loc4_.initpos.x,_loc4_.initpos.y,_loc4_.initpos.z);
               _loc4_.vel = _loc4_.vel.subtract(_loc5_.loc);
               _loc4_.vel.y += Math.random() * 3 + 10;
               if(_loc4_.vel.length != 0)
               {
                  _loc4_.vel.scaleBy(_loc5_.vel.length / 12 / _loc4_.vel.length);
               }
               _loc4_.acc = _loc4_.vel.clone();
               if(_loc4_.acc.length != 0)
               {
                  _loc4_.acc.scaleBy(-0.8 / _loc4_.acc.length);
               }
               _loc4_.acc.y = -3;
               _loc4_.offset.y += 10;
               _loc4_.rotationZ = Math.random() * 360;
               _loc4_.size = 0.05;
               _loc4_.m_delta = -1020;
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.MUD_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[45],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc4_.vel = new Vector3D(_loc4_.initpos.x,_loc4_.initpos.y,_loc4_.initpos.z);
               _loc4_.vel = _loc4_.vel.subtract(_loc5_.loc);
               _loc4_.vel.y += Math.random() * 3 + 10;
               if(_loc4_.vel.length != 0)
               {
                  _loc4_.vel.scaleBy(_loc5_.vel.length / 12 / _loc4_.vel.length);
               }
               _loc4_.acc = _loc4_.vel.clone();
               if(_loc4_.acc.length != 0)
               {
                  _loc4_.acc.scaleBy(-0.8 / _loc4_.acc.length);
               }
               _loc4_.acc.y = -3;
               _loc4_.offset.y += 10;
               _loc4_.rotationZ = Math.random() * 360;
               _loc4_.size = 0.05;
               _loc4_.m_delta = -1020;
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.MOUNT_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[46],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc4_.vel = new Vector3D(_loc4_.initpos.x,_loc4_.initpos.y,_loc4_.initpos.z);
               _loc4_.vel = _loc4_.vel.subtract(_loc5_.loc);
               _loc4_.vel.y += Math.random() * 3 + 10;
               if(_loc4_.vel.length != 0)
               {
                  _loc4_.vel.scaleBy(_loc5_.vel.length / 12 / _loc4_.vel.length);
               }
               _loc4_.acc = _loc4_.vel.clone();
               if(_loc4_.acc.length != 0)
               {
                  _loc4_.acc.scaleBy(-0.8 / _loc4_.acc.length);
               }
               _loc4_.acc.y = -3;
               _loc4_.offset.y += 10;
               _loc4_.rotationZ = Math.random() * 360;
               _loc4_.size = 0.05;
               _loc4_.m_delta = -1020;
               addParticle(_loc4_);
               break;
            case RSpecialEffectType.WATER_BLOW_EFFECT:
               _loc5_ = EntState(param2);
               (_loc4_ = new GameParticle(param1,RSpecialEffect.m_lParticleMaterials[42],1)).owner = RCar(param3);
               if(Math.random() > 0.5)
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BLWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FLWheelLoc;
                  }
               }
               else
               {
                  if(_loc4_.owner.m_isForward == 1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_BRWheelLoc;
                  }
                  if(_loc4_.owner.m_isForward == -1)
                  {
                     _loc4_.initpos = _loc4_.owner.m_FRWheelLoc;
                  }
               }
               _loc4_.vel = new Vector3D(_loc4_.initpos.x,_loc4_.initpos.y,_loc4_.initpos.z);
               _loc4_.vel = _loc4_.vel.subtract(_loc5_.loc);
               _loc4_.vel.y += Math.random() * 3 + 10;
               if(_loc4_.vel.length != 0)
               {
                  _loc4_.vel.scaleBy(_loc5_.vel.length / 12 / _loc4_.vel.length);
               }
               _loc4_.acc = _loc4_.vel.clone();
               if(_loc4_.acc.length != 0)
               {
                  _loc4_.acc.scaleBy(-0.8 / _loc4_.acc.length);
               }
               _loc4_.acc.y = -3;
               _loc4_.offset.y += 10;
               _loc4_.rotationZ = Math.random() * 360;
               _loc4_.size = 0.02;
               _loc4_.m_delta = -1020;
               addParticle(_loc4_);
         }
      }
   }
}
