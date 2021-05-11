package Const
{
   public class RTerrainType
   {
      
      public static const START_LINE:int = 1;
      
      public static const ASPHALT_ROAD:int = 2;
      
      public static const OIL_ROAD:int = 3;
      
      public static const GRASS:int = 4;
      
      public static const ACCELENT_ROAD:int = 5;
      
      public static const SAND_ROAD:int = 6;
      
      public static const OUT:int = 14;
      
      public static const MUD_ROAD:int = 100;
      
      public static const MOUNT:int = 101;
      
      public static const WATER:int = 200;
       
      
      public function RTerrainType()
      {
         super();
      }
      
      public static function GetFriction(param1:int) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case START_LINE:
               _loc2_ = {
                  "f1":0.05,
                  "f2":0.8
               };
               break;
            case ASPHALT_ROAD:
               _loc2_ = {
                  "f1":0.05,
                  "f2":0.8
               };
               break;
            case MUD_ROAD:
               _loc2_ = {
                  "f1":0.1,
                  "f2":0.3
               };
               break;
            case MOUNT:
               _loc2_ = {
                  "f1":0.12,
                  "f2":0.8
               };
               break;
            case SAND_ROAD:
               _loc2_ = {
                  "f1":0.06,
                  "f2":0.8
               };
               break;
            case OIL_ROAD:
               _loc2_ = {
                  "f1":0.08,
                  "f2":0.3
               };
               break;
            case GRASS:
               _loc2_ = {
                  "f1":0.1,
                  "f2":0.8
               };
               break;
            case WATER:
               _loc2_ = {
                  "f1":0.07,
                  "f2":0.8
               };
               break;
            case OUT:
               _loc2_ = {
                  "f1":0.8,
                  "f2":1
               };
               break;
            case ACCELENT_ROAD:
               _loc2_ = {
                  "f1":0.01,
                  "f2":1
               };
               break;
            default:
               _loc2_ = {
                  "f1":0.5,
                  "f2":1
               };
         }
         return _loc2_;
      }
   }
}
