package com.google.analytics.core
{
   public class OrganicReferrer
   {
       
      
      private var _engine:String;
      
      private var _keyword:String;
      
      public function OrganicReferrer(engine:String, keyword:String)
      {
         super();
         this.engine = engine;
         this.keyword = keyword;
      }
      
      public function get keyword() : String
      {
         return _keyword;
      }
      
      public function get engine() : String
      {
         return _engine;
      }
      
      public function set engine(value:String) : void
      {
         _engine = value.toLowerCase();
      }
      
      public function toString() : String
      {
         return engine + "?" + keyword;
      }
      
      public function set keyword(value:String) : void
      {
         _keyword = value.toLowerCase();
      }
   }
}
