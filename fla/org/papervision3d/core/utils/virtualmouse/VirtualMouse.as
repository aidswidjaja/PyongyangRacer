package org.papervision3d.core.utils.virtualmouse
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import org.papervision3d.core.log.PaperLogger;
   
   public class VirtualMouse extends EventDispatcher
   {
      
      public static const UPDATE:String = "update";
      
      private static var _mouseIsDown:Boolean = false;
       
      
      private var altKey:Boolean = false;
      
      private var ctrlKey:Boolean = false;
      
      private var shiftKey:Boolean = false;
      
      private var delta:int = 0;
      
      private var _stage:Stage;
      
      private var _container:Sprite;
      
      private var target:InteractiveObject;
      
      private var location:Point;
      
      private var isLocked:Boolean = false;
      
      private var isDoubleClickEvent:Boolean = false;
      
      private var disabledEvents:Object;
      
      private var ignoredInstances:Dictionary;
      
      private var _lastEvent:Event;
      
      private var lastMouseDown:Boolean = false;
      
      private var updateMouseDown:Boolean = false;
      
      private var lastLocation:Point;
      
      private var lastDownTarget:DisplayObject;
      
      private var lastWithinStage:Boolean = true;
      
      private var _useNativeEvents:Boolean = false;
      
      private var eventEvent:Class;
      
      private var mouseEventEvent:Class;
      
      public function VirtualMouse(param1:Stage = null, param2:Sprite = null, param3:Number = 0, param4:Number = 0)
      {
         this.disabledEvents = new Object();
         this.ignoredInstances = new Dictionary(true);
         this.eventEvent = VirtualMouseEvent;
         this.mouseEventEvent = VirtualMouseMouseEvent;
         super();
         this.stage = param1;
         this.container = param2;
         this.location = new Point(param3,param4);
         this.lastLocation = this.location.clone();
         addEventListener(UPDATE,this.handleUpdate);
         this.update();
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function set stage(param1:Stage) : void
      {
         var _loc2_:Boolean = false;
         if(this._stage)
         {
            _loc2_ = true;
            this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyHandler);
            this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyHandler);
         }
         else
         {
            _loc2_ = false;
         }
         this._stage = param1;
         if(this._stage)
         {
            this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyHandler);
            this._stage.addEventListener(KeyboardEvent.KEY_UP,this.keyHandler);
            this.target = this._stage;
            if(!_loc2_)
            {
               this.update();
            }
         }
      }
      
      public function set container(param1:Sprite) : void
      {
         this._container = param1;
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function get lastEvent() : Event
      {
         return this._lastEvent;
      }
      
      public function get mouseIsDown() : Boolean
      {
         return _mouseIsDown;
      }
      
      public function get x() : Number
      {
         return this.location.x;
      }
      
      public function set x(param1:Number) : void
      {
         this.location.x = param1;
         if(!this.isLocked)
         {
            this.update();
         }
      }
      
      public function get y() : Number
      {
         return this.location.y;
      }
      
      public function set y(param1:Number) : void
      {
         this.location.y = param1;
         if(!this.isLocked)
         {
            this.update();
         }
      }
      
      public function get useNativeEvents() : Boolean
      {
         return this._useNativeEvents;
      }
      
      public function set useNativeEvents(param1:Boolean) : void
      {
         if(param1 == this._useNativeEvents)
         {
            return;
         }
         this._useNativeEvents = param1;
         if(this._useNativeEvents)
         {
            this.eventEvent = VirtualMouseEvent;
            this.mouseEventEvent = VirtualMouseMouseEvent;
         }
         else
         {
            this.eventEvent = Event;
            this.mouseEventEvent = MouseEvent;
         }
      }
      
      public function getLocation() : Point
      {
         return this.location.clone();
      }
      
      public function setLocation(param1:*, param2:* = null) : void
      {
         var _loc3_:Point = null;
         if(param1 is Point)
         {
            _loc3_ = param1 as Point;
            this.location.x = _loc3_.x;
            this.location.y = _loc3_.y;
         }
         else
         {
            this.location.x = Number(param1);
            this.location.y = Number(param2);
         }
         if(!this.isLocked)
         {
            this.update();
         }
      }
      
      public function lock() : void
      {
         this.isLocked = true;
      }
      
      public function unlock() : void
      {
         this.isLocked = false;
         this.update();
      }
      
      public function disableEvent(param1:String) : void
      {
         this.disabledEvents[param1] = true;
      }
      
      public function enableEvent(param1:String) : void
      {
         if(param1 in this.disabledEvents)
         {
            delete this.disabledEvents[param1];
         }
      }
      
      public function ignore(param1:DisplayObject) : void
      {
         this.ignoredInstances[param1] = true;
      }
      
      public function unignore(param1:DisplayObject) : void
      {
         if(param1 in this.ignoredInstances)
         {
            delete this.ignoredInstances[param1];
         }
      }
      
      public function press() : void
      {
         this.updateMouseDown = true;
         _mouseIsDown = true;
         if(!this.isLocked)
         {
            this.update();
         }
      }
      
      public function release() : void
      {
         this.updateMouseDown = true;
         _mouseIsDown = false;
         if(!this.isLocked)
         {
            this.update();
         }
      }
      
      public function click() : void
      {
         this.press();
         this.release();
      }
      
      public function doubleClick() : void
      {
         if(this.isLocked)
         {
            this.release();
         }
         else
         {
            this.click();
            this.press();
            this.isDoubleClickEvent = true;
            this.release();
            this.isDoubleClickEvent = false;
         }
      }
      
      public function exitContainer() : void
      {
         if(!this.container)
         {
            return;
         }
         var _loc1_:Point = this.target.globalToLocal(this.location);
         if(!this.disabledEvents[MouseEvent.MOUSE_OUT])
         {
            this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
            this.container.dispatchEvent(new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
            dispatchEvent(new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
         }
         if(!this.disabledEvents[MouseEvent.ROLL_OUT])
         {
            this._lastEvent = new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
            this.container.dispatchEvent(new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
            dispatchEvent(new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
         }
         if(this.target != this.container)
         {
            if(!this.disabledEvents[MouseEvent.MOUSE_OUT])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               this.target.dispatchEvent(new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
               dispatchEvent(new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
            }
            if(!this.disabledEvents[MouseEvent.ROLL_OUT])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               this.target.dispatchEvent(new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
               dispatchEvent(new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc1_.x,_loc1_.y,this.container,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta));
            }
         }
         this.target = this._stage;
      }
      
      public function update() : void
      {
         dispatchEvent(new Event(UPDATE,false,false));
      }
      
      private function handleUpdate(param1:Event) : void
      {
         var _loc4_:InteractiveObject = null;
         var _loc5_:DisplayObject = null;
         var _loc9_:Boolean = false;
         if(!this.container)
         {
            return;
         }
         if(this.container.scrollRect)
         {
            PaperLogger.warning("The container that virtualMouse is trying to test against has a scrollRect defined, and may cause an issue with finding objects under a defined point.  Use MovieMaterial.rect to set a rectangle area instead");
         }
         var _loc2_:Point = new Point();
         _loc2_.x = this.container.x;
         _loc2_.y = this.container.y;
         this.container.x = this.container.y = 0;
         var _loc3_:Array = _loc3_ = this.container.getObjectsUnderPoint(this.location);
         this.container.x = _loc2_.x;
         this.container.y = _loc2_.y;
         var _loc6_:int = _loc3_.length;
         while(_loc6_--)
         {
            _loc5_ = _loc3_[_loc6_];
            while(_loc5_)
            {
               if(this.ignoredInstances[_loc5_])
               {
                  _loc4_ = null;
                  break;
               }
               if(_loc4_ && _loc5_ is SimpleButton)
               {
                  _loc4_ = null;
               }
               else if(_loc4_ && !DisplayObjectContainer(_loc5_).mouseChildren)
               {
                  _loc4_ = null;
               }
               if(!_loc4_ && _loc5_ is InteractiveObject && InteractiveObject(_loc5_).mouseEnabled)
               {
                  _loc4_ = InteractiveObject(_loc5_);
               }
               _loc5_ = _loc5_.parent;
            }
            if(_loc4_)
            {
               break;
            }
         }
         if(!_loc4_)
         {
            _loc4_ = this.container;
         }
         var _loc7_:Point = this.target.globalToLocal(this.location);
         var _loc8_:Point = _loc4_.globalToLocal(this.location);
         if(this.lastLocation.x != this.location.x || this.lastLocation.y != this.location.y)
         {
            _loc9_ = false;
            if(this.stage)
            {
               _loc9_ = this.location.x >= 0 && this.location.y >= 0 && this.location.x <= this.stage.stageWidth && this.location.y <= this.stage.stageHeight;
            }
            if(!_loc9_ && this.lastWithinStage && !this.disabledEvents[Event.MOUSE_LEAVE])
            {
               this._lastEvent = new this.eventEvent(Event.MOUSE_LEAVE,false,false);
               this.stage.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
            if(_loc9_ && !this.disabledEvents[MouseEvent.MOUSE_MOVE])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_MOVE,true,false,_loc8_.x,_loc8_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               _loc4_.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
            this.lastWithinStage = _loc9_;
         }
         if(_loc4_ != this.target)
         {
            if(!this.disabledEvents[MouseEvent.MOUSE_OUT])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_OUT,true,false,_loc7_.x,_loc7_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               this.target.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
            if(!this.disabledEvents[MouseEvent.ROLL_OUT])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.ROLL_OUT,false,false,_loc7_.x,_loc7_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               this.target.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
            if(!this.disabledEvents[MouseEvent.MOUSE_OVER])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_OVER,true,false,_loc8_.x,_loc8_.y,this.target,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               _loc4_.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
            if(!this.disabledEvents[MouseEvent.ROLL_OVER])
            {
               this._lastEvent = new this.mouseEventEvent(MouseEvent.ROLL_OVER,false,false,_loc8_.x,_loc8_.y,this.target,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
               _loc4_.dispatchEvent(this._lastEvent);
               dispatchEvent(this._lastEvent);
            }
         }
         if(this.updateMouseDown)
         {
            if(_mouseIsDown)
            {
               if(!this.disabledEvents[MouseEvent.MOUSE_DOWN])
               {
                  this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_DOWN,true,false,_loc8_.x,_loc8_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
                  _loc4_.dispatchEvent(this._lastEvent);
                  dispatchEvent(this._lastEvent);
               }
               this.lastDownTarget = _loc4_;
               this.updateMouseDown = false;
            }
            else
            {
               if(!this.disabledEvents[MouseEvent.MOUSE_UP])
               {
                  this._lastEvent = new this.mouseEventEvent(MouseEvent.MOUSE_UP,true,false,_loc8_.x,_loc8_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
                  _loc4_.dispatchEvent(this._lastEvent);
                  dispatchEvent(this._lastEvent);
               }
               if(!this.disabledEvents[MouseEvent.CLICK] && _loc4_ == this.lastDownTarget)
               {
                  this._lastEvent = new this.mouseEventEvent(MouseEvent.CLICK,true,false,_loc8_.x,_loc8_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
                  _loc4_.dispatchEvent(this._lastEvent);
                  dispatchEvent(this._lastEvent);
               }
               this.lastDownTarget = null;
               this.updateMouseDown = false;
            }
         }
         if(this.isDoubleClickEvent && !this.disabledEvents[MouseEvent.DOUBLE_CLICK] && _loc4_.doubleClickEnabled)
         {
            this._lastEvent = new this.mouseEventEvent(MouseEvent.DOUBLE_CLICK,true,false,_loc8_.x,_loc8_.y,_loc4_,this.ctrlKey,this.altKey,this.shiftKey,_mouseIsDown,this.delta);
            _loc4_.dispatchEvent(this._lastEvent);
            dispatchEvent(this._lastEvent);
         }
         this.lastLocation = this.location.clone();
         this.lastMouseDown = _mouseIsDown;
         this.target = _loc4_;
      }
      
      private function keyHandler(param1:KeyboardEvent) : void
      {
         this.altKey = param1.altKey;
         this.ctrlKey = param1.ctrlKey;
         this.shiftKey = param1.shiftKey;
      }
   }
}
