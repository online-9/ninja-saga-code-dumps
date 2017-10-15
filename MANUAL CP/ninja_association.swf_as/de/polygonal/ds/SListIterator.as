package de.polygonal.ds 
{
    public class SListIterator extends Object implements de.polygonal.ds.Iterator
    {
        public function SListIterator(arg1:de.polygonal.ds.SLinkedList=null, arg2:de.polygonal.ds.SListNode=null)
        {
            super();
            this.list = arg1;
            this.node = arg2;
            return;
        }

        public function start():void
        {
            if (this.list)
            {
                this.node = this.list.head;
            }
            return;
        }

        public function next():*
        {
            var loc1:*;
            loc1 = undefined;
            if (this.hasNext())
            {
                loc1 = this.node.data;
                this.node = this.node.next;
                return loc1;
            }
            return null;
        }

        public function hasNext():Boolean
        {
            return Boolean(this.node);
        }

        public function get data():*
        {
            if (this.node)
            {
                return this.node.data;
            }
            return null;
        }

        public function set data(arg1:*):void
        {
            this.node.data = arg1;
            return;
        }

        public function end():void
        {
            if (this.list)
            {
                this.node = this.list.tail;
            }
            return;
        }

        public function forth():void
        {
            if (this.node)
            {
                this.node = this.node.next;
            }
            return;
        }

        public function valid():Boolean
        {
            return Boolean(this.node);
        }

        public function remove():Boolean
        {
            return this.list.remove(this);
        }

        public function toString():String
        {
            return "{SListIterator: data=" + this.node.data + "}";
        }

        public var node:de.polygonal.ds.SListNode;

        public var list:de.polygonal.ds.SLinkedList;
    }
}
