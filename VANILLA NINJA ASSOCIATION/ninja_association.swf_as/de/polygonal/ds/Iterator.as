package de.polygonal.ds 
{
    public interface Iterator
    {
        function next():*;

        function hasNext():Boolean;

        function start():void;

        function get data():*;

        function set data(arg1:*):void;
    }
}
