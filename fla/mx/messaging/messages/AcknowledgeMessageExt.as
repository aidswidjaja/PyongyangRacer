package mx.messaging.messages
{
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class AcknowledgeMessageExt extends AcknowledgeMessage implements IExternalizable
   {
       
      
      private var _message:AcknowledgeMessage;
      
      public function AcknowledgeMessageExt(param1:AcknowledgeMessage = null)
      {
         super();
         _message = param1;
      }
      
      override public function get messageId() : String
      {
         if(_message != null)
         {
            return _message.messageId;
         }
         return super.messageId;
      }
      
      override public function writeExternal(param1:IDataOutput) : void
      {
         if(_message != null)
         {
            _message.writeExternal(param1);
         }
         else
         {
            super.writeExternal(param1);
         }
      }
   }
}
