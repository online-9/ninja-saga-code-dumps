package br.com.stimuli.loading.loadingtypes 
{
    import br.com.stimuli.loading.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class SoundItem extends br.com.stimuli.loading.loadingtypes.LoadingItem
    {
        public function SoundItem(arg1:flash.net.URLRequest, arg2:String, arg3:String)
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
            this.loader = new flash.media.Sound();
            this.loader.addEventListener(flash.events.ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            this.loader.addEventListener(flash.events.Event.COMPLETE, this.onCompleteHandler, false, 0, true);
            this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onErrorHandler, false, 0, true);
            this.loader.addEventListener(flash.events.Event.OPEN, this.onStartedHandler, false, 0, true);
            this.loader.load(url, context);
            return;
        }

        public override function onStartedHandler(arg1:flash.events.Event):void
        {
            _content = this.loader;
            super.onStartedHandler(arg1);
            return;
        }

        public override function onErrorHandler(arg1:flash.events.Event):void
        {
            super.onErrorHandler(arg1);
            return;
        }

        public override function onCompleteHandler(arg1:flash.events.Event):void
        {
            _content = this.loader;
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
            }
            return;
        }

        public override function isStreamable():Boolean
        {
            return true;
        }

        public override function isSound():Boolean
        {
            return true;
        }

        public override function destroy():void
        {
            this.cleanListeners();
            this.stop();
            _content = null;
            this.loader = null;
            return;
        }

        public var loader:flash.media.Sound;
    }
}
