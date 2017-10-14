package br.com.stimuli.loading.loadingtypes
{
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import br.com.stimuli.loading.BulkLoader;
   import flash.utils.getTimer;
   import flash.events.HTTPStatusEvent;
   import flash.events.Event;
   import br.com.stimuli.loading.BulkErrorEvent;
   
   public class LoadingItem extends EventDispatcher
   {
      
      public static const STATUS_STOPPED:String = "stopped";
      
      public static const STATUS_STARTED:String = "started";
      
      public static const STATUS_FINISHED:String = "finished";
      
      public static const STATUS_ERROR:String = "error";
       
      
      public var _type:String;
      
      public var url:URLRequest;
      
      public var _id:String;
      
      public var _uid:String;
      
      public var _additionIndex:int;
      
      public var _priority:int = 0;
      
      public var _isLoaded:Boolean;
      
      public var _isLoading:Boolean;
      
      public var status:String;
      
      public var maxTries:int = 3;
      
      public var numTries:int = 0;
      
      public var weight:int = 1;
      
      public var preventCache:Boolean;
      
      public var _bytesTotal:int = -1;
      
      public var _bytesLoaded:int = 0;
      
      public var _bytesRemaining:int = 10000000;
      
      public var _percentLoaded:Number;
      
      public var _weightPercentLoaded:Number;
      
      public var _addedTime:int;
      
      public var _startTime:int;
      
      public var _responseTime:Number;
      
      public var _latency:Number;
      
      public var _totalTime:int;
      
      public var _timeToDownload:int;
      
      public var _speed:Number;
      
      public var _content;
      
      public var _httpStatus:int = -1;
      
      public var context = null;
      
      public var specificAvailableProps:Array;
      
      public var propertyParsingErrors:Array;
      
      public function LoadingItem(url:URLRequest, type:String, _uid:String)
      {
         super();
         this._type = type;
         this.url = url;
         if(!specificAvailableProps)
         {
            specificAvailableProps = [];
         }
         this._uid = _uid;
      }
      
      public function _parseOptions(props:Object) : Array
      {
         var propName:* = null;
         preventCache = props[BulkLoader.PREVENT_CACHING];
         _id = props[BulkLoader.ID];
         _priority = int(int(props[BulkLoader.PRIORITY])) || 0;
         maxTries = int(props[BulkLoader.MAX_TRIES]) || 3;
         weight = int(int(props[BulkLoader.WEIGHT])) || 1;
         var allowedProps:Array = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(specificAvailableProps);
         propertyParsingErrors = [];
         for(propName in props)
         {
            if(allowedProps.indexOf(propName) == -1)
            {
               propertyParsingErrors.push(this + ": got a wrong property name: " + propName + ", with value:" + props[propName]);
            }
         }
         return propertyParsingErrors;
      }
      
      public function get content() : *
      {
         return _content;
      }
      
      public function load() : void
      {
         _isLoading = true;
         _startTime = getTimer();
      }
      
      public function onHttpStatusHandler(evt:HTTPStatusEvent) : void
      {
         _httpStatus = evt.status;
         dispatchEvent(evt);
      }
      
      public function onProgressHandler(evt:*) : void
      {
         _bytesLoaded = evt.bytesLoaded;
         _bytesTotal = evt.bytesTotal;
         _bytesRemaining = _bytesTotal - bytesLoaded;
         _percentLoaded = _bytesLoaded / _bytesTotal;
         _weightPercentLoaded = _percentLoaded * weight;
         dispatchEvent(evt);
      }
      
      public function onCompleteHandler(evt:Event) : void
      {
         _totalTime = getTimer();
         _timeToDownload = (_totalTime - _responseTime) / 1000;
         if(_timeToDownload == 0)
         {
            _timeToDownload = 0.2;
         }
         _speed = BulkLoader.truncateNumber(bytesTotal / 1024 / _timeToDownload);
         if(_timeToDownload == 0)
         {
            _speed = 3000;
         }
         status = STATUS_FINISHED;
         _isLoaded = true;
         dispatchEvent(evt);
         evt.stopPropagation();
      }
      
      public function onErrorHandler(evt:Event) : void
      {
         var bulkErrorEvent:BulkErrorEvent = null;
         numTries++;
         status = STATUS_ERROR;
         evt.stopPropagation();
         if(numTries >= maxTries)
         {
            bulkErrorEvent = new BulkErrorEvent(BulkErrorEvent.ERROR);
            bulkErrorEvent.errors = [this];
            dispatchEvent(bulkErrorEvent);
         }
         else
         {
            status = null;
            load();
         }
      }
      
      public function onStartedHandler(evt:Event) : void
      {
         _responseTime = getTimer();
         _latency = BulkLoader.truncateNumber((_responseTime - _startTime) / 1000);
         status = STATUS_STARTED;
         dispatchEvent(evt);
      }
      
      override public function toString() : String
      {
         return "LoadingItem url: " + url.url + ", type:" + _type + ", status: " + status;
      }
      
      public function stop() : void
      {
         if(_isLoaded)
         {
            return;
         }
         status = STATUS_STOPPED;
         _isLoading = false;
      }
      
      public function cleanListeners() : void
      {
      }
      
      public function isVideo() : Boolean
      {
         return false;
      }
      
      public function isSound() : Boolean
      {
         return false;
      }
      
      public function isText() : Boolean
      {
         return false;
      }
      
      public function isXML() : Boolean
      {
         return false;
      }
      
      public function isImage() : Boolean
      {
         return false;
      }
      
      public function isSWF() : Boolean
      {
         return false;
      }
      
      public function isLoader() : Boolean
      {
         return false;
      }
      
      public function isStreamable() : Boolean
      {
         return false;
      }
      
      public function destroy() : void
      {
         _content = null;
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      public function get bytesRemaining() : int
      {
         return _bytesRemaining;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get weightPercentLoaded() : Number
      {
         return _weightPercentLoaded;
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function get isLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      public function get addedTime() : int
      {
         return _addedTime;
      }
      
      public function get startTime() : int
      {
         return _startTime;
      }
      
      public function get responseTime() : Number
      {
         return _responseTime;
      }
      
      public function get latency() : Number
      {
         return _latency;
      }
      
      public function get totalTime() : int
      {
         return _totalTime;
      }
      
      public function get timeToDownload() : int
      {
         return _timeToDownload;
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      public function get httpStatus() : int
      {
         return _httpStatus;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function getStats() : String
      {
         return "Item url:" + url.url + ", total time: " + _timeToDownload + "(s), latency:" + _latency + "(s), speed: " + _speed + " kb/s, size: " + BulkLoader.truncateNumber(_bytesTotal / 1024) + " kb";
      }
   }
}
