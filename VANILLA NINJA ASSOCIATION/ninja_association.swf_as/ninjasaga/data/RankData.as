package ninjasaga.data 
{
    public final class RankData extends Object
    {
        public function RankData()
        {
            super();
            return;
        }

        public static const STUDENT:uint=0;

        public static const GENIN:uint=1;

        public static const CHUNIN:uint=2;

        public static const CHUNIN_TALENTED:uint=3;

        public static const JOUNIN:uint=4;

        public static const JOUNIN_TALENTED:uint=5;

        public static const SPECIAL_JOUNIN:uint=6;

        public static const SPECIAL_JOUNIN_TALENTED:uint=7;

        public static const TUTOR:uint=8;

        public static const TUTOR_SENIOR:uint=9;

        public static const GENIN_LEVEL_CAP:uint=20;

        public static const CHUNIN_LEVEL_CAP:uint=40;

        public static const JOUNIN_LEVEL_CAP:uint=60;

        public static const SPECIAL_JOUNIN_LEVEL_CAP:uint=80;

        public static const TUTOR_LEVEL_CAP:uint=100;

        public static const ALL_RANK:Array=[GENIN, CHUNIN, CHUNIN_TALENTED, JOUNIN, JOUNIN_TALENTED, SPECIAL_JOUNIN, SPECIAL_JOUNIN_TALENTED, TUTOR, TUTOR_SENIOR];

        public static const RANK_MAP:Array=[ninjasaga.data.TitleData.RANK_STUDENT, ninjasaga.data.TitleData.RANK_GENIN, ninjasaga.data.TitleData.RANK_CHUNIN, ninjasaga.data.TitleData.RANK_TENSAI_CHUNIN, ninjasaga.data.TitleData.RANK_JOUNIN, ninjasaga.data.TitleData.RANK_TENSAI_JOUNIN, ninjasaga.data.TitleData.RANK_SPECIAL_JOUNIN, ninjasaga.data.TitleData.RANK_TENSAI_SPECIAL_JOUNIN, ninjasaga.data.TitleData.RANK_TUTOR, ninjasaga.data.TitleData.RANK_TUTOR_SENIOR];

        public static const HP_LIMIT:int=99000;

        public static const CP_LIMIT:int=99000;

        public static const SPEED_LIMIT:int=100;

        public static const WIND_LIMIT:int=30;

        public static const LIGHTNING_LIMIT:int=60;

        public static const FIRE_LIMIT:int=30;

        public static const WATER_LIMIT:int=50;

        public static const EARTH_LIMIT:int=40;
    }
}
