package ninjasaga.data 
{
    public final class InventoryData extends Object
    {
        public function InventoryData()
        {
            super();
            return;
        }

        public static const TYPE_WEAPON:String="weapon";

        public static const TYPE_BODY_SET:String="body_set";

        public static const TYPE_ITEM:String="item";

        public static const TYPE_ESSENCE:String="essence";

        public static const TYPE_MATERIAL:String="material";

        public static const TYPE_BACK_ITEM:String="back";

        public static const TYPE_HAIR:String="hair";

        public static const ITEM_TYPES:Array=[TYPE_WEAPON, TYPE_BODY_SET, TYPE_ITEM, TYPE_BACK_ITEM, TYPE_ESSENCE, TYPE_MATERIAL, TYPE_HAIR];

        public static const TYPE_SKILL:String="skill";

        public static const TYPE_MISSION:String="mission";

        public static const TYPE_DAILY_TASK:String="daily_task";

        public static const TYPE_MAGATAMA:String="magatama";

        public static const TYPE_BLOODLINE:String="bloodline";

        public static const TYPE_SENJUTSU:String="senjutsu";
    }
}
