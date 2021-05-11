package fl.containers
{
   import fl.core.InvalidationType;
   import fl.core.UIComponent;
   import fl.events.ComponentEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class UILoader extends UIComponent
   {
      
      private static var defaultStyles:Object = {};
       
      
      protected var contentInited:Boolean = false;
      
      protected var _maintainAspectRatio:Boolean = true;
      
      protected var loader:Loader;
      
      protected var _autoLoad:Boolean = true;
      
      protected var contentClip:Sprite;
      
      protected var _scaleContent:Boolean = true;
      
      protected var _source:Object;
      
      public function UILoader()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      protected function _unload(param1:Boolean = false) : void
      {
         var throwError:Boolean = param1;
         if(loader != null)
         {
            clearLoadEvents();
            contentClip.removeChild(loader);
            try
            {
               loader.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               loader.unload();
            }
            catch(e:*)
            {
               if(throwError)
               {
                  throw e;
               }
            }
            loader = null;
            return;
         }
         contentInited = false;
         if(contentClip.numChildren)
         {
            contentClip.removeChildAt(0);
         }
      }
      
      protected function handleComplete(param1:Event) : void
      {
         clearLoadEvents();
         passEvent(param1);
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         if(!_scaleContent && _width > 0)
         {
            return;
         }
         super.setSize(param1,param2);
      }
      
      override protected function draw() : void
      {
         if(isInvalid(InvalidationType.SIZE))
         {
            drawLayout();
         }
         super.draw();
      }
      
      protected function handleError(param1:Event) : void
      {
         passEvent(param1);
         clearLoadEvents();
         loader.contentLoaderInfo.removeEventListener(Event.INIT,handleInit);
      }
      
      protected function initLoader() : void
      {
         loader = new Loader();
         contentClip.addChild(loader);
      }
      
      protected function clearLoadEvents() : void
      {
         loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleError);
         loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
         loader.contentLoaderInfo.removeEventListener(Event.OPEN,passEvent);
         loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,passEvent);
         loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,passEvent);
         loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleComplete);
      }
      
      protected function drawLayout() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc6_:LoaderInfo = null;
         if(!contentInited)
         {
            return;
         }
         var _loc1_:Boolean = false;
         if(loader)
         {
            _loc2_ = (_loc6_ = loader.contentLoaderInfo).width;
            _loc3_ = _loc6_.height;
         }
         else
         {
            _loc2_ = contentClip.width;
            _loc3_ = contentClip.height;
         }
         var _loc4_:Number = _width;
         var _loc5_:Number = _height;
         if(!_scaleContent)
         {
            _width = contentClip.width;
            _height = contentClip.height;
         }
         else
         {
            sizeContent(contentClip,_loc2_,_loc3_,_width,_height);
         }
         if(_loc4_ != _width || _loc5_ != _height)
         {
            dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE,true));
         }
      }
      
      public function get scaleContent() : Boolean
      {
         return _scaleContent;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         contentClip = new Sprite();
         addChild(contentClip);
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return _maintainAspectRatio;
      }
      
      protected function passEvent(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      public function get bytesTotal() : uint
      {
         return loader == null || loader.contentLoaderInfo == null ? uint(0) : uint(loader.contentLoaderInfo.bytesTotal);
      }
      
      protected function sizeContent(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:Number = param4;
         var _loc7_:Number = param5;
         if(_maintainAspectRatio)
         {
            _loc8_ = param4 / param5;
            _loc9_ = param2 / param3;
            if(_loc8_ < _loc9_)
            {
               _loc7_ = _loc6_ / _loc9_;
            }
            else
            {
               _loc6_ = _loc7_ * _loc9_;
            }
         }
         param1.width = _loc6_;
         param1.height = _loc7_;
         param1.x = param4 / 2 - _loc6_ / 2;
         param1.y = param5 / 2 - _loc7_ / 2;
      }
      
      public function get source() : Object
      {
         return _source;
      }
      
      public function set scaleContent(param1:Boolean) : void
      {
         if(_scaleContent == param1)
         {
            return;
         }
         _scaleContent = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get bytesLoaded() : uint
      {
         return loader == null || loader.contentLoaderInfo == null ? uint(0) : uint(loader.contentLoaderInfo.bytesLoaded);
      }
      
      public function loadBytes(param1:ByteArray, param2:LoaderContext = null) : void
      {
         var bytes:ByteArray = param1;
         var context:LoaderContext = param2;
         _unload();
         initLoader();
         try
         {
            loader.loadBytes(bytes,context);
         }
         catch(error:*)
         {
            throw error;
         }
      }
      
      protected function handleInit(param1:Event) : void
      {
         loader.contentLoaderInfo.removeEventListener(Event.INIT,handleInit);
         contentInited = true;
         passEvent(param1);
         invalidate(InvalidationType.SIZE);
      }
      
      public function set autoLoad(param1:Boolean) : void
      {
         _autoLoad = param1;
         if(_autoLoad && loader == null && _source != null && _source != "")
         {
            load();
         }
      }
      
      public function load(param1:URLRequest = null, param2:LoaderContext = null) : void
      {
         _unload();
         if((param1 == null || param1.url == null) && (_source == null || _source == ""))
         {
            return;
         }
         var _loc3_:DisplayObject = getDisplayObjectInstance(source);
         if(_loc3_ != null)
         {
            contentClip.addChild(_loc3_);
            contentInited = true;
            invalidate(InvalidationType.SIZE);
            return;
         }
         param1 = param1;
         if(param1 == null)
         {
            param1 = new URLRequest(_source.toString());
         }
         if(param2 == null)
         {
            param2 = new LoaderContext(false,ApplicationDomain.currentDomain);
         }
         initLoader();
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleError,false,0,true);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError,false,0,true);
         loader.contentLoaderInfo.addEventListener(Event.OPEN,passEvent,false,0,true);
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,passEvent,false,0,true);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleComplete,false,0,true);
         loader.contentLoaderInfo.addEventListener(Event.INIT,handleInit,false,0,true);
         loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,passEvent,false,0,true);
         loader.load(param1,param2);
      }
      
      public function get percentLoaded() : Number
      {
         return bytesTotal <= 0 ? Number(0) : Number(bytesLoaded / bytesTotal * 100);
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         _maintainAspectRatio = param1;
         invalidate(InvalidationType.SIZE);
      }
      
      public function get autoLoad() : Boolean
      {
         return _autoLoad;
      }
      
      public function set source(param1:Object) : void
      {
         if(param1 == "")
         {
            return;
         }
         _source = param1;
         _unload();
         if(_autoLoad && _source != null)
         {
            load();
         }
      }
      
      public function close() : void
      {
         try
         {
            loader.close();
         }
         catch(error:*)
         {
            throw error;
         }
      }
      
      public function get content() : DisplayObject
      {
         if(loader != null)
         {
            return loader.content;
         }
         if(contentClip.numChildren)
         {
            return contentClip.getChildAt(0);
         }
         return null;
      }
      
      public function unload() : void
      {
         _source = null;
         _unload(true);
      }
   }
}
