package it.gotoandplay.smartfoxserver.handlers
{
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   import it.gotoandplay.smartfoxserver.util.ObjectSerializer;
   
   public class ExtHandler implements IMessageHandler
   {
       
      
      private var sfs:SmartFoxClient;
      
      public function ExtHandler(param1:SmartFoxClient)
      {
         super();
         this.sfs = param1;
      }
      
      public function handleMessage(param1:Object, param2:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:SFSEvent = null;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         if(param2 == SmartFoxClient.XTMSG_TYPE_XML)
         {
            _loc6_ = (_loc5_ = param1 as XML).body.@action;
            _loc7_ = int(_loc5_.body.@id);
            if(_loc6_ == "xtRes")
            {
               _loc8_ = _loc5_.body.toString();
               _loc9_ = ObjectSerializer.getInstance().deserialize(_loc8_);
               _loc3_ = {};
               _loc3_.dataObj = _loc9_;
               _loc3_.type = param2;
               _loc4_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc3_);
               this.sfs.dispatchEvent(_loc4_);
            }
         }
         else if(param2 == SmartFoxClient.XTMSG_TYPE_JSON)
         {
            _loc3_ = {};
            _loc3_.dataObj = param1.o;
            _loc3_.type = param2;
            _loc4_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc3_);
            this.sfs.dispatchEvent(_loc4_);
         }
         else if(param2 == SmartFoxClient.XTMSG_TYPE_STR)
         {
            _loc3_ = {};
            _loc3_.dataObj = param1;
            _loc3_.type = param2;
            _loc4_ = new SFSEvent(SFSEvent.onExtensionResponse,_loc3_);
            this.sfs.dispatchEvent(_loc4_);
         }
      }
   }
}
