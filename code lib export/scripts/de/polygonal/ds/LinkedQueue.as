package de.polygonal.ds
{
   public class LinkedQueue implements Collection
   {
       
      
      private var _list:de.polygonal.ds.SLinkedList;
      
      public function LinkedQueue(list:de.polygonal.ds.SLinkedList = null)
      {
         super();
         if(list == null)
         {
            _list = new de.polygonal.ds.SLinkedList();
         }
         else
         {
            _list = list;
         }
      }
      
      public function peek() : *
      {
         return _list.size > 0?_list.head.data:null;
      }
      
      public function back() : *
      {
         return _list.size > 0?_list.tail.data:null;
      }
      
      public function enqueue(obj:*) : void
      {
         _list.append(obj);
      }
      
      public function dequeue() : *
      {
         var front:* = undefined;
         if(_list.size > 0)
         {
            front = _list.head.data;
            _list.removeHead();
            return front;
         }
         return null;
      }
      
      public function contains(obj:*) : Boolean
      {
         return _list.contains(obj);
      }
      
      public function clear() : void
      {
         _list.clear();
      }
      
      public function getIterator() : Iterator
      {
         return _list.getIterator();
      }
      
      public function get size() : int
      {
         return _list.size;
      }
      
      public function isEmpty() : Boolean
      {
         return _list.size == 0;
      }
      
      public function toArray() : Array
      {
         return _list.toArray();
      }
      
      public function toString() : String
      {
         return "[LinkedQueue > " + _list + "]";
      }
      
      public function dump() : String
      {
         return "LinkedQueue:\n" + _list.dump();
      }
   }
}
