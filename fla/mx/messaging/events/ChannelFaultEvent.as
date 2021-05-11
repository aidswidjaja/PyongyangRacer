package mx.messaging.events
{
   import flash.events.Event;
   import mx.messaging.Channel;
   import mx.messaging.messages.ErrorMessage;
   
   public class ChannelFaultEvent extends ChannelEvent
   {
      
      public static const FAULT:String = "channelFault";
       
      
      public var faultString:String;
      
      public var rootCause:Object;
      
      public var faultDetail:String;
      
      public var faultCode:String;
      
      public function ChannelFaultEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Channel = null, param5:Boolean = false, param6:String = null, param7:String = null, param8:String = null, param9:Boolean = false, param10:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param9,param10);
         faultCode = param6;
         faultString = param7;
         faultDetail = param8;
      }
      
      public static function createEvent(param1:Channel, param2:Boolean = false, param3:String = null, param4:String = null, param5:String = null, param6:Boolean = false, param7:Boolean = false) : ChannelFaultEvent
      {
         return new ChannelFaultEvent(ChannelFaultEvent.FAULT,false,false,param1,param2,param3,param4,param5,param6,param7);
      }
      
      override public function clone() : Event
      {
         var _loc1_:ChannelFaultEvent = new ChannelFaultEvent(type,bubbles,cancelable,channel,reconnecting,faultCode,faultString,faultDetail,rejected,connected);
         _loc1_.rootCause = rootCause;
         return _loc1_;
      }
      
      public function createErrorMessage() : ErrorMessage
      {
         var _loc1_:ErrorMessage = new ErrorMessage();
         _loc1_.faultCode = faultCode;
         _loc1_.faultString = faultString;
         _loc1_.faultDetail = faultDetail;
         _loc1_.rootCause = rootCause;
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return formatToString("ChannelFaultEvent","faultCode","faultString","faultDetail","channelId","type","bubbles","cancelable","eventPhase");
      }
   }
}
