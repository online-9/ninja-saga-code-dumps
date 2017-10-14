package ninjasaga.base
{
   import com.utils.Out;
   import ninjasaga.Battle;
   import ninjasaga.data.Timeline;
   import ninjasaga.Central;
   import ninjasaga.Main;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import com.utils.GF;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.AppData;
   import com.utils.NumberUtil;
   import ninjasaga.data.ButtonData;
   
   public class CharacterBattle extends CharacterDisplay
   {
       
      
      public function CharacterBattle()
      {
         super();
      }
      
      public function nextRound(roundObj:Object) : void
      {
         var i:int = 0;
         var overheadString:String = null;
         var buffArr:Array = null;
         var debuffArr:Array = null;
         var hpAmount:int = 0;
         var cpAmount:int = 0;
         var sign:String = null;
         var restoreArr:Array = null;
         var restoreObj:Object = null;
         var key:* = null;
         if(roundObj == null)
         {
            Out.error(this,"nextRound :: roundObj is null");
            return;
         }
         if(roundObj.purify != null)
         {
            if(Battle.type == Battle.TYPE_NETWORK)
            {
               this.clearAllDebuff();
            }
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
            if(roundObj.purify.restoreHp != null)
            {
               if(roundObj.purify.restoreHp > 0)
               {
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     this.updateHP(roundObj.purify.restoreHp);
                  }
                  this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(483) + " " + roundObj.purify.restoreHp));
               }
               this.updateBattleFrame();
               Main.updateMenu();
            }
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            this.reduceSkillCooldown(1);
         }
         if(roundObj.buff != null)
         {
            buffArr = roundObj.buff;
            for(i = 0; i < buffArr.length; i++)
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.setBattleBuff(buffArr[i]);
               }
            }
         }
         if(roundObj.debuff != null)
         {
            debuffArr = roundObj.debuff;
            for(i = 0; i < debuffArr.length; i++)
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.setBattleDebuff(debuffArr[i]);
               }
            }
         }
         this.nextBattleRound();
         var updateDotHP:Boolean = true;
         if(roundObj.restore != null)
         {
            hpAmount = roundObj.restore.hp;
            cpAmount = roundObj.restore.cp;
            if(hpAmount != 0)
            {
               if(hpAmount > 0)
               {
                  sign = "+";
               }
               if(hpAmount < 0)
               {
                  sign = "-";
               }
               this.showOverheadNumber(Timeline.WORD,sign + Math.abs(hpAmount) + " " + String(Central.main.langLib.get(483)).replace("+",""));
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.updateHP(hpAmount);
               }
            }
            if(cpAmount != 0)
            {
               if(cpAmount > 0)
               {
                  sign = "+";
               }
               if(cpAmount < 0)
               {
                  sign = "-";
               }
               this.showOverheadNumber(Timeline.WORD,sign + Math.abs(cpAmount) + " " + String(Central.main.langLib.get(350)).replace("+",""));
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  this.updateCP(cpAmount);
               }
            }
            if(roundObj.restore.arr != null)
            {
               restoreArr = roundObj.restore.arr;
               hpAmount = 0;
               cpAmount = 0;
               for(i = 0; i < restoreArr.length; i++)
               {
                  restoreObj = restoreArr[i];
                  if(!updateDotHP && restoreObj.hp < 0)
                  {
                     restoreObj.hp = 0;
                  }
                  switch(restoreObj.type)
                  {
                     case BattleData.EFFECT_BURN:
                     case BattleData.EFFECT_BURN_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(375)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_FLAME:
                        this.showOverheadNumber(Timeline.WORD,restoreObj.hp + "" + String(Central.main.langLib.get(483).replace("+","")));
                        this.showOverheadNumber(Timeline.WORD,restoreObj.cp + "" + String(Central.main.langLib.get(295).replace("+","")));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        cpAmount = cpAmount + Math.round(restoreObj.cp);
                        break;
                     case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(String(restoreObj.hp) + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_POISON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(376)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(377)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_PARASITE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(378)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_BURNING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(379)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_PET_BURN:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(379)).replace("[valamount]",String(restoreObj.hp)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_COLLIDING_WAVE:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     case BattleData.EFFECT_REDUCE_HP_CP:
                        this.showOverheadNumber(Timeline.WORD,String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP) + ", " + restoreObj.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        cpAmount = cpAmount + Math.round(restoreObj.cp);
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                        this.showOverheadNumber(Timeline.WORD,String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                        this.showOverheadNumber(Timeline.WORD,String(restoreObj.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        cpAmount = cpAmount + Math.round(restoreObj.cp);
                        break;
                     case BloodlineData.EFFECT_UPDATE_HP:
                        if(int(restoreObj.hp) > 0)
                        {
                           overheadString = "+" + restoreObj.hp + " " + String(Central.main.langLib.get(483)).replace("+","");
                        }
                        else
                        {
                           overheadString = restoreObj.hp + " " + String(Central.main.langLib.get(483)).replace("+","");
                        }
                        if(restoreObj.skill == "skill1019")
                        {
                           overheadString = Central.main.langLib.get(753) + " " + overheadString;
                        }
                        this.showOverheadNumber(Timeline.WORD,overheadString);
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BloodlineData.EFFECT_UPDATE_CP:
                        if(int(restoreObj.cp) > 0)
                        {
                           overheadString = "+" + restoreObj.cp + " " + Central.main.langLib.get(295);
                        }
                        else
                        {
                           overheadString = restoreObj.cp + " " + Central.main.langLib.get(295);
                        }
                        trace("overheadString = " + overheadString);
                        this.showOverheadNumber(Timeline.WORD,overheadString);
                        break;
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(596)));
                     case BattleData.EFFECT_PET_HEAL:
                     case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                     case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                     case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                        hpAmount = hpAmount + restoreObj.hp;
                        this.showOverheadNumber(Timeline.HEAL,restoreObj.hp);
                        break;
                     case BattleData.SKILL_377:
                        this.showOverheadNumber(Timeline.WORD,String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_DOT_HP:
                        this.showOverheadNumber(Timeline.WORD,String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        cpAmount = cpAmount + Math.round(restoreObj.cp);
                        break;
                     case BattleData.EFFECT_REGENERATE_HP:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.cp.toString() + Central.main.langLib.titleTxt(TitleData.CP)));
                        cpAmount = cpAmount + Math.round(restoreObj.cp);
                        break;
                     case BattleData.SKILL_335:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY:
                        if(restoreObj.hp && restoreObj.hp != 0)
                        {
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[3] + "(" + String(restoreObj.hp.toString()) + Central.main.langLib.titleTxt(TitleData.HP) + ")");
                           hpAmount = hpAmount + Math.round(restoreObj.hp);
                        }
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + 250;
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + 550;
                        break;
                     case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,"+" + String(restoreObj.hp.toString() + Central.main.langLib.titleTxt(TitleData.HP)));
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                        break;
                     case BattleData.EFFECT_ULTRA_BURNING:
                        this.showOverheadNumber(Timeline.WORD,"(" + String(Central.main.langLib.get(2018) + String(restoreObj.hp)) + "HP)");
                        hpAmount = hpAmount + Math.round(restoreObj.hp);
                  }
               }
            }
         }
         if(this.battleBuff)
         {
            for(key in this.battleBuff)
            {
               if(this.battleBuff[key])
               {
                  if(this.battleBuff[key].duration > 0)
                  {
                     switch(key)
                     {
                        case BattleData.EFFECT_DAMAGE_DELAY:
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1844) + Number(-this.battleBuff[key].intmem1).toString() + "/" + Number(this.battleBuff[key].intmem2).toString());
                           hpAmount = this.battleBuff[key].intmem1;
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
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            if(hpAmount != 0)
            {
               this.updateHP(hpAmount);
            }
            if(cpAmount != 0)
            {
               this.updateCP(cpAmount);
            }
            Central.battle.syncHpCpCommandAction();
         }
         this.updateBattleFrame();
         Main.updateMenu();
      }
      
      public function nextBattleRound() : void
      {
         var key:* = null;
         var rNum:Number = NaN;
         var amount:int = 0;
         var effect:Object = null;
         var value1:int = 0;
         var value2:int = 0;
         var BLkey:String = "";
         var BLkeyArr:Array = [];
         var BLOverHeadString:String = "";
         var BL_HP_Amount:int = 0;
         var BL_CP_Amount:int = 0;
         var OverHeadWord:* = "";
         var Sign:String = "";
         var effectamt:Number = 0;
         var effectreq:String = "";
         var effectduration:Number = 0;
         var reqArr:Array = null;
         var i:int = 0;
         var CPMax:Number = 0;
         var deBuffDeBugSkill:Array = [];
         if(Central.main.senjutsuFeature)
         {
            showCharacterSenjutsuBuffAndDebuff();
         }
         trace("hank :: battle buff = " + GF.printObject(this.battleBuff));
         for(key in this.battleBuff)
         {
            if(this.battleBuff[key])
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  if(this.battleBuff[key].duration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                  {
                  }
               }
               if(this.battleBuff[key].duration > 0)
               {
                  trace("Hank :: key >> " + key);
                  switch(key)
                  {
                     case BattleData.EFFECT_CRITICAL_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_REWIND:
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(800));
                           this.reduceSkillCooldown(this.battleBuff[key].amount,BattleData.REDUCETYPE_SKILL);
                        }
                        break;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(875) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2008) + "(" + String(this.battleBuff[key].duration) + ")"));
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(330)));
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS:
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                     case BattleData.SKILL_369:
                     case BattleData.SKILL_501:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(330) + "(" + this.battleBuff[key].duration + ")"));
                        break;
                     case BattleData.EFFECT_PET_SAVE_CP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(805) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_ATTENTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(807) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(322) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(878)));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(832) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(322) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_ATTACK_MODE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(881) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(883) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_SERENE_MIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(622) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_ENERGIZE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(893) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(822) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_GUARD:
                     case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(636)));
                        break;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(834) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1871) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(873) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_BLOOD_FEED:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(683) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.EFFECT_LOW_HP_CRITICAL_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[4] + "(" + String(this.battleBuff[key].duration) + ")");
                        break;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(292) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(747) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleBuff[key].duration))));
                        break;
                     case BattleData.SKILL_302:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1358) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.SKILL_234:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(807) + "(" + battleBuff[key].duration + ")"));
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(814) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.SKILL_307:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1363) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_MANA_SHIELD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324) + "(" + battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS:
                     case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(613));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        break;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        break;
                     case BattleData.SKILL_251:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                        break;
                     case BattleData.SKILL_285:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1355));
                        this.syncCoolDown();
                     case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                        break;
                     case BattleData.EFFECT_ACCURATE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                        break;
                     case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        break;
                     case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_CRITICAL_N_DODGE_REDUCTION:
                        if(this.hp / this.maxHP <= this.getBattleBuff()[SenjutsuData.EFFECT_SS_SPIRIT_MODE].amount * 0.01)
                        {
                           this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_DIVIDE_CHAOS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2008) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(687)).replace("[valamt]",String(battleBuff[key].amount)) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_CP_LOCK:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_COMPLETE_GUARD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_RECEIVED_DMG_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2016) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_RECEIVED_BURNING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2019) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_CRITICAL_BUFF_N_RECEIVED_STUN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2020) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_DMG_N_AGI:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2021) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_MANA_SHILED_N_PURIFY_BELOW_CP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2023) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_SAND_GUARD:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2025) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2026) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2027) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_ALL_BUFF:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2029) + "(" + this.battleBuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_DEBUFF_RESIST_EX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2028));
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2032));
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2033));
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(" + this.battleBuff[key].duration + (AppData.lang == AppData.ZH?" 回合":" turns") + ")");
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034) + "(" + battleDebuff[key].amount + ")(" + battleDebuff[key].duration + (AppData.lang == AppData.ZH?" 回合":" turns") + ")");
                  }
                  BLkeyArr = [];
                  BLkey = "";
                  BLkeyArr = key.split(".");
                  if(BLkeyArr && BLkeyArr.length > 0)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  if(BLkey && this.battleBuff[key].chancetoeffect && this.battleBuff[key].chancetoeffect > 0)
                  {
                     rNum = NumberUtil.getRandom();
                     if(rNum <= this.battleBuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_UPDATE_HP:
                              BL_HP_Amount = 0;
                              BL_HP_Amount = Math.round(this.maxHP * (this.battleBuff[key].amount / 100));
                              this.updateHP(BL_HP_Amount);
                              BLOverHeadString = "";
                              if(BL_HP_Amount > 0)
                              {
                                 BLOverHeadString = "+" + BL_HP_Amount + " " + String(Central.main.langLib.get(483)).replace("+","");
                              }
                              else
                              {
                                 BLOverHeadString = BL_HP_Amount + " " + String(Central.main.langLib.get(483)).replace("+","");
                              }
                              if(BLkeyArr[1] == "skill1019")
                              {
                                 BLOverHeadString = Central.main.langLib.get(753) + " " + BLOverHeadString;
                              }
                              this.showOverheadNumber(Timeline.WORD,BLOverHeadString);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_UPDATE_CP:
                              BL_CP_Amount = 0;
                              BL_CP_Amount = Math.round(this.maxCP * (this.battleBuff[key].amount / 100));
                              this.updateCP(BL_CP_Amount);
                              BLOverHeadString = "";
                              if(BL_CP_Amount > 0)
                              {
                                 BLOverHeadString = "+" + BL_CP_Amount + " " + Central.main.langLib.get(295);
                              }
                              else
                              {
                                 BLOverHeadString = BL_CP_Amount + " " + Central.main.langLib.get(295);
                              }
                              this.showOverheadNumber(Timeline.WORD,BLOverHeadString);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_MAX_CP_RECOVER:
                              this.updateCP(0);
                              this.updateBattleFrame();
                              Main.updateMenu();
                              break;
                           case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                        }
                     }
                  }
               }
               effectamt = 0;
               effectreq = "";
               if(this.battleBuff[key].duration <= 0)
               {
                  if(this.battleBuff[key].amount)
                  {
                     effectamt = this.battleBuff[key].amount;
                  }
                  if(this.battleBuff[key].requirement)
                  {
                     effectreq = this.battleBuff[key].requirement;
                  }
                  this.battleBuff[key] = null;
                  switch(key)
                  {
                     case BattleData.SKILL_285:
                        this.syncCoolDown();
                        break;
                     case BattleData.EFFECT_DAMAGE_REDUCTION:
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS:
                     case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                     case BattleData.SKILL_369:
                        break;
                     case BattleData.EFFECT_DODGE_BONUS:
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        break;
                     case BattleData.EFFECT_COMBUSTION:
                        break;
                     case BattleData.EFFECT_GATE_OPENING:
                        break;
                     case BattleData.EFFECT_REACTIVE_FORCE:
                        break;
                     case BattleData.EFFECT_MANA_SHIELD:
                        break;
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        break;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        break;
                     case BattleData.EFFECT_PET_ATTENTION:
                        break;
                     case BattleData.EFFECT_COMPLETE_GUARD:
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        break;
                     case BattleData.EFFECT_PET_HEAL:
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        break;
                     case BattleData.EFFECT_PET_SAVE_CP:
                        break;
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                        break;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                        break;
                     case BattleData.EFFECT_FRENZY:
                        break;
                     case BattleData.EFFECT_SERENE_MIND:
                        break;
                     case BattleData.EFFECT_ATTACK_MODE:
                        break;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        break;
                     case BattleData.EFFECT_PET_ENERGIZE:
                        break;
                     case BattleData.EFFECT_GUARD:
                        break;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        break;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        break;
                     case BattleData.EFFECT_EXTRA_CP_RECOVER:
                        break;
                     case BattleData.EFFECT_BLOOD_FEED:
                        break;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        break;
                     case BattleData.SKILL_307:
                  }
                  OverHeadWord = "";
                  Sign = "";
                  BLkey = "";
                  BLkeyArr = [];
                  BLkeyArr = key.split(".");
                  if(BLkeyArr && BLkeyArr.length > 0)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  if(BLkey && BLkey != "")
                  {
                     if(effectamt > 0)
                     {
                        Sign = "+";
                     }
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(735);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           OverHeadWord = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           OverHeadWord = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           OverHeadWord = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(740);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(741);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           OverHeadWord = Central.main.langLib.get(742);
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(744);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(745);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(746);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(747);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           OverHeadWord = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           OverHeadWord = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           OverHeadWord = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           OverHeadWord = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           OverHeadWord = Central.main.langLib.get(281);
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           OverHeadWord = "";
                           if(BLkeyArr[1] == "skill1019")
                           {
                              OverHeadWord = Central.main.langLib.get(753);
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           OverHeadWord = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(755);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           OverHeadWord = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(758);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           OverHeadWord = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           OverHeadWord = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           OverHeadWord = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           OverHeadWord = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(805);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           OverHeadWord = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           OverHeadWord = Central.main.langLib.get(734);
                           break;
                        case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(2005) + "(" + this.battleBuff[key].duration + ")";
                           break;
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           OverHeadWord = Central.main.langLib.get(2011) + "(" + this.battleBuff[key].duration + ")";
                     }
                     if(OverHeadWord != "")
                     {
                        OverHeadWord = OverHeadWord + " " + Central.main.langLib.get(647);
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                           }
                        }
                     }
                  }
               }
               else
               {
                  effectamt = 0;
                  effectreq = "";
                  effectduration = 0;
                  if(this.battleBuff[key].amount)
                  {
                     effectamt = this.battleBuff[key].amount;
                  }
                  if(this.battleBuff[key].requirement)
                  {
                     effectreq = this.battleBuff[key].requirement;
                  }
                  if(this.battleBuff[key].duration)
                  {
                     effectduration = this.battleBuff[key].duration;
                  }
                  OverHeadWord = "";
                  Sign = "";
                  BLkey = "";
                  BLkeyArr = [];
                  BLkeyArr = key.split(".");
                  if(BLkeyArr && BLkeyArr.length > 0)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  if(BLkey && BLkey != "" && effectduration <= BloodlineData.PASSIVE_BUFF_IDENTIFIER)
                  {
                     if(effectamt > 0)
                     {
                        Sign = "+";
                     }
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(735);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           OverHeadWord = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           OverHeadWord = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           OverHeadWord = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(740);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(741);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           OverHeadWord = Central.main.langLib.get(742);
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(744);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(745);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(746);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(747);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           OverHeadWord = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           OverHeadWord = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           OverHeadWord = "";
                           if(BLkeyArr[1] == "skill1019")
                           {
                              OverHeadWord = "";
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           OverHeadWord = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(755);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           OverHeadWord = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(758);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           OverHeadWord = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           OverHeadWord = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           OverHeadWord = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           OverHeadWord = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(805);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           OverHeadWord = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           OverHeadWord = Central.main.langLib.get(734);
                           break;
                        case BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(2005);
                           break;
                        case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                           OverHeadWord = Central.main.langLib.get(2011);
                     }
                     if(OverHeadWord != "")
                     {
                        OverHeadWord = OverHeadWord + "(" + String(effectduration) + ")";
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                              this.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                           }
                        }
                        else
                        {
                           this.showOverheadNumber(Timeline.WORD,OverHeadWord);
                        }
                     }
                  }
               }
            }
         }
         trace("hank :: battle debuff = " + GF.printObject(this.battleDebuff));
         for(key in this.battleDebuff)
         {
            if(this.battleDebuff[key])
            {
               if(Battle.type == Battle.TYPE_NETWORK)
               {
                  if(this.battleDebuff[key].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                  }
               }
               if(this.battleDebuff[key].duration > 0)
               {
                  trace("Hank :: key >> " + key);
                  switch(key)
                  {
                     case SenjutsuData.EFFECT_SS_BUNDLE_TALENT:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[6] + "(" + this.battleDebuff[key].duration + ")");
                        Out.debug("characterbattle hank","EFFECT_SS_BUNDLE_TALENT");
                  }
               }
               if(this.battleDebuff[key].duration <= 0)
               {
                  effectamt = 0;
                  effectreq = "";
                  if(this.battleDebuff[key].amount)
                  {
                     effectamt = this.battleDebuff[key].amount;
                  }
                  if(this.battleDebuff[key].requirement)
                  {
                     effectreq = this.battleDebuff[key].requirement;
                  }
                  this.battleDebuff[key] = null;
                  switch(key)
                  {
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_PET_BLEEDING:
                        break;
                     case BattleData.EFFECT_BURN:
                        break;
                     case BattleData.EFFECT_BLIND:
                        break;
                     case BattleData.EFFECT_BUNDLE:
                     case BattleData.SKILL_377:
                        break;
                     case BattleData.EFFECT_POISON:
                        break;
                     case BattleData.EFFECT_FEAR:
                        break;
                     case BattleData.EFFECT_FEAR_WEAKEN:
                        break;
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                        break;
                     case BattleData.EFFECT_PARASITE:
                        break;
                     case BattleData.EFFECT_BURNING:
                        break;
                     case BattleData.EFFECT_PET_BURN:
                        break;
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        break;
                     case BattleData.EFFECT_DISTRACT:
                        break;
                     case BattleData.EFFECT_HAMSTRING:
                        break;
                     case BattleData.EFFECT_CUBE_ILLUSION:
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        if(effectamt == 2)
                        {
                        }
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                        break;
                     case BattleData.EFFECT_DARK_CURSE:
                        break;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        break;
                     case BattleData.EFFECT_PET_BLIND:
                        break;
                     case BattleData.EFFECT_PET_WEAKEN:
                        break;
                     case BattleData.EFFECT_DISMANTLE:
                        break;
                     case BattleData.EFFECT_CHAOS:
                        break;
                     case BattleData.EFFECT_PET_FREEZE:
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        break;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        break;
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                        break;
                     case BattleData.EFFECT_PET_DISORIENTED:
                        break;
                     case BattleData.EFFECT_SLEEP:
                        break;
                     case BattleData.EFFECT_DARKNESS:
                        break;
                     case BattleData.SKILL_342:
                        break;
                     case BattleData.EFFECT_MERIDIANS_SEAL:
                        break;
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                        break;
                     case BattleData.SKILL_359:
                  }
                  OverHeadWord = "";
                  Sign = "";
                  BLkey = "";
                  BLkeyArr = [];
                  BLkeyArr = key.split(".");
                  if(BLkeyArr && BLkeyArr.length > 0)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  if(BLkey && BLkey != "")
                  {
                     if(effectamt > 0)
                     {
                        Sign = "+";
                     }
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(735);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           OverHeadWord = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           OverHeadWord = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           OverHeadWord = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(740);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(741);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(744);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(745);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(746);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(747);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           OverHeadWord = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           OverHeadWord = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           OverHeadWord = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           OverHeadWord = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           OverHeadWord = Central.main.langLib.get(281);
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           OverHeadWord = "";
                           if(BLkeyArr[1] == "skill1019")
                           {
                              OverHeadWord = Central.main.langLib.get(753);
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           OverHeadWord = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(755);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           OverHeadWord = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(758);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           OverHeadWord = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           OverHeadWord = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           OverHeadWord = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           OverHeadWord = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(805);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           OverHeadWord = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           OverHeadWord = Central.main.langLib.get(734);
                     }
                     if(OverHeadWord != "")
                     {
                        OverHeadWord = OverHeadWord + " " + Central.main.langLib.get(647);
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                           }
                        }
                     }
                  }
               }
               else
               {
                  switch(key)
                  {
                     case BattleData.EFFECT_BLEEDING:
                     case BattleData.EFFECT_BLEEDING_FIX_NUM:
                     case BattleData.EFFECT_PET_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(286) + "(" + this.battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.EFFECT_DECREASE_CRITICAL_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(670) + "(" + this.battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.EFFECT_BLIND:
                     case BattleData.EFFECT_ALL_CP_BLIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(287)));
                        break;
                     case BattleData.EFFECT_DODGE_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        break;
                     case BattleData.EFFECT_DISTRACT:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(671)).replace("[valamt]",(this.battleDebuff[key].amount * 100).toString()));
                        break;
                     case BattleData.EFFECT_HAMSTRING:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(688)));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_DARK_CURSE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(649));
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034));
                        break;
                     case BattleData.EFFECT_PET_BLIND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(287) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_DISMANTLE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(816).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.SKILL_341:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(817)));
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(762)));
                        break;
                     case BattleData.EFFECT_CHAOS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(734));
                        break;
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(804) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PET_WEAKEN:
                     case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(801)));
                        break;
                     case BattleData.EFFECT_PET_FREEZE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_STUN:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(281) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(954) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        if(this.battleDebuff[BattleData.EFFECT_SILVER_CHAIN_BUNDLE].amount == 1)
                        {
                           this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(801) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        }
                        break;
                     case BattleData.EFFECT_PET_DISORIENTED:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(891) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(651) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(609) + Central.main.langLib.get(880).replace("[valturn]",String(this.battleDebuff[key].duration))));
                        break;
                     case BattleData.EFFECT_DARKNESS:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1088) + " (" + String(this.battleDebuff[key].duration) + ")");
                        break;
                     case BattleData.SKILL_236:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799) + "(" + battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.SKILL_304:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1359) + "(" + battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                        break;
                     case BattleData.EFFECT_BUFF_NEGATE:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(2035) + "(" + battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.SKILL_253:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.SKILL_270:
                        this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1364) + "(" + battleDebuff[key].duration + ")"));
                        break;
                     case BattleData.SKILL_342:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1361) + "(" + battleDebuff[key].duration + ")");
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(670) + "(" + battleDebuff[key].duration + ")");
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_SLEEP:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0] + "(" + battleDebuff[key].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "(" + battleDebuff[key].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra " + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_FEAR:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(304) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                     case BattleData.EFFECT_FEAR_WEAKEN:
                     case BattleData.EFFECT_PET_FEAR_WEAKEN:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_MERIDIANS_SEAL:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_BUNDLE:
                     case BattleData.SKILL_377:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(754) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.SKILL_359:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                        break;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(615) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.SKILL_285:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1355));
                        this.syncCoolDown();
                        break;
                     case BattleData.EFFECT_CUBE_ILLUSION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(673));
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_TRANSFORM:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2003) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case SenjutsuData.EFFECT_SS_WEAPON_ONLY:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2010) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_REDUCE_CP_MAX:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2012) + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_ACCUM_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2017) + "(" + battleDebuff[key].amount + "%)");
                        break;
                     case BattleData.EFFECT_CP_BLEEDING:
                        this.showOverheadNumber(Timeline.WORD,"CP流失" + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_AGI_REDUCTION:
                        this.showOverheadNumber(Timeline.WORD,"AGI減少" + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_CP_RESTORE_LOCK:
                        this.showOverheadNumber(Timeline.WORD,"CP回復鎖定" + "(" + battleDebuff[key].duration + ")");
                        break;
                     case BattleData.EFFECT_FLAME:
                        this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2024) + "(" + battleDebuff[key].duration + ")");
                  }
                  BLkeyArr = [];
                  BLkey = "";
                  BLkeyArr = key.split(".");
                  if(BLkeyArr)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  effectamt = 0;
                  effectreq = "";
                  effectduration = 0;
                  if(this.battleDebuff[key].amount)
                  {
                     effectamt = this.battleDebuff[key].amount;
                  }
                  if(this.battleDebuff[key].requirement)
                  {
                     effectreq = this.battleDebuff[key].requirement;
                  }
                  if(this.battleDebuff[key].duration)
                  {
                     effectduration = this.battleDebuff[key].duration;
                  }
                  OverHeadWord = "";
                  Sign = "";
                  BLkey = "";
                  BLkeyArr = [];
                  BLkeyArr = key.split(".");
                  if(BLkeyArr && BLkeyArr.length > 0)
                  {
                     BLkey = BLkeyArr[0];
                  }
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     if(BLkeyArr.indexOf("skill1005") >= 0)
                     {
                        BLkey = "";
                     }
                  }
                  if(BLkey && BLkey != "" && effectduration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
                  {
                     if(effectamt > 0)
                     {
                        Sign = "+";
                     }
                     switch(BLkey)
                     {
                        case BloodlineData.EFFECT_ACCURATE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(735);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(287);
                           }
                           break;
                        case BloodlineData.EFFECT_CAPTURE:
                           OverHeadWord = Central.main.langLib.get(736);
                           break;
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_CP:
                           OverHeadWord = Central.main.langLib.get(738);
                           break;
                        case BloodlineData.EFFECT_CONVERT_DMG_HP:
                           OverHeadWord = Central.main.langLib.get(739);
                           break;
                        case BloodlineData.EFFECT_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(740);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(670);
                           }
                           break;
                        case BloodlineData.EFFECT_DODGE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(741);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(799);
                           }
                           break;
                        case BloodlineData.EFFECT_MAX_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MAX_CP_RECOVER:
                           break;
                        case BloodlineData.EFFECT_MAX_HP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                           OverHeadWord = Central.main.langLib.get(743);
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(744);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(800);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(745);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(746);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(801);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(747);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(688);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(802);
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                           effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                           effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                           effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                           effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                           effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                           effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                           effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                           reqArr = null;
                           reqArr = effectreq.split(",");
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(748);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(803);
                           }
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                           OverHeadWord = Central.main.langLib.get(749);
                           break;
                        case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                           OverHeadWord = Central.main.langLib.get(750);
                           break;
                        case BloodlineData.EFFECT_REFLECT_DAMAGE:
                           OverHeadWord = Central.main.langLib.get(751);
                           break;
                        case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                           OverHeadWord = Central.main.langLib.get(752);
                           break;
                        case BloodlineData.EFFECT_STUN:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_CP:
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                           OverHeadWord = "";
                           if(BLkeyArr[1] == "skill1019")
                           {
                              OverHeadWord = "";
                           }
                           break;
                        case BloodlineData.EFFECT_RESTRICT_CHARGE:
                           OverHeadWord = Central.main.langLib.get(754);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(755);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(804);
                           }
                           break;
                        case BloodlineData.EFFECT_RESIST_DEBUFF:
                           OverHeadWord = Central.main.langLib.get(756);
                           break;
                        case BloodlineData.EFFECT_DRAIN_HP:
                           OverHeadWord = Central.main.langLib.get(757);
                           break;
                        case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(758);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(806);
                           }
                           break;
                        case BloodlineData.EFFECT_INTERNAL_INJURY:
                           OverHeadWord = Central.main.langLib.get(648);
                           break;
                        case BloodlineData.EFFECT_RESURRECTION:
                           OverHeadWord = Central.main.langLib.get(759);
                           break;
                        case BloodlineData.EFFECT_COPY_JUTSU:
                           OverHeadWord = Central.main.langLib.get(760);
                           break;
                        case BloodlineData.EFFECT_TITAN:
                           OverHeadWord = Central.main.langLib.get(761);
                           break;
                        case BloodlineData.EFFECT_EXTRA_CP_USE:
                           if(effectamt > 0)
                           {
                              OverHeadWord = Central.main.langLib.get(805);
                           }
                           else
                           {
                              OverHeadWord = Central.main.langLib.get(762);
                           }
                           break;
                        case BloodlineData.EFFECT_EXTREME:
                           OverHeadWord = Central.main.langLib.get(763);
                           break;
                        case BloodlineData.EFFECT_HALLUCINATIONS:
                           OverHeadWord = Central.main.langLib.get(734);
                     }
                     if(OverHeadWord != "")
                     {
                        OverHeadWord = OverHeadWord + "(" + String(effectduration) + ")";
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                              this.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                           }
                           reqArr = null;
                        }
                        else
                        {
                           this.showOverheadNumber(Timeline.WORD,OverHeadWord);
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function setBattleBuff(_effect:Object) : Boolean
      {
         var result:Boolean = false;
         if(this.isBattleBuffActive(_effect.type) && !_effect.duration >= this.getBattleBuff()[_effect.type].duration)
         {
            return result = super.setBattleBuff(_effect);
         }
         switch(_effect.type)
         {
            case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(691)).replace("[valamt]",String(_effect.amount)));
               break;
            case BattleData.EFFECT_ACCURATE_WEAPON:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(685)).replace("[valamt]",String(_effect.amount)));
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(686)).replace("[valamt]",String(_effect.amount)));
               break;
            case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(294)) + String(_effect.amount));
               break;
            case BattleData.EFFECT_DAMAGE_REDUCTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
               break;
            case BattleData.EFFECT_COMBUSTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(357));
               break;
            case BattleData.EFFECT_POISON:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
               break;
            case BattleData.EFFECT_STUN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
               break;
            case BattleData.EFFECT_REDUCE_AGILITY:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1]);
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra");
               Out.debug("CBattle","rex show word < CharacterBattle - setBattleRound()");
               break;
            case BattleData.EFFECT_PET_BURN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288) + " (" + String(_effect.amount) + "%)");
               break;
            case BattleData.EFFECT_PET_FEAR_WEAKEN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
               break;
            case BattleData.EFFECT_PET_FREEZE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(820));
               break;
            case BattleData.EFFECT_PET_WEAKEN:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
               break;
            case BattleData.EFFECT_DISMANTLE:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(816).replace("[valturn]",String(_effect.duration - 1)));
               break;
            case BattleData.EFFECT_CUBE_ILLUSION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(673));
               break;
            case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
               if(int(_effect.amount) == 1)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
               }
               if(int(_effect.amount) == 2)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(676));
               }
               break;
            case BattleData.EFFECT_PUMPKIN_POWER:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1603) + " " + _effect.amount + "%");
               break;
            case BattleData.EFFECT_RECEIVED_DMG_PARRY:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2006));
               break;
            case BattleData.EFFECT_DAMAGE_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
               break;
            case BattleData.EFFECT_CRITICAL_DMG_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747));
               break;
            case BattleData.EFFECT_COMPLETE_GUARD:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
               break;
            case BattleData.EFFECT_PET_ATTENTION:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
               break;
            case BattleData.EFFECT_PET_DAMAGE_BONUS:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
               break;
            case BattleData.EFFECT_PET_DEBUFF_RESIST:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
               break;
            case BattleData.EFFECT_MANA_SHIELD:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594));
         }
         result = super.setBattleBuff(_effect);
         return result;
      }
      
      override public function setBattleDebuff(_effect:Object) : Boolean
      {
         var result:Boolean = false;
         if(this.isBattleDebuffActive(_effect.type) && !_effect.duration >= this.getBattleDebuff()[_effect.type].duration)
         {
            return result = super.setBattleDebuff(_effect);
         }
         switch(_effect.type)
         {
            case BattleData.EFFECT_CHAOS:
               if(_effect.duration > 0)
               {
                  if(Battle.getShowChaos())
                  {
                     Battle.reverseShowChaosChecking();
                     this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(734));
                  }
               }
               break;
            case BattleData.EFFECT_RESTRICT_CHARGE:
               if(_effect.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(754));
               }
               break;
            case BattleData.EFFECT_SLEEP:
               if(_effect.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
               }
               break;
            case BattleData.EFFECT_TRANSFORM:
               if(_effect.duration > 0)
               {
                  this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2003));
               }
               break;
            case BattleData.EFFECT_BLEEDING:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(_effect.amount) + "%)");
               break;
            case BattleData.EFFECT_ACCUM_BLEEDING:
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2017));
               break;
            case BattleData.EFFECT_BURNING:
               this.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(379)).replace("([valamount])",""));
               break;
            case BattleData.EFFECT_CP_BLEEDING:
               this.showOverheadNumber(Timeline.WORD,"CP流失(" + _effect.amount + "%)");
               break;
            case BattleData.EFFECT_AGI_REDUCTION:
               this.showOverheadNumber(Timeline.WORD,"AGI減少");
               break;
            case BattleData.EFFECT_CP_RESTORE_LOCK:
               this.showOverheadNumber(Timeline.WORD,"CP回復鎖定");
         }
         result = super.setBattleDebuff(_effect);
         return result;
      }
      
      private function showWord_nextBattleRound(effectTypeStr:String, showWordStr:String) : *
      {
         var key:* = undefined;
         if(showWordStr == "")
         {
            return;
         }
         var weaponData:Object = Central.main.WEAPON_DATA.find(this.getWeapon());
         var effectArr:* = weaponData.effect;
         var duration:int = 0;
         for(key in effectArr)
         {
            if(effectArr[key].type == effectTypeStr)
            {
               duration = effectArr[key].duration;
               break;
            }
         }
         if(duration >= 999)
         {
            this.showOverheadNumber(Timeline.WORD,showWordStr);
         }
         else
         {
            this.showOverheadNumber(Timeline.WORD,showWordStr + " (" + duration + ")");
         }
      }
      
      private function showWord_setBuff(effectTypeStr:String, showWordStr:String) : *
      {
         if(showWordStr == "")
         {
            return;
         }
         this.showOverheadNumber(Timeline.WORD,showWordStr);
      }
      
      private function showWord_setDeuff(effectTypeStr:String, showWordStr:String) : *
      {
         if(showWordStr == "")
         {
            return;
         }
         this.showOverheadNumber(Timeline.WORD,showWordStr);
      }
   }
}
