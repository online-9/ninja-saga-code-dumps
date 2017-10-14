package de.polygonal.ds
{
   public class SListIterator implements Iterator
   {
       
      
      public var node:de.polygonal.ds.SListNode;
      
      public var list:de.polygonal.ds.SLinkedList;
      
      public function SListIterator(list:de.polygonal.ds.SLinkedList = null, node:de.polygonal.ds.SListNode = null)
      {
         super();
         this.list = list;
         this.node = node;
      }
      
      public function start() : void
      {
         if(list)
         {
            node = list.head;
         }
      }
      
      public function next() : *
      {
         var obj:* = undefined;
         if(hasNext())
         {
            obj = node.data;
            node = node.next;
            return obj;
         }
         return null;
      }
      
      public function hasNext() : Boolean
      {
         return Boolean(node);
      }
      
      public function get data() : *
      {
         if(node)
         {
            return node.data;
         }
         return null;
      }
      
      public function set data(obj:*) : void
      {
         node.data = obj;
      }
      
      public function end() : void
      {
         if(list)
         {
            node = list.tail;
         }
      }
      
      public function forth() : void
      {
         if(node)
         {
            node = node.next;
         }
      }
      
      public function valid() : Boolean
      {
         return Boolean(node);
      }
      
      public function remove() : Boolean
      {
         return list.remove(this);
      }
      
      public function toString() : String
      {
         return "{SListIterator: data=" + node.data + "}";
      }
   }
}
