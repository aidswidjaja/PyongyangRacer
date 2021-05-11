package mx.messaging
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.messaging.channels.PollingChannel;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.events.MessageFaultEvent;
   import mx.messaging.messages.AcknowledgeMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.ErrorMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class AbstractConsumer extends MessageAgent
   {
       
      
      private var _currentAttempt:int;
      
      private var _timestamp:Number = -1;
      
      private var _resubscribeInterval:int = 5000;
      
      private var _resubscribeAttempts:int = 5;
      
      private var _resubscribeTimer:Timer;
      
      protected var _shouldBeSubscribed:Boolean;
      
      private var _subscribeMsg:CommandMessage;
      
      private var _subscribed:Boolean;
      
      private var resourceManager:IResourceManager;
      
      public function AbstractConsumer()
      {
         resourceManager = ResourceManager.getInstance();
         super();
         _log = Log.getLogger("mx.messaging.Consumer");
         _agentType = "consumer";
      }
      
      override public function channelFaultHandler(param1:ChannelFaultEvent) : void
      {
         if(!param1.channel.connected)
         {
            setSubscribed(false);
         }
         super.channelFaultHandler(param1);
         if(_shouldBeSubscribed && !param1.rejected && !param1.channel.connected)
         {
            startResubscribeTimer();
         }
      }
      
      protected function buildUnsubscribeMessage(param1:Boolean) : CommandMessage
      {
         var _loc2_:CommandMessage = null;
         _loc2_ = new CommandMessage();
         _loc2_.operation = CommandMessage.UNSUBSCRIBE_OPERATION;
         _loc2_.clientId = clientId;
         _loc2_.destination = destination;
         if(param1)
         {
            _loc2_.headers[CommandMessage.PRESERVE_DURABLE_HEADER] = param1;
         }
         return _loc2_;
      }
      
      override mx_internal function setClientId(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(super.clientId != param1)
         {
            _loc2_ = false;
            if(subscribed)
            {
               unsubscribe();
               _loc2_ = true;
            }
            super.setClientId(param1);
            if(_loc2_)
            {
               subscribe(param1);
            }
         }
      }
      
      override public function disconnect() : void
      {
         _shouldBeSubscribed = false;
         stopResubscribeTimer();
         setSubscribed(false);
         super.disconnect();
      }
      
      public function subscribe(param1:String = null) : void
      {
         var _loc2_:Boolean = param1 != null && super.clientId != param1 ? true : false;
         if(subscribed && _loc2_)
         {
            unsubscribe();
         }
         stopResubscribeTimer();
         _shouldBeSubscribed = true;
         if(_loc2_)
         {
            super.setClientId(param1);
         }
         if(Log.isInfo())
         {
            _log.info("\'{0}\' {1} subscribe.",id,_agentType);
         }
         _subscribeMsg = buildSubscribeMessage();
         internalSend(_subscribeMsg);
      }
      
      override public function channelDisconnectHandler(param1:ChannelEvent) : void
      {
         setSubscribed(false);
         super.channelDisconnectHandler(param1);
         if(_shouldBeSubscribed && !param1.rejected)
         {
            startResubscribeTimer();
         }
      }
      
      protected function buildSubscribeMessage() : CommandMessage
      {
         var _loc1_:CommandMessage = new CommandMessage();
         _loc1_.operation = CommandMessage.SUBSCRIBE_OPERATION;
         _loc1_.clientId = clientId;
         _loc1_.destination = destination;
         return _loc1_;
      }
      
      protected function startResubscribeTimer() : void
      {
         if(_shouldBeSubscribed && _resubscribeTimer == null)
         {
            if(_resubscribeAttempts != 0 && _resubscribeInterval > 0)
            {
               if(Log.isDebug())
               {
                  _log.debug("\'{0}\' {1} starting resubscribe timer.",id,_agentType);
               }
               _resubscribeTimer = new Timer(1);
               _resubscribeTimer.addEventListener(TimerEvent.TIMER,resubscribe);
               _resubscribeTimer.start();
               _currentAttempt = 0;
            }
         }
      }
      
      public function unsubscribe(param1:Boolean = false) : void
      {
         _shouldBeSubscribed = false;
         if(subscribed)
         {
            if(channelSet != null)
            {
               channelSet.removeEventListener(destination,mx_internal::messageHandler);
            }
            if(Log.isInfo())
            {
               _log.info("\'{0}\' {1} unsubscribe.",id,_agentType);
            }
            internalSend(buildUnsubscribeMessage(param1));
         }
         else
         {
            stopResubscribeTimer();
         }
      }
      
      mx_internal function messageHandler(param1:MessageEvent) : void
      {
         var _loc3_:CommandMessage = null;
         var _loc2_:IMessage = param1.message;
         if(_loc2_ is CommandMessage)
         {
            _loc3_ = _loc2_ as CommandMessage;
            switch(_loc3_.operation)
            {
               case CommandMessage.SUBSCRIPTION_INVALIDATE_OPERATION:
                  if(channelSet.currentChannel is PollingChannel)
                  {
                     PollingChannel(channelSet.currentChannel).disablePolling();
                  }
                  setSubscribed(false);
                  break;
               default:
                  if(Log.isWarn())
                  {
                     _log.warn("\'{0}\' received a CommandMessage \'{1}\' that could not be handled.",id,CommandMessage.getOperationAsString(_loc3_.operation));
                  }
            }
            return;
         }
         if(_loc2_.timestamp > _timestamp)
         {
            _timestamp = _loc2_.timestamp;
         }
         if(_loc2_ is ErrorMessage)
         {
            dispatchEvent(MessageFaultEvent.createEvent(ErrorMessage(_loc2_)));
         }
         else
         {
            dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,_loc2_));
         }
      }
      
      public function get timestamp() : Number
      {
         return _timestamp;
      }
      
      public function get resubscribeInterval() : int
      {
         return _resubscribeInterval;
      }
      
      public function get subscribed() : Boolean
      {
         return _subscribed;
      }
      
      override public function fault(param1:ErrorMessage, param2:IMessage) : void
      {
         if(_disconnectBarrier)
         {
            return;
         }
         if(param1.headers[ErrorMessage.RETRYABLE_HINT_HEADER])
         {
            if(_resubscribeTimer == null)
            {
               if(_subscribeMsg != null && param1.correlationId == _subscribeMsg.messageId)
               {
                  _shouldBeSubscribed = false;
               }
               super.fault(param1,param2);
            }
         }
         else
         {
            super.fault(param1,param2);
         }
      }
      
      protected function setSubscribed(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_subscribed != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"subscribed",_subscribed,param1);
            _subscribed = param1;
            if(_subscribed)
            {
               ConsumerMessageDispatcher.getInstance().registerSubscription(this);
               if(channelSet != null && channelSet.currentChannel != null && channelSet.currentChannel is PollingChannel)
               {
                  PollingChannel(channelSet.currentChannel).enablePolling();
               }
            }
            else
            {
               ConsumerMessageDispatcher.getInstance().unregisterSubscription(this);
               if(channelSet != null && channelSet.currentChannel != null && channelSet.currentChannel is PollingChannel)
               {
                  PollingChannel(channelSet.currentChannel).disablePolling();
               }
            }
            dispatchEvent(_loc2_);
         }
      }
      
      public function get resubscribeAttempts() : int
      {
         return _resubscribeAttempts;
      }
      
      public function receive(param1:Number = 0) : void
      {
         var _loc2_:CommandMessage = null;
         if(clientId != null)
         {
            _loc2_ = new CommandMessage();
            _loc2_.operation = CommandMessage.POLL_OPERATION;
            _loc2_.destination = destination;
            internalSend(_loc2_);
         }
      }
      
      override public function set destination(param1:String) : void
      {
         var _loc2_:Boolean = false;
         if(destination != param1)
         {
            _loc2_ = false;
            if(subscribed)
            {
               unsubscribe();
               _loc2_ = true;
            }
            super.destination = param1;
            if(_loc2_)
            {
               subscribe();
            }
         }
      }
      
      protected function stopResubscribeTimer() : void
      {
         if(_resubscribeTimer != null)
         {
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' {1} stopping resubscribe timer.",id,_agentType);
            }
            _resubscribeTimer.removeEventListener(TimerEvent.TIMER,resubscribe);
            _resubscribeTimer.reset();
            _resubscribeTimer = null;
         }
      }
      
      override public function acknowledge(param1:AcknowledgeMessage, param2:IMessage) : void
      {
         var _loc3_:CommandMessage = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:IMessage = null;
         if(_disconnectBarrier)
         {
            return;
         }
         if(!param1.headers[AcknowledgeMessage.ERROR_HINT_HEADER] && param2 is CommandMessage)
         {
            _loc3_ = param2 as CommandMessage;
            if((_loc4_ = _loc3_.operation) == CommandMessage.MULTI_SUBSCRIBE_OPERATION)
            {
               if(param2.headers.DSlastUnsub != null)
               {
                  _loc4_ = CommandMessage.UNSUBSCRIBE_OPERATION;
               }
               else
               {
                  _loc4_ = CommandMessage.SUBSCRIBE_OPERATION;
               }
            }
            switch(_loc4_)
            {
               case CommandMessage.UNSUBSCRIBE_OPERATION:
                  if(Log.isInfo())
                  {
                     _log.info("\'{0}\' {1} acknowledge for unsubscribe.",id,_agentType);
                  }
                  super.setClientId(null);
                  setSubscribed(false);
                  param1.clientId = null;
                  super.acknowledge(param1,param2);
                  break;
               case CommandMessage.SUBSCRIBE_OPERATION:
                  stopResubscribeTimer();
                  if(param1.timestamp > _timestamp)
                  {
                     _timestamp = param1.timestamp - 1;
                  }
                  if(Log.isInfo())
                  {
                     _log.info("\'{0}\' {1} acknowledge for subscribe. Client id \'{2}\' new timestamp {3}",id,_agentType,param1.clientId,_timestamp);
                  }
                  super.setClientId(param1.clientId);
                  setSubscribed(true);
                  super.acknowledge(param1,param2);
                  break;
               case CommandMessage.POLL_OPERATION:
                  if(param1.body != null && param1.body is Array)
                  {
                     _loc5_ = param1.body as Array;
                     for each(_loc6_ in _loc5_)
                     {
                        messageHandler(MessageEvent.createEvent(MessageEvent.MESSAGE,_loc6_));
                     }
                  }
                  super.acknowledge(param1,param2);
            }
         }
         else
         {
            super.acknowledge(param1,param2);
         }
      }
      
      protected function resubscribe(param1:TimerEvent) : void
      {
         var _loc2_:ErrorMessage = null;
         if(_resubscribeAttempts != -1 && _currentAttempt >= _resubscribeAttempts)
         {
            stopResubscribeTimer();
            _shouldBeSubscribed = false;
            _loc2_ = new ErrorMessage();
            _loc2_.faultCode = "Client.Error.Subscribe";
            _loc2_.faultString = resourceManager.getString("messaging","consumerSubscribeError");
            _loc2_.faultDetail = resourceManager.getString("messaging","failedToSubscribe");
            _loc2_.correlationId = _subscribeMsg.messageId;
            fault(_loc2_,_subscribeMsg);
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' {1} trying to resubscribe.",id,_agentType);
         }
         _resubscribeTimer.delay = _resubscribeInterval;
         ++_currentAttempt;
         internalSend(_subscribeMsg,false);
      }
      
      public function set resubscribeInterval(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         var _loc3_:String = null;
         if(_resubscribeInterval != param1)
         {
            if(param1 < 0)
            {
               _loc3_ = resourceManager.getString("messaging","resubscribeIntervalNegative");
               throw new ArgumentError(_loc3_);
            }
            if(param1 == 0)
            {
               stopResubscribeTimer();
            }
            else if(_resubscribeTimer != null)
            {
               _resubscribeTimer.delay = param1;
            }
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"resubscribeInterval",_resubscribeInterval,param1);
            _resubscribeInterval = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function set resubscribeAttempts(param1:int) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_resubscribeAttempts != param1)
         {
            if(param1 == 0)
            {
               stopResubscribeTimer();
            }
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"resubscribeAttempts",_resubscribeAttempts,param1);
            _resubscribeAttempts = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function set timestamp(param1:Number) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_timestamp != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"timestamp",_timestamp,param1);
            _timestamp = param1;
            dispatchEvent(_loc2_);
         }
      }
   }
}
