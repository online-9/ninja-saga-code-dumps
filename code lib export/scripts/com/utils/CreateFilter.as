package com.utils
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public final class CreateFilter
   {
       
      
      public function CreateFilter()
      {
         super();
      }
      
      public static function getSaturationFilter(saturation:Number) : ColorMatrixFilter
      {
         var colorArray:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         colorArray[0] = (1 - saturation) * 0.3086 + saturation;
         colorArray[1] = (1 - saturation) * 0.6094;
         colorArray[2] = (1 - saturation) * 0.082;
         colorArray[5] = (1 - saturation) * 0.3086;
         colorArray[6] = (1 - saturation) * 0.6094 + saturation;
         colorArray[7] = (1 - saturation) * 0.082;
         colorArray[10] = (1 - saturation) * 0.3086;
         colorArray[11] = (1 - saturation) * 0.6094;
         colorArray[12] = (1 - saturation) * 0.082 + saturation;
         colorArray[18] = 1;
         return new ColorMatrixFilter(colorArray);
      }
      
      public static function getBrightnessFilter(brightness:Number) : ColorMatrixFilter
      {
         var colorArray:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0];
         colorArray[0] = brightness;
         colorArray[6] = brightness;
         colorArray[12] = brightness;
         colorArray[18] = 1;
         return new ColorMatrixFilter(colorArray);
      }
      
      public static function getGlowFilter(_params:Object = null) : GlowFilter
      {
         var color:Number = 16711680;
         var strength:Number = 2;
         if(_params != null)
         {
            if(_params.color != null)
            {
               color = _params.color;
            }
            if(_params.strength != null)
            {
               strength = _params.strength;
            }
         }
         return new GlowFilter(color,1,6,6,strength);
      }
   }
}
