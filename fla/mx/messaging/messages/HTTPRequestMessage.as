package mx.messaging.messages
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class HTTPRequestMessage extends AbstractMessage
   {
      
      public static const POST_METHOD:String = "POST";
      
      public static const CONTENT_TYPE_SOAP_XML:String = "text/xml; charset=utf-8";
      
      public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
      
      public static const GET_METHOD:String = "GET";
      
      public static const HEAD_METHOD:String = "HEAD";
      
      public static const PUT_METHOD:String = "PUT";
      
      public static const TRACE_METHOD:String = "TRACE";
      
      public static const DELETE_METHOD:String = "DELETE";
      
      public static const CONTENT_TYPE_XML:String = "application/xml";
      
      public static const OPTIONS_METHOD:String = "OPTIONS";
      
      private static const VALID_METHODS:String = "POST,PUT,GET,HEAD,DELETE,OPTIONS,TRACE";
       
      
      private var _method:String;
      
      public var httpHeaders:Object;
      
      public var url:String;
      
      public var contentType:String;
      
      public var recordHeaders:Boolean;
      
      private var resourceManager:IResourceManager;
      
      public function HTTPRequestMessage()
      {
         resourceManager = ResourceManager.getInstance();
         super();
         _method = GET_METHOD;
      }
      
      public function get method() : String
      {
         return _method;
      }
      
      public function set method(param1:String) : void
      {
         var _loc2_:String = null;
         if(VALID_METHODS.indexOf(param1) == -1)
         {
            _loc2_ = resourceManager.getString("messaging","invalidRequestMethod");
            throw new ArgumentError(_loc2_);
         }
         _method = param1;
      }
   }
}
