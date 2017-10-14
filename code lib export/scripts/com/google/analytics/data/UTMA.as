package com.google.analytics.data
{
   import com.google.analytics.utils.Timespan;
   
   public class UTMA extends UTMCookie
   {
       
      
      private var _sessionId:Number;
      
      private var _domainHash:Number;
      
      private var _firstTime:Number;
      
      private var _currentTime:Number;
      
      private var _lastTime:Number;
      
      private var _sessionCount:Number;
      
      public function UTMA(domainHash:Number = NaN, sessionId:Number = NaN, firstTime:Number = NaN, lastTime:Number = NaN, currentTime:Number = NaN, sessionCount:Number = NaN)
      {
         super("utma","__utma",["domainHash","sessionId","firstTime","lastTime","currentTime","sessionCount"],Timespan.twoyears * 1000);
         this.domainHash = domainHash;
         this.sessionId = sessionId;
         this.firstTime = firstTime;
         this.lastTime = lastTime;
         this.currentTime = currentTime;
         this.sessionCount = sessionCount;
      }
      
      public function get lastTime() : Number
      {
         return _lastTime;
      }
      
      public function set lastTime(value:Number) : void
      {
         _lastTime = value;
         update();
      }
      
      public function set currentTime(value:Number) : void
      {
         _currentTime = value;
         update();
      }
      
      public function get sessionId() : Number
      {
         return _sessionId;
      }
      
      public function get sessionCount() : Number
      {
         return _sessionCount;
      }
      
      public function get firstTime() : Number
      {
         return _firstTime;
      }
      
      public function get currentTime() : Number
      {
         return _currentTime;
      }
      
      public function set domainHash(value:Number) : void
      {
         _domainHash = value;
         update();
      }
      
      public function set sessionId(value:Number) : void
      {
         _sessionId = value;
         update();
      }
      
      public function set sessionCount(value:Number) : void
      {
         _sessionCount = value;
         update();
      }
      
      public function get domainHash() : Number
      {
         return _domainHash;
      }
      
      public function set firstTime(value:Number) : void
      {
         _firstTime = value;
         update();
      }
   }
}
