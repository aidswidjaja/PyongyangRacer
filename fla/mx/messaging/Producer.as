package mx.messaging
{
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   
   public class Producer extends AbstractProducer
   {
       
      
      private var _subtopic:String = "";
      
      public function Producer()
      {
         super();
         _log = Log.getLogger("mx.messaging.Producer");
         _agentType = "producer";
      }
      
      override protected function internalSend(param1:IMessage, param2:Boolean = true) : void
      {
         if(subtopic.length > 0)
         {
            param1.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopic;
         }
         super.internalSend(param1,param2);
      }
      
      public function set subtopic(param1:String) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(_subtopic != param1)
         {
            if(param1 == null)
            {
               param1 = "";
            }
            _loc2_ = PropertyChangeEvent.createUpdateEvent(this,"subtopic",_subtopic,param1);
            _subtopic = param1;
            dispatchEvent(_loc2_);
         }
      }
      
      public function get subtopic() : String
      {
         return _subtopic;
      }
   }
}
