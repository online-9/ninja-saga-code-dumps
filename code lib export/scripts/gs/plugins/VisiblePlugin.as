package gs.plugins
{
   import gs.TweenLite;
   
   public class VisiblePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _tween:TweenLite;
      
      protected var _visible:Boolean;
      
      public function VisiblePlugin()
      {
         super();
         this.propName = "visible";
         this.overwriteProps = ["visible"];
         this.onComplete = onCompleteTween;
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _tween = $tween;
         _visible = Boolean($value);
         return true;
      }
      
      public function onCompleteTween() : void
      {
         if(_tween.vars.runBackwards != true && _tween.ease == _tween.vars.ease)
         {
            _target.visible = _visible;
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         if(_target.visible != true)
         {
            _target.visible = true;
         }
      }
   }
}
