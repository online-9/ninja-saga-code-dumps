package com.google.analytics.core
{
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   
   public class RequestObject
   {
       
      
      public var start:int;
      
      public var end:int;
      
      public var request:URLRequest;
      
      public function RequestObject(request:URLRequest)
      {
         super();
         start = getTimer();
         this.request = request;
      }
      
      public function hasCompleted() : Boolean
      {
         return end > 0;
      }
      
      public function toString() : String
      {
         var data:Array = [];
         data.push("duration: " + duration + "ms");
         data.push("url: " + request.url);
         return "{ " + data.join(", ") + " }";
      }
      
      public function complete() : void
      {
         end = getTimer();
      }
      
      public function get duration() : int
      {
         if(!hasCompleted())
         {
            return 0;
         }
         return end - start;
      }
   }
}
