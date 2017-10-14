package com.utils
{
   public class TextFilter
   {
      
      public static var dictionaryList:Array;
      
      public static var blockList:Array;
       
      
      public function TextFilter()
      {
         super();
      }
      
      public static function isBlockWords(str:String) : Boolean
      {
         var result:Boolean = false;
         for(var i:int = 0; i < blockList.length; i++)
         {
            if(str.indexOf(blockList[i]) >= 0)
            {
               result = true;
            }
         }
         return result;
      }
      
      public static function filter(str:String) : String
      {
         var re:RegExp = null;
         for(var i:int = 0; i < dictionaryList.length; i++)
         {
            re = dictionaryList[i];
            str = regexReplace(re,str);
         }
         return str;
      }
      
      private static function regexReplace(regex:RegExp, str:String) : String
      {
         var _arr:Array = null;
         var _replacement:* = null;
         var k:uint = 0;
         while(regex.test(str) != false)
         {
            _arr = str.match(regex);
            _replacement = "";
            if(_arr)
            {
               for(k = 0; k < _arr[0].length; k++)
               {
                  _replacement = _replacement + "?";
               }
            }
            else
            {
               _replacement = "?";
            }
            str = str.replace(regex,_replacement);
         }
         return str;
      }
      
      public static function regexCheck(regex:RegExp, str:String) : Boolean
      {
         var _arr:Array = null;
         while(regex.test(str) != false)
         {
            _arr = str.match(regex);
            if(_arr)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isEng(target:String) : Boolean
      {
         var bo:RegExp = /^[a-z A-Z 0-9 \- \_]+$/gi;
         return bo.test(target);
      }
      
      public static function isChi(target:String) : Boolean
      {
         var bo:RegExp = /^[一-龥]+$/gi;
         return bo.test(target);
      }
      
      public static function isNotException(target:String) : Boolean
      {
         if(target.indexOf("`") == -1 && target.indexOf("~") == -1 && target.indexOf("!") == -1 && target.indexOf("@") == -1 && target.indexOf("#") == -1 && target.indexOf("$") == -1 && target.indexOf("%") == -1 && target.indexOf("^") == -1 && target.indexOf("&") == -1 && target.indexOf("*") == -1 && target.indexOf("(") == -1 && target.indexOf(")") == -1 && target.indexOf("+") == -1 && target.indexOf("=") == -1 && target.indexOf("{") == -1 && target.indexOf("[") == -1 && target.indexOf("]") == -1 && target.indexOf("}") == -1 && target.indexOf("\\") == -1 && target.indexOf("|") == -1 && target.indexOf(";") == -1 && target.indexOf(":") == -1 && target.indexOf("\'") == -1 && target.indexOf("\"") == -1 && target.indexOf(".") == -1 && target.indexOf("==") == -1 && target.indexOf("<") == -1 && target.indexOf(">") == -1 && target.indexOf(",") == -1 && target.indexOf("/") == -1 && target.indexOf("-") == -1 && target.indexOf("_") == -1 && target.indexOf("?") == -1)
         {
            return true;
         }
         return false;
      }
   }
}
