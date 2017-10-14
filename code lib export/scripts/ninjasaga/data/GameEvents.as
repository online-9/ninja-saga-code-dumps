package ninjasaga.data
{
   public final class GameEvents
   {
      
      public static const GAME_START:String = "GameStart";
      
      public static const MAP_ENTER:String = "EnterMap";
      
      public static const MAP_CLICK:String = "ClickMap";
      
      public static const BATTLE_START:String = "BattleStart";
      
      public static const BATTLE_FINISH:String = "BattleFinish";
      
      public static const BATTLE_WIN:String = "BattleWin";
      
      public static const BATTLE_LOSE:String = "BattleLose";
      
      public static const BATTLE_RUN:String = "BattleRun";
      
      public static const BATTLE_SHOW_ACTION_BAR:String = "BattleShowActionBar";
      
      public static const BATTLE_ATK_HIT:String = "BattleAttackHit";
      
      public static const MAP_MISSION_FINISH:String = "map_mission_finish";
       
      
      public function GameEvents()
      {
         super();
      }
   }
}
