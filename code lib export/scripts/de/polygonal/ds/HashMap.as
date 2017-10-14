package de.polygonal.ds
{
   import flash.utils.Dictionary;
   
   public class HashMap implements Collection, DummyInterface
   {
       
      
      private var _keyMap:Dictionary;
      
      private var _dupMap:Dictionary;
      
      private var _initSize:int;
      
      private var _maxSize:int;
      
      private var _size:int;
      
      private var _pair:PairNode;
      
      private var _head:PairNode;
      
      private var _tail:PairNode;
      
      public function HashMap(size:int = 500)
      {
         super();
         _initSize = _maxSize = Math.max(10,size);
         _keyMap = new Dictionary(true);
         _dupMap = new Dictionary(true);
         _size = 0;
         var node:PairNode = new PairNode();
         _head = _tail = node;
         var k:int = _initSize + 1;
         for(var i:int = 0; i < k; i++)
         {
            node.next = new PairNode();
            node = node.next;
         }
         _tail = node;
      }
      
      public function insert(key:*, obj:*) : Boolean
      {
         var k:int = 0;
         var i:int = 0;
         if(key == null)
         {
            return false;
         }
         if(obj == null)
         {
            return false;
         }
         if(_keyMap[key])
         {
            return false;
         }
         if(_size++ == _maxSize)
         {
            k = (_maxSize = _maxSize + _initSize) + 1;
            for(i = 0; i < k; i++)
            {
               _tail.next = new PairNode();
               _tail = _tail.next;
            }
         }
         var pair:PairNode = _head;
         _head = _head.next;
         pair.key = key;
         pair.obj = obj;
         pair.next = _pair;
         if(_pair)
         {
            _pair.prev = pair;
         }
         _pair = pair;
         _keyMap[key] = pair;
         if(_dupMap[obj])
         {
            _dupMap[obj]++;
         }
         else
         {
            _dupMap[obj] = 1;
         }
         return true;
      }
      
      public function find(key:*) : *
      {
         var pair:PairNode = _keyMap[key];
         if(pair)
         {
            return pair.obj;
         }
         return null;
      }
      
      public function remove(key:*) : *
      {
         var obj:* = undefined;
         var k:int = 0;
         var i:int = 0;
         var pair:PairNode = _keyMap[key];
         if(pair)
         {
            obj = pair.obj;
            delete _keyMap[key];
            if(pair.prev)
            {
               pair.prev.next = pair.next;
            }
            if(pair.next)
            {
               pair.next.prev = pair.prev;
            }
            if(pair == _pair)
            {
               _pair = pair.next;
            }
            pair.prev = null;
            pair.next = null;
            _tail.next = pair;
            _tail = pair;
            if(--_dupMap[obj] <= 0)
            {
               delete _dupMap[obj];
            }
            if(--_size <= _maxSize - _initSize)
            {
               k = (_maxSize = _maxSize - _initSize) + 1;
               for(i = 0; i < k; i++)
               {
                  _head = _head.next;
               }
            }
            return obj;
         }
         return null;
      }
      
      public function containsKey(key:*) : Boolean
      {
         return _keyMap[key] != undefined;
      }
      
      public function getKeySet() : Array
      {
         var i:int = 0;
         var p:PairNode = null;
         var a:Array = new Array(_size);
         for each(p in _keyMap)
         {
            a[i++] = p.key;
         }
         return a;
      }
      
      public function contains(obj:*) : Boolean
      {
         return _dupMap[obj] > 0;
      }
      
      public function clear() : void
      {
         var t:PairNode = null;
         _keyMap = new Dictionary(true);
         _dupMap = new Dictionary(true);
         var n:PairNode = _pair;
         while(n)
         {
            t = n.next;
            n.next = n.prev = null;
            n.key = null;
            n.obj = null;
            _tail.next = n;
            _tail = _tail.next;
            n = t;
         }
         _pair = null;
         _size = 0;
      }
      
      public function getIterator() : Iterator
      {
         return new HashMapIterator(_pair);
      }
      
      public function get size() : int
      {
         return _size;
      }
      
      public function isEmpty() : Boolean
      {
         return _size == 0;
      }
      
      public function toArray() : Array
      {
         var i:int = 0;
         var p:PairNode = null;
         var a:Array = new Array(_size);
         for each(p in _keyMap)
         {
            a[i++] = p.obj;
         }
         return a;
      }
      
      public function toString() : String
      {
         return "[HashMap, size=" + size + "]";
      }
      
      public function dump() : String
      {
         var p:PairNode = null;
         var s:String = "HashMap:\n";
         for each(p in _keyMap)
         {
            s = s + ("[key: " + p.key + ", val:" + p.obj + "]\n");
         }
         return s;
      }
   }
}

class PairNode
{
    
   
   public var key;
   
   public var obj;
   
   public var prev:PairNode;
   
   public var next:PairNode;
   
   function PairNode()
   {
      super();
   }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.DummyInterface;

class HashMapIterator implements Iterator, DummyInterface
{
    
   
   private var _pair:PairNode;
   
   private var _walker:PairNode;
   
   function HashMapIterator(pairList:PairNode)
   {
      super();
      _pair = _walker = pairList;
   }
   
   public function get data() : *
   {
      return _walker.obj;
   }
   
   public function set data(obj:*) : void
   {
      _walker.obj = obj;
   }
   
   public function start() : void
   {
      _walker = _pair;
   }
   
   public function hasNext() : Boolean
   {
      return _walker != null;
   }
   
   public function next() : *
   {
      var obj:* = _walker.obj;
      _walker = _walker.next;
      return obj;
   }
}
