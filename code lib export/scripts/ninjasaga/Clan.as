package ninjasaga
{
   import ninjasaga.data.ClanData;
   
   public final class Clan
   {
      
      private static var instance:ninjasaga.Clan;
       
      
      public var clanData:Object;
      
      public var buildingData:Array;
      
      public var history:Array;
      
      public var battleClanData:Object;
      
      public var battleBuildingData:Array;
      
      public function Clan(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.Clan
      {
         if(instance == null)
         {
            instance = new ninjasaga.Clan(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function get proc() : ninjasaga.Clan
      {
         if(instance == null)
         {
            instance = new ninjasaga.Clan(new SingletonBlocker());
         }
         return instance;
      }
      
      public function getAttackerBonus(type:String) : Number
      {
         if(this.buildingData == null)
         {
            return 0;
         }
         return this.getBuildingBonus(this.buildingData,type);
      }
      
      public function getDefenderBonus(type:String) : Number
      {
         if(this.battleBuildingData == null)
         {
            return 0;
         }
         return this.getBuildingBonus(this.battleBuildingData,type);
      }
      
      private function getBuildingBonus(data:Array, type:String) : Number
      {
         var i:uint = 0;
         for(i = 0; i < data.length; i++)
         {
            if(ClanData.BUILDING_DATA[int(data[i].id)].bonusType == type)
            {
               return int(data[i].level) * ClanData.BUILDING_DATA[int(data[i].id)].bonus;
            }
         }
         return 0;
      }
   }
}

class SingletonBlocker
{
    
   
   function SingletonBlocker()
   {
      super();
   }
}
