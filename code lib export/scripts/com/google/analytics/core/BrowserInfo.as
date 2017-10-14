package com.google.analytics.core
{
   import com.google.analytics.v4.Configuration;
   import com.google.analytics.utils.Variables;
   import com.google.analytics.utils.Environment;
   import com.google.analytics.utils.Version;
   
   public class BrowserInfo
   {
       
      
      private var _config:Configuration;
      
      private var _info:Environment;
      
      public function BrowserInfo(config:Configuration, info:Environment)
      {
         super();
         _config = config;
         _info = info;
      }
      
      public function get utmul() : String
      {
         return _info.language.toLowerCase();
      }
      
      public function get utmje() : String
      {
         return "0";
      }
      
      public function toURLString() : String
      {
         var v:Variables = toVariables();
         return v.toString();
      }
      
      public function get utmsr() : String
      {
         return _info.screenWidth + "x" + _info.screenHeight;
      }
      
      public function get utmfl() : String
      {
         var v:Version = null;
         if(_config.detectFlash)
         {
            v = _info.flashVersion;
            return v.major + "." + v.minor + " r" + v.build;
         }
         return "-";
      }
      
      public function get utmcs() : String
      {
         return _info.languageEncoding;
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         variables.utmcs = utmcs;
         variables.utmsr = utmsr;
         variables.utmsc = utmsc;
         variables.utmul = utmul;
         variables.utmje = utmje;
         variables.utmfl = utmfl;
         return variables;
      }
      
      public function get utmsc() : String
      {
         return _info.screenColorDepth + "-bit";
      }
   }
}
