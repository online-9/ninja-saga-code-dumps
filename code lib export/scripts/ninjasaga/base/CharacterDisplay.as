package ninjasaga.base
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.filters.GlowFilter;
   import flash.filters.ColorMatrixFilter;
   import com.utils.Out;
   import com.utils.NumberUtil;
   import com.utils.GF;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.Central;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.SenjutsuData;
   import com.utils.Sha1Encrypt;
   import ninjasaga.Main;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.Timeline;
   import ninjasaga.Battle;
   import ninjasaga.data.TitleData;
   import flash.text.TextField;
   import ninjasaga.data.RankData;
   import ninjasaga.data.Data;
   import ninjasaga.data.Formula;
   import flash.events.MouseEvent;
   import flash.display.DisplayObject;
   import ninjasaga.data.PositionType;
   import com.utils.CreateFilter;
   
   public class CharacterDisplay extends CharacterBase
   {
       
      
      protected var swf:MovieClip;
      
      protected var actionBase:MovieClip;
      
      protected var skillSwfArr:Array;
      
      protected var bloodlineSwfArr:Array;
      
      protected var secretSwfArr:Array;
      
      protected var classSkillSwfArr:Array;
      
      protected var senjutsuSwfArr:Array;
      
      public var charMc:MovieClip;
      
      public var charOrigPoint:Point = null;
      
      public var charHitPoint:Point = null;
      
      public var speedBonus:int = 0;
      
      protected var battleAction_CB:Function = null;
      
      protected var battleAttackHit_CB:Function = null;
      
      public var atbTimer:uint = 0;
      
      protected var _clanEffect:Object;
      
      protected var threat:Object;
      
      protected var enemyGlowFilter:GlowFilter;
      
      protected var commandGlowFilter:GlowFilter;
      
      private var dimFilter:ColorMatrixFilter;
      
      private var anni4Enemy:Array;
      
      public var isPlayingAnimation:Boolean = false;
      
      private var hpHashString:String;
      
      private var cpHashString:String;
      
      private var spHashString:String;
      
      protected var BG_elemental:int = 0;
      
      protected var elemental_Mode:int = 0;
      
      protected var SufferDamageModifier:uint = 100;
      
      protected var DealDamageModifier:uint = 100;
      
      public var checkTitanRes:Boolean = false;
      
      public var titanRes:Boolean = false;
      
      public var resurrection:Boolean = false;
      
      protected var fuckNoBloodline:Boolean = false;
      
      public var waitingForCommand:Boolean = false;
      
      public var lastBattleAction:Object;
      
      public var pendingSkills:Array;
      
      public var skill_2003_lv:int = 0;
      
      private var buttonEnableArr:Array;
      
      private var skillButtonEnableArr:Array;
      
      private var senjutsuButtonEnableArr:Array;
      
      private var bloodlineButtonEnableArr:Array;
      
      private var secretButtonEnableArr:Array;
      
      public var startResurrection:Boolean = false;
      
      public function CharacterDisplay()
      {
         swf = new MovieClip();
         skillSwfArr = new Array();
         bloodlineSwfArr = new Array();
         secretSwfArr = new Array();
         classSkillSwfArr = new Array();
         senjutsuSwfArr = new Array();
         _clanEffect = {};
         threat = {};
         enemyGlowFilter = CreateFilter.getGlowFilter();
         commandGlowFilter = CreateFilter.getGlowFilter({"color":16777215});
         dimFilter = CreateFilter.getSaturationFilter(0);
         anni4Enemy = ["enemy293","enemy294","enemy295","enemy296","enemy297","enemy298"];
         buttonEnableArr = [true,true,true,true];
         skillButtonEnableArr = [true,true,true,true,true,true,true,true];
         senjutsuButtonEnableArr = [false,false,false,false,false,false,false,false];
         bloodlineButtonEnableArr = [true,true,true,true];
         secretButtonEnableArr = [true,true,true,true];
         super();
      }
      
      public function getSwf() : MovieClip
      {
         this.restoreScale();
         return this.swf;
      }
      
      public function setCharMc(_mc:MovieClip) : void
      {
         this.charMc = _mc;
         if(_mc != null)
         {
            resetCharMc();
         }
      }
      
      public function resetCharMc() : void
      {
         var tmpMc:MovieClip = null;
         var skillIdxArr:Array = null;
         var j:int = 0;
         var i:int = 0;
         var pos:int = 0;
         var rand:int = 0;
         if(this.charMc == null)
         {
            Out.debug("CharacterDisplay ","");
         }
         Out.debug("characterDisplay"," charMC >> " + this.charMc);
         Out.debug("characterDisplay"," charMC >> " + this.charMc.parent);
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         var arrName:Array = battleFrame.name.split("_");
         if(arrName[0].indexOf("enemyMc") >= 0)
         {
            tmpMc = battleFrame.parent["detail_box_" + arrName[1]];
            (tmpMc as MovieClip).visible = false;
            skillIdxArr = new Array();
            for(j = 0; j < skillSwfArr.length; j++)
            {
               skillIdxArr.push(j);
            }
            for(i = 0; i < 4; i++)
            {
               pos = i + 1;
               if(i < skillSwfArr.length)
               {
                  rand = Math.floor(NumberUtil.getRandom() * skillIdxArr.length);
                  tmpMc["skill_" + pos]["holder"].addChild(skillSwfArr[skillIdxArr[rand]].getAsset("icon"));
                  skillIdxArr.splice(rand,1);
               }
               else
               {
                  (tmpMc["skill_" + pos] as MovieClip).visible = false;
               }
            }
         }
         initSkill2003Lv();
      }
      
      public function getHitArea() : Object
      {
         if(this.actionBase == null)
         {
            Out.error(this,"getHitArea :: action base is null");
         }
         if(this.actionBase["hitAreaMc"] == null)
         {
            Out.error(this,"getHitArea :: hit area is null");
         }
         return {
            "width":this.actionBase["hitAreaMc"].width,
            "height":this.actionBase["hitAreaMc"].height
         };
      }
      
      public function get hitArea() : MovieClip
      {
         if(this.actionBase == null)
         {
            Out.error(this,"hitArea :: action base is null");
         }
         if(this.actionBase["hitAreaMc"] == null)
         {
            Out.error(this,"hitArea :: hit area is null");
         }
         return this.actionBase["hitAreaMc"];
      }
      
      public function isHitObject(_mc:MovieClip) : Boolean
      {
         if(this.swf != null && _mc != null)
         {
            return this.swf.hitTestObject(_mc);
         }
         return false;
      }
      
      public function removeParent() : void
      {
         GF.removeParent(this.swf);
         this.clearSwf();
         this.swf.stop();
      }
      
      public function setScale(_scale:Number) : void
      {
         this.swf.scaleX = this.swf.scaleX * _scale;
         this.swf.scaleY = this.swf.scaleY * Math.abs(_scale);
      }
      
      public function restoreScale() : void
      {
         this.swf.scaleX = 1;
         this.swf.scaleY = 1;
         this.swf.x = 0;
         this.swf.y = 0;
      }
      
      public function getCloseup() : MovieClip
      {
         var closeupMc:MovieClip = GF.cloneAsBitmap(this.actionBase["head"],1,25,25);
         closeupMc.scaleX = closeupMc.scaleX * -1;
         closeupMc.x = closeupMc.x + closeupMc.width;
         return closeupMc;
      }
      
      public function getHalfBody(factor:Number = 1, offsetX:Number = 115, offsetY:Number = 250, width:Number = 100, height:Number = 150) : MovieClip
      {
         var halfBodyMc:MovieClip = GF.cloneAsBitmap(this.actionBase,factor,offsetX,offsetY,{
            "width":width,
            "height":height
         });
         return halfBodyMc;
      }
      
      public function moveToFront() : void
      {
         if(this.charMc != null)
         {
            GF.moveToFront(MovieClip(this.charMc.parent));
         }
      }
      
      public function getCharacterName() : String
      {
         return this.dbChar.character_name;
      }
      
      public function setCharacterName(newName:String) : void
      {
         this.dbChar.character_name = newName;
      }
      
      public function getName() : String
      {
         return this.dbChar.character_name;
      }
      
      public function restoreOriginalStatus() : void
      {
         if(this.getData(DBCharacterData.SESSION_PLAYTIME) == -1)
         {
            this.updateHP(0 - this.maxHP);
            this.updateHP(this.maxHP / 2);
            this.updateCP(0 - this.maxCP);
            this.updatePetCP(0 - this.petMaxCP);
         }
         else
         {
            this.updateHP(this.maxHP);
            this.updateCP(this.maxCP);
            this.updateSP(-this.maxSP);
            this.updatePetCP(this.petMaxCP);
         }
      }
      
      public function pvpPlayerDisconnect() : void
      {
         var mc:MovieClip = new MovieClip();
         mc = Central.main.getLib("disconnect_Icon");
         var charHolder:MovieClip = Central.battle.getCharacterHolder(this.getData(DBCharacterData.ID));
         charHolder["disconnect_holder"].addChild(mc);
         if(this.swf.scaleX > 0)
         {
         }
         if(this.isDead == true)
         {
         }
      }
      
      public function removePvpPlayerDisconnectIcon() : void
      {
         this.charMc.parent["disconnect_holder"].removeChildAt(0);
      }
      
      public function SetBloodlinePassiveSkill() : void
      {
         var i:int = 0;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var bloodline:Array = this.dbChar.bloodline;
         var bl_effect_1:Object = {};
         var bl_effect_2:Object = {};
         var bl_effect_3:Object = {};
         Out.debug("characterDisplay","SetBloodlinePassiveSkill ");
         if(bloodline)
         {
            for(i = 0; i < bloodline.length; i++)
            {
               skill_id = bloodline[i].skill_id;
               level = bloodline[i].level;
               for(k = 0; k < Central.main.BLOODLINE_SKILL_DATA_ARR.length; k++)
               {
                  if(Central.main.BLOODLINE_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && Central.main.BLOODLINE_SKILL_DATA_ARR[k].bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                  {
                     effect = Central.main.BLOODLINE_SKILL_DATA_ARR[k].effect;
                     for(j = 0; j < effect.length; j++)
                     {
                        if(effect[j].skill_level == level)
                        {
                           if(effect[j].effect_type_1)
                           {
                              bl_effect_1 = {};
                              bl_effect_1.type = effect[j].effect_type_1;
                              bl_effect_1.duration = effect[j].duration_1;
                              bl_effect_1.target = effect[j].effect_target_1;
                              bl_effect_1.chancetohit = effect[j].effect_chancetohit_1;
                              bl_effect_1.chancetoeffect = effect[j].effect_chancetoeffect_1;
                              bl_effect_1.requirement = effect[j].effect_requirement_1;
                              bl_effect_1.amount = effect[j].effect_amount_1;
                              SetBloodlineBuffOrDebuffEffect(bl_effect_1,String("skill" + skill_id));
                           }
                           if(effect[j].effect_type_2)
                           {
                              bl_effect_2 = {};
                              bl_effect_2.type = effect[j].effect_type_2;
                              bl_effect_2.duration = effect[j].duration_2;
                              bl_effect_2.target = effect[j].effect_target_2;
                              bl_effect_2.chancetohit = effect[j].effect_chancetohit_2;
                              bl_effect_2.chancetoeffect = effect[j].effect_chancetoeffect_2;
                              bl_effect_2.requirement = effect[j].effect_requirement_2;
                              bl_effect_2.amount = effect[j].effect_amount_2;
                              SetBloodlineBuffOrDebuffEffect(bl_effect_2,String("skill" + skill_id));
                           }
                           if(effect[j].effect_type_3)
                           {
                              bl_effect_3 = {};
                              bl_effect_3.type = effect[j].effect_type_3;
                              bl_effect_3.duration = effect[j].duration_3;
                              bl_effect_3.target = effect[j].effect_target_3;
                              bl_effect_3.chancetohit = effect[j].effect_chancetohit_3;
                              bl_effect_3.chancetoeffect = effect[j].effect_chancetoeffect_3;
                              bl_effect_3.requirement = effect[j].effect_requirement_3;
                              bl_effect_3.amount = effect[j].effect_amount_3;
                              SetBloodlineBuffOrDebuffEffect(bl_effect_3,String("skill" + skill_id));
                           }
                        }
                     }
                     break;
                  }
               }
            }
         }
      }
      
      public function SetSenjutsuPassiveSkill() : void
      {
         var i:int = 0;
         var skill_id:int = 0;
         var level:int = 0;
         var k:int = 0;
         var effect:Array = null;
         var j:int = 0;
         var senjutsu:Array = this.dbChar.senjutsu;
         var sen_effect_1:Object = {};
         var sen_effect_2:Object = {};
         var sen_effect_3:Object = {};
         Out.debug("characterDisplay","SetSenjutsuPassiveSkill ");
         if(senjutsu)
         {
            for(i = 0; i < senjutsu.length; i++)
            {
               skill_id = senjutsu[i].skill_id;
               level = senjutsu[i].level;
               for(k = 0; k < Central.main.SENJUTSU_SKILL_DATA_ARR.length; k++)
               {
                  if(Central.main.SENJUTSU_SKILL_DATA_ARR[k].skill_id == String("skill" + skill_id) && Central.main.SENJUTSU_SKILL_DATA_ARR[k].senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                  {
                     effect = Central.main.SENJUTSU_SKILL_DATA_ARR[k].effect;
                     for(j = 0; j < effect.length; j++)
                     {
                        if(effect[j].skill_level == level)
                        {
                           if(effect[j].effect_type_1)
                           {
                              sen_effect_1 = {};
                              sen_effect_1.type = effect[j].effect_type_1;
                              sen_effect_1.duration = effect[j].duration_1;
                              sen_effect_1.target = effect[j].effect_target_1;
                              sen_effect_1.chancetohit = effect[j].effect_chancetohit_1;
                              sen_effect_1.chancetoeffect = effect[j].effect_chancetoeffect_1;
                              sen_effect_1.requirement = effect[j].effect_requirement_1;
                              sen_effect_1.amount = effect[j].effect_amount_1;
                              SetSenjutsuBuffOrDebuffEffect(sen_effect_1,String("skill" + skill_id));
                           }
                           if(effect[j].effect_type_2)
                           {
                              sen_effect_2 = {};
                              sen_effect_2.type = effect[j].effect_type_2;
                              sen_effect_2.duration = effect[j].duration_2;
                              sen_effect_2.target = effect[j].effect_target_2;
                              sen_effect_2.chancetohit = effect[j].effect_chancetohit_2;
                              sen_effect_2.chancetoeffect = effect[j].effect_chancetoeffect_2;
                              sen_effect_2.requirement = effect[j].effect_requirement_2;
                              sen_effect_2.amount = effect[j].effect_amount_2;
                              SetSenjutsuBuffOrDebuffEffect(sen_effect_2,String("skill" + skill_id));
                           }
                           if(effect[j].effect_type_3)
                           {
                              sen_effect_3 = {};
                              sen_effect_3.type = effect[j].effect_type_3;
                              sen_effect_3.duration = effect[j].duration_3;
                              sen_effect_3.target = effect[j].effect_target_3;
                              sen_effect_3.chancetohit = effect[j].effect_chancetohit_3;
                              sen_effect_3.chancetoeffect = effect[j].effect_chancetoeffect_3;
                              sen_effect_3.requirement = effect[j].effect_requirement_3;
                              sen_effect_3.amount = effect[j].effect_amount_3;
                              SetSenjutsuBuffOrDebuffEffect(sen_effect_3,String("skill" + skill_id));
                           }
                        }
                     }
                     break;
                  }
               }
            }
         }
      }
      
      public function SetBloodlineBuffOrDebuffEffect(effect:Object, bloodlineskillID:String) : void
      {
         var not_stack_array:Array = [];
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
         switch(int(effect.target))
         {
            case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
               if(effect.type != BloodlineData.EFFECT_MAX_HP && effect.type != BloodlineData.EFFECT_MAX_CP && effect.type != BloodlineData.EFFECT_SPEED)
               {
                  this.setBattleBuff(effect);
               }
         }
      }
      
      public function SetSenjutsuBuffOrDebuffEffect(effect:Object, senjutsuskillID:String) : void
      {
         var not_stack_array:Array = [];
         switch(int(effect.target))
         {
            case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
               if(effect.type != SenjutsuData.EFFECT_SS_MAX_HP)
               {
                  this.setBattleBuff(effect);
               }
         }
      }
      
      public function syncHp(_value:int) : void
      {
         var hp:int = _value;
         if(hp < 0)
         {
            hp = 0;
         }
         if(hp > this.maxHP)
         {
            hp = this.maxHP;
         }
         this.hpHashString = Sha1Encrypt.encrypt(String(hp));
         this.updateData(DBCharacterData.HP,hp);
      }
      
      public function syncCp(_value:int) : void
      {
         var cp:int = _value;
         if(cp < 0)
         {
            cp = 0;
         }
         if(cp > this.maxCP)
         {
            cp = this.maxCP;
         }
         this.cpHashString = Sha1Encrypt.encrypt(String(cp));
         this.updateData(DBCharacterData.CP,cp);
      }
      
      public function syncSp(_value:int) : void
      {
         var sp:int = _value;
         if(sp < 0)
         {
            sp = 0;
         }
         if(sp > this.maxSP)
         {
            sp = this.maxSP;
         }
         this.spHashString = Sha1Encrypt.encrypt(String(sp));
         this.updateData(DBCharacterData.SP,sp);
      }
      
      override public function updateHP(_value:int) : uint
      {
         if(!this.hpCheck())
         {
            Main.onError();
         }
         var hp:int = super.updateHP(_value);
         this.hpHashString = Sha1Encrypt.encrypt(String(hp));
         if(_value < 0)
         {
            this.removeDebuff(BattleData.EFFECT_SLEEP);
         }
         return hp;
      }
      
      protected function hpCheck() : Boolean
      {
         var _hpHashString:String = null;
         if(this.hpHashString)
         {
            _hpHashString = Sha1Encrypt.encrypt(String(hp));
            if(_hpHashString == this.hpHashString)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      public function updateCP(_value:int, _isCausedByEnemyAttack:Boolean = false, _attacker:* = null) : uint
      {
         var cp:int = this.getData(DBCharacterData.CP);
         if(!this.cpCheck())
         {
            Main.onError();
         }
         var origCP:int = cp;
         cp = cp + _value;
         if(cp < 0)
         {
            cp = 0;
         }
         if(cp > this.maxCP)
         {
            cp = this.maxCP;
         }
         var ModifyCPPercent:Number = this.getBloodlineCPMax();
         var MaxCPBL:Number = this.maxCP * ModifyCPPercent / 100;
         if(cp > this.maxCP + MaxCPBL)
         {
            cp = this.maxCP + MaxCPBL;
         }
         if(cp > this.maxCP)
         {
            cp = this.maxCP;
         }
         var finalCP:int = cp;
         var effectiveCPChange:int = finalCP - origCP;
         this.cpHashString = Sha1Encrypt.encrypt(String(cp));
         if(Central.battle.type != Central.battle.TYPE_NETWORK)
         {
            if(_isCausedByEnemyAttack && _attacker)
            {
               this.triggerFeedbackOnUpdateCP(_attacker,_value,effectiveCPChange);
            }
         }
         this.updateData(DBCharacterData.CP,cp);
         if(cp < 0)
         {
            cp = 0;
         }
         return cp;
      }
      
      protected function cpCheck() : Boolean
      {
         var _cpHashString:String = null;
         if(this.cpHashString)
         {
            _cpHashString = Sha1Encrypt.encrypt(String(cp));
            if(_cpHashString == this.cpHashString)
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      public function Add_Dbchar_Bloodline(Bloodline_skill:Array) : void
      {
         this.dbChar.bloodline = Bloodline_skill;
      }
      
      public function Add_Dbchar_Senjutsu(Senjutsu_skill:Array) : void
      {
         this.dbChar.senjutsu = Senjutsu_skill;
      }
      
      public function Get_Dbchar_Bloodline() : Array
      {
         return this.dbChar.bloodline;
      }
      
      public function Get_Dbchar_Senjutsu() : Array
      {
         return this.dbChar.senjutsu;
      }
      
      public function getSpecialClass() : uint
      {
         return this.dbChar[DBCharacterData.CONTROL];
      }
      
      protected function actionFinish_CB() : void
      {
         var i:int = 0;
         var reallyDead:Boolean = false;
         var adminArr:Array = null;
         var hackDamageArr:Array = null;
         var battleRound:int = 0;
         var checkHackDmgRounds:uint = 0;
         var defenderToLog:* = undefined;
         var attackerToLog:* = undefined;
         var damageWeaponEffect:Object = null;
         var unlawfulWeaponInstantKill:Boolean = false;
         var tmpEffect:Object = null;
         var amount:int = 0;
         var attackPoint:Point = null;
         var reflectBattleaction:Object = null;
         var defender:* = undefined;
         var attacker:* = undefined;
         var resurrectionChar:* = undefined;
         var blSkillID:String = null;
         var blSkillObj:Object = null;
         var blData:Object = null;
         var effect:Object = null;
         var j:int = 0;
         var charBloodline:Array = null;
         var MAX_SKILL_EFFECT_LENGTH:int = 0;
         var k:int = 0;
         var skillEffect:Object = null;
         Central.main.getMainChar().securityCheck();
         var battleAction:Object = Central.battle.getAttacker().getBattleAction();
         if(Central.battle.seal_enemy && Central.main.actionChecker)
         {
            Central.main.actionChecker = false;
            Central.battle.getDefender().isDead = true;
            Central.battle.getDefender().playDead();
            this.isPlayingAnimation = false;
            battleAction.titan = false;
            return;
         }
         if(this.hp > 0)
         {
            if(this.startResurrection == false)
            {
               this.playStandby();
            }
         }
         else if(!this.isDead)
         {
            reallyDead = true;
            if(battleAction)
            {
               if(battleAction.resurrectionObj)
               {
                  if(battleAction.resurrectionObj[this.getCharacterId()] != null)
                  {
                     reallyDead = false;
                  }
               }
            }
            if(reallyDead)
            {
               this.isDead = true;
               battleAction.titan = false;
               if(this.limb && this.limb > 1)
               {
                  this.playStandby();
                  this.actionFinish_CB();
                  return;
               }
               this.playDead();
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  Main.achievement.updateBattleStat(Main.achievementData.DEATH,1);
               }
               adminArr = [30714278,30714554,47864495,44490146,55951532,8333357,56291997,9300982,29675282,103195,62998342,62299565,62543662,64183147,64053942,64986164,31935389,63586083,40248560,64676239,30712310,65152595,64978655,67190509,65152634,66764216,66965816,66108746,65152630,66966519,65152642];
               hackDamageArr = [20000,32985,48257,65425,70254,71581,72485,125463];
               battleRound = Central.battle.battleRoundCounter;
               checkHackDmgRounds = 8;
               if(battleRound > checkHackDmgRounds)
               {
                  battleRound = checkHackDmgRounds;
               }
               defenderToLog = Central.battle.getDefender();
               attackerToLog = Central.battle.getAttacker();
               damageWeaponEffect = Central.main.WEAPON_DATA.find(attackerToLog.getWeapon());
               unlawfulWeaponInstantKill = true;
               if(damageWeaponEffect && damageWeaponEffect.effect)
               {
                  for(i = 0; i < damageWeaponEffect.effect.length; i++)
                  {
                     tmpEffect = damageWeaponEffect.effect[i];
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                           amount = tmpEffect.amount;
                           if(defenderToLog.hp <= defenderToLog.maxHP * tmpEffect.amount / 100)
                           {
                              if(Central.battle.battleDamageLog > -(defenderToLog.maxHP + 1) * 4)
                              {
                                 unlawfulWeaponInstantKill = false;
                              }
                           }
                     }
                  }
               }
               if(battleAction.effect)
               {
                  if(battleAction.effect.type == BattleData.INSTANT_KILL && Central.battle.battleDamageLog > -(defenderToLog.maxHP * 4 + 1))
                  {
                     unlawfulWeaponInstantKill = false;
                  }
                  if(battleAction.effect.type == BattleData.INSTANT_CUT_HALF_HP && Central.battle.battleDamageLog > -(defenderToLog.maxHP * 2 + 1))
                  {
                     unlawfulWeaponInstantKill = false;
                  }
               }
               return;
            }
         }
         if(this.charOrigPoint != null)
         {
            this.charMc.x = this.charOrigPoint.x;
            this.charMc.y = this.charOrigPoint.y;
            this.charOrigPoint = null;
         }
         if(battleAction == null)
         {
            Out.debug("CharacterDisplay","startResurrection n");
         }
         if(battleAction.resurrectionObj != null && battleAction.resurrectionObj[this.getCharacterId()] != null)
         {
            if(battleAction.titan == false && this.startResurrection == false)
            {
               this.startResurrection = true;
               this.fuckNoBloodline = true;
               attackPoint = null;
               reflectBattleaction = {};
               defender = Central.battle.getDefender();
               attacker = Central.battle.getAttacker();
               if(Central.battle.type == Central.battle.TYPE_NETWORK)
               {
                  if(battleAction.resurrectionObj[this.getCharacterId()] != null)
                  {
                     if(this.getCharacterId() == Main.getMainChar().getCharacterId())
                     {
                        Central.main.resurrection = true;
                     }
                  }
               }
               attackPoint = new Point(0,0);
               blSkillID = "";
               blSkillObj = {};
               blData = {};
               effect = {};
               trace("Phillip:this.getCharacterId()" + this.getCharacterId());
               trace("Phillip:attacker.getCharacterId()" + attacker.getCharacterId());
               trace("Phillip:defender.getCharacterId()" + defender.getCharacterId());
               trace("Phillip:battleAction.resurrectionObj[this.getCharacterId()]" + battleAction.resurrectionObj[this.getCharacterId()]);
               if(this.getCharacterId() == attacker.getCharacterId())
               {
                  resurrectionChar = attacker;
               }
               else if(this.getCharacterId() == defender.getCharacterId())
               {
                  resurrectionChar = defender;
               }
               else
               {
                  resurrectionChar = Central.battle.getCharacterById(this.getCharacterId());
               }
               if(resurrectionChar.getBloodline())
               {
                  charBloodline = resurrectionChar.getBloodline();
                  MAX_SKILL_EFFECT_LENGTH = 3;
                  for(i = 0; i < charBloodline.length; i++)
                  {
                     blSkillObj = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + charBloodline[i].skill_id];
                     for(k = 0; k < blSkillObj.effect.length; k++)
                     {
                        if(blSkillObj.effect[k].skill_level == charBloodline[i].level)
                        {
                           skillEffect = blSkillObj.effect[k];
                           break;
                        }
                     }
                     for(j = 1; j < MAX_SKILL_EFFECT_LENGTH + 1; j++)
                     {
                        switch(skillEffect["effect_type_" + j])
                        {
                           case BloodlineData.EFFECT_RESURRECTION:
                              blData.id = "skill" + charBloodline[i].skill_id;
                              blData.level = charBloodline[i].level;
                              blData.type = Central.main.BLOODLINE_DATA["bloodline" + charBloodline[i].bloodline_id].type;
                              blData.location = i;
                              blData.posType = blSkillObj.postype;
                              this.setActiveBuff({});
                              break;
                           case BloodlineData.EFFECT_REBORN:
                              blData.id = "skill" + charBloodline[i].skill_id;
                              blData.level = charBloodline[i].level;
                              blData.type = Central.main.BLOODLINE_DATA["bloodline" + charBloodline[i].bloodline_id].type;
                              blData.posType = blSkillObj.postype;
                              blData.location = i;
                              this.setActiveBuff({});
                              effect.type = String(skillEffect["effect_type_2"]);
                              effect.duration = int(skillEffect["duration_2"]);
                              effect.target = int(skillEffect["effect_target_2"]);
                              effect.amount = int(skillEffect["effect_amount_2"]);
                              effect.chancetohit = int(skillEffect["effect_chancetohit_2"]);
                              effect.chancetoeffect = int(skillEffect["effect_chancetoeffect_2"]);
                              this.setBattleBuff(effect);
                              effect.type = String(skillEffect["effect_type_3"]);
                              effect.duration = int(skillEffect["duration_3"]);
                              effect.target = int(skillEffect["effect_target_3"]);
                              effect.amount = int(skillEffect["effect_amount_3"]);
                              effect.chancetohit = int(skillEffect["effect_chancetohit_3"]);
                              effect.chancetoeffect = int(skillEffect["effect_chancetoeffect_3"]);
                              this.setBattleBuff(effect);
                        }
                     }
                  }
                  reflectBattleaction = {
                     "action":"bloodline",
                     "skillId":blData.location,
                     "posType":blData.posType,
                     "cp":0,
                     "dmg":0,
                     "effect":{},
                     "BLSKILLID":blData.id,
                     "BLTYPE":blData.type
                  };
                  battleAction.copyJutsu = false;
                  this.playBloodline(reflectBattleaction,attackPoint);
                  this.showOverheadNumber(Timeline.WORD,"+" + battleAction.resurrectionObj[this.getCharacterId()].hp + " " + String(Central.main.langLib.get(483)).replace("+",""));
                  this.showOverheadNumber(Timeline.WORD,"+" + battleAction.resurrectionObj[this.getCharacterId()].cp + " " + String(Central.main.langLib.get(350)).replace("+",""));
                  if(Battle.type == Battle.TYPE_NETWORK)
                  {
                     attacker.resetBuff();
                     defender.resetBuff();
                     this.updateHP(battleAction.resurrectionObj[this.getCharacterId()].hp);
                     this.updateCP(battleAction.resurrectionObj[this.getCharacterId()].cp);
                     this.setActiveBuff({});
                     this.setActiveDebuff({});
                  }
                  battleAction.resurrectionObj[this.getCharacterId()] = null;
                  resurrectionChar.setBattleAction(battleAction);
               }
               return;
            }
            titanRes = false;
         }
         else if(startResurrection == true)
         {
            startResurrection = false;
         }
         if(startResurrection == false)
         {
            this.isPlayingAnimation = false;
            if(this.battleAction_CB != null)
            {
               this.battleAction_CB();
            }
         }
      }
      
      protected function attackHit_CB() : void
      {
         this.moveToHitBox();
         if(this.battleAttackHit_CB != null)
         {
            this.battleAttackHit_CB();
         }
      }
      
      public function moveToHitBox() : void
      {
         if(this.charHitPoint != null)
         {
            this.charMc.x = this.charHitPoint.x;
            this.charMc.y = this.charHitPoint.y;
            this.charHitPoint = null;
         }
      }
      
      public function setBattleActionCB(_cb:Function) : void
      {
         this.battleAction_CB = _cb;
      }
      
      public function setBattleAttackHitCB(_cb:Function) : void
      {
         this.battleAttackHit_CB = _cb;
      }
      
      public function updateBattleFrame() : void
      {
         var tmpMc:MovieClip = null;
         var displayHP:* = null;
         var displayMaxHP:* = null;
         var displayCP:* = null;
         var displayMaxCP:* = null;
         if(this.charMc == null)
         {
            Out.error(this,"updateBattleFrame :: charMc is null");
            return;
         }
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(battleFrame == null)
         {
            Out.error(this,"updateBattleFrame :: battleFrame is null");
            return;
         }
         battleFrame["nameTxt"].text = Central.main.langLib.titleTxt(TitleData.LV) + this.getLevel() + " " + this.getCharacterName();
         battleFrame["hpBar"].scaleX = this.hp / this.maxHP;
         if(this.anni4Enemy.indexOf(Central.battle.bossId) >= 0 && battleFrame.name == "enemyMc_1")
         {
            battleFrame["hpBar"].filters = [this.dimFilter];
         }
         else
         {
            battleFrame["hpBar"].filters = null;
         }
         var arrMcName:Array = battleFrame.name.split("_");
         if(arrMcName[0].indexOf("enemyMc") >= 0)
         {
            tmpMc = battleFrame.parent["detail_box_" + arrMcName[1]];
            tmpMc.visible = false;
            displayHP = "";
            displayMaxHP = "";
            displayCP = "";
            displayMaxCP = "";
            if(this.hp >= 10000)
            {
               displayHP = Math.round(this.hp / 1000) + "k";
            }
            else
            {
               displayHP = String(this.hp);
            }
            if(this.maxHP >= 10000)
            {
               displayMaxHP = Math.round(this.maxHP / 1000) + "k";
            }
            else
            {
               displayMaxHP = String(this.maxHP);
            }
            if(this.cp >= 10000)
            {
               displayCP = Math.round(this.cp / 1000) + "k";
            }
            else
            {
               displayCP = String(this.cp);
            }
            if(this.hp >= 10000)
            {
               displayMaxCP = Math.round(this.maxCP / 1000) + "k";
            }
            else
            {
               displayMaxCP = String(this.maxCP);
            }
            (tmpMc["txt_hp"] as TextField).text = displayHP + "/" + displayMaxHP;
            (tmpMc["txt_cp"] as TextField).text = displayCP + "/" + displayMaxCP;
         }
         if(Central.main.getMainChar().pet)
         {
            if(arrMcName[0].indexOf("playerPetMc") >= 0)
            {
               if(this.petMaxEp > 0)
               {
                  battleFrame.parent["petStatus"].visible = true;
                  battleFrame.parent["petStatus"]["hpTxt"].text = this.hp + "/" + this.maxHP;
                  battleFrame.parent["petStatus"]["cpTxt"].text = this.petCP + "/" + this.petMaxCP;
                  battleFrame.parent["petStatus"]["hpBar"].scaleX = this.hp / this.maxHP;
                  battleFrame.parent["petStatus"]["cpBar"].scaleX = this.petCP / this.petMaxCP;
               }
               else
               {
                  battleFrame.parent["petStatus"].visible = false;
               }
            }
         }
         else
         {
            battleFrame.parent["petStatus"].visible = false;
         }
         if(RankData.ALL_RANK.indexOf(this.getData(DBCharacterData.RANK)) >= 0)
         {
            battleFrame["rankIcon"].gotoAndStop(this.getData(DBCharacterData.RANK));
         }
         else
         {
            battleFrame["rankIcon"].visible = false;
         }
      }
      
      public function showOverheadNumber(_type:String, _str:String) : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         battleFrame["ohNumber"].showNumber(_type,_str);
         var hitArea:Object = this.getHitArea();
         if(this.swf.scaleX > 0)
         {
            battleFrame["ohNumber"].x = this.charMc.x - hitArea.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         else
         {
            battleFrame["ohNumber"].x = this.charMc.x + hitArea.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         battleFrame["ohNumber"].y = this.charMc.y - hitArea.height * Data.BATTLE_CHAR_SCALE;
      }
      
      public function resetBattleData() : void
      {
         this.battleSkillCooldown = {};
         this.battleBuff = {};
         this.battleDebuff = {};
         this.atbTimer = 0;
         this.isPlayingAnimation = false;
         this.clanEffect = {};
         this.threat = {};
         this.senjustuSkillFirstUseArr = [];
         this.damageShield = 0;
      }
      
      public function setElemental(elemental:int) : void
      {
         this.BG_elemental = elemental;
      }
      
      public function getElemental() : Object
      {
         return this.BG_elemental;
      }
      
      public function setElemental_Mode(elemental:int) : void
      {
         this.elemental_Mode = elemental;
      }
      
      public function getElemental_Mode() : Object
      {
         return this.elemental_Mode;
      }
      
      public function setSufferDamageModifier(damage:uint) : void
      {
         this.SufferDamageModifier = damage;
      }
      
      public function getSufferDamageModifier() : Object
      {
         return this.SufferDamageModifier;
      }
      
      public function setDealDamageModifier(damage:uint) : void
      {
         this.DealDamageModifier = damage;
      }
      
      public function getDealDamageModifier() : Object
      {
         return this.DealDamageModifier;
      }
      
      public function setThreat(_attacker:Object, _dmg:int = 0, _heal:int = 0, _effect:Object = null, _Other:String = "") : void
      {
         var threatObj:Object = null;
         var Modifier_Level:int = 200;
         var Modifier_MaxHP:int = 5;
         var Modifier_Damage:int = 5;
         var Modifier_Heal:int = 20;
         var Modifier_SpecialEffect:int = 1500;
         var Modifier_Charge:int = 0 - 1500;
         var Modifier_Buff:int = 2000;
         var base_threat_lv:int = int(_attacker.getData(DBCharacterData.LEVEL)) * Modifier_Level;
         var base_threat_hp:int = int(_attacker.maxHP) * Modifier_MaxHP;
         var base_threat_total:int = base_threat_lv + base_threat_hp;
         var cur_threat_dmg:int = Math.abs(_dmg) * Modifier_Damage;
         var cur_threat_heal:int = Math.abs(_heal) * Modifier_Heal;
         var cur_threat_effect:int = 0;
         if(_effect)
         {
            if(String(_effect.type).length > 0)
            {
               cur_threat_effect = Modifier_SpecialEffect;
            }
         }
         var cur_threat_charge:int = 0;
         var cur_threat_buff:int = 0;
         switch(_Other)
         {
            case "CHARGE":
               cur_threat_charge = Modifier_Charge;
               break;
            case "BUFF":
               cur_threat_buff = Modifier_Buff;
         }
         var cur_threat_total:int = cur_threat_dmg + cur_threat_effect + cur_threat_heal + cur_threat_charge + cur_threat_buff;
         if(this.threat[_attacker.getData(DBCharacterData.ID)])
         {
            this.threat[_attacker.getData(DBCharacterData.ID)].base = base_threat_total;
            this.threat[_attacker.getData(DBCharacterData.ID)].accuthreat = this.threat[_attacker.getData(DBCharacterData.ID)].accuthreat + cur_threat_total;
            this.threat[_attacker.getData(DBCharacterData.ID)].total = this.threat[_attacker.getData(DBCharacterData.ID)].base + this.threat[_attacker.getData(DBCharacterData.ID)].accuthreat;
         }
         else
         {
            threatObj = {};
            threatObj.base = base_threat_total;
            threatObj.accuthreat = cur_threat_total;
            threatObj.total = base_threat_total + cur_threat_total;
            this.threat[_attacker.getData(DBCharacterData.ID)] = threatObj;
         }
      }
      
      public function getThreat() : Object
      {
         return this.threat;
      }
      
      public function clearTargetDeBuff(_effect:Object) : void
      {
         var key:* = null;
         for(key in this.battleDebuff)
         {
            if(key == _effect.type)
            {
               this.battleDebuff[key] = null;
            }
         }
      }
      
      public function clearDeBuff(_effect:Object) : void
      {
         var key:* = null;
         for(key in this.battleDebuff)
         {
            if(this.battleDebuff[key])
            {
               if(this.battleDebuff[key].duration <= BloodlineData.PASSIVE_DEBUFF_IDENTIFIER)
               {
                  this.battleDebuff[key] = null;
               }
            }
         }
      }
      
      public function removeBattleBuff() : void
      {
         this.battleBuff = {};
      }
      
      public function removeBuff(type:String) : void
      {
         delete this.battleBuff[type];
      }
      
      public function updateATB() : Boolean
      {
         this.atbTimer++;
         if(atbTimer >= Data.BATTLE_ATB_ACTION_TIME - Math.round(this.agility / 10))
         {
            atbTimer = 0;
            return true;
         }
         return false;
      }
      
      public function get atbScale() : Number
      {
         return atbTimer / (Data.BATTLE_ATB_ACTION_TIME - Math.round(this.agility / 10));
      }
      
      public function get agility() : int
      {
         return Formula.calcAgility(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR) + this.speedBonus;
      }
      
      public function get critical() : Number
      {
         return Formula.calcCritical(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
      }
      
      public function get dodge() : Number
      {
         return Formula.calcDodge(this,Central.main.BLOODLINE_SKILL_DATA_ARR,Central.main.SENJUTSU_SKILL_DATA_ARR);
      }
      
      public function get criticalBonus() : Number
      {
         var lightningBonus:Number = 0.008;
         var result:Number = Main.coreData.BASE_CRITICAL_MULTIPLIER + Number(int(this.getData(DBCharacterData.LIGHTNING)) * lightningBonus);
         if(this.isBattleBuffActive(BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON))
         {
            result = result + int(this.getBattleBuff()[BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON].amount) / 100;
         }
         if(this.isBattleBuffActive(BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM))
         {
            result = result + this.getBattleBuff()[BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM].amount;
         }
         return result;
      }
      
      public function enableSelection() : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         battleFrame.buttonMode = true;
         battleFrame.addEventListener(MouseEvent.CLICK,Battle.selectTarget);
      }
      
      public function disableSelection() : void
      {
         this.hideSelection();
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         battleFrame.buttonMode = false;
         battleFrame.removeEventListener(MouseEvent.CLICK,Battle.selectTarget);
      }
      
      public function displaySelection() : void
      {
         var limbIndex:int = 0;
         var limbFound:Boolean = false;
         var children:Array = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:int = 0;
         var tragetMC:MovieClip = null;
         var targetMCChild:DisplayObject = null;
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(this.limb && this.limb > 1)
         {
            limbIndex = this.getCharacterId() - int(this.getCharacterId() / 10) * 10;
            limbFound = false;
            children = [];
            for(i = 0; i < battleFrame.parent["enemyMc_1"]["charMc"].numChildren; i++)
            {
               for(j = 0; j < battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).numChildren; j++)
               {
                  for(k = 0; k < battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).getChildAt(j).numChildren; k++)
                  {
                     tragetMC = battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).getChildAt(j);
                     if(tragetMC)
                     {
                        targetMCChild = tragetMC.getChildByName("limb_" + limbIndex);
                        if(targetMCChild)
                        {
                           targetMCChild.filters = [this.enemyGlowFilter];
                           limbFound = true;
                           break;
                        }
                     }
                  }
                  if(limbFound)
                  {
                     break;
                  }
               }
               if(limbFound)
               {
                  break;
               }
            }
         }
         else
         {
            battleFrame.filters = [this.enemyGlowFilter];
         }
         battleFrame["targetArrow"].gotoAndPlay(Timeline.SHOW);
         var hitArea:Object = this.getHitArea();
         if(this.swf.scaleX > 0)
         {
            battleFrame["targetArrow"].x = this.charMc.x - hitArea.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         else
         {
            battleFrame["targetArrow"].x = this.charMc.x + hitArea.width * Data.BATTLE_CHAR_SCALE / 2;
         }
         battleFrame["targetArrow"].y = this.charMc.y - hitArea.height * Data.BATTLE_CHAR_SCALE;
      }
      
      public function hideSelection() : void
      {
         var limbIndex:int = 0;
         var limbFound:Boolean = false;
         var children:Array = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:int = 0;
         var tragetMC:MovieClip = null;
         var targetMCChild:DisplayObject = null;
         if(this.charMc == null)
         {
            return;
         }
         if(this.charMc.parent == null)
         {
            return;
         }
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(battleFrame == null)
         {
            return;
         }
         if(battleFrame["targetArrow"] == null)
         {
            return;
         }
         if(this.limb && this.limb > 1)
         {
            limbIndex = this.getCharacterId() - int(this.getCharacterId() / 10) * 10;
            limbFound = false;
            children = [];
            for(i = 0; i < battleFrame.parent["enemyMc_1"]["charMc"].numChildren; i++)
            {
               for(j = 0; j < battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).numChildren; j++)
               {
                  for(k = 0; k < battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).getChildAt(j).numChildren; k++)
                  {
                     tragetMC = battleFrame.parent["enemyMc_1"]["charMc"].getChildAt(i).getChildAt(j);
                     if(tragetMC)
                     {
                        targetMCChild = tragetMC.getChildByName("limb_" + limbIndex);
                        if(targetMCChild)
                        {
                           targetMCChild.filters = null;
                           limbFound = true;
                           break;
                        }
                     }
                  }
                  if(limbFound)
                  {
                     break;
                  }
               }
               if(limbFound)
               {
                  break;
               }
            }
         }
         else
         {
            battleFrame.filters = null;
         }
         battleFrame["targetArrow"].gotoAndStop(Timeline.IDLE);
      }
      
      public function showCmdDisplay() : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         battleFrame.filters = [this.commandGlowFilter];
      }
      
      public function hideCmdDisplay() : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         battleFrame.filters = null;
      }
      
      public function set clanEffect(obj:Object) : void
      {
         this._clanEffect = obj;
      }
      
      public function getClanEffect() : Object
      {
         return this._clanEffect;
      }
      
      public function pauseAnimation() : void
      {
         var mc:MovieClip = MovieClip(this.swf.getChildAt(0));
         mc.stop();
      }
      
      public function resumeAnimation() : void
      {
         var mc:MovieClip = MovieClip(this.swf.getChildAt(0));
         mc.play();
      }
      
      protected function clearSwf() : void
      {
         GF.removeAllChild(this.swf);
      }
      
      public function playRun() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoRun();
      }
      
      public function playStand() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStand();
      }
      
      public function playStandby() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStandby();
      }
      
      public function playWin() : void
      {
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoWin();
      }
      
      public function playBloodline(_battleAction:Object, _attackPoint:Point) : void
      {
         var b:uint = 0;
         var tmpskillID:String = null;
         var c:uint = 0;
         var tmpskillID2:String = null;
         Out.debug(this,this.getCharacterId() + " :: " + this.getCharacterName() + " :: playBloodline");
         this.isPlayingAnimation = true;
         this.clearSwf();
         switch(_battleAction.posType)
         {
            case PositionType.MELEE_1:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
               break;
            case PositionType.MELEE_2:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = _attackPoint;
               }
               break;
            case PositionType.MELEE_3:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
               break;
            case PositionType.MELEE_4:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
         }
         var skillID:String = String(_battleAction.BLSKILLID).replace("skill","");
         if(_battleAction.BLTYPE == BloodlineData.SKILL_TYPE_BLOODLINE)
         {
            for(b = 0; b < this.bloodlineSwfArr.length; b++)
            {
               tmpskillID = String(String(this.bloodlineSwfArr[b]).replace("[object Skill_","")).replace("]","");
               if(skillID == tmpskillID)
               {
                  this.swf.addChild(this.bloodlineSwfArr[b]);
                  this.bloodlineSwfArr[b].playAnimation(_battleAction,_attackPoint);
               }
            }
         }
         else
         {
            for(c = 0; c < this.secretSwfArr.length; c++)
            {
               tmpskillID2 = String(String(this.secretSwfArr[c]).replace("[object Skill_","")).replace("]","");
               if(skillID == tmpskillID2)
               {
                  this.swf.addChild(this.secretSwfArr[c]);
                  this.secretSwfArr[c].playAnimation(_battleAction,_attackPoint);
               }
            }
         }
      }
      
      public function playSenjutsu(_battleAction:Object, _attackPoint:Point) : void
      {
         var tmpskillID:String = null;
         Out.debug(this,this.getCharacterId() + " :: " + this.getCharacterName() + " :: playSenjutsu");
         this.isPlayingAnimation = true;
         this.clearSwf();
         switch(_battleAction.posType)
         {
            case PositionType.MELEE_1:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
               break;
            case PositionType.MELEE_2:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = _attackPoint;
               }
               break;
            case PositionType.MELEE_3:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
         }
         var skillID:String = String(_battleAction.SENSKILLID).replace("skill","");
         for(var b:uint = 0; b < this.senjutsuSwfArr.length; b++)
         {
            tmpskillID = String(String(this.senjutsuSwfArr[b]).replace("[object Skill_","")).replace("]","");
            if(skillID == tmpskillID)
            {
               this.swf.addChild(this.senjutsuSwfArr[b]);
               this.senjutsuSwfArr[b].playAnimation(_battleAction,_attackPoint);
            }
         }
      }
      
      public function showCharacterSenjutsuBuffAndDebuff() : void
      {
         var effect:Object = null;
         for each(effect in this.battleBuff)
         {
            if(effect.duration > 0)
            {
               switch(effect.type)
               {
                  case SenjutsuData.EFFECT_SENNIN_MODE:
                     this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1862)[0].replace("[valturn]",effect.duration));
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
      }
      
      public function playAttack(_battleAction:Object, _attackPoint:Point = null) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         switch(_battleAction.posType)
         {
            case PositionType.MELEE_1:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
               break;
            case PositionType.MELEE_2:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = _attackPoint;
               }
               break;
            case PositionType.MELEE_3:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
               break;
            case PositionType.MELEE_4:
               if(_attackPoint != null)
               {
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = _attackPoint.x;
                  this.charMc.y = _attackPoint.y;
               }
         }
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoPlay(_battleAction,_attackPoint);
      }
      
      public function playCharge() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoCharge();
      }
      
      public function playSkip() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoSkip();
      }
      
      public function playHit() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoHit();
      }
      
      public function playDead() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoDead();
      }
      
      public function playRevival() : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoStandby();
      }
      
      public function playAction(animation:String, animationLock:Boolean = true) : void
      {
         this.isPlayingAnimation = animationLock;
         this.clearSwf();
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoAction(animation);
      }
      
      public function playBattleAction(battleAction:Object, attackPoint:Point) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         if(attackPoint != null)
         {
            switch(battleAction.posType)
            {
               case PositionType.MELEE_1:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = attackPoint.x;
                  this.charMc.y = attackPoint.y;
                  break;
               case PositionType.MELEE_2:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charHitPoint = attackPoint;
                  break;
               case PositionType.MELEE_3:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = attackPoint.x;
                  this.charMc.y = attackPoint.y;
                  break;
               case PositionType.MELEE_4:
                  this.charOrigPoint = new Point(this.charMc.x,this.charMc.y);
                  this.charMc.x = attackPoint.x;
                  this.charMc.y = attackPoint.y;
            }
         }
         this.swf.addChild(this.actionBase);
         this.actionBase.gotoPlay(battleAction,attackPoint);
      }
      
      public function getEffectResistance() : Array
      {
         return this.effectResistance;
      }
      
      public function getBloodlineCPMax() : Number
      {
         var key:* = null;
         var rNum:Number = NaN;
         var BLkey:String = "";
         var BLSkillID:String = "";
         var BLkeyArr:Array = [];
         var Effect:Object = {};
         var BLSkillRequirementArr:Array = [];
         var BLSkillRequirement:String = "";
         var tmpstring:String = "";
         var tmparr:Array = [];
         var MAX_CP_RECOVER_Already:Boolean = false;
         var CPMax:Number = 0;
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
                     rNum = NumberUtil.getRandom();
                     if(rNum <= this.battleBuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_MAX_CP_RECOVER:
                              if(!MAX_CP_RECOVER_Already)
                              {
                                 CPMax = 0;
                                 CPMax = CPMax + int(this.battleBuff[key].amount);
                                 MAX_CP_RECOVER_Already = true;
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
         for(key in this.battleDebuff)
         {
            BLkeyArr = [];
            BLkey = "";
            BLSkillID = "";
            BLSkillRequirementArr = [];
            BLSkillRequirement = "";
            tmparr = [];
            tmpstring = "";
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
                     rNum = NumberUtil.getRandom();
                     if(rNum <= this.battleDebuff[key].chancetoeffect / 100)
                     {
                        switch(BLkey)
                        {
                           case BloodlineData.EFFECT_MAX_CP_RECOVER:
                              if(!MAX_CP_RECOVER_Already)
                              {
                                 CPMax = 0;
                                 CPMax = CPMax + int(this.battleDebuff[key].amount);
                                 MAX_CP_RECOVER_Already = true;
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
         return CPMax;
      }
      
      public function showClassSkillDetail() : void
      {
         var tmpMc:MovieClip = null;
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         var arrMcName:Array = battleFrame.name.split("_");
         if(arrMcName[0].indexOf("enemyMc") >= 0)
         {
            tmpMc = battleFrame.parent["detail_box_" + arrMcName[1]];
            (tmpMc as MovieClip).visible = true;
         }
      }
      
      public function hideClassSkillDetail() : void
      {
         var tmpMc:MovieClip = null;
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         var arrMcName:Array = battleFrame.name.split("_");
         if(arrMcName[0].indexOf("enemyMc") >= 0)
         {
            tmpMc = battleFrame.parent["detail_box_" + arrMcName[1]];
            (tmpMc as MovieClip).visible = false;
         }
      }
      
      public function getIsClassSkillAvailable(idx:int) : Boolean
      {
         return isClassSkillAvailable[idx];
      }
      
      public function setIsClassSkillAvailable(idx:int, b:Boolean) : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(!b && battleFrame["skill_2003_storage"])
         {
            battleFrame["skill_2003_storage"].visible = false;
         }
         isClassSkillAvailable[idx] = b;
      }
      
      public function getButtonEnableArr() : Array
      {
         return buttonEnableArr;
      }
      
      public function getSkillButtonEnableArr() : Array
      {
         return skillButtonEnableArr;
      }
      
      public function getBloodlineButtonEnableArr() : Array
      {
         return bloodlineButtonEnableArr;
      }
      
      public function getSecretButtonEnableArr() : Array
      {
         return secretButtonEnableArr;
      }
      
      public function getSenjutsuButtonEnableArr() : Array
      {
         for(var i:int = 0; i < senjutsuButtonEnableArr.length; i++)
         {
            if(i < Central.main.senjutsuSlot)
            {
               senjutsuButtonEnableArr[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER[i] - 1] = true;
            }
            else
            {
               senjutsuButtonEnableArr[Central.main.SENJUTSU_BUTTON_ENABLE_ORDER[i] - 1] = false;
            }
         }
         return senjutsuButtonEnableArr;
      }
      
      protected function initSkill2003Lv() : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(battleFrame["skill_2003_storage"])
         {
            battleFrame["skill_2003_storage"].visible = false;
         }
      }
      
      private function triggerFeedbackOnUpdateCP(attacker:*, changeCP:int, effectiveCPChange:int) : void
      {
         var effectStr:* = null;
         var effect:Object = null;
         var hpFeedbackDmg:int = 0;
         var cpDmgFeedback:Object = null;
         var chance:int = 0;
         var rand:int = 0;
         var cpDmgStunEffect:Object = null;
         var cpDmgStunFeedback:Object = null;
         var battleAction:Object = attacker.getBattleAction();
         effectStr = BloodlineData.EFFECT_CPDMG + ".skill1039";
         if(this.isBattleBuffActive(effectStr))
         {
            if(effectiveCPChange < 0)
            {
               effect = this.getBattleBuff()[effectStr];
               if(effect)
               {
                  if(!battleAction.feedback_skipcheck)
                  {
                     battleAction.feedback_skipcheck = new Array();
                  }
                  hpFeedbackDmg = int(effectiveCPChange * effect.amount * 0.01);
                  cpDmgFeedback = {
                     "type":BloodlineData.EFFECT_CPDMG,
                     "damage":-hpFeedbackDmg
                  };
                  battleAction.feedback_skipcheck.push(cpDmgFeedback);
                  if(this.isBattleBuffActive(BloodlineData.EFFECT_CPDMG_STUN + ".skill1039"))
                  {
                     chance = int(this.getBattleBuff()[BloodlineData.EFFECT_CPDMG_STUN + ".skill1039"].chancetohit);
                     rand = Math.random() * 100;
                     if(rand < chance)
                     {
                        cpDmgStunEffect = {};
                        cpDmgStunEffect.type = BattleData.EFFECT_STUN;
                        cpDmgStunEffect.duration = 2;
                        attacker.setBattleDebuff(cpDmgStunEffect);
                        cpDmgStunFeedback = {};
                        cpDmgStunFeedback.type = BloodlineData.EFFECT_CPDMG_STUN;
                        battleAction.feedback_skipcheck.push(cpDmgStunFeedback);
                     }
                  }
               }
            }
         }
      }
   }
}
