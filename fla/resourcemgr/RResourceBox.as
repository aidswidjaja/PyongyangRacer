package resourcemgr
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.materials.BitmapFileMaterial;
   
   public class RResourceBox
   {
       
      
      public var m_LumpNum:int;
      
      public var m_Ident:int;
      
      public var m_Version:int;
      
      public var m_LumpOfs:int;
      
      public var m_FrameNum:int;
      
      public var m_VtxNum:int;
      
      public var m_TriNum:int;
      
      public var m_UVsNum:int;
      
      public var m_BoxOfs:int;
      
      public var m_lUvsBuf:Array;
      
      public var m_lTrisBuf:Array;
      
      public var m_lFrameBuf:Array;
      
      public var m_texturefilename:String;
      
      public var m_Material:BitmapFileMaterial;
      
      public function RResourceBox()
      {
         super();
         this.m_Ident = -1;
         this.m_Version = 0;
         this.m_lUvsBuf = new Array();
         this.m_lTrisBuf = new Array();
         this.m_lFrameBuf = new Array();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadHeader(param1);
         this.Readlumps(param1,this.m_LumpNum,this.m_LumpOfs);
      }
      
      public function ReadHeader(param1:ByteArray) : void
      {
         this.m_Ident = param1.readInt();
         this.m_Version = param1.readInt();
         if(1)
         {
            this.m_LumpNum = param1.readInt();
            this.m_LumpOfs = param1.readInt();
            this.m_FrameNum = param1.readInt();
            this.m_BoxOfs = param1.readInt();
            return;
         }
         throw new Error("error loading Box file");
      }
      
      public function Readlumps(param1:ByteArray, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:RResourceImg = null;
         var _loc7_:int = 0;
         param1.position = param3;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = param1.readInt();
            this.m_VtxNum = param1.readInt();
            this.m_TriNum = param1.readInt();
            this.m_UVsNum = param1.readInt();
            this.m_texturefilename = param1.readMultiByte(100,"0");
            this.m_Material = new BitmapFileMaterial();
            this.m_Material.doubleSided = false;
            _loc6_ = new RResourceImg();
            _loc7_ = RockRacer.GameCommon.CommonRsrMgr.GetIDFromName(this.m_texturefilename);
            _loc6_ = RockRacer.GameCommon.CommonRsrMgr.m_lrsObj[_loc7_];
            this.m_Material.LoadTextureInMemory(this.m_texturefilename,_loc6_.m_lTexture);
            this.m_Material.maxU = 512;
            this.m_Material.maxV = 512;
            this.ReadpolyMesh(param1,_loc5_);
            _loc4_++;
         }
      }
      
      public function ReadpolyMesh(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         param1.position = param2;
         _loc3_ = 0;
         while(_loc3_ < this.m_UVsNum)
         {
            this.m_lUvsBuf.push(new NumberUV(param1.readFloat(),1 - param1.readFloat()));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_TriNum)
         {
            _loc5_ = {
               "a":param1.readInt(),
               "ta":param1.readInt(),
               "b":param1.readInt(),
               "tb":param1.readInt(),
               "c":param1.readInt(),
               "tc":param1.readInt()
            };
            this.m_lTrisBuf.push(_loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.m_FrameNum)
         {
            _loc6_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < this.m_VtxNum)
            {
               _loc6_.push({
                  "x":param1.readFloat(),
                  "y":param1.readFloat(),
                  "z":param1.readFloat()
               });
               _loc4_++;
            }
            this.m_lFrameBuf.push(_loc6_);
            _loc3_++;
         }
      }
   }
}
