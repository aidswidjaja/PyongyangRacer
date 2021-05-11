package Congrate_fla
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public dynamic class BTT_Racenow_11 extends MovieClip
   {
       
      
      public function BTT_Racenow_11()
      {
         super();
      }
      
      public function over(param1:MouseEvent) : void
      {
         gotoAndStop("over");
      }
      
      public function out(param1:MouseEvent) : void
      {
         gotoAndStop("out");
      }
      
      public function down(param1:MouseEvent) : void
      {
         gotoAndStop("hit");
      }
      
      public function up(param1:MouseEvent) : void
      {
         gotoAndStop("over");
      }
   }
}
