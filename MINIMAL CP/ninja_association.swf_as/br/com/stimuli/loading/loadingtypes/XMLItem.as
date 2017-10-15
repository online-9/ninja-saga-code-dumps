package br.com.stimuli.loading.loadingtypes 
{
    import br.com.stimuli.loading.*;
    import flash.events.*;
    import flash.net.*;
    
    public class XMLItem extends br.com.stimuli.loading.loadingtypes.LoadingItem
    {
        public function XMLItem(arg1:flash.net.URLRequest, arg2:String, arg3:String)
        {
            super(arg1, arg2, arg3);
            return;
        }

        public override function _parseOptions(arg1:Object):Array
        {
            return super._parseOptions(arg1);
        }

        public override function load():void
        {
            super.load();
            this.loader = new flash.net.URLLoader();
            this.loader.addEventListener(flash.events.ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            this.loader.addEventListener(flash.events.Event.COMPLETE, this.onCompleteHandler, false, 0, true);
            this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onErrorHandler, false, 0, true);
            this.loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false, 0, true);
            this.loader.addEventListener(flash.events.Event.OPEN, this.onStartedHandler, false, 0, true);
            this.loader.load(url);
            return;
        }

        public override function onErrorHandler(arg1:flash.events.Event):void
        {
            super.onErrorHandler(arg1);
            return;
        }

        public override function onStartedHandler(arg1:flash.events.Event):void
        {
            super.onStartedHandler(arg1);
            return;
        }

        public override function onCompleteHandler(arg1:flash.events.Event):void
        {
            _content = new XML(this.loader.data);
            super.onCompleteHandler(arg1);
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
            if (this.loader)
            {
                this.loader.removeEventListener(flash.events.ProgressEvent.PROGRESS, onProgressHandler, false);
                this.loader.removeEventListener(flash.events.Event.COMPLETE, this.onCompleteHandler, false);
                this.loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onErrorHandler, false);
                this.loader.removeEventListener(br.com.stimuli.loading.BulkLoader.OPEN, this.onStartedHandler, false);
                this.loader.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, super.onHttpStatusHandler, false);
            }
            return;
        }

        public override function isText():Boolean
        {
            return true;
        }

        public override function destroy():void
        {
            this.stop();
            this.cleanListeners();
            _content = null;
            this.loader = null;
            return;
        }

        public var loader:flash.net.URLLoader;
    }
}
