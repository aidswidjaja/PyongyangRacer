package object
{
   import flash.geom.Vector3D;
   
   public class EntState
   {
       
      
      public var mass:Number;
      
      public var vel:Vector3D;
      
      public var loc:Vector3D;
      
      public var terrainType:int;
      
      public var pose:Vector3D;
      
      public var animState:int;
      
      public var curFrame:int;
      
      public var actionState:int;
      
      public var bSphere:RBSphere3;
      
      public function EntState()
      {
         this.mass = new Number();
         this.vel = new Vector3D();
         this.loc = new Vector3D();
         this.pose = new Vector3D(0,0,180);
         this.bSphere = new RBSphere3(100,new Vector3D(0,0,0));
         super();
      }
   }
}
