package com.adobe.serialization.json
{
   public class JSON
   {
       
      
      public function JSON()
      {
         super();
      }
      
      public static function decode(param1:String) : *
      {
         var _loc2_:JSONDecoder = new JSONDecoder(param1);
         return _loc2_.getValue();
      }
      
      public static function encode(param1:Object) : String
      {
         var _loc2_:JSONEncoder = new JSONEncoder(param1);
         return _loc2_.getString();
      }
   }
}
