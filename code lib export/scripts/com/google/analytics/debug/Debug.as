package com.google.analytics.debug
{
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class Debug extends Label
   {
      
      public static var count:uint = 0;
       
      
      private var _lines:Array;
      
      private var _preferredForcedWidth:uint = 540;
      
      private var _linediff:int = 0;
      
      public var maxLines:uint = 16;
      
      public function Debug(color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
      {
         if(alignement == null)
         {
            alignement = Align.bottom;
         }
         super("","uiLabel",color,alignement,stickToEdge);
         this.name = "Debug" + count++;
         _lines = [];
         selectable = true;
         addEventListener(KeyboardEvent.KEY_DOWN,onKey);
      }
      
      public function writeBold(message:String) : void
      {
         write(message,true);
      }
      
      private function _getLinesToDisplay(direction:int = 0) : Array
      {
         var lines:Array = null;
         var start:uint = 0;
         var end:uint = 0;
         if(_lines.length - 1 > maxLines)
         {
            if(_linediff <= 0)
            {
               _linediff = _linediff + direction;
            }
            else if(_linediff > 0 && direction < 0)
            {
               _linediff = _linediff + direction;
            }
            start = _lines.length - maxLines + _linediff;
            end = start + maxLines;
            lines = _lines.slice(start,end);
         }
         else
         {
            lines = _lines;
         }
         return lines;
      }
      
      private function onKey(event:KeyboardEvent = null) : void
      {
         var lines:Array = null;
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
               lines = _getLinesToDisplay(1);
               break;
            case Keyboard.UP:
               lines = _getLinesToDisplay(-1);
               break;
            default:
               lines = null;
         }
         if(lines == null)
         {
            return;
         }
         text = lines.join("\n");
      }
      
      override public function get forcedWidth() : uint
      {
         if(this.parent)
         {
            if(UISprite(this.parent).forcedWidth > _preferredForcedWidth)
            {
               return _preferredForcedWidth;
            }
            return UISprite(this.parent).forcedWidth;
         }
         return super.forcedWidth;
      }
      
      public function write(message:String, bold:Boolean = false) : void
      {
         var inputLines:Array = null;
         if(message.indexOf("") > -1)
         {
            inputLines = message.split("\n");
         }
         else
         {
            inputLines = [message];
         }
         var pre:String = "";
         var post:String = "";
         if(bold)
         {
            pre = "<b>";
            post = "</b>";
         }
         for(var i:int = 0; i < inputLines.length; i++)
         {
            _lines.push(pre + inputLines[i] + post);
         }
         var lines:Array = _getLinesToDisplay();
         text = lines.join("\n");
      }
      
      public function close() : void
      {
         dispose();
      }
      
      override protected function dispose() : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,onKey);
         super.dispose();
      }
   }
}
