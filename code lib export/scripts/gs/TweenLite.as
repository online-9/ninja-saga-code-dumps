package gs
{
   import flash.utils.Dictionary;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.events.TimerEvent;
   import gs.utils.tween.TweenInfo;
   import gs.plugins.TweenPlugin;
   import gs.plugins.TintPlugin;
   import gs.plugins.RemoveTintPlugin;
   import gs.plugins.FramePlugin;
   import gs.plugins.AutoAlphaPlugin;
   import gs.plugins.VisiblePlugin;
   import gs.plugins.VolumePlugin;
   import gs.plugins.EndArrayPlugin;
   import flash.display.DisplayObject;
   
   public class TweenLite
   {
      
      public static const version:Number = 10.09;
      
      public static var plugins:Object = {};
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      public static var overwriteManager:Object;
      
      public static var currentTime:uint;
      
      public static var masterList:Dictionary = new Dictionary(false);
      
      public static var timingSprite:Sprite = new Sprite();
      
      private static var _tlInitted:Boolean;
      
      private static var _timer:Timer = new Timer(2000);
      
      protected static var _reservedProps:Object = {
         "ease":1,
         "delay":1,
         "overwrite":1,
         "onComplete":1,
         "onCompleteParams":1,
         "runBackwards":1,
         "startAt":1,
         "onUpdate":1,
         "onUpdateParams":1,
         "roundProps":1,
         "onStart":1,
         "onStartParams":1,
         "persist":1,
         "renderOnStart":1,
         "proxiedEase":1,
         "easeParams":1,
         "yoyo":1,
         "loop":1,
         "onCompleteListener":1,
         "onUpdateListener":1,
         "onStartListener":1,
         "orientToBezier":1,
         "timeScale":1
      };
       
      
      public var duration:Number;
      
      public var vars:Object;
      
      public var delay:Number;
      
      public var startTime:Number;
      
      public var initTime:Number;
      
      public var tweens:Array;
      
      public var target:Object;
      
      public var active:Boolean;
      
      public var ease:Function;
      
      public var initted:Boolean;
      
      public var combinedTimeScale:Number;
      
      public var gc:Boolean;
      
      public var started:Boolean;
      
      public var exposedVars:Object;
      
      protected var _hasPlugins:Boolean;
      
      protected var _hasUpdate:Boolean;
      
      public function TweenLite($target:Object, $duration:Number, $vars:Object)
      {
         super();
         if($target == null)
         {
            return;
         }
         if(!_tlInitted)
         {
            TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin]);
            currentTime = getTimer();
            timingSprite.addEventListener(Event.ENTER_FRAME,updateAll,false,0,true);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _timer.addEventListener("timer",killGarbage,false,0,true);
            _timer.start();
            _tlInitted = true;
         }
         this.vars = $vars;
         this.duration = Number($duration) || Number(0.001);
         this.delay = Number($vars.delay) || Number(0);
         this.combinedTimeScale = Number($vars.timeScale) || Number(1);
         this.active = Boolean($duration == 0 && this.delay == 0);
         this.target = $target;
         if(typeof this.vars.ease != "function")
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = easeProxy;
         }
         this.ease = this.vars.ease;
         this.exposedVars = this.vars.isTV == true?this.vars.exposedVars:this.vars;
         this.tweens = [];
         this.initTime = currentTime;
         this.startTime = this.initTime + this.delay * 1000;
         var mode:int = $vars.overwrite == undefined || !overwriteManager.enabled && $vars.overwrite > 1?int(overwriteManager.mode):int(int($vars.overwrite));
         if(!($target in masterList) || mode == 1)
         {
            masterList[$target] = [this];
         }
         else
         {
            masterList[$target].push(this);
         }
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this.active)
         {
            initTweenVals();
            if(this.active)
            {
               render(this.startTime + 1);
            }
            else
            {
               render(this.startTime);
            }
            if(this.exposedVars.visible != null && this.vars.runBackwards == true && this.target is DisplayObject)
            {
               this.target.visible = this.exposedVars.visible;
            }
         }
      }
      
      public static function to($target:Object, $duration:Number, $vars:Object) : TweenLite
      {
         return new TweenLite($target,$duration,$vars);
      }
      
      public static function from($target:Object, $duration:Number, $vars:Object) : TweenLite
      {
         $vars.runBackwards = true;
         return new TweenLite($target,$duration,$vars);
      }
      
      public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null) : TweenLite
      {
         return new TweenLite($onComplete,0,{
            "delay":$delay,
            "onComplete":$onComplete,
            "onCompleteParams":$onCompleteParams,
            "overwrite":0
         });
      }
      
      public static function updateAll($e:Event = null) : void
      {
         var a:Array = null;
         var i:int = 0;
         var tween:TweenLite = null;
         var time:uint = currentTime = getTimer();
         var ml:Dictionary = masterList;
         for each(a in ml)
         {
            for(i = a.length - 1; i > -1; i--)
            {
               tween = a[i];
               if(tween.active)
               {
                  tween.render(time);
               }
               else if(tween.gc)
               {
                  a.splice(i,1);
               }
               else if(time >= tween.startTime)
               {
                  tween.activate();
                  tween.render(time);
               }
            }
         }
      }
      
      public static function removeTween($tween:TweenLite, $clear:Boolean = true) : void
      {
         if($tween != null)
         {
            if($clear)
            {
               $tween.clear();
            }
            $tween.enabled = false;
         }
      }
      
      public static function killTweensOf($target:Object = null, $complete:Boolean = false) : void
      {
         var a:Array = null;
         var i:int = 0;
         var tween:TweenLite = null;
         if($target != null && $target in masterList)
         {
            a = masterList[$target];
            for(i = a.length - 1; i > -1; i--)
            {
               tween = a[i];
               if($complete && !tween.gc)
               {
                  tween.complete(false);
               }
               tween.clear();
            }
            delete masterList[$target];
         }
      }
      
      protected static function killGarbage($e:TimerEvent) : void
      {
         var tgt:* = null;
         var ml:Dictionary = masterList;
         for(tgt in ml)
         {
            if(ml[tgt].length == 0)
            {
               delete ml[tgt];
            }
         }
      }
      
      public static function easeOut($t:Number, $b:Number, $c:Number, $d:Number) : Number
      {
         return -$c * ($t = $t / $d) * ($t - 2) + $b;
      }
      
      public function initTweenVals() : void
      {
         var p:* = null;
         var i:int = 0;
         var plugin:* = undefined;
         var ti:TweenInfo = null;
         if(this.exposedVars.timeScale != undefined && this.target is TweenLite)
         {
            this.tweens[this.tweens.length] = new TweenInfo(this.target,"timeScale",this.target.timeScale,this.exposedVars.timeScale - this.target.timeScale,"timeScale",false);
         }
         for(p in this.exposedVars)
         {
            if(!(p in _reservedProps))
            {
               if(p in plugins)
               {
                  plugin = new plugins[p]();
                  if(plugin.onInitTween(this.target,this.exposedVars[p],this) == false)
                  {
                     this.tweens[this.tweens.length] = new TweenInfo(this.target,p,this.target[p],typeof this.exposedVars[p] == "number"?Number(this.exposedVars[p] - this.target[p]):Number(Number(this.exposedVars[p])),p,false);
                  }
                  else
                  {
                     this.tweens[this.tweens.length] = new TweenInfo(plugin,"changeFactor",0,1,plugin.overwriteProps.length == 1?plugin.overwriteProps[0]:"_MULTIPLE_",true);
                     _hasPlugins = true;
                  }
               }
               else
               {
                  this.tweens[this.tweens.length] = new TweenInfo(this.target,p,this.target[p],typeof this.exposedVars[p] == "number"?Number(this.exposedVars[p] - this.target[p]):Number(Number(this.exposedVars[p])),p,false);
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            for(i = this.tweens.length - 1; i > -1; i--)
            {
               ti = this.tweens[i];
               ti.start = ti.start + ti.change;
               ti.change = -ti.change;
            }
         }
         if(this.vars.onUpdate != null)
         {
            _hasUpdate = true;
         }
         if(TweenLite.overwriteManager.enabled && this.target in masterList)
         {
            overwriteManager.manageOverwrites(this,masterList[this.target]);
         }
         this.initted = true;
      }
      
      public function activate() : void
      {
         this.started = this.active = true;
         if(!this.initted)
         {
            initTweenVals();
         }
         if(this.vars.onStart != null)
         {
            this.vars.onStart.apply(null,this.vars.onStartParams);
         }
         if(this.duration == 0.001)
         {
            this.startTime = this.startTime - 1;
         }
      }
      
      public function render($t:uint) : void
      {
         var factor:Number = NaN;
         var ti:TweenInfo = null;
         var i:int = 0;
         var time:Number = ($t - this.startTime) * 0.001;
         if(time >= this.duration)
         {
            time = this.duration;
            factor = this.ease == this.vars.ease || this.duration == 0.001?Number(1):Number(0);
         }
         else
         {
            factor = this.ease(time,0,1,this.duration);
         }
         for(i = this.tweens.length - 1; i > -1; i--)
         {
            ti = this.tweens[i];
            ti.target[ti.property] = ti.start + factor * ti.change;
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(time == this.duration)
         {
            complete(true);
         }
      }
      
      public function complete($skipRender:Boolean = false) : void
      {
         var i:int = 0;
         if(!$skipRender)
         {
            if(!this.initted)
            {
               initTweenVals();
            }
            this.startTime = currentTime - this.duration * 1000 / this.combinedTimeScale;
            render(currentTime);
            return;
         }
         if(_hasPlugins)
         {
            for(i = this.tweens.length - 1; i > -1; i--)
            {
               if(this.tweens[i].isPlugin && this.tweens[i].target.onComplete != null)
               {
                  this.tweens[i].target.onComplete();
               }
            }
         }
         if(this.vars.persist != true)
         {
            this.enabled = false;
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
      
      public function clear() : void
      {
         this.tweens = [];
         this.vars = this.exposedVars = {"ease":this.vars.ease};
         _hasUpdate = false;
      }
      
      public function killVars($vars:Object) : void
      {
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars($vars,this.exposedVars,this.tweens);
         }
      }
      
      protected function easeProxy($t:Number, $b:Number, $c:Number, $d:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function get enabled() : Boolean
      {
         return !!this.gc?false:true;
      }
      
      public function set enabled($b:Boolean) : void
      {
         var a:Array = null;
         var found:Boolean = false;
         var i:int = 0;
         if($b)
         {
            if(!(this.target in masterList))
            {
               masterList[this.target] = [this];
            }
            else
            {
               a = masterList[this.target];
               for(i = a.length - 1; i > -1; i--)
               {
                  if(a[i] == this)
                  {
                     found = true;
                     break;
                  }
               }
               if(!found)
               {
                  a[a.length] = this;
               }
            }
         }
         this.gc = !!$b?false:true;
         if(this.gc)
         {
            this.active = false;
         }
         else
         {
            this.active = this.started;
         }
      }
   }
}
