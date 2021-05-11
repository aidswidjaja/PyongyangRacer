package org.papervision3d.core.render.data
{
   import flash.display.Sprite;
   import org.papervision3d.core.clipping.DefaultClipping;
   import org.papervision3d.core.clipping.FrustumClipping;
   import org.papervision3d.core.culling.IParticleCuller;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.proto.SceneObject3D;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.view.Viewport3D;
   
   public class RenderSessionData
   {
       
      
      public var sorted:Boolean;
      
      public var triangleCuller:ITriangleCuller;
      
      public var particleCuller:IParticleCuller;
      
      public var viewPort:Viewport3D;
      
      public var container:Sprite;
      
      public var scene:SceneObject3D;
      
      public var camera:CameraObject3D;
      
      public var renderer:IRenderEngine;
      
      public var renderStatistics:RenderStatistics;
      
      public var renderObjects:Array;
      
      public var renderLayers:Array;
      
      public var clipping:DefaultClipping;
      
      public var quadrantTree:QuadTree;
      
      public var TerrainClip:FrustumClipping;
      
      public function RenderSessionData()
      {
         super();
         this.renderStatistics = new RenderStatistics();
      }
      
      public function destroy() : void
      {
         this.triangleCuller = null;
         this.particleCuller = null;
         this.viewPort = null;
         this.container = null;
         this.scene = null;
         this.camera = null;
         this.renderer = null;
         this.renderStatistics = null;
         this.renderObjects = null;
         this.renderLayers = null;
         this.clipping = null;
         this.quadrantTree = null;
      }
      
      public function clone() : RenderSessionData
      {
         var _loc1_:RenderSessionData = new RenderSessionData();
         _loc1_.triangleCuller = this.triangleCuller;
         _loc1_.particleCuller = this.particleCuller;
         _loc1_.viewPort = this.viewPort;
         _loc1_.container = this.container;
         _loc1_.scene = this.scene;
         _loc1_.camera = this.camera;
         _loc1_.renderer = this.renderer;
         _loc1_.renderStatistics = this.renderStatistics.clone();
         _loc1_.clipping = this.clipping;
         _loc1_.quadrantTree = this.quadrantTree;
         return _loc1_;
      }
   }
}
