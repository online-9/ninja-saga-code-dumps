package br.com.stimuli.loading 
{
    import flash.events.*;
    
    public class BulkErrorEvent extends flash.events.Event
    {
        public function BulkErrorEvent(arg1:String, arg2:Boolean=true, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            this.name = arg1;
            return;
        }

        public override function clone():flash.events.Event
        {
            var loc1:*;
            loc1 = new br.com.stimuli.loading.BulkErrorEvent(this.name, bubbles, cancelable);
            loc1.errors = this.errors ? this.errors.slice() : [];
            return loc1;
        }

        public override function toString():String
        {
            return super.toString();
        }

        public static const ERROR:String="error";

        public var name:String;

        public var errors:Array;
    }
}
