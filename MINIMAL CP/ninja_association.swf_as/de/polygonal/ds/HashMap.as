package de.polygonal.ds 
{
    import flash.utils.*;
    
    public class HashMap extends Object implements de.polygonal.ds.Collection, de.polygonal.ds.DummyInterface
    {
        public function HashMap(arg1:int=500)
        {
            super();
            var loc4:*;
            this._maxSize = loc4 = Math.max(10, arg1);
            this._initSize = loc4;
            this._keyMap = new flash.utils.Dictionary(true);
            this._dupMap = new flash.utils.Dictionary(true);
            this._size = 0;
            var loc1:*;
            loc1 = new PairNode();
            this._tail = loc4 = loc1;
            this._head = loc4;
            var loc2:*;
            loc2 = this._initSize + 1;
            var loc3:*;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                loc1.next = new PairNode();
                loc1 = loc1.next;
                ++loc3;
            }
            this._tail = loc1;
            return;
        }

        public function insert(arg1:*, arg2:*):Boolean
        {
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = 0;
            if (arg1 == null)
            {
                return false;
            }
            if (arg2 == null)
            {
                return false;
            }
            if (this._keyMap[arg1])
            {
                return false;
            }
            var loc4:*;
            var loc5:*;
            loc5 = ((loc4 = this)._size + 1);
            loc4._size = loc5;
            if ((loc4 = this)._size == this._maxSize)
            {
                this._maxSize = loc4 = this._maxSize + this._initSize;
                loc2 = loc4 + 1;
                loc3 = 0;
                while (loc3 < loc2) 
                {
                    this._tail.next = new PairNode();
                    this._tail = this._tail.next;
                    ++loc3;
                }
            }
            var loc1:*;
            loc1 = this._head;
            this._head = this._head.next;
            loc1.key = arg1;
            loc1.obj = arg2;
            loc1.next = this._pair;
            if (this._pair)
            {
                this._pair.prev = loc1;
            }
            this._pair = loc1;
            this._keyMap[arg1] = loc1;
            if (this._dupMap[arg2])
            {
                var loc6:*;
                loc6 = ((loc4 = this._dupMap)[(loc5 = arg2)] + 1);
                loc4[loc5] = loc6;
            }
            else 
            {
                this._dupMap[arg2] = 1;
            }
            return true;
        }

        public function find(arg1:*):*
        {
            var loc1:*;
            loc1 = this._keyMap[arg1];
            if (loc1)
            {
                return loc1.obj;
            }
            return null;
        }

        public function remove(arg1:*):*
        {
            var loc2:*;
            loc2 = undefined;
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = 0;
            var loc1:*;
            loc1 = this._keyMap[arg1];
            if (loc1)
            {
                loc2 = loc1.obj;
                delete this._keyMap[arg1];
                if (loc1.prev)
                {
                    loc1.prev.next = loc1.next;
                }
                if (loc1.next)
                {
                    loc1.next.prev = loc1.prev;
                }
                if (loc1 == this._pair)
                {
                    this._pair = loc1.next;
                }
                loc1.prev = null;
                loc1.next = null;
                this._tail.next = loc1;
                this._tail = loc1;
                var loc5:*;
                var loc6:*;
                var loc7:*;
                if ((loc5[loc6] = loc7 = ((loc5 = this._dupMap)[(loc6 = loc2)] - 1)) <= 0)
                {
                    delete this._dupMap[loc2];
                }
                if ((loc5._size = loc6 = ((loc5 = this)._size - 1)) <= this._maxSize - this._initSize)
                {
                    this._maxSize = loc5 = this._maxSize - this._initSize;
                    loc3 = loc5 + 1;
                    loc4 = 0;
                    while (loc4 < loc3) 
                    {
                        this._head = this._head.next;
                        ++loc4;
                    }
                }
                return loc2;
            }
            return null;
        }

        public function containsKey(arg1:*):Boolean
        {
            return !(this._keyMap[arg1] == undefined);
        }

        public function getKeySet():Array
        {
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = null;
            var loc1:*;
            loc1 = new Array(this._size);
            var loc4:*;
            loc4 = 0;
            var loc5:*;
            loc5 = this._keyMap;
            for each (loc3 in loc5)
            {
                var loc6:*;
                loc1[(loc6 = loc2++)] = loc3.key;
            }
            return loc1;
        }

        public function contains(arg1:*):Boolean
        {
            return this._dupMap[arg1] > 0;
        }

        public function clear():void
        {
            var loc1:*;
            loc1 = null;
            this._keyMap = new flash.utils.Dictionary(true);
            this._dupMap = new flash.utils.Dictionary(true);
            var loc2:*;
            loc2 = this._pair;
            while (loc2) 
            {
                loc1 = loc2.next;
                var loc3:*;
                loc2.prev = loc3 = null;
                loc2.next = loc3;
                loc2.key = null;
                loc2.obj = null;
                this._tail.next = loc2;
                this._tail = this._tail.next;
                loc2 = loc1;
            }
            this._pair = null;
            this._size = 0;
            return;
        }

        public function getIterator():de.polygonal.ds.Iterator
        {
            return new HashMapIterator(this._pair);
        }

        public function get size():int
        {
            return this._size;
        }

        public function isEmpty():Boolean
        {
            return this._size == 0;
        }

        public function toArray():Array
        {
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = null;
            var loc1:*;
            loc1 = new Array(this._size);
            var loc4:*;
            loc4 = 0;
            var loc5:*;
            loc5 = this._keyMap;
            for each (loc3 in loc5)
            {
                var loc6:*;
                loc1[(loc6 = loc2++)] = loc3.obj;
            }
            return loc1;
        }

        public function toString():String
        {
            return "[HashMap, size=" + this.size + "]";
        }

        public function dump():String
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = "HashMap:\n";
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = this._keyMap;
            for each (loc2 in loc4)
            {
                loc1 = loc1 + "[key: " + loc2.key + ", val:" + loc2.obj + "]\n";
            }
            return loc1;
        }

        private var _keyMap:flash.utils.Dictionary;

        private var _dupMap:flash.utils.Dictionary;

        private var _initSize:int;

        private var _maxSize:int;

        private var _size:int;

        private var _pair:PairNode;

        private var _head:PairNode;

        private var _tail:PairNode;
    }
}


class HashMapIterator extends Object implements de.polygonal.ds.Iterator, de.polygonal.ds.DummyInterface
{
    public function HashMapIterator(arg1:PairNode)
    {
        super();
        var loc1:*;
        this._walker = loc1 = arg1;
        this._pair = loc1;
        return;
    }

    public function get data():*
    {
        return this._walker.obj;
    }

    public function set data(arg1:*):void
    {
        this._walker.obj = arg1;
        return;
    }

    public function start():void
    {
        this._walker = this._pair;
        return;
    }

    public function hasNext():Boolean
    {
        return !(this._walker == null);
    }

    public function next():*
    {
        var loc1:*;
        loc1 = this._walker.obj;
        this._walker = this._walker.next;
        return loc1;
    }

    private var _pair:PairNode;

    private var _walker:PairNode;
}

class PairNode extends Object
{
    public function PairNode()
    {
        super();
        return;
    }

    public var key:*;

    public var obj:*;

    public var prev:PairNode;

    public var next:PairNode;
}