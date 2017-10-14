package de.polygonal.ds
{
   import de.polygonal.ds.sort.sLinkedInsertionSortCmp;
   import de.polygonal.ds.sort.sLinkedMergeSortCmp;
   import de.polygonal.ds.sort.compare.compareStringCaseSensitiveDesc;
   import de.polygonal.ds.sort.compare.compareStringCaseInSensitive;
   import de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc;
   import de.polygonal.ds.sort.compare.compareStringCaseSensitive;
   import de.polygonal.ds.sort.sLinkedInsertionSort;
   import de.polygonal.ds.sort.sLinkedMergeSort;
   
   public class SLinkedList implements Collection
   {
      
      public static const INSERTION_SORT:int = 1 << 1;
      
      public static const MERGE_SORT:int = 1 << 2;
      
      public static const NUMERIC:int = 1 << 3;
      
      public static const DESCENDING:int = 1 << 4;
       
      
      private var _count:int;
      
      public var head:de.polygonal.ds.SListNode;
      
      public var tail:de.polygonal.ds.SListNode;
      
      public function SLinkedList(... args)
      {
         super();
         head = tail = null;
         _count = 0;
         if(args.length > 0)
         {
            append.apply(this,args);
         }
      }
      
      public function append(... args) : de.polygonal.ds.SListNode
      {
         var t:de.polygonal.ds.SListNode = null;
         var i:int = 0;
         var k:int = args.length;
         var node:de.polygonal.ds.SListNode = new de.polygonal.ds.SListNode(args[0]);
         if(head)
         {
            tail.next = node;
            tail = node;
         }
         else
         {
            head = tail = node;
         }
         if(k > 1)
         {
            t = node;
            for(i = 1; i < k; i++)
            {
               node = new de.polygonal.ds.SListNode(args[i]);
               tail.next = node;
               tail = node;
            }
            _count = _count + k;
            return t;
         }
         _count++;
         return node;
      }
      
      public function prepend(... args) : de.polygonal.ds.SListNode
      {
         var t:de.polygonal.ds.SListNode = null;
         var i:int = 0;
         var k:int = args.length;
         var node:de.polygonal.ds.SListNode = new de.polygonal.ds.SListNode(args[int(k - 1)]);
         if(head)
         {
            node.next = head;
            head = node;
         }
         else
         {
            head = tail = node;
         }
         if(k > 1)
         {
            t = node;
            for(i = k - 2; i >= 0; i--)
            {
               node = new de.polygonal.ds.SListNode(args[i]);
               node.next = head;
               head = node;
            }
            _count = _count + k;
            return t;
         }
         _count++;
         return node;
      }
      
      public function insertAfter(itr:SListIterator, obj:*) : de.polygonal.ds.SListNode
      {
         var node:de.polygonal.ds.SListNode = null;
         if(itr.list != this)
         {
            return null;
         }
         if(itr.node)
         {
            node = new de.polygonal.ds.SListNode(obj);
            itr.node.insertAfter(node);
            if(itr.node == tail)
            {
               tail = itr.node.next;
            }
            _count++;
            return node;
         }
         return append(obj);
      }
      
      public function remove(itr:SListIterator) : Boolean
      {
         if(itr.list != this || !itr.node)
         {
            return false;
         }
         var node:de.polygonal.ds.SListNode = head;
         if(itr.node == head)
         {
            itr.forth();
            removeHead();
            return true;
         }
         while(node.next != itr.node)
         {
            node = node.next;
         }
         itr.forth();
         if(node.next == tail)
         {
            tail = node;
         }
         node.next = itr.node;
         _count--;
         return true;
      }
      
      public function removeHead() : *
      {
         var obj:* = undefined;
         var node:de.polygonal.ds.SListNode = null;
         if(head)
         {
            obj = head.data;
            if(head == tail)
            {
               head = tail = null;
            }
            else
            {
               node = head;
               head = head.next;
               node.next = null;
               if(head == null)
               {
                  tail = null;
               }
            }
            _count--;
            return obj;
         }
         return null;
      }
      
      public function removeTail() : *
      {
         var obj:* = undefined;
         var node:de.polygonal.ds.SListNode = null;
         if(tail)
         {
            obj = tail.data;
            if(head == tail)
            {
               head = tail = null;
            }
            else
            {
               node = head;
               while(node.next != tail)
               {
                  node = node.next;
               }
               tail = node;
               node.next = null;
            }
            _count--;
            return obj;
         }
         return null;
      }
      
      public function merge(... args) : void
      {
         var a:SLinkedList = null;
         if(args.length == 0)
         {
            return;
         }
         a = args[0];
         if(a.head)
         {
            if(head)
            {
               tail.next = a.head;
               tail = a.tail;
            }
            else
            {
               head = a.head;
               tail = a.tail;
            }
            _count = _count + a.size;
         }
         var k:int = args.length;
         for(var i:int = 1; i < k; i++)
         {
            a = args[i];
            if(a.head)
            {
               tail.next = a.head;
               tail = a.tail;
               _count = _count + a.size;
            }
         }
      }
      
      public function concat(... args) : SLinkedList
      {
         var a:SLinkedList = null;
         var n:de.polygonal.ds.SListNode = null;
         var c:SLinkedList = new SLinkedList();
         n = head;
         while(n)
         {
            c.append(n.data);
            n = n.next;
         }
         var k:int = args.length;
         for(var i:int = 0; i < k; i++)
         {
            a = args[i];
            n = a.head;
            while(n)
            {
               c.append(n.data);
               n = n.next;
            }
         }
         return c;
      }
      
      public function sort(... sortOptions) : void
      {
         var b:int = 0;
         var cmp:Function = null;
         var o:* = undefined;
         if(_count <= 1)
         {
            return;
         }
         if(sortOptions.length > 0)
         {
            b = 0;
            cmp = null;
            o = sortOptions[0];
            if(o is Function)
            {
               cmp = o;
               if(sortOptions.length > 1)
               {
                  o = sortOptions[1];
                  if(o is int)
                  {
                     b = o;
                  }
               }
            }
            else if(o is int)
            {
               b = o;
            }
            if(Boolean(cmp))
            {
               if(b & 2)
               {
                  head = sLinkedInsertionSortCmp(head,cmp,b == 18);
               }
               else
               {
                  head = sLinkedMergeSortCmp(head,cmp,b == 16);
               }
            }
            else if(b & 2)
            {
               if(b & 4)
               {
                  if(b == 22)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseSensitiveDesc);
                  }
                  else if(b == 14)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseInSensitive);
                  }
                  else if(b == 30)
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseInSensitiveDesc);
                  }
                  else
                  {
                     head = sLinkedInsertionSortCmp(head,compareStringCaseSensitive);
                  }
               }
               else
               {
                  head = sLinkedInsertionSort(head,b == 18);
               }
            }
            else if(b & 4)
            {
               if(b == 20)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseSensitiveDesc);
               }
               else if(b == 12)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseInSensitive);
               }
               else if(b == 28)
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseInSensitiveDesc);
               }
               else
               {
                  head = sLinkedMergeSortCmp(head,compareStringCaseSensitive);
               }
            }
            else if(b & 16)
            {
               head = sLinkedMergeSort(head,true);
            }
         }
         else
         {
            head = sLinkedMergeSort(head);
         }
      }
      
      public function nodeOf(obj:*, from:SListIterator = null) : SListIterator
      {
         if(from != null)
         {
            if(from.list != null)
            {
               return null;
            }
         }
         var node:de.polygonal.ds.SListNode = from == null?head:from.node;
         while(node)
         {
            if(node.data === obj)
            {
               return new SListIterator(this,node);
            }
            node = node.next;
         }
         return null;
      }
      
      public function splice(start:SListIterator, deleteCount:uint = 4.294967295E9, ... args) : SLinkedList
      {
         var s:de.polygonal.ds.SListNode = null;
         var t:de.polygonal.ds.SListNode = null;
         var c:SLinkedList = null;
         var i:int = 0;
         var k:int = 0;
         var n:de.polygonal.ds.SListNode = null;
         if(start)
         {
            if(start.list != this)
            {
               return null;
            }
         }
         if(start.node)
         {
            s = start.node;
            t = head;
            while(t.next != s)
            {
               t = t.next;
            }
            c = new SLinkedList();
            if(deleteCount == 4294967295)
            {
               if(start.node == tail)
               {
                  return c;
               }
               while(start.node)
               {
                  c.append(start.node.data);
                  start.remove();
               }
               start.list = c;
               start.node = s;
               return c;
            }
            for(i = 0; i < deleteCount; )
            {
               if(start.node)
               {
                  c.append(start.node.data);
                  start.remove();
                  i++;
                  continue;
               }
               break;
            }
            k = args.length;
            if(k > 0)
            {
               if(_count == 0)
               {
                  for(i = 0; i < k; i++)
                  {
                     append(args[i]);
                  }
               }
               else if(t == null)
               {
                  n = prepend(args[0]);
                  for(i = 1; i < k; i++)
                  {
                     n.insertAfter(new de.polygonal.ds.SListNode(args[i]));
                     if(n == tail)
                     {
                        tail = n.next;
                     }
                     n = n.next;
                     _count++;
                  }
               }
               else
               {
                  n = t;
                  for(i = 0; i < k; i++)
                  {
                     n.insertAfter(new de.polygonal.ds.SListNode(args[i]));
                     if(n == tail)
                     {
                        tail = n.next;
                     }
                     n = n.next;
                     _count++;
                  }
               }
               start.node = n;
            }
            else
            {
               start.node = s;
            }
            start.list = c;
            return c;
         }
         return null;
      }
      
      public function shiftUp() : void
      {
         var t:de.polygonal.ds.SListNode = head;
         if(head.next == tail)
         {
            head = tail;
            tail = t;
            tail.next = null;
            head.next = tail;
         }
         else
         {
            head = head.next;
            tail.next = t;
            t.next = null;
            tail = t;
         }
      }
      
      public function popDown() : void
      {
         var node:de.polygonal.ds.SListNode = null;
         var t:de.polygonal.ds.SListNode = tail;
         if(head.next == tail)
         {
            tail = head;
            head = t;
            tail.next = null;
            head.next = tail;
         }
         else
         {
            node = head;
            while(node.next != tail)
            {
               node = node.next;
            }
            tail = node;
            tail.next = null;
            t.next = head;
            head = t;
         }
      }
      
      public function reverse() : void
      {
         if(_count == 0)
         {
            return;
         }
         var a:Array = new Array(_count);
         var i:int = 0;
         var node:de.polygonal.ds.SListNode = head;
         while(node)
         {
            a[i++] = node;
            node = node.next;
         }
         a.reverse();
         node = head = a[0];
         for(i = 1; i < _count; i++)
         {
            node = node.next = a[i];
         }
         node.next = null;
         tail = node;
         a = null;
      }
      
      public function join(sep:*) : String
      {
         if(_count == 0)
         {
            return "";
         }
         var s:String = "";
         var node:de.polygonal.ds.SListNode = head;
         while(node.next)
         {
            s = s + (node.data + sep);
            node = node.next;
         }
         s = s + node.data;
         return s;
      }
      
      public function contains(obj:*) : Boolean
      {
         var node:de.polygonal.ds.SListNode = head;
         while(node)
         {
            if(node.data == obj)
            {
               return true;
            }
            node = node.next;
         }
         return false;
      }
      
      public function clear() : void
      {
         var next:de.polygonal.ds.SListNode = null;
         var node:de.polygonal.ds.SListNode = head;
         head = null;
         while(node)
         {
            next = node.next;
            node.next = null;
            node = next;
         }
         _count = 0;
      }
      
      public function getIterator() : Iterator
      {
         return new SListIterator(this,head);
      }
      
      public function getListIterator() : SListIterator
      {
         return new SListIterator(this,head);
      }
      
      public function get size() : int
      {
         return _count;
      }
      
      public function isEmpty() : Boolean
      {
         return _count == 0;
      }
      
      public function toArray() : Array
      {
         var a:Array = [];
         var node:de.polygonal.ds.SListNode = head;
         while(node)
         {
            a.push(node.data);
            node = node.next;
         }
         return a;
      }
      
      public function toString() : String
      {
         return "[SlinkedList, size=" + size + "]";
      }
      
      public function dump() : String
      {
         if(!head)
         {
            return "SLinkedList: (empty)";
         }
         var s:* = "SLinkedList: has " + _count + " node" + (_count == 1?"":"s") + "\n|< Head\n";
         var itr:SListIterator = getListIterator();
         while(itr.valid())
         {
            s = s + ("\t" + itr.data + "\n");
            itr.forth();
         }
         s = s + "Tail >|";
         return s;
      }
   }
}
