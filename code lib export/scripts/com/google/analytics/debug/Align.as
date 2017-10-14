package com.google.analytics.debug
{
   public class Align
   {
      
      public static const bottomRight:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(18,"bottomRight");
      
      public static const right:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(16,"right");
      
      public static const left:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(32,"left");
      
      public static const topRight:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(17,"topRight");
      
      public static const bottom:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(2,"bottom");
      
      public static const bottomLeft:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(34,"bottomLeft");
      
      public static const topLeft:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(33,"topLeft");
      
      public static const center:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(256,"center");
      
      public static const none:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(0,"none");
      
      public static const top:com.google.analytics.debug.Align = new com.google.analytics.debug.Align(1,"top");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function Align(value:int = 0, name:String = "")
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
