package com.adobe.serialization.json
{
   public class JSONToken
   {
       
      
      private var _value:Object;
      
      private var _type:int;
      
      public function JSONToken(param1:int = -1, param2:Object = null)
      {
         super();
         _type = param1;
         _value = param2;
      }
      
      public function get value() : Object
      {
         return _value;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function set type(param1:int) : void
      {
         _type = param1;
      }
      
      public function set value(param1:Object) : void
      {
         _value = param1;
      }
   }
}
