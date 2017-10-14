package com.google.analytics.data
{
   public class UTMK extends UTMCookie
   {
       
      
      private var _hash:Number;
      
      public function UTMK(hash:Number = NaN)
      {
         super("utmk","__utmk",["hash"]);
         this.hash = hash;
      }
      
      public function set hash(value:Number) : void
      {
         _hash = value;
         update();
      }
      
      public function get hash() : Number
      {
         return _hash;
      }
   }
}
