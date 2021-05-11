package it.gotoandplay.smartfoxserver.util
{
   public class ObjectSerializer
   {
      
      private static var instance:ObjectSerializer;
       
      
      private var debug:Boolean;
      
      private var eof:String;
      
      private var tabs:String;
      
      public function ObjectSerializer(param1:Boolean = false)
      {
         super();
         this.tabs = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
         this.setDebug(param1);
      }
      
      public static function getInstance(param1:Boolean = false) : ObjectSerializer
      {
         if(instance == null)
         {
            instance = new ObjectSerializer(param1);
         }
         return instance;
      }
      
      private function setDebug(param1:Boolean) : void
      {
         this.debug = param1;
         if(this.debug)
         {
            this.eof = "\n";
         }
         else
         {
            this.eof = "";
         }
      }
      
      public function serialize(param1:Object) : String
      {
         var _loc2_:Object = {};
         this.obj2xml(param1,_loc2_);
         return _loc2_.xmlStr;
      }
      
      public function deserialize(param1:String) : Object
      {
         var _loc2_:XML = new XML(param1);
         var _loc3_:Object = {};
         this.xml2obj(_loc2_,_loc3_);
         return _loc3_;
      }
      
      private function obj2xml(param1:Object, param2:Object, param3:int = 0, param4:String = "") : void
      {
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc7_:* = null;
         var _loc8_:* = undefined;
         if(param3 == 0)
         {
            param2.xmlStr = "<dataObj>" + this.eof;
         }
         else
         {
            if(this.debug)
            {
               param2.xmlStr += this.tabs.substr(0,param3);
            }
            _loc6_ = param1 is Array ? "a" : "o";
            param2.xmlStr += "<obj t=\'" + _loc6_ + "\' o=\'" + param4 + "\'>" + this.eof;
         }
         for(_loc5_ in param1)
         {
            _loc7_ = typeof param1[_loc5_];
            _loc8_ = param1[_loc5_];
            if(_loc7_ == "boolean" || _loc7_ == "number" || _loc7_ == "string" || _loc7_ == "null")
            {
               if(_loc7_ == "boolean")
               {
                  _loc8_ = Number(_loc8_);
               }
               else if(_loc7_ == "null")
               {
                  _loc7_ = "x";
                  _loc8_ = "";
               }
               else if(_loc7_ == "string")
               {
                  _loc8_ = Entities.encodeEntities(_loc8_);
               }
               if(this.debug)
               {
                  param2.xmlStr += this.tabs.substr(0,param3 + 1);
               }
               param2.xmlStr += "<var n=\'" + _loc5_ + "\' t=\'" + _loc7_.substr(0,1) + "\'>" + _loc8_ + "</var>" + this.eof;
            }
            else if(_loc7_ == "object")
            {
               this.obj2xml(_loc8_,param2,param3 + 1,_loc5_);
               if(this.debug)
               {
                  param2.xmlStr += this.tabs.substr(0,param3 + 1);
               }
               param2.xmlStr += "</obj>" + this.eof;
            }
         }
         if(param3 == 0)
         {
            param2.xmlStr += "</dataObj>" + this.eof;
         }
      }
      
      private function xml2obj(param1:XML, param2:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc3_:int = 0;
         var _loc4_:XMLList = param1.children();
         for each(_loc6_ in _loc4_)
         {
            if((_loc5_ = _loc6_.name().toString()) == "obj")
            {
               _loc7_ = _loc6_.@o;
               if((_loc8_ = _loc6_.@t) == "a")
               {
                  param2[_loc7_] = [];
               }
               else if(_loc8_ == "o")
               {
                  param2[_loc7_] = {};
               }
               this.xml2obj(_loc6_,param2[_loc7_]);
            }
            else if(_loc5_ == "var")
            {
               _loc9_ = _loc6_.@n;
               _loc10_ = _loc6_.@t;
               _loc11_ = _loc6_.toString();
               if(_loc10_ == "b")
               {
                  param2[_loc9_] = _loc11_ == "0" ? false : true;
               }
               else if(_loc10_ == "n")
               {
                  param2[_loc9_] = Number(_loc11_);
               }
               else if(_loc10_ == "s")
               {
                  param2[_loc9_] = _loc11_;
               }
               else if(_loc10_ == "x")
               {
                  param2[_loc9_] = null;
               }
            }
         }
      }
      
      private function encodeEntities(param1:String) : String
      {
         return param1;
      }
   }
}
