package br.com.stimuli.loading 
{
    import br.com.stimuli.loading.loadingtypes.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class BulkLoader extends flash.events.EventDispatcher
    {
        public function BulkLoader(arg1:String, arg2:int=7, arg3:int=20)
        {
            this._items = [];
            this._contents = new flash.utils.Dictionary();
            this._logFunction = trace;
            super();
            if (Boolean(_allLoaders[arg1]))
            {
                __debug_print_loaders();
                throw new Error("BulkLoader with name\'" + arg1 + "\' has already been created.");
            }
            if (!arg1)
            {
                throw new Error("Cannot create a BulkLoader instance without a name");
            }
            _allLoaders[arg1] = this;
            if (arg2 > 0)
            {
                this._numConnections = arg2;
            }
            this.logLevel = arg3;
            this._name = arg1;
            var loc1:*;
            var loc2:*;
            _instancesCreated++;
            this._id = _instancesCreated;
            this._additionIndex = 0;
            return;
        }

        public function hasItem(arg1:*, arg2:Boolean=true):Boolean
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = null;
            if (arg2)
            {
                loc1 = _allLoaders;
            }
            else 
            {
                loc1 = [this];
            }
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = loc1;
            for each (loc2 in loc4)
            {
                if (!_hasItemInBulkLoader(arg1, loc2))
                {
                    continue;
                }
                return true;
            }
            return false;
        }

        public function add(arg1:*, arg2:Object=null):br.com.stimuli.loading.loadingtypes.LoadingItem
        {
            var loc2:*;
            loc2 = null;
            var loc4:*;
            loc4 = null;
            if (!this._name)
            {
                throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
            }
            if (!arg1 || !String(arg1))
            {
                throw new Error("[BulkLoader] Cannot add an item with a null url");
            }
            arg2 = arg2 || {};
            if (arg1 as String)
            {
                arg1 = new flash.net.URLRequest(br.com.stimuli.loading.BulkLoader.substituteURLString(arg1, this._stringSubstitutions));
                if (arg2[HEADERS])
                {
                    arg1.requestHeaders = arg2[HEADERS];
                }
            }
            else 
            {
                if (!arg1 as flash.net.URLRequest)
                {
                    throw new Error("[BulkLoader] cannot add object with bad type for url:\'" + arg1.url);
                }
            }
            var loc1:*;
            loc1 = this.get(arg2[ID]);
            if (loc1)
            {
                this.log("Add received an already added id: " + arg2[ID] + ", not adding a new item");
                return loc1;
            }
            if (arg2["type"])
            {
                loc2 = arg2["type"].toLowerCase();
                if (AVAILABLE_TYPES.indexOf(loc2) == -1)
                {
                    this.log("add received an unknown type:", loc2, "and will cast it to text", LOG_WARNINGS);
                }
            }
            if (!loc2)
            {
                loc2 = guessType(arg1.url);
            }
            var loc5:*;
            var loc6:*;
            loc6 = ((loc5 = this)._additionIndex + 1);
            loc5._additionIndex = loc6;
            loc1 = new _typeClasses[loc2](arg1, loc2, _instancesCreated + "_" + String(this._additionIndex));
            if (!arg2["id"] && this._allowsAutoIDFromFileName)
            {
                arg2["id"] = getFileName(arg1.url);
                this.log("Adding automatic id from file name for item:", loc1, "( id= " + arg2["id"] + " )");
            }
            var loc3:*;
            loc3 = loc1._parseOptions(arg2);
            loc5 = 0;
            loc6 = loc3;
            for each (loc4 in loc6)
            {
                this.log(loc4, LOG_WARNINGS);
            }
            this.log("Added", loc1, LOG_VERBOSE);
            loc1._addedTime = flash.utils.getTimer();
            loc1._additionIndex = this._additionIndex;
            loc1.addEventListener(flash.events.Event.COMPLETE, this._onItemComplete, false, int.MIN_VALUE, true);
            loc1.addEventListener(ERROR, this._onItemError, false, 0, true);
            loc1.addEventListener(flash.events.Event.OPEN, this._onItemStarted, false, 0, true);
            loc1.addEventListener(flash.events.ProgressEvent.PROGRESS, this._onProgress, false, 0, true);
            this._items.push(loc1);
            this._itemsTotal = this._itemsTotal + 1;
            this._totalWeight = this._totalWeight + loc1.weight;
            this.sortItemsByPriority();
            this._isFinished = false;
            if (!this._isPaused)
            {
                this._loadNext();
            }
            return loc1;
        }

        public function start(arg1:int=-1):void
        {
            if (arg1 > 0)
            {
                this._numConnections = arg1;
            }
            if (this._connections)
            {
                this._loadNext();
                return;
            }
            this._startTime = flash.utils.getTimer();
            this._connections = [];
            this._loadNext();
            this._isRunning = true;
            this._lastBytesCheck = 0;
            this._lastSpeedCheck = flash.utils.getTimer();
            this._isPaused = false;
            return;
        }

        public function reload(arg1:*):Boolean
        {
            var loc1:*;
            loc1 = null;
            if (arg1 as br.com.stimuli.loading.loadingtypes.LoadingItem)
            {
                loc1 = arg1;
            }
            else 
            {
                loc1 = this.get(arg1);
            }
            if (!loc1)
            {
                return false;
            }
            this._removeFromItems(loc1);
            this._removeFromConnections(loc1);
            loc1.stop();
            loc1.cleanListeners();
            loc1.status = null;
            this._isFinished = false;
            loc1._addedTime = flash.utils.getTimer();
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this)._additionIndex + 1);
            loc2._additionIndex = loc3;
            loc1._additionIndex = (loc2 = this)._additionIndex;
            loc1.addEventListener(flash.events.Event.COMPLETE, this._onItemComplete, false, int.MIN_VALUE, true);
            loc1.addEventListener(ERROR, this._onItemError, false, 0, true);
            loc1.addEventListener(flash.events.Event.OPEN, this._onItemStarted, false, 0, true);
            loc1.addEventListener(flash.events.ProgressEvent.PROGRESS, this._onProgress, false, 0, true);
            this._items.push(loc1);
            this._itemsTotal = this._itemsTotal + 1;
            this._totalWeight = this._totalWeight + loc1.weight;
            this.sortItemsByPriority();
            this._isFinished = false;
            this.loadNow(loc1);
            return true;
        }

        public function loadNow(arg1:*):Boolean
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = null;
            if (arg1 as br.com.stimuli.loading.loadingtypes.LoadingItem)
            {
                loc1 = arg1;
            }
            else 
            {
                loc1 = this.get(arg1);
            }
            if (!loc1)
            {
                return false;
            }
            if (!this._connections)
            {
                this._connections = [];
            }
            if (loc1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_FINISHED || loc1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STARTED)
            {
                return true;
            }
            if (this._connections.length >= this.numConnections)
            {
                loc2 = this._getLeastUrgentOpenedItem();
                this._removeFromConnections(loc2);
                loc2.status = null;
            }
            loc1._priority = this.highestPriority;
            this._loadNext(loc1);
            return true;
        }

        public function _getLeastUrgentOpenedItem():br.com.stimuli.loading.loadingtypes.LoadingItem
        {
            var loc1:*;
            loc1 = br.com.stimuli.loading.loadingtypes.LoadingItem(this._connections.sortOn(["priority", "bytesRemaining", "_additionIndex"], [Array.NUMERIC, Array.DESCENDING, Array.NUMERIC, Array.NUMERIC])[0]);
            return loc1;
        }

        public function _loadNext(arg1:br.com.stimuli.loading.loadingtypes.LoadingItem=null):Boolean
        {
            var checkItem:br.com.stimuli.loading.loadingtypes.LoadingItem;
            var next:Boolean;
            var toLoad:br.com.stimuli.loading.loadingtypes.LoadingItem=null;

            var loc1:*;
            checkItem = null;
            toLoad = arg1;
            if (this._isFinished)
            {
                return false;
            }
            if (!this._connections)
            {
                this._connections = [];
            }
            this._connections.forEach(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):void
            {
                if (arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_ERROR && arg1.numTries < arg1.maxTries)
                {
                    _removeFromConnections(arg1);
                }
                return;
            })
            next = false;
            if (!toLoad)
            {
                var loc2:*;
                loc2 = 0;
                var loc3:*;
                loc3 = this._items;
                for each (checkItem in loc3)
                {
                    if (!(!checkItem._isLoading && !(checkItem.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STOPPED)))
                    {
                        continue;
                    }
                    toLoad = checkItem;
                    break;
                }
            }
            if (toLoad)
            {
                next = true;
                this._isRunning = true;
                if (this._connections.length < this.numConnections)
                {
                    this._connections.push(toLoad);
                    toLoad.load();
                    this.log("Will load item:", toLoad, LOG_INFO);
                }
                if (this._connections.length < this.numConnections)
                {
                    this._loadNext();
                }
            }
            return next;
        }

        public function _onItemComplete(arg1:flash.events.Event):void
        {
            var loc1:*;
            loc1 = arg1.target as br.com.stimuli.loading.loadingtypes.LoadingItem;
            this._removeFromConnections(loc1);
            this.log("Loaded ", loc1, LOG_INFO);
            this.log("Items to load", this.getNotLoadedItems(), LOG_VERBOSE);
            loc1.cleanListeners();
            this._contents[loc1.url.url] = loc1.content;
            var loc2:*;
            loc2 = this._loadNext();
            var loc3:*;
            loc3 = this._isAllDoneP();
            var loc4:*;
            var loc5:*;
            loc5 = ((loc4 = this)._itemsLoaded + 1);
            loc4._itemsLoaded = loc5;
            if (loc3)
            {
                this._onAllLoaded();
            }
            return;
        }

        public function _updateStats():void
        {
            var loc4:*;
            loc4 = null;
            this.avgLatency = 0;
            this.speedAvg = 0;
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = 0;
            this._speedTotal = 0;
            var loc3:*;
            loc3 = 0;
            var loc5:*;
            loc5 = 0;
            var loc6:*;
            loc6 = this._items;
            for each (loc4 in loc6)
            {
                if (!(loc4._isLoaded && !(loc4.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_ERROR)))
                {
                    continue;
                }
                loc1 = loc1 + loc4.latency;
                loc2 = loc2 + loc4.bytesTotal;
                loc3 = (loc3 + 1);
            }
            this._speedTotal = loc2 / 1024 / this.totalTime;
            this.avgLatency = loc1 / loc3;
            this.speedAvg = this._speedTotal / loc3;
            return;
        }

        public function _removeFromItems(arg1:br.com.stimuli.loading.loadingtypes.LoadingItem):Boolean
        {
            var loc1:*;
            loc1 = this._items.indexOf(arg1);
            if (loc1 > -1)
            {
                this._items.splice(loc1, 1);
            }
            else 
            {
                return false;
            }
            if (arg1._isLoaded)
            {
                var loc2:*;
                var loc3:*;
                loc3 = ((loc2 = this)._itemsLoaded - 1);
                loc2._itemsLoaded = loc3;
            }
            loc3 = ((loc2 = this)._itemsTotal - 1);
            loc2._itemsTotal = loc3;
            this._totalWeight = this._totalWeight - arg1.weight;
            this.log("Removing " + arg1, LOG_VERBOSE);
            return true;
        }

        public function _removeFromConnections(arg1:*):Boolean
        {
            if (!this._connections)
            {
                return false;
            }
            var loc1:*;
            loc1 = this._connections.indexOf(arg1);
            if (loc1 > -1)
            {
                this._connections.splice(loc1, 1);
                return true;
            }
            return false;
        }

        public function _onItemError(arg1:br.com.stimuli.loading.BulkErrorEvent):void
        {
            var bulkErrorEvent:br.com.stimuli.loading.BulkErrorEvent;
            var evt:br.com.stimuli.loading.BulkErrorEvent;
            var item:br.com.stimuli.loading.loadingtypes.LoadingItem;

            var loc1:*;
            evt = arg1;
            item = evt.target as br.com.stimuli.loading.loadingtypes.LoadingItem;
            this.log("After " + item.numTries + " I am giving up on " + item.url.url, LOG_ERRORS);
            this.log("Error loading", item, LOG_ERRORS);
            this._removeFromConnections(item);
            evt.stopPropagation();
            bulkErrorEvent = new br.com.stimuli.loading.BulkErrorEvent(br.com.stimuli.loading.BulkErrorEvent.ERROR);
            bulkErrorEvent.errors = this._items.filter(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):Boolean
            {
                return arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_ERROR;
            })
            dispatchEvent(bulkErrorEvent);
            return;
        }

        public function _onItemStarted(arg1:flash.events.Event):void
        {
            var loc1:*;
            loc1 = arg1.target as br.com.stimuli.loading.loadingtypes.LoadingItem;
            this.log("Started loading", loc1, LOG_INFO);
            dispatchEvent(arg1);
            return;
        }

        public function _onProgress(arg1:flash.events.Event=null):void
        {
            var loc1:*;
            loc1 = this.getProgressForItems(this._items);
            this._bytesLoaded = loc1.bytesLoaded;
            this._bytesTotal = loc1.bytesTotal;
            this._weightPercent = loc1.weightPercent;
            this._percentLoaded = loc1.percentLoaded;
            this._bytesTotalCurrent = loc1.bytesTotalCurrent;
            this._loadedRatio = loc1.ratioLoaded;
            dispatchEvent(loc1);
            return;
        }

        public function getProgressForItems(arg1:Array):br.com.stimuli.loading.BulkProgressEvent
        {
            var loc10:*;
            loc10 = null;
            var loc12:*;
            loc12 = undefined;
            var loc14:*;
            this._bytesTotalCurrent = loc14 = 0;
            this._bytesTotal = loc14 = loc14;
            this._bytesLoaded = loc14;
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = 0;
            var loc5:*;
            loc5 = 0;
            var loc6:*;
            loc6 = 0;
            var loc7:*;
            loc7 = 0;
            var loc8:*;
            loc8 = 0;
            var loc9:*;
            loc9 = 0;
            var loc11:*;
            loc11 = [];
            loc14 = 0;
            var loc15:*;
            loc15 = arg1;
            for each (loc12 in loc15)
            {
                if (!(loc10 = loc12 as br.com.stimuli.loading.loadingtypes.LoadingItem ? loc12 : this.get(loc12)))
                {
                    continue;
                }
                ++loc5;
                loc2 = loc2 + loc10.weight;
                if (!(loc10.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STARTED || loc10.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_FINISHED || loc10.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STOPPED))
                {
                    continue;
                }
                loc7 = loc7 + loc10._bytesLoaded;
                loc9 = loc9 + loc10._bytesTotal;
                loc4 = loc4 + loc10._bytesLoaded / loc10._bytesTotal * loc10.weight;
                if (loc10.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_FINISHED)
                {
                    ++loc6;
                }
                ++loc3;
            }
            if (loc3 == loc5)
            {
                loc8 = loc9;
            }
            else 
            {
                loc8 = Number.POSITIVE_INFINITY;
            }
            loc1 = loc4 / loc2;
            if (loc2 == 0)
            {
                loc1 = 0;
            }
            var loc13:*;
            (loc13 = new br.com.stimuli.loading.BulkProgressEvent(PROGRESS)).setInfo(loc7, loc8, loc8, loc6, loc5, loc1);
            return loc13;
        }

        public function get numConnections():int
        {
            return this._numConnections;
        }

        public function get contents():Object
        {
            return this._contents;
        }

        public function get items():Array
        {
            return this._items.slice();
        }

        public function get name():String
        {
            return this._name;
        }

        public function get loadedRatio():Number
        {
            return this._loadedRatio;
        }

        public function get itemsTotal():int
        {
            return this.items.length;
        }

        public function get itemsLoaded():int
        {
            return this._itemsLoaded;
        }

        public function set itemsLoaded(arg1:int):void
        {
            this._itemsLoaded = arg1;
            return;
        }

        public function get totalWeight():int
        {
            return this._totalWeight;
        }

        public function get bytesTotal():int
        {
            return this._bytesTotal;
        }

        public function get bytesLoaded():int
        {
            return this._bytesLoaded;
        }

        public function get bytesTotalCurrent():int
        {
            return this._bytesTotalCurrent;
        }

        public function get percentLoaded():Number
        {
            return this._percentLoaded;
        }

        public function get weightPercent():Number
        {
            return this._weightPercent;
        }

        public function get isRunning():Boolean
        {
            return this._isRunning;
        }

        public function get isFinished():Boolean
        {
            return this._isFinished;
        }

        public function get highestPriority():int
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = int.MIN_VALUE;
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = this._items;
            for each (loc2 in loc4)
            {
                if (!(loc2.priority > loc1))
                {
                    continue;
                }
                loc1 = loc2.priority;
            }
            return loc1;
        }

        public function get logFunction():Function
        {
            return this._logFunction;
        }

        public function get allowsAutoIDFromFileName():Boolean
        {
            return this._allowsAutoIDFromFileName;
        }

        public function set allowsAutoIDFromFileName(arg1:Boolean):void
        {
            this._allowsAutoIDFromFileName = arg1;
            return;
        }

        public function getNotLoadedItems():Array
        {
            var loc1:*;
            return this._items.filter(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):Boolean
            {
                return !(arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_FINISHED);
            })
        }

        public function get speed():Number
        {
            var loc1:*;
            loc1 = flash.utils.getTimer() - this._lastSpeedCheck;
            var loc2:*;
            loc2 = (this.bytesLoaded - this._lastBytesCheck) / 1024;
            var loc3:*;
            loc3 = loc2 / (loc1 / 1000);
            this._lastSpeedCheck = loc1;
            this._lastBytesCheck = this.bytesLoaded;
            return loc3;
        }

        public function set logFunction(arg1:Function):void
        {
            this._logFunction = arg1;
            return;
        }

        public function get id():int
        {
            return this._id;
        }

        public function get stringSubstitutions():Object
        {
            return this._stringSubstitutions;
        }

        public function set stringSubstitutions(arg1:Object):void
        {
            this._stringSubstitutions = arg1;
            return;
        }

        public function changeItemPriority(arg1:String, arg2:int):Boolean
        {
            var loc1:*;
            loc1 = this.get(arg1);
            if (!loc1)
            {
                return false;
            }
            loc1._priority = arg2;
            this.sortItemsByPriority();
            return true;
        }

        public function sortItemsByPriority():void
        {
            this._items.sortOn(["priority", "_additionIndex"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);
            return;
        }

        public function _getContentAsType(arg1:*, arg2:Class, arg3:Boolean=false):*
        {
            var clearMemory:Boolean=false;
            var item:br.com.stimuli.loading.loadingtypes.LoadingItem;
            var key:*;
            var res:*;
            var type:Class;

            var loc1:*;
            res = undefined;
            key = arg1;
            type = arg2;
            clearMemory = arg3;
            if (!this._name)
            {
                throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
            }
            item = this.get(key);
            if (!item)
            {
                return null;
            }
            try
            {
                if (item._isLoaded || item.isStreamable() && item.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STARTED)
                {
                    res = item.content as type;
                    if (res == null)
                    {
                        throw new Error("bad cast");
                    }
                    if (clearMemory)
                    {
                        this.remove(key);
                    }
                    return res;
                }
            }
            catch (e:Error)
            {
                log("Failed to get content with url: \'" + key + "\'as type:", type, LOG_ERRORS);
            }
            return null;
        }

        public function getContent(arg1:String, arg2:Boolean=false):*
        {
            return this._getContentAsType(arg1, Object, arg2);
        }

        public function getXML(arg1:*, arg2:Boolean=false):XML
        {
            return XML(this._getContentAsType(arg1, XML, arg2));
        }

        public function getText(arg1:*, arg2:Boolean=false):String
        {
            return String(this._getContentAsType(arg1, String, arg2));
        }

        public function getSound(arg1:*, arg2:Boolean=false):flash.media.Sound
        {
            return flash.media.Sound(this._getContentAsType(arg1, flash.media.Sound, arg2));
        }

        public function getBitmap(arg1:String, arg2:Boolean=false):flash.display.Bitmap
        {
            return flash.display.Bitmap(this._getContentAsType(arg1, flash.display.Bitmap, arg2));
        }

        public function getMovieClip(arg1:String, arg2:Boolean=false):flash.display.MovieClip
        {
            return flash.display.MovieClip(this._getContentAsType(arg1, flash.display.MovieClip, arg2));
        }

        public function getAVM1Movie(arg1:String, arg2:Boolean=false):flash.display.AVM1Movie
        {
            return flash.display.AVM1Movie(this._getContentAsType(arg1, flash.display.AVM1Movie, arg2));
        }

        public function getNetStream(arg1:String, arg2:Boolean=false):flash.net.NetStream
        {
            return flash.net.NetStream(this._getContentAsType(arg1, flash.net.NetStream, arg2));
        }

        public function getNetStreamMetaData(arg1:String, arg2:Boolean=false):Object
        {
            var loc1:*;
            loc1 = this.getNetStream(arg1, arg2);
            return Boolean(loc1) ? (this.get(arg1) as Object).metaData : null;
        }

        public function getBitmapData(arg1:*, arg2:Boolean=false):flash.display.BitmapData
        {
            var clearMemory:Boolean=false;
            var key:*;

            var loc1:*;
            key = arg1;
            clearMemory = arg2;
            try
            {
                return this.getBitmap(key, clearMemory).bitmapData;
            }
            catch (e:Error)
            {
                log("Failed to get bitmapData with url:", key, LOG_ERRORS);
            }
            return null;
        }

        public function getSerializedData(arg1:*, arg2:Boolean=false, arg3:Function=null):*
        {
            var clearMemory:Boolean=false;
            var encodingFunction:Function=null;
            var key:*;
            var parsed:*;
            var raw:*;

            var loc1:*;
            raw = undefined;
            parsed = undefined;
            key = arg1;
            clearMemory = arg2;
            encodingFunction = arg3;
            try
            {
                raw = this._getContentAsType(key, Object, clearMemory);
                parsed = encodingFunction.apply(null, [raw]);
                return parsed;
            }
            catch (e:Error)
            {
                log("Failed to parse key:", key, "with encodingFunction:" + encodingFunction, LOG_ERRORS);
            }
            return null;
        }

        public function getHttpStatus(arg1:*):int
        {
            var loc1:*;
            loc1 = this.get(arg1);
            if (loc1)
            {
                return loc1.httpStatus;
            }
            return -1;
        }

        public function _isAllDoneP():Boolean
        {
            var loc1:*;
            return this._items.every(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):Boolean
            {
                return arg1._isLoaded;
            })
        }

        public function _onAllLoaded():void
        {
            if (this._isFinished)
            {
                return;
            }
            var loc1:*;
            loc1 = new br.com.stimuli.loading.BulkProgressEvent(COMPLETE);
            loc1.setInfo(this.bytesLoaded, this.bytesTotal, this.bytesTotalCurrent, this._itemsLoaded, this.itemsTotal, this.weightPercent);
            var loc2:*;
            loc2 = new br.com.stimuli.loading.BulkProgressEvent(PROGRESS);
            loc2.setInfo(this.bytesLoaded, this.bytesTotal, this.bytesTotalCurrent, this._itemsLoaded, this.itemsTotal, this.weightPercent);
            this._isRunning = false;
            this._endTIme = flash.utils.getTimer();
            this.totalTime = br.com.stimuli.loading.BulkLoader.truncateNumber((this._endTIme - this._startTime) / 1000);
            this._updateStats();
            this._connections = [];
            this.getStats();
            this._isFinished = true;
            this.log("Finished all", LOG_INFO);
            dispatchEvent(loc2);
            dispatchEvent(loc1);
            return;
        }

        public function getStats():String
        {
            var itemsInfo:Array;
            var stats:Array;
            var statsString:String;

            var loc1:*;
            stats = [];
            stats.push("\n************************************");
            stats.push("All items loaded(" + this.itemsTotal + ")");
            stats.push("Total time(s):       " + this.totalTime);
            stats.push("Average latency(s):  " + truncateNumber(this.avgLatency));
            stats.push("Average speed(kb/s): " + truncateNumber(this.speedAvg));
            stats.push("Median speed(kb/s):  " + truncateNumber(this._speedTotal));
            stats.push("KiloBytes total:     " + truncateNumber(this.bytesTotal / 1024));
            itemsInfo = this._items.map(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):String
            {
                return "\t" + arg1.getStats();
            })
            stats.push(itemsInfo.join("\n"));
            stats.push("************************************");
            statsString = stats.join("\n");
            this.log(statsString, LOG_VERBOSE);
            return statsString;
        }

        public function log(... rest):void
        {
            var loc1:*;
            loc1 = isNaN(rest[(rest.length - 1)]) ? 3 : int(rest.pop());
            if (loc1 >= this.logLevel)
            {
                this._logFunction("[BulkLoader] " + rest.join(" "));
            }
            return;
        }

        public function get(arg1:*):br.com.stimuli.loading.loadingtypes.LoadingItem
        {
            var loc1:*;
            loc1 = null;
            if (!arg1)
            {
                return null;
            }
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = this._items;
            for each (loc1 in loc3)
            {
                if (!(loc1._id == arg1 || loc1.url.url == arg1 || loc1.url == arg1 || arg1 as flash.net.URLRequest && loc1.url.url == arg1.url))
                {
                    continue;
                }
                return loc1;
            }
            return null;
        }

        public function remove(arg1:*):Boolean
        {
            var allDone:Boolean;
            var item:br.com.stimuli.loading.loadingtypes.LoadingItem;
            var key:*;

            var loc1:*;
            item = null;
            allDone = false;
            key = arg1;
            try
            {
                if (key as br.com.stimuli.loading.loadingtypes.LoadingItem)
                {
                    item = key;
                }
                else 
                {
                    item = this.get(key);
                }
                if (!item)
                {
                    return false;
                }
                this._removeFromItems(item);
                this._removeFromConnections(item);
                item.destroy();
                item = null;
                this._onProgress();
                allDone = this._isAllDoneP();
                if (allDone)
                {
                    this._onAllLoaded();
                }
                return true;
            }
            catch (e:Error)
            {
                log("Error while removing item from key:" + key, undefined.getStackTrace(), LOG_ERRORS);
            }
            return false;
        }

        public function removeAll():void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = this._items.slice();
            for each (loc1 in loc3)
            {
                this.remove(loc1);
            }
            this._items = [];
            this._connections = [];
            this._contents = new flash.utils.Dictionary();
            return;
        }

        public function clear():void
        {
            this.removeAll();
            delete _allLoaders[this.name];
            this._name = null;
            return;
        }

        public function removePausedItems():Boolean
        {
            var stoppedLoads:Array;

            var loc1:*;
            stoppedLoads = this._items.filter(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):Boolean
            {
                return arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STOPPED;
            })
            stoppedLoads.forEach(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):void
            {
                remove(arg1);
                return;
            })
            this._loadNext();
            return stoppedLoads.length > 0;
        }

        public function removeFailedItems():int
        {
            var badItems:Array;
            var numCleared:int;

            var loc1:*;
            numCleared = 0;
            badItems = this._items.filter(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):Boolean
            {
                return arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_ERROR;
            })
            numCleared = badItems.length;
            badItems.forEach(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):void
            {
                remove(arg1);
                return;
            })
            this._loadNext();
            return numCleared;
        }

        public function pause(arg1:*, arg2:Boolean=false):Boolean
        {
            var loc1:*;
            loc1 = arg1 as br.com.stimuli.loading.loadingtypes.LoadingItem ? arg1 : this.get(arg1);
            if (!loc1)
            {
                return false;
            }
            loc1.stop();
            this.log("STOPPED ITEM:", loc1, LOG_INFO);
            var loc2:*;
            loc2 = this._removeFromConnections(loc1);
            if (arg2)
            {
                this._loadNext();
            }
            return loc2;
        }

        public function pauseAll():void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = this._items;
            for each (loc1 in loc3)
            {
                this.pause(loc1);
            }
            this._isRunning = false;
            this._isPaused = true;
            this.log("Stopping all items", LOG_INFO);
            return;
        }

        public function resume(arg1:*):Boolean
        {
            var loc1:*;
            loc1 = arg1 as br.com.stimuli.loading.loadingtypes.LoadingItem ? arg1 : this.get(arg1);
            this._isPaused = false;
            if (loc1 && loc1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STOPPED)
            {
                loc1.status = null;
                this._loadNext();
                return true;
            }
            return false;
        }

        public function resumeAll():Boolean
        {
            var affected:Boolean;

            var loc1:*;
            this.log("Resuming all items", LOG_VERBOSE);
            affected = false;
            this._items.forEach(function (arg1:br.com.stimuli.loading.loadingtypes.LoadingItem, ... rest):void
            {
                if (arg1.status == br.com.stimuli.loading.loadingtypes.LoadingItem.STATUS_STOPPED)
                {
                    resume(arg1);
                    affected = true;
                }
                return;
            })
            this._loadNext();
            return affected;
        }

        public override function toString():String
        {
            return "[BulkLoader] name:" + this.name + ", itemsTotal: " + this.itemsTotal + ", itemsLoaded: " + this._itemsLoaded;
        }

        public static function createUniqueNamedLoader(arg1:int=7, arg2:int=20):br.com.stimuli.loading.BulkLoader
        {
            return new BulkLoader(br.com.stimuli.loading.BulkLoader.getUniqueName(), arg1, arg2);
        }

        public static function getUniqueName():String
        {
            return "BulkLoader-" + _instancesCreated;
        }

        public static function getLoader(arg1:String):br.com.stimuli.loading.BulkLoader
        {
            return br.com.stimuli.loading.BulkLoader._allLoaders[arg1] as br.com.stimuli.loading.BulkLoader;
        }

        public static function _hasItemInBulkLoader(arg1:*, arg2:br.com.stimuli.loading.BulkLoader):Boolean
        {
            var loc1:*;
            loc1 = arg2.get(arg1);
            if (loc1 && loc1._isLoaded)
            {
                return true;
            }
            return false;
        }

        public static function whichLoaderHasItem(arg1:*):br.com.stimuli.loading.BulkLoader
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = _allLoaders;
            for each (loc1 in loc3)
            {
                if (!br.com.stimuli.loading.BulkLoader._hasItemInBulkLoader(arg1, loc1))
                {
                    continue;
                }
                return loc1;
            }
            return null;
        }

        public static function registerNewType(arg1:String, arg2:String, arg3:Class):Boolean
        {
            var loc1:*;
            loc1 = null;
            if (arg1.charAt(0) == ".")
            {
                arg1 = arg1.substring(1);
            }
            if (AVAILABLE_TYPES.indexOf(arg2) == -1)
            {
                if (!Boolean(arg3) || !(arg3 as br.com.stimuli.loading.loadingtypes.LoadingItem))
                {
                    throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
                }
                _typeClasses[arg2] = arg3;
                if (!_customTypesExtensions[arg2])
                {
                    _customTypesExtensions[arg2] = [];
                    AVAILABLE_TYPES.push(arg2);
                }
                _customTypesExtensions[arg2].push(arg1);
                return true;
            }
            var loc2:*;
            if ((loc1 = (loc2 = {"IMAGE_EXTENSIONS":TYPE_IMAGE, "VIDEO_EXTENSIONS":TYPE_VIDEO, "SOUND_EXTENSIONS":TYPE_SOUND, "TEXT_EXTENSIONS":TYPE_TEXT})[arg2]) && loc1.indexOf(arg1) == -1)
            {
                loc1.push(arg1);
                return true;
            }
            return false;
        }

        public static function removeAllLoaders():void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = _allLoaders;
            for each (loc1 in loc3)
            {
                loc1.removeAll();
                loc1.clear();
                loc1 = null;
            }
            _allLoaders = {};
            return;
        }

        public static function pauseAllLoaders():void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = _allLoaders;
            for each (loc1 in loc3)
            {
                loc1.pauseAll();
            }
            return;
        }

        public static function truncateNumber(arg1:Number, arg2:int=2):Number
        {
            var loc1:*;
            loc1 = Math.pow(10, arg2);
            return Math.round(arg1 * loc1) / loc1;
        }

        public static function guessType(arg1:String):String
        {
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = null;
            var loc5:*;
            loc5 = null;
            var loc1:*;
            loc1 = arg1.indexOf("?") > -1 ? arg1.substring(0, arg1.indexOf("?")) : arg1;
            var loc2:*;
            loc2 = loc1.substring(loc1.lastIndexOf(".") + 1).toLowerCase();
            if (!Boolean(loc2))
            {
                loc2 = br.com.stimuli.loading.BulkLoader.TYPE_TEXT;
            }
            if (loc2 == br.com.stimuli.loading.BulkLoader.TYPE_IMAGE || br.com.stimuli.loading.BulkLoader.IMAGE_EXTENSIONS.indexOf(loc2) > -1)
            {
                loc3 = br.com.stimuli.loading.BulkLoader.TYPE_IMAGE;
            }
            else 
            {
                if (loc2 == br.com.stimuli.loading.BulkLoader.TYPE_SOUND || br.com.stimuli.loading.BulkLoader.SOUND_EXTENSIONS.indexOf(loc2) > -1)
                {
                    loc3 = br.com.stimuli.loading.BulkLoader.TYPE_SOUND;
                }
                else 
                {
                    if (loc2 == br.com.stimuli.loading.BulkLoader.TYPE_VIDEO || br.com.stimuli.loading.BulkLoader.VIDEO_EXTENSIONS.indexOf(loc2) > -1)
                    {
                        loc3 = br.com.stimuli.loading.BulkLoader.TYPE_VIDEO;
                    }
                    else 
                    {
                        if (loc2 == br.com.stimuli.loading.BulkLoader.TYPE_XML || br.com.stimuli.loading.BulkLoader.XML_EXTENSIONS.indexOf(loc2) > -1)
                        {
                            loc3 = br.com.stimuli.loading.BulkLoader.TYPE_XML;
                        }
                        else 
                        {
                            if (loc2 == br.com.stimuli.loading.BulkLoader.TYPE_MOVIECLIP || br.com.stimuli.loading.BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(loc2) > -1)
                            {
                                loc3 = br.com.stimuli.loading.BulkLoader.TYPE_MOVIECLIP;
                            }
                            else 
                            {
                                var loc6:*;
                                loc6 = 0;
                                var loc7:*;
                                loc7 = _customTypesExtensions;
                                for (loc4 in loc7)
                                {
                                    var loc8:*;
                                    loc8 = 0;
                                    var loc9:*;
                                    loc9 = _customTypesExtensions[loc4];
                                    for each (loc5 in loc9)
                                    {
                                        if (loc5 == loc2)
                                        {
                                            loc3 = loc4;
                                            break;
                                        }
                                        if (!loc3)
                                        {
                                            continue;
                                        }
                                        break;
                                    }
                                }
                                if (!loc3)
                                {
                                    loc3 = br.com.stimuli.loading.BulkLoader.TYPE_TEXT;
                                }
                            }
                        }
                    }
                }
            }
            return loc3;
        }

        public static function substituteURLString(arg1:String, arg2:Object):String
        {
            var loc7:*;
            loc7 = null;
            var loc8:*;
            loc8 = null;
            var loc10:*;
            loc10 = null;
            if (!arg2)
            {
                return arg1;
            }
            var loc1:*;
            loc1 = new RegExp("(?P<var_name>\\{\\s*[^\\}]*\\})", "g");
            var loc2:*;
            var loc3:*;
            loc3 = (loc2 = loc1.exec(arg1)) ? loc2.var_name : null;
            var loc4:*;
            loc4 = [];
            var loc5:*;
            loc5 = 0;
            while (Boolean(loc2) && Boolean(loc2.var_name)) 
            {
                if (loc2.var_name)
                {
                    loc3 = (loc3 = (loc3 = (loc3 = loc2.var_name).replace("{", "")).replace("}", "")).replace(new RegExp("\\s*", "g"), "");
                }
                loc4.push({"start":loc2.index, "end":loc2.index + loc2.var_name.length, "changeTo":arg2[loc3]});
                ++loc5;
                if (loc5 > 400)
                {
                    break;
                }
                loc3 = (loc2 = loc1.exec(arg1)) ? loc2.var_name : null;
            }
            if (loc4.length == 0)
            {
                return arg1;
            }
            var loc6:*;
            loc6 = [];
            var loc9:*;
            loc9 = arg1.substr(0, loc4[0].start);
            var loc11:*;
            loc11 = 0;
            var loc12:*;
            loc12 = loc4;
            for each (loc8 in loc12)
            {
                if (loc7)
                {
                    loc9 = arg1.substring(loc7.end, loc8.start);
                }
                loc6.push(loc9);
                loc6.push(loc8.changeTo);
                loc7 = loc8;
            }
            loc6.push(arg1.substring(loc8.end));
            return loc6.join("");
        }

        public static function getFileName(arg1:String):String
        {
            if (arg1.lastIndexOf("/") == (arg1.length - 1))
            {
                return getFileName(arg1.substring(0, (arg1.length - 1)));
            }
            var loc1:*;
            loc1 = arg1.lastIndexOf("/") + 1;
            var loc2:*;
            loc2 = arg1.substring(loc1);
            var loc3:*;
            if ((loc3 = loc2.indexOf(".")) == -1)
            {
                if (loc2.indexOf("?") > -1)
                {
                    loc3 = loc2.indexOf("?");
                }
                else 
                {
                    loc3 = loc2.length;
                }
            }
            var loc4:*;
            return loc4 = loc2.substring(0, loc3);
        }

        public static function __debug_print_loaders():void
        {
            var instNames:String;
            var theNames:Array;

            var loc1:*;
            instNames = null;
            theNames = [];
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = br.com.stimuli.loading.BulkLoader._allLoaders;
            for each (instNames in loc3)
            {
                theNames.push(instNames);
            }
            theNames.sort();
            trace("All loaders");
            theNames.forEach(function (arg1:*, ... rest):void
            {
                trace("\t", arg1);
                return;
            })
            trace("===========");
            return;
        }

        public static function __debug_print_num_loaders():void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = 0;
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = br.com.stimuli.loading.BulkLoader._allLoaders;
            for each (loc2 in loc4)
            {
                ++loc1;
            }
            trace("BulkLoader has ", loc1, "instances");
            return;
        }

        public static function __debug_printStackTrace():void
        {
            var loc1:*;
            try
            {
                throw new Error("stack trace");
            }
            catch (e:Error)
            {
                trace(undefined.getStackTrace());
            }
            return;
        }

        
        {
            AVAILABLE_EXTENSIONS = ["swf", "jpg", "jpeg", "gif", "png", "flv", "mp3", "xml", "txt", "js"];
            IMAGE_EXTENSIONS = ["jpg", "jpeg", "gif", "png"];
            MOVIECLIP_EXTENSIONS = ["swf"];
            TEXT_EXTENSIONS = ["txt", "js", "php", "asp", "py"];
            VIDEO_EXTENSIONS = ["flv", "f4v", "f4p"];
            SOUND_EXTENSIONS = ["mp3", "f4a", "f4b"];
            XML_EXTENSIONS = ["xml"];
            _instancesCreated = 0;
            _allLoaders = {};
            _typeClasses = {"image":br.com.stimuli.loading.loadingtypes.ImageItem, "movieclip":br.com.stimuli.loading.loadingtypes.ImageItem, "xml":br.com.stimuli.loading.loadingtypes.XMLItem, "video":br.com.stimuli.loading.loadingtypes.VideoItem, "sound":br.com.stimuli.loading.loadingtypes.SoundItem, "text":br.com.stimuli.loading.loadingtypes.URLItem};
        }

        public static const VERSION:String="rev 196 (0.9.9.4)";

        public static const TYPE_IMAGE:String="image";

        public static const TYPE_MOVIECLIP:String="movieclip";

        public static const TYPE_SOUND:String="sound";

        public static const TYPE_TEXT:String="text";

        public static const TYPE_XML:String="xml";

        public static const TYPE_VIDEO:String="video";

        public static const AVAILABLE_TYPES:Array=[TYPE_VIDEO, TYPE_XML, TYPE_TEXT, TYPE_SOUND, TYPE_MOVIECLIP, TYPE_IMAGE];

        public static const PROGRESS:String="progress";

        public static const COMPLETE:String="complete";

        public static const HTTP_STATUS:String="httpStatus";

        public static const ERROR:String="error";

        public static const OPEN:String="open";

        public static const CAN_BEGIN_PLAYING:String="canBeginPlaying";

        public static const CHECK_POLICY_FILE:String="checkPolicyFile";

        public static const PREVENT_CACHING:String="preventCache";

        public static const HEADERS:String="headers";

        public static const CONTEXT:String="context";

        public static const ID:String="id";

        public static const PRIORITY:String="priority";

        public static const MAX_TRIES:String="maxTries";

        public static const WEIGHT:String="weight";

        public static const PAUSED_AT_START:String="pausedAtStart";

        public static const GENERAL_AVAILABLE_PROPS:Array=[WEIGHT, MAX_TRIES, HEADERS, ID, PRIORITY, PREVENT_CACHING, "type"];

        public static const DEFAULT_NUM_CONNECTIONS:int=7;

        public static const LOG_VERBOSE:int=0;

        public static const LOG_INFO:int=2;

        public static const LOG_WARNINGS:int=3;

        public static const LOG_ERRORS:int=4;

        public static const LOG_SILENT:int=10;

        public static const DEFAULT_LOG_LEVEL:int=20;

        public var _name:String;

        public var _id:int;

        public var _items:Array;

        public var _contents:flash.utils.Dictionary;

        public var _additionIndex:int=0;

        public var _numConnections:int=7;

        public var _connections:Array;

        public var _loadedRatio:Number=0;

        public var _itemsTotal:int=0;

        public var _itemsLoaded:int=0;

        public var _totalWeight:int=0;

        public var _bytesTotal:int=0;

        public var _bytesTotalCurrent:int=0;

        public var _bytesLoaded:int=0;

        public var _percentLoaded:Number=0;

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

        public var logLevel:int=20;

        public var _allowsAutoIDFromFileName:Boolean=false;

        public var _isRunning:Boolean;

        public var _isFinished:Boolean;

        public var _isPaused:Boolean=true;

        public var _logFunction:Function;

        public var _stringSubstitutions:Object;

        public static var AVAILABLE_EXTENSIONS:Array;

        public static var IMAGE_EXTENSIONS:Array;

        public static var MOVIECLIP_EXTENSIONS:Array;

        public static var TEXT_EXTENSIONS:Array;

        public static var VIDEO_EXTENSIONS:Array;

        public static var SOUND_EXTENSIONS:Array;

        public static var XML_EXTENSIONS:Array;

        public static var _customTypesExtensions:Object;

        public static var _instancesCreated:int=0;

        public static var _allLoaders:Object;

        public static var _typeClasses:Object;
    }
}
