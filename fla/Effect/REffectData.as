package Effect
{
   import flash.geom.Vector3D;
   import object.EntState;
   import player.RCar;
   
   public class REffectData
   {
       
      
      public var m_EffectType:int;
      
      public var m_ObjEnt1:EntState;
      
      public var m_ObjEnt2:EntState;
      
      public var m_car:RCar;
      
      public var collpos:Vector3D;
      
      public function REffectData(param1:int, param2:EntState, param3:EntState)
      {
         this.m_ObjEnt1 = new EntState();
         this.m_ObjEnt2 = new EntState();
         super();
         this.m_EffectType = param1;
         this.m_ObjEnt1 = param2;
         this.m_ObjEnt2 = param3;
      }
      
      public function SetEffectData(param1:int, param2:EntState, param3:EntState) : void
      {
         this.m_EffectType = param1;
         this.m_ObjEnt1 = param2;
         this.m_ObjEnt2 = param3;
      }
   }
}
