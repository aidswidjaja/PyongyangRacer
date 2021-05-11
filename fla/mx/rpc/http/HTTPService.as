package mx.rpc.http
{
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.core.mx_internal;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.messaging.channels.DirectHTTPChannel;
   import mx.messaging.config.LoaderConfig;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.messaging.messages.IMessage;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.AbstractInvoker;
   import mx.rpc.AsyncDispatcher;
   import mx.rpc.AsyncRequest;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.xml.SimpleXMLDecoder;
   import mx.rpc.xml.SimpleXMLEncoder;
   import mx.utils.ObjectProxy;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   import mx.utils.URLUtil;
   
   use namespace mx_internal;
   
   public class HTTPService extends AbstractInvoker
   {
      
      public static const RESULT_FORMAT_E4X:String = "e4x";
      
      public static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
      
      private static var _directChannelSet:ChannelSet;
      
      public static const RESULT_FORMAT_XML:String = "xml";
      
      public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
      
      public static const RESULT_FORMAT_TEXT:String = "text";
      
      public static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
      
      public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
      
      public static const CONTENT_TYPE_XML:String = "application/xml";
      
      public static const ERROR_ENCODING:String = "Client.CouldNotEncode";
      
      public static const RESULT_FORMAT_ARRAY:String = "array";
      
      public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
      
      public static const RESULT_FORMAT_OBJECT:String = "object";
      
      public static const ERROR_DECODING:String = "Client.CouldNotDecode";
       
      
      private var _log:ILogger;
      
      public var headers:Object;
      
      public var request:Object;
      
      private var _resultFormat:String = "object";
      
      public var xmlEncode:Function;
      
      private var _useProxy:Boolean = false;
      
      public var contentType:String = "application/x-www-form-urlencoded";
      
      public var method:String = "GET";
      
      public var xmlDecode:Function;
      
      mx_internal var _rootURL:String;
      
      private var _url:String;
      
      private var resourceManager:IResourceManager;
      
      public function HTTPService(param1:String = null, param2:String = null)
      {
         resourceManager = ResourceManager.getInstance();
         headers = {};
         request = {};
         super();
         asyncRequest = new AsyncRequest();
         makeObjectsBindable = true;
         if(param2 == null)
         {
            if(URLUtil.isHttpsURL(LoaderConfig.url))
            {
               mx_internal::asyncRequest.destination = DEFAULT_DESTINATION_HTTPS;
            }
            else
            {
               mx_internal::asyncRequest.destination = DEFAULT_DESTINATION_HTTP;
            }
         }
         else
         {
            mx_internal::asyncRequest.destination = param2;
            useProxy = true;
         }
         _log = Log.getLogger("mx.rpc.http.HTTPService");
      }
      
      private function getDirectChannelSet() : ChannelSet
      {
         var _loc1_:ChannelSet = null;
         if(_directChannelSet == null)
         {
            _loc1_ = new ChannelSet();
            _loc1_.addChannel(new DirectHTTPChannel("direct_http_channel"));
            _directChannelSet = _loc1_;
         }
         return _directChannelSet;
      }
      
      public function send(param1:Object = null) : AsyncToken
      {
         var _loc2_:Object = null;
         var _loc3_:AsyncToken = null;
         var _loc4_:Fault = null;
         var _loc5_:FaultEvent = null;
         var _loc6_:String = null;
         var _loc8_:Object = null;
         var _loc9_:SimpleXMLEncoder = null;
         var _loc10_:XMLDocument = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:* = undefined;
         var _loc16_:ChannelSet = null;
         if(param1 == null)
         {
            param1 = request;
         }
         if(contentType == CONTENT_TYPE_XML)
         {
            if(!(param1 is XMLNode) && !(param1 is XML))
            {
               if(xmlEncode != null)
               {
                  _loc8_ = xmlEncode(param1);
                  if(null == _loc8_)
                  {
                     _loc3_ = new AsyncToken(null);
                     _loc6_ = resourceManager.getString("rpc","xmlEncodeReturnNull");
                     _loc4_ = new Fault(ERROR_ENCODING,_loc6_);
                     _loc5_ = FaultEvent.createEvent(_loc4_,_loc3_);
                     new AsyncDispatcher(mx_internal::dispatchRpcEvent,[_loc5_],10);
                     return _loc3_;
                  }
                  if(!(_loc8_ is XMLNode))
                  {
                     _loc3_ = new AsyncToken(null);
                     _loc6_ = resourceManager.getString("rpc","xmlEncodeReturnNoXMLNode");
                     _loc4_ = new Fault(ERROR_ENCODING,_loc6_);
                     _loc5_ = FaultEvent.createEvent(_loc4_,_loc3_);
                     new AsyncDispatcher(mx_internal::dispatchRpcEvent,[_loc5_],10);
                     return _loc3_;
                  }
                  _loc2_ = XMLNode(_loc8_).toString();
               }
               else
               {
                  _loc9_ = new SimpleXMLEncoder(null);
                  _loc10_ = new XMLDocument();
                  _loc11_ = _loc9_.encodeValue(param1,new QName(null,"encoded"),new XMLNode(1,"top")).childNodes.concat();
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_.length)
                  {
                     _loc10_.appendChild(_loc11_[_loc12_]);
                     _loc12_++;
                  }
                  _loc2_ = _loc10_.toString();
               }
            }
            else
            {
               _loc2_ = XML(param1).toXMLString();
            }
         }
         else if(contentType == CONTENT_TYPE_FORM)
         {
            _loc2_ = {};
            _loc14_ = ObjectUtil.getClassInfo(param1);
            for each(_loc15_ in _loc14_.properties)
            {
               if((_loc13_ = param1[_loc15_]) != null)
               {
                  if(_loc13_ is Array)
                  {
                     _loc2_[_loc15_] = _loc13_;
                  }
                  else
                  {
                     _loc2_[_loc15_] = _loc13_.toString();
                  }
               }
            }
         }
         else
         {
            _loc2_ = param1;
         }
         var _loc7_:HTTPRequestMessage = new HTTPRequestMessage();
         if(useProxy)
         {
            if(url && url != "")
            {
               _loc7_.url = URLUtil.getFullURL(rootURL,url);
            }
         }
         else
         {
            if(!url)
            {
               _loc3_ = new AsyncToken(null);
               _loc6_ = resourceManager.getString("rpc","urlNotSpecified");
               _loc4_ = new Fault(ERROR_URL_REQUIRED,_loc6_);
               _loc5_ = FaultEvent.createEvent(_loc4_,_loc3_);
               new AsyncDispatcher(mx_internal::dispatchRpcEvent,[_loc5_],10);
               return _loc3_;
            }
            if(!useProxy)
            {
               if((_loc16_ = getDirectChannelSet()) != mx_internal::asyncRequest.channelSet)
               {
                  mx_internal::asyncRequest.channelSet = _loc16_;
               }
            }
            _loc7_.url = url;
         }
         _loc7_.contentType = contentType;
         _loc7_.method = method.toUpperCase();
         if(contentType == CONTENT_TYPE_XML && _loc7_.method == HTTPRequestMessage.GET_METHOD)
         {
            _loc7_.method = HTTPRequestMessage.POST_METHOD;
         }
         _loc7_.body = _loc2_;
         _loc7_.httpHeaders = headers;
         return invoke(_loc7_);
      }
      
      private function decodeArray(param1:Object) : Object
      {
         var _loc2_:Array = null;
         if(param1 is Array)
         {
            _loc2_ = param1 as Array;
         }
         else
         {
            if(param1 is ArrayCollection)
            {
               return param1;
            }
            _loc2_ = [];
            _loc2_.push(param1);
         }
         if(makeObjectsBindable)
         {
            return new ArrayCollection(_loc2_);
         }
         return _loc2_;
      }
      
      public function set channelSet(param1:ChannelSet) : void
      {
         useProxy = true;
         mx_internal::asyncRequest.channelSet = param1;
      }
      
      public function get destination() : String
      {
         return mx_internal::asyncRequest.destination;
      }
      
      public function get requestTimeout() : int
      {
         return mx_internal::asyncRequest.requestTimeout;
      }
      
      public function logout() : void
      {
         mx_internal::asyncRequest.logout();
      }
      
      public function set useProxy(param1:Boolean) : void
      {
         var _loc2_:ChannelSet = null;
         if(param1 != _useProxy)
         {
            _useProxy = param1;
            _loc2_ = getDirectChannelSet();
            if(!useProxy)
            {
               if(_loc2_ != mx_internal::asyncRequest.channelSet)
               {
                  mx_internal::asyncRequest.channelSet = _loc2_;
               }
            }
            else if(mx_internal::asyncRequest.channelSet == _loc2_)
            {
               mx_internal::asyncRequest.channelSet = null;
            }
         }
      }
      
      public function get channelSet() : ChannelSet
      {
         return mx_internal::asyncRequest.channelSet;
      }
      
      public function set destination(param1:String) : void
      {
         useProxy = true;
         mx_internal::asyncRequest.destination = param1;
      }
      
      public function set requestTimeout(param1:int) : void
      {
         if(mx_internal::asyncRequest.requestTimeout != param1)
         {
            mx_internal::asyncRequest.requestTimeout = param1;
         }
      }
      
      public function set url(param1:String) : void
      {
         _url = param1;
      }
      
      public function get useProxy() : Boolean
      {
         return _useProxy;
      }
      
      public function set resultFormat(param1:String) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case RESULT_FORMAT_OBJECT:
            case RESULT_FORMAT_ARRAY:
            case RESULT_FORMAT_XML:
            case RESULT_FORMAT_E4X:
            case RESULT_FORMAT_TEXT:
            case RESULT_FORMAT_FLASHVARS:
               _resultFormat = param1;
               return;
            default:
               _loc2_ = resourceManager.getString("rpc","invalidResultFormat",[param1,RESULT_FORMAT_OBJECT,RESULT_FORMAT_ARRAY,RESULT_FORMAT_XML,RESULT_FORMAT_E4X,RESULT_FORMAT_TEXT,RESULT_FORMAT_FLASHVARS]);
               throw new ArgumentError(_loc2_);
         }
      }
      
      public function set rootURL(param1:String) : void
      {
         _rootURL = param1;
      }
      
      public function disconnect() : void
      {
         mx_internal::asyncRequest.disconnect();
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      public function get resultFormat() : String
      {
         return _resultFormat;
      }
      
      public function setRemoteCredentials(param1:String, param2:String, param3:String = null) : void
      {
         mx_internal::asyncRequest.setRemoteCredentials(param1,param2,param3);
      }
      
      private function decodeParameterString(param1:String) : Object
      {
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:String = StringUtil.trim(param1);
         var _loc3_:Array = _loc2_.split("&");
         var _loc4_:Object = {};
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc7_ = (_loc6_ = _loc3_[_loc5_]).indexOf("=")) != -1)
            {
               _loc8_ = (_loc8_ = unescape(_loc6_.substr(0,_loc7_))).split("+").join(" ");
               _loc9_ = (_loc9_ = unescape(_loc6_.substr(_loc7_ + 1))).split("+").join(" ");
               _loc4_[_loc8_] = _loc9_;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function setCredentials(param1:String, param2:String, param3:String = null) : void
      {
         mx_internal::asyncRequest.setCredentials(param1,param2,param3);
      }
      
      override mx_internal function processResult(param1:IMessage, param2:AsyncToken) : Boolean
      {
         var tmp:Object = null;
         var fault:Fault = null;
         var decoded:Object = null;
         var msg:String = null;
         var fault1:Fault = null;
         var decoder:SimpleXMLDecoder = null;
         var fault2:Fault = null;
         var fault3:Fault = null;
         var message:IMessage = param1;
         var token:AsyncToken = param2;
         var body:Object = message.body;
         _log.info("Decoding HTTPService response");
         _log.debug("Processing HTTPService response message:\n{0}",message);
         if(body == null || body != null && body is String && StringUtil.trim(String(body)) == "")
         {
            _result = body;
            return true;
         }
         if(body is String)
         {
            if(resultFormat == RESULT_FORMAT_XML || resultFormat == RESULT_FORMAT_OBJECT || resultFormat == RESULT_FORMAT_ARRAY)
            {
               tmp = new XMLDocument();
               XMLDocument(tmp).ignoreWhite = true;
               try
               {
                  XMLDocument(tmp).parseXML(String(body));
               }
               catch(parseError:Error)
               {
                  fault = new Fault(ERROR_DECODING,parseError.message);
                  dispatchRpcEvent(FaultEvent.createEvent(fault,token,message));
                  return false;
               }
               if(resultFormat == RESULT_FORMAT_OBJECT || resultFormat == RESULT_FORMAT_ARRAY)
               {
                  if(xmlDecode != null)
                  {
                     decoded = xmlDecode(tmp);
                     if(decoded == null)
                     {
                        msg = resourceManager.getString("rpc","xmlDecodeReturnNull");
                        fault1 = new Fault(ERROR_DECODING,msg);
                        dispatchRpcEvent(FaultEvent.createEvent(fault1,token,message));
                     }
                  }
                  else
                  {
                     decoder = new SimpleXMLDecoder(makeObjectsBindable);
                     decoded = decoder.decodeXML(XMLNode(tmp));
                     if(decoded == null)
                     {
                        msg = resourceManager.getString("rpc","defaultDecoderFailed");
                        fault2 = new Fault(ERROR_DECODING,msg);
                        dispatchRpcEvent(FaultEvent.createEvent(fault2,token,message));
                     }
                  }
                  if(decoded == null)
                  {
                     return false;
                  }
                  if(makeObjectsBindable && getQualifiedClassName(decoded) == "Object")
                  {
                     decoded = new ObjectProxy(decoded);
                  }
                  else
                  {
                     ;
                  }
                  if(resultFormat == RESULT_FORMAT_ARRAY)
                  {
                     decoded = decodeArray(decoded);
                  }
                  _result = decoded;
               }
               else
               {
                  if(tmp.childNodes.length == 1)
                  {
                     tmp = tmp.firstChild;
                  }
                  _result = tmp;
               }
            }
            else if(resultFormat == RESULT_FORMAT_E4X)
            {
               try
               {
                  _result = new XML(String(body));
               }
               catch(error:Error)
               {
                  fault3 = new Fault(ERROR_DECODING,error.message);
                  dispatchRpcEvent(FaultEvent.createEvent(fault3,token,message));
                  return false;
               }
            }
            else if(resultFormat == RESULT_FORMAT_FLASHVARS)
            {
               _result = decodeParameterString(String(body));
            }
            else
            {
               _result = body;
            }
         }
         else
         {
            if(resultFormat == RESULT_FORMAT_ARRAY)
            {
               body = decodeArray(body);
            }
            _result = body;
         }
         return true;
      }
      
      public function get rootURL() : String
      {
         if(mx_internal::_rootURL == null)
         {
            _rootURL = LoaderConfig.url;
         }
         return mx_internal::_rootURL;
      }
   }
}
