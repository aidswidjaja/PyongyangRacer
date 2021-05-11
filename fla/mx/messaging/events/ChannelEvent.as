package mx.messaging.events
{
   import flash.events.Event;
   import mx.messaging.Channel;
   
   public class ChannelEvent extends Event
   {
      
      public static const CONNECT:String = "channelConnect";
      
      public static const DISCONNECT:String = "channelDisconnect";
       
      
      public var channel:Channel;
      
      public var connected:Boolean;
      
      public var reconnecting:Boolean;
      
      public var rejected:Boolean;
      
      public function ChannelEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Channel = null, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false)
      {
         super(param1,param2,param3);
         this.channel = param4;
         this.reconnecting = param5;
         this.rejected = param6;
         this.connected = param7;
      }
      
      public static function createEvent(param1:String, param2:Channel = null, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : ChannelEvent
      {
         return new ChannelEvent(param1,false,false,param2,param3,param4,param5);
      }
      
      override public function toString() : String
      {
         return formatToString("ChannelEvent","channelId","reconnecting","rejected","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new ChannelEvent(type,bubbles,cancelable,channel,reconnecting,rejected,connected);
      }
      
      public function get channelId() : String
      {
         if(channel != null)
         {
            return channel.id;
         }
         return null;
      }
   }
}
