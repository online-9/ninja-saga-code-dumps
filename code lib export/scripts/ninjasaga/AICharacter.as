package ninjasaga
{
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import com.utils.NumberUtil;
   import com.utils.Out;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.Data;
   import ninjasaga.dbclass.DBCharacter;
   
   public class AICharacter extends Character
   {
       
      
      public var friendly:Boolean = false;
      
      public function AICharacter(dbChar:DBCharacter)
      {
         super(dbChar);
         this.type = this.TYPE_AICHARACTER;
      }
      
      override public function skillCheck() : void
      {
         var i:int = 0;
         var skillData:Object = null;
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         var equippedSkills:Array = this.getSkillListArr();
         if(equippedSkills.indexOf("skill91") >= 0)
         {
            this.dbChar.character_skills = [];
         }
         else
         {
            for(i = 0; i < equippedSkills.length; )
            {
               skillData = Main.SKILL_DATA[equippedSkills[i]];
               if(skillData)
               {
                  i++;
                  continue;
               }
               this.dbChar.character_skills = [];
               break;
            }
         }
      }
      
      public function aiAction() : void
      {
         var rNum:Number = NaN;
         var randomBloodlineSkillId:uint = 0;
         var BloodlineskillData:Object = null;
         var BloodlineskillData_effect:Object = null;
         var Bloodlinecp:int = 0;
         var canPlay1010:Boolean = false;
         var canPlay1022:Boolean = false;
         var canPlay1046:Boolean = false;
         var Button_Data_Obj:Object = null;
         var btn:Object = null;
         var randomSecretSkillId:uint = 0;
         var SecretskillData:Object = null;
         var SecretskillData_effect:Object = null;
         var Secretcp:int = 0;
         var Button_Data_Obj_secret:Object = null;
         var SecretDMG:int = 0;
         var btn2:Object = null;
         var randomSenjutsuSkillId:uint = 0;
         var SenjutsuskillData:Object = null;
         var SenjutsuskillData_effect:Object = null;
         var Senjutsusp:int = 0;
         var Button_Data_Obj_Senjutsu:Object = null;
         var SenjutsuDMG:int = 0;
         var btn3:Object = null;
         var randomSkillId:uint = 0;
         var allElementArr:Array = null;
         var blockElementObj:Object = null;
         var blockOtherSkillObj:Object = null;
         var i:uint = 0;
         var k:int = 0;
         var m:int = 0;
         trace("rockman>trace senjutsu> AI character>DBCharacterData.SENJUTSU = " + getData(DBCharacterData.SENJUTSU));
         trace("rockman>trace senjutsu> AI character>SenjutsuListArr = " + this.getSenjutsuListArr());
         trace("rockman>trace senjutsu> AI character>bloodline_skill_arr = " + this.getBloodlineListArr());
         trace("rockman>trace senjutsu> AI character>Secret_skill_arr = " + this.getSecretListArr());
         trace("rockman>trace senjutsu> AI character>skills = " + this.getSkillListArr());
         if(this.battleDebuff[BattleData.EFFECT_BUNDLE])
         {
            if(this.battleDebuff[BattleData.EFFECT_BUNDLE].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.SKILL_377])
         {
            if(this.battleDebuff[BattleData.SKILL_377].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_MERIDIANS_SEAL])
         {
            if(this.battleDebuff[BattleData.EFFECT_MERIDIANS_SEAL].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BattleData.EFFECT_ECSTATIC_SOUND])
         {
            if(this.battleDebuff[BattleData.EFFECT_ECSTATIC_SOUND].duration > 0)
            {
               this.setPlayerCommand("weapon_attack");
               return;
            }
         }
         if(this.battleDebuff[BloodlineData.EFFECT_MERIDIAN_BLOCK])
         {
            if(this.battleDebuff[BloodlineData.EFFECT_MERIDIAN_BLOCK].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         if(this.battleBuff[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF])
         {
            if(this.battleBuff[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF].duration > 0)
            {
               this.setPlayerCommand("pass");
               return;
            }
         }
         var bloodline_skill_arr:Array = this.getBloodlineListArr();
         if(this.fuckNoBloodline == true)
         {
            bloodline_skill_arr = [];
         }
         for(i = 0; i < bloodline_skill_arr.length; i++)
         {
            randomBloodlineSkillId = Math.floor(NumberUtil.randomNumber(0,bloodline_skill_arr.length));
            BloodlineskillData = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[randomBloodlineSkillId].skill_id];
            BloodlineskillData_effect = {};
            for(k = 0; k < 10; k++)
            {
               if(BloodlineskillData.effect[k].skill_level == bloodline_skill_arr[randomBloodlineSkillId].level)
               {
                  BloodlineskillData_effect = BloodlineskillData.effect[k];
               }
            }
            Bloodlinecp = int(this.getLevel() * (BloodlineskillData_effect.skill_cp / 100));
            trace("AI Character :: bloodline_skill_arr[randomBloodlineSkillId].skill_id :: " + bloodline_skill_arr[randomBloodlineSkillId].skill_id);
            rNum = NumberUtil.getRandom();
            canPlay1010 = true;
            if(bloodline_skill_arr[randomBloodlineSkillId].skill_id == "1010")
            {
               if(this.isBattleBuffActive(BloodlineData.EFFECT_EXTREME + ".skill1009"))
               {
                  canPlay1010 = true;
               }
               else
               {
                  canPlay1010 = false;
               }
            }
            canPlay1022 = true;
            if(bloodline_skill_arr[randomBloodlineSkillId].skill_id == "1022")
            {
               canPlay1022 = false;
            }
            canPlay1046 = true;
            if(bloodline_skill_arr[randomBloodlineSkillId].skill_id == "1046")
            {
               canPlay1046 = false;
            }
            if(rNum > 0.5 && this.getBattleSkillCooldown(BloodlineskillData.skill_id) <= 0 && this.cp >= Bloodlinecp && canPlay1010 == true && canPlay1022 == true && canPlay1046 == true)
            {
               Button_Data_Obj = {};
               Button_Data_Obj.id = BloodlineskillData.skill_id;
               Button_Data_Obj.dbid = String(BloodlineskillData.skill_id).replace("skill","");
               Button_Data_Obj.name = BloodlineskillData.name;
               Button_Data_Obj.gold = 0;
               Button_Data_Obj.crystal = 0;
               Button_Data_Obj.damage = int(this.getLevel() * (BloodlineskillData_effect.skill_damage / 100));
               Button_Data_Obj.rarity = BloodlineskillData.rarity;
               Button_Data_Obj.swfName = BloodlineskillData.swf_name;
               Button_Data_Obj.description = BloodlineskillData.description;
               Button_Data_Obj.cp = int(this.getLevel() * (BloodlineskillData_effect.skill_cp / 100));
               Button_Data_Obj.cooldown = BloodlineskillData.cooldown;
               Button_Data_Obj.posType = BloodlineskillData.postype;
               Button_Data_Obj.tooltip = BloodlineskillData.tooltip;
               Button_Data_Obj.type = BloodlineskillData.type;
               Button_Data_Obj.effect = BloodlineskillData_effect;
               Button_Data_Obj.level = BloodlineskillData_effect.skill_level;
               Button_Data_Obj.premium = BloodlineskillData.premium;
               Button_Data_Obj.vendor = BloodlineskillData.vendor;
               Button_Data_Obj.train_time = 0;
               Button_Data_Obj.bloodline_id = BloodlineskillData.bloodline_id;
               Button_Data_Obj.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + BloodlineskillData.bloodline_id].type;
               btn = {};
               btn.skillData = Button_Data_Obj;
               this.setPlayerCommand("bloodline",randomBloodlineSkillId,btn);
               return;
            }
         }
         var Secret_skill_arr:Array = this.getSecretListArr();
         for(i = 0; i < Secret_skill_arr.length; i++)
         {
            randomSecretSkillId = Math.floor(NumberUtil.randomNumber(0,Secret_skill_arr.length - 0.001));
            Out.debug(this,"randomSecretSkillId >> " + randomSecretSkillId);
            Out.debug(this,"bl_skill >> " + Secret_skill_arr[randomSecretSkillId]);
            Out.debug(this,"bl_skill_id >> " + Secret_skill_arr[randomSecretSkillId].skill_id);
            SecretskillData = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + Secret_skill_arr[randomSecretSkillId].skill_id];
            SecretskillData_effect = {};
            for(k = 0; k < 10; k++)
            {
               if(SecretskillData.effect[k].skill_level == Secret_skill_arr[randomSecretSkillId].level)
               {
                  SecretskillData_effect = SecretskillData.effect[k];
               }
            }
            Secretcp = int(this.getLevel() * (SecretskillData_effect.skill_cp / 100));
            rNum = NumberUtil.getRandom();
            if(rNum > 0.5 && this.getBattleSkillCooldown(SecretskillData.skill_id) <= 0 && this.cp >= Secretcp)
            {
               Button_Data_Obj_secret = {};
               SecretDMG = 0;
               SecretDMG = int(this.getLevel() * (SecretskillData_effect.skill_damage / 100));
               Button_Data_Obj_secret.id = SecretskillData.skill_id;
               Button_Data_Obj_secret.dbid = String(SecretskillData.skill_id).replace("skill","");
               Button_Data_Obj_secret.name = SecretskillData.name;
               Button_Data_Obj_secret.gold = 0;
               Button_Data_Obj_secret.crystal = 0;
               Button_Data_Obj_secret.damage = SecretDMG;
               Button_Data_Obj_secret.rarity = SecretskillData.rarity;
               Button_Data_Obj_secret.swfName = SecretskillData.swf_name;
               Button_Data_Obj_secret.description = SecretskillData.description;
               Button_Data_Obj_secret.cp = Secretcp;
               Button_Data_Obj_secret.cooldown = SecretskillData.cooldown;
               Button_Data_Obj_secret.posType = SecretskillData.postype;
               Button_Data_Obj_secret.tooltip = SecretskillData.tooltip;
               Button_Data_Obj_secret.type = SecretskillData.type;
               Button_Data_Obj_secret.effect = SecretskillData_effect;
               Button_Data_Obj_secret.level = SecretskillData_effect.skill_level;
               Button_Data_Obj_secret.premium = SecretskillData.premium;
               Button_Data_Obj_secret.vendor = SecretskillData.vendor;
               Button_Data_Obj_secret.train_time = 0;
               Button_Data_Obj_secret.bloodline_id = SecretskillData.bloodline_id;
               Button_Data_Obj_secret.bloodline_type = Central.main.BLOODLINE_DATA["bloodline" + SecretskillData.bloodline_id].type;
               btn2 = {};
               btn2.skillData = Button_Data_Obj_secret;
               this.setPlayerCommand("bloodline",randomSecretSkillId,btn2);
               return;
            }
         }
         var Senjutsu_skill_arr2:Array = this.getSenjutsuListArr();
         var Senjutsu_skill_arr:Array = [];
         for(i = 0; i < Senjutsu_skill_arr2.length; i++)
         {
            if(dbChar[DBCharacterData.SENJUTSU].indexOf("senjutsu_skill" + Senjutsu_skill_arr2[i].skill_id) >= 0)
            {
               Senjutsu_skill_arr.push(Senjutsu_skill_arr2[i]);
            }
         }
         i = 0;
         while(true)
         {
            if(i >= Senjutsu_skill_arr.length)
            {
               var skills:Array = this.getSkillListArr();
               i = 0;
               while(true)
               {
                  if(i < skills.length)
                  {
                     randomSkillId = Math.floor(NumberUtil.randomNumber(0,skills.length));
                     rNum = NumberUtil.getRandom();
                     if(rNum > 0.5 && this.getBattleSkillCooldown(skills[randomSkillId]) <= 0 && this.cp >= Main.SKILL_DATA[skills[randomSkillId]].cp)
                     {
                        if(!(this.hp > this.maxHP * 0.8 && Main.SKILL_DATA[skills[randomSkillId]].effect.type == SkillData.EFFECT_TYPE_HEAL))
                        {
                           if(Main.SKILL_DATA[skills[randomSkillId]].effect.type == BattleData.EFFECT_HEAL_MEMBER)
                           {
                              if(this.friendly == true)
                              {
                                 if(Central.main.getMainChar().hp < Central.main.getMainChar().maxHP * 0.8)
                                 {
                                    break;
                                 }
                                 for(m = 0; m < Battle.partyArr.length; m++)
                                 {
                                    if(!Battle.partyArr[m].isDead && Battle.partyArr[m] != this && Battle.partyArr[m].hp < Battle.partyArr[m].maxHP * 0.8)
                                    {
                                       Battle.setDefender(Battle.partyArr[m]);
                                       this.setPlayerCommand("skill",randomSkillId);
                                       return;
                                    }
                                 }
                              }
                              else
                              {
                                 for(m = 0; m < Battle.enemyArr.length; m++)
                                 {
                                    if(!Battle.enemyArr[m].isDead && Battle.enemyArr[m] != this && Battle.enemyArr[m].hp < Battle.enemyArr[m].maxHP * 0.8)
                                    {
                                       Battle.setDefender(Battle.enemyArr[m]);
                                       this.setPlayerCommand("skill",randomSkillId);
                                       return;
                                    }
                                 }
                              }
                           }
                           else
                           {
                              allElementArr = ["fire","water","wind","earth","lightning"];
                              blockElementObj = {
                                 "fire":"wind",
                                 "wind":"lightning",
                                 "lightning":"earth",
                                 "earth":"water",
                                 "water":"fire"
                              };
                              blockOtherSkillObj = {
                                 "noTaijutsu":"taijutsu",
                                 "noGenjutsu":"genjutsu"
                              };
                              if(String(Main.SKILL_DATA[skills[randomSkillId]].type).indexOf(blockOtherSkillObj[String(Central.battle.getBattleBackground().name)]) < 0)
                              {
                                 if(!(Central.battle.getBattleBackground().name == "noNinjutsu" && allElementArr.indexOf(String(Main.SKILL_DATA[skills[randomSkillId]].type)) >= 0))
                                 {
                                    if(String(Main.SKILL_DATA[skills[randomSkillId]].type).indexOf(blockElementObj[String(Central.battle.getBattleBackground().name)]) < 0)
                                    {
                                       this.setPlayerCommand("skill",randomSkillId);
                                       return;
                                    }
                                 }
                              }
                           }
                        }
                     }
                     i++;
                     continue;
                  }
                  rNum = NumberUtil.getRandom();
                  if(rNum > 0.5 && this.cp < this.maxCP / 2)
                  {
                     this.setPlayerCommand("charge");
                     return;
                  }
                  if(rNum > 0.3 && this.cp < this.maxCP / 3)
                  {
                     this.setPlayerCommand("charge");
                     return;
                  }
                  this.setPlayerCommand("weapon_attack");
                  return;
               }
               Battle.setDefender(Central.main.getMainChar());
               this.setPlayerCommand("skill",randomSkillId);
               return;
            }
            randomSenjutsuSkillId = Math.floor(NumberUtil.randomNumber(0,Senjutsu_skill_arr.length - 0.001));
            SenjutsuskillData = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + Senjutsu_skill_arr[randomSenjutsuSkillId].skill_id];
            Out.debug(this,"sen_skill_id >> " + Senjutsu_skill_arr[randomSenjutsuSkillId].skill_id);
            SenjutsuskillData_effect = {};
            for(k = 0; k < 10; k++)
            {
               if(SenjutsuskillData.effect[k].skill_level == Senjutsu_skill_arr[randomSenjutsuSkillId].level)
               {
                  SenjutsuskillData_effect = SenjutsuskillData.effect[k];
                  break;
               }
            }
            Senjutsusp = 0;
            if(Senjutsu_skill_arr[randomSenjutsuSkillId].skill_id == "3000")
            {
               Senjutsusp = int(this.maxSP);
            }
            else if(isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
            {
               Senjutsusp = 0;
            }
            else
            {
               Senjutsusp = int(SenjutsuskillData_effect.skill_sp);
            }
            rNum = NumberUtil.getRandom();
            if(rNum > 0.5 && this.getBattleSkillCooldown(SenjutsuskillData.skill_id) <= 0 && this.sp >= Senjutsusp)
            {
               break;
            }
            i++;
         }
         Button_Data_Obj_Senjutsu = {};
         SenjutsuDMG = 0;
         SenjutsuDMG = int(this.getLevel() * (SenjutsuskillData_effect.skill_damage / 100));
         Button_Data_Obj_Senjutsu.id = SenjutsuskillData.skill_id;
         Button_Data_Obj_Senjutsu.dbid = String(SenjutsuskillData.skill_id).replace("skill","");
         Button_Data_Obj_Senjutsu.name = SenjutsuskillData.name;
         Button_Data_Obj_Senjutsu.gold = 0;
         Button_Data_Obj_Senjutsu.crystal = 0;
         Button_Data_Obj_Senjutsu.damage = SenjutsuDMG;
         Button_Data_Obj_Senjutsu.rarity = SenjutsuskillData.rarity;
         Button_Data_Obj_Senjutsu.swfName = SenjutsuskillData.swf_name;
         Button_Data_Obj_Senjutsu.description = SenjutsuskillData.description;
         Button_Data_Obj_Senjutsu.sp = Senjutsusp;
         Button_Data_Obj_Senjutsu.cooldown = SenjutsuskillData.cooldown;
         Button_Data_Obj_Senjutsu.posType = SenjutsuskillData.postype;
         Button_Data_Obj_Senjutsu.tooltip = SenjutsuskillData.tooltip;
         Button_Data_Obj_Senjutsu.type = SenjutsuskillData.type;
         Button_Data_Obj_Senjutsu.effect = SenjutsuskillData_effect;
         Button_Data_Obj_Senjutsu.level = SenjutsuskillData_effect.skill_level;
         Button_Data_Obj_Senjutsu.premium = SenjutsuskillData.premium;
         Button_Data_Obj_Senjutsu.vendor = SenjutsuskillData.vendor;
         Button_Data_Obj_Senjutsu.train_time = 0;
         Button_Data_Obj_Senjutsu.senjutsu_id = SenjutsuskillData.senjutsu_id;
         btn3 = {};
         btn3.skillData = Button_Data_Obj_Senjutsu;
         this.setPlayerCommand("senjutsu",randomSenjutsuSkillId,btn3);
      }
      
      public function get rewardGold() : uint
      {
         if(this.getLevel() < 3)
         {
            return 25;
         }
         return this.getLevel() * 10;
      }
      
      public function get rewardXP() : uint
      {
         if(this.getLevel() == 1)
         {
            return 10;
         }
         return this.getLevel() * 5;
      }
      
      public function get rewardConsumable() : Object
      {
         var i:uint = 0;
         var itemDataArr:Array = null;
         var availableConsumables:Array = null;
         if(this.getLevel() >= Main.getMainChar().getLevel() - 1)
         {
            itemDataArr = Central.main.ITEM_DATA.toArray();
            availableConsumables = [];
            for(i = 0; i < itemDataArr.length; i++)
            {
               if(itemDataArr[i].level >= this.getLevel() - Data.BATTLE_REWARDS_CONSUMABLE_LEVEL_RESTRICTION && itemDataArr[i].level <= this.getLevel() && itemDataArr[i].rarity == 1)
               {
                  availableConsumables.push(itemDataArr[i]);
               }
            }
            return availableConsumables[Math.floor(NumberUtil.randomNumber(0,availableConsumables.length - 1.0001))];
         }
         return null;
      }
      
      public function get rewardItem() : Object
      {
         return null;
      }
   }
}
