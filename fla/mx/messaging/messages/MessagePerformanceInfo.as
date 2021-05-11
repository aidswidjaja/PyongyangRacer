package mx.messaging.messages
{
   public class MessagePerformanceInfo
   {
       
      
      public var recordMessageSizes:Boolean;
      
      public var pushedFlag:Boolean;
      
      public var serverPrePushTime:Number;
      
      public var receiveTime:Number;
      
      public var overheadTime:Number;
      
      public var serverPostAdapterExternalTime:Number;
      
      private var _infoType:String;
      
      public var messageSize:int;
      
      public var serverPreAdapterExternalTime:Number;
      
      public var recordMessageTimes:Boolean;
      
      public var sendTime:Number = 0;
      
      public var serverPostAdapterTime:Number;
      
      public var serverPreAdapterTime:Number;
      
      public function MessagePerformanceInfo()
      {
         super();
      }
      
      public function get infoType() : String
      {
         return this._infoType;
      }
      
      public function set infoType(param1:String) : void
      {
         var _loc2_:Date = null;
         _infoType = param1;
         if(_infoType == "OUT")
         {
            _loc2_ = new Date();
            this.receiveTime = _loc2_.getTime();
         }
      }
   }
}
