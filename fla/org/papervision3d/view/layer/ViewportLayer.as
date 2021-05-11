package org.papervision3d.view.layer
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.view.layer.util.ViewportLayerSortMode;
   
   public class ViewportLayer extends Sprite
   {
       
      
      public var childLayers:Array;
      
      public var layers:Dictionary;
      
      public var displayObject3D:DisplayObject3D;
      
      public var displayObjects:Dictionary;
      
      public var layerIndex:Number;
      
      public var forceDepth:Boolean = false;
      
      public var screenDepth:Number = 0;
      
      public var originDepth:Number = 0;
      
      public var weight:Number = 0;
      
      public var sortMode:String;
      
      public var dynamicLayer:Boolean = false;
      
      public var graphicsChannel:Graphics;
      
      protected var viewport:Viewport3D;
      
      public function ViewportLayer(param1:Viewport3D, param2:DisplayObject3D, param3:Boolean = false)
      {
         this.layers = new Dictionary(true);
         this.displayObjects = new Dictionary(true);
         this.sortMode = ViewportLayerSortMode.Z_SORT;
         super();
         this.viewport = param1;
         this.displayObject3D = param2;
         this.dynamicLayer = param3;
         this.graphicsChannel = this.graphics;
         if(param3)
         {
            this.filters = param2.filters;
            this.blendMode = param2.blendMode;
            this.alpha = param2.alpha;
         }
         if(param2)
         {
            this.addDisplayObject3D(param2);
            param2.container = this;
         }
         this.init();
      }
      
      public function addDisplayObject3D(param1:DisplayObject3D, param2:Boolean = false) : void
      {
         if(!param1)
         {
            return;
         }
         this.displayObjects[param1] = param1;
         dispatchEvent(new ViewportLayerEvent(ViewportLayerEvent.CHILD_ADDED,param1,this));
         if(param2)
         {
            param1.addChildrenToLayer(param1,this);
         }
      }
      
      public function removeDisplayObject3D(param1:DisplayObject3D) : void
      {
         this.displayObjects[param1] = null;
         dispatchEvent(new ViewportLayerEvent(ViewportLayerEvent.CHILD_REMOVED,param1,this));
      }
      
      public function hasDisplayObject3D(param1:DisplayObject3D) : Boolean
      {
         return this.displayObjects[param1] != null;
      }
      
      protected function init() : void
      {
         this.childLayers = new Array();
      }
      
      public function getChildLayer(param1:DisplayObject3D, param2:Boolean = true, param3:Boolean = false) : ViewportLayer
      {
         param1 = !!param1.parentContainer ? param1.parentContainer : param1;
         if(this.layers[param1])
         {
            return this.layers[param1];
         }
         if(param2)
         {
            return this.getChildLayerFor(param1,param3);
         }
         return null;
      }
      
      protected function getChildLayerFor(param1:DisplayObject3D, param2:Boolean = false) : ViewportLayer
      {
         var _loc3_:ViewportLayer = null;
         if(param1)
         {
            _loc3_ = new ViewportLayer(this.viewport,param1,param1.useOwnContainer);
            this.addLayer(_loc3_);
            if(param2)
            {
               param1.addChildrenToLayer(param1,_loc3_);
            }
            return _loc3_;
         }
         PaperLogger.warning("Needs to be a do3d");
         return null;
      }
      
      public function childLayerIndex(param1:DisplayObject3D) : Number
      {
         param1 = !!param1.parentContainer ? param1.parentContainer : param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.childLayers.length)
         {
            if(this.childLayers[_loc2_].hasDisplayObject3D(param1))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function addLayer(param1:ViewportLayer) : void
      {
         var _loc2_:DisplayObject3D = null;
         var _loc3_:ViewportLayer = null;
         if(this.childLayers.indexOf(param1) != -1)
         {
            PaperLogger.warning("Child layer already exists in ViewportLayer");
            return;
         }
         this.childLayers.push(param1);
         addChild(param1);
         param1.addEventListener(ViewportLayerEvent.CHILD_ADDED,this.onChildAdded);
         param1.addEventListener(ViewportLayerEvent.CHILD_REMOVED,this.onChildRemoved);
         for each(_loc2_ in param1.displayObjects)
         {
            this.linkChild(_loc2_,param1);
         }
         for each(_loc3_ in param1.layers)
         {
            for each(_loc2_ in _loc3_.displayObjects)
            {
               this.linkChild(_loc2_,_loc3_);
            }
         }
      }
      
      private function linkChild(param1:DisplayObject3D, param2:ViewportLayer, param3:ViewportLayerEvent = null) : void
      {
         this.layers[param1] = param2;
         dispatchEvent(new ViewportLayerEvent(ViewportLayerEvent.CHILD_ADDED,param1,param2));
      }
      
      private function unlinkChild(param1:DisplayObject3D, param2:ViewportLayerEvent = null) : void
      {
         this.layers[param1] = null;
         dispatchEvent(new ViewportLayerEvent(ViewportLayerEvent.CHILD_REMOVED,param1));
      }
      
      private function onChildAdded(param1:ViewportLayerEvent) : void
      {
         if(param1.do3d)
         {
            this.linkChild(param1.do3d,param1.layer,param1);
         }
      }
      
      private function onChildRemoved(param1:ViewportLayerEvent) : void
      {
         if(param1.do3d)
         {
            this.unlinkChild(param1.do3d,param1);
         }
      }
      
      public function updateBeforeRender() : void
      {
         var _loc1_:ViewportLayer = null;
         this.clear();
         for each(_loc1_ in this.childLayers)
         {
            _loc1_.updateBeforeRender();
         }
      }
      
      public function updateAfterRender() : void
      {
         var _loc1_:ViewportLayer = null;
         for each(_loc1_ in this.childLayers)
         {
            _loc1_.updateAfterRender();
         }
      }
      
      public function removeLayer(param1:ViewportLayer) : void
      {
         var _loc2_:int = getChildIndex(param1);
         if(_loc2_ > -1)
         {
            this.removeLayerAt(_loc2_);
         }
         else
         {
            PaperLogger.error("Layer not found for removal.");
         }
      }
      
      public function removeLayerAt(param1:Number) : void
      {
         var _loc2_:DisplayObject3D = null;
         for each(_loc2_ in this.childLayers[param1].displayObjects)
         {
            this.unlinkChild(_loc2_);
         }
         removeChild(this.childLayers[param1]);
         this.childLayers.splice(param1,1);
      }
      
      public function getLayerObjects(param1:Array = null) : Array
      {
         var _loc2_:DisplayObject3D = null;
         var _loc3_:ViewportLayer = null;
         if(!param1)
         {
            param1 = new Array();
         }
         for each(_loc2_ in this.displayObjects)
         {
            if(_loc2_)
            {
               param1.push(_loc2_);
            }
         }
         for each(_loc3_ in this.childLayers)
         {
            _loc3_.getLayerObjects(param1);
         }
         return param1;
      }
      
      public function clear() : void
      {
         this.graphicsChannel.clear();
         this.reset();
      }
      
      protected function reset() : void
      {
         if(!this.forceDepth)
         {
            this.screenDepth = 0;
            this.originDepth = 0;
         }
         this.weight = 0;
      }
      
      public function sortChildLayers() : void
      {
         switch(this.sortMode)
         {
            case ViewportLayerSortMode.Z_SORT:
               this.childLayers.sortOn("screenDepth",Array.DESCENDING | Array.NUMERIC);
               break;
            case ViewportLayerSortMode.INDEX_SORT:
               this.childLayers.sortOn("layerIndex",Array.NUMERIC);
               break;
            case ViewportLayerSortMode.ORIGIN_SORT:
               this.childLayers.sortOn(["originDepth","screenDepth"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC]);
         }
         this.orderLayers();
      }
      
      protected function orderLayers() : void
      {
         var _loc2_:ViewportLayer = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.childLayers.length)
         {
            _loc2_ = this.childLayers[_loc1_];
            if(this.getChildIndex(_loc2_) != _loc1_)
            {
               this.setChildIndex(_loc2_,_loc1_);
            }
            _loc2_.sortChildLayers();
            _loc1_++;
         }
      }
      
      public function processRenderItem(param1:RenderableListItem) : void
      {
         if(!this.forceDepth)
         {
            if(!isNaN(param1.screenZ))
            {
               this.screenDepth += param1.screenZ;
               if(param1.instance)
               {
                  this.originDepth += param1.instance.world.n34;
                  this.originDepth += param1.instance.screen.z;
               }
               ++this.weight;
            }
         }
      }
      
      public function updateInfo() : void
      {
         var _loc1_:ViewportLayer = null;
         for each(_loc1_ in this.childLayers)
         {
            _loc1_.updateInfo();
            if(!this.forceDepth)
            {
               if(!isNaN(_loc1_.screenDepth))
               {
                  this.weight += _loc1_.weight;
                  this.screenDepth += _loc1_.screenDepth * _loc1_.weight;
                  this.originDepth += _loc1_.originDepth * _loc1_.weight;
               }
            }
         }
         if(!this.forceDepth)
         {
            this.screenDepth /= this.weight;
            this.originDepth /= this.weight;
         }
      }
      
      public function removeAllLayers() : void
      {
         var _loc1_:int = this.childLayers.length - 1;
         while(_loc1_ >= 0)
         {
            this.removeLayerAt(_loc1_);
            _loc1_--;
         }
      }
   }
}
