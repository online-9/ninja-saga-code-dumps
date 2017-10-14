package com.google.analytics.data
{
   import com.google.analytics.utils.Timespan;
   
   public class UTMB extends UTMCookie
   {
      
      public static var defaultTimespan:Number = Timespan.thirtyminutes;
       
      
      private var _trackCount:Number;
      
      private var _lastTime:Number;
      
      private var _domainHash:Number;
      
      private var _token:Number;
      
      public function UTMB(domainHash:Number = NaN, trackCount:Number = NaN, token:Number = NaN, lastTime:Number = NaN)
      {
         super("utmb","__utmb",["domainHash","trackCount","token","lastTime"],defaultTimespan * 1000);
         this.domainHash = domainHash;
         this.trackCount = trackCount;
         this.token = token;
         this.lastTime = lastTime;
      }
      
      public function set token(value:Number) : void
      {
         _token = value;
         update();
      }
      
      public function set trackCount(value:Number) : void
      {
         _trackCount = value;
         update();
      }
      
      public function get lastTime() : Number
      {
         return _lastTime;
      }
      
      public function set domainHash(value:Number) : void
      {
         _domainHash = value;
         update();
      }
      
      public function set lastTime(value:Number) : void
      {
         _lastTime = value;
         update();
      }
      
      public function get domainHash() : Number
      {
         return _domainHash;
      }
      
      public function get token() : Number
      {
         return _token;
      }
      
      public function get trackCount() : Number
      {
         return _trackCount;
      }
   }
}
