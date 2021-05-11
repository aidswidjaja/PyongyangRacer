package it.gotoandplay.smartfoxserver.http
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   
   public class LoaderFactory
   {
      
      private static const DEFAULT_POOL_SIZE:int = 8;
       
      
      private var loadersPool:Array;
      
      private var currentLoaderIndex:int;
      
      public function LoaderFactory(param1:Function, param2:Function, param3:int = 8)
      {
         var _loc5_:URLLoader = null;
         super();
         this.loadersPool = [];
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.TEXT;
            _loc5_.addEventListener(Event.COMPLETE,param1);
            _loc5_.addEventListener(IOErrorEvent.IO_ERROR,param2);
            _loc5_.addEventListener(IOErrorEvent.NETWORK_ERROR,param2);
            this.loadersPool.push(_loc5_);
            _loc4_++;
         }
         this.currentLoaderIndex = 0;
      }
      
      public function getLoader() : URLLoader
      {
         var _loc1_:URLLoader = this.loadersPool[this.currentLoaderIndex];
         ++this.currentLoaderIndex;
         if(this.currentLoaderIndex >= this.loadersPool.length)
         {
            this.currentLoaderIndex = 0;
         }
         return _loc1_;
      }
   }
}
