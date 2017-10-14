package com.google.analytics.core
{
   public class ServerOperationMode
   {
      
      public static const both:com.google.analytics.core.ServerOperationMode = new com.google.analytics.core.ServerOperationMode(2,"both");
      
      public static const remote:com.google.analytics.core.ServerOperationMode = new com.google.analytics.core.ServerOperationMode(1,"remote");
      
      public static const local:com.google.analytics.core.ServerOperationMode = new com.google.analytics.core.ServerOperationMode(0,"local");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function ServerOperationMode(value:int = 0, name:String = "")
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
