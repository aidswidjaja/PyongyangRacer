package resourcemgr
{
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RResourceHeightmap
   {
       
      
      protected var m_ident:int;
      
      protected var m_version:int;
      
      public var m_lFaceInfo:Array;
      
      public var m_lHeightInfo:Array;
      
      public var m_spilt:int;
      
      public var m_faces:int;
      
      public var m_max:Vector3D;
      
      public var m_min:Vector3D;
      
      public function RResourceHeightmap()
      {
         super();
         this.m_lFaceInfo = new Array();
         this.m_lHeightInfo = new Array();
         this.m_max = new Vector3D();
         this.m_min = new Vector3D();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadHeader(param1);
         this.ReadFaceInfo(param1);
         this.ReadHeightInfo(param1);
      }
      
      public function ReadHeader(param1:ByteArray) : void
      {
         this.m_ident = param1.readInt();
         this.m_version = param1.readInt();
         if(1)
         {
            this.m_spilt = param1.readInt();
            this.m_faces = param1.readInt();
            this.m_max.x = param1.readFloat();
            this.m_max.y = param1.readFloat();
            this.m_max.z = param1.readFloat();
            this.m_min.x = param1.readFloat();
            this.m_min.y = param1.readFloat();
            this.m_min.z = param1.readFloat();
            return;
         }
         throw new Error("error loading Heightmap file (" + "heightmap" + "): Not a valid Heightmap file/bad version");
      }
      
      public function ReadFaceInfo(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.m_faces)
         {
            _loc2_ = {
               "A":param1.readFloat(),
               "B":param1.readFloat(),
               "C":param1.readFloat(),
               "D":param1.readFloat(),
               "friction":param1.readFloat(),
               "type":param1.readInt()
            };
            this.m_lFaceInfo.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function ReadHeightInfo(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.m_spilt * this.m_spilt)
         {
            this.m_lHeightInfo.push(param1.readUnsignedShort());
            _loc2_++;
         }
      }
   }
}
