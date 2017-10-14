package gs.plugins
{
   import gs.TweenLite;
   import gs.utils.tween.ArrayTweenInfo;
   
   public class EndArrayPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
       
      
      protected var _a:Array;
      
      protected var _info:Array;
      
      public function EndArrayPlugin()
      {
         _info = [];
         super();
         this.propName = "endArray";
         this.overwriteProps = ["endArray"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!($target is Array) || !($value is Array))
         {
            return false;
         }
         init($target as Array,$value);
         return true;
      }
      
      public function init($start:Array, $end:Array) : void
      {
         _a = $start;
         for(var i:int = $end.length - 1; i > -1; i--)
         {
            if($start[i] != $end[i] && $start[i] != null)
            {
               _info[_info.length] = new ArrayTweenInfo(i,_a[i],$end[i] - _a[i]);
            }
         }
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var i:int = 0;
         var ti:ArrayTweenInfo = null;
         var val:Number = NaN;
         var neg:int = 0;
         if(this.round)
         {
            for(i = _info.length - 1; i > -1; i--)
            {
               ti = _info[i];
               val = ti.start + ti.change * $n;
               neg = val < 0?-1:1;
               _a[ti.index] = val % 1 * neg > 0.5?int(val) + neg:int(val);
            }
         }
         else
         {
            for(i = _info.length - 1; i > -1; i--)
            {
               ti = _info[i];
               _a[ti.index] = ti.start + ti.change * $n;
            }
         }
      }
   }
}
