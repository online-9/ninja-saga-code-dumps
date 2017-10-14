package com.google.analytics.core
{
   import com.google.analytics.utils.Variables;
   import com.google.analytics.v4.Configuration;
   import com.google.analytics.external.AdSenseGlobals;
   import com.google.analytics.utils.Environment;
   
   public class DocumentInfo
   {
       
      
      private var _pageURL:String;
      
      private var _utmr:String;
      
      private var _config:Configuration;
      
      private var _adSense:AdSenseGlobals;
      
      private var _info:Environment;
      
      public function DocumentInfo(config:Configuration, info:Environment, formatedReferrer:String, pageURL:String = null, adSense:AdSenseGlobals = null)
      {
         super();
         _config = config;
         _info = info;
         _utmr = formatedReferrer;
         _pageURL = pageURL;
         _adSense = adSense;
      }
      
      public function get utmr() : String
      {
         if(!_utmr)
         {
            return "-";
         }
         return _utmr;
      }
      
      public function toURLString() : String
      {
         var v:Variables = toVariables();
         return v.toString();
      }
      
      private function _renderPageURL(pageURL:String = "") : String
      {
         var pathname:String = _info.locationPath;
         var search:String = _info.locationSearch;
         if(!pageURL || pageURL == "")
         {
            pageURL = pathname + unescape(search);
         }
         return pageURL;
      }
      
      public function get utmp() : String
      {
         return _renderPageURL(_pageURL);
      }
      
      public function get utmhid() : String
      {
         return String(_generateHitId());
      }
      
      private function _generateHitId() : Number
      {
         var hid:Number = NaN;
         if(_adSense.hid && _adSense.hid != "")
         {
            hid = Number(_adSense.hid);
         }
         else
         {
            hid = Math.round(Math.random() * 2147483647);
            _adSense.hid = String(hid);
         }
         return hid;
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         if(_config.detectTitle && utmdt != "")
         {
            variables.utmdt = utmdt;
         }
         variables.utmhid = utmhid;
         variables.utmr = utmr;
         variables.utmp = utmp;
         return variables;
      }
      
      public function get utmdt() : String
      {
         return _info.documentTitle;
      }
   }
}
