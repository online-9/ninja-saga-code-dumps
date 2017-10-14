package com.google.analytics.v4
{
   import com.google.analytics.utils.Protocols;
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.data.X10;
   import com.google.analytics.core.BrowserInfo;
   import com.google.analytics.campaign.CampaignManager;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.core.EventInfo;
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.utils.URL;
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.core.Buffer;
   import com.google.analytics.core.DomainNameMode;
   import com.google.analytics.core.DocumentInfo;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.core.ServerOperationMode;
   import com.google.analytics.core.Utils;
   import com.google.analytics.campaign.CampaignInfo;
   import com.google.analytics.core.GIFRequest;
   
   public class Tracker implements GoogleAnalyticsAPI
   {
       
      
      private var _adSense:AdSenseGlobals;
      
      private const EVENT_TRACKER_LABEL_KEY_NUM:int = 3;
      
      private var _eventTracker:X10;
      
      private const EVENT_TRACKER_VALUE_VALUE_NUM:int = 1;
      
      private var _noSessionInformation:Boolean = false;
      
      private var _browserInfo:BrowserInfo;
      
      private var _debug:DebugConfiguration;
      
      private var _isNewVisitor:Boolean = false;
      
      private var _buffer:Buffer;
      
      private var _config:com.google.analytics.v4.Configuration;
      
      private var _x10Module:X10;
      
      private var _campaign:CampaignManager;
      
      private var _formatedReferrer:String;
      
      private var _timeStamp:Number;
      
      private var _info:Environment;
      
      private var _domainHash:Number;
      
      private const EVENT_TRACKER_PROJECT_ID:int = 5;
      
      private var _campaignInfo:CampaignInfo;
      
      private const EVENT_TRACKER_OBJECT_NAME_KEY_NUM:int = 1;
      
      private var _gifRequest:GIFRequest;
      
      private const EVENT_TRACKER_TYPE_KEY_NUM:int = 2;
      
      private var _hasInitData:Boolean = false;
      
      private var _account:String;
      
      public function Tracker(account:String, config:com.google.analytics.v4.Configuration, debug:DebugConfiguration, info:Environment, buffer:Buffer, gifRequest:GIFRequest, adSense:AdSenseGlobals)
      {
         var msg:* = null;
         super();
         _account = account;
         _config = config;
         _debug = debug;
         _info = info;
         _buffer = buffer;
         _gifRequest = gifRequest;
         _adSense = adSense;
         if(!Utils.validateAccount(account))
         {
            msg = "Account \"" + account + "\" is not valid.";
            _debug.warning(msg);
            throw new Error(msg);
         }
         _initData();
      }
      
      private function _doTracking() : Boolean
      {
         if(_info.protocol != Protocols.file && _info.protocol != Protocols.none && _isNotGoogleSearch())
         {
            return true;
         }
         if(_config.allowLocalTracking)
         {
            return true;
         }
         return false;
      }
      
      public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
      {
         _debug.info("addOrganic( " + [newOrganicEngine,newOrganicKeyword].join(", ") + " )");
         _config.organic.addSource(newOrganicEngine,newOrganicKeyword);
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         _config.allowLinker = enable;
         _debug.info("setAllowLinker( " + _config.allowLinker + " )");
      }
      
      public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
      {
         var success:Boolean = true;
         var params:int = 2;
         if(category != "" && action != "")
         {
            _eventTracker.clearKey(EVENT_TRACKER_PROJECT_ID);
            _eventTracker.clearValue(EVENT_TRACKER_PROJECT_ID);
            success = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID,EVENT_TRACKER_OBJECT_NAME_KEY_NUM,category);
            success = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID,EVENT_TRACKER_TYPE_KEY_NUM,action);
            if(label && label != "")
            {
               success = _eventTracker.setKey(EVENT_TRACKER_PROJECT_ID,EVENT_TRACKER_LABEL_KEY_NUM,label);
               params = 3;
               if(!isNaN(value))
               {
                  success = _eventTracker.setValue(EVENT_TRACKER_PROJECT_ID,EVENT_TRACKER_VALUE_VALUE_NUM,value);
                  params = 4;
               }
            }
            if(success)
            {
               _debug.info("valid event tracking call\ncategory: " + category + "\naction: " + action,VisualDebugMode.geek);
               _sendXEvent(_eventTracker);
            }
         }
         else
         {
            _debug.warning("event tracking call is not valid, failed!\ncategory: " + category + "\naction: " + action,VisualDebugMode.geek);
            success = false;
         }
         switch(params)
         {
            case 4:
               _debug.info("trackEvent( " + [category,action,label,value].join(", ") + " )");
               break;
            case 3:
               _debug.info("trackEvent( " + [category,action,label].join(", ") + " )");
               break;
            case 2:
            default:
               _debug.info("trackEvent( " + [category,action].join(", ") + " )");
         }
         return success;
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         _debug.info("trackPageview( " + pageURL + " )");
         if(_doTracking())
         {
            _initData();
            _trackMetrics(pageURL);
            _noSessionInformation = false;
         }
         else
         {
            _debug.warning("trackPageview( " + pageURL + " ) failed");
         }
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         _config.conversionTimeout = newDefaultTimeout;
         _debug.info("setCookieTimeout( " + _config.conversionTimeout + " )");
      }
      
      public function trackTrans() : void
      {
         _debug.warning("trackTrans() not implemented");
      }
      
      public function setClientInfo(enable:Boolean) : void
      {
         _config.detectClientInfo = enable;
         _debug.info("setClientInfo( " + _config.detectClientInfo + " )");
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         _debug.warning("linkByPost( " + [formObject,useHash].join(", ") + " ) not implemented");
      }
      
      private function _initData() : void
      {
         var data0:* = null;
         var data:* = null;
         if(!_hasInitData)
         {
            _updateDomainName();
            _domainHash = _getDomainHash();
            _timeStamp = Math.round(new Date().getTime() / 1000);
            if(_debug.verbose)
            {
               data0 = "";
               data0 = data0 + "_initData 0";
               data0 = data0 + ("\ndomain name: " + _config.domainName);
               data0 = data0 + ("\ndomain hash: " + _domainHash);
               data0 = data0 + ("\ntimestamp:   " + _timeStamp + " (" + new Date(_timeStamp * 1000) + ")");
               _debug.info(data0,VisualDebugMode.geek);
            }
         }
         if(_doTracking())
         {
            _handleCookie();
         }
         if(!_hasInitData)
         {
            if(_doTracking())
            {
               _formatedReferrer = _formatReferrer();
               _browserInfo = new BrowserInfo(_config,_info);
               _debug.info("browserInfo: " + _browserInfo.toURLString(),VisualDebugMode.advanced);
               if(_config.campaignTracking)
               {
                  _campaign = new CampaignManager(_config,_debug,_buffer,_domainHash,_formatedReferrer,_timeStamp);
                  _campaignInfo = _campaign.getCampaignInformation(_info.locationSearch,_noSessionInformation);
                  _debug.info("campaignInfo: " + _campaignInfo.toURLString(),VisualDebugMode.advanced);
               }
            }
            _x10Module = new X10();
            _eventTracker = new X10();
            _hasInitData = true;
         }
         if(_config.hasSiteOverlay)
         {
            _debug.warning("Site Overlay is not supported");
         }
         if(_debug.verbose)
         {
            data = "";
            data = data + "_initData (misc)";
            data = data + ("\nflash version: " + _info.flashVersion.toString(4));
            data = data + ("\nprotocol: " + _info.protocol);
            data = data + ("\ndefault domain name (auto): \"" + _info.domainName + "\"");
            data = data + ("\nlanguage: " + _info.language);
            data = data + ("\ndomain hash: " + _getDomainHash());
            data = data + ("\nuser-agent: " + _info.userAgent);
            _debug.info(data,VisualDebugMode.geek);
         }
      }
      
      public function getDetectTitle() : Boolean
      {
         _debug.info("getDetectTitle()");
         return _config.detectTitle;
      }
      
      public function resetSession() : void
      {
         _debug.info("resetSession()");
         _buffer.resetCurrentSession();
      }
      
      public function getClientInfo() : Boolean
      {
         _debug.info("getClientInfo()");
         return _config.detectClientInfo;
      }
      
      private function _sendXEvent(opt_xObj:X10 = null) : void
      {
         var searchVariables:Variables = null;
         var eventInfo:EventInfo = null;
         var eventvars:Variables = null;
         var generalvars:Variables = null;
         _initData();
         if(_takeSample())
         {
            searchVariables = new Variables();
            searchVariables.URIencode = true;
            eventInfo = new EventInfo(true,_x10Module,opt_xObj);
            eventvars = eventInfo.toVariables();
            generalvars = _renderMetricsSearchVariables();
            searchVariables.join(eventvars,generalvars);
            _gifRequest.send(_account,searchVariables,false,true);
         }
      }
      
      public function setDetectFlash(enable:Boolean) : void
      {
         _config.detectFlash = enable;
         _debug.info("setDetectFlash( " + _config.detectFlash + " )");
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         _config.campaignKey.UCCN = newCampNameKey;
         var msg:* = "setCampNameKey( " + _config.campaignKey.UCCN + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCCN]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      private function _formatReferrer() : String
      {
         var domainName:String = null;
         var ref:URL = null;
         var dom:URL = null;
         var referrer:String = _info.referrer;
         if(referrer == "" || referrer == "localhost")
         {
            referrer = "-";
         }
         else
         {
            domainName = _info.domainName;
            ref = new URL(referrer);
            dom = new URL("http://" + domainName);
            if(ref.hostName == domainName)
            {
               return "-";
            }
            if(dom.domain == ref.domain)
            {
               if(dom.subDomain != ref.subDomain)
               {
                  referrer = "0";
               }
            }
            if(referrer.charAt(0) == "[" && referrer.charAt(referrer.length - 1))
            {
               referrer = "-";
            }
         }
         _debug.info("formated referrer: " + referrer,VisualDebugMode.advanced);
         return referrer;
      }
      
      private function _visitCode() : Number
      {
         if(_debug.verbose)
         {
            _debug.info("visitCode: " + _buffer.utma.sessionId,VisualDebugMode.geek);
         }
         return _buffer.utma.sessionId;
      }
      
      public function createEventTracker(objName:String) : EventTracker
      {
         _debug.info("createEventTracker( " + objName + " )");
         return new EventTracker(objName,this);
      }
      
      public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         _debug.warning("addItem( " + [item,sku,name,category,price,quantity].join(", ") + " ) not implemented");
      }
      
      public function clearIgnoredOrganic() : void
      {
         _debug.info("clearIgnoredOrganic()");
         _config.organic.clearIgnoredKeywords();
      }
      
      public function setVar(newVal:String) : void
      {
         var variables:Variables = null;
         if(newVal != "" && _isNotGoogleSearch())
         {
            _initData();
            _buffer.utmv.domainHash = _domainHash;
            _buffer.utmv.value = newVal;
            if(_debug.verbose)
            {
               _debug.info(_buffer.utmv.toString(),VisualDebugMode.geek);
            }
            _debug.info("setVar( " + newVal + " )");
            if(_takeSample())
            {
               variables = new Variables();
               variables.utmt = "var";
               _gifRequest.send(_account,variables);
            }
         }
         else
         {
            _debug.warning("setVar \"" + newVal + "\" is ignored");
         }
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         if(newDomainName == "auto")
         {
            _config.domain.mode = DomainNameMode.auto;
         }
         else if(newDomainName == "none")
         {
            _config.domain.mode = DomainNameMode.none;
         }
         else
         {
            _config.domain.mode = DomainNameMode.custom;
            _config.domain.name = newDomainName;
         }
         _updateDomainName();
         _debug.info("setDomainName( " + _config.domainName + " )");
      }
      
      private function _updateDomainName() : void
      {
         var domainName:String = null;
         if(_config.domain.mode == DomainNameMode.auto)
         {
            domainName = _info.domainName;
            if(domainName.substring(0,4) == "www.")
            {
               domainName = domainName.substring(4);
            }
            _config.domain.name = domainName;
         }
         _config.domainName = _config.domain.name.toLowerCase();
         _debug.info("domain name: " + _config.domainName,VisualDebugMode.advanced);
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object
      {
         _debug.warning("addTrans( " + [orderId,affiliation,total,tax,shipping,city,state,country].join(", ") + " ) not implemented");
         return null;
      }
      
      private function _renderMetricsSearchVariables(pageURL:String = "") : Variables
      {
         var campvars:Variables = null;
         var variables:Variables = new Variables();
         variables.URIencode = true;
         var docInfo:DocumentInfo = new DocumentInfo(_config,_info,_formatedReferrer,pageURL,_adSense);
         _debug.info("docInfo: " + docInfo.toURLString(),VisualDebugMode.geek);
         if(_config.campaignTracking)
         {
            campvars = _campaignInfo.toVariables();
         }
         var browservars:Variables = _browserInfo.toVariables();
         variables.join(docInfo.toVariables(),browservars,campvars);
         return variables;
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         _config.campaignKey.UCCT = newCampContentKey;
         var msg:* = "setCampContentKey( " + _config.campaignKey.UCCT + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCCT]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      private function _handleCookie() : void
      {
         var data0:* = null;
         var data1:* = null;
         var vid:Array = null;
         var data2:* = null;
         if(!_config.allowLinker)
         {
         }
         if(_buffer.hasUTMA() && !_buffer.utma.isEmpty())
         {
            if(!_buffer.hasUTMB() || !_buffer.hasUTMC())
            {
               _buffer.updateUTMA(_timeStamp);
               _noSessionInformation = true;
            }
            if(_debug.verbose)
            {
               _debug.info("from cookie " + _buffer.utma.toString(),VisualDebugMode.geek);
            }
         }
         else
         {
            _debug.info("create a new utma",VisualDebugMode.advanced);
            _buffer.utma.domainHash = _domainHash;
            _buffer.utma.sessionId = _getUniqueSessionId();
            _buffer.utma.firstTime = _timeStamp;
            _buffer.utma.lastTime = _timeStamp;
            _buffer.utma.currentTime = _timeStamp;
            _buffer.utma.sessionCount = 1;
            if(_debug.verbose)
            {
               _debug.info(_buffer.utma.toString(),VisualDebugMode.geek);
            }
            _noSessionInformation = true;
            _isNewVisitor = true;
         }
         if(_adSense.gaGlobal && _adSense.dh == String(_domainHash))
         {
            if(_adSense.sid)
            {
               _buffer.utma.currentTime = Number(_adSense.sid);
               if(_debug.verbose)
               {
                  data0 = "";
                  data0 = data0 + "AdSense sid found\n";
                  data0 = data0 + ("Override currentTime(" + _buffer.utma.currentTime + ") from AdSense sid(" + Number(_adSense.sid) + ")");
                  _debug.info(data0,VisualDebugMode.geek);
               }
            }
            if(_isNewVisitor)
            {
               if(_adSense.sid)
               {
                  _buffer.utma.lastTime = Number(_adSense.sid);
                  if(_debug.verbose)
                  {
                     data1 = "";
                     data1 = data1 + "AdSense sid found (new visitor)\n";
                     data1 = data1 + ("Override lastTime(" + _buffer.utma.lastTime + ") from AdSense sid(" + Number(_adSense.sid) + ")");
                     _debug.info(data1,VisualDebugMode.geek);
                  }
               }
               if(_adSense.vid)
               {
                  vid = _adSense.vid.split(".");
                  _buffer.utma.sessionId = Number(vid[0]);
                  _buffer.utma.firstTime = Number(vid[1]);
                  if(_debug.verbose)
                  {
                     data2 = "";
                     data2 = data2 + "AdSense vid found (new visitor)\n";
                     data2 = data2 + ("Override sessionId(" + _buffer.utma.sessionId + ") from AdSense vid(" + Number(vid[0]) + ")\n");
                     data2 = data2 + ("Override firstTime(" + _buffer.utma.firstTime + ") from AdSense vid(" + Number(vid[1]) + ")");
                     _debug.info(data2,VisualDebugMode.geek);
                  }
               }
               if(_debug.verbose)
               {
                  _debug.info("AdSense modified : " + _buffer.utma.toString(),VisualDebugMode.geek);
               }
            }
         }
         _buffer.utmb.domainHash = _domainHash;
         if(isNaN(_buffer.utmb.trackCount))
         {
            _buffer.utmb.trackCount = 0;
         }
         if(isNaN(_buffer.utmb.token))
         {
            _buffer.utmb.token = _config.tokenCliff;
         }
         if(isNaN(_buffer.utmb.lastTime))
         {
            _buffer.utmb.lastTime = _buffer.utma.currentTime;
         }
         _buffer.utmc.domainHash = _domainHash;
         if(_debug.verbose)
         {
            _debug.info(_buffer.utmb.toString(),VisualDebugMode.advanced);
            _debug.info(_buffer.utmc.toString(),VisualDebugMode.advanced);
         }
      }
      
      public function setLocalServerMode() : void
      {
         _config.serverMode = ServerOperationMode.local;
         _debug.info("setLocalServerMode()");
      }
      
      public function clearIgnoredRef() : void
      {
         _debug.info("clearIgnoredRef()");
         _config.organic.clearIgnoredReferrals();
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         _config.campaignKey.UCSR = newCampSrcKey;
         var msg:* = "setCampSourceKey( " + _config.campaignKey.UCSR + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCSR]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      public function getLocalGifPath() : String
      {
         _debug.info("getLocalGifPath()");
         return _config.localGIFpath;
      }
      
      public function setLocalGifPath(newLocalGifPath:String) : void
      {
         _config.localGIFpath = newLocalGifPath;
         _debug.info("setLocalGifPath( " + _config.localGIFpath + " )");
      }
      
      public function getVersion() : String
      {
         _debug.info("getVersion()");
         return _config.version;
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         _config.allowAnchor = enable;
         _debug.info("setAllowAnchor( " + _config.allowAnchor + " )");
      }
      
      private function _isNotGoogleSearch() : Boolean
      {
         var domainName:String = _config.domainName;
         var g0:* = domainName.indexOf("www.google.") < 0;
         var g1:* = domainName.indexOf(".google.") < 0;
         var g2:* = domainName.indexOf("google.") < 0;
         var g4:* = domainName.indexOf("google.org") > -1;
         return g0 || g1 || g2 || _config.cookiePath != "/" || g4;
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         if(newRate < 0)
         {
            _debug.warning("sample rate can not be negative, ignoring value.");
         }
         else
         {
            _config.sampleRate = newRate;
         }
         _debug.info("setSampleRate( " + _config.sampleRate + " )");
      }
      
      private function _takeSample() : Boolean
      {
         if(_debug.verbose)
         {
            _debug.info("takeSample: (" + _visitCode() % 10000 + ") < (" + _config.sampleRate * 10000 + ")",VisualDebugMode.geek);
         }
         return _visitCode() % 10000 < _config.sampleRate * 10000;
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         _config.cookiePath = newCookiePath;
         _debug.info("setCookiePath( " + _config.cookiePath + " )");
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         _config.allowDomainHash = enable;
         _debug.info("setAllowHash( " + _config.allowDomainHash + " )");
      }
      
      private function _generateUserDataHash() : Number
      {
         var hash:String = "";
         hash = hash + _info.appName;
         hash = hash + _info.appVersion;
         hash = hash + _info.language;
         hash = hash + _info.platform;
         hash = hash + _info.userAgent.toString();
         hash = hash + (_info.screenWidth + "x" + _info.screenHeight + _info.screenColorDepth);
         hash = hash + _info.referrer;
         return Utils.generateHash(hash);
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         _config.campaignKey.UCNO = newCampNOKey;
         var msg:* = "setCampNOKey( " + _config.campaignKey.UCNO + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCNO]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
      {
         _debug.info("addIgnoredOrganic( " + newIgnoredOrganicKeyword + " )");
         _config.organic.addIgnoredKeyword(newIgnoredOrganicKeyword);
      }
      
      public function setLocalRemoteServerMode() : void
      {
         _config.serverMode = ServerOperationMode.both;
         _debug.info("setLocalRemoteServerMode()");
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         _debug.warning("cookiePathCopy( " + newPath + " ) not implemented");
      }
      
      public function setDetectTitle(enable:Boolean) : void
      {
         _config.detectTitle = enable;
         _debug.info("setDetectTitle( " + _config.detectTitle + " )");
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         _config.campaignKey.UCTR = newCampTermKey;
         var msg:* = "setCampTermKey( " + _config.campaignKey.UCTR + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCTR]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         _debug.info("getServiceMode()");
         return _config.serverMode;
      }
      
      private function _trackMetrics(pageURL:String = "") : void
      {
         var searchVariables:Variables = null;
         var x10vars:Variables = null;
         var generalvars:Variables = null;
         var eventInfo:EventInfo = null;
         if(_takeSample())
         {
            searchVariables = new Variables();
            searchVariables.URIencode = true;
            if(_x10Module && _x10Module.hasData())
            {
               eventInfo = new EventInfo(false,_x10Module);
               x10vars = eventInfo.toVariables();
            }
            generalvars = _renderMetricsSearchVariables(pageURL);
            searchVariables.join(x10vars,generalvars);
            _gifRequest.send(_account,searchVariables);
         }
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         _config.campaignTracking = enable;
         _debug.info("setCampaignTrack( " + _config.campaignTracking + " )");
      }
      
      public function addIgnoredRef(newIgnoredReferrer:String) : void
      {
         _debug.info("addIgnoredRef( " + newIgnoredReferrer + " )");
         _config.organic.addIgnoredReferral(newIgnoredReferrer);
      }
      
      public function clearOrganic() : void
      {
         _debug.info("clearOrganic()");
         _config.organic.clearEngines();
      }
      
      public function getDetectFlash() : Boolean
      {
         _debug.info("getDetectFlash()");
         return _config.detectFlash;
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         _config.campaignKey.UCMD = newCampMedKey;
         var msg:* = "setCampMediumKey( " + _config.campaignKey.UCMD + " )";
         if(_debug.mode == VisualDebugMode.geek)
         {
            _debug.info(msg + " [UCMD]");
         }
         else
         {
            _debug.info(msg);
         }
      }
      
      private function _getUniqueSessionId() : Number
      {
         var sessionID:Number = (Utils.generate32bitRandom() ^ _generateUserDataHash()) * 2147483647;
         _debug.info("Session ID: " + sessionID,VisualDebugMode.geek);
         return sessionID;
      }
      
      private function _getDomainHash() : Number
      {
         if(!_config.domainName || _config.domainName == "" || _config.domain.mode == DomainNameMode.none)
         {
            _config.domainName = "";
            return 1;
         }
         _updateDomainName();
         if(_config.allowDomainHash)
         {
            return Utils.generateHash(_config.domainName);
         }
         return 1;
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         _config.sessionTimeout = newTimeout;
         _debug.info("setSessionTimeout( " + _config.sessionTimeout + " )");
      }
      
      public function getAccount() : String
      {
         _debug.info("getAccount()");
         return _account;
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         _debug.warning("link( " + [targetUrl,useHash].join(", ") + " ) not implemented");
      }
      
      public function setRemoteServerMode() : void
      {
         _config.serverMode = ServerOperationMode.remote;
         _debug.info("setRemoteServerMode()");
      }
   }
}
