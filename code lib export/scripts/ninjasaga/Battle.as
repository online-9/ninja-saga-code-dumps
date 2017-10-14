package ninjasaga
{
   import ninjasaga.linkage.BattleDoc;
   import flash.media.Sound;
   import flash.display.MovieClip;
   import gs.TweenGroup;
   import flash.filters.ColorMatrixFilter;
   import com.utils.Out;
   import com.utils.GF;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.ClanData;
   import com.utils.Sha1Encrypt;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.objects.Pet;
   import flash.text.TextFormat;
   import ninjasaga.data.Data;
   import ninjasaga.data.GameEvents;
   import gs.TweenLite;
   import gs.easing.Linear;
   import ninjasaga.data.Timeline;
   import com.utils.NumberUtil;
   import ninjasaga.objects.Npc;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.WeaponData;
   import ninjasaga.data.PositionType;
   import bitemycode.facebook.FBUser;
   import ninjasaga.data.AppData;
   import ninjasaga.data.DailyTaskData;
   import flash.geom.Point;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.EffectLangData;
   import ninjasaga.data.EnemyAttributeData;
   import flash.events.MouseEvent;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.SNSData;
   import flash.text.TextField;
   import ninjasaga.data.PvPData;
   import com.utils.CreateFilter;
   import com.utils.Environment;
   import flash.events.Event;
   import com.dynamicflash.util.Base64;
   import ninjasaga.battle.BattleProcessor;
   
   public final class Battle
   {
      
      public static const REMATCH_TIME_LIMIT:int = 31;
      
      private static var battleMc:BattleDoc;
      
      public static var round:uint;
      
      private static var characterArr:Array = [];
      
      private static var attacker;
      
      private static var defender;
      
      private static var selectedTarget;
      
      public static var partyArr:Array;
      
      public static var enemyArr:Array;
      
      public static var petArr:Array;
      
      private static var battleMusic:Sound;
      
      private static var onBattleMusic:Boolean = false;
      
      private static var battleBgDefault:MovieClip;
      
      private static var battleBg:MovieClip;
      
      private static var atbDisplayObj:Object = {};
      
      private static var isShowLevelUp:Boolean = false;
      
      private static var tweenGroup:TweenGroup = new TweenGroup();
      
      public static var consumablesUsed:uint = 0;
      
      private static var consumablesUsedHash:String;
      
      private static var rematchTimes:uint;
      
      private static var bWaitingToStartRematch:Boolean;
      
      private static var battleType:String;
      
      public static var subType:uint = 0;
      
      public static const TYPE_LOCAL:String = "local";
      
      public static const TYPE_NETWORK:String = "network";
      
      private static var _battleResult:uint;
      
      private static var repGain:int;
      
      private static var prestigeGain:int;
      
      private static var connectingAmf:Boolean = false;
      
      private static var battleLog:String = "";
      
      private static var disconnect:Boolean = false;
      
      public static var bossId:String = "";
      
      public static var seal_enemy:Boolean = false;
      
      public static var use_seal_enemy:Boolean = false;
      
      public static var spy_enemy:Boolean = false;
      
      private static var bossRewardXp:int = 0;
      
      private static var bossRewardPetXp:int = 0;
      
      private static var bossRewardGold:int = 0;
      
      private static var bossRewardWeapon:int = 0;
      
      private static var bossRewardMagatama:int = 0;
      
      private static var eventBossArr:Array = ["enemy309","enemy310","enemy311","enemy312","enemy313","enemy314","enemy315","enemy317"];
      
      private static var isEventEnd:Boolean = Central.main.isEventEnd;
      
      private static var isOldHunting:Boolean = Central.main.isOldHunting;
      
      public static var roomId:int = 0;
      
      private static var huntingHash:String = "";
      
      private static var ClanWarHash:String = "";
      
      public static var feedReward:Object;
      
      private static var bossRewardSkill:int = 0;
      
      public static var isPartyControllable:Boolean = false;
      
      public static var AttackerRandomSkillSlot:int = 999;
      
      public static var DefenderRandomSkillSlot:int = 999;
      
      public static var lastBattleAction:Object;
      
      private static var pvpSyncLogSaved:Boolean = false;
      
      private static var pvpLogTimeSaved:Boolean = false;
      
      private static var isTriggerSkill2002:Boolean = false;
      
      public static var isPlayingSkillAnimation:Boolean = false;
      
      public static var showEffectCharId:String;
      
      public static var syncCoolDownObj:Object = {};
      
      public static var noCoolDown:Boolean = false;
      
      public static var log_time:int;
      
      public static var log_server_time:int;
      
      public static var log_total_time:int;
      
      public static var log_time_user:String;
      
      public static var whole_battle_time:int;
      
      public static var start_battle_time:int;
      
      public static var finish_battle_time:int;
      
      private static var bRematchAnyPlayerOpponentLeft:Boolean;
      
      private static var bRematchTimedOut:Boolean;
      
      private static var bRematchPressedOk:Boolean;
      
      private static var bRematchOnePlayerWantRematch:Boolean;
      
      public static var loadingQuitArr:Array = [];
      
      public static var commandActionSyncData:Array;
      
      private static var defaultTarget = null;
      
      private static var canSelectparty:Boolean = false;
      
      private static var _selectedPartySkillID:int = -1;
      
      public static var holdTargetIsMember = null;
      
      private static var canSelectpartyDead:Boolean = false;
      
      private static const dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      private static var bGearBtnEnabled:Boolean = true;
      
      public static var battleRoundCounter:int = 0;
      
      private static var battleDamageLog:int = 0;
      
      public static var specialHpData:Object = {
         "display":true,
         "textCatch":"catch",
         "textRangeLess":0,
         "textRangeOver":0,
         "texthpTxt":"",
         "canClick":true,
         "textButton":"catch now",
         "clickFn":new Function(),
         "showConfirm":false,
         "textShowConfirm":"use",
         "textShowConfirmDetailUse":"",
         "textShowConfirmDetailBuy":"",
         "itemId":"",
         "iconData":new Object(),
         "specialRate":1,
         "showGlowBackground":false
      };
      
      public static var isActionBarShow:Boolean = false;
      
      private static var myCurrencyGain:int = 0;
      
      private static var myPointGain:int = 0;
      
      private static var pvpCurrencyGainDisplay:Boolean = false;
      
      private static var pvpPointGainDisplay:Boolean = false;
      
      private static var pvpshowMyDisconnectText:Boolean = false;
      
      public static var isCompletedDailyFirstBonus:Boolean = false;
      
      private static var myPvEReward:Array;
      
      private static var myPvEScore:int;
      
      private static var rewardList:Array;
       
      
      public function Battle()
      {
         super();
      }
      
      private static function get selectedPartySkillID() : int
      {
         return _selectedPartySkillID;
      }
      
      private static function set selectedPartySkillID(skillPos:int) : void
      {
         if(!canSelectparty && skillPos != -1)
         {
            Out.error("Battle","Party Skill selected when Select Party not allowed.");
         }
         if(skillPos > 7 || skillPos < -1)
         {
            Out.error("Battle","Party Skill selected invalid, skillPos=" + skillPos + ".");
         }
         _selectedPartySkillID = skillPos;
      }
      
      public static function getConstructor() : *
      {
         return Battle.prototype.constructor;
      }
      
      public static function setBattleMusic(_battleMusic:Sound) : void
      {
         battleMusic = _battleMusic;
      }
      
      public static function setBattleBg(_bg:MovieClip = null) : void
      {
         battleBg = _bg;
      }
      
      public static function get battleResult() : uint
      {
         return _battleResult;
      }
      
      public static function set battleResult(newBattleResult:uint) : void
      {
         _battleResult = newBattleResult;
      }
      
      public static function changeBg(_bg:MovieClip) : void
      {
         if(battleMc != null)
         {
            GF.removeAllChild(battleMc["bgHolder"]);
            battleMc["bgHolder"].addChild(_bg);
            if(Mission.curMissionID == "msn135")
            {
               battleMc["bgHolder"].getChildAt(battleMc["bgHolder"].numChildren - 1).name = "bg";
            }
         }
      }
      
      public static function initBattle(_battleMc:BattleDoc) : void
      {
         var clanEffect:Object = null;
         var hpBonus:int = 0;
         var cpBonus:int = 0;
         var dmgBonus:int = 0;
         battleMc = _battleMc;
         Main.hideMenu();
         Main.disableMenu();
         Main.invisibleMapSideBtn();
         bRematchAnyPlayerOpponentLeft = false;
         bRematchTimedOut = false;
         bRematchPressedOk = false;
         bRematchOnePlayerWantRematch = false;
         bWaitingToStartRematch = false;
         isTriggerSkill2002 = false;
         isPlayingSkillAnimation = false;
         var classSkillList:Array = Central.main.getMainChar().getClassSkillListArr();
         for(var i:* = 0; i < classSkillList.length; i++)
         {
            if(classSkillList[i] == "skill2002")
            {
               isTriggerSkill2002 = true;
            }
         }
         battleBgDefault = Central.main.getLib("BattleBG");
         battleBgDefault.name = "";
         if(battleBg == null)
         {
            changeBg(battleBgDefault);
            Out.debug("","load default bg");
         }
         else
         {
            changeBg(battleBg);
            Out.debug("","load bg~~~");
         }
         resetVariables();
         partyArr = new Array();
         enemyArr = new Array();
         petArr = [];
         disconnect = false;
         Main.getMainChar().setBattleActionCB(actionFinish_CB);
         Main.getMainChar().setBattleAttackHitCB(attackHit_CB);
         Main.getMainChar().resetBattleData();
         Main.showMapCoin(false);
         characterArr.push(Main.getMainChar());
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            clanEffect = {};
            hpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
            if(hpBonus > 0)
            {
               clanEffect[ClanData.CLAN_HP_BONUS] = {};
               clanEffect[ClanData.CLAN_HP_BONUS].amount = hpBonus;
            }
            cpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
            if(cpBonus > 0)
            {
               clanEffect[ClanData.CLAN_CP_BONUS] = {};
               clanEffect[ClanData.CLAN_CP_BONUS].amount = cpBonus;
            }
            dmgBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(dmgBonus > 0)
            {
               clanEffect[ClanData.CLAN_DAMAGE_BONUS] = {};
               clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount = dmgBonus;
            }
            Main.getMainChar().clanEffect = clanEffect;
            Main.getMainChar().restoreOriginalStatus();
            Main.getMainChar().updateBattleFrame();
            Main.updateMenu();
         }
         if(Mission.curMissionID == null)
         {
            Mission.isSpecialActionOfEnemy = false;
         }
         try
         {
            Main.tracking.trackBattleWeapon();
         }
         catch(err:Error)
         {
            Out.error("Battle","initBattle :: TRACKING - trackBattleWeapon");
         }
      }
      
      private static function resetVariables() : void
      {
         round = 0;
         attacker = null;
         defender = null;
         selectedTarget = null;
         consumablesUsed = 0;
         consumablesUsedHash = Sha1Encrypt.encrypt(String(0));
         rematchTimes = 0;
         battleResult = 0;
         repGain = 0;
         battleLog = "";
         bossRewardXp = 0;
         bossRewardGold = 0;
         bossRewardWeapon = 0;
         bossRewardMagatama = 0;
         bossRewardSkill = 0;
      }
      
      public static function resetBattleSetting() : void
      {
         var i:int = 0;
         try
         {
            resetVariables();
            Main.getMainChar().playStandby();
            Main.getMainChar().resetBattleData();
            atbDisplayObj.main_char.x = 0;
            for(i = 0; i < enemyArr.length; i++)
            {
               enemyArr[i].restoreOriginalStatus();
               enemyArr[i].isDead = false;
               enemyArr[i].playStandby();
               enemyArr[i].updateBattleFrame();
               enemyArr[i].resetBattleData();
               atbDisplayObj["enemy_" + i].x = 0;
            }
            if(partyArr)
            {
               for(i = 0; i < partyArr.length; i++)
               {
                  partyArr[i].restoreOriginalStatus();
                  partyArr[i].isDead = false;
                  partyArr[i].playStandby();
                  partyArr[i].updateBattleFrame();
                  partyArr[i].resetBattleData();
                  atbDisplayObj["party_" + i].x = 0;
               }
            }
            if(petArr)
            {
               for(i = 0; i < petArr.length; i++)
               {
                  petArr[i].restoreOriginalStatus();
                  petArr[i].isDead = false;
                  petArr[i].playStandby();
                  petArr[i].updateBattleFrame();
                  petArr[i].resetBattleData();
                  petArr[i].resetSkillCooldown();
                  atbDisplayObj["pet_" + i].x = 0;
               }
            }
            if(Battle.type == TYPE_NETWORK)
            {
               Main.getMainChar().restoreOriginalStatus();
               Main.getMainChar().SetBloodlinePassiveSkill();
               Main.getMainChar().SetSenjutsuPassiveSkill();
               Main.getMainChar().isDead = false;
               Main.getMainChar().updateBattleFrame();
               Main.updateMenu();
            }
            consumablesUsed = 0;
            consumablesUsedHash = Sha1Encrypt.encrypt(String(0));
         }
         catch(e:Error)
         {
            Out.error("Battle","resetBattle :: " + e.getStackTrace());
            Main.submitLogDump();
         }
      }
      
      private static function sendResetBattleMessage() : void
      {
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "reset";
         Out.debug("sendData_event=" + dataObj.event + ":" + dataObj.state + " CharacterID=" + Main.getMainChar().getData(DBCharacterData.ID),"");
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function addEnemy(enemy:*) : void
      {
         var clanEffect:Object = null;
         var hpBonus:int = 0;
         var cpBonus:int = 0;
         var dmgBonus:int = 0;
         var enemyObj:Object = {};
         enemyObj.name = enemy.getData(DBCharacterData.NAME);
         enemyObj.id = String(enemy.getData(DBCharacterData.ID));
         enemyObj.agility = enemy.agility;
         Central.client.getInstance().addEnemy(enemyObj);
         enemy.side = BattleData.SIDE_HOSTILE;
         enemy.setBattleActionCB(actionFinish_CB);
         enemy.setBattleAttackHitCB(attackHit_CB);
         enemy.updateBattleFrame();
         enemy.resetBattleData();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            clanEffect = {};
            hpBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_HP_BONUS);
            if(hpBonus > 0)
            {
               clanEffect[ClanData.CLAN_HP_BONUS] = {};
               clanEffect[ClanData.CLAN_HP_BONUS].amount = hpBonus;
            }
            cpBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_CP_BONUS);
            if(cpBonus > 0)
            {
               clanEffect[ClanData.CLAN_CP_BONUS] = {};
               clanEffect[ClanData.CLAN_CP_BONUS].amount = cpBonus;
            }
            dmgBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(dmgBonus > 0)
            {
               clanEffect[ClanData.CLAN_DAMAGE_BONUS] = {};
               clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount = dmgBonus;
            }
            enemy.clanEffect = clanEffect;
            enemy.restoreOriginalStatus();
            enemy.updateBattleFrame();
         }
         enemyArr.push(enemy);
         characterArr.push(enemy);
      }
      
      public static function addParty(member:*) : void
      {
         var clanEffect:Object = null;
         var hpBonus:int = 0;
         var cpBonus:int = 0;
         var dmgBonus:int = 0;
         var teamateObj:Object = {};
         teamateObj.name = member.getData(DBCharacterData.NAME);
         teamateObj.id = String(member.getData(DBCharacterData.ID));
         teamateObj.agility = member.agility;
         Central.client.getInstance().addParty(teamateObj);
         member.setBattleActionCB(actionFinish_CB);
         member.setBattleAttackHitCB(attackHit_CB);
         member.resetBattleData();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            clanEffect = {};
            hpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
            if(hpBonus > 0)
            {
               clanEffect[ClanData.CLAN_HP_BONUS] = {};
               clanEffect[ClanData.CLAN_HP_BONUS].amount = hpBonus;
            }
            cpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
            if(cpBonus > 0)
            {
               clanEffect[ClanData.CLAN_CP_BONUS] = {};
               clanEffect[ClanData.CLAN_CP_BONUS].amount = cpBonus;
            }
            dmgBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
            if(dmgBonus > 0)
            {
               clanEffect[ClanData.CLAN_DAMAGE_BONUS] = {};
               clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount = dmgBonus;
            }
            member.clanEffect = clanEffect;
            member.restoreOriginalStatus();
         }
         member.updateBattleFrame();
         partyArr.push(member);
         characterArr.push(member);
      }
      
      public static function addPet(pet:Pet) : void
      {
         var clanEffect:Object = null;
         var hpBonus:int = 0;
         var cpBonus:int = 0;
         var dmgBonus:int = 0;
         var petObj:Object = {};
         petObj.name = pet.getData(DBCharacterData.NAME);
         petObj.id = pet.getData(DBCharacterData.ID);
         petObj.agility = pet.agility;
         Central.client.getInstance().addPet(petObj);
         pet.setBattleActionCB(actionFinish_CB);
         pet.setBattleAttackHitCB(attackHit_CB);
         pet.resetBattleData();
         pet.resetSkillCooldown();
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            clanEffect = {};
            switch(pet.side)
            {
               case BattleData.SIDE_FRIENDLY:
                  hpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_HP_BONUS);
                  cpBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_CP_BONUS);
                  dmgBonus = Clan.proc.getAttackerBonus(ClanData.CLAN_DAMAGE_BONUS);
                  break;
               case BattleData.SIDE_HOSTILE:
                  hpBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_HP_BONUS);
                  cpBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_CP_BONUS);
                  dmgBonus = Clan.proc.getDefenderBonus(ClanData.CLAN_DAMAGE_BONUS);
            }
            if(hpBonus > 0)
            {
               clanEffect[ClanData.CLAN_HP_BONUS] = {};
               clanEffect[ClanData.CLAN_HP_BONUS].amount = hpBonus;
            }
            if(cpBonus > 0)
            {
               clanEffect[ClanData.CLAN_CP_BONUS] = {};
               clanEffect[ClanData.CLAN_CP_BONUS].amount = cpBonus;
            }
            if(dmgBonus > 0)
            {
               clanEffect[ClanData.CLAN_DAMAGE_BONUS] = {};
               clanEffect[ClanData.CLAN_DAMAGE_BONUS].amount = dmgBonus;
            }
            pet.clanEffect = clanEffect;
            pet.restoreOriginalStatus();
         }
         pet.updateBattleFrame();
         petArr.push(pet);
      }
      
      public static function restoreMainChar() : void
      {
         battleMc.addMainChar();
      }
      
      public static function onBattleStart() : void
      {
         var body:MovieClip = null;
         var i:uint = 0;
         var myFormat:TextFormat = null;
         var scrollMc:String = null;
         battleMc["autoBattleBtn"].visible = false;
         var holderSize:int = battleMc["atbBar"]["holder"].numChildren;
         for(var k:int = 0; k < holderSize; k++)
         {
            battleMc["atbBar"]["holder"].removeChildAt(0);
         }
         var soundArr:Array = [];
         if(!Central.main.mixer.isPlayingMusic())
         {
            if(battleMusic == null)
            {
               battleMusic = Sound(Main.getLib("BattleBGM"));
            }
            if(Mission.curMissionID == "msn0")
            {
               soundArr.push(Sound(Main.getLib("TutorialBGM")));
            }
            else if(battleMusic != null)
            {
               soundArr.push(battleMusic);
            }
            Central.main.mixer.playMusic(soundArr);
            onBattleMusic = true;
         }
         body = Main.getMainChar().getStaticFullBody();
         body.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
         body.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
         body.y = 0 - body.height;
         atbDisplayObj.main_char = body;
         battleMc["atbBar"]["holder"].addChild(body);
         Out.debug("","resetCharMc Main.getMainChar() = " + GF.printObject(Main.getMainChar()));
         Out.debug("","Main.getMainChar() type = " + typeof Main.getMainChar());
         Main.getMainChar().resetCharMc();
         for(i = 0; i < enemyArr.length; i++)
         {
            body = enemyArr[i].getStaticFullBody();
            body.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
            body.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
            if(enemyArr[i].limb && enemyArr[i].limb > 1)
            {
               if(i == 0)
               {
                  battleMc["atbBar"]["holder"].addChild(body);
               }
            }
            else
            {
               battleMc["atbBar"]["holder"].addChild(body);
            }
            atbDisplayObj["enemy_" + i] = body;
            enemyArr[i].resetCharMc();
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               body = partyArr[i].getStaticFullBody();
               body.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
               body.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
               atbDisplayObj["party_" + i] = body;
               battleMc["atbBar"]["holder"].addChild(body);
               partyArr[i].resetCharMc();
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               body = petArr[i].getStaticFullBody();
               body.scaleX = -Data.BATTLE_ATB_CHAR_SCALE;
               body.scaleY = Data.BATTLE_ATB_CHAR_SCALE;
               atbDisplayObj["pet_" + i] = body;
               battleMc["atbBar"]["holder"].addChild(body);
               petArr[i].resetCharMc();
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            myFormat = new TextFormat();
            myFormat.font = "Arial";
            myFormat.size = 14;
            battleMc["chatDisplayMc"].setStyle("textFormat",myFormat);
            battleMc["chatDisplayMc"].bgAlpha = 0.5;
            battleMc["chatDisplayMc"].bgOpaqueColor = 0;
            battleMc["chatDisplayMc"].visible = true;
            Main.mapMenu.showChatInput();
            scrollMc = "";
            if(Central.main.PvpBattleType == "quickMatch" || Central.main.PvpBattleType == "tournament")
            {
               scrollMc = "scrollDisplayMc_1";
            }
            if(Central.main.PvpBattleType == "private")
            {
               for(i = 0; i < Central.main.PvpPVMode; i++)
               {
                  if(Central.main.PvpTeamA[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
                  if(Central.main.PvpTeamB[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
               }
            }
            if(Central.main.PvpBattleType != "PVE")
            {
               for(i = 1; i <= BattleData.CONSUMABLE_LIMIT; i++)
               {
                  battleMc[scrollMc]["scroll_" + String(i)].gotoAndStop(1);
               }
            }
            start_battle_time = int(getTimeStamp());
         }
         else
         {
            battleMc["chatDisplayMc"].visible = false;
            Main.mapMenu.hideChatInput();
         }
         if(!Central.main.isOldHunting)
         {
            Central.main.logHuntingMission(true);
         }
         if(Central.main.senjutsuFeature)
         {
            Central.main.senninModeBtn.visible = true;
            Central.main.senninModeBtn.mouseEnabled = false;
            Central.main.senninModeBtn.mouseChildren = false;
            Central.main.senninModeBtn.filters = [dimFilter];
         }
      }
      
      public static function startBattle() : void
      {
         var i:uint = 0;
         var tmpInt:int = 0;
         if(Battle.type == TYPE_NETWORK)
         {
            bWaitingToStartRematch = false;
         }
         if(Battle.type == TYPE_LOCAL)
         {
            Main.getMainChar().setCharMc(battleMc["playerMc_1"]["charMc"]);
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            Main.getMainChar().setCharMc(battleMc[Main.PvpMainCharMc]["charMc"]);
         }
         Main.updateMenu();
         if(!Main.dispatchGameEvent(GameEvents.BATTLE_START))
         {
            startATB();
         }
         Mission135_SpecialAction();
         if(Main.getMainChar())
         {
            Main.getMainChar().SetBloodlinePassiveSkill();
            Main.getMainChar().SetSenjutsuPassiveSkill();
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i])
            {
               enemyArr[i].SetBloodlinePassiveSkill();
               enemyArr[i].SetSenjutsuPassiveSkill();
               if(enemyArr[i].limb && enemyArr[i].limb > 1)
               {
                  switch(i)
                  {
                     case 0:
                        tmpInt = 1;
                        break;
                     case 1:
                        tmpInt = 0;
                        break;
                     default:
                        tmpInt = i;
                  }
               }
               else
               {
                  tmpInt = i;
               }
               enemyArr[i].setCharMc(battleMc["enemyMc_" + (i + 1)]["charMc"]);
               enemyArr[i].updateBattleFrame();
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(partyArr[i])
               {
                  partyArr[i].SetBloodlinePassiveSkill();
                  partyArr[i].SetSenjutsuPassiveSkill();
               }
            }
         }
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            specialHpData.showGlowBackground = false;
            specialHpData.showConfirm = false;
            specialHpData.canClick = true;
            specialHpData.display = true;
            specialHpData.lv = enemyArr[0].getLevel();
         }
         if(Battle.type == TYPE_NETWORK)
         {
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().pet.swfName,"Pet");
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getWeapon(),Central.main.tracking.TRACK_WEAPON_TAKEN);
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_START + "Premuim");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_START + "Free");
               }
               trackSkillType();
            }
            catch(err:Error)
            {
               Out.error("Battle","startBattle :: TRACKING - trackSkillType");
            }
         }
      }
      
      public static function getCharacterHolder(charID:int) : MovieClip
      {
         var i:int = 0;
         var MAX_PARTY_LENGTH:int = 3;
         if(battleMc["playerMc_1"].charID == charID)
         {
            return battleMc["playerMc_1"];
         }
         for(i = 1; i < MAX_PARTY_LENGTH; i++)
         {
            if(battleMc["partyMc_" + i].charID == charID)
            {
               return battleMc["partyMc_" + i];
            }
         }
         for(i = 1; i < MAX_PARTY_LENGTH + 1; i++)
         {
            if(battleMc["enemyMc_" + i].charID == charID)
            {
               return battleMc["enemyMc_" + i];
            }
         }
         return null;
      }
      
      private static function trackSkillType() : void
      {
         var charLv:int = Central.main.getMainChar().getLevel();
         var ramArr:Array = new Array();
         var SKILL_TYPE:Array = ["wind","fire","lightning","earth","water"];
         var WIND:Boolean = false;
         var FIRE:Boolean = false;
         var LIGHTING:Boolean = false;
         var EARTH:Boolean = false;
         var WATER:Boolean = false;
         for(var i:int = 0; i < SKILL_TYPE.length; i++)
         {
            if(Central.main.getMainChar().hasSkillType(SKILL_TYPE[i]))
            {
               switch(SKILL_TYPE[i])
               {
                  case "wind":
                     WIND = true;
                     ramArr.push(SKILL_TYPE[i]);
                     break;
                  case "fire":
                     FIRE = true;
                     ramArr.push(SKILL_TYPE[i]);
                     break;
                  case "lightning":
                     LIGHTING = true;
                     ramArr.push(SKILL_TYPE[i]);
                     break;
                  case "earth":
                     EARTH = true;
                     ramArr.push(SKILL_TYPE[i]);
                     break;
                  case "water":
                     WATER = true;
                     ramArr.push(SKILL_TYPE[i]);
               }
            }
         }
         if(ramArr.length == 1)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,ramArr[0]);
         }
         if(ramArr.length == 2)
         {
            if(EARTH && FIRE)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Fire");
               }
            }
            if(EARTH && LIGHTING)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Lighting");
               }
            }
            if(EARTH && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Water");
               }
            }
            if(EARTH && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Wind");
               }
            }
            if(FIRE && LIGHTING)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Lighting");
               }
            }
            if(FIRE && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Water");
               }
            }
            if(FIRE && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Wind");
               }
            }
            if(LIGHTING && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Lighting_Water");
               }
            }
            if(LIGHTING && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Lighting_Wind");
               }
            }
            if(WATER && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Water_Wind");
               }
            }
         }
         if(ramArr.length == 3)
         {
            if(EARTH && FIRE && LIGHTING)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Lighting","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Fire_Lighting");
               }
            }
            if(EARTH && FIRE && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Fire_Water");
               }
            }
            if(EARTH && FIRE && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Fire_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Fire_Wind");
               }
            }
            if(EARTH && LIGHTING && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Lighting");
               }
            }
            if(EARTH && LIGHTING && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Lighting");
               }
            }
            if(EARTH && WATER && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Earth_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Earth_Water_Wind");
               }
            }
            if(FIRE && LIGHTING && WATER)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting_Water","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Lighting_Water");
               }
            }
            if(FIRE && LIGHTING && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Lighting_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Lighting_Wind");
               }
            }
            if(FIRE && WATER && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Fire_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Fire_Water_Wind");
               }
            }
            if(LIGHTING && WATER && WIND)
            {
               if(Central.main.getMainChar().getLevel() == 80)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,"Lighting_Water_Wind","Lv80");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP_ELEMENTS,charLv,"Lighting_Water_Wind");
               }
            }
         }
      }
      
      public static function onBattle() : void
      {
         if(battleMc)
         {
            if(battleMc["actionBar"])
            {
               battleMc["actionBar"].hide();
               isActionBarShow = false;
               if(Central.main.senjutsuFeature)
               {
                  disableSPButton();
               }
               if(Main.battleModeSpecial && Main.battleModeSpecial == true)
               {
                  Main.hidePopupSpecialHpBar();
               }
            }
         }
         Main.hideMenu();
         Main.disableMenu();
         disableTargetSelection();
         var attacker:* = Central.battle.getAttacker();
         attacker.hideCmdDisplay();
      }
      
      public static function getAttacker() : *
      {
         return attacker;
      }
      
      public static function getDefender() : *
      {
         return defender;
      }
      
      public static function getShowEffectChar() : String
      {
         return showEffectCharId;
      }
      
      public static function getEnemyArr() : Array
      {
         return enemyArr;
      }
      
      public static function getPetMasterById(petId:uint) : *
      {
         var i:uint = 0;
         if(Main.getMainChar().pet)
         {
            if(int(Main.getMainChar().pet.getData(DBCharacterData.ID)) == petId)
            {
               return Main.getMainChar();
            }
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i].type != 4 && enemyArr[i].pet)
            {
               if(int(enemyArr[i].pet.getData(DBCharacterData.ID)) == petId)
               {
                  return enemyArr[i];
               }
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(partyArr[i].pet)
               {
                  if(int(partyArr[i].getData(DBCharacterData.ID)) == petId)
                  {
                     return partyArr[i];
                  }
               }
            }
         }
         return null;
      }
      
      public static function tweenATB(duration:Number, atbArr:Array) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         var mainIndex:int = 0;
         tweenGroup.clear();
         tweenGroup.align = TweenGroup.ALIGN_START;
         var limbIsShow:Boolean = false;
         for(i = 0; i < atbArr.length; i++)
         {
            if(atbArr[i].charId == Main.getMainChar().getData(DBCharacterData.ID))
            {
               if(Main.getMainChar().isDead)
               {
                  atbDisplayObj.main_char.x = 0;
               }
               else
               {
                  tweenGroup.push(TweenLite.to(atbDisplayObj.main_char,duration,{
                     "x":atbArr[i].moveTo,
                     "ease":Linear.easeNone
                  }));
               }
            }
            else
            {
               for(j = 0; j < enemyArr.length; j++)
               {
                  if(atbArr[i].charId == enemyArr[j].getData(DBCharacterData.ID))
                  {
                     if(enemyArr[j].isDead && !(enemyArr[j].limb && enemyArr[j].limb > 1))
                     {
                        atbDisplayObj["enemy_" + j].x = 0;
                     }
                     else if(enemyArr[j].limb && enemyArr[j].limb > 1)
                     {
                        for(k = 0; k < enemyArr.length; k++)
                        {
                           if(enemyArr[k].getCharacterId() == int(enemyArr[k].getCharacterId() / 10) * 10 + 1)
                           {
                              mainIndex = k;
                           }
                        }
                        if(!limbIsShow)
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["enemy_" + mainIndex],duration,{
                              "x":atbArr[i].moveTo,
                              "ease":Linear.easeNone
                           }));
                           limbIsShow = true;
                        }
                     }
                     else
                     {
                        tweenGroup.push(TweenLite.to(atbDisplayObj["enemy_" + j],duration,{
                           "x":atbArr[i].moveTo,
                           "ease":Linear.easeNone
                        }));
                     }
                     break;
                  }
               }
               if(partyArr)
               {
                  for(j = 0; j < partyArr.length; j++)
                  {
                     if(atbArr[i].charId == partyArr[j].getData(DBCharacterData.ID))
                     {
                        if(partyArr[j].isDead)
                        {
                           atbDisplayObj["party_" + j].x = 0;
                        }
                        else
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["party_" + j],duration,{
                              "x":atbArr[i].moveTo,
                              "ease":Linear.easeNone
                           }));
                        }
                        break;
                     }
                  }
               }
               if(petArr)
               {
                  for(j = 0; j < petArr.length; j++)
                  {
                     if(atbArr[i].charId == petArr[j].getData(DBCharacterData.ID))
                     {
                        if(petArr[j].isDead)
                        {
                           atbDisplayObj["pet_" + j].x = 0;
                        }
                        else
                        {
                           tweenGroup.push(TweenLite.to(atbDisplayObj["pet_" + j],duration,{
                              "x":atbArr[i].moveTo,
                              "ease":Linear.easeNone
                           }));
                        }
                        break;
                     }
                  }
               }
            }
         }
         tweenGroup.onComplete = tweenATBFinish;
      }
      
      public static function tweenATBFinish() : void
      {
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "action";
         dataObj.charId = Main.getMainChar().getData("character_id");
         Central.client.getInstance().sendData(dataObj);
      }
      
      private static function resetATBPosition() : void
      {
         if(atbDisplayObj.main_char.x >= 600)
         {
            atbDisplayObj.main_char.x = 0;
         }
         var i:uint = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            if(atbDisplayObj["enemy_" + i].x >= 600)
            {
               atbDisplayObj["enemy_" + i].x = 0;
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(atbDisplayObj["party_" + i].x >= 600)
               {
                  atbDisplayObj["party_" + i].x = 0;
               }
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               if(atbDisplayObj["pet_" + i].x >= 600)
               {
                  atbDisplayObj["pet_" + i].x = 0;
               }
            }
         }
      }
      
      public static function startATB() : void
      {
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "start_atb";
         dataObj.charId = Main.getMainChar().getData("character_id");
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function checkCanSync(_type:String, roundObj:Object) : Boolean
      {
         var i:int = 0;
         var debuffObj:Object = null;
         if(roundObj && roundObj.debuff)
         {
            for(i = 0; i < roundObj.debuff.length; i++)
            {
               debuffObj = roundObj.debuff[i];
               if(debuffObj.type == BattleData.EFFECT_CHAOS)
               {
                  return false;
               }
            }
         }
         if(_type == "pet" || _type == "enemy")
         {
            return false;
         }
         return true;
      }
      
      public static function characterTurn(_type:String, _id:uint, roundObj:Object, battleAction:Object, commandSyncData:Array = null) : void
      {
         var i:uint = 0;
         var canSync:Boolean = true;
         canSync = checkCanSync(_type,roundObj);
         if(canSync == true)
         {
            commandActionSyncData = commandSyncData;
         }
         else
         {
            commandActionSyncData = [];
         }
         showEffectCharId = String(_id);
         switch(_type)
         {
            case "player":
               if(_id == int(Main.getMainChar().getData("character_id")))
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     Main.getMainChar().SetSenjutsuPassiveSkill();
                  }
                  Main.getMainChar().updateSkill2003Lv();
                  nextAction(Main.getMainChar(),roundObj,battleAction);
                  disablePartySelection();
                  if(isTriggerSkill2002 && !((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP)))
                  {
                     isTriggerSkill2002 = false;
                     triggerSkill2002();
                  }
               }
               else
               {
                  for(i = 0; i < enemyArr.length; i++)
                  {
                     if(_id == enemyArr[i].getData(DBCharacterData.ID))
                     {
                        nextAction(enemyArr[i],roundObj,battleAction);
                        break;
                     }
                  }
                  for(i = 0; i < partyArr.length; i++)
                  {
                     if(_id == partyArr[i].getData(DBCharacterData.ID))
                     {
                        nextAction(partyArr[i],roundObj,battleAction);
                        break;
                     }
                  }
               }
               break;
            case "enemy":
               for(i = 0; i < enemyArr.length; i++)
               {
                  if(_id == enemyArr[i].getData(DBCharacterData.ID))
                  {
                     nextAction(enemyArr[i],roundObj,battleAction);
                     break;
                  }
               }
               break;
            case "party":
               for(i = 0; i < partyArr.length; i++)
               {
                  if(_id == partyArr[i].getData(DBCharacterData.ID))
                  {
                     nextAction(partyArr[i],roundObj,battleAction);
                     break;
                  }
               }
               break;
            case "pet":
               for(i = 0; i < petArr.length; i++)
               {
                  if(_id == petArr[i].getData(DBCharacterData.ID))
                  {
                     nextAction(petArr[i],roundObj,battleAction);
                     break;
                  }
               }
         }
      }
      
      private static function nextAction(char:*, roundObj:Object, battleAction:Object) : void
      {
         var i:int = 0;
         var tmpInt:int = 0;
         attacker = char;
         if(attacker.limb && attacker.limb > 1)
         {
            for(i = 0; i < attacker.limb; i++)
            {
               switch(i)
               {
                  case 0:
                     tmpInt = 1;
                     break;
                  case 1:
                     tmpInt = 0;
                     break;
                  default:
                     tmpInt = i;
               }
               getCharacterById(int(attacker.getCharacterId() / 10) * 10 + tmpInt).moveToFront();
            }
         }
         else
         {
            attacker.moveToFront();
         }
         if(roundObj == null)
         {
            return;
         }
         if(attacker.isDead)
         {
            actionFinish_CB();
         }
         else
         {
            if(battleAction)
            {
               attacker.setBattleAction(battleAction);
            }
            Out.debug("Battle","nextAction :: nextRound");
            Out.debug("Battle","rex:A pvp show word roundObj.debuff.length=" + roundObj.debuff.length);
            attacker.nextRound(roundObj);
            Out.debug("Battle","rex:B pvp show word roundObj.debuff.length=" + roundObj.debuff.length);
            setupAction(battleAction);
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID))
            {
               battleRoundCounter++;
            }
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID) && round != 0)
            {
               Mission135_SpecialAction();
            }
         }
      }
      
      public static function resetHpCpLimitOver() : void
      {
         if(attacker.hp > attacker.maxHP)
         {
            attacker.hp == attacker.maxHP;
         }
         if(attacker.cp > attacker.maxCP)
         {
            attacker.cp == attacker.maxCP;
         }
         if(attacker.sp > attacker.maxSP)
         {
            attacker.sp == attacker.maxSP;
         }
         if(defender.hp > defender.maxHP)
         {
            defender.hp == defender.maxHP;
         }
         if(defender.cp > defender.maxCP)
         {
            defender.cp == defender.maxCP;
         }
         if(defender.sp > defender.maxSP)
         {
            defender.sp == defender.maxSP;
         }
         attacker.syncHp(attacker.hp);
         attacker.syncCp(attacker.cp);
         attacker.syncSp(attacker.sp);
         defender.syncHp(defender.hp);
         defender.syncCp(defender.cp);
         defender.syncSp(defender.sp);
      }
      
      public static function syncHpCpCommandAction() : void
      {
         var syncObj:Object = null;
         var j:int = 0;
         var target:* = undefined;
         Out.debug("syncHpCpCommandAction >> ",">>");
         var syncData:Array = commandActionSyncData;
         Out.debug("syncHpCpCommandAction","syncData >> " + syncData);
         for(var i:* = 0; i < syncData.length; i++)
         {
            syncObj = syncData[i];
            Out.debug("syncHpCpCommandAction","syncObj >> " + GF.printObject(syncObj));
            if(syncObj.type == 1 || syncObj.type == 4)
            {
               for(j = 0; j < Central.main.PvpAllPlayer.length; j++)
               {
                  if(syncObj.ID == Central.main.PvpAllPlayer[j])
                  {
                     target = getCharacterById(int(syncObj.ID));
                     Out.debug("syncHpCpCommandAction","SyncHp B4 >> " + target.hp);
                     Out.debug("syncHpCpCommandAction","SyncCp B4 >> " + target.cp);
                     Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + target.sp);
                     target.syncHp(syncObj.HP);
                     target.syncCp(syncObj.CP);
                     target.syncSp(syncObj.SP);
                     Out.debug("syncHpCpCommandAction","SyncHp After >> " + target.hp);
                     Out.debug("syncHpCpCommandAction","SyncCp After >> " + target.cp);
                     Out.debug("syncHpCpCommandAction","SyncSp After >> " + target.sp);
                     target.updateBattleFrame();
                  }
               }
            }
         }
         Central.main.updateMenu();
      }
      
      private static function setupAction(battleAction:Object) : void
      {
         var key:String = null;
         var i:uint = 0;
         var tmpCurrHp:int = 0;
         var targetPos:uint = 0;
         var debuff:Object = null;
         var correspondingEffect:Object = null;
         var battleDebuff:Object = attacker.getBattleDebuff();
         var dataObj:Object = {};
         var maxTarget:uint = 0;
         var primaryTargets:Array = [];
         var secondaryTargets:Array = [];
         var ChaosTargets:Array = [];
         var isControlAction:Boolean = false;
         if(battleAction != null && battleAction.debuffOverride != true)
         {
            Out.debug("Battle","setupAction :: battleAction >> " + GF.objectToString(battleAction));
            if(Battle.type == TYPE_NETWORK)
            {
               attacker.setBattleAction(battleAction);
            }
            if(battleAction.targetType != null && int(battleAction.targetId) > 0)
            {
               setDefenderById(battleAction.targetId);
            }
            else
            {
               defender = Main.getMainChar();
            }
            switch(battleAction.action)
            {
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(677)).replace("[valturn]",battleAction.duration));
            }
            dataObj.battleAction = battleAction;
            dataObj.targetId = battleAction.targetId;
            callBattleAction(dataObj);
            return;
         }
         if(Battle.type == TYPE_LOCAL || attacker.getData("character_id") == Main.getMainChar().getData("character_id"))
         {
            isControlAction = true;
         }
         else if(Main.getMainChar().pet != null)
         {
            if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().pet.getData(DBCharacterData.ID))
            {
               isControlAction = true;
            }
         }
         if(isControlAction)
         {
            for(var _loc17_ in battleDebuff)
            {
               switch(_loc17_)
               {
                  case BattleData.EFFECT_CUBE_ILLUSION:
                     if(battleDebuff[key] != null)
                     {
                        if(battleDebuff[key].duration > 0)
                        {
                           if(Battle.type != TYPE_NETWORK)
                           {
                              defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(674)).replace("[valturn]",Math.round(battleDebuff[key].duration).toString()));
                           }
                        }
                     }
                     continue;
                  default:
                     continue;
               }
            }
            if(attacker.constructor == Enemy)
            {
               primaryTargets.push(Main.getMainChar());
               if(partyArr)
               {
                  for(i = 0; i < partyArr.length; i++)
                  {
                     if(!partyArr[i].isDead)
                     {
                        primaryTargets.push(partyArr[i]);
                     }
                  }
               }
               defender = primaryTargets[Math.floor(NumberUtil.randomNumber(0,primaryTargets.length - 0.001))];
               sendCommand();
            }
            if(attacker.constructor == AICharacter)
            {
               attacker.skillCheck();
               if(isPartyControllable == true)
               {
                  if(selectedTarget)
                  {
                     selectedTarget.hideSelection();
                     if(selectedTarget.isDead)
                     {
                        for(i = 0; i < enemyArr.length; i++)
                        {
                           if(!enemyArr[i].isDead)
                           {
                              selectedTarget = enemyArr[i];
                              break;
                           }
                        }
                     }
                  }
                  else
                  {
                     for(i = 0; i < enemyArr.length; i++)
                     {
                        if(!enemyArr[i].isDead)
                        {
                           selectedTarget = enemyArr[i];
                           break;
                        }
                     }
                  }
                  selectedTarget.displaySelection();
                  defender = selectedTarget;
                  onPlayerCommand();
               }
               else
               {
                  if(attacker.friendly)
                  {
                     for(i = 0; i < enemyArr.length; i++)
                     {
                        if(!enemyArr[i].isDead)
                        {
                           debuff = enemyArr[i].getBattleDebuff();
                           if(debuff[BattleData.EFFECT_SLEEP] == null)
                           {
                              primaryTargets.push(i);
                           }
                           else
                           {
                              secondaryTargets.push(i);
                           }
                        }
                     }
                     tmpCurrHp = Math.floor(Main.getMainChar().hp / Main.getMainChar().maxHP * 100);
                     holdTargetIsMember = Main.getMainChar();
                     for(i = 0; i < partyArr.length; i++)
                     {
                        if(!partyArr[i].isDead && partyArr[i] != attacker)
                        {
                           if(Math.floor(partyArr[i].hp / partyArr[i].maxHP * 100) < tmpCurrHp)
                           {
                              holdTargetIsMember = partyArr[i];
                           }
                        }
                     }
                     if(primaryTargets.length == 0)
                     {
                        targetPos = secondaryTargets[Math.floor(NumberUtil.randomNumber(0,secondaryTargets.length - 0.001))];
                     }
                     else
                     {
                        targetPos = primaryTargets[Math.floor(NumberUtil.randomNumber(0,primaryTargets.length - 0.001))];
                     }
                     defender = enemyArr[targetPos];
                  }
                  else
                  {
                     tmpCurrHp = 0;
                     for(i = 0; i < enemyArr.length; i++)
                     {
                        if(!enemyArr[i].isDead && enemyArr[i] != attacker)
                        {
                           if(tmpCurrHp == 0 || Math.floor(enemyArr[i].hp / enemyArr[i].maxHP * 100) < tmpCurrHp)
                           {
                              tmpCurrHp = Math.floor(enemyArr[i].hp / enemyArr[i].maxHP * 100);
                              holdTargetIsMember = enemyArr[i];
                           }
                        }
                     }
                     defender = Main.getMainChar();
                  }
                  sendCommand();
               }
            }
            if(attacker.constructor == Npc)
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  if(!enemyArr[i].isDead)
                  {
                     debuff = enemyArr[i].getBattleDebuff();
                     if(debuff[BattleData.EFFECT_SLEEP] == null)
                     {
                        primaryTargets.push(i);
                     }
                     else
                     {
                        secondaryTargets.push(i);
                     }
                  }
               }
               if(primaryTargets.length == 0)
               {
                  targetPos = secondaryTargets[Math.floor(NumberUtil.randomNumber(0,secondaryTargets.length - 0.001))];
               }
               else
               {
                  targetPos = primaryTargets[Math.floor(NumberUtil.randomNumber(0,primaryTargets.length - 0.001))];
               }
               defender = enemyArr[targetPos];
               sendCommand();
            }
            if(attacker.constructor == Character)
            {
               if(selectedTarget)
               {
                  selectedTarget.hideSelection();
                  if(selectedTarget.isDead)
                  {
                     for(i = 0; i < enemyArr.length; i++)
                     {
                        if(!enemyArr[i].isDead)
                        {
                           selectedTarget = enemyArr[i];
                           break;
                        }
                     }
                  }
               }
               else
               {
                  for(i = 0; i < enemyArr.length; i++)
                  {
                     if(!enemyArr[i].isDead)
                     {
                        selectedTarget = enemyArr[i];
                        break;
                     }
                  }
               }
               selectedTarget.displaySelection();
               defender = selectedTarget;
               if(battleAction != null)
               {
                  if(battleAction.debuffOverride == true)
                  {
                     correspondingEffect = {};
                     correspondingEffect[BattleData.EFFECT_STUN] = Main.langLib.get(281);
                     correspondingEffect[BattleData.EFFECT_PET_FREEZE] = Main.langLib.get(820);
                     correspondingEffect[BattleData.EFFECT_PETRIFICATION] = Main.langLib.get(954);
                     correspondingEffect[BattleData.EFFECT_SLEEP] = Main.langLib.get(280);
                     correspondingEffect[BloodlineData.EFFECT_HALLUCINATIONS + ".skill1020"] = Main.langLib.get(820);
                     correspondingEffect[BattleData.EFFECT_CHAOS] = Main.langLib.get(734);
                     correspondingEffect[BattleData.EFFECT_FEAR] = Main.langLib.get(304);
                     if(battleDebuff[BattleData.EFFECT_CHAOS])
                     {
                        Main.showInfo(String(Central.main.langLib.get(1454)).replace("[valamount]",correspondingEffect[BattleData.EFFECT_CHAOS]));
                     }
                     else
                     {
                        Main.showInfo(String(Central.main.langLib.get(1454)).replace("[valamount]",correspondingEffect[battleAction.action]));
                     }
                  }
               }
               onPlayerCommand();
            }
            if(attacker.constructor == Pet)
            {
               if(attacker.side == BattleData.SIDE_FRIENDLY)
               {
                  for(i = 0; i < enemyArr.length; i++)
                  {
                     if(!enemyArr[i].isDead)
                     {
                        debuff = enemyArr[i].getBattleDebuff();
                        if(debuff[BattleData.EFFECT_SLEEP] == null)
                        {
                           primaryTargets.push(i);
                        }
                        else
                        {
                           secondaryTargets.push(i);
                           defender = enemyArr[i];
                        }
                     }
                  }
                  if(primaryTargets.length != 0)
                  {
                     targetPos = primaryTargets[Math.floor(NumberUtil.randomNumber(0,primaryTargets.length - 0.001))];
                     defender = enemyArr[targetPos];
                  }
               }
               if(attacker.side == BattleData.SIDE_HOSTILE)
               {
                  defender = Main.getMainChar();
               }
               sendCommand();
            }
         }
      }
      
      private static function sendCommand() : void
      {
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "battle_command";
         dataObj.charId = attacker.getCharacterId();
         dataObj.targetId = defender.getCharacterId();
         dataObj.battleAction = attacker.getBattleAction();
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function callBattleAction(_dataObj:Object) : void
      {
         var i:int = 0;
         var effect:Object = null;
         var weaponData:Object = null;
         var animation:String = null;
         var posType:String = null;
         var skillData:Object = null;
         Out.debug("Battle","callBattleAction :: _dataObj >> " + GF.printObject(_dataObj));
         var battleAction:Object = _dataObj.battleAction;
         lastBattleAction = battleAction;
         if(attacker.getData(DBCharacterData.ID) == Main.getMainChar().getData(DBCharacterData.ID))
         {
            round++;
            Out.debug("","rex round counter= " + round);
         }
         if(battleAction.action == "weapon_attack")
         {
            weaponData = Central.main.WEAPON_DATA.find(attacker.getWeapon());
            animation = weaponData[WeaponData.ANIMATION];
            switch(animation)
            {
               case "attack_01":
                  posType = PositionType.MELEE_2;
                  break;
               default:
                  posType = PositionType.MELEE_1;
            }
            battleAction.animation = animation;
            battleAction.posType = posType;
         }
         attacker.setBattleAction(battleAction);
         setDefenderById(_dataObj.targetId);
         if(battleAction.attackerBuff)
         {
            for(i = 0; i < battleAction.attackerBuff.length; i++)
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  effect = battleAction.attackerBuff[i];
                  attacker.setBattleBuff(effect);
               }
            }
         }
         if(battleAction.attackerDebuff)
         {
            for(i = 0; i < battleAction.attackerDebuff.length; i++)
            {
               if(checkResisted(battleAction.attackerDebuff[i].resisted,attacker) == false)
               {
                  effect = battleAction.attackerDebuff[i];
                  attacker.setBattleDebuff(effect);
               }
               else
               {
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
            }
         }
         if(battleAction.defenderBuff)
         {
            for(i = 0; i < battleAction.defenderBuff.length; i++)
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  effect = battleAction.defenderBuff[i];
                  defender.setBattleBuff(effect);
               }
            }
         }
         if(battleAction.defenderDebuff)
         {
            for(i = 0; i < battleAction.defenderDebuff.length; i++)
            {
               if(checkResisted(battleAction.defenderDebuff[i].resisted,defender) == false)
               {
                  effect = battleAction.defenderDebuff[i];
                  defender.setBattleDebuff(effect);
               }
               else
               {
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
            }
         }
         if(Battle.type == TYPE_LOCAL && battleAction.dodge == true)
         {
            if(defender.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.DODGE,1);
            }
         }
         if(Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[Main.getMainChar().getCharacterId] && battleAction.dodge[Main.getMainChar().getCharacterId] == true)
         {
            Main.achievement.updateBattleStat(Main.achievementData.DODGE,1);
         }
         switch(battleAction.action)
         {
            case "skill":
               if(battleAction)
               {
                  if(battleAction.withoutCP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1370));
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  if(attacker.type == 4)
                  {
                     battleAction.action = "special";
                     characterTurn(_dataObj.charType,_dataObj.charId,_dataObj.roundObj,battleAction,_dataObj.syncData);
                  }
                  else
                  {
                     skillData = Main.SKILL_DATA[battleAction.skillId];
                     attacker.updateCP(0 - battleAction.cp);
                     if(!noCoolDown)
                     {
                        attacker.setSkillCooldown(skillData);
                     }
                     else
                     {
                        noCoolDown = false;
                     }
                  }
               }
               break;
            case "bloodline":
               if(battleAction)
               {
                  if(battleAction.withoutCP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1370));
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(0 - battleAction.cp);
               }
               break;
            case "senjutsu":
               if(battleAction)
               {
                  if(battleAction.withoutSP)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1862)[2]);
                  }
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(0 - battleAction.sp);
               }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            if(battleAction.defenderDamageShield != null)
            {
               defender.damageShield = battleAction.defenderDamageShield;
            }
         }
         else
         {
            Out.debug("Battle","rex defenderDamageShield shoudld not exist");
         }
         actionFlow();
         Central.main.getMainChar().securityCheck();
      }
      
      public static function callBattleFinishHAV(_dataObj:Object) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         var signature:String = null;
         var charId:int = 0;
         var signatureData:String = null;
         if(godModeHackCheck())
         {
            Main.onError("2973","");
            return;
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(Main.dispatchGameEvent(GameEvents.BATTLE_FINISH))
            {
               return;
            }
         }
         Main.achievement.updateBattleStat(Main.achievementData.BATTLE,1);
         if(Battle.type == TYPE_NETWORK)
         {
            bWaitingToStartRematch = true;
            Main.showAmfLoading();
            Main.getMainChar().updateDB(0,0,[],"",2,Battle);
         }
         var winnerIDs:Array = _dataObj.winnerIDs as Array;
         var currencyGainList:Object = _dataObj.currencyGainList as Object;
         var pointGainList:Object = _dataObj.pointGainList as Object;
         var pveRewardList:Object = _dataObj.reward as Object;
         var scoreList:Object = _dataObj.score as Object;
         Battle.myCurrencyGain = 0;
         Battle.myPointGain = 0;
         Battle.pvpCurrencyGainDisplay = false;
         Battle.pvpPointGainDisplay = false;
         Battle.pvpshowMyDisconnectText = false;
         if(Central.main.getMainChar().getCharacterId())
         {
            charId = Central.main.getMainChar().getCharacterId();
            if(currencyGainList)
            {
               Battle.pvpCurrencyGainDisplay = true;
               Battle.myCurrencyGain = currencyGainList[charId];
               if(Battle.myCurrencyGain == 0)
               {
                  Battle.pvpshowMyDisconnectText = true;
               }
            }
            if(pointGainList)
            {
               Battle.pvpPointGainDisplay = true;
               Battle.myPointGain = pointGainList[charId];
            }
            if(pveRewardList)
            {
               Battle.myPvEReward = pveRewardList[charId];
            }
            if(scoreList)
            {
               GF.printObject(scoreList);
               Battle.myPvEScore = scoreList[charId];
            }
         }
         var EventArray:Array = [];
         EventArray[0] = Central.main.eventBattleMethod;
         EventArray[1] = int(seal_enemy);
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            EventArray[1] = battleRoundCounter;
            if(specialHpData.finalHP)
            {
               EventArray[2] = specialHpData.finalHP;
            }
            else
            {
               EventArray[2] = 0;
            }
            EventArray[3] = specialHpData.lv;
            EventArray[4] = Central.main.battleId;
            EventArray[5] = int(seal_enemy);
         }
         var isMeWinner:Boolean = false;
         for(i = 0; i < winnerIDs.length; i++)
         {
            if(Main.getMainChar().getData(DBCharacterData.ID).toString() == winnerIDs[i].toString())
            {
               isMeWinner = true;
               break;
            }
         }
         if(isMeWinner)
         {
            if(Battle.type == TYPE_NETWORK)
            {
               if(_dataObj.disconnect != null)
               {
                  disconnect = true;
                  Main.showInfo(Main.langLib.get(214));
               }
               showPvPBattleWin();
            }
            else if(subType == BattleData.SUBTYPE_CLAN)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               battleResult = 1;
               if(round > 5)
               {
                  battleLog = "";
               }
               else
               {
                  battleLog = "Round " + String(round) + " || " + battleLog;
               }
               signature = Main.getHash(String(battleResult) + battleLog + Account.getAccountSessionKey());
               Main.amfClient.service("ClanWar.generateBattleResult",[Account.getAccountSessionKey(),Main.updateSequence(),String(battleResult),battleLog,signature],gotClanBattleResult);
            }
            else if(subType == BattleData.SUBTYPE_BOSS)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               if(!Central.main.isOldHunting)
               {
                  Central.main.logHuntingMission(false,true);
               }
               if(isEventEnd)
               {
                  signature = Main.getHash(String(bossId) + "|0|");
                  Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,0],getBossRewardResponse02);
               }
               else if(Central.main.isOldHunting)
               {
                  huntingHash = Main.getHash(String(roomId) + 0);
                  Central.main.isOldHunting = false;
                  Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,0,huntingHash],getBossRewardResponse02);
               }
               else if(Central.main.isNewClanWar)
               {
                  Central.main.extraData.crew_merit = Central.main.extraData.crew_merit + 10;
                  Central.main.getMainChar().itemUsedInBattle = !!Central.main.getMainChar().itemUsedInBattle?Central.main.getMainChar().itemUsedInBattle:[];
                  ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 0));
                  Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,0,Central.main.updateSequence(),ClanWarHash],getBossRewardResponse02);
               }
               else
               {
                  signatureData = "";
                  for(j = 0; j < EventArray.length; j++)
                  {
                     signatureData = signatureData + EventArray[j];
                     if(j < EventArray.length - 1)
                     {
                        signatureData = signatureData + ",";
                     }
                  }
                  signature = Main.getHash(String(bossId) + "|0|" + signatureData);
                  Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,0,EventArray],getBossRewardResponse02);
               }
               Main.removePartyNpc();
               Main.partyMembers = null;
               Main.emptyRecruitedFriends();
               if(Central.main.eventName == "Vday2015")
               {
                  Central.main.partyNpc = Central.main.prevNpcArr;
                  Central.main.partyMembers = Central.main.prevPartyMemberArr;
               }
            }
            else
            {
               showBattleWin();
            }
            return;
         }
         if(Battle.type != TYPE_NETWORK)
         {
            if(subType == BattleData.SUBTYPE_CLAN)
            {
               if(connectingAmf)
               {
                  return;
               }
               connectingAmf = true;
               Main.showAmfLoading();
               battleResult = 2;
               if(round > 5)
               {
                  battleLog = "";
               }
               else
               {
                  battleLog = "Round " + String(round) + " || " + battleLog;
               }
               signature = Main.getHash(String(battleResult) + battleLog + Account.getAccountSessionKey());
               Main.amfClient.service("ClanWar.generateBattleResult",[Account.getAccountSessionKey(),Main.updateSequence(),String(battleResult),battleLog,signature],gotClanBattleResult);
               return;
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            showPvPBattleLose();
            return;
         }
         if(Main.challengeFriendUID != null)
         {
            if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
            {
               switch(AppData.type)
               {
                  case AppData.FB:
                     break;
                  case AppData.OK:
                     SNS.sendNotification(String(String(Central.main.langLib.get(299)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                     break;
                  case AppData.MP:
                     SNS.sendNotification(String(String(Central.main.langLib.get(298)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
               }
               Main.challengedFriends.push(Main.challengeFriendUID);
            }
            for(i = 0; i < enemyArr.length; i++)
            {
               Main.saveChallengeRecord(enemyArr[i].getData(DBCharacterData.ID),1);
               Panel.getInstance().setChallenged(int(enemyArr[i].getData(DBCharacterData.ID)));
            }
            Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
            Main.challengeFriendUID = null;
         }
         if(subType == BattleData.SUBTYPE_CLAN)
         {
            battleResult = 2;
            battleMc.gotoClanResult();
         }
         else
         {
            try
            {
               Central.main.tracking.trackHuntBoss(bossId,Central.main.tracking.TRACK_HUNT_BOSS + Central.main.tracking.TRACK_FAIL);
            }
            catch(err:Error)
            {
               Out.error("Battle","callBattleFinish :: TRACKING - trackHuntBoss(TRACK_FAIL)");
            }
            battleLose();
         }
      }
      
      private static function setDefenderById(_id:int) : void
      {
         var i:uint = 0;
         Out.debug("Battle","setDefenderById :: _id >> " + _id);
         if(Main.getMainChar().getData("character_id") == _id)
         {
            defender = Main.getMainChar();
            return;
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i].getData("character_id") == _id)
            {
               defender = enemyArr[i];
               return;
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(partyArr[i].getData(DBCharacterData.ID) == _id)
               {
                  defender = partyArr[i];
                  return;
               }
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               if(petArr[i].getData(DBCharacterData.ID) == _id)
               {
                  defender = petArr[i];
                  return;
               }
            }
         }
      }
      
      public static function setDefender(char:*) : void
      {
         defender = char;
      }
      
      public static function getCharacterById(_id:int) : *
      {
         var i:uint = 0;
         if(Main.getMainChar().getData("character_id") == _id)
         {
            return Main.getMainChar();
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i].getData("character_id") == _id)
            {
               return enemyArr[i];
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(partyArr[i].getData(DBCharacterData.ID) == _id)
               {
                  return partyArr[i];
               }
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               if(petArr[i].getData(DBCharacterData.ID) == _id)
               {
                  return petArr[i];
               }
            }
         }
      }
      
      private static function actionFlow() : void
      {
         var battleAction:Object = null;
         var tmpEffect:Object = null;
         var defenderWeapon:Object = null;
         var itemData:Object = null;
         var mainLimbID:int = 0;
         battleAction = attacker.getBattleAction();
         var attackPoint:Point = null;
         if(Battle.type == TYPE_LOCAL && battleAction.dodge == true || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
         {
            if(defender.getWeapon())
            {
               if(Central.main.WEAPON_DATA.find(defender.getWeapon()))
               {
                  defenderWeapon = Central.main.WEAPON_DATA.find(defender.getWeapon());
                  if(defenderWeapon)
                  {
                     for each(tmpEffect in defenderWeapon.effect)
                     {
                        switch(tmpEffect.type)
                        {
                           case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                              continue;
                           default:
                              continue;
                        }
                     }
                  }
               }
            }
         }
         Out.debug("Battle","actionFlow :: battleAction >> " + GF.objectToString(battleAction));
         Out.debug("Battle","actionFlow :: attacker >> " + attacker.getCharacterName() + " :: defender >> " + defender.getCharacterName() + " :: posType >> " + battleAction.posType);
         if(battleAction.posType != null)
         {
            switch(battleAction.posType)
            {
               case PositionType.MELEE_1:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     attackPoint = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     attackPoint = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_2:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     attackPoint = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     attackPoint = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_3:
                  Out.debug("Battle","MELEE_3");
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     attackPoint = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE - attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE - 300,defender.charMc.y);
                  }
                  else
                  {
                     attackPoint = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE + attacker.getHitArea().width * Data.BATTLE_CHAR_SCALE + 300,defender.charMc.y);
                  }
                  break;
               case PositionType.MELEE_4:
                  if(defender.charMc.x > Data.GAME_WIDTH / 2)
                  {
                     attackPoint = new Point(Data.GAME_WIDTH / 2 - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE * 2 / 3,Central.main.getMainChar().charMc.y);
                  }
                  if(defender.charMc.x < Data.GAME_WIDTH / 2)
                  {
                     attackPoint = new Point(Data.GAME_WIDTH / 2 + PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE * 2 / 3,Central.main.getMainChar().charMc.y);
                  }
                  break;
               case PositionType.RANGE_1:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     attackPoint = new Point(defender.charMc.x,defender.charMc.y - defender.getHitArea().height * Data.BATTLE_CHAR_SCALE / 2);
                  }
                  else
                  {
                     attackPoint = new Point(defender.charMc.x,defender.charMc.y - defender.getHitArea().height * Data.BATTLE_CHAR_SCALE / 2);
                  }
                  break;
               case PositionType.RANGE_2:
                  if(attacker.charMc.x < defender.charMc.x)
                  {
                     attackPoint = new Point(defender.charMc.x - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE,defender.charMc.y);
                  }
                  else
                  {
                     attackPoint = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE * 3,defender.charMc.y);
                  }
                  break;
               case PositionType.RANGE_3:
                  if(defender.charMc.x > Data.GAME_WIDTH / 2)
                  {
                     attackPoint = new Point(defender.charMc.x - defender.getHitArea().width * Data.BATTLE_CHAR_SCALE / 2,defender.charMc.y);
                  }
                  if(defender.charMc.x < Data.GAME_WIDTH / 2)
                  {
                     attackPoint = new Point(defender.charMc.x + defender.getHitArea().width * Data.BATTLE_CHAR_SCALE / 2,defender.charMc.y);
                  }
            }
         }
         Out.debug("Battle","actionFlow :: battleAction.action >> " + battleAction.action);
         switch(battleAction.action)
         {
            case "pass":
               break;
            case "attack":
               if(battleAction.skillCP)
               {
                  attacker.updatePetCP(0 - battleAction.skillCP);
                  attacker.updateBattleFrame();
               }
               playAttack(attacker,battleAction,attackPoint);
               break;
            case "weapon_attack":
               if(Central.main.isNewChar)
               {
                  battleAction.animation = "attack_01";
               }
               playAttack(attacker,battleAction,attackPoint);
               break;
            case "charge":
               playCharge(attacker);
               break;
            case "skill":
               attacker.updateBattleFrame();
               playSkill(attacker,battleAction,attackPoint);
               break;
            case "class_skill":
               playClassSkill(attacker,battleAction,attackPoint);
               break;
            case "item":
               itemData = Main.ITEM_DATA.find(battleAction.item);
               if(itemData != null)
               {
                  playAction(attacker,itemData.animation);
               }
               break;
            case "special":
               if(battleAction.skillCP)
               {
                  attacker.updatePetCP(0 - battleAction.skillCP);
                  attacker.updateBattleFrame();
               }
               if(attacker.limb && attacker.limb > 1)
               {
                  mainLimbID = int(attacker.getCharacterId() / 10) * 10 + 1;
                  playBattleAction(getCharacterById(mainLimbID),battleAction,attackPoint);
               }
               else
               {
                  playBattleAction(attacker,battleAction,attackPoint);
               }
               break;
            case BattleData.EFFECT_STUN:
               attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(332)).replace("[valamt]",battleAction.duration));
               break;
            case "bloodline":
               attacker.updateBattleFrame();
               playBloodline(attacker,battleAction,attackPoint);
               break;
            case "senjutsu":
               attacker.updateBattleFrame();
               playSenjutsu(attacker,battleAction,attackPoint);
               break;
            case "event_action":
               playAttack(attacker,battleAction,attackPoint);
               break;
            case "dodge":
               attacker.updateBattleFrame();
               playSkip(attacker);
         }
         actionFinish_CB();
      }
      
      public static function attackHit_CB() : void
      {
         var battleAction:Object = null;
         var effect:Object = null;
         var key:String = null;
         var rand:Number = NaN;
         var i:int = 0;
         var arr_AttackerSkill:Array = null;
         var arr_DefenderSkill:Array = null;
         var healCharacter:* = undefined;
         var petDrainHP:int = 0;
         var petDrainCP:int = 0;
         var extraEffect:Object = null;
         var tmpEffect:Object = null;
         var amount:int = 0;
         var itemData:Object = null;
         var battleAction_effect:Object = null;
         var battleAction_skillId:String = null;
         var bl_effect_1:Object = null;
         var bl_effect_2:Object = null;
         var bl_effect_3:Object = null;
         var battleAction_effect_Arr:Array = null;
         var OverHeadWord:String = null;
         var isSelfBuff:Boolean = false;
         var senjutsu_effect:Object = null;
         var senjutsu_skillId:String = null;
         var sen_effect_1:Object = null;
         var sen_effect_2:Object = null;
         var sen_effect_3:Object = null;
         var senjutsu_effect_Arr:Array = null;
         var attackerWeapon:Object = null;
         var attackerBackItem:Object = null;
         var arr_effect:Array = null;
         var arr_effect_master:Array = null;
         var PET_randomeffectchance:Number = NaN;
         var PET_RandomPos:int = 0;
         var PetRandEffect:Object = null;
         var OverHeadString:String = null;
         var z:* = undefined;
         var Pet_colliding_wave_effect:Object = null;
         var PET_randomeffect_master_chance:Number = NaN;
         var PET_Random_master_Pos:int = 0;
         var PetRand_master_Effect:Object = null;
         var master_OverHeadString:String = null;
         var c:* = undefined;
         var arr_MasterSkill:Array = null;
         var cooldown_Masterskillkey:uint = 0;
         var cooldown_MasterskillID:String = null;
         var cooldown_MastertmpVal:int = 0;
         var j:int = 0;
         var restoreObj:Object = null;
         var target:* = undefined;
         if(Main.dispatchGameEvent(GameEvents.BATTLE_ATK_HIT))
         {
            attacker.pauseAnimation();
            return;
         }
         attacker.resumeAnimation();
         battleAction = attacker.getBattleAction();
         var attackerBuff:Object = attacker.getBattleBuff();
         var attackerDebuff:Object = attacker.getBattleDebuff();
         var defenderBuff:Object = defender.getBattleBuff();
         var defenderDebuff:Object = attacker.getBattleDebuff();
         var Item_restore_HP:int = 0;
         var Item_restore_CP:int = 0;
         var Item_Restore_Pet_CP:int = 0;
         var amountCP:int = 0;
         var cooldownSkillkey:uint = 0;
         var cooldownSkillID:String = "";
         var cooldownTmpVal:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = "";
         var cooldown_tmpVal:int = 0;
         if(battleAction.hitNum == null)
         {
            battleAction.hitNum = 1;
         }
         else
         {
            battleAction.hitNum++;
         }
         if(Battle.type == TYPE_LOCAL && battleAction.dodge == false || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == false)
         {
            if(battleAction.critical == true)
            {
               if(attacker.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  Main.achievement.updateBattleStat(Main.achievementData.CRITICAL,1);
               }
            }
            if(battleAction.effect)
            {
               if(battleAction.effect.restoreHp)
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(battleAction.effect.restoreHp);
                  }
                  defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.effect.restoreHp + " " + String(Central.main.langLib.get(483)).replace("+",""));
               }
               if(battleAction.effect.restoreCp)
               {
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(battleAction.effect.restoreCp);
                  }
                  defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.effect.restoreCp + " " + String(Central.main.langLib.get(350)).replace("+",""));
               }
               defender.updateBattleFrame();
               Main.updateMenu();
               updateSPButton();
               Out.debug("battleAction :: "," battleAction >> " + GF.printObject(battleAction));
               if(checkResisted(battleAction.effect.resisted,defender) == true)
               {
                  Out.debug("checkResisted"," 2120");
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
               }
               if(battleAction.effect.resisted == false || battleAction.effect.resisted == null)
               {
               }
               if(checkResisted(battleAction.effect.resisted,defender) == false)
               {
                  switch(battleAction.effect.type)
                  {
                     case BattleData.EFFECT_SLEEP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_FEAR_WEAKEN:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_FREEZE:
                        if(battleAction.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(820));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.setBattleDebuff(battleAction.effect);
                           }
                        }
                        break;
                     case BattleData.EFFECT_BURN_HP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(0 - int(battleAction.effect.damageHp));
                        }
                        break;
                     case BattleData.EFFECT_BURN_CP_FIX_NUM:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(battleAction.effect.damageCp));
                           defender.updateCP(0 - battleAction.effect.damageCp);
                        }
                        break;
                     case BattleData.EFFECT_ECSTATIC_SOUND:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(609));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DISMANTLE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(817));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_REDUCE_CHARGE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(804));
                        break;
                     case BattleData.EFFECT_BURN_CP_HP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(-int(battleAction.effect.damageHp));
                           defender.updateCP(0 - int(battleAction.effect.damageCp));
                        }
                        break;
                     case BattleData.EFFECT_PET_BLEEDING:
                        if(battleAction.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(battleAction.effect.amount) + "%)");
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.setBattleDebuff(battleAction.effect);
                           }
                        }
                        break;
                     case BattleData.EFFECT_FLAME_EATER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(battleAction.effect.flameEaten));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.removeDebuff(BattleData.EFFECT_BURN);
                           defender.removeDebuff(BattleData.EFFECT_PET_BURN);
                           defender.removeDebuff(BattleData.EFFECT_BURNING);
                           defender.updateHP(int(battleAction.effect.flameEaten));
                        }
                        break;
                     case BattleData.EFFECT_CLEAR_BUFF:
                        if(battleAction.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.EFFECT_ADD_COOLDOWN:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           addSkillCoolDown(battleAction.effect,battleAction);
                        }
                        break;
                     case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + " + (battleAction.effect.amount - 1));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addAllSkillCooldown(battleAction.effect.amount);
                        }
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP:
                        petDrainHP = battleAction.effect.damageHp;
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(petDrainHP));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateHP(0 - petDrainHP);
                        }
                        healCharacter = getPetMasterById(attacker.getPetId());
                        if(healCharacter)
                        {
                           healCharacter.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(petDrainHP));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              healCharacter.updateHP(petDrainHP);
                           }
                        }
                        break;
                     case BattleData.EFFECT_PET_DRAIN_CP:
                        petDrainCP = battleAction.effect.damageCp;
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(petDrainCP));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateCP(0 - petDrainCP);
                        }
                        healCharacter = getPetMasterById(attacker.getPetId());
                        if(healCharacter)
                        {
                           healCharacter.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(petDrainCP));
                           if(Battle.type == TYPE_NETWORK)
                           {
                              healCharacter.updateCP(petDrainCP);
                           }
                        }
                        break;
                     case BattleData.EFFECT_EXTRA_CP_RECOVER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(755));
                        break;
                     case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.EFFECT_RESTRICT_CHARGE:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_CRIT_CHANCE_DMG:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(747));
                        break;
                     case BattleData.EFFECT_AMONG_ROCKS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(617));
                        break;
                     case BattleData.EFFECT_HEAL_OVER_TIME:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.MONSTER_HP1:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.updateHP(battleAction.effect.damageHp);
                        }
                        break;
                     case BattleData.EFFECT_CHAOS:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case SkillData.EFFECT_TYPE_HEAL:
                     case BattleData.EFFECT_ALL_CP_HEAL:
                        healTarget();
                        break;
                     case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(676)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_AGILITY_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(282));
                        break;
                     case BattleData.EFFECT_DODGE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_PET_DODGE_BONUS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                        break;
                     case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                        break;
                     case BattleData.EFFECT_REGENERATE_CHAKRA:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(324));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_REGENERATE_HP:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(490));
                        break;
                     case BattleData.EFFECT_MANA_SHIELD:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(594));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        break;
                     case BattleData.EFFECT_THUNDERSTORM_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        setbuffThreat(battleAction.effect);
                        break;
                     case BattleData.EFFECT_WIND_PEACE:
                     case BattleData.EFFECT_WIND_PEACE_2:
                     case BattleData.EFFECT_WIND_PEACE_3:
                     case BattleData.EFFECT_WIND_PEACE_4:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           if(attacker.getCharacterId() != Main.getMainChar().getCharacterId())
                           {
                              Main.getMainChar().showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 Main.getMainChar().setBattleBuff(battleAction.effect);
                              }
                           }
                           if(partyArr)
                           {
                              for(i = 0; i < partyArr.length; i++)
                              {
                                 if(!partyArr[i].isDead)
                                 {
                                    partyArr[i].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       partyArr[i].setBattleBuff(battleAction.effect);
                                    }
                                 }
                              }
                           }
                        }
                        if(attacker.side == BattleData.SIDE_HOSTILE)
                        {
                           for(i = 0; i < enemyArr.length; i++)
                           {
                              if(!enemyArr[i].isDead)
                              {
                                 enemyArr[i].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(611));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    enemyArr[i].setBattleBuff(battleAction.effect);
                                 }
                              }
                           }
                        }
                        setbuffThreat(battleAction.effect);
                        break;
                     case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(613));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           effect = {
                              "type":BattleData.EFFECT_EXCITATION_CP,
                              "duration":battleAction.effect.amount
                           };
                           attacker.setBattleBuff(effect);
                           effect = {
                              "type":BattleData.EFFECT_EXCITATION_CHARGE,
                              "duration":battleAction.effect.duration
                           };
                           attacker.setBattleBuff(effect);
                        }
                        break;
                     case BattleData.EFFECT_LIGHTING_BUNDLE:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                     case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(615));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_AMONG_ROCKS:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(617));
                        break;
                     case BattleData.EFFECT_COLLIDING_WAVE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(619));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                           extraEffect = {
                              "type":BattleData.EFFECT_STUN,
                              "duration":battleAction.effect.duration
                           };
                           defender.setBattleDebuff(extraEffect);
                        }
                        break;
                     case BattleData.EFFECT_DARK_CURSE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(649));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                     case BattleData.EFFECT_CALM_TARGET:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_HP:
                     case BattleData.EFFECT_CLEARBUFF_REDUCE_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(Math.round(defender.maxCP * (battleAction.effect.amount / 100))));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateCP(0 - int(Math.round(defender.maxCP * (battleAction.effect.amount / 100))));
                           defender.addAllSkillCooldown(battleAction.effect.duration);
                        }
                        break;
                     case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addAllSkillCooldown(battleAction.effect.duration);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_DRINKER_N_RESTORE_HP:
                        healTarget();
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(819));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_THEFT_HP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2034) + "(" + battleAction.effect.amount + "%)(" + battleAction.effect.duration + ")");
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_BUFF_NEGATE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2035) + "(" + String(battleAction.effect.duration - 1) + ")");
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(954));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DARKNESS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1088));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_BLOOD_FEED:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(683)));
                        break;
                     case BattleData.SKILL_307:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_310:
                        attacker.showOverheadNumber(Timeline.WORD,String("SKILL 310   open"));
                        break;
                     case BattleData.SKILL_311:
                        defender.showOverheadNumber(Timeline.WORD,String("SKILL 311   open"));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.SKILL_312:
                        attacker.showOverheadNumber(Timeline.WORD,String("SKILL 312   open"));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_ACCURATE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                        break;
                     case BattleData.EFFECT_PET_DISORIENTED:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(891));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearBuff();
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.SKILL_335:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1369)));
                        setbuffThreat(battleAction.effect);
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.SKILL_285:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1355)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_302:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1358)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_251:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(748)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_268:
                     case BattleData.SKILL_268_2:
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                        attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                           attacker.clearAllDebuff();
                        }
                        break;
                     case BattleData.SKILL_304:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1359)));
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1360)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addSkillCooldown(4,SkillData.TYPE_EARTH);
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                        break;
                     case BattleData.SKILL_253:
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361)));
                        defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1362)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.addSkillCooldown(4,SkillData.TYPE_WATER);
                        }
                        break;
                     case BattleData.EFFECT_GATE_OPENING:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(296));
                        effect = battleAction.effect;
                        break;
                     case BattleData.EFFECT_PURIFY:
                        if(battleAction.effect.activated == true)
                        {
                           defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                           if(defender.isBattleDebuffActive(BattleData.SKILL_253) == true)
                           {
                              defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1361) + "(" + defender.getBattleDebuff()[BattleData.SKILL_253].duration + ")"));
                           }
                           if(Battle.type == TYPE_NETWORK)
                           {
                              defender.clearAllDebuff();
                              if(battleAction.effect.restoreHp != null || battleAction.effect.restoreHp > 0)
                              {
                              }
                           }
                           else
                           {
                              checkWeaponPurifyRestore(defender);
                              checBackItemPurifyRestore(defender);
                           }
                        }
                        break;
                     case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                        effect = battleAction.effect;
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(329));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(effect);
                        }
                        break;
                     case BattleData.EFFECT_RESTORE_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + battleAction.effect.amount);
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.updateCP(battleAction.effect.amount);
                        }
                        break;
                     case BattleData.EFFECT_REACTIVE_FORCE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(533));
                        effect = battleAction.effect;
                        break;
                     case BattleData.EFFECT_FRENZY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(834));
                        break;
                     case BattleData.EFFECT_GUARD:
                     case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
                        break;
                     case BattleData.EFFECT_LIGHT_IMPLUSE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(651));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_PET_ATTENTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_BONUS:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                        effect = battleAction.effect;
                        break;
                     case BattleData.EFFECT_COMPLETE_GUARD:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(636));
                        break;
                     case BattleData.EFFECT_CATALYTIC_MATTER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(814));
                        break;
                     case BattleData.EFFECT_PET_DEBUFF_RESIST:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(822));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                        break;
                     case BattleData.EFFECT_PET_HEAL:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(830));
                        break;
                     case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(832));
                        break;
                     case BattleData.EFFECT_PET_SAVE_CP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(805));
                        break;
                     case BattleData.EFFECT_PET_REFLECT_ATTACK:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(873));
                        break;
                     case BattleData.EFFECT_PET_LIGHTNING:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(875));
                        break;
                     case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                     case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(878));
                        break;
                     case BattleData.EFFECT_BLOODLUST_DEDICATION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(356));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.clearAllDebuff();
                        }
                        else
                        {
                           checkWeaponPurifyRestore(defender);
                        }
                        break;
                     case BattleData.EFFECT_ATTACK_MODE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(881));
                        break;
                     case BattleData.EFFECT_DEFENCE_MODE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(883));
                        break;
                     case BattleData.EFFECT_WAKE_UP:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(890));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.getBattleDebuff()[BattleData.EFFECT_SLEEP] = null;
                        }
                        break;
                     case BattleData.EFFECT_PET_ENERGIZE:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(893));
                        break;
                     case BattleData.EFFECT_BUNNY_FRENZY:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(834));
                        break;
                     case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1871));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.SKILL_369:
                     case BattleData.SKILL_501:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.SKILL_377:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DOT_HP:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                           defender.clearBuff();
                        }
                        break;
                     case BattleData.SKILL_341:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(817));
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(762));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           defender.setBattleDebuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                        break;
                     case BattleData.EFFECT_HEAL_MEMBER:
                        healTarget();
                        break;
                     case BattleData.EFFECT_PET_PERSEVERANCE_MASTER:
                        defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[0]);
                        break;
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS:
                     case BattleData.EFFECT_HEAL_HP_N_DMG_BONUS_UPGRADE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2007));
                        break;
                     case BattleData.EFFECT_INTERNAL_INJURY_CHAOS:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           switch(battleAction.target)
                           {
                              case "friendly":
                                 for(i = 0; i < characterArr.length; i++)
                                 {
                                    if(characterArr[i].isDead == false && characterArr[i].side == defender.side)
                                    {
                                       tmpEffect = {
                                          "type":BattleData.EFFECT_CHAOS,
                                          "duration":3
                                       };
                                       characterArr[i].setBattleDebuff(tmpEffect);
                                       tmpEffect = {
                                          "type":BattleData.EFFECT_INTERNAL_INJURY,
                                          "duration":battleAction.effect.duration,
                                          "amount":battleAction.effect.amount
                                       };
                                       characterArr[i].setBattleDebuff(tmpEffect);
                                    }
                                 }
                                 break;
                              default:
                                 tmpEffect = {
                                    "type":BattleData.EFFECT_CHAOS,
                                    "duration":3
                                 };
                                 defender.setBattleDebuff(tmpEffect);
                                 tmpEffect = {
                                    "type":BattleData.EFFECT_INTERNAL_INJURY,
                                    "duration":battleAction.effect.duration,
                                    "amount":battleAction.effect.amount
                                 };
                                 defender.setBattleDebuff(tmpEffect);
                           }
                           break;
                        }
                        break;
                     case BattleData.EFFECT_CP_LOCK_AND_DEBUFF_RESIST:
                        if(Battle.type == TYPE_NETWORK)
                        {
                           switch(battleAction.target)
                           {
                              case "allEnemy":
                                 for(i = 0; i < characterArr.length; i++)
                                 {
                                    if(characterArr[i].isDead == false && characterArr[i].side == attacker.side)
                                    {
                                       characterArr[i].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013));
                                       tmpEffect = {
                                          "type":BattleData.EFFECT_CP_LOCK,
                                          "duration":battleAction.effect.duration
                                       };
                                       characterArr[i].setBattleBuff(tmpEffect);
                                       tmpEffect = {
                                          "type":BattleData.EFFECT_RESTRICT_CHARGE,
                                          "duration":battleAction.effect.amount
                                       };
                                       characterArr[i].setBattleDebuff(tmpEffect);
                                       tmpEffect = {
                                          "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                                          "duration":battleAction.effect.duration,
                                          "amount":100
                                       };
                                       characterArr[i].setBattleBuff(tmpEffect);
                                    }
                                 }
                                 break;
                              default:
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2013));
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
                        }
                        break;
                     case BattleData.EFFECT_THUNDER_MODE_N_DEBUFF_RESIST:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(601));
                        tmpEffect = {
                           "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                           "duration":battleAction.effect.duration,
                           "amount":100
                        };
                        attacker.setBattleDebuff(tmpEffect);
                        tmpEffect = {
                           "type":BattleData.EFFECT_THUNDERSTORM_MODE,
                           "duration":battleAction.effect.duration,
                           "amount":battleAction.effect.amount
                        };
                        attacker.setBattleBuff(tmpEffect);
                        break;
                     case BattleData.EFFECT_FLAME:
                        switch(battleAction.target)
                        {
                           case "allEnemy":
                              trace(GF.printObject(characterArr));
                              for(i = 0; i < characterArr.length; i++)
                              {
                                 if(characterArr[i].isDead == false && characterArr[i].side == defender.side)
                                 {
                                    if(Battle.type == Battle.TYPE_NETWORK)
                                    {
                                       characterArr[i].setBattleDebuff(battleAction.effect);
                                    }
                                 }
                              }
                        }
                        break;
                     case BattleData.EFFECT_SAND_GUARD:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2025));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           tmpEffect = {
                              "type":BattleData.EFFECT_REACTIVE_FORCE,
                              "duration":battleAction.effect.duration,
                              "chance":int(battleAction.effect.amount) + 10
                           };
                           attacker.setBattleBuff(tmpEffect);
                           tmpEffect = {
                              "type":BattleData.EFFECT_RECEIVED_DMG_RESTORE_HP,
                              "duration":battleAction.effect.duration,
                              "amount":battleAction.effect.amount
                           };
                           attacker.setBattleBuff(tmpEffect);
                        }
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION_FIX:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2026));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DMG_BONUS_N_REDUCTION:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2027));
                        if(Battle.type == Battle.TYPE_NETWORK)
                        {
                           attacker.setBattleBuff(battleAction.effect);
                        }
                        break;
                     case BattleData.EFFECT_DEBUFF_RESIST_EX:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2028));
                        break;
                     case BattleData.EFFECT_ALL_BUFF:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2029));
                        break;
                     case BattleData.EFFECT_PROTECT_BY_DUMMY:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_BURN:
                     case BattleData.EFFECT_PROTECT_BY_DUMMY_RECEIVED_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030));
                        break;
                     case BattleData.EFFECT_ABSORB_BUFF:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2031));
                  }
               }
            }
            if(battleAction.reflectEffect)
            {
               defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(752));
               checkReflectGenjutsu(battleAction.reflectEffect);
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.setBattleDebuff(battleAction.reflectEffect);
               }
            }
            attacker.updateBattleFrame();
            defender.updateBattleFrame();
         }
         switch(battleAction.action)
         {
            case "attack":
               damageTarget();
               break;
            case "weapon_attack":
               if(attacker.getWeapon())
               {
                  attackerWeapon = Central.main.WEAPON_DATA.find(attacker.getWeapon());
                  if(attackerWeapon)
                  {
                     for each(tmpEffect in attackerWeapon.effect)
                     {
                        switch(tmpEffect.type)
                        {
                           case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                              if(attacker.getWeapon() == "wpn332" && battleAction.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(887));
                                 battleAction.weapon_activated = false;
                              }
                              continue;
                           case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                              if(battleAction.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                                 battleAction.weapon_activated = false;
                              }
                              continue;
                           case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                              if(Battle.type == TYPE_LOCAL && battleAction.dodge == false || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_GENJUTSU);
                                 }
                              }
                           case "attack_reduce_cooldown.0":
                              if(Battle.type == TYPE_LOCAL && battleAction.dodge == false || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1609));
                              }
                              continue;
                           case BattleData.EFFECT_DEFENDER_FREEZE:
                              if(battleAction.weapon_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820)));
                                 battleAction.weapon_activated = false;
                              }
                              continue;
                           default:
                              continue;
                        }
                     }
                  }
               }
               if(attacker.getBackItem())
               {
                  attackerBackItem = Central.main.BACK_ITEM_DATA.find(attacker.getBackItem());
                  if(attackerWeapon)
                  {
                     for each(tmpEffect in attackerBackItem.effect)
                     {
                        switch(tmpEffect.type)
                        {
                           case BattleData.EFFECT_DEFENDER_STUN:
                              if(battleAction.backitem_activated)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                                 battleAction.backitem_activated = false;
                              }
                              continue;
                           default:
                              continue;
                        }
                     }
                  }
               }
               damageTarget();
               break;
            case "charge":
               if(attacker.isBattleBuffActive(BattleData.EFFECT_EXTRA_CP_RECOVER))
               {
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(755));
               }
               if(battleAction.restoreHp)
               {
                  attacker.showOverheadNumber(Timeline.HEAL,"+" + battleAction.restoreHp + " " + String(Central.main.langLib.get(483)).replace("+",""));
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.cpRestore);
                  if(battleAction.restoreHp)
                  {
                     attacker.updateHP(battleAction.restoreHp);
                  }
               }
               attacker.updateBattleFrame();
               setchargeThreat();
               break;
            case "skill":
               damageTarget();
               break;
            case "class_skill":
               switch(battleAction.effect.type)
               {
                  case BattleData.SKILL_2000:
                     healTarget();
                     break;
                  case BattleData.SKILL_2001:
                     effect = battleAction.effect;
                     attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1366)));
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.clearAllDebuff();
                     }
                     break;
                  case BattleData.SKILL_2003:
                     effect = battleAction.effect;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.setBattleDebuff(effect);
                     }
               }
               damageTarget();
               break;
            case "item":
               itemData = Central.main.ITEM_DATA.find(battleAction.item);
               switch(itemData.effect)
               {
                  case BattleData.ITEM_PERCENT_HP:
                  case BattleData.ITEM_RESTORE_HP:
                     Item_restore_HP = battleAction.restoreHp;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateHP(Item_restore_HP);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.HEAL,"+" + Item_restore_HP + " " + String(Central.main.langLib.get(483)).replace("+",""));
                     break;
                  case BattleData.ITEM_PERCENT_CP:
                  case BattleData.ITEM_RESTORE_CP:
                     Item_restore_CP = battleAction.restoreCp;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateCP(Item_restore_CP);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.WORD,"+" + Item_restore_CP + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.ITEM_PERCENT_HPCP:
                  case BattleData.ITEM_SPECIAL_RUNE_SCROLL:
                     Item_restore_HP = battleAction.restoreHp;
                     Item_restore_CP = battleAction.restoreCp;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateHP(Item_restore_HP);
                        attacker.updateCP(Item_restore_CP);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.HEAL,"+" + Item_restore_HP + " " + String(Central.main.langLib.get(483)).replace("+",""));
                     attacker.showOverheadNumber(Timeline.WORD,"+" + Item_restore_CP + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.EFFECT_DAMAGE_BONUS:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     break;
                  case BattleData.EFFECT_DAMAGE_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     break;
                  case BattleData.EFFECT_DODGE_BONUS:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     break;
                  case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_CRITICAL_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     break;
                  case BattleData.ITEM_DODGE_BONUS_N_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(306));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.ITEM_CRITICAL_CHANCE_N_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(292));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.ITEM_DAMAGE_BONUS_N_ACCURATE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(745));
                     break;
                  case BattleData.EFFECT_REGENERATE_HP:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(490));
                     break;
                  case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1688));
                     break;
                  case BattleData.EFFECT_ACCURATE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(735));
                     break;
                  case BattleData.ITEM_CLEARDEBUFF_RESIST:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                     attacker.clearAllDebuff();
                     break;
                  case BattleData.ITEM_STRENGTHEN_N_BLEEDING:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                     break;
                  case BattleData.ITEM_BOTH_DAMAGE_REDUCTION:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                     break;
                  case BattleData.ITEM_EFFECT_SEAL_GAN:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1725)[0]);
                     break;
                  case BattleData.ITEM_EFFECT_SPY_CP:
                     Item_restore_CP = battleAction.restoreCp;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        attacker.updateCP(Item_restore_CP);
                     }
                     attacker.updateBattleFrame();
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1725)[1]);
                     attacker.showOverheadNumber(Timeline.WORD,"+" + Item_restore_CP + " " + String(Central.main.langLib.get(350)).replace("+",""));
                     break;
                  case BattleData.ITEM_RESTORE_PET_CP_PRESENT:
                     Item_Restore_Pet_CP = battleAction.restorePetCp;
                     if(Battle.type == TYPE_NETWORK)
                     {
                        if(attacker.pet && attacker.pet.petMaxEp > 0)
                        {
                           attacker.pet.updatePetCP(Item_Restore_Pet_CP);
                        }
                     }
                     if(attacker.pet)
                     {
                        attacker.pet.updateBattleFrame();
                        attacker.showOverheadNumber(Timeline.WORD,"+" + Item_Restore_Pet_CP + " " + AppData.lang == AppData.ZH?"寵物CP":"Pet CP");
                     }
               }
               break;
            case "special":
               switch(battleAction.effect.type)
               {
                  case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_DEFENDER:
                     effect = battleAction.effect;
                     arr_effect = [];
                     if(effect.EffectArray)
                     {
                        arr_effect = effect.EffectArray;
                        PET_randomeffectchance = NumberUtil.getRandom();
                        PET_RandomPos = 0;
                        PetRandEffect = {};
                        OverHeadString = "";
                        for(z = 0; z < arr_effect.length; z++)
                        {
                           if(PET_randomeffectchance >= arr_effect[z].chance)
                           {
                              PET_RandomPos = z;
                           }
                        }
                        PetRandEffect = arr_effect[PET_RandomPos];
                        OverHeadString = GetOverHeadString(PetRandEffect);
                        if(!battleAction.dodge)
                        {
                           if(PetRandEffect.isDebuff == true)
                           {
                              if(defender.setBattleDebuff(PetRandEffect))
                              {
                                 defender.showOverheadNumber(Timeline.WORD,OverHeadString);
                                 if(PetRandEffect.type == BattleData.EFFECT_COLLIDING_WAVE)
                                 {
                                    Pet_colliding_wave_effect = {};
                                    Pet_colliding_wave_effect.type = BattleData.EFFECT_STUN;
                                    Pet_colliding_wave_effect.duration = PetRandEffect.duration;
                                    defender.setBattleDebuff(Pet_colliding_wave_effect);
                                 }
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                           }
                           else
                           {
                              defender.setBattleBuff(PetRandEffect);
                              defender.showOverheadNumber(Timeline.WORD,OverHeadString);
                           }
                        }
                     }
                     break;
                  case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_MASTER:
                     effect = battleAction.effect;
                     arr_effect_master = [];
                     if(effect.EffectArray)
                     {
                        arr_effect_master = effect.EffectArray;
                        PET_randomeffect_master_chance = NumberUtil.getRandom();
                        PET_Random_master_Pos = 0;
                        PetRand_master_Effect = {};
                        master_OverHeadString = "";
                        for(c = 0; c < arr_effect_master.length; c++)
                        {
                           if(PET_randomeffect_master_chance >= arr_effect_master[c].chance)
                           {
                              PET_Random_master_Pos = c;
                           }
                        }
                        PetRand_master_Effect = arr_effect_master[PET_Random_master_Pos];
                        master_OverHeadString = GetOverHeadString(PetRand_master_Effect);
                        switch(PetRand_master_Effect.type)
                        {
                           case SkillData.EFFECT_TYPE_HEAL:
                              healTarget();
                              break;
                           case BattleData.EFFECT_RESTORE_CP:
                              defender.showOverheadNumber(Timeline.WORD,master_OverHeadString + PetRand_master_Effect.amount);
                              defender.updateCP(PetRand_master_Effect.amount);
                              break;
                           case BattleData.EFFECT_COOLDOWN_REDUCTION:
                              defender.showOverheadNumber(Timeline.WORD,master_OverHeadString);
                              arr_MasterSkill = defender.getData(DBCharacterData.SKILLS);
                              cooldown_Masterskillkey = 0;
                              cooldown_MasterskillID = "";
                              cooldown_MastertmpVal = 0;
                              for(cooldown_Masterskillkey = 0; cooldown_Masterskillkey < arr_MasterSkill.length; cooldown_Masterskillkey++)
                              {
                                 cooldown_MasterskillID = arr_MasterSkill[cooldown_Masterskillkey];
                                 if(defender.isBattleSkillCooldown(cooldown_MasterskillID))
                                 {
                                    cooldown_MastertmpVal = defender.getBattleSkillCooldown(cooldown_MasterskillID);
                                    cooldown_MastertmpVal = cooldown_MastertmpVal - int(PetRand_master_Effect.amount);
                                    if(cooldown_MastertmpVal <= 0)
                                    {
                                       cooldown_MastertmpVal = 0;
                                    }
                                    defender.battleSkillCooldown[cooldown_MasterskillID] = cooldown_MastertmpVal;
                                 }
                              }
                        }
                     }
               }
               damageTarget();
               break;
            case "bloodline":
               battleAction_effect = battleAction.effect;
               battleAction_skillId = "";
               if(battleAction.BLSKILLID)
               {
                  battleAction_skillId = battleAction.BLSKILLID;
               }
               bl_effect_1 = {};
               bl_effect_2 = {};
               bl_effect_3 = {};
               battleAction_effect_Arr = [];
               if(battleAction_effect.effect_type_1 && battleAction_effect.effect_type_1 != "")
               {
                  bl_effect_1.type = battleAction_effect.effect_type_1;
                  bl_effect_1.duration = battleAction_effect.duration_1;
                  bl_effect_1.target = battleAction_effect.effect_target_1;
                  bl_effect_1.chancetohit = battleAction_effect.effect_chancetohit_1;
                  bl_effect_1.chancetoeffect = battleAction_effect.effect_chancetoeffect_1;
                  bl_effect_1.requirement = battleAction_effect.effect_requirement_1;
                  bl_effect_1.amount = battleAction_effect.effect_amount_1;
                  bl_effect_1.hit = battleAction_effect.effect_hit_1;
                  bl_effect_1.resisted = !!battleAction_effect.effect_resisted_1?battleAction_effect.effect_resisted_1:false;
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
                  bl_effect_2.hit = battleAction_effect.effect_hit_2;
                  bl_effect_2.resisted = !!battleAction_effect.effect_resisted_2?battleAction_effect.effect_resisted_2:false;
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
                  bl_effect_3.hit = battleAction_effect.effect_hit_3;
                  bl_effect_3.resisted = !!battleAction_effect.effect_resisted_3?battleAction_effect.effect_resisted_3:false;
                  battleAction_effect_Arr.push(bl_effect_3);
               }
               OverHeadWord = "";
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
               for(i = 0; i < battleAction_effect_Arr.length; i++)
               {
                  if(battleAction_effect_Arr[i].type != "")
                  {
                     showBloodlineEffect(battleAction_effect_Arr[i],battleAction_skillId,battleAction);
                  }
               }
               damageTarget();
               break;
            case "senjutsu":
               senjutsu_effect = battleAction.effect;
               senjutsu_skillId = "";
               if(battleAction.SENSKILLID)
               {
                  senjutsu_skillId = battleAction.SENSKILLID;
               }
               sen_effect_1 = {};
               sen_effect_2 = {};
               sen_effect_3 = {};
               senjutsu_effect_Arr = [];
               if(senjutsu_effect.effect_type_1 && senjutsu_effect.effect_type_1 != "")
               {
                  sen_effect_1.type = senjutsu_effect.effect_type_1;
                  sen_effect_1.duration = senjutsu_effect.duration_1;
                  sen_effect_1.target = senjutsu_effect.effect_target_1;
                  sen_effect_1.chancetohit = senjutsu_effect.effect_chancetohit_1;
                  sen_effect_1.chancetoeffect = senjutsu_effect.effect_chancetoeffect_1;
                  sen_effect_1.requirement = senjutsu_effect.effect_requirement_1;
                  sen_effect_1.amount = senjutsu_effect.effect_amount_1;
                  sen_effect_1.hit = senjutsu_effect.effect_hit_1;
                  sen_effect_1.resisted = senjutsu_effect.effect_resisted_1;
                  senjutsu_effect_Arr.push(sen_effect_1);
               }
               if(senjutsu_effect.effect_type_2 && senjutsu_effect.effect_type_2 != "")
               {
                  sen_effect_2.type = senjutsu_effect.effect_type_2;
                  sen_effect_2.duration = senjutsu_effect.duration_2;
                  sen_effect_2.target = senjutsu_effect.effect_target_2;
                  sen_effect_2.chancetohit = senjutsu_effect.effect_chancetohit_2;
                  sen_effect_2.chancetoeffect = senjutsu_effect.effect_chancetoeffect_2;
                  sen_effect_2.requirement = senjutsu_effect.effect_requirement_2;
                  sen_effect_2.amount = senjutsu_effect.effect_amount_2;
                  sen_effect_2.hit = senjutsu_effect.effect_hit_2;
                  sen_effect_2.resisted = senjutsu_effect.effect_resisted_2;
                  senjutsu_effect_Arr.push(sen_effect_2);
               }
               if(senjutsu_effect.effect_type_3 && senjutsu_effect.effect_type_3 != "")
               {
                  sen_effect_3.type = senjutsu_effect.effect_type_3;
                  sen_effect_3.duration = senjutsu_effect.duration_3;
                  sen_effect_3.target = senjutsu_effect.effect_target_3;
                  sen_effect_3.chancetohit = senjutsu_effect.effect_chancetohit_3;
                  sen_effect_3.chancetoeffect = senjutsu_effect.effect_chancetoeffect_3;
                  sen_effect_3.requirement = senjutsu_effect.effect_requirement_3;
                  sen_effect_3.amount = senjutsu_effect.effect_amount_3;
                  sen_effect_3.hit = senjutsu_effect.effect_hit_3;
                  sen_effect_3.resisted = senjutsu_effect.effect_resisted_3;
                  senjutsu_effect_Arr.push(sen_effect_3);
               }
               OverHeadWord = "";
               isSelfBuff = true;
               for(i = 0; i < senjutsu_effect_Arr.length; i++)
               {
                  if(senjutsu_effect_Arr[i].target != 0 && senjutsu_effect_Arr[i].target != 3 && senjutsu_effect_Arr[i].target != 4 && senjutsu_effect_Arr[i].target != 6)
                  {
                     isSelfBuff = false;
                  }
               }
               if(isSelfBuff)
               {
                  battleAction.dodge = false;
               }
               for(i = 0; i < senjutsu_effect_Arr.length; i++)
               {
                  showSenjutsuEffect(senjutsu_effect_Arr[i],senjutsu_skillId,battleAction);
               }
               damageTarget();
               break;
            case "event_action":
               damageTarget();
         }
         checkBloodlineHpCpChange(battleAction);
         checkSenjutsuHpCpChange(battleAction);
         if(Battle.type == TYPE_LOCAL)
         {
            if(battleAction.attackerExtraHp != null)
            {
               if(battleAction.attackerExtraHp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.attackerExtraHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(battleAction.attackerExtraHp);
                  }
               }
            }
            if(battleAction.attackerExtraCp != null)
            {
               if(battleAction.attackerExtraCp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.attackerExtraCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(battleAction.attackerExtraCp);
                  }
               }
            }
            if(battleAction.attackerExtraSp != null)
            {
               if(battleAction.attackerExtraSp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.attackerExtraSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateSP(battleAction.attackerExtraSp);
                  }
               }
            }
            if(battleAction.defenderExtraHp != null)
            {
               if(battleAction.defenderExtraHp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.defenderExtraHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(battleAction.defenderExtraHp);
                  }
               }
            }
            if(battleAction.defenderExtraCp != null)
            {
               trace("1111111111111111111111111111111111111111111111111111111");
               if(battleAction.defenderExtraCp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.defenderExtraCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(battleAction.defenderExtraCp);
                  }
               }
            }
            if(battleAction.defenderExtraSp != null)
            {
               if(battleAction.defenderExtraSp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.defenderExtraSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateSP(battleAction.defenderExtraSp);
                  }
               }
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(battleAction.extraRestore)
            {
               if(battleAction.extraRestore.length > 0)
               {
                  for(j = 0; j < battleAction.extraRestore.length; j++)
                  {
                     restoreObj = battleAction.extraRestore[j];
                     target = getCharacterById(restoreObj.charId);
                     switch(restoreObj.type)
                     {
                        case "hp":
                           if(restoreObj.amount != 0)
                           {
                              target.showOverheadNumber(Timeline.WORD,"+" + restoreObj.amount + Central.main.langLib.titleTxt(TitleData.HP));
                              target.updateHP(restoreObj.amount);
                           }
                           break;
                        case "cp":
                           if(restoreObj.amount != 0)
                           {
                              trace("111111111111111111111111111111111111111111111111111111132131313");
                              target.showOverheadNumber(Timeline.WORD,"+" + restoreObj.amount + Central.main.langLib.titleTxt(TitleData.CP));
                              target.updateCP(restoreObj.amount);
                           }
                           break;
                        case "sp":
                           if(restoreObj.amount != 0)
                           {
                              target.showOverheadNumber(Timeline.WORD,"+" + restoreObj.amount + Central.main.langLib.titleTxt(TitleData.SP));
                              target.updateSP(restoreObj.amount);
                           }
                     }
                  }
               }
            }
         }
         Main.updateMenu();
      }
      
      public static function showBloodlineEffect(effect:Object, battleAction_skillId:String, battleAction:Object = null, effect_target:* = null) : void
      {
         var i:int = 0;
         var checkDodgeChar:* = undefined;
         var arr_DefenderSkill:Array = null;
         var k:int = 0;
         var rNum:Number = NaN;
         var OverHeadWord:* = "";
         var arr_AttackerSkill:Array = null;
         var effectreq:String = "";
         var reqArr:Array = null;
         var Cooldown_Amount:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = "";
         var cooldown_tmpVal:int = 0;
         var not_stack_array:Array = [];
         not_stack_array = BloodlineData.NOT_STACK_ARRAY;
         var bl_resisted:Boolean = false;
         var bl_dodge:Boolean = false;
         var targetArr:Array = [];
         if(Battle.type == TYPE_LOCAL && battleAction.dodge == false || Battle.type == TYPE_NETWORK)
         {
            if(effect.hit != false)
            {
               if(effect.duration == 0)
               {
                  if(Battle.type == TYPE_LOCAL && effect.resisted == false || Battle.type == TYPE_LOCAL && effect.resisted == null || Battle.type == TYPE_NETWORK)
                  {
                     switch(effect.type)
                     {
                        case BloodlineData.EFFECT_CLEAR_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           if(effect.target == BloodlineData.TARGET_SELF)
                           {
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(battleAction.dodge && battleAction.dodge[attacker.getCharacterId()] == false)
                                 {
                                    if(checkResisted(effect.resisted,attacker) == false)
                                    {
                                       attacker.clearBuff();
                                       attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                                    }
                                 }
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                              }
                           }
                           else if(effect.target == BloodlineData.TARGET_ENEMY)
                           {
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(effect_target == null)
                                 {
                                    if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == false)
                                    {
                                       if(checkResisted(effect.resisted,defender) == false)
                                       {
                                          defender.clearBuff();
                                       }
                                       defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                                    }
                                 }
                                 else if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == false)
                                 {
                                    if(checkResisted(effect.resisted,effect_target) == false)
                                    {
                                       effect_target.clearBuff();
                                    }
                                    effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord);
                                 }
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_UPDATE_HP:
                        case BloodlineData.EFFECT_UPDATE_HP_CP:
                        case BloodlineData.EFFECT_DRAIN_HP:
                           if(effect.target == BloodlineData.TARGET_SELF)
                           {
                              if(haveSkill268HpEffect())
                              {
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    if(battleAction.dodge && battleAction.dodge[attacker.getCharacterId()] == false)
                                    {
                                       if(checkResisted(effect.resisted,attacker) == false)
                                       {
                                          attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                       }
                                    }
                                 }
                                 else
                                 {
                                    attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                 }
                              }
                           }
                           else if(effect.target == BloodlineData.TARGET_ENEMY)
                           {
                              if(haveSkill268HpEffect())
                              {
                                 if(Battle.type == TYPE_NETWORK)
                                 {
                                    if(battleAction.dodge && battleAction.dodge[attacker.getCharacterId()] == false)
                                    {
                                       if(checkResisted(effect.resisted,attacker) == false)
                                       {
                                          attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                       }
                                    }
                                 }
                                 else
                                 {
                                    attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1363)));
                                 }
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              addSkillCoolDown(effect,battleAction);
                           }
                           else
                           {
                              if(effect.amount < 0)
                              {
                                 OverHeadWord = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " ";
                              }
                              else
                              {
                                 OverHeadWord = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + ";
                              }
                              if(effect.target == BloodlineData.TARGET_SELF)
                              {
                                 Cooldown_Amount = effect.amount;
                                 arr_AttackerSkill = attacker.getData(DBCharacterData.SKILLS);
                                 cooldown_skillkey = battleAction.AttackerRandomSkillSlot;
                                 if(cooldown_skillkey != 999)
                                 {
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       cooldown_skillID = arr_AttackerSkill[cooldown_skillkey];
                                       cooldown_tmpVal = attacker.getBattleSkillCooldown(cooldown_skillID);
                                       cooldown_tmpVal = cooldown_tmpVal + Cooldown_Amount;
                                       if(cooldown_tmpVal <= 0)
                                       {
                                          cooldown_tmpVal = 0;
                                       }
                                       if(checkResisted(effect.resisted,attacker) == false)
                                       {
                                          attacker.battleSkillCooldown[cooldown_skillID] = cooldown_tmpVal;
                                          attacker.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount));
                                       }
                                    }
                                    else
                                    {
                                       attacker.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount));
                                    }
                                 }
                              }
                              else if(effect.target == BloodlineData.TARGET_ENEMY)
                              {
                                 Cooldown_Amount = effect.amount;
                                 if(effect_target == null)
                                 {
                                    arr_DefenderSkill = defender.getData(DBCharacterData.SKILLS);
                                 }
                                 else
                                 {
                                    arr_DefenderSkill = effect_target.getData(DBCharacterData.SKILLS);
                                 }
                                 cooldown_skillkey = battleAction.DefenderRandomSkillSlot;
                                 if(cooldown_skillkey != 999)
                                 {
                                    if(Battle.type == TYPE_NETWORK)
                                    {
                                       cooldown_skillID = arr_DefenderSkill[cooldown_skillkey];
                                       cooldown_tmpVal = defender.getBattleSkillCooldown(cooldown_skillID);
                                       cooldown_tmpVal = cooldown_tmpVal + Cooldown_Amount;
                                       if(cooldown_tmpVal <= 0)
                                       {
                                          cooldown_tmpVal = 0;
                                       }
                                       if(effect_target == null)
                                       {
                                          if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == false)
                                          {
                                             if(checkResisted(effect.resisted,defender) == false)
                                             {
                                                defender.battleSkillCooldown[cooldown_skillID] = cooldown_tmpVal;
                                                defender.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount));
                                             }
                                          }
                                       }
                                       else if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == false)
                                       {
                                          if(checkResisted(effect.resisted,effect_target) == false)
                                          {
                                             effect_target.battleSkillCooldown[cooldown_skillID] = cooldown_tmpVal;
                                             effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount));
                                          }
                                       }
                                    }
                                    else
                                    {
                                       defender.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount));
                                    }
                                 }
                              }
                           }
                           OverHeadWord = "";
                           break;
                        case BloodlineData.EFFECT_CLEAR_ALL_TARGET_BUFF:
                           OverHeadWord = Central.main.langLib.get(737);
                           if(Battle.type == Battle.TYPE_NETWORK)
                           {
                              if(battleAction.isClearBuff)
                              {
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
                                    targetArr[k].showOverheadNumber(Timeline.WORD,OverHeadWord);
                                    targetArr[k].clearBuff();
                                 }
                              }
                           }
                           else
                           {
                              switch(int(effect.target))
                              {
                                 case BloodlineData.TARGET_ENEMY:
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
                                    rNum = NumberUtil.getRandom();
                                    if(rNum <= effect.amount / 100)
                                    {
                                       for(k = 0; k < targetArr.length; k++)
                                       {
                                          targetArr[k].showOverheadNumber(Timeline.WORD,OverHeadWord);
                                          targetArr[k].clearBuff();
                                       }
                                    }
                              }
                           }
                           break;
                        case BloodlineData.EFFECT_RESTORE_ALL_PARTY:
                           healTarget();
                     }
                  }
               }
               else
               {
                  switch(effect.type)
                  {
                     case BloodlineData.EFFECT_ACCURATE:
                        if(effect.amount > 0)
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
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(740);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(670);
                        }
                        break;
                     case BloodlineData.EFFECT_DODGE:
                        if(effect.amount > 0)
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
                        OverHeadWord = Central.main.langLib.get(743);
                        break;
                     case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(744);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(800);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(745);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(801);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                        effectreq = effect.requirement;
                        effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                        effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                        effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                        effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                        effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                        effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                        effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                        reqArr = null;
                        reqArr = effectreq.split(",");
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(746);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(801);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(747);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(688);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(748);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(802);
                        }
                        break;
                     case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                        effectreq = effect.requirement;
                        effectreq = String(effectreq).replace("fire",Central.main.langLib.titleTxt(TitleData.FIRE));
                        effectreq = String(effectreq).replace("wind",Central.main.langLib.titleTxt(TitleData.WIND));
                        effectreq = String(effectreq).replace("lightning",Central.main.langLib.titleTxt(TitleData.THUNDER));
                        effectreq = String(effectreq).replace("water",Central.main.langLib.titleTxt(TitleData.WATER));
                        effectreq = String(effectreq).replace("earth",Central.main.langLib.titleTxt(TitleData.EARTH));
                        effectreq = String(effectreq).replace("taijutsu",Central.main.langLib.btnTxt(ButtonData.TAIJUTSU));
                        effectreq = String(effectreq).replace("genjutsu",Central.main.langLib.btnTxt(ButtonData.GENJUTSU));
                        reqArr = null;
                        reqArr = effectreq.split(",");
                        if(effect.amount > 0)
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
                        break;
                     case BloodlineData.EFFECT_STUN:
                        OverHeadWord = Central.main.langLib.get(281);
                        break;
                     case BloodlineData.EFFECT_UPDATE_CP:
                        OverHeadWord = "";
                        break;
                     case BloodlineData.EFFECT_UPDATE_HP:
                        OverHeadWord = "";
                        if(battleAction_skillId == "skill1019")
                        {
                           OverHeadWord = Central.main.langLib.get(753);
                        }
                        if(battleAction_skillId == "skill1011")
                        {
                           OverHeadWord = Central.main.langLib.get(1735);
                        }
                        break;
                     case BloodlineData.EFFECT_RESTRICT_CHARGE:
                        OverHeadWord = Central.main.langLib.get(754);
                        break;
                     case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                        if(effect.amount > 0)
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
                        if(effect.amount > 0)
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
                        if(effect.amount > 0)
                        {
                           OverHeadWord = Central.main.langLib.get(805);
                        }
                        else
                        {
                           OverHeadWord = Central.main.langLib.get(762);
                        }
                        if(Battle.type == TYPE_NETWORK)
                        {
                           if(effect_target == null)
                           {
                              if(checkResisted(effect.resisted,defender) == false)
                              {
                                 defender.setBattleDebuff(effect);
                              }
                           }
                           else if(checkResisted(effect.resisted,effect_target) == false)
                           {
                              effect_target.setBattleDebuff(effect);
                           }
                        }
                        break;
                     case BloodlineData.EFFECT_EXTREME:
                        if(effect_target == null)
                        {
                           if(checkResisted(effect.resisted,defender) == false)
                           {
                           }
                        }
                        else if(checkResisted(effect.resisted,effect_target) == false)
                        {
                        }
                        OverHeadWord = Central.main.langLib.get(763);
                        break;
                     case BloodlineData.EFFECT_HALLUCINATIONS:
                        OverHeadWord = Central.main.langLib.get(734);
                        break;
                     case BloodlineData.EFFECT_BUNDLE:
                        OverHeadWord = Central.main.langLib.get(325);
                        break;
                     case BloodlineData.EFFECT_PET_FREEZE:
                        OverHeadWord = Central.main.langLib.get(820);
                        break;
                     case BloodlineData.EFFECT_REDUCE_CP:
                        OverHeadWord = Central.main.langLib.get(1657);
                        break;
                     case BloodlineData.EFFECT_BL_UPDATE_HP_FIX_NUM:
                        OverHeadWord = Central.main.langLib.get(2011);
                  }
                  if(not_stack_array.indexOf(effect.type) < 0)
                  {
                     if(effect.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER || effect.type == BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER)
                     {
                        effect.type = effect.type + "." + battleAction_skillId + effect.requirement;
                     }
                     else
                     {
                        effect.type = effect.type + "." + battleAction_skillId;
                     }
                  }
                  switch(int(effect.target))
                  {
                     case BloodlineData.TARGET_SELF:
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                              if(checkResisted(effect.resisted,attacker) == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                           }
                        }
                        else if(checkResisted(effect.resisted,attacker) == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_ENEMY:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              bl_resisted = false;
                           }
                           else
                           {
                              bl_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           bl_dodge = false;
                           if(effect_target == null)
                           {
                              bl_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                           else
                           {
                              bl_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                        }
                        if(bl_resisted == false && bl_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 if(effect_target == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                                 else
                                 {
                                    effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                              }
                           }
                           else if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(bl_dodge == false)
                        {
                           if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        break;
                     case BloodlineData.TARGET_ARRACKER_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              bl_resisted = false;
                           }
                           else
                           {
                              bl_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           bl_dodge = false;
                           if(effect_target == null)
                           {
                              bl_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                           else
                           {
                              bl_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                        }
                        if(bl_resisted == false && bl_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(bl_dodge == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_MAIN_CHARACTER_BUFF:
                        if(effect.type != BloodlineData.EFFECT_MAX_HP && effect.type != BloodlineData.EFFECT_MAX_CP && effect.type != BloodlineData.EFFECT_SPEED)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 Central.main.getMainChar().showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              Central.main.getMainChar().showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        break;
                     case BloodlineData.TARGET_SELF_AND_ENEMY_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              bl_resisted = false;
                           }
                           else
                           {
                              bl_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           bl_dodge = false;
                           if(effect_target == null)
                           {
                              bl_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                           else
                           {
                              bl_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 bl_dodge = true;
                              }
                           }
                        }
                        if(bl_resisted == false && bl_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 if(effect_target == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                                 else
                                 {
                                    effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                              }
                           }
                           else if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(bl_dodge == false)
                        {
                           if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              bl_resisted = false;
                           }
                           else
                           {
                              bl_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           bl_resisted = checkResisted(effect.resisted,attacker);
                        }
                        if(bl_resisted == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case BloodlineData.TARGET_ENEMY_ALL:
                        targetArr = [defender];
                        if(attacker.side == BattleData.SIDE_FRIENDLY)
                        {
                           targetArr = enemyArr;
                        }
                        else
                        {
                           targetArr = [];
                           targetArr.push(Main.getMainChar());
                           if(partyArr)
                           {
                              targetArr = targetArr.concat(partyArr);
                           }
                        }
                        for(k = 0; k < targetArr.length; k++)
                        {
                           if(Battle.type == TYPE_LOCAL)
                           {
                              if(!effect.resisted)
                              {
                                 bl_resisted = false;
                              }
                              else
                              {
                                 bl_resisted = true;
                              }
                           }
                           else if(Battle.type == TYPE_NETWORK)
                           {
                              bl_dodge = false;
                              if(effect_target == null)
                              {
                                 bl_resisted = checkResisted(effect.resisted,targetArr[k]);
                                 if(battleAction.dodge && battleAction.dodge[targetArr[k].getCharacterId()] == true)
                                 {
                                    bl_dodge = true;
                                 }
                              }
                              else
                              {
                                 bl_resisted = checkResisted(effect.resisted,effect_target);
                                 if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                                 {
                                    bl_dodge = true;
                                 }
                              }
                           }
                           if(bl_resisted == false && bl_dodge == false)
                           {
                              if(reqArr)
                              {
                                 for(i = 0; i < reqArr.length; i++)
                                 {
                                    if(effect_target == null)
                                    {
                                       if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                       {
                                          targetArr[k].showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                       }
                                    }
                                    else
                                    {
                                       effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                    }
                                 }
                              }
                              else if(effect_target == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                 {
                                    targetArr[k].showOverheadNumber(Timeline.WORD,OverHeadWord);
                                 }
                              }
                              else
                              {
                                 effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else if(bl_dodge == false)
                           {
                              if(effect_target == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                 {
                                    targetArr[k].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                                 }
                              }
                              else
                              {
                                 effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                        }
                  }
                  if(String(effect.type).split(".")[0] == BloodlineData.EFFECT_MAX_CP_RECOVER)
                  {
                     if(Battle.type == TYPE_NETWORK)
                     {
                        if(effect_target == null)
                        {
                           defender.setBattleBuff(effect);
                           defender.updateCP(0);
                        }
                        else
                        {
                           effect_target.setBattleBuff(effect);
                           effect_target.updateCP(0);
                        }
                        Main.updateMenu();
                     }
                  }
               }
            }
         }
         attacker.updateBattleFrame();
         if(effect_target == null)
         {
            defender.updateBattleFrame();
         }
         else
         {
            effect_target.updateBattleFrame();
         }
         Main.updateMenu();
      }
      
      public static function haveSkill268HpEffect() : Boolean
      {
         var key:* = null;
         var attackerBuff:Object = attacker.getBattleBuff();
         while(true)
         {
            loop0:
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
                           break loop0;
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
            return false;
         }
         return true;
      }
      
      public static function showSenjutsuEffect(effect:Object, battleAction_skillId:String, battleAction:Object = null, effect_target:* = null) : void
      {
         var i:int = 0;
         var checkDodgeChar:* = undefined;
         var targetArr:Array = null;
         var k:int = 0;
         Out.debug("","showSenjutsuEffect effect.type" + effect.type);
         Out.debug("","effect.duration:" + effect.duration);
         Out.debug(""," effect.hit=" + effect.hit);
         Out.debug("","effect.resisted=" + effect.resisted);
         var OverHeadWord:* = "";
         var arr_AttackerSkill:Array = null;
         var effectreq:String = "";
         var reqArr:Array = null;
         var Cooldown_Amount:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = "";
         var cooldown_tmpVal:int = 0;
         var not_stack_array:Array = [];
         var sen_resisted:Boolean = false;
         var sen_dodge:Boolean = false;
         if(Battle.type == TYPE_LOCAL && battleAction.dodge == false || Battle.type == TYPE_NETWORK)
         {
            if(effect.hit != false)
            {
               if(effect.duration == 0)
               {
                  if(Battle.type == TYPE_LOCAL && effect.resisted == false || Battle.type == TYPE_LOCAL && effect.resisted == null || Battle.type == TYPE_NETWORK)
                  {
                     switch(effect.type)
                     {
                        case BattleData.EFFECT_DAMAGE_SHIELD:
                           if(battleAction.damageShield)
                           {
                              attacker.damageShield = battleAction.damageShield;
                              Out.debug("Battle","attacker.damageShield = " + battleAction.damageShield);
                           }
                           else
                           {
                              Out.debug("Battle","rex0624: damage shield don\'t exsit!! ");
                           }
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[2] + "(HP:" + attacker.damageShield + ")");
                           break;
                        case SenjutsuData.EFFECT_SS_REDUCE_AGILITY_DMG_BONUS:
                           if(defender.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY) || defender.isBattleDebuffActive(BattleData.EFFECT_REDUCE_AGILITY + ".skill3002"))
                           {
                              Out.debug("Battle>showSenjutsuEffect","battleAction.effect.damageHp=" + int(battleAction.effect.damageHp));
                              if(Battle.type == TYPE_NETWORK)
                              {
                                 if(battleAction.isReduceAgility == null)
                                 {
                                    Out.debug("","skill3003 not dmg bonus XXX");
                                 }
                                 defender.updateHP(-int(battleAction.effect.damageHp));
                              }
                              else
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(int(-1 * battleAction.dmg * effect.amount / 100)));
                              }
                           }
                           break;
                        case BattleData.EFFECT_LOSS_HP_DMG_BONUS:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              if(battleAction.dodge && battleAction.dodge[attacker.getCharacterId()] == false)
                              {
                                 if(checkResisted(effect.resisted,defender) == false)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[5]);
                                 }
                              }
                           }
                           else
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[4]);
                           }
                           break;
                        case SenjutsuData.EFFECT_SS_JUSTU_STEAL:
                           if(Battle.type == TYPE_NETWORK)
                           {
                              Out.debug(null,"on EFFECT_SS_JUSTU_STEAL, [1], battleAction=" + GF.printObject(battleAction));
                              if(!battleAction.dodge || !battleAction.dodge[defender.getCharacterId()] || battleAction.dodge[defender.getCharacterId()] == false)
                              {
                                 defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[9]);
                                 defender.setBattleSkillCooldown("skill" + battleAction.stealSkillId,int(effect.amount));
                              }
                           }
                           else
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[9]);
                           }
                           break;
                        case SenjutsuData.EFFECT_SS_DODGE_IGNORE:
                           break;
                        case BattleData.EFFECT_DRAIN_MAX_SP:
                           attacker.showOverheadNumber(Timeline.WORD,"Skill 3010");
                           break;
                        case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
                           attacker.showOverheadNumber(Timeline.WORD,"Skill 3110");
                     }
                  }
               }
               else
               {
                  switch(effect.type)
                  {
                     case SenjutsuData.EFFECT_SENNIN_MODE:
                        break;
                     case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
                        if(effect.type != SenjutsuData.EFFECT_SS_MAX_HP)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 Central.main.getMainChar().showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              Central.main.getMainChar().showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        break;
                     case BattleData.EFFECT_REDUCE_AGILITY:
                        OverHeadWord = Central.main.langLib.get(2001)[0];
                        break;
                     case BattleData.EFFECT_PETRIFICATION:
                        OverHeadWord = Central.main.langLib.get(954);
                        break;
                     case BattleData.EFFECT_POISON:
                        OverHeadWord = Central.main.langLib.get(321);
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                        if(defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
                        {
                           OverHeadWord = Central.main.langLib.get(2001)[1] + "Extra";
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                        if(!defender.isBattleDebuffActive(BattleData.EFFECT_POISON))
                        {
                           OverHeadWord = Central.main.langLib.get(2001)[1];
                        }
                        break;
                     case SenjutsuData.EFFECT_SS_CRITICAL_CHANCE_BONUS:
                        OverHeadWord = Central.main.langLib.get(292);
                        Out.debug("battle","EFFECT_SS_CRITICAL_CHANCE_BONUS :: " + OverHeadWord);
                        break;
                     case SenjutsuData.EFFECT_SS_SKIP_BATTLE_TURN:
                        OverHeadWord = Central.main.langLib.get(2001)[8];
                        Out.debug("battle","EFFECT_SS_SKIP_BATTLE_TURN :: " + OverHeadWord);
                        break;
                     case BattleData.EFFECT_DAMAGE_BONUS_BY_SP:
                        OverHeadWord = Central.main.langLib.get(330);
                        break;
                     case SenjutsuData.EFFECT_SS_BUNDLE_TALENT:
                        OverHeadWord = Central.main.langLib.get(2001)[6];
                        break;
                     case SenjutsuData.EFFECT_SS_BURN_HP_CP_SP:
                        OverHeadWord = Central.main.langLib.get(2008);
                        Out.debug("","showSenjutsuEffect > word > skill3106");
                        break;
                     case SenjutsuData.EFFECT_SS_IGNORE_DMG:
                        OverHeadWord = Central.main.langLib.get(2009);
                        break;
                     case SenjutsuData.EFFECT_SS_WEAPON_ONLY:
                        OverHeadWord = Central.main.langLib.get(2010);
                        break;
                     case SenjutsuData.EFFECT_SS_DIVIDE_CHAOS:
                        OverHeadWord = Central.main.langLib.get(2008);
                        break;
                     case SenjutsuData.EFFECT_SS_ABSORB_HPTOSP:
                        OverHeadWord = "Absorb HP to SP";
                  }
                  switch(int(effect.target))
                  {
                     case SenjutsuData.TARGET_SELF:
                     case SenjutsuData.TARGET_MAIN_CHARACTER_BUFF:
                        if(reqArr)
                        {
                           for(i = 0; i < reqArr.length; i++)
                           {
                              if(checkResisted(effect.resisted,attacker) == false)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                              else
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                              }
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                        }
                        break;
                     case SenjutsuData.TARGET_ENEMY:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              sen_resisted = false;
                           }
                           else
                           {
                              sen_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           sen_dodge = false;
                           if(effect_target == null)
                           {
                              sen_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                           else
                           {
                              sen_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                        }
                        if(sen_resisted == false && sen_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 if(effect_target == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                                 else
                                 {
                                    effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                              }
                           }
                           else if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(sen_dodge == false)
                        {
                           if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        break;
                     case SenjutsuData.TARGET_ARRACKER_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              sen_resisted = false;
                           }
                           else
                           {
                              sen_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           sen_dodge = false;
                           if(effect_target == null)
                           {
                              sen_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                           else
                           {
                              sen_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                        }
                        if(sen_resisted == false && sen_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(sen_dodge == false)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
                        break;
                     case SenjutsuData.TARGET_SELF_AND_ENEMY_DEBUFF:
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              sen_resisted = false;
                           }
                           else
                           {
                              sen_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           sen_dodge = false;
                           if(effect_target == null)
                           {
                              sen_resisted = checkResisted(effect.resisted,defender);
                              if(battleAction.dodge && battleAction.dodge[defender.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                           else
                           {
                              sen_resisted = checkResisted(effect.resisted,effect_target);
                              if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                              {
                                 sen_dodge = true;
                              }
                           }
                        }
                        if(sen_resisted == false && sen_dodge == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 if(effect_target == null)
                                 {
                                    defender.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                                 else
                                 {
                                    effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                 }
                              }
                           }
                           else if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else if(sen_dodge == false)
                        {
                           if(effect_target == null)
                           {
                              defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                           else
                           {
                              effect_target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                           }
                        }
                        if(Battle.type == TYPE_LOCAL)
                        {
                           if(!effect.resisted)
                           {
                              sen_resisted = false;
                           }
                           else
                           {
                              sen_resisted = true;
                           }
                        }
                        else if(Battle.type == TYPE_NETWORK)
                        {
                           sen_resisted = checkResisted(effect.resisted,attacker);
                        }
                        if(sen_resisted == false)
                        {
                           if(reqArr)
                           {
                              for(i = 0; i < reqArr.length; i++)
                              {
                                 attacker.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else
                           {
                              attacker.showOverheadNumber(Timeline.WORD,OverHeadWord);
                           }
                        }
                        else
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                        }
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
                           targetArr.push(Main.getMainChar());
                           if(partyArr)
                           {
                              targetArr = targetArr.concat(partyArr);
                           }
                        }
                        for(k = 0; k < targetArr.length; k++)
                        {
                           if(Battle.type == TYPE_LOCAL)
                           {
                              if(!effect.resisted)
                              {
                                 sen_resisted = false;
                              }
                              else
                              {
                                 sen_resisted = true;
                              }
                           }
                           else if(Battle.type == TYPE_NETWORK)
                           {
                              sen_dodge = false;
                              if(effect_target == null)
                              {
                                 sen_resisted = checkResisted(effect.resisted,targetArr[k]);
                                 if(battleAction.dodge && battleAction.dodge[targetArr[k].getCharacterId()] == true)
                                 {
                                    sen_dodge = true;
                                 }
                              }
                              else
                              {
                                 sen_resisted = checkResisted(effect.resisted,effect_target);
                                 if(battleAction.dodge && battleAction.dodge[effect_target.getCharacterId()] == true)
                                 {
                                    sen_dodge = true;
                                 }
                              }
                           }
                           if(sen_resisted == false && sen_dodge == false)
                           {
                              if(reqArr)
                              {
                                 for(i = 0; i < reqArr.length; i++)
                                 {
                                    if(effect_target == null)
                                    {
                                       if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                       {
                                          targetArr[k].showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                       }
                                    }
                                    else
                                    {
                                       effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                                    }
                                 }
                              }
                              else if(effect_target == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                 {
                                    targetArr[k].showOverheadNumber(Timeline.WORD,OverHeadWord);
                                 }
                              }
                              else
                              {
                                 effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                           else if(sen_dodge == false)
                           {
                              if(effect_target == null)
                              {
                                 if(Battle.type == TYPE_LOCAL || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[targetArr[k].getData(DBCharacterData.ID)] == false)
                                 {
                                    targetArr[k].showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                                 }
                              }
                              else
                              {
                                 effect_target.showOverheadNumber(Timeline.WORD,reqArr[i] + " " + OverHeadWord);
                              }
                           }
                        }
                  }
               }
            }
         }
         attacker.updateBattleFrame();
         if(effect_target == null)
         {
            defender.updateBattleFrame();
         }
         else
         {
            effect_target.updateBattleFrame();
         }
         Main.updateMenu();
      }
      
      public static function addSkillCoolDown(effect:Object, battleAction:Object) : void
      {
         var coolDownUpdate:Array = null;
         var target:* = undefined;
         var coolDownId:String = null;
         var i:int = 0;
         var OverHeadWord:* = null;
         var Cooldown_Amount:int = 0;
         var cooldown_skillkey:uint = 0;
         var cooldown_skillID:String = null;
         var cooldown_tmpVal:int = 0;
         if(battleAction.coolDownUpdate)
         {
            coolDownUpdate = battleAction.coolDownUpdate;
            Cooldown_Amount = 0;
            cooldown_skillkey = 0;
            cooldown_skillID = "";
            cooldown_tmpVal = 0;
            for(i = 0; i < coolDownUpdate.length; i++)
            {
               if(coolDownUpdate[i].amount < 0)
               {
                  OverHeadWord = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " ";
               }
               else
               {
                  OverHeadWord = Central.main.langLib.titleTxt(TitleData.COOLDOWN) + " + ";
               }
               Cooldown_Amount = coolDownUpdate[i].amount;
               cooldown_skillID = coolDownUpdate[i].skillId;
               target = getCharacterById(coolDownUpdate[i].charId);
               coolDownId = "skill" + cooldown_skillID;
               cooldown_tmpVal = target.getBattleSkillCooldown(coolDownId);
               cooldown_tmpVal = cooldown_tmpVal + Cooldown_Amount;
               if(cooldown_tmpVal <= 0)
               {
                  cooldown_tmpVal = 0;
               }
               if(battleAction.dodge && battleAction.dodge[target.getCharacterId()] == false)
               {
                  if(checkResisted(effect.resisted,target) == false)
                  {
                     target.battleSkillCooldown[coolDownId] = cooldown_tmpVal;
                     target.showOverheadNumber(Timeline.WORD,OverHeadWord + " : " + String(Cooldown_Amount - 1));
                  }
               }
            }
         }
      }
      
      public static function checkReflectGenjutsu(effect:Object) : void
      {
         var cpLost:int = 0;
         if(checkResisted(effect.resisted,attacker) == true)
         {
            attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
         }
         if(checkResisted(effect.resisted,attacker) == false)
         {
            if(effect.attackerDamageCp != null)
            {
               if(effect.attackerDamageCp < 0)
               {
                  trace("1111111111111111111111111111111111111111111111111111111321432454545");
                  attacker.showOverheadNumber(Timeline.WORD,"-" + effect.attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(effect.attackerDamageCp);
                  }
               }
            }
            if(effect.attackerRestoreCp != null)
            {
               if(effect.attackerRestoreCp > 0)
               {
                  trace("111111111111111111111111111111111111111111111111111111786876868681");
                  attacker.showOverheadNumber(Timeline.WORD,"+" + effect.attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateCP(effect.attackerRestoreCp);
                  }
               }
            }
            if(effect.attackerDamageHp != null)
            {
               if(effect.attackerDamageHp < 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"-" + effect.attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(effect.attackerDamageHp);
                  }
               }
            }
            if(effect.attackerRestoreHp != null)
            {
               if(effect.attackerRestoreHp > 0)
               {
                  attacker.showOverheadNumber(Timeline.WORD,"+" + effect.attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.updateHP(effect.attackerRestoreHp);
                  }
               }
            }
            if(effect.defenderDamageCp != null)
            {
               if(effect.defenderDamageCp < 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111111231232131232132131232131");
                  defender.showOverheadNumber(Timeline.WORD,"-" + effect.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(effect.defenderDamageCp);
                  }
               }
            }
            if(effect.defenderRestoreCp != null)
            {
               if(effect.defenderRestoreCp > 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111119989879987987987");
                  defender.showOverheadNumber(Timeline.WORD,"+" + effect.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateCP(effect.defenderRestoreCp);
                  }
               }
            }
            if(effect.defenderDamageHp != null)
            {
               if(effect.defenderDamageHp < 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"-" + effect.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(effect.defenderDamageHp);
                  }
               }
            }
            if(effect.defenderRestoreHp != null)
            {
               if(effect.defenderRestoreHp > 0)
               {
                  defender.showOverheadNumber(Timeline.WORD,"+" + effect.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     defender.updateHP(effect.defenderRestoreHp);
                  }
               }
            }
            switch(effect.type)
            {
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(744));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.addAllSkillCooldown(effect.duration);
                  }
                  break;
               case BattleData.EFFECT_CALM_TARGET:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(676)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.SKILL_336:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  defender.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpLost));
                  break;
               case BattleData.SKILL_345:
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_DARKNESS:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearBuff();
                     attacker.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(737));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(effect);
                     attacker.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_CHAOS:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.setBattleDebuff(effect);
                  }
            }
         }
      }
      
      public static function checkResisted(resisted:*, char:*) : Boolean
      {
         var charId:int = char.getData(DBCharacterData.ID);
         Out.debug("checkResisted :: ","type >> " + Battle.type);
         if(Battle.type == TYPE_LOCAL)
         {
            if(resisted && resisted == true)
            {
               return true;
            }
            if(resisted == false || resisted == null)
            {
               Out.debug("checkResisted :: ","resisted >> " + resisted);
               return false;
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(resisted && resisted[charId] && resisted[charId] == true)
            {
               return true;
            }
            if(!resisted || !resisted[charId] || resisted[charId] == false)
            {
               Out.debug("checkResisted !???:: ","resisted >> " + resisted);
               return false;
            }
         }
         Out.debug("checkResisted Last:: ","resisted >> " + resisted);
         return false;
      }
      
      public static function checkBloodlineHpCpChange(battleAction:Object) : void
      {
         if(battleAction.bl_attackerRestoreHp != null)
         {
            if(battleAction.bl_attackerRestoreHp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.bl_attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.bl_attackerRestoreHp);
               }
            }
         }
         if(battleAction.bl_attackerRestoreCp != null)
         {
            if(battleAction.bl_attackerRestoreCp > 0)
            {
               trace("1111111111111111111111111111111111111111112313213131231313213111111111111111222");
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.bl_attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.bl_attackerRestoreCp);
               }
            }
         }
         if(battleAction.bl_attackerDamageHp != null)
         {
            if(battleAction.bl_attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.bl_attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.bl_attackerDamageHp);
               }
            }
         }
         if(battleAction.bl_attackerDamageCp != null)
         {
            if(battleAction.bl_attackerDamageCp < 0)
            {
               trace("111111111111111111111111111111111111111111111111114321432312654654311111");
               attacker.showOverheadNumber(Timeline.WORD,battleAction.bl_attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.bl_attackerDamageCp);
               }
            }
         }
         if(battleAction.bl_defenderRestoreHp != null)
         {
            if(battleAction.bl_defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.bl_defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.bl_defenderRestoreHp);
               }
            }
         }
         if(battleAction.bl_defenderRestoreCp != null)
         {
            if(battleAction.bl_defenderRestoreCp > 0)
            {
               trace("1111111111111111111111111111111111111143543678698779711111111111111111");
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.bl_defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(battleAction.bl_defenderRestoreCp);
               }
            }
         }
         if(battleAction.bl_defenderDamageHp != null)
         {
            if(battleAction.bl_defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.bl_defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.bl_defenderDamageHp);
               }
            }
         }
         if(battleAction.bl_defenderDamageCp != null)
         {
            if(battleAction.bl_defenderDamageCp < 0)
            {
               trace("1111111111111111111111111111111111111111117657573645431111111111111");
               defender.showOverheadNumber(Timeline.WORD,battleAction.bl_defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(battleAction.bl_defenderDamageCp);
               }
            }
         }
      }
      
      public static function checkSenjutsuHpCpChange(battleAction:Object) : void
      {
         if(battleAction.sen_attackerRestoreHp != null)
         {
            if(battleAction.sen_attackerRestoreHp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.sen_attackerRestoreHp);
               }
            }
         }
         if(battleAction.sen_attackerRestoreCp != null)
         {
            if(battleAction.sen_attackerRestoreCp > 0)
            {
               trace("111111111111111111111111111111111111111111111111111111333333331");
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.sen_attackerRestoreCp);
               }
            }
         }
         if(battleAction.sen_attackerRestoreSp != null)
         {
            if(battleAction.sen_attackerRestoreSp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_attackerRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(battleAction.sen_attackerRestoreSp);
               }
            }
         }
         if(battleAction.sen_attackerDamageHp != null)
         {
            if(battleAction.sen_attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.sen_attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.sen_attackerDamageHp);
               }
            }
         }
         if(battleAction.sen_attackerDamageCp != null)
         {
            if(battleAction.sen_attackerDamageCp < 0)
            {
               trace("11111111111111111111114321455974328761111111111111111111111111111111111");
               attacker.showOverheadNumber(Timeline.WORD,battleAction.sen_attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.sen_attackerDamageCp);
               }
            }
         }
         if(battleAction.sen_attackerDamageSp != null)
         {
            if(battleAction.sen_attackerDamageSp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.sen_attackerDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(battleAction.sen_attackerDamageSp);
               }
            }
         }
         if(battleAction.sen_defenderRestoreHp != null)
         {
            if(battleAction.sen_defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.sen_defenderRestoreHp);
               }
            }
         }
         if(battleAction.sen_defenderRestoreCp != null)
         {
            if(battleAction.sen_defenderRestoreCp > 0)
            {
               trace("11111111111111111111745662345353211111111111111111111111111111111111");
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(battleAction.sen_defenderRestoreCp);
               }
            }
         }
         if(battleAction.sen_defenderDamageHp != null)
         {
            if(battleAction.sen_defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.sen_defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.sen_defenderDamageHp);
               }
            }
         }
         if(battleAction.sen_defenderDamageCp != null)
         {
            if(battleAction.sen_defenderDamageCp < 0)
            {
               trace("111111111111111111111145325587987687654323245111111111111111111111111111111111");
               defender.showOverheadNumber(Timeline.WORD,battleAction.sen_defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(battleAction.sen_defenderDamageCp);
               }
            }
         }
         if(battleAction.sen_defenderDamageSp != null)
         {
            if(battleAction.sen_defenderDamageSp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.sen_defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(battleAction.sen_defenderDamageSp);
               }
            }
         }
         if(battleAction.sen_defenderRestoreSp != null)
         {
            if(battleAction.sen_defenderRestoreSp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.sen_defenderRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(battleAction.sen_defenderRestoreSp);
               }
            }
         }
         for(var i:int = 0; i < characterArr.length; i++)
         {
            if(characterArr[i].RestoreHp != null)
            {
               if(characterArr[i].RestoreHp > 0)
               {
                  characterArr[i].showOverheadNumber(Timeline.WORD,"+" + characterArr[i].RestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateHP(characterArr[i].RestoreHp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreHp >> " + characterArr[i].RestoreHp);
                  characterArr[i].RestoreHp = 0;
               }
            }
            if(characterArr[i].RestoreCp != null)
            {
               if(characterArr[i].RestoreCp > 0)
               {
                  trace("11111111111111111111111111111111111111111111111111111114444444");
                  characterArr[i].showOverheadNumber(Timeline.WORD,"+" + characterArr[i].RestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateCP(characterArr[i].RestoreCp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreCp >> " + characterArr[i].RestoreCp);
                  characterArr[i].RestoreCp = 0;
               }
            }
            if(characterArr[i].RestoreSp != null)
            {
               if(characterArr[i].RestoreSp > 0)
               {
                  characterArr[i].showOverheadNumber(Timeline.WORD,"+" + characterArr[i].RestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateSP(characterArr[i].RestoreSp);
                  }
                  trace("checkSenjutsuHpCpChange RestoreSp >> " + characterArr[i].RestoreSp);
                  characterArr[i].RestoreSp = 0;
               }
            }
            if(characterArr[i].DamageHp != null)
            {
               if(characterArr[i].DamageHp < 0)
               {
                  characterArr[i].showOverheadNumber(Timeline.WORD,characterArr[i].DamageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateHP(characterArr[i].DamageHp);
                  }
                  trace("checkSenjutsuHpCpChange DamageHp >> " + characterArr[i].DamageHp);
                  characterArr[i].DamageHp = 0;
               }
            }
            if(characterArr[i].DamageCp != null)
            {
               if(characterArr[i].DamageCp < 0)
               {
                  trace("1111111111111111111111111111111111111111111111111111115555551");
                  characterArr[i].showOverheadNumber(Timeline.WORD,characterArr[i].DamageCp + Central.main.langLib.titleTxt(TitleData.CP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateCP(characterArr[i].DamageCp);
                  }
                  trace("checkSenjutsuHpCpChange DamageCp >> " + characterArr[i].DamageCp);
                  characterArr[i].DamageCp = 0;
               }
            }
            if(characterArr[i].DamageSp != null)
            {
               if(characterArr[i].DamageSp < 0)
               {
                  characterArr[i].showOverheadNumber(Timeline.WORD,characterArr[i].DamageSp + Central.main.langLib.titleTxt(TitleData.SP));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     characterArr[i].updateSP(characterArr[i].DamageSp);
                  }
                  trace("checkSenjutsuHpCpChange DamageSp >> " + characterArr[i].DamageSp);
                  characterArr[i].DamageSp = 0;
               }
            }
         }
      }
      
      private static function processDamage(dmgObj:Object) : void
      {
         var damageShieldCharacter:* = undefined;
         var effect:Object = null;
         var cpLost:int = 0;
         var hpLost:int = 0;
         var key:* = null;
         var skillData:Object = null;
         var BloodlineDamageBonus:int = 0;
         var BloodlineDamageConvert:int = 0;
         var EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR:Array = null;
         var EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR:Array = null;
         var tmpEffect:Object = null;
         var tmpBLSkillID:String = null;
         var tmpEffectCharId:String = null;
         var k:int = 0;
         var cpRegen:int = 0;
         var removeEffect:Object = null;
         var removeEffectType:String = null;
         var targetBackItem:Object = null;
         var tmpEffectB:Object = null;
         var attackerWeapon:Object = null;
         var typeName:Array = null;
         var elementType:String = null;
         var bNonTaijutsuDisplay:Boolean = false;
         var skillId:int = 0;
         var effectName:String = null;
         var maxHit:int = 0;
         var i:int = 0;
         var reboundDamage:int = 0;
         var attackPoint:Point = null;
         if(godModeHackCheck())
         {
            Main.onError("2973","");
            return;
         }
         trace("processDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamageprocessDamage");
         var target:* = getCharacterById(dmgObj.characterId);
         var battleAction:Object = attacker.getBattleAction();
         if(Battle.type == TYPE_LOCAL && battleAction.dodge || Battle.type == TYPE_NETWORK && battleAction.dodge && battleAction.dodge[target.getCharacterId()] == true)
         {
            if(target.limb && target.limb > 1)
            {
               playAction(getCharacterById(int(target.getCharacterId() / 10) * 10 + 1),"dodge");
            }
            else
            {
               playAction(target,"dodge");
            }
            target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(293) + "!");
            return;
         }
         if(defender.damageShield > 0 && defender.damageShield > Math.abs(dmgObj.dmg))
         {
            damageShieldCharacter = defender;
            Out.debug("Battle","rex0624: defender hold damageshield.");
         }
         else
         {
            damageShieldCharacter = null;
         }
         if(damageShieldCharacter != null)
         {
            Out.debug("Battle","rex0624: damageShield" + damageShieldCharacter.damageShield);
            Out.debug("Battle","rex0624: damageShieldCharacterInfo" + GF.printObject(damageShieldCharacter));
            damageShieldCharacter.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[2] + "(HP:" + damageShieldCharacter.damageShield + ")");
         }
         if(battleAction.effect != null && checkResisted(battleAction.effect.resisted,target) == false)
         {
            effect = battleAction.effect;
            switch(effect.type)
            {
               case BattleData.EFFECT_BURN_CP:
                  break;
               case BattleData.EFFECT_STUN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(281));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(battleAction.effect);
                  }
                  break;
               case BattleData.EFFECT_REDUCE_AGILITY:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[0]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(battleAction.effect);
                  }
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1]);
                  Out.debug("code_library","rex show word EFFECT_SS_MAX_CP_CHANGE < processDamage");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(battleAction.effect);
                  }
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[1] + "Extra");
                  Out.debug("code_library","rex show word EFFECT_SS_MAX_CP_CHANGE_EXTRA < processDamage");
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(battleAction.effect);
                  }
                  break;
               case BattleData.EFFECT_BLEEDING:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_BURN_FIX_NUM:
               case BattleData.EFFECT_BURN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_BUNDLE:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  cpLost = effect.damageCp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpLost));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.updateCP(0 - cpLost);
                     attacker.updateCP(cpLost);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  hpLost = effect.damageHp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(hpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(hpLost));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.updateHP(0 - hpLost);
                     attacker.updateHP(hpLost);
                  }
                  break;
               case BattleData.EFFECT_POISON:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(321));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_FEAR:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(304));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
               case BattleData.EFFECT_FEAR_WEAKEN:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_PARASITE:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(319));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  cpLost = effect.damageCp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.updateCP(0 - cpLost);
                  }
                  break;
               case BattleData.EFFECT_BURNING:
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(289)).replace("[valamt]",Math.round(effect.amount).toString()));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(287));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.SKILL_342:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1361));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleBuff(effect);
                  }
                  break;
               case BattleData.SKILL_234:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(807));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(74));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleBuff(effect);
                  }
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(596));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleBuff(effect);
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS:
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(330));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleBuff(effect);
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCTION:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(322));
                  break;
               case BattleData.EFFECT_SERENE_MIND:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(622));
                  break;
               case BattleData.SKILL_236:
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(799)));
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1357)));
                  if(effect.damageHp != null)
                  {
                     target.showOverheadNumber(Timeline.WORD,"-" + effect.damageHp + Central.main.langLib.titleTxt(TitleData.HP));
                  }
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.addSkillCooldown(4,SkillData.TYPE_WIND);
                     if(effect.damageHp != null)
                     {
                        target.updateHP(0 - effect.damageHp);
                     }
                  }
                  break;
               case BattleData.SKILL_287:
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(670)));
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1356)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.addSkillCooldown(4,SkillData.TYPE_LIGHTNING);
                     target.setBattleDebuff({
                        "type":BattleData.EFFECT_DECREASE_CRITICAL_CHANCE,
                        "duration":4,
                        "amount":20
                     });
                  }
                  break;
               case BattleData.SKILL_270:
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1365)));
                  target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1364)));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.addSkillCooldown(4,SkillData.TYPE_FIRE);
                     if(battleAction.effect.extraEffect == true)
                     {
                        target.setBattleDebuff({
                           "type":BattleData.EFFECT_DAMAGE_REDUCTION,
                           "duration":5,
                           "amount":50
                        });
                     }
                  }
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1807)[1]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleBuff(effect);
                     effect = {
                        "type":BattleData.EFFECT_PET_DEBUFF_RESIST,
                        "duration":effect.duration,
                        "amount":100
                     };
                     target.setBattleBuff(effect);
                  }
                  break;
               case BattleData.SKILL_359:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(305));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.SKILL_336:
                  cpLost = effect.damageCp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpLost));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.updateCP(0 - cpLost);
                     attacker.updateCP(cpLost);
                  }
                  break;
               case BattleData.EFFECT_PET_BURN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(288));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(801));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.setBattleDebuff(effect);
                  }
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.reduceSkillCooldown(effect.amount,BattleData.REDUCETYPE_SKILL);
                  }
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     break;
                  }
                  hpLost = effect.damageHp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(hpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(hpLost));
                  cpLost = effect.damageCp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpLost));
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                     target.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_N_INTERNAL_INJURY:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                     target.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_BURN_HP_CLEAR_BUFF:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(799));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF_WEAK:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  for each(removeEffect in battleAction.removedEffectList)
                  {
                     if(target.getData(DBCharacterData.ID) == removeEffect.targetId)
                     {
                        removeEffectType = removeEffect.type;
                        target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1809).replace("[valeffecttype]",EffectLangData.getEffectNameByType(removeEffectType)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           target.removeBuff(removeEffectType);
                           target.removeDebuff(removeEffectType);
                        }
                     }
                  }
                  break;
               case BattleData.EFFECT_CLEAR_SELF_DEBUFF_DEFENDER_BUFF:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1366));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_FINAL_ATTACK:
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2001)[3]);
                  if(Battle.type == TYPE_NETWORK)
                  {
                     attacker.clearAllDebuff();
                  }
                  break;
               case BattleData.EFFECT_CLEARBUFF:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(877));
                  if(Battle.type == TYPE_NETWORK)
                  {
                     target.clearBuff();
                  }
                  break;
               case BattleData.EFFECT_HALFHP_DAMAGE_REDUCTION:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(748));
                  break;
               case BattleData.EFFECT_HEAL_MEMBER:
                  cpLost = effect.cpDisplay;
                  cpRegen = effect.regenCP;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpRegen));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  defender.updateCP(cpRegen);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_BLEEDING:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(286) + "(" + String(effect.amount) + "%)");
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(648));
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP_N_ADD_COOLDOWN:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     break;
                  }
                  hpLost = effect.damageHp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(482) + String(hpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(483) + String(hpLost));
                  cpLost = effect.damageCp;
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(349) + String(cpLost));
                  attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(350) + String(cpLost));
                  break;
            }
         }
         if(target.getBackItem())
         {
            targetBackItem = Central.main.BACK_ITEM_DATA.find(target.getBackItem());
            if(targetBackItem)
            {
               for each(tmpEffectB in targetBackItem.effect)
               {
                  switch(tmpEffectB.type)
                  {
                     case BattleData.EFFECT_ATTACKER_FREEZE:
                        if(battleAction.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(820)));
                           battleAction.backitem_activated = false;
                        }
                        continue;
                     case BattleData.EFFECT_ATTACKER_STUN:
                        if(battleAction.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                           battleAction.backitem_activated = false;
                        }
                        continue;
                     case BattleData.EFFECT_DEFENDER_STUN:
                        if(battleAction.backitem_activated)
                        {
                           attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                           battleAction.backitem_activated = false;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(Battle.type == TYPE_NETWORK && battleAction.action == "weapon_attack")
         {
            if(attacker.getWeapon())
            {
               attackerWeapon = Central.main.WEAPON_DATA.find(attacker.getWeapon());
               if(attackerWeapon)
               {
                  for each(tmpEffect in attackerWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case "attack_reduce_cooldown.0":
                           typeName = tmpEffect.type.split(".");
                           if(Battle.type == TYPE_NETWORK)
                           {
                              attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(598));
                              switch(typeName[1])
                              {
                                 case "0":
                                    attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_ALL);
                                    break;
                                 case "1":
                                    if(typeName[2] == null)
                                    {
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
                                    attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_SKILL,elementType);
                                    break;
                                 case "2":
                                    attacker.reduceSkillCooldown(tmpEffect.amount,BattleData.REDUCETYPE_TALENT);
                              }
                           }
                           continue;
                        default:
                           continue;
                     }
                  }
               }
            }
         }
         if(dmgObj.defenderRestoreHp > 0)
         {
            target.showOverheadNumber(Timeline.HEAL,"+" + dmgObj.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
            if(Battle.type == TYPE_NETWORK)
            {
               target.updateHP(dmgObj.defenderRestoreHp);
            }
         }
         if(dmgObj.defenderRestoreCp > 0)
         {
            target.showOverheadNumber(Timeline.WORD,"+" + dmgObj.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
            if(Battle.type == TYPE_NETWORK)
            {
               target.updateCP(dmgObj.defenderRestoreCp);
            }
         }
         if(dmgObj.defenderDamageCp < 0)
         {
            target.showOverheadNumber(Timeline.WORD,dmgObj.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
            if(Battle.type == TYPE_NETWORK)
            {
               target.updateCP(dmgObj.defenderDamageCp);
            }
         }
         if(dmgObj.defenderDamageHp < 0)
         {
            target.showOverheadNumber(Timeline.WORD,dmgObj.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
            if(Battle.type == TYPE_NETWORK)
            {
               target.updateHP(dmgObj.defenderDamageHp);
            }
         }
         if(dmgObj.defenderDamageSp < 0)
         {
            target.showOverheadNumber(Timeline.WORD,dmgObj.defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
            if(Battle.type == TYPE_NETWORK)
            {
               target.updateSP(dmgObj.defenderDamageSp);
            }
         }
         if(battleAction.defenderRestoreHp != null)
         {
            if(battleAction.defenderRestoreHp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.defenderRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.defenderRestoreHp);
               }
            }
         }
         if(battleAction.defenderRestoreCp != null)
         {
            if(battleAction.defenderRestoreCp > 0)
            {
               defender.showOverheadNumber(Timeline.WORD,"+" + battleAction.defenderRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.defenderRestoreCp);
               }
            }
         }
         if(battleAction.defenderDamageCp != null)
         {
            if(battleAction.defenderDamageCp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.defenderDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateCP(battleAction.defenderDamageCp);
               }
            }
         }
         if(battleAction.defenderDamageHp != null)
         {
            if(battleAction.defenderDamageHp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.defenderDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateHP(battleAction.defenderDamageHp);
               }
            }
         }
         if(battleAction.defenderDamageSp != null)
         {
            if(battleAction.defenderDamageSp < 0)
            {
               defender.showOverheadNumber(Timeline.WORD,battleAction.defenderDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  defender.updateSP(battleAction.defenderDamageSp);
               }
            }
            Out.debug("","2015-7-13 sucees show word defender damage sp");
         }
         if(battleAction.selfhit != null)
         {
            bNonTaijutsuDisplay = false;
            skillId = 0;
            if(battleAction.skillId != null)
            {
               skillId = battleAction.skillId;
               skillData = Central.main.SKILL_DATA[battleAction.skillId];
               if(skillData != null && skillData.effect.type == BattleData.EFFECT_HEAL_MEMBER)
               {
                  bNonTaijutsuDisplay = true;
               }
            }
            if(bNonTaijutsuDisplay)
            {
               attacker.showOverheadNumber(Timeline.WORD,"-" + battleAction.selfhit + Central.main.langLib.titleTxt(TitleData.HP));
            }
            else
            {
               attacker.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(333)).replace("[valamt]",battleAction.selfhit));
            }
            if(Battle.type == TYPE_NETWORK)
            {
               attacker.updateHP(0 - battleAction.selfhit);
            }
         }
         if(battleAction.clones && battleAction.clones != null && battleAction.clones[target.getCharacterId()])
         {
            effectName = Battle.type == TYPE_LOCAL?battleAction.clones[target.getCharacterId()].effectName:battleAction.clones[target.getCharacterId()];
            switch(effectName)
            {
               case BattleData.TYPE_DUMMY:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(target,BattleData.DUMMY);
                  break;
               case BattleData.TYPE_DUMMY_BURN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(target,BattleData.DUMMY_BURN);
                  break;
               case BattleData.TYPE_DUMMY_STUN:
                  target.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(2030) + "(-1)");
                  playAction(target,BattleData.DUMMY_STUN);
            }
         }
         if(dmgObj.dmg == null)
         {
            return;
         }
         var dmg:int = dmgObj.dmg;
         var defenderBuff:Object = target.getBattleBuff();
         var defenderDebuff:Object = target.getBattleDebuff();
         for(key in defenderBuff)
         {
            if(defenderBuff[key])
            {
               if(int(defenderBuff[key].duration) > 0)
               {
                  switch(key)
                  {
                     case BattleData.SKILL_285:
                        target.showOverheadNumber(Timeline.WORD,String(Central.main.langLib.get(1355)));
                        if(Battle.type == TYPE_NETWORK)
                        {
                           target.reduceSkillCooldown(defenderBuff[key].amount,BattleData.REDUCETYPE_SKILL,SkillData.TYPE_WIND);
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
         BloodlineDamageBonus = 0;
         BloodlineDamageConvert = 0;
         skillData = Main.SKILL_DATA[battleAction.skillId];
         EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR = [];
         EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR = [];
         tmpEffect = {};
         tmpBLSkillID = "";
         if(battleAction.EFFECT_REACTIVE_DEBUFF_DEFENDER)
         {
            EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR = battleAction.EFFECT_REACTIVE_DEBUFF_DEFENDER;
            for(k = 0; k < EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR.length; k++)
            {
               tmpEffect = {};
               tmpBLSkillID = "";
               tmpEffectCharId = "";
               tmpEffect = EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR[k].Effect;
               tmpBLSkillID = EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR[k].BLSkillID;
               tmpEffectCharId = EFFECT_REACTIVE_DEBUFF_DEFENDER_ARR[k].charId;
               if(tmpEffectCharId == target.getData(DBCharacterData.ID) || tmpEffectCharId == attacker.getCharacterId())
               {
                  showBloodlineEffect(tmpEffect,tmpBLSkillID,battleAction,target);
               }
            }
            battleAction.EFFECT_REACTIVE_DEBUFF_DEFENDER = null;
         }
         if(battleAction.EFFECT_REACTIVE_DEBUFF_ATTACKER)
         {
            EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR = battleAction.EFFECT_REACTIVE_DEBUFF_ATTACKER;
            for(k = 0; k < EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR.length; k++)
            {
               tmpEffect = {};
               tmpBLSkillID = "";
               tmpEffectCharId = "";
               tmpEffect = EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR[k].Effect;
               tmpBLSkillID = EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR[k].BLSkillID;
               tmpEffectCharId = EFFECT_REACTIVE_DEBUFF_ATTACKER_ARR[k].charId;
               if(tmpEffectCharId == target.getData(DBCharacterData.ID) || tmpEffectCharId == attacker.getCharacterId())
               {
                  showBloodlineEffect(tmpEffect,tmpBLSkillID,battleAction,target);
               }
            }
            battleAction.EFFECT_REACTIVE_DEBUFF_ATTACKER = null;
         }
         if(battleAction.critical)
         {
            target.showOverheadNumber(Timeline.CRITICAL,Math.abs(dmg));
         }
         else
         {
            target.showOverheadNumber(Timeline.NORMAL,Math.abs(dmg));
         }
         if(battleAction.clones && battleAction.clones != null && battleAction.clones[target.getCharacterId()])
         {
            if(Battle.type == TYPE_LOCAL)
            {
               target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName].remainClones--;
               if(target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName].remainClones == 0)
               {
                  trace("target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName] = " + GF.printObject(target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName]));
                  target.getBattleBuff()[battleAction.clones[target.getCharacterId()].buffName] = null;
               }
            }
         }
         else
         {
            if(target.limb && target.limb > 1)
            {
               playHit(getCharacterById(int(target.getCharacterId() / 10) * 10 + 1));
            }
            else
            {
               playHit(target);
            }
            if(Battle.type == TYPE_NETWORK)
            {
               if(dmgObj.defenderRestoreHp > 0 && Math.abs(dmg) > target.hp)
               {
                  dmg = -(target.hp - dmgObj.defenderRestoreHp);
               }
               target.updateHP(dmg);
            }
         }
         if(int(battleAction.hitNum) > 1 && Battle.type == TYPE_LOCAL)
         {
            maxHit = 99;
            if(battleAction.action == BattleData.ACTION_SKILL)
            {
               skillData = Main.SKILL_DATA[battleAction.skillId];
               if(skillData.skill_hit_num > 0)
               {
                  maxHit = skillData.skill_hit_num;
               }
            }
            Out.debug("Battle","battleAction.hitNum >> " + battleAction.hitNum + " :: maxHit >> " + maxHit);
            if(int(battleAction.hitNum) <= maxHit)
            {
               target.updateHP(dmg);
            }
         }
         if(Battle.type == TYPE_LOCAL)
         {
            if(battleAction.rebound == true)
            {
               attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(751));
               attacker.updateBattleFrame();
            }
         }
         else if(Battle.type == TYPE_NETWORK)
         {
            if(battleAction.rebound)
            {
               if(battleAction.rebound.length > 0)
               {
                  for(i = 0; i < battleAction.rebound.length; i++)
                  {
                     reboundDamage = battleAction.rebound[i].damage;
                     if(target.getData(DBCharacterData.ID) == battleAction.rebound[i].charId)
                     {
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(751));
                        attacker.updateHP(reboundDamage);
                        attacker.updateBattleFrame();
                     }
                  }
               }
            }
         }
         if(!Central.main.isNewChar)
         {
            if(target.hp <= 0 && attacker.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.ENEMY_KILLED,1);
            }
         }
         var reactiveEffect:Object = battleAction.reactiveEffect;
         if(reactiveEffect != null)
         {
            if(checkResisted(reactiveEffect.resisted,attacker) == false)
            {
               switch(reactiveEffect.type)
               {
                  case BattleData.EFFECT_STUN:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(331));
                     break;
                  case BattleData.EFFECT_SLEEP:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(280));
                     break;
                  case BattleData.EFFECT_BUNDLE:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
                     break;
                  case BattleData.EFFECT_MERIDIANS_SEAL:
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(527));
               }
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.setBattleDebuff(reactiveEffect);
               }
            }
            else
            {
               attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
            }
            if(Battle.type == TYPE_NETWORK)
            {
               target.removeBuff(BattleData.EFFECT_REACTIVE_DEBUFF);
            }
         }
         if(battleAction.titan == true)
         {
            attackPoint = null;
            if(attacker.charMc.x < target.charMc.x)
            {
               attackPoint = new Point(target.charMc.x - PositionType.RANGE_2_OFFSET * Data.BATTLE_CHAR_SCALE,target.charMc.y);
            }
            else
            {
               attackPoint = new Point(target.charMc.x + target.getHitArea().width * Data.BATTLE_CHAR_SCALE * 3,target.charMc.y);
            }
            battleAction.TitanattackPoint = attackPoint;
            attacker.setBattleAction(battleAction);
         }
         target.updateBattleFrame();
      }
      
      private static function damageTarget() : void
      {
         var i:int = 0;
         var feedBackType:String = null;
         var feedBackDamage:int = 0;
         var battleAction:Object = attacker.getBattleAction();
         var dmgArr:Array = battleAction.dmgArr;
         for(var k:uint = 0; k < dmgArr.length; k++)
         {
            processDamage(dmgArr[k]);
         }
         if(battleAction.feedback)
         {
            if(battleAction.feedback.length > 0)
            {
               for(i = 0; i < battleAction.feedback.length; i++)
               {
                  feedBackType = battleAction.feedback[i].type;
                  feedBackDamage = battleAction.feedback[i].damage;
                  if(battleAction.feedback[i].resisted)
                  {
                     attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(484));
                  }
                  switch(feedBackType)
                  {
                     case BattleData.EFFECT_REACTIVE_FORCE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(533));
                        attacker.showOverheadNumber(Timeline.WORD,"-" + feedBackDamage + Central.main.langLib.titleTxt(TitleData.HP));
                        break;
                     case BattleData.EFFECT_BERSERKER_MODE:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(599));
                        attacker.showOverheadNumber(Timeline.WORD,"-" + feedBackDamage + Central.main.langLib.titleTxt(TitleData.HP));
                        break;
                     case BloodlineData.EFFECT_PASSIVE_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1870));
                        break;
                     case BloodlineData.EFFECT_CPDMG:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1869) + " -" + feedBackDamage + "HP");
                        break;
                     case BloodlineData.EFFECT_CPDMG_STUN:
                        attacker.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(1870));
                  }
               }
            }
         }
         if(battleAction.effect)
         {
            switch(battleAction.effect.type)
            {
               case BattleData.EFFECT_MODIFY_COOLDOWN:
               case BattleData.EFFECT_MDF_CD_N_ADD_ATTENTION:
                  if(Battle.type == TYPE_NETWORK)
                  {
                     addSkillCoolDown(battleAction.effect,battleAction);
                     if(battleAction.effect.skillCooldown)
                     {
                        attacker.battleSkillCooldown[battleAction.skillId] = battleAction.effect.skillCooldown;
                     }
                  }
            }
         }
         if(battleAction.attackerRestoreHp != null)
         {
            if(battleAction.attackerRestoreHp > 0)
            {
               attacker.showOverheadNumber(Timeline.HEAL,"+" + battleAction.attackerRestoreHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.attackerRestoreHp);
               }
            }
         }
         if(battleAction.attackerRestoreCp != null)
         {
            if(battleAction.attackerRestoreCp > 0)
            {
               trace("11111111111111111111111111111111111111111111111111111119999");
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.attackerRestoreCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.attackerRestoreCp);
               }
            }
         }
         if(battleAction.attackerRestoreSp != null)
         {
            if(battleAction.attackerRestoreSp > 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,"+" + battleAction.attackerRestoreSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(battleAction.attackerRestoreSp);
               }
            }
         }
         if(battleAction.attackerDamageHp != null)
         {
            if(battleAction.attackerDamageHp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.attackerDamageHp + Central.main.langLib.titleTxt(TitleData.HP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateHP(battleAction.attackerDamageHp);
               }
            }
         }
         if(battleAction.attackerDamageCp != null)
         {
            if(battleAction.attackerDamageCp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.attackerDamageCp + Central.main.langLib.titleTxt(TitleData.CP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateCP(battleAction.attackerDamageCp);
               }
            }
         }
         if(battleAction.attackerDamageSp != null)
         {
            if(battleAction.attackerDamageSp < 0)
            {
               attacker.showOverheadNumber(Timeline.WORD,battleAction.attackerDamageSp + Central.main.langLib.titleTxt(TitleData.SP));
               if(Battle.type == TYPE_NETWORK)
               {
                  attacker.updateSP(0 - battleAction.attackerDamageSp);
               }
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            battleAction.effect = null;
            battleAction.feedback = null;
         }
         attacker.updateBattleFrame();
      }
      
      public static function healTarget() : void
      {
         var i:int = 0;
         var healObj:Object = null;
         var _target:* = undefined;
         var battleAction:Object = attacker.getBattleAction();
         if(battleAction.healTarget)
         {
            for(i = 0; i < battleAction.healTarget.length; i++)
            {
               healObj = battleAction.healTarget[i];
               if(Battle.type == TYPE_NETWORK)
               {
                  _target = getCharacterById(healObj.target);
                  _target.updateHP(healObj.heal);
                  _target.updateBattleFrame();
                  _target.showOverheadNumber(Timeline.HEAL,healObj.heal);
               }
               else
               {
                  healObj.target.updateBattleFrame();
                  healObj.target.showOverheadNumber(Timeline.HEAL,healObj.heal);
               }
            }
            return;
         }
         if(battleAction.heal == null)
         {
            return;
         }
         var heal:int = battleAction.heal;
         if(battleAction.target)
         {
            switch(battleAction.target)
            {
               case "self":
                  defender = attacker;
            }
         }
         if(Battle.type == TYPE_NETWORK)
         {
            defender.updateHP(heal);
         }
         defender.updateBattleFrame();
         sethealThreat(heal);
         if(battleAction.critical)
         {
            defender.showOverheadNumber(Timeline.HEAL,heal);
         }
         else
         {
            defender.showOverheadNumber(Timeline.HEAL,heal);
         }
      }
      
      public static function setdamageThreat(_dmg:int, _effect:Object) : void
      {
         defender.setThreat(attacker,_dmg,0,_effect);
      }
      
      public static function sethealThreat(_heal:int) : void
      {
         var i:int = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].setThreat(attacker,0,_heal);
         }
      }
      
      public static function setchargeThreat() : void
      {
         var i:int = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].setThreat(attacker,0,0,null,"CHARGE");
         }
      }
      
      public static function setbuffThreat(_effect:Object = null) : void
      {
         var i:int = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].setThreat(attacker,0,0,null,"BUFF");
         }
      }
      
      public static function setDebuffThreat(_effect:Object = null) : void
      {
         defender.setThreat(attacker,0,0,null,"DEBUFF");
      }
      
      private static function playExtraAttack() : Boolean
      {
         var battleAction:Object = null;
         var TitanBattleaction:Object = null;
         var BloodlineskillData_TITAN:Object = null;
         var BloodlineskillData_effect_TITAN:Object = null;
         var BloodlineList_TITAN:Array = null;
         var Skill1021_Lv:int = 0;
         var Skill1021_skilllocation:int = 0;
         var b:int = 0;
         var i:int = 0;
         var Button_Data_Obj_titan:Object = null;
         var titaneffect:Object = null;
         var dmgObj:Object = null;
         battleAction = attacker.getBattleAction();
         if(battleAction == null)
         {
            return false;
         }
         Out.debug("Battle",attacker.getCharacterName() + " :: defender.hp >> " + defender.hp + " :: playExtraAttack :: .titan >> " + battleAction.titan);
         if(battleAction.titan == true)
         {
            attacker.isPlayingAnimation = true;
            TitanBattleaction = {};
            BloodlineskillData_TITAN = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1021"];
            BloodlineskillData_effect_TITAN = {};
            BloodlineList_TITAN = attacker.getBloodlineListArr();
            Skill1021_Lv = 0;
            Skill1021_skilllocation = 0;
            for(b = 0; b < BloodlineList_TITAN.length; b++)
            {
               if(BloodlineList_TITAN[b].skill_id == "1021")
               {
                  Skill1021_Lv = BloodlineList_TITAN[b].level;
                  Skill1021_skilllocation = b;
               }
            }
            for(i = 0; i < 10; i++)
            {
               if(BloodlineskillData_TITAN.effect[i].skill_level == Skill1021_Lv)
               {
                  BloodlineskillData_effect_TITAN = BloodlineskillData_TITAN.effect[i];
               }
            }
            Button_Data_Obj_titan = {};
            Button_Data_Obj_titan.id = BloodlineskillData_TITAN.skill_id;
            Button_Data_Obj_titan.dbid = String(BloodlineskillData_TITAN.skill_id).replace("skill","");
            Button_Data_Obj_titan.name = BloodlineskillData_TITAN.name;
            Button_Data_Obj_titan.gold = 0;
            Button_Data_Obj_titan.crystal = 0;
            Button_Data_Obj_titan.damage = 0 - int(battleAction.titanDamage);
            Button_Data_Obj_titan.rarity = BloodlineskillData_TITAN.rarity;
            Button_Data_Obj_titan.swfName = BloodlineskillData_TITAN.swf_name;
            Button_Data_Obj_titan.description = BloodlineskillData_TITAN.description;
            Button_Data_Obj_titan.cp = 0;
            Button_Data_Obj_titan.cooldown = BloodlineskillData_TITAN.cooldown;
            Button_Data_Obj_titan.posType = BloodlineskillData_TITAN.postype;
            Button_Data_Obj_titan.tooltip = BloodlineskillData_TITAN.tooltip;
            Button_Data_Obj_titan.type = BloodlineskillData_TITAN.type;
            Button_Data_Obj_titan.effect = BloodlineskillData_effect_TITAN;
            Button_Data_Obj_titan.level = BloodlineskillData_effect_TITAN.skill_level;
            Button_Data_Obj_titan.premium = BloodlineskillData_TITAN.premium;
            Button_Data_Obj_titan.vendor = BloodlineskillData_TITAN.vendor;
            Button_Data_Obj_titan.train_time = 0;
            Button_Data_Obj_titan.bloodline_id = BloodlineskillData_TITAN.bloodline_id;
            Button_Data_Obj_titan.bloodline_type = Central.main.BLOODLINE_DATA["bloodline1"].type;
            titaneffect = {};
            if(battleAction.titanstun == true)
            {
               titaneffect = battleAction.titanEffect;
            }
            else
            {
               titaneffect = {};
            }
            TitanBattleaction = {
               "action":"bloodline",
               "skillId":Skill1021_skilllocation,
               "posType":Button_Data_Obj_titan.posType,
               "cp":0,
               "dmg":Button_Data_Obj_titan.damage,
               "effect":titaneffect,
               "BLSKILLID":Button_Data_Obj_titan.id,
               "BLTYPE":Button_Data_Obj_titan.bloodline_type
            };
            if(battleAction.BLSKILLID)
            {
               battleAction.BLSKILLID = null;
            }
            dmgObj = {};
            dmgObj.characterType = defender.type;
            dmgObj.characterId = defender.getCharacterId();
            dmgObj.dmg = TitanBattleaction.dmg;
            battleAction.dmgArr = [dmgObj];
            Out.debug("Battle","playExtraAttack :: .dmgObj.dmg >> " + dmgObj.dmg);
            battleAction.titan = false;
            battleAction.effect = TitanBattleaction.effect;
            attacker.setBattleAction(battleAction);
            playBloodline(attacker,TitanBattleaction,battleAction.TitanattackPoint);
            return true;
         }
         return false;
      }
      
      public static function playerDisconnect(charId:String) : void
      {
         var char:* = undefined;
         if(Battle.pvpCurrencyGainDisplay)
         {
            if(Battle.myCurrencyGain == 0)
            {
               charId = Central.main.getMainChar().getCharacterId();
            }
         }
         char = getCharacterById(int(charId));
         char.pvpPlayerDisconnect();
      }
      
      public static function checkLoadingQuit() : void
      {
         var i:int = 0;
         var char:* = undefined;
         for(i = 0; i < loadingQuitArr.length; i++)
         {
            char = getCharacterById(int(loadingQuitArr[i]));
            char.pvpPlayerDisconnect();
         }
         loadingQuitArr = [];
      }
      
      private static function actionFinish_CB() : void
      {
         var checkActionFinish:Boolean = false;
         var i:* = undefined;
         var j:uint = 0;
         var EventArray:Array = null;
         var signature:String = null;
         var signatureData:String = null;
         var battleAction:Object = null;
         var dataObj:Object = null;
         var skillData:Object = null;
         var itemData:Object = null;
         var decreaseItem:Boolean = false;
         var isEventBoss:Boolean = false;
         var tmpAttacker:* = undefined;
         var tmpDefender:* = undefined;
         var confirmBattleLose:Function = null;
         var revival:Function = null;
         var reviveBattleCharacter:Function = null;
         var revivalPrice:int = 0;
         var serverAttackerHP:int = 0;
         var serverAttackerCP:int = 0;
         var serverAttackerSP:int = 0;
         var serverDefenderHP:int = 0;
         var serverDefenderCP:int = 0;
         var serverDefenderSP:int = 0;
         var logToServer:Boolean = false;
         var syncData:Array = null;
         var syncObj:Object = null;
         var k:int = 0;
         var target:* = undefined;
         var action:String = null;
         var actionItem:String = null;
         var attackerWeapon:String = null;
         var attackerBackitem:String = null;
         var attackerPetId:int = 0;
         var attackerAPStr:String = null;
         var attackerSkillList:Array = null;
         var attackerClassSkillList:Array = null;
         var attackerSkill:String = null;
         var attackerBLObj:Object = null;
         var attackerBloodline:String = null;
         var attackerSENObj:Object = null;
         var attackerSenjutsu:String = null;
         var defenderWeapon:String = null;
         var defenderBackitem:String = null;
         var defenderPetId:int = 0;
         var defenderAPStr:String = null;
         var defenderSkillList:Array = null;
         var defenderClassSkillList:Array = null;
         var defenderSkill:String = null;
         var defenderBLObj:Object = null;
         var defenderBloodline:String = null;
         var defenderSENObj:Object = null;
         var defenderSenjutsu:String = null;
         Out.debug("battle","actionFinish_CB");
         checkActionFinish = isAllActionFinish();
         holdTargetIsMember = null;
         EventArray = [];
         EventArray[0] = Central.main.eventBattleMethod;
         EventArray[1] = int(seal_enemy);
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            EventArray[1] = battleRoundCounter;
            if(specialHpData.finalHP)
            {
               EventArray[2] = specialHpData.finalHP;
            }
            else
            {
               EventArray[2] = 0;
            }
            EventArray[3] = specialHpData.lv;
            EventArray[4] = Central.main.battleId;
            EventArray[5] = int(seal_enemy);
         }
         signatureData = "";
         for(j = 0; j < EventArray.length; j++)
         {
            signatureData = signatureData + EventArray[j];
            if(j < EventArray.length - 1)
            {
               signatureData = signatureData + ",";
            }
         }
         if(!checkActionFinish)
         {
            Out.debug("battle","checkActionFinish");
            return;
         }
         battleAction = attacker.getBattleAction();
         try
         {
            if(int(battleAction.hitNum) > 1 && battleAction.action == "skill")
            {
               skillData = Main.SKILL_DATA[battleAction.skillId];
               if(int(skillData.skill_hit_num) != int(battleAction.hitNum))
               {
                  Main.amfClient.service("ReportService.pvpActionHitLog",[battleAction.action,battleAction.skillId,int(battleAction.hitNum),int(skillData.skill_hit_num)],Main.saveLogResult);
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","pvpActionHitLog error");
         }
         if(playExtraAttack() == true)
         {
            Out.debug("battle","playExtraAttack");
            return;
         }
         if(Battle.type == TYPE_LOCAL && !attacker.isDead)
         {
            if(attacker.getBattleAction().action == "item")
            {
               itemData = Main.ITEM_DATA.find(attacker.getBattleAction().item);
               if(itemData.effect == BattleData.ITEM_SMOKE)
               {
                  decreaseItem = false;
                  if(Mission.curMissionID == "msn0")
                  {
                     Main.dispatchGameEvent(GameEvents.BATTLE_RUN);
                     return;
                  }
                  if(Main.challengeFriendUID != null)
                  {
                     if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
                     {
                        switch(AppData.type)
                        {
                           case AppData.FB:
                              break;
                           case AppData.OK:
                              SNS.sendNotification(String(String(Central.main.langLib.get(301)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                              break;
                           case AppData.MP:
                              SNS.sendNotification(String(String(Central.main.langLib.get(300)).replace("[valfbuserusername]",FBUser.username)).replace("[valapplicationurl]",Data.APPLICATION_URL),[Main.challengeFriendUID]);
                        }
                        Main.challengedFriends.push(Main.challengeFriendUID);
                     }
                     for(i = 0; i < enemyArr.length; i++)
                     {
                        Main.saveChallengeRecord(enemyArr[i].getData(DBCharacterData.ID),2);
                        Panel.getInstance().setChallenged(int(enemyArr[i].getData(DBCharacterData.ID)));
                     }
                     Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
                     Main.challengeFriendUID = null;
                     decreaseItem = true;
                  }
                  if(subType == BattleData.SUBTYPE_BOSS)
                  {
                     decreaseItem = true;
                     isEventBoss = false;
                     for(i = 0; i < eventBossArr.length; i++)
                     {
                        if(bossId.indexOf(eventBossArr[i]) >= 0)
                        {
                           isEventBoss = true;
                           break;
                        }
                     }
                     if(Central.main.isOldHunting)
                     {
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isOldHunting = false;
                        Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash],getBossRewardResponse04);
                     }
                     if(Central.main.isNewClanWar)
                     {
                        Central.main.extraData.crew_merit = Central.main.extraData.crew_merit + 2;
                        Central.main.getMainChar().itemUsedInBattle = !!Central.main.getMainChar().itemUsedInBattle?Central.main.getMainChar().itemUsedInBattle:[];
                        ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 1));
                        Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,1,Central.main.updateSequence(),ClanWarHash],getBossRewardResponse04);
                     }
                     if(isEventBoss)
                     {
                        Main.showAmfLoading();
                        signature = Main.getHash(String(bossId) + "|1|" + signatureData);
                        Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,1,EventArray],getBossRewardResponse04);
                     }
                  }
                  if(decreaseItem)
                  {
                     decreaseItem = false;
                     Main.getMainChar().updateDB(0,0,[],"",1,Battle);
                  }
                  try
                  {
                     Central.main.tracking.trackHuntBoss(Central.main.bossId,Central.main.tracking.TRACK_HUNT_BOSS + Central.main.tracking.TRACK_FAIL);
                  }
                  catch(err:Error)
                  {
                     Out.error("Battle","actionFinish_CB :: TRACKING - trackHuntBoss(TRACK_FAIL)");
                  }
                  battleFinish();
                  if(Central.main.eventName == "Vday2015")
                  {
                     Central.main.partyNpc = Central.main.prevNpcArr;
                     Central.main.partyMembers = Central.main.prevPartyMemberArr;
                     Central.main.eventName = "";
                  }
                  Main.battleRun();
                  return;
               }
            }
         }
         dataObj = {};
         resetATBPosition();
         if(battleAction != null)
         {
            if(battleAction.copyJutsu == true)
            {
               tmpAttacker = attacker;
               tmpDefender = defender;
               attacker = null;
               defender = null;
               attacker = tmpDefender;
               defender = tmpAttacker;
               attacker.moveToFront();
               attacker.showOverheadNumber(Timeline.WORD,Central.main.BLOODLINE_SKILL_DATA["bloodline_skill1023"].name);
               noCoolDown = true;
            }
         }
         dataObj.event = "info";
         dataObj.charId = String(Main.getMainChar().getData("character_id"));
         if(Battle.type == TYPE_LOCAL)
         {
            if(isBattleWin())
            {
               dataObj.state = "battle_win";
               Central.client.getInstance().sendData(dataObj,"BATTLE_HAV_WIN");
               return;
            }
            if(isBattleLose())
            {
               confirmBattleLose = function():*
               {
                  if(subType == BattleData.SUBTYPE_BOSS)
                  {
                     if(Central.main.isOldHunting)
                     {
                        Main.showAmfLoading();
                        huntingHash = Main.getHash(String(roomId) + 1);
                        Central.main.isOldHunting = false;
                        Main.amfClient.service("EudemonGarden.finishHunting",[Account.getAccountSessionKey(),roomId,Central.main.getMainChar().itemUsedInBattle,1,huntingHash],getBossRewardResponse03);
                     }
                     else if(Central.main.isNewClanWar)
                     {
                        Main.showAmfLoading();
                        Central.main.extraData.crew_merit = Central.main.extraData.crew_merit + 2;
                        Central.main.getMainChar().itemUsedInBattle = !!Central.main.getMainChar().itemUsedInBattle?Central.main.getMainChar().itemUsedInBattle:[];
                        ClanWarHash = Main.getHash(String(Central.main.getMainChar().itemUsedInBattle + Central.main.recruitedMembers.toString() + Central.main.selectedNewClanWar + 1));
                        Main.amfClient.service("CrewWar.finishLandHunt",[Account.getAccountSessionKey(),Central.main.getMainChar().itemUsedInBattle,Central.main.recruitedMembers.toString(),Central.main.selectedNewClanWar,1,Central.main.updateSequence(),ClanWarHash],getBossRewardResponse03);
                     }
                     else
                     {
                        Central.main.logHuntingMission(false,false);
                        Main.showAmfLoading();
                        signature = Main.getHash(String(bossId) + "|1|" + signatureData);
                        Main.amfClient.service("ItemDAO.getBossReward",[Account.getAccountSessionKey(),signature,bossId,1,EventArray],getBossRewardResponse03);
                     }
                  }
                  if(Main.challengeFriendUID != null)
                  {
                     Main.getMainChar().updateDB(0,0,[],"",1,Battle);
                  }
                  dataObj.state = "battle_lose";
                  Central.client.getInstance().sendData(dataObj);
               };
               revival = function(response:Object):*
               {
                  if(Central.main.validateAmfResponse(response))
                  {
                     Central.main.hideAmfLoading();
                     Central.main.getMainChar().updateHP(Math.round(Main.getMainChar().maxHP * 0.3));
                     Central.main.getMainChar().updateBattleFrame();
                     Central.main.getMainChar().isDead = false;
                     Central.main.getMainChar().playStandby();
                     Central.main.getMainChar().playRevival();
                     Central.main.getMainChar().isPlayingAnimation = false;
                     Central.main.getMainChar().resetBattleData();
                     Central.main.updateMenu();
                     Central.battle.actionFinish_CB();
                     Central.main.getMainChar().updateBattleFrame();
                     Central.main.getMainChar().resetBattleData();
                  }
               };
               reviveBattleCharacter = function():*
               {
                  Central.main.showAmfLoading();
                  Central.main.amfClient.service("CharacterService.reviveBattleCharacter",[Account.getAccountSessionKey()],revival);
               };
               revivalPrice = 50;
               if(Central.main.getMainChar().isDead)
               {
                  if(Central.main.account.getAccountBalance() >= revivalPrice)
                  {
                     Central.main.showConfirmation(AppData.lang == AppData.ZH?"是否使用" + revivalPrice + "藍幣復活？（回復30%生命值）":"Do you want to revive by using " + revivalPrice + " token? (Revert 30% HP)",reviveBattleCharacter,confirmBattleLose);
                  }
                  else
                  {
                     confirmBattleLose();
                  }
               }
               return;
            }
            dataObj.state = "action_finish";
            Central.client.getInstance().sendData(dataObj);
         }
         else
         {
            try
            {
               logToServer = false;
               syncData = lastBattleAction.syncData;
               for(j = 0; j < syncData.length; j++)
               {
                  syncObj = syncData[j];
                  if(syncObj.type == 1)
                  {
                     if(attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerHP = syncObj.HP;
                     }
                     if(defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderHP = syncObj.HP;
                     }
                     if(attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerCP = syncObj.CP;
                     }
                     if(defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderCP = syncObj.CP;
                     }
                     if(attacker.getData(DBCharacterData.RANK) >= 8 && attacker.getCharacterId() == int(syncObj.ID))
                     {
                        serverAttackerSP = syncObj.SP;
                     }
                     if(defender.getData(DBCharacterData.RANK) >= 8 && defender.getCharacterId() == int(syncObj.ID))
                     {
                        serverDefenderSP = syncObj.SP;
                     }
                  }
               }
               try
               {
                  for(i = 0; i < syncData.length; i++)
                  {
                     syncObj = syncData[i];
                     if(syncObj.type == 1)
                     {
                        for(k = 0; k < Central.main.PvpAllPlayer.length; k++)
                        {
                           if(syncObj.ID == Central.main.PvpAllPlayer[k])
                           {
                              target = getCharacterById(int(syncObj.ID));
                              Out.debug("syncHpCpCommandAction","SyncHp B4 >> " + target.hp);
                              Out.debug("syncHpCpCommandAction","SyncCp B4 >> " + target.cp);
                              Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + target.sp);
                              target.syncHp(syncObj.HP);
                              target.syncCp(syncObj.CP);
                              target.syncSp(syncObj.SP);
                              Out.debug("syncHpCpCommandAction","SyncHp After >> " + target.hp);
                              Out.debug("syncHpCpCommandAction","SyncCp After >> " + target.cp);
                              Out.debug("syncHpCpCommandAction","SyncSp After >> " + target.sp);
                              target.updateBattleFrame();
                              if(Math.abs(target.hp - syncObj.HP) > 300)
                              {
                                 logToServer = true;
                              }
                              if(Math.abs(target.cp - syncObj.CP) > 300)
                              {
                                 logToServer = true;
                              }
                              if(Central.main.senjutsuFeature)
                              {
                                 target.syncSp(syncObj.SP);
                                 Out.debug("syncHpCpCommandAction","SyncSp B4 >> " + target.sp);
                                 Out.debug("syncHpCpCommandAction","SyncSp After >> " + target.sp);
                                 if(Math.abs(target.sp - syncObj.SP) > 300)
                                 {
                                    logToServer = true;
                                 }
                              }
                           }
                        }
                     }
                  }
                  attacker.updateBattleFrame();
                  defender.updateBattleFrame();
                  Central.main.updateMenu();
               }
               catch(e:Error)
               {
                  Out.error("Battle","syncHpCp error");
               }
               if(serverAttackerHP != attacker.hp)
               {
                  logToServer = true;
               }
               if(serverAttackerCP != attacker.cp)
               {
                  logToServer = true;
               }
               if(serverDefenderHP != defender.hp)
               {
               }
               if(serverDefenderCP != defender.cp)
               {
                  logToServer = true;
               }
               if(Central.main.senjutsuFeature)
               {
                  if(serverAttackerSP != attacker.sp)
                  {
                     logToServer = true;
                  }
                  logToServer = true;
                  if(serverDefenderSP != defender.sp)
                  {
                     logToServer = true;
                  }
               }
               if(logToServer == true && Battle.type == TYPE_NETWORK)
               {
                  action = lastBattleAction.action;
                  actionItem = "";
                  switch(action)
                  {
                     case "weapon_attack":
                        actionItem = attacker.getWeapon();
                        break;
                     case "skill":
                     case "class_skill":
                        actionItem = lastBattleAction.skillId;
                        break;
                     case "bloodline":
                        actionItem = lastBattleAction.BLSKILLID;
                        break;
                     case "senjutsu":
                        actionItem = lastBattleAction.SENSKILLID;
                  }
                  attackerWeapon = "";
                  attackerBackitem = "";
                  attackerPetId = 0;
                  attackerAPStr = "";
                  attackerSkillList = [];
                  attackerClassSkillList = [];
                  attackerSkill = "";
                  attackerBLObj = {};
                  attackerBloodline = "";
                  attackerSENObj = {};
                  attackerSenjutsu = "";
                  attackerWeapon = attacker.getWeapon();
                  attackerBackitem = attacker.getBackItem();
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        if(attacker.pet != null)
                        {
                           attackerPetId = attacker.pet.id;
                        }
                  }
                  attackerSkillList = attacker.getSkillListArr();
                  for(j = 0; j < attackerSkillList.length; j++)
                  {
                     if(attackerSkill == "")
                     {
                        attackerSkill = attackerSkillList[j];
                     }
                     else
                     {
                        attackerSkill = attackerSkill + "," + attackerSkillList[j];
                     }
                  }
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        attackerClassSkillList = attacker.getClassSkillListArr();
                        for(j = 0; j < attackerClassSkillList.length; j++)
                        {
                           if(attackerSkill == "")
                           {
                              attackerSkill = attackerClassSkillList[j];
                           }
                           else
                           {
                              attackerSkill = attackerSkill + "," + attackerClassSkillList[j];
                           }
                        }
                        for each(attackerBLObj in attacker.bloodline)
                        {
                           if(attackerBloodline == "")
                           {
                              attackerBloodline = attackerBLObj.bloodline_id + "|" + attackerBLObj.skill_id + "|" + attackerBLObj.level;
                           }
                           else
                           {
                              attackerBloodline = attackerBloodline + "," + attackerBLObj.bloodline_id + "|" + attackerBLObj.skill_id + "|" + attackerBLObj.level;
                           }
                        }
                        if(Central.main.senjutsuFeature)
                        {
                           for each(attackerSENObj in attacker.senjutsu)
                           {
                              if(attackerSenjutsu == "")
                              {
                                 attackerSenjutsu = attackerSENObj.senjutsu_id + "|" + attackerSENObj.skill_id + "|" + attackerSENObj.level;
                              }
                              else
                              {
                                 attackerBloodline = attackerSenjutsu + "," + attackerSENObj.senjutsu_id + "|" + attackerSENObj.skill_id + "|" + attackerSENObj.level;
                              }
                           }
                        }
                  }
                  defenderWeapon = "";
                  defenderBackitem = "";
                  defenderPetId = 0;
                  defenderAPStr = "";
                  defenderSkillList = [];
                  defenderClassSkillList = [];
                  defenderSkill = "";
                  defenderBLObj = {};
                  defenderBloodline = "";
                  defenderSENObj = {};
                  defenderSenjutsu = "";
                  defenderWeapon = defender.getWeapon();
                  defenderBackitem = defender.getBackItem();
                  switch(defender.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        if(defender.pet != null)
                        {
                           defenderPetId = defender.pet.id;
                        }
                  }
                  defenderSkillList = defender.getSkillListArr();
                  for(j = 0; j < defenderSkillList.length; j++)
                  {
                     if(defenderSkill == "")
                     {
                        defenderSkill = defenderSkillList[j];
                     }
                     else
                     {
                        defenderSkill = defenderSkill + "," + defenderSkillList[j];
                     }
                  }
                  switch(attacker.type)
                  {
                     case 1:
                     case 2:
                     case 3:
                     case 6:
                        defenderClassSkillList = attacker.getClassSkillListArr();
                        for(j = 0; j < defenderClassSkillList.length; j++)
                        {
                           if(defenderSkill == "")
                           {
                              defenderSkill = defenderClassSkillList[j];
                           }
                           else
                           {
                              defenderSkill = defenderSkill + "," + defenderClassSkillList[j];
                           }
                        }
                        if(defender.type != 4)
                        {
                           for each(defenderBLObj in defender.bloodline)
                           {
                              if(defenderBloodline == "")
                              {
                                 defenderBloodline = defenderBLObj.bloodline_id + "|" + defenderBLObj.skill_id + "|" + defenderBLObj.level;
                              }
                              else
                              {
                                 defenderBloodline = defenderBloodline + "," + defenderBLObj.bloodline_id + "|" + defenderBLObj.skill_id + "|" + defenderBLObj.level;
                              }
                           }
                           for each(defenderSENObj in defender.senjutsu)
                           {
                              if(defenderSenjutsu == "")
                              {
                                 defenderSenjutsu = defenderSENObj.senjutsu_id + "|" + defenderSENObj.skill_id + "|" + defenderSENObj.level;
                              }
                              else
                              {
                                 defenderSenjutsu = defenderSenjutsu + "," + defenderSENObj.senjutsu_id + "|" + defenderSENObj.skill_id + "|" + defenderSENObj.level;
                              }
                           }
                        }
                  }
                  if(pvpSyncLogSaved == false)
                  {
                  }
               }
            }
            catch(e:Error)
            {
               Out.error("Battle","pvp sync report error, Stack:" + e.getStackTrace());
            }
            if(String(log_time_user) == String(Main.getMainChar().getData("character_id")))
            {
               if(pvpLogTimeSaved == false)
               {
                  pvpLogTimeSaved = true;
               }
            }
            if(Main.getMainChar().isDead)
            {
               dataObj.char_dead = true;
            }
            else
            {
               dataObj.char_dead = false;
            }
            dataObj.state = "action_finish";
            Central.client.getInstance().sendData(dataObj);
            if(Battle.type == TYPE_NETWORK)
            {
               Out.debug("7940 - Battle.as actionFinish_CB","attacker.getDebuff" + GF.printObject(attacker.getBattleDebuff()));
               Out.debug("7941 - Battle.as actionFinish_CB","defender.getDebuff" + GF.printObject(defender.getBattleDebuff()));
               if((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
               {
                  bGearBtnEnabled = false;
                  Out.debug("","Rex debug: try to fix can use item when stun");
               }
               else
               {
                  bGearBtnEnabled = true;
               }
               attacker.resetBuff();
               defender.resetBuff();
            }
         }
         Main.updateMenu();
      }
      
      private static function getBossRewardResponse03(response:Object) : void
      {
         var i:uint = 0;
         var tempArr:Array = null;
         var addItem:Boolean = false;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            connectingAmf = false;
            tempArr = String(bossId).split(",");
            addItem = true;
            for(i = 0; i < eventBossArr.length; i++)
            {
               if(tempArr.indexOf(eventBossArr[i]) >= 0)
               {
                  addItem = false;
                  break;
               }
            }
            if(addItem)
            {
               try
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_loss");
               }
               catch(err:Error)
               {
                  Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
               }
            }
            Central.main.Sakura2013BattleMethod == "";
            Main.getMainChar().updateDB(0,0,[],"",1,Battle);
            if(Central.main.isNewClanWar)
            {
               Central.main.isNewClanWar = false;
               Central.main._partyMembers = Central.main.tmpPartyMembers;
               Central.main._partyMembers = Central.main.recruitFriendTmpData;
               Central.panel.getInstance().show("newclan_village");
            }
         }
      }
      
      private static function getBossRewardResponse04(response:Object) : void
      {
         var i:uint = 0;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_loss");
            }
            catch(err:Error)
            {
               Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
            }
            Central.main.Sakura2013BattleMethod == "";
         }
         if(Central.main.isNewClanWar)
         {
            Central.main.partyNpc = Central.main.tmpParty;
            Central.main._partyMembers = Central.main.recruitFriendTmpData;
            trace("fdsafsafsafsadfsa" + Central.main.isNewClanWar);
            trace("fdsafsafsafsafdasfsafsadfsa" + Central.main.partyNpc);
            Central.panel.getInstance().show("newclan_village");
         }
         Central.main.isNewClanWar = false;
      }
      
      public static function isAllActionFinish() : Boolean
      {
         var i:uint = 0;
         if(Main.getMainChar().isPlayingAnimation)
         {
            Out.debug("battle","isAllActionFinish ：：  getMainChar");
            return false;
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i].isPlayingAnimation)
            {
               Out.debug("battle","isAllActionFinish ：：  enemyArr");
               return false;
            }
         }
         if(partyArr)
         {
            for(i = 0; i < partyArr.length; i++)
            {
               if(partyArr[i].isPlayingAnimation)
               {
                  Out.debug("battle","isAllActionFinish ：：  partyArr");
                  return false;
               }
            }
         }
         if(petArr)
         {
            for(i = 0; i < petArr.length; i++)
            {
               if(petArr[i].isPlayingAnimation)
               {
                  Out.debug("battle","isAllActionFinish ：：  petArr");
                  return false;
               }
            }
         }
         return true;
      }
      
      private static function isBattleWin() : Boolean
      {
         var i:uint = 0;
         var x:uint = 0;
         Out.debug("battle","isBattleWin :: hhhhhhhhhhhhhhhhhhhank");
         if(Mission.curMissionID == "msn136")
         {
            if(enemyArr)
            {
               for(x = 0; x < enemyArr.length; x++)
               {
                  if(enemyArr[x].getData(DBCharacterData.SESSION_PLAYTIME) == -1 && enemyArr[x].hp <= 0)
                  {
                     return true;
                  }
                  if(enemyArr[x].getData(DBCharacterData.SESSION_PLAYTIME) == -2 && enemyArr[x].hp / enemyArr[x].maxHP <= 0.5)
                  {
                     return true;
                  }
               }
            }
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            if(enemyArr[i].hp > 0)
            {
               return false;
            }
            enemyArr[i].updateHP(0);
         }
         return true;
      }
      
      private static function isBattleLose() : Boolean
      {
         var i:uint = 0;
         var j:int = 0;
         if(Mission.curMissionID == "msn135" || Central.main.eventName == "Vday2015")
         {
            if(partyArr)
            {
               for(i = 0; i < partyArr.length; i++)
               {
                  if(partyArr[i].hp <= 0)
                  {
                     if(Central.main.eventName == "Vday2015")
                     {
                        Central.main.partyNpc = Central.main.prevNpcArr;
                        Central.main.partyMembers = Central.main.prevPartyMemberArr;
                        Central.main.eventName = "";
                     }
                     return true;
                  }
               }
            }
         }
         Out.debug("battle","isBattleLose :: round >> " + round);
         if(Central.main.battleRuleArr.length > 0)
         {
            for(j = 0; j < Central.main.battleRuleArr.length; j++)
            {
               switch(Central.main.battleRuleArr[j].attribute)
               {
                  case EnemyAttributeData.ROUND:
                     if(Central.main.battleRuleArr[j].type == EnemyAttributeData.OVER)
                     {
                        if(round >= Central.main.battleRuleArr[j].amount)
                        {
                           return true;
                        }
                     }
               }
            }
         }
         if(Main.getMainChar().isDead)
         {
            return true;
         }
         return false;
      }
      
      private static function gotClanBattleResult(response:Object) : void
      {
         if(Main.validateAmfResponse(response))
         {
            Main.hideAmfLoading();
            connectingAmf = false;
            if(response.quit_clan)
            {
               Central.main.showOk(Central.main.langLib.get(1792)[6],membershipRemoved);
               return;
            }
            repGain = response.result;
            prestigeGain = response.prestige_gain;
            Clan.getInstance().clanData.reputation = int(Clan.getInstance().clanData.reputation) + repGain;
            Clan.getInstance().battleClanData.reputation = Clan.getInstance().battleClanData.reputation;
            battleMc.gotoClanResult();
         }
      }
      
      private static function membershipRemoved() : void
      {
         battleFinish();
         Battle.subType = BattleData.SUBTYPE_NORMAL;
         Central.main.gotoMap();
      }
      
      private static function getBossRewardResponse02(response:Object) : void
      {
         var i:uint = 0;
         var bossRewardList:Array = null;
         var bossRewardGetList:Array = null;
         var reward:Array = null;
         var reward_get:Array = null;
         var rewardId:String = null;
         var myEffect:Object = null;
         var mData:Object = null;
         var tempArr:Array = null;
         var addItem:Boolean = false;
         var reward_favor:int = 0;
         var tmp:Array = null;
         var extra_reward_get:Array = null;
         var reward_petData:Array = null;
         var extra_reward:Array = null;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            connectingAmf = false;
            bossRewardList = [];
            bossRewardGetList = [];
            reward = response.reward;
            reward_get = response.reward_get;
            if(response.result != null)
            {
               reward_favor = response.result.add_favorability;
            }
            rewardId = "";
            Central.main.petData = [];
            for(i = 0; i < reward.length; i++)
            {
               rewardId = itemPrototype(reward[i]);
               if(String(reward[i]).indexOf("petxp") >= 0)
               {
                  bossRewardPetXp = int(rewardId);
               }
               else if(String(reward[i]).indexOf("xp") >= 0)
               {
                  bossRewardXp = int(rewardId);
                  Main.getMainChar().showLevelUp(Main.getMainChar().updateXP(bossRewardXp,true,true));
               }
               else if(String(reward[i]).indexOf("gold") >= 0)
               {
                  bossRewardGold = int(rewardId);
                  Central.main.getMainChar().updateGold(bossRewardGold);
               }
               else if(String(reward[i]).indexOf("item_741") >= 0 || String(reward[i]).indexOf("item_742") >= 0)
               {
                  tmp = [];
                  tmp = reward[i].split("_");
                  rewardId = tmp[0] + tmp[1] + "_" + String(parseInt(tmp[2]) + 1);
                  bossRewardList.push(rewardId);
               }
               else if(String(reward[i]).indexOf("pet") >= 0)
               {
                  Central.main.petData.push(response.player_pet);
                  bossRewardList.push(rewardId);
               }
               else
               {
                  bossRewardList.push(rewardId);
               }
            }
            for(i = 0; i < reward_get.length; i++)
            {
               rewardId = itemPrototype(reward_get[i]);
               if(!(String(reward_get[i]).indexOf("petxp") >= 0 || String(reward_get[i]).indexOf("xp") >= 0 || String(reward_get[i]).indexOf("gold") >= 0))
               {
                  bossRewardGetList.push(rewardId);
               }
            }
            if(response.extra_reward && response.extra_reward_get && response.pet)
            {
               extra_reward_get = response.extra_reward_get;
               reward_petData = response.pet;
               extra_reward = response.extra_reward;
               for(i = 0; i < extra_reward.length; i++)
               {
                  tmp = extra_reward[i].split("_");
                  rewardId = tmp[0] + tmp[1];
                  bossRewardList.push(rewardId);
               }
               for(i = 0; i < extra_reward_get.length; i++)
               {
                  tmp = extra_reward_get[i].split("_");
                  rewardId = tmp[0] + tmp[1];
                  bossRewardGetList.push(rewardId);
                  Central.main.petData = reward_petData;
               }
            }
            myEffect = {
               "gold_effect":1,
               "xp_effect":1
            };
            mData = {
               "gold":bossRewardGold,
               "tp":0,
               "xp":bossRewardXp,
               "name":" ",
               "type":subType
            };
            if(Number(mData.gold) == 0 && Number(mData.xp) == 0)
            {
               BattleReward();
            }
            else
            {
               if(Central.main.eventName == "Vday2015")
               {
                  Central.main.eventName = "";
                  Central.main.showInfo(Central.main.langLib.get(1897)[14] + " +" + reward_favor);
               }
               Central.main.popup.missionComplete02.init(true,true,mData,myEffect,bossRewardList,bossRewardGetList,battleWin);
            }
            Main.updateMenu(false);
            tempArr = String(bossId).split(",");
            addItem = true;
            for(i = 0; i < eventBossArr.length; i++)
            {
               if(tempArr.indexOf(eventBossArr[i]) >= 0)
               {
                  addItem = false;
                  break;
               }
            }
            if(addItem)
            {
               try
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_HUNTING_HOUSE_2012,bossId,"Boss_win");
               }
               catch(err:Error)
               {
                  Out.error("Battle","TRACK_HUNT_BOSS >> " + err.message);
               }
            }
            Main.getMainChar().updateDB(0,0,[],"",0,Battle);
            if(Central.main.isNewClanWar)
            {
               Central.main.partyNpc = Central.main.tmpParty;
               Central.main._partyMembers = Central.main.recruitFriendTmpData;
               Central.main.isNewClanWar = false;
               Central.main.crewDamage = response.dmg;
               Central.main.showDoubleCrewWarReward = response.double_reward;
            }
         }
      }
      
      private static function itemPrototype(str:String) : String
      {
         var strArr:Array = null;
         strArr = str.split("_");
         if(strArr != null)
         {
            if(strArr.length > 1)
            {
               switch(strArr[0])
               {
                  case "petxp":
                  case "xp":
                  case "gold":
                     return strArr[1];
                  case "item":
                     return strArr[0] + strArr[1];
                  default:
                     return strArr[0] + strArr[1];
               }
            }
            else
            {
               return strArr[0];
            }
         }
         else
         {
            Out.error("itemPrototype","parameter type not match");
            return null;
         }
      }
      
      public static function addBattleReward(rewardItems:Array) : *
      {
         rewardList = rewardItems;
      }
      
      public static function BattleReward() : *
      {
         if(rewardList != null && rewardList.length != 0)
         {
            Central.main.mainMc.popupMc.addReward(rewardList);
            Central.main.mainMc.popupMc.showReward();
         }
         rewardList = new Array();
         battleWin();
      }
      
      public static function onClanResult() : void
      {
         Central.main.partyMembers = null;
         battleMc["lbl_battle_result_title"].text = Central.main.langLib.titleTxt(TitleData.BATTLERESULT);
         battleMc["lbl_battle_result_win"].text = Central.main.langLib.titleTxt(TitleData.WIN);
         battleMc["lbl_battle_result_lose"].text = Central.main.langLib.titleTxt(TitleData.LOSE);
         battleMc["lbl_reputation_win"].text = Central.main.langLib.titleTxt(TitleData.REPUTATION) + ":";
         battleMc["lbl_reputation_lose"].text = Central.main.langLib.titleTxt(TitleData.REPUTATION) + ":";
         switch(battleResult)
         {
            case 1:
               battleMc["winClanTxt"].text = Clan.getInstance().clanData.name;
               battleMc["loseClanTxt"].text = Clan.getInstance().battleClanData.name;
               battleMc["winRepTxt"].text = String(repGain);
               battleMc["SelfWinRepTxt"].text = String(prestigeGain);
               Central.main.clanPrestige = Central.main.clanPrestige + prestigeGain;
               battleMc["loseRepTxt"].text = "";
               battleMc["selfLoseRepTxt"].text = "-";
               battleMc["winTotalRepTxt"].text = String(Clan.getInstance().clanData.reputation);
               battleMc["loseTotalRepTxt"].text = String(Clan.getInstance().battleClanData.reputation);
               battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleWin);
               break;
            case 2:
               battleMc["winClanTxt"].text = Clan.getInstance().battleClanData.name;
               battleMc["loseClanTxt"].text = Clan.getInstance().clanData.name;
               battleMc["winRepTxt"].text = "0";
               battleMc["SelfWinRepTxt"].text = "-";
               Central.main.clanPrestige = Central.main.clanPrestige + prestigeGain;
               battleMc["loseRepTxt"].text = "";
               battleMc["selfLoseRepTxt"].text = String(prestigeGain);
               battleMc["winTotalRepTxt"].text = String(Clan.getInstance().battleClanData.reputation);
               battleMc["loseTotalRepTxt"].text = String(Clan.getInstance().clanData.reputation);
               battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleLose);
               break;
            default:
               return;
         }
      }
      
      public static function showBattleWin() : void
      {
         var missionData:Object = null;
         if(Mission.curMissionID)
         {
            missionData = Main.MISSION_DATA[Mission.curMissionID];
            if(missionData.sp > 0 || missionData.grade == "S" || Mission.curMissionID == "msn284")
            {
               if(isShowLevelUp)
               {
                  isShowLevelUp = false;
                  Main.showLevelUp(battleWin);
               }
               else
               {
                  battleFinish();
                  Main.battleWin();
               }
            }
            else
            {
               battleMc.gotoWin();
            }
         }
         else
         {
            battleMc.gotoWin();
         }
      }
      
      public static function onShowBattleWin() : void
      {
         var rewardXP:uint = 0;
         var rewardGold:uint = 0;
         var rewardConsumables:Array = null;
         var rewardItems:Array = null;
         var i:uint = 0;
         var msg:String = null;
         var charIDs:Array = null;
         var itemText:String = null;
         var items:Array = null;
         rewardXP = 0;
         rewardGold = 0;
         rewardConsumables = [];
         rewardItems = [];
         charIDs = [];
         battleMc["okBtn"].addEventListener(MouseEvent.CLICK,battleWin);
         Main.getMainChar().playWin();
         battleMc["itemTitle"].visible = false;
         GF.removeAllChild(battleMc["displayHolder"]);
         GF.removeAllChild(battleMc["specialHolder"]);
         if(Battle.type == TYPE_LOCAL)
         {
            if(subType != BattleData.SUBTYPE_BOSS)
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  rewardGold = rewardGold + enemyArr[i].rewardGold;
                  rewardXP = rewardXP + enemyArr[i].rewardXP;
                  if(Main.challengeFriendUID != null)
                  {
                     charIDs.push(enemyArr[i].getData(DBCharacterData.ID));
                     switch(AppData.type)
                     {
                        case AppData.FB:
                           if(enemyArr[i].getData(DBCharacterData.XP) > 0)
                           {
                              msg = "";
                           }
                           else
                           {
                              msg = "";
                           }
                           break;
                        case AppData.OK:
                           if(enemyArr[i].getData(DBCharacterData.XP) > 0)
                           {
                              msg = String(Central.main.langLib.get(278)).replace("[valfbuserusername]",FBUser.username);
                              msg = String(msg).replace("[valdbcharacterdataname]",enemyArr[i].getData(DBCharacterData.NAME));
                              msg = String(msg).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           else
                           {
                              msg = String(Central.main.langLib.get(303)).replace("[valfbuserusername]",FBUser.username);
                              msg = String(msg).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           break;
                        case AppData.MP:
                           if(enemyArr[i].getData(DBCharacterData.XP) > 0)
                           {
                              msg = String(Central.main.langLib.get(297)).replace("[valfbuserusername]",FBUser.username);
                              msg = String(msg).replace("[valdbcharacterdataname]",enemyArr[i].getData(DBCharacterData.NAME));
                              msg = String(msg).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                           else
                           {
                              msg = String(Central.main.langLib.get(302)).replace("[valfbuserusername]",FBUser.username);
                              msg = String(msg).replace("[valapplicationurl]",Data.APPLICATION_URL);
                           }
                     }
                     Main.saveChallengeRecord(enemyArr[i].getData(DBCharacterData.ID),0);
                     Panel.getInstance().setChallenged(int(enemyArr[i].getData(DBCharacterData.ID)));
                  }
               }
               battleMc["xpTxt"].text = String(rewardXP);
               battleMc["goldTxt"].text = String(rewardGold);
               isShowLevelUp = Main.getMainChar().updateXP(rewardXP);
               Main.getMainChar().saveGold(rewardGold);
               itemText = "";
               if(rewardConsumables.length > 0 || rewardItems.length > 0)
               {
                  if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.FREE)
                  {
                     Main.showInfo(Central.main.langLib.get(348));
                     rewardConsumables = [];
                     rewardItems = [];
                  }
                  if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.PREMIUM)
                  {
                     Main.provision();
                     if(Main.getMainChar().calcInventoryUsage() >= Data.INV_SPACE_PREMIUM)
                     {
                        Main.showInfo(Central.main.langLib.get(348));
                        rewardConsumables = [];
                        rewardItems = [];
                     }
                  }
               }
               items = new Array();
               if(rewardItems.length > 0)
               {
                  itemText = itemText + (rewardItems[0].name + "<br>");
                  Main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,rewardItems[0].id);
                  battleMc["itemTitle"].visible = true;
                  items.push(rewardItems[0].id);
               }
               for(i = 0; i < (rewardConsumables.length > 3?3:rewardConsumables.length); i++)
               {
                  itemText = itemText + (rewardConsumables[i].name + "<br>");
                  Main.getMainChar().addInventory(InventoryData.TYPE_ITEM,rewardConsumables[i].id);
                  battleMc["itemTitle"].visible = true;
                  items.push(rewardConsumables[0].id);
               }
               battleMc["itemTxt"].htmlText = itemText;
            }
         }
         if(Main.challengeFriendUID != null)
         {
            SNS.publishFeed(SNSData.FEED_CHALLENGE_WON,SNS.challengeFriendName);
            if(Main.challengedFriends.indexOf(Main.challengeFriendUID) == -1)
            {
               if(msg != "")
               {
                  SNS.sendNotification(msg,[Main.challengeFriendUID]);
               }
               Main.challengedFriends.push(Main.challengeFriendUID);
            }
            Mission.updateDailyTask(DailyTaskData.TYPE_CHALLENGE,1);
            Main.challengeFriendUID = null;
         }
         if(Main.getMainChar().getData(DBCharacterData.RANK) >= 8 && subType != BattleData.SUBTYPE_BOSS)
         {
            rewardXP = 0;
         }
         Main.getMainChar().updateDB(rewardXP,rewardGold,[],null,0,Battle);
         Main.updateMenu();
         battleMc["itemTitle"].htmlText = Central.main.langLib.titleTxt(TitleData.ITEMS) + ":";
         battleMc["lbl_battle_result"].htmlText = Central.main.langLib.titleTxt(TitleData.VICTORY) + "!";
      }
      
      private static function battleWin(evt:MouseEvent = null) : void
      {
         if(isShowLevelUp)
         {
            isShowLevelUp = false;
            Main.showLevelUp(battleWin);
         }
         else
         {
            battleFinish();
            Main.battleWin();
         }
      }
      
      private static function battleLose(evt:MouseEvent = null) : void
      {
         battleFinish();
         Main.battleLose();
      }
      
      private static function showPvPBattleWin() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         battleResult = 1;
         trace("Central.main.PvpPlayerPost = " + Central.main.PvpPlayerPost);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc.gotoPvPWinQuick();
            return;
         }
         if(Central.main.PvpPlayerPost == "tournament")
         {
            battleMc.gotoPvPWinTournament();
            return;
         }
         if(Central.main.PvpPlayerPost == "PVE")
         {
            battleMc.gotoPveWin();
            return;
         }
         battleMc.gotoPvPWin();
      }
      
      private static function showPvPBattleLose() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         battleResult = 2;
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc.gotoPvPLoseQuick();
            return;
         }
         if(Central.main.PvpPlayerPost == "tournament")
         {
            battleMc.gotoPvPLoseTournament();
            return;
         }
         battleMc.gotoPvPLose();
      }
      
      private static function updatePvpBattleFinishResult() : void
      {
         var txtField:TextField = null;
         Out.debug("","Battle.pvpCurrencyGainDisplay=" + Battle.pvpCurrencyGainDisplay);
         Out.debug("","Battle.myCurrencyGain=" + Battle.myCurrencyGain);
         Out.debug("","Battle.pvpPointGainDisplay=" + Battle.pvpPointGainDisplay);
         Out.debug("","Battle.myPointGain=" + Battle.myPointGain);
         if(battleMc["mc_pvp_currency"] && battleMc["mc_pvp_currency"]["txt_value"])
         {
            battleMc["mc_pvp_currency"].visible = Battle.pvpCurrencyGainDisplay;
            txtField = battleMc["mc_pvp_currency"]["txt_value"];
            txtField.text = !!Battle.pvpCurrencyGainDisplay?Battle.myCurrencyGain + "":"TBA";
         }
         if(battleMc["mc_pvp_point"] && battleMc["mc_pvp_point"]["txt_value"])
         {
            battleMc["mc_pvp_point"].visible = Battle.pvpPointGainDisplay;
            txtField = battleMc["mc_pvp_point"]["txt_value"];
            txtField.text = !!Battle.pvpPointGainDisplay?Battle.myPointGain + "":"TBA";
         }
         Out.debug("","pvp currency gain = " + Battle.myCurrencyGain);
         Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] = Main.getMainChar().pvpRecord[PvPData.PVP_CURRENCY] + Battle.myCurrencyGain;
         Main.getMainChar().pvpRecord[PvPData.PVP_POINT] = Main.getMainChar().pvpRecord[PvPData.PVP_POINT] + Battle.myPointGain;
         isCompletedDailyFirstBonus = true;
         if(Central.main.PvpPlayerPost == "tournament")
         {
            Main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] = Main.getMainChar().pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] - 1;
         }
      }
      
      public static function onShowPvEBattleWin() : void
      {
         var i:int = 0;
         var MAX_ITEM:int = 0;
         var itemRewardList:Array = null;
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         MAX_ITEM = 10;
         itemRewardList = [];
         Main.achievement.updateBattleStat(Main.achievementData.LIVE_BATTLE_WIN,1);
         battleMc["skin_0_reward"]["lbl_ninjaemblem_title"].text = AppData.lang == AppData.ZH?"擊退成功!":"Defeat Success!";
         battleMc["skin_0_reward"]["MissionTxt"].text = AppData.lang == AppData.ZH?"獎勵":"Reward";
         battleMc["skin_0_reward"]["nameTxt"].text = AppData.lang == AppData.ZH?"獎勵":"Reward";
         for(i = 0; i < Battle.myPvEReward.length; i++)
         {
            if(Battle.myPvEReward[i].indexOf("xp") >= 0)
            {
               battleMc["skin_0_reward"]["goldTxt"]["txt"].text = int(Battle.myPvEReward[i].replace("xp",""));
               Main.getMainChar().showLevelUp(Main.getMainChar().updateXP(int(Battle.myPvEReward[i].replace("xp","")),true,true));
            }
            else if(Battle.myPvEReward[i].indexOf("gold") >= 0)
            {
               battleMc["skin_0_reward"]["xpTxt"]["txt"].text = int(Battle.myPvEReward[i].replace("gold",""));
               Central.main.getMainChar().updateGold(int(Battle.myPvEReward[i].replace("gold","")));
            }
            else
            {
               itemRewardList.push(Battle.myPvEReward[i]);
            }
         }
         battleMc["skin_0_reward"]["scoreTxt"]["txt"].text = Battle.myPvEScore;
         for(i = 0; i < MAX_ITEM; i++)
         {
            if(i < itemRewardList.length)
            {
               battleMc["skin_0_reward"]["rewardIcon_" + i].visible = true;
               Central.main.showIconData(battleMc["skin_0_reward"]["rewardIcon_" + i],itemRewardList[i],"1",false);
            }
            else
            {
               battleMc["skin_0_reward"]["rewardIcon_" + i].visible = false;
            }
         }
         Central.main.disableButton(battleMc["skin_0_reward"]["shareBtn"],onBackBtn);
         Central.main.initButton(battleMc["skin_0_reward"]["shareBtn"],onBackBtn,AppData.lang == AppData.ZH?"確定":"OK");
         Main.updateMenu(false);
      }
      
      public static function onShowPvPBattleWin() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         Main.getMainChar().pvpRecord[PvPData.PLAY]++;
         Main.getMainChar().pvpRecord[PvPData.WIN]++;
         Battle.updatePvpBattleFinishResult();
         Main.achievement.updateBattleStat(Main.achievementData.LIVE_BATTLE_WIN,1);
         battleMc["lbl_rematch_title"].text = "";
         battleMc["lbl_rematch_title"].visible = false;
         battleMc["lbl_battle_result"].text = Central.main.langLib.get(183);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = true;
            enableButtonsOnRematchRequest();
            battleMc.startRematchCountdown(REMATCH_TIME_LIMIT);
            if(Central.main.PvphavePlayerDisconnect)
            {
               disableButtonsOnRematchTimerCompleted();
               pvpWinLossPanelSomeoneLeft();
               if(battleMc["lbl_rematch_title"])
               {
                  battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
               }
            }
         }
         else
         {
            battleMc["defeatBarTxt"].visible = false;
            battleMc["signalMc"].visible = false;
            battleMc["okBtn"].visible = false;
            battleMc["noBtn"].visible = false;
            battleMc["backBtn"].visible = true;
            battleMc["lbl_rematch_title"].visible = true;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         }
      }
      
      public static function onShowPvPBattleLose() : void
      {
         if(Battle.type != TYPE_NETWORK)
         {
            return;
         }
         Main.getMainChar().pvpRecord[PvPData.PLAY]++;
         Main.getMainChar().pvpRecord[PvPData.LOSE]++;
         Battle.updatePvpBattleFinishResult();
         battleMc["lbl_rematch_title"].text = "";
         battleMc["lbl_rematch_title"].visible = false;
         battleMc["lbl_battle_result"].text = Central.main.langLib.get(347);
         if(Central.main.PvpPlayerPost == "quick")
         {
            battleMc["lbl_rematch_title"].text = "";
            battleMc["lbl_rematch_title"].visible = true;
            enableButtonsOnRematchRequest();
            battleMc.startRematchCountdown(REMATCH_TIME_LIMIT);
            battleMc["lbl_disconnect"].visible = false;
            if(Battle.pvpshowMyDisconnectText)
            {
               battleMc["lbl_disconnect"].visible = true;
               Battle.pvpshowMyDisconnectText = false;
               battleMc["lbl_disconnect"].text = AppData.lang == AppData.ZH?"你已經斷線,請檢查你的網絡":"Disconnect";
            }
            if(Central.main.PvphavePlayerDisconnect)
            {
               disableButtonsOnRematchTimerCompleted();
               pvpWinLossPanelSomeoneLeft();
               if(battleMc["lbl_rematch_title"])
               {
                  battleMc["lbl_rematch_title"].text = Battle.getPvpWinLossPanelMessage();
               }
            }
         }
         else
         {
            battleMc["defeatBarTxt"].visible = false;
            battleMc["signalMc"].visible = false;
            battleMc["okBtn"].visible = false;
            battleMc["noBtn"].visible = false;
            battleMc["backBtn"].visible = true;
            battleMc["lbl_rematch_title"].visible = false;
            battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
            battleMc["okBtn"].addEventListener(MouseEvent.CLICK,onOkBtn);
            battleMc["noBtn"].addEventListener(MouseEvent.CLICK,onNoBtn);
         }
      }
      
      public static function onOkBtn(evt:MouseEvent) : void
      {
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         pvpWinLossPanelPressedOk();
         if(battleMc["lbl_rematch_title"] != null)
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
         sendResetBattleMessage();
         rematchTimes++;
         Main.socket.rematch();
      }
      
      public static function onNoBtn(evt:MouseEvent) : void
      {
         if(Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament")
         {
            Central.main.socket.leaveRoom();
         }
         battleFinish();
         Main.battleWin();
      }
      
      public static function onBackBtn(evt:MouseEvent) : void
      {
         Out.debug("battle","onBackBtn PvpPlayerPost >> " + Central.main.PvpPlayerPost);
         if(Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament" || Central.main.PvpPlayerPost == "PVE")
         {
            Central.main.socket.leaveRoom();
         }
         battleFinish();
         Main.battleWin();
      }
      
      public static function showRematch(charId:uint) : void
      {
         pvpWinLossPanelSomeoneWantRematch();
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
      }
      
      public static function updatePvpRematchPanel() : void
      {
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
         switch(getPvpWinLossPanelStatus())
         {
            case "allow_go_away":
               disableButtonsOnRematchTimerCompleted();
               break;
            case "confirmed":
               disableButtonsNoExitOnRematchTimerCompleted();
               break;
            case "unstated":
               enableButtonsOnRematchRequest();
         }
      }
      
      public static function showDisconnect() : void
      {
         battleMc["backBtn"].visible = true;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["rematchMc"].visible = false;
         battleMc["okBtn"].visible = false;
         battleMc["noBtn"].visible = false;
         Main.showInfo(Main.langLib.get(214));
      }
      
      public static function battleFinish() : void
      {
         var i:uint = 0;
         var enemy:* = undefined;
         var teamate:* = undefined;
         var pet:* = undefined;
         var hairColorArr_all:Array = null;
         var skinColorArr_all:Array = null;
         var countryAreaMatch:Array = null;
         battleMc.stage.focus = null;
         try
         {
            if(battleMc != null)
            {
               battleMc.gotoAndStop(Timeline.IDLE);
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.getMainChar().resetBattleData();
            Main.getMainChar().removeParent();
            Main.getMainChar().setCharMc(null);
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(enemyArr != null)
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  enemy = enemyArr[i];
                  enemy.resetBattleData();
                  enemy.removeParent();
                  enemy.setCharMc(null);
               }
            }
            if(partyArr)
            {
               for(i = 0; i < partyArr.length; i++)
               {
                  teamate = partyArr[i];
                  teamate.resetBattleData();
                  teamate.removeParent();
                  teamate.setCharMc(null);
               }
            }
            if(petArr)
            {
               for(i = 0; i < petArr.length; i++)
               {
                  pet = petArr[i];
                  pet.resetBattleData();
                  pet.removeParent();
                  pet.setCharMc(null);
                  pet.resetSkillCooldown();
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 3 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(onBattleMusic)
            {
               Central.main.mixer.stopMusic();
               onBattleMusic = false;
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.1 :: " + e.getStackTrace());
         }
         try
         {
            Main.mapMenu.hideChatInput();
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 5 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            GF.removeAllChild(battleMc["displayHolder"]);
            GF.removeAllChild(battleMc["specialHolder"]);
            enemyArr = null;
            partyArr = null;
            petArr = null;
            attacker = null;
            defender = null;
            selectedTarget = null;
            battleMc = null;
            consumablesUsed = 0;
            rematchTimes = 0;
            battleResult = 0;
            repGain = 0;
            bossId = "";
            use_seal_enemy = false;
            seal_enemy = false;
            spy_enemy = false;
            Central.main.battleRuleArr = [];
            Central.main.actionChecker = true;
            Central.main.battleId = "";
            Central.main.battleModeSpecial = false;
            isPartyControllable = false;
            pvpSyncLogSaved = false;
            pvpLogTimeSaved = false;
            specialHpData = {};
            battleRoundCounter = 0;
            battleDamageLog = 0;
            if(Central.main.senjutsuFeature)
            {
               Central.main.senninModeBtn.visible = false;
               Central.main.senninModeBtn.mouseEnabled = false;
               Central.main.senninModeBtn.mouseChildren = false;
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         if(Battle.type == TYPE_NETWORK)
         {
            try
            {
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_COMPLETE + "Premuim");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.getMainChar().getLevel(),Central.main.tracking.TRACK_COMPLETE + "Free");
               }
               if(Central.main.PvpPlayerPlace == "quick")
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpQMMode,Central.main.tracking.TRACK_PVP_QUICK_MATCH_FINISH);
               }
               else if(Central.main.PvpPlayerPlace == "private")
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,Central.main.PvpPVMode,Central.main.tracking.TRACK_PVP_PRIVATE_FINISH);
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","battleFinish :: TRACKING - TRACK_PVP(TRACK_COMPLETE)");
            }
            finish_battle_time = int(getTimeStamp());
            whole_battle_time = finish_battle_time - start_battle_time;
         }
         if(Central.main.isNewChar && Central.main.isNewCharByCreate)
         {
            Central.main.isNewChar = false;
            hairColorArr_all = Data.getHairColorArr();
            skinColorArr_all = Data.getSkinColorArr();
            countryAreaMatch = [[7,2],[7,7],[1,0],[7,6],[0,0]];
            Central.main.showAmfLoading();
            Central.main.amfClient.service("CharacterDAO.createCharacter",[Account.getAccountSessionKey(),Central.main.getDBChar().character_name,Central.main.getDBChar().character_gender,hairColorArr_all.indexOf(Central.main.getMainChar().getData("character_hair_color")),skinColorArr_all.indexOf(Central.main.getMainChar().getData("character_skin_color")),Central.main.getDBChar().character_hair.replace("hair_",""),Central.main.getDBChar().character_face.replace("face_","")],onAmfCreateCharacter);
         }
         else
         {
            Main.achievement.flushBattleStat();
         }
      }
      
      private static function onAmfCreateCharacter(response:Object) : void
      {
         if(Main.validateAmfResponse(response))
         {
            Central.main.getDBChar().character_id = response.character_id;
            Central.main.amfClient.service("SystemData.getCreateCharacter",[Account.getAccountSessionKey(),Data.TEST_VERSION],onAmfGetCreateCharacter);
         }
      }
      
      private static function onAmfGetCreateCharacter(result:Object) : void
      {
         var xpHash:String = null;
         if(Central.main.dataParser.parseSystemData(result))
         {
            xpHash = Central.main.getHash(String(Central.main.getMainChar().xp));
            Central.main.amfClient.service("CharacterDAO.getExtraData",[Account.getAccountSessionKey(),xpHash,Central.main.ACCESS_TOKEN],getExtraDataResult);
         }
      }
      
      private static function getExtraDataResult(result:Object) : void
      {
         var extraData:Object = null;
         if(Main.validateAmfResponse(result))
         {
            extraData = result.result as Object;
            if(Central.main.dataParser.parseCharacterData(extraData))
            {
               if(extraData.char_login_per_day == 0)
               {
                  Central.main.tracking.trackAppLang(Central.main.tracking.TRACK_APP_LANG);
                  Central.main.tracking.trackACBalance(Central.main.tracking.TRACK_GOLD);
                  if(Account.getAccountType() == Account.FREE)
                  {
                     Central.main.tracking.trackClick2(Central.main.tracking.TRACK_LOGIN,Central.main.tracking.TRACK_FREE + Central.main.tracking.TRACK_UNIQUE);
                     Central.main.tracking.generalTrack(Central.main.tracking.TRACK_LONGIN_LV,Central.main.getMainChar().getLevel());
                  }
               }
               if(Environment.IS_IN_BROWSER)
               {
                  Central.main.initRank();
               }
               Central.main.hideAmfLoading();
               Central.main.amfClient.service("CharacterService.selectFreeSkill",[Central.main.account.getAccountSessionKey(),Central.main.getDBChar().character_skills[0]],Central.main.onAmfResult);
            }
            else
            {
               Out.error("main","getExtraDataResult :: parseCharacterData failed");
            }
         }
      }
      
      public static function updateSPButton() : void
      {
         var battleAction:Object = null;
         var stunDimSenninButton:Boolean = false;
         if(Central.main.senjutsuFeature)
         {
            if(Main.getMainChar().getData(DBCharacterData.SP) >= Main.getMainChar().maxSP && !Main.getMainChar().isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
            {
               Main.updateMenu();
               battleAction = Central.battle.getAttacker().getBattleAction();
               stunDimSenninButton = false;
               if(battleAction && battleAction.debuffOverride == true)
               {
                  stunDimSenninButton = true;
               }
               if(isActionBarShow && !stunDimSenninButton)
               {
                  Central.main.senninModeBtn.visible = true;
                  Central.main.senninModeBtn.mouseEnabled = true;
                  Central.main.senninModeBtn.mouseChildren = true;
                  Central.main.senninModeBtn.buttonMode = true;
                  Central.main.senninModeBtn.filters = null;
               }
               else
               {
                  Central.main.senninModeBtn.visible = true;
                  Central.main.senninModeBtn.mouseEnabled = false;
                  Central.main.senninModeBtn.mouseChildren = false;
                  Central.main.senninModeBtn.buttonMode = false;
                  if(!stunDimSenninButton)
                  {
                     Central.main.senninModeBtn.filters = null;
                  }
                  else
                  {
                     Central.main.senninModeBtn.filters = [dimFilter];
                  }
               }
            }
            else
            {
               Central.main.senninModeBtn.visible = true;
               Central.main.senninModeBtn.mouseEnabled = false;
               Central.main.senninModeBtn.mouseChildren = false;
               Central.main.senninModeBtn.buttonMode = false;
               Central.main.senninModeBtn.filters = [dimFilter];
            }
         }
      }
      
      public static function enableSPButton() : void
      {
         updateSPButton();
      }
      
      public static function disableSPButton() : void
      {
         Central.main.senninModeBtn.mouseEnabled = false;
         Central.main.senninModeBtn.mouseChildren = false;
         Central.main.senninModeBtn.buttonMode = false;
      }
      
      private static function onPlayerCommand() : void
      {
         var attacker:* = undefined;
         var max:int = 0;
         var min:int = 0;
         attacker = Central.battle.getAttacker();
         attacker.showCmdDisplay();
         enableTargetSelection();
         battleMc["actionBar"].show();
         isActionBarShow = true;
         if(Main.battleModeSpecial && Main.battleModeSpecial == true)
         {
            max = Math.ceil(defender.hp / defender.maxHP * 100);
            min = Math.floor(defender.hp / defender.maxHP * 100);
            if(Main.battleModeSpecial && Main.battleModeSpecial == true && max >= Central.main.battleRuleArr[0].amount_over && min <= Central.main.battleRuleArr[0].amount_less)
            {
               specialHpData.showGlowBackground = true;
            }
            else
            {
               specialHpData.showGlowBackground = false;
            }
            if(!((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS)))
            {
               Main.showPopupSpecialHpBar(specialHpData);
            }
         }
         if(!isPlayingSkillAnimation)
         {
            Main.enableMenu();
         }
         enableSPButton();
         refreshGearBtn();
      }
      
      private static function refreshGearBtn() : void
      {
         bGearBtnEnabled = true;
         if((Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_STUN) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_SLEEP) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_FEAR) || (Central.main.getMainChar() as Character).isBattleDebuffActive(BattleData.EFFECT_CHAOS) || Central.main.PvpPlayerPost == "PVE")
         {
            bGearBtnEnabled = false;
         }
         if(selectedPartySkillID != -1)
         {
            bGearBtnEnabled = false;
         }
         if(bGearBtnEnabled)
         {
            Main.enableGearBtn();
         }
         else
         {
            Main.disableGearBtn();
         }
      }
      
      private static function refreshPartySelectCancelBtnPosition() : void
      {
         var actionBar:MovieClip = null;
         var i:int = 0;
         var actionBarSkillBox:MovieClip = null;
         var redCross:MovieClip = null;
         if(battleMc == null)
         {
            return;
         }
         actionBar = battleMc["actionBar"];
         if(actionBar == null)
         {
            return;
         }
         for(i = 0; i < 8; i++)
         {
            actionBarSkillBox = actionBar["skill_" + i];
            if(actionBarSkillBox != null)
            {
               redCross = MovieClip(actionBarSkillBox.getChildByName("redcross"));
               if(redCross != null)
               {
                  redCross.visible = i == selectedPartySkillID;
               }
            }
         }
      }
      
      public static function onPass() : void
      {
         if(selectedPartySkillID != -1)
         {
            disablePartySelection();
         }
         onBattle();
         Character(attacker).setPlayerCommand("pass");
         sendCommand();
      }
      
      public static function onAttack(evt:Event) : void
      {
         if(Mission.curMissionID == "msn0" && Central.main.isNewAccount)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Attack","Step9");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP9"],trackingResponse);
         }
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(!Central.main.isNewChar)
         {
            if(attacker.getCharacterId() == Main.getMainChar().getCharacterId())
            {
               Main.achievement.updateBattleStat(Main.achievementData.USE_WEAPON,1);
            }
         }
         if(attacker.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_DISMANTLE))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.SKILL_341))
         {
            Main.showInfo(Central.main.langLib.get(797));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("weapon_attack");
         sendCommand();
      }
      
      public static function onCharge(evt:Event) : void
      {
         if(Mission.curMissionID == "msn0" && Central.main.isNewAccount)
         {
            Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Charge","Step7");
            Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP7"],trackingResponse);
         }
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
         {
            Main.showInfo(Central.main.langLib.get(526));
            return;
         }
         if(attacker.isBattleDebuffActive(BattleData.EFFECT_RESTRICT_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(796));
            return;
         }
         if(attacker.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(621));
            return;
         }
         if(attacker.isBattleDebuffActive(BloodlineData.EFFECT_RESTRICT_CHARGE))
         {
            Main.showInfo(Central.main.langLib.get(796));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("charge");
         sendCommand();
      }
      
      public static function onSkill(evt:Event) : void
      {
         var skillId:uint = 0;
         var skillList:Array = null;
         var skillData:Object = null;
         var hasAliveParty:Boolean = false;
         var i:int = 0;
         if(Mission.curMissionID == "msn0" && Central.main.isNewAccount)
         {
            if(Central.main.tutorialMsnStep == 0)
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Skill","Step6");
               Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP6"],trackingResponse);
            }
            else if(Central.main.tutorialMsnStep == 1)
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_CREATE_CHAR,"Skill","Step8");
               Central.main.amfClient.service("Tracking.tutTracking",[Central.main.account.getAccountSessionKey(),"STEP8"],trackingResponse);
            }
         }
         skillId = int(String(evt.currentTarget.name).split("_")[1]);
         if(selectedPartySkillID == skillId)
         {
            disablePartySelection();
            for(i = 0; i < enemyArr.length; i++)
            {
               if(!enemyArr[i].isDead)
               {
                  enemyArr[i].enableSelection();
               }
               else
               {
                  enemyArr[i].diableSelection();
               }
               enemyArr[i].hideSelection();
            }
            if(defaultTarget)
            {
               selectedTarget = defaultTarget;
            }
            else
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  if(!enemyArr[i].isDead)
                  {
                     selectedTarget = enemyArr[i];
                     break;
                  }
               }
            }
            selectedTarget.displaySelection();
            defender = selectedTarget;
            return;
         }
         skillList = Central.main.getMainChar().getSkillListArr();
         skillData = Main.SKILL_DATA[skillList[skillId]];
         if(skillList[skillId])
         {
            switch(skillData.target)
            {
               case SkillData.TARGET_SINGLE_FRIENDLY:
                  if(partyArr.length < 1)
                  {
                     Main.showInfo(String(Central.main.langLib.get(1801)[1]));
                     return;
                  }
                  hasAliveParty = false;
                  for(i = 0; i < partyArr.length; i++)
                  {
                     if(!partyArr[i].isDead)
                     {
                        hasAliveParty = true;
                        break;
                     }
                  }
                  if(!hasAliveParty)
                  {
                     Main.showInfo(String(Central.main.langLib.get(1801)[1]));
                     return;
                  }
                  if(selectedPartySkillID == -1 && Character(attacker).setPlayerCommand("skill",skillId))
                  {
                     selectedPartySkillID = skillId;
                     enablePartySelection();
                     return;
                  }
                  break;
            }
         }
         if(selectedPartySkillID == -1)
         {
            if(Character(attacker).setPlayerCommand("skill",skillId))
            {
               onBattle();
               sendCommand();
            }
         }
         else
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
         }
      }
      
      public static function enableSageMode() : Boolean
      {
         if(attacker.sp == attacker.maxSP)
         {
            return true;
         }
         return false;
      }
      
      public static function onDodge(evt:Event) : void
      {
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         onBattle();
         Character(attacker).setPlayerCommand("dodge");
         sendCommand();
      }
      
      public static function onClassSkill(evt:Event) : void
      {
         var skillId:uint = 0;
         var classSkillList:Array = null;
         skillId = int(String(evt.currentTarget.name).split("_")[1]);
         classSkillList = Central.main.getMainChar().getClassSkillListArr();
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if((attacker as Character).getIsClassSkillAvailable(skillId - 1) && classSkillList[skillId - 1] != "skill2002")
         {
            (attacker as Character).setIsClassSkillAvailable(skillId - 1,false);
            onBattle();
            attacker.setPlayerCommand("class_skill",classSkillList[skillId - 1]);
            sendCommand();
         }
      }
      
      public static function onClassSkillMouseOver(evt:Event) : void
      {
         var skillId:uint = 0;
         var classSkillList:Array = null;
         var i:* = undefined;
         skillId = int(String(evt.currentTarget.name).split("_")[1]);
         classSkillList = Central.main.getMainChar().getClassSkillListArr();
         if(classSkillList[skillId - 1] == "skill2002")
         {
            for(i = 0; i < enemyArr.length; i++)
            {
               enemyArr[i].showClassSkillDetail();
            }
         }
      }
      
      public static function onClassSkillMouseOut(evt:Event) : void
      {
         var skillId:uint = 0;
         var classSkillList:Array = null;
         var i:* = undefined;
         skillId = int(String(evt.currentTarget.name).split("_")[1]);
         classSkillList = Central.main.getMainChar().getClassSkillListArr();
         if(classSkillList[skillId - 1] == "skill2002")
         {
            for(i = 0; i < enemyArr.length; i++)
            {
               enemyArr[i].hideClassSkillDetail();
            }
         }
      }
      
      private static function triggerSkill2002() : void
      {
         var effect:MovieClip = null;
         isPlayingSkillAnimation = true;
         Central.main.disableMenu();
         effect = Skill.getSpecialEffect("skill2002");
         addSpecialEffect(effect);
      }
      
      public static function onRun(evt:MouseEvent) : void
      {
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         if(Battle.type == TYPE_NETWORK)
         {
            Main.showInfo(Central.main.langLib.get(343));
            return;
         }
         if(Mission.curMissionID == "msn0")
         {
            onBattle();
            Character(attacker).setPlayerCommand("item","item1");
            sendCommand();
         }
         else
         {
            Main.showConfirmation(Central.main.langLib.get(285),checkRun,new Function());
         }
      }
      
      public static function checkRun() : void
      {
         var rNum:Number = NaN;
         rNum = NumberUtil.getRandom();
         if(rNum < BattleData.BATTLE_RUN_CHANGE)
         {
            Main.achievement.updateBattleStat(Main.achievementData.RUN,1);
            onBattle();
            Character(attacker).setPlayerCommand("item","item1");
            sendCommand();
         }
         else
         {
            Main.showInfo(Central.main.langLib.get(345));
            onBattle();
            Character(attacker).setPlayerCommand("pass");
            actionFinish_CB();
         }
      }
      
      public static function useItem(itemId:String) : void
      {
         var check:String = null;
         var numberToHash:uint = 0;
         var scrollMc:String = null;
         var i:int = 0;
         check = Sha1Encrypt.encrypt(consumablesUsed.toString());
         if(check != consumablesUsedHash)
         {
            return;
         }
         numberToHash = Math.round(consumablesUsed + 0);
         if(consumablesUsed >= BattleData.CONSUMABLE_LIMIT)
         {
            Main.showInfo(String(Central.main.langLib.get(339)).replace("[valconsumablelimit]",BattleData.CONSUMABLE_LIMIT.toString()));
            return;
         }
         if(Battle.type == TYPE_NETWORK)
         {
            consumablesUsed++;
            numberToHash++;
            consumablesUsedHash = Sha1Encrypt.encrypt(numberToHash.toString());
            scrollMc = "";
            if(Central.main.PvpBattleType == "quickMatch" || Central.main.PvpPlayerPost == "tournament")
            {
               scrollMc = "scrollDisplayMc_1";
            }
            if(Central.main.PvpBattleType == "private")
            {
               for(i = 0; i < Central.main.PvpPVMode; i++)
               {
                  if(Central.main.PvpTeamA[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
                  if(Central.main.PvpTeamB[i] == Main.getMainChar().getData(DBCharacterData.ID))
                  {
                     scrollMc = "scrollDisplayMc_" + (i + 1);
                  }
               }
            }
            battleMc[scrollMc]["scroll_" + consumablesUsed].gotoAndStop(2);
            try
            {
               Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,itemId,Central.main.tracking.TRACK_ITEM_USED);
            }
            catch(err:Error)
            {
               Out.error("Battle","useItem :: TRACKING - TRACK_PVP(TRACK_ITEM_USED)");
            }
         }
         onBattle();
         attacker.setPlayerCommand("item",itemId);
         if(Main.checkUseTokenInsteadItem)
         {
            Main.checkUseTokenInsteadItem = false;
         }
         else
         {
            Main.getMainChar().addUsedBattleItem(itemId);
         }
         sendCommand();
      }
      
      private static function enableTargetSelection() : void
      {
         var i:uint = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            if(!enemyArr[i].isDead)
            {
               if(selectedTarget && defaultTarget)
               {
                  selectedTarget.hideSelection();
                  selectedTarget = defaultTarget;
                  defender = selectedTarget;
                  defaultTarget = null;
                  selectedTarget.displaySelection();
               }
               enemyArr[i].enableSelection();
            }
         }
      }
      
      private static function disableTargetSelection() : void
      {
         var i:uint = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].disableSelection();
         }
      }
      
      private static function enablePartySelection() : void
      {
         var i:uint = 0;
         if(selectedTarget)
         {
            defaultTarget = selectedTarget;
            selectedTarget.hideSelection();
         }
         for(i = 0; i < partyArr.length; i++)
         {
            if(!partyArr[i].isDead)
            {
               partyArr[i].enableSelection();
            }
         }
         for(i = 0; i < partyArr.length; i++)
         {
            if(!partyArr[i].isDead)
            {
               selectedTarget = partyArr[i];
               break;
            }
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].disableSelection();
         }
         selectedTarget.displaySelection();
         defender = selectedTarget;
         canSelectparty = true;
         refreshGearBtn();
         refreshPartySelectCancelBtnPosition();
      }
      
      private static function disablePartySelection() : void
      {
         var i:uint = 0;
         for(i = 0; i < partyArr.length; i++)
         {
            partyArr[i].disableSelection();
            partyArr[i].hideSelection();
         }
         canSelectparty = false;
         selectedPartySkillID = -1;
         refreshGearBtn();
         refreshPartySelectCancelBtnPosition();
      }
      
      private static function enablePetSelection() : void
      {
         var i:uint = 0;
         for(i = 0; i < petArr.length; i++)
         {
            if(!petArr[i].isDead)
            {
               if(selectedTarget && defaultTarget)
               {
                  selectedTarget.hideSelection();
                  selectedTarget = defaultTarget;
                  defender = selectedTarget;
                  defaultTarget = null;
                  selectedTarget.displaySelection();
               }
               petArr[i].enableSelection();
            }
         }
      }
      
      private static function disablePetSelection() : void
      {
         var i:uint = 0;
         for(i = 0; i < petArr.length; i++)
         {
            petArr[i].disableSelection();
         }
      }
      
      private static function enableDeadSelection() : void
      {
         var i:uint = 0;
         canSelectpartyDead = true;
         for(i = 0; i < partyArr.length; i++)
         {
            if(partyArr[i].isDead)
            {
               if(selectedTarget && defaultTarget == null)
               {
                  defaultTarget = selectedTarget;
                  selectedTarget.hideSelection();
               }
               selectedTarget = partyArr[i];
               selectedTarget.displaySelection();
               partyArr[i].enableSelection();
            }
         }
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyArr[i].disableSelection();
         }
      }
      
      private static function disableDeadSelection() : void
      {
         var i:uint = 0;
         canSelectpartyDead = false;
         for(i = 0; i < petArr.length; i++)
         {
            petArr[i].disableSelection();
         }
      }
      
      public static function selectTarget(_evt:MouseEvent) : void
      {
         var target:* = undefined;
         var i:int = 0;
         target = _evt.currentTarget.char;
         if(!target.isDead)
         {
            if(selectedTarget)
            {
               selectedTarget.hideSelection();
            }
            selectedTarget = target;
            selectedTarget.displaySelection();
            defender = selectedTarget;
            if(canSelectparty)
            {
               holdTargetIsMember = selectedTarget;
               disablePartySelection();
               onBattle();
               sendCommand();
            }
         }
         else if(canSelectpartyDead)
         {
            if(selectedTarget)
            {
               selectedTarget.hideSelection();
            }
            selectedTarget = target;
            selectedTarget.displaySelection();
            defender = selectedTarget;
            defender.isDead = false;
            holdTargetIsMember = selectedTarget;
            disableDeadSelection();
            onBattle();
            sendCommand();
         }
      }
      
      private static function playAttack(_cls:*, _battleAction:Object, _attackPoint:Point) : void
      {
         _cls.playAttack(_battleAction,_attackPoint);
      }
      
      private static function playCharge(_cls:*) : void
      {
         _cls.playCharge();
      }
      
      private static function playSkill(_cls:*, _battleAction:Object, _attackPoint:Point) : void
      {
         _cls.playSkill(_battleAction,_attackPoint);
      }
      
      private static function playSkip(_cls:*) : void
      {
         _cls.playSkip();
      }
      
      private static function playClassSkill(_cls:*, _battleAction:Object, _attackPoint:Point) : void
      {
         _cls.playClassSkill(_battleAction,_attackPoint);
      }
      
      private static function playHit(_cls:*) : void
      {
         if(!_cls.isDead || _cls.limb > 1)
         {
            _cls.playHit();
         }
      }
      
      private static function playAction(_cls:*, _animation:String) : void
      {
         _cls.playAction(_animation);
      }
      
      private static function playBattleAction(_cls:*, battleAction:Object, attackPoint:Point) : void
      {
         _cls.playBattleAction(battleAction,attackPoint);
      }
      
      private static function playBloodline(_cls:*, _battleAction:Object, _attackPoint:Point) : void
      {
         _cls.playBloodline(_battleAction,_attackPoint);
      }
      
      private static function playSenjutsu(_cls:*, _battleAction:Object, _attackPoint:Point) : void
      {
         _cls.playSenjutsu(_battleAction,_attackPoint);
      }
      
      public static function enableButtons(_btnArr:Array) : void
      {
         var i:uint = 0;
         for(i = 0; i < _btnArr.length; i++)
         {
            battleMc["actionBar"].enableButton(_btnArr[i]);
         }
      }
      
      public static function showTutorialTips(label:String) : void
      {
         var _mainMc:MovieClip = null;
         var mc:MovieClip = null;
         _mainMc = Central.main.getMainMc();
         _mainMc["tutorialHintMc"].visible = true;
         _mainMc["tutorialHintMc"]["tutorialTipsMc"].gotoAndStop(label);
         mc = _mainMc["tutorialHintMc"]["tutorialTipsMc"];
         mc["lbl_tutorial_attack"].text = "";
         mc["lbl_tutorial_useskill"].text = "";
         mc["lbl_tutorial_charge"].text = "";
         mc["lbl_tutorial_run"].text = "";
         mc["lbl_tutorial_skill"].text = "";
         switch(label)
         {
            case "attack":
               _mainMc["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_attack"].text = Central.main.langLib.get(411);
               break;
            case "charge":
               _mainMc["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_useskill"].text = Central.main.langLib.get(413);
               _mainMc["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_charge"].text = Central.main.langLib.get(412);
               break;
            case "run":
               _mainMc["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_run"].text = Central.main.langLib.get(414);
               break;
            case "skill":
               _mainMc["tutorialHintMc"]["tutorialTipsMc"]["lbl_tutorial_skill"].text = Central.main.langLib.get(415);
         }
      }
      
      public static function addSpecialEffect(_mc:MovieClip) : void
      {
         Main.playBattleEffect(_mc);
      }
      
      private static function removeSpecialEffect() : void
      {
         Main.removeBattleEffect();
      }
      
      public static function checkWeaponPurifyRestore(char:*) : void
      {
         var purifyWeaponEffect:Object = null;
         var tmpEffect:Object = null;
         var i:int = 0;
         var restoreHp:int = 0;
         var purifyObj:Object = {};
         purifyWeaponEffect = Central.main.WEAPON_DATA.find(char.getWeapon());
         if(purifyWeaponEffect != null)
         {
            if(purifyWeaponEffect.effect.length > 0)
            {
               for(i = 0; i < purifyWeaponEffect.effect.length; i++)
               {
                  tmpEffect = purifyWeaponEffect.effect[i];
                  if(tmpEffect.type == BattleData.EFFECT_PURIFY_RESTORE_HP)
                  {
                     restoreHp = Math.round(int(char.maxHP) * (tmpEffect.amount / 100));
                  }
               }
               if(restoreHp > 0)
               {
                  char.updateHP(restoreHp);
                  char.showOverheadNumber(Timeline.HEAL,restoreHp);
               }
            }
         }
      }
      
      public static function checBackItemPurifyRestore(char:*) : void
      {
         var purifBackItemEffect:Object = null;
         var tmpEffect:Object = null;
         var i:int = 0;
         var restoreHp:int = 0;
         var purifyObj:Object = {};
         purifBackItemEffect = Central.main.BACK_ITEM_DATA.find(char.getBackItem());
         if(purifBackItemEffect != null)
         {
            if(purifBackItemEffect.effect.length > 0)
            {
               for(i = 0; i < purifBackItemEffect.effect.length; i++)
               {
                  tmpEffect = purifBackItemEffect.effect[i];
                  if(tmpEffect.type == BattleData.EFFECT_PURIFY_RESTORE_HP)
                  {
                     restoreHp = Math.round(int(char.maxHP) * (tmpEffect.amount / 100));
                  }
               }
               if(restoreHp > 0)
               {
                  char.updateHP(restoreHp);
                  char.showOverheadNumber(Timeline.HEAL,restoreHp);
               }
            }
         }
      }
      
      public static function onIncomingRoomMessage(message:String) : void
      {
         message = Base64.decode(message);
         if(battleMc["chatDisplayMc"])
         {
            if(String(battleMc["chatDisplayMc"].htmlText).length >= Data.CHAT_MAX_DISPLAY_CHARACTERS)
            {
               battleMc["chatDisplayMc"].htmlText = String(battleMc["chatDisplayMc"].htmlText).substr(200,String(battleMc["chatDisplayMc"].htmlText).length - 200);
            }
            battleMc["chatDisplayMc"].htmlText = battleMc["chatDisplayMc"].htmlText + ("<font color=\'#FFFFFF\'>" + message + "</font>");
            battleMc["chatDisplayMc"].verticalScrollPosition = battleMc["chatDisplayMc"].maxVerticalScrollPosition;
         }
      }
      
      public static function set type(_type:String) : void
      {
         battleType = _type;
      }
      
      public static function get type() : String
      {
         return battleType;
      }
      
      public static function Mission135_SpecialAction() : void
      {
         var NoofTurnChangeBG:uint = 0;
         var NoofTurnChangeBG_Modifier:uint = 0;
         var i:uint = 0;
         var targetList:Array = null;
         var noofenemyModifer:uint = 0;
         var FrameName:String = null;
         var rNum:int = 0;
         var CurrentNum:int = 0;
         if(Mission.curMissionID == "msn135")
         {
            NoofTurnChangeBG = Central.mission.curMission.NoofTurnChange;
            NoofTurnChangeBG_Modifier = Central.mission.curMission.NoofTurnChangeBG_Modifier;
            targetList = [];
            if(enemyArr != null)
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  if(!enemyArr[i].isDead)
                  {
                     targetList.push(enemyArr[i]);
                  }
               }
            }
            noofenemyModifer = 0;
            noofenemyModifer = Math.abs(targetList.length - 3);
            NoofTurnChangeBG = NoofTurnChangeBG - noofenemyModifer * NoofTurnChangeBG_Modifier;
            if(round == 0 || round % NoofTurnChangeBG == 0)
            {
               FrameName = MovieClip(battleMc["bgHolder"].getChildByName("bg")).currentLabel;
               rNum = Math.floor(NumberUtil.randomInt(1,5));
               CurrentNum = int(String(FrameName).replace("bg_",""));
               if(rNum == CurrentNum)
               {
                  rNum++;
               }
               if(rNum >= 6)
               {
                  rNum = 1;
               }
               switch(rNum)
               {
                  case 1:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_1");
                     Mission135_SetElementalMan(rNum,targetList);
                     break;
                  case 2:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_2");
                     Mission135_SetElementalMan(rNum,targetList);
                     break;
                  case 3:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_3");
                     Mission135_SetElementalMan(rNum,targetList);
                     break;
                  case 4:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_4");
                     Mission135_SetElementalMan(rNum,targetList);
                     break;
                  case 5:
                     MovieClip(battleMc["bgHolder"].getChildByName("bg")).gotoAndPlay("bg_5");
                     Mission135_SetElementalMan(rNum,targetList);
               }
            }
         }
      }
      
      public static function Mission135_SetElementalMan(bg:uint, targetList:Array) : void
      {
         var i:uint = 0;
         var rNum:int = 0;
         var rNumElenentalNo:int = 0;
         var TmpNo:int = 0;
         rNum = Math.floor(NumberUtil.randomInt(0,targetList.length - 1));
         rNumElenentalNo = bg;
         TmpNo = 0;
         for(i = 0; i < targetList.length; i++)
         {
            if(i == rNum)
            {
               Mission135_SetElementalMan_attribute(bg,targetList[i],bg,targetList.length);
            }
            else
            {
               do
               {
                  rNumElenentalNo = Math.floor(NumberUtil.randomInt(1,5));
               }
               while(rNumElenentalNo == bg || rNumElenentalNo == TmpNo);
               
               Mission135_SetElementalMan_attribute(bg,targetList[i],rNumElenentalNo,targetList.length);
               TmpNo = rNumElenentalNo;
            }
         }
      }
      
      public static function Mission135_SetElementalMan_attribute(bg:uint, EnemyData:*, TargetElenemtal:uint, noOfEnemt:uint) : void
      {
         var i:uint = 0;
         var MaxAttribute:uint = 0;
         var MinAttribute:uint = 0;
         var NormalAttribute:uint = 0;
         var SecondAttribute:uint = 0;
         var EnemyDealDamageModifier_2:Number = NaN;
         var EnemySufferDamageModifier_2:Number = NaN;
         var EnemyDealDamageModifier_1:Number = NaN;
         var EnemySufferDamageModifier_1:Number = NaN;
         var noofenemy_D:Number = NaN;
         var noofenemy_S:Number = NaN;
         var NormalDealDamageModifier:uint = 0;
         var NormalSufferDamageModifier:uint = 0;
         var SuperDealDamageModifier:uint = 0;
         var SuperSufferDamageModifier:uint = 0;
         var WeakenDealDamageModifier:uint = 0;
         var WeakenSufferDamageModifier:uint = 0;
         MaxAttribute = Central.mission.curMission.MaxAttribute;
         MinAttribute = Central.mission.curMission.MinAttribute;
         NormalAttribute = Central.mission.curMission.NormalAttribute;
         SecondAttribute = Central.mission.curMission.SecondAttribute;
         var SufferDamageModifier:uint = Central.mission.curMission.SecondAttribute;
         var DealDamageModifier:uint = Central.mission.curMission.SecondAttribute;
         EnemyDealDamageModifier_2 = Central.mission.curMission.EnemyDealDamageModifier_2;
         EnemySufferDamageModifier_2 = Central.mission.curMission.EnemySufferDamageModifier_2;
         EnemyDealDamageModifier_1 = Central.mission.curMission.EnemyDealDamageModifier_1;
         EnemySufferDamageModifier_1 = Central.mission.curMission.EnemySufferDamageModifier_1;
         noofenemy_D = 1;
         noofenemy_S = 1;
         if(!noOfEnemt)
         {
            noOfEnemt = 0;
         }
         switch(noOfEnemt)
         {
            case 3:
               noofenemy_D = 1;
               noofenemy_S = 1;
               break;
            case 2:
               noofenemy_D = EnemyDealDamageModifier_2;
               noofenemy_S = EnemySufferDamageModifier_2;
               break;
            case 1:
               noofenemy_D = EnemyDealDamageModifier_1;
               noofenemy_S = EnemySufferDamageModifier_1;
               break;
            default:
               noofenemy_D = 1;
               noofenemy_S = 1;
         }
         NormalDealDamageModifier = Math.round(Central.mission.curMission.NormalDealDamageModifier * noofenemy_D);
         NormalSufferDamageModifier = Math.round(Central.mission.curMission.NormalSufferDamageModifier * noofenemy_S);
         SuperDealDamageModifier = Math.round(Central.mission.curMission.SuperDealDamageModifier * noofenemy_D);
         SuperSufferDamageModifier = Math.round(Central.mission.curMission.SuperSufferDamageModifier * noofenemy_S);
         WeakenDealDamageModifier = Math.round(Central.mission.curMission.WeakenDealDamageModifier * noofenemy_D);
         WeakenSufferDamageModifier = Math.round(Central.mission.curMission.WeakenSufferDamageModifier * noofenemy_S);
         switch(TargetElenemtal)
         {
            case 1:
               EnemyData.updateData(DBCharacterData.LIGHTNING,SecondAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,NormalAttribute);
               EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
               EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,SecondAttribute);
               EnemyData.setElemental(bg);
               EnemyData.setElemental_Mode(TargetElenemtal);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
               if(bg == 1)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,NormalAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MaxAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,SecondAttribute);
                  EnemyData.setSufferDamageModifier(SuperSufferDamageModifier);
                  EnemyData.setDealDamageModifier(SuperDealDamageModifier);
               }
               else if(bg == 5)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
                  EnemyData.setSufferDamageModifier(WeakenSufferDamageModifier);
                  EnemyData.setDealDamageModifier(WeakenDealDamageModifier);
               }
               break;
            case 2:
               EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
               EnemyData.updateData(DBCharacterData.WATER,SecondAttribute);
               EnemyData.updateData(DBCharacterData.WIND,NormalAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
               EnemyData.setElemental(bg);
               EnemyData.setElemental_Mode(TargetElenemtal);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
               if(bg == 2)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,NormalAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MaxAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,SecondAttribute);
                  EnemyData.setSufferDamageModifier(SuperSufferDamageModifier);
                  EnemyData.setDealDamageModifier(SuperDealDamageModifier);
               }
               else if(bg == 1)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
                  EnemyData.setSufferDamageModifier(WeakenSufferDamageModifier);
                  EnemyData.setDealDamageModifier(WeakenDealDamageModifier);
               }
               break;
            case 3:
               EnemyData.updateData(DBCharacterData.LIGHTNING,NormalAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
               EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
               EnemyData.updateData(DBCharacterData.WIND,SecondAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
               EnemyData.setElemental(bg);
               EnemyData.setElemental_Mode(TargetElenemtal);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
               if(bg == 3)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MaxAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,NormalAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,NormalAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,NormalAttribute);
                  EnemyData.setSufferDamageModifier(SuperSufferDamageModifier);
                  EnemyData.setDealDamageModifier(SuperDealDamageModifier);
               }
               else if(bg == 4)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
                  EnemyData.setSufferDamageModifier(WeakenSufferDamageModifier);
                  EnemyData.setDealDamageModifier(WeakenDealDamageModifier);
               }
               break;
            case 4:
               EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,SecondAttribute);
               EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
               EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,NormalAttribute);
               EnemyData.setElemental(bg);
               EnemyData.setElemental_Mode(TargetElenemtal);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
               if(bg == 4)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,NormalAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MaxAttribute);
                  EnemyData.setSufferDamageModifier(SuperSufferDamageModifier);
                  EnemyData.setDealDamageModifier(SuperDealDamageModifier);
               }
               else if(bg == 2)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
                  EnemyData.setSufferDamageModifier(WeakenSufferDamageModifier);
                  EnemyData.setDealDamageModifier(WeakenDealDamageModifier);
               }
               break;
            case 5:
               EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
               EnemyData.updateData(DBCharacterData.WATER,NormalAttribute);
               EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,SecondAttribute);
               EnemyData.setElemental(bg);
               EnemyData.setElemental_Mode(TargetElenemtal);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
               if(bg == 5)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MaxAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,SecondAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,NormalAttribute);
                  EnemyData.setSufferDamageModifier(SuperSufferDamageModifier);
                  EnemyData.setDealDamageModifier(SuperDealDamageModifier);
               }
               else if(bg == 3)
               {
                  EnemyData.updateData(DBCharacterData.LIGHTNING,MinAttribute);
                  EnemyData.updateData(DBCharacterData.FIRE,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WATER,MinAttribute);
                  EnemyData.updateData(DBCharacterData.WIND,MinAttribute);
                  EnemyData.updateData(DBCharacterData.EARTH,MinAttribute);
                  EnemyData.setSufferDamageModifier(WeakenSufferDamageModifier);
                  EnemyData.setDealDamageModifier(WeakenDealDamageModifier);
               }
               break;
            default:
               EnemyData.updateData(DBCharacterData.LIGHTNING,NormalAttribute);
               EnemyData.updateData(DBCharacterData.FIRE,NormalAttribute);
               EnemyData.updateData(DBCharacterData.WATER,NormalAttribute);
               EnemyData.updateData(DBCharacterData.WIND,NormalAttribute);
               EnemyData.updateData(DBCharacterData.EARTH,NormalAttribute);
               EnemyData.setElemental(1);
               EnemyData.setElemental_Mode(1);
               EnemyData.setSufferDamageModifier(NormalSufferDamageModifier);
               EnemyData.setDealDamageModifier(NormalDealDamageModifier);
         }
      }
      
      public static function onBloodline(evt:Event) : void
      {
         var BloodlineId:uint = 0;
         var btn:MovieClip = null;
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         BloodlineId = int(String(evt.currentTarget.name).split("_")[1]);
         btn = MovieClip(evt.currentTarget);
         btn.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         if(Character(attacker).setPlayerCommand("bloodline",BloodlineId,btn))
         {
            onBattle();
            try
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + "Talent");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_SKILL_USED,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,"Talent");
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","onBloodline :: TRACKING - TRACK_PVP/TRACK_SKILL_USED");
            }
            sendCommand();
         }
      }
      
      public static function onSenjutsu(evt:Event) : void
      {
         var SenjutsuId:uint = 0;
         var btn:MovieClip = null;
         if(selectedPartySkillID != -1)
         {
            Main.showInfo(String(Central.main.langLib.get(1801)[0]));
            return;
         }
         SenjutsuId = 8;
         if(Central.main.senninModeBtn != evt.currentTarget)
         {
            SenjutsuId = int(String(evt.currentTarget.name).split("_")[1]);
         }
         btn = MovieClip(evt.currentTarget);
         btn.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         if(Character(attacker).setPlayerCommand("senjutsu",SenjutsuId,btn))
         {
            onBattle();
            try
            {
               if(Battle.type == TYPE_NETWORK)
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + "Senjutsu");
               }
               else
               {
                  Central.main.tracking.generalTrack(Central.main.tracking.TRACK_SKILL_USED,String(String(evt.currentTarget.name).split("_")[0]) + "_" + btn.skillData.id,"Senjutsu");
               }
            }
            catch(err:Error)
            {
               Out.error("Battle","onSenjutsu :: TRACKING - TRACK_PVP/TRACK_SKILL_USED");
            }
            sendCommand();
         }
      }
      
      public static function getTimeStamp() : uint
      {
         var now:Date = null;
         now = new Date();
         return now.getTime();
      }
      
      public static function GetOverHeadString(Effect:Object) : String
      {
         var OverHeadString:* = null;
         OverHeadString = "";
         switch(Effect.type)
         {
            case BattleData.EFFECT_DODGE_BONUS:
            case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
            case BattleData.EFFECT_PET_DODGE_BONUS:
               OverHeadString = Central.main.langLib.get(306);
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               OverHeadString = Central.main.langLib.get(292);
               break;
            case BattleData.EFFECT_REGENERATE_HP:
               OverHeadString = Central.main.langLib.get(490);
               break;
            case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
               OverHeadString = Central.main.langLib.get(329);
               break;
            case BattleData.EFFECT_STUN:
               OverHeadString = Central.main.langLib.get(281);
               break;
            case BattleData.EFFECT_REDUCE_AGILITY:
               OverHeadString = Central.main.langLib.get(2001)[0];
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
               OverHeadString = Central.main.langLib.get(2001)[1];
               break;
            case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
               OverHeadString = Central.main.langLib.get(2001)[1] + " Extra";
               break;
            case BattleData.EFFECT_SLEEP:
               OverHeadString = Central.main.langLib.get(280);
               break;
            case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
            case BattleData.EFFECT_FEAR_WEAKEN:
            case BattleData.EFFECT_PET_FEAR_WEAKEN:
               OverHeadString = Central.main.langLib.get(305);
               break;
            case BattleData.EFFECT_BUNDLE:
            case BattleData.SKILL_377:
               OverHeadString = Central.main.langLib.get(325);
               break;
            case BattleData.EFFECT_HEAL:
               OverHeadString = "";
               break;
            case BattleData.EFFECT_RESTORE_CP:
               OverHeadString = Central.main.langLib.get(350);
               break;
            case BattleData.EFFECT_COOLDOWN_REDUCTION:
               OverHeadString = Central.main.langLib.get(598);
               break;
            case BattleData.EFFECT_PET_BURN:
               OverHeadString = Central.main.langLib.get(288) + " (" + String(Effect.amount) + "%)";
               break;
            case BattleData.EFFECT_BLIND:
            case BattleData.EFFECT_ALL_CP_BLIND:
               OverHeadString = Central.main.langLib.get(287);
               break;
            case BattleData.EFFECT_DODGE_REDUCTION:
               OverHeadString = String(Central.main.langLib.get(308)).replace("[valamt]",Math.round(Effect.amount).toString() + "%");
               break;
            case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
               OverHeadString = Central.main.langLib.get(292);
               break;
            case BattleData.EFFECT_HAMSTRING:
               OverHeadString = Central.main.langLib.get(688);
               break;
            case BattleData.EFFECT_COLLIDING_WAVE:
               OverHeadString = Central.main.langLib.get(619);
               break;
            case BattleData.EFFECT_POISON:
               OverHeadString = Central.main.langLib.get(321);
               break;
            case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
            case BattleData.EFFECT_EXCITATION_CP:
            case BattleData.EFFECT_EXCITATION_CHARGE:
               OverHeadString = Central.main.langLib.get(613);
               break;
            case BattleData.EFFECT_INTERNAL_INJURY:
               OverHeadString = Central.main.langLib.get(648);
               break;
            case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
               OverHeadString = Central.main.langLib.get(648);
               break;
            default:
               OverHeadString = "";
         }
         return OverHeadString;
      }
      
      public static function get processor() : BattleProcessor
      {
         return BattleProcessor.getInstance();
      }
      
      public static function destroyProcessor() : void
      {
         BattleProcessor.destroyInstance();
      }
      
      public static function reverseShowChaosChecking() : void
      {
         BattleProcessor.showOHN_chaos = !BattleProcessor.showOHN_chaos;
      }
      
      public static function getShowChaos() : Boolean
      {
         return BattleProcessor.showOHN_chaos;
      }
      
      private static function godModeHackCheck() : Boolean
      {
         var ap:int = 0;
         ap = Central.main.getMainChar().getData(DBCharacterData.WIND) + Central.main.getMainChar().getData(DBCharacterData.FIRE) + Central.main.getMainChar().getData(DBCharacterData.LIGHTNING) + Central.main.getMainChar().getData(DBCharacterData.WATER) + Central.main.getMainChar().getData(DBCharacterData.EARTH);
         Out.debug("battle","godModeHackCheck :: ap point >> " + ap);
         Out.debug("battle","godModeHackCheck :: char lv >> " + Central.main.getMainChar().getLevel());
         if(ap < 0 || ap > Central.main.getMainChar().getLevel())
         {
            return true;
         }
         return false;
      }
      
      private static function trackingResponse(obj:Object = null) : void
      {
      }
      
      public static function setRematchPanelOnCancelReadyResponse() : void
      {
         if(!bWaitingToStartRematch)
         {
            return;
         }
         if(battleMc == null)
         {
            return;
         }
         disableButtonsOnRematchTimerCompleted();
         pvpWinLossPanelSomeoneLeft();
         if(battleMc["lbl_rematch_title"])
         {
            battleMc["lbl_rematch_title"].text = getPvpWinLossPanelMessage();
         }
      }
      
      public static function cancelReadyResponse() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function onPlayerLeaveQuickMatch() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function onPlayerLeaveTournament() : void
      {
         setRematchPanelOnCancelReadyResponse();
      }
      
      public static function callMcToReload() : void
      {
         battleMc.cancelRematchCountdown();
         battleMc.gotoAndStop("init");
      }
      
      public static function deleteBattleLikeFinish() : void
      {
         var i:uint = 0;
         var enemy:* = undefined;
         var teamate:* = undefined;
         var pet:* = undefined;
         battleMc.removeChild(battleMc["atbBar"]);
         battleMc.removeChild(battleMc["playerMc_1"]);
         battleMc.removeChild(battleMc["playerPetMc"]);
         battleMc.removeChild(battleMc["partyMc_1"]);
         battleMc.removeChild(battleMc["partyPetMc1"]);
         battleMc.removeChild(battleMc["partyMc_2"]);
         battleMc.removeChild(battleMc["partyPetMc2"]);
         battleMc.removeChild(battleMc["enemyMc_1"]);
         battleMc.removeChild(battleMc["enemyPetMc_1"]);
         battleMc.removeChild(battleMc["enemyMc_2"]);
         battleMc.removeChild(battleMc["enemyPetMc_2"]);
         battleMc.removeChild(battleMc["enemyMc_3"]);
         battleMc.removeChild(battleMc["enemyPetMc_3"]);
         try
         {
            if(battleMc != null)
            {
               battleMc.gotoAndStop(Timeline.IDLE);
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.getMainChar().resetBattleData();
            Main.getMainChar().removeParent();
            Main.getMainChar().setCharMc(null);
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            if(enemyArr != null)
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  enemy = enemyArr[i];
                  enemy.resetBattleData();
                  enemy.removeParent();
                  enemy.setCharMc(null);
               }
            }
            if(partyArr)
            {
               for(i = 0; i < partyArr.length; i++)
               {
                  teamate = partyArr[i];
                  teamate.resetBattleData();
                  teamate.removeParent();
                  teamate.setCharMc(null);
               }
            }
            if(petArr)
            {
               for(i = 0; i < petArr.length; i++)
               {
                  pet = petArr[i];
                  pet.resetBattleData();
                  pet.removeParent();
                  pet.setCharMc(null);
                  pet.resetSkillCooldown();
               }
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 3 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            Main.mapMenu.hideChatInput();
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 5 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         try
         {
            GF.removeAllChild(battleMc["displayHolder"]);
            GF.removeAllChild(battleMc["specialHolder"]);
            attacker = null;
            defender = null;
            selectedTarget = null;
            consumablesUsed = 0;
            rematchTimes = 0;
            battleResult = 0;
            repGain = 0;
            bossId = "";
            use_seal_enemy = false;
            seal_enemy = false;
            spy_enemy = false;
            Central.main.battleRuleArr = [];
            Central.main.actionChecker = true;
            isPartyControllable = false;
            pvpSyncLogSaved = false;
            pvpLogTimeSaved = false;
            if(Central.main.PvpPlayerPost == "quick")
            {
               Central.main.PvpPlayerPlace = "quick";
            }
            else if(Central.main.PvpPlayerPost == "tournament")
            {
               Central.main.PvpPlayerPlace = "tournament";
            }
         }
         catch(e:Error)
         {
            Out.error("Battle","battleFinish :: Step 4.2 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
      }
      
      public static function disableButtonsOnRematchTimerCompleted() : void
      {
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = true;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["lbl_rematch_title"].visible = true;
      }
      
      public static function disableButtonsNoExitOnRematchTimerCompleted() : void
      {
         battleMc["okBtn"].alpha = 0.5;
         battleMc["okBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["okBtn"].enabled = false;
         battleMc["okBtn"].removeEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].alpha = 0.5;
         battleMc["noBtn"].filters = [CreateFilter.getSaturationFilter(0.5)];
         battleMc["noBtn"].enabled = false;
         battleMc["noBtn"].removeEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = false;
         battleMc["backBtn"].removeEventListener(MouseEvent.CLICK,onBackBtn);
         battleMc["lbl_rematch_title"].visible = true;
      }
      
      public static function enableButtonsOnRematchRequest() : void
      {
         battleMc["signalMc"].gotoAndStop("show");
         battleMc["signalMc"].visible = true;
         battleMc["okBtn"].visible = true;
         battleMc["okBtn"].alpha = 1;
         battleMc["okBtn"].addEventListener(MouseEvent.CLICK,onOkBtn);
         battleMc["noBtn"].visible = true;
         battleMc["noBtn"].alpha = 1;
         battleMc["noBtn"].addEventListener(MouseEvent.CLICK,onNoBtn);
         battleMc["backBtn"].visible = false;
         battleMc["backBtn"].addEventListener(MouseEvent.CLICK,onBackBtn);
      }
      
      public static function getPvpWinLossPanelStatus() : String
      {
         if(bRematchAnyPlayerOpponentLeft || bRematchTimedOut)
         {
            return "allow_go_away";
         }
         if(bRematchPressedOk)
         {
            return "confirmed";
         }
         return "unstated";
      }
      
      public static function getPvpWinLossPanelMessage() : String
      {
         if(Battle.pvpCurrencyGainDisplay && Battle.myCurrencyGain == 0)
         {
            Central.main.getMainChar().pvpPlayerDisconnect();
            return Central.main.langLib.titleTxt(TitleData.DISCONNECT);
         }
         if(bRematchAnyPlayerOpponentLeft)
         {
            return Central.main.langLib.get(1840)[3];
         }
         if(bRematchTimedOut)
         {
            return Central.main.langLib.get(1840)[4];
         }
         if(bRematchPressedOk)
         {
            return Central.main.langLib.get(1840)[0];
         }
         if(bRematchOnePlayerWantRematch)
         {
            return Central.main.langLib.get(1840)[1];
         }
         return "";
      }
      
      public static function pvpWinLossPanelSomeoneWantRematch() : void
      {
         bRematchOnePlayerWantRematch = true;
      }
      
      public static function pvpWinLossPanelSomeoneLeft() : void
      {
         bRematchAnyPlayerOpponentLeft = true;
      }
      
      public static function pvpWinLossPanelTimedOut() : void
      {
         bRematchTimedOut = true;
      }
      
      public static function pvpWinLossPanelPressedOk() : void
      {
         bRematchPressedOk = true;
      }
      
      public static function getBattleBackground() : MovieClip
      {
         if(battleBg != null)
         {
            return battleBg;
         }
         return battleBgDefault;
      }
      
      public static function enableActionBarAllButtons() : *
      {
         if(battleMc == null || battleMc["actionBar"] == null)
         {
            return;
         }
         battleMc["actionBar"].enableAllButtons();
      }
      
      public static function processSkipBattleTurn() : void
      {
         var dataObj:Object = null;
         Out.debug("battle","processSkipBattleTurn");
         dataObj = {};
         resetATBPosition();
         dataObj.event = "info";
         dataObj.charId = String(Main.getMainChar().getData("character_id"));
         dataObj.state = "action_finish";
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function syncBackground(backgroundNum:String) : *
      {
         var backgrounds:* = undefined;
         Out.debug("","syncBackground num = " + backgroundNum);
         backgrounds = [];
         backgrounds.push("swf/panels/arena_bg.swf");
         Main.loadSwf(backgrounds,loadBackgroundComplete,{"backgroundNumber":backgroundNum});
      }
      
      public static function loadBackgroundComplete(swfObj:Object, parameters:Object) : void
      {
         var background:MovieClip = null;
         Out.debug("","function loadBackgroundComplete");
         Main.showAmfLoading();
         background = GF.getAsset(swfObj["swf/panels/arena_bg.swf"],"background" + parameters.backgroundNumber);
         Main.hideAmfLoading();
         if(battleBg == null)
         {
            changeBg(background);
         }
         else
         {
            Out.debug("","failure load background, already loaded background");
         }
      }
      
      private function onClickReturnPVE(evt:MouseEvent) : void
      {
      }
   }
}
