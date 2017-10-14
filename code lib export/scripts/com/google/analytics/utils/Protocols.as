package com.google.analytics.utils
{
   public class Protocols
   {
      
      public static const none:com.google.analytics.utils.Protocols = new com.google.analytics.utils.Protocols(0,"none");
      
      public static const HTTPS:com.google.analytics.utils.Protocols = new com.google.analytics.utils.Protocols(3,"HTTPS");
      
      public static const file:com.google.analytics.utils.Protocols = new com.google.analytics.utils.Protocols(1,"file");
      
      public static const HTTP:com.google.analytics.utils.Protocols = new com.google.analytics.utils.Protocols(2,"HTTP");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function Protocols(value:int = 0, name:String = "")
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
