package com.google.analytics.v4
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.core.EventTracker;
   import com.google.analytics.external.JavascriptProxy;
   import com.google.analytics.core.Utils;
   import com.google.analytics.core.ServerOperationMode;
   import com.google.analytics.debug.VisualDebugMode;
   
   public class Bridge implements GoogleAnalyticsAPI
   {
      
      private static var _linkTrackingObject_js:XML = <script>
            <![CDATA[
                function( container , target )
                {
                    var targets ;
                    var name ;
                    if( target.indexOf(".") > 0 )
                    {
                        targets = target.split(".");
                        name    = targets.pop();
                    }
                    else
                    {
                        targets = [];
                        name    = target;
                    }
                    var ref   = window;
                    var depth = targets.length;
                    for( var j = 0 ; j < depth ; j++ )
                    {
                        ref = ref[ targets[j] ] ;
                    }
                    window[container][target] = ref[name] ;
                }
            ]]>
        </script>;
      
      private static var _createTrackingObject_js:XML = <script>
            <![CDATA[
                function( acct )
                {
                    _GATracker[acct] = _gat._getTracker(acct);
                }
            ]]>
        </script>;
      
      private static var _injectTrackingObject_js:XML = <script>
            <![CDATA[
                function()
                {
                    try 
                    {
                        _GATracker
                    }
                    catch(e) 
                    {
                        _GATracker = {};
                    }
                }
            ]]>
        </script>;
      
      private static var _checkGAJS_js:XML = <script>
            <![CDATA[
                function()
                {
                    if( _gat && _gat._getTracker )
                    {
                        return true;
                    }
                    return false;
                }
            ]]>
        </script>;
      
      private static var _checkValidTrackingObject_js:XML = <script>
            <![CDATA[
                function(acct)
                {
                    if( _GATracker[acct] && (_GATracker[acct]._getAccount) )
                    {
                        return true ;
                    }
                    else
                    {
                        return false;
                    }
                }
            ]]>
        </script>;
       
      
      private var _debug:DebugConfiguration;
      
      private var _proxy:JavascriptProxy;
      
      private var _jsContainer:String = "_GATracker";
      
      private var _hasGATracker:Boolean = false;
      
      private var _account:String;
      
      public function Bridge(account:String, debug:DebugConfiguration, jsproxy:JavascriptProxy)
      {
         var msg0:* = null;
         var msg1:* = null;
         var msg2:* = null;
         super();
         _account = account;
         _debug = debug;
         _proxy = jsproxy;
         if(!_checkGAJS())
         {
            msg0 = "";
            msg0 = msg0 + "ga.js not found, be sure to check if\n";
            msg0 = msg0 + "<script src=\"http://www.google-analytics.com/ga.js\"></script>\n";
            msg0 = msg0 + "is included in the HTML.";
            _debug.warning(msg0);
            throw new Error(msg0);
         }
         if(!_hasGATracker)
         {
            if(_debug.javascript && _debug.verbose)
            {
               msg1 = "";
               msg1 = msg1 + "The Google Analytics tracking code was not found on the container page\n";
               msg1 = msg1 + "we create it";
               _debug.info(msg1,VisualDebugMode.advanced);
            }
            _injectTrackingObject();
         }
         if(Utils.validateAccount(account))
         {
            _createTrackingObject(account);
         }
         else if(_checkTrackingObject(account))
         {
            _linkTrackingObject(account);
         }
         else
         {
            msg2 = "";
            msg2 = msg2 + ("JS Object \"" + account + "\" doesn\'t exist in DOM\n");
            msg2 = msg2 + "Bridge object not created.";
            _debug.warning(msg2);
            throw new Error(msg2);
         }
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         _debug.info("link( " + targetUrl + ", " + useHash + " )");
         _call("_link",targetUrl,useHash);
      }
      
      public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
      {
         _debug.info("addOrganic( " + [newOrganicEngine,newOrganicKeyword].join(", ") + " )");
         _call("_addOrganic",newOrganicEngine);
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         _debug.info("setAllowLinker( " + enable + " )");
         _call("_setAllowLinker",enable);
      }
      
      private function _linkTrackingObject(path:String) : void
      {
         _proxy.call(_linkTrackingObject_js,_jsContainer,path);
      }
      
      public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
      {
         var param:int = 2;
         if(label && label != "")
         {
            param = 3;
         }
         if(param == 3 && !isNaN(value))
         {
            param = 4;
         }
         switch(param)
         {
            case 4:
               _debug.info("trackEvent( " + [category,action,label,value].join(", ") + " )");
               return _call("_trackEvent",category,action,label,value);
            case 3:
               _debug.info("trackEvent( " + [category,action,label].join(", ") + " )");
               return _call("_trackEvent",category,action,label);
            case 2:
            default:
               _debug.info("trackEvent( " + [category,action].join(", ") + " )");
               return _call("_trackEvent",category,action);
         }
      }
      
      public function setClientInfo(enable:Boolean) : void
      {
         _debug.info("setClientInfo( " + enable + " )");
         _call("_setClientInfo",enable);
      }
      
      public function trackTrans() : void
      {
         _debug.info("trackTrans()");
         _call("_trackTrans");
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         _debug.info("setCookieTimeout( " + newDefaultTimeout + " )");
         _call("_setCookieTimeout",newDefaultTimeout);
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         _debug.info("trackPageview( " + pageURL + " )");
         _call("_trackPageview",pageURL);
      }
      
      public function getClientInfo() : Boolean
      {
         _debug.info("getClientInfo()");
         return _call("_getClientInfo");
      }
      
      private function _checkValidTrackingObject(account:String) : Boolean
      {
         return _proxy.call(_checkValidTrackingObject_js,account);
      }
      
      private function _checkGAJS() : Boolean
      {
         return _proxy.call(_checkGAJS_js);
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         _debug.warning("linkByPost( " + formObject + ", " + useHash + " ) not implemented");
      }
      
      private function _call(functionName:String, ... args) : *
      {
         args.unshift("window." + _jsContainer + "[\"" + _account + "\"]." + functionName);
         return _proxy.call.apply(_proxy,args);
      }
      
      public function hasGAJS() : Boolean
      {
         return _checkGAJS();
      }
      
      private function _checkTrackingObject(account:String) : Boolean
      {
         var hasObj:Boolean = _proxy.hasProperty(account);
         var isTracker:Boolean = _proxy.hasProperty(account + "._getAccount");
         return hasObj && isTracker;
      }
      
      public function resetSession() : void
      {
         _debug.warning("resetSession() not implemented");
      }
      
      public function getDetectTitle() : Boolean
      {
         _debug.info("getDetectTitle()");
         return _call("_getDetectTitle");
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         _debug.info("setCampNameKey( " + newCampNameKey + " )");
         _call("_setCampNameKey",newCampNameKey);
      }
      
      public function setDetectFlash(enable:Boolean) : void
      {
         _debug.info("setDetectFlash( " + enable + " )");
         _call("_setDetectFlash",enable);
      }
      
      public function createEventTracker(objName:String) : EventTracker
      {
         _debug.info("createEventTracker( " + objName + " )");
         return new EventTracker(objName,this);
      }
      
      public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         _debug.info("addItem( " + [item,sku,name,category,price,quantity].join(", ") + " )");
         _call("_addItem",item,sku,name,category,price,quantity);
      }
      
      public function clearIgnoredOrganic() : void
      {
         _debug.info("clearIgnoredOrganic()");
         _call("_clearIgnoreOrganic");
      }
      
      public function setVar(newVal:String) : void
      {
         _debug.info("setVar( " + newVal + " )");
         _call("_setVar",newVal);
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         _debug.info("setDomainName( " + newDomainName + " )");
         _call("_setDomainName",newDomainName);
      }
      
      public function hasTrackingAccount(account:String) : Boolean
      {
         if(Utils.validateAccount(account))
         {
            return _checkValidTrackingObject(account);
         }
         return _checkTrackingObject(account);
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         _debug.info("setCampSourceKey( " + newCampSrcKey + " )");
         _call("_setCampSourceKey",newCampSrcKey);
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object
      {
         _debug.info("addTrans( " + [orderId,affiliation,total,tax,shipping,city,state,country].join(", ") + " )");
         _call("_addTrans",orderId,affiliation,total,tax,shipping,city,state,country);
         return null;
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         _debug.info("setCampContentKey( " + newCampContentKey + " )");
         _call("_setCampContentKey",newCampContentKey);
      }
      
      public function setLocalServerMode() : void
      {
         _debug.info("setLocalServerMode()");
         _call("_setLocalServerMode");
      }
      
      public function getLocalGifPath() : String
      {
         _debug.info("getLocalGifPath()");
         return _call("_getLocalGifPath");
      }
      
      public function clearIgnoredRef() : void
      {
         _debug.info("clearIgnoredRef()");
         _call("_clearIgnoreRef");
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         _debug.info("setAllowAnchor( " + enable + " )");
         _call("_setAllowAnchor",enable);
      }
      
      public function setLocalGifPath(newLocalGifPath:String) : void
      {
         _debug.info("setLocalGifPath( " + newLocalGifPath + " )");
         _call("_setLocalGifPath",newLocalGifPath);
      }
      
      public function getVersion() : String
      {
         _debug.info("getVersion()");
         return _call("_getVersion");
      }
      
      private function _injectTrackingObject() : void
      {
         _proxy.executeBlock(_injectTrackingObject_js);
         _hasGATracker = true;
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         _debug.info("setCookiePath( " + newCookiePath + " )");
         _call("_setCookiePath",newCookiePath);
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         _debug.info("setSampleRate( " + newRate + " )");
         _call("_setSampleRate",newRate);
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         _debug.info("setAllowHash( " + enable + " )");
         _call("_setAllowHash",enable);
      }
      
      public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
      {
         _debug.info("addIgnoredOrganic( " + newIgnoredOrganicKeyword + " )");
         _call("_addIgnoredOrganic",newIgnoredOrganicKeyword);
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         _debug.info("setCampNOKey( " + newCampNOKey + " )");
         _call("_setCampNOKey",newCampNOKey);
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         _debug.info("cookiePathCopy( " + newPath + " )");
         _call("_cookiePathCopy",newPath);
      }
      
      public function setLocalRemoteServerMode() : void
      {
         _debug.info("setLocalRemoteServerMode()");
         _call("_setLocalRemoteServerMode");
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         _debug.info("getServiceMode()");
         return _call("_getServiceMode");
      }
      
      public function setDetectTitle(enable:Boolean) : void
      {
         _debug.info("setDetectTitle( " + enable + " )");
         _call("_setDetectTitle",enable);
      }
      
      private function _createTrackingObject(account:String) : void
      {
         _proxy.call(_createTrackingObject_js,account);
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         _debug.info("setCampaignTrack( " + enable + " )");
         _call("_setCampaignTrack",enable);
      }
      
      public function clearOrganic() : void
      {
         _debug.info("clearOrganic()");
         _call("_clearOrganic");
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         _debug.info("setCampTermKey( " + newCampTermKey + " )");
         _call("_setCampTermKey",newCampTermKey);
      }
      
      public function getDetectFlash() : Boolean
      {
         _debug.info("getDetectFlash()");
         return _call("_getDetectFlash");
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         _debug.info("setCampMediumKey( " + newCampMedKey + " )");
         _call("_setCampMediumKey",newCampMedKey);
      }
      
      public function addIgnoredRef(newIgnoredReferrer:String) : void
      {
         _debug.info("addIgnoredRef( " + newIgnoredReferrer + " )");
         _call("_addIgnoredRef",newIgnoredReferrer);
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         _debug.info("setSessionTimeout( " + newTimeout + " )");
         _call("_setSessionTimeout",newTimeout);
      }
      
      public function setRemoteServerMode() : void
      {
         _debug.info("setRemoteServerMode()");
         _call("_setRemoteServerMode");
      }
      
      public function getAccount() : String
      {
         _debug.info("getAccount()");
         return _call("_getAccount");
      }
   }
}
