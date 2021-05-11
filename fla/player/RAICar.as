package player
{
   import common.ROBJECTINFO;
   import flash.geom.Vector3D;
   
   public class RAICar extends RCar
   {
       
      
      var carStyle:int;
      
      public function RAICar(param1:ROBJECTINFO)
      {
         this.carStyle = param1.m_ObjectProperty;
         param1.m_ObjectProperty = 2;
         super(param1);
         this.currState.bSphere.ReSet(70,new Vector3D(this.currState.loc.x,this.currState.loc.y,this.currState.loc.z));
      }
      
      override public function Tick() : void
      {
         super.Tick();
      }
   }
}
