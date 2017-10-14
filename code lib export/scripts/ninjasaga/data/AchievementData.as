package ninjasaga.data
{
   public final class AchievementData
   {
      
      public static const BATTLE:int = 1;
      
      public static const USE_WEAPON:int = 2;
      
      public static const USE_SKILL:int = 3;
      
      public static const DODGE:int = 4;
      
      public static const CRITICAL:int = 5;
      
      public static const ENEMY_KILLED:int = 7;
      
      public static const DEATH:int = 8;
      
      public static const RUN:int = 9;
      
      public static const LIVE_BATTLE:int = 10;
      
      public static const LIVE_BATTLE_WIN:int = 11;
      
      public static const ALL_BATTLE_STAT:Array = [BATTLE,USE_WEAPON,USE_SKILL,DODGE,CRITICAL,ENEMY_KILLED,DEATH,RUN,LIVE_BATTLE,LIVE_BATTLE_WIN];
      
      public static const GOLD_OBTAINED:int = 12;
      
      public static const FRIEND_VISITED:int = 13;
      
      public static const CHALLENGE_DONE:int = 14;
      
      public static const FRIEND_RECRUITED:int = 15;
      
      public static const GIFT_SHARED:int = 16;
      
      public static const WEAPON_BOUGHT:int = 17;
      
      public static const CLOTHING_BOUGHT:int = 18;
      
      public static const WEAPON_FORGED:int = 19;
      
      public static const MISSION_COMPLETED:int = 20;
      
      public static const SPECIAL_MISSION_COMPLETED:int = 21;
      
      public static const DAILY_MISSION_COMPLETED:int = 22;
      
      public static const MISSION_FAILED:int = 23;
      
      public static const WALLFEED_POSTED:int = 27;
      
      public static const WALLFEED_CLAIMED:int = 28;
      
      public static const FRIEND_INVITED:int = 29;
      
      public static const DAYS_PLAYED:int = 30;
      
      public static const ALL_CHAR_STAT:Array = [GOLD_OBTAINED,FRIEND_VISITED,CHALLENGE_DONE,FRIEND_RECRUITED,GIFT_SHARED,WEAPON_BOUGHT,CLOTHING_BOUGHT,WEAPON_FORGED,MISSION_COMPLETED,SPECIAL_MISSION_COMPLETED,DAILY_MISSION_COMPLETED,MISSION_FAILED,WALLFEED_POSTED,WALLFEED_CLAIMED,FRIEND_INVITED,DAYS_PLAYED];
      
      public static const SKILL_TRAINED:int = 24;
      
      public static const KINJUTSU_TRAINED:int = 26;
      
      public static const NINJA_EMBLEM:int = 25;
      
      public static const SPECIFIC_MISSION_COMPLETED:int = 31;
       
      
      public function AchievementData()
      {
         super();
      }
      
      public static function getAchievementTypeData(achievementType:int) : String
      {
         var achievementTypes:Array = ["","BATTLE","USE_WEAPON","USE_SKILL","DODGE","CRITICAL","HIGHEST_DAMAGE","ENEMY_KILLED","DEATH","RUN","LIVE_BATTLE","LIVE_BATTLE_WIN","GOLD_OBTAINED","FRIEND_VISITED","CHALLENGE_DONE","FRIEND_RECRUITED","GIFT_SHARED","WEAPON_BOUGHT","CLOTHING_BOUGHT","WEAPON_FORGED","MISSION_COMPLETED","SPECIAL_MISSION_COMPLETED","DAILY_MISSION_COMPLETED","MISSION_FAILED","SKILL_TRAINED","NINJA_EMBLEM","KINJUTSU_TRAINED","WALLFEED_POSTED","WALLFEED_CLAIMED","FRIEND_INVITED","DAYS_PLAYED","SPECIFIC_MISSION_COMPLETED"];
         return achievementTypes[achievementType];
      }
   }
}
