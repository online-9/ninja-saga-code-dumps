package ninjasaga.dbclass
{
   import flash.net.registerClassAlias;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Data;
   
   public class DBCharacter
   {
       
      
      public var character_id = 0;
      
      public var account_id:uint = 0;
      
      public var character_name:String = "";
      
      public var character_level:uint = 1;
      
      public var character_xp:uint = 0;
      
      public var character_armor:uint = 0;
      
      public var character_hp:uint = 100;
      
      public var character_max_hp:uint = 100;
      
      public var character_cp:uint = 100;
      
      public var character_max_cp:uint = 100;
      
      public var character_gold:uint = 300;
      
      public var character_rank:uint = 0;
      
      public var character_max_sp:uint = 0;
      
      public var character_sp:uint = 0;
      
      public var character_pet_cp:uint = 0;
      
      public var character_pet_max_cp:uint = 1000;
      
      public var character_pet_ep:uint = 0;
      
      public var character_pet_max_ep:uint = 0;
      
      public var damage_hp:int = 0;
      
      public var damage_cp:int = 0;
      
      public var damage_sp:int = 0;
      
      public var restore_hp:int = 0;
      
      public var restore_cp:int = 0;
      
      public var restore_sp:int = 0;
      
      public var character_skills:Array;
      
      public var character_skill_talent:Array;
      
      public var character_skill_unallocated:uint = 0;
      
      public var character_skill_resistance:Array;
      
      public var character_skill_resistance_unallocated:uint = 0;
      
      public var character_strength:uint = 0;
      
      public var character_speed:uint = 10;
      
      public var character_intelligence:uint = 0;
      
      public var character_stamina:uint = 0;
      
      public var character_chakra:uint = 0;
      
      public var character_body_parts:Object;
      
      public var character_hair_color:Array;
      
      public var character_gender:uint = 0;
      
      public var character_eye_color:Number;
      
      public var character_skin_color:Number;
      
      public var character_face:String;
      
      public var character_hair:String;
      
      public var character_body_set:String;
      
      public var session_playtime:int = 100;
      
      public var character_inventory:Object;
      
      public var character_fire:uint = 0;
      
      public var character_water:uint = 0;
      
      public var character_wind:uint = 0;
      
      public var character_earth:uint = 0;
      
      public var character_lightning:uint = 0;
      
      public var character_taijutsu:uint = 0;
      
      public var character_genjutsu:uint = 0;
      
      public var character_summon:uint = 0;
      
      public var character_control:uint = 0;
      
      public var character_bloodline:String = "";
      
      public var character_hash = "";
      
      public var bloodline:Array;
      
      public var senjutsu:Array;
      
      public var character_senjutsu:Array;
      
      public var character_senjutsu_ss:String = "";
      
      public var remove_inv_arr:Array;
      
      public var add_inv_arr:Array;
      
      public var equip_arr:Array;
      
      public var remove_equip_arr:Array;
      
      public var current_expiry_arr:Array;
      
      public var expired_pet_arr:Array;
      
      public var inv_slots_obj:Object;
      
      public function DBCharacter()
      {
         character_skills = new Array();
         character_skill_talent = new Array();
         character_skill_resistance = new Array();
         character_body_parts = {};
         character_hair_color = Data.DEFAULT_HAIR_COLOR;
         character_eye_color = Data.DEFAULT_EYE_COLOR;
         character_skin_color = Data.DEFAULT_SKIN_COLOR;
         character_face = Data.DEFAULT_FACE + "_" + character_gender;
         character_hair = Data.DEFAULT_HAIR + "_" + character_gender;
         character_body_set = Data.DEFAULT_BODY_SET;
         character_inventory = new Object();
         bloodline = [];
         senjutsu = [];
         character_senjutsu = [];
         remove_inv_arr = [];
         add_inv_arr = [];
         equip_arr = [];
         remove_equip_arr = [];
         current_expiry_arr = [];
         expired_pet_arr = [];
         inv_slots_obj = {};
         super();
      }
      
      public static function register() : void
      {
         registerClassAlias("ninja.Character",DBCharacter);
      }
      
      public static function parseDBCharacter(dbChar:DBCharacter) : Object
      {
         var object:Object = new Object();
         object.character_id = dbChar.character_id;
         object.account_id = dbChar.account_id;
         object.character_name = dbChar.character_name;
         object.character_level = dbChar.character_level;
         object.character_xp = dbChar.character_xp;
         object.character_armor = dbChar.character_armor;
         object.character_hp = dbChar.character_hp;
         object.character_max_hp = dbChar.character_max_hp;
         object.character_cp = dbChar.character_cp;
         object.character_max_cp = dbChar.character_max_cp;
         object.character_gold = dbChar.character_gold;
         object.character_rank = dbChar.character_rank;
         object.character_skills = dbChar.character_skills;
         object.character_skill_talent = dbChar.character_skill_talent;
         object.character_skill_unallocated = dbChar.character_skill_unallocated;
         object.character_skill_resistance = dbChar.character_skill_resistance;
         object.character_skill_resistance_unallocated = dbChar.character_skill_resistance_unallocated;
         object.character_strength = dbChar.character_strength;
         object.character_speed = dbChar.character_speed;
         object.character_intelligence = dbChar.character_intelligence;
         object.character_stamina = dbChar.character_stamina;
         object.character_chakra = dbChar.character_chakra;
         object.character_body_parts = dbChar.character_body_parts;
         object.character_hair_color = dbChar.character_hair_color;
         object.character_gender = dbChar.character_gender;
         object.character_eye_color = dbChar.character_eye_color;
         object.character_skin_color = dbChar.character_skin_color;
         object.character_face = dbChar.character_face;
         object.character_hair = dbChar.character_hair;
         object.character_body_set = dbChar.character_body_set;
         object.character_pet_cp = dbChar.character_pet_cp;
         object.character_pet_max_cp = dbChar.character_pet_max_cp;
         object.character_pet_ep = dbChar.character_pet_ep;
         object.character_pet_max_ep = dbChar.character_pet_max_ep;
         object[DBCharacterData.SP] = 0;
         object[DBCharacterData.MAX_SP] = 1;
         object[DBCharacterData.DAMAGE_HP] = 0;
         object[DBCharacterData.DAMAGE_CP] = 0;
         object[DBCharacterData.DAMAGE_SP] = 0;
         object[DBCharacterData.RESTORE_HP] = 0;
         object[DBCharacterData.RESTORE_CP] = 0;
         object[DBCharacterData.RESTORE_SP] = 0;
         object[DBCharacterData.FIRE] = dbChar[DBCharacterData.FIRE];
         object[DBCharacterData.WATER] = dbChar[DBCharacterData.WATER];
         object[DBCharacterData.WIND] = dbChar[DBCharacterData.WIND];
         object[DBCharacterData.EARTH] = dbChar[DBCharacterData.EARTH];
         object[DBCharacterData.LIGHTNING] = dbChar[DBCharacterData.LIGHTNING];
         object[DBCharacterData.TAIJUTSU] = dbChar[DBCharacterData.TAIJUTSU];
         object[DBCharacterData.GENJUTSU] = dbChar[DBCharacterData.GENJUTSU];
         object[DBCharacterData.SUMMON] = dbChar[DBCharacterData.SUMMON];
         object[DBCharacterData.CONTROL] = dbChar[DBCharacterData.CONTROL];
         object[DBCharacterData.BLOODLINE] = dbChar[DBCharacterData.BLOODLINE];
         object[DBCharacterData.BLOODLINE_SKILL] = dbChar[DBCharacterData.BLOODLINE_SKILL];
         object[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR];
         object[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR];
         object[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR];
         object[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR];
         object[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR];
         object[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR] = dbChar[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR];
         return object;
      }
      
      public static function parseObject(obj:Object) : DBCharacter
      {
         var dbChar:DBCharacter = new DBCharacter();
         dbChar.character_id = obj.character_id;
         dbChar.account_id = obj.account_id;
         dbChar.character_name = obj.character_name;
         dbChar.character_level = obj.character_level;
         dbChar.character_xp = obj.character_xp;
         dbChar.character_armor = obj.character_armor;
         dbChar.character_hp = obj.character_hp;
         dbChar.character_max_hp = obj.character_max_hp;
         dbChar.character_cp = obj.character_cp;
         dbChar.character_max_cp = obj.character_max_cp;
         dbChar.character_gold = obj.character_gold;
         dbChar.character_rank = obj.character_rank;
         dbChar.character_skills = obj.character_skills;
         dbChar.character_skill_talent = obj.character_skill_talent;
         dbChar.character_skill_unallocated = obj.character_skill_unallocated;
         dbChar.character_skill_resistance = obj.character_skill_resistance;
         dbChar.character_skill_resistance_unallocated = obj.character_skill_resistance_unallocated;
         dbChar.character_strength = obj.character_strength;
         dbChar.character_speed = obj.character_speed;
         dbChar.character_intelligence = obj.character_intelligence;
         dbChar.character_stamina = obj.character_stamina;
         dbChar.character_chakra = obj.character_chakra;
         dbChar.character_body_parts = obj.character_body_parts;
         dbChar.character_hair_color = obj.character_hair_color;
         dbChar.character_gender = obj.character_gender;
         dbChar.character_eye_color = obj.character_eye_color;
         dbChar.character_skin_color = obj.character_skin_color;
         dbChar.character_face = obj.character_face;
         dbChar.character_hair = obj.character_hair;
         dbChar.character_body_set = obj.character_body_set;
         dbChar.character_pet_cp = obj.character_pet_cp;
         dbChar.character_pet_max_cp = obj.character_pet_max_cp;
         dbChar.character_pet_ep = obj.character_pet_ep;
         dbChar.character_pet_max_ep = obj.character_pet_max_ep;
         dbChar[DBCharacterData.SP] = 0;
         dbChar[DBCharacterData.MAX_SP] = 1;
         dbChar[DBCharacterData.DAMAGE_HP] = 0;
         dbChar[DBCharacterData.DAMAGE_CP] = 0;
         dbChar[DBCharacterData.DAMAGE_SP] = 0;
         dbChar[DBCharacterData.RESTORE_HP] = 0;
         dbChar[DBCharacterData.RESTORE_CP] = 0;
         dbChar[DBCharacterData.RESTORE_SP] = 0;
         dbChar[DBCharacterData.FIRE] = obj[DBCharacterData.FIRE];
         dbChar[DBCharacterData.WATER] = obj[DBCharacterData.WATER];
         dbChar[DBCharacterData.WIND] = obj[DBCharacterData.WIND];
         dbChar[DBCharacterData.EARTH] = obj[DBCharacterData.EARTH];
         dbChar[DBCharacterData.LIGHTNING] = obj[DBCharacterData.LIGHTNING];
         dbChar[DBCharacterData.TAIJUTSU] = obj[DBCharacterData.TAIJUTSU];
         dbChar[DBCharacterData.GENJUTSU] = obj[DBCharacterData.GENJUTSU];
         dbChar[DBCharacterData.SUMMON] = obj[DBCharacterData.SUMMON];
         dbChar[DBCharacterData.CONTROL] = obj[DBCharacterData.CONTROL];
         dbChar[DBCharacterData.BLOODLINE] = obj[DBCharacterData.BLOODLINE];
         dbChar[DBCharacterData.BLOODLINE_SKILL] = obj[DBCharacterData.BLOODLINE_SKILL];
         dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR] = obj[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR];
         dbChar[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR] = obj[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR];
         dbChar[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR] = obj[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR];
         dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR] = obj[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR];
         dbChar[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR] = obj[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR];
         dbChar[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR] = obj[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR];
         return dbChar;
      }
   }
}
