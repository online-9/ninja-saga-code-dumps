package ninjasaga.data
{
   public final class BloodlineData
   {
      
      public static const EFFECT_CAPTURE:String = "bl_capture";
      
      public static const EFFECT_CLEAR_BUFF:String = "bl_clear_buff";
      
      public static const EFFECT_CONVERT_DMG_HP:String = "bl_convert_dmg_hp";
      
      public static const EFFECT_CONVERT_DMG_CP:String = "bl_convert_dmg_cp";
      
      public static const EFFECT_CRITICAL:String = "bl_critical";
      
      public static const EFFECT_DODGE:String = "bl_dodge";
      
      public static const EFFECT_ACCURATE:String = "bl_accurate";
      
      public static const EFFECT_MAX_CP:String = "bl_max_cp";
      
      public static const EFFECT_MAX_CP_RECOVER:String = "bl_max_cp_recover";
      
      public static const EFFECT_MAX_HP:String = "bl_max_hp";
      
      public static const EFFECT_MERIDIAN_BLOCK:String = "bl_meridians_seal";
      
      public static const EFFECT_MODIFY_COOLDOWN:String = "bl_modify_cooldown";
      
      public static const EFFECT_MODIFY_DAMAGE_ALL:String = "bl_modify_damage_all";
      
      public static const EFFECT_MODIFY_DAMAGE_BYTYPE:String = "bl_modify_damage_bytype";
      
      public static const EFFECT_MODIFY_DAMAGE_CRITICAL:String = "bl_modify_damage_critical";
      
      public static const EFFECT_MODIFY_DEFENCE_ALL:String = "bl_modify_defence_all";
      
      public static const EFFECT_MODIFY_DEFENCE_BYTYPE:String = "bl_modify_defence_bytype";
      
      public static const EFFECT_REFLECT_DAMAGE:String = "bl_reflect_damage";
      
      public static const EFFECT_REFLECT_GENJUTSU:String = "bl_reflect_genjutsu";
      
      public static const EFFECT_SPEED:String = "bl_speed";
      
      public static const EFFECT_STUN:String = "stun";
      
      public static const EFFECT_UPDATE_CP:String = "bl_update_cp";
      
      public static const EFFECT_UPDATE_HP:String = "bl_update_hp";
      
      public static const EFFECT_REACTIVE_DEBUFF_ATTACKER:String = "bl_reactive_debuff_attacker";
      
      public static const EFFECT_REACTIVE_DEBUFF_DEFENDER:String = "bl_reactive_debuff_defender";
      
      public static const EFFECT_BUNDLE:String = "bundle";
      
      public static const EFFECT_RESTRICT_CHARGE:String = "bl_restrict_charge";
      
      public static const EFFECT_EXTRA_CHARGE_RECOVER:String = "bl_extra_charge_recover";
      
      public static const EFFECT_RESIST_DEBUFF:String = "bl_resist_debuff";
      
      public static const EFFECT_DRAIN_HP:String = "bl_drain_hp";
      
      public static const EFFECT_MODIFY_TAIJUTSU_SELFHIT:String = "bl_modify_taijutsu_selfhit";
      
      public static const EFFECT_INTERNAL_INJURY:String = "internal_injury";
      
      public static const EFFECT_RESURRECTION:String = "bl_resurrection";
      
      public static const EFFECT_COPY_JUTSU:String = "bl_copy_jutsu";
      
      public static const EFFECT_TITAN:String = "bl_titan";
      
      public static const EFFECT_EXTRA_CP_USE:String = "bl_extra_cp_use";
      
      public static const EFFECT_EXTREME:String = "bl_extreme";
      
      public static const EFFECT_HALLUCINATIONS:String = "bl_hallucinations";
      
      public static const EFFECT_UPDATE_HP_CP:String = "bl_update_hp_cp";
      
      public static const EFFECT_PET_FREEZE:String = "pet_freeze";
      
      public static const EFFECT_REDUCE_CP:String = "bl_reduce_attacker_cp";
      
      public static const EFFECT_CPDMG:String = "bl_cpdmg";
      
      public static const EFFECT_CPDMG_STUN:String = "bl_cpdmg_stun";
      
      public static const EFFECT_PASSIVE_STUN:String = "bl_passive_stun";
      
      public static const EFFECT_ADD_HP_PASSIVE:String = "bl_add_hp_passive";
      
      public static const EFFECT_BL_SKILL_ITEM_ADD_HP_PER:String = "bl_skill_item_add_hp_per";
      
      public static const EFFECT_HP_BELOW_CP:String = "bl_add_hp_below_cp";
      
      public static const EFFECT_CLEAR_ALL_TARGET_BUFF:String = "bl_clear_all_target_buff";
      
      public static const EFFECT_RESTORE_ALL_PARTY:String = "bl_restore_all_party";
      
      public static const EFFECT_REBORN:String = "bl_reborn";
      
      public static const EFFECT_SKIP_DEAD_CLEAR_DEBUFF:String = "bl_skip_dead_clear_debuff";
      
      public static const EFFECT_DMG_BONUS_AND_DODGE_REDUCTION:String = "bl_dmg_bonus_dodge_reduction";
      
      public static const EFFECT_BL_UPDATE_HP_FIX_NUM:String = "bl_update_hp_fix_num";
      
      public static const EFFECT_MAX_HP_FIX_NUM:String = "bl_max_hp_fix_num";
      
      public static const EFFECT_REDUCE_DMG_BY_CP_PERCENT:String = "reduce_dmg_by_cp_percent";
      
      public static const EFFECT_RESTORE_CP_LT_CPP:String = "bl_restore_cp_lt_cpp";
      
      public static const EFFECT_ABSORB_CP_RESTORE_HP:String = "bl_absorb_cp_restore_hp";
      
      public static const EFFECT_DMG_HP_CP:String = "bl_dmg_hp_cp";
      
      public static const EFFECT_REDUCE_TARGET_CP_BUNDLE:String = "bl_reduce_target_cp_bundle";
      
      public static const EFFECT_ADD_DMG_BONUS_RELATE_CP:String = "bl_add_dmg_bonus_relate_cp";
      
      public static const EFFECT_DMG_REDUCTION:String = "bl_dmg_reduction";
      
      public static const EFFECT_ADD_PURIFY_CHANCE_OVER_CP:String = "bl_add_purify_chance_over_cp";
      
      public static const EFFECT_HP_BONUS_RELATE_CP_PERCENT:String = "bl_hp_bonus_relate_cp_percent";
      
      public static const EFFECT_DMG_CP_AND_STUN:String = "bl_dmg_cp_and_stun";
      
      public static const EFFECT_UPDATE_CP_N_CP_RESTORE_LOCK:String = "bl_update_cp_n_cp_restore_lock";
      
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
      
      public static const SKILL_TYPE_BLOODLINE:uint = 0;
      
      public static const SKILL_TYPE_SECRET:uint = 1;
      
      public static const NOT_STACK_ARRAY:Array = [EFFECT_MERIDIAN_BLOCK,EFFECT_CAPTURE,EFFECT_STUN,EFFECT_BUNDLE,EFFECT_RESTRICT_CHARGE,EFFECT_EXTRA_CHARGE_RECOVER,EFFECT_MODIFY_TAIJUTSU_SELFHIT,EFFECT_INTERNAL_INJURY,EFFECT_TITAN,EFFECT_EXTRA_CP_USE,EFFECT_PET_FREEZE];
      
      public static const BLOODLINE_LEVEL:uint = 40;
      
      public static const SECRET1_LEVEL:uint = 50;
      
      public static const SECRET2_LEVEL:uint = 60;
      
      public static const BLOODLINE_ID_1:String = "bloodline1";
      
      public static const BLOODLINE_ID_2:String = "bloodline2";
      
      public static const BLOODLINE_ID_3:String = "bloodline3";
      
      public static const BLOODLINE_ID_4:String = "bloodline4";
      
      public static const BLOODLINE_ID_5:String = "bloodline5";
      
      public static const BLOODLINE_ID_6:String = "bloodline6";
      
      public static const BLOODLINE_ID_7:String = "bloodline7";
      
      public static const BLOODLINE_ID_8:String = "bloodline8";
      
      public static const BLOODLINE_ID_9:String = "bloodline9";
      
      public static const BLOODLINE_ID_10:String = "bloodline10";
      
      public static const BLOODLINE_ID_11:String = "bloodline11";
      
      public static const BLOODLINE_ID_12:String = "bloodline12";
      
      public static const USER_BLOODLINE_ID_1:uint = 1;
      
      public static const USER_BLOODLINE_ID_2:uint = 2;
      
      public static const USER_BLOODLINE_ID_3:uint = 3;
      
      public static const USER_BLOODLINE_ID_4:uint = 4;
      
      public static const USER_BLOODLINE_ID_5:uint = 5;
      
      public static const USER_BLOODLINE_ID_6:uint = 6;
      
      public static const USER_BLOODLINE_ID_7:uint = 7;
      
      public static const USER_BLOODLINE_ID_8:uint = 8;
      
      public static const USER_BLOODLINE_ID_9:uint = 9;
      
      public static const USER_BLOODLINE_ID_10:uint = 10;
      
      public static const USER_BLOODLINE_ID_11:uint = 11;
      
      public static const USER_BLOODLINE_ID_12:uint = 12;
      
      public static const MAX_SKILL_LEVEL:uint = 10;
      
      public static const CRYSTAL_TO_BP_RATE:Number = 0.01;
      
      public static const CURRENCY_TOKEN:uint = 5;
      
      public static const CURRENCY_BP:uint = 1;
       
      
      public function BloodlineData()
      {
         super();
      }
   }
}
