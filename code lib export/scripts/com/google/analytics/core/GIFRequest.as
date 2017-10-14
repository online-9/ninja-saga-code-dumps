package com.google.analytics.core
{
   import flash.events.IOErrorEvent;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.utils.Variables;
   import flash.net.URLRequest;
   import com.google.analytics.utils.Protocols;
   import flash.events.SecurityErrorEvent;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.v4.Configuration;
   import flash.system.LoaderContext;
   import flash.display.Loader;
   import flash.events.Event;
   
   public class GIFRequest
   {
       
      
      private var _info:Environment;
      
      private var _count:int;
      
      private var _utmac:String;
      
      private var _alertcount:int;
      
      private var _debug:DebugConfiguration;
      
      private var _lastRequest:URLRequest;
      
      private var _buffer:com.google.analytics.core.Buffer;
      
      private var _config:Configuration;
      
      private var _requests:Array;
      
      public function GIFRequest(config:Configuration, debug:DebugConfiguration, buffer:com.google.analytics.core.Buffer, info:Environment)
      {
         super();
         _config = config;
         _debug = debug;
         _buffer = buffer;
         _info = info;
         _count = 0;
         _alertcount = 0;
         _requests = [];
      }
      
      public function get utmn() : String
      {
         return Utils.generate32bitRandom() as String;
      }
      
      public function onIOError(event:IOErrorEvent) : void
      {
         var url:String = _lastRequest.url;
         var id:String = String(_requests.length - 1);
         var msg:* = "Gif Request #" + id + " failed";
         if(_debug.GIFRequests)
         {
            if(!_debug.verbose)
            {
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = _shortenURL(url);
            }
            if(int(_debug.mode) > int(VisualDebugMode.basic))
            {
               msg = msg + (" \"" + url + "\" does not exists or is unreachable");
            }
            _debug.failure(msg);
         }
         else
         {
            _debug.warning(msg);
         }
         _removeListeners(event.target);
      }
      
      public function send(account:String, variables:Variables = null, force:Boolean = false, rateLimit:Boolean = false) : void
      {
         var localPath:String = null;
         var localImage:URLRequest = null;
         var remoteImage:URLRequest = null;
         _utmac = account;
         if(!variables)
         {
            variables = new Variables();
         }
         variables.URIencode = false;
         variables.pre = ["utmwv","utmn","utmhn","utmt","utme","utmcs","utmsr","utmsc","utmul","utmje","utmfl","utmdt","utmhid","utmr","utmp"];
         variables.post = ["utmcc"];
         if(_debug.verbose)
         {
            _debug.info("tracking: " + _buffer.utmb.trackCount + "/" + _config.trackingLimitPerSession,VisualDebugMode.geek);
         }
         if(_buffer.utmb.trackCount < _config.trackingLimitPerSession || force)
         {
            if(rateLimit)
            {
               updateToken();
            }
            if(force || !rateLimit || _buffer.utmb.token >= 1)
            {
               if(!force && rateLimit)
               {
                  _buffer.utmb.token = _buffer.utmb.token - 1;
               }
               _buffer.utmb.trackCount = _buffer.utmb.trackCount + 1;
               if(_debug.verbose)
               {
                  _debug.info(_buffer.utmb.toString(),VisualDebugMode.geek);
               }
               variables.utmwv = utmwv;
               variables.utmn = Utils.generate32bitRandom();
               if(_info.domainName != "")
               {
                  variables.utmhn = _info.domainName;
               }
               if(_config.sampleRate < 1)
               {
                  variables.utmsp = _config.sampleRate * 100;
               }
               if(_config.serverMode == ServerOperationMode.local || _config.serverMode == ServerOperationMode.both)
               {
                  localPath = _info.locationSWFPath;
                  if(localPath.lastIndexOf("/") > 0)
                  {
                     localPath = localPath.substring(0,localPath.lastIndexOf("/"));
                  }
                  localImage = new URLRequest();
                  if(_config.localGIFpath.indexOf("http") == 0)
                  {
                     localImage.url = _config.localGIFpath;
                  }
                  else
                  {
                     localImage.url = localPath + _config.localGIFpath;
                  }
                  localImage.url = localImage.url + ("?" + variables.toString());
                  if(_debug.active && _debug.GIFRequests)
                  {
                     _debugSend(localImage);
                  }
                  else
                  {
                     sendRequest(localImage);
                  }
               }
               if(_config.serverMode == ServerOperationMode.remote || _config.serverMode == ServerOperationMode.both)
               {
                  remoteImage = new URLRequest();
                  if(_info.protocol == Protocols.HTTPS)
                  {
                     remoteImage.url = _config.secureRemoteGIFpath;
                  }
                  else if(_info.protocol == Protocols.HTTP)
                  {
                     remoteImage.url = _config.remoteGIFpath;
                  }
                  else
                  {
                     remoteImage.url = _config.remoteGIFpath;
                  }
                  variables.utmac = utmac;
                  variables.utmcc = encodeURIComponent(utmcc);
                  remoteImage.url = remoteImage.url + ("?" + variables.toString());
                  if(_debug.active && _debug.GIFRequests)
                  {
                     _debugSend(remoteImage);
                  }
                  else
                  {
                     sendRequest(remoteImage);
                  }
               }
            }
         }
      }
      
      public function onSecurityError(event:SecurityErrorEvent) : void
      {
         if(_debug.GIFRequests)
         {
            _debug.failure(event.text);
         }
      }
      
      public function get utmsp() : String
      {
         return _config.sampleRate * 100 as String;
      }
      
      public function get utmcc() : String
      {
         var cookies:Array = [];
         if(_buffer.hasUTMA())
         {
            cookies.push(_buffer.utma.toURLString() + ";");
         }
         if(_buffer.hasUTMZ())
         {
            cookies.push(_buffer.utmz.toURLString() + ";");
         }
         if(_buffer.hasUTMV())
         {
            cookies.push(_buffer.utmv.toURLString() + ";");
         }
         return cookies.join("+");
      }
      
      public function get utmac() : String
      {
         return _utmac;
      }
      
      public function get utmwv() : String
      {
         return _config.version;
      }
      
      public function sendRequest(request:URLRequest) : void
      {
         var loader:Loader = new Loader();
         loader.name = String(_count++);
         var context:LoaderContext = new LoaderContext(false);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
         _lastRequest = request;
         _requests[loader.name] = new RequestObject(request);
         try
         {
            loader.load(request,context);
         }
         catch(e:Error)
         {
            _debug.failure("\"Loader.load()\" could not instanciate Gif Request");
         }
      }
      
      private function _removeListeners(target:Object) : void
      {
         target.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
         target.removeEventListener(Event.COMPLETE,onComplete);
      }
      
      public function updateToken() : void
      {
         var tokenDelta:Number = NaN;
         var timestamp:Number = new Date().getTime();
         tokenDelta = (timestamp - _buffer.utmb.lastTime) * (_config.tokenRate / 1000);
         if(_debug.verbose)
         {
            _debug.info("tokenDelta: " + tokenDelta,VisualDebugMode.geek);
         }
         if(tokenDelta >= 1)
         {
            _buffer.utmb.token = Math.min(Math.floor(_buffer.utmb.token + tokenDelta),_config.bucketCapacity);
            _buffer.utmb.lastTime = timestamp;
            if(_debug.verbose)
            {
               _debug.info(_buffer.utmb.toString(),VisualDebugMode.geek);
            }
         }
      }
      
      public function get utmhn() : String
      {
         return _info.domainName;
      }
      
      private function _shortenURL(url:String) : String
      {
         var paths:Array = null;
         if(url.length > 60)
         {
            paths = url.split("/");
            while(url.length > 60)
            {
               paths.shift();
               url = "../" + paths.join("/");
            }
         }
         return url;
      }
      
      private function _debugSend(request:URLRequest) : void
      {
         var url:String = null;
         var data:* = "";
         switch(_debug.mode)
         {
            case VisualDebugMode.geek:
               data = "Gif Request #" + _alertcount + ":\n" + request.url;
               break;
            case VisualDebugMode.advanced:
               url = request.url;
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = _shortenURL(url);
               data = "Send Gif Request #" + _alertcount + ":\n" + url + " ?";
               break;
            case VisualDebugMode.basic:
            default:
               data = "Send " + _config.serverMode.toString() + " Gif Request #" + _alertcount + " ?";
         }
         _debug.alertGifRequest(data,request,this);
         _alertcount++;
      }
      
      public function onComplete(event:Event) : void
      {
         var id:String = event.target.loader.name;
         _requests[id].complete();
         var msg:* = "Gif Request #" + id + " sent";
         var url:String = _requests[id].request.url;
         if(_debug.GIFRequests)
         {
            if(!_debug.verbose)
            {
               if(url.indexOf("?") > -1)
               {
                  url = url.split("?")[0];
               }
               url = _shortenURL(url);
            }
            if(int(_debug.mode) > int(VisualDebugMode.basic))
            {
               msg = msg + (" to \"" + url + "\"");
            }
            _debug.success(msg);
         }
         else
         {
            _debug.info(msg);
         }
         _removeListeners(event.target);
      }
   }
}
