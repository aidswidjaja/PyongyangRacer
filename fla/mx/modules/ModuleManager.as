package mx.modules
{
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ModuleManager
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
       
      
      public function ModuleManager()
      {
         super();
      }
      
      public static function getModule(param1:String) : IModuleInfo
      {
         return getSingleton().getModule(param1);
      }
      
      public static function getAssociatedFactory(param1:Object) : IFlexModuleFactory
      {
         return getSingleton().getAssociatedFactory(param1);
      }
      
      private static function getSingleton() : Object
      {
         if(!ModuleManagerGlobals.managerSingleton)
         {
            ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
         }
         return ModuleManagerGlobals.managerSingleton;
      }
   }
}

import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;
import mx.core.IFlexModuleFactory;
import mx.modules.IModuleInfo;

class ModuleManagerImpl extends EventDispatcher
{
    
   
   private var moduleList:Object;
   
   function ModuleManagerImpl()
   {
      this.moduleList = {};
      super();
   }
   
   public function getAssociatedFactory(param1:Object) : IFlexModuleFactory
   {
      var m:Object = null;
      var info:ModuleInfo = null;
      var domain:ApplicationDomain = null;
      var cls:Class = null;
      var object:Object = param1;
      var className:String = getQualifiedClassName(object);
      for each(m in this.moduleList)
      {
         info = m as ModuleInfo;
         if(info.ready)
         {
            domain = info.applicationDomain;
            try
            {
               cls = Class(domain.getDefinition(className));
               if(object is cls)
               {
                  return info.factory;
               }
            }
            catch(error:Error)
            {
               continue;
            }
         }
      }
      return null;
   }
   
   public function getModule(param1:String) : IModuleInfo
   {
      var _loc2_:ModuleInfo = this.moduleList[param1] as ModuleInfo;
      if(!_loc2_)
      {
         _loc2_ = new ModuleInfo(param1);
         this.moduleList[param1] = _loc2_;
      }
      return new ModuleInfoProxy(_loc2_);
   }
}

import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import mx.core.IFlexModuleFactory;
import mx.events.ModuleEvent;
import mx.events.Request;

class ModuleInfo extends EventDispatcher
{
    
   
   private var factoryInfo:FactoryInfo;
   
   private var limbo:Dictionary;
   
   private var loader:Loader;
   
   private var numReferences:int = 0;
   
   private var parentModuleFactory:IFlexModuleFactory;
   
   private var _error:Boolean = false;
   
   private var _loaded:Boolean = false;
   
   private var _ready:Boolean = false;
   
   private var _setup:Boolean = false;
   
   private var _url:String;
   
   function ModuleInfo(param1:String)
   {
      super();
      this._url = param1;
   }
   
   public function get applicationDomain() : ApplicationDomain
   {
      return !this.limbo && this.factoryInfo ? this.factoryInfo.applicationDomain : null;
   }
   
   public function get error() : Boolean
   {
      return !this.limbo ? Boolean(this._error) : false;
   }
   
   public function get factory() : IFlexModuleFactory
   {
      return !this.limbo && this.factoryInfo ? this.factoryInfo.factory : null;
   }
   
   public function get loaded() : Boolean
   {
      return !this.limbo ? Boolean(this._loaded) : false;
   }
   
   public function get ready() : Boolean
   {
      return !this.limbo ? Boolean(this._ready) : false;
   }
   
   public function get setup() : Boolean
   {
      return !this.limbo ? Boolean(this._setup) : false;
   }
   
   public function get size() : int
   {
      return !this.limbo && this.factoryInfo ? int(this.factoryInfo.bytesTotal) : 0;
   }
   
   public function get url() : String
   {
      return this._url;
   }
   
   public function load(param1:ApplicationDomain = null, param2:SecurityDomain = null, param3:ByteArray = null, param4:IFlexModuleFactory = null) : void
   {
      if(this._loaded)
      {
         return;
      }
      this._loaded = true;
      this.limbo = null;
      this.parentModuleFactory = param4;
      if(param3)
      {
         this.loadBytes(param1,param3);
         return;
      }
      if(this._url.indexOf("published://") == 0)
      {
         return;
      }
      var _loc5_:URLRequest = new URLRequest(this._url);
      var _loc6_:LoaderContext;
      (_loc6_ = new LoaderContext()).applicationDomain = !!param1 ? param1 : new ApplicationDomain(ApplicationDomain.currentDomain);
      _loc6_.securityDomain = param2;
      if(param2 == null && Security.sandboxType == Security.REMOTE)
      {
         _loc6_.securityDomain = SecurityDomain.currentDomain;
      }
      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initHandler);
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
      this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
      this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      this.loader.load(_loc5_,_loc6_);
   }
   
   private function loadBytes(param1:ApplicationDomain, param2:ByteArray) : void
   {
      var _loc3_:LoaderContext = new LoaderContext();
      _loc3_.applicationDomain = !!param1 ? param1 : new ApplicationDomain(ApplicationDomain.currentDomain);
      if("allowLoadBytesCodeExecution" in _loc3_)
      {
         _loc3_["allowLoadBytesCodeExecution"] = true;
      }
      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initHandler);
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
      this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
      this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
      this.loader.loadBytes(param2,_loc3_);
   }
   
   public function resurrect() : void
   {
      var _loc1_:* = null;
      if(!this._ready)
      {
         return;
      }
      if(!this.factoryInfo && this.limbo)
      {
         var _loc2_:int = 0;
         var _loc3_:* = this.limbo;
         for(_loc1_ in _loc3_)
         {
            this.factoryInfo = _loc1_ as FactoryInfo;
         }
         this.limbo = null;
      }
      if(!this.factoryInfo)
      {
         if(this._loaded)
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
         }
         this.loader = null;
         this._loaded = false;
         this._setup = false;
         this._ready = false;
         this._error = false;
      }
   }
   
   public function release() : void
   {
      if(this._ready && !this.limbo)
      {
         this.limbo = new Dictionary(true);
         this.limbo[this.factoryInfo] = 1;
         this.factoryInfo = null;
      }
      else
      {
         this.unload();
      }
   }
   
   private function clearLoader() : void
   {
      if(this.loader)
      {
         if(this.loader.contentLoaderInfo)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.initHandler);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler);
         }
         try
         {
            if(this.loader.content)
            {
               this.loader.content.removeEventListener("ready",this.readyHandler);
               this.loader.content.removeEventListener("error",this.moduleErrorHandler);
               this.loader.content.removeEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.getFlexModuleFactoryRequestHandler);
            }
         }
         catch(error:Error)
         {
         }
         if(this._loaded)
         {
            try
            {
               this.loader.close();
            }
            catch(error:Error)
            {
            }
         }
         try
         {
            this.loader.unload();
         }
         catch(error:Error)
         {
         }
         this.loader = null;
      }
   }
   
   public function unload() : void
   {
      this.clearLoader();
      if(this._loaded)
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
      }
      this.limbo = null;
      this.factoryInfo = null;
      this.parentModuleFactory = null;
      this._loaded = false;
      this._setup = false;
      this._ready = false;
      this._error = false;
   }
   
   public function publish(param1:IFlexModuleFactory) : void
   {
      if(this.factoryInfo)
      {
         return;
      }
      if(this._url.indexOf("published://") != 0)
      {
         return;
      }
      this.factoryInfo = new FactoryInfo();
      this.factoryInfo.factory = param1;
      this._loaded = true;
      this._setup = true;
      this._ready = true;
      this._error = false;
      dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
      dispatchEvent(new ModuleEvent(ModuleEvent.PROGRESS));
      dispatchEvent(new ModuleEvent(ModuleEvent.READY));
   }
   
   public function addReference() : void
   {
      ++this.numReferences;
   }
   
   public function removeReference() : void
   {
      --this.numReferences;
      if(this.numReferences == 0)
      {
         this.release();
      }
   }
   
   public function initHandler(param1:Event) : void
   {
      var moduleEvent:ModuleEvent = null;
      var event:Event = param1;
      this.factoryInfo = new FactoryInfo();
      try
      {
         this.factoryInfo.factory = this.loader.content as IFlexModuleFactory;
      }
      catch(error:Error)
      {
      }
      if(!this.factoryInfo.factory)
      {
         moduleEvent = new ModuleEvent(ModuleEvent.ERROR,event.bubbles,event.cancelable);
         moduleEvent.bytesLoaded = 0;
         moduleEvent.bytesTotal = 0;
         moduleEvent.errorText = "SWF is not a loadable module";
         dispatchEvent(moduleEvent);
         return;
      }
      this.loader.content.addEventListener("ready",this.readyHandler);
      this.loader.content.addEventListener("error",this.moduleErrorHandler);
      this.loader.content.addEventListener(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST,this.getFlexModuleFactoryRequestHandler);
      try
      {
         this.factoryInfo.applicationDomain = this.loader.contentLoaderInfo.applicationDomain;
      }
      catch(error:Error)
      {
      }
      this._setup = true;
      dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
   }
   
   public function progressHandler(param1:ProgressEvent) : void
   {
      var _loc2_:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS,param1.bubbles,param1.cancelable);
      _loc2_.bytesLoaded = param1.bytesLoaded;
      _loc2_.bytesTotal = param1.bytesTotal;
      dispatchEvent(_loc2_);
   }
   
   public function completeHandler(param1:Event) : void
   {
      var _loc2_:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS,param1.bubbles,param1.cancelable);
      _loc2_.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
      _loc2_.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      dispatchEvent(_loc2_);
   }
   
   public function errorHandler(param1:ErrorEvent) : void
   {
      this._error = true;
      var _loc2_:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR,param1.bubbles,param1.cancelable);
      _loc2_.bytesLoaded = 0;
      _loc2_.bytesTotal = 0;
      _loc2_.errorText = param1.text;
      dispatchEvent(_loc2_);
   }
   
   public function getFlexModuleFactoryRequestHandler(param1:Request) : void
   {
      param1.value = this.parentModuleFactory;
   }
   
   public function readyHandler(param1:Event) : void
   {
      this._ready = true;
      this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      var _loc2_:ModuleEvent = new ModuleEvent(ModuleEvent.READY);
      _loc2_.bytesLoaded = this.loader.contentLoaderInfo.bytesLoaded;
      _loc2_.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      this.clearLoader();
      dispatchEvent(_loc2_);
   }
   
   public function moduleErrorHandler(param1:Event) : void
   {
      var _loc2_:ModuleEvent = null;
      this._ready = true;
      this.factoryInfo.bytesTotal = this.loader.contentLoaderInfo.bytesTotal;
      this.clearLoader();
      if(param1 is ModuleEvent)
      {
         _loc2_ = ModuleEvent(param1);
      }
      else
      {
         _loc2_ = new ModuleEvent(ModuleEvent.ERROR);
      }
      dispatchEvent(_loc2_);
   }
}

import flash.system.ApplicationDomain;
import mx.core.IFlexModuleFactory;

class FactoryInfo
{
    
   
   public var factory:IFlexModuleFactory;
   
   public var applicationDomain:ApplicationDomain;
   
   public var bytesTotal:int = 0;
   
   function FactoryInfo()
   {
      super();
   }
}

import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;
import flash.utils.ByteArray;
import mx.core.IFlexModuleFactory;
import mx.events.ModuleEvent;
import mx.modules.IModuleInfo;

class ModuleInfoProxy extends EventDispatcher implements IModuleInfo
{
    
   
   private var info:ModuleInfo;
   
   private var referenced:Boolean = false;
   
   private var _data:Object;
   
   function ModuleInfoProxy(param1:ModuleInfo)
   {
      super();
      this.info = param1;
      param1.addEventListener(ModuleEvent.SETUP,this.moduleEventHandler,false,0,true);
      param1.addEventListener(ModuleEvent.PROGRESS,this.moduleEventHandler,false,0,true);
      param1.addEventListener(ModuleEvent.READY,this.moduleEventHandler,false,0,true);
      param1.addEventListener(ModuleEvent.ERROR,this.moduleEventHandler,false,0,true);
      param1.addEventListener(ModuleEvent.UNLOAD,this.moduleEventHandler,false,0,true);
   }
   
   public function get data() : Object
   {
      return this._data;
   }
   
   public function set data(param1:Object) : void
   {
      this._data = param1;
   }
   
   public function get error() : Boolean
   {
      return this.info.error;
   }
   
   public function get factory() : IFlexModuleFactory
   {
      return this.info.factory;
   }
   
   public function get loaded() : Boolean
   {
      return this.info.loaded;
   }
   
   public function get ready() : Boolean
   {
      return this.info.ready;
   }
   
   public function get setup() : Boolean
   {
      return this.info.setup;
   }
   
   public function get url() : String
   {
      return this.info.url;
   }
   
   public function publish(param1:IFlexModuleFactory) : void
   {
      this.info.publish(param1);
   }
   
   public function load(param1:ApplicationDomain = null, param2:SecurityDomain = null, param3:ByteArray = null, param4:IFlexModuleFactory = null) : void
   {
      var _loc5_:ModuleEvent = null;
      this.info.resurrect();
      if(!this.referenced)
      {
         this.info.addReference();
         this.referenced = true;
      }
      if(this.info.error)
      {
         dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
      }
      else if(this.info.loaded)
      {
         if(this.info.setup)
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
            if(this.info.ready)
            {
               (_loc5_ = new ModuleEvent(ModuleEvent.PROGRESS)).bytesLoaded = this.info.size;
               _loc5_.bytesTotal = this.info.size;
               dispatchEvent(_loc5_);
               dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            }
         }
      }
      else
      {
         this.info.load(param1,param2,param3,param4);
      }
   }
   
   public function release() : void
   {
      if(this.referenced)
      {
         this.info.removeReference();
         this.referenced = false;
      }
   }
   
   public function unload() : void
   {
      this.info.unload();
      this.info.removeEventListener(ModuleEvent.SETUP,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.PROGRESS,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.READY,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.ERROR,this.moduleEventHandler);
      this.info.removeEventListener(ModuleEvent.UNLOAD,this.moduleEventHandler);
   }
   
   private function moduleEventHandler(param1:ModuleEvent) : void
   {
      dispatchEvent(param1);
   }
}
