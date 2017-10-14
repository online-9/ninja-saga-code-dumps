package com.google.analytics.debug
{
   import flash.events.TextEvent;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class Info extends Label
   {
       
      
      private var _timer:Timer;
      
      public function Info(text:String = "", timeout:uint = 3000)
      {
         super(text,"uiInfo",Style.infoColor,Align.top,true);
         if(timeout > 0)
         {
            _timer = new Timer(timeout,1);
            _timer.start();
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComplete,false,0,true);
         }
      }
      
      public function close() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      override public function onLink(event:TextEvent) : void
      {
         switch(event.text)
         {
            case "hide":
               close();
         }
      }
      
      public function onComplete(event:TimerEvent) : void
      {
         close();
      }
   }
}
