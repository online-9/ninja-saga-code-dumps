package gs.plugins
{
   import gs.TweenLite;
   
   public class AutoAlphaPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _tweenVisible:Boolean;
      
      protected var _visible:Boolean;
      
      protected var _tween:TweenLite;
      
      protected var _target:Object;
      
      public function AutoAlphaPlugin()
      {
         super();
         this.propName = "autoAlpha";
         this.overwriteProps = ["alpha","visible"];
         this.onComplete = onCompleteTween;
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _tween = $tween;
         _visible = Boolean($value != 0);
         _tweenVisible = true;
         addTween($target,"alpha",$target.alpha,$value,"alpha");
         return true;
      }
      
      override public function killProps($lookup:Object) : void
      {
         super.killProps($lookup);
         _tweenVisible = !Boolean("visible" in $lookup);
      }
      
      public function onCompleteTween() : void
      {
         if(_tweenVisible && _tween.vars.runBackwards != true && _tween.ease == _tween.vars.ease)
         {
            _target.visible = _visible;
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         updateTweens($n);
         if(_target.visible != true && _tweenVisible)
         {
            _target.visible = true;
         }
      }
   }
}
