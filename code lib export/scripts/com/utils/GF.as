package com.utils
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public final class GF
   {
       
      
      public function GF()
      {
         super();
      }
      
      public static function removeAllChild(mc:MovieClip) : void
      {
         var numChildren:uint = 0;
         var i:uint = 0;
         if(mc != null)
         {
            numChildren = mc.numChildren;
            for(i = 0; i < numChildren; i++)
            {
               mc.removeChildAt(0);
            }
         }
      }
      
      public static function getClassName(obj:*) : String
      {
         return obj.toString().substring(8,obj.toString().length - 1);
      }
      
      public static function changeColor(_mc:MovieClip, _color:Number) : void
      {
         var ct:ColorTransform = null;
         try
         {
            if(_mc != null)
            {
               ct = _mc.transform.colorTransform;
               ct.color = _color;
               _mc.transform.colorTransform = ct;
            }
            else
            {
               trace("Error :: GF :: changeColor :: _color >> " + _color);
            }
         }
         catch(e:Error)
         {
            trace("Error :: GF :: changeColor :: e >> " + e);
         }
      }
      
      public static function cloneAsBitmap(_input:MovieClip, factor:Number, offsetX:Number, offsetY:Number, params:Object = null) : MovieClip
      {
         var transparent:Boolean = true;
         var background:int = 0;
         var width:Number = _input.width * factor;
         var height:Number = _input.height * factor;
         if(params != null)
         {
            if(params.width != null)
            {
               width = params.width * factor;
            }
            if(params.height != null)
            {
               height = params.height * factor;
            }
            if(params.transparent != null)
            {
               transparent = params.transparent;
            }
            if(params.background != null)
            {
               background = params.background;
            }
         }
         var _output:MovieClip = new MovieClip();
         var bitmapdata:BitmapData = new BitmapData(width,height,transparent,background);
         var matr:Matrix = new Matrix(factor,0,0,factor,offsetX,offsetY);
         bitmapdata.draw(_input,matr,null,"normal",null,true);
         var bitmapImg:Bitmap = new Bitmap(bitmapdata);
         _output.addChild(bitmapImg);
         return _output;
      }
      
      public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false) : DisplayObject
      {
         var rect:Rectangle = null;
         var targetClass:Class = target["constructor"];
         var duplicate:DisplayObject = new targetClass();
         duplicate.transform = target.transform;
         duplicate.filters = target.filters;
         duplicate.cacheAsBitmap = target.cacheAsBitmap;
         duplicate.opaqueBackground = target.opaqueBackground;
         if(target.scale9Grid)
         {
            rect = target.scale9Grid;
            duplicate.scale9Grid = rect;
         }
         if(autoAdd && target.parent)
         {
            target.parent.addChild(duplicate);
         }
         duplicate.x = 0;
         duplicate.y = 0;
         trace("GF :: " + duplicate.width + " :: " + duplicate.height);
         return duplicate;
      }
      
      public static function moveToFront(_mc:MovieClip) : void
      {
         var mcParent:MovieClip = null;
         if(_mc != null)
         {
            mcParent = MovieClip(_mc.parent);
            mcParent.setChildIndex(_mc,13);
         }
      }
      
      public static function removeParent(_mc:MovieClip) : void
      {
         if(_mc != null)
         {
            if(_mc.parent)
            {
               MovieClip(_mc.parent).removeChild(_mc);
            }
         }
      }
      
      public static function getAsset(_swf:MovieClip, _cls:String) : *
      {
         var cls:Class = null;
         try
         {
            cls = Class(_swf.loaderInfo.applicationDomain.getDefinition(_cls));
            return new cls();
         }
         catch(e:Error)
         {
            trace("ERROR :: getAsset :: " + _cls + " ::" + e.message);
         }
         return null;
      }
      
      public static function startTimer(_delay:Number, _repeatCount:int, _completeFn:Function) : Timer
      {
         var _timer:Timer = new Timer(_delay,_repeatCount);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,_completeFn);
         _timer.start();
         return _timer;
      }
      
      public static function stopTimer(_timer:Timer, _completeFn:Function = null) : void
      {
         if(_timer)
         {
            _timer.stop();
            _timer.reset();
            if(_timer.hasEventListener(TimerEvent.TIMER_COMPLETE) && _completeFn != null)
            {
               _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,_completeFn);
            }
            _timer = null;
         }
      }
      
      public static function printObject(obj:*, level:int = 0, outputStr:String = "") : *
      {
         var i:int = 0;
         var child:* = undefined;
         var childOutput:String = null;
         if(obj == null)
         {
            return "null";
         }
         var tabs:String = "";
         try
         {
            for(i = 0; i < level; tabs = tabs + "\t",i++)
            {
            }
            for(child in obj)
            {
               var outputStr:String = outputStr + (tabs + "[" + child + "] => " + obj[child]);
               childOutput = printObject(obj[child],level + 1);
               if(childOutput != "")
               {
                  outputStr = outputStr + (" {\n" + childOutput + tabs + "}");
               }
               outputStr = outputStr + "\n";
            }
         }
         catch(err:Error)
         {
            trace("General Fucntion Error :: printObject :: " + err.getStackTrace());
            outputStr = "";
         }
         return outputStr;
      }
      
      public static function objectToString(obj:Object) : String
      {
         var str:String = null;
         var key:* = undefined;
         if(obj == null)
         {
            return "null";
         }
         try
         {
            for(key in obj)
            {
               if(str == null)
               {
                  str = key + "::" + obj[key];
               }
               else
               {
                  str = str + (", " + key + "::" + obj[key]);
               }
            }
         }
         catch(e:Error)
         {
            trace("General Fucntion Error :: objectToString :: " + e.getStackTrace());
            str = "";
         }
         return str;
      }
      
      public static function objectToArray(obj:Object) : Array
      {
         var key:* = undefined;
         if(obj == null)
         {
            return null;
         }
         var arr:Array = [];
         try
         {
            for(key in obj)
            {
               arr.push(obj[key]);
            }
         }
         catch(e:Error)
         {
            trace("General Fucntion Error :: objectToArray :: " + e.getStackTrace());
         }
         return arr;
      }
   }
}
