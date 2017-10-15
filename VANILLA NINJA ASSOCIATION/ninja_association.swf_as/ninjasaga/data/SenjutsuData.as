package ninjasaga.data 
{
    public final class SenjutsuData extends Object
    {
        public function SenjutsuData()
        {
            super();
            return;
        }

        public static const EFFECT_SENNIN_MODE:String="senjutsu_sennin_mode";

        public static const NOT_STACK_ARRAY:Array=[EFFECT_SENNIN_MODE];

        public static const STATUS_ROUND_START:String="round_start";

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

        public static const SKILL_TYPE_SENJUTSU:uint=0;

        public static const SENJUTSU_MAX_SP:uint=1000;

        public static const SENJUTSU_MAX_SLOT:int=8;

        public static const SENJUTSU_MAX_SP_INCREMENT:uint=40;

        public static const SENJUTSU_MAX_SKILL_LEVEL:int=10;

        public static const SENJUTSU_LEVEL:uint=80;

        public static const SP_UPDATE_ROUND:String="sp_update_round";

        public static const SP_UPDATE_EXTRA:String="sp_update_extra";

        public static const SP_UPDATE_ROUND_PERCENTAGE:int=10;
    }
}
