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
   
   public class Sort extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.0.0.14159";
      
      public static const ANY_INDEX_MODE:String = "any";
      
      public static const FIRST_INDEX_MODE:String = "first";
      
      public static const LAST_INDEX_MODE:String = "last";
       
      
      private var resourceManager:IResourceManager;
      
      private var _compareFunction:Function;
      
      private var usingCustomCompareFunction:Boolean;
      
      private var _fields:Array;
      
      private var fieldList:Array;
      
      private var _unique:Boolean;
      
      private var defaultEmptyField:SortField;
      
      private var noFieldsDescending:Boolean = false;
      
      public function Sort()
      {
         this.resourceManager = ResourceManager.getInstance();
         this.fieldList = [];
         super();
      }
      
      public function get compareFunction() : Function
      {
         return !!this.usingCustomCompareFunction ? this._compareFunction : this.internalCompare;
      }
      
      public function set compareFunction(param1:Function) : void
      {
         this._compareFunction = param1;
         this.usingCustomCompareFunction = this._compareFunction != null;
      }
      
      public function get fields() : Array
      {
         return this._fields;
      }
      
      public function set fields(param1:Array) : void
      {
         var _loc2_:SortField = null;
         var _loc3_:int = 0;
         this._fields = param1;
         this.fieldList = [];
         if(this._fields)
         {
            _loc3_ = 0;
            while(_loc3_ < this._fields.length)
            {
               _loc2_ = SortField(this._fields[_loc3_]);
               this.fieldList.push(_loc2_.name);
               _loc3_++;
            }
         }
         dispatchEvent(new Event("fieldsChanged"));
      }
      
      public function get unique() : Boolean
      {
         return this._unique;
      }
      
      public function set unique(param1:Boolean) : void
      {
         this._unique = param1;
      }
      
      public function findItem(param1:Array, param2:Object, param3:String, param4:Boolean = false, param5:Function = null) : int
      {
         var compareForFind:Function = null;
         var fieldsForCompare:Array = null;
         var message:String = null;
         var index:int = 0;
         var fieldName:String = null;
         var hadPreviousFieldName:Boolean = false;
         var i:int = 0;
         var hasFieldName:Boolean = false;
         var objIndex:int = 0;
         var match:Boolean = false;
         var prevCompare:int = 0;
         var nextCompare:int = 0;
         var items:Array = param1;
         var values:Object = param2;
         var mode:String = param3;
         var returnInsertionIndex:Boolean = param4;
         var compareFunction:Function = param5;
         if(!items)
         {
            message = this.resourceManager.getString("collections","noItems");
            throw new SortError(message);
         }
         if(items.length == 0)
         {
            return !!returnInsertionIndex ? 1 : -1;
         }
         if(compareFunction == null)
         {
            compareForFind = this.compareFunction;
            if(values && this.fieldList.length > 0)
            {
               fieldsForCompare = [];
               hadPreviousFieldName = true;
               i = 0;
               while(true)
               {
                  if(i < this.fieldList.length)
                  {
                     fieldName = this.fieldList[i];
                     if(fieldName)
                     {
                        try
                        {
                           hasFieldName = values[fieldName] !== undefined;
                        }
                        catch(e:Error)
                        {
                           hasFieldName = false;
                        }
                        if(hasFieldName)
                        {
                           if(!hadPreviousFieldName)
                           {
                              break;
                           }
                           fieldsForCompare.push(fieldName);
                        }
                        else
                        {
                           hadPreviousFieldName = false;
                        }
                     }
                     else
                     {
                        fieldsForCompare.push(null);
                     }
                     continue;
                  }
                  if(fieldsForCompare.length == 0)
                  {
                     message = this.resourceManager.getString("collections","findRestriction");
                     throw new SortError(message);
                  }
                  try
                  {
                     this.initSortFields(items[0]);
                  }
                  catch(initSortError:SortError)
                  {
                  }
               }
               message = this.resourceManager.getString("collections","findCondition",[fieldName]);
               throw new SortError(message);
            }
         }
         else
         {
            compareForFind = compareFunction;
         }
         var found:Boolean = false;
         var objFound:Boolean = false;
         index = 0;
         var lowerBound:int = 0;
         var upperBound:int = items.length - 1;
         var obj:Object = null;
         var direction:int = 1;
         while(true)
         {
            if(!(!objFound && lowerBound <= upperBound))
            {
               if(!found && !returnInsertionIndex)
               {
                  return -1;
               }
               return direction > 0 ? int(index + 1) : int(index);
            }
            index = Math.round((lowerBound + upperBound) / 2);
            obj = items[index];
            direction = !!fieldsForCompare ? int(compareForFind(values,obj,fieldsForCompare)) : int(compareForFind(values,obj));
            switch(direction)
            {
               case -1:
                  upperBound = index - 1;
                  break;
               case 0:
                  objFound = true;
                  switch(mode)
                  {
                     case ANY_INDEX_MODE:
                        found = true;
                        break;
                     case FIRST_INDEX_MODE:
                        found = index == lowerBound;
                        objIndex = index - 1;
                        match = true;
                        while(match && !found && objIndex >= lowerBound)
                        {
                           obj = items[objIndex];
                           prevCompare = !!fieldsForCompare ? int(compareForFind(values,obj,fieldsForCompare)) : int(compareForFind(values,obj));
                           match = prevCompare == 0;
                           if(!match || match && objIndex == lowerBound)
                           {
                              found = true;
                              index = objIndex + (!!match ? 0 : 1);
                           }
                           objIndex--;
                        }
                        break;
                     case LAST_INDEX_MODE:
                        found = index == upperBound;
                        objIndex = index + 1;
                        match = true;
                        while(match && !found && objIndex <= upperBound)
                        {
                           obj = items[objIndex];
                           nextCompare = !!fieldsForCompare ? int(compareForFind(values,obj,fieldsForCompare)) : int(compareForFind(values,obj));
                           match = nextCompare == 0;
                           if(!match || match && objIndex == upperBound)
                           {
                              found = true;
                              index = objIndex - (!!match ? 0 : 1);
                           }
                           objIndex++;
                        }
                  }
                  break;
               case 1:
                  lowerBound = index + 1;
                  break;
            }
         }
         message = this.resourceManager.getString("collections","unknownMode");
         throw new SortError(message);
      }
      
      public function propertyAffectsSort(param1:String) : Boolean
      {
         var _loc3_:SortField = null;
         if(this.usingCustomCompareFunction || !this.fields)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.fields.length)
         {
            _loc3_ = this.fields[_loc2_];
            if(_loc3_.name == param1 || _loc3_.usingCustomCompareFunction)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function reverse() : void
      {
         var _loc1_:int = 0;
         if(this.fields)
         {
            _loc1_ = 0;
            while(_loc1_ < this.fields.length)
            {
               SortField(this.fields[_loc1_]).reverse();
               _loc1_++;
            }
         }
         this.noFieldsDescending = !this.noFieldsDescending;
      }
      
      public function sort(param1:Array) : void
      {
         var fixedCompareFunction:Function = null;
         var message:String = null;
         var uniqueRet1:Object = null;
         var fields:Array = null;
         var i:int = 0;
         var sortArgs:Object = null;
         var uniqueRet2:Object = null;
         var items:Array = param1;
         if(!items || items.length <= 1)
         {
            return;
         }
         if(this.usingCustomCompareFunction)
         {
            fixedCompareFunction = function(param1:Object, param2:Object):int
            {
               return compareFunction(param1,param2,_fields);
            };
            if(this.unique)
            {
               uniqueRet1 = items.sort(fixedCompareFunction,Array.UNIQUESORT);
               if(uniqueRet1 == 0)
               {
                  message = this.resourceManager.getString("collections","nonUnique");
                  throw new SortError(message);
               }
            }
            else
            {
               items.sort(fixedCompareFunction);
            }
         }
         else
         {
            fields = this.fields;
            if(fields && fields.length > 0)
            {
               sortArgs = this.initSortFields(items[0],true);
               if(this.unique)
               {
                  if(sortArgs && fields.length == 1)
                  {
                     uniqueRet2 = items.sortOn(sortArgs.fields[0],sortArgs.options[0] | Array.UNIQUESORT);
                  }
                  else
                  {
                     uniqueRet2 = items.sort(this.internalCompare,Array.UNIQUESORT);
                  }
                  if(uniqueRet2 == 0)
                  {
                     message = this.resourceManager.getString("collections","nonUnique");
                     throw new SortError(message);
                  }
               }
               else if(sortArgs)
               {
                  items.sortOn(sortArgs.fields,sortArgs.options);
               }
               else
               {
                  items.sort(this.internalCompare);
               }
            }
            else
            {
               items.sort(this.internalCompare);
            }
         }
      }
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      private function initSortFields(param1:Object, param2:Boolean = false) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:SortField = null;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         _loc4_ = 0;
         while(_loc4_ < this.fields.length)
         {
            SortField(this.fields[_loc4_]).initCompare(param1);
            _loc4_++;
         }
         if(param2)
         {
            _loc3_ = {
               "fields":[],
               "options":[]
            };
            _loc4_ = 0;
            while(_loc4_ < this.fields.length)
            {
               if((_loc6_ = (_loc5_ = this.fields[_loc4_]).getArraySortOnOptions()) == -1)
               {
                  return null;
               }
               _loc3_.fields.push(_loc5_.name);
               _loc3_.options.push(_loc6_);
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      private function internalCompare(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:SortField = null;
         var _loc4_:int = 0;
         if(!this._fields)
         {
            _loc4_ = this.noFieldsCompare(param1,param2);
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = !!param3 ? int(param3.length) : int(this._fields.length);
            while(_loc4_ == 0 && _loc5_ < _loc6_)
            {
               _loc4_ = (_loc7_ = SortField(this._fields[_loc5_])).internalCompare(param1,param2);
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private function noFieldsCompare(param1:Object, param2:Object, param3:Array = null) : int
      {
         var message:String = null;
         var a:Object = param1;
         var b:Object = param2;
         var fields:Array = param3;
         if(!this.defaultEmptyField)
         {
            this.defaultEmptyField = new SortField();
            try
            {
               this.defaultEmptyField.initCompare(a);
            }
            catch(e:SortError)
            {
               message = resourceManager.getString("collections","noComparator",[a]);
               throw new SortError(message);
            }
         }
         var result:int = this.defaultEmptyField.compareFunction(a,b);
         if(this.noFieldsDescending)
         {
            result *= -1;
         }
         return result;
      }
   }
}
