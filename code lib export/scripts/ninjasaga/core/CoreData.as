package ninjasaga.core
{
   public final class CoreData
   {
      
      public static const ADMIN_CHARACTERS:Array = [104,114,12071,20483,30417];
      
      public static const PET_MAX_DAMAGE_PER_LEVEL:int = 20;
      
      public static const PET_MAX_DAMAGE_BONUS:Number = 99;
      
      public static const SKILL_DATA_ERROR:int = 1102;
      
      public static const SKILL_EFFECT_ERROR:int = 1103;
      
      public static const PET_DAMAGE_ERROR:int = 1104;
      
      public static const MISSION_DATA_ERROR:int = 1105;
      
      public static const BATTLE_SKILL_SIG_ERROR:int = 1106;
      
      public static var obfus;
       
      
      public function CoreData()
      {
         super();
      }
      
      public static function get BASE_CRITICAL_CHANCE() : Number
      {
         return obfus.BASE_CRITICAL_CHANCE;
      }
      
      public static function get BASE_DODGE_CHANCE() : Number
      {
         return obfus.BASE_DODGE_CHANCE;
      }
      
      public static function get BASE_CRITICAL_MULTIPLIER() : Number
      {
         return obfus.BASE_CRITICAL_MULTIPLIER;
      }
      
      public static function get DAMAGE_LIMIT() : int
      {
         return obfus.DAMAGE_LIMIT;
      }
      
      public static function get SKILL_TYPE_BONUS() : Number
      {
         return obfus.SKILL_TYPE_BONUS;
      }
      
      public static function get ZERO_NUMBER() : int
      {
         return obfus.ZERO_NUMBER;
      }
   }
}
