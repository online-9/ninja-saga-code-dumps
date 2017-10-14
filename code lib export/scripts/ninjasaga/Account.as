package ninjasaga
{
   import ninjasaga.data.Data;
   import com.utils.Sha1Encrypt;
   import com.utils.Out;
   
   public class Account
   {
      
      private static var account_id:uint;
      
      private static var account_type:uint;
      
      private static var account_balance:int;
      
      private static var account_session_key:String;
      
      private static var accountTypeHash:String;
      
      public static const FREE:uint = 1;
      
      public static const PREMIUM:uint = 2;
       
      
      public function Account()
      {
         super();
      }
      
      public static function setupAccount(loginResult:Array, signature:String) : Boolean
      {
         var strToHash:String = null;
         account_session_key = loginResult[3];
         Data.sessionKey = account_session_key;
         if(Central.main)
         {
            strToHash = loginResult[0] + "|" + loginResult[1] + "|" + loginResult[2];
            if(Central.main.getHash(strToHash) != signature)
            {
               return false;
            }
         }
         if(loginResult[0] > 0)
         {
            account_id = loginResult[0];
            accountTypeHash = Sha1Encrypt.encrypt(String(loginResult[1]));
            account_type = loginResult[1];
            account_balance = loginResult[2];
            return true;
         }
         return false;
      }
      
      public static function getAccountId() : uint
      {
         return account_id;
      }
      
      public static function getAccountType() : uint
      {
         if(accountTypeHash == Sha1Encrypt.encrypt(String(account_type)))
         {
            return account_type;
         }
         Out.data("Account","account type mismatch");
         Central.main.submitData();
         return 1;
      }
      
      public static function getAccountTypeNoVerify() : uint
      {
         return account_type;
      }
      
      public static function getAccountBalance() : int
      {
         return account_balance;
      }
      
      public static function getAccountSessionKey() : String
      {
         return account_session_key;
      }
      
      public static function set balance(value:int) : void
      {
         account_balance = value;
      }
   }
}
