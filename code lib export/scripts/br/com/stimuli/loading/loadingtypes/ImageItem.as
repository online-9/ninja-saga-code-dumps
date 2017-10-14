package br.com.stimuli.loading.loadingtypes
{
   import flash.display.Loader;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.HTTPStatusEvent;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class ImageItem extends LoadingItem
   {
       
      
      public var loader:Loader;
      
      public function ImageItem(url:URLRequest, type:String, uid:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(url,type,uid);
      }
      
      override public function _parseOptions(props:Object) : Array
      {
         context = props[BulkLoader.CONTEXT] || null;
         return super._parseOptions(props);
      }
      
      override public function load() : void
      {
         super.load();
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,100,true);
         loader.contentLoaderInfo.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         loader.load(url,context);
      }
      
      public function _onHttpStatusHandler(evt:HTTPStatusEvent) : void
      {
         _httpStatus = evt.status;
         dispatchEvent(evt);
      }
      
      override public function onErrorHandler(evt:Event) : void
      {
         super.onErrorHandler(evt);
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         try
         {
            _content = loader.content;
         }
         catch(err:Error)
         {
            trace("BulkLoader (Error) :: " + this + " :: onCompleteHandler :: error >> " + err);
            _content = new MovieClip();
         }
         super.onCompleteHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(loader)
            {
               loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         var removalTarget:Object = null;
         if(loader)
         {
            removalTarget = loader.contentLoaderInfo;
            removalTarget.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            removalTarget.removeEventListener(Event.COMPLETE,onCompleteHandler,false);
            removalTarget.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            removalTarget.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
         }
      }
      
      override public function isImage() : Boolean
      {
         return type == BulkLoader.TYPE_IMAGE;
      }
      
      override public function isSWF() : Boolean
      {
         return type == BulkLoader.TYPE_MOVIECLIP;
      }
      
      override public function destroy() : void
      {
         stop();
         cleanListeners();
         _content = null;
         loader = null;
      }
   }
}
