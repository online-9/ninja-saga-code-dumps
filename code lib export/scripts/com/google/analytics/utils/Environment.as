package com.google.analytics.utils
{
   import flash.system.Security;
   import flash.system.Capabilities;
   import com.google.analytics.external.HTMLDOM;
   import flash.system.System;
   import com.google.analytics.debug.DebugConfiguration;
   
   public class Environment
   {
       
      
      private var _dom:HTMLDOM;
      
      private var _appName:String;
      
      private var _debug:DebugConfiguration;
      
      private var _appVersion:com.google.analytics.utils.Version;
      
      private var _url:String;
      
      private var _protocol:com.google.analytics.utils.Protocols;
      
      private var _userAgent:com.google.analytics.utils.UserAgent;
      
      public function Environment(url:String = "", app:String = "", version:String = "", debug:DebugConfiguration = null, dom:HTMLDOM = null)
      {
         var v:com.google.analytics.utils.Version = null;
         super();
         if(app == "")
         {
            if(isAIR())
            {
               app = "AIR";
            }
            else
            {
               app = "Flash";
            }
         }
         if(version == "")
         {
            v = flashVersion;
         }
         else
         {
            v = com.google.analytics.utils.Version.fromString(version);
         }
         _url = url;
         _appName = app;
         _appVersion = v;
         _debug = debug;
         _dom = dom;
      }
      
      public function isAIR() : Boolean
      {
         return playerType == "Desktop" && Security.sandboxType.toString() == "application";
      }
      
      public function get screenWidth() : Number
      {
         return Capabilities.screenResolutionX;
      }
      
      public function get playerType() : String
      {
         return Capabilities.playerType;
      }
      
      public function get locationSearch() : String
      {
         var _search:String = _dom.search;
         if(_search)
         {
            return _search;
         }
         return "";
      }
      
      public function get protocol() : com.google.analytics.utils.Protocols
      {
         if(!_protocol)
         {
            _findProtocol();
         }
         return _protocol;
      }
      
      public function get flashVersion() : com.google.analytics.utils.Version
      {
         var v:com.google.analytics.utils.Version = com.google.analytics.utils.Version.fromString(Capabilities.version.split(" ")[1],",");
         return v;
      }
      
      public function get userAgent() : com.google.analytics.utils.UserAgent
      {
         if(!_userAgent)
         {
            _userAgent = new com.google.analytics.utils.UserAgent(this,appName,appVersion.toString(4));
         }
         return _userAgent;
      }
      
      public function get languageEncoding() : String
      {
         var _charset:String = null;
         if(System.useCodePage)
         {
            _charset = _dom.characterSet;
            if(_charset)
            {
               return _charset;
            }
            return "-";
         }
         return "UTF-8";
      }
      
      public function get appName() : String
      {
         return _appName;
      }
      
      public function get screenColorDepth() : String
      {
         var color:String = null;
         switch(Capabilities.screenColor)
         {
            case "bw":
               color = "1";
               break;
            case "gray":
               color = "2";
               break;
            case "color":
            default:
               color = "24";
         }
         var _colorDepth:String = _dom.colorDepth;
         if(_colorDepth)
         {
            color = _colorDepth;
         }
         return color;
      }
      
      private function _findProtocol() : void
      {
         var URL:String = null;
         var test:String = null;
         var p:com.google.analytics.utils.Protocols = com.google.analytics.utils.Protocols.none;
         if(_url != "")
         {
            URL = _url.toLowerCase();
            test = URL.substr(0,5);
            switch(test)
            {
               case "file:":
                  p = com.google.analytics.utils.Protocols.file;
                  break;
               case "http:":
                  p = com.google.analytics.utils.Protocols.HTTP;
                  break;
               case "https":
                  if(URL.charAt(5) == ":")
                  {
                     p = com.google.analytics.utils.Protocols.HTTPS;
                  }
                  break;
               default:
                  _protocol = com.google.analytics.utils.Protocols.none;
            }
         }
         var _proto:String = _dom.protocol;
         var proto:String = (p.toString() + ":").toLowerCase();
         if(_proto && _proto != proto && _debug)
         {
            _debug.warning("Protocol mismatch: SWF=" + proto + ", DOM=" + _proto);
         }
         _protocol = p;
      }
      
      public function get locationSWFPath() : String
      {
         return _url;
      }
      
      public function get platform() : String
      {
         var p:String = Capabilities.manufacturer;
         return p.split("Adobe ")[1];
      }
      
      public function get operatingSystem() : String
      {
         return Capabilities.os;
      }
      
      public function set appName(value:String) : void
      {
         _appName = value;
         userAgent.applicationProduct = value;
      }
      
      function set url(value:String) : void
      {
         _url = value;
      }
      
      public function get referrer() : String
      {
         var _referrer:String = _dom.referrer;
         if(_referrer)
         {
            return _referrer;
         }
         if(protocol == com.google.analytics.utils.Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function isInHTML() : Boolean
      {
         return Capabilities.playerType == "PlugIn";
      }
      
      public function get language() : String
      {
         var _lang:String = _dom.language;
         var lang:String = Capabilities.language;
         if(_lang)
         {
            if(_lang.length > lang.length && _lang.substr(0,lang.length) == lang)
            {
               lang = _lang;
            }
         }
         return lang;
      }
      
      public function get domainName() : String
      {
         var URL:String = null;
         var str:String = null;
         var end:int = 0;
         if(protocol == com.google.analytics.utils.Protocols.HTTP || protocol == com.google.analytics.utils.Protocols.HTTPS)
         {
            URL = _url.toLowerCase();
            if(protocol == com.google.analytics.utils.Protocols.HTTP)
            {
               str = URL.split("http://").join("");
            }
            else if(protocol == com.google.analytics.utils.Protocols.HTTPS)
            {
               str = URL.split("https://").join("");
            }
            end = str.indexOf("/");
            if(end > -1)
            {
               str = str.substring(0,end);
            }
            return str;
         }
         if(protocol == com.google.analytics.utils.Protocols.file)
         {
            return "localhost";
         }
         return "";
      }
      
      public function set userAgent(custom:com.google.analytics.utils.UserAgent) : void
      {
         _userAgent = custom;
      }
      
      public function set appVersion(value:com.google.analytics.utils.Version) : void
      {
         _appVersion = value;
         userAgent.applicationVersion = value.toString(4);
      }
      
      public function get screenHeight() : Number
      {
         return Capabilities.screenResolutionY;
      }
      
      public function get locationPath() : String
      {
         var _pathname:String = _dom.pathname;
         if(_pathname)
         {
            return _pathname;
         }
         return "";
      }
      
      public function get documentTitle() : String
      {
         var _title:String = _dom.title;
         if(_title)
         {
            return _title;
         }
         return "";
      }
      
      public function get appVersion() : com.google.analytics.utils.Version
      {
         return _appVersion;
      }
   }
}
