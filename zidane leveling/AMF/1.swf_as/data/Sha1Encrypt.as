package data 
{
    public class Sha1Encrypt extends Object
    {
        public function Sha1Encrypt(arg1:Boolean)
        {
            super();
            if (arg1)
            {
                charInputBit = 8;
            }
            else 
            {
                charInputBit = 16;
            }
            return;
        }

        private static function string_to_bin(arg1:String):Array
        {
            var loc1:*;
            loc1 = new Array();
            var loc2:*;
            loc2 = (1 << charInputBit - 1);
            var loc3:*;
            loc3 = 0;
            while (loc3 < arg1.length * charInputBit) 
            {
                loc1[(loc3 >> 5)] = loc1[(loc3 >> 5)] | (arg1.charCodeAt(loc3 / charInputBit) & loc2) << 32 - charInputBit - loc3 % 32;
                loc3 = loc3 + charInputBit;
            }
            return loc1;
        }

        public static function encrypt(arg1:String):String
        {
            return hex_sha1(arg1);
        }

        private static function sha_f_mod(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            if (arg1 < 20)
            {
                return arg2 & arg3 | !arg2 & arg4;
            }
            if (arg1 < 40)
            {
                return arg2 ^ arg3 ^ arg4;
            }
            if (arg1 < 60)
            {
                return arg2 & arg3 | arg2 & arg4 | arg3 & arg4;
            }
            return arg2 ^ arg3 ^ arg4;
        }

        private static function bin_to_hex(arg1:Array):String
        {
            var loc1:*;
            loc1 = "0123456789abcdef";
            var loc2:*;
            loc2 = new String();
            var loc3:*;
            loc3 = 0;
            while (loc3 < arg1.length * 4) 
            {
                loc2 = loc2 + loc1.charAt(arg1[(loc3 >> 2)] >> (3 - loc3 % 4) * 8 + 4 & 15) + loc1.charAt(arg1[(loc3 >> 2)] >> (3 - loc3 % 4) * 8 & 15);
                loc3 = loc3 + 1;
            }
            return loc2;
        }

        private static function sha1_convert(arg1:Array, arg2:Number):Array
        {
            var loc1:*;
            loc1 = NaN;
            var loc2:*;
            loc2 = NaN;
            var loc3:*;
            loc3 = NaN;
            var loc4:*;
            loc4 = NaN;
            var loc5:*;
            loc5 = NaN;
            var loc6:*;
            loc6 = NaN;
            var loc7:*;
            loc7 = NaN;
            var loc8:*;
            loc8 = 1732584193;
            var loc9:*;
            loc9 = -271733879;
            var loc10:*;
            loc10 = -1732584194;
            var loc11:*;
            loc11 = 271733878;
            var loc12:*;
            loc12 = -1009589776;
            var loc13:*;
            loc13 = new Array();
            arg1[(arg2 >> 5)] = arg1[(arg2 >> 5)] | 128 << 24 - arg2 % 32;
            arg1[((arg2 + 64 >> 9 << 4) + 15)] = arg2;
            var loc14:*;
            loc14 = 0;
            while (loc14 < arg1.length) 
            {
                loc1 = loc8;
                loc2 = loc9;
                loc3 = loc10;
                loc4 = loc11;
                loc5 = loc12;
                loc6 = 0;
                while (loc6 < 80) 
                {
                    if (loc6 < 16)
                    {
                        loc13[loc6] = arg1[(loc14 + loc6)];
                    }
                    else 
                    {
                        loc13[loc6] = rol(loc13[(loc6 - 3)] ^ loc13[(loc6 - 8)] ^ loc13[(loc6 - 14)] ^ loc13[(loc6 - 16)], 1);
                    }
                    loc7 = safe_add(safe_add(rol(loc8, 5), sha_f_mod(loc6, loc9, loc10, loc11)), safe_add(safe_add(loc12, loc13[loc6]), sha_z_mod(loc6)));
                    loc12 = loc11;
                    loc11 = loc10;
                    loc10 = rol(loc9, 30);
                    loc9 = loc8;
                    loc8 = loc7;
                    loc6 = loc6 + 1;
                }
                loc8 = safe_add(loc8, loc1);
                loc9 = safe_add(loc9, loc2);
                loc10 = safe_add(loc10, loc3);
                loc11 = safe_add(loc11, loc4);
                loc12 = safe_add(loc12, loc5);
                loc14 = loc14 + 16;
            }
            return [loc8, loc9, loc10, loc11, loc12];
        }

        private static function hex_sha1(arg1:String):String
        {
            return bin_to_hex(sha1_convert(string_to_bin(arg1), arg1.length * charInputBit));
        }

        private static function sha_z_mod(arg1:Number):Number
        {
            return arg1 < 20 ? 1518500249 : arg1 < 40 ? 1859775393 : arg1 < 60 ? -1894007588 : -899497514;
        }

        private static function rol(arg1:Number, arg2:Number):Number
        {
            return arg1 << arg2 | arg1 >>> 32 - arg2;
        }

        private static function safe_add(arg1:Number, arg2:Number):Number
        {
            var loc1:*;
            loc1 = (arg1 & 65535) + (arg2 & 65535);
            var loc2:*;
            loc2 = (arg1 >> 16) + (arg2 >> 16) + (loc1 >> 16);
            return (arg1 >> 16) + (arg2 >> 16) + (loc1 >> 16) << 16 | loc1 & 65535;
        }

        
        {
            charInputBit = 8;
        }

        private static var charInputBit:uint=8;
    }
}
