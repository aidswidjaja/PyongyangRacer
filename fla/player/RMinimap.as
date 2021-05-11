package player
{
   import flash.display.Sprite;
   
   public class RMinimap extends Sprite
   {
       
      
      public function RMinimap()
      {
         super();
      }
      
      public function Init() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            removeChildAt(_loc1_);
            _loc1_++;
         }
      }
   }
}
