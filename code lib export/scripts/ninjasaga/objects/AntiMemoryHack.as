package ninjasaga.objects
{
   public class AntiMemoryHack
   {
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_NULL:int = 0;
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_1000:int = 1;
      
      public static const ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:int = 2;
      
      private static var grp:Array = [];
       
      
      private var securityType:int = 0;
      
      private var intTestValue1:int;
      
      private var intTestValue2:int;
      
      private var doubleTestValue1:Number;
      
      private var intPlusOneValue1:int;
      
      private var intPlusOneValue2:int;
      
      private var doubleMultiThousandValue1:Number;
      
      public function AntiMemoryHack(secType:int)
      {
         intTestValue1 = Math.random() * int.MAX_VALUE;
         intTestValue2 = Math.random() * int.MAX_VALUE;
         doubleTestValue1 = Math.random() * Number.MAX_VALUE;
         intPlusOneValue1 = Math.random() * int.MAX_VALUE;
         intPlusOneValue2 = Math.random() * int.MAX_VALUE;
         doubleMultiThousandValue1 = Math.random() * Number.MAX_VALUE;
         super();
         securityType = secType;
         setCheckValues(secType);
      }
      
      public static function copyInstance(securityType:int) : AntiMemoryHack
      {
         var tmpObj:AntiMemoryHack = new AntiMemoryHack(securityType);
         AntiMemoryHack.grp.push(tmpObj);
         return tmpObj;
      }
      
      public static function check() : Boolean
      {
         var antiHackObj:AntiMemoryHack = null;
         for each(antiHackObj in grp)
         {
            if(antiHackObj.check() == false)
            {
               return false;
            }
         }
         return true;
      }
      
      private function setCheckValues(secType:int) : void
      {
         switch(securityType)
         {
            case ANTIMEMORYHACK_SECURITY_TYPE_1000:
               doubleTestValue1 = 0.01;
               doubleMultiThousandValue1 = 10;
               break;
            case ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:
               intTestValue1 = 610575266;
               intTestValue2 = 2728616996;
               intPlusOneValue1 = 610575267;
               intPlusOneValue2 = 2728616997;
         }
      }
      
      public function check() : Boolean
      {
         switch(securityType)
         {
            case ANTIMEMORYHACK_SECURITY_TYPE_1000:
               return doubleTestValue1 * 1000 == doubleMultiThousandValue1;
            case ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2:
               return intTestValue1 + 1 == intPlusOneValue1 && intTestValue2 + 1 == intPlusOneValue2;
            default:
               return false;
         }
      }
   }
}
