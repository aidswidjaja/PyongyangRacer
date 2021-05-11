package resourcemgr
{
   import Const.RResorceType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.papervision3d.events.FileLoadEvent;
   
   public class RResourceMgr extends EventDispatcher
   {
       
      
      public var m_leveldata:RResourceFile;
      
      public var m_resLoadingCnt:int = 0;
      
      public var m_lrsObj:Array;
      
      public var m_lrsObjID:Array;
      
      public var m_ObjCnt:int = 0;
      
      public var m_LevelNumber:int;
      
      public var m_Infofile:RInfoFile;
      
      public function RResourceMgr()
      {
         super();
         this.m_leveldata = new RResourceFile();
         this.m_Infofile = new RInfoFile();
         this.m_Infofile.load();
      }
      
      protected function Load(param1:Array, param2:Array) : void
      {
         var _loc3_:Object = null;
         this.m_resLoadingCnt = 0;
         this.m_lrsObj = new Array();
         this.m_lrsObjID = new Array();
         this.m_ObjCnt = 0;
         this.m_resLoadingCnt = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = {
               "type":param1[_loc4_].type,
               "id":_loc4_,
               "name":param1[_loc4_].filename
            };
            this.m_lrsObjID.push(_loc3_);
            switch(param1[_loc4_].type)
            {
               case RResorceType.BOX:
                  this.m_lrsObj.push(new RResourceBox());
                  break;
               case RResorceType.OBJ:
                  this.m_lrsObj.push(new RResourceObj(false));
                  break;
               case RResorceType.MDL:
                  this.m_lrsObj.push(new RResourceObj(true));
                  break;
               case RResorceType.MAP:
                  this.m_lrsObj.push(new RResourceMap());
                  break;
               case RResorceType.HEIGHTMAP:
                  this.m_lrsObj.push(new RResourceHeightmap());
                  break;
               case RResorceType.PATH:
                  this.m_lrsObj.push(new RResourcePath());
                  break;
               case RResorceType.ANIMATE:
                  this.m_lrsObj.push(new RResourceAnim());
                  break;
               case RResorceType.CARPROPERTY:
                  this.m_lrsObj.push(new RResourceCar());
                  break;
               case RResorceType.TEXTURE:
                  this.m_lrsObj.push(new RResourceImg());
                  break;
            }
            if(param1[_loc4_].type != -1)
            {
               param2[_loc4_].position = 0;
               this.m_lrsObj[this.m_ObjCnt++].Parse(param2[_loc4_]);
            }
            _loc4_++;
         }
         dispatchEvent(new Event("LOAD_COMPLETE"));
      }
      
      public function LoadLevel(param1:int) : void
      {
         this.m_leveldata.load(param1);
         this.m_leveldata.addEventListener(FileLoadEvent.LOAD_COMPLETE,this.loadCompleteHandler);
      }
      
      public function loadCompleteHandler(param1:Event) : void
      {
         this.m_leveldata.removeEventListener(FileLoadEvent.LOAD_COMPLETE,this.loadCompleteHandler);
         this.Load(this.m_leveldata.m_lresInfo,this.m_leveldata.m_lresData);
      }
      
      public function GetIDFromName(param1:String) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.m_lrsObjID.length)
         {
            if(param1.toUpperCase() == this.m_lrsObjID[_loc2_].name.toUpperCase())
            {
               return this.m_lrsObjID[_loc2_].id;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}
