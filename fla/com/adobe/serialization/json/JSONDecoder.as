package com.adobe.serialization.json
{
   public class JSONDecoder
   {
       
      
      private var value;
      
      private var tokenizer:JSONTokenizer;
      
      private var token:JSONToken;
      
      public function JSONDecoder(param1:String)
      {
         super();
         tokenizer = new JSONTokenizer(param1);
         nextToken();
         value = parseValue();
      }
      
      private function parseObject() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = new Object();
         nextToken();
         if(token.type == JSONTokenType.RIGHT_BRACE)
         {
            return _loc1_;
         }
         while(true)
         {
            if(token.type == JSONTokenType.STRING)
            {
               _loc2_ = String(token.value);
               nextToken();
               if(token.type == JSONTokenType.COLON)
               {
                  nextToken();
                  _loc1_[_loc2_] = parseValue();
                  nextToken();
                  if(token.type == JSONTokenType.RIGHT_BRACE)
                  {
                     break;
                  }
                  if(token.type == JSONTokenType.COMMA)
                  {
                     nextToken();
                  }
                  else
                  {
                     tokenizer.parseError("Expecting } or , but found " + token.value);
                  }
               }
               else
               {
                  tokenizer.parseError("Expecting : but found " + token.value);
               }
            }
            else
            {
               tokenizer.parseError("Expecting string but found " + token.value);
            }
         }
         return _loc1_;
      }
      
      private function parseValue() : Object
      {
         if(token == null)
         {
            tokenizer.parseError("Unexpected end of input");
         }
         switch(token.type)
         {
            case JSONTokenType.LEFT_BRACE:
               return parseObject();
            case JSONTokenType.LEFT_BRACKET:
               return parseArray();
            case JSONTokenType.STRING:
            case JSONTokenType.NUMBER:
            case JSONTokenType.TRUE:
            case JSONTokenType.FALSE:
            case JSONTokenType.NULL:
               return token.value;
            default:
               tokenizer.parseError("Unexpected " + token.value);
               return null;
         }
      }
      
      private function nextToken() : JSONToken
      {
         return token = tokenizer.getNextToken();
      }
      
      public function getValue() : *
      {
         return value;
      }
      
      private function parseArray() : Array
      {
         var _loc1_:Array = new Array();
         nextToken();
         if(token.type == JSONTokenType.RIGHT_BRACKET)
         {
            return _loc1_;
         }
         while(true)
         {
            _loc1_.push(parseValue());
            nextToken();
            if(token.type == JSONTokenType.RIGHT_BRACKET)
            {
               break;
            }
            if(token.type == JSONTokenType.COMMA)
            {
               nextToken();
            }
            else
            {
               tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
         }
         return _loc1_;
      }
   }
}
