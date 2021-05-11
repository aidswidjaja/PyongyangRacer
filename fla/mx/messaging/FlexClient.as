package mx.messaging
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class FlexClient extends EventDispatcher
   {
      
      private static var _instance:FlexClient;
      
      mx_internal static const NULL_FLEXCLIENT_ID:String = "nil";
       
      
      private var _waitForFlexClientId:Boolean = false;
      
      private var _id:String;
      
      public function FlexClient()
      {
         super();
      }
      
      public static function getInstance() : FlexClient
      {
         if(_instance == null)
         {
            _instance = new FlexClient();
         }
         return _instance;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      mx_internal function get waitForFlexClientId() : Boolean
      {
         return _waitForFlexClientId;
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_id != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"id",_id,param1);
            _id = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      mx_internal function set waitForFlexClientId(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_waitForFlexClientId != param1)
         {
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"waitForFlexClientId",_waitForFlexClientId,param1);
            _waitForFlexClientId = param1;
            dispatchEvent(_loc2_);
         }
      }
   }
}
