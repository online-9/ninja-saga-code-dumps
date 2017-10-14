package com.google.analytics.external
{
   import com.google.analytics.debug.DebugConfiguration;
   
   public class HTMLDOM extends JavascriptProxy
   {
      
      public static var cache_properties_js:XML = <script>
            <![CDATA[
                    function()
                    {
                        var obj = {};
                            obj.host         = document.location.host;
                            obj.language     = navigator.language ? navigator.language : navigator.browserLanguage;
                            obj.characterSet = document.characterSet ? document.characterSet : document.charset;
                            obj.colorDepth   = window.screen.colorDepth;
                            obj.location     = document.location.toString();
                            obj.pathname     = document.location.pathname;
                            obj.protocol     = document.location.protocol;
                            obj.search       = document.location.search;
                            obj.referrer     = document.referrer;
                            obj.title        = document.title;
                        
                        return obj;
                    }
                ]]>
         </script>;
       
      
      private var _referrer:String;
      
      private var _language:String;
      
      private var _host:String;
      
      private var _pathname:String;
      
      private var _location:String;
      
      private var _search:String;
      
      private var _characterSet:String;
      
      private var _title:String;
      
      private var _protocol:String;
      
      private var _colorDepth:String;
      
      public function HTMLDOM(debug:DebugConfiguration)
      {
         super(debug);
      }
      
      public function get search() : String
      {
         if(_search)
         {
            return _search;
         }
         if(!isAvailable())
         {
            return null;
         }
         _search = getProperty("document.location.search");
         return _search;
      }
      
      public function get location() : String
      {
         if(_location)
         {
            return _location;
         }
         if(!isAvailable())
         {
            return null;
         }
         _location = getPropertyString("document.location");
         return _location;
      }
      
      public function get pathname() : String
      {
         if(_pathname)
         {
            return _pathname;
         }
         if(!isAvailable())
         {
            return null;
         }
         _pathname = getProperty("document.location.pathname");
         return _pathname;
      }
      
      public function cacheProperties() : void
      {
         if(!isAvailable())
         {
            return;
         }
         var obj:Object = call(cache_properties_js);
         if(obj)
         {
            _host = obj.host;
            _language = obj.language;
            _characterSet = obj.characterSet;
            _colorDepth = obj.colorDepth;
            _location = obj.location;
            _pathname = obj.pathname;
            _protocol = obj.protocol;
            _search = obj.search;
            _referrer = obj.referrer;
            _title = obj.title;
         }
      }
      
      public function get language() : String
      {
         if(_language)
         {
            return _language;
         }
         if(!isAvailable())
         {
            return null;
         }
         var lang:String = getProperty("navigator.language");
         if(lang == null)
         {
            lang = getProperty("navigator.browserLanguage");
         }
         _language = lang;
         return _language;
      }
      
      public function get colorDepth() : String
      {
         if(_colorDepth)
         {
            return _colorDepth;
         }
         if(!isAvailable())
         {
            return null;
         }
         _colorDepth = getProperty("window.screen.colorDepth");
         return _colorDepth;
      }
      
      public function get referrer() : String
      {
         if(_referrer)
         {
            return _referrer;
         }
         if(!isAvailable())
         {
            return null;
         }
         _referrer = getProperty("document.referrer");
         return _referrer;
      }
      
      public function get protocol() : String
      {
         if(_protocol)
         {
            return _protocol;
         }
         if(!isAvailable())
         {
            return null;
         }
         _protocol = getProperty("document.location.protocol");
         return _protocol;
      }
      
      public function get host() : String
      {
         if(_host)
         {
            return _host;
         }
         if(!isAvailable())
         {
            return null;
         }
         _host = getProperty("document.location.host");
         return _host;
      }
      
      public function get characterSet() : String
      {
         if(_characterSet)
         {
            return _characterSet;
         }
         if(!isAvailable())
         {
            return null;
         }
         var cs:String = getProperty("document.characterSet");
         if(cs == null)
         {
            cs = getProperty("document.charset");
         }
         _characterSet = cs;
         return _characterSet;
      }
      
      public function get title() : String
      {
         if(_title)
         {
            return _title;
         }
         if(!isAvailable())
         {
            return null;
         }
         _title = getProperty("document.title");
         return _title;
      }
   }
}
