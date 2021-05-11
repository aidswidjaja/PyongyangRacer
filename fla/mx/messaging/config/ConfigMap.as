package mx.messaging.config
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import mx.utils.object_proxy;
   
   use namespace object_proxy;
   
   public dynamic class ConfigMap extends Proxy
   {
       
      
      private var _item:Object;
      
      object_proxy var propertyList:Array;
      
      public function ConfigMap(param1:Object = null)
      {
         super();
         if(!param1)
         {
            param1 = {};
         }
         _item = param1;
         propertyList = [];
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         var _loc2_:Object = _item[param1];
         var _loc3_:* = delete _item[param1];
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < object_proxy::propertyList.length)
         {
            if(object_proxy::propertyList[_loc5_] == param1)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         if(_loc4_ > -1)
         {
            object_proxy::propertyList.splice(_loc4_,1);
         }
         return _loc3_;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return object_proxy::propertyList[param1 - 1];
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:Object = null;
         return _item[param1];
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return param1 in _item;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         if(param1 < object_proxy::propertyList.length)
         {
            return param1 + 1;
         }
         return 0;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = _item[param1];
         if(_loc3_ !== param2)
         {
            _item[param1] = param2;
            _loc4_ = 0;
            while(_loc4_ < object_proxy::propertyList.length)
            {
               if(object_proxy::propertyList[_loc4_] == param1)
               {
                  return;
               }
               _loc4_++;
            }
            object_proxy::propertyList.push(param1);
         }
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return _item[param1].apply(_item,rest);
      }
      
      override flash_proxy function nextValue(param1:int) : *
      {
         return _item[object_proxy::propertyList[param1 - 1]];
      }
   }
}
