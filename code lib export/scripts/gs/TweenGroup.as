package gs
{
   import flash.utils.Proxy;
   import flash.events.IEventDispatcher;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.flash_proxy;
   import flash.utils.getDefinitionByName;
   
   public dynamic class TweenGroup extends Proxy implements IEventDispatcher
   {
      
      public static const version:Number = 1.02;
      
      public static const ALIGN_INIT:String = "init";
      
      public static const ALIGN_START:String = "start";
      
      public static const ALIGN_END:String = "end";
      
      public static const ALIGN_SEQUENCE:String = "sequence";
      
      public static const ALIGN_NONE:String = "none";
      
      protected static var _overwriteMode:int = !!OverwriteManager.enabled?int(OverwriteManager.mode):int(OverwriteManager.init());
      
      protected static var _TweenMax:Class;
      
      protected static var _classInitted:Boolean;
      
      protected static var _unexpired:Array = [];
      
      protected static var _prevTime:uint = 0;
       
      
      public var onComplete:Function;
      
      public var onCompleteParams:Array;
      
      public var loop:Number;
      
      public var yoyo:Number;
      
      public var endTime:Number;
      
      public var expired:Boolean;
      
      protected var _tweens:Array;
      
      protected var _pauseTime:Number;
      
      protected var _startTime:Number;
      
      protected var _initTime:Number;
      
      protected var _reversed:Boolean;
      
      protected var _align:String;
      
      protected var _stagger:Number;
      
      protected var _repeatCount:Number;
      
      protected var _dispatcher:EventDispatcher;
      
      public function TweenGroup($tweens:Array = null, $DefaultTweenClass:Class = null, $align:String = "none", $stagger:Number = 0)
      {
         super();
         if(!_classInitted)
         {
            if(TweenLite.version < 9.291)
            {
               trace("TweenGroup error! Please update your TweenLite class or try deleting your ASO files. TweenGroup requires a more recent version. Download updates at http://www.TweenLite.com.");
            }
            try
            {
               _TweenMax = getDefinitionByName("gs.TweenMax") as Class;
            }
            catch($e:Error)
            {
               _TweenMax = Array;
            }
            TweenLite.timingSprite.addEventListener(Event.ENTER_FRAME,checkExpiration,false,-1,true);
            _classInitted = true;
         }
         this.expired = true;
         _repeatCount = 0;
         _align = $align;
         _stagger = $stagger;
         _dispatcher = new EventDispatcher(this);
         if($tweens != null)
         {
            _tweens = parse($tweens,$DefaultTweenClass);
            updateTimeSpan();
            realign();
         }
         else
         {
            _tweens = [];
            _initTime = _startTime = this.endTime = 0;
         }
      }
      
      public static function parse($tweens:Array, $DefaultTweenClass:Class = null) : Array
      {
         var i:int = 0;
         var target:Object = null;
         var duration:Number = NaN;
         if($DefaultTweenClass == null)
         {
            $DefaultTweenClass = TweenLite;
         }
         var a:Array = [];
         for(i = 0; i < $tweens.length; i++)
         {
            if($tweens[i] is TweenLite)
            {
               a[a.length] = $tweens[i];
            }
            else
            {
               target = $tweens[i].target;
               duration = $tweens[i].time;
               delete $tweens[i].target;
               delete $tweens[i].time;
               a[a.length] = new $DefaultTweenClass(target,duration,$tweens[i]);
            }
         }
         return a;
      }
      
      public static function allTo($targets:Array, $duration:Number, $vars:Object, $DefaultTweenClass:Class = null) : TweenGroup
      {
         var i:int = 0;
         var vars:Object = null;
         var p:* = null;
         if($DefaultTweenClass == null)
         {
            $DefaultTweenClass = TweenLite;
         }
         var group:TweenGroup = new TweenGroup(null,$DefaultTweenClass,ALIGN_INIT,Number($vars.stagger) || Number(0));
         group.onComplete = $vars.onCompleteAll;
         group.onCompleteParams = $vars.onCompleteAllParams;
         delete $vars.stagger;
         delete $vars.onCompleteAll;
         delete $vars.onCompleteAllParams;
         for(i = 0; i < $targets.length; i++)
         {
            vars = {};
            for(p in $vars)
            {
               vars[p] = $vars[p];
            }
            group[group.length] = new $DefaultTweenClass($targets[i],$duration,vars);
         }
         if(group.stagger < 0)
         {
            group.progressWithDelay = 0;
         }
         return group;
      }
      
      public static function allFrom($targets:Array, $duration:Number, $vars:Object, $DefaultTweenClass:Class = null) : TweenGroup
      {
         $vars.runBackwards = true;
         return allTo($targets,$duration,$vars,$DefaultTweenClass);
      }
      
      protected static function checkExpiration($e:Event) : void
      {
         var tg:TweenGroup = null;
         var i:int = 0;
         var time:uint = TweenLite.currentTime;
         var a:Array = _unexpired;
         for(i = a.length - 1; i > -1; i--)
         {
            tg = a[i];
            if(tg.endTime > _prevTime && tg.endTime <= time && !tg.paused)
            {
               a.splice(i,1);
               tg.expired = true;
               tg.handleCompletion();
            }
         }
         _prevTime = time;
      }
      
      override flash_proxy function callProperty($name:*, ... $args) : *
      {
         var returnValue:* = _tweens[$name].apply(null,$args);
         realign();
         if(!isNaN(_pauseTime))
         {
            pause();
         }
         return returnValue;
      }
      
      override flash_proxy function getProperty($prop:*) : *
      {
         return _tweens[$prop];
      }
      
      override flash_proxy function setProperty($prop:*, $value:*) : void
      {
         onSetProperty($prop,$value);
      }
      
      protected function onSetProperty($prop:*, $value:*) : void
      {
         if(!isNaN($prop) && !($value is TweenLite))
         {
            trace("TweenGroup error: an attempt was made to add a non-TweenLite element.");
         }
         else
         {
            _tweens[$prop] = $value;
            realign();
            if(!isNaN(_pauseTime) && $value is TweenLite)
            {
               pauseTween($value as TweenLite);
            }
         }
      }
      
      override flash_proxy function hasProperty($name:*) : Boolean
      {
         var props:String = " progress progressWithDelay duration durationWithDelay paused reversed timeScale align stagger tweens ";
         if(_tweens.hasOwnProperty($name))
         {
            return true;
         }
         if(props.indexOf(" " + $name + " ") != -1)
         {
            return true;
         }
         return false;
      }
      
      public function addEventListener($type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false) : void
      {
         _dispatcher.addEventListener($type,$listener,$useCapture,$priority,$useWeakReference);
      }
      
      public function removeEventListener($type:String, $listener:Function, $useCapture:Boolean = false) : void
      {
         _dispatcher.removeEventListener($type,$listener,$useCapture);
      }
      
      public function hasEventListener($type:String) : Boolean
      {
         return _dispatcher.hasEventListener($type);
      }
      
      public function willTrigger($type:String) : Boolean
      {
         return _dispatcher.willTrigger($type);
      }
      
      public function dispatchEvent($e:Event) : Boolean
      {
         return _dispatcher.dispatchEvent($e);
      }
      
      public function pause() : void
      {
         if(isNaN(_pauseTime))
         {
            _pauseTime = TweenLite.currentTime;
         }
         for(var i:int = _tweens.length - 1; i > -1; i--)
         {
            if(_tweens[i].startTime != 999999999999999)
            {
               pauseTween(_tweens[i]);
            }
         }
      }
      
      public function resume() : void
      {
         var i:int = 0;
         var offset:Number = NaN;
         var a:Array = [];
         var time:Number = TweenLite.currentTime;
         for(i = _tweens.length - 1; i > -1; i--)
         {
            if(_tweens[i].startTime == 999999999999999)
            {
               resumeTween(_tweens[i]);
               a[a.length] = _tweens[i];
            }
            if(_tweens[i].startTime >= time && !_tweens[i].enabled)
            {
               _tweens[i].enabled = true;
               _tweens[i].active = false;
            }
         }
         if(!isNaN(_pauseTime))
         {
            offset = (TweenLite.currentTime - _pauseTime) / 1000;
            _pauseTime = NaN;
            offsetTime(a,offset);
         }
      }
      
      public function restart($includeDelay:Boolean = false) : void
      {
         setProgress(0,$includeDelay);
         _repeatCount = 0;
         resume();
      }
      
      public function reverse($forcePlay:Boolean = true) : void
      {
         var i:int = 0;
         var tween:TweenLite = null;
         var proxy:ReverseProxy = null;
         var startTime:Number = NaN;
         var initTime:Number = NaN;
         var prog:Number = NaN;
         var tScale:Number = NaN;
         _reversed = !_reversed;
         var timeOffset:Number = 0;
         var isFinished:Boolean = false;
         var time:Number = !isNaN(_pauseTime)?Number(_pauseTime):Number(TweenLite.currentTime);
         if(this.endTime <= time)
         {
            timeOffset = int(this.endTime - time) + 1;
            isFinished = true;
         }
         for(i = _tweens.length - 1; i > -1; i--)
         {
            tween = _tweens[i];
            if(tween is _TweenMax)
            {
               startTime = tween.startTime;
               initTime = tween.initTime;
               (tween as Object).reverse(false,false);
               tween.startTime = startTime;
               tween.initTime = initTime;
            }
            else if(tween.ease != tween.vars.ease)
            {
               tween.ease = tween.vars.ease;
            }
            else
            {
               proxy = new ReverseProxy(tween);
               tween.ease = proxy.reverseEase;
            }
            tScale = tween.combinedTimeScale;
            prog = ((time - tween.initTime) / 1000 - tween.delay / tScale) / tween.duration * tScale;
            startTime = int(time - (1 - prog) * tween.duration * 1000 / tScale + timeOffset);
            tween.initTime = int(startTime - tween.delay * (1000 / tScale));
            if(tween.startTime != 999999999999999)
            {
               tween.startTime = startTime;
            }
            if(tween.startTime > time)
            {
               tween.enabled = true;
               tween.active = false;
            }
         }
         updateTimeSpan();
         if($forcePlay)
         {
            if(isFinished)
            {
               setProgress(0,true);
            }
            resume();
         }
      }
      
      public function getActive() : Array
      {
         var i:int = 0;
         var time:Number = NaN;
         var a:Array = [];
         if(isNaN(_pauseTime))
         {
            time = TweenLite.currentTime;
            for(i = _tweens.length - 1; i > -1; i--)
            {
               if(_tweens[i].startTime <= time && getEndTime(_tweens[i]) >= time)
               {
                  a[a.length] = _tweens[i];
               }
            }
         }
         return a;
      }
      
      public function mergeGroup($group:TweenGroup, $startIndex:Number = NaN) : void
      {
         var i:int = 0;
         if(isNaN($startIndex) || $startIndex > _tweens.length)
         {
            $startIndex = _tweens.length;
         }
         var tweens:Array = $group.tweens;
         var l:uint = tweens.length;
         for(i = 0; i < l; i++)
         {
            _tweens.splice($startIndex + i,0,tweens[i]);
         }
         realign();
      }
      
      public function clear($killTweens:Boolean = true) : void
      {
         for(var i:int = _tweens.length - 1; i > -1; i--)
         {
            if($killTweens)
            {
               TweenLite.removeTween(_tweens[i],true);
            }
            _tweens[i] = null;
            _tweens.splice(i,1);
         }
         if(!this.expired)
         {
            for(i = _unexpired.length - 1; i > -1; i--)
            {
               if(_unexpired[i] == this)
               {
                  _unexpired.splice(i,1);
                  break;
               }
            }
            this.expired = true;
         }
      }
      
      public function realign() : void
      {
         var l:uint = 0;
         var i:int = 0;
         var offset:Number = NaN;
         var prog:Number = NaN;
         var rev:Boolean = false;
         if(_align != ALIGN_NONE && _tweens.length > 1)
         {
            l = _tweens.length;
            offset = _stagger * 1000;
            rev = _reversed;
            if(rev)
            {
               prog = this.progressWithDelay;
               reverse();
               this.progressWithDelay = 0;
            }
            if(_align == ALIGN_SEQUENCE)
            {
               setTweenInitTime(_tweens[0],_initTime);
               for(i = 1; i < l; i++)
               {
                  setTweenInitTime(_tweens[i],getEndTime(_tweens[i - 1]) + offset);
               }
            }
            else if(_align == ALIGN_INIT)
            {
               for(i = 0; i < l; i++)
               {
                  setTweenInitTime(_tweens[i],_initTime + offset * i);
               }
            }
            else if(_align == ALIGN_START)
            {
               for(i = 0; i < l; i++)
               {
                  setTweenStartTime(_tweens[i],_startTime + offset * i);
               }
            }
            else
            {
               for(i = 0; i < l; i++)
               {
                  setTweenInitTime(_tweens[i],this.endTime - (_tweens[i].delay + _tweens[i].duration) * 1000 / _tweens[i].combinedTimeScale - offset * i);
               }
            }
            if(rev)
            {
               reverse();
               this.progressWithDelay = prog;
            }
         }
         updateTimeSpan();
      }
      
      public function updateTimeSpan() : void
      {
         var i:int = 0;
         var start:Number = NaN;
         var init:Number = NaN;
         var end:Number = NaN;
         var tween:TweenLite = null;
         if(_tweens.length == 0)
         {
            this.endTime = _startTime = _initTime = 0;
         }
         else
         {
            tween = _tweens[0];
            _initTime = tween.initTime;
            _startTime = _initTime + tween.delay * (1000 / tween.combinedTimeScale);
            this.endTime = _startTime + tween.duration * (1000 / tween.combinedTimeScale);
            for(i = _tweens.length - 1; i > 0; i--)
            {
               tween = _tweens[i];
               init = tween.initTime;
               start = init + tween.delay * (1000 / tween.combinedTimeScale);
               end = start + tween.duration * (1000 / tween.combinedTimeScale);
               if(init < _initTime)
               {
                  _initTime = init;
               }
               if(start < _startTime)
               {
                  _startTime = start;
               }
               if(end > this.endTime)
               {
                  this.endTime = end;
               }
            }
            if(this.expired && this.endTime > TweenLite.currentTime)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      public function toString() : String
      {
         return "TweenGroup( " + _tweens.toString() + " )";
      }
      
      protected function offsetTime($tweens:Array, $offset:Number) : void
      {
         var ms:Number = NaN;
         var time:Number = NaN;
         var tweens:Array = null;
         var isPaused:Boolean = false;
         var tween:TweenLite = null;
         var render:Boolean = false;
         var startTime:Number = NaN;
         var end:Number = NaN;
         var i:int = 0;
         var toRender:Array = null;
         if($tweens.length != 0)
         {
            ms = $offset * 1000;
            time = !!isNaN(_pauseTime)?Number(TweenLite.currentTime):Number(_pauseTime);
            tweens = getRenderOrder($tweens,time);
            toRender = [];
            for(i = tweens.length - 1; i > -1; i--)
            {
               tween = tweens[i];
               tween.initTime = tween.initTime + ms;
               isPaused = Boolean(tween.startTime == 999999999999999);
               startTime = tween.initTime + tween.delay * (1000 / tween.combinedTimeScale);
               end = getEndTime(tween);
               render = (startTime <= time || startTime - ms <= time) && (end >= time || end - ms >= time);
               if(isNaN(_pauseTime) && end >= time)
               {
                  tween.enabled = true;
               }
               if(!isPaused)
               {
                  tween.startTime = startTime;
               }
               if(startTime >= time)
               {
                  if(!tween.initted)
                  {
                     render = false;
                  }
                  tween.active = false;
               }
               if(render)
               {
                  toRender[toRender.length] = tween;
               }
            }
            for(i = toRender.length - 1; i > -1; i--)
            {
               renderTween(toRender[i],time);
            }
            this.endTime = this.endTime + ms;
            _startTime = _startTime + ms;
            _initTime = _initTime + ms;
            if(this.expired && this.endTime > time)
            {
               this.expired = false;
               _unexpired[_unexpired.length] = this;
            }
         }
      }
      
      protected function renderTween($tween:TweenLite, $time:Number) : void
      {
         var renderTime:Number = NaN;
         var isPaused:Boolean = false;
         var active:Boolean = false;
         var originalStart:Number = NaN;
         var end:Number = getEndTime($tween);
         if($tween.startTime == 999999999999999)
         {
            $tween.startTime = $tween.initTime + $tween.delay * (1000 / $tween.combinedTimeScale);
            isPaused = true;
         }
         if(!$tween.initted)
         {
            active = $tween.active;
            $tween.active = false;
            if(isPaused)
            {
               $tween.initTweenVals();
               if($tween.vars.onStart != null)
               {
                  $tween.vars.onStart.apply(null,$tween.vars.onStartParams);
               }
            }
            else
            {
               $tween.activate();
            }
            $tween.active = active;
         }
         if($tween.startTime > $time)
         {
            renderTime = $tween.startTime;
         }
         else if(end < $time)
         {
            renderTime = end;
         }
         else
         {
            renderTime = $time;
         }
         if(renderTime < 0)
         {
            originalStart = $tween.startTime;
            $tween.startTime = $tween.startTime - renderTime;
            $tween.render(0);
            $tween.startTime = originalStart;
         }
         else
         {
            $tween.render(renderTime);
         }
         if(isPaused)
         {
            $tween.startTime = 999999999999999;
         }
      }
      
      protected function getRenderOrder($tweens:Array, $time:Number) : Array
      {
         var i:int = 0;
         var startTime:Number = NaN;
         var postTweens:Array = [];
         var preTweens:Array = [];
         var a:Array = [];
         for(i = $tweens.length - 1; i > -1; i--)
         {
            startTime = getStartTime($tweens[i]);
            if(startTime >= $time)
            {
               postTweens[postTweens.length] = {
                  "start":startTime,
                  "tween":$tweens[i]
               };
            }
            else
            {
               preTweens[preTweens.length] = {
                  "end":getEndTime($tweens[i]),
                  "tween":$tweens[i]
               };
            }
         }
         postTweens.sortOn("start",Array.NUMERIC);
         preTweens.sortOn("end",Array.NUMERIC);
         for(i = postTweens.length - 1; i > -1; i--)
         {
            a[i] = postTweens[i].tween;
         }
         for(i = preTweens.length - 1; i > -1; i--)
         {
            a[a.length] = preTweens[i].tween;
         }
         return a;
      }
      
      protected function pauseTween($tween:TweenLite) : void
      {
         if($tween is _TweenMax)
         {
            ($tween as Object).pauseTime = _pauseTime;
         }
         $tween.startTime = 999999999999999;
         $tween.enabled = false;
      }
      
      protected function resumeTween($tween:TweenLite) : void
      {
         if($tween is _TweenMax)
         {
            ($tween as Object).pauseTime = NaN;
         }
         $tween.startTime = $tween.initTime + $tween.delay * (1000 / $tween.combinedTimeScale);
      }
      
      protected function getEndTime($tween:TweenLite) : Number
      {
         return $tween.initTime + ($tween.delay + $tween.duration) * (1000 / $tween.combinedTimeScale);
      }
      
      protected function getStartTime($tween:TweenLite) : Number
      {
         return $tween.initTime + $tween.delay * 1000 / $tween.combinedTimeScale;
      }
      
      protected function setTweenInitTime($tween:TweenLite, $initTime:Number) : void
      {
         var offset:Number = $initTime - $tween.initTime;
         $tween.initTime = $initTime;
         if($tween.startTime != 999999999999999)
         {
            $tween.startTime = $tween.startTime + offset;
         }
      }
      
      protected function setTweenStartTime($tween:TweenLite, $startTime:Number) : void
      {
         var offset:Number = $startTime - getStartTime($tween);
         $tween.initTime = $tween.initTime + offset;
         if($tween.startTime != 999999999999999)
         {
            $tween.startTime = $startTime;
         }
      }
      
      protected function getProgress($includeDelay:Boolean = false) : Number
      {
         var time:Number = NaN;
         var min:Number = NaN;
         var p:Number = NaN;
         if(_tweens.length == 0)
         {
            return 0;
         }
         time = !!isNaN(_pauseTime)?Number(TweenLite.currentTime):Number(_pauseTime);
         min = !!$includeDelay?Number(_initTime):Number(_startTime);
         p = (time - min) / (this.endTime - min);
         if(p < 0)
         {
            return 0;
         }
         if(p > 1)
         {
            return 1;
         }
         return p;
      }
      
      protected function setProgress($progress:Number, $includeDelay:Boolean = false) : void
      {
         var time:Number = NaN;
         var min:Number = NaN;
         if(_tweens.length != 0)
         {
            time = !!isNaN(_pauseTime)?Number(TweenLite.currentTime):Number(_pauseTime);
            min = !!$includeDelay?Number(_initTime):Number(_startTime);
            offsetTime(_tweens,(time - (min + (this.endTime - min) * $progress)) / 1000);
         }
      }
      
      public function handleCompletion() : void
      {
         if(!isNaN(this.yoyo) && (_repeatCount < this.yoyo || this.yoyo == 0))
         {
            _repeatCount++;
            reverse(true);
         }
         else if(!isNaN(this.loop) && (_repeatCount < this.loop || this.loop == 0))
         {
            _repeatCount++;
            setProgress(0,true);
         }
         if(this.onComplete != null)
         {
            this.onComplete.apply(null,this.onCompleteParams);
         }
         _dispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get length() : uint
      {
         return _tweens.length;
      }
      
      public function get progress() : Number
      {
         return getProgress(false);
      }
      
      public function set progress($n:Number) : void
      {
         setProgress($n,false);
      }
      
      public function get progressWithDelay() : Number
      {
         return getProgress(true);
      }
      
      public function set progressWithDelay($n:Number) : void
      {
         setProgress($n,true);
      }
      
      public function get duration() : Number
      {
         if(_tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - _startTime) / 1000;
      }
      
      public function get durationWithDelay() : Number
      {
         if(_tweens.length == 0)
         {
            return 0;
         }
         return (this.endTime - _initTime) / 1000;
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(_pauseTime);
      }
      
      public function set paused($b:Boolean) : void
      {
         if($b)
         {
            pause();
         }
         else
         {
            resume();
         }
      }
      
      public function get reversed() : Boolean
      {
         return _reversed;
      }
      
      public function set reversed($b:Boolean) : void
      {
         if(_reversed != $b)
         {
            reverse(true);
         }
      }
      
      public function get timeScale() : Number
      {
         for(var i:uint = 0; i < _tweens.length; i++)
         {
            if(_tweens[i] is _TweenMax)
            {
               return _tweens[i].timeScale;
            }
         }
         return 1;
      }
      
      public function set timeScale($n:Number) : void
      {
         for(var i:int = _tweens.length - 1; i > -1; i--)
         {
            if(_tweens[i] is _TweenMax)
            {
               _tweens[i].timeScale = $n;
            }
         }
         updateTimeSpan();
      }
      
      public function get align() : String
      {
         return _align;
      }
      
      public function set align($s:String) : void
      {
         _align = $s;
         realign();
      }
      
      public function get stagger() : Number
      {
         return _stagger;
      }
      
      public function set stagger($n:Number) : void
      {
         _stagger = $n;
         realign();
      }
      
      public function get tweens() : Array
      {
         return _tweens.slice();
      }
   }
}

import gs.TweenLite;

class ReverseProxy
{
    
   
   private var _tween:TweenLite;
   
   function ReverseProxy($tween:TweenLite)
   {
      super();
      _tween = $tween;
   }
   
   public function reverseEase($t:Number, $b:Number, $c:Number, $d:Number) : Number
   {
      return _tween.vars.ease($d - $t,$b,$c,$d);
   }
}
