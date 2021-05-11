package mx.collections
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.collections.errors.SortError;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class SortField extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
       
      
      private var resourceManager:IResourceManager;
      
      private var _caseInsensitive:Boolean;
      
      private var _compareFunction:Function;
      
      private var _usingCustomCompareFunction:Boolean;
      
      private var _descending:Boolean;
      
      private var _name:String;
      
      private var _numeric:Object;
      
      public function SortField(param1:String = null, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         this.resourceManager = ResourceManager.getInstance();
         super();
         this._name = param1;
         this._caseInsensitive = param2;
         this._descending = param3;
         this._numeric = param4;
         this._compareFunction = this.stringCompare;
      }
      
      public function get caseInsensitive() : Boolean
      {
         return this._caseInsensitive;
      }
      
      public function set caseInsensitive(param1:Boolean) : void
      {
         if(param1 != this._caseInsensitive)
         {
            this._caseInsensitive = param1;
            dispatchEvent(new Event("caseInsensitiveChanged"));
         }
      }
      
      public function get compareFunction() : Function
      {
         return this._compareFunction;
      }
      
      public function set compareFunction(param1:Function) : void
      {
         this._compareFunction = param1;
         this._usingCustomCompareFunction = param1 != null;
      }
      
      mx_internal function get usingCustomCompareFunction() : Boolean
      {
         return this._usingCustomCompareFunction;
      }
      
      mx_internal function internalCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:int = this.compareFunction(param1,param2);
         if(this.descending)
         {
            _loc3_ *= -1;
         }
         return _loc3_;
      }
      
      public function get descending() : Boolean
      {
         return this._descending;
      }
      
      public function set descending(param1:Boolean) : void
      {
         if(this._descending != param1)
         {
            this._descending = param1;
            dispatchEvent(new Event("descendingChanged"));
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
         dispatchEvent(new Event("nameChanged"));
      }
      
      public function get numeric() : Object
      {
         return this._numeric;
      }
      
      public function set numeric(param1:Object) : void
      {
         if(this._numeric != param1)
         {
            this._numeric = param1;
            dispatchEvent(new Event("numericChanged"));
         }
      }
      
      mx_internal function getArraySortOnOptions() : int
      {
         if(this.usingCustomCompareFunction || this.name == null || this._compareFunction == this.xmlCompare || this._compareFunction == this.dateCompare)
         {
            return -1;
         }
         var _loc1_:* = 0;
         if(this.caseInsensitive)
         {
            _loc1_ |= Array.CASEINSENSITIVE;
         }
         if(this.descending)
         {
            _loc1_ |= Array.DESCENDING;
         }
         if(this.numeric == true || this._compareFunction == this.numericCompare)
         {
            _loc1_ |= Array.NUMERIC;
         }
         return _loc1_;
      }
      
      mx_internal function initCompare(param1:Object) : void
      {
         var value:Object = null;
         var typ:String = null;
         var test:String = null;
         var obj:Object = param1;
         if(!this.usingCustomCompareFunction)
         {
            if(this.numeric == true)
            {
               this._compareFunction = this.numericCompare;
            }
            else if(this.caseInsensitive || this.numeric == false)
            {
               this._compareFunction = this.stringCompare;
            }
            else
            {
               if(this._name)
               {
                  try
                  {
                     value = obj[this._name];
                  }
                  catch(error:Error)
                  {
                  }
               }
               if(value == null)
               {
                  value = obj;
               }
               typ = typeof value;
               switch(typ)
               {
                  case "string":
                     this._compareFunction = this.stringCompare;
                     break;
                  case "object":
                     if(value is Date)
                     {
                        this._compareFunction = this.dateCompare;
                     }
                     else
                     {
                        this._compareFunction = this.stringCompare;
                        try
                        {
                           test = value.toString();
                        }
                        catch(error2:Error)
                        {
                        }
                        if(!test || test == "[object Object]")
                        {
                           this._compareFunction = this.nullCompare;
                        }
                     }
                     break;
                  case "xml":
                     this._compareFunction = this.xmlCompare;
                     break;
                  case "boolean":
                  case "number":
                     this._compareFunction = this.numericCompare;
               }
            }
         }
      }
      
      public function reverse() : void
      {
         this.descending = !this.descending;
      }
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      private function nullCompare(param1:Object, param2:Object) : int
      {
         var value:Object = null;
         var left:Object = null;
         var right:Object = null;
         var message:String = null;
         var a:Object = param1;
         var b:Object = param2;
         var found:Boolean = false;
         if(a == null && b == null)
         {
            return 0;
         }
         if(this._name)
         {
            try
            {
               left = a[this._name];
            }
            catch(error:Error)
            {
            }
            try
            {
               right = b[this._name];
            }
            catch(error:Error)
            {
            }
         }
         if(left == null && right == null)
         {
            return 0;
         }
         if(left == null && !this._name)
         {
            left = a;
         }
         if(right == null && !this._name)
         {
            right = b;
         }
         var typeLeft:String = typeof left;
         var typeRight:String = typeof right;
         if(typeLeft == "string" || typeRight == "string")
         {
            found = true;
            this._compareFunction = this.stringCompare;
         }
         else if(typeLeft == "object" || typeRight == "object")
         {
            if(left is Date || right is Date)
            {
               found = true;
               this._compareFunction = this.dateCompare;
            }
         }
         else if(typeLeft == "xml" || typeRight == "xml")
         {
            found = true;
            this._compareFunction = this.xmlCompare;
         }
         else if(typeLeft == "number" || typeRight == "number" || typeLeft == "boolean" || typeRight == "boolean")
         {
            found = true;
            this._compareFunction = this.numericCompare;
         }
         if(found)
         {
            return this._compareFunction(left,right);
         }
         message = this.resourceManager.getString("collections","noComparatorSortField",[this.name]);
         throw new SortError(message);
      }
      
      private function numericCompare(param1:Object, param2:Object) : int
      {
         var fa:Number = NaN;
         var fb:Number = NaN;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = this._name == null ? Number(Number(a)) : Number(Number(a[this._name]));
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? Number(Number(b)) : Number(Number(b[this._name]));
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.numericCompare(fa,fb);
      }
      
      private function dateCompare(param1:Object, param2:Object) : int
      {
         var fa:Date = null;
         var fb:Date = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = this._name == null ? a as Date : a[this._name] as Date;
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? b as Date : b[this._name] as Date;
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.dateCompare(fa,fb);
      }
      
      private function stringCompare(param1:Object, param2:Object) : int
      {
         var fa:String = null;
         var fb:String = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            fa = this._name == null ? String(a) : String(a[this._name]);
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? String(b) : String(b[this._name]);
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.stringCompare(fa,fb,this._caseInsensitive);
      }
      
      private function xmlCompare(param1:Object, param2:Object) : int
      {
         var sa:String = null;
         var sb:String = null;
         var a:Object = param1;
         var b:Object = param2;
         try
         {
            sa = this._name == null ? a.toString() : a[this._name].toString();
         }
         catch(error:Error)
         {
         }
         try
         {
            sb = this._name == null ? b.toString() : b[this._name].toString();
         }
         catch(error:Error)
         {
         }
         if(this.numeric == true)
         {
            return ObjectUtil.numericCompare(parseFloat(sa),parseFloat(sb));
         }
         return ObjectUtil.stringCompare(sa,sb,this._caseInsensitive);
      }
   }
}
