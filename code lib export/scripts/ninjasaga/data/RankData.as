package ninjasaga.data
{
   public final class RankData
   {
      
      public static const STUDENT:uint = 0;
      
      public static const GENIN:uint = 1;
      
      public static const CHUNIN:uint = 2;
      
      public static const CHUNIN_TALENTED:uint = 3;
      
      public static const JOUNIN:uint = 4;
      
      public static const JOUNIN_TALENTED:uint = 5;
      
      public static const SPECIAL_JOUNIN:uint = 6;
      
      public static const SPECIAL_JOUNIN_TALENTED:uint = 7;
      
      public static const TUTOR:uint = 8;
      
      public static const TUTOR_SENIOR:uint = 9;
      
      public static const GENIN_LEVEL_CAP:uint = 20;
      
      public static const CHUNIN_LEVEL_CAP:uint = 40;
      
      public static const JOUNIN_LEVEL_CAP:uint = 60;
      
      public static const SPECIAL_JOUNIN_LEVEL_CAP:uint = 80;
      
      public static const TUTOR_LEVEL_CAP:uint = 100;
      
      public static const ALL_RANK:Array = [GENIN,CHUNIN,CHUNIN_TALENTED,JOUNIN,JOUNIN_TALENTED,SPECIAL_JOUNIN,SPECIAL_JOUNIN_TALENTED,TUTOR,TUTOR_SENIOR];
      
      public static const RANK_MAP:Array = [TitleData.RANK_STUDENT,TitleData.RANK_GENIN,TitleData.RANK_CHUNIN,TitleData.RANK_TENSAI_CHUNIN,TitleData.RANK_JOUNIN,TitleData.RANK_TENSAI_JOUNIN,TitleData.RANK_SPECIAL_JOUNIN,TitleData.RANK_TENSAI_SPECIAL_JOUNIN,TitleData.RANK_TUTOR,TitleData.RANK_TUTOR_SENIOR];
      
      public static const HP_LIMIT = 99000;
      
      public static const CP_LIMIT = 99000;
      
      public static const SPEED_LIMIT = 100;
      
      public static const WIND_LIMIT = 30;
      
      public static const LIGHTNING_LIMIT = 60;
      
      public static const FIRE_LIMIT = 30;
      
      public static const WATER_LIMIT = 50;
      
      public static const EARTH_LIMIT = 40;
       
      
      public function RankData()
      {
         super();
      }
   }
}
