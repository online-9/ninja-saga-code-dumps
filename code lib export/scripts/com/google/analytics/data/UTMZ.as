package com.google.analytics.data
{
   import com.google.analytics.utils.Timespan;
   
   public class UTMZ extends UTMCookie
   {
      
      public static var defaultTimespan:Number = Timespan.sixmonths;
       
      
      private var _campaignTracking:String;
      
      private var _campaignCreation:Number;
      
      private var _responseCount:Number;
      
      private var _domainHash:Number;
      
      private var _campaignSessions:Number;
      
      public function UTMZ(domainHash:Number = NaN, campaignCreation:Number = NaN, campaignSessions:Number = NaN, responseCount:Number = NaN, campaignTracking:String = "")
      {
         super("utmz","__utmz",["domainHash","campaignCreation","campaignSessions","responseCount","campaignTracking"],defaultTimespan * 1000);
         this.domainHash = domainHash;
         this.campaignCreation = campaignCreation;
         this.campaignSessions = campaignSessions;
         this.responseCount = responseCount;
         this.campaignTracking = campaignTracking;
      }
      
      public function set responseCount(value:Number) : void
      {
         _responseCount = value;
         update();
      }
      
      public function set domainHash(value:Number) : void
      {
         _domainHash = value;
         update();
      }
      
      public function set campaignCreation(value:Number) : void
      {
         _campaignCreation = value;
         update();
      }
      
      public function get campaignTracking() : String
      {
         return _campaignTracking;
      }
      
      public function get campaignSessions() : Number
      {
         return _campaignSessions;
      }
      
      public function get domainHash() : Number
      {
         return _domainHash;
      }
      
      public function get responseCount() : Number
      {
         return _responseCount;
      }
      
      public function get campaignCreation() : Number
      {
         return _campaignCreation;
      }
      
      public function set campaignSessions(value:Number) : void
      {
         _campaignSessions = value;
         update();
      }
      
      public function set campaignTracking(value:String) : void
      {
         _campaignTracking = value;
         update();
      }
   }
}
