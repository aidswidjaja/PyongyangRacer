package resourcemgr
{
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RResourcePath
   {
       
      
      public var m_PosNum:int;
      
      public var m_lCurveInfo:Array;
      
      public var m_lPath:Array;
      
      public function RResourcePath()
      {
         super();
         this.m_lCurveInfo = new Array();
         this.m_lPath = new Array();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadHeader(param1);
         this.Readpos(param1,this.m_PosNum);
      }
      
      public function Readpos(param1:ByteArray, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector3D = null;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = param1.readInt();
            this.m_lCurveInfo.push(_loc4_);
            _loc5_ = new Vector3D(param1.readFloat(),param1.readFloat(),param1.readFloat());
            this.m_lPath.push(_loc5_);
            _loc3_++;
         }
         this.m_lPath.push(this.m_lPath[0]);
      }
      
      protected function ReadHeader(param1:ByteArray) : void
      {
         if(1)
         {
            this.m_PosNum = param1.readInt();
            return;
         }
         throw new Error("error loading MObj file (" + "path" + "): Not a valid MObj file/bad version");
      }
   }
}
