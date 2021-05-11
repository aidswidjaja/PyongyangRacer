package org.papervision3d.view
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.papervision3d.core.culling.DefaultLineCuller;
   import org.papervision3d.core.culling.DefaultParticleCuller;
   import org.papervision3d.core.culling.DefaultTriangleCuller;
   import org.papervision3d.core.culling.ILineCuller;
   import org.papervision3d.core.culling.IParticleCuller;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.culling.RectangleLineCuller;
   import org.papervision3d.core.culling.RectangleParticleCuller;
   import org.papervision3d.core.culling.RectangleTriangleCuller;
   import org.papervision3d.core.culling.ViewportObjectFilter;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.utils.InteractiveSceneManager;
   import org.papervision3d.core.view.IViewport3D;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.layer.ViewportBaseLayer;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class Viewport3D extends Sprite implements IViewport3D
   {
       
      
      protected var _width:Number;
      
      protected var _hWidth:Number;
      
      protected var _height:Number;
      
      protected var _hHeight:Number;
      
      protected var _autoClipping:Boolean;
      
      protected var _autoCulling:Boolean;
      
      protected var _autoScaleToStage:Boolean;
      
      protected var _interactive:Boolean;
      
      protected var _lastRenderer:IRenderEngine;
      
      protected var _viewportObjectFilter:ViewportObjectFilter;
      
      protected var _containerSprite:ViewportBaseLayer;
      
      protected var _layerInstances:Dictionary;
      
      public var sizeRectangle:Rectangle;
      
      public var cullingRectangle:Rectangle;
      
      public var triangleCuller:ITriangleCuller;
      
      public var particleCuller:IParticleCuller;
      
      public var lineCuller:ILineCuller;
      
      public var lastRenderList:Array;
      
      public var interactiveSceneManager:InteractiveSceneManager;
      
      protected var renderHitData:RenderHitData;
      
      private var stageScaleModeSet:Boolean = false;
      
      public function Viewport3D(param1:Number = 640, param2:Number = 480, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true, param6:Boolean = true)
      {
         super();
         this.init();
         this.interactive = param4;
         this.viewportWidth = param1;
         this.viewportHeight = param2;
         this.autoClipping = param5;
         this.autoCulling = param6;
         this.autoScaleToStage = param3;
         this._layerInstances = new Dictionary(true);
      }
      
      public function destroy() : void
      {
         if(this.interactiveSceneManager)
         {
            this.interactiveSceneManager.destroy();
            this.interactiveSceneManager = null;
         }
         this.lastRenderList = null;
      }
      
      protected function init() : void
      {
         this.renderHitData = new RenderHitData();
         this.lastRenderList = new Array();
         this.sizeRectangle = new Rectangle();
         this.cullingRectangle = new Rectangle();
         this._containerSprite = new ViewportBaseLayer(this);
         this._containerSprite.doubleClickEnabled = true;
         addChild(this._containerSprite);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function hitTestMouse() : RenderHitData
      {
         var _loc1_:Point = new Point(this.containerSprite.mouseX,this.containerSprite.mouseY);
         return this.hitTestPoint2D(_loc1_);
      }
      
      public function hitTestPoint2D(param1:Point) : RenderHitData
      {
         var _loc2_:RenderableListItem = null;
         var _loc3_:RenderHitData = null;
         var _loc4_:IRenderListItem = null;
         var _loc5_:uint = 0;
         this.renderHitData.clear();
         if(this.interactive)
         {
            _loc3_ = this.renderHitData;
            _loc5_ = this.lastRenderList.length;
            while(_loc4_ = this.lastRenderList[--_loc5_])
            {
               if(_loc4_ is RenderableListItem)
               {
                  _loc2_ = _loc4_ as RenderableListItem;
                  _loc3_ = _loc2_.hitTestPoint2D(param1,_loc3_);
                  if(_loc3_.hasHit)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return this.renderHitData;
      }
      
      public function hitTestPointObject(param1:Point, param2:DisplayObject3D) : RenderHitData
      {
         var _loc3_:RenderableListItem = null;
         var _loc4_:RenderHitData = null;
         var _loc5_:IRenderListItem = null;
         var _loc6_:uint = 0;
         if(this.interactive)
         {
            _loc4_ = new RenderHitData();
            _loc6_ = this.lastRenderList.length;
            while(_loc5_ = this.lastRenderList[--_loc6_])
            {
               if(_loc5_ is RenderableListItem)
               {
                  _loc3_ = _loc5_ as RenderableListItem;
                  if(_loc3_.renderableInstance is Triangle3D)
                  {
                     if(Triangle3D(_loc3_.renderableInstance).instance == param2)
                     {
                        if((_loc4_ = _loc3_.hitTestPoint2D(param1,_loc4_)).hasHit)
                        {
                           return _loc4_;
                        }
                     }
                  }
               }
            }
         }
         return new RenderHitData();
      }
      
      public function getChildLayer(param1:DisplayObject3D, param2:Boolean = true, param3:Boolean = true) : ViewportLayer
      {
         return this.containerSprite.getChildLayer(param1,param2,param3);
      }
      
      public function accessLayerFor(param1:RenderableListItem, param2:Boolean = false) : ViewportLayer
      {
         var _loc3_:DisplayObject3D = null;
         if(param1.renderableInstance)
         {
            _loc3_ = param1.renderableInstance.instance;
            _loc3_ = !!_loc3_.parentContainer ? _loc3_.parentContainer : _loc3_;
            if(this.containerSprite.layers[_loc3_])
            {
               if(param2)
               {
                  _loc3_.container = this.containerSprite.layers[_loc3_];
               }
               return this.containerSprite.layers[_loc3_];
            }
            if(_loc3_.useOwnContainer)
            {
               return this.containerSprite.getChildLayer(_loc3_,true,true);
            }
         }
         return this.containerSprite;
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         if(this._autoScaleToStage)
         {
            this.setStageScaleMode();
         }
         stage.addEventListener(Event.RESIZE,this.onStageResize);
         this.onStageResize();
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onStageResize);
      }
      
      protected function onStageResize(param1:Event = null) : void
      {
         if(this._autoScaleToStage)
         {
            this.viewportWidth = stage.stageWidth;
            this.viewportHeight = stage.stageHeight;
         }
      }
      
      protected function setStageScaleMode() : void
      {
         if(!this.stageScaleModeSet)
         {
            PaperLogger.info("Viewport autoScaleToStage : Papervision has changed the Stage scale mode.");
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            this.stageScaleModeSet = true;
         }
      }
      
      public function set viewportWidth(param1:Number) : void
      {
         this._width = param1;
         this._hWidth = param1 / 2;
         this.containerSprite.x = this._hWidth;
         this.cullingRectangle.x = -this._hWidth;
         this.cullingRectangle.width = param1;
         this.sizeRectangle.width = param1;
         if(this._autoClipping)
         {
            scrollRect = this.sizeRectangle;
         }
      }
      
      public function get viewportWidth() : Number
      {
         return this._width;
      }
      
      public function set viewportHeight(param1:Number) : void
      {
         this._height = param1;
         this._hHeight = param1 / 2;
         this.containerSprite.y = this._hHeight;
         this.cullingRectangle.y = -this._hHeight;
         this.cullingRectangle.height = param1;
         this.sizeRectangle.height = param1;
         if(this._autoClipping)
         {
            scrollRect = this.sizeRectangle;
         }
      }
      
      public function get viewportHeight() : Number
      {
         return this._height;
      }
      
      public function get containerSprite() : ViewportLayer
      {
         return this._containerSprite;
      }
      
      public function get autoClipping() : Boolean
      {
         return this._autoClipping;
      }
      
      public function set autoClipping(param1:Boolean) : void
      {
         if(param1)
         {
            scrollRect = this.sizeRectangle;
         }
         else
         {
            scrollRect = null;
         }
         this._autoClipping = param1;
      }
      
      public function get autoCulling() : Boolean
      {
         return this._autoCulling;
      }
      
      public function set autoCulling(param1:Boolean) : void
      {
         if(param1)
         {
            this.triangleCuller = new RectangleTriangleCuller(this.cullingRectangle);
            this.particleCuller = new RectangleParticleCuller(this.cullingRectangle);
            this.lineCuller = new RectangleLineCuller(this.cullingRectangle);
         }
         else if(!param1)
         {
            this.triangleCuller = new DefaultTriangleCuller();
            this.particleCuller = new DefaultParticleCuller();
            this.lineCuller = new DefaultLineCuller();
         }
         this._autoCulling = param1;
      }
      
      public function set autoScaleToStage(param1:Boolean) : void
      {
         this._autoScaleToStage = param1;
         if(param1 && stage != null)
         {
            this.setStageScaleMode();
            this.onStageResize();
         }
      }
      
      public function get autoScaleToStage() : Boolean
      {
         return this._autoScaleToStage;
      }
      
      public function set interactive(param1:Boolean) : void
      {
         if(param1 != this._interactive)
         {
            if(this._interactive && this.interactiveSceneManager)
            {
               this.interactiveSceneManager.destroy();
               this.interactiveSceneManager = null;
            }
            this._interactive = param1;
            if(param1)
            {
               this.interactiveSceneManager = new InteractiveSceneManager(this);
            }
         }
      }
      
      public function get interactive() : Boolean
      {
         return this._interactive;
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
         var _loc2_:ViewportLayer = null;
         this.lastRenderList.length = 0;
         if(param1.renderLayers)
         {
            for each(_loc2_ in param1.renderLayers)
            {
               _loc2_.updateBeforeRender();
            }
         }
         else
         {
            this._containerSprite.updateBeforeRender();
         }
         this._layerInstances = new Dictionary(true);
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
         var _loc2_:ViewportLayer = null;
         if(this.interactive)
         {
            this.interactiveSceneManager.updateAfterRender();
         }
         if(param1.renderLayers)
         {
            for each(_loc2_ in param1.renderLayers)
            {
               _loc2_.updateInfo();
               _loc2_.sortChildLayers();
               _loc2_.updateAfterRender();
            }
         }
         else
         {
            this.containerSprite.updateInfo();
            this.containerSprite.updateAfterRender();
         }
         this.containerSprite.sortChildLayers();
      }
      
      public function set viewportObjectFilter(param1:ViewportObjectFilter) : void
      {
         this._viewportObjectFilter = param1;
      }
      
      public function get viewportObjectFilter() : ViewportObjectFilter
      {
         return this._viewportObjectFilter;
      }
   }
}
