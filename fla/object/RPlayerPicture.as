package object
{
   import flash.display.Sprite;
   import org.papervision3d.events.FileLoadEvent;
   import org.papervision3d.materials.BitmapFileMaterial;
   
   public class RPlayerPicture extends Sprite
   {
       
      
      public var Pic:Array;
      
      protected var PlayerNum:int = 3;
      
      protected var currLoadedNum:int = 0;
      
      public var Loaded:Boolean = false;
      
      public function RPlayerPicture()
      {
         super();
         this.Pic = new Array();
      }
      
      public function LoadPictureFromUrl(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc2_:BitmapFileMaterial = new BitmapFileMaterial();
         _loc2_.doubleSided = true;
         _loc2_.addEventListener(FileLoadEvent.LOAD_COMPLETE,this.handleFileLoaded);
         _loc2_.texture = param1;
         _loc3_ = {
            "url":param1,
            "material":_loc2_
         };
         this.Pic.push(_loc3_);
      }
      
      protected function handleFileLoaded(param1:FileLoadEvent) : void
      {
         ++this.currLoadedNum;
         if(this.currLoadedNum == this.PlayerNum)
         {
            this.Loaded = true;
         }
      }
      
      public function Init() : void
      {
         this.Pic = null;
         this.Pic = new Array();
         this.Loaded = false;
         this.currLoadedNum = 0;
      }
   }
}
