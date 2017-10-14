package com.google.analytics.core
{
   public class DomainNameMode
   {
      
      public static const custom:com.google.analytics.core.DomainNameMode = new com.google.analytics.core.DomainNameMode(2,"custom");
      
      public static const none:com.google.analytics.core.DomainNameMode = new com.google.analytics.core.DomainNameMode(0,"none");
      
      public static const auto:com.google.analytics.core.DomainNameMode = new com.google.analytics.core.DomainNameMode(1,"auto");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function DomainNameMode(value:int = 0, name:String = "")
      {
         super();
         _value = value;
         _name = name;
      }
      
      public function valueOf() : int
      {
         return _value;
      }
      
      public function toString() : String
      {
         return _name;
      }
   }
}
