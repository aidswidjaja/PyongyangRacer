package mx.collections
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   import mx.collections.errors.CollectionViewError;
   import mx.collections.errors.ItemPendingError;
   import mx.collections.errors.SortError;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class ListCollectionView extends Proxy implements ICollectionView, IList, IMXMLObject
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
       
      
      private var eventDispatcher:EventDispatcher;
      
      private var revision:int;
      
      private var autoUpdateCounter:int;
      
      private var pendingUpdates:Array;
      
      mx_internal var dispatchResetEvent:Boolean = true;
      
      private var resourceManager:IResourceManager;
      
      protected var localIndex:Array;
      
      private var _list:IList;
      
      private var _filterFunction:Function;
      
      private var _sort:Sort;
      
      public function ListCollectionView(param1:IList = null)
      {
         this.resourceManager = ResourceManager.getInstance();
         super();
         this.eventDispatcher = new EventDispatcher(this);
         this.list = param1;
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this.refresh();
      }
      
      public function get length() : int
      {
         if(this.localIndex)
         {
            return this.localIndex.length;
         }
         if(this.list)
         {
            return this.list.length;
         }
         return 0;
      }
      
      public function get list() : IList
      {
         return this._list;
      }
      
      public function set list(param1:IList) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         if(this._list != param1)
         {
            if(this._list)
            {
               this._list.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.listChangeHandler);
               _loc2_ = this._list.length > 0;
            }
            this._list = param1;
            if(this._list)
            {
               this._list.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.listChangeHandler,false,0,true);
               _loc3_ = this._list.length > 0;
            }
            if(_loc2_ || _loc3_)
            {
               this.reset();
            }
            this.dispatchEvent(new Event("listChanged"));
         }
      }
      
      public function get filterFunction() : Function
      {
         return this._filterFunction;
      }
      
      public function set filterFunction(param1:Function) : void
      {
         this._filterFunction = param1;
         this.dispatchEvent(new Event("filterFunctionChanged"));
      }
      
      public function get sort() : Sort
      {
         return this._sort;
      }
      
      public function set sort(param1:Sort) : void
      {
         this._sort = param1;
         this.dispatchEvent(new Event("sortChanged"));
      }
      
      public function contains(param1:Object) : Boolean
      {
         return this.getItemIndex(param1) != -1;
      }
      
      public function disableAutoUpdate() : void
      {
         ++this.autoUpdateCounter;
      }
      
      public function enableAutoUpdate() : void
      {
         if(this.autoUpdateCounter > 0)
         {
            --this.autoUpdateCounter;
            if(this.autoUpdateCounter == 0)
            {
               this.handlePendingUpdates();
            }
         }
      }
      
      public function createCursor() : IViewCursor
      {
         return new ListCollectionViewCursor(this);
      }
      
      public function itemUpdated(param1:Object, param2:Object = null, param3:Object = null, param4:Object = null) : void
      {
         this.list.itemUpdated(param1,param2,param3,param4);
      }
      
      public function refresh() : Boolean
      {
         return this.internalRefresh(true);
      }
      
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= this.length)
         {
            _loc3_ = this.resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         if(this.localIndex)
         {
            return this.localIndex[param1];
         }
         if(this.list)
         {
            return this.list.getItemAt(param1,param2);
         }
         return null;
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         var _loc4_:String = null;
         var _loc5_:Object = null;
         if(param2 < 0 || !this.list || param2 >= this.length)
         {
            _loc4_ = this.resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         var _loc3_:int = param2;
         if(this.localIndex)
         {
            if(param2 > this.localIndex.length)
            {
               _loc3_ = this.list.length;
            }
            else
            {
               _loc5_ = this.localIndex[param2];
               _loc3_ = this.list.getItemIndex(_loc5_);
            }
         }
         return this.list.setItemAt(param1,_loc3_);
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc4_:String = null;
         if(param2 < 0 || !this.list || param2 > this.length)
         {
            _loc4_ = this.resourceManager.getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         var _loc3_:int = param2;
         if(this.localIndex && this.sort)
         {
            _loc3_ = this.list.length;
         }
         else if(this.localIndex && this.filterFunction != null)
         {
            if(_loc3_ == this.localIndex.length)
            {
               _loc3_ = this.list.length;
            }
            else
            {
               _loc3_ = this.list.getItemIndex(this.localIndex[param2]);
            }
         }
         this.list.addItemAt(param1,_loc3_);
      }
      
      public function addAll(param1:IList) : void
      {
         this.addAllAt(param1,this.length);
      }
      
      public function addAllAt(param1:IList, param2:int) : void
      {
         var _loc3_:int = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.addItemAt(param1.getItemAt(_loc4_),_loc4_ + param2);
            _loc4_++;
         }
      }
      
      public function getItemIndex(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.localIndex && this.sort)
         {
            _loc3_ = this.sort.findItem(this.localIndex,param1,Sort.FIRST_INDEX_MODE);
            if(_loc3_ == -1)
            {
               return -1;
            }
            _loc4_ = this.sort.findItem(this.localIndex,param1,Sort.LAST_INDEX_MODE);
            _loc2_ = _loc3_;
            while(_loc2_ <= _loc4_)
            {
               if(this.localIndex[_loc2_] == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
            return -1;
         }
         if(this.localIndex && this.filterFunction != null)
         {
            _loc5_ = this.localIndex.length;
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               if(this.localIndex[_loc2_] == param1)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
            return -1;
         }
         return this.list.getItemIndex(param1);
      }
      
      mx_internal function getLocalItemIndex(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = this.localIndex.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.localIndex[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function getFilteredItemIndex(param1:Object) : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = this.list.getItemIndex(param1);
         if(_loc2_ == 0)
         {
            return 0;
         }
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this.list.getItemAt(_loc3_);
            if(this.filterFunction(_loc4_))
            {
               _loc5_ = this.localIndex.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if(this.localIndex[_loc6_] == _loc4_)
                  {
                     return _loc6_ + 1;
                  }
                  _loc6_++;
               }
            }
            _loc3_--;
         }
         return 0;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param1 < 0 || param1 >= this.length)
         {
            _loc3_ = this.resourceManager.getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         var _loc2_:int = param1;
         if(this.localIndex)
         {
            _loc4_ = this.localIndex[param1];
            _loc2_ = this.list.getItemIndex(_loc4_);
         }
         return this.list.removeItemAt(_loc2_);
      }
      
      public function removeAll() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = this.length;
         if(_loc1_ > 0)
         {
            if(this.localIndex)
            {
               _loc2_ = _loc1_ - 1;
               while(_loc2_ >= 0)
               {
                  this.removeItemAt(_loc2_);
                  _loc2_--;
               }
            }
            else
            {
               this.list.removeAll();
            }
         }
      }
      
      public function toArray() : Array
      {
         var _loc1_:Array = null;
         if(this.localIndex)
         {
            _loc1_ = this.localIndex.concat();
         }
         else
         {
            _loc1_ = this.list.toArray();
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         if(this.localIndex)
         {
            return ObjectUtil.toString(this.localIndex);
         }
         if(this.list && Object(this.list).toString)
         {
            return Object(this.list).toString();
         }
         return getQualifiedClassName(this);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var n:Number = NaN;
         var message:String = null;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            message = this.resourceManager.getString("collections","unknownProperty",[name]);
            throw new Error(message);
         }
         return this.getItemAt(index);
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var n:Number = NaN;
         var message:String = null;
         var name:* = param1;
         var value:* = param2;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            message = this.resourceManager.getString("collections","unknownProperty",[name]);
            throw new Error(message);
         }
         this.setItemAt(value,index);
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         var n:Number = NaN;
         var name:* = param1;
         if(name is QName)
         {
            name = name.localName;
         }
         var index:int = -1;
         try
         {
            n = parseInt(String(name));
            if(!isNaN(n))
            {
               index = int(n);
            }
         }
         catch(e:Error)
         {
         }
         if(index == -1)
         {
            return false;
         }
         return index >= 0 && index < this.length;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 < this.length ? int(param1 + 1) : 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return (param1 - 1).toString();
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return this.getItemAt(param1 - 1);
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return null;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.eventDispatcher.willTrigger(param1);
      }
      
      private function addItemsToView(param1:Array, param2:int, param3:Boolean = true) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:CollectionEvent = null;
         var _loc4_:Array = !!this.localIndex ? [] : param1;
         var _loc5_:int = param2;
         var _loc6_:Boolean = true;
         if(this.localIndex)
         {
            _loc7_ = param2;
            _loc8_ = 0;
            while(_loc8_ < param1.length)
            {
               _loc9_ = param1[_loc8_];
               if(this.filterFunction == null || this.filterFunction(_loc9_))
               {
                  if(this.sort)
                  {
                     _loc7_ = this.findItem(_loc9_,Sort.ANY_INDEX_MODE,true);
                     if(_loc6_)
                     {
                        _loc5_ = _loc7_;
                        _loc6_ = false;
                     }
                  }
                  else
                  {
                     _loc7_ = this.getFilteredItemIndex(_loc9_);
                     if(_loc6_)
                     {
                        _loc5_ = _loc7_;
                        _loc6_ = false;
                     }
                  }
                  if(this.sort && this.sort.unique && this.sort.compareFunction(_loc9_,this.localIndex[_loc7_]) == 0)
                  {
                     _loc10_ = this.resourceManager.getString("collections","incorrectAddition");
                     throw new CollectionViewError(_loc10_);
                  }
                  this.localIndex.splice(_loc7_++,0,_loc9_);
                  _loc4_.push(_loc9_);
               }
               else
               {
                  _loc5_ = -1;
               }
               _loc8_++;
            }
         }
         if(this.localIndex && _loc4_.length > 1)
         {
            _loc5_ = -1;
         }
         if(param3 && _loc4_.length > 0)
         {
            (_loc11_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE)).kind = CollectionEventKind.ADD;
            _loc11_.location = _loc5_;
            _loc11_.items = _loc4_;
            this.dispatchEvent(_loc11_);
         }
         return _loc5_;
      }
      
      mx_internal function findItem(param1:Object, param2:String, param3:Boolean = false) : int
      {
         var _loc4_:String = null;
         if(!this.sort || !this.localIndex)
         {
            _loc4_ = this.resourceManager.getString("collections","itemNotFound");
            throw new CollectionViewError(_loc4_);
         }
         if(this.localIndex.length == 0)
         {
            return !!param3 ? 0 : -1;
         }
         return this.sort.findItem(this.localIndex,param1,param2,param3);
      }
      
      mx_internal function getBookmark(param1:int) : ListCollectionViewBookmark
      {
         var value:Object = null;
         var message:String = null;
         var index:int = param1;
         if(index < 0 || index > this.length)
         {
            message = this.resourceManager.getString("collections","invalidIndex",[index]);
            throw new CollectionViewError(message);
         }
         try
         {
            value = this.getItemAt(index);
         }
         catch(e:Error)
         {
            value = null;
         }
         return new ListCollectionViewBookmark(value,this,this.revision,index);
      }
      
      mx_internal function getBookmarkIndex(param1:CursorBookmark) : int
      {
         var bm:ListCollectionViewBookmark = null;
         var message:String = null;
         var bookmark:CursorBookmark = param1;
         if(!(bookmark is ListCollectionViewBookmark) || ListCollectionViewBookmark(bookmark).view != this)
         {
            message = this.resourceManager.getString("collections","bookmarkNotFound");
            throw new CollectionViewError(message);
         }
         bm = ListCollectionViewBookmark(bookmark);
         if(bm.viewRevision != this.revision)
         {
            if(bm.index < 0 || bm.index >= this.length || this.getItemAt(bm.index) != bm.value)
            {
               try
               {
                  bm.index = this.getItemIndex(bm.value);
               }
               catch(e:SortError)
               {
                  bm.index = getLocalItemIndex(bm.value);
               }
            }
            bm.viewRevision = this.revision;
         }
         return bm.index;
      }
      
      private function listChangeHandler(param1:CollectionEvent) : void
      {
         if(this.autoUpdateCounter > 0)
         {
            if(!this.pendingUpdates)
            {
               this.pendingUpdates = [];
            }
            this.pendingUpdates.push(param1);
         }
         else
         {
            switch(param1.kind)
            {
               case CollectionEventKind.ADD:
                  this.addItemsToView(param1.items,param1.location);
                  break;
               case CollectionEventKind.RESET:
                  this.reset();
                  break;
               case CollectionEventKind.REMOVE:
                  this.removeItemsFromView(param1.items,param1.location);
                  break;
               case CollectionEventKind.REPLACE:
                  this.replaceItemsInView(param1.items,param1.location);
                  break;
               case CollectionEventKind.UPDATE:
                  this.handlePropertyChangeEvents(param1.items);
                  break;
               default:
                  this.dispatchEvent(param1);
            }
         }
      }
      
      private function handlePropertyChangeEvents(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:PropertyChangeEvent = null;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:CollectionEvent = null;
         var _loc2_:Array = param1;
         if(this.sort || this.filterFunction != null)
         {
            _loc3_ = [];
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if((_loc8_ = param1[_loc5_]).target)
               {
                  _loc9_ = _loc8_.target;
                  _loc10_ = _loc8_.target != _loc8_.source;
               }
               else
               {
                  _loc9_ = _loc8_.source;
                  _loc10_ = false;
               }
               _loc11_ = 0;
               while(_loc11_ < _loc3_.length)
               {
                  if(_loc3_[_loc11_].item == _loc9_)
                  {
                     param1 = _loc3_[_loc11_].events;
                     _loc12_ = param1.length;
                     _loc13_ = 0;
                     while(_loc13_ < _loc12_)
                     {
                        if(param1[_loc13_].property != _loc8_.property)
                        {
                           param1.push(_loc8_);
                           break;
                        }
                        _loc13_++;
                     }
                     break;
                  }
                  _loc11_++;
               }
               if(_loc11_ < _loc3_.length)
               {
                  _loc4_ = _loc3_[_loc11_];
               }
               else
               {
                  _loc4_ = {
                     "item":_loc9_,
                     "move":_loc10_,
                     "events":[_loc8_]
                  };
                  _loc3_.push(_loc4_);
               }
               _loc4_.move = _loc4_.move || this.filterFunction || !_loc8_.property || this.sort && this.sort.propertyAffectsSort(String(_loc8_.property));
               _loc5_++;
            }
            _loc2_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if((_loc4_ = _loc3_[_loc5_]).move)
               {
                  this.moveItemInView(_loc4_.item,_loc4_.item,_loc2_);
               }
               else
               {
                  _loc2_.push(_loc4_.item);
               }
               _loc5_++;
            }
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               _loc14_ = 0;
               while(_loc14_ < _loc3_.length)
               {
                  if(_loc2_[_loc7_] == _loc3_[_loc14_].item)
                  {
                     _loc6_ = _loc6_.concat(_loc3_[_loc14_].events);
                  }
                  _loc14_++;
               }
               _loc7_++;
            }
            _loc2_ = _loc6_;
         }
         if(_loc2_.length > 0)
         {
            (_loc15_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE)).kind = CollectionEventKind.UPDATE;
            _loc15_.items = _loc2_;
            this.dispatchEvent(_loc15_);
         }
      }
      
      private function handlePendingUpdates() : void
      {
         var _loc1_:Array = null;
         var _loc2_:CollectionEvent = null;
         var _loc3_:int = 0;
         var _loc4_:CollectionEvent = null;
         var _loc5_:int = 0;
         if(this.pendingUpdates)
         {
            _loc1_ = this.pendingUpdates;
            this.pendingUpdates = null;
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               if((_loc4_ = _loc1_[_loc3_]).kind == CollectionEventKind.UPDATE)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = _loc4_;
                  }
                  else
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc4_.items.length)
                     {
                        _loc2_.items.push(_loc4_.items[_loc5_]);
                        _loc5_++;
                     }
                  }
               }
               else
               {
                  this.listChangeHandler(_loc4_);
               }
               _loc3_++;
            }
            if(_loc2_)
            {
               this.listChangeHandler(_loc2_);
            }
         }
      }
      
      private function internalRefresh(param1:Boolean) : Boolean
      {
         var tmp:Array = null;
         var len:int = 0;
         var i:int = 0;
         var item:Object = null;
         var refreshEvent:CollectionEvent = null;
         var dispatch:Boolean = param1;
         if(this.sort || this.filterFunction != null)
         {
            try
            {
               this.populateLocalIndex();
            }
            catch(pending:ItemPendingError)
            {
               pending.addResponder(new ItemResponder(function(param1:Object, param2:Object = null):void
               {
                  internalRefresh(dispatch);
               },function(param1:Object, param2:Object = null):void
               {
               }));
               return false;
            }
            if(this.filterFunction != null)
            {
               tmp = [];
               len = this.localIndex.length;
               i = 0;
               while(i < len)
               {
                  item = this.localIndex[i];
                  if(this.filterFunction(item))
                  {
                     tmp.push(item);
                  }
                  i++;
               }
               this.localIndex = tmp;
            }
            if(this.sort)
            {
               this.sort.sort(this.localIndex);
               dispatch = true;
            }
         }
         else if(this.localIndex)
         {
            this.localIndex = null;
         }
         ++this.revision;
         this.pendingUpdates = null;
         if(dispatch)
         {
            refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            refreshEvent.kind = CollectionEventKind.REFRESH;
            this.dispatchEvent(refreshEvent);
         }
         return true;
      }
      
      private function moveItemInView(param1:Object, param2:Boolean = true, param3:Array = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CollectionEvent = null;
         if(this.localIndex)
         {
            _loc4_ = -1;
            _loc5_ = 0;
            while(_loc5_ < this.localIndex.length)
            {
               if(this.localIndex[_loc5_] == param1)
               {
                  _loc4_ = _loc5_;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_ > -1)
            {
               this.localIndex.splice(_loc4_,1);
            }
            _loc6_ = this.addItemsToView([param1],_loc4_,false);
            if(param2)
            {
               (_loc7_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE)).items.push(param1);
               if(param3 && _loc6_ == _loc4_ && _loc6_ > -1)
               {
                  param3.push(param1);
                  return;
               }
               if(_loc6_ > -1 && _loc4_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.MOVE;
                  _loc7_.location = _loc6_;
                  _loc7_.oldLocation = _loc4_;
               }
               else if(_loc6_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.ADD;
                  _loc7_.location = _loc6_;
               }
               else if(_loc4_ > -1)
               {
                  _loc7_.kind = CollectionEventKind.REMOVE;
                  _loc7_.location = _loc4_;
               }
               else
               {
                  param2 = false;
               }
               if(param2)
               {
                  this.dispatchEvent(_loc7_);
               }
            }
         }
      }
      
      private function populateLocalIndex() : void
      {
         if(this.list)
         {
            this.localIndex = this.list.toArray();
         }
         else
         {
            this.localIndex = [];
         }
      }
      
      private function removeItemsFromView(param1:Array, param2:int, param3:Boolean = true) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:CollectionEvent = null;
         var _loc4_:Array = !!this.localIndex ? [] : param1;
         var _loc5_:int = param2;
         if(this.localIndex)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.length)
            {
               _loc7_ = param1[_loc6_];
               if((_loc8_ = this.getItemIndex(_loc7_)) > -1)
               {
                  this.localIndex.splice(_loc8_,1);
                  _loc4_.push(_loc7_);
                  _loc5_ = _loc8_;
               }
               _loc6_++;
            }
         }
         if(param3 && _loc4_.length > 0)
         {
            (_loc9_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE)).kind = CollectionEventKind.REMOVE;
            _loc9_.location = !this.localIndex || _loc4_.length == 1 ? int(_loc5_) : -1;
            _loc9_.items = _loc4_;
            this.dispatchEvent(_loc9_);
         }
      }
      
      private function replaceItemsInView(param1:Array, param2:int, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:PropertyChangeEvent = null;
         var _loc9_:CollectionEvent = null;
         if(this.localIndex)
         {
            _loc4_ = param1.length;
            _loc5_ = [];
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc8_ = param1[_loc7_];
               _loc5_.push(_loc8_.oldValue);
               _loc6_.push(_loc8_.newValue);
               _loc7_++;
            }
            this.removeItemsFromView(_loc5_,param2,param3);
            this.addItemsToView(_loc6_,param2,param3);
         }
         else
         {
            (_loc9_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE)).kind = CollectionEventKind.REPLACE;
            _loc9_.location = param2;
            _loc9_.items = param1;
            this.dispatchEvent(_loc9_);
         }
      }
      
      mx_internal function reset() : void
      {
         var _loc1_:CollectionEvent = null;
         this.internalRefresh(false);
         if(this.dispatchResetEvent)
         {
            _loc1_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc1_.kind = CollectionEventKind.RESET;
            this.dispatchEvent(_loc1_);
         }
      }
   }
}

import flash.events.EventDispatcher;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.collections.Sort;
import mx.collections.errors.CollectionViewError;
import mx.collections.errors.CursorError;
import mx.collections.errors.ItemPendingError;
import mx.collections.errors.SortError;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

class ListCollectionViewCursor extends EventDispatcher implements IViewCursor
{
   
   private static const BEFORE_FIRST_INDEX:int = -1;
   
   private static const AFTER_LAST_INDEX:int = -2;
    
   
   private var _view:ListCollectionView;
   
   private var currentIndex:int;
   
   private var currentValue:Object;
   
   private var invalid:Boolean;
   
   private var resourceManager:IResourceManager;
   
   function ListCollectionViewCursor(param1:ListCollectionView)
   {
      var view:ListCollectionView = param1;
      this.resourceManager = ResourceManager.getInstance();
      super();
      this._view = view;
      this._view.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionEventHandler,false,0,true);
      this.currentIndex = view.length > 0 ? 0 : int(AFTER_LAST_INDEX);
      if(this.currentIndex == 0)
      {
         try
         {
            this.setCurrent(view.getItemAt(0),false);
         }
         catch(e:ItemPendingError)
         {
            currentIndex = BEFORE_FIRST_INDEX;
            setCurrent(null,false);
         }
      }
   }
   
   public function get view() : ICollectionView
   {
      this.checkValid();
      return this._view;
   }
   
   public function get current() : Object
   {
      this.checkValid();
      return this.currentValue;
   }
   
   public function get bookmark() : CursorBookmark
   {
      this.checkValid();
      if(this.view.length == 0 || this.beforeFirst)
      {
         return CursorBookmark.FIRST;
      }
      if(this.afterLast)
      {
         return CursorBookmark.LAST;
      }
      return ListCollectionView(this.view).getBookmark(this.currentIndex);
   }
   
   public function get beforeFirst() : Boolean
   {
      this.checkValid();
      return this.currentIndex == BEFORE_FIRST_INDEX || this.view.length == 0;
   }
   
   public function get afterLast() : Boolean
   {
      this.checkValid();
      return this.currentIndex == AFTER_LAST_INDEX || this.view.length == 0;
   }
   
   public function findAny(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      this.checkValid();
      var lcView:ListCollectionView = ListCollectionView(this.view);
      try
      {
         index = lcView.findItem(values,Sort.ANY_INDEX_MODE);
      }
      catch(e:SortError)
      {
         throw new CursorError(e.message);
      }
      if(index > -1)
      {
         this.currentIndex = index;
         this.setCurrent(lcView.getItemAt(this.currentIndex));
      }
      return index > -1;
   }
   
   public function findFirst(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      this.checkValid();
      var lcView:ListCollectionView = ListCollectionView(this.view);
      try
      {
         index = lcView.findItem(values,Sort.FIRST_INDEX_MODE);
      }
      catch(sortError:SortError)
      {
         throw new CursorError(sortError.message);
      }
      if(index > -1)
      {
         this.currentIndex = index;
         this.setCurrent(lcView.getItemAt(this.currentIndex));
      }
      return index > -1;
   }
   
   public function findLast(param1:Object) : Boolean
   {
      var index:int = 0;
      var values:Object = param1;
      this.checkValid();
      var lcView:ListCollectionView = ListCollectionView(this.view);
      try
      {
         index = lcView.findItem(values,Sort.LAST_INDEX_MODE);
      }
      catch(sortError:SortError)
      {
         throw new CursorError(sortError.message);
      }
      if(index > -1)
      {
         this.currentIndex = index;
         this.setCurrent(lcView.getItemAt(this.currentIndex));
      }
      return index > -1;
   }
   
   public function insert(param1:Object) : void
   {
      var _loc2_:int = 0;
      var _loc3_:String = null;
      if(this.afterLast)
      {
         _loc2_ = this.view.length;
      }
      else if(this.beforeFirst)
      {
         if(this.view.length > 0)
         {
            _loc3_ = this.resourceManager.getString("collections","invalidInsert");
            throw new CursorError(_loc3_);
         }
         _loc2_ = 0;
      }
      else
      {
         _loc2_ = this.currentIndex;
      }
      ListCollectionView(this.view).addItemAt(param1,_loc2_);
   }
   
   public function moveNext() : Boolean
   {
      if(this.afterLast)
      {
         return false;
      }
      var _loc1_:int = !!this.beforeFirst ? 0 : int(this.currentIndex + 1);
      if(_loc1_ >= this.view.length)
      {
         _loc1_ = AFTER_LAST_INDEX;
         this.setCurrent(null);
      }
      else
      {
         this.setCurrent(ListCollectionView(this.view).getItemAt(_loc1_));
      }
      this.currentIndex = _loc1_;
      return !this.afterLast;
   }
   
   public function movePrevious() : Boolean
   {
      if(this.beforeFirst)
      {
         return false;
      }
      var _loc1_:int = !!this.afterLast ? int(this.view.length - 1) : int(this.currentIndex - 1);
      if(_loc1_ == -1)
      {
         _loc1_ = BEFORE_FIRST_INDEX;
         this.setCurrent(null);
      }
      else
      {
         this.setCurrent(ListCollectionView(this.view).getItemAt(_loc1_));
      }
      this.currentIndex = _loc1_;
      return !this.beforeFirst;
   }
   
   public function remove() : Object
   {
      var oldIndex:int = 0;
      var message:String = null;
      if(this.beforeFirst || this.afterLast)
      {
         message = this.resourceManager.getString("collections","invalidRemove");
         throw new CursorError(message);
      }
      oldIndex = this.currentIndex;
      ++this.currentIndex;
      if(this.currentIndex >= this.view.length)
      {
         this.currentIndex = AFTER_LAST_INDEX;
         this.setCurrent(null);
      }
      else
      {
         try
         {
            this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
         }
         catch(e:ItemPendingError)
         {
            setCurrent(null,false);
            ListCollectionView(view).removeItemAt(oldIndex);
            throw e;
         }
      }
      var removed:Object = ListCollectionView(this.view).removeItemAt(oldIndex);
      return removed;
   }
   
   public function seek(param1:CursorBookmark, param2:int = 0, param3:int = 0) : void
   {
      var message:String = null;
      var bookmark:CursorBookmark = param1;
      var offset:int = param2;
      var prefetch:int = param3;
      this.checkValid();
      if(this.view.length == 0)
      {
         this.currentIndex = AFTER_LAST_INDEX;
         this.setCurrent(null,false);
         return;
      }
      var newIndex:int = this.currentIndex;
      if(bookmark == CursorBookmark.FIRST)
      {
         newIndex = 0;
      }
      else if(bookmark == CursorBookmark.LAST)
      {
         newIndex = this.view.length - 1;
      }
      else if(bookmark != CursorBookmark.CURRENT)
      {
         try
         {
            newIndex = ListCollectionView(this.view).getBookmarkIndex(bookmark);
            if(newIndex < 0)
            {
               this.setCurrent(null);
               message = this.resourceManager.getString("collections","bookmarkInvalid");
               throw new CursorError(message);
            }
         }
         catch(bmError:CollectionViewError)
         {
            message = resourceManager.getString("collections","bookmarkInvalid");
            throw new CursorError(message);
         }
      }
      newIndex += offset;
      var newCurrent:Object = null;
      if(newIndex >= this.view.length)
      {
         this.currentIndex = AFTER_LAST_INDEX;
      }
      else if(newIndex < 0)
      {
         this.currentIndex = BEFORE_FIRST_INDEX;
      }
      else
      {
         newCurrent = ListCollectionView(this.view).getItemAt(newIndex,prefetch);
         this.currentIndex = newIndex;
      }
      this.setCurrent(newCurrent);
   }
   
   private function checkValid() : void
   {
      var _loc1_:String = null;
      if(this.invalid)
      {
         _loc1_ = this.resourceManager.getString("collections","invalidCursor");
         throw new CursorError(_loc1_);
      }
   }
   
   private function collectionEventHandler(param1:CollectionEvent) : void
   {
      var event:CollectionEvent = param1;
      switch(event.kind)
      {
         case CollectionEventKind.ADD:
            if(event.location <= this.currentIndex)
            {
               this.currentIndex += event.items.length;
            }
            break;
         case CollectionEventKind.REMOVE:
            if(event.location < this.currentIndex)
            {
               this.currentIndex -= event.items.length;
            }
            else if(event.location == this.currentIndex)
            {
               if(this.currentIndex < this.view.length)
               {
                  try
                  {
                     this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
                  }
                  catch(error:ItemPendingError)
                  {
                     setCurrent(null,false);
                  }
               }
               else
               {
                  this.currentIndex = AFTER_LAST_INDEX;
                  this.setCurrent(null);
               }
            }
            break;
         case CollectionEventKind.MOVE:
            if(event.oldLocation == this.currentIndex)
            {
               this.currentIndex = event.location;
            }
            else
            {
               if(event.oldLocation < this.currentIndex)
               {
                  this.currentIndex -= event.items.length;
               }
               if(event.location <= this.currentIndex)
               {
                  this.currentIndex += event.items.length;
               }
            }
            break;
         case CollectionEventKind.REFRESH:
            if(!(this.beforeFirst || this.afterLast))
            {
               try
               {
                  this.currentIndex = ListCollectionView(this.view).getItemIndex(this.currentValue);
               }
               catch(e:SortError)
               {
                  if(ListCollectionView(view).sort)
                  {
                     currentIndex = ListCollectionView(view).getLocalItemIndex(currentValue);
                  }
               }
               if(this.currentIndex == -1)
               {
                  this.setCurrent(null);
               }
            }
            break;
         case CollectionEventKind.REPLACE:
            if(event.location == this.currentIndex)
            {
               try
               {
                  this.setCurrent(ListCollectionView(this.view).getItemAt(this.currentIndex));
               }
               catch(error:ItemPendingError)
               {
                  setCurrent(null,false);
               }
            }
            break;
         case CollectionEventKind.RESET:
            this.currentIndex = BEFORE_FIRST_INDEX;
            this.setCurrent(null);
      }
   }
   
   private function setCurrent(param1:Object, param2:Boolean = true) : void
   {
      this.currentValue = param1;
      if(param2)
      {
         dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
      }
   }
}

import mx.collections.CursorBookmark;
import mx.collections.ListCollectionView;
import mx.core.mx_internal;

use namespace mx_internal;

class ListCollectionViewBookmark extends CursorBookmark
{
    
   
   mx_internal var index:int;
   
   mx_internal var view:ListCollectionView;
   
   mx_internal var viewRevision:int;
   
   function ListCollectionViewBookmark(param1:Object, param2:ListCollectionView, param3:int, param4:int)
   {
      super(param1);
      this.view = param2;
      this.viewRevision = param3;
      this.index = param4;
   }
   
   override public function getViewIndex() : int
   {
      return this.view.getBookmarkIndex(this);
   }
}
