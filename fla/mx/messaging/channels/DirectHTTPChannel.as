package mx.messaging.channels
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   import mx.core.mx_internal;
   import mx.messaging.Channel;
   import mx.messaging.MessageAgent;
   import mx.messaging.MessageResponder;
   import mx.messaging.errors.ChannelError;
   import mx.messaging.errors.InvalidChannelError;
   import mx.messaging.errors.MessageSerializationError;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   public class DirectHTTPChannel extends Channel
   {
      
      private static var clientCounter:uint;
       
      
      mx_internal var clientId:String;
      
      private var resourceManager:IResourceManager;
      
      public function DirectHTTPChannel(param1:String, param2:String = "")
      {
         var _loc3_:String = null;
         resourceManager = ResourceManager.getInstance();
         super(param1,param2);
         if(param2.length > 0)
         {
            _loc3_ = resourceManager.getString("messaging","noURIAllowed");
            throw new InvalidChannelError(_loc3_);
         }
         clientId = "DirectHTTPChannel" + clientCounter++;
      }
      
      override public function setCredentials(param1:String, param2:MessageAgent = null, param3:String = null) : void
      {
         var _loc4_:String = resourceManager.getString("messaging","authenticationNotSupported");
         throw new ChannelError(_loc4_);
      }
      
      override protected function internalSend(param1:MessageResponder) : void
      {
         var httpMsgResp:DirectHTTPMessageResponder = null;
         var urlRequest:URLRequest = null;
         var msgResp:MessageResponder = param1;
         httpMsgResp = DirectHTTPMessageResponder(msgResp);
         try
         {
            urlRequest = createURLRequest(httpMsgResp.message);
         }
         catch(e:MessageSerializationError)
         {
            httpMsgResp.agent.fault(e.fault,httpMsgResp.message);
            return;
         }
         var urlLoader:URLLoader = httpMsgResp.urlLoader;
         urlLoader.addEventListener(ErrorEvent.ERROR,httpMsgResp.errorHandler);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,httpMsgResp.errorHandler);
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,httpMsgResp.securityErrorHandler);
         urlLoader.addEventListener(Event.COMPLETE,httpMsgResp.completeHandler);
         urlLoader.load(urlRequest);
      }
      
      override public function get connected() : Boolean
      {
         return true;
      }
      
      override mx_internal function get realtime() : Boolean
      {
         return false;
      }
      
      override protected function internalConnect() : void
      {
         connectSuccess();
      }
      
      override protected function getMessageResponder(param1:MessageAgent, param2:IMessage) : MessageResponder
      {
         return new DirectHTTPMessageResponder(param1,param2,this,new URLLoader());
      }
      
      override public function get protocol() : String
      {
         return "http";
      }
      
      override protected function connectTimeoutHandler(param1:TimerEvent) : void
      {
      }
      
      mx_internal function createURLRequest(param1:IMessage) : URLRequest
      {
         var _loc8_:Array = null;
         var _loc9_:URLRequestHeader = null;
         var _loc10_:* = null;
         var _loc11_:URLVariables = null;
         var _loc12_:Object = null;
         var _loc13_:* = null;
         var _loc2_:HTTPRequestMessage = HTTPRequestMessage(param1);
         var _loc3_:URLRequest = new URLRequest();
         var _loc4_:String = _loc2_.url;
         var _loc5_:String = null;
         _loc3_.contentType = _loc2_.contentType;
         var _loc6_:Boolean = _loc3_.contentType == HTTPRequestMessage.CONTENT_TYPE_XML || _loc3_.contentType == HTTPRequestMessage.CONTENT_TYPE_SOAP_XML;
         var _loc7_:Object;
         if(_loc7_ = _loc2_.httpHeaders)
         {
            _loc8_ = [];
            for(_loc10_ in _loc7_)
            {
               _loc9_ = new URLRequestHeader(_loc10_,_loc7_[_loc10_]);
               _loc8_.push(_loc9_);
            }
            _loc3_.requestHeaders = _loc8_;
         }
         if(!_loc6_)
         {
            _loc11_ = new URLVariables();
            _loc12_ = _loc2_.body;
            for(_loc13_ in _loc12_)
            {
               _loc11_[_loc13_] = _loc2_.body[_loc13_];
            }
            _loc5_ = _loc11_.toString();
         }
         if(_loc2_.method == HTTPRequestMessage.POST_METHOD || _loc6_)
         {
            _loc3_.method = "POST";
            if(_loc3_.contentType == HTTPRequestMessage.CONTENT_TYPE_FORM)
            {
               _loc3_.data = _loc5_;
            }
            else if(_loc2_.body != null && _loc2_.body is XML)
            {
               _loc3_.data = XML(_loc2_.body).toXMLString();
            }
            else
            {
               _loc3_.data = _loc2_.body;
            }
         }
         else if(_loc5_ && _loc5_ != "")
         {
            _loc4_ = (_loc4_ += _loc4_.indexOf("?") > -1 ? "&" : "?") + _loc5_;
         }
         _loc3_.url = _loc4_;
         return _loc3_;
      }
   }
}

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import mx.core.mx_internal;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.channels.DirectHTTPChannel;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.HTTPRequestMessage;
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

class DirectHTTPMessageResponder extends MessageResponder
{
    
   
   public var urlLoader:URLLoader;
   
   private var clientId:String;
   
   private var resourceManager:IResourceManager;
   
   function DirectHTTPMessageResponder(param1:MessageAgent, param2:IMessage, param3:DirectHTTPChannel, param4:URLLoader)
   {
      resourceManager = ResourceManager.getInstance();
      super(param1,param2,param3);
      this.urlLoader = param4;
      clientId = param3.clientId;
   }
   
   public function securityErrorHandler(param1:Event) : void
   {
      status(null);
      var _loc2_:AcknowledgeMessage = new AcknowledgeMessage();
      _loc2_.clientId = clientId;
      _loc2_.correlationId = message.messageId;
      _loc2_.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(_loc2_,message);
      var _loc3_:ErrorMessage = new ErrorMessage();
      _loc3_.clientId = clientId;
      _loc3_.correlationId = message.messageId;
      _loc3_.faultCode = "Channel.Security.Error";
      _loc3_.faultString = resourceManager.getString("messaging","securityError");
      _loc3_.faultDetail = resourceManager.getString("messaging","securityError.details",[message.destination]);
      _loc3_.rootCause = param1;
      agent.fault(_loc3_,message);
   }
   
   public function completeHandler(param1:Event) : void
   {
      result(null);
      var _loc2_:AcknowledgeMessage = new AcknowledgeMessage();
      _loc2_.clientId = clientId;
      _loc2_.correlationId = message.messageId;
      _loc2_.body = URLLoader(param1.target).data;
      agent.acknowledge(_loc2_,message);
   }
   
   public function errorHandler(param1:Event) : void
   {
      status(null);
      var _loc2_:AcknowledgeMessage = new AcknowledgeMessage();
      _loc2_.clientId = clientId;
      _loc2_.correlationId = message.messageId;
      _loc2_.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(_loc2_,message);
      var _loc3_:ErrorMessage = new ErrorMessage();
      _loc3_.clientId = clientId;
      _loc3_.correlationId = message.messageId;
      _loc3_.faultCode = "Server.Error.Request";
      _loc3_.faultString = resourceManager.getString("messaging","httpRequestError");
      var _loc4_:* = param1.toString();
      if(message is HTTPRequestMessage)
      {
         _loc4_ = (_loc4_ += ". URL: ") + HTTPRequestMessage(message).url;
      }
      _loc3_.faultDetail = resourceManager.getString("messaging","httpRequestError.details",[_loc4_]);
      _loc3_.rootCause = param1;
      agent.fault(_loc3_,message);
   }
   
   override protected function requestTimedOut() : void
   {
      urlLoader.removeEventListener(ErrorEvent.ERROR,errorHandler);
      urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
      urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
      urlLoader.removeEventListener(Event.COMPLETE,completeHandler);
      urlLoader.close();
      status(null);
      var _loc1_:AcknowledgeMessage = new AcknowledgeMessage();
      _loc1_.clientId = clientId;
      _loc1_.correlationId = message.messageId;
      _loc1_.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
      agent.acknowledge(_loc1_,message);
      agent.fault(createRequestTimeoutErrorMessage(),message);
   }
}
