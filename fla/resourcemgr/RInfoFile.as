package resourcemgr
{
   import com.adobe.serialization.json.JSON;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class RInfoFile extends EventDispatcher
   {
       
      
      public var m_InfoDic:Dictionary;
      
      public function RInfoFile(param1:IEventDispatcher = null)
      {
         super(param1);
         this.m_InfoDic = new Dictionary();
      }
      
      public function load(param1:String = "info.txt") : void
      {
         var _filename:String = param1;
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.TEXT;
         loader.addEventListener(Event.COMPLETE,this.loadCompleteHandler);
         loader.addEventListener(ProgressEvent.PROGRESS,this.loadProgressHandler);
         try
         {
            loader.load(new URLRequest(RockRacer.base + _filename));
         }
         catch(e:Error)
         {
            trace("error in Loading level file (" + _filename + ")");
         }
      }
      
      public function loadCompleteHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data;
         this.parse(_loc3_);
      }
      
      public function loadProgressHandler(param1:ProgressEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function parse(param1:String) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Array = com.adobe.serialization.json.JSON.decode(param1);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = {
               "index":_loc2_[_loc3_][0],
               "title":_loc2_[_loc3_][1],
               "pic":_loc2_[_loc3_][2],
               "text":_loc2_[_loc3_][3],
               "check":int(0)
            };
            this.m_InfoDic[_loc2_[_loc3_][0]] = _loc4_;
            _loc3_++;
         }
      }
   }
}
