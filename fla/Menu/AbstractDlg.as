package Menu
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AbstractDlg extends Sprite
   {
       
      
      public var _info:Object;
      
      public var _mc:MovieClip;
      
      public function AbstractDlg(param1:Object)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      public function init() : void
      {
         if(this._mc != null)
         {
            this.removeObject();
         }
         this._mc = new this._info.mcClass();
         (this._info.parent as Sprite).addChildAt(this._mc,(this._info.parent as Sprite).numChildren - 2);
         this._mc.gotoAndPlay(1);
      }
      
      public function removeObject() : void
      {
         this.removeEvent();
         (this._info.parent as Sprite).removeChild(this._mc);
         this._mc = null;
      }
      
      public function removeEvent() : void
      {
      }
   }
}
