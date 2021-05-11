package player
{
   import common.ROBJECTINFO;
   import flash.geom.Vector3D;
   
   public class RPlayerCar extends RCar
   {
       
      
      public function RPlayerCar(param1:ROBJECTINFO)
      {
         super(param1);
         this.currState.bSphere.ReSet(70,new Vector3D(this.currState.loc.x,this.currState.loc.y,this.currState.loc.z));
         this.currState.pose.y = param1.m_CurrPose.y;
      }
      
      override public function Tick() : void
      {
         super.Tick();
      }
   }
}
