package com.google.analytics.core
{
   import flash.display.Stage;
   import flash.utils.Timer;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import com.google.analytics.debug.VisualDebugMode;
   import com.google.analytics.debug.DebugConfiguration;
   import flash.events.TimerEvent;
   import com.google.analytics.v4.Configuration;
   import flash.display.DisplayObject;
   
   public class IdleTimer
   {
       
      
      private var _stage:Stage;
      
      private var _loop:Timer;
      
      private var _lastMove:int;
      
      private var _inactivity:Number;
      
      private var _debug:DebugConfiguration;
      
      private var _session:Timer;
      
      private var _buffer:com.google.analytics.core.Buffer;
      
      public function IdleTimer(config:Configuration, debug:DebugConfiguration, display:DisplayObject, buffer:com.google.analytics.core.Buffer)
      {
         super();
         var delay:Number = config.idleLoop;
         var inactivity:Number = config.idleTimeout;
         var sessionTimeout:Number = config.sessionTimeout;
         _loop = new Timer(delay * 1000);
         _session = new Timer(sessionTimeout * 1000,1);
         _debug = debug;
         _stage = display.stage;
         _buffer = buffer;
         _lastMove = getTimer();
         _inactivity = inactivity * 1000;
         _loop.addEventListener(TimerEvent.TIMER,checkForIdle);
         _session.addEventListener(TimerEvent.TIMER_COMPLETE,endSession);
         _stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         _debug.info("delay: " + delay + "sec , inactivity: " + inactivity + "sec, sessionTimeout: " + sessionTimeout,VisualDebugMode.geek);
         _loop.start();
      }
      
      private function onMouseMove(event:MouseEvent) : void
      {
         _lastMove = getTimer();
         if(_session.running)
         {
            _debug.info("session timer reset",VisualDebugMode.geek);
            _session.reset();
         }
      }
      
      public function endSession(event:TimerEvent) : void
      {
         _session.removeEventListener(TimerEvent.TIMER_COMPLETE,endSession);
         _debug.info("session timer end session",VisualDebugMode.geek);
         _session.reset();
         _buffer.resetCurrentSession();
         _debug.info(_buffer.utmb.toString(),VisualDebugMode.geek);
         _debug.info(_buffer.utmc.toString(),VisualDebugMode.geek);
         _session.addEventListener(TimerEvent.TIMER_COMPLETE,endSession);
      }
      
      public function checkForIdle(event:TimerEvent) : void
      {
         var current:int = getTimer();
         if(current - _lastMove >= _inactivity)
         {
            if(!_session.running)
            {
               _debug.info("session timer start",VisualDebugMode.geek);
               _session.start();
            }
         }
      }
   }
}
