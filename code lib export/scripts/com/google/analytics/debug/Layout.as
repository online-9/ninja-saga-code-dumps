package com.google.analytics.debug
{
   import flash.events.KeyboardEvent;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import com.google.analytics.GATracker;
   import flash.net.URLRequest;
   import com.google.analytics.core.GIFRequest;
   
   public class Layout implements ILayout
   {
       
      
      private var _display:DisplayObject;
      
      private var _infoQueue:Array;
      
      private var _maxCharPerLine:int = 85;
      
      private var _hasInfo:Boolean;
      
      private var _warningQueue:Array;
      
      private var _hasDebug:Boolean;
      
      private var _hasWarning:Boolean;
      
      private var _mainPanel:com.google.analytics.debug.Panel;
      
      private var _GRAlertQueue:Array;
      
      private var _debug:com.google.analytics.debug.DebugConfiguration;
      
      public var visualDebug:com.google.analytics.debug.Debug;
      
      private var _hasGRAlert:Boolean;
      
      public function Layout(debug:com.google.analytics.debug.DebugConfiguration, display:DisplayObject)
      {
         super();
         _display = display;
         _debug = debug;
         _hasWarning = false;
         _hasInfo = false;
         _hasDebug = false;
         _hasGRAlert = false;
         _warningQueue = [];
         _infoQueue = [];
         _GRAlertQueue = [];
      }
      
      private function onKey(event:KeyboardEvent = null) : void
      {
         switch(event.keyCode)
         {
            case _debug.showHideKey:
               _mainPanel.visible = !_mainPanel.visible;
               break;
            case _debug.destroyKey:
               destroy();
         }
      }
      
      public function createWarning(message:String) : void
      {
         if(_hasWarning || !isAvailable())
         {
            _warningQueue.push(message);
            return;
         }
         message = _filterMaxChars(message);
         _hasWarning = true;
         var w:Warning = new Warning(message,_debug.warningTimeout);
         addToPanel("analytics",w);
         w.addEventListener(Event.REMOVED_FROM_STAGE,_clearWarning,false,0,true);
         if(_hasDebug)
         {
            visualDebug.writeBold(message);
         }
      }
      
      public function bringToFront(visual:DisplayObject) : void
      {
         _display.stage.setChildIndex(visual,_display.stage.numChildren - 1);
      }
      
      public function createFailureAlert(message:String) : void
      {
         var actionClose:AlertAction = null;
         if(_debug.verbose)
         {
            message = _filterMaxChars(message);
            actionClose = new AlertAction("Close","close","close");
         }
         else
         {
            actionClose = new AlertAction("X","close","close");
         }
         var fa:Alert = new FailureAlert(_debug,message,[actionClose]);
         addToPanel("analytics",fa);
         if(_hasDebug)
         {
            if(_debug.verbose)
            {
               message = message.split("\n").join("");
               message = _filterMaxChars(message,66);
            }
            visualDebug.writeBold(message);
         }
      }
      
      public function init() : void
      {
         var spaces:int = 10;
         var W:uint = _display.stage.stageWidth - spaces * 2;
         var H:uint = _display.stage.stageHeight - spaces * 2;
         var mp:com.google.analytics.debug.Panel = new com.google.analytics.debug.Panel("analytics",W,H);
         mp.alignement = Align.top;
         mp.stickToEdge = false;
         mp.title = "Google Analytics v" + GATracker.version;
         _mainPanel = mp;
         addToStage(mp);
         bringToFront(mp);
         if(_debug.minimizedOnStart)
         {
            _mainPanel.onToggle();
         }
         createVisualDebug();
         _display.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey,false,0,true);
      }
      
      public function addToPanel(name:String, visual:DisplayObject) : void
      {
         var panel:com.google.analytics.debug.Panel = null;
         var d:DisplayObject = _display.stage.getChildByName(name);
         if(d)
         {
            panel = d as com.google.analytics.debug.Panel;
            panel.addData(visual);
         }
         else
         {
            trace("panel \"" + name + "\" not found");
         }
      }
      
      private function _clearInfo(event:Event) : void
      {
         _hasInfo = false;
         if(_infoQueue.length > 0)
         {
            createInfo(_infoQueue.shift());
         }
      }
      
      private function _filterMaxChars(message:String, maxCharPerLine:int = 0) : String
      {
         var line:String = null;
         var CRLF:String = "\n";
         var output:Array = [];
         var lines:Array = message.split(CRLF);
         if(maxCharPerLine == 0)
         {
            maxCharPerLine = _maxCharPerLine;
         }
         for(var i:int = 0; i < lines.length; i++)
         {
            line = lines[i];
            while(line.length > maxCharPerLine)
            {
               output.push(line.substr(0,maxCharPerLine));
               line = line.substring(maxCharPerLine);
            }
            output.push(line);
         }
         return output.join(CRLF);
      }
      
      private function _clearGRAlert(event:Event) : void
      {
         _hasGRAlert = false;
         if(_GRAlertQueue.length > 0)
         {
            createGIFRequestAlert.apply(this,_GRAlertQueue.shift());
         }
      }
      
      public function createSuccessAlert(message:String) : void
      {
         var actionClose:AlertAction = null;
         if(_debug.verbose)
         {
            message = _filterMaxChars(message);
            actionClose = new AlertAction("Close","close","close");
         }
         else
         {
            actionClose = new AlertAction("X","close","close");
         }
         var sa:Alert = new SuccessAlert(_debug,message,[actionClose]);
         addToPanel("analytics",sa);
         if(_hasDebug)
         {
            if(_debug.verbose)
            {
               message = message.split("\n").join("");
               message = _filterMaxChars(message,66);
            }
            visualDebug.writeBold(message);
         }
      }
      
      public function isAvailable() : Boolean
      {
         return _display.stage != null;
      }
      
      public function createAlert(message:String) : void
      {
         message = _filterMaxChars(message);
         var a:Alert = new Alert(message,[new AlertAction("Close","close","close")]);
         addToPanel("analytics",a);
         if(_hasDebug)
         {
            visualDebug.writeBold(message);
         }
      }
      
      public function createInfo(message:String) : void
      {
         if(_hasInfo || !isAvailable())
         {
            _infoQueue.push(message);
            return;
         }
         message = _filterMaxChars(message);
         _hasInfo = true;
         var i:Info = new Info(message,_debug.infoTimeout);
         addToPanel("analytics",i);
         i.addEventListener(Event.REMOVED_FROM_STAGE,_clearInfo,false,0,true);
         if(_hasDebug)
         {
            visualDebug.write(message);
         }
      }
      
      public function createGIFRequestAlert(message:String, request:URLRequest, ref:GIFRequest) : void
      {
         if(_hasGRAlert)
         {
            _GRAlertQueue.push([message,request,ref]);
            return;
         }
         _hasGRAlert = true;
         var f:Function = function():void
         {
            ref.sendRequest(request);
         };
         var message:String = _filterMaxChars(message);
         var gra:GIFRequestAlert = new GIFRequestAlert(message,[new AlertAction("OK","ok",f),new AlertAction("Cancel","cancel","close")]);
         addToPanel("analytics",gra);
         gra.addEventListener(Event.REMOVED_FROM_STAGE,_clearGRAlert,false,0,true);
         if(_hasDebug)
         {
            if(_debug.verbose)
            {
               message = message.split("\n").join("");
               message = _filterMaxChars(message,66);
            }
            visualDebug.write(message);
         }
      }
      
      public function createVisualDebug() : void
      {
         if(!visualDebug)
         {
            visualDebug = new com.google.analytics.debug.Debug();
            visualDebug.alignement = Align.bottom;
            visualDebug.stickToEdge = true;
            addToPanel("analytics",visualDebug);
            _hasDebug = true;
         }
      }
      
      public function addToStage(visual:DisplayObject) : void
      {
         _display.stage.addChild(visual);
      }
      
      private function _clearWarning(event:Event) : void
      {
         _hasWarning = false;
         if(_warningQueue.length > 0)
         {
            createWarning(_warningQueue.shift());
         }
      }
      
      public function createPanel(name:String, width:uint, height:uint) : void
      {
         var p:com.google.analytics.debug.Panel = new com.google.analytics.debug.Panel(name,width,height);
         p.alignement = Align.center;
         p.stickToEdge = false;
         addToStage(p);
         bringToFront(p);
      }
      
      public function destroy() : void
      {
         _mainPanel.close();
         _debug.layout = null;
      }
   }
}
