package org.papervision3d.core.proto
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.core.render.material.MaterialManager;
   import org.papervision3d.materials.WireframeMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MaterialObject3D extends EventDispatcher implements ITriangleDrawer
   {
      
      private static var _totalMaterialObjects:Number = 0;
      
      public static var DEFAULT_COLOR:int = 0;
      
      public static var DEBUG_COLOR:int = 16711935;
       
      
      public var bitmap:BitmapData;
      
      public var smooth:Boolean = false;
      
      public var tiled:Boolean = false;
      
      public var baked:Boolean = false;
      
      public var lineColor:Number;
      
      public var lineAlpha:Number = 0;
      
      public var lineThickness:Number = 1;
      
      public var fillColor:Number;
      
      public var fillAlpha:Number = 0;
      
      public var oneSide:Boolean = true;
      
      public var invisible:Boolean = false;
      
      public var opposite:Boolean = false;
      
      public var name:String;
      
      public var id:Number;
      
      public var maxU:Number;
      
      public var maxV:Number;
      
      public var widthOffset:Number = 0;
      
      public var heightOffset:Number = 0;
      
      public var interactive:Boolean = false;
      
      protected var objects:Dictionary;
      
      public function MaterialObject3D()
      {
         this.lineColor = DEFAULT_COLOR;
         this.fillColor = DEFAULT_COLOR;
         super();
         this.id = _totalMaterialObjects++;
         MaterialManager.registerMaterial(this);
         this.objects = new Dictionary(true);
      }
      
      public static function get DEFAULT() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = new WireframeMaterial();
         _loc1_.lineColor = 16777215 * Math.random();
         _loc1_.lineAlpha = 1;
         _loc1_.fillColor = DEFAULT_COLOR;
         _loc1_.fillAlpha = 1;
         _loc1_.doubleSided = false;
         return _loc1_;
      }
      
      public static function get DEBUG() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = new MaterialObject3D();
         _loc1_.lineColor = 16777215 * Math.random();
         _loc1_.lineAlpha = 1;
         _loc1_.fillColor = DEBUG_COLOR;
         _loc1_.fillAlpha = 0.37;
         _loc1_.doubleSided = true;
         return _loc1_;
      }
      
      public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
      }
      
      public function drawRT(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData) : void
      {
      }
      
      public function updateBitmap() : void
      {
      }
      
      public function copy(param1:MaterialObject3D) : void
      {
         this.bitmap = param1.bitmap;
         this.smooth = param1.smooth;
         this.lineColor = param1.lineColor;
         this.lineAlpha = param1.lineAlpha;
         this.fillColor = param1.fillColor;
         this.fillAlpha = param1.fillAlpha;
         this.oneSide = param1.oneSide;
         this.opposite = param1.opposite;
         this.invisible = param1.invisible;
         this.name = param1.name;
         this.maxU = param1.maxU;
         this.maxV = param1.maxV;
      }
      
      public function clone() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = new MaterialObject3D();
         _loc1_.copy(this);
         return _loc1_;
      }
      
      public function registerObject(param1:DisplayObject3D) : void
      {
         this.objects[param1] = true;
      }
      
      public function unregisterObject(param1:DisplayObject3D) : void
      {
         if(this.objects && this.objects[param1])
         {
            this.objects[param1] = null;
         }
      }
      
      public function destroy() : void
      {
         this.objects = null;
         this.bitmap = null;
         MaterialManager.unRegisterMaterial(this);
      }
      
      override public function toString() : String
      {
         return "[MaterialObject3D] bitmap:" + this.bitmap + " lineColor:" + this.lineColor + " fillColor:" + this.fillColor;
      }
      
      public function get doubleSided() : Boolean
      {
         return !this.oneSide;
      }
      
      public function set doubleSided(param1:Boolean) : void
      {
         this.oneSide = !param1;
      }
      
      public function getObjectList() : Dictionary
      {
         return this.objects;
      }
      
      public function isUpdateable() : Boolean
      {
         return !this.baked;
      }
   }
}
