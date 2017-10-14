package gs.plugins
{
   import gs.TweenLite;
   import gs.utils.tween.TweenInfo;
   
   public class TweenPlugin
   {
      
      public static const VERSION:Number = 1.03;
      
      public static const API:Number = 1;
       
      
      public var propName:String;
      
      public var overwriteProps:Array;
      
      public var round:Boolean;
      
      public var onComplete:Function;
      
      protected var _tweens:Array;
      
      protected var _changeFactor:Number = 0;
      
      public function TweenPlugin()
      {
         _tweens = [];
         super();
      }
      
      public static function activate($plugins:Array) : Boolean
      {
         var i:int = 0;
         var instance:Object = null;
         for(i = $plugins.length - 1; i > -1; i--)
         {
            instance = new $plugins[i]();
            TweenLite.plugins[instance.propName] = $plugins[i];
         }
         return true;
      }
      
      public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         addTween($target,this.propName,$target[this.propName],$value,this.propName);
         return true;
      }
      
      protected function addTween($object:Object, $propName:String, $start:Number, $end:*, $overwriteProp:String = null) : void
      {
         var change:Number = NaN;
         if($end != null)
         {
            change = typeof $end == "number"?Number($end - $start):Number(Number($end));
            if(change != 0)
            {
               _tweens[_tweens.length] = new TweenInfo($object,$propName,$start,change,$overwriteProp || $propName,false);
            }
         }
      }
      
      protected function updateTweens($changeFactor:Number) : void
      {
         var i:int = 0;
         var ti:TweenInfo = null;
         var val:Number = NaN;
         var neg:int = 0;
         if(this.round)
         {
            for(i = _tweens.length - 1; i > -1; i--)
            {
               ti = _tweens[i];
               val = ti.start + ti.change * $changeFactor;
               neg = val < 0?-1:1;
               ti.target[ti.property] = val % 1 * neg > 0.5?int(val) + neg:int(val);
            }
         }
         else
         {
            for(i = _tweens.length - 1; i > -1; i--)
            {
               ti = _tweens[i];
               ti.target[ti.property] = ti.start + ti.change * $changeFactor;
            }
         }
      }
      
      public function set changeFactor($n:Number) : void
      {
         updateTweens($n);
         _changeFactor = $n;
      }
      
      public function get changeFactor() : Number
      {
         return _changeFactor;
      }
      
      public function killProps($lookup:Object) : void
      {
         var i:int = 0;
         for(i = this.overwriteProps.length - 1; i > -1; i--)
         {
            if(this.overwriteProps[i] in $lookup)
            {
               this.overwriteProps.splice(i,1);
            }
         }
         for(i = _tweens.length - 1; i > -1; i--)
         {
            if(_tweens[i].name in $lookup)
            {
               _tweens.splice(i,1);
            }
         }
      }
   }
}
