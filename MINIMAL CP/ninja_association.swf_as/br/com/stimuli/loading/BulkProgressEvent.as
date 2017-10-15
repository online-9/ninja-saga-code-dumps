package br.com.stimuli.loading 
{
    import flash.events.*;
    
    public class BulkProgressEvent extends flash.events.ProgressEvent
    {
        public function BulkProgressEvent(arg1:String, arg2:Boolean=true, arg3:Boolean=false)
        {
            super(arg1, arg2, arg3);
            this.name = arg1;
            return;
        }

        public function setInfo(arg1:int, arg2:int, arg3:int, arg4:int, arg5:int, arg6:Number):void
        {
            this.bytesLoaded = arg1;
            this.bytesTotal = arg2;
            this.bytesTotalCurrent = arg3;
            this.itemsLoaded = arg4;
            this.itemsTotal = arg5;
            this.weightPercent = arg6;
            this.percentLoaded = arg2 > 0 ? arg1 / arg2 : 0;
            this.ratioLoaded = arg5 != 0 ? arg4 / arg5 : 0;
            return;
        }

        public override function clone():flash.events.Event
        {
            var loc1:*;
            loc1 = new br.com.stimuli.loading.BulkProgressEvent(this.name, bubbles, cancelable);
            loc1.setInfo(bytesLoaded, bytesTotal, this.bytesTotalCurrent, this.itemsLoaded, this.itemsTotal, this.weightPercent);
            return loc1;
        }

        public function loadingStatus():String
        {
            var loc1:*;
            loc1 = [];
            loc1.push("bytesLoaded: " + bytesLoaded);
            loc1.push("bytesTotal: " + bytesTotal);
            loc1.push("itemsLoaded: " + this.itemsLoaded);
            loc1.push("itemsTotal: " + this.itemsTotal);
            loc1.push("bytesTotalCurrent: " + this.bytesTotalCurrent);
            loc1.push("percentLoaded: " + br.com.stimuli.loading.BulkLoader.truncateNumber(this.percentLoaded));
            loc1.push("weightPercent: " + br.com.stimuli.loading.BulkLoader.truncateNumber(this.weightPercent));
            loc1.push("ratioLoaded: " + br.com.stimuli.loading.BulkLoader.truncateNumber(this.ratioLoaded));
            return "BulkProgressEvent " + loc1.join(", ") + ";";
        }

        public function get weightPercent():Number
        {
            return this._weightPercent;
        }

        public function set weightPercent(arg1:Number):void
        {
            if (isNaN(arg1) || !isFinite(arg1))
            {
                arg1 = 0;
            }
            this._weightPercent = arg1;
            return;
        }

        public function get percentLoaded():Number
        {
            return this._percentLoaded;
        }

        public function set percentLoaded(arg1:Number):void
        {
            if (isNaN(arg1) || !isFinite(arg1))
            {
                arg1 = 0;
            }
            this._percentLoaded = arg1;
            return;
        }

        public function get ratioLoaded():Number
        {
            return this._ratioLoaded;
        }

        public function set ratioLoaded(arg1:Number):void
        {
            if (isNaN(arg1) || !isFinite(arg1))
            {
                arg1 = 0;
            }
            this._ratioLoaded = arg1;
            return;
        }

        public override function toString():String
        {
            return super.toString();
        }

        public static const PROGRESS:String="progress";

        public static const COMPLETE:String="complete";

        public var bytesTotalCurrent:int;

        public var _ratioLoaded:Number;

        public var _percentLoaded:Number;

        public var _weightPercent:Number;

        public var itemsLoaded:int;

        public var itemsTotal:int;

        public var name:String;
    }
}
