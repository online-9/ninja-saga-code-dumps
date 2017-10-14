package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import ninjasaga.data.Timeline;
   import ninjasaga.Central;
   import flash.display.Sprite;
   import ninjasaga.data.Data;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.DBCharacterData;
   import com.utils.Out;
   import com.utils.GF;
   import ninjasaga.data.RankData;
   import flash.events.TimerEvent;
   
   public class BattleDoc extends MovieClip
   {
       
      
      private const DEBUG_GOD_MODE_AP_ALLOWED:Boolean = false;
      
      public var PvpCloseUpObj:Object;
      
      private var rematchTimeLimit:int = 0;
      
      private var rematchTimer:Timer;
      
      private var rematchRepeat:int = 0;
      
      public function BattleDoc()
      {
         PvpCloseUpObj = {};
         super();
      }
      
      public function gotoIdle() : void
      {
         stage.focus = null;
         this.gotoAndStop(Timeline.IDLE);
      }
      
      public function gotoBattleStart() : void
      {
         this.gotoAndPlay(Timeline.START);
      }
      
      public function gotoBattle() : void
      {
         this.gotoAndStop(Timeline.BATTLE);
      }
      
      public function gotoWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndPlay(Timeline.WIN);
      }
      
      public function gotoPvPWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win");
      }
      
      public function gotoPvPWinQuick() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win_2015a");
      }
      
      public function gotoPveWin() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pve_win");
      }
      
      public function gotoPvPWinTournament() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_win_2015a");
      }
      
      public function gotoPvPLose() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose");
      }
      
      public function gotoPvPLoseQuick() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose_2015a");
      }
      
      public function gotoPvPLoseTournament() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("pvp_lose_2015a");
      }
      
      public function gotoClanResult() : void
      {
         this.resetCharacterDepth();
         this.gotoAndStop("clan_result");
      }
      
      private function onClanResult() : void
      {
         Central.battle.onClanResult();
      }
      
      public function resetCharacterDepth() : void
      {
         var depth:int = 0;
         this.setChildIndex(this["bgHolder"],depth);
         this.setChildIndex(this["partyMc_2"],depth + 6);
         this.setChildIndex(this["playerMc_1"],depth + 4);
         this.setChildIndex(this["partyMc_1"],depth + 2);
         this.setChildIndex(this["partyPetMc2"],depth + 5);
         this.setChildIndex(this["playerPetMc"],depth + 3);
         this.setChildIndex(this["partyPetMc1"],depth + 1);
         this.setChildIndex(this["enemyMc_3"],depth + 12);
         this.setChildIndex(this["enemyMc_1"],depth + 10);
         this.setChildIndex(this["enemyMc_2"],depth + 8);
         this.setChildIndex(this["enemyPetMc_3"],depth + 11);
         this.setChildIndex(this["enemyPetMc_1"],depth + 9);
         this.setChildIndex(this["enemyPetMc_2"],depth + 7);
      }
      
      private function onInit() : void
      {
         var petSwf:MovieClip = null;
         var swf:MovieClip = null;
         var i:uint = 0;
         var enemyArr:Array = null;
         var partyNpc:Array = null;
         var partyMembers:Array = null;
         var singleBattle:Boolean = false;
         var member:* = undefined;
         var enemy:* = undefined;
         var aiChars:Array = null;
         var char:* = undefined;
         var charId:String = null;
         var teamA:Array = null;
         var teamB:Array = null;
         var selfTeam:Array = null;
         var opponentsTeam:Array = null;
         var teamAPost:int = 0;
         var teamBPost:int = 0;
         var opponents:Array = null;
         var opponent:* = undefined;
         var opponentId:String = null;
         var MAX_PARTY_MENBER:int = 0;
         var tmpInt:int = 0;
         var tmpMC:MovieClip = null;
         var clickMask:Sprite = null;
         var team:String = null;
         var post:String = null;
         var setMainCharMc:String = null;
         var setMainPetMc:String = null;
         var teamPostMc:String = null;
         var teamPetPostMc:String = null;
         var charTeam:String = null;
         var havePlayer:Boolean = false;
         this.stop();
         Central.battle.initBattle(this);
         i = 0;
         var j:int = 0;
         var mainChar:* = Central.main.getMainChar();
         mainChar.isDead = false;
         mainChar.playStandby();
         if(this.onInitIsMainCharacterHack(mainChar) && !DEBUG_GOD_MODE_AP_ALLOWED)
         {
            Central.main.onError("297","");
            return;
         }
         this["detail_box_" + 1].visible = false;
         this["detail_box_" + 2].visible = false;
         this["detail_box_" + 3].visible = false;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            swf = mainChar.getSwf();
            swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
            swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
            this["playerMc_1"]["charMc"].addChild(swf);
            mainChar.setCharMc(this["playerMc_1"]["charMc"]);
            mainChar.updateBattleFrame();
            if(mainChar.pet)
            {
               trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
               petSwf = mainChar.pet.getSwf();
               petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
               petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
               this["playerPetMc"]["charMc"].addChild(petSwf);
               mainChar.pet.playStandby();
               mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
               mainChar.pet.updateBattleFrame();
               Central.battle.addPet(mainChar.pet);
            }
            else
            {
               this["playerPetMc"].visible = false;
            }
            for(i = 1; i <= 2; i++)
            {
               this["partyMc_" + i].visible = false;
               this["partyPetMc" + i].visible = false;
            }
            for(i = 1; i <= 3; i++)
            {
               this["enemyPetMc_" + String(i)].visible = false;
            }
         }
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            partyNpc = Central.main.getPartyNpc();
            partyMembers = Central.main.partyMembers;
            singleBattle = false;
            if(Central.mission.curMission)
            {
               if(Central.mission.curMission.singleBattle == true)
               {
                  singleBattle = true;
               }
            }
            if(partyNpc)
            {
               for(i = 0; i < partyNpc.length; i++)
               {
                  if(!partyNpc[i].isDead)
                  {
                     member = partyNpc[i];
                     if(this.onInitIsPartyCharacterHack(member) && !DEBUG_GOD_MODE_AP_ALLOWED)
                     {
                        Central.main.onError("2979","");
                        return;
                     }
                  }
               }
            }
            j = 0;
            if(partyNpc && Central.battle.subType != BattleData.SUBTYPE_CLAN && singleBattle == false)
            {
               for(i = 0; i < partyNpc.length; i++)
               {
                  if(!partyNpc[i].isDead)
                  {
                     member = partyNpc[i];
                     if(Central.mission.curMission == null)
                     {
                        member.restoreOriginalStatus();
                        member.isDead = false;
                     }
                     member.playStandby();
                     swf = member.getSwf();
                     swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     this["partyMc_" + (j + 1)]["charMc"].addChild(swf);
                     this["partyMc_" + (j + 1)].visible = true;
                     this["partyMc_" + (j + 1)].char = member;
                     member.setCharMc(this["partyMc_" + (j + 1)]["charMc"]);
                     Central.battle.addParty(member);
                     if(member.pet)
                     {
                        petSwf = member.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        this["partyPetMc" + String(j + 1)]["charMc"].addChild(petSwf);
                        this["partyPetMc" + String(j + 1)].visible = true;
                        member.pet.playStandby();
                        member.pet.restoreOriginalStatus();
                        member.pet.setCharMc(this["partyPetMc" + String(j + 1)]["charMc"]);
                        member.pet.updateBattleFrame();
                        Central.battle.addPet(member.pet);
                     }
                     else
                     {
                        this["partyPetMc" + String(j + 1)].visible = false;
                     }
                     j++;
                  }
               }
            }
            if(partyMembers != null)
            {
               for(i = 0; i < partyMembers.length; i++)
               {
                  if(!partyMembers[i].isDead)
                  {
                     member = partyMembers[i];
                     if(Data.LEVEL_HACK_SKIP.indexOf(Central.mission.curMissionID) < 0)
                     {
                        if(this.isLevelHack(member))
                        {
                           Central.main.onError("2978","");
                           return;
                        }
                     }
                     if(Central.mission.curMission == null)
                     {
                        member.restoreOriginalStatus();
                        member.isDead = false;
                     }
                     member.playStandby();
                     swf = member.getSwf();
                     swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     this["partyMc_" + (j + 1)]["charMc"].addChild(swf);
                     this["partyMc_" + (j + 1)].visible = true;
                     this["partyMc_" + (j + 1)].char = member;
                     member.setCharMc(this["partyMc_" + (j + 1)]["charMc"]);
                     Central.battle.addParty(member);
                     if(member.pet)
                     {
                        petSwf = member.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        this["partyPetMc" + String(j + 1)]["charMc"].addChild(petSwf);
                        this["partyPetMc" + String(j + 1)].visible = true;
                        member.pet.playStandby();
                        member.pet.restoreOriginalStatus();
                        member.pet.setCharMc(this["partyPetMc" + String(j + 1)]["charMc"]);
                        member.pet.updateBattleFrame();
                        Central.battle.addPet(member.pet);
                     }
                     else
                     {
                        this["partyPetMc" + String(j + 1)].visible = false;
                     }
                     j++;
                  }
               }
            }
            enemyArr = Central.main.getEnemy();
            if(enemyArr == null)
            {
               aiChars = Central.main.getAIChars();
               for(i = 0; i < aiChars.length; i++)
               {
                  char = aiChars[i];
                  char.restoreOriginalStatus();
                  char.isDead = false;
                  char.playStandby();
                  swf = char.getSwf();
                  swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                  swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                  this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = char;
                  char.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(char);
                  if(char.pet)
                  {
                     petSwf = char.pet.getSwf();
                     petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                     petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                     this["enemyPetMc_" + String(i + 1)]["charMc"].addChild(petSwf);
                     this["enemyPetMc_" + String(i + 1)].visible = true;
                     char.pet.playStandby();
                     char.pet.restoreOriginalStatus();
                     char.pet.setCharMc(this["enemyPetMc_" + String(i + 1)]["charMc"]);
                     char.pet.updateBattleFrame();
                     char.pet.side = BattleData.SIDE_HOSTILE;
                     Central.battle.addPet(char.pet);
                  }
                  else
                  {
                     this["enemyPetMc_" + String(i + 1)].visible = false;
                  }
               }
               for(i = 3; i > aiChars.length; i--)
               {
                  this["enemyMc_" + i].visible = false;
               }
            }
            else
            {
               for(i = 0; i < enemyArr.length; i++)
               {
                  enemy = Central.main.createEnemy(enemyArr[i]);
                  enemy.isDead = false;
                  enemy.playStandby();
                  swf = enemy.getSwf();
                  swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                  swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                  this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = enemy;
                  enemy.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(enemy);
               }
               for(i = 3; i > enemyArr.length; i--)
               {
                  this["enemyMc_" + i].visible = false;
               }
            }
         }
         if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            charId = Central.main.getMainChar().getData(DBCharacterData.ID);
            teamA = Central.main.PvpTeamA;
            teamB = Central.main.PvpTeamB;
            teamAPost = 0;
            teamBPost = 0;
            opponents = Central.main.battleChars;
            if(Central.main.PvpPlayerPlace == "quick")
            {
               for(i = 1; i <= 2; i++)
               {
                  this["partyMc_" + i].charID = null;
                  this["partyMc_" + i].visible = false;
                  this["partyPetMc" + i].visible = false;
               }
               for(i = 1; i <= 3; i++)
               {
                  this["enemyPetMc_" + String(i)].visible = false;
               }
               for(i = 1; i <= 3; i++)
               {
                  try
                  {
                     this["enemyMc_" + i].charID = null;
                     this["enemyMc_" + i].visible = false;
                  }
                  catch(err:Error)
                  {
                     Out.error("BattleDoc.as >> "," no >> enemyMc_ " + i);
                  }
               }
            }
            else if(Central.main.PvpPlayerPlace == "tournament")
            {
               for(i = 1; i <= 2; i++)
               {
                  this["partyMc_" + i].charID = null;
                  this["partyMc_" + i].visible = false;
                  this["partyPetMc" + i].visible = false;
               }
               for(i = 1; i <= 3; i++)
               {
                  this["enemyPetMc_" + String(i)].visible = false;
               }
               for(i = 1; i <= 3; i++)
               {
                  try
                  {
                     this["enemyMc_" + i].charID = null;
                     this["enemyMc_" + i].visible = false;
                  }
                  catch(err:Error)
                  {
                     Out.error("BattleDoc.as >> "," no >> enemyMc_ " + i);
                  }
               }
            }
            else if(Central.main.PvpPlayerPlace == "private")
            {
               this["playerPetMc"].visible = false;
               this["partyPetMc1"].visible = false;
               this["partyPetMc2"].visible = false;
               this["enemyPetMc_1"].visible = false;
               this["enemyPetMc_2"].visible = false;
               this["enemyPetMc_3"].visible = false;
               this["partyMc_1"].charID = null;
               this["partyMc_2"].charID = null;
               this["enemyMc_2"].charID = null;
               this["enemyMc_3"].charID = null;
               switch(Central.main.PvpPVMode)
               {
                  case 1:
                     this["partyMc_1"].visible = false;
                     this["partyMc_2"].visible = false;
                     this["enemyMc_2"].visible = false;
                     this["enemyMc_3"].visible = false;
                     break;
                  case 2:
                     this["partyMc_2"].visible = false;
                     this["enemyMc_3"].visible = false;
                     break;
                  case 3:
               }
            }
            else if(Central.main.PvpPlayerPlace == "PVE")
            {
               this["playerPetMc"].visible = false;
               this["partyPetMc1"].visible = false;
               this["partyPetMc2"].visible = false;
               this["enemyPetMc_1"].visible = false;
               this["enemyPetMc_2"].visible = false;
               this["enemyPetMc_3"].visible = false;
               this["partyMc_1"].charID = null;
               this["partyMc_2"].charID = null;
               this["enemyMc_2"].charID = null;
               this["enemyMc_3"].charID = null;
               enemyArr = Central.main.getEnemy();
               for(i = 0; i < enemyArr.length; i++)
               {
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
                  enemyArr[i].PvEID = enemyArr[i].id.replace("enemy","") + tmpInt;
                  enemy = Central.main.createEnemy(enemyArr[i]);
                  trace("enemy.getCharacterId()" + enemy.getCharacterId());
                  trace("enemy.PvEID()" + enemyArr[i].name);
                  enemy.isDead = false;
                  enemy.playStandby();
                  swf = enemy.getSwf();
                  swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                  swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                  if(enemyArr[i].limb && enemyArr[i].limb > 1)
                  {
                     if(i == 0)
                     {
                        this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                     }
                     else
                     {
                        tmpMC = new MovieClip();
                        clickMask = new Sprite();
                        tmpMC.addChild(clickMask);
                        clickMask.graphics.beginFill(255);
                        clickMask.graphics.drawRect(-140,-80,200,100);
                        clickMask.graphics.endFill();
                        clickMask.alpha = 0;
                        this["enemyMc_" + (i + 1)]["charMc"].addChild(tmpMC);
                        this.setChildIndex(this["enemyMc_" + (i + 1)],13);
                     }
                  }
                  else
                  {
                     this["enemyMc_" + (i + 1)]["charMc"].addChild(swf);
                  }
                  this["enemyMc_" + (i + 1)].visible = true;
                  this["enemyMc_" + (i + 1)].char = enemy;
                  enemy.setCharMc(this["enemyMc_" + (i + 1)]["charMc"]);
                  Central.battle.addEnemy(enemy);
               }
               for(i = 3; i > enemyArr.length; i--)
               {
                  this["enemyMc_" + i].visible = false;
               }
               MAX_PARTY_MENBER = 2;
               for(i = 0; i < MAX_PARTY_MENBER; i++)
               {
                  if(i >= Central.main.PvpTeamA.length - 1)
                  {
                     this["partyMc_" + (i + 1)].visible = false;
                  }
               }
            }
            if(Central.main.PvpPlayerPost == "quick")
            {
               Central.main.PvpMainCharMc = "playerMc_1";
               swf = mainChar.getSwf();
               swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
               swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
               if(this["playerMc_1"]["charMc"].numChildren == 0)
               {
                  this["playerMc_1"]["charMc"].addChild(swf);
               }
               mainChar.setCharMc(this["playerMc_1"]["charMc"]);
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
                  petSwf = mainChar.pet.getSwf();
                  petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                  petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                  if(this["playerPetMc"]["charMc"].numChildren == 0)
                  {
                     this["playerPetMc"]["charMc"].addChild(petSwf);
                     this["playerPetMc"]["charMc"].char = mainChar.pet;
                  }
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  this["playerPetMc"].visible = false;
               }
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               for(i = 0; i < opponents.length; i++)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = opponent.getSwf();
                  if(selfTeam.indexOf(opponentId) >= 0)
                  {
                     teamAPost++;
                     swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(this["partyMc_" + teamAPost]["charMc"].numChildren == 0)
                     {
                        this["partyMc_" + teamAPost]["charMc"].addChild(swf);
                     }
                     this["partyMc_" + teamAPost].charID = opponentId;
                     this["partyMc_" + teamAPost].visible = true;
                     this["partyMc_" + teamAPost].char = opponent;
                     opponent.setCharMc(this["partyMc_" + teamAPost]["charMc"]);
                     Central.battle.addParty(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        if(this["partyPetMc" + teamAPost]["charMc"].numChildren == 0)
                        {
                           this["partyPetMc" + teamAPost]["charMc"].addChild(petSwf);
                           this["partyPetMc" + teamAPost]["charMc"].char = opponent.pet;
                        }
                        this["partyPetMc" + teamAPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["partyPetMc" + teamAPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  else if(opponentsTeam.indexOf(opponentId) >= 0)
                  {
                     teamBPost++;
                     swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(this["enemyMc_" + teamBPost]["charMc"].numChildren == 0)
                     {
                        this["enemyMc_" + teamBPost]["charMc"].addChild(swf);
                     }
                     this["enemyMc_" + teamBPost].charID = opponentId;
                     this["enemyMc_" + teamBPost].visible = true;
                     this["enemyMc_" + teamBPost].char = opponent;
                     opponent.setCharMc(this["enemyMc_" + teamBPost]["charMc"]);
                     Central.battle.addEnemy(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        if(this["enemyPetMc_" + teamBPost]["charMc"].numChildren == 0)
                        {
                           this["enemyPetMc_" + teamBPost]["charMc"].addChild(petSwf);
                        }
                        this["enemyPetMc_" + teamBPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["enemyPetMc_" + teamBPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
               }
            }
            else if(Central.main.PvpPlayerPost == "tournament")
            {
               Central.main.PvpMainCharMc = "playerMc_1";
               swf = mainChar.getSwf();
               swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
               swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
               if(this["playerMc_1"]["charMc"].numChildren == 0)
               {
                  this["playerMc_1"]["charMc"].addChild(swf);
               }
               mainChar.setCharMc(this["playerMc_1"]["charMc"]);
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>mainChar.pet is not null");
                  petSwf = mainChar.pet.getSwf();
                  petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                  petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                  if(this["playerPetMc"]["charMc"].numChildren == 0)
                  {
                     this["playerPetMc"]["charMc"].addChild(petSwf);
                     this["playerPetMc"]["charMc"].char = mainChar.pet;
                  }
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this["playerPetMc"]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  this["playerPetMc"].visible = false;
               }
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               for(i = 0; i < opponents.length; i++)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = opponent.getSwf();
                  if(selfTeam.indexOf(opponentId) >= 0)
                  {
                     teamAPost++;
                     swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(this["partyMc_" + teamAPost]["charMc"].numChildren == 0)
                     {
                        this["partyMc_" + teamAPost]["charMc"].addChild(swf);
                     }
                     this["partyMc_" + teamAPost].charID = opponentId;
                     this["partyMc_" + teamAPost].visible = true;
                     this["partyMc_" + teamAPost].char = opponent;
                     opponent.setCharMc(this["partyMc_" + teamAPost]["charMc"]);
                     Central.battle.addParty(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        if(this["partyPetMc" + teamAPost]["charMc"].numChildren == 0)
                        {
                           this["partyPetMc" + teamAPost]["charMc"].addChild(petSwf);
                           this["partyPetMc" + teamAPost]["charMc"].char = opponent.pet;
                        }
                        this["partyPetMc" + teamAPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["partyPetMc" + teamAPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
                  else if(opponentsTeam.indexOf(opponentId) >= 0)
                  {
                     teamBPost++;
                     swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(this["enemyMc_" + teamBPost]["charMc"].numChildren == 0)
                     {
                        this["enemyMc_" + teamBPost]["charMc"].addChild(swf);
                     }
                     this["enemyMc_" + teamBPost].charID = opponentId;
                     this["enemyMc_" + teamBPost].visible = true;
                     this["enemyMc_" + teamBPost].char = opponent;
                     opponent.setCharMc(this["enemyMc_" + teamBPost]["charMc"]);
                     Central.battle.addEnemy(opponent);
                     if(opponent.pet)
                     {
                        petSwf = opponent.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        if(this["enemyPetMc_" + teamBPost]["charMc"].numChildren == 0)
                        {
                           this["enemyPetMc_" + teamBPost]["charMc"].addChild(petSwf);
                        }
                        this["enemyPetMc_" + teamBPost].visible = true;
                        opponent.pet.playStandby();
                        opponent.pet.restoreOriginalStatus();
                        opponent.pet.setCharMc(this["enemyPetMc_" + teamBPost]["charMc"]);
                        opponent.pet.updateBattleFrame();
                        opponent.pet.side = BattleData.SIDE_HOSTILE;
                        Central.battle.addPet(opponent.pet);
                     }
                  }
               }
            }
            else if(Central.main.PvpPlayerPlace == "private" || Central.main.PvpPlayerPlace == "PVE")
            {
               if(teamA.indexOf(charId) >= 0)
               {
                  selfTeam = teamA;
                  opponentsTeam = teamB;
               }
               else if(teamB.indexOf(charId) >= 0)
               {
                  selfTeam = teamB;
                  opponentsTeam = teamA;
               }
               swf = mainChar.getSwf();
               for(j = 0; j < Central.main.PvpPVMode; j++)
               {
                  if(selfTeam[j] == charId)
                  {
                     team = "A";
                     post = String(j);
                     swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(mainChar.pet)
                     {
                        petSwf = mainChar.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                     }
                     switch(post)
                     {
                        case "0":
                           setMainCharMc = "playerMc_1";
                           setMainPetMc = "playerPetMc";
                           break;
                        case "1":
                           setMainCharMc = "partyMc_1";
                           setMainPetMc = "partyPetMc1";
                           break;
                        case "2":
                           setMainCharMc = "partyMc_2";
                           setMainPetMc = "partyPetMc2";
                     }
                  }
                  if(opponentsTeam[j] == charId)
                  {
                     team = "B";
                     post = String(j);
                     swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                     swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                     if(mainChar.pet)
                     {
                        petSwf = mainChar.pet.getSwf();
                        petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                        petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                     }
                     switch(post)
                     {
                        case "0":
                           setMainCharMc = "enemyMc_1";
                           setMainPetMc = "enemyPetMc_1";
                           break;
                        case "1":
                           setMainCharMc = "enemyMc_2";
                           setMainPetMc = "enemyPetMc_2";
                           break;
                        case "2":
                           setMainCharMc = "enemyMc_3";
                           setMainPetMc = "enemyPetMc_3";
                     }
                  }
               }
               Out.debug("set setMainCharMc :: ","setMainCharMc >> " + setMainCharMc);
               Out.debug("set setMainCharMc :: ","setMainPetMc >> " + setMainPetMc);
               this[setMainCharMc].visible = true;
               this[setMainCharMc]["charMc"].addChild(swf);
               this.PvpCloseUpObj[setMainCharMc] = mainChar;
               mainChar.setCharMc(this[setMainCharMc]["charMc"]);
               Central.main.PvpMainCharMc = setMainCharMc;
               mainChar.updateBattleFrame();
               if(mainChar.pet)
               {
                  this[setMainPetMc].visible = true;
                  this[setMainPetMc]["charMc"].addChild(petSwf);
                  mainChar.pet.playStandby();
                  mainChar.pet.setCharMc(this[setMainPetMc]["charMc"]);
                  mainChar.pet.updateBattleFrame();
                  Central.battle.addPet(mainChar.pet);
               }
               else
               {
                  Out.debug("mainChar.pet :: ","oHHHHn oooo >> ");
                  this[setMainPetMc].visible = false;
               }
               for(i = 0; i < opponents.length; i++)
               {
                  opponent = opponents[i];
                  opponentId = opponent.getData(DBCharacterData.ID);
                  opponent.restoreOriginalStatus();
                  opponent.isDead = false;
                  opponent.playStandby();
                  swf = new MovieClip();
                  swf = opponent.getSwf();
                  if(opponent.pet)
                  {
                     petSwf = opponent.pet.getSwf();
                  }
                  for(j = 0; j < Central.main.PvpPVMode; j++)
                  {
                     havePlayer = false;
                     if(selfTeam[j] == opponentId)
                     {
                        teamAPost = j;
                        swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
                        swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                        charTeam = "A";
                        if(opponent.pet)
                        {
                           petSwf.scaleX = petSwf.scaleX * -Data.BATTLE_CHAR_SCALE;
                           petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        }
                        switch(teamAPost)
                        {
                           case 0:
                              teamPostMc = "playerMc_1";
                              teamPetPostMc = "playerPetMc";
                              havePlayer = true;
                              break;
                           case 1:
                              teamPostMc = "partyMc_1";
                              teamPetPostMc = "partyPetMc1";
                              havePlayer = true;
                              break;
                           case 2:
                              teamPostMc = "partyMc_2";
                              teamPetPostMc = "partyPetMc2";
                              havePlayer = true;
                        }
                     }
                     if(opponentsTeam[j] == opponentId)
                     {
                        teamBPost = j;
                        swf.scaleX = swf.scaleX * Data.BATTLE_CHAR_SCALE;
                        swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
                        charTeam = "B";
                        if(opponent.pet)
                        {
                           petSwf.scaleX = petSwf.scaleX * Data.BATTLE_CHAR_SCALE;
                           petSwf.scaleY = petSwf.scaleY * Data.BATTLE_CHAR_SCALE;
                        }
                        switch(teamBPost)
                        {
                           case 0:
                              teamPostMc = "enemyMc_1";
                              teamPetPostMc = "enemyPetMc_1";
                              havePlayer = true;
                              break;
                           case 1:
                              teamPostMc = "enemyMc_2";
                              teamPetPostMc = "enemyPetMc_2";
                              havePlayer = true;
                              break;
                           case 2:
                              teamPostMc = "enemyMc_3";
                              teamPetPostMc = "enemyPetMc_3";
                              havePlayer = true;
                        }
                     }
                     if(havePlayer == true)
                     {
                        Out.debug("set teamBPost :: ","teamPostMc >> " + teamPostMc);
                        Out.debug("set teamBPost :: ","teamPetPostMc >> " + teamPetPostMc);
                        this[teamPostMc]["charMc"].addChild(swf);
                        this[teamPostMc].charID = opponentId;
                        this[teamPostMc].visible = true;
                        this[teamPostMc].char = opponent;
                        opponent.setCharMc(this[teamPostMc]["charMc"]);
                        this.PvpCloseUpObj[teamPostMc] = opponent;
                        if(charTeam == "A")
                        {
                           Central.battle.addParty(opponent);
                        }
                        else if(charTeam == "B")
                        {
                           Central.battle.addEnemy(opponent);
                        }
                        if(opponent.pet)
                        {
                           this[teamPetPostMc]["charMc"].addChild(petSwf);
                           this[teamPetPostMc].visible = true;
                           opponent.pet.playStandby();
                           opponent.pet.restoreOriginalStatus();
                           opponent.pet.setCharMc(this[teamPetPostMc]["charMc"]);
                           opponent.pet.updateBattleFrame();
                           opponent.pet.side = BattleData.SIDE_HOSTILE;
                           Central.battle.addPet(opponent.pet);
                        }
                     }
                  }
               }
            }
         }
         this.gotoBattleStart();
      }
      
      private function onBattleStart() : void
      {
         var j:int = 0;
         this["chatDisplayMc"].visible = false;
         this["scrollDisplayMc_1"].gotoAndStop(Timeline.IDLE);
         this["scrollDisplayMc_2"].gotoAndStop(Timeline.IDLE);
         this["scrollDisplayMc_3"].gotoAndStop(Timeline.IDLE);
         if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            if(Central.main.PvpBattleType == "quickMatch")
            {
               this["scrollDisplayMc_1"].gotoAndStop(Timeline.SHOW);
            }
            else if(Central.main.PvpBattleType == "tournament")
            {
               this["scrollDisplayMc_1"].gotoAndStop(Timeline.SHOW);
            }
            else if(Central.main.PvpBattleType == "private")
            {
               for(j = 1; j <= Central.main.PvpPVMode; j++)
               {
                  if(Central.main.PvpPRTeamA[j] == Central.main.getMainChar().getData(DBCharacterData.ID))
                  {
                     this["scrollDisplayMc_" + j].gotoAndStop(Timeline.SHOW);
                  }
                  if(Central.main.PvpPRTeamB[j] == Central.main.getMainChar().getData(DBCharacterData.ID))
                  {
                     this["scrollDisplayMc_" + j].gotoAndStop(Timeline.SHOW);
                  }
               }
            }
         }
         this["battleStartMc"].gotoAndPlay(2);
         Central.battle.onBattleStart();
      }
      
      private function onBattle() : void
      {
         this.stop();
         Central.battle.startBattle();
      }
      
      private function onWin() : void
      {
         this.stop();
         Central.battle.onShowBattleWin();
      }
      
      private function onPvPWin() : void
      {
         this.stop();
         Central.battle.onShowPvPBattleWin();
      }
      
      private function onPvPLose() : void
      {
         this.stop();
         Central.battle.onShowPvPBattleLose();
      }
      
      private function onPveWin() : void
      {
         this.stop();
         Central.battle.onShowPvEBattleWin();
      }
      
      public function addCloseup() : void
      {
         var mainCharBody:MovieClip = null;
         var enemyArr:Array = null;
         var partyArr:Array = null;
         var j:uint = 0;
         var i:uint = 0;
         var party:* = undefined;
         var partyBody:MovieClip = null;
         var enemy:* = undefined;
         var char:* = undefined;
         var charBody:MovieClip = null;
         var modeInt:int = 0;
         if(Central.battle.type == Central.battle.TYPE_LOCAL || Central.battle.type == Central.battle.TYPE_NETWORK && (Central.main.PvpPlayerPost == "PVE" || Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament"))
         {
            this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
            GF.removeAllChild(this["battleStartMc"]["playerMc"]);
            mainCharBody = Central.main.getMainChar().getStaticFullBody();
            mainCharBody.scaleX = mainCharBody.scaleX * -1;
            mainCharBody.x = mainCharBody.x + mainCharBody.width;
            this["battleStartMc"]["playerMc"].addChild(mainCharBody);
            enemyArr = Central.battle.enemyArr;
            partyArr = Central.battle.partyArr;
            for(j = 0; j < partyArr.length; j++)
            {
               party = partyArr[j];
               partyBody = party.getStaticFullBody();
               partyBody.scaleX = partyBody.scaleX * -1;
               this["battleStartMc"]["partyMc" + (j + 1)].addChild(partyBody);
            }
            for(i = 0; i < enemyArr.length; i++)
            {
               enemy = enemyArr[i];
               if(enemyArr[i].limb && enemyArr[i].limb > 1)
               {
                  if(i == 0)
                  {
                     this["battleStartMc"]["enemyMc" + (i + 1)].addChild(enemy.getStaticFullBody());
                  }
               }
               else
               {
                  this["battleStartMc"]["enemyMc" + (i + 1)].addChild(enemy.getStaticFullBody());
               }
            }
         }
         else if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            if(Central.main.PvpPlayerPlace == "private")
            {
               this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
               GF.removeAllChild(this["battleStartMc"]["playerMc_pvp"]);
               if(Central.main.PvpPlayerPlace == "private")
               {
                  modeInt = Central.main.PvpPVMode;
               }
               switch(modeInt)
               {
                  case 3:
                     char = this.PvpCloseUpObj["partyMc_2"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["partyMc2_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_3"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc3"].addChild(charBody);
                  case 2:
                     char = this.PvpCloseUpObj["partyMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["partyMc1_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_2"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc2"].addChild(charBody);
                  case 1:
                     char = this.PvpCloseUpObj["playerMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["playerMc_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc1"].addChild(charBody);
               }
            }
            if(Central.main.PvpPlayerPlace == "tournament")
            {
               this["battleStartMc"]["nameTxt"].text = Central.main.getMainChar().getCharacterName();
               GF.removeAllChild(this["battleStartMc"]["playerMc_pvp"]);
               if(Central.main.PvpPlayerPlace == "private")
               {
                  modeInt = Central.main.PvpPVMode;
               }
               switch(modeInt)
               {
                  case 3:
                     char = this.PvpCloseUpObj["partyMc_2"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["partyMc2_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_3"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc3"].addChild(charBody);
                  case 2:
                     char = this.PvpCloseUpObj["partyMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["partyMc1_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_2"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc2"].addChild(charBody);
                  case 1:
                     char = this.PvpCloseUpObj["playerMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * -1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["playerMc_pvp"].addChild(charBody);
                     char = this.PvpCloseUpObj["enemyMc_1"];
                     charBody = new MovieClip();
                     charBody = char.getStaticFullBody();
                     charBody.scaleX = charBody.scaleX * 1;
                     charBody.x = charBody.x + charBody.width;
                     this["battleStartMc"]["enemyMc1"].addChild(charBody);
               }
            }
         }
      }
      
      public function addMainChar() : void
      {
         var mainChar:* = Central.main.getMainChar();
         mainChar.playStandby();
         var swf:MovieClip = mainChar.getSwf();
         swf.scaleX = swf.scaleX * -Data.BATTLE_CHAR_SCALE;
         swf.scaleY = swf.scaleY * Data.BATTLE_CHAR_SCALE;
         if(Central.battle.type == Central.battle.TYPE_LOCAL)
         {
            this["playerMc_1"]["charMc"].addChild(swf);
         }
         else if(Central.battle.type == Central.battle.TYPE_NETWORK)
         {
            this[Central.main.PvpMainCharMc]["charMc"].addChild(swf);
         }
      }
      
      public function isLevelHack(member:*) : Boolean
      {
         Out.debug(this,"isLevelHack :: rank >> " + member.getData(DBCharacterData.RANK));
         Out.debug(this,"isLevelHack :: level >> " + member.getData(DBCharacterData.LEVEL));
         switch(member.getData(DBCharacterData.RANK))
         {
            case RankData.STUDENT:
            case RankData.GENIN:
               if(member.getData(DBCharacterData.LEVEL) > RankData.GENIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.CHUNIN:
            case RankData.CHUNIN_TALENTED:
               if(member.getData(DBCharacterData.LEVEL) > RankData.CHUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.JOUNIN:
            case RankData.JOUNIN_TALENTED:
               if(member.getData(DBCharacterData.LEVEL) > RankData.JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.SPECIAL_JOUNIN:
            case RankData.SPECIAL_JOUNIN_TALENTED:
               if(member.getData(DBCharacterData.LEVEL) > RankData.SPECIAL_JOUNIN_LEVEL_CAP)
               {
                  return true;
               }
               break;
            case RankData.TUTOR:
            case RankData.TUTOR_SENIOR:
               if(member.getData(DBCharacterData.LEVEL) > RankData.TUTOR_LEVEL_CAP)
               {
                  return true;
               }
               break;
            default:
               return true;
         }
         return false;
      }
      
      private function onInitIsPartyCharacterHack(member:*) : Boolean
      {
         if(this.isLevelHack(member) || member.getData(DBCharacterData.MAX_HP) > RankData.HP_LIMIT || member.getData(DBCharacterData.MAX_CP) > RankData.CP_LIMIT || member.getData("character_speed") > RankData.SPEED_LIMIT || member.getData("character_wind") > RankData.WIND_LIMIT || member.getData("character_lightning") > RankData.LIGHTNING_LIMIT || member.getData("character_fire") > RankData.FIRE_LIMIT || member.getData("character_water") > RankData.WATER_LIMIT || member.getData("character_earth") > RankData.EARTH_LIMIT)
         {
            return true;
         }
         return false;
      }
      
      private function onInitIsMainCharacterHack(member:*) : Boolean
      {
         if(this.isLevelHack(member))
         {
            return true;
         }
         var totalApConsumed:int = member.getData("character_wind") + member.getData("character_lightning") + member.getData("character_fire") + member.getData("character_water") + member.getData("character_earth");
         if(totalApConsumed > member.getData(DBCharacterData.LEVEL))
         {
            return true;
         }
         return false;
      }
      
      public function cancelRematchCountdown() : void
      {
         if(this["defeatBarTxt"] != null)
         {
            this["defeatBarTxt"].text = "0:00";
         }
         removeEventListener(TimerEvent.TIMER,onRematchTimer);
         if(rematchTimer != null)
         {
            rematchTimer.stop();
         }
         rematchTimer = null;
      }
      
      public function startRematchCountdown(_timeLimitInSec:int) : void
      {
         rematchTimeLimit = _timeLimitInSec;
         rematchRepeat = rematchTimeLimit;
         rematchTimer = new Timer(1000,rematchTimeLimit);
         this["defeatBarTxt"].text = "0:" + zeroPad(Math.max(rematchTimeLimit - 1,0),2);
         rematchTimer.addEventListener(TimerEvent.TIMER,onRematchTimer);
         rematchTimer.start();
      }
      
      public function onRematchTimer(_evt:TimerEvent) : void
      {
         rematchRepeat--;
         switch(currentLabel)
         {
            case "pvp_win":
            case "pvp_win_2015a":
            case "pvp_lose":
            case "pvp_lose_2015a":
               if(rematchRepeat <= 0)
               {
                  this["defeatBarTxt"].text = "0:00";
                  Central.battle.pvpWinLossPanelTimedOut();
                  this["lbl_rematch_title"].text = Central.battle.getPvpWinLossPanelMessage();
                  Central.battle.disableButtonsOnRematchTimerCompleted();
               }
               else
               {
                  this["defeatBarTxt"].text = "0:" + zeroPad(Math.max(rematchRepeat - 1,0),2);
               }
         }
      }
      
      public function zeroPad(number:int, width:int) : String
      {
         var ret:String = "" + number;
         while(ret.length < width)
         {
            ret = "0" + ret;
         }
         return ret;
      }
   }
}
