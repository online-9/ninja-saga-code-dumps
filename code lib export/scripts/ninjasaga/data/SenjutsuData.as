package ninjasaga.data
{
   public final class SenjutsuData
   {
      
      public static const EFFECT_SENNIN_MODE:String = "senjutsu_sennin_mode";
      
      public static const EFFECT_SS_MAX_HP:String = "ss_max_hp";
      
      public static const EFFECT_SS_MAX_CP:String = "ss_max_cp";
      
      public static const EFFECT_SS_MAX_HP_CHANGE:String = "ss_max_hp_change";
      
      public static const EFFECT_SS_MAX_CP_CHANGE:String = "ss_max_cp_change";
      
      public static const EFFECT_SS_MAX_CP_CHANGE_EXTRA:String = "ss_max_cp_change_extra";
      
      public static const EFFECT_SS_AGILITY_CHANGE:String = "reduce_agility";
      
      public static const EFFECT_SS_BURN_CP_HP:String = "ss_burn_cp_hp";
      
      public static const EFFECT_SS_DAMAGE_BONUS:String = "ss_damage_bonus";
      
      public static const EFFECT_SS_REDUCE_AGILITY_DMG_BONUS:String = "reduce_agility_dmg_bonus";
      
      public static const EFFECT_SS_SKILL_FIRST_USE_CD_REDUCE:String = "skill_first_use_cd_reduce";
      
      public static const EFFECT_SS_JUSTU_STEAL:String = "justu_steal";
      
      public static const EFFECT_SS_CRITICAL_CHANCE_BONUS:String = "ss_critical_chance_bonus";
      
      public static const EFFECT_SS_CRITICAL_DMG_BONUS:String = "critical_dmg_bonus";
      
      public static const EFFECT_SS_SKIP_BATTLE_TURN:String = "skip_battle_turn";
      
      public static const EFFECT_SS_DODGE_IGNORE:String = "dodge_ignore";
      
      public static const EFFECT_SS_BUNDLE_TALENT:String = "bundle_talent";
      
      public static const EFFECT_SS_BURN_HP_CP_SP:String = "senjutsu_burn_hpcpsp";
      
      public static const EFFECT_SS_IGNORE_DMG:String = "senjutsu_ignore_dmg_effect";
      
      public static const EFFECT_SS_WEAPON_ONLY:String = "weapon_only";
      
      public static const EFFECT_SS_DIVIDE_CHAOS:String = "divide_chaos";
      
      public static const EFFECT_SS_ABSORB_HPTOSP:String = "senjutsu_absorb_hptosp";
      
      public static const EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:String = "ss_critical_n_dodge_reduction";
      
      public static const EFFECT_SS_SPIRIT_MODE:String = "ss_spirit_mode";
      
      public static const NOT_STACK_ARRAY:Array = [EFFECT_SENNIN_MODE];
      
      public static const STATUS_ROUND_START:String = "round_start";
      
      public static const TARGET_SELF:uint = 0;
      
      public static const TARGET_ENEMY:uint = 1;
      
      public static const TARGET_ENEMY_ALL:uint = 2;
      
      public static const TARGET_ARRACKER_DEBUFF:uint = 3;
      
      public static const TARGET_MAIN_CHARACTER_BUFF:uint = 4;
      
      public static const TARGET_SELF_AND_ENEMY_DEBUFF:uint = 5;
      
      public static const PASSIVE_BUFF_IDENTIFIER:uint = 900;
      
      public static const PASSIVE_DEBUFF_IDENTIFIER:uint = 900;
      
      public static const SKILL_TYPE_PASSIVE:uint = 0;
      
      public static const SKILL_TYPE_ACTIVE:uint = 1;
      
      public static const SKILL_TYPE_SENJUTSU:uint = 0;
      
      public static const SENJUTSU_MAX_SP:uint = 1000;
      
      public static const SENJUTSU_MAX_SLOT:int = 8;
      
      public static const SENJUTSU_MAX_SP_INCREMENT:uint = 40;
      
      public static const SENJUTSU_MAX_SKILL_LEVEL:int = 10;
      
      public static const SENJUTSU_LEVEL:uint = 80;
      
      public static const SP_UPDATE_ROUND:String = "sp_update_round";
      
      public static const SP_UPDATE_EXTRA:String = "sp_update_extra";
      
      public static const SP_UPDATE_ROUND_PERCENTAGE:int = 10;
       
      
      public function SenjutsuData()
      {
         super();
      }
   }
}
