package br.com.stimuli.loading.loadingtypes 
{
    import br.com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class ImageItem extends br.com.stimuli.loading.loadingtypes.LoadingItem
    {
        public function ImageItem(arg1:flash.net.URLRequest, arg2:String, arg3:String)
        {
            specificAvailableProps = [br.com.stimuli.loading.BulkLoader.CONTEXT];
            super(arg1, arg2, arg3);
            return;
        }

        public override function _parseOptions(arg1:Object):Array
        {
            context = arg1[br.com.stimuli.loading.BulkLoader.CONTEXT] || null;
            return super._parseOptions(arg1);
        }

        public override function load():void
        {
            super.load();
            this.loader = new flash.display.Loader();
            this.loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onCompleteHandler, false, 0, true);
            this.loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onErrorHandler, false, 100, true);
            this.loader.contentLoaderInfo.addEventListener(flash.events.Event.OPEN, onStartedHandler, false, 0, true);
            this.loader.contentLoaderInfo.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            this.loader.load(url, context);
            return;
        }

        public function _onHttpStatusHandler(arg1:flash.events.HTTPStatusEvent):void
        {
            _httpStatus = arg1.status;
            dispatchEvent(arg1);
            return;
        }

        public override function onErrorHandler(arg1:flash.events.Event):void
        {
            super.onErrorHandler(arg1);
            return;
        }

        public override function onCompleteHandler(arg1:flash.events.Event):void
        {
            var evt:flash.events.Event;

            var loc1:*;
            evt = arg1;
            try
            {
                _content = this.loader.content;
            }
            catch (err:Error)
            {
                trace("BulkLoader (Error) :: " + this + " :: onCompleteHandler :: error >> " + undefined);
                _content = new flash.display.MovieClip();
            }
            super.onCompleteHandler(evt);
            return;
        }

        public override function stop():void
        {
            try
            {
                if (this.loader)
                {
                    this.loader.close();
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
            var loc1:*;
            loc1 = null;
            if (this.loader)
            {
                loc1 = this.loader.contentLoaderInfo;
                loc1.removeEventListener(flash.events.ProgressEvent.PROGRESS, onProgressHandler, false);
                loc1.removeEventListener(flash.events.Event.COMPLETE, this.onCompleteHandler, false);
                loc1.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onErrorHandler, false);
                loc1.removeEventListener(br.com.stimuli.loading.BulkLoader.OPEN, onStartedHandler, false);
                loc1.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            }
            return;
        }

        public override function isImage():Boolean
        {
            return type == br.com.stimuli.loading.BulkLoader.TYPE_IMAGE;
        }

        public override function isSWF():Boolean
        {
            return type == br.com.stimuli.loading.BulkLoader.TYPE_MOVIECLIP;
        }

        public override function destroy():void
        {
            this.stop();
            this.cleanListeners();
            _content = null;
            this.loader = null;
            return;
        }

        public var loader:flash.display.Loader;
    }
}
