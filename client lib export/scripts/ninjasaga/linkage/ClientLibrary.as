package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import com.utils.Sha1Encrypt;
   
   public class ClientLibrary extends MovieClip
   {
       
      
      private var _s:String = "Vmn34aAciYK00Hen26nT01";
      
      public function ClientLibrary()
      {
         super();
      }
      
      public function encrypt(param1:String) : String
      {
         return Sha1Encrypt.encrypt(param1);
      }
      
      public function getLoginHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2 + _s;
         return this.generateHash(param1,_loc3_);
      }
      
      public function generateHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2;
         var _loc4_:int = parseInt("0x" + param1.substr(1,1),16);
         var _loc5_:String = Sha1Encrypt.encrypt(_loc3_);
         return _loc5_.substr(_loc4_,12);
      }
      
      public function getHash(param1:String, param2:String) : String
      {
         var _loc3_:String = param2 + _s + param1;
         return this.generateHash(param1,_loc3_);
      }
      
      public function getArrayHash(param1:String, param2:Array) : String
      {
         var _loc3_:String = param2.toString() + _s + param1;
         return this.generateHash(param1,_loc3_);
      }
   }
}
