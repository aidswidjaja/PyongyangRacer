package mx.messaging
{
   import flash.events.TimerEvent;
   import flash.net.Responder;
   import flash.utils.Timer;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class MessageResponder extends Responder
   {
       
      
      private var _channel:Channel;
      
      private var _agent:MessageAgent;
      
      private var _requestTimedOut:Boolean;
      
      private var _message:IMessage;
      
      private var _requestTimer:Timer;
      
      private var resourceManager:IResourceManager;
      
      public function MessageResponder(param1:MessageAgent, param2:IMessage, param3:Channel = null)
      {
         resourceManager = ResourceManager.getInstance();
         super(result,status);
         _agent = param1;
         _channel = param3;
         _message = param2;
         _requestTimedOut = false;
      }
      
      public function get channel() : Channel
      {
         return _channel;
      }
      
      public function get agent() : MessageAgent
      {
         return _agent;
      }
      
      protected function requestTimedOut() : void
      {
      }
      
      public final function startRequestTimeout(param1:int) : void
      {
         _requestTimer = new Timer(param1 * 1000,1);
         _requestTimer.addEventListener(TimerEvent.TIMER,timeoutRequest);
         _requestTimer.start();
      }
      
      public function get message() : IMessage
      {
         return _message;
      }
      
      public final function result(param1:IMessage) : void
      {
         if(!_requestTimedOut)
         {
            if(_requestTimer != null)
            {
               releaseTimer();
            }
            resultHandler(param1);
         }
      }
      
      private function releaseTimer() : void
      {
         _requestTimer.stop();
         _requestTimer.removeEventListener(TimerEvent.TIMER,timeoutRequest);
         _requestTimer = null;
      }
      
      public function set message(param1:IMessage) : void
      {
         _message = param1;
      }
      
      protected function createRequestTimeoutErrorMessage() : ErrorMessage
      {
         var _loc1_:ErrorMessage = new ErrorMessage();
         _loc1_.correlationId = message.messageId;
         _loc1_.faultCode = "Client.Error.RequestTimeout";
         _loc1_.faultString = resourceManager.getString("messaging","requestTimedOut");
         _loc1_.faultDetail = resourceManager.getString("messaging","requestTimedOut.details");
         return _loc1_;
      }
      
      private function timeoutRequest(param1:TimerEvent) : void
      {
         _requestTimedOut = true;
         releaseTimer();
         requestTimedOut();
      }
      
      public final function status(param1:IMessage) : void
      {
         if(!_requestTimedOut)
         {
            if(_requestTimer != null)
            {
               releaseTimer();
            }
            statusHandler(param1);
         }
      }
      
      protected function resultHandler(param1:IMessage) : void
      {
      }
      
      protected function statusHandler(param1:IMessage) : void
      {
      }
   }
}
