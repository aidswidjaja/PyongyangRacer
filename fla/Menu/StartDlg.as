package Menu
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StartDlg extends AbstractDlg
   {
       
      
      public function StartDlg()
      {
         var _loc1_:Object = {};
         _loc1_.parent = MainMenu._self;
         _loc1_.mcClass = StartDialog;
         super(_loc1_);
         _mc.x = 425;
         _mc.y = 135;
         _mc.BTT_Racenow.addEventListener(MouseEvent.CLICK,this.PlayerMode);
         _mc.addEventListener("startDlgEnd",this.bannerVisible);
      }
      
      private function bannerVisible(param1:Event) : void
      {
         _info.parent.banner.visible = true;
      }
      
      private function PlayerMode(param1:Event) : void
      {
         _info.parent.ToRace(null);
      }
      
      protected function Invite(param1:Event) : void
      {
      }
   }
}
