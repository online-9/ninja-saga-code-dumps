package br.com.stimuli.loading.loadingtypes 
{
    import br.com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class VideoItem extends br.com.stimuli.loading.loadingtypes.LoadingItem
    {
        public function VideoItem(arg1:flash.net.URLRequest, arg2:String, arg3:String)
        {
            specificAvailableProps = [br.com.stimuli.loading.BulkLoader.CHECK_POLICY_FILE, br.com.stimuli.loading.BulkLoader.PAUSED_AT_START];
            super(arg1, arg2, arg3);
            return;
        }

        public override function _parseOptions(arg1:Object):Array
        {
            this.pausedAtStart = arg1[br.com.stimuli.loading.BulkLoader.PAUSED_AT_START] || false;
            this._checkPolicyFile = arg1[br.com.stimuli.loading.BulkLoader.CHECK_POLICY_FILE] || false;
            return super._parseOptions(arg1);
        }

        public override function load():void
        {
            var customClient:Object;

            var loc1:*;
            super.load();
            this.nc = new flash.net.NetConnection();
            this.nc.connect(null);
            this.stream = new flash.net.NetStream(this.nc);
            this.stream.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            this.stream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus, false, 0, true);
            this.dummyEventTrigger = new flash.display.Sprite();
            this.dummyEventTrigger.addEventListener(flash.events.Event.ENTER_FRAME, this.createNetStreamEvent, false, 0, true);
            customClient = new Object();
            customClient.onCuePoint = function (... rest):void
            {
                return;
            }
            customClient.onMetaData = this.onVideoMetadata;
            customClient.onPlayStatus = function (... rest):void
            {
                return;
            }
            this.stream.client = customClient;
            this.stream.play(url.url, this._checkPolicyFile);
            this.stream.seek(0);
            return;
        }

        public function createNetStreamEvent(arg1:flash.events.Event):void
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
            loc5 = NaN;
            var loc6:*;
            loc6 = NaN;
            var loc7:*;
            loc7 = NaN;
            if (_bytesTotal == _bytesLoaded && _bytesTotal > 8)
            {
                if (this.dummyEventTrigger)
                {
                    this.dummyEventTrigger.removeEventListener(flash.events.Event.ENTER_FRAME, this.createNetStreamEvent, false);
                }
                loc1 = new flash.events.Event(flash.events.Event.COMPLETE);
                this.onCompleteHandler(loc1);
            }
            else 
            {
                if (_bytesTotal == 0 && this.stream.bytesTotal > 4)
                {
                    loc2 = new flash.events.Event(flash.events.Event.OPEN);
                    this.onStartedHandler(loc2);
                    _bytesLoaded = this.stream.bytesLoaded;
                    _bytesTotal = this.stream.bytesTotal;
                }
                else 
                {
                    if (this.stream)
                    {
                        loc3 = new flash.events.ProgressEvent(flash.events.ProgressEvent.PROGRESS, false, false, this.stream.bytesLoaded, this.stream.bytesTotal);
                        if (this.isVideo() && this.metaData && !this._canBeginStreaming)
                        {
                            loc4 = flash.utils.getTimer() - responseTime;
                            loc5 = bytesLoaded / (loc4 / 1000);
                            loc6 = _bytesRemaining / (loc5 * 0.8);
                            if ((loc7 = this.metaData.duration - this.stream.bufferLength) > loc6)
                            {
                                this.fireCanBeginStreamingEvent();
                            }
                        }
                        super.onProgressHandler(loc3);
                    }
                }
            }
            return;
        }

        public override function onCompleteHandler(arg1:flash.events.Event):void
        {
            _content = this.stream;
            super.onCompleteHandler(arg1);
            return;
        }

        public override function onStartedHandler(arg1:flash.events.Event):void
        {
            _content = this.stream;
            if (this.pausedAtStart && this.stream)
            {
                this.stream.pause();
            }
            super.onStartedHandler(arg1);
            return;
        }

        public override function stop():void
        {
            try
            {
                if (this.stream)
                {
                    this.stream.close();
                }
            }
            catch (e:Error)
            {
            };
            super.stop();
            return;
        }

        public override function cleanListeners():void
        {
            if (this.stream)
            {
                this.stream.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, onErrorHandler, false);
                this.stream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus, false);
            }
            if (this.dummyEventTrigger)
            {
                this.dummyEventTrigger.removeEventListener(flash.events.Event.ENTER_FRAME, this.createNetStreamEvent, false);
                this.dummyEventTrigger = null;
            }
            return;
        }

        public override function isVideo():Boolean
        {
            return true;
        }

        public override function isStreamable():Boolean
        {
            return true;
        }

        public override function destroy():void
        {
            if (!this.stream)
            {
            };
            this.stop();
            this.cleanListeners();
            this.stream = null;
            super.destroy();
            return;
        }

        function onNetStatus(arg1:flash.events.NetStatusEvent):void
        {
            var loc1:*;
            loc1 = null;
            if (!this.stream)
            {
                return;
            }
            this.stream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus, false);
            if (arg1.info.code != "NetStream.Play.Start")
            {
                if (arg1.info.code == "NetStream.Play.StreamNotFound")
                {
                    onErrorHandler(arg1);
                }
            }
            else 
            {
                _content = this.stream;
                loc1 = new flash.events.Event(flash.events.Event.OPEN);
                this.onStartedHandler(loc1);
            }
            return;
        }

        function onVideoMetadata(arg1:*):void
        {
            this._metaData = arg1;
            return;
        }

        public function get metaData():Object
        {
            return this._metaData;
        }

        public function get checkPolicyFile():Object
        {
            return this._checkPolicyFile;
        }

        private function fireCanBeginStreamingEvent():void
        {
            if (this._canBeginStreaming)
            {
                return;
            }
            this._canBeginStreaming = true;
            var loc1:*;
            loc1 = new flash.events.Event(br.com.stimuli.loading.BulkLoader.CAN_BEGIN_PLAYING);
            dispatchEvent(loc1);
            return;
        }

        private var nc:flash.net.NetConnection;

        var stream:flash.net.NetStream;

        private var dummyEventTrigger:flash.display.Sprite;

        private var _checkPolicyFile:Boolean;

        var pausedAtStart:Boolean=false;

        private var _metaData:Object;

        private var _canBeginStreaming:Boolean=false;
    }
}
