package bitemycode.loader 
{
    import com.utils.*;
    import de.polygonal.ds.*;
    import flash.display.*;
    
    public class DynamicLoader extends Object
    {
        public function DynamicLoader(arg1:String, arg2:flash.display.MovieClip, arg3:String=null, arg4:Function=null, arg5:Boolean=false)
        {
            super();
            this.path = arg1;
            this.holder = arg2;
            this.cls = arg3;
            this.cbfn = arg4;
            this.addCache = arg5;
            if (arg1 != null)
            {
                if (arg5 && !(this.get(this.path) == null))
                {
                    this.loadCallback(this.get(this.path));
                }
                else 
                {
                    new OneTimeLoader(arg1, this.loadCallback);
                }
            }
            else 
            {
                com.utils.Out.error(this, "path is null");
            }
            var loc1:*;
            var loc2:*;
            this.loaderId = ++loaderCounter;
            return;
        }

        public function getLoaderId():int
        {
            return this.loaderId;
        }

        protected function loadCallback(arg1:flash.display.MovieClip):void
        {
            if (this.addCache)
            {
                if (this.get(this.path) == null)
                {
                    if (arg1 != null)
                    {
                        this.set(this.path, arg1);
                    }
                }
            }
            if (this.cls != null)
            {
                this.refreshHolder(com.utils.GF.getAsset(arg1, this.cls));
            }
            else 
            {
                this.refreshHolder(arg1);
            }
            if (this.cbfn != null)
            {
                this.cbfn(this.loaderId, this.holder);
            }
            this.gc();
            return;
        }

        protected function refreshHolder(arg1:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = 0;
            if (arg1)
            {
                if (this.holder)
                {
                    com.utils.GF.removeAllChild(this.holder);
                    this.holder.addChild(arg1);
                }
                else 
                {
                    com.utils.Out.error(this, "refreshHolder :: holder is null");
                }
            }
            else 
            {
                com.utils.Out.error(this, "refreshHolder :: mc is null");
            }
            return;
        }

        protected function gc():void
        {
            this.path = null;
            this.holder = null;
            this.cls = null;
            this.cbfn = null;
            this.addCache = false;
            return;
        }

        protected function get(arg1:String):*
        {
            return storage.find(arg1);
        }

        protected function set(arg1:String, arg2:*):void
        {
            storage.insert(arg1, arg2);
            return;
        }

        public static function load(arg1:String, arg2:flash.display.MovieClip, arg3:String=null, arg4:Function=null, arg5:Boolean=false):bitemycode.loader.DynamicLoader
        {
            return new DynamicLoader(arg1, arg2, arg3, arg4, arg5);
        }

        
        {
            loaderCounter = 0;
            storage = new de.polygonal.ds.HashMap();
        }

        protected var loaderId:int;

        protected var path:String;

        protected var holder:flash.display.MovieClip;

        protected var cls:String;

        protected var cbfn:Function;

        protected var addCache:Boolean;

        private static var loaderCounter:int=0;

        private static var storage:de.polygonal.ds.HashMap;
    }
}

import br.com.stimuli.loading.*;
import com.utils.*;
import flash.display.*;
import flash.events.*;


class OneTimeLoader extends Object
{
    public function OneTimeLoader(arg1:String, arg2:Function)
    {
        super();
        this.path = arg1;
        this.callback = arg2;
        this.loader = br.com.stimuli.loading.BulkLoader.createUniqueNamedLoader();
        this.loader.add(this.path);
        this.loader.addEventListener(br.com.stimuli.loading.BulkLoader.COMPLETE, this.onLoadFinish);
        this.loader.addEventListener(br.com.stimuli.loading.BulkLoader.PROGRESS, this.onLoadProgress);
        this.loader.addEventListener(br.com.stimuli.loading.BulkLoader.ERROR, this.onLoadError);
        this.loader.start();
        return;
    }

    private function onLoadFinish(arg1:flash.events.Event):void
    {
        var loc1:*;
        loc1 = this.loader.getMovieClip(this.path);
        this.loader.removeAll();
        this.loader.removeEventListener(br.com.stimuli.loading.BulkLoader.COMPLETE, this.onLoadFinish);
        this.loader.removeEventListener(br.com.stimuli.loading.BulkLoader.PROGRESS, this.onLoadProgress);
        this.loader.removeEventListener(br.com.stimuli.loading.BulkLoader.ERROR, this.onLoadError);
        this.callback(loc1);
        this.loader = null;
        this.callback = null;
        this.path = null;
        return;
    }

    private function onLoadProgress(arg1:br.com.stimuli.loading.BulkProgressEvent):void
    {
        return;
    }

    private function onLoadError(arg1:br.com.stimuli.loading.BulkErrorEvent):void
    {
        var loc1:*;
        loc1 = undefined;
        var loc2:*;
        loc2 = 0;
        var loc3:*;
        loc3 = arg1.errors;
        for each (loc1 in loc3)
        {
            com.utils.Out.error(this, "BulkLoader :: " + loc1 + " has failed to load.");
        }
        return;
    }

    private var path:String;

    private var callback:Function;

    private var loader:br.com.stimuli.loading.BulkLoader;
}