package com.utils
{
   public class Sha1Encrypt
   {
      
      private static var charInputBit:uint = 8;
       
      
      public function Sha1Encrypt(param1:Boolean)
      {
         super();
         if(param1)
         {
            charInputBit = 8;
         }
         else
         {
            charInputBit = 16;
         }
      }
      
      public static function encrypt(param1:String) : String
      {
         return hex_sha1(param1);
      }
      
      private static function hex_sha1(param1:String) : String
      {
         return bin_to_hex(sha1_convert(string_to_bin(param1),param1.length * charInputBit));
      }
      
      private static function sha1_convert(param1:Array, param2:Number) : Array
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc3_:Number = 1732584193;
         var _loc4_:Number = -271733879;
         var _loc5_:Number = -1732584194;
         var _loc6_:Number = 271733878;
         var _loc7_:Number = -1009589776;
         var _loc8_:Array = new Array();
         param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
         param1[(param2 + 64 >> 9 << 4) + 15] = param2;
         var _loc9_:Number = 0;
         while(_loc9_ < param1.length)
         {
            _loc10_ = _loc3_;
            _loc11_ = _loc4_;
            _loc12_ = _loc5_;
            _loc13_ = _loc6_;
            _loc14_ = _loc7_;
            _loc15_ = 0;
            while(_loc15_ < 80)
            {
               if(_loc15_ < 16)
               {
                  _loc8_[_loc15_] = param1[_loc9_ + _loc15_];
               }
               else
               {
                  _loc8_[_loc15_] = rol(_loc8_[_loc15_ - 3] ^ _loc8_[_loc15_ - 8] ^ _loc8_[_loc15_ - 14] ^ _loc8_[_loc15_ - 16],1);
               }
               _loc16_ = safe_add(safe_add(rol(_loc3_,5),sha_f_mod(_loc15_,_loc4_,_loc5_,_loc6_)),safe_add(safe_add(_loc7_,_loc8_[_loc15_]),sha_z_mod(_loc15_)));
               _loc7_ = _loc6_;
               _loc6_ = _loc5_;
               _loc5_ = rol(_loc4_,30);
               _loc4_ = _loc3_;
               _loc3_ = _loc16_;
               _loc15_++;
            }
            _loc3_ = safe_add(_loc3_,_loc10_);
            _loc4_ = safe_add(_loc4_,_loc11_);
            _loc5_ = safe_add(_loc5_,_loc12_);
            _loc6_ = safe_add(_loc6_,_loc13_);
            _loc7_ = safe_add(_loc7_,_loc14_);
            _loc9_ = _loc9_ + 16;
         }
         return [_loc3_,_loc4_,_loc5_,_loc6_,_loc7_];
      }
      
      private static function sha_f_mod(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 < 20)
         {
            return param2 & param3 | ~param2 & param4;
         }
         if(param1 < 40)
         {
            return param2 ^ param3 ^ param4;
         }
         if(param1 < 60)
         {
            return param2 & param3 | param2 & param4 | param3 & param4;
         }
         return param2 ^ param3 ^ param4;
      }
      
      private static function sha_z_mod(param1:Number) : Number
      {
         return param1 < 20?Number(1518500249):param1 < 40?Number(1859775393):param1 < 60?Number(-1894007588):Number(-899497514);
      }
      
      private static function safe_add(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param1 & 65535) + (param2 & 65535);
         var _loc4_:Number = (param1 >> 16) + (param2 >> 16) + (_loc3_ >> 16);
         return _loc4_ << 16 | _loc3_ & 65535;
      }
      
      private static function rol(param1:Number, param2:Number) : Number
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
      
      private static function string_to_bin(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = 1 << charInputBit - 1;
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length * charInputBit)
         {
            _loc2_[_loc4_ >> 5] = _loc2_[_loc4_ >> 5] | (param1.charCodeAt(_loc4_ / charInputBit) & _loc3_) << 32 - charInputBit - _loc4_ % 32;
            _loc4_ = _loc4_ + charInputBit;
         }
         return _loc2_;
      }
      
      private static function bin_to_hex(param1:Array) : String
      {
         var _loc2_:String = "0123456789abcdef";
         var _loc3_:String = new String();
         var _loc4_:Number = 0;
         while(_loc4_ < param1.length * 4)
         {
            _loc3_ = _loc3_ + (_loc2_.charAt(param1[_loc4_ >> 2] >> (3 - _loc4_ % 4) * 8 + 4 & 15) + _loc2_.charAt(param1[_loc4_ >> 2] >> (3 - _loc4_ % 4) * 8 & 15));
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
