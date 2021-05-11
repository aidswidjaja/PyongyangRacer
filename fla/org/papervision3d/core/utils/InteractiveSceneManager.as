package org.papervision3d.core.utils
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.utils.virtualmouse.IVirtualMouseEvent;
   import org.papervision3d.core.utils.virtualmouse.VirtualMouse;
   import org.papervision3d.events.InteractiveScene3DEvent;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.view.Viewport3D;
   
   public class InteractiveSceneManager extends EventDispatcher
   {
      
      public static var MOUSE_IS_DOWN:Boolean = false;
       
      
      public var virtualMouse:VirtualMouse;
      
      public var mouse3D:Mouse3D;
      
      public var viewport:Viewport3D;
      
      public var container:Sprite;
      
      public var renderHitData:RenderHitData;
      
      public var currentDisplayObject3D:DisplayObject3D;
      
      public var currentMaterial:MaterialObject3D;
      
      public var enableOverOut:Boolean = true;
      
      public var currentMouseDO3D:DisplayObject3D = null;
      
      public var debug:Boolean = false;
      
      public var currentMousePos:Point;
      
      public var lastMousePos:Point;
      
      public var _viewportRendered:Boolean = false;
      
      public function InteractiveSceneManager(param1:Viewport3D)
      {
         this.virtualMouse = new VirtualMouse();
         this.mouse3D = new Mouse3D();
         this.currentMousePos = new Point();
         this.lastMousePos = new Point();
         super();
         this.viewport = param1;
         this.container = param1.containerSprite;
         this.init();
      }
      
      public function destroy() : void
      {
         this.viewport = null;
         this.renderHitData = null;
         this.currentDisplayObject3D = null;
         this.currentMaterial = null;
         this.currentMouseDO3D = null;
         this.virtualMouse.stage = null;
         this.virtualMouse.container = null;
         this.container.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMousePress);
         this.container.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseRelease);
         this.container.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.container.removeEventListener(MouseEvent.DOUBLE_CLICK,this.handleMouseDoubleClick);
         if(this.container.stage)
         {
            this.container.stage.removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
         }
         this.container = null;
      }
      
      public function init() : void
      {
         if(this.container)
         {
            if(this.container.stage)
            {
               this.initVirtualMouse();
               this.initListeners();
            }
            else
            {
               this.container.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
            }
         }
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         this.container.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.initVirtualMouse();
         this.initListeners();
      }
      
      protected function initVirtualMouse() : void
      {
         this.virtualMouse.stage = this.container.stage;
         this.virtualMouse.container = this.container;
      }
      
      public function initListeners() : void
      {
         if(this.viewport.interactive)
         {
            this.container.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMousePress,false,0,true);
            this.container.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseRelease,false,0,true);
            this.container.addEventListener(MouseEvent.CLICK,this.handleMouseClick,false,0,true);
            this.container.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleMouseDoubleClick,false,0,true);
            this.container.stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
      }
      
      public function updateRenderHitData() : void
      {
         this.resolveRenderHitData();
         this.currentDisplayObject3D = this.renderHitData.displayObject3D;
         this.currentMaterial = this.renderHitData.material;
         this.manageOverOut();
      }
      
      protected function manageOverOut() : void
      {
         if(!this.enableOverOut)
         {
            return;
         }
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            if(!this.currentMouseDO3D && this.currentDisplayObject3D)
            {
               this.handleMouseOver(this.currentDisplayObject3D);
               this.currentMouseDO3D = this.currentDisplayObject3D;
            }
            else if(this.currentMouseDO3D && this.currentMouseDO3D != this.currentDisplayObject3D)
            {
               this.handleMouseOut(this.currentMouseDO3D);
               this.handleMouseOver(this.currentDisplayObject3D);
               this.currentMouseDO3D = this.currentDisplayObject3D;
            }
         }
         else if(this.currentMouseDO3D != null)
         {
            this.handleMouseOut(this.currentMouseDO3D);
            this.currentMouseDO3D = null;
         }
      }
      
      protected function resolveRenderHitData() : void
      {
         this.renderHitData = this.viewport.hitTestPoint2D(this.currentMousePos) as RenderHitData;
      }
      
      protected function handleMousePress(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         MOUSE_IS_DOWN = true;
         if(this.virtualMouse)
         {
            this.virtualMouse.press();
         }
         if(Mouse3D.enabled && this.renderHitData && this.renderHitData.renderable != null)
         {
            this.mouse3D.updatePosition(this.renderHitData);
         }
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_PRESS,this.currentDisplayObject3D);
         }
      }
      
      protected function handleMouseRelease(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         MOUSE_IS_DOWN = false;
         if(this.virtualMouse)
         {
            this.virtualMouse.release();
         }
         if(Mouse3D.enabled && this.renderHitData && this.renderHitData.renderable != null)
         {
            this.mouse3D.updatePosition(this.renderHitData);
         }
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_RELEASE,this.currentDisplayObject3D);
         }
      }
      
      protected function handleMouseClick(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_CLICK,this.currentDisplayObject3D);
         }
      }
      
      protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         if(param1 is IVirtualMouseEvent)
         {
            return;
         }
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_DOUBLE_CLICK,this.currentDisplayObject3D);
         }
      }
      
      protected function handleMouseOver(param1:DisplayObject3D) : void
      {
         if(this.hasMouseMoved())
         {
            this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OVER,param1);
         }
      }
      
      protected function handleMouseOut(param1:DisplayObject3D) : void
      {
         var _loc2_:MovieMaterial = null;
         if(!this.hasMouseMoved())
         {
            return;
         }
         if(param1)
         {
            _loc2_ = param1.material as MovieMaterial;
            if(_loc2_)
            {
               this.virtualMouse.exitContainer();
            }
         }
         this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OUT,param1);
      }
      
      public function updateAfterRender() : void
      {
         this._viewportRendered = true;
      }
      
      protected function hasMouseMoved() : Boolean
      {
         this.currentMousePos.x = this.container.mouseX;
         this.currentMousePos.y = this.container.mouseY;
         return !this.currentMousePos.equals(this.lastMousePos);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         var _loc3_:MovieMaterial = null;
         var _loc2_:Boolean = this.hasMouseMoved();
         if(_loc2_ || this._viewportRendered)
         {
            this.updateRenderHitData();
            this._viewportRendered = false;
            if(param1 is IVirtualMouseEvent)
            {
               return;
            }
            if(this.virtualMouse && this.renderHitData)
            {
               _loc3_ = this.currentMaterial as MovieMaterial;
               if(_loc3_)
               {
                  this.virtualMouse.container = _loc3_.movie as Sprite;
               }
               if(this.virtualMouse.container)
               {
                  this.virtualMouse.setLocation(this.renderHitData.u,this.renderHitData.v);
               }
               if(Mouse3D.enabled && this.renderHitData && this.renderHitData.hasHit)
               {
                  this.mouse3D.updatePosition(this.renderHitData);
               }
               this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE,this.currentDisplayObject3D);
            }
            else if(this.renderHitData && this.renderHitData.hasHit)
            {
               this.dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE,this.currentDisplayObject3D);
            }
         }
         this.lastMousePos.x = this.currentMousePos.x;
         this.lastMousePos.y = this.currentMousePos.y;
      }
      
      protected function dispatchObjectEvent(param1:String, param2:DisplayObject3D) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:InteractiveScene3DEvent = null;
         if(this.renderHitData && this.renderHitData.hasHit)
         {
            _loc3_ = !!this.renderHitData.u ? Number(this.renderHitData.u) : Number(0);
            _loc4_ = !!this.renderHitData.v ? Number(this.renderHitData.v) : Number(0);
            (_loc5_ = new InteractiveScene3DEvent(param1,param2,this.container,this.renderHitData.renderable as Triangle3D,_loc3_,_loc4_,this.renderHitData)).renderHitData = this.renderHitData;
            dispatchEvent(_loc5_);
            param2.dispatchEvent(_loc5_);
         }
         else
         {
            dispatchEvent(new InteractiveScene3DEvent(param1,param2,this.container));
            if(param2)
            {
               param2.dispatchEvent(new InteractiveScene3DEvent(param1,param2,this.container));
            }
         }
      }
   }
}
