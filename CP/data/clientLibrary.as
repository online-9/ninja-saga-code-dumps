package data
{
    import data.*;
    import flash.display.*;

    public class clientLibrary {
        private var _s:String = "Vmn34aAciYK00Hen26nT01";
		
        public function clientLibrary(){return;}
		
        public function getArrayHash(arg1:String, arg2:Array) : String{
            var loc3:* = arg2.toString() + _s + arg1;
            return this.generateHash(arg1, loc3);
        }
        public function getLoginHash(arg1:String, arg2:String) : String{
            var loc3:* = arg2 + _s;
            return this.generateHash(arg1, loc3);
        }
        public function generateHash(arg1:String, arg2:String) : String{
            var loc3:* = arg2;
            var loc4:* = parseInt("0x" + arg1.substr(1, 1), 16);
            var loc5:* = Sha1Encrypt.encrypt(loc3);
            return Sha1Encrypt.encrypt(loc3).substr(loc4, 12);
        }
        public function encrypt(arg1:String) : String{return Sha1Encrypt.encrypt(arg1);}
        public function getHash(arg1:String, arg2:String) : String{
            var loc3:* = arg2 + _s + arg1;
            return this.generateHash(arg1, loc3);
        }
    }
}