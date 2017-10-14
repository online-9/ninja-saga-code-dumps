package gs
{
   import gs.utils.tween.TweenInfo;
   
   public class OverwriteManager
   {
      
      public static const version:Number = 3.12;
      
      public static const NONE:int = 0;
      
      public static const ALL:int = 1;
      
      public static const AUTO:int = 2;
      
      public static const CONCURRENT:int = 3;
      
      public static var mode:int;
      
      public static var enabled:Boolean;
       
      
      public function OverwriteManager()
      {
         super();
      }
      
      public static function init($mode:int = 2) : int
      {
         if(TweenLite.version < 10.09)
         {
            trace("TweenLite warning: Your TweenLite class needs to be updated to work with OverwriteManager (or you may need to clear your ASO files). Please download and install the latest version from http://www.tweenlite.com.");
         }
         TweenLite.overwriteManager = OverwriteManager;
         mode = $mode;
         enabled = true;
         return mode;
      }
      
      public static function manageOverwrites($tween:TweenLite, $targetTweens:Array) : void
      {
         var i:int = 0;
         var tween:TweenLite = null;
         var tweens:Array = null;
         var v:Object = null;
         var j:int = 0;
         var ti:TweenInfo = null;
         var overwriteProps:Array = null;
         var vars:Object = $tween.vars;
         var m:int = vars.overwrite == undefined?int(mode):int(int(vars.overwrite));
         if(m < 2 || $targetTweens == null)
         {
            return;
         }
         var startTime:Number = $tween.startTime;
         var a:Array = [];
         var index:int = -1;
         for(i = $targetTweens.length - 1; i > -1; i--)
         {
            tween = $targetTweens[i];
            if(tween == $tween)
            {
               index = i;
            }
            else if(i < index && tween.startTime <= startTime && tween.startTime + tween.duration * 1000 / tween.combinedTimeScale > startTime)
            {
               a[a.length] = tween;
            }
         }
         if(a.length == 0 || $tween.tweens.length == 0)
         {
            return;
         }
         if(m == AUTO)
         {
            tweens = $tween.tweens;
            v = {};
            for(i = tweens.length - 1; i > -1; i--)
            {
               ti = tweens[i];
               if(ti.isPlugin)
               {
                  if(ti.name == "_MULTIPLE_")
                  {
                     overwriteProps = ti.target.overwriteProps;
                     for(j = overwriteProps.length - 1; j > -1; j--)
                     {
                        v[overwriteProps[j]] = true;
                     }
                  }
                  else
                  {
                     v[ti.name] = true;
                  }
                  v[ti.target.propName] = true;
               }
               else
               {
                  v[ti.name] = true;
               }
            }
            for(i = a.length - 1; i > -1; i--)
            {
               killVars(v,a[i].exposedVars,a[i].tweens);
            }
         }
         else
         {
            for(i = a.length - 1; i > -1; i--)
            {
               a[i].enabled = false;
            }
         }
      }
      
      public static function killVars($killVars:Object, $vars:Object, $tweens:Array) : void
      {
         var i:int = 0;
         var p:* = null;
         var ti:TweenInfo = null;
         for(i = $tweens.length - 1; i > -1; i--)
         {
            ti = $tweens[i];
            if(ti.name in $killVars)
            {
               $tweens.splice(i,1);
            }
            else if(ti.isPlugin && ti.name == "_MULTIPLE_")
            {
               ti.target.killProps($killVars);
               if(ti.target.overwriteProps.length == 0)
               {
                  $tweens.splice(i,1);
               }
            }
         }
         for(p in $killVars)
         {
            delete $vars[p];
         }
      }
   }
}
