package mx.rpc
{
   public class ActiveCalls
   {
       
      
      private var callOrder:Array;
      
      private var calls:Object;
      
      public function ActiveCalls()
      {
         super();
         calls = {};
         callOrder = [];
      }
      
      public function removeCall(param1:String) : AsyncToken
      {
         var _loc2_:AsyncToken = calls[param1];
         if(_loc2_ != null)
         {
            delete calls[param1];
            callOrder.splice(callOrder.lastIndexOf(param1),1);
         }
         return _loc2_;
      }
      
      public function cancelLast() : AsyncToken
      {
         if(callOrder.length > 0)
         {
            return removeCall(callOrder[callOrder.length - 1] as String);
         }
         return null;
      }
      
      public function hasActiveCalls() : Boolean
      {
         return callOrder.length > 0;
      }
      
      public function wasLastCall(param1:String) : Boolean
      {
         if(callOrder.length > 0)
         {
            return callOrder[callOrder.length - 1] == param1;
         }
         return false;
      }
      
      public function getAllMessages() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = [];
         for(_loc2_ in calls)
         {
            _loc1_.push(calls[_loc2_]);
         }
         return _loc1_;
      }
      
      public function addCall(param1:String, param2:AsyncToken) : void
      {
         calls[param1] = param2;
         callOrder.push(param1);
      }
   }
}
