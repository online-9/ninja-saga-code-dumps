package com.google.analytics.core
{
   import com.google.analytics.v4.GoogleAnalyticsAPI;
   
   public class EventTracker
   {
       
      
      private var _parent:GoogleAnalyticsAPI;
      
      public var name:String;
      
      public function EventTracker(name:String, parent:GoogleAnalyticsAPI)
      {
         super();
         this.name = name;
         _parent = parent;
      }
      
      public function trackEvent(action:String, label:String = null, value:Number = NaN) : Boolean
      {
         return _parent.trackEvent(name,action,label,value);
      }
   }
}
