package mx.messaging.channels
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.logging.Log;
   import mx.messaging.Channel;
   import mx.messaging.ConsumerMessageDispatcher;
   import mx.messaging.MessageAgent;
   import mx.messaging.MessageResponder;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class PollingChannel extends Channel
   {
      
      private static const DEFAULT_POLLING_INTERVAL:int = 3000;
       
      
      mx_internal var _timer:Timer;
      
      private var _pollingEnabled:Boolean;
      
      private var _piggybackingEnabled:Boolean;
      
      mx_internal var _pollingInterval:int;
      
      mx_internal var pollOutstanding:Boolean;
      
      private var _pollingRef:int = -1;
      
      mx_internal var _shouldPoll:Boolean;
      
      private var resourceManager:IResourceManager;
      
      public function PollingChannel(param1:String = null, param2:String = null)
      {
         resourceManager = ResourceManager.getInstance();
         super(param1,param2);
         _pollingEnabled = true;
         _shouldPoll = false;
         if(timerRequired())
         {
            _pollingInterval = DEFAULT_POLLING_INTERVAL;
            _timer = new Timer(mx_internal::_pollingInterval,1);
            mx_internal::_timer.addEventListener(TimerEvent.TIMER,internalPoll);
         }
      }
      
      public function enablePolling() : void
      {
         ++_pollingRef;
         if(_pollingRef == 0)
         {
            startPolling();
         }
      }
      
      protected function timerRequired() : Boolean
      {
         return true;
      }
      
      override protected function connectFailed(param1:ChannelFaultEvent) : void
      {
         stopPolling();
         super.connectFailed(param1);
      }
      
      override public function send(param1:MessageAgent, param2:IMessage) : void
      {
         var consumerDispatcher:ConsumerMessageDispatcher = null;
         var msg:CommandMessage = null;
         var agent:MessageAgent = param1;
         var message:IMessage = param2;
         var piggyback:Boolean = false;
         if(!mx_internal::pollOutstanding && _piggybackingEnabled && !(message is CommandMessage))
         {
            if(mx_internal::_shouldPoll)
            {
               piggyback = true;
            }
            else
            {
               consumerDispatcher = ConsumerMessageDispatcher.getInstance();
               if(consumerDispatcher.isChannelUsedForSubscriptions(this))
               {
                  piggyback = true;
               }
            }
         }
         if(piggyback)
         {
            internalPoll();
         }
         super.send(agent,message);
         if(piggyback)
         {
            msg = new CommandMessage();
            msg.operation = CommandMessage.POLL_OPERATION;
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' channel sending poll message\n{1}\n",id,msg.toString());
            }
            try
            {
               internalSend(new PollCommandMessageResponder(null,msg,this,_log));
            }
            catch(e:Error)
            {
               stopPolling();
               throw e;
            }
         }
      }
      
      protected function getPollSyncMessageResponder(param1:MessageAgent, param2:CommandMessage) : MessageResponder
      {
         return null;
      }
      
      protected function applyPollingSettings(param1:XML) : void
      {
         var _loc2_:XML = null;
         if(param1.properties.length())
         {
            _loc2_ = param1.properties[0];
            if(_loc2_["polling-enabled"].length())
            {
               internalPollingEnabled = _loc2_["polling-enabled"].toString() == "true";
            }
            if(_loc2_["polling-interval-millis"].length())
            {
               internalPollingInterval = parseInt(_loc2_["polling-interval-millis"].toString());
            }
            else if(_loc2_["polling-interval-seconds"].length())
            {
               internalPollingInterval = parseInt(_loc2_["polling-interval-seconds"].toString()) * 1000;
            }
            if(_loc2_["piggybacking-enabled"].length())
            {
               internalPiggybackingEnabled = _loc2_["piggybacking-enabled"].toString() == "true";
            }
            if(_loc2_["login-after-disconnect"].length())
            {
               _loginAfterDisconnect = _loc2_["login-after-disconnect"].toString() == "true";
            }
         }
      }
      
      mx_internal function set internalPollingInterval(param1:Number) : void
      {
         var _loc2_:String = null;
         if(param1 == 0)
         {
            _pollingInterval = param1;
            if(mx_internal::_timer != null)
            {
               mx_internal::_timer.stop();
            }
            if(mx_internal::_shouldPoll)
            {
               startPolling();
            }
         }
         else
         {
            if(param1 <= 0)
            {
               _loc2_ = resourceManager.getString("messaging","pollingIntervalNonPositive");
               throw new ArgumentError(_loc2_);
            }
            if(mx_internal::_timer != null)
            {
               mx_internal::_timer.delay = _pollingInterval = param1;
               if(!mx_internal::timerRunning && mx_internal::_shouldPoll)
               {
                  startPolling();
               }
            }
         }
      }
      
      public function poll() : void
      {
         internalPoll();
      }
      
      protected function set internalPiggybackingEnabled(param1:Boolean) : void
      {
         _piggybackingEnabled = param1;
      }
      
      protected function get internalPollingEnabled() : Boolean
      {
         return _pollingEnabled;
      }
      
      mx_internal function pollFailed(param1:Boolean = false) : void
      {
         internalDisconnect(param1);
      }
      
      mx_internal function stopPolling() : void
      {
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel polling stopped.",id);
         }
         if(mx_internal::_timer != null)
         {
            mx_internal::_timer.stop();
         }
         _pollingRef = -1;
         _shouldPoll = false;
         pollOutstanding = false;
      }
      
      protected function internalPoll(param1:Event = null) : void
      {
         var msg:CommandMessage = null;
         var event:Event = param1;
         if(!mx_internal::pollOutstanding)
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel requesting queued messages.",id);
            }
            if(mx_internal::timerRunning)
            {
               mx_internal::_timer.stop();
            }
            msg = new CommandMessage();
            msg.operation = CommandMessage.POLL_OPERATION;
            if(Log.isDebug())
            {
               _log.debug("\'{0}\' channel sending poll message\n{1}\n",id,msg.toString());
            }
            try
            {
               internalSend(new PollCommandMessageResponder(null,msg,this,_log));
               pollOutstanding = true;
            }
            catch(e:Error)
            {
               stopPolling();
               throw e;
            }
         }
         else if(Log.isInfo())
         {
            _log.info("\'{0}\' channel waiting for poll response.",id);
         }
      }
      
      protected function getDefaultMessageResponder(param1:MessageAgent, param2:IMessage) : MessageResponder
      {
         return super.getMessageResponder(param1,param2);
      }
      
      mx_internal function get internalPollingInterval() : Number
      {
         return mx_internal::_timer == null ? Number(0) : Number(mx_internal::_pollingInterval);
      }
      
      protected function startPolling() : void
      {
         if(_pollingEnabled)
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel polling started.",id);
            }
            _shouldPoll = true;
            poll();
         }
      }
      
      protected function get internalPiggybackingEnabled() : Boolean
      {
         return _piggybackingEnabled;
      }
      
      override mx_internal function get realtime() : Boolean
      {
         return _pollingEnabled;
      }
      
      override protected final function getMessageResponder(param1:MessageAgent, param2:IMessage) : MessageResponder
      {
         var _loc4_:CommandMessage = null;
         var _loc3_:MessageResponder = null;
         if(param2 is CommandMessage)
         {
            if((_loc4_ = CommandMessage(param2)).operation == CommandMessage.SUBSCRIBE_OPERATION || _loc4_.operation == CommandMessage.UNSUBSCRIBE_OPERATION)
            {
               _loc3_ = getPollSyncMessageResponder(param1,_loc4_);
            }
            else if(_loc4_.operation == CommandMessage.POLL_OPERATION)
            {
               _loc3_ = new PollCommandMessageResponder(param1,param2,this,_log);
            }
         }
         return _loc3_ == null ? getDefaultMessageResponder(param1,param2) : _loc3_;
      }
      
      override protected function internalDisconnect(param1:Boolean = false) : void
      {
         stopPolling();
         super.internalDisconnect(param1);
      }
      
      mx_internal function get timerRunning() : Boolean
      {
         return mx_internal::_timer != null && mx_internal::_timer.running;
      }
      
      public function disablePolling() : void
      {
         --_pollingRef;
         if(_pollingRef < 0)
         {
            stopPolling();
         }
      }
      
      protected function set internalPollingEnabled(param1:Boolean) : void
      {
         _pollingEnabled = param1;
         if(!param1 && (mx_internal::timerRunning || !mx_internal::timerRunning && mx_internal::_pollingInterval == 0))
         {
            stopPolling();
         }
         else if(param1 && mx_internal::_shouldPoll && !mx_internal::timerRunning)
         {
            startPolling();
         }
      }
   }
}

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.channels.PollingChannel;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.events.MessageEvent;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.messaging.messages.MessagePerformanceUtils;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

class PollCommandMessageResponder extends MessageResponder
{
    
   
   private var _log:ILogger;
   
   private var resourceManager:IResourceManager;
   
   function PollCommandMessageResponder(param1:MessageAgent, param2:IMessage, param3:PollingChannel, param4:ILogger)
   {
      resourceManager = ResourceManager.getInstance();
      super(param1,param2,param3);
      _log = param4;
   }
   
   override protected function statusHandler(param1:IMessage) : void
   {
      var _loc2_:PollingChannel = PollingChannel(channel);
      _loc2_.stopPolling();
      var _loc3_:ErrorMessage = param1 as ErrorMessage;
      var _loc4_:String = _loc3_ != null ? _loc3_.faultDetail : "";
      var _loc5_:ChannelFaultEvent;
      (_loc5_ = ChannelFaultEvent.createEvent(_loc2_,false,"Channel.Polling.Error","error",_loc4_)).rootCause = param1;
      _loc2_.dispatchEvent(_loc5_);
      if(_loc3_ != null && _loc3_.faultCode == "Server.PollNotSupported")
      {
         _loc2_.pollFailed(true);
      }
      else
      {
         _loc2_.pollFailed(false);
      }
   }
   
   override protected function resultHandler(param1:IMessage) : void
   {
      var _loc3_:Array = null;
      var _loc4_:IMessage = null;
      var _loc5_:MessagePerformanceUtils = null;
      var _loc6_:ErrorMessage = null;
      var _loc7_:int = 0;
      PollingChannel(channel).pollOutstanding = false;
      if(param1 is CommandMessage)
      {
         if(param1.headers[CommandMessage.NO_OP_POLL_HEADER] == true)
         {
            return;
         }
         if(param1.body != null)
         {
            _loc3_ = param1.body as Array;
            for each(_loc4_ in _loc3_)
            {
               if(Log.isDebug())
               {
                  _log.debug("\'{0}\' channel got message\n{1}\n",channel.id,_loc4_.toString());
                  if(channel.mpiEnabled)
                  {
                     _loc5_ = new MessagePerformanceUtils(_loc4_);
                     _log.debug(_loc5_.prettyPrint());
                  }
               }
               channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE,_loc4_));
            }
         }
      }
      else if(!(param1 is AcknowledgeMessage))
      {
         (_loc6_ = new ErrorMessage()).faultDetail = resourceManager.getString("messaging","receivedNull");
         status(_loc6_);
         return;
      }
      var _loc2_:PollingChannel = PollingChannel(channel);
      if(_loc2_.connected && _loc2_._shouldPoll)
      {
         _loc7_ = 0;
         if(param1.headers[CommandMessage.POLL_WAIT_HEADER] != null)
         {
            _loc7_ = param1.headers[CommandMessage.POLL_WAIT_HEADER];
         }
         if(_loc7_ == 0)
         {
            if(_loc2_.internalPollingInterval == 0)
            {
               _loc2_.poll();
            }
            else if(!_loc2_.timerRunning)
            {
               _loc2_._timer.delay = _loc2_._pollingInterval;
               _loc2_._timer.start();
            }
         }
         else
         {
            _loc2_._timer.delay = _loc7_;
            _loc2_._timer.start();
         }
      }
   }
}
