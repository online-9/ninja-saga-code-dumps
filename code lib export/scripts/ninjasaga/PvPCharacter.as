package ninjasaga
{
   import ninjasaga.data.InventoryData;
   import com.utils.Out;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.dbclass.DBCharacter;
   
   public class PvPCharacter extends Character
   {
       
      
      public function PvPCharacter(dbChar:DBCharacter)
      {
         super(dbChar);
         this.type = this.TYPE_PVPCHARACTER;
         this.initClassSkill();
      }
      
      private function initClassSkill() : void
      {
         var invSkills:Array = this.getInventory(InventoryData.TYPE_SKILL);
         for(var i:int = 0; i < invSkills.length; i++)
         {
            if(Central.main.SKILL_DATA[invSkills[i]] == null)
            {
               Out.error(this,"skill not exist :: " + invSkills[i]);
               this.removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
               this.databaseCharacter[DBCharacterData.SKILLS] = [];
            }
            else if(int(Central.main.SKILL_DATA[invSkills[i]].special_class) > 0)
            {
               if(int(Central.main.SKILL_DATA[invSkills[i]].special_class) == this.getData(DBCharacterData.CONTROL))
               {
                  this.setClassSkillListArr(invSkills[i]);
                  this.removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
               }
               else
               {
                  Out.error(this,"Class Skill not match :: " + invSkills[i]);
               }
            }
         }
      }
      
      override public function skillCheck() : void
      {
      }
   }
}
