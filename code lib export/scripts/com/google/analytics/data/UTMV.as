package com.google.analytics.data
{
   import com.google.analytics.utils.Timespan;
   
   public class UTMV extends UTMCookie
   {
       
      
      private var _domainHash:Number;
      
      private var _value:String;
      
      public function UTMV(domainHash:Number = NaN, value:String = "")
      {
         super("utmv","__utmv",["domainHash","value"],Timespan.twoyears * 1000);
         this.domainHash = domainHash;
         this.value = value;
      }
      
      override public function toURLString() : String
      {
         return inURL + "=" + encodeURI(valueOf());
      }
      
      public function get value() : String
      {
         return _value;
      }
      
      public function get domainHash() : Number
      {
         return _domainHash;
      }
      
      public function set domainHash(value:Number) : void
      {
         _domainHash = value;
         update();
      }
      
      public function set value(value:String) : void
      {
         _value = value;
         update();
      }
   }
}
