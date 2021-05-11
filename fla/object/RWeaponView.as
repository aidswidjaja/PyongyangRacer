package object
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class RWeaponView extends MovieClip
   {
      
      public static const STATE_EMPTYVIEW:String = "emptyWeaponView";
      
      public static const STATE_QUICKVIEW:String = "quickWeaponView";
      
      public static const STATE_SLOWVIEW:String = "slowWeaponView";
      
      public static const STATE_COMPLETVIEW:String = "completWeaponView";
      
      protected static const READYVIEW_FRAME:int = 65;
      
      protected static const QUICKVIEW_FRAME:Number = 40;
      
      protected static const SLOWVIEW_FRAME:Number = 6;
      
      protected static const SCREENMASK_FRAME:Number = 25;
       
      
      private var mcEmptyView:MovieClip;
      
      private var mcQuickView:MovieClip;
      
      private var mcSlowView:MovieClip;
      
      private var _currentView:MovieClip;
      
      private var _currentState:String;
      
      public var weaponType:Number;
      
      public function RWeaponView()
      {
         super();
         var _loc1_:Class = this.GetClassInSWF("EmptyWeaponView");
         this.mcEmptyView = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("QuickWeaponView");
         this.mcQuickView = MovieClip(new _loc1_());
         _loc1_ = this.GetClassInSWF("SlowWeaponView");
         this.mcSlowView = MovieClip(new _loc1_());
         this.currentState = STATE_EMPTYVIEW;
      }
      
      public function GetClassInSWF(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public function set currentState(param1:String) : void
      {
         switch(param1)
         {
            case STATE_EMPTYVIEW:
               this.currentView = this.mcEmptyView;
               break;
            case STATE_QUICKVIEW:
               this.currentView = this.mcQuickView;
               break;
            case STATE_SLOWVIEW:
               this.currentView = this.mcSlowView;
         }
         this._currentState = param1;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function set currentView(param1:MovieClip) : void
      {
         if(this._currentView)
         {
            removeChild(this._currentView);
         }
         param1.x = 10;
         param1.y = 500 - param1.width - 10;
         addChild(param1);
         param1.gotoAndPlay(1);
         this._currentView = param1;
      }
      
      public function get currentView() : MovieClip
      {
         return this._currentView;
      }
      
      public function set pause(param1:Boolean) : void
      {
         if(this.currentState == STATE_COMPLETVIEW || this.currentState == STATE_EMPTYVIEW)
         {
            return;
         }
         if(param1)
         {
            this.currentView.stop();
         }
         else
         {
            this.currentView.play();
         }
      }
      
      public function startSelecting() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function stopSelecting() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.currentState = STATE_EMPTYVIEW;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         switch(this.currentState)
         {
            case STATE_EMPTYVIEW:
               this.currentState = STATE_QUICKVIEW;
               break;
            case STATE_QUICKVIEW:
               if(this.currentView.currentFrame == QUICKVIEW_FRAME)
               {
                  this.currentState = STATE_SLOWVIEW;
                  if(this.weaponType > 3)
                  {
                     this.currentView.gotoAndPlay((this.weaponType - 2) * SLOWVIEW_FRAME);
                  }
               }
               break;
            case STATE_SLOWVIEW:
               _loc2_ = (this.weaponType + 1) * SLOWVIEW_FRAME;
               if(this.currentView.currentFrame == _loc2_)
               {
                  this.currentView.gotoAndStop(_loc2_);
                  this.currentState = STATE_COMPLETVIEW;
                  removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               }
         }
      }
   }
}
