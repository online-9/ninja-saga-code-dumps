package com.adobe.utils
{
   public class IntUtil
   {
      
      private static var hexChars:String = "0123456789abcdef";
       
      
      public function IntUtil()
      {
         super();
      }
      
      public static function rol(x:int, n:int) : int
      {
         return x << n | x >>> 32 - n;
      }
      
      public static function ror(x:int, n:int) : uint
      {
         var nn:int = 32 - n;
         return x << nn | x >>> 32 - nn;
      }
      
      public static function toHex(n:int, bigEndian:Boolean = false) : String
      {
         var i:int = 0;
         var x:int = 0;
         var s:String = "";
         if(bigEndian)
         {
            for(i = 0; i < 4; i++)
            {
               s = s + (hexChars.charAt(n >> (3 - i) * 8 + 4 & 15) + hexChars.charAt(n >> (3 - i) * 8 & 15));
            }
         }
         else
         {
            for(x = 0; x < 4; x++)
            {
               s = s + (hexChars.charAt(n >> x * 8 + 4 & 15) + hexChars.charAt(n >> x * 8 & 15));
            }
         }
         return s;
      }
   }
}
