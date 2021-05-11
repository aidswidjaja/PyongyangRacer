package mx.messaging.channels
{
   import flash.events.AsyncErrorEvent;
   import flash.events.ErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import mx.logging.Log;
   import mx.messaging.MessageAgent;
   import mx.messaging.MessageResponder;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   import mx.messaging.messages.ISmallMessage;
   import mx.messaging.messages.MessagePerformanceInfo;
   import mx.messaging.messages.MessagePerformanceUtils;
   
   public class NetConnectionChannel extends PollingChannel
   {
       
      
      protected var _nc:NetConnection;
      
      public function NetConnectionChannel(param1:String = null, param2:String = null)
      {
         super(param1,param2);
         _nc = new NetConnection();
         _nc.objectEncoding = ObjectEncoding.AMF3;
         _nc.client = this;
      }
      
      public function AppendToGatewayUrl(param1:String) : void
      {
         if(param1 != null && endpoint != null)
         {
            netConnection.connect(endpoint + param1);
         }
      }
      
      protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         defaultErrorHandler("Channel.Security.Error",param1);
      }
      
      public function receive(param1:IMessage, ... rest) : void
      {
         var _loc3_:MessagePerformanceUtils = null;
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got message\n{1}\n",id,param1.toString());
            if(this.mpiEnabled)
            {
               _loc3_ = new MessagePerformanceUtils(param1);
               _log.debug(_loc3_.prettyPrint());
            }
         }
         dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,param1));
      }
      
      override protected function internalSend(param1:MessageResponder) : void
      {
         var _loc3_:MessagePerformanceInfo = null;
         var _loc4_:IMessage = null;
         setFlexClientIdOnMessage(param1.message);
         if(mpiEnabled)
         {
            _loc3_ = new MessagePerformanceInfo();
            if(recordMessageTimes)
            {
               _loc3_.sendTime = new Date().getTime();
            }
            param1.message.headers[MessagePerformanceUtils.MPI_HEADER_IN] = _loc3_;
         }
         var _loc2_:IMessage = param1.message;
         if(useSmallMessages && _loc2_ is ISmallMessage)
         {
            if((_loc4_ = ISmallMessage(_loc2_).getSmallMessage()) != null)
            {
               _loc2_ = _loc4_;
            }
         }
         _nc.call(null,param1,_loc2_);
      }
      
      override protected function getDefaultMessageResponder(param1:MessageAgent, param2:IMessage) : MessageResponder
      {
         return new NetConnectionMessageResponder(param1,param2,this);
      }
      
      private function defaultErrorHandler(param1:String, param2:ErrorEvent) : void
      {
         var _loc3_:ChannelFaultEvent = ChannelFaultEvent.createEvent(this,false,param1,"error",param2.text + " url: \'" + endpoint + "\'");
         _loc3_.rootCause = param2;
         if(_connecting)
         {
            connectFailed(_loc3_);
         }
         else
         {
            dispatchEvent(_loc3_);
         }
      }
      
      override protected function getPollSyncMessageResponder(param1:MessageAgent, param2:CommandMessage) : MessageResponder
      {
         return new PollSyncMessageResponder(param1,param2,this);
      }
      
      override public function get useSmallMessages() : Boolean
      {
         return super.useSmallMessages && _nc != null && _nc.objectEncoding >= ObjectEncoding.AMF3;
      }
      
      override protected function internalConnect() : void
      {
         super.internalConnect();
         if(_nc.uri != null && _nc.uri.length > 0 && _nc.connected)
         {
            _nc.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
            _nc.close();
         }
         _nc.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
         _nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         _nc.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         _nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
         try
         {
            _nc.connect(endpoint);
         }
         catch(e:Error)
         {
            e.message += "  url: \'" + endpoint + "\'";
            throw e;
         }
      }
      
      protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         defaultErrorHandler("Channel.IO.Error",param1);
      }
      
      protected function statusHandler(param1:NetStatusEvent) : void
      {
      }
      
      override protected function internalDisconnect(param1:Boolean = false) : void
      {
         super.internalDisconnect(param1);
         shutdownNetConnection();
         disconnectSuccess(param1);
      }
      
      override protected function connectTimeoutHandler(param1:TimerEvent) : void
      {
         shutdownNetConnection();
         super.connectTimeoutHandler(param1);
      }
      
      public function get netConnection() : NetConnection
      {
         return _nc;
      }
      
      protected function shutdownNetConnection() : void
      {
         _nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         _nc.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         _nc.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
         _nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErrorHandler);
         _nc.close();
      }
      
      protected function asyncErrorHandler(param1:AsyncErrorEvent) : void
      {
         defaultErrorHandler("Channel.Async.Error",param1);
      }
   }
}

import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.channels.NetConnectionChannel;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

class NetConnectionMessageResponder extends MessageResponder
{
    
   
   private var resourceManager:IResourceManager;
   
   function NetConnectionMessageResponder(param1:MessageAgent, param2:IMessage, param3:NetConnectionChannel)
   {
      resourceManager = ResourceManager.getInstance();
      super(param1,param2,param3);
      param3.addEventListener(ChannelEvent.DISCONNECT,channelDisconnectHandler);
      param3.addEventListener(ChannelFaultEvent.FAULT,channelFaultHandler);
   }
   
   protected function channelFaultHandler(param1:ChannelFaultEvent) : void
   {
      disconnect();
      var _loc2_:ErrorMessage = param1.createErrorMessage();
      _loc2_.correlationId = message.messageId;
      if(!param1.channel.connected)
      {
         _loc2_.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
      }
      agent.fault(_loc2_,message);
   }
   
   override protected function requestTimedOut() : void
   {
      disconnect();
      statusHandler(createRequestTimeoutErrorMessage());
   }
   
   override protected function statusHandler(param1:IMessage) : void
   {
      var _loc2_:AcknowledgeMessage = null;
      var _loc3_:ErrorMessage = null;
      disconnect();
      if(param1 is AsyncMessage)
      {
         if(AsyncMessage(param1).correlationId == message.messageId)
         {
            _loc2_ = new AcknowledgeMessage();
            _loc2_.correlationId = AsyncMessage(param1).correlationId;
            _loc2_.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
            agent.acknowledge(_loc2_,message);
            agent.fault(param1 as ErrorMessage,message);
         }
         else if(param1 is ErrorMessage)
         {
            agent.fault(param1 as ErrorMessage,message);
         }
         else
         {
            _loc3_ = new ErrorMessage();
            _loc3_.faultCode = "Server.Acknowledge.Failed";
            _loc3_.faultString = resourceManager.getString("messaging","noErrorForMessage");
            _loc3_.faultDetail = resourceManager.getString("messaging","noErrorForMessage.details",[message.messageId,AsyncMessage(param1).correlationId]);
            _loc3_.correlationId = message.messageId;
            agent.fault(_loc3_,message);
         }
      }
      else
      {
         _loc3_ = new ErrorMessage();
         _loc3_.faultCode = "Server.Acknowledge.Failed";
         _loc3_.faultString = resourceManager.getString("messaging","noAckMessage");
         _loc3_.faultDetail = resourceManager.getString("messaging","noAckMessage.details",[!!param1 ? param1.toString() : "null"]);
         _loc3_.correlationId = message.messageId;
         agent.fault(_loc3_,message);
      }
   }
   
   protected function channelDisconnectHandler(param1:ChannelEvent) : void
   {
      disconnect();
      var _loc2_:ErrorMessage = new ErrorMessage();
      _loc2_.correlationId = message.messageId;
      _loc2_.faultString = resourceManager.getString("messaging","deliveryInDoubt");
      _loc2_.faultDetail = resourceManager.getString("messaging","deliveryInDoubt.details");
      _loc2_.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
      agent.fault(_loc2_,message);
   }
   
   private function disconnect() : void
   {
      channel.removeEventListener(ChannelEvent.DISCONNECT,channelDisconnectHandler);
      channel.removeEventListener(ChannelFaultEvent.FAULT,channelFaultHandler);
   }
   
   override protected function resultHandler(param1:IMessage) : void
   {
      var _loc2_:ErrorMessage = null;
      disconnect();
      if(param1 is AsyncMessage)
      {
         if(AsyncMessage(param1).correlationId == message.messageId)
         {
            agent.acknowledge(param1 as AcknowledgeMessage,message);
         }
         else
         {
            _loc2_ = new ErrorMessage();
            _loc2_.faultCode = "Server.Acknowledge.Failed";
            _loc2_.faultString = resourceManager.getString("messaging","ackFailed");
            _loc2_.faultDetail = resourceManager.getString("messaging","ackFailed.details",[message.messageId,AsyncMessage(param1).correlationId]);
            _loc2_.correlationId = message.messageId;
            agent.fault(_loc2_,message);
         }
      }
      else
      {
         _loc2_ = new ErrorMessage();
         _loc2_.faultCode = "Server.Acknowledge.Failed";
         _loc2_.faultString = resourceManager.getString("messaging","noAckMessage");
         _loc2_.faultDetail = resourceManager.getString("messaging","noAckMessage.details",[!!param1 ? param1.toString() : "null"]);
         _loc2_.correlationId = message.messageId;
         agent.fault(_loc2_,message);
      }
   }
}

import mx.messaging.MessageAgent;
import mx.messaging.channels.NetConnectionChannel;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.IMessage;

class PollSyncMessageResponder extends NetConnectionMessageResponder
{
    
   
   function PollSyncMessageResponder(param1:MessageAgent, param2:IMessage, param3:NetConnectionChannel)
   {
      super(param1,param2,param3);
   }
   
   override protected function channelFaultHandler(param1:ChannelFaultEvent) : void
   {
   }
   
   override protected function channelDisconnectHandler(param1:ChannelEvent) : void
   {
   }
   
   override protected function resultHandler(param1:IMessage) : void
   {
      var _loc2_:CommandMessage = null;
      super.resultHandler(param1);
      if(param1 is AsyncMessage && AsyncMessage(param1).correlationId == message.messageId)
      {
         _loc2_ = CommandMessage(message);
         switch(_loc2_.operation)
         {
            case CommandMessage.SUBSCRIBE_OPERATION:
               NetConnectionChannel(channel).enablePolling();
               break;
            case CommandMessage.UNSUBSCRIBE_OPERATION:
               NetConnectionChannel(channel).disablePolling();
         }
      }
   }
}
