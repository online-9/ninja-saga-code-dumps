package com.google.analytics
{
   import com.google.analytics.utils.Version;
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.utils.Environment;
   import flash.events.Event;
   import com.google.analytics.v4.Configuration;
   import com.google.analytics.core.IdleTimer;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.core.Buffer;
   import com.google.analytics.v4.GoogleAnalyticsAPI;
   import com.google.analytics.v4.Bridge;
   import com.google.analytics.core.EventTracker;
   import flash.display.DisplayObject;
   import com.google.analytics.external.JavascriptProxy;
   import com.google.analytics.external.HTMLDOM;
   import flash.events.EventDispatcher;
   import com.google.analytics.core.GIFRequest;
   import com.google.analytics.debug.Layout;
   import com.google.analytics.core.TrackerCache;
   import com.google.analytics.core.TrackerMode;
   import com.google.analytics.events.AnalyticsEvent;
   import com.google.analytics.v4.Tracker;
   import com.google.analytics.core.ServerOperationMode;
   
   public class GATracker implements AnalyticsTracker
   {
      
      public static var version:Version = API.version;
      
      public static var autobuild:Boolean = true;
       
      
      private var _adSense:AdSenseGlobals;
      
      private var _env:Environment;
      
      private var _visualDebug:Boolean;
      
      private var _idleTimer:IdleTimer;
      
      private var _debug:DebugConfiguration;
      
      private var _buffer:Buffer;
      
      private var _config:Configuration;
      
      private var _mode:String;
      
      private var _display:DisplayObject;
      
      private var _jsproxy:JavascriptProxy;
      
      private var _dom:HTMLDOM;
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _ready:Boolean = false;
      
      private var _gifRequest:GIFRequest;
      
      private var _account:String;
      
      private var _tracker:GoogleAnalyticsAPI;
      
      public function GATracker(display:DisplayObject, account:String, mode:String = "AS3", visualDebug:Boolean = false, config:Configuration = null, debug:DebugConfiguration = null)
      {
         super();
         _display = display;
         _eventDispatcher = new EventDispatcher(this);
         _tracker = new TrackerCache();
         this.account = account;
         this.mode = mode;
         this.visualDebug = visualDebug;
         if(!debug)
         {
            this.debug = new DebugConfiguration();
         }
         if(!config)
         {
            this.config = new Configuration(debug);
         }
         if(autobuild)
         {
            _factory();
         }
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         _tracker.link(targetUrl,useHash);
      }
      
      public function addOrganic(param1:String, param2:String) : void
      {
         _tracker.addOrganic(param1,param2);
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         _tracker.setAllowLinker(enable);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String = null, param4:Number = NaN) : Boolean
      {
         return _tracker.trackEvent(param1,param2,param3,param4);
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         _tracker.setCookieTimeout(newDefaultTimeout);
      }
      
      public function trackTrans() : void
      {
         _tracker.trackTrans();
      }
      
      public function getClientInfo() : Boolean
      {
         return _tracker.getClientInfo();
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         _tracker.trackPageview(pageURL);
      }
      
      public function setClientInfo(param1:Boolean) : void
      {
         _tracker.setClientInfo(param1);
      }
      
      public function get account() : String
      {
         return _account;
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         _tracker.linkByPost(formObject,useHash);
      }
      
      public function getDetectTitle() : Boolean
      {
         return _tracker.getDetectTitle();
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return _eventDispatcher.dispatchEvent(event);
      }
      
      public function get config() : Configuration
      {
         return _config;
      }
      
      public function set mode(value:String) : void
      {
         _mode = value;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _eventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function setDetectFlash(param1:Boolean) : void
      {
         _tracker.setDetectFlash(param1);
      }
      
      public function resetSession() : void
      {
         _tracker.resetSession();
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         _tracker.setCampNameKey(newCampNameKey);
      }
      
      public function get debug() : DebugConfiguration
      {
         return _debug;
      }
      
      public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         _tracker.addItem(item,sku,name,category,price,quantity);
      }
      
      private function _bridgeFactory() : GoogleAnalyticsAPI
      {
         debug.info("GATracker (Bridge) v" + version + "\naccount: " + account);
         return new Bridge(account,_debug,_jsproxy);
      }
      
      public function clearIgnoredOrganic() : void
      {
         _tracker.clearIgnoredOrganic();
      }
      
      public function set account(value:String) : void
      {
         _account = value;
      }
      
      public function setVar(newVal:String) : void
      {
         _tracker.setVar(newVal);
      }
      
      public function build() : void
      {
         if(!isReady())
         {
            _factory();
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         _eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         _tracker.setDomainName(newDomainName);
      }
      
      public function createEventTracker(param1:String) : EventTracker
      {
         return _tracker.createEventTracker(param1);
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         _tracker.setCampSourceKey(newCampSrcKey);
      }
      
      public function set config(value:Configuration) : void
      {
         _config = value;
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object
      {
         return _tracker.addTrans(orderId,affiliation,total,tax,shipping,city,state,country);
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         _tracker.setCampContentKey(newCampContentKey);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return _eventDispatcher.willTrigger(type);
      }
      
      public function setLocalServerMode() : void
      {
         _tracker.setLocalServerMode();
      }
      
      public function getLocalGifPath() : String
      {
         return _tracker.getLocalGifPath();
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         _tracker.setAllowAnchor(enable);
      }
      
      public function clearIgnoredRef() : void
      {
         _tracker.clearIgnoredRef();
      }
      
      public function isReady() : Boolean
      {
         return _ready;
      }
      
      public function get mode() : String
      {
         return _mode;
      }
      
      public function set debug(value:DebugConfiguration) : void
      {
         _debug = value;
      }
      
      public function setLocalGifPath(param1:String) : void
      {
         _tracker.setLocalGifPath(param1);
      }
      
      public function getVersion() : String
      {
         return _tracker.getVersion();
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         _tracker.setSampleRate(newRate);
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         _tracker.setCookiePath(newCookiePath);
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         _tracker.setAllowHash(enable);
      }
      
      public function addIgnoredOrganic(param1:String) : void
      {
         _tracker.addIgnoredOrganic(param1);
      }
      
      public function setLocalRemoteServerMode() : void
      {
         _tracker.setLocalRemoteServerMode();
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         _tracker.cookiePathCopy(newPath);
      }
      
      private function _factory() : void
      {
         var activeTracker:GoogleAnalyticsAPI = null;
         _jsproxy = new JavascriptProxy(debug);
         if(visualDebug)
         {
            debug.layout = new Layout(debug,_display);
            debug.active = visualDebug;
         }
         var cache:TrackerCache = _tracker as TrackerCache;
         switch(mode)
         {
            case TrackerMode.BRIDGE:
               activeTracker = _bridgeFactory();
               break;
            case TrackerMode.AS3:
            default:
               activeTracker = _trackerFactory();
         }
         if(!cache.isEmpty())
         {
            cache.tracker = activeTracker;
            cache.flush();
         }
         _tracker = activeTracker;
         _ready = true;
         dispatchEvent(new AnalyticsEvent(AnalyticsEvent.READY,this));
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         _tracker.setCampTermKey(newCampTermKey);
      }
      
      private function _trackerFactory() : GoogleAnalyticsAPI
      {
         debug.info("GATracker (AS3) v" + version + "\naccount: " + account);
         _adSense = new AdSenseGlobals(debug);
         _dom = new HTMLDOM(debug);
         _dom.cacheProperties();
         _env = new Environment("","","",debug,_dom);
         _buffer = new Buffer(config,debug,false);
         _gifRequest = new GIFRequest(config,debug,_buffer,_env);
         _idleTimer = new IdleTimer(config,debug,_display,_buffer);
         _env.url = _display.stage.loaderInfo.url;
         return new Tracker(account,config,debug,_env,_buffer,_gifRequest,_adSense);
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         _tracker.setCampNOKey(newCampNOKey);
      }
      
      public function setDetectTitle(param1:Boolean) : void
      {
         _tracker.setDetectTitle(param1);
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         return _tracker.getServiceMode();
      }
      
      public function clearOrganic() : void
      {
         _tracker.clearOrganic();
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         _tracker.setCampaignTrack(enable);
      }
      
      public function addIgnoredRef(param1:String) : void
      {
         _tracker.addIgnoredRef(param1);
      }
      
      public function set visualDebug(value:Boolean) : void
      {
         _visualDebug = value;
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         _tracker.setCampMediumKey(newCampMedKey);
      }
      
      public function getDetectFlash() : Boolean
      {
         return _tracker.getDetectFlash();
      }
      
      public function get visualDebug() : Boolean
      {
         return _visualDebug;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return _eventDispatcher.hasEventListener(type);
      }
      
      public function getAccount() : String
      {
         return _tracker.getAccount();
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         _tracker.setSessionTimeout(newTimeout);
      }
      
      public function setRemoteServerMode() : void
      {
         _tracker.setRemoteServerMode();
      }
   }
}
