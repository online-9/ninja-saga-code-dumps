package br.com.stimuli.loading.loadingtypes
{
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.display.Sprite;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   
   public class VideoItem extends LoadingItem
   {
       
      
      private var nc:NetConnection;
      
      var stream:NetStream;
      
      private var dummyEventTrigger:Sprite;
      
      private var _checkPolicyFile:Boolean;
      
      var pausedAtStart:Boolean = false;
      
      private var _metaData:Object;
      
      private var _canBeginStreaming:Boolean = false;
      
      public function VideoItem(url:URLRequest, type:String, uid:String)
      {
         specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE,BulkLoader.PAUSED_AT_START];
         super(url,type,uid);
      }
      
      override public function _parseOptions(props:Object) : Array
      {
         pausedAtStart = props[BulkLoader.PAUSED_AT_START] || false;
         _checkPolicyFile = props[BulkLoader.CHECK_POLICY_FILE] || false;
         return super._parseOptions(props);
      }
      
      override public function load() : void
      {
         super.load();
         nc = new NetConnection();
         nc.connect(null);
         stream = new NetStream(nc);
         stream.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         stream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
         dummyEventTrigger = new Sprite();
         dummyEventTrigger.addEventListener(Event.ENTER_FRAME,createNetStreamEvent,false,0,true);
         var customClient:Object = new Object();
         customClient.onCuePoint = function(... args):void
         {
         };
         customClient.onMetaData = onVideoMetadata;
         customClient.onPlayStatus = function(... args):void
         {
         };
         stream.client = customClient;
         stream.play(url.url,_checkPolicyFile);
         stream.seek(0);
      }
      
      public function createNetStreamEvent(evt:Event) : void
      {
         var completeEvent:Event = null;
         var startEvent:Event = null;
         var event:ProgressEvent = null;
         var timeElapsed:int = 0;
         var currentSpeed:Number = NaN;
         var estimatedTimeRemaining:Number = NaN;
         var videoTimeToDownload:Number = NaN;
         if(_bytesTotal == _bytesLoaded && _bytesTotal > 8)
         {
            if(dummyEventTrigger)
            {
               dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            }
            completeEvent = new Event(Event.COMPLETE);
            onCompleteHandler(completeEvent);
         }
         else if(_bytesTotal == 0 && stream.bytesTotal > 4)
         {
            startEvent = new Event(Event.OPEN);
            onStartedHandler(startEvent);
            _bytesLoaded = stream.bytesLoaded;
            _bytesTotal = stream.bytesTotal;
         }
         else if(stream)
         {
            event = new ProgressEvent(ProgressEvent.PROGRESS,false,false,stream.bytesLoaded,stream.bytesTotal);
            if(isVideo() && metaData && !_canBeginStreaming)
            {
               timeElapsed = getTimer() - responseTime;
               currentSpeed = bytesLoaded / (timeElapsed / 1000);
               estimatedTimeRemaining = _bytesRemaining / (currentSpeed * 0.8);
               videoTimeToDownload = metaData.duration - stream.bufferLength;
               if(videoTimeToDownload > estimatedTimeRemaining)
               {
                  fireCanBeginStreamingEvent();
               }
            }
            super.onProgressHandler(event);
         }
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         _content = stream;
         super.onCompleteHandler(evt);
      }
      
      override public function onStartedHandler(evt:Event) : void
      {
         _content = stream;
         if(pausedAtStart && stream)
         {
            stream.pause();
         }
         super.onStartedHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(stream)
            {
               stream.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(stream)
         {
            stream.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         }
         if(dummyEventTrigger)
         {
            dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            dummyEventTrigger = null;
         }
      }
      
      override public function isVideo() : Boolean
      {
         return true;
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         if(!stream)
         {
         }
         stop();
         cleanListeners();
         stream = null;
         super.destroy();
      }
      
      function onNetStatus(evt:NetStatusEvent) : void
      {
         var e:Event = null;
         if(!stream)
         {
            return;
         }
         stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         if(evt.info.code == "NetStream.Play.Start")
         {
            _content = stream;
            e = new Event(Event.OPEN);
            onStartedHandler(e);
         }
         else if(evt.info.code == "NetStream.Play.StreamNotFound")
         {
            onErrorHandler(evt);
         }
      }
      
      function onVideoMetadata(evt:*) : void
      {
         _metaData = evt;
      }
      
      public function get metaData() : Object
      {
         return _metaData;
      }
      
      public function get checkPolicyFile() : Object
      {
         return _checkPolicyFile;
      }
      
      private function fireCanBeginStreamingEvent() : void
      {
         if(_canBeginStreaming)
         {
            return;
         }
         _canBeginStreaming = true;
         var evt:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
         dispatchEvent(evt);
      }
   }
}
