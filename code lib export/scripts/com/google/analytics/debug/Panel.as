package com.google.analytics.debug
{
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.display.Graphics;
   import flash.display.DisplayObject;
   
   public class Panel extends com.google.analytics.debug.UISprite
   {
       
      
      private var _savedH:uint;
      
      private var _data:com.google.analytics.debug.UISprite;
      
      private var _mask:Sprite;
      
      private var _background:Shape;
      
      private var _savedW:uint;
      
      private var _stickToEdge:Boolean;
      
      private var _border:Shape;
      
      private var _borderColor:uint;
      
      protected var baseAlpha:Number;
      
      private var _backgroundColor:uint;
      
      private var _title:com.google.analytics.debug.Label;
      
      private var _colapsed:Boolean;
      
      private var _name:String;
      
      public function Panel(name:String, width:uint, height:uint, backgroundColor:uint = 0, borderColor:uint = 0, baseAlpha:Number = 0.3, alignement:Align = null, stickToEdge:Boolean = false)
      {
         super();
         _name = name;
         this.name = name;
         this.mouseEnabled = false;
         _colapsed = false;
         forcedWidth = width;
         forcedHeight = height;
         this.baseAlpha = baseAlpha;
         _background = new Shape();
         _data = new com.google.analytics.debug.UISprite();
         _data.forcedWidth = width;
         _data.forcedHeight = height;
         _data.mouseEnabled = false;
         _title = new com.google.analytics.debug.Label(name,"uiLabel",16777215,Align.topLeft,stickToEdge);
         _title.buttonMode = true;
         _title.margin.top = 0.6;
         _title.margin.left = 0.6;
         _title.addEventListener(MouseEvent.CLICK,onToggle);
         _title.mouseChildren = false;
         _border = new Shape();
         _mask = new Sprite();
         _mask.useHandCursor = false;
         _mask.mouseEnabled = false;
         _mask.mouseChildren = false;
         if(alignement == null)
         {
            alignement = Align.none;
         }
         this.alignement = alignement;
         this.stickToEdge = stickToEdge;
         if(backgroundColor == 0)
         {
            backgroundColor = Style.backgroundColor;
         }
         _backgroundColor = backgroundColor;
         if(borderColor == 0)
         {
            borderColor = Style.borderColor;
         }
         _borderColor = borderColor;
      }
      
      public function get stickToEdge() : Boolean
      {
         return _stickToEdge;
      }
      
      public function onToggle(event:MouseEvent = null) : void
      {
         if(_colapsed)
         {
            _data.visible = true;
         }
         else
         {
            _data.visible = false;
         }
         _colapsed = !_colapsed;
         _update();
         resize();
      }
      
      public function set stickToEdge(value:Boolean) : void
      {
         _stickToEdge = value;
         _title.stickToEdge = value;
      }
      
      override protected function dispose() : void
      {
         _title.removeEventListener(MouseEvent.CLICK,onToggle);
         super.dispose();
      }
      
      private function _draw() : void
      {
         var W:uint = 0;
         var H:uint = 0;
         if(_savedW && _savedH)
         {
            forcedWidth = _savedW;
            forcedHeight = _savedH;
         }
         if(!_colapsed)
         {
            W = forcedWidth;
            H = forcedHeight;
         }
         else
         {
            W = _title.width;
            H = _title.height;
            _savedW = forcedWidth;
            _savedH = forcedHeight;
            forcedWidth = W;
            forcedHeight = H;
         }
         var g0:Graphics = _background.graphics;
         g0.clear();
         g0.beginFill(_backgroundColor);
         Background.drawRounded(this,g0,W,H);
         g0.endFill();
         var g01:Graphics = _data.graphics;
         g01.clear();
         g01.beginFill(_backgroundColor,0);
         Background.drawRounded(this,g01,W,H);
         g01.endFill();
         var g1:Graphics = _border.graphics;
         g1.clear();
         g1.lineStyle(0.1,_borderColor);
         Background.drawRounded(this,g1,W,H);
         g1.endFill();
         var g2:Graphics = _mask.graphics;
         g2.clear();
         g2.beginFill(_backgroundColor);
         Background.drawRounded(this,g2,W + 1,H + 1);
         g2.endFill();
      }
      
      public function get title() : String
      {
         return _title.text;
      }
      
      private function _update() : void
      {
         _draw();
         if(baseAlpha < 1)
         {
            _background.alpha = baseAlpha;
            _border.alpha = baseAlpha;
         }
      }
      
      public function addData(child:DisplayObject) : void
      {
         _data.addChild(child);
      }
      
      override protected function layout() : void
      {
         _update();
         addChild(_background);
         addChild(_data);
         addChild(_title);
         addChild(_border);
         addChild(_mask);
         mask = _mask;
      }
      
      public function set title(value:String) : void
      {
         _title.text = value;
      }
      
      public function close() : void
      {
         dispose();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}
