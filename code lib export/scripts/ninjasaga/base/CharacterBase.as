package ninjasaga.base
{
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Formula;
   import ninjasaga.Central;
   import ninjasaga.data.RankData;
   import ninjasaga.data.SenjutsuData;
   import com.utils.Out;
   import ninjasaga.data.BattleData;
   import com.utils.NumberUtil;
   import ninjasaga.data.BloodlineData;
   import com.utils.GF;
   
   public class CharacterBase
   {
       
      
      protected var dbChar;
      
      public var battleSkillCooldown:Object;
      
      protected var battleAction:Object = null;
      
      protected var battleBuff:Object;
      
      protected var battleDebuff:Object;
      
      public var isDead:Boolean = false;
      
      public var hpBonus:int = 0;
      
      public var cpBonus:int = 0;
      
      public var spBonus:int = 0;
      
      public var side:uint = 1;
      
      public var type:int;
      
      public var dodgeBonus:Number = 0;
      
      public var effectResistance:Array;
      
      public var isStunResistBoo:Boolean = false;
      
      public var limb:int = 1;
      
      public const TYPE_CHARACTER:int = 1;
      
      public const TYPE_AICHARACTER:int = 2;
      
      public const TYPE_PVPCHARACTER:int = 3;
      
      public const TYPE_ENEMY:int = 4;
      
      public const TYPE_PET:int = 5;
      
      public const TYPE_NPC:int = 6;
      
      protected var isClassSkillAvailable:Array;
      
      protected var classSkillList:Array;
      
      public var salfLifeSkill:Array;
      
      public var senjustuSkillFirstUseArr:Array;
      
      public var damageShield:int = 0;
      
      public var divideChaosSingleClearRound:int = 0;
      
      public var divideChaosRound:int = 0;
      
      public function CharacterBase()
      {
         battleSkillCooldown = {};
         battleBuff = {};
         battleDebuff = {};
         effectResistance = [];
         isClassSkillAvailable = new Array();
         classSkillList = [];
         salfLifeSkill = [BattleData.EFFECT_ALL_CP_DODGE_BONUS,BattleData.EFFECT_ALL_CP_DRAIN_HP,BattleData.EFFECT_ALL_CP_BLIND,BattleData.EFFECT_ALL_CP_GUARD_RESIST,BattleData.EFFECT_ALL_CP_HEAL,SenjutsuData.EFFECT_SS_DIVIDE_CHAOS];
         senjustuSkillFirstUseArr = [];
         super();
      }
      
      public function getData(_dataName:String) : *
      {
         return this.dbChar[_dataName];
      }
      
      public function updateData(_dataType:String, _value:*) : void
      {
         this.dbChar[_dataType] = _value;
      }
      
      public function getCharacterId() : int
      {
         return this.getData(DBCharacterData.ID);
      }
      
      private function isLevelHack() : Boolean
      {
         if(Formula.getLvByXp(Central.main.getMainChar().getData(DBCharacterData.XP)) != Central.main.getMainChar().getData(DBCharacterData.LEVEL))
         {
            return true;
         }
         switch(Central.main.getMainChar().getData(DBCharacterData.RANK))
         {
            case RankData.GENIN:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.GENIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.CHUNIN:
            case RankData.CHUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.CHUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.JOUNIN:
            case RankData.JOUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.SPECIAL_JOUNIN:
            case RankData.SPECIAL_JOUNIN_TALENTED:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.SPECIAL_JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.TUTOR:
            case RankData.TUTOR_SENIOR:
               if(Central.main.getMainChar().getData(DBCharacterData.LEVEL) > RankData.TUTOR_LEVEL_CAP)
               {
                  return true;
               }
               break;
         }
         return false;
      }
      
      public function getLevel() : uint
      {
         if(this.isLevelHack())
         {
            Central.main.onError("2977","");
            return 0;
         }
         return this.dbChar.character_level;
      }
      
      public function get hp() : uint
      {
         return this.getData(DBCharacterData.HP);
      }
      
      public function get cp() : uint
      {
         return this.getData(DBCharacterData.CP);
      }
      
      public function get sp() : uint
      {
         return this.getData(DBCharacterData.SP);
      }
      
      public function get petCP() : uint
      {
         return this.getData(DBCharacterData.PET_CP);
      }
      
      public function get petMaxCP() : uint
      {
         return this.getData(DBCharacterData.PET_MAX_CP);
      }
      
      public function get petMaxEp() : uint
      {
         return this.getData(DBCharacterData.PET_MAX_EP);
      }
      
      public function updatePetCP(_value:int) : uint
      {
         var cp:* = this.getData(DBCharacterData.PET_CP);
         cp = cp + _value;
         if(cp < 0)
         {
            cp = 0;
         }
         if(cp > this.petMaxCP)
         {
            cp = this.petMaxCP;
         }
         this.updateData(DBCharacterData.PET_CP,cp);
         return cp;
      }
      
      public function updatePetEP(_value:int) : uint
      {
         var ep:* = this.getData(DBCharacterData.PET_EP);
         ep = ep + _value;
         if(ep < 0)
         {
            ep = 0;
         }
         if(ep > this.petMaxEp)
         {
            ep = this.petMaxEp;
         }
         this.updateData(DBCharacterData.PET_EP,ep);
         return ep;
      }
      
      public function get maxHP() : uint
      {
         return Formula.calcHP(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.hpBonus;
      }
      
      public function get maxCP() : uint
      {
         return Formula.calcCP(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.cpBonus;
      }
      
      public function get maxSP() : uint
      {
         return Formula.calcSP(this) + this.spBonus;
      }
      
      public function get DamageHp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_HP);
      }
      
      public function get DamageCp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_CP);
      }
      
      public function get DamageSp() : int
      {
         return this.getData(DBCharacterData.DAMAGE_SP);
      }
      
      public function get RestoreHp() : int
      {
         return this.getData(DBCharacterData.RESTORE_HP);
      }
      
      public function get RestoreCp() : int
      {
         return this.getData(DBCharacterData.RESTORE_CP);
      }
      
      public function get RestoreSp() : int
      {
         return this.getData(DBCharacterData.RESTORE_SP);
      }
      
      public function set DamageHp(v:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_HP,v);
      }
      
      public function set DamageCp(v:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_CP,v);
      }
      
      public function set DamageSp(v:int) : void
      {
         this.updateData(DBCharacterData.DAMAGE_SP,v);
      }
      
      public function set RestoreHp(v:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_HP,v);
      }
      
      public function set RestoreCp(v:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_CP,v);
      }
      
      public function set RestoreSp(v:int) : void
      {
         this.updateData(DBCharacterData.RESTORE_SP,v);
      }
      
      public function updateHP(_value:int) : uint
      {
         var hp:int = this.getData(DBCharacterData.HP);
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.getCharacterId() != Central.main.getMainChar().getCharacterId())
            {
               if(this.isDead == true)
               {
                  return hp;
               }
            }
         }
         hp = hp + _value;
         if(hp < 0)
         {
            hp = 0;
         }
         if(hp > this.maxHP)
         {
            hp = this.maxHP;
         }
         this.updateData(DBCharacterData.HP,hp);
         return hp;
      }
      
      public function updateSP(_value:int) : uint
      {
         var sp:int = this.getData(DBCharacterData.SP);
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.getCharacterId() != Central.main.getMainChar().getCharacterId())
            {
               if(this.isDead == true)
               {
                  return sp;
               }
            }
         }
         sp = sp + _value;
         if(sp < 0)
         {
            sp = 0;
         }
         if(sp > this.maxSP)
         {
            sp = this.maxSP;
         }
         this.updateData(DBCharacterData.SP,sp);
         return sp;
      }
      
      public function updateSPstatus(status:String, extrasp:int = 0) : void
      {
         switch(status)
         {
            case SenjutsuData.SP_UPDATE_ROUND:
               updateSP(int(this.maxSP * SenjutsuData.SP_UPDATE_ROUND_PERCENTAGE * 0.01));
               break;
            case SenjutsuData.SP_UPDATE_EXTRA:
               updateSP(extrasp);
         }
      }
      
      public function getWeapon() : String
      {
         return "";
      }
      
      public function getWeaponEffectObj(effectType:String) : Object
      {
         return {};
      }
      
      public function getBackItem() : String
      {
         return "";
      }
      
      public function getAccessory() : String
      {
         return "";
      }
      
      public function getTradingItem() : String
      {
         return "";
      }
      
      public function getBloodlineEffect() : Array
      {
         return null;
      }
      
      public function getBloodline() : Array
      {
         return null;
      }
      
      public function getGearset() : Object
      {
         return null;
      }
      
      public function getSkillListArr() : Array
      {
         var i:int = 0;
         if(this.dbChar.character_skills == null)
         {
            return [];
         }
         var skillList:Array = this.dbChar.character_skills;
         var isSkillListInvalid:Boolean = false;
         for(i = 0; i < skillList.length; )
         {
            if(skillList[i] != null)
            {
               i++;
               continue;
            }
            isSkillListInvalid = true;
            break;
         }
         if(!isSkillListInvalid)
         {
            switch(this.type)
            {
               case TYPE_PET:
                  for(i = 0; i < skillList.length; )
                  {
                     if(skillList[i] >= 0 && skillList[i] <= 5)
                     {
                        i++;
                        continue;
                     }
                     isSkillListInvalid = true;
                     break;
                  }
                  break;
               default:
                  for(i = 0; i < skillList.length; )
                  {
                     if(skillList[i] != 0)
                     {
                        i++;
                        continue;
                     }
                     isSkillListInvalid = true;
                     break;
                  }
                  if(isSkillListInvalid)
                  {
                     break;
                  }
                  for(i = 0; i < skillList.length; i++)
                  {
                     if(Central.main.SKILL_DATA != null)
                     {
                        if(Central.main.SKILL_DATA[skillList[i]] == null)
                        {
                           isSkillListInvalid = true;
                           break;
                        }
                     }
                  }
                  break;
            }
         }
         if(isSkillListInvalid)
         {
            this.dbChar.character_skills = [];
            skillList = [];
            return skillList;
         }
         return skillList;
      }
      
      public function getWeaponDamage() : int
      {
         var equippedWeapon:String = this.getWeapon();
         var weapon:Object = Central.main.WEAPON_DATA.find(equippedWeapon);
         if(weapon == null)
         {
            Out.debug(this,"getWeaponDamage :: weapon not found");
            return 0;
         }
         return Formula.calcDamage(weapon);
      }
      
      public function isBattleSkillCooldown(_skillName:String) : Boolean
      {
         if(this.battleSkillCooldown[_skillName])
         {
            if(this.battleSkillCooldown[_skillName] > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleSkillCooldown(_skillName:String) : int
      {
         if(this.battleSkillCooldown[_skillName])
         {
            return this.battleSkillCooldown[_skillName];
         }
         return 0;
      }
      
      public function setSkillCooldown(outputSkill:Object) : void
      {
         var skillList:Array = null;
         var i:int = 0;
         var skillData:Object = null;
         Out.debug(this,"rex1706 : outputSkill id : " + outputSkill.id);
         var cd_reduce:int = 0;
         var cd:int = 0;
         if(this.isBattleBuffActive(SenjutsuData.EFFECT_SS_SKILL_FIRST_USE_CD_REDUCE))
         {
            if(this.senjustuSkillFirstUseArr.indexOf(outputSkill.id) < 0)
            {
               Out.debug(this,"setSkillCooldown :: need reduce");
               cd_reduce = this.getBattleBuff()[SenjutsuData.EFFECT_SS_SKILL_FIRST_USE_CD_REDUCE].amount;
               this.senjustuSkillFirstUseArr.push(outputSkill.id);
            }
         }
         if(outputSkill.skill_cooldown_group != 0 && outputSkill.skill_cooldown_group != null)
         {
            skillList = this.getSkillListArr();
            for(i = 0; i < skillList.length; i++)
            {
               skillData = Central.main.SKILL_DATA[skillList[i]];
               if(skillData.skill_cooldown_group == outputSkill.skill_cooldown_group)
               {
                  cd = outputSkill.cooldown - cd_reduce;
                  if(cd > 0)
                  {
                     Out.debug(this,"group setSkillCooldown :: cd_reduce >> " + cd_reduce);
                     Out.debug(this,"group setSkillCooldown :: cd >> " + cd);
                     this.battleSkillCooldown[skillData.id] = cd;
                  }
               }
            }
         }
         else
         {
            cd = outputSkill.cooldown - cd_reduce;
            if(cd > 0)
            {
               Out.debug(this,"setSkillCooldown :: cd_reduce >> " + cd_reduce);
               Out.debug(this,"setSkillCooldown :: cd >> " + cd);
               this.battleSkillCooldown[outputSkill.id] = cd;
            }
         }
      }
      
      public function setBattleSkillCooldown(skillName:String, cooldown:int) : void
      {
         if(skillName.indexOf("skill") == -1)
         {
            skillName = "skill" + skillName;
         }
         this.battleSkillCooldown[skillName] = Math.round(cooldown + 0);
      }
      
      public function reduceSkillCooldown(round:int, reduceType:int = 0, skillElement:String = null) : void
      {
         var key:* = null;
         var remainingTurn:int = 0;
         var found:Boolean = false;
         var skillCooldown:Object = {};
         for(key in this.battleSkillCooldown)
         {
            switch(reduceType)
            {
               case BattleData.REDUCETYPE_ALL:
                  found = true;
                  break;
               case BattleData.REDUCETYPE_SKILL:
                  if(Central.main.SKILL_DATA[key])
                  {
                     if(skillElement != null)
                     {
                        if(Central.main.SKILL_DATA[key].type == skillElement)
                        {
                           found = true;
                        }
                     }
                     else
                     {
                        found = true;
                     }
                  }
                  break;
               case BattleData.REDUCETYPE_TALENT:
                  if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + key])
                  {
                     found = true;
                  }
            }
            remainingTurn = this.battleSkillCooldown[key];
            if(found)
            {
               remainingTurn = remainingTurn - round;
               found = false;
            }
            if(remainingTurn > 0)
            {
               skillCooldown[key] = remainingTurn;
            }
         }
         this.battleSkillCooldown = skillCooldown;
      }
      
      public function addSkillCooldown(cd:int, skillElement:String = null) : void
      {
         var i:int = 0;
         var skillCooldown:int = 0;
         var found:Boolean = false;
         var skillList:Array = this.getSkillListArr();
         for(i = 0; i < skillList.length; i++)
         {
            if(skillElement != null)
            {
               if(Central.main.SKILL_DATA[skillList[i]])
               {
                  if(Central.main.SKILL_DATA[skillList[i]].type == skillElement)
                  {
                     found = true;
                  }
               }
            }
            else
            {
               found = true;
            }
            if(found)
            {
               skillCooldown = this.getBattleSkillCooldown(skillList[i]);
               skillCooldown = skillCooldown + cd;
               this.setBattleSkillCooldown(skillList[i],skillCooldown);
               found = false;
            }
         }
      }
      
      public function addAllSkillCooldown(cd:int) : void
      {
         var i:int = 0;
         var skillCooldown:int = 0;
         var skillList:Array = this.getSkillListArr();
         for(i = 0; i < skillList.length; i++)
         {
            skillCooldown = this.getBattleSkillCooldown(skillList[i]);
            skillCooldown = skillCooldown + cd;
            this.setBattleSkillCooldown(skillList[i],skillCooldown);
         }
      }
      
      public function addRandomSkillCooldown(cd:int) : void
      {
         var i:int = 0;
         var rNum:int = 0;
         var skillCooldown:int = 0;
         var skillList:Array = this.getSkillListArr();
         if(skillList.length > 0)
         {
            rNum = NumberUtil.randomInt(0,skillList.length - 1);
            skillCooldown = this.getBattleSkillCooldown(skillList[rNum]);
            skillCooldown = skillCooldown + cd;
            this.setBattleSkillCooldown(skillList[rNum],skillCooldown);
         }
      }
      
      public function syncCoolDown() : void
      {
         var skillID:String = null;
         var skillList:Array = this.getSkillListArr();
         var coolDownObj:Object = Central.battle.syncCoolDownObj;
         for(var i:int = 0; i < skillList.length; i++)
         {
            skillID = skillList[i];
            trace("Central.battle.syncCoolDownObj.skillList[i] >> " + coolDownObj[skillID]);
            if(coolDownObj[skillID])
            {
               this.setBattleSkillCooldown(skillList[i],coolDownObj[skillID]);
            }
         }
      }
      
      public function setCommand(action:String) : void
      {
         Out.debug(this,"setCommand :: action >> " + action);
         switch(action)
         {
            case "pass":
               this.battleAction = {"action":action};
               break;
            case "dodge":
               this.battleAction = {"action":action};
         }
      }
      
      public function setBattleAction(_battleAction:Object = null) : void
      {
         this.battleAction = _battleAction;
      }
      
      public function getBattleAction() : Object
      {
         return this.battleAction;
      }
      
      public function updateBattleAction(name:String, value:*) : void
      {
         if(this.battleAction)
         {
            this.battleAction[name] = value;
         }
      }
      
      public function resetBuff() : void
      {
         this.battleBuff = {};
         this.battleDebuff = {};
      }
      
      public function isBattleBuffActive(type:String) : Boolean
      {
         if(this.battleBuff[type] != null)
         {
            if(this.battleBuff[type].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBattleDeBuffActive(type:String) : Boolean
      {
         if(this.battleDebuff[type] != null)
         {
            if(this.battleDebuff[type].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleBuff() : Object
      {
         return this.battleBuff;
      }
      
      public function getBattleDeBuff() : Object
      {
         return this.battleDebuff;
      }
      
      public function setBattleBuff(_effect:Object) : Boolean
      {
         var rNum:int = 0;
         var resistChance:Number = NaN;
         var buffObj:Object = {};
         buffObj.type = _effect.type;
         buffObj.duration = Math.round(int(_effect.duration) + 0);
         buffObj.amount = _effect.amount + 0;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.isBattleDeBuffActive(BattleData.EFFECT_BUFF_NEGATE))
            {
               rNum = NumberUtil.getRandom();
               resistChance = int(this.getBattleDeBuff()[BattleData.EFFECT_BUFF_NEGATE].amount) / 100;
               if(rNum < resistChance)
               {
                  return false;
               }
            }
         }
         if(_effect.chance != null)
         {
            buffObj.chance = _effect.chance;
         }
         if(_effect.target != null)
         {
            buffObj.target = _effect.target;
         }
         if(_effect.chancetohit != null)
         {
            buffObj.chancetohit = Math.round(int(_effect.chancetohit) + 0);
         }
         if(_effect.chancetoeffect != null)
         {
            buffObj.chancetoeffect = Math.round(int(_effect.chancetoeffect) + 0);
         }
         if(_effect.requirement != null)
         {
            buffObj.requirement = _effect.requirement;
         }
         if(_effect.intmem1 != null)
         {
            buffObj.intmem1 = _effect.intmem1;
         }
         if(_effect.intmem2 != null)
         {
            buffObj.intmem2 = _effect.intmem2;
         }
         if(_effect.remainClones != null)
         {
            buffObj.remainClones = _effect.remainClones;
         }
         if(this.battleAction && this.battleAction.clones && this.battleAction.clones != null)
         {
            if(this.battleAction.clones[this.getCharacterId()])
            {
               return false;
            }
         }
         this.battleBuff[buffObj.type] = buffObj;
         return true;
      }
      
      public function setActiveBuff(buffObj:Object) : void
      {
         this.battleBuff = buffObj;
      }
      
      public function clearBuff() : void
      {
         var key:* = null;
         for(key in this.battleBuff)
         {
            if(this.battleBuff[key])
            {
               if(salfLifeSkill.indexOf(key) >= 0)
               {
                  return;
               }
               if(key.indexOf(BattleData.EFFECT_DAMAGE_DELAY) < 0)
               {
                  if(key.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) < 0)
                  {
                     if(key.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) < 0)
                     {
                        if(this.battleBuff[key].duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                        {
                           if(key.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) < 0)
                           {
                              if(key.indexOf(BattleData.EFFECT_CLEAR_BLESS_N_REDUCE_HP) < 0)
                              {
                                 this.battleBuff[key] = null;
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function isBattleDebuffActive(type:String) : Boolean
      {
         if(this.battleDebuff[type])
         {
            if(this.battleDebuff[type].duration > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getBattleDebuff() : Object
      {
         return this.battleDebuff;
      }
      
      public function setBattleDebuff(_effect:Object) : Boolean
      {
         var rNum:int = 0;
         var resistChance:Number = NaN;
         if(_effect.resisted && _effect.resisted == true)
         {
            return false;
         }
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            if(this.isBattleBuffActive(BattleData.EFFECT_PET_DEBUFF_RESIST) && this.checkDebuffCanResist(_effect.type))
            {
               rNum = NumberUtil.getRandom();
               resistChance = int(this.getBattleBuff()[BattleData.EFFECT_PET_DEBUFF_RESIST].amount) / 100;
               if(rNum < resistChance)
               {
                  return false;
               }
            }
         }
         if(this.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            return false;
         }
         if(this.isBattleBuffActive(BattleData.EFFECT_DEBUFF_RESIST_EX))
         {
            return false;
         }
         Out.debug("setBattleDebuff","_effect >> " + GF.printObject(_effect));
         var debuffObj:Object = {};
         debuffObj.type = _effect.type;
         debuffObj.duration = Math.round(int(_effect.duration) + 0);
         debuffObj.amount = _effect.amount + 0;
         if(_effect.target != null)
         {
            debuffObj.target = _effect.target;
         }
         if(_effect.chancetohit != null)
         {
            debuffObj.chancetohit = Math.round(int(_effect.chancetohit) + 0);
         }
         if(_effect.chancetoeffect != null)
         {
            debuffObj.chancetoeffect = Math.round(int(_effect.chancetoeffect) + 0);
         }
         if(_effect.requirement != null)
         {
            debuffObj.requirement = _effect.requirement;
         }
         if(_effect.intmem1 != null)
         {
            debuffObj.intmem1 = _effect.intmem1;
         }
         if(_effect.intmem2 != null)
         {
            debuffObj.intmem2 = _effect.intmem2;
         }
         this.battleDebuff[debuffObj.type] = debuffObj;
         return true;
      }
      
      private function checkDebuffCanResist(_type:String) : Boolean
      {
         switch(_type)
         {
            case BattleData.EFFECT_DAMAGE_DELAY:
            case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
               return false;
            default:
               return true;
         }
      }
      
      public function removeDebuff(type:String) : void
      {
         if(this.battleDebuff[type])
         {
            this.battleDebuff[type] = null;
         }
      }
      
      public function setActiveDebuff(debuffObj:Object) : void
      {
         this.battleDebuff = debuffObj;
      }
      
      public function clearAllDebuff() : void
      {
         var key:* = null;
         for(key in this.battleDebuff)
         {
            if(this.battleDebuff[key])
            {
               if(salfLifeSkill.indexOf(key) >= 0)
               {
                  return;
               }
               if(this.battleDebuff[key].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  this.battleDebuff[key] = null;
               }
            }
         }
      }
      
      public function getBloodlineListArr() : Array
      {
         var i:int = 0;
         var value3:Object = null;
         var bloodline_skill_obj:Object = null;
         var bloodline_header_obl:Object = null;
         var bloodlineList:Array = [];
         if(this.dbChar.bloodline == null)
         {
            return [];
         }
         for each(value3 in this.dbChar.bloodline)
         {
            if(Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id] && Central.main.BLOODLINE_DATA["bloodline" + value3.bloodline_id])
            {
               bloodline_skill_obj = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id];
               bloodline_header_obl = Central.main.BLOODLINE_DATA["bloodline" + value3.bloodline_id];
               if(bloodline_skill_obj.bloodline_type == BloodlineData.SKILL_TYPE_ACTIVE && bloodline_header_obl.type == BloodlineData.SKILL_TYPE_BLOODLINE)
               {
                  bloodlineList.push(value3);
               }
               if(bloodline_skill_obj.bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE && (bloodline_skill_obj.skill_id == "skill1022" || bloodline_skill_obj.skill_id == "skill1046"))
               {
                  bloodlineList.push(value3);
               }
            }
         }
         return bloodlineList;
      }
      
      public function getSenjutsuListArr() : Array
      {
         var i:int = 0;
         var value3:Object = null;
         var senjutsu_skill_obj:Object = null;
         var senjutsuList:Array = [];
         if(this.dbChar.senjutsu == null)
         {
            return [];
         }
         for each(value3 in this.dbChar.senjutsu)
         {
            if(Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + value3.skill_id] && Central.main.SENJUTSU_DATA["senjutsu" + value3.senjutsu_id])
            {
               senjutsu_skill_obj = Central.main.SENJUTSU_SKILL_DATA["senjutsu_skill" + value3.skill_id];
               if(senjutsu_skill_obj.senjutsu_type == SenjutsuData.SKILL_TYPE_ACTIVE)
               {
                  senjutsuList.push(value3);
               }
            }
         }
         return senjutsuList;
      }
      
      public function reseteffectResistance() : void
      {
         this.effectResistance = [];
      }
      
      public function initResistance() : void
      {
         var key:* = null;
         var rNum:Number = NaN;
         var i:uint = 0;
         var BLkey:String = "";
         var BLSkillID:String = "";
         var BLkeyArr:Array = [];
         var Effect:Object = {};
         var BLSkillRequirementArr:Array = [];
         var BLSkillRequirement:String = "";
         var tmpstring:String = "";
         var tmparr:Array = [];
         var ResistType:String = "";
         var ResistChance:Number = 0;
         var ResistObject:Object = {};
         var res:Array = this.effectResistance;
         var ResExists:Boolean = false;
         var defaultResistStunChance:Number = 0;
         var notHaveAnyBuffOfDebuff:Boolean = true;
         isStunResistBoo = false;
         if(this.type == TYPE_AICHARACTER)
         {
            defaultResistStunChance = 30;
         }
         for(key in this.battleBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
            ResistType = "";
            ResistChance = 0;
            ResistObject = {};
            ResExists = false;
            if(this.battleBuff[key])
            {
               if(this.battleBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(BLkey && this.battleBuff[key].chancetoeffect && this.battleBuff[key].chancetoeffect > 0)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           ResistType = this.battleBuff[key].requirement;
                           ResistChance = this.battleBuff[key].amount + defaultResistStunChance;
                           ResistObject = {
                              "type":ResistType,
                              "change":ResistChance
                           };
                           if(res)
                           {
                              for(i = 0; i < res.length; i++)
                              {
                                 if(res[i].type == ResistType)
                                 {
                                    res[i].change = ResistChance;
                                    ResExists = true;
                                 }
                              }
                           }
                           if(ResExists == false)
                           {
                              this.effectResistance.push(ResistObject);
                           }
                           notHaveAnyBuffOfDebuff = false;
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
         for(key in this.battleDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
            ResistType = "";
            ResistChance = 0;
            ResistObject = {};
            ResExists = false;
            if(this.battleDebuff[key])
            {
               if(this.battleDebuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(BLkey && this.battleDebuff[key].chancetoeffect && this.battleDebuff[key].chancetoeffect > 0)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           ResistType = this.battleDebuff[key].requirement;
                           ResistChance = this.battleDebuff[key].amount + defaultResistStunChance;
                           ResistObject = {
                              "type":ResistType,
                              "change":ResistChance
                           };
                           if(res)
                           {
                              for(i = 0; i < res.length; i++)
                              {
                                 if(res[i].type == ResistType)
                                 {
                                    res[i].change = ResistChance;
                                    ResExists = true;
                                 }
                              }
                           }
                           if(ResExists == false)
                           {
                              this.effectResistance.push(ResistObject);
                           }
                           notHaveAnyBuffOfDebuff = false;
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
         if(notHaveAnyBuffOfDebuff)
         {
            ResistType = BattleData.EFFECT_STUN;
            ResistChance = defaultResistStunChance;
            ResistObject = {
               "type":ResistType,
               "change":ResistChance
            };
            this.effectResistance.push(ResistObject);
         }
         rNum = NumberUtil.getRandom();
         for(i = 0; i < effectResistance.length; i++)
         {
            if(rNum < effectResistance[i].change / 100 && effectResistance[i].type == BattleData.EFFECT_STUN)
            {
               Out.debug("initResistance :: ","initResistance >> " + rNum);
               Out.debug("initResistance :: ","effectResistance[i].change / 100 >> " + effectResistance[i].change / 100);
               isStunResistBoo = true;
            }
         }
      }
      
      public function isStunResist() : Boolean
      {
         return isStunResistBoo;
      }
      
      public function checkBloodlineresurrection() : Object
      {
         var key:* = null;
         var rNum:Number = NaN;
         var i:int = 0;
         var BLkey:String = "";
         var BLSkillID:String = "";
         var BLkeyArr:Array = [];
         var Effect:Object = {};
         var BLSkillRequirementArr:Array = [];
         var BLSkillRequirement:String = "";
         var tmpstring:String = "";
         var tmparr:Array = [];
         var resurrectionObj:Object = {};
         var HPRec:Number = 0;
         var CPRec:Number = 0;
         for(key in this.battleBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
            if(this.battleBuff[key])
            {
               if(this.battleBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(BLkey && this.battleBuff[key].chancetoeffect && this.battleBuff[key].chancetoeffect > 0)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_RESURRECTION:
                           HPRec = HPRec + int(this.battleBuff[key].amount / 100 * this.maxHP - this.hp);
                           CPRec = CPRec + int(this.battleBuff[key].amount / 100 * this.maxCP - this.cp);
                           this.resetBuff();
                           this.battleBuff[key] = null;
                           this.battleBuff[BloodlineData.EFFECT_COPY_JUTSU + ".skill1023"] = null;
                           this.battleBuff[BloodlineData.EFFECT_REFLECT_GENJUTSU + ".skill1024"] = null;
                           resurrectionObj["type"] = BLkey;
                           continue;
                        case BloodlineData.EFFECT_REBORN:
                           this.battleBuff[key] = null;
                           HPRec = HPRec + 1;
                           resurrectionObj["type"] = BLkey;
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
         resurrectionObj["HPRec"] = HPRec;
         resurrectionObj["CPRec"] = CPRec;
         return resurrectionObj;
      }
      
      public function isClassSkillActive(skillID:String) : Boolean
      {
         var idx:int = classSkillList.indexOf(skillID);
         return isClassSkillAvailable[idx];
      }
   }
}
