package org.papervision3d.core.utils.virtualmouse
{
   import flash.events.Event;
   
   public class VirtualMouseEvent extends Event implements IVirtualMouseEvent
   {
       
      
      public function VirtualMouseEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
