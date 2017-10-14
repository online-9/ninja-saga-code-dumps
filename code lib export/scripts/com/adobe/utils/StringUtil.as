package com.adobe.utils
{
   public class StringUtil
   {
       
      
      public function StringUtil()
      {
         super();
      }
      
      public static function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean) : Boolean
      {
         if(caseSensitive)
         {
            return s1 == s2;
         }
         return s1.toUpperCase() == s2.toUpperCase();
      }
      
      public static function trim(input:String) : String
      {
         return StringUtil.ltrim(StringUtil.rtrim(input));
      }
      
      public static function ltrim(input:String) : String
      {
         var size:Number = input.length;
         for(var i:Number = 0; i < size; i++)
         {
            if(input.charCodeAt(i) > 32)
            {
               return input.substring(i);
            }
         }
         return "";
      }
      
      public static function rtrim(input:String) : String
      {
         var size:Number = input.length;
         for(var i:Number = size; i > 0; i--)
         {
            if(input.charCodeAt(i - 1) > 32)
            {
               return input.substring(0,i);
            }
         }
         return "";
      }
      
      public static function beginsWith(input:String, prefix:String) : Boolean
      {
         return prefix == input.substring(0,prefix.length);
      }
      
      public static function endsWith(input:String, suffix:String) : Boolean
      {
         return suffix == input.substring(input.length - suffix.length);
      }
      
      public static function remove(input:String, remove:String) : String
      {
         return StringUtil.replace(input,remove,"");
      }
      
      public static function replace(input:String, replace:String, replaceWith:String) : String
      {
         var j:Number = NaN;
         var sb:String = new String();
         var found:Boolean = false;
         var sLen:Number = input.length;
         var rLen:Number = replace.length;
         for(var i:Number = 0; i < sLen; i++)
         {
            if(input.charAt(i) == replace.charAt(0))
            {
               found = true;
               for(j = 0; j < rLen; j++)
               {
                  if(input.charAt(i + j) != replace.charAt(j))
                  {
                     found = false;
                     break;
                  }
               }
               if(found)
               {
                  sb = sb + replaceWith;
                  i = i + (rLen - 1);
                  continue;
               }
            }
            sb = sb + input.charAt(i);
         }
         return sb;
      }
   }
}
