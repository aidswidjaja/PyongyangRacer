package com.adobe.serialization.json
{
   public class JSONTokenizer
   {
       
      
      private var loc:int;
      
      private var ch:String;
      
      private var obj:Object;
      
      private var jsonString:String;
      
      public function JSONTokenizer(param1:String)
      {
         super();
         jsonString = param1;
         loc = 0;
         nextChar();
      }
      
      private function skipComments() : void
      {
         if(ch == "/")
         {
            nextChar();
            switch(ch)
            {
               case "/":
                  do
                  {
                     nextChar();
                  }
                  while(ch != "\n" && ch != "");
                  
                  nextChar();
                  break;
               case "*":
                  nextChar();
                  while(true)
                  {
                     if(ch == "*")
                     {
                        nextChar();
                        if(ch == "/")
                        {
                           break;
                        }
                     }
                     else
                     {
                        nextChar();
                     }
                     if(ch == "")
                     {
                        parseError("Multi-line comment not closed");
                     }
                  }
                  nextChar();
                  break;
               default:
                  parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
            }
         }
      }
      
      private function isDigit(param1:String) : Boolean
      {
         return param1 >= "0" && param1 <= "9";
      }
      
      private function readString() : JSONToken
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc1_:JSONToken = new JSONToken();
         _loc1_.type = JSONTokenType.STRING;
         var _loc2_:* = "";
         nextChar();
         while(ch != "\"" && ch != "")
         {
            if(ch == "\\")
            {
               nextChar();
               switch(ch)
               {
                  case "\"":
                     _loc2_ += "\"";
                     break;
                  case "/":
                     _loc2_ += "/";
                     break;
                  case "\\":
                     _loc2_ += "\\";
                     break;
                  case "b":
                     _loc2_ += "\b";
                     break;
                  case "f":
                     _loc2_ += "\f";
                     break;
                  case "n":
                     _loc2_ += "\n";
                     break;
                  case "r":
                     _loc2_ += "\r";
                     break;
                  case "t":
                     _loc2_ += "\t";
                     break;
                  case "u":
                     _loc3_ = "";
                     _loc4_ = 0;
                     while(_loc4_ < 4)
                     {
                        if(!isHexDigit(nextChar()))
                        {
                           parseError(" Excepted a hex digit, but found: " + ch);
                        }
                        _loc3_ += ch;
                        _loc4_++;
                     }
                     _loc2_ += String.fromCharCode(parseInt(_loc3_,16));
                     break;
                  default:
                     _loc2_ += "\\" + ch;
               }
            }
            else
            {
               _loc2_ += ch;
            }
            nextChar();
         }
         if(ch == "")
         {
            parseError("Unterminated string literal");
         }
         nextChar();
         _loc1_.value = _loc2_;
         return _loc1_;
      }
      
      private function nextChar() : String
      {
         return ch = jsonString.charAt(loc++);
      }
      
      public function getNextToken() : JSONToken
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:JSONToken = new JSONToken();
         skipIgnored();
         switch(ch)
         {
            case "{":
               _loc1_.type = JSONTokenType.LEFT_BRACE;
               _loc1_.value = "{";
               nextChar();
               break;
            case "}":
               _loc1_.type = JSONTokenType.RIGHT_BRACE;
               _loc1_.value = "}";
               nextChar();
               break;
            case "[":
               _loc1_.type = JSONTokenType.LEFT_BRACKET;
               _loc1_.value = "[";
               nextChar();
               break;
            case "]":
               _loc1_.type = JSONTokenType.RIGHT_BRACKET;
               _loc1_.value = "]";
               nextChar();
               break;
            case ",":
               _loc1_.type = JSONTokenType.COMMA;
               _loc1_.value = ",";
               nextChar();
               break;
            case ":":
               _loc1_.type = JSONTokenType.COLON;
               _loc1_.value = ":";
               nextChar();
               break;
            case "t":
               _loc2_ = "t" + nextChar() + nextChar() + nextChar();
               if(_loc2_ == "true")
               {
                  _loc1_.type = JSONTokenType.TRUE;
                  _loc1_.value = true;
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'true\' but found " + _loc2_);
               }
               break;
            case "f":
               _loc3_ = "f" + nextChar() + nextChar() + nextChar() + nextChar();
               if(_loc3_ == "false")
               {
                  _loc1_.type = JSONTokenType.FALSE;
                  _loc1_.value = false;
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'false\' but found " + _loc3_);
               }
               break;
            case "n":
               if((_loc4_ = "n" + nextChar() + nextChar() + nextChar()) == "null")
               {
                  _loc1_.type = JSONTokenType.NULL;
                  _loc1_.value = null;
                  nextChar();
               }
               else
               {
                  parseError("Expecting \'null\' but found " + _loc4_);
               }
               break;
            case "\"":
               _loc1_ = readString();
               break;
            default:
               if(isDigit(ch) || ch == "-")
               {
                  _loc1_ = readNumber();
               }
               else
               {
                  if(ch == "")
                  {
                     return null;
                  }
                  parseError("Unexpected " + ch + " encountered");
               }
         }
         return _loc1_;
      }
      
      private function skipWhite() : void
      {
         while(isWhiteSpace(ch))
         {
            nextChar();
         }
      }
      
      public function parseError(param1:String) : void
      {
         throw new JSONParseError(param1,loc,jsonString);
      }
      
      private function isWhiteSpace(param1:String) : Boolean
      {
         return param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r";
      }
      
      private function skipIgnored() : void
      {
         var _loc1_:int = 0;
         do
         {
            _loc1_ = loc;
            skipWhite();
            skipComments();
         }
         while(_loc1_ != loc);
         
      }
      
      private function isHexDigit(param1:String) : Boolean
      {
         var _loc2_:String = param1.toUpperCase();
         return isDigit(param1) || _loc2_ >= "A" && _loc2_ <= "F";
      }
      
      private function readNumber() : JSONToken
      {
         var _loc1_:JSONToken = new JSONToken();
         _loc1_.type = JSONTokenType.NUMBER;
         var _loc2_:* = "";
         if(ch == "-")
         {
            _loc2_ += "-";
            nextChar();
         }
         if(!isDigit(ch))
         {
            parseError("Expecting a digit");
         }
         if(ch == "0")
         {
            _loc2_ += ch;
            nextChar();
            if(isDigit(ch))
            {
               parseError("A digit cannot immediately follow 0");
            }
         }
         else
         {
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         if(ch == ".")
         {
            _loc2_ += ".";
            nextChar();
            if(!isDigit(ch))
            {
               parseError("Expecting a digit");
            }
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         if(ch == "e" || ch == "E")
         {
            _loc2_ += "e";
            nextChar();
            if(ch == "+" || ch == "-")
            {
               _loc2_ += ch;
               nextChar();
            }
            if(!isDigit(ch))
            {
               parseError("Scientific notation number needs exponent value");
            }
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         var _loc3_:Number = Number(_loc2_);
         if(isFinite(_loc3_) && !isNaN(_loc3_))
         {
            _loc1_.value = _loc3_;
            return _loc1_;
         }
         parseError("Number " + _loc3_ + " is not valid!");
         return null;
      }
   }
}
