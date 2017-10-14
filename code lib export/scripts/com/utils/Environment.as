package com.utils
{
   import flash.system.Capabilities;
   import flash.net.LocalConnection;
   
   public class Environment
   {
       
      
      public function Environment()
      {
         super();
      }
      
      public static function get IS_IN_BROWSER() : Boolean
      {
         return Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn";
      }
      
      public static function get DOMAIN() : String
      {
         return new LocalConnection().domain;
      }
      
      public static function get IS_IN_AIR() : Boolean
      {
         return Capabilities.playerType == "Desktop";
      }
      
      public static function get IS_NINJASAGA() : Boolean
      {
         if(DOMAIN != "www.ninjasaga.com")
         {
         }
         return DOMAIN == "ninjasaga.com";
      }
   }
}
