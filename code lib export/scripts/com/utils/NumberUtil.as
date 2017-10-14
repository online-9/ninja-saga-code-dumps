package com.utils
{
   import com.de.polygonal.math.PM_PRNG;
   
   public final class NumberUtil
   {
       
      
      public function NumberUtil()
      {
         super();
      }
      
      public static function randomNumber(min:Number, max:Number) : Number
      {
         return Math.floor((min + getRandom() * (max - min)) * 10000) / 10000;
      }
      
      public static function getRandom() : Number
      {
         var P:* = new PM_PRNG();
         return P.nextDoubleRange(0,1);
      }
      
      public static function randomInt(min:int, max:int) : int
      {
         var P:* = new PM_PRNG();
         var result:int = P.nextIntRange(min,max);
         if(result < min)
         {
            result = min;
         }
         if(result > max)
         {
            result = max;
         }
         return result;
      }
   }
}
