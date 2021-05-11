package mx.rpc.xml
{
   dynamic class ComplexString
   {
       
      
      public var value:String;
      
      function ComplexString(param1:String)
      {
         super();
         value = param1;
      }
      
      public function valueOf() : Object
      {
         return SimpleXMLDecoder.simpleType(value);
      }
      
      public function toString() : String
      {
         return value;
      }
   }
}
