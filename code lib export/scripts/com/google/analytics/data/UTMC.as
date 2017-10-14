package com.google.analytics.data
{
   public class UTMC extends UTMCookie
   {
       
      
      private var _domainHash:Number;
      
      public function UTMC(domainHash:Number = NaN)
      {
         super("utmc","__utmc",["domainHash"]);
         this.domainHash = domainHash;
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
   }
}
