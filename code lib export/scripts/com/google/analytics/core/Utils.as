package com.google.analytics.core
{
   public class Utils
   {
       
      
      public function Utils()
      {
         super();
      }
      
      public static function trim(raw:String, everything:Boolean = false) : String
      {
         var i:int = 0;
         var iLeft:int = 0;
         var iRight:int = 0;
         if(raw == "")
         {
            return "";
         }
         var whitespaces:Array = [" ","\n","\r","\t"];
         var str:String = raw;
         if(everything)
         {
            i = 0;
            while(i < whitespaces.length && str.indexOf(whitespaces[i]) > -1)
            {
               str = str.split(whitespaces[i]).join("");
               i++;
            }
         }
         else
         {
            iLeft = 0;
            while(iLeft < str.length && whitespaces.indexOf(str.charAt(iLeft)) > -1)
            {
               iLeft++;
            }
            str = str.substr(iLeft);
            iRight = str.length - 1;
            while(iRight >= 0 && whitespaces.indexOf(str.charAt(iRight)) > -1)
            {
               iRight--;
            }
            str = str.substring(0,iRight + 1);
         }
         return str;
      }
      
      public static function generateHash(input:String) : int
      {
         var pos:int = 0;
         var current:int = 0;
         var hash:* = 1;
         var leftMost7:* = 0;
         if(input != null && input != "")
         {
            hash = 0;
            for(pos = input.length - 1; pos >= 0; pos--)
            {
               current = input.charCodeAt(pos);
               hash = int((hash << 6 & 268435455) + current + (current << 14));
               leftMost7 = hash & 266338304;
               if(leftMost7 != 0)
               {
                  hash = hash ^ leftMost7 >> 21;
               }
            }
         }
         return hash;
      }
      
      public static function generate32bitRandom() : int
      {
         return Math.round(Math.random() * 2147483647);
      }
      
      public static function validateAccount(account:String) : Boolean
      {
         var rel:RegExp = /^UA-[0-9]*-[0-9]*$/;
         return rel.test(account);
      }
   }
}
