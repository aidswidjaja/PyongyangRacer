package org.papervision3d.objects.primitives
{
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class Sphere extends TriangleMesh3D
   {
      
      public static var DEFAULT_RADIUS:Number = 100;
      
      public static var DEFAULT_SCALE:Number = 1;
      
      public static var DEFAULT_SEGMENTSW:Number = 8;
      
      public static var DEFAULT_SEGMENTSH:Number = 6;
      
      public static var MIN_SEGMENTSW:Number = 3;
      
      public static var MIN_SEGMENTSH:Number = 2;
       
      
      private var segmentsW:Number;
      
      private var segmentsH:Number;
      
      public function Sphere(param1:MaterialObject3D = null, param2:Number = 100, param3:int = 8, param4:int = 6)
      {
         super(param1,new Array(),new Array(),null);
         this.segmentsW = Math.max(MIN_SEGMENTSW,Number(param3) || Number(DEFAULT_SEGMENTSW));
         this.segmentsH = Math.max(MIN_SEGMENTSH,Number(param4) || Number(DEFAULT_SEGMENTSH));
         if(param2 == 0)
         {
            param2 = DEFAULT_RADIUS;
         }
         var _loc5_:Number = DEFAULT_SCALE;
         this.buildSphere(param2);
      }
      
      private function buildSphere(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc11_:Triangle3D = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Array = null;
         var _loc16_:Vertex3D = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:int = 0;
         var _loc21_:* = false;
         var _loc22_:Vertex3D = null;
         var _loc23_:Vertex3D = null;
         var _loc24_:Vertex3D = null;
         var _loc25_:Vertex3D = null;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:NumberUV = null;
         var _loc31_:NumberUV = null;
         var _loc32_:NumberUV = null;
         var _loc33_:NumberUV = null;
         var _loc5_:Number = Math.max(3,this.segmentsW);
         var _loc6_:Number = Math.max(2,this.segmentsH);
         var _loc7_:Array = this.geometry.vertices;
         var _loc8_:Array = this.geometry.faces;
         var _loc9_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc6_ + 1)
         {
            _loc12_ = Number(_loc3_ / _loc6_);
            _loc13_ = -param1 * Math.cos(_loc12_ * Math.PI);
            _loc14_ = param1 * Math.sin(_loc12_ * Math.PI);
            _loc15_ = new Array();
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               _loc17_ = Number(2 * _loc2_ / _loc5_);
               _loc18_ = _loc14_ * Math.sin(_loc17_ * Math.PI);
               _loc19_ = _loc14_ * Math.cos(_loc17_ * Math.PI);
               if(!((_loc3_ == 0 || _loc3_ == _loc6_) && _loc2_ > 0))
               {
                  _loc16_ = new Vertex3D(_loc19_,_loc13_,_loc18_);
                  _loc7_.push(_loc16_);
               }
               _loc15_.push(_loc16_);
               _loc2_++;
            }
            _loc9_.push(_loc15_);
            _loc3_++;
         }
         var _loc10_:int = _loc9_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc10_)
         {
            _loc20_ = _loc9_[_loc3_].length;
            if(_loc3_ > 0)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc20_)
               {
                  _loc21_ = _loc2_ == _loc20_ - 1;
                  _loc22_ = _loc9_[_loc3_][!!_loc21_ ? 0 : _loc2_ + 1];
                  _loc23_ = _loc9_[_loc3_][!!_loc21_ ? _loc20_ - 1 : _loc2_];
                  _loc24_ = _loc9_[_loc3_ - 1][!!_loc21_ ? _loc20_ - 1 : _loc2_];
                  _loc25_ = _loc9_[_loc3_ - 1][!!_loc21_ ? 0 : _loc2_ + 1];
                  _loc26_ = _loc3_ / (_loc10_ - 1);
                  _loc27_ = (_loc3_ - 1) / (_loc10_ - 1);
                  _loc28_ = (_loc2_ + 1) / _loc20_;
                  _loc29_ = _loc2_ / _loc20_;
                  _loc30_ = new NumberUV(_loc28_,_loc27_);
                  _loc31_ = new NumberUV(_loc28_,_loc26_);
                  _loc32_ = new NumberUV(_loc29_,_loc26_);
                  _loc33_ = new NumberUV(_loc29_,_loc27_);
                  if(_loc3_ < _loc9_.length - 1)
                  {
                     _loc8_.push(new Triangle3D(this,new Array(_loc22_,_loc23_,_loc24_),material,new Array(_loc31_,_loc32_,_loc33_)));
                  }
                  if(_loc3_ > 1)
                  {
                     _loc8_.push(new Triangle3D(this,new Array(_loc22_,_loc24_,_loc25_),material,new Array(_loc31_,_loc33_,_loc30_)));
                  }
                  _loc2_++;
               }
            }
            _loc3_++;
         }
         for each(_loc11_ in _loc8_)
         {
            _loc11_.renderCommand.create = createRenderTriangle;
         }
         this.geometry.ready = true;
         if(Papervision3D.useRIGHTHANDED)
         {
            this.geometry.flipFaces();
         }
      }
   }
}
