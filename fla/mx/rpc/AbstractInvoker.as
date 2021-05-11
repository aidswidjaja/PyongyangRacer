package mx.rpc
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.core.mx_internal;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.errors.MessagingError;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.events.MessageFaultEvent;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.AbstractEvent;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.InvokeEvent;
   import mx.rpc.events.ResultEvent;
   import mx.utils.ObjectProxy;
   
   use namespace mx_internal;
   
   public class AbstractInvoker extends EventDispatcher
   {
      
      mx_internal static const BINDING_RESULT:String = "resultForBinding";
       
      
      mx_internal var _result:Object;
      
      mx_internal var _responseHeaders:Array;
      
      private var resourceManager:IResourceManager;
      
      private var _asyncRequest:AsyncRequest;
      
      private var _log:ILogger;
      
      mx_internal var activeCalls:ActiveCalls;
      
      mx_internal var _makeObjectsBindable:Boolean;
      
      public function AbstractInvoker()
      {
         resourceManager = ResourceManager.getInstance();
         super();
         _log = Log.getLogger("mx.rpc.AbstractInvoker");
         activeCalls = new ActiveCalls();
      }
      
      mx_internal function getNetmonId() : String
      {
         return null;
      }
      
      public function cancel(param1:String = null) : AsyncToken
      {
         if(param1 != null)
         {
            return mx_internal::activeCalls.removeCall(param1);
         }
         return mx_internal::activeCalls.cancelLast();
      }
      
      mx_internal function get asyncRequest() : AsyncRequest
      {
         if(_asyncRequest == null)
         {
            _asyncRequest = new AsyncRequest();
         }
         return _asyncRequest;
      }
      
      mx_internal function faultHandler(param1:MessageFaultEvent) : void
      {
         var _loc2_:MessageEvent = MessageEvent.createEvent(MessageEvent.MESSAGE,param1.message);
         var _loc3_:AsyncToken = preHandle(_loc2_);
         if(_loc3_ == null && AsyncMessage(param1.message).correlationId != null && AsyncMessage(param1.message).correlationId != "" && param1.faultCode != "Client.Authentication")
         {
            return;
         }
         var _loc4_:Fault;
         (_loc4_ = new Fault(param1.faultCode,param1.faultString,param1.faultDetail)).rootCause = param1.rootCause;
         var _loc5_:FaultEvent;
         (_loc5_ = FaultEvent.createEvent(_loc4_,_loc3_,param1.message)).headers = mx_internal::_responseHeaders;
         dispatchRpcEvent(_loc5_);
      }
      
      public function clearResult(param1:Boolean = true) : void
      {
         _result = null;
         if(param1)
         {
            dispatchEvent(new Event(mx_internal::BINDING_RESULT));
         }
      }
      
      mx_internal function dispatchRpcEvent(param1:AbstractEvent) : void
      {
         param1.callTokenResponders();
         if(!param1.isDefaultPrevented())
         {
            dispatchEvent(param1);
         }
      }
      
      public function get lastResult() : Object
      {
         return mx_internal::_result;
      }
      
      mx_internal function set asyncRequest(param1:AsyncRequest) : void
      {
         _asyncRequest = param1;
      }
      
      mx_internal function preHandle(param1:MessageEvent) : AsyncToken
      {
         return mx_internal::activeCalls.removeCall(AsyncMessage(param1.message).correlationId);
      }
      
      mx_internal function processResult(param1:IMessage, param2:AsyncToken) : Boolean
      {
         var _loc3_:Object = param1.body;
         if(makeObjectsBindable && _loc3_ != null && getQualifiedClassName(_loc3_) == "Object")
         {
            _result = new ObjectProxy(_loc3_);
         }
         else
         {
            _result = _loc3_;
         }
         return true;
      }
      
      mx_internal function resultHandler(param1:MessageEvent) : void
      {
         var _loc3_:ResultEvent = null;
         var _loc2_:AsyncToken = preHandle(param1);
         if(_loc2_ == null)
         {
            return;
         }
         if(processResult(param1.message,_loc2_))
         {
            dispatchEvent(new Event(mx_internal::BINDING_RESULT));
            _loc3_ = ResultEvent.createEvent(mx_internal::_result,_loc2_,param1.message);
            _loc3_.headers = mx_internal::_responseHeaders;
            dispatchRpcEvent(_loc3_);
         }
      }
      
      public function set makeObjectsBindable(param1:Boolean) : void
      {
         _makeObjectsBindable = param1;
      }
      
      public function get makeObjectsBindable() : Boolean
      {
         return mx_internal::_makeObjectsBindable;
      }
      
      mx_internal function invoke(param1:IMessage, param2:AsyncToken = null) : AsyncToken
      {
         var fault:Fault = null;
         var errorText:String = null;
         var message:IMessage = param1;
         var token:AsyncToken = param2;
         if(token == null)
         {
            token = new AsyncToken(message);
         }
         else
         {
            token.setMessage(message);
         }
         mx_internal::activeCalls.addCall(message.messageId,token);
         try
         {
            mx_internal::asyncRequest.invoke(message,new Responder(mx_internal::resultHandler,mx_internal::faultHandler));
            dispatchRpcEvent(InvokeEvent.createEvent(token,message));
         }
         catch(e:MessagingError)
         {
            _log.warn(e.toString());
            errorText = resourceManager.getString("rpc","cannotConnectToDestination",[mx_internal::asyncRequest.destination]);
            fault = new Fault("InvokeFailed",e.toString(),errorText);
            new AsyncDispatcher(mx_internal::dispatchRpcEvent,[FaultEvent.createEvent(fault,token,message)],10);
         }
         catch(e2:Error)
         {
            _log.warn(e2.toString());
            fault = new Fault("InvokeFailed",e2.message);
            new AsyncDispatcher(mx_internal::dispatchRpcEvent,[FaultEvent.createEvent(fault,token,message)],10);
         }
         return token;
      }
   }
}
