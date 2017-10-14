package com.utils
{
   public class Sha1Encrypt
   {
      
      private static var charInputBit:uint = 8;
       
      
      public function Sha1Encrypt(ASCII:Boolean)
      {
         super();
         if(ASCII)
         {
            charInputBit = 8;
         }
         else
         {
            charInputBit = 16;
         }
      }
      
      public static function encrypt(s_source:String) : String
      {
         return hex_sha1(s_source);
      }
      
      private static function hex_sha1(string:String) : String
      {
         return bin_to_hex(sha1_convert(string_to_bin(string),string.length * charInputBit));
      }
      
      private static function sha1_convert(input:Array, amount:Number) : Array
      {
         var stored_bit1:Number = NaN;
         var stored_bit2:Number = NaN;
         var stored_bit3:Number = NaN;
         var stored_bit4:Number = NaN;
         var stored_bit5:Number = NaN;
         var j:Number = NaN;
         var t:Number = NaN;
         var bit1:Number = 1732584193;
         var bit2:Number = -271733879;
         var bit3:Number = -1732584194;
         var bit4:Number = 271733878;
         var bit5:Number = -1009589776;
         var bitwise_op:Array = new Array();
         input[amount >> 5] = input[amount >> 5] | 128 << 24 - amount % 32;
         input[(amount + 64 >> 9 << 4) + 15] = amount;
         for(var i:Number = 0; i < input.length; i = i + 16)
         {
            stored_bit1 = bit1;
            stored_bit2 = bit2;
            stored_bit3 = bit3;
            stored_bit4 = bit4;
            stored_bit5 = bit5;
            for(j = 0; j < 80; j++)
            {
               if(j < 16)
               {
                  bitwise_op[j] = input[i + j];
               }
               else
               {
                  bitwise_op[j] = rol(bitwise_op[j - 3] ^ bitwise_op[j - 8] ^ bitwise_op[j - 14] ^ bitwise_op[j - 16],1);
               }
               t = safe_add(safe_add(rol(bit1,5),sha_f_mod(j,bit2,bit3,bit4)),safe_add(safe_add(bit5,bitwise_op[j]),sha_z_mod(j)));
               bit5 = bit4;
               bit4 = bit3;
               bit3 = rol(bit2,30);
               bit2 = bit1;
               bit1 = t;
            }
            bit1 = safe_add(bit1,stored_bit1);
            bit2 = safe_add(bit2,stored_bit2);
            bit3 = safe_add(bit3,stored_bit3);
            bit4 = safe_add(bit4,stored_bit4);
            bit5 = safe_add(bit5,stored_bit5);
         }
         return [bit1,bit2,bit3,bit4,bit5];
      }
      
      private static function sha_f_mod(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t < 20)
         {
            return b & c | ~b & d;
         }
         if(t < 40)
         {
            return b ^ c ^ d;
         }
         if(t < 60)
         {
            return b & c | b & d | c & d;
         }
         return b ^ c ^ d;
      }
      
      private static function sha_z_mod(t:Number) : Number
      {
         return t < 20?Number(1518500249):t < 40?Number(1859775393):t < 60?Number(-1894007588):Number(-899497514);
      }
      
      private static function safe_add(x:Number, y:Number) : Number
      {
         var lsw:Number = (x & 65535) + (y & 65535);
         var msw:Number = (x >> 16) + (y >> 16) + (lsw >> 16);
         return msw << 16 | lsw & 65535;
      }
      
      private static function rol(num:Number, cnt:Number) : Number
      {
         return num << cnt | num >>> 32 - cnt;
      }
      
      private static function string_to_bin(str:String) : Array
      {
         var bin:Array = new Array();
         var mask:Number = 1 << charInputBit - 1;
         for(var i:Number = 0; i < str.length * charInputBit; bin[i >> 5] = bin[i >> 5] | (str.charCodeAt(i / charInputBit) & mask) << 32 - charInputBit - i % 32,i = i + charInputBit)
         {
         }
         return bin;
      }
      
      private static function bin_to_hex(binarray:Array) : String
      {
         var charMap:String = "0123456789abcdef";
         var str:String = new String();
         for(var i:Number = 0; i < binarray.length * 4; i++)
         {
            str = str + (charMap.charAt(binarray[i >> 2] >> (3 - i % 4) * 8 + 4 & 15) + charMap.charAt(binarray[i >> 2] >> (3 - i % 4) * 8 & 15));
         }
         return str;
      }
   }
}
