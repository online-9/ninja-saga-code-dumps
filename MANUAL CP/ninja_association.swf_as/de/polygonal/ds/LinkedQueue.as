package de.polygonal.ds 
{
    public class LinkedQueue extends Object implements de.polygonal.ds.Collection
    {
        public function LinkedQueue(arg1:de.polygonal.ds.SLinkedList=null)
        {
            super();
            if (arg1 != null)
            {
                this._list = arg1;
            }
            else 
            {
                this._list = new de.polygonal.ds.SLinkedList();
            }
            return;
        }

        public function peek():*
        {
            return this._list.size > 0 ? this._list.head.data : null;
        }

        public function back():*
        {
            return this._list.size > 0 ? this._list.tail.data : null;
        }

        public function enqueue(arg1:*):void
        {
            this._list.append(arg1);
            return;
        }

        public function dequeue():*
        {
            var loc1:*;
            loc1 = undefined;
            if (this._list.size > 0)
            {
                loc1 = this._list.head.data;
                this._list.removeHead();
                return loc1;
            }
            return null;
        }

        public function contains(arg1:*):Boolean
        {
            return this._list.contains(arg1);
        }

        public function clear():void
        {
            this._list.clear();
            return;
        }

        public function getIterator():de.polygonal.ds.Iterator
        {
            return this._list.getIterator();
        }

        public function get size():int
        {
            return this._list.size;
        }

        public function isEmpty():Boolean
        {
            return this._list.size == 0;
        }

        public function toArray():Array
        {
            return this._list.toArray();
        }

        public function toString():String
        {
            return "[LinkedQueue > " + this._list + "]";
        }

        public function dump():String
        {
            return "LinkedQueue:\n" + this._list.dump();
        }

        private var _list:de.polygonal.ds.SLinkedList;
    }
}
