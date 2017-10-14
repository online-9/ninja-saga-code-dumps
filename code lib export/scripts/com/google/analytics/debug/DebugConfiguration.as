package com.google.analytics.debug
{
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   import com.google.analytics.core.GIFRequest;
   import flash.ui.Keyboard;
   
   public class DebugConfiguration
   {
       
      
      public var showHideKey:Number;
      
      private var _mode:com.google.analytics.debug.VisualDebugMode;
      
      private var _verbose:Boolean = false;
      
      public var destroyKey:Number;
      
      public var GIFRequests:Boolean = false;
      
      public var showInfos:Boolean = true;
      
      public var infoTimeout:Number = 1000;
      
      public var minimizedOnStart:Boolean = false;
      
      private var _active:Boolean = false;
      
      public var traceOutput:Boolean = false;
      
      public var layout:com.google.analytics.debug.ILayout;
      
      public var warningTimeout:Number = 1500;
      
      public var javascript:Boolean = false;
      
      public var showWarnings:Boolean = true;
      
      private var _visualInitialized:Boolean = false;
      
      public function DebugConfiguration()
      {
         _mode = com.google.analytics.debug.VisualDebugMode.basic;
         showHideKey = Keyboard.SPACE;
         destroyKey = Keyboard.BACKSPACE;
         super();
      }
      
      public function get verbose() : Boolean
      {
         return _verbose;
      }
      
      public function set verbose(value:Boolean) : void
      {
         _verbose = value;
      }
      
      public function set mode(value:*) : void
      {
         if(value is String)
         {
            switch(value)
            {
               case "geek":
                  value = com.google.analytics.debug.VisualDebugMode.geek;
                  break;
               case "advanced":
                  value = com.google.analytics.debug.VisualDebugMode.advanced;
                  break;
               default:
               case "basic":
                  value = com.google.analytics.debug.VisualDebugMode.basic;
            }
         }
         _mode = value;
      }
      
      public function success(message:String) : void
      {
         if(layout)
         {
            layout.createSuccessAlert(message);
         }
         if(traceOutput)
         {
            trace("[+] " + message + " !!");
         }
      }
      
      public function get active() : Boolean
      {
         return _active;
      }
      
      private function _initializeVisual() : void
      {
         if(layout)
         {
            layout.init();
            _visualInitialized = true;
         }
      }
      
      private function _destroyVisual() : void
      {
         if(layout && _visualInitialized)
         {
            layout.destroy();
         }
      }
      
      public function warning(message:String, mode:com.google.analytics.debug.VisualDebugMode = null) : void
      {
         if(_filter(mode))
         {
            return;
         }
         if(layout && showWarnings)
         {
            layout.createWarning(message);
         }
         if(traceOutput)
         {
            trace("## " + message + " ##");
         }
      }
      
      private function _filter(mode:com.google.analytics.debug.VisualDebugMode = null) : Boolean
      {
         return mode && int(mode) >= int(this.mode);
      }
      
      public function failure(message:String) : void
      {
         if(layout)
         {
            layout.createFailureAlert(message);
         }
         if(traceOutput)
         {
            trace("[-] " + message + " !!");
         }
      }
      
      public function get mode() : *
      {
         return _mode;
      }
      
      public function set active(value:Boolean) : void
      {
         _active = value;
         if(_active)
         {
            _initializeVisual();
         }
         else
         {
            _destroyVisual();
         }
      }
      
      protected function trace(message:String) : void
      {
         var msgs:Array = null;
         var j:int = 0;
         var messages:Array = [];
         var pre0:* = "";
         var pre1:* = "";
         if(this.mode == com.google.analytics.debug.VisualDebugMode.geek)
         {
            pre0 = getTimer() + " - ";
            pre1 = new Array(pre0.length).join(" ") + " ";
         }
         if(message.indexOf("\n") > -1)
         {
            msgs = message.split("\n");
            for(j = 0; j < msgs.length; j++)
            {
               if(msgs[j] != "")
               {
                  if(j == 0)
                  {
                     messages.push(pre0 + msgs[j]);
                  }
                  else
                  {
                     messages.push(pre1 + msgs[j]);
                  }
               }
            }
         }
         else
         {
            messages.push(pre0 + message);
         }
         var len:int = messages.length;
         for(var i:int = 0; i < len; i++)
         {
            trace(messages[i]);
         }
      }
      
      public function alert(message:String) : void
      {
         if(layout)
         {
            layout.createAlert(message);
         }
         if(traceOutput)
         {
            trace("!! " + message + " !!");
         }
      }
      
      public function info(message:String, mode:com.google.analytics.debug.VisualDebugMode = null) : void
      {
         if(_filter(mode))
         {
            return;
         }
         if(layout && showInfos)
         {
            layout.createInfo(message);
         }
         if(traceOutput)
         {
            trace(message);
         }
      }
      
      public function alertGifRequest(message:String, request:URLRequest, ref:GIFRequest) : void
      {
         if(layout)
         {
            layout.createGIFRequestAlert(message,request,ref);
         }
         if(traceOutput)
         {
            trace(">> " + message + " <<");
         }
      }
   }
}
