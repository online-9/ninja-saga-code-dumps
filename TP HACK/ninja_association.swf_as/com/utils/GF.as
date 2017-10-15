package com.utils 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    
    public final class GF extends Object
    {
        public function GF()
        {
            super();
            return;
        }

        public static function removeAllChild(arg1:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = 0;
            if (arg1 != null)
            {
                loc1 = arg1.numChildren;
                loc2 = 0;
                while (loc2 < loc1) 
                {
                    arg1.removeChildAt(0);
                    loc2 = (loc2 + 1);
                }
            }
            return;
        }

        public static function getClassName(arg1:*):String
        {
            return arg1.toString().substring(8, (arg1.toString().length - 1));
        }

        public static function changeColor(arg1:flash.display.MovieClip, arg2:Number):void
        {
            var _color:Number;
            var _mc:flash.display.MovieClip;
            var ct:flash.geom.ColorTransform;

            var loc1:*;
            ct = null;
            _mc = arg1;
            _color = arg2;
            try
            {
                if (_mc == null)
                {
                    trace("Error :: GF :: changeColor :: _color >> " + _color);
                }
                else 
                {
                    ct = _mc.transform.colorTransform;
                    ct.color = _color;
                    _mc.transform.colorTransform = ct;
                }
            }
            catch (e:Error)
            {
                trace("Error :: GF :: changeColor :: e >> " + undefined);
            }
            return;
        }

        public static function cloneAsBitmap(arg1:flash.display.MovieClip, arg2:Number, arg3:Number, arg4:Number, arg5:Object=null):flash.display.MovieClip
        {
            var loc1:*;
            loc1 = true;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = arg1.width * arg2;
            var loc4:*;
            loc4 = arg1.height * arg2;
            if (arg5 != null)
            {
                if (arg5.width != null)
                {
                    loc3 = arg5.width * arg2;
                }
                if (arg5.height != null)
                {
                    loc4 = arg5.height * arg2;
                }
                if (arg5.transparent != null)
                {
                    loc1 = arg5.transparent;
                }
                if (arg5.background != null)
                {
                    loc2 = arg5.background;
                }
            }
            var loc5:*;
            loc5 = new flash.display.MovieClip();
            var loc6:*;
            loc6 = new flash.display.BitmapData(loc3, loc4, loc1, loc2);
            var loc7:*;
            loc7 = new flash.geom.Matrix(arg2, 0, 0, arg2, arg3, arg4);
            loc6.draw(arg1, loc7, null, "normal", null, true);
            var loc8:*;
            loc8 = new flash.display.Bitmap(loc6);
            loc5.addChild(loc8);
            return loc5;
        }

        public static function duplicateDisplayObject(arg1:flash.display.DisplayObject, arg2:Boolean=false):flash.display.DisplayObject
        {
            var loc3:*;
            loc3 = null;
            var loc1:*;
            loc1 = arg1["constructor"];
            var loc2:*;
            (loc2 = new loc1()).transform = arg1.transform;
            loc2.filters = arg1.filters;
            loc2.cacheAsBitmap = arg1.cacheAsBitmap;
            loc2.opaqueBackground = arg1.opaqueBackground;
            if (arg1.scale9Grid)
            {
                loc3 = arg1.scale9Grid;
                loc2.scale9Grid = loc3;
            }
            if (arg2 && arg1.parent)
            {
                arg1.parent.addChild(loc2);
            }
            loc2.x = 0;
            loc2.y = 0;
            trace("GF :: " + loc2.width + " :: " + loc2.height);
            return loc2;
        }

        public static function moveToFront(arg1:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = null;
            if (arg1 != null)
            {
                loc1 = flash.display.MovieClip(arg1.parent);
                loc1.setChildIndex(arg1, 13);
            }
            return;
        }

        public static function removeParent(arg1:flash.display.MovieClip):void
        {
            if (arg1 != null)
            {
                if (arg1.parent)
                {
                    flash.display.MovieClip(arg1.parent).removeChild(arg1);
                }
            }
            return;
        }

        public static function getAsset(arg1:flash.display.MovieClip, arg2:String):*
        {
            var _cls:String;
            var _swf:flash.display.MovieClip;
            var cls:Class;

            var loc1:*;
            cls = null;
            _swf = arg1;
            _cls = arg2;
            try
            {
                cls = Class(_swf.loaderInfo.applicationDomain.getDefinition(_cls));
                return new cls();
            }
            catch (e:Error)
            {
                trace("ERROR :: getAsset :: " + _cls + " ::" + undefined.message);
            }
            return null;
        }

        public static function startTimer(arg1:Number, arg2:int, arg3:Function):flash.utils.Timer
        {
            var loc1:*;
            (loc1 = new flash.utils.Timer(arg1, arg2)).addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, arg3);
            loc1.start();
            return loc1;
        }

        public static function stopTimer(arg1:flash.utils.Timer, arg2:Function=null):void
        {
            if (arg1)
            {
                arg1.stop();
                arg1.reset();
                if (arg1.hasEventListener(flash.events.TimerEvent.TIMER_COMPLETE) && !(arg2 == null))
                {
                    arg1.removeEventListener(flash.events.TimerEvent.TIMER_COMPLETE, arg2);
                }
                arg1 = null;
            }
            return;
        }

        public static function printObject(arg1:*, arg2:int=0, arg3:String=""):*
        {
            var child:*;
            var childOutput:String;
            var i:int;
            var level:int=0;
            var obj:*;
            var outputStr:String="";
            var tabs:String;

            var loc1:*;
            i = 0;
            child = undefined;
            childOutput = null;
            obj = arg1;
            level = arg2;
            outputStr = arg3;
            if (obj == null)
            {
                return "null";
            }
            tabs = "";
            try
            {
                i = 0;
                while (i < level) 
                {
                    tabs = tabs + "\t";
                    i = (i + 1);
                }
                var loc2:*;
                loc2 = 0;
                var loc3:*;
                loc3 = obj;
                for (child in loc3)
                {
                    outputStr = outputStr + tabs + "[" + child + "] => " + obj[child];
                    childOutput = printObject(obj[child], level + 1);
                    if (childOutput != "")
                    {
                        outputStr = outputStr + " {\n" + childOutput + tabs + "}";
                    }
                    outputStr = outputStr + "\n";
                }
            }
            catch (err:Error)
            {
                trace("General Fucntion Error :: printObject :: " + undefined.getStackTrace());
                outputStr = "";
            }
            return outputStr;
        }

        public static function objectToString(arg1:Object):String
        {
            var key:*;
            var obj:Object;
            var str:String;

            var loc1:*;
            str = null;
            key = undefined;
            obj = arg1;
            if (obj == null)
            {
                return "null";
            }
            try
            {
                var loc2:*;
                loc2 = 0;
                var loc3:*;
                loc3 = obj;
                for (key in loc3)
                {
                    if (str == null)
                    {
                        str = key + "::" + obj[key];
                        continue;
                    }
                    str = str + ", " + key + "::" + obj[key];
                }
            }
            catch (e:Error)
            {
                trace("General Fucntion Error :: objectToString :: " + undefined.getStackTrace());
                str = "";
            }
            return str;
        }

        public static function objectToArray(arg1:Object):Array
        {
            var arr:Array;
            var key:*;
            var obj:Object;

            var loc1:*;
            key = undefined;
            obj = arg1;
            if (obj == null)
            {
                return null;
            }
            arr = [];
            try
            {
                var loc2:*;
                loc2 = 0;
                var loc3:*;
                loc3 = obj;
                for (key in loc3)
                {
                    arr.push(obj[key]);
                }
            }
            catch (e:Error)
            {
                trace("General Fucntion Error :: objectToArray :: " + undefined.getStackTrace());
            }
            return arr;
        }
    }
}
