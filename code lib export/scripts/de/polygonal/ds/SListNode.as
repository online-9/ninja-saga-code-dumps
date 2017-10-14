package de.polygonal.ds
{
   public class SListNode implements LinkedListNode
   {
       
      
      public var data;
      
      public var next:de.polygonal.ds.SListNode;
      
      public function SListNode(obj:*)
      {
         super();
         data = obj;
         next = null;
      }
      
      public function insertAfter(node:de.polygonal.ds.SListNode) : void
      {
         node.next = next;
         next = node;
      }
      
      public function toString() : String
      {
         return "[SListNode, data=" + data + "]";
      }
   }
}
