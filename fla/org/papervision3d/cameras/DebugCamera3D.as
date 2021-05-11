package org.papervision3d.cameras
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import org.papervision3d.view.Viewport3D;
   
   public class DebugCamera3D extends Camera3D
   {
       
      
      protected var _propertiesDisplay:Sprite;
      
      protected var _inertia:Number = 3;
      
      protected var viewportStage:Stage;
      
      protected var startPoint:Point;
      
      protected var startRotationY:Number;
      
      protected var startRotationX:Number;
      
      protected var targetRotationY:Number = 0;
      
      protected var targetRotationX:Number = 0;
      
      protected var keyRight:Boolean = false;
      
      protected var keyLeft:Boolean = false;
      
      protected var keyForward:Boolean = false;
      
      protected var keyBackward:Boolean = false;
      
      protected var forwardFactor:Number = 0;
      
      protected var sideFactor:Number = 0;
      
      protected var xText:TextField;
      
      protected var yText:TextField;
      
      protected var zText:TextField;
      
      protected var rotationXText:TextField;
      
      protected var rotationYText:TextField;
      
      protected var rotationZText:TextField;
      
      protected var fovText:TextField;
      
      protected var nearText:TextField;
      
      protected var farText:TextField;
      
      protected var viewport3D:Viewport3D;
      
      public function DebugCamera3D(param1:Viewport3D, param2:Number = 90, param3:Number = 10, param4:Number = 5000)
      {
         super(param2,param3,param4,true);
         this.viewport3D = param1;
         this.viewport = param1.sizeRectangle;
         this.focus = this.viewport.height / 2 / Math.tan(param2 / 2 * (Math.PI / 180));
         this.zoom = this.focus / param3;
         this.focus = param3;
         this.far = param4;
         this.displayProperties();
         this.checkStageReady();
      }
      
      private function checkStageReady() : void
      {
         if(this.viewport3D.containerSprite.stage == null)
         {
            this.viewport3D.containerSprite.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageHandler);
         }
         else
         {
            this.setupEvents();
         }
      }
      
      protected function onAddedToStageHandler(param1:Event) : void
      {
         this.setupEvents();
      }
      
      protected function displayProperties() : void
      {
         this._propertiesDisplay = new Sprite();
         this._propertiesDisplay.graphics.beginFill(0);
         this._propertiesDisplay.graphics.drawRect(0,0,100,100);
         this._propertiesDisplay.graphics.endFill();
         this._propertiesDisplay.x = 0;
         this._propertiesDisplay.y = 0;
         var _loc1_:TextFormat = new TextFormat("_sans",9);
         this.xText = new TextField();
         this.yText = new TextField();
         this.zText = new TextField();
         this.rotationXText = new TextField();
         this.rotationYText = new TextField();
         this.rotationZText = new TextField();
         this.fovText = new TextField();
         this.nearText = new TextField();
         this.farText = new TextField();
         var _loc2_:Array = [this.xText,this.yText,this.zText,this.rotationXText,this.rotationYText,this.rotationZText,this.fovText,this.nearText,this.farText];
         var _loc3_:int = 10;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc2_[_loc4_].width = 100;
            _loc2_[_loc4_].selectable = false;
            _loc2_[_loc4_].textColor = 16776960;
            _loc2_[_loc4_].text = "";
            _loc2_[_loc4_].defaultTextFormat = _loc1_;
            _loc2_[_loc4_].y = _loc3_ * _loc4_;
            this._propertiesDisplay.addChild(_loc2_[_loc4_]);
            _loc4_++;
         }
         this.viewport3D.addChild(this._propertiesDisplay);
      }
      
      protected function setupEvents() : void
      {
         this.viewportStage = this.viewport3D.containerSprite.stage;
         this.viewportStage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.viewportStage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.viewportStage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         this.viewportStage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
         this.viewportStage.addEventListener(Event.ENTER_FRAME,this.onEnterFrameHandler);
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         this.viewportStage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         this.startPoint = new Point(this.viewportStage.mouseX,this.viewportStage.mouseY);
         this.startRotationY = this.rotationY;
         this.startRotationX = this.rotationX;
      }
      
      protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.targetRotationY = this.startRotationY - (this.startPoint.x - this.viewportStage.mouseX) / 2;
         this.targetRotationX = this.startRotationX + (this.startPoint.y - this.viewportStage.mouseY) / 2;
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         this.viewportStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case "W".charCodeAt():
            case Keyboard.UP:
               this.keyForward = true;
               this.keyBackward = false;
               break;
            case "S".charCodeAt():
            case Keyboard.DOWN:
               this.keyBackward = true;
               this.keyForward = false;
               break;
            case "A".charCodeAt():
            case Keyboard.LEFT:
               this.keyLeft = true;
               this.keyRight = false;
               break;
            case "D".charCodeAt():
            case Keyboard.RIGHT:
               this.keyRight = true;
               this.keyLeft = false;
               break;
            case "Q".charCodeAt():
               --rotationZ;
               break;
            case "E".charCodeAt():
               ++rotationZ;
               break;
            case "F".charCodeAt():
               --fov;
               break;
            case "R".charCodeAt():
               ++fov;
               break;
            case "G".charCodeAt():
               near -= 10;
               break;
            case "T".charCodeAt():
               near += 10;
               break;
            case "H".charCodeAt():
               far -= 10;
               break;
            case "Y".charCodeAt():
               far += 10;
         }
      }
      
      protected function keyUpHandler(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case "W".charCodeAt():
            case Keyboard.UP:
               this.keyForward = false;
               break;
            case "S".charCodeAt():
            case Keyboard.DOWN:
               this.keyBackward = false;
               break;
            case "A".charCodeAt():
            case Keyboard.LEFT:
               this.keyLeft = false;
               break;
            case "D".charCodeAt():
            case Keyboard.RIGHT:
               this.keyRight = false;
         }
      }
      
      protected function onEnterFrameHandler(param1:Event) : void
      {
         if(this.keyForward)
         {
            this.forwardFactor += 50;
         }
         if(this.keyBackward)
         {
            this.forwardFactor += -50;
         }
         if(this.keyLeft)
         {
            this.sideFactor += -50;
         }
         if(this.keyRight)
         {
            this.sideFactor += 50;
         }
         var _loc2_:Number = this.rotationX + (this.targetRotationX - this.rotationX) / this._inertia;
         var _loc3_:Number = this.rotationY + (this.targetRotationY - this.rotationY) / this._inertia;
         this.rotationX = Math.round(_loc2_ * 10) / 10;
         this.rotationY = Math.round(_loc3_ * 10) / 10;
         this.forwardFactor += (0 - this.forwardFactor) / this._inertia;
         this.sideFactor += (0 - this.sideFactor) / this._inertia;
         if(this.forwardFactor > 0)
         {
            this.moveForward(this.forwardFactor);
         }
         else
         {
            this.moveBackward(-this.forwardFactor);
         }
         if(this.sideFactor > 0)
         {
            this.moveRight(this.sideFactor);
         }
         else
         {
            this.moveLeft(-this.sideFactor);
         }
         this.xText.text = "x:" + int(x);
         this.yText.text = "y:" + int(y);
         this.zText.text = "z:" + int(z);
         this.rotationXText.text = "rotationX:" + int(_loc2_);
         this.rotationYText.text = "rotationY:" + int(_loc3_);
         this.rotationZText.text = "rotationZ:" + int(rotationZ);
         this.fovText.text = "fov:" + Math.round(fov);
         this.nearText.text = "near:" + Math.round(near);
         this.farText.text = "far:" + Math.round(far);
      }
      
      public function get propsDisplay() : Sprite
      {
         return this._propertiesDisplay;
      }
      
      public function set propsDisplay(param1:Sprite) : void
      {
         this._propertiesDisplay = param1;
      }
      
      public function get inertia() : Number
      {
         return this._inertia;
      }
      
      public function set inertia(param1:Number) : void
      {
         this._inertia = param1;
      }
   }
}
