package mx.messaging
{
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.config.LoaderConfig;
   import mx.messaging.config.ServerConfig;
   import mx.messaging.errors.InvalidDestinationError;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.URLUtil;
   
   use namespace mx_internal;
   
   public class Channel extends EventDispatcher implements IMXMLObject
   {
      
      public static const SMALL_MESSAGES_FEATURE:String = "small_messages";
      
      private static const dep:ArrayCollection = null;
       
      
      private var _failoverIndex:int;
      
      private var _ownsWaitGuard:Boolean = false;
      
      protected var _recordMessageTimes:Boolean = false;
      
      private var _reconnecting:Boolean = false;
      
      private var _authenticated:Boolean = false;
      
      protected var messagingVersion:Number = 1;
      
      private var _channelSets:Array;
      
      private var _connectTimeout:int = -1;
      
      mx_internal var authenticating:Boolean;
      
      protected var _connecting:Boolean;
      
      private var _connectTimer:Timer;
      
      protected var _recordMessageSizes:Boolean = false;
      
      private var _failoverURIs:Array;
      
      protected var _log:ILogger;
      
      private var _connected:Boolean = false;
      
      private var _smallMessagesSupported:Boolean;
      
      private var _primaryURI:String;
      
      public var enableSmallMessages:Boolean = true;
      
      private var _id:String;
      
      private var resourceManager:IResourceManager;
      
      private var _uri:String;
      
      protected var _loginAfterDisconnect:Boolean = false;
      
      private var _isEndpointCalculated:Boolean = false;
      
      private var _shouldBeConnected:Boolean;
      
      private var _requestTimeout:int = -1;
      
      private var _endpoint:String;
      
      protected var credentials:String;
      
      public function Channel(param1:String = null, param2:String = null)
      {
         resourceManager = ResourceManager.getInstance();
         _channelSets = [];
         super();
         _log = Log.getLogger("mx.messaging.Channel");
         _connecting = false;
         _failoverIndex = -1;
         this.id = param1;
         _primaryURI = param2;
         _shouldBeConnected = false;
         this.uri = param2;
         authenticating = false;
      }
      
      private function shutdownConnectTimer() : void
      {
         if(_connectTimer != null)
         {
            _connectTimer.stop();
            _connectTimer = null;
         }
      }
      
      public function get connected() : Boolean
      {
         return _connected;
      }
      
      public function get connectTimeout() : int
      {
         return _connectTimeout;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      private function calculateEndpoint() : void
      {
         var _loc1_:String = uri;
         var _loc2_:String = URLUtil.getProtocol(_loc1_);
         if(_loc2_.length == 0)
         {
            _loc1_ = URLUtil.getFullURL(LoaderConfig.url,_loc1_);
         }
         if(!URLUtil.hasUnresolvableTokens())
         {
            _isEndpointCalculated = false;
            return;
         }
         _loc1_ = URLUtil.replaceTokens(_loc1_);
         _loc2_ = URLUtil.getProtocol(_loc1_);
         if(_loc2_.length > 0)
         {
            _endpoint = URLUtil.replaceProtocol(_loc1_,protocol);
         }
         else
         {
            _endpoint = protocol + ":" + _loc1_;
         }
         _isEndpointCalculated = true;
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel endpoint set to {1}",id,_endpoint);
         }
      }
      
      public function get reconnecting() : Boolean
      {
         return _reconnecting;
      }
      
      public function get useSmallMessages() : Boolean
      {
         return _smallMessagesSupported && enableSmallMessages;
      }
      
      public function set connectTimeout(param1:int) : void
      {
         _connectTimeout = param1;
      }
      
      public function get authenticated() : Boolean
      {
         return _authenticated;
      }
      
      protected function getMessageResponder(param1:MessageAgent, param2:IMessage) : MessageResponder
      {
         throw new IllegalOperationError("Channel subclasses must override " + " getMessageResponder().");
      }
      
      public function set failoverURIs(param1:Array) : void
      {
         if(param1 != null)
         {
            _failoverURIs = param1;
            _failoverIndex = -1;
         }
      }
      
      protected function internalDisconnect(param1:Boolean = false) : void
      {
      }
      
      public function setCredentials(param1:String, param2:MessageAgent = null, param3:String = null) : void
      {
         var _loc5_:CommandMessage = null;
         var _loc4_:* = this.credentials !== param1;
         if(mx_internal::authenticating && _loc4_)
         {
            throw new IllegalOperationError("Credentials cannot be set while authenticating or logging out.");
         }
         if(authenticated && _loc4_)
         {
            throw new IllegalOperationError("Credentials cannot be set when already authenticated. Logout must be performed before changing credentials.");
         }
         this.credentials = param1;
         if(connected && _loc4_ && param1 != null)
         {
            authenticating = true;
            (_loc5_ = new CommandMessage()).operation = CommandMessage.LOGIN_OPERATION;
            _loc5_.body = param1;
            if(param3 != null)
            {
               _loc5_.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = param3;
            }
            internalSend(new AuthenticationMessageResponder(param2,_loc5_,this,_log));
         }
      }
      
      public function get mpiEnabled() : Boolean
      {
         return _recordMessageSizes || _recordMessageTimes;
      }
      
      public function set id(param1:String) : void
      {
         if(_id != param1)
         {
            _id = param1;
         }
      }
      
      protected function connectTimeoutHandler(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:ChannelFaultEvent = null;
         shutdownConnectTimer();
         if(!connected)
         {
            _shouldBeConnected = false;
            _loc2_ = resourceManager.getString("messaging","connectTimedOut");
            _loc3_ = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","error",_loc2_);
            connectFailed(_loc3_);
         }
      }
      
      protected function setFlexClientIdOnMessage(param1:IMessage) : void
      {
         var _loc2_:String = FlexClient.getInstance().id;
         param1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] = _loc2_ != null ? _loc2_ : FlexClient.NULL_FLEXCLIENT_ID;
      }
      
      protected function flexClientWaitHandler(param1:PropertyChangeEvent) : void
      {
         var _loc2_:FlexClient = null;
         if(param1.property == "waitForFlexClientId")
         {
            _loc2_ = param1.source as FlexClient;
            if(_loc2_.waitForFlexClientId == false)
            {
               _loc2_.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,flexClientWaitHandler);
               _loc2_.waitForFlexClientId = true;
               _ownsWaitGuard = true;
               internalConnect();
            }
         }
      }
      
      public function set useSmallMessages(param1:Boolean) : void
      {
         _smallMessagesSupported = param1;
      }
      
      mx_internal function internalSetCredentials(param1:String) : void
      {
         this.credentials = param1;
      }
      
      private function reconnect(param1:TimerEvent) : void
      {
         internalConnect();
      }
      
      mx_internal function get realtime() : Boolean
      {
         return false;
      }
      
      protected function internalConnect() : void
      {
      }
      
      public function get url() : String
      {
         return uri;
      }
      
      public function get recordMessageTimes() : Boolean
      {
         return _recordMessageTimes;
      }
      
      public function get uri() : String
      {
         return _uri;
      }
      
      private function initializeRequestTimeout(param1:MessageResponder) : void
      {
         var _loc2_:IMessage = param1.message;
         if(_loc2_.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] != null)
         {
            param1.startRequestTimeout(_loc2_.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER]);
         }
         else if(requestTimeout > 0)
         {
            param1.startRequestTimeout(requestTimeout);
         }
      }
      
      public function send(param1:MessageAgent, param2:IMessage) : void
      {
         var _loc4_:String = null;
         if(param2.destination.length == 0)
         {
            if(param1.destination.length == 0)
            {
               _loc4_ = resourceManager.getString("messaging","noDestinationSpecified");
               throw new InvalidDestinationError(_loc4_);
            }
            param2.destination = param1.destination;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel sending message:\n{1}",id,param2.toString());
         }
         param2.headers[AbstractMessage.ENDPOINT_HEADER] = id;
         var _loc3_:MessageResponder = getMessageResponder(param1,param2);
         initializeRequestTimeout(_loc3_);
         internalSend(_loc3_);
      }
      
      public function logout(param1:MessageAgent) : void
      {
         var _loc2_:CommandMessage = null;
         if(connected && authenticated && credentials || mx_internal::authenticating && credentials)
         {
            _loc2_ = new CommandMessage();
            _loc2_.operation = CommandMessage.LOGOUT_OPERATION;
            internalSend(new AuthenticationMessageResponder(param1,_loc2_,this,_log));
            authenticating = true;
         }
         credentials = null;
      }
      
      public function get endpoint() : String
      {
         if(!_isEndpointCalculated)
         {
            calculateEndpoint();
         }
         return _endpoint;
      }
      
      public function get protocol() : String
      {
         throw new IllegalOperationError("Channel subclasses must override " + "the get function for \'protocol\' to return the proper protocol " + "string.");
      }
      
      public function get failoverURIs() : Array
      {
         return _failoverURIs != null ? _failoverURIs : [];
      }
      
      public final function disconnect(param1:ChannelSet) : void
      {
         if(_ownsWaitGuard)
         {
            _ownsWaitGuard = false;
            FlexClient.getInstance().waitForFlexClientId = false;
         }
         var _loc2_:int = param1 != null ? int(_channelSets.indexOf(param1)) : -1;
         if(_loc2_ != -1)
         {
            _channelSets.splice(_loc2_,1);
            removeEventListener(ChannelEvent.CONNECT,param1.channelConnectHandler,false);
            removeEventListener(ChannelEvent.DISCONNECT,param1.channelDisconnectHandler,false);
            removeEventListener(ChannelFaultEvent.FAULT,param1.channelFaultHandler,false);
            if(connected)
            {
               param1.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT,this,false));
            }
            if(_channelSets.length == 0)
            {
               _shouldBeConnected = false;
               if(connected)
               {
                  internalDisconnect();
               }
            }
         }
      }
      
      public function set requestTimeout(param1:int) : void
      {
         _requestTimeout = param1;
      }
      
      private function shouldAttemptFailover() : Boolean
      {
         return _shouldBeConnected && _failoverURIs != null && _failoverURIs.length > 0;
      }
      
      private function setReconnecting(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_reconnecting != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"reconnecting",_reconnecting,param1);
            _reconnecting = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function applySettings(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XMLList = null;
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel settings are:\n{1}",id,param1);
         }
         if(param1.properties.length())
         {
            _loc2_ = param1.properties[0];
            if(_loc2_["connect-timeout-seconds"].length())
            {
               connectTimeout = _loc2_["connect-timeout-seconds"].toString();
            }
            if(_loc2_["record-message-times"].length())
            {
               _recordMessageTimes = _loc2_["record-message-times"].toString() == "true";
            }
            if(_loc2_["record-message-sizes"].length())
            {
               _recordMessageSizes = _loc2_["record-message-sizes"].toString() == "true";
            }
            _loc3_ = _loc2_["serialization"];
            if(_loc3_.length() > 0)
            {
               if(_loc3_["enable-small-messages"].toString() == "false")
               {
                  enableSmallMessages = false;
               }
            }
         }
      }
      
      protected function connectSuccess() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(_ownsWaitGuard)
         {
            _ownsWaitGuard = false;
            FlexClient.getInstance().waitForFlexClientId = false;
         }
         shutdownConnectTimer();
         _connecting = false;
         if(ServerConfig.fetchedConfig(endpoint))
         {
            _loc1_ = 0;
            while(_loc1_ < channelSets.length)
            {
               _loc2_ = ChannelSet(channelSets[_loc1_]).messageAgents;
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc2_[_loc3_].needsConfig = false;
                  _loc3_++;
               }
               _loc1_++;
            }
         }
         setConnected(true);
         _failoverIndex = -1;
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel is connected.",id);
         }
         dispatchEvent(ChannelEvent.createEvent(ChannelEvent.CONNECT,this,reconnecting));
         setReconnecting(false);
      }
      
      public function get recordMessageSizes() : Boolean
      {
         return _recordMessageSizes;
      }
      
      protected function disconnectSuccess(param1:Boolean = false) : void
      {
         setConnected(false);
         if(Log.isInfo())
         {
            _log.info("\'{0}\' channel disconnected.",id);
         }
         if(!param1 && shouldAttemptFailover())
         {
            _connecting = true;
            failover();
         }
         else
         {
            _connecting = false;
         }
         dispatchEvent(ChannelEvent.createEvent(ChannelEvent.DISCONNECT,this,reconnecting,param1));
      }
      
      protected function setConnected(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_connected != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"connected",_connected,param1);
            _connected = param1;
            dispatchEvent(_loc2_);
            if(!param1)
            {
               setAuthenticated(false);
            }
         }
      }
      
      public function get requestTimeout() : int
      {
         return _requestTimeout;
      }
      
      protected function connectFailed(param1:ChannelFaultEvent) : void
      {
         shutdownConnectTimer();
         setConnected(false);
         if(Log.isError())
         {
            _log.error("\'{0}\' channel connect failed.",id);
         }
         if(!param1.rejected && shouldAttemptFailover())
         {
            _connecting = true;
            failover();
         }
         else
         {
            if(_ownsWaitGuard)
            {
               _ownsWaitGuard = false;
               FlexClient.getInstance().waitForFlexClientId = false;
            }
            _connecting = false;
         }
         if(reconnecting)
         {
            param1.reconnecting = true;
         }
         dispatchEvent(param1);
      }
      
      public function set uri(param1:String) : void
      {
         if(param1 != null)
         {
            _uri = param1;
            calculateEndpoint();
         }
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this.id = param2;
      }
      
      mx_internal function sendClusterRequest(param1:MessageResponder) : void
      {
         internalSend(param1);
      }
      
      public function set url(param1:String) : void
      {
         uri = param1;
      }
      
      protected function handleServerMessagingVersion(param1:Number) : void
      {
         useSmallMessages = param1 >= messagingVersion;
      }
      
      protected function internalSend(param1:MessageResponder) : void
      {
      }
      
      public final function connect(param1:ChannelSet) : void
      {
         var _loc5_:FlexClient = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = _channelSets.length;
         var _loc4_:int = 0;
         while(_loc4_ < _channelSets.length)
         {
            if(_channelSets[_loc4_] == param1)
            {
               _loc2_ = true;
               break;
            }
            _loc4_++;
         }
         _shouldBeConnected = true;
         if(!_loc2_)
         {
            _channelSets.push(param1);
            addEventListener(ChannelEvent.CONNECT,param1.channelConnectHandler);
            addEventListener(ChannelEvent.DISCONNECT,param1.channelDisconnectHandler);
            addEventListener(ChannelFaultEvent.FAULT,param1.channelFaultHandler);
         }
         if(connected)
         {
            param1.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT,this,false,false,connected));
         }
         else if(!_connecting)
         {
            _connecting = true;
            if(connectTimeout > 0)
            {
               _connectTimer = new Timer(connectTimeout * 1000,1);
               _connectTimer.addEventListener(TimerEvent.TIMER,connectTimeoutHandler);
               _connectTimer.start();
            }
            if(FlexClient.getInstance().id == null)
            {
               if(!(_loc5_ = FlexClient.getInstance()).waitForFlexClientId)
               {
                  _loc5_.waitForFlexClientId = true;
                  _ownsWaitGuard = true;
                  internalConnect();
               }
               else
               {
                  _loc5_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,flexClientWaitHandler);
               }
            }
            else
            {
               internalConnect();
            }
         }
      }
      
      private function resetToPrimaryURI() : void
      {
         _connecting = false;
         setReconnecting(false);
         uri = _primaryURI;
         _failoverIndex = -1;
      }
      
      mx_internal function setAuthenticated(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         var _loc3_:ChannelSet = null;
         var _loc4_:int = 0;
         if(param1 != _authenticated)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"authenticated",_authenticated,param1);
            _authenticated = param1;
            if(!_authenticated)
            {
               credentials = null;
            }
            _loc4_ = 0;
            while(_loc4_ < _channelSets.length)
            {
               _loc3_ = ChannelSet(_channelSets[_loc4_]);
               _loc3_.setAuthenticated(authenticated,credentials);
               _loc4_++;
            }
            dispatchEvent(_loc2_);
         }
      }
      
      mx_internal function get loginAfterDisconnect() : Boolean
      {
         return _loginAfterDisconnect;
      }
      
      private function failover() : void
      {
         var _loc1_:Timer = null;
         ++_failoverIndex;
         if(_failoverIndex + 1 <= failoverURIs.length)
         {
            setReconnecting(true);
            uri = failoverURIs[_failoverIndex];
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel attempting to connect to {1}.",id,endpoint);
            }
            _loc1_ = new Timer(1,1);
            _loc1_.addEventListener(TimerEvent.TIMER,reconnect);
            _loc1_.start();
         }
         else
         {
            if(Log.isInfo())
            {
               _log.info("\'{0}\' channel has exhausted failover options and has reset to its primary endpoint.",id);
            }
            resetToPrimaryURI();
         }
      }
      
      public function get channelSets() : Array
      {
         return _channelSets;
      }
      
      protected function disconnectFailed(param1:ChannelFaultEvent) : void
      {
         _connecting = false;
         setConnected(false);
         if(Log.isError())
         {
            _log.error("\'{0}\' channel disconnect failed.",id);
         }
         if(reconnecting)
         {
            resetToPrimaryURI();
            param1.reconnecting = false;
         }
         dispatchEvent(param1);
      }
   }
}

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.Channel;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;

use namespace mx_internal;

class AuthenticationMessageResponder extends MessageResponder
{
    
   
   private var _log:ILogger;
   
   function AuthenticationMessageResponder(param1:MessageAgent, param2:IMessage, param3:Channel, param4:ILogger)
   {
      super(param1,param2,param3);
      _log = param4;
   }
   
   override protected function statusHandler(param1:IMessage) : void
   {
      var _loc3_:ErrorMessage = null;
      var _loc4_:ChannelFaultEvent = null;
      var _loc2_:CommandMessage = CommandMessage(message);
      if(Log.isDebug())
      {
         _log.debug("{1} failure: {0}",param1.toString(),_loc2_.operation == CommandMessage.LOGIN_OPERATION ? "Login" : "Logout");
      }
      channel.authenticating = false;
      channel.setAuthenticated(false);
      if(agent != null && agent.hasPendingRequestForMessage(message))
      {
         agent.fault(ErrorMessage(param1),message);
      }
      else
      {
         _loc3_ = ErrorMessage(param1);
         (_loc4_ = ChannelFaultEvent.createEvent(channel,false,"Channel.Authentication.Error","warn",_loc3_.faultString)).rootCause = _loc3_;
         channel.dispatchEvent(_loc4_);
      }
   }
   
   override protected function resultHandler(param1:IMessage) : void
   {
      var _loc2_:CommandMessage = message as CommandMessage;
      channel.authenticating = false;
      if(_loc2_.operation == CommandMessage.LOGIN_OPERATION)
      {
         if(Log.isDebug())
         {
            _log.debug("Login successful");
         }
         channel.setAuthenticated(true);
      }
      else
      {
         if(Log.isDebug())
         {
            _log.debug("Logout successful");
         }
         channel.setAuthenticated(false);
      }
   }
}
