package org.papervision3d.render
{
   import flash.geom.Point;
   import org.papervision3d.core.clipping.DefaultClipping;
   import org.papervision3d.core.clipping.FrustumClipping;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.AbstractRenderEngine;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.core.render.command.IRenderListItem;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.data.RenderStatistics;
   import org.papervision3d.core.render.filter.BasicRenderFilter;
   import org.papervision3d.core.render.filter.IRenderFilter;
   import org.papervision3d.core.render.material.MaterialManager;
   import org.papervision3d.core.render.project.BasicProjectionPipeline;
   import org.papervision3d.core.render.project.ProjectionPipeline;
   import org.papervision3d.core.render.sort.BasicRenderSorter;
   import org.papervision3d.core.render.sort.IRenderSorter;
   import org.papervision3d.core.utils.StopWatch;
   import org.papervision3d.events.RendererEvent;
   import org.papervision3d.view.Viewport3D;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class BasicRenderEngine extends AbstractRenderEngine implements IRenderEngine
   {
       
      
      public var projectionPipeline:ProjectionPipeline;
      
      public var sorter:IRenderSorter;
      
      public var clipping:DefaultClipping;
      
      public var TerrainClip:FrustumClipping;
      
      public var filter:IRenderFilter;
      
      protected var renderDoneEvent:RendererEvent;
      
      protected var projectionDoneEvent:RendererEvent;
      
      protected var renderStatistics:RenderStatistics;
      
      protected var renderList:Array;
      
      protected var renderSessionData:RenderSessionData;
      
      protected var cleanRHD:RenderHitData;
      
      protected var stopWatch:StopWatch;
      
      public var drawTriangleCount:int;
      
      public function BasicRenderEngine()
      {
         this.cleanRHD = new RenderHitData();
         super();
         this.init();
      }
      
      public function destroy() : void
      {
         this.renderDoneEvent = null;
         this.projectionDoneEvent = null;
         this.projectionPipeline = null;
         this.sorter = null;
         this.filter = null;
         this.renderStatistics = null;
         this.renderList = null;
         this.renderSessionData.destroy();
         this.renderSessionData = null;
         this.cleanRHD = null;
         this.stopWatch = null;
         this.clipping = null;
      }
      
      protected function init() : void
      {
         this.renderStatistics = new RenderStatistics();
         this.projectionPipeline = new BasicProjectionPipeline();
         this.stopWatch = new StopWatch();
         this.sorter = new BasicRenderSorter();
         this.filter = new BasicRenderFilter();
         this.renderList = new Array();
         this.clipping = null;
         this.TerrainClip = new FrustumClipping(FrustumClipping.NEAR + FrustumClipping.LEFT + FrustumClipping.RIGHT);
         this.renderSessionData = new RenderSessionData();
         this.renderSessionData.renderer = this;
         this.projectionDoneEvent = new RendererEvent(RendererEvent.PROJECTION_DONE,this.renderSessionData);
         this.renderDoneEvent = new RendererEvent(RendererEvent.RENDER_DONE,this.renderSessionData);
      }
      
      override public function renderScene(param1:SceneObject3D, param2:CameraObject3D, param3:Viewport3D) : RenderStatistics
      {
         param2.viewport = param3.sizeRectangle;
         this.renderSessionData.scene = param1;
         this.renderSessionData.camera = param2;
         this.renderSessionData.viewPort = param3;
         this.renderSessionData.container = param3.containerSprite;
         this.renderSessionData.triangleCuller = param3.triangleCuller;
         this.renderSessionData.particleCuller = param3.particleCuller;
         this.renderSessionData.renderObjects = param1.objects;
         this.renderSessionData.renderLayers = null;
         this.renderSessionData.renderStatistics.clear();
         this.renderSessionData.clipping = this.clipping;
         this.renderSessionData.TerrainClip = this.TerrainClip;
         if(this.clipping)
         {
            this.clipping.reset(this.renderSessionData);
         }
         this.TerrainClip.reset(this.renderSessionData);
         param3.updateBeforeRender(this.renderSessionData);
         this.projectionPipeline.project(this.renderSessionData);
         if(hasEventListener(RendererEvent.PROJECTION_DONE))
         {
            dispatchEvent(this.projectionDoneEvent);
         }
         this.doRender(this.renderSessionData,null);
         if(hasEventListener(RendererEvent.RENDER_DONE))
         {
            dispatchEvent(this.renderDoneEvent);
         }
         return this.renderSessionData.renderStatistics;
      }
      
      public function renderLayers(param1:SceneObject3D, param2:CameraObject3D, param3:Viewport3D, param4:Array = null) : RenderStatistics
      {
         this.renderSessionData.scene = param1;
         this.renderSessionData.camera = param2;
         this.renderSessionData.viewPort = param3;
         this.renderSessionData.container = param3.containerSprite;
         this.renderSessionData.triangleCuller = param3.triangleCuller;
         this.renderSessionData.particleCuller = param3.particleCuller;
         this.renderSessionData.renderObjects = this.getLayerObjects(param4);
         this.renderSessionData.renderLayers = param4;
         this.renderSessionData.renderStatistics.clear();
         this.renderSessionData.clipping = this.clipping;
         param3.updateBeforeRender(this.renderSessionData);
         this.projectionPipeline.project(this.renderSessionData);
         if(hasEventListener(RendererEvent.PROJECTION_DONE))
         {
            dispatchEvent(this.projectionDoneEvent);
         }
         this.doRender(this.renderSessionData);
         if(hasEventListener(RendererEvent.RENDER_DONE))
         {
            dispatchEvent(this.renderDoneEvent);
         }
         return this.renderSessionData.renderStatistics;
      }
      
      private function getLayerObjects(param1:Array) : Array
      {
         var _loc3_:ViewportLayer = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc2_.concat(_loc3_.getLayerObjects());
         }
         return _loc2_;
      }
      
      protected function doRender(param1:RenderSessionData, param2:Array = null) : RenderStatistics
      {
         var _loc3_:RenderableListItem = null;
         var _loc5_:ViewportLayer = null;
         this.stopWatch.reset();
         this.stopWatch.start();
         MaterialManager.getInstance().updateMaterialsBeforeRender(param1);
         this.filter.filter(this.renderList);
         this.sorter.sort(this.renderList);
         var _loc4_:Viewport3D = param1.viewPort;
         this.drawTriangleCount = 0;
         while(_loc3_ = this.renderList.pop())
         {
            ++this.drawTriangleCount;
            _loc5_ = _loc4_.accessLayerFor(_loc3_,true);
            _loc3_.render(param1,_loc5_.graphicsChannel);
            _loc4_.lastRenderList.push(_loc3_);
            _loc5_.processRenderItem(_loc3_);
         }
         MaterialManager.getInstance().updateMaterialsAfterRender(param1);
         param1.renderStatistics.triangles = 0;
         param1.renderStatistics.triangles = this.drawTriangleCount;
         param1.renderStatistics.renderTime = this.stopWatch.stop();
         param1.viewPort.updateAfterRender(param1);
         return this.renderStatistics;
      }
      
      public function hitTestPoint2D(param1:Point, param2:Viewport3D) : RenderHitData
      {
         return param2.hitTestPoint2D(param1);
      }
      
      override public function addToRenderList(param1:RenderableListItem) : int
      {
         return this.renderList.push(param1);
      }
      
      override public function removeFromRenderList(param1:IRenderListItem) : int
      {
         return this.renderList.splice(this.renderList.indexOf(param1),1);
      }
   }
}
