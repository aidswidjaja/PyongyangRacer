package Const
{
   public class RBonusType
   {
      
      public static const MAX:int = 10;
      
      public static var AVAILABLE_BONUS:Array;
       
      
      public function RBonusType()
      {
         super();
         AVAILABLE_BONUS = new Array(new Array(0,2),new Array(0,7),new Array(2,8),new Array(7,3));
      }
      
      public static function GetBonusType(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:Number = Math.random();
         if(param1 < 0)
         {
            return -1;
         }
         if(param1 > 3)
         {
            param1 = 3;
         }
         return int(RObjectType.NONE_BONUS + 1 + AVAILABLE_BONUS[param1][0] + _loc2_ * 100 % AVAILABLE_BONUS[param1][1]);
      }
      
      public static function CreateInstance() : void
      {
         new RBonusType();
      }
   }
}
