package mx.rpc
{
   public class Responder implements IResponder
   {
       
      
      private var _faultHandler:Function;
      
      private var _resultHandler:Function;
      
      public function Responder(param1:Function, param2:Function)
      {
         super();
         _resultHandler = param1;
         _faultHandler = param2;
      }
      
      public function result(param1:Object) : void
      {
         _resultHandler(param1);
      }
      
      public function fault(param1:Object) : void
      {
         _faultHandler(param1);
      }
   }
}
