package bitemycode.loader
{
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import com.utils.GF;
   import com.utils.Out;
   
   public class DynamicLoader
   {
      
      private static var loaderCounter:int = 0;
      
      private static var storage:HashMap = new HashMap();
       
      
      protected var loaderId:int;
      
      protected var path:String;
      
      protected var holder:MovieClip;
      
      protected var cls:String;
      
      protected var cbfn:Function;
      
      protected var addCache:Boolean;
      
      public function DynamicLoader(path:String, holder:MovieClip, cls:String = null, cbfn:Function = null, addCache:Boolean = false)
      {
         super();
         this.path = path;
         this.holder = holder;
         this.cls = cls;
         this.cbfn = cbfn;
         this.addCache = addCache;
         if(path == null)
         {
            Out.error(this,"path is null");
         }
         else if(addCache && this.get(this.path) != null)
         {
            this.loadCallback(this.get(this.path));
         }
         else
         {
            new OneTimeLoader(path,this.loadCallback);
         }
         this.loaderId = ++loaderCounter;
      }
      
      public static function load(path:String, holder:MovieClip, cls:String = null, cbfn:Function = null, addCache:Boolean = false) : DynamicLoader
      {
         return new DynamicLoader(path,holder,cls,cbfn,addCache);
      }
      
      public function getLoaderId() : int
      {
         return this.loaderId;
      }
      
      protected function loadCallback(mc:MovieClip) : void
      {
         if(this.addCache)
         {
            if(this.get(this.path) == null)
            {
               if(mc != null)
               {
                  this.set(this.path,mc);
               }
            }
         }
         if(this.cls == null)
         {
            this.refreshHolder(mc);
         }
         else
         {
            this.refreshHolder(GF.getAsset(mc,this.cls));
         }
         if(this.cbfn != null)
         {
            this.cbfn(this.loaderId,this.holder);
         }
         this.gc();
      }
      
      protected function refreshHolder(mc:MovieClip) : void
      {
         var i:int = 0;
         if(mc)
         {
            if(this.holder)
            {
               GF.removeAllChild(this.holder);
               this.holder.addChild(mc);
            }
            else
            {
               Out.error(this,"refreshHolder :: holder is null");
            }
         }
         else
         {
            Out.error(this,"refreshHolder :: mc is null");
         }
      }
      
      protected function gc() : void
      {
         this.path = null;
         this.holder = null;
         this.cls = null;
         this.cbfn = null;
         this.addCache = false;
      }
      
      protected function get(swfPath:String) : *
      {
         return storage.find(swfPath);
      }
      
      protected function set(swfPath:String, item:*) : void
      {
         storage.insert(swfPath,item);
      }
   }
}

import br.com.stimuli.loading.BulkLoader;
import flash.events.Event;
import flash.display.MovieClip;
import br.com.stimuli.loading.BulkProgressEvent;
import br.com.stimuli.loading.BulkErrorEvent;
import com.utils.Out;

class OneTimeLoader
{
    
   
   private var path:String;
   
   private var callback:Function;
   
   private var loader:BulkLoader;
   
   function OneTimeLoader(path:String, cb:Function)
   {
      super();
      this.path = path;
      this.callback = cb;
      this.loader = BulkLoader.createUniqueNamedLoader();
      this.loader.add(this.path);
      this.loader.addEventListener(BulkLoader.COMPLETE,this.onLoadFinish);
      this.loader.addEventListener(BulkLoader.PROGRESS,this.onLoadProgress);
      this.loader.addEventListener(BulkLoader.ERROR,this.onLoadError);
      this.loader.start();
   }
   
   private function onLoadFinish(evt:Event) : void
   {
      var mc:MovieClip = this.loader.getMovieClip(this.path);
      this.loader.removeAll();
      this.loader.removeEventListener(BulkLoader.COMPLETE,this.onLoadFinish);
      this.loader.removeEventListener(BulkLoader.PROGRESS,this.onLoadProgress);
      this.loader.removeEventListener(BulkLoader.ERROR,this.onLoadError);
      this.callback(mc);
      this.loader = null;
      this.callback = null;
      this.path = null;
   }
   
   private function onLoadProgress(evt:BulkProgressEvent) : void
   {
   }
   
   private function onLoadError(evt:BulkErrorEvent) : void
   {
      var loadingItem:* = undefined;
      for each(loadingItem in evt.errors)
      {
         Out.error(this,"BulkLoader :: " + loadingItem + " has failed to load.");
      }
   }
}
