package mx.messaging
{
   import flash.utils.Dictionary;
   import mx.core.mx_internal;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   
   use namespace mx_internal;
   
   public class ConsumerMessageDispatcher
   {
      
      private static var _instance:ConsumerMessageDispatcher;
       
      
      private const _consumerDuplicateMessageBarrier:Object = {};
      
      private const _channelSetRefCounts:Dictionary = new Dictionary();
      
      private const _consumers:Object = {};
      
      public function ConsumerMessageDispatcher()
      {
         super();
      }
      
      public static function getInstance() : ConsumerMessageDispatcher
      {
         if(!_instance)
         {
            _instance = new ConsumerMessageDispatcher();
         }
         return _instance;
      }
      
      public function registerSubscription(param1:AbstractConsumer) : void
      {
         _consumers[param1.clientId] = param1;
         if(_channelSetRefCounts[param1.channelSet] == null)
         {
            param1.channelSet.addEventListener(MessageEvent.MESSAGE,messageHandler);
            _channelSetRefCounts[param1.channelSet] = 1;
         }
         else
         {
            ++_channelSetRefCounts[param1.channelSet];
         }
      }
      
      private function messageHandler(param1:MessageEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:AbstractConsumer = _consumers[param1.message.clientId];
         if(_loc2_ == null)
         {
            if(Log.isDebug())
            {
               Log.getLogger("mx.messaging.Consumer").debug("\'{0}\' received pushed message for consumer but no longer subscribed: {1}",param1.message.clientId,param1.message);
            }
            return;
         }
         if(param1.target.currentChannel.channelSets.length > 1)
         {
            _loc3_ = _loc2_.id;
            if(_consumerDuplicateMessageBarrier[_loc3_] == null)
            {
               _consumerDuplicateMessageBarrier[_loc3_] = {};
            }
            _loc4_ = param1.target.currentChannel.id;
            if(_consumerDuplicateMessageBarrier[_loc3_][_loc4_] != param1.messageId)
            {
               _consumerDuplicateMessageBarrier[_loc3_][_loc4_] = param1.messageId;
               _loc2_.messageHandler(param1);
            }
         }
         else
         {
            _loc2_.messageHandler(param1);
         }
      }
      
      public function unregisterSubscription(param1:AbstractConsumer) : void
      {
         delete _consumers[param1.clientId];
         var _loc2_:int = _channelSetRefCounts[param1.channelSet];
         if(--_loc2_ == 0)
         {
            param1.channelSet.removeEventListener(MessageEvent.MESSAGE,messageHandler);
            _channelSetRefCounts[param1.channelSet] = null;
            if(_consumerDuplicateMessageBarrier[param1.id] != null)
            {
               delete _consumerDuplicateMessageBarrier[param1.id];
            }
         }
         else
         {
            _channelSetRefCounts[param1.channelSet] = _loc2_;
         }
      }
      
      public function isChannelUsedForSubscriptions(param1:Channel) : Boolean
      {
         var _loc2_:Array = param1.channelSets;
         var _loc3_:ChannelSet = null;
         var _loc4_:int = _loc2_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_];
            if(_channelSetRefCounts[_loc3_] != null && _loc3_.currentChannel == param1)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
   }
}
