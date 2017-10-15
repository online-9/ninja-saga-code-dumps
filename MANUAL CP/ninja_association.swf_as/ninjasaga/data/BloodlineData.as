package ninjasaga.data 
{
    public final class BloodlineData extends Object
    {
        public function BloodlineData()
        {
            super();
            return;
        }

        public static const EFFECT_CAPTURE:String="bl_capture";

        public static const EFFECT_CLEAR_BUFF:String="bl_clear_buff";

        public static const EFFECT_CONVERT_DMG_HP:String="bl_convert_dmg_hp";

        public static const EFFECT_CONVERT_DMG_CP:String="bl_convert_dmg_cp";

        public static const EFFECT_CRITICAL:String="bl_critical";

        public static const EFFECT_DODGE:String="bl_dodge";

        public static const EFFECT_ACCURATE:String="bl_accurate";

        public static const EFFECT_MAX_CP:String="bl_max_cp";

        public static const EFFECT_MAX_CP_RECOVER:String="bl_max_cp_recover";

        public static const EFFECT_MAX_HP:String="bl_max_hp";

        public static const EFFECT_MERIDIAN_BLOCK:String="bl_meridians_seal";

        public static const EFFECT_MODIFY_COOLDOWN:String="bl_modify_cooldown";

        public static const EFFECT_MODIFY_DAMAGE_ALL:String="bl_modify_damage_all";

        public static const EFFECT_MODIFY_DAMAGE_BYTYPE:String="bl_modify_damage_bytype";

        public static const EFFECT_MODIFY_DAMAGE_CRITICAL:String="bl_modify_damage_critical";

        public static const EFFECT_MODIFY_DEFENCE_ALL:String="bl_modify_defence_all";

        public static const EFFECT_MODIFY_DEFENCE_BYTYPE:String="bl_modify_defence_bytype";

        public static const EFFECT_REFLECT_DAMAGE:String="bl_reflect_damage";

        public static const EFFECT_REFLECT_GENJUTSU:String="bl_reflect_genjutsu";

        public static const EFFECT_SPEED:String="bl_speed";

        public static const EFFECT_STUN:String="stun";

        public static const EFFECT_UPDATE_CP:String="bl_update_cp";

        public static const EFFECT_UPDATE_HP:String="bl_update_hp";

        public static const EFFECT_REACTIVE_DEBUFF_ATTACKER:String="bl_reactive_debuff_attacker";

        public static const EFFECT_REACTIVE_DEBUFF_DEFENDER:String="bl_reactive_debuff_defender";

        public static const EFFECT_BUNDLE:String="bundle";

        public static const EFFECT_RESTRICT_CHARGE:String="bl_restrict_charge";

        public static const EFFECT_EXTRA_CHARGE_RECOVER:String="bl_extra_charge_recover";

        public static const EFFECT_RESIST_DEBUFF:String="bl_resist_debuff";

        public static const EFFECT_DRAIN_HP:String="bl_drain_hp";

        public static const EFFECT_MODIFY_TAIJUTSU_SELFHIT:String="bl_modify_taijutsu_selfhit";

        public static const EFFECT_INTERNAL_INJURY:String="internal_injury";

        public static const EFFECT_RESURRECTION:String="bl_resurrection";

        public static const EFFECT_COPY_JUTSU:String="bl_copy_jutsu";

        public static const EFFECT_TITAN:String="bl_titan";

        public static const EFFECT_EXTRA_CP_USE:String="bl_extra_cp_use";

        public static const EFFECT_EXTREME:String="bl_extreme";

        public static const EFFECT_HALLUCINATIONS:String="bl_hallucinations";

        public static const EFFECT_UPDATE_HP_CP:String="bl_update_hp_cp";

        public static const EFFECT_PET_FREEZE:String="pet_freeze";

        public static const EFFECT_REDUCE_CP:String="bl_reduce_attacker_cp";

        public static const TARGET_SELF:uint=0;

        public static const TARGET_ENEMY:uint=1;

        public static const TARGET_ENEMY_ALL:uint=2;

        public static const TARGET_ARRACKER_DEBUFF:uint=3;

        public static const TARGET_MAIN_CHARACTER_BUFF:uint=4;

        public static const TARGET_SELF_AND_ENEMY_DEBUFF:uint=5;

        public static const PASSIVE_BUFF_IDENTIFIER:uint=900;

        public static const PASSIVE_DEBUFF_IDENTIFIER:uint=900;

        public static const SKILL_TYPE_PASSIVE:uint=0;

        public static const SKILL_TYPE_ACTIVE:uint=1;

        public static const SKILL_TYPE_BLOODLINE:uint=0;

        public static const SKILL_TYPE_SECRET:uint=1;

        public static const NOT_STACK_ARRAY:Array=[EFFECT_MERIDIAN_BLOCK, EFFECT_CAPTURE, EFFECT_STUN, EFFECT_BUNDLE, EFFECT_RESTRICT_CHARGE, EFFECT_EXTRA_CHARGE_RECOVER, EFFECT_MODIFY_TAIJUTSU_SELFHIT, EFFECT_INTERNAL_INJURY, EFFECT_TITAN, EFFECT_EXTRA_CP_USE, EFFECT_PET_FREEZE];

        public static const BLOODLINE_LEVEL:uint=40;

        public static const SECRET1_LEVEL:uint=50;

        public static const SECRET2_LEVEL:uint=60;

        public static const BLOODLINE_ID_1:String="bloodline1";

        public static const BLOODLINE_ID_2:String="bloodline2";

        public static const BLOODLINE_ID_3:String="bloodline3";

        public static const BLOODLINE_ID_4:String="bloodline4";

        public static const BLOODLINE_ID_5:String="bloodline5";

        public static const BLOODLINE_ID_6:String="bloodline6";

        public static const BLOODLINE_ID_7:String="bloodline7";

        public static const BLOODLINE_ID_8:String="bloodline8";

        public static const USER_BLOODLINE_ID_1:uint=1;

        public static const USER_BLOODLINE_ID_2:uint=2;

        public static const USER_BLOODLINE_ID_3:uint=3;

        public static const USER_BLOODLINE_ID_4:uint=4;

        public static const USER_BLOODLINE_ID_5:uint=5;

        public static const USER_BLOODLINE_ID_6:uint=6;

        public static const USER_BLOODLINE_ID_7:uint=7;

        public static const USER_BLOODLINE_ID_8:uint=8;

        public static const MAX_SKILL_LEVEL:uint=10;

        public static const CRYSTAL_TO_BP_RATE:Number=0.01;

        public static const CURRENCY_TOKEN:uint=5;

        public static const CURRENCY_BP:uint=1;
    }
}
