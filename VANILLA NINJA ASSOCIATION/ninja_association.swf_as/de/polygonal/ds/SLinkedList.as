package de.polygonal.ds 
{
    import de.polygonal.ds.sort.*;
    import de.polygonal.ds.sort.compare.*;
    
    public class SLinkedList extends Object implements de.polygonal.ds.Collection
    {
        public function SLinkedList(... rest)
        {
            super();
            var loc1:*;
            this.tail = loc1 = null;
            this.head = loc1;
            this._count = 0;
            if (rest.length > 0)
            {
                this.append.apply(this, rest);
            }
            return;
        }

        public function append(... rest):de.polygonal.ds.SListNode
        {
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = 0;
            var loc1:*;
            loc1 = rest.length;
            var loc2:*;
            loc2 = new de.polygonal.ds.SListNode(rest[0]);
            if (this.head)
            {
                this.tail.next = loc2;
                this.tail = loc2;
            }
            else 
            {
                var loc5:*;
                this.tail = loc5 = loc2;
                this.head = loc5;
            }
            if (loc1 > 1)
            {
                loc3 = loc2;
                loc4 = 1;
                while (loc4 < loc1) 
                {
                    loc2 = new de.polygonal.ds.SListNode(rest[loc4]);
                    this.tail.next = loc2;
                    this.tail = loc2;
                    ++loc4;
                }
                this._count = this._count + loc1;
                return loc3;
            }
            var loc6:*;
            loc6 = ((loc5 = this)._count + 1);
            loc5._count = loc6;
            return loc2;
        }

        public function prepend(... rest):de.polygonal.ds.SListNode
        {
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = 0;
            var loc1:*;
            loc1 = rest.length;
            var loc2:*;
            loc2 = new de.polygonal.ds.SListNode(rest[int((loc1 - 1))]);
            if (this.head)
            {
                loc2.next = this.head;
                this.head = loc2;
            }
            else 
            {
                var loc5:*;
                this.tail = loc5 = loc2;
                this.head = loc5;
            }
            if (loc1 > 1)
            {
                loc3 = loc2;
                loc4 = loc1 - 2;
                while (loc4 >= 0) 
                {
                    loc2 = new de.polygonal.ds.SListNode(rest[loc4]);
                    loc2.next = this.head;
                    this.head = loc2;
                    loc4 = (loc4 - 1);
                }
                this._count = this._count + loc1;
                return loc3;
            }
            var loc6:*;
            loc6 = ((loc5 = this)._count + 1);
            loc5._count = loc6;
            return loc2;
        }

        public function insertAfter(arg1:de.polygonal.ds.SListIterator, arg2:*):de.polygonal.ds.SListNode
        {
            var loc1:*;
            loc1 = null;
            if (arg1.list != this)
            {
                return null;
            }
            if (arg1.node)
            {
                loc1 = new de.polygonal.ds.SListNode(arg2);
                arg1.node.insertAfter(loc1);
                if (arg1.node == this.tail)
                {
                    this.tail = arg1.node.next;
                }
                var loc2:*;
                var loc3:*;
                loc3 = ((loc2 = this)._count + 1);
                loc2._count = loc3;
                return loc1;
            }
            return this.append(arg2);
        }

        public function remove(arg1:de.polygonal.ds.SListIterator):Boolean
        {
            if (!(arg1.list == this) || !arg1.node)
            {
                return false;
            }
            var loc1:*;
            loc1 = this.head;
            if (arg1.node == this.head)
            {
                arg1.forth();
                this.removeHead();
                return true;
            }
            while (loc1.next != arg1.node) 
            {
                loc1 = loc1.next;
            }
            arg1.forth();
            if (loc1.next == this.tail)
            {
                this.tail = loc1;
            }
            loc1.next = arg1.node;
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this)._count - 1);
            loc2._count = loc3;
            return true;
        }

        public function removeHead():*
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = null;
            if (this.head)
            {
                loc1 = this.head.data;
                if (this.head != this.tail)
                {
                    loc2 = this.head;
                    this.head = this.head.next;
                    loc2.next = null;
                    if (this.head == null)
                    {
                        this.tail = null;
                    }
                }
                else 
                {
                    var loc3:*;
                    this.tail = loc3 = null;
                    this.head = loc3;
                }
                var loc4:*;
                loc4 = ((loc3 = this)._count - 1);
                loc3._count = loc4;
                return loc1;
            }
            return null;
        }

        public function removeTail():*
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = null;
            if (this.tail)
            {
                loc1 = this.tail.data;
                if (this.head != this.tail)
                {
                    loc2 = this.head;
                    while (loc2.next != this.tail) 
                    {
                        loc2 = loc2.next;
                    }
                    this.tail = loc2;
                    loc2.next = null;
                }
                else 
                {
                    var loc3:*;
                    this.tail = loc3 = null;
                    this.head = loc3;
                }
                var loc4:*;
                loc4 = ((loc3 = this)._count - 1);
                loc3._count = loc4;
                return loc1;
            }
            return null;
        }

        public function merge(... rest):void
        {
            var loc1:*;
            loc1 = null;
            if (rest.length == 0)
            {
                return;
            }
            loc1 = rest[0];
            if (loc1.head)
            {
                if (this.head)
                {
                    this.tail.next = loc1.head;
                    this.tail = loc1.tail;
                }
                else 
                {
                    this.head = loc1.head;
                    this.tail = loc1.tail;
                }
                this._count = this._count + loc1.size;
            }
            var loc2:*;
            loc2 = rest.length;
            var loc3:*;
            loc3 = 1;
            while (loc3 < loc2) 
            {
                loc1 = rest[loc3];
                if (loc1.head)
                {
                    this.tail.next = loc1.head;
                    this.tail = loc1.tail;
                    this._count = this._count + loc1.size;
                }
                ++loc3;
            }
            return;
        }

        public function concat(... rest):de.polygonal.ds.SLinkedList
        {
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = null;
            var loc1:*;
            loc1 = new de.polygonal.ds.SLinkedList();
            loc3 = this.head;
            while (loc3) 
            {
                loc1.append(loc3.data);
                loc3 = loc3.next;
            }
            var loc4:*;
            loc4 = rest.length;
            var loc5:*;
            loc5 = 0;
            while (loc5 < loc4) 
            {
                loc2 = rest[loc5];
                loc3 = loc2.head;
                while (loc3) 
                {
                    loc1.append(loc3.data);
                    loc3 = loc3.next;
                }
                ++loc5;
            }
            return loc1;
        }

        public function sort(... rest):void
        {
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = undefined;
            if (this._count <= 1)
            {
                return;
            }
            if (rest.length > 0)
            {
                loc1 = 0;
                loc2 = null;
                if ((loc3 = rest[0]) as Function)
                {
                    loc2 = loc3;
                    if (rest.length > 1)
                    {
                        if ((loc3 = rest[1]) as int)
                        {
                            loc1 = loc3;
                        }
                    }
                }
                else 
                {
                    if (loc3 as int)
                    {
                        loc1 = loc3;
                    }
                }
                if (Boolean(loc2))
                {
                    if (loc1 & 2)
                    {
                        this.head = de.polygonal.ds.sort.sLinkedInsertionSortCmp(this.head, loc2, loc1 == 18);
                    }
                    else 
                    {
                        this.head = de.polygonal.ds.sort.sLinkedMergeSortCmp(this.head, loc2, loc1 == 16);
                    }
                }
                else 
                {
                    if (loc1 & 2)
                    {
                        if (loc1 & 4)
                        {
                            if (loc1 != 22)
                            {
                                if (loc1 != 14)
                                {
                                    if (loc1 != 30)
                                    {
                                        this.head = de.polygonal.ds.sort.sLinkedInsertionSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseSensitive);
                                    }
                                    else 
                                    {
                                        this.head = de.polygonal.ds.sort.sLinkedInsertionSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc);
                                    }
                                }
                                else 
                                {
                                    this.head = de.polygonal.ds.sort.sLinkedInsertionSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseInSensitive);
                                }
                            }
                            else 
                            {
                                this.head = de.polygonal.ds.sort.sLinkedInsertionSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseSensitiveDesc);
                            }
                        }
                        else 
                        {
                            this.head = de.polygonal.ds.sort.sLinkedInsertionSort(this.head, loc1 == 18);
                        }
                    }
                    else 
                    {
                        if (loc1 & 4)
                        {
                            if (loc1 != 20)
                            {
                                if (loc1 != 12)
                                {
                                    if (loc1 != 28)
                                    {
                                        this.head = de.polygonal.ds.sort.sLinkedMergeSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseSensitive);
                                    }
                                    else 
                                    {
                                        this.head = de.polygonal.ds.sort.sLinkedMergeSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseInSensitiveDesc);
                                    }
                                }
                                else 
                                {
                                    this.head = de.polygonal.ds.sort.sLinkedMergeSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseInSensitive);
                                }
                            }
                            else 
                            {
                                this.head = de.polygonal.ds.sort.sLinkedMergeSortCmp(this.head, de.polygonal.ds.sort.compare.compareStringCaseSensitiveDesc);
                            }
                        }
                        else 
                        {
                            if (loc1 & 16)
                            {
                                this.head = de.polygonal.ds.sort.sLinkedMergeSort(this.head, true);
                            }
                        }
                    }
                }
            }
            else 
            {
                this.head = de.polygonal.ds.sort.sLinkedMergeSort(this.head);
            }
            return;
        }

        public function nodeOf(arg1:*, arg2:de.polygonal.ds.SListIterator=null):de.polygonal.ds.SListIterator
        {
            if (arg2 != null)
            {
                if (arg2.list != null)
                {
                    return null;
                }
            }
            var loc1:*;
            loc1 = arg2 != null ? arg2.node : this.head;
            while (loc1) 
            {
                if (loc1.data === arg1)
                {
                    return new de.polygonal.ds.SListIterator(this, loc1);
                }
                loc1 = loc1.next;
            }
            return null;
        }

        public function splice(arg1:de.polygonal.ds.SListIterator, arg2:uint=4294967295, ... rest):de.polygonal.ds.SLinkedList
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = 0;
            var loc5:*;
            loc5 = 0;
            var loc6:*;
            loc6 = null;
            if (arg1)
            {
                if (arg1.list != this)
                {
                    return null;
                }
            }
            if (arg1.node)
            {
                loc1 = arg1.node;
                loc2 = this.head;
                while (loc2.next != loc1) 
                {
                    loc2 = loc2.next;
                }
                loc3 = new de.polygonal.ds.SLinkedList();
                if (arg2 == 4294967295)
                {
                    if (arg1.node == this.tail)
                    {
                        return loc3;
                    }
                    while (arg1.node) 
                    {
                        loc3.append(arg1.node.data);
                        arg1.remove();
                    }
                    arg1.list = loc3;
                    arg1.node = loc1;
                    return loc3;
                }
                loc4 = 0;
                while (loc4 < arg2) 
                {
                    if (arg1.node)
                    {
                        loc3.append(arg1.node.data);
                        arg1.remove();
                    }
                    else 
                    {
                        break;
                    }
                    ++loc4;
                }
                if ((loc5 = rest.length) > 0)
                {
                    if (this._count != 0)
                    {
                        if (loc2 != null)
                        {
                            loc6 = loc2;
                            loc4 = 0;
                            while (loc4 < loc5) 
                            {
                                loc6.insertAfter(new de.polygonal.ds.SListNode(rest[loc4]));
                                if (loc6 == this.tail)
                                {
                                    this.tail = loc6.next;
                                }
                                loc6 = loc6.next;
                                loc8 = ((loc7 = this)._count + 1);
                                loc7._count = loc8;
                                ++loc4;
                            }
                        }
                        else 
                        {
                            loc6 = this.prepend(rest[0]);
                            loc4 = 1;
                            while (loc4 < loc5) 
                            {
                                loc6.insertAfter(new de.polygonal.ds.SListNode(rest[loc4]));
                                if (loc6 == this.tail)
                                {
                                    this.tail = loc6.next;
                                }
                                loc6 = loc6.next;
                                var loc7:*;
                                var loc8:*;
                                loc8 = ((loc7 = this)._count + 1);
                                loc7._count = loc8;
                                ++loc4;
                            }
                        }
                    }
                    else 
                    {
                        loc4 = 0;
                        while (loc4 < loc5) 
                        {
                            this.append(rest[loc4]);
                            ++loc4;
                        }
                    }
                    arg1.node = loc6;
                }
                else 
                {
                    arg1.node = loc1;
                }
                arg1.list = loc3;
                return loc3;
            }
            return null;
        }

        public function shiftUp():void
        {
            var loc1:*;
            loc1 = this.head;
            if (this.head.next != this.tail)
            {
                this.head = this.head.next;
                this.tail.next = loc1;
                loc1.next = null;
                this.tail = loc1;
            }
            else 
            {
                this.head = this.tail;
                this.tail = loc1;
                this.tail.next = null;
                this.head.next = this.tail;
            }
            return;
        }

        public function popDown():void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = this.tail;
            if (this.head.next != this.tail)
            {
                loc2 = this.head;
                while (loc2.next != this.tail) 
                {
                    loc2 = loc2.next;
                }
                this.tail = loc2;
                this.tail.next = null;
                loc1.next = this.head;
                this.head = loc1;
            }
            else 
            {
                this.tail = this.head;
                this.head = loc1;
                this.tail.next = null;
                this.head.next = this.tail;
            }
            return;
        }

        public function reverse():void
        {
            if (this._count == 0)
            {
                return;
            }
            var loc1:*;
            loc1 = new Array(this._count);
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = this.head;
            while (loc3) 
            {
                var loc4:*;
                loc1[(loc4 = loc2++)] = loc3;
                loc3 = loc3.next;
            }
            loc1.reverse();
            this.head = loc4 = loc1[0];
            loc3 = loc4;
            loc2 = 1;
            while (loc2 < this._count) 
            {
                loc3.next = loc4 = loc1[loc2];
                loc3 = loc4;
                ++loc2;
            }
            loc3.next = null;
            this.tail = loc3;
            loc1 = null;
            return;
        }

        public function join(arg1:*):String
        {
            if (this._count == 0)
            {
                return "";
            }
            var loc1:*;
            loc1 = "";
            var loc2:*;
            loc2 = this.head;
            while (loc2.next) 
            {
                loc1 = loc1 + loc2.data + arg1;
                loc2 = loc2.next;
            }
            loc1 = loc1 + loc2.data;
            return loc1;
        }

        public function contains(arg1:*):Boolean
        {
            var loc1:*;
            loc1 = this.head;
            while (loc1) 
            {
                if (loc1.data == arg1)
                {
                    return true;
                }
                loc1 = loc1.next;
            }
            return false;
        }

        public function clear():void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = this.head;
            this.head = null;
            while (loc1) 
            {
                loc2 = loc1.next;
                loc1.next = null;
                loc1 = loc2;
            }
            this._count = 0;
            return;
        }

        public function getIterator():de.polygonal.ds.Iterator
        {
            return new de.polygonal.ds.SListIterator(this, this.head);
        }

        public function getListIterator():de.polygonal.ds.SListIterator
        {
            return new de.polygonal.ds.SListIterator(this, this.head);
        }

        public function get size():int
        {
            return this._count;
        }

        public function isEmpty():Boolean
        {
            return this._count == 0;
        }

        public function toArray():Array
        {
            var loc1:*;
            loc1 = [];
            var loc2:*;
            loc2 = this.head;
            while (loc2) 
            {
                loc1.push(loc2.data);
                loc2 = loc2.next;
            }
            return loc1;
        }

        public function toString():String
        {
            return "[SlinkedList, size=" + this.size + "]";
        }

        public function dump():String
        {
            if (!this.head)
            {
                return "SLinkedList: (empty)";
            }
            var loc1:*;
            loc1 = "SLinkedList: has " + this._count + " node" + (this._count != 1 ? "s" : "") + "\n|< Head\n";
            var loc2:*;
            loc2 = this.getListIterator();
            while (loc2.valid()) 
            {
                loc1 = loc1 + "\t" + loc2.data + "\n";
                loc2.forth();
            }
            loc1 = loc1 + "Tail >|";
            return loc1;
        }

        public static const INSERTION_SORT:int=1 << 1;

        public static const MERGE_SORT:int=1 << 2;

        public static const NUMERIC:int=1 << 3;

        public static const DESCENDING:int=1 << 4;

        private var _count:int;

        public var head:de.polygonal.ds.SListNode;

        public var tail:de.polygonal.ds.SListNode;
    }
}
