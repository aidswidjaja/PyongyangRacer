package Const
{
   import flash.geom.Vector3D;
   
   public class RPlayerType
   {
      
      public static const DUCK:int = 0;
      
      public static const ELEPHANT:int = 1;
      
      public static const MAN:int = 2;
      
      public static const WOMAN:int = 3;
      
      public static const HIGHMODEL:int = 0;
      
      public static const MIDDLEMODEL:int = 1;
      
      public static const LOWMODEL:int = 2;
      
      public static var WheelOffset:Array;
       
      
      public function RPlayerType()
      {
         super();
         WheelOffset = new Array(new Array(new Vector3D(53,24,34),new Vector3D(66.5,24,-66.5),1.05),new Array(new Vector3D(63,21.5,63.5),new Vector3D(60,21.5,-52),1.1),new Array(new Vector3D(56,22,109.5),new Vector3D(56,22,-95.5),1),new Array(new Vector3D(55,20,46),new Vector3D(62.5,20,-58.5),1.2));
      }
      
      public static function CreateInstance() : void
      {
         new RPlayerType();
      }
   }
}
