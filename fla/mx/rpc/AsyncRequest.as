package mx.rpc
{
   import mx.messaging.Producer;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.events.MessageFaultEvent;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   
   public class AsyncRequest extends Producer
   {
       
      
      private var _pendingRequests:Object;
      
      public function AsyncRequest()
      {
         _pendingRequests = {};
         super();
      }
      
      override public function hasPendingRequestForMessage(param1:IMessage) : Boolean
      {
         var _loc2_:String = param1.messageId;
         return _pendingRequests[_loc2_];
      }
      
      override public function fault(param1:ErrorMessage, param2:IMessage) : void
      {
         super.fault(param1,param2);
         if(_ignoreFault)
         {
            return;
         }
         var _loc3_:String = param2.messageId;
         var _loc4_:IResponder;
         if(_loc4_ = IResponder(_pendingRequests[_loc3_]))
         {
            delete _pendingRequests[_loc3_];
            _loc4_.fault(MessageFaultEvent.createEvent(param1));
         }
      }
      
      public function invoke(param1:IMessage, param2:IResponder) : void
      {
         _pendingRequests[param1.messageId] = param2;
         send(param1);
      }
      
      override public function acknowledge(param1:AcknowledgeMessage, param2:IMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:IResponder = null;
         var _loc3_:Boolean = param1.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
         super.acknowledge(param1,param2);
         if(!_loc3_)
         {
            _loc4_ = param1.correlationId;
            if(_loc5_ = IResponder(_pendingRequests[_loc4_]))
            {
               delete _pendingRequests[_loc4_];
               _loc5_.result(MessageEvent.createEvent(MessageEvent.RESULT,param1));
            }
         }
      }
   }
}
