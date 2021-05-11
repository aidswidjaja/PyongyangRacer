package common
{
   import flash.geom.Vector3D;
   import object.RGameEnt;
   
   public class ROBJECTINFO
   {
       
      
      public var m_ObjectID:int;
      
      public var m_ObjectType:int;
      
      public var m_CurrLoc:Vector3D;
      
      public var m_CurrPose:Vector3D;
      
      public var m_CurrState:int;
      
      public var m_ParentObject:RGameEnt;
      
      public var m_ObjectProperty:int;
      
      public var m_userId:int;
      
      public var m_reserve:int;
      
      public function ROBJECTINFO()
      {
         super();
         this.m_CurrLoc = new Vector3D(0,0,0);
         this.m_CurrPose = new Vector3D(0,0,0);
         this.m_ParentObject = null;
      }
   }
}
