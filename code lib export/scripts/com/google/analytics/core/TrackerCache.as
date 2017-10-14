package com.google.analytics.core
{
   import com.google.analytics.v4.GoogleAnalyticsAPI;
   import flash.errors.IllegalOperationError;
   
   public class TrackerCache implements GoogleAnalyticsAPI
   {
      
      public static var CACHE_THROW_ERROR:Boolean;
       
      
      public var tracker:GoogleAnalyticsAPI;
      
      private var _ar:Array;
      
      public function TrackerCache(tracker:GoogleAnalyticsAPI = null)
      {
         super();
         this.tracker = tracker;
         _ar = [];
      }
      
      public function size() : uint
      {
         return _ar.length;
      }
      
      public function flush() : void
      {
         var o:Object = null;
         var name:String = null;
         var args:Array = null;
         var l:int = 0;
         var i:int = 0;
         if(tracker == null)
         {
            return;
         }
         if(size() > 0)
         {
            for(l = _ar.length; i < l; )
            {
               o = _ar.shift();
               name = o.name as String;
               args = o.args as Array;
               if(name != null && name in tracker)
               {
                  (tracker[name] as Function).apply(tracker,args);
               }
               i++;
            }
         }
      }
      
      public function enqueue(name:String, ... args) : Boolean
      {
         if(name == null)
         {
            return false;
         }
         _ar.push({
            "name":name,
            "args":args
         });
         return true;
      }
      
      public function link(targetUrl:String, useHash:Boolean = false) : void
      {
         enqueue("link",targetUrl,useHash);
      }
      
      public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String) : void
      {
         enqueue("addOrganic",newOrganicEngine,newOrganicKeyword);
      }
      
      public function setAllowLinker(enable:Boolean) : void
      {
         enqueue("setAllowLinker",enable);
      }
      
      public function trackEvent(category:String, action:String, label:String = null, value:Number = NaN) : Boolean
      {
         enqueue("trackEvent",category,action,label,value);
         return true;
      }
      
      public function getClientInfo() : Boolean
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getClientInfo\' method for the moment.");
         }
         return false;
      }
      
      public function trackTrans() : void
      {
         enqueue("trackTrans");
      }
      
      public function trackPageview(pageURL:String = "") : void
      {
         enqueue("trackPageview",pageURL);
      }
      
      public function setClientInfo(enable:Boolean) : void
      {
         enqueue("setClientInfo",enable);
      }
      
      public function linkByPost(formObject:Object, useHash:Boolean = false) : void
      {
         enqueue("linkByPost",formObject,useHash);
      }
      
      public function setCookieTimeout(newDefaultTimeout:int) : void
      {
         enqueue("setCookieTimeout",newDefaultTimeout);
      }
      
      public function isEmpty() : Boolean
      {
         return _ar.length == 0;
      }
      
      public function getDetectTitle() : Boolean
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getDetectTitle\' method for the moment.");
         }
         return false;
      }
      
      public function resetSession() : void
      {
         enqueue("resetSession");
      }
      
      public function setDetectFlash(enable:Boolean) : void
      {
         enqueue("setDetectFlash",enable);
      }
      
      public function clear() : void
      {
         _ar = [];
      }
      
      public function setCampNameKey(newCampNameKey:String) : void
      {
         enqueue("setCampNameKey",newCampNameKey);
      }
      
      public function addItem(item:String, sku:String, name:String, category:String, price:Number, quantity:int) : void
      {
         enqueue("addItem",item,sku,name,category,price,quantity);
      }
      
      public function createEventTracker(objName:String) : EventTracker
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'createEventTracker\' method for the moment.");
         }
         return null;
      }
      
      public function setVar(newVal:String) : void
      {
         enqueue("setVar",newVal);
      }
      
      public function clearIgnoredOrganic() : void
      {
         enqueue("clearIgnoredOrganic");
      }
      
      public function setDomainName(newDomainName:String) : void
      {
         enqueue("setDomainName",newDomainName);
      }
      
      public function setCampSourceKey(newCampSrcKey:String) : void
      {
         enqueue("setCampSourceKey",newCampSrcKey);
      }
      
      public function addTrans(orderId:String, affiliation:String, total:Number, tax:Number, shipping:Number, city:String, state:String, country:String) : Object
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'addTrans\' method for the moment.");
         }
         return null;
      }
      
      public function setCampContentKey(newCampContentKey:String) : void
      {
         enqueue("setCampContentKey",newCampContentKey);
      }
      
      public function setLocalServerMode() : void
      {
         enqueue("setLocalServerMode");
      }
      
      public function getLocalGifPath() : String
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getLocalGifPath\' method for the moment.");
         }
         return "";
      }
      
      public function setAllowAnchor(enable:Boolean) : void
      {
         enqueue("setAllowAnchor",enable);
      }
      
      public function clearIgnoredRef() : void
      {
         enqueue("clearIgnoredRef");
      }
      
      public function setLocalGifPath(newLocalGifPath:String) : void
      {
         enqueue("setLocalGifPath",newLocalGifPath);
      }
      
      public function getVersion() : String
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getVersion\' method for the moment.");
         }
         return "";
      }
      
      public function setCookiePath(newCookiePath:String) : void
      {
         enqueue("setCookiePath",newCookiePath);
      }
      
      public function setSampleRate(newRate:Number) : void
      {
         enqueue("setSampleRate",newRate);
      }
      
      public function setDetectTitle(enable:Boolean) : void
      {
         enqueue("setDetectTitle",enable);
      }
      
      public function setAllowHash(enable:Boolean) : void
      {
         enqueue("setAllowHash",enable);
      }
      
      public function addIgnoredOrganic(newIgnoredOrganicKeyword:String) : void
      {
         enqueue("addIgnoredOrganic",newIgnoredOrganicKeyword);
      }
      
      public function setCampNOKey(newCampNOKey:String) : void
      {
         enqueue("setCampNOKey",newCampNOKey);
      }
      
      public function getServiceMode() : ServerOperationMode
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getServiceMode\' method for the moment.");
         }
         return null;
      }
      
      public function setLocalRemoteServerMode() : void
      {
         enqueue("setLocalRemoteServerMode");
      }
      
      public function cookiePathCopy(newPath:String) : void
      {
         enqueue("cookiePathCopy",newPath);
      }
      
      public function getDetectFlash() : Boolean
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getDetectFlash\' method for the moment.");
         }
         return false;
      }
      
      public function setCampaignTrack(enable:Boolean) : void
      {
         enqueue("setCampaignTrack",enable);
      }
      
      public function clearOrganic() : void
      {
         enqueue("clearOrganic");
      }
      
      public function setCampTermKey(newCampTermKey:String) : void
      {
         enqueue("setCampTermKey",newCampTermKey);
      }
      
      public function addIgnoredRef(newIgnoredReferrer:String) : void
      {
         enqueue("addIgnoredRef",newIgnoredReferrer);
      }
      
      public function setCampMediumKey(newCampMedKey:String) : void
      {
         enqueue("setCampMediumKey",newCampMedKey);
      }
      
      public function setSessionTimeout(newTimeout:int) : void
      {
         enqueue("setSessionTimeout",newTimeout);
      }
      
      public function setRemoteServerMode() : void
      {
         enqueue("setRemoteServerMode");
      }
      
      public function element() : *
      {
         return _ar[0];
      }
      
      public function getAccount() : String
      {
         if(CACHE_THROW_ERROR)
         {
            throw new IllegalOperationError("The tracker is not ready and you can use the \'getAccount\' method for the moment.");
         }
         return "";
      }
   }
}
