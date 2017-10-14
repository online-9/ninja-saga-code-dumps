package br.com.stimuli.loading
{
   import flash.events.EventDispatcher;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   import br.com.stimuli.loading.loadingtypes.XMLItem;
   import br.com.stimuli.loading.loadingtypes.VideoItem;
   import br.com.stimuli.loading.loadingtypes.SoundItem;
   import br.com.stimuli.loading.loadingtypes.URLItem;
   import flash.utils.Dictionary;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.AVM1Movie;
   import flash.net.NetStream;
   import flash.display.BitmapData;
   
   public class BulkLoader extends EventDispatcher
   {
      
      public static const VERSION:String = "rev 196 (0.9.9.4)";
      
      public static const TYPE_IMAGE:String = "image";
      
      public static const TYPE_MOVIECLIP:String = "movieclip";
      
      public static const TYPE_SOUND:String = "sound";
      
      public static const TYPE_TEXT:String = "text";
      
      public static const TYPE_XML:String = "xml";
      
      public static const TYPE_VIDEO:String = "video";
      
      public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO,TYPE_XML,TYPE_TEXT,TYPE_SOUND,TYPE_MOVIECLIP,TYPE_IMAGE];
      
      public static var AVAILABLE_EXTENSIONS:Array = ["swf","jpg","jpeg","gif","png","flv","mp3","xml","txt","js"];
      
      public static var IMAGE_EXTENSIONS:Array = ["jpg","jpeg","gif","png"];
      
      public static var MOVIECLIP_EXTENSIONS:Array = ["swf"];
      
      public static var TEXT_EXTENSIONS:Array = ["txt","js","php","asp","py"];
      
      public static var VIDEO_EXTENSIONS:Array = ["flv","f4v","f4p"];
      
      public static var SOUND_EXTENSIONS:Array = ["mp3","f4a","f4b"];
      
      public static var XML_EXTENSIONS:Array = ["xml"];
      
      public static var _customTypesExtensions:Object;
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
      
      public static const HTTP_STATUS:String = "httpStatus";
      
      public static const ERROR:String = "error";
      
      public static const OPEN:String = "open";
      
      public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
      
      public static const CHECK_POLICY_FILE:String = "checkPolicyFile";
      
      public static const PREVENT_CACHING:String = "preventCache";
      
      public static const HEADERS:String = "headers";
      
      public static const CONTEXT:String = "context";
      
      public static const ID:String = "id";
      
      public static const PRIORITY:String = "priority";
      
      public static const MAX_TRIES:String = "maxTries";
      
      public static const WEIGHT:String = "weight";
      
      public static const PAUSED_AT_START:String = "pausedAtStart";
      
      public static const GENERAL_AVAILABLE_PROPS:Array = [WEIGHT,MAX_TRIES,HEADERS,ID,PRIORITY,PREVENT_CACHING,"type"];
      
      public static var _instancesCreated:int = 0;
      
      public static var _allLoaders:Object = {};
      
      public static const DEFAULT_NUM_CONNECTIONS:int = 7;
      
      public static const LOG_VERBOSE:int = 0;
      
      public static const LOG_INFO:int = 2;
      
      public static const LOG_WARNINGS:int = 3;
      
      public static const LOG_ERRORS:int = 4;
      
      public static const LOG_SILENT:int = 10;
      
      public static const DEFAULT_LOG_LEVEL:int = 20;
      
      public static var _typeClasses:Object = {
         "image":ImageItem,
         "movieclip":ImageItem,
         "xml":XMLItem,
         "video":VideoItem,
         "sound":SoundItem,
         "text":URLItem
      };
       
      
      public var _name:String;
      
      public var _id:int;
      
      public var _items:Array;
      
      public var _contents:Dictionary;
      
      public var _additionIndex:int = 0;
      
      public var _numConnections:int = 7;
      
      public var _connections:Array;
      
      public var _loadedRatio:Number = 0;
      
      public var _itemsTotal:int = 0;
      
      public var _itemsLoaded:int = 0;
      
      public var _totalWeight:int = 0;
      
      public var _bytesTotal:int = 0;
      
      public var _bytesTotalCurrent:int = 0;
      
      public var _bytesLoaded:int = 0;
      
      public var _percentLoaded:Number = 0;
      
      public var _weightPercent:Number;
      
      public var avgLatency:Number;
      
      public var speedAvg:Number;
      
      public var _speedTotal:Number;
      
      public var _startTime:int;
      
      public var _endTIme:int;
      
      public var _lastSpeedCheck:int;
      
      public var _lastBytesCheck:int;
      
      public var _speed:Number;
      
      public var totalTime:Number;
      
      public var logLevel:int = 20;
      
      public var _allowsAutoIDFromFileName:Boolean = false;
      
      public var _isRunning:Boolean;
      
      public var _isFinished:Boolean;
      
      public var _isPaused:Boolean = true;
      
      public var _logFunction:Function;
      
      public var _stringSubstitutions:Object;
      
      public function BulkLoader(name:String, numConnections:int = 7, logLevel:int = 20)
      {
         _items = [];
         _contents = new Dictionary();
         _logFunction = trace;
         super();
         if(Boolean(_allLoaders[name]))
         {
            __debug_print_loaders();
            throw new Error("BulkLoader with name\'" + name + "\' has already been created.");
         }
         if(!name)
         {
            throw new Error("Cannot create a BulkLoader instance without a name");
         }
         _allLoaders[name] = this;
         if(numConnections > 0)
         {
            this._numConnections = numConnections;
         }
         this.logLevel = logLevel;
         _name = name;
         _instancesCreated++;
         _id = _instancesCreated;
         _additionIndex = 0;
      }
      
      public static function createUniqueNamedLoader(numConnections:int = 7, logLevel:int = 20) : BulkLoader
      {
         return new BulkLoader(BulkLoader.getUniqueName(),numConnections,logLevel);
      }
      
      public static function getUniqueName() : String
      {
         return "BulkLoader-" + _instancesCreated;
      }
      
      public static function getLoader(name:String) : BulkLoader
      {
         return BulkLoader._allLoaders[name] as BulkLoader;
      }
      
      public static function _hasItemInBulkLoader(key:*, atLoader:BulkLoader) : Boolean
      {
         var item:LoadingItem = atLoader.get(key);
         if(item && item._isLoaded)
         {
            return true;
         }
         return false;
      }
      
      public static function whichLoaderHasItem(key:*) : BulkLoader
      {
         var l:BulkLoader = null;
         for each(l in _allLoaders)
         {
            if(BulkLoader._hasItemInBulkLoader(key,l))
            {
               return l;
            }
         }
         return null;
      }
      
      public static function registerNewType(extension:String, atType:String, withClass:Class) : Boolean
      {
         var extensions:Array = null;
         if(extension.charAt(0) == ".")
         {
            extension = extension.substring(1);
         }
         if(AVAILABLE_TYPES.indexOf(atType) == -1)
         {
            if(!Boolean(withClass) || !(withClass is LoadingItem))
            {
               throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
            }
            _typeClasses[atType] = withClass;
            if(!_customTypesExtensions[atType])
            {
               _customTypesExtensions[atType] = [];
               AVAILABLE_TYPES.push(atType);
            }
            _customTypesExtensions[atType].push(extension);
            return true;
         }
         var options:Object = {
            "IMAGE_EXTENSIONS":TYPE_IMAGE,
            "VIDEO_EXTENSIONS":TYPE_VIDEO,
            "SOUND_EXTENSIONS":TYPE_SOUND,
            "TEXT_EXTENSIONS":TYPE_TEXT
         };
         extensions = options[atType];
         if(extensions && extensions.indexOf(extension) == -1)
         {
            extensions.push(extension);
            return true;
         }
         return false;
      }
      
      public static function removeAllLoaders() : void
      {
         var atLoader:BulkLoader = null;
         for each(atLoader in _allLoaders)
         {
            atLoader.removeAll();
            atLoader.clear();
            atLoader = null;
         }
         _allLoaders = {};
      }
      
      public static function pauseAllLoaders() : void
      {
         var atLoader:BulkLoader = null;
         for each(atLoader in _allLoaders)
         {
            atLoader.pauseAll();
         }
      }
      
      public static function truncateNumber(raw:Number, decimals:int = 2) : Number
      {
         var power:int = Math.pow(10,decimals);
         return Math.round(raw * power) / power;
      }
      
      public static function guessType(urlAsString:String) : String
      {
         var type:String = null;
         var checkType:* = null;
         var checkExt:String = null;
         var searchString:String = urlAsString.indexOf("?") > -1?urlAsString.substring(0,urlAsString.indexOf("?")):urlAsString;
         var extension:String = searchString.substring(searchString.lastIndexOf(".") + 1).toLowerCase();
         if(!Boolean(extension))
         {
            extension = BulkLoader.TYPE_TEXT;
         }
         if(extension == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_IMAGE;
         }
         else if(extension == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_SOUND;
         }
         else if(extension == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_VIDEO;
         }
         else if(extension == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_XML;
         }
         else if(extension == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_MOVIECLIP;
         }
         else
         {
            for(checkType in _customTypesExtensions)
            {
               for each(checkExt in _customTypesExtensions[checkType])
               {
                  if(checkExt == extension)
                  {
                     type = checkType;
                     break;
                  }
                  if(type)
                  {
                     break;
                  }
               }
            }
            if(!type)
            {
               type = BulkLoader.TYPE_TEXT;
            }
         }
         return type;
      }
      
      public static function substituteURLString(raw:String, substitutions:Object) : String
      {
         var lastMatch:Object = null;
         var match:Object = null;
         var subs:String = null;
         if(!substitutions)
         {
            return raw;
         }
         var subRegex:RegExp = /(?P<var_name>\{\s*[^\}]*\})/g;
         var result:Object = subRegex.exec(raw);
         var var_name:String = !!result?result.var_name:null;
         var matches:Array = [];
         var numRuns:int = 0;
         while(Boolean(result) && Boolean(result.var_name))
         {
            if(result.var_name)
            {
               var_name = result.var_name;
               var_name = var_name.replace("{","");
               var_name = var_name.replace("}","");
               var_name = var_name.replace(/\s*/g,"");
            }
            matches.push({
               "start":result.index,
               "end":result.index + result.var_name.length,
               "changeTo":substitutions[var_name]
            });
            numRuns++;
            if(numRuns > 400)
            {
               break;
            }
            result = subRegex.exec(raw);
            var_name = !!result?result.var_name:null;
         }
         if(matches.length == 0)
         {
            return raw;
         }
         var buffer:Array = [];
         var previous:String = raw.substr(0,matches[0].start);
         for each(match in matches)
         {
            if(lastMatch)
            {
               previous = raw.substring(lastMatch.end,match.start);
            }
            buffer.push(previous);
            buffer.push(match.changeTo);
            lastMatch = match;
         }
         buffer.push(raw.substring(match.end));
         return buffer.join("");
      }
      
      public static function getFileName(text:String) : String
      {
         if(text.lastIndexOf("/") == text.length - 1)
         {
            return getFileName(text.substring(0,text.length - 1));
         }
         var startAt:int = text.lastIndexOf("/") + 1;
         var croppedString:String = text.substring(startAt);
         var lastIndex:int = croppedString.indexOf(".");
         if(lastIndex == -1)
         {
            if(croppedString.indexOf("?") > -1)
            {
               lastIndex = croppedString.indexOf("?");
            }
            else
            {
               lastIndex = croppedString.length;
            }
         }
         var finalPath:String = croppedString.substring(0,lastIndex);
         return finalPath;
      }
      
      public static function __debug_print_loaders() : void
      {
         var instNames:String = null;
         var theNames:Array = [];
         for each(instNames in BulkLoader._allLoaders)
         {
            theNames.push(instNames);
         }
         theNames.sort();
         trace("All loaders");
         theNames.forEach(function(item:*, ... rest):void
         {
            trace("\t",item);
         });
         trace("===========");
      }
      
      public static function __debug_print_num_loaders() : void
      {
         var instNames:String = null;
         var num:int = 0;
         for each(instNames in BulkLoader._allLoaders)
         {
            num++;
         }
         trace("BulkLoader has ",num,"instances");
      }
      
      public static function __debug_printStackTrace() : void
      {
         try
         {
            throw new Error("stack trace");
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      public function hasItem(key:*, searchAll:Boolean = true) : Boolean
      {
         var loaders:* = undefined;
         var l:BulkLoader = null;
         if(searchAll)
         {
            loaders = _allLoaders;
         }
         else
         {
            loaders = [this];
         }
         for each(l in loaders)
         {
            if(_hasItemInBulkLoader(key,l))
            {
               return true;
            }
         }
         return false;
      }
      
      public function add(url:*, props:Object = null) : LoadingItem
      {
         var type:String = null;
         var error:String = null;
         if(!_name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         if(!url || !String(url))
         {
            throw new Error("[BulkLoader] Cannot add an item with a null url");
         }
         props = props || {};
         if(url is String)
         {
            url = new URLRequest(BulkLoader.substituteURLString(url,_stringSubstitutions));
            if(props[HEADERS])
            {
               url.requestHeaders = props[HEADERS];
            }
         }
         else if(!url is URLRequest)
         {
            throw new Error("[BulkLoader] cannot add object with bad type for url:\'" + url.url);
         }
         var item:LoadingItem = get(props[ID]);
         if(item)
         {
            log("Add received an already added id: " + props[ID] + ", not adding a new item");
            return item;
         }
         if(props["type"])
         {
            type = props["type"].toLowerCase();
            if(AVAILABLE_TYPES.indexOf(type) == -1)
            {
               log("add received an unknown type:",type,"and will cast it to text",LOG_WARNINGS);
            }
         }
         if(!type)
         {
            type = guessType(url.url);
         }
         _additionIndex++;
         item = new _typeClasses[type](url,type,_instancesCreated + "_" + String(_additionIndex));
         if(!props["id"] && _allowsAutoIDFromFileName)
         {
            props["id"] = getFileName(url.url);
            log("Adding automatic id from file name for item:",item,"( id= " + props["id"] + " )");
         }
         var errors:Array = item._parseOptions(props);
         for each(error in errors)
         {
            log(error,LOG_WARNINGS);
         }
         log("Added",item,LOG_VERBOSE);
         item._addedTime = getTimer();
         item._additionIndex = _additionIndex;
         item.addEventListener(Event.COMPLETE,_onItemComplete,false,int.MIN_VALUE,true);
         item.addEventListener(ERROR,_onItemError,false,0,true);
         item.addEventListener(Event.OPEN,_onItemStarted,false,0,true);
         item.addEventListener(ProgressEvent.PROGRESS,_onProgress,false,0,true);
         _items.push(item);
         _itemsTotal = _itemsTotal + 1;
         _totalWeight = _totalWeight + item.weight;
         sortItemsByPriority();
         _isFinished = false;
         if(!_isPaused)
         {
            _loadNext();
         }
         return item;
      }
      
      public function start(withConnections:int = -1) : void
      {
         if(withConnections > 0)
         {
            _numConnections = withConnections;
         }
         if(_connections)
         {
            _loadNext();
            return;
         }
         _startTime = getTimer();
         _connections = [];
         _loadNext();
         _isRunning = true;
         _lastBytesCheck = 0;
         _lastSpeedCheck = getTimer();
         _isPaused = false;
      }
      
      public function reload(key:*) : Boolean
      {
         var item:LoadingItem = null;
         if(key is LoadingItem)
         {
            item = key;
         }
         else
         {
            item = get(key);
         }
         if(!item)
         {
            return false;
         }
         _removeFromItems(item);
         _removeFromConnections(item);
         item.stop();
         item.cleanListeners();
         item.status = null;
         _isFinished = false;
         item._addedTime = getTimer();
         item._additionIndex = _additionIndex++;
         item.addEventListener(Event.COMPLETE,_onItemComplete,false,int.MIN_VALUE,true);
         item.addEventListener(ERROR,_onItemError,false,0,true);
         item.addEventListener(Event.OPEN,_onItemStarted,false,0,true);
         item.addEventListener(ProgressEvent.PROGRESS,_onProgress,false,0,true);
         _items.push(item);
         _itemsTotal = _itemsTotal + 1;
         _totalWeight = _totalWeight + item.weight;
         sortItemsByPriority();
         _isFinished = false;
         loadNow(item);
         return true;
      }
      
      public function loadNow(key:*) : Boolean
      {
         var item:LoadingItem = null;
         var itemToRemove:LoadingItem = null;
         if(key is LoadingItem)
         {
            item = key;
         }
         else
         {
            item = get(key);
         }
         if(!item)
         {
            return false;
         }
         if(!_connections)
         {
            _connections = [];
         }
         if(item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STARTED)
         {
            return true;
         }
         if(_connections.length >= numConnections)
         {
            itemToRemove = _getLeastUrgentOpenedItem();
            _removeFromConnections(itemToRemove);
            itemToRemove.status = null;
         }
         item._priority = highestPriority;
         _loadNext(item);
         return true;
      }
      
      public function _getLeastUrgentOpenedItem() : LoadingItem
      {
         var toRemove:LoadingItem = LoadingItem(_connections.sortOn(["priority","bytesRemaining","_additionIndex"],[Array.NUMERIC,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC])[0]);
         return toRemove;
      }
      
      public function _loadNext(toLoad:LoadingItem = null) : Boolean
      {
         var checkItem:LoadingItem = null;
         if(_isFinished)
         {
            return false;
         }
         if(!_connections)
         {
            _connections = [];
         }
         _connections.forEach(function(i:LoadingItem, ... rest):void
         {
            if(i.status == LoadingItem.STATUS_ERROR && i.numTries < i.maxTries)
            {
               _removeFromConnections(i);
            }
         });
         var next:Boolean = false;
         if(!toLoad)
         {
            for each(checkItem in _items)
            {
               if(!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED)
               {
                  var toLoad:LoadingItem = checkItem;
                  break;
               }
            }
         }
         if(toLoad)
         {
            next = true;
            _isRunning = true;
            if(_connections.length < numConnections)
            {
               _connections.push(toLoad);
               toLoad.load();
               log("Will load item:",toLoad,LOG_INFO);
            }
            if(_connections.length < numConnections)
            {
               _loadNext();
            }
         }
         return next;
      }
      
      public function _onItemComplete(evt:Event) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         _removeFromConnections(item);
         log("Loaded ",item,LOG_INFO);
         log("Items to load",getNotLoadedItems(),LOG_VERBOSE);
         item.cleanListeners();
         _contents[item.url.url] = item.content;
         var next:Boolean = _loadNext();
         var allDone:Boolean = _isAllDoneP();
         _itemsLoaded++;
         if(allDone)
         {
            _onAllLoaded();
         }
      }
      
      public function _updateStats() : void
      {
         var item:LoadingItem = null;
         avgLatency = 0;
         speedAvg = 0;
         var totalLatency:Number = 0;
         var totalBytes:int = 0;
         _speedTotal = 0;
         var num:Number = 0;
         for each(item in _items)
         {
            if(item._isLoaded && item.status != LoadingItem.STATUS_ERROR)
            {
               totalLatency = totalLatency + item.latency;
               totalBytes = totalBytes + item.bytesTotal;
               num++;
            }
         }
         _speedTotal = totalBytes / 1024 / totalTime;
         avgLatency = totalLatency / num;
         speedAvg = _speedTotal / num;
      }
      
      public function _removeFromItems(item:LoadingItem) : Boolean
      {
         var removeIndex:int = _items.indexOf(item);
         if(removeIndex > -1)
         {
            _items.splice(removeIndex,1);
            if(item._isLoaded)
            {
               _itemsLoaded--;
            }
            _itemsTotal--;
            _totalWeight = _totalWeight - item.weight;
            log("Removing " + item,LOG_VERBOSE);
            return true;
         }
         return false;
      }
      
      public function _removeFromConnections(item:*) : Boolean
      {
         if(!_connections)
         {
            return false;
         }
         var removeIndex:int = _connections.indexOf(item);
         if(removeIndex > -1)
         {
            _connections.splice(removeIndex,1);
            return true;
         }
         return false;
      }
      
      public function _onItemError(evt:BulkErrorEvent) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         log("After " + item.numTries + " I am giving up on " + item.url.url,LOG_ERRORS);
         log("Error loading",item,LOG_ERRORS);
         _removeFromConnections(item);
         evt.stopPropagation();
         var bulkErrorEvent:BulkErrorEvent = new BulkErrorEvent(BulkErrorEvent.ERROR);
         bulkErrorEvent.errors = _items.filter(function(i:LoadingItem, ... rest):Boolean
         {
            return i.status == LoadingItem.STATUS_ERROR;
         });
         dispatchEvent(bulkErrorEvent);
      }
      
      public function _onItemStarted(evt:Event) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         log("Started loading",item,LOG_INFO);
         dispatchEvent(evt);
      }
      
      public function _onProgress(evt:Event = null) : void
      {
         var e:BulkProgressEvent = getProgressForItems(_items);
         _bytesLoaded = e.bytesLoaded;
         _bytesTotal = e.bytesTotal;
         _weightPercent = e.weightPercent;
         _percentLoaded = e.percentLoaded;
         _bytesTotalCurrent = e.bytesTotalCurrent;
         _loadedRatio = e.ratioLoaded;
         dispatchEvent(e);
      }
      
      public function getProgressForItems(keys:Array) : BulkProgressEvent
      {
         var item:LoadingItem = null;
         var key:* = undefined;
         _bytesLoaded = _bytesTotal = _bytesTotalCurrent = 0;
         var localWeightPercent:Number = 0;
         var localWeightTotal:int = 0;
         var itemsStarted:int = 0;
         var localWeightLoaded:Number = 0;
         var localItemsTotal:int = 0;
         var localItemsLoaded:int = 0;
         var localBytesLoaded:int = 0;
         var localBytesTotal:int = 0;
         var localBytesTotalCurrent:int = 0;
         var theseItems:Array = [];
         for each(key in keys)
         {
            item = key is LoadingItem?key:get(key);
            if(item)
            {
               localItemsTotal++;
               localWeightTotal = localWeightTotal + item.weight;
               if(item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED)
               {
                  localBytesLoaded = localBytesLoaded + item._bytesLoaded;
                  localBytesTotalCurrent = localBytesTotalCurrent + item._bytesTotal;
                  localWeightLoaded = localWeightLoaded + item._bytesLoaded / item._bytesTotal * item.weight;
                  if(item.status == LoadingItem.STATUS_FINISHED)
                  {
                     localItemsLoaded++;
                  }
                  itemsStarted++;
               }
            }
         }
         if(itemsStarted != localItemsTotal)
         {
            localBytesTotal = Number.POSITIVE_INFINITY;
         }
         else
         {
            localBytesTotal = localBytesTotalCurrent;
         }
         localWeightPercent = localWeightLoaded / localWeightTotal;
         if(localWeightTotal == 0)
         {
            localWeightPercent = 0;
         }
         var e:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         e.setInfo(localBytesLoaded,localBytesTotal,localBytesTotal,localItemsLoaded,localItemsTotal,localWeightPercent);
         return e;
      }
      
      public function get numConnections() : int
      {
         return _numConnections;
      }
      
      public function get contents() : Object
      {
         return _contents;
      }
      
      public function get items() : Array
      {
         return _items.slice();
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get loadedRatio() : Number
      {
         return _loadedRatio;
      }
      
      public function get itemsTotal() : int
      {
         return items.length;
      }
      
      public function get itemsLoaded() : int
      {
         return _itemsLoaded;
      }
      
      public function set itemsLoaded(value:int) : void
      {
         _itemsLoaded = value;
      }
      
      public function get totalWeight() : int
      {
         return _totalWeight;
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      public function get bytesTotalCurrent() : int
      {
         return _bytesTotalCurrent;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get weightPercent() : Number
      {
         return _weightPercent;
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
      }
      
      public function get isFinished() : Boolean
      {
         return _isFinished;
      }
      
      public function get highestPriority() : int
      {
         var item:LoadingItem = null;
         var highest:int = int.MIN_VALUE;
         for each(item in _items)
         {
            if(item.priority > highest)
            {
               highest = item.priority;
            }
         }
         return highest;
      }
      
      public function get logFunction() : Function
      {
         return _logFunction;
      }
      
      public function get allowsAutoIDFromFileName() : Boolean
      {
         return _allowsAutoIDFromFileName;
      }
      
      public function set allowsAutoIDFromFileName(value:Boolean) : void
      {
         _allowsAutoIDFromFileName = value;
      }
      
      public function getNotLoadedItems() : Array
      {
         return _items.filter(function(i:LoadingItem, ... rest):Boolean
         {
            return i.status != LoadingItem.STATUS_FINISHED;
         });
      }
      
      public function get speed() : Number
      {
         var timeElapsed:int = getTimer() - _lastSpeedCheck;
         var bytesDelta:int = (bytesLoaded - _lastBytesCheck) / 1024;
         var speed:int = bytesDelta / (timeElapsed / 1000);
         _lastSpeedCheck = timeElapsed;
         _lastBytesCheck = bytesLoaded;
         return speed;
      }
      
      public function set logFunction(func:Function) : void
      {
         _logFunction = func;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get stringSubstitutions() : Object
      {
         return _stringSubstitutions;
      }
      
      public function set stringSubstitutions(value:Object) : void
      {
         _stringSubstitutions = value;
      }
      
      public function changeItemPriority(key:String, newPriority:int) : Boolean
      {
         var item:LoadingItem = get(key);
         if(!item)
         {
            return false;
         }
         item._priority = newPriority;
         sortItemsByPriority();
         return true;
      }
      
      public function sortItemsByPriority() : void
      {
         _items.sortOn(["priority","_additionIndex"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
      }
      
      public function _getContentAsType(key:*, type:Class, clearMemory:Boolean = false) : *
      {
         var res:* = undefined;
         if(!_name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         var item:LoadingItem = get(key);
         if(!item)
         {
            return null;
         }
         try
         {
            if(item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
            {
               res = item.content as type;
               if(res == null)
               {
                  throw new Error("bad cast");
               }
               if(clearMemory)
               {
                  remove(key);
               }
               return res;
            }
         }
         catch(e:Error)
         {
            log("Failed to get content with url: \'" + key + "\'as type:",type,LOG_ERRORS);
         }
         return null;
      }
      
      public function getContent(key:String, clearMemory:Boolean = false) : *
      {
         return _getContentAsType(key,Object,clearMemory);
      }
      
      public function getXML(key:*, clearMemory:Boolean = false) : XML
      {
         return XML(_getContentAsType(key,XML,clearMemory));
      }
      
      public function getText(key:*, clearMemory:Boolean = false) : String
      {
         return String(_getContentAsType(key,String,clearMemory));
      }
      
      public function getSound(key:*, clearMemory:Boolean = false) : Sound
      {
         return Sound(_getContentAsType(key,Sound,clearMemory));
      }
      
      public function getBitmap(key:String, clearMemory:Boolean = false) : Bitmap
      {
         return Bitmap(_getContentAsType(key,Bitmap,clearMemory));
      }
      
      public function getMovieClip(key:String, clearMemory:Boolean = false) : MovieClip
      {
         return MovieClip(_getContentAsType(key,MovieClip,clearMemory));
      }
      
      public function getAVM1Movie(key:String, clearMemory:Boolean = false) : AVM1Movie
      {
         return AVM1Movie(_getContentAsType(key,AVM1Movie,clearMemory));
      }
      
      public function getNetStream(key:String, clearMemory:Boolean = false) : NetStream
      {
         return NetStream(_getContentAsType(key,NetStream,clearMemory));
      }
      
      public function getNetStreamMetaData(key:String, clearMemory:Boolean = false) : Object
      {
         var netStream:NetStream = getNetStream(key,clearMemory);
         return !!Boolean(netStream)?(get(key) as Object).metaData:null;
      }
      
      public function getBitmapData(key:*, clearMemory:Boolean = false) : BitmapData
      {
         try
         {
            return getBitmap(key,clearMemory).bitmapData;
         }
         catch(e:Error)
         {
            log("Failed to get bitmapData with url:",key,LOG_ERRORS);
         }
         return null;
      }
      
      public function getSerializedData(key:*, clearMemory:Boolean = false, encodingFunction:Function = null) : *
      {
         var raw:* = undefined;
         var parsed:* = undefined;
         try
         {
            raw = _getContentAsType(key,Object,clearMemory);
            parsed = encodingFunction.apply(null,[raw]);
            return parsed;
         }
         catch(e:Error)
         {
            log("Failed to parse key:",key,"with encodingFunction:" + encodingFunction,LOG_ERRORS);
         }
         return null;
      }
      
      public function getHttpStatus(key:*) : int
      {
         var item:LoadingItem = get(key);
         if(item)
         {
            return item.httpStatus;
         }
         return -1;
      }
      
      public function _isAllDoneP() : Boolean
      {
         return _items.every(function(item:LoadingItem, ... rest):Boolean
         {
            return item._isLoaded;
         });
      }
      
      public function _onAllLoaded() : void
      {
         if(_isFinished)
         {
            return;
         }
         var eComplete:BulkProgressEvent = new BulkProgressEvent(COMPLETE);
         eComplete.setInfo(bytesLoaded,bytesTotal,bytesTotalCurrent,_itemsLoaded,itemsTotal,weightPercent);
         var eProgress:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         eProgress.setInfo(bytesLoaded,bytesTotal,bytesTotalCurrent,_itemsLoaded,itemsTotal,weightPercent);
         _isRunning = false;
         _endTIme = getTimer();
         totalTime = BulkLoader.truncateNumber((_endTIme - _startTime) / 1000);
         _updateStats();
         _connections = [];
         getStats();
         _isFinished = true;
         log("Finished all",LOG_INFO);
         dispatchEvent(eProgress);
         dispatchEvent(eComplete);
      }
      
      public function getStats() : String
      {
         var stats:Array = [];
         stats.push("\n************************************");
         stats.push("All items loaded(" + itemsTotal + ")");
         stats.push("Total time(s):       " + totalTime);
         stats.push("Average latency(s):  " + truncateNumber(avgLatency));
         stats.push("Average speed(kb/s): " + truncateNumber(speedAvg));
         stats.push("Median speed(kb/s):  " + truncateNumber(_speedTotal));
         stats.push("KiloBytes total:     " + truncateNumber(bytesTotal / 1024));
         var itemsInfo:Array = _items.map(function(item:LoadingItem, ... rest):String
         {
            return "\t" + item.getStats();
         });
         stats.push(itemsInfo.join("\n"));
         stats.push("************************************");
         var statsString:String = stats.join("\n");
         log(statsString,LOG_VERBOSE);
         return statsString;
      }
      
      public function log(... msg) : void
      {
         var level:int = !!isNaN(msg[msg.length - 1])?3:int(int(msg.pop()));
         if(level >= logLevel)
         {
            _logFunction("[BulkLoader] " + msg.join(" "));
         }
      }
      
      public function get(key:*) : LoadingItem
      {
         var item:LoadingItem = null;
         if(!key)
         {
            return null;
         }
         for each(item in _items)
         {
            if(item._id == key || item.url.url == key || item.url == key || key is URLRequest && item.url.url == key.url)
            {
               return item;
            }
         }
         return null;
      }
      
      public function remove(key:*) : Boolean
      {
         var item:LoadingItem = null;
         var allDone:Boolean = false;
         try
         {
            if(key is LoadingItem)
            {
               item = key;
            }
            else
            {
               item = get(key);
            }
            if(!item)
            {
               return false;
            }
            _removeFromItems(item);
            _removeFromConnections(item);
            item.destroy();
            item = null;
            _onProgress();
            allDone = _isAllDoneP();
            if(allDone)
            {
               _onAllLoaded();
            }
            return true;
         }
         catch(e:Error)
         {
            log("Error while removing item from key:" + key,e.getStackTrace(),LOG_ERRORS);
         }
         return false;
      }
      
      public function removeAll() : void
      {
         var item:LoadingItem = null;
         for each(item in _items.slice())
         {
            remove(item);
         }
         _items = [];
         _connections = [];
         _contents = new Dictionary();
      }
      
      public function clear() : void
      {
         removeAll();
         delete _allLoaders[name];
         _name = null;
      }
      
      public function removePausedItems() : Boolean
      {
         var stoppedLoads:Array = _items.filter(function(item:LoadingItem, ... rest):Boolean
         {
            return item.status == LoadingItem.STATUS_STOPPED;
         });
         stoppedLoads.forEach(function(item:LoadingItem, ... rest):void
         {
            remove(item);
         });
         _loadNext();
         return stoppedLoads.length > 0;
      }
      
      public function removeFailedItems() : int
      {
         var numCleared:int = 0;
         var badItems:Array = _items.filter(function(item:LoadingItem, ... rest):Boolean
         {
            return item.status == LoadingItem.STATUS_ERROR;
         });
         numCleared = badItems.length;
         badItems.forEach(function(item:LoadingItem, ... rest):void
         {
            remove(item);
         });
         _loadNext();
         return numCleared;
      }
      
      public function pause(key:*, loadsNext:Boolean = false) : Boolean
      {
         var item:LoadingItem = key is LoadingItem?key:get(key);
         if(!item)
         {
            return false;
         }
         item.stop();
         log("STOPPED ITEM:",item,LOG_INFO);
         var result:Boolean = _removeFromConnections(item);
         if(loadsNext)
         {
            _loadNext();
         }
         return result;
      }
      
      public function pauseAll() : void
      {
         var item:LoadingItem = null;
         for each(item in _items)
         {
            pause(item);
         }
         _isRunning = false;
         _isPaused = true;
         log("Stopping all items",LOG_INFO);
      }
      
      public function resume(key:*) : Boolean
      {
         var item:LoadingItem = key is LoadingItem?key:get(key);
         _isPaused = false;
         if(item && item.status == LoadingItem.STATUS_STOPPED)
         {
            item.status = null;
            _loadNext();
            return true;
         }
         return false;
      }
      
      public function resumeAll() : Boolean
      {
         log("Resuming all items",LOG_VERBOSE);
         var affected:Boolean = false;
         _items.forEach(function(item:LoadingItem, ... rest):void
         {
            if(item.status == LoadingItem.STATUS_STOPPED)
            {
               resume(item);
               affected = true;
            }
         });
         _loadNext();
         return affected;
      }
      
      override public function toString() : String
      {
         return "[BulkLoader] name:" + name + ", itemsTotal: " + itemsTotal + ", itemsLoaded: " + _itemsLoaded;
      }
   }
}
