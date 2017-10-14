package ninjasaga.language
{
   import flash.display.MovieClip;
   import ninjasaga.data.MissionDetail;
   import ninjasaga.data.HairData;
   import ninjasaga.data.EnemyData;
   
   public class DataLibraryEN extends MovieClip
   {
       
      
      public function DataLibraryEN()
      {
         super();
      }
      
      public function DataLibrary() : *
      {
      }
      
      private function get SystemData() : *
      {
         return SystemDataEN;
      }
      
      public function getMissionDetail() : Object
      {
         return MissionDetail.getData();
      }
      
      public function getHairData(param1:uint) : Array
      {
         var _loc2_:Array = HairData.getData();
         return _loc2_[param1];
      }
      
      public function getHairDetailData() : Object
      {
         return this.SystemData.HAIR;
      }
      
      public function getWeapon() : Object
      {
         return this.SystemData.WEAPON;
      }
      
      public function getSkill() : Object
      {
         return this.SystemData.SKILL;
      }
      
      public function getBack_item() : Object
      {
         return this.SystemData.BACK_ITEM;
      }
      
      public function getAccessory() : Object
      {
         return this.SystemData.ACCESSORY;
      }
      
      public function getGearset() : Object
      {
         return this.SystemData.GEAR_SET;
      }
      
      public function getBloodline() : Object
      {
         return this.SystemData.BLOODLINE;
      }
      
      public function getBloodlineSkill() : Object
      {
         return this.SystemData.BLOODLINE_SKILL;
      }
      
      public function getSenjutsu() : Object
      {
         return this.SystemData.SENJUTSU;
      }
      
      public function getSenjutsuSkill() : Object
      {
         return this.SystemData.SENJUTSU_SKILL;
      }
      
      public function getBossEnemy() : Object
      {
         return this.SystemData.ENEMY;
      }
      
      public function getPet() : Object
      {
         return this.SystemData.PET;
      }
      
      public function getWallfeed() : Object
      {
         return this.SystemData.WALLFEED;
      }
      
      public function getBodySet(param1:uint) : Object
      {
         if(param1 == 0)
         {
            return this.SystemData.BODY_SET_BOY;
         }
         if(param1 == 1)
         {
            return this.SystemData.BODY_SET_GIRL;
         }
         return null;
      }
      
      public function getItem() : Object
      {
         return this.SystemData.ITEM;
      }
      
      public function getEnemy() : Class
      {
         return EnemyData;
      }
      
      public function getAchievement() : Object
      {
         return AchievementDataEN.ACHIEVEMENT_DATA;
      }
      
      public function getStory() : Class
      {
         return StoryDataEN;
      }
   }
}
