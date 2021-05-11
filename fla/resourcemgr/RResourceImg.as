package resourcemgr
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RResourceImg
   {
       
      
      public var m_Len:int;
      
      public var m_lTexture:ByteArray;
      
      public function RResourceImg()
      {
         super();
         this.m_lTexture = new ByteArray();
         this.m_lTexture.endian = Endian.LITTLE_ENDIAN;
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.m_Len = param1.length;
         param1.readBytes(this.m_lTexture,0,0);
      }
   }
}
