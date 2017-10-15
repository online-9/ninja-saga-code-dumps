package de.polygonal.ds 
{
    public class SListNode extends Object implements de.polygonal.ds.LinkedListNode
    {
        public function SListNode(arg1:*)
        {
            super();
            this.data = arg1;
            this.next = null;
            return;
        }

        public function insertAfter(arg1:de.polygonal.ds.SListNode):void
        {
            arg1.next = this.next;
            this.next = arg1;
            return;
        }

        public function toString():String
        {
            return "[SListNode, data=" + this.data + "]";
        }

        public var data:*;

        public var next:de.polygonal.ds.SListNode;
    }
}
