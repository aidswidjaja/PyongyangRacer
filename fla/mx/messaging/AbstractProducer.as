package mx.messaging
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class AbstractProducer extends MessageAgent
   {
       
      
      private var _currentAttempt:int;
      
      private var _autoConnect:Boolean = true;
      
      private var _reconnectTimer:Timer;
      
      protected var _shouldBeConnected:Boolean;
      
      private var _connectMsg:CommandMessage;
      
      private var _defaultHeaders:Object;
      
      private var _reconnectInterval:int;
      
      private var _reconnectAttempts:int;
      
      private var resourceManager:IResourceManager;
      
      public function AbstractProducer()
      {
         resourceManager = ResourceManager.getInstance();
         super();
      }
      
      public function get reconnectAttempts() : int
      {
         return _reconnectAttempts;
      }
      
      public function get defaultHeaders() : Object
      {
         return _defaultHeaders;
      }
      
      public function set reconnectInterval(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         var _loc3_:String = null;
         if(_reconnectInterval != param1)
         {
            if(param1 < 0)
            {
               _loc3_ = resourceManager.getString("messaging","reconnectIntervalNegative");
               throw new ArgumentError(_loc3_);
            }
            if(param1 == 0)
            {
               stopReconnectTimer();
            }
            else if(_reconnectTimer != null)
            {
               _reconnectTimer.delay = param1;
            }
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"reconnectInterval",_reconnectInterval,param1);
            _reconnectInterval = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function set defaultHeaders(param1:Object) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_defaultHeaders != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"defaultHeaders",_defaultHeaders,param1);
            _defaultHeaders = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function get reconnectInterval() : int
      {
         return _reconnectInterval;
      }
      
      public function send(param1:IMessage) : void
      {
         var _loc2_:* = null;
         var _loc3_:ErrorMessage = null;
         if(!connected && autoConnect)
         {
            _shouldBeConnected = true;
         }
         if(defaultHeaders != null)
         {
            for(_loc2_ in defaultHeaders)
            {
               if(!param1.headers.hasOwnProperty(_loc2_))
               {
                  param1.headers[_loc2_] = defaultHeaders[_loc2_];
               }
            }
         }
         if(!connected && !autoConnect)
         {
            _shouldBeConnected = false;
            _loc3_ = new ErrorMessage();
            _loc3_.faultCode = "Client.Error.MessageSend";
            _loc3_.faultString = resourceManager.getString("messaging","producerSendError");
            _loc3_.faultDetail = resourceManager.getString("messaging","producerSendErrorDetails");
            _loc3_.correlationId = param1.messageId;
            internalFault(_loc3_,param1,false,true);
         }
         else
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' {1} sending message \'{2}\'",id,_agentType,param1.messageId);
            }
            internalSend(param1);
         }
      }
      
      protected function stopReconnectTimer() : void
      {
         if(_reconnectTimer != null)
         {
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' {1} stopping reconnect timer.",id,_agentType);
            }
            _reconnectTimer.removeEventListener(TimerEvent.TIMER,reconnect);
            _reconnectTimer.reset();
            _reconnectTimer = null;
         }
      }
      
      override public function channelDisconnectHandler(param1:ChannelEvent) : void
      {
         super.channelDisconnectHandler(param1);
         if(_shouldBeConnected && !param1.rejected)
         {
            startReconnectTimer();
         }
      }
      
      protected function reconnect(param1:TimerEvent) : void
      {
         if(_reconnectAttempts != -1 && _currentAttempt >= _reconnectAttempts)
         {
            stopReconnectTimer();
            _shouldBeConnected = false;
            fault(buildConnectErrorMessage(),_connectMsg);
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' {1} trying to reconnect.",id,_agentType);
         }
         _reconnectTimer.delay = _reconnectInterval;
         ++_currentAttempt;
         if(_connectMsg == null)
         {
            _connectMsg = buildConnectMessage();
         }
         internalSend(_connectMsg,false);
      }
      
      private function buildConnectErrorMessage() : ErrorMessage
      {
         var _loc1_:ErrorMessage = new ErrorMessage();
         _loc1_.faultCode = "Client.Error.Connect";
         _loc1_.faultString = resourceManager.getString("messaging","producerConnectError");
         _loc1_.faultDetail = resourceManager.getString("messaging","failedToConnect");
         _loc1_.correlationId = _connectMsg.messageId;
         return _loc1_;
      }
      
      override public function acknowledge(param1:AcknowledgeMessage, param2:IMessage) : void
      {
         if(_disconnectBarrier)
         {
            return;
         }
         super.acknowledge(param1,param2);
         if(param2 is CommandMessage && CommandMessage(param2).operation == CommandMessage.CLIENT_PING_OPERATION)
         {
            stopReconnectTimer();
         }
      }
      
      override public function fault(param1:ErrorMessage, param2:IMessage) : void
      {
         internalFault(param1,param2);
      }
      
      override public function disconnect() : void
      {
         _shouldBeConnected = false;
         stopReconnectTimer();
         super.disconnect();
      }
      
      mx_internal function internalFault(param1:ErrorMessage, param2:IMessage, param3:Boolean = true, param4:Boolean = false) : void
      {
         var _loc5_:ErrorMessage = null;
         if(_disconnectBarrier && !param4)
         {
            return;
         }
         if(param2 is CommandMessage && CommandMessage(param2).operation == CommandMessage.CLIENT_PING_OPERATION)
         {
            if(_reconnectTimer == null)
            {
               if(_connectMsg != null && param1.correlationId == _connectMsg.messageId)
               {
                  _shouldBeConnected = false;
                  (_loc5_ = buildConnectErrorMessage()).rootCause = param1.rootCause;
                  super.fault(_loc5_,param2);
               }
               else
               {
                  super.fault(param1,param2);
               }
            }
         }
         else
         {
            super.fault(param1,param2);
         }
      }
      
      public function connect() : void
      {
         if(!connected)
         {
            _shouldBeConnected = true;
            if(_connectMsg == null)
            {
               _connectMsg = buildConnectMessage();
            }
            internalSend(_connectMsg,false);
         }
      }
      
      override public function channelFaultHandler(param1:ChannelFaultEvent) : void
      {
         super.channelFaultHandler(param1);
         if(_shouldBeConnected && !param1.rejected && !param1.channel.connected)
         {
            startReconnectTimer();
         }
      }
      
      private function buildConnectMessage() : CommandMessage
      {
         var _loc1_:CommandMessage = null;
         _loc1_ = new CommandMessage();
         _loc1_.operation = CommandMessage.CLIENT_PING_OPERATION;
         _loc1_.clientId = clientId;
         _loc1_.destination = destination;
         return _loc1_;
      }
      
      protected function startReconnectTimer() : void
      {
         if(_shouldBeConnected && _reconnectTimer == null)
         {
            if(_reconnectAttempts != 0 && _reconnectInterval > 0)
            {
               if(Log.isDebug())
               {
                  _log.debug("\'{0}\' {1} starting reconnect timer.",id,_agentType);
               }
               _reconnectTimer = new Timer(1);
               _reconnectTimer.addEventListener(TimerEvent.TIMER,reconnect);
               _reconnectTimer.start();
               _currentAttempt = 0;
            }
         }
      }
      
      public function set autoConnect(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_autoConnect != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"autoConnect",_autoConnect,param1);
            _autoConnect = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function set reconnectAttempts(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_reconnectAttempts != param1)
         {
            if(param1 == 0)
            {
               stopReconnectTimer();
            }
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"reconnectAttempts",_reconnectAttempts,param1);
            _reconnectAttempts = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function get autoConnect() : Boolean
      {
         return _autoConnect;
      }
   }
}
