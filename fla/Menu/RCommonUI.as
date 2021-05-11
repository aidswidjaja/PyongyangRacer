package Menu
{
   import common.RGameCommon;
   import flash.display.MovieClip;
   
   public class RCommonUI extends MovieClip
   {
       
      
      public var _manager:RGameCommon;
      
      protected var _mc:MovieClip;
      
      protected var _mcChar:MovieClip;
      
      public var _bForward:Boolean = true;
      
      public var _mContentsRete:int;
      
      public function RCommonUI(param1:RGameCommon)
      {
         super();
         this._manager = param1;
         this.init();
      }
      
      protected function init() : void
      {
         this.display = true;
      }
      
      public function initDel() : void
      {
         this.displayDel = true;
      }
      
      protected function setMC(param1:Class) : void
      {
         this._mc = new param1();
         addChild(this._mc);
      }
      
      public function set display(param1:Boolean) : void
      {
         if(param1)
         {
            this._manager.addChildAt(this,0);
         }
         else
         {
            this._manager.removeChild(this);
         }
      }
      
      public function set displayDel(param1:Boolean) : void
      {
         this._manager.removeChild(this);
      }
      
      protected function initDriver() : void
      {
         this.view = true;
      }
      
      public function set view(param1:Boolean) : void
      {
         if(param1)
         {
            this._manager.addChildAt(this,1);
         }
         else
         {
            this._manager.removeChild(this);
         }
      }
   }
}
