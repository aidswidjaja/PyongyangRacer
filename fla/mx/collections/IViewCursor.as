package mx.collections
{
   import flash.events.IEventDispatcher;
   
   public interface IViewCursor extends IEventDispatcher
   {
       
      
      function get afterLast() : Boolean;
      
      function get beforeFirst() : Boolean;
      
      function get bookmark() : CursorBookmark;
      
      function get current() : Object;
      
      function get view() : ICollectionView;
      
      function findAny(param1:Object) : Boolean;
      
      function findFirst(param1:Object) : Boolean;
      
      function findLast(param1:Object) : Boolean;
      
      function insert(param1:Object) : void;
      
      function moveNext() : Boolean;
      
      function movePrevious() : Boolean;
      
      function remove() : Object;
      
      function seek(param1:CursorBookmark, param2:int = 0, param3:int = 0) : void;
   }
}
