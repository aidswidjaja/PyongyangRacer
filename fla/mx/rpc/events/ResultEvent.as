package mx.rpc.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   import mx.messaging.messages.IMessage;
   import mx.rpc.AsyncToken;
   
   public class ResultEvent extends AbstractEvent
   {
      
      public static const RESULT:String = "result";
       
      
      private var _headers:Object;
      
      private var _result:Object;
      
      public function ResultEvent(param1:String, param2:Boolean = false, param3:Boolean = true, param4:Object = null, param5:AsyncToken = null, param6:IMessage = null)
      {
         super(param1,param2,param3,param5,param6);
         _result = param4;
      }
      
      public static function createEvent(param1:Object = null, param2:AsyncToken = null, param3:IMessage = null) : ResultEvent
      {
         return new ResultEvent(ResultEvent.RESULT,false,true,param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new ResultEvent(type,bubbles,cancelable,result,token,message);
      }
      
      public function get headers() : Object
      {
         return _headers;
      }
      
      public function set headers(param1:Object) : void
      {
         _headers = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("ResultEvent","messageId","type","bubbles","cancelable","eventPhase");
      }
      
      public function get result() : Object
      {
         return _result;
      }
      
      override mx_internal function callTokenResponders() : void
      {
         if(token != null)
         {
            token.applyResult(this);
         }
      }
   }
}
