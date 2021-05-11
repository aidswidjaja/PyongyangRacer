package resourcemgr
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class RResourceAnim
   {
       
      
      protected var m_PlayerAnim:Array;
      
      protected var m_PlayerNum:int;
      
      protected var m_AnimateNum:int;
      
      protected var m_AnimateName:Array;
      
      public function RResourceAnim()
      {
         super();
         this.m_PlayerAnim = new Array();
         this.m_PlayerNum = 4;
         this.m_AnimateName = new Array();
      }
      
      public function Parse(param1:ByteArray) : void
      {
         param1.endian = Endian.LITTLE_ENDIAN;
         this.ReadAnimate(param1);
      }
      
      public function GetAnimStartFrame(param1:int, param2:int) : int
      {
         if(param2 < 0 || param2 >= this.m_AnimateNum)
         {
            return -1;
         }
         return this.m_PlayerAnim[this.m_AnimateNum * param1 + param2].startFrame;
      }
      
      public function GetAnimEndFrame(param1:int, param2:int) : int
      {
         if(param2 < 0 || param2 >= this.m_AnimateNum)
         {
            return -1;
         }
         return this.m_PlayerAnim[this.m_AnimateNum * param1 + param2].endFrame;
      }
      
      protected function ReadAnimate(param1:ByteArray) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         this.m_AnimateNum = param1.readInt();
         var _loc2_:int = 0;
         while(_loc2_ < this.m_AnimateNum)
         {
            _loc3_ = param1.readMultiByte(30,"0");
            this.m_AnimateName.push(_loc3_);
            _loc2_++;
         }
         this.m_PlayerNum = param1.readInt();
         _loc2_ = 0;
         while(_loc2_ < this.m_PlayerNum)
         {
            _loc4_ = param1.readMultiByte(20,"0");
            _loc5_ = 0;
            while(_loc5_ < this.m_AnimateNum)
            {
               _loc6_ = {
                  "startFrame":param1.readInt(),
                  "endFrame":param1.readInt()
               };
               this.m_PlayerAnim.push(_loc6_);
               _loc5_++;
            }
            _loc2_++;
         }
      }
   }
}
