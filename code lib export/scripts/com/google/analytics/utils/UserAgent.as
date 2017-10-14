package com.google.analytics.utils
{
   import flash.system.System;
   import com.google.analytics.core.Utils;
   import flash.system.Capabilities;
   
   public class UserAgent
   {
      
      public static var minimal:Boolean = false;
       
      
      private var _localInfo:com.google.analytics.utils.Environment;
      
      private var _applicationProduct:String;
      
      private var _version:com.google.analytics.utils.Version;
      
      public function UserAgent(localInfo:com.google.analytics.utils.Environment, product:String = "", version:String = "")
      {
         super();
         _localInfo = localInfo;
         applicationProduct = product;
         _version = com.google.analytics.utils.Version.fromString(version);
      }
      
      public function get tamarinProductToken() : String
      {
         if(UserAgent.minimal)
         {
            return "";
         }
         if(System.vmVersion)
         {
            return "Tamarin/" + Utils.trim(System.vmVersion,true);
         }
         return "";
      }
      
      public function get applicationVersion() : String
      {
         return _version.toString(2);
      }
      
      public function get vendorProductToken() : String
      {
         var vp:* = "";
         if(_localInfo.isAIR())
         {
            vp = vp + "AIR";
         }
         else
         {
            vp = vp + "FlashPlayer";
         }
         vp = vp + "/";
         vp = vp + _version.toString(3);
         return vp;
      }
      
      public function toString() : String
      {
         var UA:String = "";
         UA = UA + applicationProductToken;
         if(applicationComment != "")
         {
            UA = UA + (" " + applicationComment);
         }
         if(tamarinProductToken != "")
         {
            UA = UA + (" " + tamarinProductToken);
         }
         if(vendorProductToken != "")
         {
            UA = UA + (" " + vendorProductToken);
         }
         return UA;
      }
      
      public function get applicationComment() : String
      {
         var comment:Array = [];
         comment.push(_localInfo.platform);
         comment.push(_localInfo.playerType);
         if(!UserAgent.minimal)
         {
            comment.push(_localInfo.operatingSystem);
            comment.push(_localInfo.language);
         }
         if(Capabilities.isDebugger)
         {
            comment.push("DEBUG");
         }
         if(comment.length > 0)
         {
            return "(" + comment.join("; ") + ")";
         }
         return "";
      }
      
      public function set applicationVersion(value:String) : void
      {
         _version = com.google.analytics.utils.Version.fromString(value);
      }
      
      public function get applicationProductToken() : String
      {
         var token:String = applicationProduct;
         if(applicationVersion != "")
         {
            token = token + ("/" + applicationVersion);
         }
         return token;
      }
      
      public function set applicationProduct(value:String) : void
      {
         _applicationProduct = value;
      }
      
      public function get applicationProduct() : String
      {
         return _applicationProduct;
      }
   }
}
