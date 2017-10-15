package br.com.stimuli.loading.loadingtypes 
{
    import br.com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class LoadingItem extends flash.events.EventDispatcher
    {
        public function LoadingItem(arg1:flash.net.URLRequest, arg2:String, arg3:String)
        {
            super();
            this._type = arg2;
            this.url = arg1;
            if (!this.specificAvailableProps)
            {
                this.specificAvailableProps = [];
            }
            this._uid = arg3;
            return;
        }

        public function _parseOptions(arg1:Object):Array
        {
            var loc2:*;
            loc2 = null;
            this.preventCache = arg1[br.com.stimuli.loading.BulkLoader.PREVENT_CACHING];
            this._id = arg1[br.com.stimuli.loading.BulkLoader.ID];
            this._priority = int(arg1[br.com.stimuli.loading.BulkLoader.PRIORITY]) || 0;
            this.maxTries = arg1[br.com.stimuli.loading.BulkLoader.MAX_TRIES] || 3;
            this.weight = int(arg1[br.com.stimuli.loading.BulkLoader.WEIGHT]) || 1;
            var loc1:*;
            loc1 = br.com.stimuli.loading.BulkLoader.GENERAL_AVAILABLE_PROPS.concat(this.specificAvailableProps);
            this.propertyParsingErrors = [];
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = arg1;
            for (loc2 in loc4)
            {
                if (loc1.indexOf(loc2) != -1)
                {
                    continue;
                }
                this.propertyParsingErrors.push(this + ": got a wrong property name: " + loc2 + ", with value:" + arg1[loc2]);
            }
            return this.propertyParsingErrors;
        }

        public function get content():*
        {
            return this._content;
        }

        public function load():void
        {
            this._isLoading = true;
            this._startTime = flash.utils.getTimer();
            return;
        }

        public function onHttpStatusHandler(arg1:flash.events.HTTPStatusEvent):void
        {
            this._httpStatus = arg1.status;
            dispatchEvent(arg1);
            return;
        }

        public function onProgressHandler(arg1:*):void
        {
            this._bytesLoaded = arg1.bytesLoaded;
            this._bytesTotal = arg1.bytesTotal;
            this._bytesRemaining = this._bytesTotal - this.bytesLoaded;
            this._percentLoaded = this._bytesLoaded / this._bytesTotal;
            this._weightPercentLoaded = this._percentLoaded * this.weight;
            dispatchEvent(arg1);
            return;
        }

        public function onCompleteHandler(arg1:flash.events.Event):void
        {
            this._totalTime = flash.utils.getTimer();
            this._timeToDownload = (this._totalTime - this._responseTime) / 1000;
            if (this._timeToDownload == 0)
            {
                this._timeToDownload = 0.2;
            }
            this._speed = br.com.stimuli.loading.BulkLoader.truncateNumber(this.bytesTotal / 1024 / this._timeToDownload);
            if (this._timeToDownload == 0)
            {
                this._speed = 3000;
            }
            this.status = STATUS_FINISHED;
            this._isLoaded = true;
            dispatchEvent(arg1);
            arg1.stopPropagation();
            return;
        }

        public function onErrorHandler(arg1:flash.events.Event):void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).numTries + 1);
            loc2.numTries = loc3;
            this.status = STATUS_ERROR;
            arg1.stopPropagation();
            if (this.numTries >= this.maxTries)
            {
                loc1 = new br.com.stimuli.loading.BulkErrorEvent(br.com.stimuli.loading.BulkErrorEvent.ERROR);
                loc1.errors = [this];
                dispatchEvent(loc1);
            }
            else 
            {
                this.status = null;
                this.load();
            }
            return;
        }

        public function onStartedHandler(arg1:flash.events.Event):void
        {
            this._responseTime = flash.utils.getTimer();
            this._latency = br.com.stimuli.loading.BulkLoader.truncateNumber((this._responseTime - this._startTime) / 1000);
            this.status = STATUS_STARTED;
            dispatchEvent(arg1);
            return;
        }

        public override function toString():String
        {
            return "LoadingItem url: " + this.url.url + ", type:" + this._type + ", status: " + this.status;
        }

        public function stop():void
        {
            if (this._isLoaded)
            {
                return;
            }
            this.status = STATUS_STOPPED;
            this._isLoading = false;
            return;
        }

        public function cleanListeners():void
        {
            return;
        }

        public function isVideo():Boolean
        {
            return false;
        }

        public function isSound():Boolean
        {
            return false;
        }

        public function isText():Boolean
        {
            return false;
        }

        public function isXML():Boolean
        {
            return false;
        }

        public function isImage():Boolean
        {
            return false;
        }

        public function isSWF():Boolean
        {
            return false;
        }

        public function isLoader():Boolean
        {
            return false;
        }

        public function isStreamable():Boolean
        {
            return false;
        }

        public function destroy():void
        {
            this._content = null;
            return;
        }

        public function get bytesTotal():int
        {
            return this._bytesTotal;
        }

        public function get bytesLoaded():int
        {
            return this._bytesLoaded;
        }

        public function get bytesRemaining():int
        {
            return this._bytesRemaining;
        }

        public function get percentLoaded():Number
        {
            return this._percentLoaded;
        }

        public function get weightPercentLoaded():Number
        {
            return this._weightPercentLoaded;
        }

        public function get priority():int
        {
            return this._priority;
        }

        public function get type():String
        {
            return this._type;
        }

        public function get isLoaded():Boolean
        {
            return this._isLoaded;
        }

        public function get addedTime():int
        {
            return this._addedTime;
        }

        public function get startTime():int
        {
            return this._startTime;
        }

        public function get responseTime():Number
        {
            return this._responseTime;
        }

        public function get latency():Number
        {
            return this._latency;
        }

        public function get totalTime():int
        {
            return this._totalTime;
        }

        public function get timeToDownload():int
        {
            return this._timeToDownload;
        }

        public function get speed():Number
        {
            return this._speed;
        }

        public function get httpStatus():int
        {
            return this._httpStatus;
        }

        public function get id():String
        {
            return this._id;
        }

        public function getStats():String
        {
            return "Item url:" + this.url.url + ", total time: " + this._timeToDownload + "(s), latency:" + this._latency + "(s), speed: " + this._speed + " kb/s, size: " + br.com.stimuli.loading.BulkLoader.truncateNumber(this._bytesTotal / 1024) + " kb";
        }

        public static const STATUS_STOPPED:String="stopped";

        public static const STATUS_STARTED:String="started";

        public static const STATUS_FINISHED:String="finished";

        public static const STATUS_ERROR:String="error";

        public var _type:String;

        public var url:flash.net.URLRequest;

        public var _id:String;

        public var _uid:String;

        public var _additionIndex:int;

        public var _priority:int=0;

        public var _isLoaded:Boolean;

        public var _isLoading:Boolean;

        public var status:String;

        public var maxTries:int=3;

        public var numTries:int=0;

        public var weight:int=1;

        public var preventCache:Boolean;

        public var _bytesTotal:int=-1;

        public var _bytesLoaded:int=0;

        public var _bytesRemaining:int=10000000;

        public var _percentLoaded:Number;

        public var _weightPercentLoaded:Number;

        public var _addedTime:int;

        public var _startTime:int;

        public var _responseTime:Number;

        public var _latency:Number;

        public var _totalTime:int;

        public var _timeToDownload:int;

        public var _speed:Number;

        public var _content:*;

        public var _httpStatus:int=-1;

        public var context:*=null;

        public var specificAvailableProps:Array;

        public var propertyParsingErrors:Array;
    }
}
