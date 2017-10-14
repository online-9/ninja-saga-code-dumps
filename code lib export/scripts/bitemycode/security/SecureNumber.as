package bitemycode.security
{
   import com.utils.Sha1Encrypt;
   import ninjasaga.Central;
   
   public class SecureNumber
   {
       
      
      private var _number:Number;
      
      private var _numberHash:String;
      
      public function SecureNumber(num:Number = 0)
      {
         super();
         this._number = num;
         this._numberHash = Sha1Encrypt.encrypt(String(num));
      }
      
      public function set value(num:Number) : void
      {
         this._number = num;
         this._numberHash = Sha1Encrypt.encrypt(String(num));
      }
      
      public function get value() : Number
      {
         if(Sha1Encrypt.encrypt(String(this._number)) != this._numberHash)
         {
            Central.main.onError();
         }
         return this._number;
      }
   }
}
