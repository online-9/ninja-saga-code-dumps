package com.de.polygonal.math
{
   public class PM_PRNG
   {
       
      
      public var seed:uint;
      
      public function PM_PRNG()
      {
         super();
         seed = Math.random() * 2147483646;
      }
      
      public function nextInt() : uint
      {
         return gen();
      }
      
      public function nextDouble() : Number
      {
         return gen() / 2147483647;
      }
      
      public function nextIntRange(min:Number, max:Number) : uint
      {
         min = min - 0.4999;
         max = max + 0.4999;
         return Math.round(min + (max - min) * nextDouble());
      }
      
      public function nextDoubleRange(min:Number, max:Number) : Number
      {
         return min + (max - min) * nextDouble();
      }
      
      private function gen() : uint
      {
         return seed = seed * 16807 % 2147483647;
      }
   }
}
