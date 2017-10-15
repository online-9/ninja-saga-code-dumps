package data 
{
    import flash.display.*;
    
    public class clientLibrary extends Object
    {
        public function clientLibrary()
        {
            super();
            return;
        }

        public function getArrayHash(arg1:String, arg2:Array):String
        {
            var loc1:*;
            loc1 = arg2.toString() + this._s + arg1;
            return this.generateHash(arg1, loc1);
        }

        public function getLoginHash(arg1:String, arg2:String):String
        {
            var loc1:*;
            loc1 = arg2 + this._s;
            return this.generateHash(arg1, loc1);
        }

        public function generateHash(arg1:String, arg2:String):String
        {
            var loc1:*;
            loc1 = arg2;
            var loc2:*;
            loc2 = parseInt("0x" + arg1.substr(1, 1), 16);
            var loc3:*;
            loc3 = data.Sha1Encrypt.encrypt(loc1);
            return data.Sha1Encrypt.encrypt(loc1).substr(loc2, 12);
        }

        public function encrypt(arg1:String):String
        {
            return data.Sha1Encrypt.encrypt(arg1);
        }

        public function getHash(arg1:String, arg2:String):String
        {
            var loc1:*;
            loc1 = arg2 + this._s + arg1;
            return this.generateHash(arg1, loc1);
        }

        private var _s:String="Vmn34aAciYK00Hen26nT01";
    }
}
