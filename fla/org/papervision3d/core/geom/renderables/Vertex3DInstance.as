package org.papervision3d.core.geom.renderables
{
   import org.papervision3d.core.math.Number3D;
   
   public class Vertex3DInstance
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public var extra:Object;
      
      public var particle_z:Number = 1;
      
      public var visible:Boolean;
      
      public var normal:Number3D;
      
      private var persp:Number = 0;
      
      public function Vertex3DInstance(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
         this.visible = false;
         this.normal = new Number3D();
      }
      
      public static function dot(param1:Vertex3DInstance, param2:Vertex3DInstance) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function cross(param1:Vertex3DInstance, param2:Vertex3DInstance) : Number
      {
         return param1.x * param2.y - param2.x * param1.y;
      }
      
      public static function sub(param1:Vertex3DInstance, param2:Vertex3DInstance) : Vertex3DInstance
      {
         return new Vertex3DInstance(param2.x - param1.x,param2.y - param1.y);
      }
      
      public static function subTo(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance) : void
      {
         param3.x = param2.x - param1.x;
         param3.y = param2.y - param1.y;
      }
      
      public static function median(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Number) : Vertex3DInstance
      {
         var _loc4_:Number = (param1.z + param2.z) / 2;
         var _loc5_:Number = param3 + param1.z;
         var _loc6_:Number = param3 + param2.z;
         var _loc7_:Number = 1 / (param3 + _loc4_) / 2;
         return new Vertex3DInstance((param1.x * _loc5_ + param2.x * _loc6_) * _loc7_,(param1.y * _loc5_ + param2.y * _loc6_) * _loc7_,_loc4_);
      }
      
      public function clone() : Vertex3DInstance
      {
         var _loc1_:Vertex3DInstance = new Vertex3DInstance(this.x,this.y,this.z);
         _loc1_.visible = this.visible;
         _loc1_.extra = this.extra;
         return _loc1_;
      }
      
      public function deperspective(param1:Number) : Vertex3D
      {
         this.persp = 1 + this.z / param1;
         return new Vertex3D(this.x * this.persp,this.y * this.persp,this.z);
      }
      
      public function distanceSqr(param1:Vertex3DInstance) : Number
      {
         return (this.x - param1.x) * (this.x - param1.x) + (this.y - param1.y) * (this.y - param1.y);
      }
      
      public function distance(param1:Vertex3DInstance) : Number
      {
         return Math.sqrt((this.x - param1.x) * (this.x - param1.x) + (this.y - param1.y) * (this.y - param1.y));
      }
   }
}
