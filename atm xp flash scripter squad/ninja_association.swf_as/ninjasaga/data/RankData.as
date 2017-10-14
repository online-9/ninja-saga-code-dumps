package ninjasaga.data 
{
    public final class RankData extends Object
    {
        public function RankData()
        {
            super();
            return;
        }

        public static const JOUNIN:uint=4;

        public static const CHUNIN_TALENTED:uint=3;

        public static const CHUNIN_LEVEL_CAP:uint=40;

        public static const RANK_MAP:Array=["Student", "Genin", "Chunin", "Tensai Chunin", "Jounin", "Tensai Jounin"];

        public static const CHUNIN:uint=2;

        public static const STUDENT:uint=0;

        public static const GENIN_LEVEL_CAP:uint=20;

        public static const GENIN:uint=1;

        public static const ALL_RANK:Array=[GENIN, CHUNIN, CHUNIN_TALENTED, JOUNIN, JOUNIN_TALENTED];

        public static const JOUNIN_LEVEL_CAP:uint=60;

        public static const JOUNIN_TALENTED:uint=5;
    }
}
