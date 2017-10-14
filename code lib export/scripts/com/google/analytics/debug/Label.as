package com.google.analytics.debug
{
   import flash.display.Graphics;
   import flash.text.TextFieldType;
   import flash.text.TextFieldAutoSize;
   import flash.display.Shape;
   import flash.text.TextField;
   import flash.events.TextEvent;
   
   public class Label extends UISprite
   {
      
      public static var count:uint = 0;
       
      
      private var _color:uint;
      
      private var _background:Shape;
      
      private var _textField:TextField;
      
      public var stickToEdge:Boolean;
      
      private var _text:String;
      
      protected var selectable:Boolean;
      
      private var _tag:String;
      
      public function Label(text:String = "", tag:String = "uiLabel", color:uint = 0, alignement:Align = null, stickToEdge:Boolean = false)
      {
         super();
         this.name = "Label" + count++;
         selectable = false;
         _background = new Shape();
         _textField = new TextField();
         _text = text;
         _tag = tag;
         if(alignement == null)
         {
            alignement = Align.none;
         }
         this.alignement = alignement;
         this.stickToEdge = stickToEdge;
         if(color == 0)
         {
            color = Style.backgroundColor;
         }
         _color = color;
         _textField.addEventListener(TextEvent.LINK,onLink);
      }
      
      public function get tag() : String
      {
         return _tag;
      }
      
      private function _draw() : void
      {
         var g:Graphics = _background.graphics;
         g.clear();
         g.beginFill(_color);
         var W:uint = _textField.width;
         var H:uint = _textField.height;
         if(forcedWidth > 0)
         {
            W = forcedWidth;
         }
         Background.drawRounded(this,g,W,H);
         g.endFill();
      }
      
      public function get text() : String
      {
         return _textField.text;
      }
      
      public function appendText(value:String, newtag:String = "") : void
      {
         if(value == "")
         {
            return;
         }
         if(newtag == "")
         {
            newtag = tag;
         }
         _textField.htmlText = _textField.htmlText + ("<span class=\"" + newtag + "\">" + value + "</span>");
         _text = _text + value;
         _draw();
         resize();
      }
      
      public function set text(value:String) : void
      {
         if(value == "")
         {
            value = _text;
         }
         _textField.htmlText = "<span class=\"" + tag + "\">" + value + "</span>";
         _text = value;
         _draw();
         resize();
      }
      
      override protected function layout() : void
      {
         _textField.type = TextFieldType.DYNAMIC;
         _textField.autoSize = TextFieldAutoSize.LEFT;
         _textField.background = false;
         _textField.selectable = selectable;
         _textField.multiline = true;
         _textField.styleSheet = Style.sheet;
         this.text = _text;
         addChild(_background);
         addChild(_textField);
      }
      
      public function set tag(value:String) : void
      {
         _tag = value;
         text = "";
      }
      
      public function onLink(event:TextEvent) : void
      {
      }
      
      override protected function dispose() : void
      {
         _textField.removeEventListener(TextEvent.LINK,onLink);
         super.dispose();
      }
   }
}
