package ninjasaga.battle
{
   import ninjasaga.Central;
   import com.utils.Out;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.SenjutsuData;
   import com.utils.GF;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.BattleData;
   import com.utils.NumberUtil;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.AppData;
   import ninjasaga.data.WeaponData;
   import ninjasaga.data.PositionType;
   import ninjasaga.data.Formula;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.EnemyAttributeData;
   import ninjasaga.data.ClanData;
   import ninjasaga.Account;
   
   public final class BattleProcessor
   {
      
      private static var instance:ninjasaga.battle.BattleProcessor;
      
      public static var showOHN_chaos:Boolean = false;
       
      
      private var characterArr:Array;
      
      private var petArr:Array;
      
      private var attacker;
      
      private var defender;
      
      private var attackerWeapon;
      
      private var attackerBackItem;
      
      private var attackerAccessory;
      
      private var initialized:Boolean = false;
      
      private var roundObj:Object;
      
      private var actionLimited:int = 0;
      
      public var backItemMaxEffectNum:int = 3;
      
      private var HpCondition:Boolean = false;
      
      private var CpCondition:Boolean = false;
      
      public var skipBattleTurn:Boolean = false;
      
      var adminArr:Array;
      
      public function BattleProcessor(_key:InstanceBlocker)
      {
         characterArr = [];
         petArr = [];
         adminArr = [30714278,30714554,47864495,44490146,62299565,62543662,64183147,63586083,40248560,64676239,30712310,65152634,66764216,66108746,65152630,66966519];
         super();
         if(_key == null)
         {
            throw new Error("Error: [BattleProcessor] Instantiation failed: Use Client.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.battle.BattleProcessor
      {
         if(instance == null)
         {
            instance = new ninjasaga.battle.BattleProcessor(new InstanceBlocker());
         }
         return instance;
      }
      
      public static function destroyInstance() : void
      {
         instance = null;
      }
      
      public function init() : void
      {
         if(this.initialized == true)
         {
            return;
         }
         var i:int = 0;
         this.characterArr.push(Central.main.getMainChar());
         var enemyArr:Array = Central.battle.enemyArr;
         for(i = 0; i < enemyArr.length; i++)
         {
            this.characterArr.push(enemyArr[i]);
         }
         var partyArr:Array = Central.battle.partyArr;
         if(partyArr != null)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               this.characterArr.push(partyArr[i]);
            }
         }
         var petArr:Array = Central.battle.petArr;
         if(petArr != null)
         {
            for(i = 0; i < petArr.length; i++)
            {
               this.petArr.push(petArr[i]);
            }
         }
         this.initialized = true;
      }
      
      public function getAttacker() : *
      {
         return this.attacker;
      }
      
      public function setDefenderById(_id:int) : void
      {
         var i:uint = 0;
         for(i = 0; i < this.characterArr.length; i++)
         {
            if(this.characterArr[i].getCharacterId() == _id)
            {
               this.defender = this.characterArr[i];
               return;
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               if(petArr[i].getCharacterId() == _id)
               {
                  this.defender = petArr[i];
                  return;
               }
            }
         }
      }
      
      public function getDefender() : *
      {
         return this.defender;
      }
      
      public function characterTurn(_type:String, _id:uint) : Boolean
      {
         var i:uint = 0;
         Out.debug(this,"characterTurn :: _type " + _type + " :: _id " + _id);
         this.attacker = null;
         this.defender = null;
         switch(_type)
         {
            case "player":
               for(i = 0; i < characterArr.length; i++)
               {
                  if(_id == characterArr[i].getCharacterId())
                  {
                     attacker = characterArr[i];
                     break;
                  }
               }
               break;
            case "enemy":
               for(i = 0; i < characterArr.length; i++)
               {
                  if(_id == characterArr[i].getCharacterId())
                  {
                     attacker = characterArr[i];
                     break;
                  }
               }
               break;
            case "party":
               for(i = 0; i < characterArr.length; i++)
               {
                  if(_id == characterArr[i].getCharacterId())
                  {
                     attacker = characterArr[i];
                     break;
                  }
               }
               break;
            case "pet":
               for(i = 0; i < petArr.length; i++)
               {
                  if(_id == petArr[i].getData(DBCharacterData.ID))
                  {
                     attacker = petArr[i];
                     break;
                  }
               }
         }
         this.attackerWeapon = null;
         this.attackerBackItem = null;
         this.attackerAccessory = null;
         if(attacker)
         {
            if(this.attacker.getWeapon())
            {
               this.attackerWeapon = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
            }
            if(this.attacker.getBackItem())
            {
               this.attackerBackItem = Central.main.BACK_ITEM_DATA.find(this.attacker.getBackItem());
            }
            if(this.attacker.getAccessory())
            {
               this.attackerAccessory = Central.main.BACK_ITEM_DATA.find(this.attacker.getAccessory());
            }
         }
         this.defender = this.attacker;
         this.checkSkipBattleTurn();
         if(this.attacker.isDead == true)
         {
            return false;
         }
         return true;
      }
      
      private function checkSkipBattleTurn() : void
      {
         Out.debug(this,"checkSkipBattleTurn");
         if(this.attacker.isBattleDebuffActive(SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN))
         {
            this.skipBattleTurn = true;
            Out.debug(this,"need SkipBattleTurn");
            this.attacker.getBattleDebuff()[SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN] = null;
         }
      }
      
      public function nextRound() : Object
      {
         var i:int = 0;
         Out.debug(this,"nextRound");
         this.roundObj = {};
         this.roundObj.restore = {
            "hp":0,
            "cp":0,
            "arr":[]
         };
         this.roundObj.buff = [];
         this.roundObj.debuff = [];
         this.roundObj.buff = this.checkBuff(this.attacker);
         this.checkBuffEffect(this.attacker,this.roundObj.buff);
         this.attacker.reduceSkillCooldown(1);
         this.updateRoundBuff(this.attacker);
         this.updateRoundDebuff(this.attacker);
         this.roundObj.purify = this.checkPurify(this.attacker);
         this.checkAgility(this.attacker);
         this.checkRestore(this.attacker);
         if(int(this.attacker.getData(DBCharacterData.RANK)) >= 8 && !this.attacker.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
         {
            this.attacker.updateSPstatus(SenjutsuData.SP_UPDATE_ROUND);
            this.attacker.updateSPstatus(SenjutsuData.SP_UPDATE_EXTRA,calcSenjutsuRecoverSPBonus(0,this.attacker.getBattleBuff(),this.attacker.getBattleDebuff(),this.defender.getBattleBuff(),this.defender.getBattleDebuff(),SenjutsuData.STATUS_ROUND_START));
         }
         Out.debug("","nextRound=" + GF.printObject(this.roundObj));
         return this.roundObj;
      }
      
      private function updateRoundBuff(char:*) : void
      {
         var battleBuff:Object = null;
         var effect:Object = null;
         var key:* = null;
         var hpAmountTemp:int = 0;
         battleBuff = char.getBattleBuff();
         var activeBattleBuff:Object = {};
         for(key in battleBuff)
         {
            if(battleBuff[key])
            {
               effect = battleBuff[key];
               if(effect.duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
               {
                  effect.duration--;
               }
               if(int(effect.duration) > 0)
               {
                  activeBattleBuff[key] = effect;
                  continue;
               }
               switch(key)
               {
                  case BattleData.EFFECT_GATE_OPENING:
                     effect = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":2
                     };
                     this.roundObj.debuff.push(effect);
                     continue;
                  case BattleData.EFFECT_DAMAGE_DELAY:
                     hpAmountTemp = battleBuff[key].intmem1;
                     hpAmountTemp = this.updateHP(char,hpAmountTemp);
                     this.roundObj.restore.arr.push({
                        "type":key,
                        "hp":hpAmountTemp
                     });
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_DELAY_INJURY,
                        "duration":3,
                        "amount":100
                     };
                     this.roundObj.debuff.push(this.setDebuff(this.attacker,effect));
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
         char.setActiveBuff(activeBattleBuff);
      }
      
      private function updateRoundDebuff(char:*) : void
      {
         var effect:Object = null;
         var tmpAmount:int = 0;
         var key:* = null;
         var battleDebuff:Object = char.getBattleDebuff();
         var activeBattleDebuff:Object = {};
         for(key in battleDebuff)
         {
            effect = battleDebuff[key];
            if(battleDebuff[key])
            {
               if(effect.type == BattleData.EFFECT_ACCUM_BLEEDING)
               {
                  effect.amount = effect.amount + effect.duration;
                  activeBattleDebuff[key] = effect;
               }
               else
               {
                  if(effect.duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     effect.duration--;
                  }
                  if(int(effect.duration) > 0)
                  {
                     activeBattleDebuff[key] = effect;
                  }
               }
            }
         }
         if(battleDebuff[SenjutsuData.EFFECT_SS_DIVIDE_CHAOS])
         {
            if(battleDebuff[SenjutsuData.EFFECT_SS_DIVIDE_CHAOS].duration % 2 == 1)
            {
               effect = {
                  "type":BattleData.EFFECT_CHAOS,
                  "duration":1
               };
               activeBattleDebuff[BattleData.EFFECT_CHAOS] = effect;
            }
         }
         char.setActiveDebuff(activeBattleDebuff);
      }
      
      private function checkPurify(char:*) : Object
      {
         var tmpEffect:Object = null;
         var charWeapon:Object = null;
         var charBackItem:Object = null;
         var gearObj:Object = null;
         var key:* = null;
         var charGearset:Object = null;
         var i:int = 0;
         var setEffect:Object = null;
         var purifyChance:Number = int(char.getData(DBCharacterData.WATER)) * 4 / 1000;
         var rNum:Number = NumberUtil.getRandom();
         var purifyObj:Object = {};
         purifyObj.restoreHp = 0;
         if(char.getWeapon())
         {
            charWeapon = Central.main.WEAPON_DATA.find(char.getWeapon());
            if(charWeapon)
            {
               for each(tmpEffect in charWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        purifyChance = purifyChance + tmpEffect.amount / 100;
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
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        purifyChance = purifyChance + tmpEffect.amount / 100;
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
                  case BloodlineData.EFFECT_ADD_PURIFY_CHANCE_OVER_CP:
                     if(char.cp >= tmpEffect.amount)
                     {
                        purifyChance = purifyChance + int(char.maxCP / tmpEffect.amount) * tmpEffect.chancetoeffect * 0.01;
                     }
                     continue;
                  default:
                     continue;
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
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        purifyChance = purifyChance + setEffect.amount * 0.01;
                  }
               }
            }
         }
         if(char.isBattleBuffActive(BattleData.EFFECT_ADD_PURIFY_CHANCE))
         {
            purifyChance = purifyChance + int(char.getBattleBuff()[BattleData.EFFECT_ADD_PURIFY_CHANCE].amount) / 100;
         }
         if(char.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
         {
            purifyChance = purifyChance + int(char.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount) / 100;
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
         {
            purifyChance = purifyChance - int(char.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount) / 100;
         }
         if(char.isBattleDebuffActive(BattleData.SKILL_342))
         {
            purifyChance = purifyChance - int(char.getBattleDebuff()[BattleData.SKILL_342].amount) / 100;
         }
         if(char.isBattleDebuffActive(BattleData.SKILL_253))
         {
            purifyChance = purifyChance - int(char.getBattleDebuff()[BattleData.SKILL_253].amount) / 100;
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_REDUCE_PURIFY_CHANCE))
         {
            purifyChance = purifyChance - int(char.getBattleDebuff()[BattleData.EFFECT_REDUCE_PURIFY_CHANCE].amount) / 100;
         }
         if(char.isBattleBuffActive(BattleData.EFFECT_PURIFY_BELOW_CP))
         {
            if(char.cp <= char.getBattleBuff()[BattleData.EFFECT_PURIFY_BELOW_CP].amount * 0.01 * char.maxCP)
            {
               purifyChance = 1;
               rNum = 0;
            }
         }
         if(purifyChance >= rNum)
         {
            char.clearAllDebuff();
            if(charWeapon)
            {
               for each(tmpEffect in charWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_PURIFY_RESTORE_HP:
                        purifyObj.restoreHp = Math.round(int(char.maxHP) * (tmpEffect.amount / 100));
                        continue;
                     default:
                        continue;
                  }
               }
            }
            if(charBackItem)
            {
               for each(tmpEffect in charBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_PURIFY_RESTORE_HP:
                        purifyObj.restoreHp = Math.round(int(char.maxHP) * (tmpEffect.amount / 100));
                        continue;
                     default:
                        continue;
                  }
               }
            }
            if(purifyObj.restoreHp > 0)
            {
               purifyObj.restoreHp = this.updateHP(char,purifyObj.restoreHp);
            }
            purifyObj.purify = true;
            return purifyObj;
         }
         return null;
      }
      
      private function checkRestore(char:*) : void
      {
         var rNum:Number = NaN;
         var key:* = null;
         var effect:Object = null;
         var bloodlineKeyArr:Array = null;
         var bloodlineKey:String = null;
         var battleDebuff:Object = null;
         var tmpEffect:Object = null;
         var charWeapon:Object = null;
         var charBackItem:Object = null;
         var charAccessory:Object = null;
         var gearObj:Object = null;
         var charGearset:Object = null;
         var i:int = 0;
         var setEffect:Object = null;
         var hpAmount:int = 0;
         var cpAmount:int = 0;
         var hpAmountTemp:int = 0;
         var cpAmountTemp:int = 0;
         var displayObj:Object = null;
         var hasDisplayObj:Boolean = true;
         if(char.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            trace("char.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF");
            char.clearAllDebuff();
            return;
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
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        hpAmount = hpAmount + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           hpAmount = hpAmount + Math.round(char.maxHP * (tmpEffect.amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           cpAmount = cpAmount + Math.round(char.maxCP * (tmpEffect.amount / 100));
                           trace("cpcpAmount = " + cpAmount);
                        }
                        continue;
                     case BattleData.EFFECT_ADD_CP_BELOW_CP:
                        if(char.cp < Math.round(char.maxCP * (tmpEffect.chance / 100)))
                        {
                           cpAmount = cpAmount + Math.round(char.maxCP * (tmpEffect.amount / 100));
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
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        hpAmount = hpAmount + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ADD_CP_AMOUNT:
                        cpAmount = cpAmount + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           hpAmount = hpAmount + Math.round(char.maxHP * (tmpEffect.amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           cpAmount = cpAmount + Math.round(char.maxCP * (tmpEffect.amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_REWIND:
                        char.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_ALL);
                        continue;
                     case BattleData.EFFECT_ADD_CP_BELOW_CP:
                        if(char.cp < Math.round(char.maxCP * (tmpEffect.chance / 100)))
                        {
                           cpAmount = cpAmount + Math.round(char.maxCP * (tmpEffect.amount / 100));
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
                     case BattleData.EFFECT_ADD_HP_AMOUNT:
                        hpAmount = hpAmount + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ADD_CP_AMOUNT:
                        cpAmount = cpAmount + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           hpAmount = hpAmount + Math.round(char.maxHP * (tmpEffect.amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           cpAmount = cpAmount + Math.round(char.maxCP * (tmpEffect.amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_REWIND:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           char.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                           char.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_SKILL);
                        }
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
                  case BloodlineData.EFFECT_ADD_HP_PASSIVE:
                     hpAmount = hpAmount + tmpEffect.amount;
                     continue;
                  case BloodlineData.EFFECT_HP_BELOW_CP:
                     if(char.hp < Math.round(char.maxHP * tmpEffect.chancetohit * 0.01))
                     {
                        hpAmount = hpAmount + tmpEffect.amount;
                     }
                     continue;
                  case BloodlineData.EFFECT_RESTORE_CP_LT_CPP:
                     if(char.cp < Math.round(char.maxCP * tmpEffect.chancetoeffect * 0.01))
                     {
                        cpAmount = cpAmount + char.maxCP * tmpEffect.amount * 0.01;
                     }
                     continue;
                  default:
                     continue;
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
                     case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                        cpAmount = cpAmount + Math.round(char.maxCP * setEffect.amount * 0.01);
                        break;
                     case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                        hpAmount = hpAmount + Math.round(char.maxHP * setEffect.amount * 0.01);
                  }
               }
            }
         }
         hpAmount = this.updateHP(char,hpAmount);
         cpAmount = this.updateCP(char,cpAmount);
         this.roundObj.restore.hp = this.roundObj.restore.hp + hpAmount;
         this.roundObj.restore.cp = this.roundObj.restore.cp + cpAmount;
         var battleBuff:Object = char.getBattleBuff();
         for(key in battleBuff)
         {
            if(battleBuff[key])
            {
               effect = battleBuff[key];
               hpAmountTemp = 0;
               cpAmountTemp = 0;
               displayObj = null;
               hasDisplayObj = true;
               switch(key)
               {
                  case BattleData.EFFECT_REGENERATE_CHAKRA:
                     cpAmountTemp = cpAmountTemp + Math.round(char.maxCP * (int(effect.amount) / 100));
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                     hpAmountTemp = hpAmountTemp + Math.round(char.maxHP * (int(effect.amount) / 100));
                     break;
                  case BattleData.EFFECT_WIND_PEACE:
                  case BattleData.EFFECT_WIND_PEACE_2:
                     cpAmountTemp = cpAmountTemp + Math.round(char.maxCP * (8 / 100));
                     break;
                  case BattleData.EFFECT_WIND_PEACE_3:
                  case BattleData.EFFECT_WIND_PEACE_4:
                     cpAmountTemp = cpAmountTemp + Math.round(char.maxCP * (9 / 100));
                     break;
                  case BattleData.EFFECT_REWIND:
                     this.attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                     char.reduceSkillCooldown(effect.amount,BattleData.REDUCETYPE_SKILL);
                     break;
                  case BattleData.SKILL_335:
                     hpAmountTemp = hpAmountTemp + Math.round(char.maxHP * 0.08);
                     break;
                  case BattleData.EFFECT_CATALYTIC_MATTER:
                     hpAmountTemp = hpAmountTemp - Math.round(char.maxHP * (2 / 100));
                     break;
                  case BattleData.EFFECT_PET_HEAL:
                     hasDisplayObj = false;
                     hpAmountTemp = Math.round(char.maxHP * (int(effect.amount) / 100));
                     hpAmountTemp = this.updateHP(char,hpAmountTemp);
                     this.roundObj.restore.arr.push({
                        "type":key,
                        "hp":hpAmountTemp,
                        "cp":cpAmountTemp
                     });
                     break;
                  case BattleData.EFFECT_GATE_OPENING:
                     hpAmountTemp = hpAmountTemp - Math.round(char.maxHP * 0.02);
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME:
                  case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                     hpAmountTemp = hpAmountTemp + Math.round(char.maxHP * (int(effect.amount) / 100));
                     char.clearAllDebuff();
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                     hpAmountTemp = hpAmountTemp + int(effect.amount);
                     char.clearAllDebuff();
                     break;
                  case BattleData.SKILL_234:
                  case BattleData.EFFECT_DAMAGE_DELAY:
                     char.clearAllDebuff();
                     break;
                  case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                     hpAmountTemp = hpAmountTemp + int(effect.amount);
                     break;
                  case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                     hpAmountTemp = hpAmountTemp + 250;
                     break;
                  case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                     hpAmountTemp = hpAmountTemp + 550;
               }
               displayObj = {
                  "type":key,
                  "hp":hpAmountTemp,
                  "cp":cpAmountTemp
               };
               bloodlineKeyArr = key.split(".");
               bloodlineKey = null;
               if(bloodlineKeyArr != null)
               {
                  bloodlineKey = bloodlineKeyArr[0];
               }
               if(bloodlineKey != null && effect.chancetoeffect != null && int(effect.chancetoeffect) > 0)
               {
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(effect.chancetoeffect) / 100)
                  {
                     switch(bloodlineKey)
                     {
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           hpAmountTemp = hpAmountTemp + int(effect.amount);
                     }
                  }
                  key = bloodlineKey;
                  displayObj = {
                     "type":key,
                     "hp":hpAmountTemp,
                     "cp":cpAmountTemp
                  };
               }
               if(hasDisplayObj)
               {
                  displayObj.hp = this.updateHP(char,displayObj.hp) + 0;
                  displayObj.cp = this.updateCP(char,displayObj.cp) + 0;
                  this.roundObj.restore.arr.push(displayObj);
               }
            }
         }
         battleDebuff = char.getBattleDebuff();
         for(key in battleDebuff)
         {
            if(battleDebuff[key])
            {
               effect = battleDebuff[key];
               hpAmountTemp = 0;
               cpAmountTemp = 0;
               displayObj = null;
               hasDisplayObj = true;
               Out.debug("[rockman","battle processor -> check restore -> key in battleDebuff >> key = " + key);
               switch(key)
               {
                  case BattleData.EFFECT_BURN:
                  case BattleData.EFFECT_BURN_FIX_NUM:
                  case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                     hpAmountTemp = 0 - Math.round(effect.amount);
                     break;
                  case BattleData.EFFECT_POISON:
                  case BattleData.EFFECT_PARASITE:
                  case BattleData.EFFECT_BURNING:
                  case BattleData.EFFECT_PET_BURN:
                  case BattleData.SKILL_377:
                  case BattleData.EFFECT_DOT_HP:
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                  case BattleData.EFFECT_ULTRA_BURNING:
                     hpAmountTemp = 0 - Math.round(char.maxHP * (int(effect.amount) / 100));
                     break;
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                     cpAmountTemp = 0 - Math.round(char.maxCP * (int(effect.amount) / 100));
                     break;
                  case BattleData.EFFECT_FLAME:
                     hpAmountTemp = 0 - Math.round(char.maxHP * (int(effect.amount) / 100));
                     cpAmountTemp = 0 - Math.round(char.maxCP * (int(effect.amount) / 100));
                     break;
                  case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                     hpAmountTemp = 0 - int(effect.amount);
                     break;
                  case BattleData.EFFECT_COLLIDING_WAVE:
                  case BattleData.EFFECT_REDUCE_HP_CP:
                  case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     hpAmountTemp = 0 - Math.round(char.maxHP * (effect.amount / 100));
                     cpAmountTemp = 0 - Math.round(char.maxCP * (effect.amount / 100));
               }
               displayObj = {
                  "type":key,
                  "hp":hpAmountTemp,
                  "cp":cpAmountTemp
               };
               bloodlineKeyArr = key.split(".");
               bloodlineKey = null;
               if(bloodlineKeyArr != null)
               {
                  bloodlineKey = bloodlineKeyArr[0];
               }
               if(bloodlineKey != null && effect.chancetoeffect != null && int(effect.chancetoeffect) > 0)
               {
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(effect.chancetoeffect) / 100)
                  {
                     switch(bloodlineKey)
                     {
                        case BloodlineData.EFFECT_UPDATE_HP:
                           hpAmountTemp = Math.round(char.maxHP * (int(effect.amount) / 100));
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           cpAmountTemp = Math.round(char.maxCP * (int(effect.amount) / 100));
                     }
                  }
                  key = bloodlineKey;
                  displayObj = {
                     "type":key,
                     "hp":hpAmountTemp,
                     "cp":cpAmountTemp,
                     "skill":bloodlineKeyArr[1]
                  };
               }
               if(hasDisplayObj)
               {
                  displayObj.hp = this.updateHP(char,displayObj.hp) + 0;
                  displayObj.cp = this.updateCP(char,displayObj.cp) + 0;
                  this.roundObj.restore.arr.push(displayObj);
               }
            }
         }
      }
      
      private function checkAgility(char:*) : void
      {
         Out.debug(this,"checkAgility :: agility >> " + char.agility);
         Out.debug(this,"checkAgility :: character_id >> " + char.getData("character_id"));
         var agility:int = char.agility;
         if(char.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY))
         {
            agility = agility - Math.round(agility * (100 - int(char.getBattleDebuff()[BattleData.EFFECT_REDUCE_AGILITY].amount)) * 0.01);
            if(agility < 10)
            {
               agility = 10;
            }
         }
         Central.client.getInstance().updateCharacterAgility(char.getData("character_id"),agility);
         Out.debug(this,"checkAgility :: agility after >> " + agility);
      }
      
      private function checkBuff(char:*) : Array
      {
         var rNum:Number = NaN;
         var effect:Object = null;
         var tmpEffect:Object = null;
         var combustionChance:Number = NaN;
         var combustionWeaponEffect:Object = null;
         var combustionBackItemEffect:Object = null;
         var combustion:Object = null;
         var buffArr:Array = [];
         var amount:int = 0;
         var i:int = 0;
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_BLOOD_FEED:
                  case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
                  case BattleData.EFFECT_ACCURATE_WEAPON:
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
                  case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                  case BattleData.EFFECT_REWIND:
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                  case BattleData.EFFECT_WEAPON_SENJUTSU_DMG_BONUS:
                     if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                     {
                        buffArr.push({
                           "type":tmpEffect.type,
                           "duration":int(tmpEffect.duration),
                           "amount":int(tmpEffect.amount)
                        });
                     }
                     continue;
                  case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                     if(this.attacker.hp / this.attacker.maxHP * 100 < tmpEffect.chance)
                     {
                        buffArr.push({
                           "type":tmpEffect.type,
                           "duration":int(tmpEffect.duration),
                           "amount":int(tmpEffect.amount)
                        });
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(int(char.getData(DBCharacterData.FIRE)) > 0 && char.isBattleBuffActive(BattleData.EFFECT_COMBUSTION) == false)
         {
            combustionChance = int(char.getData(DBCharacterData.FIRE)) * 4 / 1000;
            combustionWeaponEffect = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
            if(combustionWeaponEffect && combustionWeaponEffect.effect)
            {
               for(i = 0; i < combustionWeaponEffect.effect.length; i++)
               {
                  tmpEffect = combustionWeaponEffect.effect[i];
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                        combustionChance = combustionChance + tmpEffect.amount / 100;
                  }
               }
            }
            combustionBackItemEffect = Central.main.BACK_ITEM_DATA.find(this.attacker.getBackItem());
            if(combustionBackItemEffect && combustionBackItemEffect.effect)
            {
               for(i = 0; i < combustionBackItemEffect.effect.length; i++)
               {
                  tmpEffect = combustionBackItemEffect.effect[i];
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                        combustionChance = combustionChance + tmpEffect.amount / 100;
                  }
               }
            }
            rNum = NumberUtil.getRandom();
            if(char.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
            {
               combustionChance = combustionChance + char.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount / 100;
            }
            if(char.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
            {
               combustionChance = combustionChance - char.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount / 100;
            }
            if(char.isBattleDebuffActive(BattleData.SKILL_270))
            {
               combustionChance = combustionChance - char.getBattleDebuff()[BattleData.SKILL_270].amount / 100;
            }
            if(combustionChance >= rNum)
            {
               combustion = {
                  "type":BattleData.EFFECT_COMBUSTION,
                  "duration":2
               };
               buffArr.push(combustion);
            }
         }
         return buffArr;
      }
      
      private function checkBuffEffect(char:*, buffArr:Array) : void
      {
         var i:int = 0;
         var key:* = undefined;
         var rtnObj:Object = {};
         rtnObj.restore = {
            "hp":0,
            "cp":0
         };
         rtnObj.restore.hp = this.updateHP(char,rtnObj.restore.hp);
         rtnObj.restore.cp = this.updateCP(char,rtnObj.restore.cp);
         this.roundObj.restore.hp = this.roundObj.restore.hp + rtnObj.restore.hp;
         this.roundObj.restore.cp = this.roundObj.restore.cp + rtnObj.restore.cp;
         for(key in buffArr)
         {
            char.setBattleBuff(buffArr[key]);
         }
      }
      
      public function setupAction() : Object
      {
         var key:String = null;
         var battleAction:Object = null;
         var rNum:Number = NaN;
         Out.debug(this,"setupAction :: attacker >> " + this.attacker.getCharacterName());
         var battleDebuff:Object = this.attacker.getBattleDebuff();
         this.actionLimited = 0;
         for(var _loc8_ in battleDebuff)
         {
            switch(_loc8_)
            {
               case BattleData.EFFECT_STUN:
               case BattleData.EFFECT_FEAR:
               case BattleData.EFFECT_PET_FREEZE:
               case BattleData.EFFECT_PETRIFICATION:
               case BattleData.EFFECT_SLEEP:
                  if(!Central.mission.isSpecialActionOfEnemy)
                  {
                     if(battleDebuff[key] != null)
                     {
                        if(battleDebuff[key].duration > 0)
                        {
                           battleAction = {
                              "action":key,
                              "duration":battleDebuff[key].duration
                           };
                           this.attacker.setBattleAction(battleAction);
                           continue;
                        }
                     }
                  }
                  continue;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  if(battleDebuff[key] != null)
                  {
                     if(battleDebuff[key].duration > 0 && int(battleDebuff[key].amount) == 2)
                     {
                        battleAction = {
                           "action":key,
                           "duration":battleDebuff[key].duration
                        };
                        this.attacker.setBattleAction(battleAction);
                     }
                  }
                  continue;
               case BloodlineData.EFFECT_HALLUCINATIONS + ".skill1020":
                  if(battleDebuff[key] != null)
                  {
                     if(battleDebuff[key].duration > 0)
                     {
                        switch(this.attacker.type)
                        {
                           case this.attacker.TYPE_AICHARACTER:
                              rNum = NumberUtil.getRandom();
                              if(rNum < 0.3)
                              {
                                 this.attacker.setPlayerCommand("weapon_attack");
                              }
                              if(rNum >= 0.3 && rNum < 0.6)
                              {
                                 this.attacker.setPlayerCommand("pass");
                              }
                              if(rNum >= 0.6)
                              {
                                 this.attacker.setPlayerCommand("charge");
                              }
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           default:
                              this.attacker.setCommand("pass");
                        }
                        this.randomTarget();
                        this.finalizeBattleAction();
                        battleAction = this.attacker.getBattleAction();
                        battleAction.targetType = this.defender.type;
                        battleAction.targetId = this.defender.getCharacterId();
                     }
                  }
                  continue;
               case BattleData.EFFECT_CHAOS:
                  if(battleDebuff[key] != null)
                  {
                     if(battleDebuff[key].duration > 0)
                     {
                        switch(this.attacker.type)
                        {
                           case this.attacker.TYPE_CHARACTER:
                              rNum = NumberUtil.getRandom();
                              this.attacker.setCommand("pass");
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           case this.attacker.TYPE_AICHARACTER:
                              rNum = NumberUtil.getRandom();
                              if(rNum < 0.3)
                              {
                                 this.attacker.setPlayerCommand("weapon_attack");
                              }
                              if(rNum >= 0.3 && rNum < 0.6)
                              {
                                 this.attacker.setPlayerCommand("pass");
                              }
                              if(rNum >= 0.6)
                              {
                                 this.attacker.setPlayerCommand("charge");
                              }
                              this.setCharacterCommand(this.attacker.getBattleAction());
                              break;
                           default:
                              this.attacker.setCommand("pass");
                        }
                        this.randomTarget();
                        this.finalizeBattleAction();
                        battleAction = this.attacker.getBattleAction();
                        battleAction.targetType = this.defender.type;
                        battleAction.targetId = this.defender.getCharacterId();
                     }
                  }
                  continue;
               case BattleData.EFFECT_DISMANTLE:
               case BattleData.SKILL_341:
                  if(battleDebuff[key] != null)
                  {
                     if(battleDebuff[key].duration > 0)
                     {
                        if(this.attacker.type != this.attacker.TYPE_CHARACTER && this.attacker.type != this.attacker.TYPE_AICHARACTER)
                        {
                           this.attacker.setCommand("pass");
                           battleAction = this.attacker.getBattleAction();
                        }
                     }
                  }
                  continue;
               default:
                  continue;
            }
         }
         if(battleAction)
         {
            battleAction.debuffOverride = false;
            if(this.attacker.isClassSkillActive("skill2001") == true)
            {
               battleAction.debuffOverride = true;
               this.actionLimited = 1;
            }
         }
         for(var i:int = 0; i < this.characterArr.length; i++)
         {
            Out.debug(this,this.characterArr[i].getCharacterName() + " :: HP :: " + this.characterArr[i].hp + " / " + this.characterArr[i].maxHP);
         }
         return battleAction;
      }
      
      public function processCommand(battleCommand:Object) : void
      {
         var battleAction:Object = null;
         Out.debug("BattleProcessor","processCommand");
         if(battleCommand == null)
         {
            battleCommand = {};
         }
         battleCommand.noCooldown = false;
         switch(this.attacker.type)
         {
            case this.attacker.TYPE_CHARACTER:
               this.setCharacterCommand(battleCommand);
               break;
            case this.attacker.TYPE_PET:
               this.setPetCommand(battleCommand);
               break;
            case this.attacker.TYPE_ENEMY:
               this.attacker.setBattleAction();
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
               battleAction = this.attacker.getBattleAction();
               if(battleAction.dmg == 0)
               {
                  battleAction.dmg = null;
                  this.attacker.setBattleAction(battleAction);
               }
               if(battleAction.heal == 0)
               {
                  battleAction.heal = null;
                  this.attacker.setBattleAction(battleAction);
               }
               break;
            case this.attacker.TYPE_AICHARACTER:
               if(Central.battle.isPartyControllable == false)
               {
                  this.attacker.aiAction();
               }
               this.setCharacterCommand(this.attacker.getBattleAction());
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
               break;
            case this.attacker.TYPE_NPC:
               this.attacker.setBattleAction();
               trace("Central.battle.getDefender().getCharacterId() = " + Central.battle.getDefender().getCharacterId());
               this.setDefenderById(Central.battle.getDefender().getCharacterId());
         }
         this.finalizeBattleAction();
      }
      
      private function finalizeBattleAction() : void
      {
         Out.debug("BattleProcessor","finalizeBattleAction");
         var battleAction:Object = this.attacker.getBattleAction();
         showOHN_chaos = true;
         battleAction.attackerRestoreHp = 0;
         battleAction.attackerRestoreCp = 0;
         battleAction.attackerDamageHp = 0;
         battleAction.attackerDamageCp = 0;
         battleAction.defenderRestoreHp = 0;
         battleAction.defenderRestoreCp = 0;
         battleAction.defenderDamageCp = 0;
         battleAction.defenderDamageHp = 0;
         battleAction.attackerBuff = [];
         battleAction.attackerDebuff = [];
         battleAction.defenderBuff = [];
         battleAction.defenderDebuff = [];
         battleAction.dmgArr = [];
         battleAction.clones = {};
         this.attacker.setBattleAction(battleAction);
         this.checkDodge();
         this.checkDamageModifier();
         this.checkCritical();
         this.checkStun();
         this.checkFeedbackEffectBefore();
         this.processBattleAction();
         this.checkFeedbackEffectAfter();
         this.checkFeedback();
         this.checkExtraAttack();
         this.checkResurrection();
      }
      
      private function setCharacterCommand(battleCommand:Object) : void
      {
         var battleAction:Object = null;
         var effect:Object = null;
         var rNum:Number = NaN;
         var skillData:Object = null;
         var damage:Number = NaN;
         var weaponData:Object = null;
         var animation:String = null;
         var posType:String = null;
         var tmpEffect:Object = null;
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var cpRequired:int = 0;
         var checkReduceCpObj:Object = null;
         var fiveElenemtArr:Array = null;
         var heal:int = 0;
         var regenCP:int = 0;
         var skill_hit_chance:int = 0;
         var charBackItemEffect:Object = null;
         var cpExtra:int = 0;
         var dmg:int = 0;
         var taijutsuDefaultSelfHit:int = 0;
         var selfhitmod:Number = NaN;
         var action:String = battleCommand.action;
         var withoutCP:Boolean = false;
         switch(this.actionLimited)
         {
            case 1:
               if(action == "class_skill")
               {
                  if(battleCommand.skillId == "skill2001")
                  {
                     break;
                  }
               }
               if(action == "dodge")
               {
                  break;
               }
               this.attacker.setCommand("pass");
               return;
         }
         if(this.attacker.isBattleDebuffActive(SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN))
         {
            Out.debug(this,"skill3007 need SkipBattleTurn");
            this.attacker.setCommand("pass");
         }
         else
         {
            Out.debug(this,this.attacker.getCharacterName() + ": skill3007 no skip battle turn effect");
         }
         switch(action)
         {
            case "weapon_attack":
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_DISMANTLE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               damage = this.attacker.getWeaponDamage();
               if(AppData.type == AppData.YM)
               {
                  adminArr = new Array();
                  adminArr.push(33732240);
                  adminArr.push(33732043);
               }
               if(adminArr.indexOf(this.attacker.getCharacterId()) >= 0)
               {
                  damage = 400000;
               }
               weaponData = Central.main.WEAPON_DATA.find(this.attacker.getWeapon());
               if(weaponData != null)
               {
                  animation = weaponData[WeaponData.ANIMATION];
               }
               switch(animation)
               {
                  case "attack_01":
                     posType = PositionType.MELEE_2;
                     break;
                  default:
                     posType = PositionType.MELEE_1;
               }
               battleAction = {
                  "action":action,
                  "animation":animation,
                  "posType":posType,
                  "dmg":damage
               };
               if(this.attackerWeapon)
               {
                  for each(tmpEffect in this.attackerWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_DODGE_REDUCTION:
                        case BattleData.EFFECT_BLIND:
                        case BattleData.EFFECT_BLEEDING:
                        case BattleData.EFFECT_POISON:
                        case BattleData.EFFECT_FEAR_WEAKEN:
                        case BattleData.INSTANT_KILL:
                        case BattleData.INSTANT_CUT_HALF_HP:
                        case BattleData.EFFECT_BURNING:
                        case BattleData.EFFECT_HAMSTRING:
                        case BattleData.EFFECT_BURN:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              battleAction.effect = {
                                 "type":tmpEffect.type,
                                 "duration":int(tmpEffect.duration),
                                 "amount":int(tmpEffect.amount)
                              };
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               this.attacker.setBattleAction(battleAction);
               break;
            case "charge":
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_RESTRICT_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_RESTRICT_CHARGE))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               this.attacker.setCommand("charge");
               break;
            case "skill":
               attackerBuff = this.attacker.getBattleBuff();
               attackerDebuff = this.attacker.getBattleDebuff();
               skillData = Central.main.SKILL_DATA[battleCommand.skillId];
               cpRequired = skillData.cp;
               effect = {};
               if(this.attacker.isBattleSkillCooldown(skillData.id) == true && battleCommand.noCooldown == false)
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  cpRequired = 0;
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
               {
                  cpRequired = Math.round(cpRequired * (int(attackerBuff[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  cpRequired = Math.round(cpRequired * 1.4);
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
               {
                  cpRequired = Math.round(cpRequired * (1 - int(attackerBuff[BattleData.EFFECT_PET_SAVE_CP].amount) / 100));
               }
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
               {
                  cpRequired = Math.round(cpRequired * 2);
               }
               if(this.attacker.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  cpRequired = Math.round(cpRequired * (1 + int(attackerDebuff[BattleData.SKILL_341].amount) / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_TRANSFORM))
               {
                  cpRequired = Math.round(cpRequired * (1 + 300 / 100));
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_CP_LOCK))
               {
                  cpRequired = 0;
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING))
               {
                  cpRequired = cpRequired + Math.round(cpRequired * this.attacker.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount);
               }
               if(this.attacker.getBackItem())
               {
                  charBackItemEffect = Central.main.BACK_ITEM_DATA.find(this.attacker.getBackItem()).effect;
                  switch(charBackItemEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                        cpRequired = cpRequired - Math.round(cpRequired * charBackItemEffect.amount * 0.01);
                  }
               }
               checkReduceCpObj = this.checkWpnReduceCp(cpRequired);
               cpRequired = checkReduceCpObj.cpRequire;
               withoutCP = checkReduceCpObj.withoutCp;
               if(this.attacker.cp < cpRequired)
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               fiveElenemtArr = ["fire","wind","earth","water","lightning"];
               if(fiveElenemtArr.indexOf(String(skillData.type)) >= 0)
               {
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.SKILL_377))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
                  if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
                  {
                     this.attacker.setCommand("pass");
                     return;
                  }
               }
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  trace("this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF");
                  this.attacker.setCommand("pass");
                  return;
               }
               switch(skillData.effect.type)
               {
                  case SkillData.EFFECT_TYPE_HEAL:
                     heal = Formula.randomizeValue(skillData.damage);
                     effect.type = skillData.effect.type;
                     effect.duration = int(skillData.effect.duration) + 0;
                     effect.amount = int(skillData.effect.amount) + 0;
                     battleAction = {
                        "action":action,
                        "skillId":skillData.id,
                        "posType":skillData.posType,
                        "cp":cpRequired,
                        "heal":heal,
                        "effect":effect
                     };
                     this.defender = this.attacker;
                     break;
                  case BattleData.EFFECT_ALL_CP_HEAL:
                     heal = this.attacker.maxHP;
                     effect.type = skillData.effect.type;
                     effect.duration = int(skillData.effect.duration) + 0;
                     effect.amount = int(skillData.effect.amount) + 0;
                     battleAction = {
                        "action":action,
                        "skillId":skillData.id,
                        "posType":skillData.posType,
                        "cp":cpRequired,
                        "heal":heal,
                        "effect":effect
                     };
                     this.defender = this.attacker;
                     break;
                  case BattleData.EFFECT_HEAL_MEMBER:
                     if(Central.battle.holdTargetIsMember != null)
                     {
                        defender = Central.battle.holdTargetIsMember;
                     }
                     heal = defender.maxHP * 0.4;
                     regenCP = defender.maxCP * 0.4;
                     cpExtra = (attacker.cp - cpRequired) * skillData.effect.amount * 0.01;
                     effect.type = skillData.effect.type;
                     effect.duration = int(skillData.effect.duration) + 0;
                     effect.amount = int(skillData.effect.amount) + 0;
                     effect.cpDisplay = cpExtra;
                     effect.regenCP = regenCP;
                     battleAction = {
                        "action":action,
                        "skillId":skillData.id,
                        "posType":skillData.posType,
                        "cp":cpRequired + cpExtra,
                        "heal":heal,
                        "effect":effect
                     };
                     battleAction.selfhit = Math.round(attacker.hp * battleAction.effect.amount * 0.01);
                     battleAction.targetId = defender.getCharacterId();
                     break;
                  case SkillData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                     skill_hit_chance = skillData.skill_hit_chance;
                     dmg = this.calcSkillDamage(this.attacker,skillData);
                     effect.type = skillData.effect.type;
                     effect.duration = int(skillData.effect.duration) + 0;
                     effect.amount = int(skillData.effect.amount) + 0;
                     battleAction = {
                        "action":action,
                        "skillId":skillData.id,
                        "posType":skillData.posType,
                        "cp":cpRequired,
                        "dmg":dmg,
                        "effect":effect,
                        "skill_hit_chance":skill_hit_chance
                     };
                     battleAction.selfhit = Math.floor(this.attacker.hp * skillData.effect.amount * 0.01);
                     break;
                  default:
                     effect.type = skillData.effect.type;
                     skill_hit_chance = skillData.skill_hit_chance;
                     if(effect.type == BattleData.EFFECT_STUN)
                     {
                        effect.duration = int(skillData.effect.duration);
                     }
                     else
                     {
                        effect.duration = int(skillData.effect.duration);
                     }
                     effect.amount = int(skillData.effect.amount) + 0;
                     if(int(skillData.damage) == 0)
                     {
                        battleAction = {
                           "action":action,
                           "skillId":skillData.id,
                           "posType":skillData.posType,
                           "cp":cpRequired,
                           "effect":effect,
                           "skill_hit_chance":skill_hit_chance
                        };
                     }
                     else
                     {
                        dmg = this.calcSkillDamage(this.attacker,skillData);
                        battleAction = {
                           "action":action,
                           "skillId":skillData.id,
                           "posType":skillData.posType,
                           "cp":cpRequired,
                           "dmg":dmg,
                           "effect":effect,
                           "skill_hit_chance":skill_hit_chance
                        };
                     }
               }
               if(skillData.type == SkillData.TYPE_TAIJUTSU)
               {
                  battleAction.selfhit = !!battleAction.selfhit?battleAction.selfhit:0;
                  taijutsuDefaultSelfHit = Math.round(this.attacker.maxHP * 0.05);
                  selfhitmod = 1;
                  if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT))
                  {
                     selfhitmod = 1 - this.attacker.getBattleBuff()[BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT].amount / 100;
                  }
                  taijutsuDefaultSelfHit = Math.round(taijutsuDefaultSelfHit * selfhitmod);
                  battleAction.selfhit = battleAction.selfhit + taijutsuDefaultSelfHit;
               }
               if(battleAction.effect)
               {
                  if(battleAction.effect.type == BattleData.EFFECT_FINAL_ATTACK)
                  {
                     this.updateHP(this.attacker,1 - this.attacker.hp);
                  }
               }
               if(battleAction.selfhit)
               {
                  this.updateHP(this.attacker,0 - battleAction.selfhit);
               }
               if(battleCommand.noCooldown != true)
               {
                  this.attacker.setSkillCooldown(skillData);
               }
               Out.debug(this,"skillData.target >> " + skillData.target);
               switch(skillData.target)
               {
                  case SkillData.TARGET_SELF:
                     this.defender = this.attacker;
                     break;
                  case SkillData.TARGET_FRIENDLY:
                     battleAction.target = "friendly";
                     break;
                  case SkillData.TARGET_HOSTILE:
                     battleAction.target = "allEnemy";
               }
               if(withoutCP)
               {
                  battleAction.withoutCP = withoutCP;
               }
               this.attacker.setBattleAction(battleAction);
               break;
            case "dodge":
               this.attacker.setCommand("dodge");
               break;
            case "item":
               battleAction = {
                  "action":action,
                  "item":battleCommand.item
               };
               this.attacker.setBattleAction(battleAction);
               break;
            case "bloodline":
               if(this.attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  this.attacker.setCommand("pass");
                  return;
               }
               this.attacker.setBattleAction(battleCommand);
               break;
            case "senjutsu":
               this.attacker.setBattleAction(battleCommand);
               break;
            case "class_skill":
               skillData = Central.main.SKILL_DATA[battleCommand.skillId];
               effect = {};
               effect.type = skillData.effect.type;
               effect.duration = int(skillData.effect.duration) + 0;
               effect.amount = int(skillData.effect.amount) + 0;
               if(effect.type == BattleData.SKILL_2004)
               {
                  battleAction = {
                     "action":action,
                     "skillId":battleCommand.skillId,
                     "posType":skillData.posType,
                     "dmg":0,
                     "effect":effect
                  };
               }
               else
               {
                  battleAction = {
                     "action":action,
                     "skillId":battleCommand.skillId,
                     "posType":skillData.posType,
                     "effect":effect
                  };
               }
               this.attacker.setBattleAction(battleAction);
               break;
            default:
               this.attacker.setCommand("pass");
         }
      }
      
      private function checkWpnReduceCp(cpRequired:int) : Object
      {
         var withoutCP:Boolean = false;
         var rNum:Number = NaN;
         var tmpEffect:Object = null;
         var cpRequiredObj:Object = {};
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                     if(tmpEffect.amount > 0)
                     {
                        cpRequired = Math.round(cpRequired * (tmpEffect.amount / 100));
                        withoutCP = false;
                     }
                     else if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                     {
                        cpRequired = 0;
                        withoutCP = true;
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         cpRequiredObj.cpRequire = cpRequired;
         cpRequiredObj.withoutCp = withoutCP;
         return cpRequiredObj;
      }
      
      private function setPetCommand(battleCommand:Object) : void
      {
         var defenderDebuff:Object = this.defender.getBattleDebuff();
         if(defenderDebuff[BattleData.EFFECT_SLEEP] != null)
         {
            if(int(defenderDebuff[BattleData.EFFECT_SLEEP].duration) > 0)
            {
               this.attacker.setCommand("pass");
               return;
            }
         }
         this.attacker.setBattleAction();
         this.setDefenderById(Central.battle.getDefender().getCharacterId());
      }
      
      private function checkDodge() : void
      {
         var key:* = null;
         var tmpEffect:Object = null;
         var skillData:Object = null;
         var dodgeAmount:Number = NaN;
         var hpPresent:Number = NaN;
         var gearObj:Object = null;
         var attackerGearset:Object = null;
         var setEffect:Object = null;
         var tmpInt:int = 0;
         var currTmpInt:int = 0;
         var buff:* = undefined;
         var defenderWeapon:Object = null;
         var battleAction:Object = this.attacker.getBattleAction();
         var i:int = 0;
         battleAction.dodge = false;
         this.attacker.setBattleAction(battleAction);
         if(this.attacker.side == this.defender.side)
         {
            return;
         }
         if(battleAction.action == BattleData.ACTION_SKILL)
         {
            skillData = Central.main.SKILL_DATA[battleAction.skillId];
            switch(skillData.effect_nature)
            {
               case SkillData.NATURE_BUFF:
                  return;
            }
         }
         var attackerBuff:Object = this.attacker.getBattleBuff();
         var attackerDebuff:Object = this.attacker.getBattleDebuff();
         var defenderBuff:Object = defender.getBattleBuff();
         var defenderDebuff:Object = defender.getBattleDebuff();
         var dodgeRandom:Number = NumberUtil.getRandom();
         var dodgeReduction:Number = 0;
         var dodgeBonus:Number = 0;
         dodgeBonus = dodgeBonus + this.defender.dodgeBonus;
         var BloodlineDodgeBonus:int = this.CalculateBloodlineDodgebonus();
         dodgeBonus = dodgeBonus + BloodlineDodgeBonus;
         var SenjutsuDodgeBonus:Number = this.CalculateSenjutsuDodgebonus();
         dodgeBonus = dodgeBonus + SenjutsuDodgeBonus;
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(int(attackerBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        dodgeReduction = dodgeReduction + Number(attackerBuff[key].amount) / 100;
                        continue;
                     case BattleData.SKILL_234:
                        dodgeReduction = dodgeReduction + Number(attackerBuff[key].amount) / 100;
                        if(attackerBuff[key].amount == 100)
                        {
                           dodgeReduction = dodgeReduction + 99999;
                        }
                        continue;
                     case BattleData.EFFECT_PET_ATTENTION:
                        dodgeReduction = dodgeReduction + int(attackerBuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        dodgeReduction = dodgeReduction + int(attackerBuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_ACCURATE:
                        dodgeReduction = dodgeReduction + int(attackerBuff[key].amount) / 100;
                        continue;
                     case BloodlineData.EFFECT_DMG_BONUS_AND_DODGE_REDUCTION:
                        dodgeReduction = dodgeReduction + int(attackerBuff[key].amount) / 100;
                        continue;
                     case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                        if(this.attacker.hp / this.attacker.maxHP <= attackerBuff[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount * 0.01)
                        {
                           dodgeReduction = dodgeReduction + Number(attackerBuff[key].amount) / 100;
                        }
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
         for(key in attackerDebuff)
         {
            if(attackerDebuff[key])
            {
               if(int(attackerDebuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_BLIND:
                     case BattleData.EFFECT_ALL_CP_BLIND:
                        dodgeBonus = dodgeBonus + Number(attackerDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_PET_BLIND:
                        dodgeBonus = dodgeBonus + Number(attackerDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_DARKNESS:
                        dodgeBonus = dodgeBonus + int(attackerDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_ACCURATE_WEAPON:
                        dodgeBonus = dodgeBonus + int(attackerDebuff[key].amount) / 100;
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
         for(key in defenderBuff)
         {
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                     case BattleData.EFFECT_DODGE_BONUS:
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        dodgeBonus = dodgeBonus + int(defenderBuff[key].amount) / 100;
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
         for(key in defenderDebuff)
         {
            if(defenderDebuff[key])
            {
               if(int(defenderDebuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        dodgeReduction = dodgeReduction + Number(defenderDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        dodgeReduction = dodgeReduction + Number(defenderDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                        dodgeReduction = dodgeReduction + Number(defenderDebuff[key].amount) / 100;
                        continue;
                     case BattleData.EFFECT_DARKNESS:
                        dodgeReduction = dodgeReduction + int(defenderDebuff[key].amount) / 100;
                        continue;
                     case BattleData.SKILL_342:
                        dodgeReduction = dodgeReduction + int(defenderDebuff[key].amount) / 100;
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
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_BONUS:
                     dodgeBonus = dodgeBonus + tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     dodgeRandom = dodgeRandom + tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     dodgeReduction = dodgeReduction + tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
                     dodgeAmount = tmpEffect.amount;
                     hpPresent = tmpEffect.chance;
                     if(this.attacker.hp >= Math.round(this.attacker.maxHP * (hpPresent / 100)))
                     {
                        dodgeReduction = dodgeReduction + dodgeAmount / 100;
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(tmpEffect in this.attackerBackItem.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     dodgeRandom = dodgeRandom + tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                     dodgeRandom = dodgeRandom - tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     dodgeReduction = dodgeReduction + tmpEffect.amount / 100;
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(tmpEffect in this.attackerAccessory.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_DODGE_RANDOM:
                     dodgeRandom = dodgeRandom + tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                     dodgeRandom = dodgeRandom - tmpEffect.amount / 100;
                     continue;
                  case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                     dodgeReduction = dodgeReduction + tmpEffect.amount / 100;
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attacker.getGearset())
         {
            gearObj = this.attacker.getGearset();
            for(key in gearObj)
            {
               attackerGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = attackerGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                        dodgeReduction = dodgeReduction + tmpEffect.amount / 100;
                  }
               }
            }
         }
         if(battleAction.action == BattleData.ACTION_CLASS_SKILL)
         {
            if(battleAction.effect.type == BattleData.SKILL_2004)
            {
               dodgeReduction = dodgeReduction + 1;
            }
         }
         if(battleAction.action == BattleData.ACTION_SKILL)
         {
            if(battleAction.effect.type == BattleData.EFFECT_HUNDRED_PERCENT_ATTACK || battleAction.effect.type == BattleData.EFFECT_BURN_CP_CLEAR_BUFF || battleAction.effect.type == BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK || battleAction.skillId == "skill709")
            {
               dodgeReduction = dodgeReduction + 999;
            }
            else if(battleAction.skillId == "skill669")
            {
               dodgeReduction = dodgeReduction + 999;
            }
            else if(battleAction.effect.type == BattleData.EFFECT_BURN_CP_HP)
            {
               dodgeReduction = dodgeReduction + int(battleAction.effect.duration) * 0.01;
            }
         }
         if(battleAction.actoin == BattleData.ACTION_SKILL)
         {
            if(battleAction.effect)
            {
               if(battleAction.effect.type == BattleData.EFFECT_CRITICAL_DMG_N_DODGE_REDUCTION)
               {
                  tmpInt = 0;
                  switch(battleAction.target)
                  {
                     case "allEnemy":
                        for(i = 0; i < this.characterArr.length; i++)
                        {
                           if(this.characterArr[i].isDead == false && this.characterArr[i].side == this.defender.side)
                           {
                              currTmpInt = 0;
                              for(buff in this.characterArr[i].getBattleBuff())
                              {
                                 if(this.characterArr[i].getBattleBuff()[buff].druration < 999)
                                 {
                                    currTmpInt++;
                                 }
                              }
                              if(currTmpInt > tmpInt)
                              {
                                 tmpInt = currTmpInt;
                              }
                           }
                        }
                  }
                  dodgeReduction = dodgeReduction + battleAction.effect.amount * tmpInt * 0.01;
               }
            }
         }
         if(defender.dodge - dodgeReduction >= dodgeRandom - dodgeBonus && defender.getData(DBCharacterData.AGILITY) > 0)
         {
            Out.debug(this,"seal enemy dogde");
            battleAction.dodge = true;
         }
         else
         {
            Out.debug(this,"seal enemy hasn\'t dogde");
            battleAction.dodge = false;
         }
         if(this.defender.getWeapon())
         {
            defenderWeapon = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
            if(defenderWeapon)
            {
               for each(tmpEffect in defenderWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                        if(battleAction.dodge)
                        {
                           battleAction.defenderBuff.push({
                              "type":BattleData.EFFECT_DAMAGE_BONUS,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           });
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(Central.mission.curMissionID == "msn0")
         {
            battleAction.dodge = false;
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkCritical() : void
      {
         var key:* = null;
         var tmpEffect:Object = null;
         var gearObj:Object = null;
         var attackerGearset:Object = null;
         var i:int = 0;
         var setEffect:Object = null;
         var rNum:Number = NumberUtil.getRandom();
         var criticalChance:Number = Formula.calcCritical(this.attacker,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
         var attackerDebuff:Object = this.attacker.getBattleDebuff();
         var attackerBuff:Object = this.attacker.getBattleBuff();
         var defenderDebuff:Object = this.defender.getBattleDebuff();
         var battleAction:Object = this.attacker.getBattleAction();
         battleAction.critical = false;
         if(battleAction.dodge == true || battleAction.dmg == null)
         {
            battleAction.critical = false;
            this.attacker.setBattleAction(battleAction);
            return;
         }
         for(key in attackerDebuff)
         {
            if(attackerDebuff[key])
            {
               if(attackerDebuff[key].duration > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_DISTRACT:
                        rNum = rNum + attackerDebuff[key].amount;
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
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        rNum = rNum - 0.15;
                        continue;
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                        rNum = rNum - attackerBuff[key].amount / 100;
                        continue;
                     case SenjutsuData.EFFECT_SS_CRITICAL_CHANCE_BONUS:
                        if(attacker.hp * 100 / attacker.maxHP < attackerBuff[key].amount)
                        {
                           rNum = rNum - attackerBuff[key].chancetoeffect / 100;
                        }
                        Out.debug(this,"EFFECT_SS_CRITICAL_CHANCE_BONUS rNum >> " + rNum);
                        continue;
                     case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                        rNum = rNum - attackerBuff[key].amount / 100;
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
         if(this.attacker.getGearset())
         {
            gearObj = this.attacker.getGearset();
            for(key in gearObj)
            {
               attackerGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = attackerGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        rNum = rNum - setEffect.amount * 0.01;
                  }
               }
            }
         }
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     rNum = rNum - tmpEffect.amount / 100;
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(tmpEffect in this.attackerBackItem.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     rNum = rNum - tmpEffect.amount / 100;
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(tmpEffect in this.attackerAccessory.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                     rNum = rNum - tmpEffect.amount / 100;
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(battleAction.effect)
         {
            if(battleAction.effect.type == BattleData.SKILL_304)
            {
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_302))
               {
                  rNum = 0;
               }
            }
         }
         if(rNum <= criticalChance)
         {
            battleAction.critical = true;
         }
         if(Central.mission.curMissionID == "msn0")
         {
            battleAction.critical = false;
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkStun() : void
      {
         var i:uint = 0;
         var chance:Number = NaN;
         var res:Array = null;
         var effectType:String = null;
         var checkBloodLineResistance:Boolean = false;
         var battleAction:Object = this.attacker.getBattleAction();
         if(battleAction.dodge == true)
         {
            battleAction.stun = false;
            this.attacker.setBattleAction(battleAction);
            return;
         }
         var stunRandom:Number = NumberUtil.getRandom();
         var stunReduction:int = 0;
         this.defender.reseteffectResistance();
         this.attacker.reseteffectResistance();
         this.defender.initResistance();
         this.attacker.initResistance();
         if(battleAction.effect)
         {
            if(this.defender.effectResistance)
            {
               res = this.defender.effectResistance;
               for(i = 0; i < res.length; i++)
               {
                  checkBloodLineResistance = false;
                  chance = NumberUtil.getRandom();
                  if(battleAction.action == "skill")
                  {
                     if(res[i].type == battleAction.effect.type && chance <= res[i].change / 100)
                     {
                        stunReduction = 1;
                     }
                  }
                  if(battleAction.action == "bloodline")
                  {
                     if(battleAction.effect.effect_type_1 && battleAction.effect.effect_type_1 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_1 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_1"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_1)
                        {
                           battleAction.effect["effect_resisted_1"] = false;
                        }
                     }
                     if(battleAction.effect.effect_type_2 && battleAction.effect.effect_type_2 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_2 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_2"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_2)
                        {
                           battleAction.effect["effect_resisted_2"] = false;
                        }
                     }
                     if(battleAction.effect.effect_type_3 && battleAction.effect.effect_type_3 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_3 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_3"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_3)
                        {
                           battleAction.effect["effect_resisted_3"] = false;
                        }
                     }
                  }
                  if(battleAction.action == "senjutsu")
                  {
                     if(battleAction.effect.effect_type_1 && battleAction.effect.effect_type_1 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_1 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_1"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_1)
                        {
                           battleAction.effect["effect_resisted_1"] = false;
                        }
                     }
                     if(battleAction.effect.effect_type_2 && battleAction.effect.effect_type_2 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_2 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_2"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_2)
                        {
                           battleAction.effect["effect_resisted_2"] = false;
                        }
                     }
                     if(battleAction.effect.effect_type_3 && battleAction.effect.effect_type_3 != "")
                     {
                        if(res[i].type == battleAction.effect.effect_type_3 && chance <= res[i].change / 100)
                        {
                           battleAction.effect["effect_resisted_3"] = true;
                           stunReduction = 1;
                        }
                        else if(res[i].type == battleAction.effect.effect_type_3)
                        {
                           battleAction.effect["effect_resisted_3"] = false;
                        }
                     }
                  }
               }
            }
         }
         battleAction.stun = true;
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkDamageModifier() : void
      {
         var battleAction:Object = this.attacker.getBattleAction();
         if(battleAction.dodge == true || battleAction.dmg == null)
         {
            return;
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkFeedback() : void
      {
         var rNum:Number = NaN;
         var defenderBuff:Object = null;
         var feedbackChance:Number = NaN;
         var reactiveBonus:Number = NaN;
         var tmpEffect:Object = null;
         var debuffRandom:int = 0;
         var reactiveEffect:Object = null;
         var defenderWeapon:Object = null;
         var defenderAccessory:Object = null;
         var reactive_force_feedback:Object = null;
         var Berserker_mode_feedback:Object = null;
         var chance:* = undefined;
         var rand:int = 0;
         var passiveStunEffect:Object = null;
         var passiveStunFeedback:Object = null;
         var feedbackSkipCheckObj:Object = null;
         var feedbackObj:Object = null;
         var battleAction:Object = this.attacker.getBattleAction();
         if(battleAction.dodge == true)
         {
            battleAction.feedback = null;
            battleAction.AttackerRandomSkillSlot = 999;
            battleAction.DefenderRandomSkillSlot = 999;
            this.attacker.setBattleAction(battleAction);
            return;
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            trace("checkFeedback 111111111111111111111111111111111111111111111111");
            return;
         }
         if(this.attacker != this.defender)
         {
            defenderBuff = this.defender.getBattleBuff();
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_REACTIVE_DEBUFF) && this.attacker.type != this.attacker.TYPE_PET)
            {
               debuffRandom = NumberUtil.randomInt(1,4);
               reactiveEffect = {};
               switch(debuffRandom)
               {
                  case 1:
                     reactiveEffect.type = BattleData.EFFECT_STUN;
                     break;
                  case 2:
                     reactiveEffect.type = BattleData.EFFECT_SLEEP;
                     break;
                  case 3:
                     reactiveEffect.type = BattleData.EFFECT_BUNDLE;
                     break;
                  default:
                     reactiveEffect.type = BattleData.EFFECT_MERIDIANS_SEAL;
               }
               reactiveEffect.duration = defenderBuff[BattleData.EFFECT_REACTIVE_DEBUFF].amount;
               reactiveEffect.amount = 0;
               battleAction.reactiveEffect = this.setDebuff(this.attacker,reactiveEffect);
               defender.removeBuff(BattleData.EFFECT_REACTIVE_DEBUFF);
            }
            feedbackChance = 0;
            reactiveBonus = 0;
            if(int(this.defender.getData(DBCharacterData.EARTH)) >= 0)
            {
               feedbackChance = feedbackChance + int(this.defender.getData(DBCharacterData.EARTH)) * (4 / 1000);
            }
            if(this.defender.getWeapon())
            {
               defenderWeapon = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
               if(defenderWeapon)
               {
                  for each(tmpEffect in defenderWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                           feedbackChance = feedbackChance + tmpEffect.amount / 100;
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.defender.getAccessory())
            {
               defenderAccessory = Central.main.ACCESSORY_DATA.find(this.defender.getAccessory());
               if(defenderAccessory)
               {
                  for each(tmpEffect in defenderAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                           feedbackChance = feedbackChance + tmpEffect.amount * 0.01;
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_REACTIVE_FORCE))
            {
               feedbackChance = feedbackChance + int(defenderBuff[BattleData.EFFECT_REACTIVE_FORCE].chance) / 100;
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_SAND_GUARD))
            {
               feedbackChance = feedbackChance + (int(defenderBuff[BattleData.EFFECT_SAND_GUARD].amount) + 10) / 100;
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_PET_ENERGIZE))
            {
               feedbackChance = feedbackChance + int(this.defender.getBattleBuff()[BattleData.EFFECT_PET_ENERGIZE].amount) / 100;
            }
            if(this.defender.isBattleDebuffActive(BattleData.EFFECT_PET_DISORIENTED))
            {
               feedbackChance = feedbackChance - int(this.defender.getBattleDebuff()[BattleData.EFFECT_PET_DISORIENTED].amount) / 100;
            }
            if(this.defender.isBattleDebuffActive(BattleData.SKILL_304))
            {
               feedbackChance = feedbackChance - int(this.defender.getBattleDebuff()[BattleData.SKILL_304].amount) / 100;
            }
            rNum = NumberUtil.getRandom();
            if(feedbackChance >= rNum)
            {
               reactive_force_feedback = {};
               reactive_force_feedback.damage = Math.round(Math.abs(battleAction.dmg) * (0.3 + reactiveBonus));
               reactive_force_feedback.type = BattleData.EFFECT_REACTIVE_FORCE;
               this.setBattleActionFeedback(battleAction,reactive_force_feedback);
            }
            if(this.defender.isBattleBuffActive(BattleData.EFFECT_BERSERKER_MODE))
            {
               if(battleAction.action != "class_skill" || battleAction.action == "class_skill" && battleAction.effect.type != BattleData.SKILL_2004)
               {
                  Berserker_mode_feedback = {};
                  Berserker_mode_feedback.damage = Math.round(Math.abs(battleAction.dmg));
                  Berserker_mode_feedback.type = BattleData.EFFECT_BERSERKER_MODE;
                  this.setBattleActionFeedback(battleAction,Berserker_mode_feedback);
               }
            }
            if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_PASSIVE_STUN + ".skill1039"))
            {
               chance = int(defenderBuff[BloodlineData.EFFECT_PASSIVE_STUN + ".skill1039"].chancetohit);
               rand = Math.random() * 100;
               if(rand < chance)
               {
                  passiveStunEffect = {};
                  passiveStunEffect.type = BattleData.EFFECT_STUN;
                  passiveStunEffect.duration = 2;
                  this.setDebuff(this.attacker,passiveStunEffect);
                  passiveStunFeedback = {};
                  passiveStunFeedback.type = BloodlineData.EFFECT_PASSIVE_STUN;
                  this.setBattleActionFeedback(battleAction,passiveStunFeedback);
               }
            }
            if(battleAction.feedback_skipcheck)
            {
               for each(feedbackSkipCheckObj in battleAction.feedback_skipcheck)
               {
                  if(!battleAction.feedback)
                  {
                     battleAction.feedback = new Array();
                  }
                  battleAction.feedback.push(feedbackSkipCheckObj);
               }
               delete battleAction.feedback_skipcheck;
            }
            if(battleAction.feedback != null)
            {
               for each(feedbackObj in battleAction.feedback)
               {
                  if(this.defender.hp > 0)
                  {
                     if(feedbackObj.damage)
                     {
                        this.updateHP(this.attacker,0 - feedbackObj.damage);
                     }
                  }
               }
            }
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      private function checkFeedbackEffectBefore() : void
      {
         var rNum:Number = NaN;
         var key:* = null;
         var skillData:Object = null;
         var BLkeyArr:Array = null;
         var BLkey:String = null;
         var BLSkillID:String = null;
         var isReflected:Boolean = false;
         var battleAction:Object = this.attacker.getBattleAction();
         var defenderBuff:Object = this.defender.getBattleBuff();
         for(key in defenderBuff)
         {
            BLkeyArr = [];
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(defenderBuff[key].chancetoeffect == null)
                  {
                     if(int(defenderBuff[key].chancetoeffect) <= 0)
                     {
                        BLkey = null;
                     }
                  }
                  if(BLkey != null)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           rNum = NumberUtil.getRandom();
                           if(rNum <= int(defenderBuff[key].chancetoeffect) / 100)
                           {
                              battleAction.rebound = true;
                              battleAction.reboundDamage = int(defenderBuff[key].amount);
                           }
                           continue;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           rNum = NumberUtil.getRandom();
                           if(rNum <= int(defenderBuff[key].chancetoeffect) / 100)
                           {
                              if(battleAction.action == BattleData.ACTION_SKILL && this.attacker.getCharacterId() != this.defender.getCharacterId())
                              {
                                 skillData = Central.main.SKILL_DATA[battleAction.skillId];
                                 if(skillData)
                                 {
                                    if(skillData.type == SkillData.TYPE_GENJUTSU)
                                    {
                                       isReflected = true;
                                       if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BUNDLE) || this.defender.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL) || this.defender.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND) || this.defender.isBattleDebuffActive(BattleData.EFFECT_STUN) || this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP) || this.defender.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK) || this.defender.isBattleDebuffActive(BattleData.SKILL_377))
                                       {
                                          isReflected = false;
                                       }
                                       if(skillData.target == SkillData.TARGET_SINGLE_FRIENDLY)
                                       {
                                          isReflected = false;
                                       }
                                       if(isReflected)
                                       {
                                          battleAction.reflectEffect = battleAction.effect;
                                          battleAction.reflectEffect.resisted = false;
                                          battleAction.effect = null;
                                       }
                                    }
                                 }
                              }
                           }
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
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkFeedbackEffectAfter() : void
      {
         var rNum:Number = NaN;
         var key:* = null;
         var skillData:Object = null;
         var BLkeyArr:Array = null;
         var BLkey:String = null;
         var BLSkillID:String = null;
         var Arr_Ninjutsu_Type:Array = null;
         var battleAction:Object = this.attacker.getBattleAction();
         var defenderBuff:Object = this.defender.getBattleBuff();
         battleAction = this.reactiveBufforDebuffTarget(battleAction);
         for(key in defenderBuff)
         {
            BLkeyArr = [];
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(defenderBuff[key].chancetoeffect == null)
                  {
                     if(int(defenderBuff[key].chancetoeffect) <= 0)
                     {
                        BLkey = null;
                     }
                  }
                  if(BLkey != null)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           rNum = NumberUtil.getRandom();
                           if(rNum <= int(defenderBuff[key].chancetoeffect) / 100)
                           {
                              if(battleAction.action == BattleData.ACTION_SKILL && this.attacker.getCharacterId() != this.defender.getCharacterId())
                              {
                                 Arr_Ninjutsu_Type = [];
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_GENJUTSU);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_TAIJUTSU);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_EARTH);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_FIRE);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_LIGHTNING);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_WATER);
                                 Arr_Ninjutsu_Type.push(SkillData.TYPE_WIND);
                                 skillData = Central.main.SKILL_DATA[battleAction.skillId];
                                 if(skillData)
                                 {
                                    if(Arr_Ninjutsu_Type.indexOf(skillData.type) >= 0 && this.defender.cp >= battleAction.cp && !this.defender.isBattleDebuffActive(BattleData.EFFECT_BUNDLE) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_STUN) && !this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP) && !this.defender.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK) && !this.defender.isBattleDebuffActive(BattleData.SKILL_377))
                                    {
                                       battleAction.copyJutsu = true;
                                    }
                                    if(battleAction.effect)
                                    {
                                       if(battleAction.effect.type == BattleData.EFFECT_STUN && battleAction.stun == true)
                                       {
                                          battleAction.copyJutsu = false;
                                       }
                                       if(battleAction.effect.target == SkillData.TARGET_SINGLE_FRIENDLY)
                                       {
                                          battleAction.copyJutsu = false;
                                       }
                                    }
                                 }
                              }
                           }
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
         this.attacker.setBattleAction(battleAction);
      }
      
      private function checkExtraAttack() : void
      {
         var rNum:Number = NaN;
         var i:int = 0;
         var damage:int = 0;
         var BloodlineList_TITAN:Array = null;
         var Skill1021_Lv:int = 0;
         var b:int = 0;
         var BloodlineskillData_TITAN:Object = null;
         var BloodlineskillData_effect_TITAN:Object = null;
         var effect:Object = null;
         var chance:Number = NaN;
         var res:Array = null;
         var effectType:String = null;
         var battleAction:Object = this.attacker.getBattleAction();
         var firstTimeTitan:Boolean = false;
         var haveDmg:Boolean = false;
         battleAction.titan = false;
         if(battleAction.action == "bloodline")
         {
            if(battleAction.effect.effect_type_1 == BloodlineData.EFFECT_TITAN || battleAction.effect.effect_type_2 == BloodlineData.EFFECT_TITAN || battleAction.effect.effect_type_3 == BloodlineData.EFFECT_TITAN)
            {
               firstTimeTitan = true;
            }
         }
         var dmgArr:Array = battleAction.dmgArr;
         if(dmgArr)
         {
            for(i = 0; i < dmgArr.length; i++)
            {
               if(dmgArr[i].dmg != 0)
               {
                  haveDmg = true;
               }
            }
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_TITAN) && firstTimeTitan == false)
         {
            if(this.attacker.hp > 0 && this.defender.hp > 0 && this.attacker.getCharacterId() != this.defender.getCharacterId() && this.attacker.side != this.defender.side && battleAction.dmg != null && haveDmg == true)
            {
               i = 0;
               damage = 0;
               BloodlineList_TITAN = this.attacker.getBloodlineListArr();
               Skill1021_Lv = 0;
               for(b = 0; b < BloodlineList_TITAN.length; b++)
               {
                  if(BloodlineList_TITAN[b].skill_id == "1021")
                  {
                     Skill1021_Lv = BloodlineList_TITAN[b].level;
                  }
               }
               rNum = NumberUtil.getRandom();
               if(rNum <= Skill1021_Lv / 100)
               {
                  battleAction.titanstun = true;
               }
               else
               {
                  battleAction.titanstun = false;
               }
               BloodlineskillData_TITAN = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1021"];
               BloodlineskillData_effect_TITAN = {};
               for(i = 0; i < 10; i++)
               {
                  if(BloodlineskillData_TITAN.effect[i].skill_level == Skill1021_Lv)
                  {
                     BloodlineskillData_effect_TITAN = BloodlineskillData_TITAN.effect[i];
                  }
               }
               damage = Math.round(BloodlineskillData_effect_TITAN.skill_damage / 100 * this.attacker.getLevel());
               if(battleAction.critical)
               {
                  damage = damage * attacker.criticalBonus;
               }
               battleAction.titan = true;
               battleAction.titanDamage = damage;
               if(battleAction.titanstun == true)
               {
                  effect = {
                     "type":BloodlineData.EFFECT_STUN,
                     "duration":2,
                     "amount":0
                  };
                  this.defender.initResistance();
                  if(this.defender.effectResistance)
                  {
                     res = this.defender.effectResistance;
                     for(i = 0; i < res.length; i++)
                     {
                        chance = NumberUtil.getRandom();
                        if(res[i].type == effect.type && chance <= res[i].change / 100)
                        {
                           effect["resisted"] = true;
                        }
                     }
                  }
                  battleAction.titanEffect = this.setDebuff(this.defender,effect);
               }
            }
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function checkExtraTurn() : Boolean
      {
         var battleAction:Object = this.attacker.getBattleAction();
         var tmpAttacker:* = this.attacker;
         var tmpDefender:* = this.defender;
         if(battleAction)
         {
            if(battleAction.copyJutsu == true)
            {
               this.attacker = tmpDefender;
               this.defender = tmpAttacker;
               this.setCharacterCommand({
                  "action":"skill",
                  "skillId":battleAction.skillId,
                  "noCooldown":true
               });
               this.finalizeBattleAction();
               return true;
            }
            if(battleAction.stealSkillId)
            {
               Out.debug(this,"stealSkillId is not null");
               this.setCharacterCommand({
                  "action":"skill",
                  "skillId":battleAction.stealSkillId,
                  "noCooldown":true
               });
               this.finalizeBattleAction();
               return true;
            }
            Out.debug(this,"stealSkillId is null");
         }
         return false;
      }
      
      private function processBattleAction() : void
      {
         var battleAction:Object = null;
         var effect:Object = null;
         var i:* = undefined;
         var j:int = 0;
         var key:String = null;
         var rNum:Number = NaN;
         var tmpAmt:int = 0;
         var cpBonusPercent:Number = NaN;
         var cpBonus:int = 0;
         var hpBonus:int = 0;
         var tmpEffect:Object = null;
         var cpRestore:int = 0;
         var skillData:Object = null;
         var amount:int = 0;
         var itemData:Object = null;
         var Item_restore_HP:int = 0;
         var Item_restore_CP:int = 0;
         var Item_Restore_Pet_CP:int = 0;
         var BloodLineAmt:int = 0;
         var SenjutsuAmt:int = 0;
         var max:int = 0;
         var min:int = 0;
         var allowedNaturalRegeneration:Array = null;
         var tmpDamageCP:int = 0;
         Out.debug("[rockman]","\n-----------------------------------------------------------------------------------------------------\n");
         Out.debug("[rockman]","battleProcessor  processbattleAction start");
         battleAction = this.attacker.getBattleAction();
         var attackerBuff:Object = this.attacker.getBattleBuff();
         var attackerDebuff:Object = this.attacker.getBattleDebuff();
         var defenderBuff:Object = this.defender.getBattleBuff();
         var defenderDebuff:Object = this.defender.getBattleDebuff();
         this.HpCondition = true;
         this.CpCondition = true;
         for(j = 0; j < Central.main.battleRuleArr.length; j++)
         {
            switch(Central.main.battleRuleArr[j].attribute)
            {
               case EnemyAttributeData.HP:
                  if(Central.main.battleRuleArr[j].type == EnemyAttributeData.OVER)
                  {
                     this.HpCondition = this.attacker.hp / this.attacker.maxHP * 100 >= Central.main.battleRuleArr[j].amount?true:false;
                  }
                  else
                  {
                     this.HpCondition = this.attacker.hp / this.attacker.maxHP * 100 <= Central.main.battleRuleArr[j].amount?true:false;
                  }
                  break;
               case EnemyAttributeData.CP:
                  if(Central.main.battleRuleArr[j].type == EnemyAttributeData.OVER)
                  {
                     this.CpCondition = this.attacker.cp / this.attacker.maxCP * 100 >= Central.main.battleRuleArr[j].amount?true:false;
                  }
                  else
                  {
                     this.CpCondition = this.attacker.cp / this.attacker.maxCP * 100 <= Central.main.battleRuleArr[j].amount?true:false;
                  }
            }
         }
         if(this.defender.isBattleBuffActive(SenjutsuData.EFFECT_SS_IGNORE_DMG) && this.attacker.type != this.attacker.TYPE_PET)
         {
            rNum = NumberUtil.getRandom();
            if((this.defender.sp >= defenderBuff[SenjutsuData.EFFECT_SS_IGNORE_DMG].amount || this.defender.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE)) && rNum < defenderBuff[SenjutsuData.EFFECT_SS_IGNORE_DMG].chancetohit * 0.01)
            {
               battleAction.dmg = 0;
               battleAction.effect = null;
               this.attacker.setBattleAction(battleAction);
            }
         }
         switch(battleAction.action)
         {
            case "attack":
               this.hitTarget();
               break;
            case "weapon_attack":
               this.hitTarget();
               break;
            case "charge":
               cpBonusPercent = 0;
               cpBonus = 0;
               hpBonus = 0;
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER))
               {
                  cpBonusPercent = this.attacker.getBattleBuff()[BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER].amount;
                  cpBonus = cpBonus + Math.round(this.attacker.maxCP * (cpBonusPercent / 100));
               }
               if(this.attacker.isBattleBuffActive(BattleData.EFFECT_EXTRA_CP_RECOVER))
               {
                  cpBonusPercent = this.attacker.getBattleBuff()[BattleData.EFFECT_EXTRA_CP_RECOVER].amount;
                  cpBonus = cpBonus + Math.round(this.attacker.maxCP * (cpBonusPercent / 100));
               }
               if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_PET_REDUCE_CHARGE))
               {
                  cpBonusPercent = this.attacker.getBattleBuff()[BattleData.EFFECT_PET_REDUCE_CHARGE].amount;
                  cpBonus = cpBonus - Math.round(this.attacker.maxCP * BattleData.CHAKRA_RECOVER_CHARGE * cpBonusPercent / 100);
               }
               if(this.attackerBackItem)
               {
                  for each(tmpEffect in this.attackerBackItem.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_CHARGE_CP_BONUS:
                           cpBonus = cpBonus + Math.round(this.attacker.maxCP * (tmpEffect.amount / 100));
                           continue;
                        case BattleData.EFFECT_CHARGE_RECOVER_HP:
                           hpBonus = hpBonus + Math.round(this.attacker.maxHP * (tmpEffect.amount / 100));
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               tmpEffect = null;
               if(this.attackerAccessory)
               {
                  for each(tmpEffect in this.attackerAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_CHARGE_CP_BONUS:
                           cpBonus = cpBonus + Math.round(this.attacker.maxCP * (tmpEffect.amount / 100));
                           continue;
                        case BattleData.EFFECT_CHARGE_RECOVER_HP:
                           hpBonus = hpBonus + Math.round(this.attacker.maxHP * (tmpEffect.amount / 100));
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               if(hpBonus > 0)
               {
                  battleAction.restoreHp = this.updateHP(this.attacker,hpBonus);
               }
               cpRestore = Math.round(this.attacker.maxCP * BattleData.CHAKRA_RECOVER_CHARGE + cpBonus);
               battleAction.cpRestore = this.updateCP(this.attacker,cpRestore);
               break;
            case "skill":
               if(Central.mission.curMissionID == "msn0")
               {
                  Central.main.tutorialMsnStep++;
               }
               if(this.attackerWeapon)
               {
                  for each(tmpEffect in this.attackerWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_CP_CONSUME_TO_HP:
                           battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + Math.round(battleAction.cp * (tmpEffect.amount / 100));
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               skillData = Central.main.SKILL_DATA[battleAction.skillId];
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_251))
               {
                  if(skillData.type == SkillData.TYPE_EARTH && skillData.id != "skill251")
                  {
                     battleAction.attackerBuff.push({
                        "type":BattleData.EFFECT_COMPLETE_GUARD,
                        "duration":2,
                        "amount":0
                     });
                  }
               }
               if(this.attacker.isBattleBuffActive(BattleData.SKILL_302))
               {
                  if(skillData.type == SkillData.TYPE_LIGHTNING)
                  {
                     if(this.attacker != this.defender)
                     {
                        this.defender.setBattleDebuff({
                           "type":BattleData.EFFECT_STUN,
                           "duration":2,
                           "amount":0
                        });
                     }
                  }
               }
               switch(String(skillData.effect.type))
               {
                  case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                  case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                  case BattleData.EFFECT_ALL_CP_BLIND:
                  case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  case BattleData.EFFECT_ALL_CP_HEAL:
                     battleAction.cp = this.attacker.cp;
               }
               this.updateCP(this.attacker,0 - battleAction.cp);
               this.hitTarget();
               break;
            case "class_skill":
               switch(battleAction.effect.type)
               {
                  case BattleData.SKILL_2001:
                     effect = battleAction.effect;
                     this.attacker.clearAllDebuff();
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.SKILL_2003:
                     effect = battleAction.effect;
                     battleAction.attackerBuff.push(effect);
               }
               break;
            case "item":
               itemData = Central.main.ITEM_DATA.find(battleAction.item);
               Item_restore_HP = 0;
               Item_restore_CP = 0;
               Item_Restore_Pet_CP = 0;
               switch(itemData.effect)
               {
                  case BattleData.ITEM_RESTORE_HP:
                     Item_restore_HP = itemData.amount + 0;
                     break;
                  case BattleData.ITEM_RESTORE_CP:
                     Item_restore_CP = itemData.amount + 0;
                     break;
                  case BattleData.ITEM_SPECIAL_RUNE_SCROLL:
                     Item_restore_HP = 800;
                     Item_restore_CP = 800;
                     break;
                  case BattleData.ITEM_PERCENT_HP:
                     Item_restore_HP = Math.round(attacker.maxHP * ((itemData.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_PERCENT_CP:
                     Item_restore_CP = Math.round(attacker.maxCP * ((itemData.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_PERCENT_HPCP:
                     Item_restore_HP = Math.round(attacker.maxHP * ((itemData.amount + 0) / 100));
                     Item_restore_CP = Math.round(attacker.maxCP * ((itemData.amount + 0) / 100));
                     break;
                  case BattleData.EFFECT_DODGE_BONUS:
                     effect = {
                        "type":itemData.effect,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUS:
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     effect = {
                        "type":itemData.effect,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_REDUCTION:
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_CRITICAL_CHANCE:
                     effect = {
                        "type":BattleData.EFFECT_DODGE_BONUS,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_ADD_CRITICAL_CHANCE,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_PURIFY_CHANCE:
                     effect = {
                        "type":BattleData.EFFECT_DODGE_BONUS,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_ADD_PURIFY_CHANCE,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_CRITICAL_CHANCE_N_PURIFY_CHANCE:
                     effect = {
                        "type":BattleData.EFFECT_ADD_CRITICAL_CHANCE,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_ADD_PURIFY_CHANCE,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_ACCURATE:
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_ACCURATE,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                  case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                  case BattleData.EFFECT_ACCURATE:
                     effect = {
                        "type":itemData.effect,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     break;
                  case BattleData.ITEM_CLEARDEBUFF_RESIST:
                     effect = {
                        "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                        "duration":itemData.duration,
                        "amount":100
                     };
                     battleAction.attackerBuff.push(effect);
                     this.attacker.clearAllDebuff();
                     break;
                  case BattleData.ITEM_STRENGTHEN_N_BLEEDING:
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_BONUS,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_BLEEDING,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerDebuff.push(effect);
                     break;
                  case BattleData.ITEM_BOTH_DAMAGE_REDUCTION:
                     effect = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerBuff.push(effect);
                     effect = {
                        "type":BattleData.EFFECT_PET_WEAKEN,
                        "duration":itemData.duration,
                        "amount":itemData.amount
                     };
                     battleAction.attackerDebuff.push(effect);
                     break;
                  case BattleData.ITEM_RESTORE_PET_CP_PRESENT:
                     Item_Restore_Pet_CP = Math.round(1000 * ((itemData.amount + 0) / 100));
                     break;
                  case BattleData.ITEM_EFFECT_SEAL_GAN:
                     for(j = 0; j < Central.main.battleRuleArr.length; j++)
                     {
                        switch(Central.main.battleRuleArr[j].attribute)
                        {
                           case EnemyAttributeData.SEAL_GAN:
                              Central.battle.use_seal_enemy = true;
                              max = Math.ceil(this.defender.hp / this.defender.maxHP * 100);
                              min = Math.floor(this.defender.hp / this.defender.maxHP * 100);
                              Central.battle.seal_enemy = max >= Central.main.battleRuleArr[j].amount_over && min <= Central.main.battleRuleArr[j].amount_less?true:false;
                              Out.debug(this,"processbattleaction :: defender >> " + Central.battle.seal_enemy);
                              if(Central.battle.seal_enemy)
                              {
                                 battleAction.dmg = this.defender.maxHP;
                                 if(Central.main.battleModeSpecial && Central.main.battleModeSpecial == true)
                                 {
                                    Central.battle.specialHpData.finalHP = this.defender.hp;
                                 }
                              }
                        }
                     }
                     break;
                  case BattleData.ITEM_EFFECT_SPY_CP:
                     Item_restore_CP = Math.round(attacker.maxCP * ((itemData.amount + 0) / 100));
                     Central.battle.spy_enemy = true;
               }
               if(this.attackerBackItem)
               {
                  for each(tmpEffect in this.attackerBackItem.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                           if(Item_restore_HP > 0)
                           {
                              Item_restore_HP = Math.round(Item_restore_HP * (1 + tmpEffect.amount / 100));
                           }
                           continue;
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                           if(Item_restore_HP > 0)
                           {
                              Item_restore_HP = Item_restore_HP + tmpEffect.amount;
                           }
                           continue;
                        case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                           Item_restore_CP = Math.round(Item_restore_CP * (1 + tmpEffect.amount / 100));
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               if(this.attackerAccessory)
               {
                  for each(tmpEffect in this.attackerAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                           if(Item_restore_HP > 0)
                           {
                              Item_restore_HP = Math.round(Item_restore_HP * (1 + tmpEffect.amount / 100));
                           }
                           continue;
                        case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                           if(Item_restore_HP > 0)
                           {
                              Item_restore_HP = Item_restore_HP + tmpEffect.amount;
                           }
                           continue;
                        case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                           Item_restore_CP = Math.round(Item_restore_CP * (1 + tmpEffect.amount / 100));
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               if(this.attacker.getBloodlineEffect())
               {
                  for each(tmpEffect in this.attacker.getBloodlineEffect())
                  {
                     switch(tmpEffect.type)
                     {
                        case BloodlineData.EFFECT_BL_SKILL_ITEM_ADD_HP_PER:
                           if(Item_restore_HP > 0)
                           {
                              Item_restore_HP = Item_restore_HP + Math.round(Item_restore_HP * tmpEffect.amount * 0.01);
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
               if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  Item_restore_HP = 0;
               }
               if(Item_restore_HP > 0)
               {
                  battleAction.restoreHp = this.updateHP(this.attacker,Item_restore_HP);
               }
               if(Item_restore_CP > 0)
               {
                  battleAction.restoreCp = this.updateCP(this.attacker,Item_restore_CP);
               }
               if(attacker.pet && attacker.pet.petMaxEp > 0)
               {
                  if(Item_Restore_Pet_CP > 0)
                  {
                     attacker.pet.updatePetCP(Item_Restore_Pet_CP);
                     battleAction.restorePetCp = Item_Restore_Pet_CP;
                  }
               }
               break;
            case "special":
               this.hitTarget();
               break;
            case "bloodline":
               BloodLineAmt = battleAction.cp;
               if(attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
               {
                  BloodLineAmt = 0;
               }
               this.updateCP(this.attacker,0 - BloodLineAmt);
               this.hitTarget();
               break;
            case "senjutsu":
               SenjutsuAmt = battleAction.sp;
               attacker.updateSP(0 - SenjutsuAmt);
               this.hitTarget();
         }
         this.healTarget();
         this.damageTarget();
         if(battleAction.action != "dodge" && battleAction.action != "pass" && battleAction.action != "charge")
         {
            if(this.attacker.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
            {
               battleAction.attackerDamageHp = battleAction.attackerDamageHp + Math.round(this.attacker.maxHP * 0.03);
               battleAction.attackerDamageCp = battleAction.attackerDamageCp + Math.round(this.attacker.maxCP * 0.03);
            }
         }
         if(battleAction.action == "attack" || battleAction.action == "weapon_attack")
         {
            allowedNaturalRegeneration = [this.attacker.TYPE_CHARACTER,this.attacker.TYPE_AICHARACTER,this.attacker.TYPE_PVPCHARACTER];
            if(allowedNaturalRegeneration.indexOf(this.attacker.type) >= 0)
            {
               battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + Math.round(this.attacker.maxCP * BattleData.CHAKRA_NATURAL_REGENERATION);
            }
         }
         for(i = 0; i < battleAction.attackerBuff.length; i++)
         {
            effect = battleAction.attackerBuff[i];
            this.attacker.setBattleBuff(effect);
         }
         for(i = 0; i < battleAction.attackerDebuff.length; i++)
         {
            effect = battleAction.attackerDebuff[i];
            battleAction.attackerDebuff[i] = this.setDebuff(this.attacker,effect);
         }
         for(i = 0; i < battleAction.defenderBuff.length; i++)
         {
            effect = battleAction.defenderBuff[i];
            this.defender.setBattleBuff(effect);
         }
         for(i = 0; i < battleAction.defenderDebuff.length; i++)
         {
            effect = battleAction.defenderDebuff[i];
            battleAction.defenderDebuff[i] = this.setDebuff(this.defender,effect);
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"))
         {
            if(battleAction.defenderDamageCp > 0)
            {
               if(NumberUtil.getRandom() <= this.attacker.getBattleBuff()[BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"].chancetoeffect * 0.01)
               {
                  battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + this.attacker.getBattleBuff()[BloodlineData.EFFECT_ABSORB_CP_RESTORE_HP + ".skill1050"].amount;
               }
            }
         }
         if(this.attacker.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            if(battleAction.attackerDamageHp > 0)
            {
               if(NumberUtil.getRandom() <= this.attacker.getBattleBuff()[BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF].chancetoeffect * 0.01)
               {
                  battleAction.attackerDamageHp = 0;
               }
            }
         }
         if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_CPDMG_STUN + ".skill1004"))
         {
            if(battleAction.defenderDamageCp > 0 || battleAction.effect != null && battleAction.effect.damageCp > 0)
            {
               if(NumberUtil.getRandom() <= this.defender.getBattleBuff()[BloodlineData.EFFECT_CPDMG_STUN + ".skill1004"].chancetoeffect * 0.01)
               {
                  effect = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":2
                  };
                  this.attacker.setBattleDebuff(effect);
               }
            }
         }
         if(this.defender.isBattleBuffActive(BloodlineData.EFFECT_CPDMG + ".skill1004"))
         {
            if(battleAction.defenderDamageCp > 0 || battleAction.effect != null && battleAction.effect.damageCp > 0)
            {
               tmpDamageCP = 0;
               if(battleAction.effect != null && battleAction.effect.damageCp > 0)
               {
                  tmpDamageCP = battleAction.effect.damageCp;
               }
               battleAction.attackerDamageHp = battleAction.attackerDamageHp + (tmpDamageCP + battleAction.defenderDamageCp) * this.defender.getBattleBuff()[BloodlineData.EFFECT_CPDMG + ".skill1004"].amount * 0.01;
            }
         }
         if(battleAction.attackerRestoreHp > 0)
         {
            battleAction.attackerRestoreHp = this.updateHP(this.attacker,battleAction.attackerRestoreHp);
         }
         if(battleAction.attackerRestoreCp > 0)
         {
            battleAction.attackerRestoreCp = this.updateCP(this.attacker,battleAction.attackerRestoreCp);
         }
         if(battleAction.attackerDamageHp > 0)
         {
            battleAction.attackerDamageHp = this.updateHP(this.attacker,0 - battleAction.attackerDamageHp);
         }
         if(battleAction.attackerDamageCp > 0)
         {
            battleAction.attackerDamageCp = this.updateCP(this.attacker,0 - battleAction.attackerDamageCp);
         }
         if(battleAction.defenderRestoreHp > 0)
         {
            battleAction.defenderRestoreHp = this.updateHP(this.defender,battleAction.defenderRestoreHp);
         }
         if(battleAction.defenderRestoreCp > 0)
         {
            battleAction.defenderRestoreCp = this.updateCP(this.defender,battleAction.defenderRestoreCp);
         }
         if(battleAction.defenderDamageCp > 0)
         {
            battleAction.defenderDamageCp = this.updateCP(this.defender,0 - battleAction.defenderDamageCp);
         }
         if(battleAction.defenderDamageHp > 0)
         {
            battleAction.defenderDamageHp = this.updateHP(this.defender,0 - battleAction.defenderDamageHp);
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      private function hitTarget() : void
      {
         var battleAction:Object = null;
         var healTarget:* = undefined;
         var effect:Object = null;
         var key:* = null;
         var rNum:Number = NaN;
         var i:int = 0;
         var gearObj:Object = null;
         var setEffect:Object = null;
         var defenderGearset:Object = null;
         var attackerGearset:Object = null;
         var affectedEnemyArr:Array = null;
         var flameEaten:int = 0;
         var petDrainHP:int = 0;
         var petDrainCP:int = 0;
         var clearChance:int = 0;
         var absorbBuff:Array = null;
         var tmpArray:* = undefined;
         var targetIdStr:String = null;
         var j:int = 0;
         var battleEffect:Object = null;
         var effPicked:Object = null;
         var removeEffectObj:Object = null;
         var skillData:Object = null;
         var skillExtraEffect:Object = null;
         var tmpEffect:Object = null;
         var defenderBackItem:Object = null;
         var tmpEffectB:Object = null;
         var typeName:Array = null;
         var elementType:String = null;
         var defenderWeapon:Object = null;
         var absorbAmt:int = 0;
         var defenderAccessory:Object = null;
         battleAction = this.attacker.getBattleAction();
         if(!this.checkIsSelfBuff(battleAction))
         {
            this.checkClone(battleAction);
         }
         if(battleAction.action == "bloodline")
         {
            this.checkBloodlineEffect();
         }
         if(battleAction.action == "senjutsu")
         {
            this.checkSenjutsuEffect();
         }
         if(battleAction.clones != null)
         {
            if(battleAction.clones[this.defender.getCharacterId()])
            {
               this.attacker.setBattleAction(battleAction);
               return;
            }
         }
         if(battleAction.effect && battleAction.effect.type == BattleData.EFFECT_DMG_BONUS_N_BLEEDING)
         {
            effect = {
               "type":BattleData.EFFECT_DAMAGE_BONUS,
               "duration":battleAction.effect.duration,
               "amount":battleAction.effect.amount
            };
            battleAction.attackerBuff.push(effect);
         }
         if(battleAction.dodge == true)
         {
            return;
         }
         if(battleAction.effect)
         {
            switch(battleAction.effect.type)
            {
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                  effect = {
                     "type":BattleData.EFFECT_BLOOD_DRINKER,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.defenderDebuff.push(effect);
                  break;
               case BattleData.EFFECT_SLEEP:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
               case BattleData.EFFECT_ECSTATIC_SOUND:
               case BattleData.EFFECT_DISMANTLE:
               case BattleData.SKILL_341:
               case BattleData.EFFECT_RESTRICT_CHARGE:
               case BattleData.EFFECT_CHAOS:
               case BattleData.EFFECT_LIGHTING_BUNDLE:
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
               case BattleData.EFFECT_DARK_CURSE:
               case BattleData.EFFECT_BLOOD_DRINKER:
               case BattleData.EFFECT_THEFT_HP:
               case BattleData.EFFECT_BUFF_NEGATE:
               case BattleData.EFFECT_PETRIFICATION:
               case BattleData.EFFECT_DARKNESS:
               case BattleData.SKILL_311:
               case BattleData.SKILL_312:
               case BattleData.EFFECT_PET_DISORIENTED:
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
               case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
               case BattleData.EFFECT_LIGHT_IMPLUSE:
               case BattleData.SKILL_377:
               case BattleData.EFFECT_DOT_HP:
               case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                  battleAction.defenderDebuff.push(battleAction.effect);
                  break;
               case BattleData.EFFECT_EXTRA_CP_RECOVER:
               case BattleData.EFFECT_PET_DODGE_BONUS:
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               case BattleData.EFFECT_GUARD:
               case BattleData.EFFECT_PET_ATTENTION:
               case BattleData.EFFECT_PET_DAMAGE_BONUS:
               case BattleData.EFFECT_COMPLETE_GUARD:
               case BattleData.EFFECT_CATALYTIC_MATTER:
               case BattleData.EFFECT_PET_DEBUFF_RESIST:
               case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
               case BattleData.EFFECT_PET_HEAL:
               case BattleData.EFFECT_PET_DAMAGE_TO_CP:
               case BattleData.EFFECT_PET_SAVE_CP:
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
               case BattleData.EFFECT_PET_LIGHTNING:
               case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
               case BattleData.EFFECT_ATTACK_MODE:
               case BattleData.EFFECT_DEFENCE_MODE:
               case BattleData.EFFECT_PET_ENERGIZE:
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
               case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                  battleAction.defenderBuff.push(battleAction.effect);
                  break;
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
               case BattleData.EFFECT_AMONG_ROCKS:
               case BattleData.EFFECT_ALL_CP_DRAIN_HP:
               case BattleData.EFFECT_AGILITY_BONUS:
               case BattleData.EFFECT_DODGE_BONUS:
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
               case BattleData.EFFECT_REGENERATE_CHAKRA:
               case BattleData.EFFECT_REGENERATE_HP:
               case BattleData.EFFECT_MANA_SHIELD:
               case BattleData.EFFECT_THUNDERSTORM_MODE:
               case BattleData.EFFECT_REACTIVE_DEBUFF:
               case BattleData.EFFECT_BLOOD_FEED:
               case BattleData.SKILL_310:
               case BattleData.EFFECT_ACCURATE:
               case BattleData.SKILL_335:
               case BattleData.EFFECT_GATE_OPENING:
               case BattleData.EFFECT_REACTIVE_FORCE:
               case BattleData.EFFECT_FRENZY:
               case BattleData.EFFECT_BUNNY_FRENZY:
               case BattleData.SKILL_369:
               case BattleData.SKILL_501:
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
               case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
               case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
                  battleAction.attackerBuff.push(battleAction.effect);
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
               case BattleData.EFFECT_CALM_TARGET:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
               case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  this.defender.clearBuff();
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= battleAction.effect.amount / 100)
                  {
                     battleAction.effect.activated = true;
                     battleAction.defenderDebuff.push(battleAction.effect);
                  }
                  else
                  {
                     battleAction.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_BURN_HP:
                  battleAction.defenderDamageHp = battleAction.defenderDamageHp + Math.round(this.defender.maxHP * int(battleAction.effect.amount) * 0.01);
                  break;
               case BattleData.EFFECT_PET_BLEEDING:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(battleAction.effect.chance) / 100)
                  {
                     battleAction.effect.activated = true;
                     battleAction.effect = this.setDebuff(this.defender,battleAction.effect);
                  }
                  else
                  {
                     battleAction.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_STUN_RANDOM:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(battleAction.effect.amount) / 100 && battleAction.stun == true)
                  {
                     effect = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":battleAction.effect.duration,
                        "amount":0
                     };
                     battleAction.defenderDebuff.push(effect);
                  }
                  break;
               case BattleData.EFFECT_FLAME_EATER:
                  flameEaten = 0;
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BURN))
                  {
                     flameEaten = flameEaten + Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_BURN);
                  }
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_PET_BURN))
                  {
                     flameEaten = flameEaten + Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_PET_BURN);
                  }
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_BURNING))
                  {
                     flameEaten = flameEaten + Math.round(this.defender.maxHP * 0.05);
                     this.defender.removeDebuff(BattleData.EFFECT_BURNING);
                  }
                  if(flameEaten == 0)
                  {
                     flameEaten = int(this.defender.maxHP * 0.01);
                  }
                  flameEaten = this.updateHP(this.defender,0 - flameEaten);
                  battleAction.effect.flameEaten = flameEaten;
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_RANDOM:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(battleAction.effect.amount) / 100)
                  {
                     effect = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":battleAction.effect.duration,
                        "amount":battleAction.effect.amount
                     };
                     battleAction.defenderDebuff.push(effect);
                  }
                  break;
               case BattleData.EFFECT_CLEAR_BUFF:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(battleAction.effect.amount) / 100)
                  {
                     battleAction.effect.activated = true;
                     this.defender.clearBuff();
                  }
                  else
                  {
                     battleAction.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP:
                  petDrainHP = Math.round(this.defender.maxHP * int(battleAction.effect.amount) / 100);
                  petDrainHP = Math.abs(this.updateHP(this.defender,0 - petDrainHP));
                  healTarget = this.getPetMasterById(this.attacker.getCharacterId());
                  if(healTarget)
                  {
                     this.updateHP(healTarget,petDrainHP);
                     battleAction.effect.damageHp = petDrainHP;
                  }
                  break;
               case BattleData.EFFECT_PET_DRAIN_CP:
                  petDrainCP = Math.round(this.defender.maxCP * int(battleAction.effect.amount) / 100);
                  if(petDrainCP > this.defender.cp)
                  {
                     petDrainCP = this.defender.cp;
                  }
                  battleAction.effect.damageCp = Math.abs(this.updateCP(this.defender,0 - petDrainCP));
                  healTarget = this.getPetMasterById(this.attacker.getCharacterId());
                  if(healTarget)
                  {
                     this.updateCP(healTarget,battleAction.effect.damageCp);
                  }
                  break;
               case BattleData.MONSTER_HP1:
                  battleAction.attakcerDamageHp = battleAction.attakcerDamageHp + (this.attacker.hp - 1);
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  if(this.defender.hp / this.defender.maxHP >= 0.5)
                  {
                     battleAction.effect.amount = 1;
                  }
                  else
                  {
                     battleAction.effect.amount = 2;
                  }
                  battleAction.defenderDebuff.push(battleAction.effect);
                  break;
               case BattleData.EFFECT_BURN_CP_FIX_NUM:
                  battleAction.defenderDamageCp = int(battleAction.effect.amount);
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  battleAction.attackerBuff.push(battleAction.effect);
                  battleAction.attackerDebuff.push(battleAction.effect);
                  break;
               case BattleData.EFFECT_WIND_PEACE:
               case BattleData.EFFECT_WIND_PEACE_2:
               case BattleData.EFFECT_WIND_PEACE_3:
               case BattleData.EFFECT_WIND_PEACE_4:
                  battleAction.attackerBuff.push(battleAction.effect);
                  for(i = 0; i < this.characterArr.length; i++)
                  {
                     if(this.characterArr[i].isDead == false && this.characterArr[i].side == this.attacker.side)
                     {
                        this.setBuff(this.characterArr[i],battleAction.effect);
                     }
                  }
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                  effect = {
                     "type":BattleData.EFFECT_EXCITATION_CP,
                     "duration":battleAction.effect.amount
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_EXCITATION_CHARGE,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  battleAction.defenderDebuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.defenderDebuff.push(effect);
                  break;
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  battleAction.defenderDamageCp = battleAction.defenderDamageCp + Math.round(this.defender.maxCP * int(battleAction.effect.amount) * 0.01);
                  this.defender.addAllSkillCooldown(battleAction.effect.duration);
                  break;
               case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                  this.defender.addAllSkillCooldown(battleAction.effect.amount);
                  break;
               case BattleData.SKILL_285:
               case BattleData.SKILL_302:
               case BattleData.SKILL_251:
               case BattleData.SKILL_268:
               case BattleData.SKILL_268_2:
                  battleAction.attackerBuff.push(battleAction.effect);
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.SKILL_253:
                  battleAction.defenderDebuff.push(battleAction.effect);
                  this.defender.addSkillCooldown(battleAction.effect.duration - 1,SkillData.TYPE_WATER);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_251))
                  {
                     effect = {
                        "type":BattleData.EFFECT_INTERNAL_INJURY,
                        "duration":battleAction.effect.duration
                     };
                     battleAction.defenderDebuff.push(effect);
                  }
                  break;
               case BattleData.EFFECT_PURIFY:
                  clearChance = 1;
                  rNum = NumberUtil.getRandom();
                  if(this.defender.isBattleDebuffActive(BattleData.SKILL_253))
                  {
                     clearChance = 0;
                  }
                  if(rNum <= clearChance)
                  {
                     this.defender.clearAllDebuff();
                     battleAction.effect.activated = true;
                  }
                  else
                  {
                     battleAction.effect.activated = false;
                  }
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + int(battleAction.effect.amount);
                  break;
               case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  battleAction.defenderBuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":battleAction.effect.duration,
                     "amount":100
                  };
                  battleAction.defenderBuff.push(effect);
                  break;
               case BattleData.EFFECT_BLOODLUST_DEDICATION:
                  defender.clearAllDebuff();
                  battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + Math.round(this.defender.maxHP * int(battleAction.effect.amount) / 100);
                  break;
               case BattleData.EFFECT_WAKE_UP:
                  if(this.defender.isBattleDebuffActive(BattleData.EFFECT_SLEEP))
                  {
                     this.defender.getBattleDebuff()[BattleData.EFFECT_SLEEP] = null;
                  }
                  break;
               case BattleData.EFFECT_RANDOM_SLEEP:
                  rNum = NumberUtil.getRandom();
                  if(rNum <= int(battleAction.effect.amount) / 100)
                  {
                     effect = {
                        "type":BattleData.EFFECT_SLEEP,
                        "duration":battleAction.effect.duration
                     };
                     battleAction.defenderDebuff.push(effect);
                  }
                  break;
               case BattleData.EFFECT_ADD_COOLDOWN:
                  this.defender.addRandomSkillCooldown(battleAction.effect.amount);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  battleAction.defenderDebuff.push(battleAction.effect);
                  this.defender.clearBuff();
                  break;
               case BattleData.INSTANT_KILL:
                  battleAction.dmg = this.defender.maxHP;
                  break;
               case BattleData.INSTANT_CUT_HALF_HP:
                  battleAction.dmg = defender.maxHP / 2;
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  if(Central.battle.type == Central.battle.TYPE_LOCAL)
                  {
                     targetIdStr = defender.getData(DBCharacterData.ID);
                     for(j = 0; j < 2; j++)
                     {
                        battleEffect = j == 0?defender.getBattleBuff():defender.getBattleDebuff();
                        if(battleEffect)
                        {
                           effPicked = this.getOneRandomNonPassiveEffectFromLists(new Array(battleEffect));
                           if(effPicked)
                           {
                              if(!battleAction.removedEffectList)
                              {
                                 battleAction.removedEffectList = [];
                              }
                              removeEffectObj = {
                                 "targetId":targetIdStr,
                                 "type":effPicked.type
                              };
                              battleAction.removedEffectList.push(removeEffectObj);
                           }
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_REDUCE_CP_MAX_BLEEDING:
                  effect = {
                     "type":BattleData.EFFECT_REDUCE_CP_MAX,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.defenderDebuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_BLEEDING,
                     "duration":battleAction.effect.duration,
                     "amount":int(battleAction.effect.amount) + 20
                  };
                  battleAction.defenderDebuff.push(effect);
                  break;
               case BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST:
                  switch(battleAction.target)
                  {
                     case "friendly":
                        for(i = 0; i < characterArr.length; i++)
                        {
                           if(characterArr[i].isDead == false && characterArr[i].side == attacker.side)
                           {
                              tmpEffect = {
                                 "type":BattleData.EFFECT_CP_LOCK,
                                 "duration":battleAction.effect.duration
                              };
                              this.setBuff(characterArr[i],tmpEffect);
                              tmpEffect = {
                                 "type":BattleData.EFFECT_RESTRICT_CHARGE,
                                 "duration":battleAction.effect.amount
                              };
                              this.setDebuff(characterArr[i],tmpEffect);
                              tmpEffect = {
                                 "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                                 "duration":battleAction.effect.duration,
                                 "amount":100
                              };
                              this.setBuff(characterArr[i],tmpEffect);
                           }
                        }
                        break;
                     default:
                        tmpEffect = {
                           "type":BattleData.EFFECT_CP_LOCK,
                           "duration":battleAction.effect.duration
                        };
                        attacker.setBattleBuff(tmpEffect);
                        tmpEffect = {
                           "type":BattleData.EFFECT_RESTRICT_CHARGE,
                           "duration":battleAction.effect.amount
                        };
                        attacker.setBattleDebuff(tmpEffect);
                        tmpEffect = {
                           "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                           "duration":battleAction.effect.duration,
                           "amount":100
                        };
                        attacker.setBattleBuff(tmpEffect);
                  }
                  break;
               case BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST:
                  tmpEffect = {
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":battleAction.effect.duration,
                     "amount":100
                  };
                  attacker.setBattleBuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_THUNDERSTORM_MODE,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  attacker.setBattleBuff(tmpEffect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_RECEIVED_BURNING:
                  battleAction.attackerBuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_DEFENDER_BURNING,
                     "amount":5,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_CRITICAL_BUFF_N_RECEIVED_STUN:
                  battleAction.attackerBuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_CRITICAL_DMG_BONUS,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_RECEIVED_DMG_STUN,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_MANA_SHILED_N_PURIFY_BELOW_CP:
                  battleAction.attackerBuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_MANA_SHIELD,
                     "amount":2,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_PURIFY_BELOW_CP,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_REDUCE_DMG_N_AGI:
                  battleAction.attackerBuff.push(battleAction.effect);
                  effect = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_RECEIVED_DMG_REDUCE_AGI,
                     "amount":50,
                     "duration":2
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_RESTORE_CP_DMG_SHIELD:
                  battleAction.attackerRestoreCp = this.attacker.maxCP;
                  effect = {
                     "type":BattleData.EFFECT_MANA_SHIELD,
                     "amount":2,
                     "duration":battleAction.effect.duration
                  };
                  battleAction.attackerBuff.push(effect);
                  effect = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.attackerBuff.push(effect);
                  break;
               case BattleData.EFFECT_PET_BURN_FREEZE:
                  effect = {
                     "type":BattleData.EFFECT_PET_FREEZE,
                     "duration":battleAction.effect.duration
                  };
                  this.defender.setBattleDebuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.defender.setBattleDebuff(effect);
                  break;
               case BattleData.EFFECT_BUNDLE_DARKNESS:
                  effect = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.defender.setBattleDebuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_BUNDLE,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.defender.setBattleDebuff(effect);
                  break;
               case BattleData.EFFECT_SAND_GUARD:
                  this.attacker.setBattleBuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                  this.attacker.setBattleBuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                  this.attacker.setBattleBuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_DEBUFF_RESIST_EX:
                  this.attacker.setBattleBuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_ALL_BUFF:
                  effect = {
                     "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.attacker.setBattleBuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.attacker.setBattleBuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_DODGE_BONUS,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.attacker.setBattleBuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_ACCURATE,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.attacker.setBattleBuff(effect);
                  break;
               case BattleData.EFFECT_MDF_CD_N_ADD_ATTENTION:
                  effect = {
                     "type":BattleData.EFFECT_PET_ATTENTION,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  this.attacker.setBattleBuff(effect);
                  break;
               case BattleData.EFFECT_CLEAR_DEBUFF_RST_DMG_HP:
                  battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + battleAction.effect.duration;
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.EFFECT_PROTECT_BY_DUMMY:
               case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
               case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                  battleAction.effect.chance = battleAction.effect.amount;
                  battleAction.effect.remainClones = battleAction.effect.duration - 2;
                  battleAction.attackerBuff.push(battleAction.effect);
                  trace("battleAction.effect.remainClones  = " + battleAction.effect.remainClones);
                  break;
               case BattleData.EFFECT_ABSORB_BUFF:
                  absorbBuff = this.getAvailableBuff(this.defender,battleAction.effect.amount);
                  tmpArray = this.getOneRandomNonPassiveEffectCanAbsorb(absorbBuff);
                  for(i = 0; i < tmpArray.length; i++)
                  {
                     if(tmpArray[i] == 2)
                     {
                        battleAction.attackerBuff.push(absorbBuff[i]);
                        this.defender.removeBuff(absorbBuff[i].type);
                     }
                     else if(tmpArray[i] == 1)
                     {
                        this.defender.removeBuff(absorbBuff[i].type);
                     }
                     else if(tmpArray[i] == 0)
                     {
                     }
                  }
            }
         }
         if(battleAction.skillId)
         {
            skillData = Central.main.SKILL_DATA[battleAction.skillId];
            if(skillData)
            {
               if(skillData.extra_effect && skillData.extra_effect != null)
               {
                  skillExtraEffect = skillData.extra_effect;
                  affectedEnemyArr = [];
                  for(i = 0; i < skillExtraEffect.enemy.length; i++)
                  {
                     affectedEnemyArr.push(Central.main.ENEMY_DATA.find(skillExtraEffect.enemy[i]).name);
                  }
                  if(defender.type == 4 && affectedEnemyArr.indexOf(this.defender.getCharacterName()) >= 0)
                  {
                     switch(skillExtraEffect.type)
                     {
                        case BattleData.EFFECT_CLEAR_BLESS_N_REDUCE_HP:
                           if(this.defender.isBattleBuffActive(BattleData.EFFECT_DEBUFF_RESIST_EX))
                           {
                              delete this.defender.getBattleBuff()[BattleData.EFFECT_DEBUFF_RESIST_EX];
                           }
                           battleAction.defenderDamageHp = battleAction.defenderDamageHp + Math.round(this.defender.hp * skillExtraEffect.amount * 0.01);
                     }
                  }
               }
            }
         }
         if(battleAction.action == "weapon_attack")
         {
            if(this.attackerWeapon)
            {
               for each(tmpEffect in this.attackerWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_WEAPON_CHAOS_PERCENT:
                        if(NumberUtil.getRandom() <= int(tmpEffect.chance) / 100)
                        {
                           effect = {
                              "type":BattleData.EFFECT_CHAOS,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           };
                           battleAction.defenderDebuff.push(effect);
                        }
                        continue;
                     case BattleData.EFFECT_TRANSFORM:
                        if(NumberUtil.getRandom() <= int(tmpEffect.chance) / 100)
                        {
                           battleAction.defenderDebuff.push(tmpEffect);
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
            if(this.attackerWeapon)
            {
               for each(tmpEffect in this.attackerWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_BURN:
                     case BattleData.EFFECT_BURNING:
                     case BattleData.EFFECT_PET_BURN:
                     case BattleData.EFFECT_BURN_FIX_NUM:
                     case BattleData.EFFECT_DEFENDER_BURNING:
                        if(this.defender.getBackItem())
                        {
                           defenderBackItem = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
                           if(defenderBackItem)
                           {
                              for each(tmpEffectB in defenderBackItem.effect)
                              {
                                 switch(tmpEffectB.type)
                                 {
                                    case BattleData.EFFECT_BURN_PROTECTION:
                                       if(NumberUtil.getRandom() <= tmpEffectB.chance / 100)
                                       {
                                          tmpEffect.type = null;
                                       }
                                       continue;
                                    default:
                                       continue;
                                 }
                              }
                           }
                        }
                  }
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_ATTACKER_RESTORE_HP:
                        battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_ATTACKER_RESTORE_CP:
                        battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_DEFENDER_DAMAGE_CP:
                        battleAction.defenderDamageCp = battleAction.defenderDamageCp + tmpEffect.amount;
                        continue;
                     case BattleData.EFFECT_DEFENDER_BURNING:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           effect = {
                              "type":BattleData.EFFECT_BURNING,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           };
                           battleAction.defenderDebuff.push(effect);
                           battleAction.weapon_activated = true;
                        }
                        continue;
                     case BattleData.EFFECT_DEFENDER_BUNDLE:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           effect = {
                              "type":BattleData.EFFECT_BUNDLE,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           };
                           battleAction.defenderDebuff.push(effect);
                        }
                        continue;
                     case BattleData.EFFECT_DEFENDER_POISON:
                        effect = {
                           "type":BattleData.EFFECT_POISON,
                           "duration":tmpEffect.duration,
                           "amount":tmpEffect.amount
                        };
                        battleAction.defenderDebuff.push(effect);
                        continue;
                     case BattleData.EFFECT_ATTACKER_DAMAGE_REDUCTION:
                        effect = {
                           "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                           "duration":tmpEffect.duration,
                           "amount":tmpEffect.amount
                        };
                        battleAction.attackerBuff.push(effect);
                        continue;
                     case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                        effect = {
                           "type":BattleData.EFFECT_DAMAGE_BONUS,
                           "duration":tmpEffect.duration,
                           "amount":tmpEffect.amount
                        };
                        battleAction.attackerBuff.push(effect);
                        continue;
                     case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           this.defender.clearBuff();
                           battleAction.weapon_activated = true;
                        }
                        continue;
                     case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                        this.attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_GENJUTSU);
                        continue;
                     case BattleData.EFFECT_DEFENDER_FREEZE:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           effect = {
                              "type":BattleData.EFFECT_PET_FREEZE,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           };
                           battleAction.defenderDebuff.push(effect);
                           battleAction.weapon_activated = true;
                        }
                        continue;
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_BLEEDING:
                        battleAction.defenderDebuff.push(tmpEffect);
                        continue;
                     case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                        battleAction.attackerBuff.push(tmpEffect);
                        continue;
                     case BattleData.EFFECT_BURN_FIX_NUM:
                     case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                        battleAction.defenderDebuff.push(tmpEffect);
                        continue;
                     case BattleData.EFFECT_PET_WEAKEN:
                     case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                        battleAction.defenderDebuff.push(tmpEffect);
                        continue;
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        battleAction.defenderDebuff.push(tmpEffect);
                        continue;
                     case BattleData.EFFECT_REDUCE_SELF_CP_CONSUME:
                        effect = {
                           "type":BattleData.EFFECT_PET_SAVE_CP,
                           "duration":tmpEffect.duration,
                           "amount":tmpEffect.amount
                        };
                        battleAction.attackerBuff.push(effect);
                        continue;
                     default:
                        if(tmpEffect.type != null)
                        {
                           typeName = tmpEffect.type.split(".");
                           if(typeName != null && typeName.length > 0 && typeName[0] == BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN)
                           {
                              switch(typeName[1])
                              {
                                 case "0":
                                    this.attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_ALL);
                                    break;
                                 case "1":
                                    if(typeName[2] == null)
                                    {
                                       Out.debug(this,"Skill element undefined.");
                                       break;
                                    }
                                    elementType = "";
                                    switch(typeName[2])
                                    {
                                       case "0":
                                          elementType = SkillData.TYPE_FIRE;
                                          break;
                                       case "1":
                                          elementType = SkillData.TYPE_WIND;
                                          break;
                                       case "2":
                                          elementType = SkillData.TYPE_LIGHTNING;
                                          break;
                                       case "3":
                                          elementType = SkillData.TYPE_WATER;
                                          break;
                                       case "4":
                                          elementType = SkillData.TYPE_EARTH;
                                          break;
                                       case "5":
                                          elementType = SkillData.TYPE_TAIJUTSU;
                                          break;
                                       case "6":
                                          elementType = SkillData.TYPE_GENJUTSU;
                                    }
                                    this.attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_SKILL,elementType);
                                    break;
                                 case "2":
                                    this.attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_TALENT);
                              }
                              this.attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                           }
                        }
                        continue;
                  }
               }
            }
         }
         if(this.attackerBackItem)
         {
            for each(tmpEffect in this.attackerBackItem.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ATTACKER_RESTORE_CP_PRESENT:
                     battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + Math.round(attacker.maxCP * tmpEffect.amount / 100);
                     continue;
                  case BattleData.EFFECT_REDUCE_TARGET_CP:
                     if(battleAction.action == "weapon_attack")
                     {
                        battleAction.defenderDamageCp = battleAction.defenderDamageCp + Math.round(this.defender.maxCP * tmpEffect.amount * 0.01);
                     }
                     continue;
                  case BattleData.EFFECT_DEFENDER_STUN:
                     if(NumberUtil.getRandom() <= tmpEffect.chance / 100 && battleAction.action == "weapon_attack")
                     {
                        effect = {
                           "type":BattleData.EFFECT_STUN,
                           "duration":tmpEffect.duration,
                           "amount":0
                        };
                        battleAction.defenderDebuff.push(effect);
                        battleAction.backitem_activated = true;
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attacker.side != this.defender.side)
         {
            if(this.defender.getWeapon())
            {
               defenderWeapon = Central.main.WEAPON_DATA.find(this.defender.getWeapon());
               if(defenderWeapon)
               {
                  for each(tmpEffect in defenderWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_DEFENDER_CRITICAL_CHANCE:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              battleAction.defenderBuff.push({
                                 "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON,
                                 "duration":tmpEffect.duration,
                                 "amount":tmpEffect.amount
                              });
                           }
                           continue;
                        case BattleData.EFFECT_DEFENDER_RESTORE_HP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + Math.round(this.defender.maxHP * (tmpEffect.amount / 100));
                           }
                           continue;
                        case BattleData.EFFECT_ATTACKER_BLEEDING:
                           battleAction.attackerDebuff.push({
                              "type":BattleData.EFFECT_BLEEDING,
                              "duration":tmpEffect.duration,
                              "amount":tmpEffect.amount
                           });
                           continue;
                        case BattleData.EFFECT_RECEIVED_DAMAGE_BURN_TARGET:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_BURNING,
                                 "duration":tmpEffect.duration,
                                 "amount":tmpEffect.amount
                              };
                              battleAction.attackerDebuff.push(effect);
                           }
                           continue;
                        case BattleData.EFFECT_RECEIVED_DMG_PARRY:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_COMPLETE_GUARD,
                                 "duration":tmpEffect.duration
                              };
                              battleAction.defenderBuff.push(effect);
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.attacker.getAccessory())
            {
               attackerAccessory = Central.main.ACCESSORY_DATA.find(this.attacker.getAccessory());
               if(attackerAccessory)
               {
                  for each(tmpEffect in attackerAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_BLIND:
                           if(battleAction.action == "weapon_attack")
                           {
                              battleAction.defenderDebuff.push(tmpEffect);
                           }
                           continue;
                        case BattleData.EFFECT_PET_WEAKEN:
                           if(battleAction.action == "weapon_attack")
                           {
                              battleAction.defenderDebuff.push(tmpEffect);
                           }
                           continue;
                        case BattleData.EFFECT_DEFENDER_BURNING:
                           tmpEffect = {
                              "type":BattleData.EFFECT_BURNING,
                              "amount":tmpEffect.amount,
                              "duration":2
                           };
                           battleAction.defenderDebuff.push(tmpEffect);
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.attacker.getGearset())
            {
               gearObj = this.attacker.getGearset();
               for(key in gearObj)
               {
                  attackerGearset = Central.main.GEAR_SET_DATA.find(key);
                  for(i = 0; i < gearObj[key] - 1; i++)
                  {
                     setEffect = attackerGearset.effect[i];
                     switch(setEffect.type)
                     {
                        case BattleData.EFFECT_DEFENDER_POISON:
                           if(battleAction.action == "weapon_attack")
                           {
                              effect = {
                                 "type":BattleData.EFFECT_POISON,
                                 "duration":setEffect.duration,
                                 "amount":setEffect.amount
                              };
                              battleAction.defenderDebuff.push(effect);
                           }
                           break;
                        case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                           if(battleAction.action == "weapon_attack")
                           {
                              effect = {
                                 "type":BattleData.EFFECT_DAMAGE_BONUS,
                                 "duration":2,
                                 "amount":setEffect.amount
                              };
                              battleAction.attackerBuff.push(effect);
                           }
                     }
                  }
               }
            }
            if(this.defender.getBackItem())
            {
               defenderBackItem = Central.main.BACK_ITEM_DATA.find(this.defender.getBackItem());
               if(defenderBackItem)
               {
                  for each(tmpEffect in defenderBackItem.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ATTACKER_FREEZE:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_PET_FREEZE,
                                 "duration":tmpEffect.duration,
                                 "amount":tmpEffect.amount
                              };
                              battleAction.attackerDebuff.push(effect);
                              battleAction.backitem_activated = true;
                           }
                           continue;
                        case BattleData.EFFECT_ATTACKER_STUN:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_STUN,
                                 "duration":tmpEffect.duration,
                                 "amount":0
                              };
                              battleAction.attackerDebuff.push(effect);
                              battleAction.backitem_activated = true;
                           }
                           continue;
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              absorbAmt = Math.round(this.attacker.maxHP * (tmpEffect.amount / 100));
                              battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + absorbAmt;
                              battleAction.attackerDamageHp = battleAction.attackerDamageHp + absorbAmt;
                           }
                           continue;
                        case BattleData.EFFECT_ATTACK_BUNDLE:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_BUNDLE,
                                 "duration":tmpEffect.duration
                              };
                              battleAction.attackerDebuff.push(effect);
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.defender.getAccessory())
            {
               defenderAccessory = Central.main.ACCESSORY_DATA.find(this.defender.getAccessory());
               if(defenderAccessory)
               {
                  for each(tmpEffect in defenderAccessory.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ATTACKER_FREEZE:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_PET_FREEZE,
                                 "duration":tmpEffect.duration,
                                 "amount":tmpEffect.amount
                              };
                              battleAction.attackerDebuff.push(effect);
                           }
                           continue;
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              absorbAmt = Math.round(this.attacker.maxHP * (tmpEffect.amount / 100));
                              battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + absorbAmt;
                              battleAction.attackerDamageHp = battleAction.attackerDamageHp + absorbAmt;
                           }
                           continue;
                        case BattleData.EFFECT_ATTACK_BUNDLE:
                           if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                           {
                              effect = {
                                 "type":BattleData.EFFECT_BUNDLE,
                                 "duration":tmpEffect.duration
                              };
                              battleAction.attackerDebuff.push(effect);
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
            if(this.defender.getGearset())
            {
               gearObj = this.defender.getGearset();
               for(key in gearObj)
               {
                  defenderGearset = Central.main.GEAR_SET_DATA.find(key);
                  for(i = 0; i < gearObj[key] - 1; i++)
                  {
                     setEffect = defenderGearset.effect[i];
                     switch(setEffect.type)
                     {
                        case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                           if(NumberUtil.getRandom() <= setEffect.chance * 0.01)
                           {
                              absorbAmt = Math.round(this.attacker.maxHP * (setEffect.amount * 0.01));
                              battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + absorbAmt;
                              battleAction.attackerDamageHp = battleAction.attackerDamageHp + absorbAmt;
                           }
                           break;
                        case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                           battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + Math.round(Math.abs(battleAction.dmg) * (setEffect.amount / 100));
                     }
                  }
               }
            }
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function getBloodlineEffectArr(battleAction_effect:Object) : Array
      {
         var bl_effect_1:Object = {};
         var bl_effect_2:Object = {};
         var bl_effect_3:Object = {};
         var battleAction_effect_Arr:Array = [];
         if(battleAction_effect == null)
         {
            return battleAction_effect_Arr;
         }
         if(battleAction_effect.effect_type_1 && battleAction_effect.effect_type_1 != "")
         {
            bl_effect_1.type = battleAction_effect.effect_type_1;
            bl_effect_1.duration = battleAction_effect.duration_1;
            bl_effect_1.target = battleAction_effect.effect_target_1;
            bl_effect_1.chancetohit = battleAction_effect.effect_chancetohit_1;
            bl_effect_1.chancetoeffect = battleAction_effect.effect_chancetoeffect_1;
            bl_effect_1.requirement = battleAction_effect.effect_requirement_1;
            bl_effect_1.amount = battleAction_effect.effect_amount_1;
            bl_effect_1.hit = false;
            bl_effect_1.resisted = battleAction_effect.effect_resisted_1;
            battleAction_effect_Arr.push(bl_effect_1);
         }
         if(battleAction_effect.effect_type_2 && battleAction_effect.effect_type_2 != "")
         {
            bl_effect_2.type = battleAction_effect.effect_type_2;
            bl_effect_2.duration = battleAction_effect.duration_2;
            bl_effect_2.target = battleAction_effect.effect_target_2;
            bl_effect_2.chancetohit = battleAction_effect.effect_chancetohit_2;
            bl_effect_2.chancetoeffect = battleAction_effect.effect_chancetoeffect_2;
            bl_effect_2.requirement = battleAction_effect.effect_requirement_2;
            bl_effect_2.amount = battleAction_effect.effect_amount_2;
            bl_effect_2.hit = false;
            bl_effect_2.resisted = battleAction_effect.effect_resisted_2;
            battleAction_effect_Arr.push(bl_effect_2);
         }
         if(battleAction_effect.effect_type_3 && battleAction_effect.effect_type_3 != "")
         {
            bl_effect_3.type = battleAction_effect.effect_type_3;
            bl_effect_3.duration = battleAction_effect.duration_3;
            bl_effect_3.target = battleAction_effect.effect_target_3;
            bl_effect_3.chancetohit = battleAction_effect.effect_chancetohit_3;
            bl_effect_3.chancetoeffect = battleAction_effect.effect_chancetoeffect_3;
            bl_effect_3.requirement = battleAction_effect.effect_requirement_3;
            bl_effect_3.amount = battleAction_effect.effect_amount_3;
            bl_effect_3.hit = false;
            bl_effect_3.resisted = battleAction_effect.effect_resisted_3;
            battleAction_effect_Arr.push(bl_effect_3);
         }
         return battleAction_effect_Arr;
      }
      
      public function checkBloodlineEffect() : *
      {
         var healTarget:* = undefined;
         var effect:Object = null;
         var key:String = null;
         var rNum:Number = NaN;
         var i:int = 0;
         var battleAction:Object = this.attacker.getBattleAction();
         var battleAction_effect:Object = battleAction.effect;
         var battleAction_skillId:String = "";
         if(battleAction.BLSKILLID)
         {
            battleAction_skillId = battleAction.BLSKILLID;
         }
         var battleAction_effect_Arr:Array = getBloodlineEffectArr(battleAction_effect);
         rNum = NumberUtil.getRandom();
         var isSelfBuff:Boolean = true;
         for(i = 0; i < battleAction_effect_Arr.length; i++)
         {
            if(battleAction_effect_Arr[i].target != 0 && battleAction_effect_Arr[i].target != 3 && battleAction_effect_Arr[i].target != 4 && battleAction_effect_Arr[i].target != 6)
            {
               isSelfBuff = false;
            }
         }
         if(isSelfBuff)
         {
            battleAction.dodge = false;
         }
         else
         {
            this.checkClone(battleAction);
         }
         battleAction.bl_attackerRestoreHp = 0;
         battleAction.bl_attackerRestoreCp = 0;
         battleAction.bl_attackerDamageHp = 0;
         battleAction.bl_attackerDamageCp = 0;
         battleAction.bl_defenderRestoreHp = 0;
         battleAction.bl_defenderRestoreCp = 0;
         battleAction.bl_defenderDamageHp = 0;
         battleAction.bl_defenderDamageCp = 0;
         for(i = 0; i < battleAction_effect_Arr.length; i++)
         {
            if(rNum <= battleAction_effect_Arr[i].chancetohit / 100)
            {
               if(!battleAction.dodge || isSelfBuff)
               {
                  if(battleAction_effect_Arr[i].duration == 0)
                  {
                     SetBloodlineInstantEffect(battleAction_effect_Arr[i],battleAction_skillId,battleAction);
                     battleAction_effect_Arr[i].hit = true;
                  }
                  else
                  {
                     SetBloodlineBuffOrDebuffEffect(battleAction_effect_Arr[i],battleAction_skillId);
                     battleAction_effect_Arr[i].hit = true;
                  }
               }
            }
            battleAction.effect["effect_hit_" + [i + 1]] = battleAction_effect_Arr[i].hit;
         }
      }
      
      public function getSenjutsuEffectArr(battleAction_effect:Object) : Array
      {
         var sen_effect_1:Object = {};
         var sen_effect_2:Object = {};
         var sen_effect_3:Object = {};
         var battleAction_effect_Arr:Array = [];
         if(battleAction_effect == null)
         {
            return battleAction_effect_Arr;
         }
         if(battleAction_effect.effect_type_1 && battleAction_effect.effect_type_1 != "")
         {
            sen_effect_1.type = battleAction_effect.effect_type_1;
            sen_effect_1.duration = battleAction_effect.duration_1;
            sen_effect_1.target = battleAction_effect.effect_target_1;
            sen_effect_1.chancetohit = battleAction_effect.effect_chancetohit_1;
            sen_effect_1.chancetoeffect = battleAction_effect.effect_chancetoeffect_1;
            sen_effect_1.requirement = battleAction_effect.effect_requirement_1;
            sen_effect_1.amount = battleAction_effect.effect_amount_1;
            sen_effect_1.hit = false;
            sen_effect_1.resisted = battleAction_effect.effect_resisted_1;
            battleAction_effect_Arr.push(sen_effect_1);
         }
         if(battleAction_effect.effect_type_2 && battleAction_effect.effect_type_2 != "")
         {
            sen_effect_2.type = battleAction_effect.effect_type_2;
            sen_effect_2.duration = battleAction_effect.duration_2;
            sen_effect_2.target = battleAction_effect.effect_target_2;
            sen_effect_2.chancetohit = battleAction_effect.effect_chancetohit_2;
            sen_effect_2.chancetoeffect = battleAction_effect.effect_chancetoeffect_2;
            sen_effect_2.requirement = battleAction_effect.effect_requirement_2;
            sen_effect_2.amount = battleAction_effect.effect_amount_2;
            sen_effect_2.hit = false;
            sen_effect_2.resisted = battleAction_effect.effect_resisted_2;
            battleAction_effect_Arr.push(sen_effect_2);
         }
         if(battleAction_effect.effect_type_3 && battleAction_effect.effect_type_3 != "")
         {
            sen_effect_3.type = battleAction_effect.effect_type_3;
            sen_effect_3.duration = battleAction_effect.duration_3;
            sen_effect_3.target = battleAction_effect.effect_target_3;
            sen_effect_3.chancetohit = battleAction_effect.effect_chancetohit_3;
            sen_effect_3.chancetoeffect = battleAction_effect.effect_chancetoeffect_3;
            sen_effect_3.requirement = battleAction_effect.effect_requirement_3;
            sen_effect_3.amount = battleAction_effect.effect_amount_3;
            sen_effect_3.hit = false;
            sen_effect_3.resisted = battleAction_effect.effect_resisted_3;
            battleAction_effect_Arr.push(sen_effect_3);
         }
         return battleAction_effect_Arr;
      }
      
      public function checkSenjutsuEffect() : *
      {
         var battleAction:Object = null;
         var healTarget:* = undefined;
         var effect:Object = null;
         var key:String = null;
         var rNum:Number = NaN;
         var i:int = 0;
         var battleAction_effect:Object = null;
         var battleAction_skillId:String = null;
         var battleAction_effect_Arr:Array = null;
         var isSelfBuff:Boolean = false;
         battleAction = this.attacker.getBattleAction();
         battleAction_effect = battleAction.effect;
         battleAction_skillId = "";
         if(battleAction.SENSKILLID)
         {
            battleAction_skillId = battleAction.SENSKILLID;
         }
         battleAction_effect_Arr = getSenjutsuEffectArr(battleAction_effect);
         rNum = NumberUtil.getRandom();
         isSelfBuff = true;
         for(i = 0; i < battleAction_effect_Arr.length; i++)
         {
            if(battleAction_effect_Arr[i].target != 0 && battleAction_effect_Arr[i].target != 3 && battleAction_effect_Arr[i].target != 4 && battleAction_effect_Arr[i].target != 6)
            {
               isSelfBuff = false;
            }
         }
         if(isSelfBuff)
         {
            battleAction.dodge = false;
         }
         else
         {
            this.checkClone(battleAction);
         }
         battleAction.sen_attackerRestoreHp = 0;
         battleAction.sen_attackerRestoreCp = 0;
         battleAction.sen_attackerDamageHp = 0;
         battleAction.sen_attackerDamageCp = 0;
         battleAction.sen_defenderRestoreHp = 0;
         battleAction.sen_defenderRestoreCp = 0;
         battleAction.sen_defenderDamageHp = 0;
         battleAction.sen_defenderDamageCp = 0;
         battleAction.sen_attackerRestoreSp = 0;
         battleAction.sen_defenderRestoreSp = 0;
         battleAction.sen_attackerDamageSp = 0;
         battleAction.sen_defenderDamageSp = 0;
         for(i = 0; i < battleAction_effect_Arr.length; i++)
         {
            Out.debug("","senjutsu type = " + battleAction_effect_Arr[i].type);
            if(rNum <= battleAction_effect_Arr[i].chancetohit / 100)
            {
               if(!battleAction.dodge || isSelfBuff)
               {
                  if(battleAction_effect_Arr[i].duration == 0)
                  {
                     SetSenjutsuInstantEffect(battleAction_effect_Arr[i],battleAction_skillId,battleAction);
                     battleAction_effect_Arr[i].hit = true;
                  }
                  else
                  {
                     SetSenjutsuBuffOrDebuffEffect(battleAction_effect_Arr[i],battleAction_skillId);
                     battleAction_effect_Arr[i].hit = true;
                  }
               }
               else
               {
                  Out.debug("rex","senjutsu be dodge");
               }
            }
            battleAction.effect["effect_hit_" + [i + 1]] = battleAction_effect_Arr[i].hit;
         }
      }
      
      private function healTarget() : void
      {
         var battleAction:Object = null;
         var heal:int = 0;
         var result:Number = NaN;
         var amount:int = 0;
         var healObj:Object = null;
         var i:int = 0;
         var levelBouns:int = 0;
         battleAction = this.attacker.getBattleAction();
         if(battleAction.effect)
         {
            trace(battleAction.effect.type);
            switch(battleAction.effect.type)
            {
               case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                  battleAction.healTarget = [];
                  amount = int(battleAction.effect.amount) * 29;
                  amount = this.updateHP(this.attacker,amount);
                  healObj = {
                     "target":this.attacker,
                     "heal":amount
                  };
                  battleAction.healTarget.push(healObj);
                  this.attacker.setBattleAction(battleAction);
                  return;
               case BattleData.SKILL_2000:
                  levelBouns = this.attacker.getLevel() - 60;
                  if(levelBouns < 0)
                  {
                     levelBouns = 0;
                  }
                  amount = Math.round(1000 + levelBouns * 70);
                  battleAction.healTarget = [];
                  for(i = 0; i < this.characterArr.length; i++)
                  {
                     if(this.characterArr[i].side == this.attacker.side)
                     {
                        amount = this.updateHP(this.characterArr[i],amount);
                        healObj = {
                           "target":this.characterArr[i],
                           "heal":amount
                        };
                        battleAction.healTarget.push(healObj);
                     }
                  }
                  this.attacker.setBattleAction(battleAction);
                  return;
            }
         }
         if(battleAction.heal == null)
         {
            return;
         }
         heal = battleAction.heal;
         result = Number(int(this.attacker.getData(DBCharacterData.WATER)) * 1 / 100);
         heal = Math.round(heal * (1 + result));
         if(battleAction.critical == true)
         {
            heal = Math.round(heal * this.attacker.criticalBonus);
         }
         if(this.attacker.side != this.defender.side)
         {
            this.defender = this.attacker;
            battleAction.target = "self";
         }
         heal = this.updateHP(this.defender,heal);
         battleAction.heal = heal;
         this.attacker.setBattleAction(battleAction);
      }
      
      private function damageTarget() : void
      {
         var battleAction:Object = null;
         var i:int = 0;
         var targetArr:Array = null;
         var dmgArr:Array = null;
         battleAction = this.attacker.getBattleAction();
         targetArr = [defender];
         Out.debug(this,"damageTarget :: targetArr.length >> " + targetArr.length);
         if(battleAction.target)
         {
            if(battleAction.target == "all")
            {
               targetArr = [];
               for(i = 0; i < this.characterArr.length; i++)
               {
                  if(this.characterArr[i].side != this.attacker.side)
                  {
                     targetArr.push(this.characterArr[i]);
                  }
               }
            }
            if(battleAction.target == "allEnemy")
            {
               targetArr = [];
               for(i = 0; i < this.characterArr.length; i++)
               {
                  if(this.characterArr[i].side != this.attacker.side)
                  {
                     targetArr.push(this.characterArr[i]);
                  }
               }
            }
            if(battleAction.target == "map")
            {
               targetArr = this.characterArr;
            }
            if(battleAction.target == "friendly")
            {
               targetArr = [];
               for(i = 0; i < this.characterArr.length; i++)
               {
                  if(this.characterArr[i].side == this.attacker.side)
                  {
                     targetArr.push(this.characterArr[i]);
                  }
               }
            }
         }
         for(i = 0; i < targetArr.length; i++)
         {
            this.processDamage(targetArr[i]);
         }
         dmgArr = battleAction.dmgArr;
         if(dmgArr)
         {
            for(i = 0; i < dmgArr.length; i++)
            {
               if(dmgArr[i].characterId == this.defender.getCharacterId())
               {
                  if(dmgArr[i].dmg != null)
                  {
                     battleAction.dmg = dmgArr[i].dmg;
                  }
                  break;
               }
            }
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      private function processDamage(target:*) : void
      {
         var battleAction:Object = null;
         var dmg:int = 0;
         var rNum:Number = NaN;
         var key:* = null;
         var amount:int = 0;
         var effect:Object = null;
         var gearObj:Object = null;
         var dmgAbsorption:int = 0;
         var cpRequired:int = 0;
         var hpRequired:int = 0;
         var ReboundDmgRate:Number = NaN;
         var ReboundDmg:int = 0;
         var hpLost:int = 0;
         var cpLost:int = 0;
         var tempEffect:Object = null;
         var i:int = 0;
         var affectedEnemyArr:Array = null;
         var dmgObj:Object = null;
         var BloodlineDamageBonus:int = 0;
         var BloodlineDamageConvert:int = 0;
         var skillData:Object = null;
         var skillDamageReduction:int = 0;
         var tmpEffect:Object = null;
         var refObj:* = undefined;
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var defenderBuff:Object = null;
         var defenderDebuff:Object = null;
         var clanEffect:Object = null;
         var tmpEffectB:Object = null;
         var targetAccessory:Object = null;
         var temp:int = 0;
         var burnCP:int = 0;
         var burnCP_weak:int = 0;
         var factor:* = undefined;
         var tmpDebuff:Object = null;
         var debuffLen:int = 0;
         var removeEffect:Object = null;
         var removeEffectType:String = null;
         var tmpKey:* = undefined;
         var dmgBonus:Number = NaN;
         var tagerWeapon:Object = null;
         var targetBackItem:Object = null;
         var targetGearset:Object = null;
         var setEffect:Object = null;
         var hpReduce:Number = NaN;
         var cpReduce:Number = NaN;
         var spReduce:Number = NaN;
         var guardChance:Number = NaN;
         var targetWeapon:Object = null;
         var SufferDamageModifier:uint = 0;
         var DealDamageModifier:uint = 0;
         var levelBouns:int = 0;
         var minusHP:int = 0;
         var tmpInt:int = 0;
         var currTmpInt:int = 0;
         var buff:* = undefined;
         var diff:int = 0;
         var dmgPartAbsorbed:int = 0;
         var dmgPartDmg:int = 0;
         Out.debug(this,"processDamage :: target >> " + target.getCharacterName());
         Out.debug(this,"processDamage :: attacker maxcp >> " + this.attacker.maxCP);
         Out.debug(this,"processDamage :: attacker cp >> " + this.attacker.cp);
         Out.debug(this,"processDamage :: attacker maxhp >> " + this.attacker.maxHP);
         Out.debug(this,"processDamage :: attacker hp >> " + this.attacker.hp);
         Out.debug(this,"processDamage :: defender.type >> " + this.defender.type);
         Out.debug(this,"processDamage :: attacker.type >> " + this.attacker.type);
         battleAction = this.attacker.getBattleAction();
         Out.debug(this,"processDamage :: battleAction.dmg >> " + battleAction.dmg);
         Central.main.petExtraDmg = false;
         Central.main.petExtraDmgAmount = 0;
         if(this.attacker.type == this.attacker.TYPE_CHARACTER || this.attacker.type == this.attacker.TYPE_PET)
         {
            if(!this.HpCondition || !this.CpCondition)
            {
               battleAction.dmg = 0;
            }
         }
         this.HpCondition = true;
         this.CpCondition = true;
         var ignoreProtection:Boolean = false;
         dmg = 0 - battleAction.dmg;
         ReboundDmgRate = 0;
         ReboundDmg = 0;
         var MAX_SKILL_EFFECT_LENGTH:int = 3;
         var k:int = 0;
         var j:int = 0;
         i = 0;
         dmgObj = {};
         dmgObj.characterType = target.type;
         dmgObj.characterId = target.getCharacterId();
         dmgObj.defenderRestoreHp = 0;
         dmgObj.defenderRestoreCp = 0;
         dmgObj.defenderDamageHp = 0;
         dmgObj.defenderDamageCp = 0;
         if(battleAction.clones != null)
         {
            if(battleAction.clones[target.getCharacterId()])
            {
               dmgObj.dmg = 0;
               switch(battleAction.clones[target.getCharacterId()].effectName)
               {
                  case BattleData.TYPE_DUMMY_BURN:
                     effect = {
                        "type":BattleData.EFFECT_BURNING,
                        "duration":3,
                        "amount":5
                     };
                     battleAction.attackerDebuff.push(effect);
                     break;
                  case BattleData.TYPE_DUMMY_STUN:
                     effect = {
                        "type":BattleData.EFFECT_STUN,
                        "duration":2
                     };
                     battleAction.attackerDebuff.push(effect);
               }
               battleAction.dmgArr.push(dmgObj);
               this.attacker.setBattleAction(battleAction);
               return;
            }
         }
         if(!Central.battle.seal_enemy)
         {
            if(battleAction.dodge == true)
            {
               Out.debug(this,"seal enemy was dogde");
               battleAction.dmgArr.push(dmgObj);
               this.attacker.setBattleAction(battleAction);
               return;
            }
         }
         else
         {
            Out.debug(this,"seal enemy can\'t dogde");
         }
         if(battleAction.effect)
         {
            Out.debug(this,"battleAction.effect.type >> " + battleAction.effect.type);
            switch(battleAction.effect.type)
            {
               case BattleData.EFFECT_BURN:
               case BattleData.EFFECT_BURNING:
               case BattleData.EFFECT_PET_BURN:
               case BattleData.EFFECT_BURN_FIX_NUM:
               case BattleData.EFFECT_DEFENDER_BURNING:
                  if(target.getBackItem())
                  {
                     targetBackItem = Central.main.BACK_ITEM_DATA.find(target.getBackItem());
                     if(targetBackItem)
                     {
                        for each(tmpEffectB in targetBackItem.effect)
                        {
                           switch(tmpEffectB.type)
                           {
                              case BattleData.EFFECT_BURN_PROTECTION:
                                 if(NumberUtil.getRandom() <= tmpEffectB.chance / 100)
                                 {
                                    battleAction.effect = null;
                                 }
                                 continue;
                              default:
                                 continue;
                           }
                        }
                     }
                  }
                  if(target.getAccessory())
                  {
                     targetAccessory = Central.main.ACCESSORY_DATA.find(target.getAccessory());
                     if(targetAccessory)
                     {
                        tmpEffectB = null;
                        for each(tmpEffectB in targetAccessory.effect)
                        {
                           switch(tmpEffectB.type)
                           {
                              case BattleData.EFFECT_BURN_PROTECTION:
                                 if(NumberUtil.getRandom() <= tmpEffectB.chance / 100)
                                 {
                                    battleAction.effect = null;
                                 }
                                 continue;
                              default:
                                 continue;
                           }
                        }
                     }
                  }
            }
         }
         if(battleAction.effect)
         {
            effect = battleAction.effect;
            switch(effect.type)
            {
               case BattleData.EFFECT_STUN:
                  if(battleAction.stun == true)
                  {
                     battleAction.effect = this.setDebuff(target,effect);
                  }
                  break;
               case BattleData.EFFECT_BLEEDING:
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_BURN:
                  effect.amount = Math.round(target.maxHP * (effect.amount / 100));
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_BURN_FIX_NUM:
               case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  if(effect.amount == null || int(effect.amount) <= 0)
                  {
                     effect.amount = 70;
                  }
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_BUNDLE:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  battleAction.effect.damageCp = Math.abs(this.updateCP(target,0 - Math.round(target.cp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageCp = this.updateCP(this.attacker,battleAction.effect.damageCp);
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  hpLost = Math.round(target.hp * 0.15);
                  hpLost = Math.abs(this.updateHP(target,0 - hpLost));
                  battleAction.effect.damageHp = this.updateHP(this.attacker,hpLost);
                  break;
               case BattleData.EFFECT_POISON:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                  tempEffect = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tempEffect);
                  tempEffect = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":effect.duration,
                     "amount":0
                  };
                  target.setBattleDebuff(tempEffect);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  tempEffect = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tempEffect);
                  tempEffect = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":effect.duration,
                     "amount":0
                  };
                  target.setBattleDebuff(tempEffect);
                  break;
               case BattleData.EFFECT_FEAR:
               case BattleData.EFFECT_FEAR_WEAKEN:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_PARASITE:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  battleAction.defenderDamageCp = Math.round(target.maxCP * int(effect.amount) * 0.01);
                  break;
               case BattleData.EFFECT_BURNING:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.SKILL_342:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME:
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                  Out.debug(this,"processDamage :: effect hank >> " + effect.type);
                  target.setBattleBuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_DARKNESS,
                     "duration":battleAction.effect.duration,
                     "amount":5
                  };
                  target.setBattleDebuff(effect);
                  break;
               case BattleData.SKILL_234:
               case BattleData.EFFECT_DAMAGE_BONUS:
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
               case BattleData.EFFECT_DAMAGE_REDUCTION:
               case BattleData.EFFECT_SERENE_MIND:
                  target.setBattleBuff(effect);
                  break;
               case BattleData.SKILL_236:
                  battleAction.effect = this.setDebuff(target,effect);
                  target.addSkillCooldown(4,SkillData.TYPE_WIND);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_234))
                  {
                     hpLost = Math.round(target.maxHP * 0.08);
                     battleAction.effect.damageHp = Math.abs(this.updateHP(target,0 - hpLost));
                  }
                  break;
               case BattleData.SKILL_287:
                  tempEffect = {
                     "type":BattleData.EFFECT_DECREASE_CRITICAL_CHANCE,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  tempEffect = this.setDebuff(target,tempEffect);
                  battleAction.effect.resisted = tempEffect.resisted;
                  target.addSkillCooldown(3,SkillData.TYPE_LIGHTNING);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_285))
                  {
                     dmg = Math.round(dmg * 1.2);
                  }
                  break;
               case BattleData.SKILL_270:
                  battleAction.effect = this.setDebuff(target,effect);
                  target.addSkillCooldown(4,SkillData.TYPE_FIRE);
                  if(this.attacker.isBattleBuffActive(BattleData.SKILL_268))
                  {
                     tempEffect = {
                        "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                        "duration":5,
                        "amount":50
                     };
                     target.setBattleDebuff(tempEffect);
                     battleAction.effect.extraEffect = true;
                  }
                  break;
               case BattleData.SKILL_304:
                  battleAction.effect = this.setDebuff(target,effect);
                  target.addSkillCooldown(4,SkillData.TYPE_EARTH);
                  break;
               case BattleData.SKILL_307:
                  target.setBattleBuff(effect);
                  target.clearAllDebuff();
                  break;
               case BattleData.SKILL_359:
                  battleAction.effect = this.setDebuff(target,effect);
                  battleAction.defenderDamageCp = Math.round(target.maxCP * 0.75);
                  break;
               case BattleData.SKILL_336:
                  battleAction.effect.damageCp = Math.abs(this.updateCP(target,0 - Math.round(target.cp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageCp = this.updateCP(this.attacker,battleAction.effect.damageCp);
                  effect = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":effect.duration
                  };
                  target.setBattleDebuff(effect);
                  break;
               case BattleData.EFFECT_PET_BURN:
               case BattleData.EFFECT_PET_WEAKEN:
               case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  target.reduceSkillCooldown(effect.amount,BattleData.REDUCETYPE_SKILL);
                  break;
               case BattleData.EFFECT_WIND_PEACE:
               case BattleData.EFFECT_WIND_PEACE_2:
               case BattleData.EFFECT_WIND_PEACE_3:
               case BattleData.EFFECT_WIND_PEACE_4:
                  target.setBattleBuff(effect);
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  battleAction.effect.damageHp = Math.abs(this.updateHP(target,0 - Math.round(target.hp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageHp = this.updateHP(this.attacker,battleAction.effect.damageHp);
                  battleAction.effect.damageCp = Math.abs(this.updateCP(target,0 - Math.round(target.cp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageCp = this.updateCP(this.attacker,battleAction.effect.damageCp);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
               case BattleData.EFFECT_REDUCE_HP_CP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
               case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                  battleAction.effect = this.setDebuff(target,effect);
                  break;
               case BattleData.EFFECT_CLEARBUFF_STUN:
                  tempEffect = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":effect.duration
                  };
                  battleAction.effect = this.setDebuff(target,tempEffect);
                  target.clearBuff();
                  break;
               case BattleData.EFFECT_CLEARBUFF:
                  target.clearBuff();
                  tempEffect = {"type":BattleData.EFFECT_CLEARBUFF};
                  battleAction.effect = this.setDebuff(target,tempEffect);
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  target.clearBuff();
                  target.clearAllDebuff();
                  temp = Math.ceil(Math.random() * 25);
                  burnCP = Math.round(target.cp * ((int(battleAction.effect.amount) - temp) / 100));
                  battleAction.defenderDamageCp = burnCP;
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY:
                  target.clearBuff();
                  target.clearAllDebuff();
                  tmpEffect = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  burnCP_weak = target.cp * (15 + Math.floor(Math.random() * 21)) / 100;
                  battleAction.defenderDamageCp = burnCP_weak;
                  if(!battleAction.removedEffectList)
                  {
                     break;
                  }
                  for each(removeEffect in battleAction.removedEffectList)
                  {
                     if(target.getData(DBCharacterData.ID) == removeEffect.targetId)
                     {
                        removeEffectType = removeEffect.type;
                        target.removeBuff(removeEffectType);
                        target.removeDebuff(removeEffectType);
                     }
                  }
                  break;
               case BattleData.EFFECT_CLEAR_SELF_DEBUFF_DEFENDER_BUFF:
                  target.clearBuff();
                  this.attacker.clearAllDebuff();
                  break;
               case BattleData.EFFECT_FINAL_ATTACK:
                  this.attacker.clearAllDebuff();
                  dmg = -100;
                  factor = Math.random() * int(battleAction.effect.amount - 1);
                  dmg = dmg * (1 + factor);
                  dmg = int(dmg);
                  battleAction.dmg = dmg * -1;
                  break;
               case BattleData.EFFECT_BURN_CP:
                  battleAction.defenderDamageCp = Math.round(target.maxCP * int(effect.amount) * 0.01);
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
                  effect.intmem1 = 0;
                  effect.intmem2 = Math.floor(target.maxHP * effect.amount * 0.01);
                  target.setBattleBuff(effect);
                  effect = {
                     "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                     "duration":effect.duration,
                     "amount":100
                  };
                  target.setBattleBuff(effect);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_BLEEDING:
                  tmpEffect = {
                     "type":BattleData.EFFECT_BLEEDING,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":effect.duration,
                     "amount":100
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_TRANSFORM:
                  target.setBattleDebuff(effect);
                  break;
               case BattleData.EFFECT_BLEEDING_STUN:
                  tmpEffect = {
                     "type":BattleData.EFFECT_STUN,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_BLEEDING,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_CHAOS_N_BURN:
                  tmpEffect = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":effect.duration
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_BURN_HP_CLEAR_BUFF:
                  target.clearBuff();
                  tmpEffect = {
                     "type":BattleData.EFFECT_PET_BURN,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  target.clearBuff();
                  target.setBattleDebuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_BURN_CP_HP:
                  dmgObj.defenderDamageHp = Math.round(target.maxHP * int(effect.amount) * 0.01);
                  dmgObj.defenderDamageCp = Math.round(target.maxCP * int(effect.amount) * 0.01);
                  dmgObj.defenderDamageHp = this.updateHP(target,0 - dmgObj.defenderDamageHp);
                  dmgObj.defenderDamageCp = this.updateCP(target,0 - dmgObj.defenderDamageCp);
                  break;
               case BattleData.EFFECT_REDUCE_PURIFY_N_BURNING:
                  tmpEffect = {
                     "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                     "duration":effect.duration,
                     "amount":20
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_UPG_REDUCE_PURIFY_N_BURNING:
                  tmpEffect = {
                     "type":BattleData.EFFECT_REDUCE_PURIFY_CHANCE,
                     "duration":effect.duration,
                     "amount":50
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_BURNING,
                     "duration":effect.duration,
                     "amount":effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_CHAOS:
                  tmpEffect = {
                     "type":BattleData.EFFECT_CHAOS,
                     "duration":3
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_INTERNAL_INJURY,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_CLEAR_DEBUFF_RST_DMG_HP:
                  dmgObj.defenderDamageHp = Math.round(target.maxHP * battleAction.effect.amount * 0.01);
                  break;
               case BattleData.EFFECT_ACCUM_BLEEDING:
                  target.setBattleDebuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_BURNING_WITH_DEBUFF_NUM:
                  tmpDebuff = target.getBattleDebuff();
                  debuffLen = 0;
                  for(tmpKey in tmpDebuff)
                  {
                     debuffLen++;
                  }
                  if(debuffLen > 0)
                  {
                     tmpEffect = {
                        "type":BattleData.EFFECT_ULTRA_BURNING,
                        "amount":5 * debuffLen,
                        "duration":battleAction.effect.duration
                     };
                     target.setBattleDebuff(tmpEffect);
                  }
                  tmpEffect = {
                     "type":BattleData.EFFECT_BURNING,
                     "amount":battleAction.effect.amount,
                     "duration":battleAction.effect.duration
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_FLAME:
                  target.setBattleDebuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION_N_FEAR_WEAKEN:
                  tmpEffect = {
                     "type":BattleData.EFFECT_CUBE_ILLUSION,
                     "duration":battleAction.effect.duration
                  };
                  target.setBattleDebuff(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_FEAR_WEAKEN,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_DMG_BONUS_N_BLEEDING:
                  tmpEffect = {
                     "type":BattleData.EFFECT_BLEEDING,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  target.setBattleDebuff(tmpEffect);
                  break;
               case BattleData.EFFECT_CP_BLEEDING:
                  target.setBattleDebuff(battleAction.effect);
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                  battleAction.effect.damageHp = Math.abs(this.updateHP(target,0 - Math.round(target.hp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageHp = this.updateHP(this.attacker,battleAction.effect.damageHp);
                  battleAction.effect.damageCp = Math.abs(this.updateCP(target,0 - Math.round(target.cp * int(effect.amount) * 0.01)));
                  battleAction.effect.damageCp = this.updateCP(this.attacker,battleAction.effect.damageCp);
                  this.defender.addAllSkillCooldown(battleAction.effect.duration);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_DISORIENTED:
                  this.defender.clearBuff();
                  tmpEffect = {
                     "type":BattleData.EFFECT_PET_DISORIENTED,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.defenderDebuff.push(tmpEffect);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_N_BLIND:
                  tmpEffect = {
                     "type":BattleData.EFFECT_DAMAGE_BONUS,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.attackerBuff.push(tmpEffect);
                  tmpEffect = {
                     "type":BattleData.EFFECT_BLIND,
                     "duration":battleAction.effect.duration,
                     "amount":battleAction.effect.amount
                  };
                  battleAction.defenderDebuff.push(tmpEffect);
            }
         }
         if(battleAction.dmg == null)
         {
            battleAction.dmgArr.push(dmgObj);
            this.attacker.setBattleAction(battleAction);
            return;
         }
         if(dmg > 0)
         {
            return;
         }
         if(battleAction.critical)
         {
            dmg = dmg * this.attacker.criticalBonus;
         }
         BloodlineDamageBonus = 0;
         BloodlineDamageConvert = 0;
         skillData = Central.main.SKILL_DATA[battleAction.skillId];
         BloodlineDamageBonus = this.CalculateBloodlineDamagebonus(battleAction,effect,skillData,dmg);
         dmg = dmg + BloodlineDamageBonus;
         dmg = calcSenjutsuDamageBonus(dmg,this.attacker.getBattleBuff(),this.attacker.getBattleDebuff(),target.getBattleBuff(),target.getBattleDebuff());
         if(BloodlineDamageBonus > 0 && target.hp > 0 || BloodlineDamageBonus < 0)
         {
            this.updateHP(target,BloodlineDamageBonus);
         }
         skillDamageReduction = this.calculateSkillDamageReduction(battleAction,effect,skillData,dmg);
         dmg = dmg + skillDamageReduction;
         if(skillDamageReduction > 0)
         {
            this.updateHP(target,skillDamageReduction);
         }
         BloodlineDamageConvert = this.CalculateBloodlineDamageConvert(battleAction,dmg);
         dmg = dmg + BloodlineDamageConvert;
         this.updateHP(target,BloodlineDamageConvert);
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
                     dmg = dmg - this.updateDamageByHitNum(battleAction,tmpEffect.amount);
                     continue;
                  case BattleData.EFFECT_ADD_DAMAGE_BONUS:
                     if(battleAction.action == "weapon_attack")
                     {
                        rNum = NumberUtil.getRandom();
                        if(rNum <= tmpEffect.chance / 100)
                        {
                           dmg = Math.round(dmg * (1 + tmpEffect.amount / 100));
                        }
                     }
                     else
                     {
                        dmg = Math.round(dmg * (1 + tmpEffect.amount / 100));
                     }
                     continue;
                  case BattleData.EFFECT_REDUCE_HP_PRESENT:
                     rNum = NumberUtil.getRandom();
                     if(rNum <= tmpEffect.chance / 100)
                     {
                        dmg = dmg - Math.round(this.defender.hp * (tmpEffect.amount / 100));
                     }
                     continue;
                  case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                     dmgBonus = tmpEffect.amount;
                     if(battleAction.action == "weapon_attack")
                     {
                        if(target.hp / target.maxHP < dmgBonus / 100)
                        {
                           dmg = dmg - target.maxHP;
                           battleAction.weapon_activated = true;
                        }
                     }
                     continue;
                  case BattleData.EFFECT_REDUCE_TARGET_CP:
                     if(battleAction.action == "weapon_attack")
                     {
                        cpRequired = Math.round(target.maxCP * (tmpEffect.amount / 100));
                        if(cpRequired <= 0)
                        {
                           cpRequired = 0;
                        }
                        battleAction.defenderDamageCp = battleAction.defenderDamageCp + cpRequired;
                     }
                     continue;
                  case BattleData.EFFECT_REDUCE_TARGET_HP:
                     if(battleAction.action == "weapon_attack")
                     {
                        hpRequired = Math.round(target.maxHP * (tmpEffect.amount / 100));
                        if(hpRequired <= 0)
                        {
                           hpRequired = 0;
                        }
                        battleAction.defenderDamageHp = battleAction.defenderDamageHp + hpRequired;
                     }
                     continue;
                  case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                     if(battleAction.critical)
                     {
                        dmg = dmg - tmpEffect.amount;
                     }
                     continue;
                  case BattleData.EFFECT_CRITICAL_SUCCESS_TO_ADD_CHANCE:
                     if(battleAction.critical)
                     {
                        effect = {
                           "type":BattleData.EFFECT_CRITICAL_CHANCE_BONUS,
                           "duration":tmpEffect.duration,
                           "amount":tmpEffect.amount
                        };
                        battleAction.attackerBuff.push(effect);
                     }
                     continue;
                  default:
                     continue;
               }
            }
            if(this.attackerWeapon.extra_effect && this.attackerWeapon.extra_effect != null)
            {
               affectedEnemyArr = [];
               tmpEffect = this.attackerWeapon.extra_effect;
               for(i = 0; i < tmpEffect.enemy.length; i++)
               {
                  affectedEnemyArr.push(Central.main.ENEMY_DATA.find(tmpEffect.enemy[i]).name);
               }
               if(defender.type == 4 && affectedEnemyArr.indexOf(target.getCharacterName()) >= 0)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_BURN_CP:
                        battleAction.defenderDamageCp = battleAction.defenderDamageCp + Math.round(defender.maxCP * int(tmpEffect.amount) * 0.01);
                        break;
                     case BattleData.EFFECT_BURN_HP:
                        dmgObj.defenderDamageHp = dmgObj.defenderDamageHp + Math.round(target.maxHP * int(tmpEffect.amount) * 0.01);
                  }
               }
            }
         }
         if(target.getWeapon())
         {
            tagerWeapon = Central.main.WEAPON_DATA.find(target.getWeapon());
            if(tagerWeapon)
            {
               for each(tmpEffect in tagerWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        dmg = dmg + tmpEffect.amount;
                        if(dmg > 0)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_ATTACKER_BLIND:
                        effect = {};
                        effect.type = BattleData.EFFECT_BLIND;
                        effect.duration = int(tmpEffect.duration);
                        effect.amount = int(tmpEffect.amount);
                        battleAction.attackerDebuff.push(effect);
                        continue;
                     case BattleData.EFFECT_WEAPON_MANA_SHIELD:
                        dmgAbsorption = Math.round(dmg * (tmpEffect.amount / 100));
                        cpRequired = Math.round(Math.abs(dmgAbsorption) / 2);
                        if(target.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
                        {
                           cpRequired = 0;
                        }
                        if(target.cp >= cpRequired)
                        {
                           battleAction.defenderDamageCp = battleAction.defenderDamageCp + cpRequired;
                        }
                        dmg = dmg - dmgAbsorption;
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        dmg = Math.round(dmg * (1 - tmpEffect.amount / 100));
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        dmg = Math.round(dmg * (tmpEffect.amount / 100));
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         refObj = {"dmg":dmg};
         dmg = refObj.dmg;
         if(this.attackerBackItem)
         {
            for each(tmpEffect in this.attackerBackItem.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                     dmg = Math.round(dmg * (1 + tmpEffect.amount / 100));
                     continue;
                  case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                     if(battleAction.critical)
                     {
                        dmg = dmg * (1 + tmpEffect.amount / 100);
                     }
                     continue;
                  case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     dmg = dmg - this.updateDamageByHitNum(battleAction,tmpEffect.amount);
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(this.attackerAccessory)
         {
            for each(tmpEffect in this.attackerAccessory.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                     dmg = Math.round(dmg * (1 + tmpEffect.amount / 100));
                     continue;
                  case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                     if(battleAction.critical)
                     {
                        dmg = dmg * (1 + tmpEffect.amount / 100);
                     }
                     continue;
                  case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     dmg = dmg - this.updateDamageByHitNum(battleAction,tmpEffect.amount);
                     continue;
                  default:
                     continue;
               }
            }
            if(this.attackerAccessory.extra_effect && this.attackerAccessory.extra_effect != null)
            {
               affectedEnemyArr = [];
               tmpEffect = this.attackerAccessory.extra_effect;
               for(i = 0; i < tmpEffect.enemy.length; i++)
               {
                  affectedEnemyArr.push(Central.main.ENEMY_DATA.find(tmpEffect.enemy[i]).name);
               }
               if(defender.type == 4 && affectedEnemyArr.indexOf(target.getCharacterName()) >= 0)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_BURN_HP:
                        dmgObj.defenderDamageHp = dmgObj.defenderDamageHp + Math.round(target.maxHP * int(tmpEffect.amount) * 0.01);
                  }
               }
            }
         }
         if(this.attacker.getBloodlineEffect())
         {
            for each(tmpEffect in this.attacker.getBloodlineEffect())
            {
               switch(tmpEffect.type)
               {
                  case BloodlineData.EFFECT_ADD_DMG_BONUS_RELATE_CP:
                     dmg = dmg - Math.round(this.attacker.maxCP * tmpEffect.amount * 0.01);
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(target.getBackItem())
         {
            targetBackItem = Central.main.BACK_ITEM_DATA.find(target.getBackItem());
            if(targetBackItem)
            {
               for each(tmpEffect in targetBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        dmg = dmg - Math.round(dmg * (tmpEffect.amount / 100));
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        dmg = dmg + tmpEffect.amount;
                        if(dmg > 0)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        dmg = Math.round(dmg * (1 - tmpEffect.amount / 100));
                        continue;
                     default:
                        continue;
                  }
               }
            }
            if(targetBackItem.extra_effect && targetBackItem.extra_effect != null)
            {
               affectedEnemyArr = [];
               tmpEffect = targetBackItem.extra_effect;
               for(i = 0; i < tmpEffect.enemy.length; i++)
               {
                  affectedEnemyArr.push(Central.main.ENEMY_DATA.find(tmpEffect.enemy[i]).name);
               }
               if(defender.type == 1 && affectedEnemyArr.indexOf(this.attacker.getCharacterName()) >= 0)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        dmg = Math.round(dmg * (1 - tmpEffect.amount / 100));
                  }
               }
            }
         }
         if(target.getAccessory())
         {
            targetAccessory = Central.main.ACCESSORY_DATA.find(target.getAccessory());
            if(targetAccessory)
            {
               for each(tmpEffect in targetAccessory.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        dmg = dmg - Math.round(dmg * (tmpEffect.amount / 100));
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                        dmg = dmg + tmpEffect.amount;
                        if(dmg > 0)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                        dmg = Math.round(dmg * (1 - tmpEffect.amount / 100));
                        continue;
                     case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                        if(target.hp / target.maxHP < tmpEffect.amount / 100 && NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           dmg = 0;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(target.getBloodlineEffect())
         {
            for each(tmpEffect in target.getBloodlineEffect())
            {
               switch(tmpEffect.type)
               {
                  case BloodlineData.EFFECT_REDUCE_DMG_BY_CP_PERCENT:
                     dmg = dmg + Math.round(Math.abs(dmg) * (1 - target.cp / target.maxCP) * tmpEffect.amount * 0.01);
                     continue;
                  case BloodlineData.EFFECT_DMG_REDUCTION:
                     dmg = dmg + Math.round(Math.abs(dmg) * tmpEffect.amount * 0.01);
                     continue;
                  default:
                     continue;
               }
            }
         }
         if(target.getGearset())
         {
            gearObj = target.getGearset();
            for(key in gearObj)
            {
               targetGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = targetGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                        dmg = dmg + Math.round(Math.abs(dmg) * setEffect.amount * 0.01);
                  }
               }
            }
         }
         attackerBuff = this.attacker.getBattleBuff();
         attackerDebuff = this.attacker.getBattleDebuff();
         defenderBuff = target.getBattleBuff();
         defenderDebuff = target.getBattleDebuff();
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(int(attackerBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_DAMAGE_BONUS:
                     case BattleData.SKILL_369:
                     case BattleData.SKILL_501:
                     case BattleData.EFFECT_PUMPKIN_POWER:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case SenjutsuData.EFFECT_SS_DAMAGE_BONUS:
                        Out.debug(this,"EFFECT_SS_DAMAGE_BONUS dmg before >> " + dmg);
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        Out.debug(this,"EFFECT_SS_DAMAGE_BONUS dmg after >> " + dmg);
                        continue;
                     case BattleData.EFFECT_DAMAGE_BONUS_BY_SP:
                        Out.debug(this,"EFFECT_DAMAGE_BONUS_BY_SP dmg before >> " + dmg);
                        dmg = dmg - Math.round(Math.abs(this.attacker.maxSP) * (attackerBuff[key].amount / 100));
                        Out.debug(this,"EFFECT_DAMAGE_BONUS_BY_SP dmg after >> " + dmg);
                        continue;
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                        dmg = dmg - attackerBuff[key].amount;
                        continue;
                     case BattleData.EFFECT_GATE_OPENING:
                        dmg = dmg - Math.round(Math.abs(dmg) * 0.5);
                        continue;
                     case BattleData.EFFECT_FRENZY:
                        dmg = dmg - Math.round(Math.abs(dmg) * 0.2);
                        continue;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        dmg = dmg + dmg;
                        continue;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        dmg = dmg - Math.round(Math.abs(dmg) * 0.25);
                        continue;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_AMONG_ROCKS:
                        if(int(attackerBuff[key].duration) == 1)
                        {
                           dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        }
                        continue;
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_ATTACK_MODE:
                        dmg = dmg - Math.round(Math.abs(dmg) * 0.5);
                        continue;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        dmg = dmg + Math.round(Math.abs(dmg) * 0.5);
                        continue;
                     case BattleData.SKILL_310:
                        dmg = dmg - attackerBuff[key].amount;
                        continue;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        if(battleAction.critical)
                        {
                           dmg = dmg + Math.round(dmg * attackerBuff[key].amount / 100);
                        }
                        continue;
                     case BattleData.SKILL_2003:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case SenjutsuData.EFFECT_SS_CRITICAL_DMG_BONUS:
                        if(attacker.hp * 100 / attacker.maxHP < attackerBuff[key].amount && battleAction.critical)
                        {
                           Out.debug(this,"EFFECT_SS_CRITICAL_DMG_BONUS dmg before >> " + dmg);
                           dmg = Math.round(dmg * (1 + attackerBuff[key].chancetoeffect / 100));
                           Out.debug(this,"EFFECT_SS_CRITICAL_DMG_BONUS dmg after >> " + dmg);
                        }
                        continue;
                     case BloodlineData.EFFECT_DMG_BONUS_AND_DODGE_REDUCTION:
                        dmg = dmg - Math.round(Math.abs(dmg) * (attackerBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_CRITICAL_DMG_BONUS:
                        if(battleAction.critical)
                        {
                           dmg = dmg - Math.round(Math.abs(dmg) * attackerBuff[key].amount * 0.01);
                        }
                        continue;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        dmg = dmg - attackerBuff[key].amount;
                        continue;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        dmg = dmg - Math.round(Math.abs(dmg) * attackerBuff[key].amount * 0.01);
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
         for(key in attackerDebuff)
         {
            if(attackerDebuff[key])
            {
               if(int(attackerDebuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                        dmg = dmg + Math.round(Math.abs(dmg) * (attackerDebuff[key].amount / 100));
                     case BattleData.EFFECT_FEAR_WEAKEN:
                        if(int(attackerDebuff[key].amount) > 0)
                        {
                           dmg = dmg - int(Math.round(dmg * (int(attackerDebuff[key].amount) / 100)));
                        }
                        else
                        {
                           dmg = int(Math.round(dmg * 0.85));
                        }
                        continue;
                     case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                        dmg = dmg - int(Math.round(dmg * (int(attackerDebuff[key].amount) / 100)));
                        continue;
                     case BattleData.EFFECT_PET_FEAR_WEAKEN:
                        dmg = Math.round(dmg * ((100 - attackerDebuff[key].amount) / 100));
                        continue;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        dmg = dmg - dmg * (attackerDebuff[key].amount / 100);
                        continue;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                        amount = Math.round(this.attacker.maxCP * (8 / 100));
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + amount;
                        continue;
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        amount = Math.round(this.attacker.maxCP * (9 / 100));
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + amount;
                        continue;
                     case BattleData.EFFECT_DARK_CURSE:
                        dmg = Math.round(dmg * 0.9);
                        continue;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        if(battleAction.critical)
                        {
                           dmg = Math.round(dmg * 0.75);
                        }
                        continue;
                     case BattleData.EFFECT_THEFT_HP:
                        battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + Math.round(this.attacker.maxHP * (int(attackerDebuff[key].amount) / 100));
                        battleAction.attackerDamageHp = battleAction.attackerDamageHp + Math.round(this.attacker.maxHP * (int(attackerDebuff[key].amount) / 100));
                        continue;
                     case BattleData.EFFECT_HAMSTRING:
                        if(battleAction.critical)
                        {
                           dmg = Math.round(dmg / 1.5 * (1.5 - attackerDebuff[key].amount));
                        }
                        continue;
                     case BattleData.EFFECT_PET_WEAKEN:
                        dmg = Math.round(dmg * (1 - int(attackerDebuff[key].amount) / 100));
                        continue;
                     case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                        dmg = dmg + this.updateDamageByHitNum(battleAction,attackerDebuff[key].amount);
                        if(dmg > 0)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.SKILL_311:
                        amount = attackerDebuff[key].amount;
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + amount;
                        continue;
                     case BattleData.SKILL_342:
                        dmg = Math.round(dmg * (1 - int(attackerDebuff[key].amount) / 100));
                        continue;
                     case BattleData.SKILL_359:
                        dmg = dmg - dmg * (attackerDebuff[key].amount / 100);
                        continue;
                     case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                        dmg = dmg + Math.round(Math.abs(dmg) * (attackerDebuff[key].amount / 100));
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
         for(key in defenderBuff)
         {
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  effect = defenderBuff[key];
                  switch(key)
                  {
                     case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                        hpReduce = this.defender.maxHP * (defenderBuff[key].amount / 100);
                        cpReduce = this.defender.maxCP * (defenderBuff[key].amount / 100);
                        spReduce = this.defender.maxSP * (defenderBuff[key].amount / 100);
                        battleAction.attackerDamageHp = battleAction.attackerDamageHp + int(hpReduce);
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + int(cpReduce);
                        battleAction.attackerDamageSp = battleAction.attackerDamageSp + int(spReduce);
                        continue;
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                     case BattleData.EFFECT_PUMPKIN_POWER:
                        dmg = dmg + Math.round(Math.abs(dmg) * (defenderBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_FRENZY:
                        dmg = Math.round(dmg * 1.2);
                        continue;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        dmg = Math.round(dmg * 1.2);
                        continue;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        continue;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        dmg = dmg + Math.round(Math.abs(dmg) * (defenderBuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                        effect = {
                           "type":BattleData.EFFECT_PET_BURN,
                           "duration":2,
                           "amount":int(defenderBuff[key].amount)
                        };
                        battleAction.attackerDebuff.push(effect);
                        continue;
                     case BattleData.EFFECT_ATTACK_MODE:
                        dmg = dmg - Math.round(Math.abs(dmg) * 0.5);
                        continue;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        dmg = dmg + Math.round(Math.abs(dmg) * 0.5);
                        continue;
                     case BattleData.SKILL_307:
                        dmg = 0;
                        continue;
                     case BattleData.SKILL_285:
                        target.reduceSkillCooldown(defenderBuff[key].amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_WIND);
                        continue;
                     case BattleData.SKILL_251:
                        dmg = Math.round(dmg * (100 - defenderBuff[key].amount) / 100);
                        continue;
                     case BattleData.SKILL_335:
                        ReboundDmgRate = int(defenderBuff[key].amount) / 100;
                        ReboundDmg = Math.round(Math.abs(dmg) * ReboundDmgRate);
                        dmg = dmg + ReboundDmg;
                        battleAction.attackerDamageHp = battleAction.attackerDamageHp + Math.abs(ReboundDmg);
                        continue;
                     case BattleData.SKILL_268:
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + Math.round(this.attacker.cp * 0.1);
                        continue;
                     case BattleData.SKILL_268_2:
                        battleAction.attackerDamageCp = battleAction.attackerDamageCp + Math.round(this.attacker.cp * 0.15);
                        continue;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        amount = Math.round(Math.abs(dmg) * (int(defenderBuff[key].amount) / 100));
                        battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + amount;
                        continue;
                     case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                        dmg = 0;
                        continue;
                     case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
                        battleAction.attackerDamageHp = effect.amount;
                        tmpEffect = {
                           "type":BattleData.EFFECT_BLEEDING,
                           "amount":40,
                           "duration":2
                        };
                        this.attacker.setBattleDebuff(tmpEffect);
                        continue;
                     case BattleData.EFFECT_DEFENDER_BURNING:
                        tmpEffect = {
                           "type":BattleData.EFFECT_BURNING,
                           "amount":effect.amount,
                           "duration":2
                        };
                        this.attacker.setBattleDebuff(tmpEffect);
                        continue;
                     case BattleData.EFFECT_RECEIVED_DMG_STUN:
                        tmpEffect = {
                           "type":BattleData.EFFECT_STUN,
                           "duration":2
                        };
                        this.attacker.setBattleDebuff(tmpEffect);
                        continue;
                     case BattleData.EFFECT_RECEIVED_DMG_REDUCE_AGI:
                        tmpEffect = {
                           "type":BattleData.EFFECT_REDUCE_AGILITY,
                           "duration":2,
                           "amount":effect.amount
                        };
                        this.attacker.setBattleDebuff(tmpEffect);
                        continue;
                     case BattleData.EFFECT_SAND_GUARD:
                        battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + Math.abs(dmg) * effect.amount * 0.01;
                        continue;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        dmg = dmg + effect.amount;
                        if(dmg > 0)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        dmg = dmg + Math.round(Math.abs(dmg) * effect.amount * 0.01);
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
         for(key in defenderDebuff)
         {
            Out.debug(this,"processDamage :: defenderDebuff.key >> " + key);
            if(defenderDebuff[key])
            {
               if(defenderDebuff[key].duration > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_PET_BLEEDING:
                     case BattleData.EFFECT_ACCUM_BLEEDING:
                        dmg = dmg + int(Math.round(dmg * Number(int(defenderDebuff[key].amount) / 100)));
                        continue;
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                        Central.main.petExtraDmg = true;
                        Central.main.petExtraDmgAmount = int(defenderDebuff[key].amount);
                        dmg = dmg - this.updateDamageByHitNum(battleAction,int(defenderDebuff[key].amount));
                        continue;
                     case BattleData.EFFECT_PET_FREEZE:
                        dmg = dmg + Math.round(Math.abs(dmg) * 0.8);
                        continue;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + Math.round(int(defenderDebuff[key].amount) / 100 * dmg * -1);
                        continue;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + Math.round(int(defenderDebuff[key].amount) / 100 * dmg * -1);
                        continue;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        dmg = dmg - Math.round(Math.abs(dmg) * (defenderDebuff[key].amount / 100));
                        continue;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        this.checkAgility(target);
                        continue;
                     case BattleData.EFFECT_TRANSFORM:
                        battleAction.defenderDamageCp = Math.round(Math.abs(dmg) * (defenderDebuff[key].amount / 100));
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
         if(target.isBattleBuffActive(BattleData.EFFECT_GUARD))
         {
            guardChance = 0.5;
            rNum = NumberUtil.getRandom();
            if(rNum >= guardChance)
            {
               dmg = 0;
            }
         }
         if(target.isBattleBuffActive(BattleData.EFFECT_COMPLETE_GUARD))
         {
            dmg = 0;
         }
         if(target.isBattleBuffActive(BattleData.EFFECT_ALL_CP_GUARD_RESIST))
         {
            dmg = 0;
         }
         if(target.isBattleDebuffActive(BattleData.EFFECT_PETRIFICATION))
         {
            dmg = 0;
         }
         if(target.damageShield > 0)
         {
            Out.debug(this,"processDamage :: dmg before >> " + dmg);
            Out.debug(this,"processDamage :: target.damageShield before >> " + target.damageShield);
            if(target.damageShield > Math.abs(dmg))
            {
               target.damageShield = target.damageShield + dmg;
               dmg = 0;
            }
            else
            {
               dmg = dmg + target.damageShield;
               target.damageShield = 0;
            }
            Out.debug(this,"processDamage :: dmg after >> " + dmg);
            Out.debug(this,"processDamage :: target.damageShield after >> " + target.damageShield);
         }
         if(battleAction.rebound == true)
         {
            battleAction.reboundDamage = Math.round(int(battleAction.reboundDamage) / 100 * Math.abs(dmg));
            dmg = dmg + battleAction.reboundDamage;
            battleAction.reboundDamage = this.updateHP(this.attacker,0 - battleAction.reboundDamage);
         }
         key = BattleData.EFFECT_AMONG_ROCKS;
         if(target.isBattleBuffActive(key))
         {
            if(defenderBuff[key].duration == 2)
            {
               dmg = 0;
            }
         }
         key = BattleData.EFFECT_SERENE_MIND;
         if(target.isBattleBuffActive(key))
         {
            battleAction.attackerDamageHp = battleAction.attackerDamageHp + Math.abs(dmg);
            dmg = 0;
         }
         key = BattleData.EFFECT_SILVER_CHAIN_BUNDLE;
         if(this.attacker.isBattleDebuffActive(key))
         {
            if(int(attackerDebuff[key].amount) == 1)
            {
               dmg = 0;
            }
         }
         if(target.getWeapon())
         {
            targetWeapon = Central.main.WEAPON_DATA.find(target.getWeapon());
            if(targetWeapon)
            {
               for each(tmpEffect in targetWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                        if(target.hp / target.maxHP < tmpEffect.amount / 100 && NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_WEAPON_FULL_GUARD:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           dmg = 0;
                        }
                        continue;
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        amount = Math.round(Math.abs(dmg) * (tmpEffect.amount / 100));
                        battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + amount;
                        continue;
                     case BattleData.EFFECT_RECEIVED_DMG_RESTORE_HP:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           amount = Math.round(Math.abs(dmg) * (tmpEffect.amount / 100));
                           battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + amount;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(target.getBackItem())
         {
            targetBackItem = Central.main.BACK_ITEM_DATA.find(target.getBackItem());
            if(targetBackItem)
            {
               for each(tmpEffect in targetBackItem.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_CONVERT_FULLDMG_TO_HP:
                        if(NumberUtil.getRandom() <= tmpEffect.chance / 100)
                        {
                           battleAction.defenderRestoreHp = battleAction.defenderRestoreHp + Math.abs(dmg);
                           dmg = 0;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(target.getAccessory())
         {
            targetAccessory = Central.main.ACCESSORY_DATA.find(target.getAccessory());
            if(targetAccessory)
            {
               for each(tmpEffect in targetAccessory.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        amount = Math.round(Math.abs(dmg) * (tmpEffect.amount / 100));
                        battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + amount;
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         key = BattleData.EFFECT_ALL_CP_DRAIN_HP;
         if(target.isBattleBuffActive(key))
         {
            battleAction.defenderRestoreHp = Math.abs(dmg) * (int(defenderBuff[key].amount) / 100);
            dmg = 0;
         }
         key = BattleData.EFFECT_MANA_SHIELD;
         if(target.isBattleBuffActive(key))
         {
            cpRequired = Math.round(Math.abs(dmg) / int(defenderBuff[key].amount));
            if(target.cp >= cpRequired)
            {
               battleAction.defenderDamageCp = battleAction.defenderDamageCp + cpRequired;
               dmg = 0;
            }
            else
            {
               battleAction.defenderDamageCp = target.cp;
               dmg = dmg + Math.round((cpRequired - target.cp) * int(defenderBuff[key].amount));
            }
         }
         clanEffect = this.attacker.getClanEffect();
         if(clanEffect)
         {
            if(clanEffect[ClanData.CLAN_DAMAGE_BONUS])
            {
               dmg = dmg + Math.round(dmg * (int(clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount) / 100));
            }
         }
         if(Central.mission.curMissionID == "msn135")
         {
            if(this.attacker.side == BattleData.SIDE_FRIENDLY)
            {
               SufferDamageModifier = target.getSufferDamageModifier();
               dmg = Math.round(dmg * (SufferDamageModifier / 100));
            }
            else
            {
               DealDamageModifier = this.attacker.getDealDamageModifier();
               dmg = Math.round(dmg * (DealDamageModifier / 100));
            }
         }
         if(battleAction.action == BattleData.ACTION_CLASS_SKILL)
         {
            switch(battleAction.effect.type)
            {
               case BattleData.SKILL_2004:
                  levelBouns = Math.round(this.attacker.getLevel() - 60);
                  if(levelBouns < 0)
                  {
                     levelBouns = 0;
                  }
                  minusHP = Math.round(-((700 + levelBouns * 64) * (target.hp / target.maxHP)));
                  dmg = minusHP;
                  ignoreProtection = true;
            }
         }
         if(battleAction.action == BattleData.ACTION_SKILL)
         {
            if(battleAction.effect)
            {
               switch(battleAction.effect.type)
               {
                  case BattleData.SKILL_345:
                     dmg = dmg - Math.round(target.hp * (battleAction.effect.amount / 100));
                     ignoreProtection = true;
                     break;
                  case BattleData.SKILL_368:
                  case BattleData.SKILL_369:
                     dmg = dmg - Math.round(target.maxHP * (battleAction.effect.amount / 100));
                     ignoreProtection = true;
                     break;
                  case BattleData.EFFECT_CRITICAL_DMG_N_DODGE_REDUCTION:
                     if(battleAction.critical)
                     {
                        tmpInt = 0;
                        switch(battleAction.target)
                        {
                           case "allEnemy":
                              for(i = 0; i < this.characterArr.length; i++)
                              {
                                 if(this.characterArr[i].isDead == false && this.characterArr[i].side == this.defender.side)
                                 {
                                    currTmpInt = 0;
                                    for(buff in this.characterArr[i].getBattleBuff())
                                    {
                                       if(this.characterArr[i].getBattleBuff()[buff].druration < 999)
                                       {
                                          currTmpInt++;
                                       }
                                    }
                                    if(currTmpInt > tmpInt)
                                    {
                                       tmpInt = currTmpInt;
                                    }
                                 }
                              }
                        }
                        dmg = dmg * (1 + battleAction.effect.amount * tmpInt * 0.01);
                     }
               }
            }
         }
         for(key in defenderBuff)
         {
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_DAMAGE_DELAY:
                        diff = defenderBuff[key].intmem1 + defenderBuff[key].intmem2;
                        dmgPartAbsorbed = diff < -dmg?int(-diff):int(dmg);
                        dmgPartDmg = diff < -dmg?int(dmg + diff):0;
                        defenderBuff[key].intmem1 = defenderBuff[key].intmem1 + dmgPartAbsorbed;
                        dmg = dmgPartDmg;
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
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(int(attackerBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_BLOOD_FEED:
                        amount = Math.round(Math.abs(dmg) * (int(attackerBuff[key].amount) / 100));
                        battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + amount;
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
         for(key in defenderDebuff)
         {
            if(defenderDebuff[key])
            {
               if(int(defenderDebuff[key].duration) > 0)
               {
                  if(0)
                  {
                  }
                  break;
               }
            }
         }
         if(Central.battle.seal_enemy)
         {
            dmg = -this.defender.maxHP;
         }
         if(Central.mission.curMissionID == "msn0" && (battleAction.action == "weapon_attack" || battleAction.action == "attack"))
         {
            dmg = -this.defender.hp;
         }
         if(Math.abs(dmg) > 80000 && adminArr.indexOf(this.attacker.getCharacterId()) < 0 && this.attacker.getWeapon() != "wpn9999" && dmg > Central.battle.getDefender().maxHP && Central.battle.battleRoundCounter <= 4)
         {
            this.checkDmgHack(Math.abs(dmg),Central.battle.battleRoundCounter,Central.main.getPartyNpc().toString(),Central.battle.getDefender().enemyObj.id,Central.battle.getDefender().maxHP);
            dmg = Math.random() * 1000 + 300;
         }
         dmg = this.updateHP(target,dmg);
         if(battleAction.action == BattleData.ACTION_SKILL)
         {
            if(Central.battle.type == Central.battle.TYPE_NETWORK)
            {
               if(skillData.skill_hit_num != null)
               {
                  if(skillData.skill_hit_num > 0)
                  {
                     this.updateHP(target,Math.round(dmg * (skillData.skill_hit_num - 1)));
                  }
               }
            }
         }
         if(target.getBackItem())
         {
            targetBackItem = Central.main.BACK_ITEM_DATA.find(target.getBackItem());
            if(targetBackItem)
            {
               for each(tmpEffect in targetBackItem.effect)
               {
                  trace(Math.abs(dmg));
                  trace(tmpEffect.amount / 100);
                  switch(tmpEffect.type)
                  {
                     case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                        if(dmg < 0)
                        {
                           battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + Math.round(Math.abs(dmg) * (tmpEffect.amount / 100));
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(dmgObj.defenderRestoreHp > 0)
         {
            dmgObj.defenderRestoreHp = this.updateHP(target,dmgObj.defenderRestoreHp);
         }
         if(dmgObj.defenderRestoreCp > 0)
         {
            dmgObj.defenderRestoreCp = this.updateCP(target,dmgObj.defenderRestoreCp);
         }
         if(dmgObj.defenderDamageHp > 0)
         {
            dmgObj.defenderDamageHp = this.updateHP(target,0 - dmgObj.defenderDamageHp);
         }
         if(dmgObj.defenderDamageCp > 0)
         {
            dmgObj.defenderDamageCp = this.updateCP(target,0 - dmgObj.defenderDamageCp);
         }
         this.processDrainHp(battleAction,dmg);
         dmgObj.dmg = dmg;
         Central.battle.battleDamageLog = dmg;
         if(int(target.getData(DBCharacterData.RANK)) >= 8)
         {
            calcDmgRestoreSp(dmg,target);
         }
         battleAction.dmgArr.push(dmgObj);
         this.attacker.setBattleAction(battleAction);
      }
      
      public function calcDmgRestoreSp(dmg:int, target:*) : void
      {
         var RATE_MIN:Number = NaN;
         var RATE_MAX:Number = NaN;
         var randomRate:Number = NaN;
         RATE_MIN = 0.3;
         RATE_MAX = 0.4;
         randomRate = Math.random() < 0.5?Number(RATE_MIN):Number(RATE_MAX);
         target.updateSPstatus(SenjutsuData.SP_UPDATE_EXTRA,Math.abs(int(dmg * randomRate)));
         if(target.getData(DBCharacterData.ID) == Central.main.getMainChar().getData(DBCharacterData.ID))
         {
            Central.battle.updateSPButton();
            Central.battle.disableSPButton();
         }
      }
      
      public function calcSenjutsuRecoverSPBonus(currentVal:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object, status:String = "") : int
      {
         var finalRecoverSP:int = 0;
         var recoverSPBonus:int = 0;
         var tmpEffect:Object = null;
         var backEffect:Object = null;
         var i:int = 0;
         finalRecoverSP = currentVal;
         recoverSPBonus = 0;
         if(this.attackerBackItem)
         {
            for each(tmpEffect in this.attackerBackItem.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_BACKITEM_RECOVER_TURN_SP:
                     if(status == SenjutsuData.STATUS_ROUND_START)
                     {
                        recoverSPBonus = recoverSPBonus + int(this.attacker.maxSP * tmpEffect.amount * 0.01);
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         finalRecoverSP = finalRecoverSP + recoverSPBonus;
         return finalRecoverSP;
      }
      
      public function calcSenjutsuDamageBonus(currentDmg:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object) : int
      {
         var key:* = null;
         var finalDmg:int = 0;
         var wpnDmgBonus:int = 0;
         var tmpEffect:Object = null;
         var wpnEffect:Object = null;
         var i:int = 0;
         key = "";
         finalDmg = currentDmg;
         wpnDmgBonus = 0;
         if(this.attackerWeapon)
         {
            for each(tmpEffect in this.attackerWeapon.effect)
            {
               switch(tmpEffect.type)
               {
                  case BattleData.EFFECT_WEAPON_SENJUTSU_DMG_BONUS:
                     if(this.attacker.getBattleAction().action == "senjutsu")
                     {
                        wpnDmgBonus = wpnDmgBonus + int(currentDmg * tmpEffect.amount * 0.01);
                     }
                     continue;
                  default:
                     continue;
               }
            }
         }
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(int(attackerBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case SenjutsuData.EFFECT_SENNIN_MODE:
                        finalDmg = finalDmg + int(finalDmg * attackerBuff[key].amount * 0.01);
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
         finalDmg = finalDmg + wpnDmgBonus;
         return finalDmg;
      }
      
      public function calcSenjutsuDodgeBonus(currentDodge:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object) : int
      {
         var finalDodge:int = 0;
         finalDodge = currentDodge;
         return finalDodge;
      }
      
      public function calcSenjutsuRecoverHPBonus(currentValue:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object) : int
      {
         var finalValue:int = 0;
         finalValue = currentValue;
         return finalValue;
      }
      
      public function calcSenjutsuRecoverCPBonus(currentValue:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object) : int
      {
         var finalValue:int = 0;
         finalValue = currentValue;
         return finalValue;
      }
      
      public function calcSenjutsuAgiBonus(currentValue:int, attackerBuff:Object, attackerDebuff:Object, defenderBuff:Object, defenderDebuff:Object) : int
      {
         var finalValue:int = 0;
         finalValue = currentValue;
         return finalValue;
      }
      
      public function updateHP(char:*, value:int) : int
      {
         var buff:Object = null;
         var key:* = null;
         var battleAction:Object = null;
         var beforeCommand:Boolean = false;
         var excludeItem:Boolean = false;
         buff = char.getBattleBuff();
         battleAction = char.getBattleAction();
         beforeCommand = true;
         excludeItem = false;
         if(battleAction)
         {
            if(battleAction.action)
            {
               beforeCommand = false;
               if(battleAction.action != "item")
               {
                  excludeItem = true;
               }
            }
         }
         if((char.isBattleDebuffActive(BloodlineData.EFFECT_INTERNAL_INJURY) || char.isBattleDebuffActive(BattleData.EFFECT_INTERNAL_INJURY)) && (beforeCommand || excludeItem))
         {
            if(value > 0)
            {
               value = 0;
            }
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_DAMAGE_DELAY_INJURY) && value > 0)
         {
            value = 0;
         }
         if(char.isBattleDebuffActive(BattleData.SKILL_312))
         {
            if(value < 0)
            {
               value = 0;
            }
            else
            {
               value = value * Math.round(int(char.battleDebuff[BattleData.SKILL_312].amount) / 100);
            }
         }
         if(char.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
         {
            value = 0;
         }
         for(key in buff)
         {
            if(buff[key])
            {
               if(buff[key].duration > 0)
               {
                  switch(key)
                  {
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        if(value > 0)
                        {
                           value = Math.round(value * (100 + int(buff[key].amount)) / 100);
                        }
                        continue;
                     case BattleData.EFFECT_DAMAGE_DELAY:
                        if(value < 0 && buff[key].intmem1 + buff[key].intmem2 > 0)
                        {
                           value = 0;
                        }
                        continue;
                     case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                        if(value < 0 && Math.abs(value) >= char.hp)
                        {
                           if(Math.floor(char.hp / char.maxHP * 100) >= buff[key].amount)
                           {
                              value = -(char.hp - 1);
                           }
                        }
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
         if(value < 0)
         {
            char.removeDebuff(BattleData.EFFECT_SLEEP);
         }
         char.updateHP(value);
         return value;
      }
      
      private function updateCP(char:*, value:int) : int
      {
         var battleAction:Object = null;
         try
         {
            throw new Error();
         }
         catch(e:Error)
         {
            trace("BattleProcessor::updateCP, e=" + e.getStackTrace());
         }
         trace("~~~~~BattleProcessor::updateCP *0* -> value = " + value + ", charDebuff=" + GF.printObject(char.getBattleDebuff()));
         battleAction = char.getBattleAction();
         if(char.isBattleBuffActive(BattleData.EFFECT_CP_LOCK) && value < 0)
         {
            var value:int = 0;
         }
         trace("~~~~~BattleProcessor::updateCP *1* -> value = " + value + ", charDebuff=" + GF.printObject(char.getBattleDebuff()));
         trace("isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING)????????" + char.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING));
         if(char.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING) && value < 0)
         {
            value = value - Math.abs(value) * char.getBattleDebuff()[BattleData.EFFECT_CP_BLEEDING].amount * 0.01;
            trace("~~~~~BattleProcessor::updateCP *2* -> value = " + value);
         }
         if(char.isBattleDebuffActive(BattleData.EFFECT_CP_BLEEDING) && value > 0)
         {
            value = 0;
         }
         if(battleAction)
         {
            if(battleAction.clones)
            {
               if(battleAction.clones[char.getCharacterId()])
               {
                  value = 0;
               }
            }
         }
         char.updateCP(value);
         return value;
      }
      
      private function setDebuff(char:*, effect:Object) : Object
      {
         var i:uint = 0;
         var rNum:Number = NaN;
         var tmpEffect:Object = null;
         var setSuccess:Boolean = false;
         var charWeapon:Object = null;
         var amtHP:int = 0;
         var amtCP:int = 0;
         var charBackItem:Object = null;
         if(effect.resisted == null || effect.resisted == false)
         {
            effect.resisted = false;
            if(char.isStunResist() == true && effect.type == BattleData.EFFECT_STUN)
            {
               effect.resisted = true;
               return effect;
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
                     case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                        amtHP = Math.round(char.maxHP * (tmpEffect.amount / 100));
                        amtHP = this.updateHP(char,amtHP);
                        effect.restoreHp = amtHP;
                        continue;
                     case BattleData.EFFECT_DEBUFF_RESTORE_CP_PRESENT:
                        amtCP = Math.round(char.maxCP * (tmpEffect.amount / 100));
                        amtCP = this.updateCP(char,amtCP);
                        effect.restoreCp = amtCP;
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
                     case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                        effect.restoreHp = Math.round(char.maxHP * (tmpEffect.amount / 100));
                        effect.restoreHp = this.updateHP(char,effect.restoreHp);
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         setSuccess = true;
         setSuccess = char.setBattleDebuff(effect);
         if(setSuccess == false)
         {
            effect.resisted = true;
         }
         return effect;
      }
      
      private function setBuff(char:*, effect:Object) : Object
      {
         char.setBattleBuff(effect);
         return effect;
      }
      
      private function getPetMasterById(petId:uint) : *
      {
         var i:int = 0;
         i = 0;
         for(i = 0; i < this.characterArr.length; i++)
         {
            if(this.characterArr[i].pet != null)
            {
               if(this.characterArr[i].pet.getCharacterId() == petId)
               {
                  return this.characterArr[i];
               }
            }
         }
      }
      
      private function calcSkillDamage(char:*, skillData:Object) : uint
      {
         var typeValue:int = 0;
         var damage:int = 0;
         var buff:Object = null;
         var typeBonus1:Number = NaN;
         var typeBonus:Number = NaN;
         var typeBonus2:Number = NaN;
         var rand:Number = NaN;
         var typeBonus3:Number = NaN;
         var typeBonus4:Number = NaN;
         var typeBonus5:Number = NaN;
         var fireBonus:int = 0;
         var combustionBonus:int = 0;
         damage = skillData.damage;
         buff = char.getBattleBuff();
         switch(skillData.type)
         {
            case "fire":
               typeValue = char.getData(DBCharacterData.FIRE);
               break;
            case "wind":
               typeValue = char.getData(DBCharacterData.WIND);
               break;
            case "water":
               typeValue = char.getData(DBCharacterData.WATER);
               break;
            case "lightning":
               typeValue = char.getData(DBCharacterData.LIGHTNING);
               break;
            case "earth":
               typeValue = char.getData(DBCharacterData.EARTH);
               break;
            default:
               typeValue = 0;
         }
         typeBonus1 = 1 * 1 * damage * (typeValue / 100);
         typeBonus2 = damage * (typeValue * 0.01);
         rand = Math.random();
         typeBonus3 = damage * (typeValue * 0.01);
         var a:int = typeBonus;
         typeBonus4 = damage * (typeValue * 1 / 100);
         var b:Boolean = Boolean(typeBonus);
         typeBonus5 = damage * (typeValue / 100);
         if(rand <= 0.2)
         {
            typeBonus = 1 * (typeBonus1 == typeBonus2?typeBonus1:damage * (typeValue * 1 / 100));
         }
         else if(rand <= 0.4)
         {
            typeBonus = typeBonus2 == typeBonus3?Number(typeBonus2):Number(1 * damage * (typeValue / 100));
         }
         else if(rand <= 0.6)
         {
            typeBonus = typeBonus3 == typeBonus4?Number(typeBonus3):Number(damage * (typeValue / 100));
         }
         else if(rand <= 0.8)
         {
            typeBonus = typeBonus4 == typeBonus5?Number(typeBonus4):Number(1 * damage * (typeValue / 100));
         }
         else
         {
            typeBonus = typeBonus5 == typeBonus1?Number(typeBonus5):Number(1 * damage * (typeValue / 100));
         }
         fireBonus = Math.round(damage * (int(char.getData(DBCharacterData.FIRE)) * 4 / 1000));
         combustionBonus = 0;
         if(buff[BattleData.EFFECT_COMBUSTION])
         {
            if(buff[BattleData.EFFECT_COMBUSTION].duration > 0)
            {
               combustionBonus = Math.round(damage * 0.3);
            }
         }
         damage = damage + (Math.round(1 * damage * (typeValue * 0.01)) + fireBonus + combustionBonus);
         damage = Formula.randomizeValue(damage);
         return damage;
      }
      
      private function randomTarget() : void
      {
         var targetArr:Array = null;
         var i:int = 0;
         targetArr = [];
         for(i = 0; i < this.characterArr.length; i++)
         {
            if(this.characterArr[i].side != this.attacker.side && this.characterArr[i].hp > 0)
            {
               targetArr.push(this.characterArr[i]);
            }
         }
         this.defender = targetArr[NumberUtil.randomInt(0,targetArr.length - 1)];
      }
      
      private function checkResurrection() : void
      {
         var battleAction:Object = null;
         var i:int = 0;
         var resurrectionObj:Object = null;
         var recHP:int = 0;
         var recCP:int = 0;
         var type:String = null;
         battleAction = this.attacker.getBattleAction();
         battleAction.resurrectionObj = {};
         recHP = 0;
         recCP = 0;
         type = "";
         for(i = 0; i < this.characterArr.length; i++)
         {
            if(this.characterArr[i].hp <= 0)
            {
               resurrectionObj = this.characterArr[i].checkBloodlineresurrection();
               recHP = resurrectionObj.HPRec;
               recCP = resurrectionObj.CPRec;
               type = resurrectionObj.type;
               if(recHP > 0)
               {
                  this.characterArr[i].updateHP(recHP);
                  this.characterArr[i].updateCP(recCP);
                  this.characterArr[i].setActiveBuff({});
                  this.characterArr[i].setActiveDebuff({});
                  recCP = characterArr[i].getData(DBCharacterData.CP);
                  battleAction.resurrectionObj[this.characterArr[i].getCharacterId()] = {
                     "hp":recHP,
                     "cp":recCP,
                     "type":type
                  };
               }
            }
         }
         this.attacker.setBattleAction(battleAction);
      }
      
      public function reactiveBufforDebuffTarget(battleAction:Object) : Object
      {
         var attackerBuff:Object = null;
         var defenderBuff:Object = null;
         var key:* = null;
         var BLkey:String = null;
         var BLSkillID:String = null;
         var BLkeyArr:Array = null;
         var rNum:Number = NaN;
         var BLSkillRequirementArr:Array = null;
         var BLSkillRequirement:String = null;
         var tmpstring:String = null;
         var tmparr:Array = null;
         var skillData:Object = null;
         var EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR:Array = null;
         var EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR:Array = null;
         var SkillEffectSkipArr:Array = null;
         var tmpobject:Object = null;
         var i:int = 0;
         var Effect:Object = null;
         var effectbonus:Number = NaN;
         var haveDmg:Boolean = false;
         var dmgArr:Array = null;
         var effect:Object = null;
         var HP_Amount:int = 0;
         var CP_Amount:int = 0;
         attackerBuff = attacker.getBattleBuff();
         var attackerDebuff:Object = attacker.getBattleDebuff();
         defenderBuff = defender.getBattleBuff();
         var defenderDebuff:Object = defender.getBattleDebuff();
         BLkey = "";
         BLSkillID = "";
         BLkeyArr = [];
         BLSkillRequirementArr = [];
         BLSkillRequirement = "";
         tmpstring = "";
         tmparr = [];
         var skillList:Array = null;
         skillData = {};
         var BloodlineDamageBonus:int = 0;
         var BloodlineDamageConvert:int = 0;
         EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR = [];
         EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR = [];
         SkillEffectSkipArr = [BattleData.EFFECT_HEAL];
         tmpobject = {};
         for(key in attackerBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
            Effect = {};
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(BLkey && attackerBuff[key].chancetoeffect && attackerBuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     effectbonus = 0;
                     if(String(BLSkillID).indexOf("skill1034") >= 0)
                     {
                        effectbonus = this.GetShadowCaptureBonus();
                     }
                     if(rNum <= (attackerBuff[key].chancetoeffect + effectbonus) / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                              BLSkillRequirement = attackerBuff[key].requirement;
                              BLSkillRequirementArr = BLSkillRequirement.split("|");
                              Effect = null;
                              Effect = {};
                              Effect.type = BLSkillRequirementArr[0];
                              Effect.duration = int(BLSkillRequirementArr[1]) + 0;
                              Effect.target = int(BLSkillRequirementArr[2]) + 0;
                              Effect.amount = int(BLSkillRequirementArr[3]) + 0;
                              Effect.chancetohit = int(BLSkillRequirementArr[4]) + 0;
                              Effect.chancetoeffect = int(BLSkillRequirementArr[5]) + 0;
                              Effect.requirement = BLSkillRequirementArr[6];
                              tmpstring = "";
                              if(BLSkillRequirementArr[7])
                              {
                                 tmpstring = BLSkillRequirementArr[7];
                              }
                              if(tmpstring.length > 2)
                              {
                                 tmparr = tmpstring.split(",");
                                 skillData = Central.main.SKILL_DATA[battleAction.skillId];
                                 if(skillData && skillData.type && battleAction.action == BattleData.ACTION_SKILL)
                                 {
                                    if(tmparr.indexOf(skillData.type) >= 0)
                                    {
                                       if(skillData.damage > 0)
                                       {
                                          if(SkillEffectSkipArr.indexOf(skillData.effect.type) < 0)
                                          {
                                             tmpobject = {};
                                             tmpobject = {
                                                "Effect":Effect,
                                                "BLSkillID":BLSkillID,
                                                "charId":defender.getCharacterId()
                                             };
                                             EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR.push(tmpobject);
                                             this.defender.setBattleDebuff(Effect);
                                          }
                                       }
                                       else if(this.defender == this.attacker && Effect.target == BloodlineData.TARGET_SELF)
                                       {
                                          tmpobject = {};
                                          tmpobject = {
                                             "Effect":Effect,
                                             "BLSkillID":BLSkillID,
                                             "charId":defender.getCharacterId()
                                          };
                                          EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR.push(tmpobject);
                                          this.defender.setBattleDebuff(Effect);
                                       }
                                    }
                                 }
                              }
                              else if(battleAction.action == BattleData.ACTION_SKILL || battleAction.action == "weapon_attack" || battleAction.action == "bloodline" || battleAction.action == "attack")
                              {
                                 haveDmg = false;
                                 dmgArr = battleAction.dmgArr;
                                 if(dmgArr)
                                 {
                                    for(i = 0; i < dmgArr.length; i++)
                                    {
                                       if(dmgArr[i].dmg)
                                       {
                                          if(dmgArr[i].dmg != 0)
                                          {
                                             haveDmg = true;
                                          }
                                       }
                                    }
                                 }
                                 if(haveDmg == true)
                                 {
                                    tmpobject = {};
                                    tmpobject = {
                                       "Effect":Effect,
                                       "BLSkillID":BLSkillID,
                                       "charId":defender.getCharacterId()
                                    };
                                    EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR.push(tmpobject);
                                    this.defender.setBattleDebuff(Effect);
                                 }
                              }
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
         for(key in defenderBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
            if(defenderBuff[key])
            {
               if(defenderBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                     BLSkillID = BLkeyArr[1];
                  }
                  if(BLkey && defenderBuff[key].chancetoeffect && defenderBuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= defenderBuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                              BLSkillRequirement = defenderBuff[key].requirement;
                              BLSkillRequirementArr = BLSkillRequirement.split("|");
                              Effect = null;
                              Effect = {};
                              Effect.type = BLSkillRequirementArr[0];
                              Effect.duration = int(BLSkillRequirementArr[1]) + 0;
                              Effect.target = int(BLSkillRequirementArr[2]) + 0;
                              Effect.amount = int(BLSkillRequirementArr[3]) + 0;
                              Effect.chancetohit = int(BLSkillRequirementArr[4]) + 0;
                              Effect.chancetoeffect = int(BLSkillRequirementArr[5]) + 0;
                              Effect.requirement = BLSkillRequirementArr[6];
                              tmpstring = "";
                              if(BLSkillRequirementArr[7])
                              {
                                 tmpstring = BLSkillRequirementArr[7];
                              }
                              if(tmpstring.length > 2)
                              {
                                 tmparr = tmpstring.split(",");
                                 skillData = Central.main.SKILL_DATA[battleAction.skillId];
                                 if(skillData && skillData.type && battleAction.action == BattleData.ACTION_SKILL)
                                 {
                                    if(tmparr.indexOf(skillData.type) >= 0 && skillData.damage > 0)
                                    {
                                       tmpobject = {};
                                       tmpobject = {
                                          "Effect":Effect,
                                          "BLSkillID":BLSkillID,
                                          "charId":defender.getCharacterId()
                                       };
                                       EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR.push(tmpobject);
                                       this.attacker.setBattleDebuff(Effect);
                                    }
                                 }
                              }
                              else if(battleAction.action == BattleData.ACTION_SKILL || battleAction.action == "weapon_attack" || battleAction.action == "bloodline" || battleAction.action == "attack")
                              {
                                 tmpobject = {};
                                 tmpobject = {
                                    "Effect":Effect,
                                    "BLSkillID":BLSkillID,
                                    "charId":defender.getCharacterId()
                                 };
                                 EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR.push(tmpobject);
                                 this.attacker.setBattleDebuff(Effect);
                              }
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
         battleAction.EFFECT_REACTIVE_DEBUFF_DEFENDER = EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR;
         battleAction.EFFECT_REACTIVE_DEBUFF_ATTACKER = EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR;
         for(i = 0; i < EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR.length; i++)
         {
            if(EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR[i].Effect.type == BloodlineData.EFFECT_UPDATE_HP_CP)
            {
               effect = EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR[i].Effect;
               HP_Amount = 0;
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  HP_Amount = Math.round(attacker.maxHP * (effect.amount / 100));
                  HP_Amount = applySkill268HpEffect(HP_Amount);
                  if(HP_Amount > 0)
                  {
                     battleAction.attackerRestoreHp = HP_Amount;
                  }
                  else if(HP_Amount < 0)
                  {
                     battleAction.attackerDamageHp = Math.abs(HP_Amount);
                  }
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  HP_Amount = Math.round(defender.maxHP * (effect.amount / 100));
                  HP_Amount = applySkill268HpEffect(HP_Amount);
                  if(HP_Amount > 0)
                  {
                     battleAction.defenderRestoreHp = HP_Amount;
                  }
                  else if(HP_Amount < 0)
                  {
                     battleAction.defenderDamageHp = Math.abs(HP_Amount);
                  }
               }
               CP_Amount = 0;
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  CP_Amount = Math.round(attacker.maxCP * (effect.amount / 100));
                  if(CP_Amount > 0)
                  {
                     battleAction.attackerRestoreCp = CP_Amount;
                  }
                  else if(CP_Amount < 0)
                  {
                     battleAction.attacterDamageCp = Math.abs(CP_Amount);
                  }
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  CP_Amount = Math.round(defender.maxCP * (effect.amount / 100));
                  defender.updateCP(CP_Amount,true,this.attacker);
                  if(CP_Amount > 0)
                  {
                     battleAction.defenderRestoreCp = CP_Amount;
                  }
                  else if(CP_Amount < 0)
                  {
                     battleAction.defenderDamageCp = Math.abs(CP_Amount);
                  }
               }
            }
         }
         return battleAction;
      }
      
      public function applySkill268HpEffect(HP_Amount:int) : int
      {
         var attackerBuff:Object = null;
         var key:* = null;
         attackerBuff = attacker.getBattleBuff();
         for(key in attackerBuff)
         {
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  switch(key)
                  {
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        HP_Amount = HP_Amount * (100 + attackerBuff[key].amount) / 100;
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
         return HP_Amount;
      }
      
      private function GetShadowCaptureBonus() : Number
      {
         var bloodline:Array = null;
         var bonus:Number = NaN;
         var i:int = 0;
         var skill_id:int = 0;
         var skill_lv:int = 0;
         bloodline = this.attacker.getData(DBCharacterData.BLOODLINE_SKILL);
         bonus = 0;
         for(i = 0; i < bloodline.length; i++)
         {
            skill_id = bloodline[i].skill_id;
            skill_lv = bloodline[i].level;
            if(String(skill_id) == "1011")
            {
               switch(String(skill_lv))
               {
                  case "1":
                     bonus = bonus + 1;
                     break;
                  case "2":
                     bonus = bonus + 1.5;
                     break;
                  case "3":
                     bonus = bonus + 2;
                     break;
                  case "4":
                     bonus = bonus + 3;
                     break;
                  case "5":
                     bonus = bonus + 4;
                     break;
                  case "6":
                     bonus = bonus + 5;
                     break;
                  case "7":
                     bonus = bonus + 6;
                     break;
                  case "8":
                     bonus = bonus + 7;
                     break;
                  case "9":
                     bonus = bonus + 8.5;
                     break;
                  case "10":
                     bonus = bonus + 10;
               }
            }
            if(String(skill_id) == "1012")
            {
               switch(String(skill_lv))
               {
                  case "1":
                     bonus = bonus + 1;
                     break;
                  case "2":
                     bonus = bonus + 2;
                     break;
                  case "3":
                     bonus = bonus + 2;
                     break;
                  case "4":
                     bonus = bonus + 3;
                     break;
                  case "5":
                     bonus = bonus + 4.2;
                     break;
                  case "6":
                     bonus = bonus + 5.6;
                     break;
                  case "7":
                     bonus = bonus + 6;
                     break;
                  case "8":
                     bonus = bonus + 7;
                     break;
                  case "9":
                     bonus = bonus + 8.5;
                     break;
                  case "10":
                     bonus = bonus + 10;
               }
            }
         }
         return bonus;
      }
      
      public function processDrainHp(battleAction:Object, dmg:int) : void
      {
         var bloodlineEffectArr:Array = null;
         var HP_Amount:int = 0;
         var i:int = 0;
         var effect:Object = null;
         var effect_type:String = null;
         var Drain_Amount:int = 0;
         var defenderBuff:Object = null;
         bloodlineEffectArr = getBloodlineEffectArr(battleAction.effect);
         HP_Amount = 0;
         for(i = 0; i < bloodlineEffectArr.length; i++)
         {
            effect = bloodlineEffectArr[i];
            effect_type = bloodlineEffectArr[i].type;
            switch(effect_type)
            {
               case BloodlineData.EFFECT_DRAIN_HP:
                  Drain_Amount = 0;
                  if(effect.target == BloodlineData.TARGET_SELF)
                  {
                     Drain_Amount = Math.round(Math.abs(dmg) * (effect.amount / 100));
                     Drain_Amount = applySkill268HpEffect(Drain_Amount);
                     if(Drain_Amount > 0)
                     {
                        battleAction.attackerRestoreHp = Drain_Amount;
                     }
                     else if(HP_Amount < 0)
                     {
                        battleAction.attackerDamageHp = Math.abs(Drain_Amount);
                     }
                  }
                  else if(effect.target == BloodlineData.TARGET_ENEMY)
                  {
                     Drain_Amount = Math.round(Math.abs(dmg) * (effect.amount / 100));
                     defenderBuff = this.defender.getBattleBuff();
                     Drain_Amount = applySkill268HpEffect(Drain_Amount);
                     if(Drain_Amount > 0)
                     {
                        battleAction.defenderRestoreHp = Drain_Amount;
                     }
                     else if(HP_Amount < 0)
                     {
                        battleAction.defenderDamageHp = Math.abs(Drain_Amount);
                     }
                  }
            }
         }
      }
      
      public function SetBloodlineInstantEffect(effect:Object, bloodlineskillID:String, battleAction:Object = null) : void
      {
         var arr_AttackerSkill:Array = null;
         var Cooldown_Amount:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = null;
         var cooldown_tmpVal:int = 0;
         var tmpCP:int = 0;
         var CP_Amount:int = 0;
         var HP_Amount:int = 0;
         var i:int = 0;
         var attackerBuff:Object = null;
         var key:String = null;
         var arr_DefenderSkill:Array = null;
         var amount:int = 0;
         var healObj:Object = null;
         arr_AttackerSkill = null;
         Cooldown_Amount = 0;
         cooldown_skillkey = 0;
         cooldown_skillID = "";
         cooldown_tmpVal = 0;
         var defenderBuff:Object = null;
         tmpCP = 0;
         var enemyArr:Array = Central.battle.enemyArr;
         var partyArr:Array = Central.battle.partyArr;
         switch(effect.type)
         {
            case BloodlineData.EFFECT_CLEAR_BUFF:
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  this.attacker.clearBuff();
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  this.defender.clearBuff();
               }
               break;
            case BloodlineData.EFFECT_UPDATE_CP:
               CP_Amount = 0;
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  CP_Amount = Math.round(this.attacker.maxCP * (effect.amount / 100));
                  if(CP_Amount > 0)
                  {
                     battleAction.attackerRestoreCp = CP_Amount;
                  }
                  else if(CP_Amount < 0)
                  {
                     battleAction.attackerDamageCp = Math.abs(CP_Amount);
                  }
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  CP_Amount = Math.round(this.defender.maxCP * (effect.amount / 100));
                  if(CP_Amount > 0)
                  {
                     battleAction.defenderRestoreCp = battleAction.defenderRestoreCp + CP_Amount;
                  }
                  else if(CP_Amount < 0)
                  {
                     battleAction.defenderDamageCp = battleAction.defenderDamageCp + Math.abs(CP_Amount);
                  }
               }
               break;
            case BloodlineData.EFFECT_UPDATE_HP:
               HP_Amount = 0;
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  HP_Amount = Math.round(this.attacker.maxHP * (effect.amount / 100));
                  attackerBuff = this.attacker.getBattleBuff();
                  HP_Amount = applySkill268HpEffect(HP_Amount);
                  this.attacker.updateHP(HP_Amount);
                  if(HP_Amount > 0)
                  {
                     battleAction.attackerRestoreHp = HP_Amount;
                  }
                  else if(HP_Amount < 0)
                  {
                     battleAction.attackerDamageHp = Math.abs(HP_Amount);
                  }
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  HP_Amount = Math.round(defender.maxHP * (effect.amount / 100));
                  defenderBuff = this.defender.getBattleBuff();
                  HP_Amount = applySkill268HpEffect(HP_Amount);
                  if(HP_Amount > 0)
                  {
                     battleAction.defenderRestoreHp = HP_Amount;
                  }
                  else if(HP_Amount < 0)
                  {
                     battleAction.defenderDamageHp = Math.abs(HP_Amount);
                  }
               }
               break;
            case BloodlineData.EFFECT_MODIFY_COOLDOWN:
               if(effect.target == BloodlineData.TARGET_SELF)
               {
                  Cooldown_Amount = effect.amount;
                  arr_AttackerSkill = this.attacker.getData(DBCharacterData.SKILLS);
                  cooldown_skillkey = battleAction.AttackerRandomSkillSlot;
                  if(cooldown_skillkey != 999)
                  {
                     cooldown_skillID = arr_AttackerSkill[cooldown_skillkey];
                     cooldown_tmpVal = this.attacker.getBattleSkillCooldown(cooldown_skillID);
                     cooldown_tmpVal = cooldown_tmpVal + Cooldown_Amount;
                     if(cooldown_tmpVal <= 0)
                     {
                        cooldown_tmpVal = 0;
                     }
                     this.attacker.battleSkillCooldown[cooldown_skillID] = cooldown_tmpVal;
                  }
               }
               else if(effect.target == BloodlineData.TARGET_ENEMY)
               {
                  Cooldown_Amount = effect.amount;
                  arr_DefenderSkill = this.defender.getData(DBCharacterData.SKILLS);
                  cooldown_skillkey = battleAction.DefenderRandomSkillSlot;
                  if(cooldown_skillkey != 999)
                  {
                     cooldown_skillID = arr_DefenderSkill[cooldown_skillkey];
                     cooldown_tmpVal = this.defender.getBattleSkillCooldown(cooldown_skillID);
                     cooldown_tmpVal = cooldown_tmpVal + Cooldown_Amount;
                     if(cooldown_tmpVal <= 0)
                     {
                        cooldown_tmpVal = 0;
                     }
                     this.defender.battleSkillCooldown[cooldown_skillID] = cooldown_tmpVal;
                  }
               }
               break;
            case BloodlineData.EFFECT_CLEAR_ALL_TARGET_BUFF:
               switch(int(effect.target))
               {
                  case BloodlineData.TARGET_ENEMY:
                     break;
                  case BloodlineData.TARGET_ENEMY_ALL:
                     battleAction.target = "allEnemy";
               }
               break;
            case BloodlineData.EFFECT_RESTORE_ALL_PARTY:
               battleAction.healTarget = [];
               for(i = 0; i < this.characterArr.length; i++)
               {
                  if(this.characterArr[i].side == this.attacker.side)
                  {
                     amount = this.updateHP(this.characterArr[i],effect.amount);
                     healObj = {
                        "target":this.characterArr[i],
                        "heal":amount
                     };
                     battleAction.healTarget.push(healObj);
                  }
               }
               break;
            case BloodlineData.EFFECT_DMG_HP_CP:
               tmpCP = Math.round(this.defender.maxCP * int(effect.amount) * 0.01);
               if(tmpCP > this.defender.cp)
               {
                  battleAction.defenderDamageCp = battleAction.defenderDamageCp + this.defender.cp;
                  battleAction.defenderDamageHp = battleAction.defenderDamageHp + (tmpCP - this.defender.cp);
               }
               else
               {
                  battleAction.defenderDamageCp = battleAction.defenderDamageCp + tmpCP;
               }
               battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + tmpCP;
               break;
            case BloodlineData.EFFECT_DMG_CP_AND_STUN:
               tmpCP = Math.round(this.defender.maxCP * int(effect.amount) * 0.01);
               if(tmpCP > this.defender.cp)
               {
                  tmpCP = this.defender.cp;
                  this.defender.setBattleDebuff({
                     "type":BattleData.EFFECT_STUN,
                     "duration":effect.chancetoeffect
                  });
               }
               battleAction.defenderDamageCp = battleAction.defenderDamageCp + tmpCP;
               battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + tmpCP;
               break;
            case BloodlineData.EFFECT_UPDATE_CP_N_CP_RESTORE_LOCK:
               tmpCP = Math.round(this.defender.maxCP * Math.abs(int(effect.amount)) * 0.01);
               if(tmpCP > this.defender.cp)
               {
                  tmpCP = this.defender.cp;
                  this.defender.setBattleDebuff({
                     "type":BattleData.EFFECT_CP_RESTORE_LOCK,
                     "duration":effect.chancetoeffect
                  });
               }
               battleAction.defenderDamageCp = battleAction.defenderDamageCp + tmpCP;
         }
      }
      
      public function SetSenjutsuInstantEffect(effect:Object, senjutsuskillID:String, battleAction:Object = null) : void
      {
         var enemyArr:Array = null;
         var partyArr:Array = null;
         var cp_amount:int = 0;
         var hp_amount:int = 0;
         var sp_amount:int = 0;
         var sp_all:int = 0;
         var senninBonus:int = 0;
         var hpAmount:int = 0;
         var targetArr:Array = null;
         var k:int = 0;
         var arr_DefenderSkill:Array = null;
         var skillSlot:int = 0;
         var arr_AttackerSkill:Array = null;
         var Cooldown_Amount:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = "";
         var cooldown_tmpVal:int = 0;
         var defenderBuff:Object = null;
         enemyArr = Central.battle.enemyArr;
         partyArr = Central.battle.partyArr;
         cp_amount = 0;
         hp_amount = 0;
         sp_amount = 0;
         sp_all = 0;
         switch(effect.type)
         {
            case BattleData.EFFECT_SENJUTSU_RECOVER_HP_CP:
               senninBonus = 0;
               if(this.attacker.isBattleBuffActive(SenjutsuData.EFFECT_SENNIN_MODE))
               {
                  senninBonus = 15;
               }
               hp_amount = hp_amount + int(this.attacker.maxHP * (effect.amount + senninBonus) * 0.01);
               cp_amount = cp_amount + int(this.attacker.maxCP * (effect.amount + senninBonus) * 0.01);
               battleAction.attackerRestoreHp = battleAction.attackerRestoreHp + hp_amount;
               battleAction.attackerRestoreCp = battleAction.attackerRestoreCp + cp_amount;
               break;
            case SenjutsuData.EFFECT_SS_BURN_CP_HP:
               if(this.defender.isBattleDebuffActive(SenjutsuData.EFFECT_SS_AGILITY_CHANGE))
               {
                  hp_amount = int(this.defender.maxHP * effect.amount * 0.01 * 2);
                  cp_amount = int(this.defender.maxCP * effect.amount * 0.01 * 2);
               }
               else
               {
                  hp_amount = int(this.defender.maxHP * effect.amount * 0.01);
                  cp_amount = int(this.defender.maxCP * effect.amount * 0.01);
               }
               battleAction.defenderDamageHp = hp_amount;
               battleAction.defenderDamageCp = cp_amount;
               break;
            case BattleData.EFFECT_LOSS_HP_DMG_BONUS:
               battleAction.dmg = battleAction.dmg + int(this.defender.maxHP - this.defender.hp) * effect.amount * 0.01;
               break;
            case BattleData.EFFECT_DAMAGE_SHIELD:
               this.attacker.damageShield = effect.amount;
               break;
            case BattleData.EFFECT_DRAIN_MAX_SP:
               switch(int(effect.target))
               {
                  case SenjutsuData.TARGET_ENEMY:
                     sp_amount = int(this.defender.maxSP * effect.amount * 0.01);
                     this.defender.DamageSp = -sp_amount;
                     sp_all = sp_all + sp_amount;
                     break;
                  case SenjutsuData.TARGET_ENEMY_ALL:
                     targetArr = [defender];
                     k = 0;
                     if(attacker.side == BattleData.SIDE_FRIENDLY)
                     {
                        targetArr = enemyArr;
                     }
                     else
                     {
                        targetArr = [];
                        targetArr.push(Central.main.getMainChar());
                        if(partyArr)
                        {
                           targetArr = targetArr.concat(partyArr);
                        }
                     }
                     for(k = 0; k < targetArr.length; k++)
                     {
                        sp_amount = int(targetArr[k].maxSP * effect.amount * 0.01);
                        targetArr[k].DamageSp = -sp_amount;
                        sp_all = sp_all + sp_amount;
                        targetArr[k].updateSP(-sp_amount);
                     }
                     battleAction.target = "allEnemy";
               }
               this.attacker.RestoreSp = sp_all / 2;
               this.attacker.updateSP(sp_all / 2);
               break;
            case SenjutsuData.EFFECT_SS_JUSTU_STEAL:
               if(this.defender.type == this.defender.TYPE_CHARACTER || this.defender.type == this.defender.TYPE_AICHARACTER || this.defender.type == this.defender.TYPE_PVPCHARACTER)
               {
                  arr_DefenderSkill = this.defender.getData(DBCharacterData.SKILLS);
                  skillSlot = Math.floor(NumberUtil.randomInt(0,arr_DefenderSkill.length - 1));
                  battleAction.stealSkillId = arr_DefenderSkill[skillSlot];
                  this.defender.battleSkillCooldown[battleAction.stealSkillId] = effect.amount;
               }
               break;
            case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
               break;
            case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
               hpAmount = int(this.defender.maxHP * effect.chancetoeffect / 100);
               defender.DamageHp = -hpAmount;
               attacker.RestoreSp = hpAmount / 2;
               attacker.updateSP(hpAmount / 2);
         }
      }
      
      public function SetBloodlineBuffOrDebuffEffect(effect:Object, bloodlineskillID:String) : void
      {
         var enemyArr:Array = null;
         var partyArr:Array = null;
         var not_stack_array:Array = null;
         var defenderDebuff:Object = null;
         var key:* = null;
         var BLkey:String = null;
         var BLkeyArr:Array = null;
         var targetArr:Array = null;
         var k:int = 0;
         enemyArr = Central.battle.enemyArr;
         partyArr = Central.battle.partyArr;
         not_stack_array = [];
         not_stack_array = BloodlineData.NOT_STACK_ARRAY;
         if(not_stack_array.indexOf(effect.type) < 0)
         {
            if(effect.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER || effect.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER)
            {
               effect.type = effect.type + "." + bloodlineskillID + effect.requirement;
            }
            else
            {
               effect.type = effect.type + "." + bloodlineskillID;
            }
         }
         if(bloodlineskillID == "skill1011")
         {
            defenderDebuff = this.defender.getBattleDebuff();
            BLkey = "";
            BLkeyArr = [];
            for(key in defenderDebuff)
            {
               BLkeyArr = [];
               BLkey = "";
               if(defenderDebuff[key])
               {
                  if(defenderDebuff[key].duration > 0)
                  {
                     BLkeyArr = key.split(".");
                     if(BLkeyArr)
                     {
                        BLkey = BLkeyArr[0];
                     }
                     if(BLkey)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_CAPTURE:
                              effect.amount = effect.amount * 3;
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
         }
         var i:int = 0;
         switch(int(effect.target))
         {
            case BloodlineData.TARGET_SELF:
               this.attacker.setBattleBuff(effect);
               break;
            case BloodlineData.TARGET_ENEMY:
               this.defender.setBattleDebuff(effect);
               break;
            case BloodlineData.TARGET_ARRACKER_DEBUFF:
               this.attacker.setBattleDebuff(effect);
               break;
            case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
               if(effect.type != BloodlineData.EFFECT_MAX_HP && effect.type != BloodlineData.EFFECT_MAX_CP && effect.type != BloodlineData.EFFECT_SPEED)
               {
                  Central.main.getMainChar().setBattleBuff(effect);
               }
               break;
            case BloodlineData.TARGET_SELF_AND_ENEMY_DEBUFF:
               this.defender.setBattleDebuff(effect);
               this.attacker.setBattleDebuff(effect);
               break;
            case BloodlineData.TARGET_ENEMY_ALL:
               targetArr = [defender];
               k = 0;
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  targetArr = enemyArr;
               }
               else
               {
                  targetArr = [];
                  targetArr.push(Central.main.getMainChar());
                  if(partyArr)
                  {
                     targetArr = targetArr.concat(partyArr);
                  }
               }
               for(k = 0; k < targetArr.length; k++)
               {
                  targetArr[k].setBattleDebuff(effect);
               }
         }
         if(String(effect.type).split(".")[0] == BloodlineData.EFFECT_MAX_CP_RECOVER)
         {
            this.updateCP(this.defender,0);
         }
      }
      
      public function SetSenjutsuBuffOrDebuffEffect(effect:Object, senjutsuskillID:String) : void
      {
         var enemyArr:Array = null;
         var partyArr:Array = null;
         var targetArr:Array = null;
         var k:int = 0;
         enemyArr = Central.battle.enemyArr;
         partyArr = Central.battle.partyArr;
         var not_stack_array:Array = [];
         not_stack_array = SenjutsuData.NOT_STACK_ARRAY;
         if(senjutsuskillID == "skill3103")
         {
            if(effect.type == SenjutsuData.EFFECT_SS_MAX_CP_CHANGE && this.defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
            {
               return;
            }
            if(effect.type == SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA && !this.defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
            {
               return;
            }
         }
         var i:int = 0;
         switch(int(effect.target))
         {
            case SenjutsuData.TARGET_SELF:
               this.attacker.setBattleBuff(effect);
               break;
            case SenjutsuData.TARGET_ENEMY:
               this.defender.setBattleDebuff(effect);
               break;
            case SenjutsuData.TARGET_ARRACKER_DEBUFF:
               this.attacker.setBattleDebuff(effect);
               break;
            case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
               if(effect.type != SenjutsuData.EFFECT_SS_MAX_HP)
               {
                  Central.main.getMainChar().setBattleBuff(effect);
               }
               break;
            case SenjutsuData.TARGET_SELF_AND_ENEMY_DEBUFF:
               this.defender.setBattleDebuff(effect);
               this.attacker.setBattleDebuff(effect);
               break;
            case SenjutsuData.TARGET_ENEMY_ALL:
               targetArr = [defender];
               k = 0;
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  targetArr = enemyArr;
               }
               else
               {
                  targetArr = [];
                  targetArr.push(Central.main.getMainChar());
                  if(partyArr)
                  {
                     targetArr = targetArr.concat(partyArr);
                  }
               }
               for(k = 0; k < targetArr.length; k++)
               {
                  targetArr[k].setBattleDebuff(effect);
               }
         }
      }
      
      public function updateDamageByHitNum(battleAction:Object, dmgBonus:int) : int
      {
         var skillData:Object = null;
         if(battleAction.action == BattleData.ACTION_SKILL)
         {
            skillData = Central.main.SKILL_DATA[battleAction.skillId];
            if(skillData.skill_hit_num != null)
            {
               if(skillData.skill_hit_num > 1)
               {
                  dmgBonus = Math.round(dmgBonus / skillData.skill_hit_num);
               }
            }
         }
         return dmgBonus;
      }
      
      public function CalculateBloodlineDamagebonus(battleAction:Object, effect:Object, skillData:Object, dmg:int) : int
      {
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var defenderBuff:Object = null;
         var defenderDebuff:Object = null;
         var DamageBonus:int = 0;
         var tmpdmg:int = 0;
         var key:* = null;
         var BLkey:String = null;
         var BLkeyArr:Array = null;
         var BLSkill_requirement:String = null;
         var BLSkill_requirementArr:Array = null;
         var tmpcp:int = 0;
         var BloodlineSkill_ID:String = null;
         attackerBuff = this.attacker.getBattleBuff();
         attackerDebuff = this.attacker.getBattleDebuff();
         defenderBuff = this.defender.getBattleBuff();
         defenderDebuff = this.defender.getBattleDebuff();
         DamageBonus = 0;
         tmpdmg = 0;
         if(dmg > 0)
         {
            tmpdmg = 0;
         }
         else
         {
            tmpdmg = Math.abs(dmg);
         }
         BLkey = "";
         BLkeyArr = [];
         BLSkill_requirement = "";
         BLSkill_requirementArr = [];
         tmpcp = 0;
         BloodlineSkill_ID = "";
         var BloodlineType:String = "";
         if(battleAction.BLSKILLID)
         {
            BloodlineSkill_ID = battleAction.BLSKILLID;
         }
         if(battleAction.BLTYPE)
         {
            BloodlineType = battleAction.BLTYPE;
         }
         for(key in attackerBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkill_requirementArr = [];
            BLSkill_requirement = "";
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           BLSkill_requirement = attackerBuff[key].requirement;
                           BLSkill_requirementArr = BLSkill_requirement.split(",");
                           if(battleAction.action == "bloodline")
                           {
                              if(BloodlineSkill_ID != null)
                              {
                                 if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + BloodlineSkill_ID])
                                 {
                                    if(BLSkill_requirementArr.indexOf(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + BloodlineSkill_ID].type) >= 0)
                                    {
                                       DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                                    }
                                 }
                              }
                           }
                           if(battleAction.action == "skill")
                           {
                              if(skillData)
                              {
                                 if(BLSkill_requirementArr.indexOf(skillData.type) >= 0)
                                 {
                                    DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                                 }
                              }
                           }
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(battleAction.critical)
                           {
                              DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                           }
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
         for(key in attackerDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkill_requirementArr = [];
            BLSkill_requirement = "";
            if(attackerDebuff[key])
            {
               if(attackerDebuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           DamageBonus = DamageBonus - Number(attackerDebuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           BLSkill_requirement = attackerDebuff[key].requirement;
                           BLSkill_requirementArr = BLSkill_requirement.split(",");
                           if(battleAction.action == "bloodline")
                           {
                              if(BloodlineSkill_ID != null)
                              {
                                 if(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + BloodlineSkill_ID])
                                 {
                                    if(BLSkill_requirementArr.indexOf(Central.main.BLOODLINE_SKILL_DATA["bloodline_" + BloodlineSkill_ID].type) >= 0)
                                    {
                                       DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                                    }
                                 }
                              }
                           }
                           if(battleAction.action == "skill")
                           {
                              if(skillData)
                              {
                                 if(BLSkill_requirementArr.indexOf(skillData.type) >= 0)
                                 {
                                    DamageBonus = DamageBonus - Number(attackerBuff[key].amount) / 100 * tmpdmg;
                                 }
                              }
                           }
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(battleAction.critical)
                           {
                              DamageBonus = DamageBonus - Number(attackerDebuff[key].amount) / 100 * tmpdmg;
                           }
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
         for(key in defenderBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkill_requirementArr = [];
            BLSkill_requirement = "";
            if(defenderBuff[key])
            {
               if(defenderBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           DamageBonus = DamageBonus + Number(defenderBuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           if(skillData && skillData.type)
                           {
                              BLSkill_requirement = defenderBuff[key].requirement;
                              BLSkill_requirementArr = BLSkill_requirement.split(",");
                              if(BLSkill_requirementArr.indexOf(skillData.type) >= 0)
                              {
                                 DamageBonus = DamageBonus + Number(defenderBuff[key].amount) / 100 * tmpdmg;
                              }
                           }
                           continue;
                        case BloodlineData.EFFECT_REDUCE_CP:
                           tmpcp = Math.round(attacker.maxCP * (defenderBuff[key].amount / 100));
                           if(0 - tmpcp > 0)
                           {
                              battleAction.attackerRestoreCp = tmpcp;
                           }
                           else if(0 - tmpcp < 0)
                           {
                              battleAction.attackerDamageCp = tmpcp;
                           }
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
         for(key in defenderDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkill_requirementArr = [];
            BLSkill_requirement = "";
            if(defenderDebuff[key])
            {
               if(defenderDebuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           DamageBonus = DamageBonus + Number(defenderDebuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           if(skillData && skillData.type)
                           {
                              BLSkill_requirement = defenderDebuff[key].requirement;
                              BLSkill_requirementArr = BLSkill_requirement.split(",");
                              if(BLSkill_requirementArr.indexOf(skillData.type) >= 0)
                              {
                                 DamageBonus = DamageBonus + Number(defenderDebuff[key].amount) / 100 * tmpdmg;
                              }
                           }
                           continue;
                        case BloodlineData.EFFECT_CAPTURE:
                           if(BloodlineSkill_ID == "skill1012")
                           {
                              DamageBonus = DamageBonus + -3 * tmpdmg;
                           }
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
         return DamageBonus;
      }
      
      public function CalculateSenjutsuDamagebonus(battleAction:Object, effect:Object, skillData:Object, dmg:int) : int
      {
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var defenderBuff:Object = null;
         var defenderDebuff:Object = null;
         var DamageBonus:int = 0;
         var key:* = null;
         var SENkey:String = null;
         var SENkeyArr:Array = null;
         attackerBuff = this.attacker.getBattleBuff();
         attackerDebuff = this.attacker.getBattleDebuff();
         defenderBuff = this.defender.getBattleBuff();
         defenderDebuff = this.defender.getBattleDebuff();
         DamageBonus = 0;
         var tmpdmg:int = 0;
         if(dmg > 0)
         {
            tmpdmg = 0;
         }
         else
         {
            tmpdmg = Math.abs(dmg);
         }
         SENkey = "";
         SENkeyArr = [];
         var SENSkill_requirement:String = "";
         var SENSkill_requirementArr:Array = [];
         var tmpcp:int = 0;
         var SenjutsuSkill_ID:String = "";
         var SenjutsuType:String = "";
         if(battleAction.SENSKILLID)
         {
            SenjutsuSkill_ID = battleAction.SENSKILLID;
         }
         if(battleAction.SENTYPE)
         {
            SenjutsuType = battleAction.SENTYPE;
         }
         for(key in attackerBuff)
         {
            SENkeyArr = [];
            SENkey = "";
            SENSkill_requirementArr = [];
            SENSkill_requirement = "";
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey)
                  {
                     if(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(key in attackerDebuff)
         {
            SENkeyArr = [];
            SENkey = "";
            SENSkill_requirementArr = [];
            SENSkill_requirement = "";
            if(attackerDebuff[key])
            {
               if(attackerDebuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey)
                  {
                     if(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(key in defenderBuff)
         {
            SENkeyArr = [];
            SENkey = "";
            SENSkill_requirementArr = [];
            SENSkill_requirement = "";
            if(defenderBuff[key])
            {
               if(defenderBuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey)
                  {
                     if(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         for(key in defenderDebuff)
         {
            SENkeyArr = [];
            SENkey = "";
            SENSkill_requirementArr = [];
            SENSkill_requirement = "";
            if(defenderDebuff[key])
            {
               if(defenderDebuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey)
                  {
                     if(0)
                     {
                     }
                     break;
                  }
               }
            }
         }
         return DamageBonus;
      }
      
      public function CalculateBloodlineDamageConvert(battleAction:Object, dmg:int) : int
      {
         var defenderBuff:Object = null;
         var defenderDebuff:Object = null;
         var DamageConvert:int = 0;
         var DamageConvert_TO_CP:int = 0;
         var DamageConvert_TO_HP:int = 0;
         var tmpdmg:int = 0;
         var key:* = null;
         var BLkey:String = null;
         var BLkeyArr:Array = null;
         var attackerBuff:Object = this.attacker.getBattleBuff();
         var attackerDebuff:Object = this.attacker.getBattleDebuff();
         defenderBuff = this.defender.getBattleBuff();
         defenderDebuff = this.defender.getBattleDebuff();
         DamageConvert = 0;
         DamageConvert_TO_CP = 0;
         DamageConvert_TO_HP = 0;
         var BLOverHeadString:String = "";
         tmpdmg = 0;
         if(dmg > 0)
         {
            tmpdmg = 0;
         }
         else
         {
            tmpdmg = Math.abs(dmg);
         }
         BLkey = "";
         BLkeyArr = [];
         for(key in defenderBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(defenderBuff[key])
            {
               if(defenderBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           DamageConvert_TO_CP = DamageConvert_TO_CP + Number(defenderBuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           DamageConvert_TO_HP = DamageConvert_TO_HP + Number(defenderBuff[key].amount) / 100 * tmpdmg;
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
         for(key in defenderDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(defenderDebuff[key])
            {
               if(defenderDebuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey)
                  {
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           DamageConvert_TO_CP = DamageConvert_TO_CP + Number(defenderDebuff[key].amount) / 100 * tmpdmg;
                           continue;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           DamageConvert_TO_HP = DamageConvert_TO_HP + Number(defenderDebuff[key].amount) / 100 * tmpdmg;
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
         if(DamageConvert_TO_CP >= tmpdmg)
         {
            DamageConvert_TO_CP = tmpdmg;
         }
         if(DamageConvert_TO_HP >= tmpdmg)
         {
            DamageConvert_TO_HP = tmpdmg;
         }
         if(DamageConvert_TO_HP + DamageConvert_TO_CP >= tmpdmg)
         {
            DamageConvert = tmpdmg;
         }
         else
         {
            DamageConvert = DamageConvert_TO_HP + DamageConvert_TO_CP;
         }
         if(DamageConvert_TO_HP > 0)
         {
            defenderBuff = defender.getBattleBuff();
            DamageConvert_TO_HP = this.applySkill268HpEffect(DamageConvert_TO_HP);
            battleAction.defenderRestoreHp = DamageConvert_TO_HP;
         }
         if(DamageConvert_TO_CP > 0)
         {
            BLOverHeadString = "CP +" + DamageConvert_TO_CP;
            battleAction.defenderRestoreCp = DamageConvert_TO_CP;
         }
         return DamageConvert;
      }
      
      private function CalculateBloodlineDodgebonus() : int
      {
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var DodgeBonus:int = 0;
         var key:* = null;
         var BLkey:String = null;
         var BLkeyArr:Array = null;
         var rNum:Number = NaN;
         attackerBuff = this.attacker.getBattleBuff();
         attackerDebuff = this.attacker.getBattleDebuff();
         DodgeBonus = 0;
         BLkey = "";
         BLkeyArr = [];
         for(key in attackerBuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && attackerBuff[key].chancetoeffect && attackerBuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= attackerBuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_ACCURATE:
                              DodgeBonus = DodgeBonus - Number(attackerBuff[key].amount) / 100;
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
         for(key in attackerDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            if(attackerDebuff[key])
            {
               if(attackerDebuff[key].duration > 0)
               {
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(BLkey && attackerDebuff[key].chancetoeffect && attackerDebuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= attackerDebuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_ACCURATE:
                              DodgeBonus = DodgeBonus - Number(attackerDebuff[key].amount) / 100;
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
         return DodgeBonus;
      }
      
      private function CalculateSenjutsuDodgebonus() : Number
      {
         var attackerBuff:Object = null;
         var attackerDebuff:Object = null;
         var dodgeBonus:Number = NaN;
         var key:* = null;
         var SENkey:String = null;
         var SENkeyArr:Array = null;
         var rNum:Number = NaN;
         var attackerEffect:* = undefined;
         var attackerEffectTypeArray:Array = null;
         var attackerEffectChanceToEffectArray:Array = null;
         var effectTypeIndex:int = 0;
         attackerBuff = this.attacker.getBattleBuff();
         attackerDebuff = this.attacker.getBattleDebuff();
         dodgeBonus = 0;
         SENkey = "";
         SENkeyArr = [];
         attackerEffect = this.attacker.getBattleAction().effect;
         attackerEffectTypeArray = [];
         attackerEffectChanceToEffectArray = [];
         if(attackerEffect != null)
         {
            if(attackerEffect.effect_type_1 != null)
            {
               attackerEffectTypeArray.push(attackerEffect.effect_type_1);
               attackerEffectChanceToEffectArray.push(attackerEffect.effect_chancetoeffect_1);
            }
            if(attackerEffect.effect_type_2 != null)
            {
               attackerEffectTypeArray.push(attackerEffect.effect_type_2);
               attackerEffectChanceToEffectArray.push(attackerEffect.effect_chancetoeffect_2);
            }
            if(attackerEffect.effect_type_3 != null)
            {
               attackerEffectTypeArray.push(attackerEffect.effect_type_3);
               attackerEffectChanceToEffectArray.push(attackerEffect.effect_chancetoeffect_3);
            }
         }
         effectTypeIndex = -1;
         effectTypeIndex = attackerEffectTypeArray.indexOf(SenjutsuData.EFFECT_SS_DODGE_IGNORE);
         if(effectTypeIndex >= 0)
         {
            dodgeBonus = dodgeBonus - Number(attackerEffectChanceToEffectArray[effectTypeIndex]) / 100;
         }
         for(key in attackerBuff)
         {
            SENkeyArr = [];
            SENkey = "";
            if(attackerBuff[key])
            {
               if(attackerBuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey && attackerBuff[key].chancetoeffect && attackerBuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= attackerBuff[key].chancetoeffect / 100)
                     {
                        switch(SENkey)
                        {
                           case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
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
         for(key in attackerDebuff)
         {
            SENkeyArr = [];
            SENkey = "";
            if(attackerDebuff[key])
            {
               if(attackerDebuff[key].duration > 0)
               {
                  SENkeyArr = key.split(".");
                  if(SENkeyArr)
                  {
                     SENkey = SENkeyArr[0];
                  }
                  if(SENkey && attackerDebuff[key].chancetoeffect && attackerDebuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= attackerDebuff[key].chancetoeffect / 100)
                     {
                        if(0)
                        {
                        }
                        break;
                     }
                  }
               }
            }
         }
         return dodgeBonus;
      }
      
      private function getOneRandomNonPassiveEffectFromLists(effectList:Array) : Object
      {
         var count:int = 0;
         var effectObj:Object = null;
         var key:* = null;
         var i:int = 0;
         var pickedNum:int = 0;
         var countPick:int = 0;
         var value:Object = null;
         count = 0;
         for(i = 0; i < effectList.length; i++)
         {
            if(effectList[i])
            {
               effectObj = effectList[i];
               for(key in effectObj)
               {
                  if(effectObj[key])
                  {
                     if(effectObj[key].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                     {
                        count++;
                     }
                  }
               }
            }
         }
         if(count == 0)
         {
            return null;
         }
         pickedNum = Math.floor(NumberUtil.getRandom() * count);
         countPick = 0;
         for(i = 0; i < effectList.length; i++)
         {
            if(effectList[i])
            {
               effectObj = effectList[i];
               for(key in effectObj)
               {
                  trace("key = ===== " + key);
                  value = effectObj[key];
                  trace("value = " + GF.printObject(value));
                  if(effectObj[key].duration > BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     continue;
                  }
                  if(key.indexOf(BattleData.EFFECT_DAMAGE_DELAY) >= 0)
                  {
                     continue;
                  }
                  if(key.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) >= 0)
                  {
                     continue;
                  }
                  if(key.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) >= 0)
                  {
                     continue;
                  }
                  if(key.indexOf(BloodlineData.EFFECT_TITAN) >= 0)
                  {
                     continue;
                  }
                  if(key.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) >= 0)
                  {
                     trace("getOneRandomNonPassiveEffectFromLists 111111111111111111111111111111111111111111111111");
                     continue;
                  }
                  if(countPick != pickedNum)
                  {
                     countPick++;
                     continue;
                  }
                  return effectObj[key];
               }
            }
         }
         return null;
      }
      
      private function getOneRandomNonPassiveEffectCanAbsorb(effectList:Array) : Array
      {
         var effectObj:Object = null;
         var key:String = null;
         var i:int = 0;
         var result:Array = null;
         trace("effectList = " + GF.printObject(effectList));
         var count:int = 0;
         result = [];
         for(i = 0; i < effectList.length; i++)
         {
            if(effectList[i])
            {
               trace("effectList.length = " + effectList.length);
               effectObj = effectList[i];
               trace("effectObj = " + GF.printObject(effectObj));
               if(effectObj.duration > BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  result.push(1);
               }
               else if(effectObj.type.indexOf(BattleData.EFFECT_DAMAGE_DELAY) >= 0)
               {
                  result.push(1);
               }
               else if(effectObj.type.indexOf(BattleData.EFFECT_DAMAGE_DELAY_INJURY) >= 0)
               {
                  result.push(1);
               }
               else if(effectObj.type.indexOf(SenjutsuData.EFFECT_SENNIN_MODE) >= 0)
               {
                  result.push(1);
               }
               else if(effectObj.type.indexOf(BloodlineData.EFFECT_EXTREME) >= 0)
               {
                  trace("getOneRandomNonPassiveEffectCanAbsorb");
                  result.push(1);
               }
               else if(effectObj.type.indexOf(BloodlineData.EFFECT_TITAN) >= 0)
               {
                  result.push(1);
               }
               else if(effectObj.type.indexOf(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF) >= 0)
               {
                  result.push(0);
               }
               else
               {
                  result.push(2);
               }
            }
         }
         return result;
      }
      
      private function calculateSkillDamageReduction(battleAction:Object, effect:Object, skillData:Object, dmg:int) : int
      {
         var tmpdmg:int = 0;
         var defenderBuff:Object = null;
         var damageModifier:int = 0;
         var rNum:Number = NaN;
         var key:* = null;
         var EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MIN:uint = 0;
         var EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MAX:uint = 0;
         var randRange:Number = NaN;
         tmpdmg = dmg > 0?0:int(Math.abs(dmg));
         defenderBuff = this.defender.getBattleBuff();
         damageModifier = 0;
         rNum = Math.random();
         for(key in defenderBuff)
         {
            if(defenderBuff[key] == null)
            {
               continue;
            }
            if(defenderBuff[key].duration < 0)
            {
               continue;
            }
            switch(key)
            {
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                  EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MIN = 25;
                  EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MAX = 75;
                  randRange = EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MAX - EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MIN + 1;
                  damageModifier = damageModifier + (Math.floor(rNum * randRange) + EFFECT_HALFHP_DAMAGE_REDUCTION_REDUCE_MIN) * 0.01 * tmpdmg;
                  continue;
               default:
                  continue;
            }
         }
         return damageModifier;
      }
      
      public function checkDmgHack(dmg:int, round:int, members:String, defId:String, defMaxHP:int) : void
      {
         var missionId:String = null;
         var hash:String = null;
         missionId = Central.mission.curMissionID == null?"0":Central.mission.curMissionID;
         hash = Central.main.getHash(String(round) + missionId + String(dmg) + members + defId + String(defMaxHP));
         Central.main.amfClient.service("CharacterDAO.makeBattleBetter",[Account.getAccountSessionKey(),round,missionId,dmg,members,defId,defMaxHP,hash],function(response:Object):*
         {
            if(!Central.main.validateAmfResponse(response))
            {
            }
         });
      }
      
      private function setBattleActionFeedback(battleAction:Object, feedbackObject:Object) : *
      {
         if(!battleAction.feedback)
         {
            battleAction.feedback = new Array();
         }
         battleAction.feedback.push(feedbackObject);
      }
      
      private function checkIsSelfBuff(battleAcion:Object) : Boolean
      {
         var skillData:Object = null;
         var skillTarget:int = 0;
         loop0:
         switch(battleAcion.action)
         {
            case "waepon_attack":
            case "attack":
               return false;
            case "skill":
               if(battleAcion.skillId)
               {
                  skillData = Central.main.SKILL_DATA[battleAcion.skillId];
                  skillTarget = !!skillData?int(skillData.target):0;
                  switch(skillTarget)
                  {
                     case 1:
                     case 3:
                     case 4:
                        return true;
                  }
               }
               break;
            case "special":
               switch(battleAcion.target)
               {
                  case "master":
                  case "self":
                     return true;
                  default:
                     break loop0;
               }
            case "bloodline":
            case "senjutsu":
               return true;
         }
         return false;
      }
      
      private function checkClone(battleAction:Object) : void
      {
         var i:* = undefined;
         var buff:* = undefined;
         for(i = 0; i < this.characterArr.length; i++)
         {
            if(this.characterArr[i].isDead == false && this.characterArr[i].side == this.defender.side)
            {
               for(var _loc6_ in this.characterArr[i].getBattleBuff())
               {
                  switch(_loc6_)
                  {
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                        if(this.characterArr[i].getBattleBuff()[buff] && this.characterArr[i].getBattleBuff()[buff].chance / 100 >= NumberUtil.getRandom() && battleAction.clones[this.characterArr[i].getCharacterId()] == null)
                        {
                           if(!battleAction.clones[this.characterArr[i].getCharacterId()])
                           {
                              battleAction.clones[this.characterArr[i].getCharacterId()] = {};
                           }
                           battleAction.clones[this.characterArr[i].getCharacterId()].effectName = BattleData.TYPE_DUMMY;
                           battleAction.clones[this.characterArr[i].getCharacterId()].buffName = buff;
                        }
                        continue;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                        trace("checkClone battleAction = " + battleAction.clones);
                        trace("checkClone battleAction = " + GF.printObject(battleAction.clones));
                        trace("checkClone battleAction = " + GF.printObject(battleAction));
                        if(this.characterArr[i].getBattleBuff()[buff] && this.characterArr[i].getBattleBuff()[buff].chance / 100 >= NumberUtil.getRandom())
                        {
                           if(!battleAction.clones[this.characterArr[i].getCharacterId()])
                           {
                              battleAction.clones[this.characterArr[i].getCharacterId()] = {};
                           }
                           battleAction.clones[this.characterArr[i].getCharacterId()].effectName = BattleData.TYPE_DUMMY_BURN;
                           battleAction.clones[this.characterArr[i].getCharacterId()].buffName = buff;
                        }
                        continue;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        if(this.characterArr[i].getBattleBuff()[buff] && this.characterArr[i].getBattleBuff()[buff].chance / 100 >= NumberUtil.getRandom())
                        {
                           if(!battleAction.clones[this.characterArr[i].getCharacterId()])
                           {
                              battleAction.clones[this.characterArr[i].getCharacterId()] = {};
                           }
                           battleAction.clones[this.characterArr[i].getCharacterId()].effectName = BattleData.TYPE_DUMMY_STUN;
                           battleAction.clones[this.characterArr[i].getCharacterId()].buffName = buff;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
      }
      
      private function getAvailableBuff(char:*, getNum:int) : Array
      {
         var abBuff:Array = null;
         var i:int = 0;
         var rtArr:Array = null;
         var tmpBuff:Object = null;
         var nexrNum:int = 0;
         var buff:* = undefined;
         abBuff = [];
         rtArr = [];
         for(buff in char.getBattleBuff())
         {
            tmpBuff = char.getBattleBuff()[buff];
            if(buff == BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF)
            {
               trace("getAvailableBuff 123123123213131231313123123213213211223131212");
            }
            else if(buff != BattleData.EFFECT_DAMAGE_DELAY)
            {
               if(buff != SenjutsuData.EFFECT_SENNIN_MODE)
               {
                  if(tmpBuff.duration < 900)
                  {
                     abBuff.push(tmpBuff);
                  }
               }
            }
         }
         if(abBuff.length > 0)
         {
            for(i = 0; i < getNum; i++)
            {
               if(i >= abBuff.length)
               {
                  break;
               }
               while(i == rtArr.length)
               {
                  nexrNum = NumberUtil.randomInt(0,abBuff.length - 1);
                  if(rtArr.indexOf(abBuff[nexrNum]) < 0)
                  {
                     rtArr.push(abBuff[nexrNum]);
                  }
               }
            }
         }
         return rtArr;
      }
   }
}

class InstanceBlocker
{
    
   
   function InstanceBlocker()
   {
      super();
   }
}
