package ninjasaga.data
{
   import com.utils.NumberUtil;
   import ninjasaga.Central;
   import com.utils.Out;
   
   public final class Formula
   {
       
      
      public function Formula()
      {
         super();
      }
      
      public static function calcDamage(_weapon:Object) : int
      {
         var damage:Number = _weapon.damage;
         return randomizeValue(damage);
      }
      
      public static function randomizeValue(value:int) : int
      {
         var deviation:Number = 0.2;
         var min:Number = value - value * deviation;
         var max:Number = value + value * deviation;
         return Math.round(NumberUtil.randomNumber(min,max));
      }
      
      public static function calcAgility(char:*, BLOODLINE_SKILL_DATA_ARR:Array = null, SENJUTSU_SKILL_DATA_ARR:Array = null) : int
      {
         var tmpEffect:Object = null;
         var charBackItem:Object = null;
         var charWeapon:Object = null;
         var charAccessory:Object = null;
         var gearObj:Object = null;
         var key:* = null;
         var charGearset:Object = null;
         var setEffect:Object = null;
         var Chr_Bloodline_Skill:Array = null;
         var i:int = 0;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var Chr_Senjutsu_Skill:Array = null;
         var result:int = int(char.getData(DBCharacterData.AGILITY)) + int((char.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_AGILITY) + int(char.getData(DBCharacterData.WIND));
         var buff:Object = char.getBattleBuff();
         if(buff[BattleData.EFFECT_AGILITY_BONUS])
         {
            if(buff[BattleData.EFFECT_AGILITY_BONUS].duration > 0)
            {
               result = result + int(buff[BattleData.EFFECT_AGILITY_BONUS].amount);
            }
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_AGI_REDUCTION))
         {
            result = result - Math.round(result * int(char.getBattleDebuff()[BattleData.EFFECT_AGI_REDUCTION].amount));
         }
         if(char.getBackItem())
         {
            charBackItem = Central.main.BACK_ITEM_DATA.find(char.getBackItem());
            if(charBackItem)
            {
               for each(tmpEffect in charBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case "effect_agility":
                        result = result + tmpEffect.amount;
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getWeapon())
         {
            charWeapon = Central.main.WEAPON_DATA.find(char.getWeapon());
            if(charWeapon)
            {
               for each(tmpEffect in charWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case "effect_agility":
                        result = result + tmpEffect.amount;
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getAccessory())
         {
            charAccessory = Central.main.ACCESSORY_DATA.find(char.getAccessory());
            if(charAccessory)
            {
               for each(tmpEffect in charAccessory.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case "effect_agility":
                        result = result + tmpEffect.amount;
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getGearset())
         {
            gearObj = char.getGearset();
            for(key in gearObj)
            {
               charGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = charGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case "effect_agility":
                        result = result + setEffect.amount;
                  }
               }
            }
         }
         var Bonus:int = 0;
         if(BLOODLINE_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Bloodline_Skill = char.getData(DBCharacterData.BLOODLINE_SKILL);
            if(Chr_Bloodline_Skill)
            {
               for(i = 0; i < Chr_Bloodline_Skill.length; i++)
               {
                  skill_id = Chr_Bloodline_Skill[i].skill_id;
                  level = Chr_Bloodline_Skill[i].level;
                  for(k = 0; k < BLOODLINE_SKILL_DATA_ARR.length; k++)
                  {
                     if(BLOODLINE_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && BLOODLINE_SKILL_DATA_ARR[k].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        effect = BLOODLINE_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                              if(effect[j].effect_type_1 == BloodlineData.EFFECT_SPEED)
                              {
                                 Bonus = Bonus + Math.round(effect[j].effect_amount_1 / 100 * result);
                              }
                              if(effect[j].effect_type_2 == BloodlineData.EFFECT_SPEED)
                              {
                                 Bonus = Bonus + Math.round(effect[j].effect_amount_2 / 100 * result);
                              }
                              if(effect[j].effect_type_3 == BloodlineData.EFFECT_SPEED)
                              {
                                 Bonus = Bonus + Math.round(effect[j].effect_amount_3 / 100 * result);
                              }
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         var senjutsuBonus:int = 0;
         if(SENJUTSU_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Senjutsu_Skill = char.getData(DBCharacterData.SENJUTSU_SKILL);
            if(Chr_Senjutsu_Skill)
            {
               for(i = 0; i < Chr_Senjutsu_Skill.length; i++)
               {
                  skill_id = Chr_Senjutsu_Skill[i].skill_id;
                  level = Chr_Senjutsu_Skill[i].level;
                  for(k = 0; k < SENJUTSU_SKILL_DATA_ARR.length; k++)
                  {
                     if(SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        effect = SENJUTSU_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         result = result + Bonus + senjutsuBonus;
         return result;
      }
      
      public static function calcCritical(char:*, BLOODLINE_SKILL_DATA_ARR:Array = null, SENJUTSU_SKILL_DATA_ARR:Array = null) : Number
      {
         var key:* = null;
         var rNum:Number = NaN;
         var senjutsuBonus:int = 0;
         var Chr_Bloodline_Skill:Array = null;
         var i:int = 0;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var Chr_Senjutsu_Skill:Array = null;
         var result:Number = Central.main.coreData.BASE_CRITICAL_CHANCE + Number(int(char.getData(DBCharacterData.LIGHTNING)) * 4 / 1000);
         var buff:Object = char.getBattleBuff();
         if(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS])
         {
            if(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS].duration > 0)
            {
               result = result + Number(int(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS].amount) / 100);
            }
         }
         if(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON])
         {
            if(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON].duration > 0)
            {
               result = result + int(buff[BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON].amount) / 100;
            }
         }
         if(buff[BattleData.EFFECT_FRENZY])
         {
            if(buff[BattleData.EFFECT_FRENZY].duration > 0)
            {
               result = result + 0.2;
            }
         }
         if(buff[BattleData.EFFECT_BUNNY_FRENZY])
         {
            if(buff[BattleData.EFFECT_BUNNY_FRENZY].duration > 0)
            {
               result = result + 0.25;
            }
         }
         if(buff[BattleData.EFFECT_BATTLE_BUNNY_FRENZY])
         {
            if(buff[BattleData.EFFECT_BATTLE_BUNNY_FRENZY].duration > 0)
            {
               result = result + 0.25;
            }
         }
         if(buff[BattleData.EFFECT_THUNDERSTORM_MODE])
         {
            if(buff[BattleData.EFFECT_THUNDERSTORM_MODE].duration > 0)
            {
               result = result + Number(int(buff[BattleData.EFFECT_THUNDERSTORM_MODE].amount) / 100);
            }
         }
         var Debuff:Object = char.getBattleDebuff();
         if(Debuff[BattleData.EFFECT_DARK_CURSE])
         {
            if(Debuff[BattleData.EFFECT_DARK_CURSE].duration > 0)
            {
               result = result - 0.1;
            }
         }
         if(buff[BattleData.EFFECT_PET_ENERGIZE] && buff[BattleData.EFFECT_PET_ENERGIZE].duration > 0)
         {
            result = result + buff[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
         }
         if(Debuff[BattleData.EFFECT_PET_DISORIENTED] && Debuff[BattleData.EFFECT_PET_DISORIENTED].duration > 0)
         {
            result = result - Debuff[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
         }
         if(Debuff[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE] && Debuff[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE].duration > 0)
         {
            result = result - Debuff[BattleData.EFFECT_DECREASE_CRITICAL_CHANCE].amount / 100;
         }
         var Bonus:Number = 0;
         if(BLOODLINE_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Bloodline_Skill = char.getData(DBCharacterData.BLOODLINE_SKILL);
            if(Chr_Bloodline_Skill)
            {
               for(i = 0; i < Chr_Bloodline_Skill.length; i++)
               {
                  skill_id = Chr_Bloodline_Skill[i].skill_id;
                  level = Chr_Bloodline_Skill[i].level;
                  for(k = 0; k < BLOODLINE_SKILL_DATA_ARR.length; k++)
                  {
                     if(BLOODLINE_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && BLOODLINE_SKILL_DATA_ARR[k].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        effect = BLOODLINE_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                              if(effect[j].effect_type_1 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_1) / 100;
                              }
                              if(effect[j].effect_type_2 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_2) / 100;
                              }
                              if(effect[j].effect_type_3 == BloodlineData.EFFECT_CRITICAL)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_3) / 100;
                              }
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         var CritBonus:Number = 0;
         var BLkey:String = "";
         var BLkeyArr:Array = [];
         for(key in buff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(buff[key])
            {
               if(buff[key].duration > 0 && buff[key].duration < BloodlineData.PASSIVE_BUFF_IDENTIFIER)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && buff[key].chancetoeffect && buff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= buff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_CRITICAL:
                              CritBonus = CritBonus + Number(buff[key].amount) / 100;
                              continue;
                           default:
                              continue;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               else
               {
                  continue;
               }
            }
            else
            {
               continue;
            }
         }
         for(key in Debuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(Debuff[key])
            {
               if(Debuff[key].duration > 0 && Debuff[key].duration < BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && Debuff[key].chancetoeffect && Debuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= Debuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_CRITICAL:
                              CritBonus = CritBonus + Number(Debuff[key].amount) / 100;
                              continue;
                           default:
                              continue;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               else
               {
                  continue;
               }
            }
            else
            {
               continue;
            }
         }
         senjutsuBonus = 0;
         if(SENJUTSU_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Senjutsu_Skill = char.getData(DBCharacterData.SENJUTSU_SKILL);
            if(Chr_Senjutsu_Skill)
            {
               for(i = 0; i < Chr_Senjutsu_Skill.length; i++)
               {
                  skill_id = Chr_Senjutsu_Skill[i].skill_id;
                  level = Chr_Senjutsu_Skill[i].level;
                  for(k = 0; k < SENJUTSU_SKILL_DATA_ARR.length; k++)
                  {
                     if(SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        effect = SENJUTSU_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         result = result + Bonus + CritBonus + senjutsuBonus;
         result = Number(result.toFixed(3));
         if(result < 0)
         {
            result = 0;
         }
         return result;
      }
      
      public static function calcDodge(char:*, BLOODLINE_SKILL_DATA_ARR:Array = null, SENJUTSU_SKILL_DATA_ARR:Array = null) : Number
      {
         var key:* = null;
         var rNum:Number = NaN;
         var senjutsuBonus:int = 0;
         var Chr_Bloodline_Skill:Array = null;
         var i:int = 0;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var Chr_Senjutsu_Skill:Array = null;
         var result:Number = Central.main.coreData.BASE_DODGE_CHANCE + Number(int(char.getData(DBCharacterData.WIND)) * 4 / 1000);
         var buff:Object = char.getBattleBuff();
         if(buff[BattleData.EFFECT_DODGE_BONUS])
         {
            if(buff[BattleData.EFFECT_DODGE_BONUS].duration > 0)
            {
               result = result + Number(int(buff[BattleData.EFFECT_DODGE_BONUS].amount) / 100);
            }
         }
         if(buff[BattleData.EFFECT_PET_DODGE_BONUS])
         {
            if(buff[BattleData.EFFECT_PET_DODGE_BONUS].duration > 0)
            {
               result = result + Number(int(buff[BattleData.EFFECT_PET_DODGE_BONUS].amount) / 100);
            }
         }
         for(var w:int = 0; w < BattleData.WIND_PEACE_ARR.length; w++)
         {
            if(buff[BattleData.WIND_PEACE_ARR[w]])
            {
               if(buff[BattleData.WIND_PEACE_ARR[w]].duration > 0)
               {
                  result = result + Number(int(buff[BattleData.WIND_PEACE_ARR[w]].amount) / 100);
               }
            }
         }
         var Debuff:Object = char.getBattleDebuff();
         if(Debuff[BattleData.EFFECT_DARK_CURSE])
         {
            if(Debuff[BattleData.EFFECT_DARK_CURSE].duration > 0)
            {
               result = result - 0.1;
            }
         }
         if(Debuff[BattleData.SKILL_236])
         {
            if(Debuff[BattleData.SKILL_236].duration > 0)
            {
               result = result - Number(int(Debuff[BattleData.SKILL_236].amount) / 100);
            }
         }
         if(buff[BattleData.EFFECT_PET_ENERGIZE] && buff[BattleData.EFFECT_PET_ENERGIZE].duration > 0)
         {
            result = result + buff[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
         }
         if(Debuff[BattleData.EFFECT_PET_DISORIENTED] && Debuff[BattleData.EFFECT_PET_DISORIENTED].duration > 0)
         {
            result = result - Debuff[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
         }
         var Bonus:Number = 0;
         if(BLOODLINE_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Bloodline_Skill = char.getData(DBCharacterData.BLOODLINE_SKILL);
            if(Chr_Bloodline_Skill)
            {
               for(i = 0; i < Chr_Bloodline_Skill.length; i++)
               {
                  skill_id = Chr_Bloodline_Skill[i].skill_id;
                  level = Chr_Bloodline_Skill[i].level;
                  for(k = 0; k < BLOODLINE_SKILL_DATA_ARR.length; k++)
                  {
                     if(BLOODLINE_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && BLOODLINE_SKILL_DATA_ARR[k].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        effect = BLOODLINE_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                              if(effect[j].effect_type_1 == BloodlineData.EFFECT_DODGE)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_1) / 100;
                              }
                              if(effect[j].effect_type_2 == BloodlineData.EFFECT_DODGE)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_2) / 100;
                              }
                              if(effect[j].effect_type_3 == BloodlineData.EFFECT_DODGE)
                              {
                                 Bonus = Bonus + Number(effect[j].effect_amount_3) / 100;
                              }
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         var DodgeBonus:Number = 0;
         var BLkey:String = "";
         var BLkeyArr:Array = [];
         for(key in buff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(buff[key])
            {
               if(buff[key].duration > 0 && buff[key].duration < BloodlineData.PASSIVE_BUFF_IDENTIFIER)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && buff[key].chancetoeffect && buff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= buff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_DODGE:
                              DodgeBonus = DodgeBonus + Number(buff[key].amount) / 100;
                              continue;
                           case BloodlineData.EFFECT_CAPTURE:
                              DodgeBonus = DodgeBonus + Number(buff[key].amount) / 100;
                              continue;
                           default:
                              continue;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               else
               {
                  continue;
               }
            }
            else
            {
               continue;
            }
         }
         for(key in Debuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(Debuff[key])
            {
               if(Debuff[key].duration > 0 && Debuff[key].duration < BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && Debuff[key].chancetoeffect && Debuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= Debuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_DODGE:
                              DodgeBonus = DodgeBonus + Number(Debuff[key].amount) / 100;
                              continue;
                           case BloodlineData.EFFECT_CAPTURE:
                              DodgeBonus = DodgeBonus + Number(Debuff[key].amount) / 100;
                              continue;
                           default:
                              continue;
                        }
                     }
                     else
                     {
                        continue;
                     }
                  }
                  else
                  {
                     continue;
                  }
               }
               else
               {
                  continue;
               }
            }
            else
            {
               continue;
            }
         }
         senjutsuBonus = 0;
         if(SENJUTSU_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Senjutsu_Skill = char.getData(DBCharacterData.SENJUTSU_SKILL);
            if(Chr_Senjutsu_Skill)
            {
               for(i = 0; i < Chr_Senjutsu_Skill.length; i++)
               {
                  skill_id = Chr_Senjutsu_Skill[i].skill_id;
                  level = Chr_Senjutsu_Skill[i].level;
                  for(k = 0; k < SENJUTSU_SKILL_DATA_ARR.length; k++)
                  {
                     if(SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        effect = SENJUTSU_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         result = result + Bonus + DodgeBonus + senjutsuBonus;
         result = Number(result.toFixed(3));
         if(result < 0)
         {
            result = 0;
         }
         return result;
      }
      
      public static function calcHP(char:*, BLOODLINE_SKILL_DATA_ARR:Array = null, SENJUTSU_SKILL_DATA_ARR:Array = null) : uint
      {
         var k:int = 0;
         var j:int = 0;
         var tmpEffect:Object = null;
         var i:int = 0;
         var rNum:Number = NaN;
         var clanBonus:Number = NaN;
         var charWeapon:Object = null;
         var charBackItem:Object = null;
         var charAccessory:Object = null;
         var Chr_Senjutsu_Skill:Array = null;
         var skill_id:int = 0;
         var level:int = 0;
         var effect:Array = null;
         var earthBonus:uint = 30;
         var hp:int = Math.round(char.getData(DBCharacterData.MAX_HP)) + Math.round((char.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_HP) + Math.round(char.getData(DBCharacterData.EARTH) * earthBonus);
         var clanEffect:Object = char.getClanEffect();
         var baseHP:int = 0;
         if(clanEffect)
         {
            if(clanEffect[ClanData.CLAN_HP_BONUS])
            {
               clanBonus = int(clanEffect[ClanData.CLAN_HP_BONUS].amount) / 100;
               baseHP = baseHP + Math.round(hp * clanBonus);
            }
         }
         if(char.getWeapon())
         {
            charWeapon = Central.main.WEAPON_DATA.find(char.getWeapon());
            if(charWeapon)
            {
               for each(tmpEffect in charWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_HP:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseHP = baseHP + tmpEffect.amount;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getBackItem())
         {
            charBackItem = Central.main.BACK_ITEM_DATA.find(char.getBackItem());
            if(charBackItem)
            {
               for each(tmpEffect in charBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_HP_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseHP = baseHP + Math.round(hp * tmpEffect.amount / 100);
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getAccessory())
         {
            charAccessory = Central.main.ACCESSORY_DATA.find(char.getAccessory());
            if(charAccessory)
            {
               for each(tmpEffect in charAccessory.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_HP_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseHP = baseHP + Math.round(hp * tmpEffect.amount / 100);
                        }
                        Out.debug("","accessory EFFECT_MAX_HP_PRESENT");
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getBloodlineEffect())
         {
            for each(tmpEffect in char.getBloodlineEffect())
            {
               switch(tmpEffect.type)
               {
                  case BloodlineData.EFFECT_MAX_HP_FIX_NUM:
                     baseHP = baseHP + tmpEffect.amount;
                     continue;
                  case BloodlineData.EFFECT_MAX_HP:
                     baseHP = baseHP + Math.round(tmpEffect.amount * 0.01 * hp);
                     continue;
                  case BloodlineData.EFFECT_HP_BONUS_RELATE_CP_PERCENT:
                     baseHP = baseHP + Math.round(char.maxCP * tmpEffect.amount * 0.01);
                     continue;
                  default:
                     continue;
               }
            }
         }
         var TmphpBonus:int = 0;
         var senjutsuBonus:int = 0;
         if(SENJUTSU_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Senjutsu_Skill = char.getData(DBCharacterData.SENJUTSU_SKILL);
            if(Chr_Senjutsu_Skill)
            {
               for(i = 0; i < Chr_Senjutsu_Skill.length; i++)
               {
                  skill_id = Chr_Senjutsu_Skill[i].skill_id;
                  level = Chr_Senjutsu_Skill[i].level;
                  for(k = 0; k < SENJUTSU_SKILL_DATA_ARR.length; k++)
                  {
                     if(SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        effect = SENJUTSU_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                              if(effect[j].effect_type_1 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 senjutsuBonus = senjutsuBonus + Math.round(effect[j].effect_amount_1 / 100 * hp);
                              }
                              if(effect[j].effect_type_2 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 senjutsuBonus = senjutsuBonus + Math.round(effect[j].effect_amount_2 / 100 * hp);
                              }
                              if(effect[j].effect_type_3 == SenjutsuData.EFFECT_SS_MAX_HP)
                              {
                                 senjutsuBonus = senjutsuBonus + Math.round(effect[j].effect_amount_3 / 100 * hp);
                              }
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         baseHP = baseHP + senjutsuBonus;
         hp = hp + baseHP;
         return hp;
      }
      
      public static function calcCP(char:*, BLOODLINE_SKILL_DATA_ARR:Array = null, SENJUTSU_SKILL_DATA_ARR:Array = null) : uint
      {
         var tmpEffect:Object = null;
         var i:int = 0;
         var rNum:Number = NaN;
         var clanBonus:Number = NaN;
         var charWeapon:Object = null;
         var charBackItem:Object = null;
         var charAccessory:Object = null;
         var gearObj:Object = null;
         var key:* = null;
         var charGearset:Object = null;
         var setEffect:Object = null;
         var Chr_Bloodline_Skill:Array = null;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var Chr_Senjutsu_Skill:Array = null;
         var waterBonus:uint = 30;
         var cp:int = Math.round(char.getData(DBCharacterData.MAX_CP)) + Math.round((char.getData(DBCharacterData.LEVEL) - 1) * Data.LEVEL_INC_CP) + Math.round(char.getData(DBCharacterData.WATER) * waterBonus);
         var clanEffect:Object = char.getClanEffect();
         var baseCP:int = 0;
         if(clanEffect)
         {
            if(clanEffect[ClanData.CLAN_CP_BONUS])
            {
               clanBonus = int(clanEffect[ClanData.CLAN_CP_BONUS].amount) / 100;
               baseCP = baseCP + Math.round(cp * clanBonus);
            }
         }
         if(char.getWeapon())
         {
            charWeapon = Central.main.WEAPON_DATA.find(char.getWeapon());
            if(charWeapon)
            {
               for each(tmpEffect in charWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_CP:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseCP = baseCP + tmpEffect.amount;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getBackItem())
         {
            charBackItem = Central.main.BACK_ITEM_DATA.find(char.getBackItem());
            if(charBackItem)
            {
               for each(tmpEffect in charBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseCP = baseCP + Math.round(cp * tmpEffect.amount / 100);
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getAccessory())
         {
            charAccessory = Central.main.ACCESSORY_DATA.find(char.getAccessory());
            if(charAccessory)
            {
               for each(tmpEffect in charAccessory.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           baseCP = baseCP + Math.round(cp * tmpEffect.amount / 100);
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(char.getGearset())
         {
            gearObj = char.getGearset();
            for(key in gearObj)
            {
               charGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = charGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case BattleData.EFFECT_MAX_CP_PRESENT:
                        baseCP = baseCP + Math.round(cp * setEffect.amount / 100);
                  }
               }
            }
         }
         var TmpcpBonus:int = 0;
         if(BLOODLINE_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Bloodline_Skill = char.getData(DBCharacterData.BLOODLINE_SKILL);
            if(Chr_Bloodline_Skill)
            {
               for(i = 0; i < Chr_Bloodline_Skill.length; i++)
               {
                  skill_id = Chr_Bloodline_Skill[i].skill_id;
                  level = Chr_Bloodline_Skill[i].level;
                  for(k = 0; k < BLOODLINE_SKILL_DATA_ARR.length; k++)
                  {
                     if(BLOODLINE_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && BLOODLINE_SKILL_DATA_ARR[k].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                     {
                        effect = BLOODLINE_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                              if(effect[j].effect_type_1 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 TmpcpBonus = TmpcpBonus + Math.round(effect[j].effect_amount_1 / 100 * cp);
                              }
                              if(effect[j].effect_type_2 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 TmpcpBonus = TmpcpBonus + Math.round(effect[j].effect_amount_2 / 100 * cp);
                              }
                              if(effect[j].effect_type_3 == BloodlineData.EFFECT_MAX_CP)
                              {
                                 TmpcpBonus = TmpcpBonus + Math.round(effect[j].effect_amount_3 / 100 * cp);
                              }
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         baseCP = baseCP + TmpcpBonus;
         var senjutsuBonus:int = 0;
         if(SENJUTSU_SKILL_DATA_ARR && (String(char.constructor) == "[class Character]" || String(char.constructor) == "[class PvPCharacter]" || String(char.constructor) == "[class AICharacter]"))
         {
            Chr_Senjutsu_Skill = char.getData(DBCharacterData.SENJUTSU_SKILL);
            if(Chr_Senjutsu_Skill)
            {
               for(i = 0; i < Chr_Senjutsu_Skill.length; i++)
               {
                  skill_id = Chr_Senjutsu_Skill[i].skill_id;
                  level = Chr_Senjutsu_Skill[i].level;
                  for(k = 0; k < SENJUTSU_SKILL_DATA_ARR.length; k++)
                  {
                     if(SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        effect = SENJUTSU_SKILL_DATA_ARR[k].effect;
                        for(j = 0; j < effect.length; j++)
                        {
                           if(effect[j].skill_level == level)
                           {
                           }
                        }
                        break;
                     }
                  }
               }
            }
         }
         baseCP = baseCP + senjutsuBonus;
         cp = cp + baseCP;
         var orgCP:int = cp;
         if(char.isBattleDebuffActive(SenjutsuData.EFFECT_SS_MAX_CP_CHANGE))
         {
            cp = cp * (1 - char.getBattleDebuff()[SenjutsuData.EFFECT_SS_MAX_CP_CHANGE].amount / 100);
         }
         if(char.isBattleDebuffActive(SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA))
         {
            cp = cp * (1 - char.getBattleDebuff()[SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA].amount / 100);
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_REDUCE_CP_MAX))
         {
            cp = cp * (1 - char.getBattleDebuff()[BattleData.EFFECT_REDUCE_CP_MAX].amount / 100);
         }
         if(char.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
         {
            cp = orgCP;
         }
         return cp;
      }
      
      public static function calcSP(char:*, SENJUTSU_DATA_ARR:Array = null) : uint
      {
         var sp:int = SenjutsuData.SENJUTSU_MAX_SP + (char.getData(DBCharacterData.LEVEL) - SenjutsuData.SENJUTSU_LEVEL) * SenjutsuData.SENJUTSU_MAX_SP_INCREMENT;
         return sp;
      }
      
      public static function getSenjutsuSlot(_level:uint) : int
      {
         var MAX_SLOT:int = 8;
         var MIN_SLOT:int = 4;
         var currSlot:uint = 0;
         if(_level - SenjutsuData.SENJUTSU_LEVEL >= 0)
         {
            currSlot = MIN_SLOT + int(Math.floor((_level - SenjutsuData.SENJUTSU_LEVEL) * 0.1));
         }
         if(currSlot <= MAX_SLOT)
         {
            return currSlot;
         }
         return MAX_SLOT;
      }
      
      public static function getXpByLv(_level:uint) : uint
      {
         var LEVEL_TO_XP:uint = 130;
         var XP_MODIFIER:uint = 50;
         var LEVEL_COEFFICIENT:uint = 50;
         var curLevelXp:uint = 0;
         var i:uint = 1;
         while(i < _level)
         {
            curLevelXp = curLevelXp + Math.round(i * LEVEL_TO_XP * Math.pow(XP_MODIFIER,i / LEVEL_COEFFICIENT));
            i++;
         }
         if(curLevelXp < 0)
         {
            curLevelXp = 0;
         }
         return curLevelXp;
      }
      
      public static function getLvByXp(_xp:uint) : uint
      {
         var LEVEL_TO_XP:uint = 130;
         var XP_MODIFIER:uint = 50;
         var LEVEL_COEFFICIENT:uint = 50;
         var curLevelXp:uint = 0;
         var i:uint = 0;
         while(curLevelXp <= _xp)
         {
            i++;
            curLevelXp = curLevelXp + Math.round(i * LEVEL_TO_XP * Math.pow(XP_MODIFIER,i / LEVEL_COEFFICIENT));
         }
         return i;
      }
      
      public static function getPetXpByLv(_level:uint) : uint
      {
         var LEVEL_TO_XP:uint = 130;
         var XP_MODIFIER:uint = 50;
         var LEVEL_COEFFICIENT:uint = 50;
         var curLevelXp:uint = 0;
         var i:uint = 1;
         while(i < _level)
         {
            curLevelXp = curLevelXp + Math.round(i * LEVEL_TO_XP * Math.pow(XP_MODIFIER,i / LEVEL_COEFFICIENT) * 0.2);
            i++;
         }
         if(curLevelXp < 0)
         {
            curLevelXp = 0;
         }
         return curLevelXp;
      }
      
      public static function getPetLvByXp(_xp:uint) : uint
      {
         var LEVEL_TO_XP:uint = 130;
         var XP_MODIFIER:uint = 50;
         var LEVEL_COEFFICIENT:uint = 50;
         var curLevelXp:uint = 0;
         var i:uint = 0;
         while(curLevelXp <= _xp)
         {
            i++;
            curLevelXp = curLevelXp + Math.round(i * LEVEL_TO_XP * Math.pow(XP_MODIFIER,i / LEVEL_COEFFICIENT) * 0.2);
         }
         return i;
      }
      
      public static function calcXpPenalty(levelDiff:int, xp:int) : int
      {
         var finalXP:int = 0;
         finalXP = xp;
         return finalXP;
      }
   }
}
