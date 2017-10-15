package de.polygonal.ds 
{
    public interface Collection
    {
        function contains(arg1:*):Boolean;

        function clear():void;

        function getIterator():de.polygonal.ds.Iterator;

        function get size():int;

        function isEmpty():Boolean;

        function toArray():Array;
    }
}
