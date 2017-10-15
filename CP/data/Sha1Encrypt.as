package data
{

	
	import data.*;
	
    public class Sha1Encrypt extends Object
    {
        private static var charInputBit:uint = 8;

        public function Sha1Encrypt(param1:Boolean)
        {
            if (param1)
            {
                charInputBit = 8;
            }
            else
            {
                charInputBit = 16;
            }
            return;
        }// end function

        private static function string_to_bin(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = (1 << charInputBit) - 1;
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length * charInputBit)
            {
                
                _loc_2[_loc_4 >> 5] = _loc_2[_loc_4 >> 5] | (param1.charCodeAt(_loc_4 / charInputBit) & _loc_3) << 32 - charInputBit - _loc_4 % 32;
                _loc_4 = _loc_4 + charInputBit;
            }
            return _loc_2;
        }// end function

        public static function encrypt(param1:String) : String
        {
            return hex_sha1(param1);
        }// end function

        private static function sha_f_mod(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            if (param1 < 20)
            {
                return param2 & param3 | ~param2 & param4;
            }
            if (param1 < 40)
            {
                return param2 ^ param3 ^ param4;
            }
            if (param1 < 60)
            {
                return param2 & param3 | param2 & param4 | param3 & param4;
            }
            return param2 ^ param3 ^ param4;
        }// end function

        private static function bin_to_hex(param1:Array) : String
        {
            var _loc_2:String = "0123456789abcdef";
            var _loc_3:* = new String();
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length * 4)
            {
                
                _loc_3 = _loc_3 + (_loc_2.charAt(param1[_loc_4 >> 2] >> (3 - _loc_4 % 4) * 8 + 4 & 15) + _loc_2.charAt(param1[_loc_4 >> 2] >> (3 - _loc_4 % 4) * 8 & 15));
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        private static function sha1_convert(param1:Array, param2:Number) : Array
        {
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_15:Number = NaN;
            var _loc_16:Number = NaN;
            var _loc_3:Number = 1732584193;
            var _loc_4:Number = -271733879;
            var _loc_5:Number = -1732584194;
            var _loc_6:Number = 271733878;
            var _loc_7:Number = -1009589776;
            var _loc_8:* = new Array();
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _loc_9:Number = 0;
            while (_loc_9 < param1.length)
            {
                
                _loc_10 = _loc_3;
                _loc_11 = _loc_4;
                _loc_12 = _loc_5;
                _loc_13 = _loc_6;
                _loc_14 = _loc_7;
                _loc_15 = 0;
                while (_loc_15 < 80)
                {
                    
                    if (_loc_15 < 16)
                    {
                        _loc_8[_loc_15] = param1[_loc_9 + _loc_15];
                    }
                    else
                    {
                        _loc_8[_loc_15] = rol(_loc_8[_loc_15 - 3] ^ _loc_8[_loc_15 - 8] ^ _loc_8[_loc_15 - 14] ^ _loc_8[_loc_15 - 16], 1);
                    }
                    _loc_16 = safe_add(safe_add(rol(_loc_3, 5), sha_f_mod(_loc_15, _loc_4, _loc_5, _loc_6)), safe_add(safe_add(_loc_7, _loc_8[_loc_15]), sha_z_mod(_loc_15)));
                    _loc_7 = _loc_6;
                    _loc_6 = _loc_5;
                    _loc_5 = rol(_loc_4, 30);
                    _loc_4 = _loc_3;
                    _loc_3 = _loc_16;
                    _loc_15 = _loc_15 + 1;
                }
                _loc_3 = safe_add(_loc_3, _loc_10);
                _loc_4 = safe_add(_loc_4, _loc_11);
                _loc_5 = safe_add(_loc_5, _loc_12);
                _loc_6 = safe_add(_loc_6, _loc_13);
                _loc_7 = safe_add(_loc_7, _loc_14);
                _loc_9 = _loc_9 + 16;
            }
            return [_loc_3, _loc_4, _loc_5, _loc_6, _loc_7];
        }// end function

        private static function hex_sha1(param1:String) : String
        {
            return bin_to_hex(sha1_convert(string_to_bin(param1), param1.length * charInputBit));
        }// end function

        private static function sha_z_mod(param1:Number) : Number
        {
            return param1 < 20 ? (1518500249) : (param1 < 40 ? (1859775393) : (param1 < 60 ? (-1894007588) : (-899497514)));
        }// end function

        private static function rol(param1:Number, param2:Number) : Number
        {
            return param1 << param2 | param1 >>> 32 - param2;
        }// end function

        private static function safe_add(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = (param1 & 65535) + (param2 & 65535);
            var _loc_4:* = (param1 >> 16) + (param2 >> 16) + (_loc_3 >> 16);
            return (param1 >> 16) + (param2 >> 16) + (_loc_3 >> 16) << 16 | _loc_3 & 65535;
        }
    }
}
