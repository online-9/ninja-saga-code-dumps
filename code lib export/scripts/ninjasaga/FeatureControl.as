package ninjasaga
{
   import ninjasaga.data.AppData;
   import ninjasaga.data.Data;
   
   public class FeatureControl
   {
       
      
      private const LOCAL_TYPE:String = AppData.FB;
      
      private var usedAppType:String;
      
      public var LV_RANGE_01_20:Boolean = false;
      
      public var LV_RANGE_21_40:Boolean = false;
      
      public var LV_RANGE_41_60:Boolean = false;
      
      public var LV_RANGE_61_80:Boolean = false;
      
      public var THEME_THANKSGIVING:Boolean = false;
      
      public var EVENT_RR_EXAM_PROMOTE:Boolean = false;
      
      public var EVENT_RR_DRAGON_BOAT:Boolean = false;
      
      public var EVENT_RR_PROMOTE_EVENT:Boolean = false;
      
      public var EVENT_VDAY2012_EVENT:Boolean = false;
      
      public var EVENT_MOTHERDAY2012_EVENT:Boolean = false;
      
      public var EVENT_FATHERDAY2012_EVENT:Boolean = false;
      
      public var EVENT_15M_PROMOTION_EVENT:Boolean = false;
      
      public var EVENT_VDAY2012_PACKAGE:Boolean = false;
      
      public var EVENT_VDAY2012_PAY_PET:Boolean = false;
      
      public var THEME_CHRISMAS:Boolean = false;
      
      public var EVENT_NEW_YEAR:Boolean = false;
      
      public var THEME_CNY:Boolean = false;
      
      public var EVENT_HALLOWEEN_PREMIUM:Boolean = false;
      
      public var EVENT_HALLOWEEN_PACKAGE:Boolean = false;
      
      public var EVENT_HALLOWEEN_EVENT:Boolean = false;
      
      public var EVENT_HALLOWEEN_PAY_PET:Boolean = false;
      
      public var EVENT_MOL_CODE:Boolean = false;
      
      public var EVENT_PAYMENT_SKILL:Boolean = false;
      
      public var EVENT_EASTER_2012:Boolean = false;
      
      public var EVENT_HALLOWEEN_2012:Boolean = false;
      
      public var EVENT_THANKSGIVING_2012:Boolean = false;
      
      public var EXAM_CHUNIN:Boolean = false;
      
      public var EXAM_JOUNIN:Boolean = false;
      
      public var EXAM_S_JOUNIN:Boolean = false;
      
      public var EXAM_CHUNIN_PANEL:Boolean = false;
      
      public var EXAM_JOUNIN_PANEL:Boolean = false;
      
      public var EXAM_S_JOUNIN_PANEL:Boolean = false;
      
      public var EXAM_TUTOR_PANEL:Boolean = false;
      
      public var FEATURE_PET_LEARN_SKILL_BY_TOKEN:Boolean = false;
      
      public var FEATURE_ROULETTE:Boolean = false;
      
      public var FEATURE_DAILY_TASK:Boolean = false;
      
      public var FEATURE_DAILY_TASK_2:Boolean = false;
      
      public var FEATURE_GIFT:Boolean = false;
      
      public var FEATURE_INVITE_REWARD:Boolean = false;
      
      public var FEATURE_ACHIEVEMENT:Boolean = false;
      
      public var FEATURE_MAIL:Boolean = false;
      
      public var FEATURE_EMBLEM_DAILY_GIFT:Boolean = false;
      
      public var FEATURE_DAILY_LOGIN:Boolean = false;
      
      public var FEATURE_DAILY_SCRATCH:Boolean = false;
      
      public var FEATURE_PVP:Boolean = false;
      
      public var FEATURE_NINJA_CHALLENGE:Boolean = false;
      
      public var FEATURE_CLAN:Boolean = false;
      
      public var FEATURE_TALENT:Boolean = false;
      
      public var FEATURE_ESSENCE:Boolean = false;
      
      public var FEATURE_ESSENCE_ITEM500:Boolean = false;
      
      public var FEATURE_MATERIAL:Boolean = false;
      
      public var FEATURE_REQUEST:Boolean = false;
      
      public var FEATURE_EXPIRY_ITEM:Boolean = false;
      
      public var FEATURE_SHOPPACKAGE:Boolean = false;
      
      public var FEATURE_INVITE_INSTANT_REWRAD:Boolean = false;
      
      public var FEATURE_NEW_CHAR_DAILY_REWARDS:Boolean = false;
      
      public var FEATURE_FD_KUNAI_CURRENCY:Boolean = false;
      
      public var FEATURE_PAYMENT_PACKAGE:Boolean = false;
      
      public var FEATURE_FREE_PROMOTE:Boolean = false;
      
      public var MISSION_GRADE_A:Boolean = false;
      
      public var FEATURE_DAILY_LUCK_DRAW:Boolean = false;
      
      public var FEATURE_DOUBLE_GOLD:Boolean = false;
      
      public var FEATURE_DOUBLE_XP:Boolean = false;
      
      public var FEATURE_HALF_TRAIN_TIME:Boolean = false;
      
      public var FEATURE_SKILL_HALF_GOLD:Boolean = false;
      
      public var FEATURE_SHOP_HALF_TOKEN:Boolean = false;
      
      public var FEATURE_SHOP_HALF_GOLD:Boolean = false;
      
      public var FEATURE_DOUBLE_TP:Boolean = false;
      
      public var FEATURE_PET_HALF_TRAIN_TIME:Boolean = false;
      
      public var FEATURE_TOKEN_DISCOUNT:Boolean = false;
      
      public var FEATURE_HUNTING_BOSS_EXTRA_MATERIAL:Boolean = false;
      
      public var FEATURE_BLACKSMITH:Boolean = false;
      
      public var FEATURE_RESET_SKILL:Boolean = false;
      
      public var FEATURE_RESET_TALENT:Boolean = false;
      
      public var FEATURE_RENAME_CHAR:Boolean = false;
      
      public var FEATURE_BLOODLINE:Boolean = false;
      
      public var FEATURE_SENJUTSU:Boolean = false;
      
      public var FEATURE_UPGRADE_SKILL:Boolean = false;
      
      public var FEATURE_TRAIN_TIME_INSTANCE:Boolean = false;
      
      public var PANEL_RECRUIT_FRIEND_1:Boolean = false;
      
      public var PANEL_RECRUIT_FRIEND_2:Boolean = false;
      
      public var PANEL_VISIT_FRIEND_1:Boolean = false;
      
      public var PANEL_VISIT_FRIEND_2:Boolean = false;
      
      public var PANEL_MISSION_1:Boolean = false;
      
      public var PANEL_MISSION_2:Boolean = false;
      
      public var PANEL_CHALLENGE_FD_1:Boolean = false;
      
      public var PANEL_CHALLENGE_FD_2:Boolean = false;
      
      public var PANEL_HUNTING_HOUSE_2:Boolean = false;
      
      public var PANEL_TUTORIAL_2:Boolean = false;
      
      public var PANEL_GIFT_BAG_2:Boolean = false;
      
      public var PANEL_DAILY_WALLFEED:Boolean = false;
      
      public var PANEL_INVITE_CHALLENGE:Boolean = false;
      
      public var FEATURE_PAYMENT_CENTRALIZE:Boolean = false;
      
      public var FEATURE_LEVEL_CONTROL:Boolean = false;
      
      public var disableList:Object;
      
      public var disableMission:Array;
      
      public var disableSkill:Array;
      
      public var disableWeapon:Array;
      
      public var disableBackItem:Array;
      
      public var disableItem:Array;
      
      public var disableBodySet:Array;
      
      public var disableBloodline:Array;
      
      public function FeatureControl()
      {
         disableList = new Object();
         disableMission = new Array();
         disableSkill = new Array();
         disableWeapon = new Array();
         disableBackItem = new Array();
         disableItem = new Array();
         disableBodySet = new Array();
         disableBloodline = new Array();
         super();
         disableList.missions = [];
         disableList.skills = [];
         disableList.weapons = [];
         disableList.backItems = [];
         disableList.items = [];
         disableList.bodySets = [];
         disableList.bloodlines = [];
      }
      
      public function checkFeatureControl(type:String = null) : void
      {
         if(type)
         {
            usedAppType = type;
         }
         else if(isLocal())
         {
            usedAppType = LOCAL_TYPE;
         }
         else
         {
            usedAppType = AppData.type;
         }
         this.checkTheme();
         this.checkLvRange();
         this.checkEvent();
         this.checkExam();
         this.checkFeature();
         this.checkOthers();
      }
      
      public function setFeatureControl() : void
      {
         runLvRangeBlock();
         runExtraBlock();
      }
      
      private function checkTheme() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
               break;
            case AppData.YM:
               break;
            case AppData.RR:
         }
      }
      
      private function checkLvRange() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
               LV_RANGE_01_20 = true;
               LV_RANGE_21_40 = true;
               LV_RANGE_41_60 = true;
               LV_RANGE_61_80 = true;
               break;
            case AppData.YM:
               LV_RANGE_01_20 = true;
               LV_RANGE_21_40 = true;
               LV_RANGE_41_60 = true;
               LV_RANGE_61_80 = false;
               break;
            case AppData.RR:
               LV_RANGE_01_20 = true;
               LV_RANGE_21_40 = true;
               LV_RANGE_41_60 = true;
               LV_RANGE_61_80 = false;
               break;
            default:
               LV_RANGE_01_20 = true;
               LV_RANGE_21_40 = true;
               LV_RANGE_41_60 = true;
               LV_RANGE_61_80 = true;
         }
      }
      
      private function checkEvent() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
               EVENT_HALLOWEEN_PREMIUM = true;
               EVENT_HALLOWEEN_PACKAGE = true;
               EVENT_HALLOWEEN_EVENT = true;
               EVENT_HALLOWEEN_PAY_PET = true;
               EVENT_MOL_CODE = true;
               EVENT_NEW_YEAR = true;
               EVENT_PAYMENT_SKILL = true;
               break;
            case AppData.RR:
               EVENT_RR_EXAM_PROMOTE = true;
               EVENT_RR_DRAGON_BOAT = true;
               break;
            default:
               EVENT_HALLOWEEN_PREMIUM = true;
               EVENT_HALLOWEEN_PACKAGE = true;
               EVENT_HALLOWEEN_EVENT = true;
               EVENT_HALLOWEEN_PAY_PET = true;
         }
      }
      
      private function checkExam() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
               EXAM_CHUNIN = true;
               EXAM_JOUNIN = true;
               EXAM_S_JOUNIN = true;
               EXAM_CHUNIN_PANEL = true;
               EXAM_JOUNIN_PANEL = true;
               EXAM_S_JOUNIN_PANEL = true;
               EXAM_TUTOR_PANEL = true;
               break;
            case AppData.YM:
               EXAM_CHUNIN = true;
               EXAM_JOUNIN = true;
               EXAM_CHUNIN_PANEL = true;
               EXAM_JOUNIN_PANEL = true;
               break;
            case AppData.RR:
               EXAM_CHUNIN = true;
               EXAM_CHUNIN_PANEL = true;
               EXAM_JOUNIN = true;
               EXAM_JOUNIN_PANEL = true;
               break;
            default:
               EXAM_CHUNIN = true;
               EXAM_JOUNIN = true;
               EXAM_S_JOUNIN = true;
               EXAM_CHUNIN_PANEL = true;
               EXAM_JOUNIN_PANEL = true;
         }
      }
      
      private function checkFeature() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
               FEATURE_GIFT = true;
            case AppData.OK:
            case AppData.MP:
               FEATURE_DAILY_TASK = true;
               FEATURE_INVITE_REWARD = true;
               FEATURE_ACHIEVEMENT = true;
               FEATURE_MAIL = true;
               FEATURE_EMBLEM_DAILY_GIFT = true;
               FEATURE_DAILY_SCRATCH = true;
               FEATURE_PVP = true;
               FEATURE_CLAN = true;
               FEATURE_DAILY_LUCK_DRAW = true;
               FEATURE_ESSENCE = true;
               FEATURE_ESSENCE_ITEM500 = true;
               FEATURE_MATERIAL = true;
               FEATURE_REQUEST = true;
               FEATURE_TALENT = true;
               MISSION_GRADE_A = true;
               FEATURE_BLACKSMITH = true;
               FEATURE_RESET_SKILL = true;
               FEATURE_RESET_TALENT = true;
               FEATURE_RENAME_CHAR = true;
               FEATURE_BLOODLINE = true;
               FEATURE_PAYMENT_PACKAGE = true;
               FEATURE_PET_LEARN_SKILL_BY_TOKEN = true;
               FEATURE_UPGRADE_SKILL = true;
               FEATURE_EXPIRY_ITEM = true;
               break;
            case AppData.YM:
               FEATURE_ROULETTE = true;
               FEATURE_DAILY_TASK = true;
               FEATURE_ACHIEVEMENT = true;
               FEATURE_MAIL = true;
               FEATURE_TALENT = true;
               MISSION_GRADE_A = true;
               FEATURE_BLACKSMITH = true;
               FEATURE_RESET_SKILL = true;
               FEATURE_RENAME_CHAR = true;
               FEATURE_BLOODLINE = true;
               break;
            case AppData.RR:
               FEATURE_DAILY_TASK = true;
               FEATURE_GIFT = true;
               FEATURE_INVITE_REWARD = true;
               FEATURE_ACHIEVEMENT = true;
               FEATURE_MAIL = true;
               FEATURE_ROULETTE = true;
               FEATURE_DAILY_SCRATCH = true;
               FEATURE_REQUEST = true;
               FEATURE_NEW_CHAR_DAILY_REWARDS = true;
               FEATURE_FD_KUNAI_CURRENCY = true;
               FEATURE_ESSENCE = true;
               FEATURE_MATERIAL = true;
               FEATURE_PET_LEARN_SKILL_BY_TOKEN = true;
               FEATURE_HUNTING_BOSS_EXTRA_MATERIAL = true;
               FEATURE_SKILL_HALF_GOLD = true;
               FEATURE_DOUBLE_XP = true;
               FEATURE_PVP = true;
               MISSION_GRADE_A = true;
               FEATURE_ESSENCE_ITEM500 = true;
               FEATURE_RESET_SKILL = true;
               FEATURE_BLOODLINE = true;
               FEATURE_TALENT = true;
               FEATURE_SHOPPACKAGE = true;
               FEATURE_EMBLEM_DAILY_GIFT = true;
               FEATURE_DAILY_TASK_2 = true;
               break;
            default:
               FEATURE_TALENT = true;
               FEATURE_PVP = true;
               MISSION_GRADE_A = true;
         }
      }
      
      private function checkOthers() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
               PANEL_RECRUIT_FRIEND_2 = true;
               PANEL_VISIT_FRIEND_2 = true;
               PANEL_MISSION_2 = true;
               PANEL_CHALLENGE_FD_1 = true;
               PANEL_HUNTING_HOUSE_2 = true;
               break;
            case AppData.YM:
               PANEL_RECRUIT_FRIEND_2 = true;
               PANEL_VISIT_FRIEND_2 = true;
               PANEL_MISSION_2 = true;
               PANEL_CHALLENGE_FD_1 = true;
               break;
            case AppData.RR:
               PANEL_RECRUIT_FRIEND_2 = true;
               PANEL_VISIT_FRIEND_2 = true;
               PANEL_MISSION_2 = true;
               PANEL_CHALLENGE_FD_2 = true;
               PANEL_HUNTING_HOUSE_2 = true;
               PANEL_GIFT_BAG_2 = true;
               PANEL_DAILY_WALLFEED = true;
               PANEL_TUTORIAL_2 = true;
               FEATURE_LEVEL_CONTROL = true;
               break;
            default:
               PANEL_RECRUIT_FRIEND_2 = true;
               PANEL_VISIT_FRIEND_2 = true;
               PANEL_MISSION_2 = true;
               PANEL_CHALLENGE_FD_1 = true;
         }
      }
      
      public function runExtraBlock() : void
      {
         switch(usedAppType)
         {
            case AppData.FB:
               break;
            case AppData.MP:
               break;
            case AppData.OK:
               break;
            case AppData.YM:
               disableList.bodySets = [1138,1139];
               disableList.skills = [368,369];
               disableList.items = [29,30,31,32];
               disableList.backItems = [128,130,131,132,146,147];
               break;
            case AppData.RR:
               disableList.bodySets = [1138,1139];
               disableList.skills = [];
               disableList.items = [29,30,31,32];
               break;
            default:
               disableList.bodySets = [1138,1139];
               disableList.skills = [368,369];
         }
         runExtraBlock_Mission();
         runExtraBlock_Skill();
         runExtraBlock_Weapon();
         runExtraBlock_BackItem();
         runExtraBlock_Item();
         runExtraBlock_BodySet();
      }
      
      public function runExtraBlock_Mission() : void
      {
         var i:uint = 0;
         var arr:Array = Central.main.MISSION_DATA_AA.arr;
         for(i = 0; i < disableList.missions.length; i++)
         {
            Central.main.MISSION_DATA_AA.removeById("msn" + disableList.missions[i]);
         }
         if(!EXAM_CHUNIN)
         {
            for(i = 0; i < Data.EXAM_CHUNIN_ARR.length; i++)
            {
               Central.main.MISSION_DATA_AA.removeById(Data.EXAM_CHUNIN_ARR[i]);
            }
         }
         if(!EXAM_JOUNIN)
         {
            for(i = 0; i < Data.EXAM_JOUNIN_ARR.length; i++)
            {
               Central.main.MISSION_DATA_AA.removeById(Data.EXAM_JOUNIN_ARR[i]);
            }
         }
         if(!EXAM_S_JOUNIN)
         {
            for(i = 0; i < Data.EXAM_SPECIAL_JOUNIN_ARR.length; i++)
            {
               Central.main.MISSION_DATA_AA.removeById(Data.EXAM_SPECIAL_JOUNIN_ARR[i]);
            }
         }
      }
      
      public function runExtraBlock_Weapon() : *
      {
         var weaponDataArr:Array = Central.main.WEAPON_DATA.toArray();
         for(var i:int = 0; i < disableList.weapons.length; i++)
         {
            Central.main.WEAPON_DATA.remove("wpn" + disableList.weapons[i]);
         }
      }
      
      public function runExtraBlock_Skill() : *
      {
         var j:int = 0;
         var skillDataArr:Array = Central.main.SKILL_DATA_ARR;
         for(var i:int = 0; i < disableList.skills.length; i++)
         {
            for(j = 0; j < skillDataArr.length; j++)
            {
               if(skillDataArr[j].id == "skill" + disableList.skills[i])
               {
                  skillDataArr.splice(j,1);
                  j--;
               }
            }
         }
         Central.main.SKILL_DATA_ARR = skillDataArr;
      }
      
      public function runExtraBlock_BackItem() : *
      {
         for(var i:int = 0; i < disableList.backItems.length; i++)
         {
            Central.main.BACK_ITEM_DATA.remove("back" + disableList.backItems[i]);
         }
      }
      
      private function runExtraBlock_Item() : void
      {
         for(var i:int = 0; i < disableList.items.length; i++)
         {
            Central.main.ITEM_DATA.remove("item" + disableList.items[i]);
         }
      }
      
      private function runExtraBlock_BodySet() : void
      {
         var key:* = null;
         for(var i:int = 0; i < disableList.bodySets.length; i++)
         {
            if(Central.main.BODY_SET_BOY["set" + disableList.bodySets[i]])
            {
               delete Central.main.BODY_SET_BOY["set" + disableList.bodySets[i]];
            }
            else if(Central.main.BODY_SET_GIRL["set" + disableList.bodySets[i]])
            {
               delete Central.main.BODY_SET_GIRL["set" + disableList.bodySets[i]];
            }
         }
         for(key in Central.main.BODY_SET_BOY)
         {
            if(Central.main.BODY_SET_BOY[key].id == [])
            {
               delete Central.main.BODY_SET_BOY[key];
            }
         }
      }
      
      private function runLvRangeBlock() : void
      {
         var maxLv:int = 0;
         if(!LV_RANGE_01_20)
         {
            maxLv = 0;
         }
         else if(!LV_RANGE_21_40)
         {
            maxLv = 20;
         }
         else if(!LV_RANGE_41_60)
         {
            maxLv = 40;
         }
         else if(!LV_RANGE_61_80)
         {
            maxLv = 60;
         }
         if(maxLv != 0)
         {
            runLvRangeBlock_Mission(maxLv);
            runLvRangeBlock_Skill(maxLv);
            runLvRangeBlock_Weapon(maxLv);
            runLvRangeBlock_BackItem(maxLv);
            runLvRangeBlock_Item(maxLv);
            runLvRangeBlock_BodySet(maxLv);
         }
      }
      
      private function runLvRangeBlock_Mission(maxLv:int) : void
      {
         var mission:Object = null;
         var arr:Array = Central.main.MISSION_DATA_AA.arr;
         for(var i:int = 0; i < arr.length; i++)
         {
            mission = arr[i];
            if(mission.level >= maxLv)
            {
               Central.main.MISSION_DATA_AA.removeById(mission.id);
               i--;
            }
         }
      }
      
      private function runLvRangeBlock_Skill(maxLv:int) : void
      {
         var skillDataArr:Array = Central.main.SKILL_DATA_ARR;
         for(var i:int = 0; i < skillDataArr.length; i++)
         {
            if(skillDataArr[i].level > maxLv)
            {
               skillDataArr.splice(i,1);
               i--;
            }
         }
         Central.main.SKILL_DATA_ARR = skillDataArr;
      }
      
      private function runLvRangeBlock_Weapon(maxLv:int) : void
      {
         var weaponDataArr:Array = Central.main.WEAPON_DATA.toArray();
         for(var i:int = 0; i < weaponDataArr.length; i++)
         {
            if(weaponDataArr[i].level > maxLv)
            {
               Central.main.WEAPON_DATA.remove(weaponDataArr[i].id);
            }
         }
      }
      
      private function runLvRangeBlock_BackItem(maxLv:int) : void
      {
         var backItemDataArr:Array = Central.main.BACK_ITEM_DATA.toArray();
         for(var i:int = 0; i < backItemDataArr.length; i++)
         {
            if(backItemDataArr[i].level > maxLv)
            {
               Central.main.BACK_ITEM_DATA.remove(backItemDataArr[i].id);
            }
         }
      }
      
      private function runLvRangeBlock_Item(maxLv:int) : void
      {
         var itemDataArr:Array = Central.main.ITEM_DATA.toArray();
         for(var i:int = 0; i < itemDataArr.length; i++)
         {
            if(itemDataArr[i].level > maxLv)
            {
               Central.main.ITEM_DATA.remove(itemDataArr[i].id);
            }
         }
      }
      
      private function runLvRangeBlock_BodySet(maxLv:int) : void
      {
         var key:* = null;
         for(key in Central.main.BODY_SET_BOY)
         {
            if(Central.main.BODY_SET_BOY[key].level > maxLv)
            {
               delete Central.main.BODY_SET_BOY[key];
            }
         }
         for(key in Central.main.BODY_SET_GIRL)
         {
            if(Central.main.BODY_SET_GIRL[key].level > maxLv)
            {
               delete Central.main.BODY_SET_GIRL[key];
            }
         }
      }
      
      private function isLocal() : Boolean
      {
         switch(AppData.type)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
            case AppData.YM:
            case AppData.RR:
               return false;
            default:
               return true;
         }
      }
   }
}
