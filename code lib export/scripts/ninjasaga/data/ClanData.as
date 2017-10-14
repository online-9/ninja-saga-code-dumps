package ninjasaga.data
{
   public final class ClanData
   {
      
      public static const ID:String = "id";
      
      public static const NAME:String = "name";
      
      public static const MASTER_ID:String = "master_id";
      
      public static const MASTER_NAME:String = "master_name";
      
      public static const MEMBER_SLOTS:String = "member_slots";
      
      public static const TOURNAMENT:String = "tournament";
      
      public static const REPUTATION:String = "reputation";
      
      public static const GOLD:String = "gold";
      
      public static const TOKEN:String = "token";
      
      public static const MEMBER_NUMBER:String = "member_number";
      
      public static const ANNOUNCEMENT:String = "announcement";
      
      public static const HAVE_NEW_MEMBER_REQUEST:String = "new_request";
      
      public static const CHARACTER_MAX_STAMINA:String = "character_max_stamina";
      
      public static const CHARACTER_STAMINA:String = "character_stamina";
      
      public static const REQUEST_MAMBER_ID:String = "id";
      
      public static const REQUEST_MAMBER_LEVEL:String = "level";
      
      public static const REQUEST_MAMBER_NAME:String = "name";
      
      public static const REQUEST_MAMBER_ACCOUNT_TYPE:String = "account_type";
      
      public static const REQUEST_MAMBER_SKILL_TYPE:String = "skill_type";
      
      public static const CLAN_STAMINA_BONUS:String = "clan_stamina_bonus";
      
      public static const CLAN_HP_BONUS:String = "clan_hp_bonus";
      
      public static const CLAN_CP_BONUS:String = "clan_cp_bonus";
      
      public static const CLAN_DAMAGE_BONUS:String = "clan_damage_bonus";
      
      public static const BUILDING_DATA:Object = {
         1:{
            "id":1,
            "name":"Ramen",
            "mc":"ramenMc",
            "maxLevel":3,
            "gold":[1000000,2000000,0],
            "token":[0,0,4000],
            "bonusType":CLAN_STAMINA_BONUS,
            "bonus":10
         },
         2:{
            "id":2,
            "name":"Hot Spring",
            "mc":"hotSpringMc",
            "maxLevel":3,
            "gold":[1000000,2000000,0],
            "token":[0,0,4000],
            "bonusType":CLAN_HP_BONUS,
            "bonus":30
         },
         3:{
            "id":3,
            "name":"Temple",
            "mc":"templeMc",
            "maxLevel":3,
            "gold":[1000000,2000000,0],
            "token":[0,0,4000],
            "bonusType":CLAN_CP_BONUS,
            "bonus":30
         },
         4:{
            "id":4,
            "name":"Training Hall",
            "mc":"trainingHallMc",
            "maxLevel":3,
            "gold":[1000000,2000000,0],
            "token":[0,0,4000],
            "bonusType":CLAN_DAMAGE_BONUS,
            "bonus":30
         }
      };
       
      
      public function ClanData()
      {
         super();
      }
   }
}
