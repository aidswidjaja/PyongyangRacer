package resourcemgr
{
   import Const.RResorceType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.Timer;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.events.FileLoadEvent;
   
   public class RResourceFile extends EventDispatcher
   {
       
      
      public var m_level:String;
      
      public var m_loader:URLLoader;
      
      public var m_num:int;
      
      public var m_lresInfo:Array;
      
      public var m_lresData:Array;
      
      public var m_BoxCount:int;
      
      public var m_ObjCount:int;
      
      public var m_LodingDegree:int;
      
      public function RResourceFile()
      {
         super();
      }
      
      public function load(param1:int) : void
      {
         var _level:int = param1;
         this.m_lresInfo = new Array();
         this.m_lresData = new Array();
         this.m_BoxCount = 0;
         this.m_ObjCount = 0;
         this.m_LodingDegree = 0;
         if(_level == 0)
         {
            this.m_level = "common.dat";
         }
         else
         {
            this.m_level = String(_level) + ".dat";
         }
         this.m_loader = new URLLoader();
         this.m_loader.dataFormat = URLLoaderDataFormat.BINARY;
         if(_level == 0)
         {
            this.m_loader.addEventListener(ProgressEvent.PROGRESS,this.loadProgress1);
         }
         if(_level > 0)
         {
            this.m_loader.addEventListener(ProgressEvent.PROGRESS,this.loadProgressHandler);
         }
         this.m_loader.addEventListener(Event.COMPLETE,this.loadCompleteHandler);
         try
         {
            this.m_loader.load(new URLRequest(RockRacer.base + this.m_level));
         }
         catch(e:Error)
         {
            PaperLogger.error("error in Loading level file (" + m_level + ")");
         }
      }
      
      public function loadCompleteHandler(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:ByteArray = _loc2_.data;
         _loc3_.inflate();
         this.parse(_loc3_);
      }
      
      public function loadProgressHandler(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded * 100 / param1.bytesTotal;
         this.m_LodingDegree = _loc2_;
         dispatchEvent(new Event("progress"));
      }
      
      public function loadProgress1(param1:ProgressEvent) : void
      {
         var _loc2_:int = int(param1.bytesLoaded * 100 / param1.bytesTotal);
         RockRacer.updateProgress(_loc2_ * 1);
      }
      
      public function parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.readHeader(param1);
         this.readpos(param1,this.m_num);
         var _loc2_:Timer = new Timer(3000,1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,this.timercompleteHandler);
         _loc2_.start();
      }
      
      private function timercompleteHandler(param1:TimerEvent) : void
      {
         dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE,this.m_level));
      }
      
      public function readHeader(param1:ByteArray) : void
      {
         if(1)
         {
            this.m_num = param1.readInt();
            return;
         }
         throw new Error("error loading Object number");
      }
      
      public function readpos(param1:ByteArray, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ByteArray = null;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = param1.readByte();
            _loc6_ = param1.readMultiByte(_loc5_,"0");
            if((_loc7_ = param1.readByte()) != RResorceType.TEXTURE)
            {
               _loc6_ = _loc6_.substr(0,_loc5_ - 4);
            }
            _loc3_ = {
               "filename":_loc6_,
               "type":_loc7_
            };
            this.m_lresInfo.push(_loc3_);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc8_ = param1.readInt();
            (_loc9_ = new ByteArray()).endian = Endian.LITTLE_ENDIAN;
            param1.readBytes(_loc9_,0,_loc8_);
            this.m_lresData.push(_loc9_);
            _loc4_++;
         }
      }
   }
}
