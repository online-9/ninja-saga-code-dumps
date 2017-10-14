package ninjasaga.loader
{
   import de.polygonal.ds.HashMap;
   import flash.display.MovieClip;
   import ninjasaga.Central;
   import com.utils.GF;
   
   public class AssetLoader
   {
      
      private static var loadingPathArray:Array = [];
      
      private static var loadingCallbacks:HashMap = new HashMap();
       
      
      public var path:String;
      
      private var holder;
      
      private var clsName:String;
      
      private var callback:Function;
      
      public var swf:MovieClip;
      
      public var displayObj:MovieClip;
      
      public function AssetLoader(path:String, holder:*, clsName:String, callback:Function = null)
      {
         super();
         this.path = path;
         this.holder = holder;
         this.clsName = clsName;
         this.callback = callback;
         var swf:MovieClip = Central.main.localCache.get(this.path);
         if(null == swf)
         {
            if(loadingPathArray.indexOf(this.path) >= 0)
            {
               if(loadingCallbacks.containsKey(this.path))
               {
                  loadingCallbacks.insert(this.path,loadingCallbacks.find(this.path).push(this));
               }
               else
               {
                  loadingCallbacks.insert(this.path,[this]);
               }
            }
            else
            {
               loadingPathArray.push(this.path);
               Central.main.dynamicLoad(this.path,this.loadCallback);
            }
         }
         else
         {
            this.loadCallback(swf);
         }
      }
      
      private function loadCallback(mc:MovieClip) : void
      {
         var dispObj:MovieClip = null;
         Central.main.localCache.set(this.path,mc);
         loadingPathArray.splice(loadingPathArray.indexOf(this.path),1);
         this.swf = mc;
         if(null != this.holder)
         {
            dispObj = GF.getAsset(mc,this.clsName);
            this.holder.addChild(dispObj);
            this.displayObj = dispObj;
         }
         if(null != this.callback)
         {
            this.callback(this);
         }
         this.refreshAllCallback();
         this.gc();
      }
      
      private function gc() : void
      {
         this.path = null;
         this.holder = null;
         this.clsName = null;
         this.callback = null;
         this.swf = null;
         this.displayObj = null;
      }
      
      private function refreshAllCallback() : void
      {
         var callbackArr:Array = null;
         var i:int = 0;
         if(loadingCallbacks.containsKey(this.path))
         {
            callbackArr = loadingCallbacks.find(this.path);
            loadingCallbacks.remove(this.path);
            for(i = 0; i < callbackArr.length; i++)
            {
               callbackArr[i].loadCallback(this.swf);
            }
         }
      }
   }
}
