package ninjasaga.data 
{
    public final class SkillData extends Object
    {
        public function SkillData()
        {
            super();
            return;
        }

        public static const TYPE_FIRE:String="fire";

        public static const TYPE_WIND:String="wind";

        public static const TYPE_LIGHTNING:String="lightning";

        public static const TYPE_WATER:String="water";

        public static const TYPE_EARTH:String="earth";

        public static const TYPE_TAIJUTSU:String="taijutsu";

        public static const TYPE_GENJUTSU:String="genjutsu";

        public static const ALL_NINJUTSU_TYPES:Array=[TYPE_FIRE, TYPE_WIND, TYPE_LIGHTNING, TYPE_WATER, TYPE_EARTH];

        public static const EFFECT_TYPE_HEAL:String="heal";

        public static const EFFECT_HALFHP_DAMAGE_REDUCTION:String="halfhp_damage_reduction";

        public static const TARGET_SELF:int=1;

        public static const TARGET_HOSTILE:int=2;

        public static const TARGET_FRIENDLY:int=3;

        public static const TARGET_SINGLE_FRIENDLY:int=4;

        public static const NATURE_BUFF:int=1;

        public static const NATURE_DEBUFF:int=2;
    }
}
