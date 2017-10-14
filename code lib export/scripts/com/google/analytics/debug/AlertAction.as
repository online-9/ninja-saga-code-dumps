package com.google.analytics.debug
{
   public class AlertAction
   {
       
      
      public var container:com.google.analytics.debug.Alert;
      
      private var _callback;
      
      public var activator:String;
      
      public var name:String;
      
      public function AlertAction(name:String, activator:String, callback:*)
      {
         super();
         this.name = name;
         this.activator = activator;
         _callback = callback;
      }
      
      public function execute() : void
      {
         if(_callback)
         {
            if(_callback is Function)
            {
               (_callback as Function)();
            }
            else if(_callback is String)
            {
               container[_callback]();
            }
         }
      }
   }
}
