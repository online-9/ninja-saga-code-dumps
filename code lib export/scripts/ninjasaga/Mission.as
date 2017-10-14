package ninjasaga
{
   import flash.display.MovieClip;
   import com.utils.Out;
   import ninjasaga.data.Data;
   import com.utils.Mixer;
   import ninjasaga.data.MissionData;
   import ninjasaga.data.AMFData;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.data.BattleData;
   import com.utils.GF;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.RankData;
   import ninjasaga.data.Formula;
   import com.utils.NumberUtil;
   import ninjasaga.data.DailyTaskData;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.Timeline;
   
   public final class Mission
   {
      
      private static var _track:Boolean = true;
      
      public static var state:int = 0;
      
      public static var stateHash:String;
      
      public static var curMissionStep:uint = 0;
      
      public static var curMission:MovieClip = null;
      
      public static var curMissionID:String = null;
      
      private static var curEventStep:uint = 0;
      
      private static var curEventData:Array;
      
      private static var isPause:Boolean = false;
      
      private static var enemiesArr:Array = new Array();
      
      private static var currentEnemyIndex:int = -1;
      
      private static var mapMissoinDoc:MovieClip;
      
      public static var isSpecialActionOfEnemy:Boolean = false;
      
      public static var SelfEnemyHPMod:uint = 0;
      
      public static var SelfEnemyCPMod:uint = 0;
      
      public static var SelfEnemyispet:uint = 0;
      
      public static const EVT_TEXT:String = "text";
      
      public static const EVT_BATTLE:String = "battle";
      
      public static const EVT_BATTLE_BUTTON:String = "battle_button";
      
      public static const EVT_END:String = "end";
      
      public static const EVT_MC:String = "mc";
      
      public static const EVT_FINISH:String = "finish";
      
      public static const EVT_FAIL:String = "fail";
      
      public static const EVT_MAP_MISSION:String = "map_mission";
      
      public static const EVT_ENGAGE:String = "engage";
      
      public static const EVT_HIDE:String = "hide";
      
      public static const TYPE_NORMAL:String = "normal";
      
      public static const TYPE_MAP_MISSION:String = "map_mission";
      
      public static const TYPE_ENGAGE:String = "engage";
      
      private static var missionCompleteCb:Function;
      
      private static const sjeArr:Array = ["msn205","msn227","msn206","msn229","msn207","msn231","msn208","msn233","msn209","msn235"];
      
      private static var sMissioncomplete:int;
      
      private static var HalloweenComplete2015:int;
      
      private static var tmpCurMissionID:String;
       
      
      public function Mission()
      {
         super();
      }
      
      public static function getConstructor() : *
      {
         return Mission.prototype.constructor;
      }
      
      private static function checkMissionData() : void
      {
         var missionData:Object = null;
         if(curMissionID)
         {
            if(curMissionID == "msn0")
            {
               return;
            }
            missionData = Main.MISSION_DATA[curMissionID];
            if(missionData)
            {
               if(String(missionData.swfName).replace("mission_") != curMissionID.replace("msn"))
               {
                  Out.error("Mission","Error >> " + Main.coreData.MISSION_DATA_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.MISSION_DATA_ERROR;
               }
            }
         }
      }
      
      public static function setMission(_id:String, _mc:MovieClip) : void
      {
         var showMsnADs:Array = null;
         var tmpClassSkill:Array = null;
         if(curMission != _mc)
         {
            state++;
            stateHash = Main.getHash(state + "_setMission_" + _mc.toString() + "_" + stateHash);
            if(_id != "msn0")
            {
               Main.tracking.trackStartAction(Main.tracking.SA_MISSION);
            }
            if(Data.EXAM_CHUNIN_ARR.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_JOUNIN_ARR.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SENNIN_ARR.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SENNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(Data.EXAM_SENNIN_ARR_EASY.indexOf(_id) >= 0)
            {
               Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SENNIN,_id,Main.tracking.TRACK_EXAM_START);
            }
            if(sjeArr.indexOf(_id) >= 0)
            {
               tmpClassSkill = Central.main.getMainChar().getClassSkillListArr();
               if(tmpClassSkill.length > 0)
               {
                  Central.main.oriClassSkill.push(tmpClassSkill[0]);
                  Central.main.getMainChar().foreClearClassSkillListArr();
               }
            }
            showMsnADs = ["msn5","msn6","msn36"];
            if(showMsnADs)
            {
               if(showMsnADs.indexOf(_id) >= 0)
               {
                  Central.main.isShowMsnADs = true;
               }
            }
            curMissionStep = 0;
            curMission = _mc;
            curMissionID = _id;
            curEventStep = 0;
            checkMissionData();
         }
      }
      
      public static function clearMission() : void
      {
         Mixer.getInstance().stopMusic();
         if(curMissionID != null)
         {
            if(isOnMapMission())
            {
               if(mapMissoinDoc)
               {
                  mapMissoinDoc.removeAllChild();
               }
            }
            switch(onMission())
            {
               case TYPE_ENGAGE:
                  Main.resetEngage();
            }
         }
         curMissionStep = 0;
         curMission = null;
         curMissionID = null;
         curEventStep = 0;
         if(Central.main.MISSION_ENGAGE_BG != MissionData.ENGAGE_BG)
         {
            Central.main.MISSION_ENGAGE_RESET = true;
         }
         Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         isSpecialActionOfEnemy = false;
         state = 0;
      }
      
      public static function pause() : void
      {
         isPause = true;
      }
      
      public static function resume() : void
      {
         isPause = false;
      }
      
      public static function start() : void
      {
         if(curMission != null && !isPause)
         {
            Main.disableMenu();
            Main.invisibleMapSideBtn();
            dispatchGameEvent();
         }
      }
      
      public static function dispatchGameEvent(_evt:String = null) : Boolean
      {
         if(curMission != null)
         {
            setEventData(curMission.getData(curMissionStep,_evt));
            if(curEventData != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function setEventData(eventData:Array, stepOffset:uint = 1) : void
      {
         var charId:String = null;
         curEventData = eventData;
         if(curEventData != null)
         {
            if(curMissionStep == 0 && state == 1)
            {
               state++;
               stateHash = Main.getHash(state + "_setEventData_" + stateHash);
            }
            curMissionStep = curMissionStep + stepOffset;
            curEventStep = 0;
            switch(curEventData[curEventStep].type)
            {
               case EVT_TEXT:
                  Main.showDialogue(curEventData,curEventStep);
                  break;
               case EVT_MC:
                  playCinematics();
                  break;
               case EVT_BATTLE:
                  if(curEventData[curEventStep].enemySelf)
                  {
                     SelfEnemyHPMod = curEventData[curEventStep].enemySelf[0].hpmod;
                     SelfEnemyCPMod = curEventData[curEventStep].enemySelf[0].cpmod;
                     SelfEnemyispet = curEventData[curEventStep].enemySelf[0].ispet;
                     Central.main.showAmfLoading();
                     charId = String(Central.main.getMainChar().getCharacterId());
                     Main.amfClient.service("CharacterDAO.getCharacterProfileById",[Account.getAccountSessionKey(),charId,true],gotCharacterProfile);
                  }
                  else
                  {
                     Main.setEnemy(curEventData[curEventStep].enemies);
                  }
                  break;
               case EVT_BATTLE_BUTTON:
                  curMissionStep--;
                  Battle.enableButtons(curEventData[curEventStep].buttonArr);
                  break;
               case EVT_MAP_MISSION:
                  if(curMission.mapType == MissionData.MAP_TYPE_MULTIPLE)
                  {
                     setMapMissionEnemies(Mission.curMission.getEnemiesOnMap());
                  }
                  else
                  {
                     setMapMissionEnemies(curEventData[curEventStep].enemies);
                  }
                  Main.initMapMission();
                  break;
               case EVT_ENGAGE:
                  Main.initEngage();
                  break;
               case EVT_FAIL:
                  failMission();
                  break;
               case EVT_FINISH:
                  completeMission();
                  break;
               case EVT_HIDE:
            }
         }
      }
      
      private static function nextStep() : void
      {
         var charId:String = null;
         if(curMission != null)
         {
            curEventStep++;
            if(curEventData[curEventStep] == null)
            {
               Main.gotoMap();
               return;
            }
            switch(curEventData[curEventStep].type)
            {
               case EVT_TEXT:
                  Main.showDialogue(curEventData,curEventStep);
                  break;
               case EVT_MC:
                  playCinematics();
                  break;
               case EVT_BATTLE:
                  if(curEventData[curEventStep].enemySelf)
                  {
                     SelfEnemyHPMod = curEventData[curEventStep].enemySelf[0].hpmod;
                     SelfEnemyCPMod = curEventData[curEventStep].enemySelf[0].cpmod;
                     SelfEnemyispet = curEventData[curEventStep].enemySelf[0].ispet;
                     Central.main.showAmfLoading();
                     charId = String(Central.main.getMainChar().getCharacterId());
                     Main.amfClient.service("CharacterDAO.getCharacterProfileById",[Account.getAccountSessionKey(),charId],gotCharacterProfile);
                  }
                  else
                  {
                     Main.setEnemy(curEventData[curEventStep].enemies);
                  }
                  break;
               case EVT_MAP_MISSION:
                  if(curMission.mapType != MissionData.MAP_TYPE_MULTIPLE)
                  {
                     setMapMissionEnemies(curEventData[curEventStep].enemies);
                  }
                  else
                  {
                     setMapMissionEnemies(Mission.curMission.getEnemiesOnMap());
                  }
                  Main.initMapMission();
                  break;
               case EVT_ENGAGE:
                  Main.initEngage();
                  break;
               case EVT_END:
                  if(curEventData[curEventStep].fn != null)
                  {
                     curEventData[curEventStep].fn();
                  }
                  break;
               case EVT_FINISH:
                  completeMission();
                  break;
               case EVT_FAIL:
                  failMission();
                  break;
               case EVT_HIDE:
            }
         }
      }
      
      public static function gotCharacterProfile(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         Central.main.hideAmfLoading();
         var dbChar:DBCharacter = Central.main.dataParser.parseRawCharacter(result.result,true);
         var petData:Object = result.pet_data as Object;
         var obj:Object = {};
         dbChar.character_id = int(1);
         dbChar.character_hp = dbChar.character_hp * SelfEnemyHPMod;
         dbChar.character_cp = dbChar.character_cp * SelfEnemyCPMod;
         dbChar.character_max_hp = dbChar.character_max_hp * SelfEnemyHPMod;
         dbChar.character_max_cp = dbChar.character_max_cp * SelfEnemyCPMod;
         if(SelfEnemyispet == 1)
         {
            petData.id = int(1);
            obj.petData = petData;
         }
         obj.dbChar = dbChar;
         Central.battle.subType = BattleData.SUBTYPE_NORMAL;
         Central.main.initChallenge([obj]);
      }
      
      public static function prevMissionStep() : void
      {
         curMissionStep--;
      }
      
      public static function dialogueFinish(_eventStep:uint) : void
      {
         if(curMission != null)
         {
            curEventStep = _eventStep;
            nextStep();
         }
      }
      
      public static function getMovieClip(_name:String) : MovieClip
      {
         var mc:MovieClip = null;
         if(curMission != null)
         {
            mc = GF.getAsset(curMission,_name);
            if(mc != null)
            {
               return mc;
            }
         }
         return new MovieClip();
      }
      
      public static function getCloseup() : MovieClip
      {
         var closeup:MovieClip = null;
         if(curMission != null)
         {
            closeup = curMission.getAsset("closeup");
            if(closeup != null)
            {
               return closeup;
            }
         }
         return new MovieClip();
      }
      
      public static function onMission() : String
      {
         if(curMission)
         {
            return curMission.type;
         }
         return null;
      }
      
      public static function getMapMissionType() : uint
      {
         if(curMission)
         {
            return curMission.mapType;
         }
         return 0;
      }
      
      public static function setMapMissionEnemies(_enemies:Array) : void
      {
         if(curMission != null)
         {
            enemiesArr = _enemies;
         }
      }
      
      public static function getMapMissionEnemies() : Array
      {
         if(curMission != null)
         {
            return enemiesArr;
         }
         return [];
      }
      
      public static function getSetting() : Object
      {
         if(curMission.getSetting != null)
         {
            return curMission.getSetting();
         }
         return {};
      }
      
      public static function isOnMapMission() : Boolean
      {
         if(curMission != null)
         {
            if(curMission.type != null)
            {
               return curMission.type == TYPE_MAP_MISSION?true:false;
            }
         }
         return false;
      }
      
      public static function setCurrentEnemy(_index:uint) : void
      {
         currentEnemyIndex = _index;
      }
      
      public static function getCurrentEnemy() : int
      {
         return currentEnemyIndex;
      }
      
      public static function setMapMission(_mc:MovieClip) : void
      {
         mapMissoinDoc = _mc;
      }
      
      public static function getMapMissionExit() : MovieClip
      {
         if(getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
         {
            return getCurrentMap()["exitMc"];
         }
         return mapMissoinDoc["exitMc"];
      }
      
      public static function mapMissionFinish() : void
      {
         if(dispatchGameEvent(GameEvents.MAP_MISSION_FINISH))
         {
            return;
         }
         Main.gotoMap();
      }
      
      public static function getCurrentMap() : MovieClip
      {
         if(curMission != null && getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
         {
            return curMission.currentMap;
         }
         return null;
      }
      
      public static function hitMapMissionLink(index:uint) : void
      {
         var obj:Object = null;
         var charMc:MovieClip = null;
         if(curMission)
         {
            if(curMission.id == "msn133")
            {
               if(index == 0)
               {
                  if(curMission.Counter + 1 < curMission.MapIndex)
                  {
                     Central.main.showInfo(Central.main.langLib.get(571));
                     obj = getSetting();
                     charMc = Central.main.getMainChar().getSwf();
                     charMc.x = obj.charPos.x;
                     charMc.y = obj.charPos.y;
                     charMc.scaleX = obj.scale * obj.charDir;
                     charMc.scaleY = obj.scale;
                     return;
                  }
               }
            }
            curMission.gotoNextMap(index);
            setMapMissionEnemies(curMission.getEnemiesOnMap());
            Main.loadMapEnemies();
         }
      }
      
      public static function reshowMap() : void
      {
         if(mapMissoinDoc)
         {
            mapMissoinDoc.reshow();
         }
      }
      
      public static function hitMapObject(name:String) : Boolean
      {
         if(curMission)
         {
            return curMission.hitMapObject(name);
         }
         return false;
      }
      
      public static function playCinematics() : void
      {
         var mc:MovieClip = null;
         try
         {
            mc = GF.getAsset(curMission,curEventData[curEventStep].name);
            if(curEventData[curEventStep].fn != null)
            {
               curMission[curEventData[curEventStep].fn](mc);
            }
            curMission.initCinematics(mc);
         }
         catch(e:Error)
         {
            Out.error("Mission","playCinematics :: Step 1 :: " + e.getStackTrace());
            Main.submitLogDump();
         }
         Main.playCinematics(mc);
      }
      
      public static function finishCinematics() : void
      {
         if(curMissionID != null)
         {
         }
         Main.removeMC();
         nextStep();
      }
      
      public static function engageEnemy() : void
      {
         var enemies:Array = curMission.enemies;
         Out.debug("Mission","engageEnemy :: enemies.length " + enemies.length);
         Main.setEnemy(enemies);
      }
      
      public static function engageGoal() : void
      {
         Out.debug("Mission","engageGoal");
         Main.gotoMap();
      }
      
      public static function get minEngageNum() : uint
      {
         return curMission.minEngageNum;
      }
      
      public static function get maxEngageNum() : uint
      {
         return curMission.maxEngageNum;
      }
      
      public static function get engageHitChance() : Number
      {
         return curMission.engageHitChance;
      }
      
      public static function get checkPointNum() : uint
      {
         return curMission.checkPointNum;
      }
      
      public static function set engageHitChance(data:Number) : void
      {
         curMission.engageHitChance = data;
      }
      
      public static function set checkPointNum(data:uint) : void
      {
         curMission.checkPointNum = data;
      }
      
      public static function completeMission() : void
      {
         var i:uint = 0;
         var tmpEffect:Object = null;
         var member:* = undefined;
         var msnRecord:Object = null;
         var mainCharWeapon:Object = null;
         var mainCharBackItem:Object = null;
         var tmpEffectB:Object = null;
         var level:int = 0;
         var gearObj:Object = null;
         var key:String = null;
         var charGearset:Object = null;
         var setEffect:Object = null;
         Out.debug("Mission","completeMission :: curMissionID " + curMissionID);
         state++;
         stateHash = Main.getHash(state + "_completeMission_" + stateHash);
         var missionData:Object = Main.MISSION_DATA[curMissionID];
         var mainChar:Character = Main.getMainChar();
         var xp:int = 0;
         var xpBonus:int = 0;
         var rewardArr:Array = [];
         var baseMissionGold:int = missionData.gold;
         var goldBonus:int = 0;
         var tp:int = 0;
         var partyMembers:Array = Central.main.partyMembers;
         if(partyMembers)
         {
            for(i = 0; i < partyMembers.length; i++)
            {
               member = partyMembers[i];
               member.isDead = false;
               member.updateHP(member.maxHP);
            }
         }
         Main.tracking.trackMission(missionData);
         var isExam:Boolean = false;
         if(Data.EXAM_CHUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SENNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(Data.EXAM_SENNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_SUCCESS);
            isExam = true;
         }
         if(isExam)
         {
            msnRecord = mainChar.checkMissionRecord(curMissionID);
            Main.tracking.trackExamTry(curMissionID,int(msnRecord.fail));
            isExam = false;
            msnRecord = {};
         }
         if(Central.main.Features.FEATURE_DOUBLE_GOLD)
         {
            baseMissionGold = baseMissionGold * 2;
         }
         if(mainChar.getData(DBCharacterData.RANK) >= RankData.CHUNIN)
         {
            xp = Formula.calcXpPenalty(mainChar.getLevel() - int(missionData.level),missionData.xp);
         }
         else
         {
            xp = int(missionData.xp);
         }
         if(Central.main.Features.FEATURE_DOUBLE_XP)
         {
            switch(curMissionID)
            {
               case "msn0":
               case "msn46":
               case "msn54":
               case "msn105":
               case "msn106":
               case "msn107":
                  break;
               default:
                  xpBonus = xpBonus + xp;
            }
         }
         if(Central.main.getMainChar().getWeapon())
         {
            mainCharWeapon = Central.main.WEAPON_DATA.find(Central.main.getMainChar().getWeapon());
            if(mainCharWeapon)
            {
               for each(tmpEffect in mainCharWeapon.effect)
               {
                  switch(tmpEffect.type)
                  {
                     case "xp_bouns":
                        xpBonus = xpBonus + tmpEffect.amount;
                        continue;
                     case "gold_bouns":
                        goldBonus = goldBonus + tmpEffect.amount;
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         var tpMultiplierBonus:Number = 1;
         if(Central.main.getMainChar().getBackItem())
         {
            mainCharBackItem = Central.main.BACK_ITEM_DATA.find(Central.main.getMainChar().getBackItem());
            if(mainCharBackItem)
            {
               for each(tmpEffectB in mainCharBackItem.effect)
               {
                  switch(tmpEffectB.type)
                  {
                     case "xp_bouns":
                        xpBonus = xpBonus + tmpEffectB.amount;
                        continue;
                     case "gold_bouns":
                        goldBonus = goldBonus + tmpEffectB.amount;
                        continue;
                     case "tp_double":
                        tpMultiplierBonus = 2;
                        continue;
                     case "gold_bonus_percent":
                        goldBonus = goldBonus + int(baseMissionGold * tmpEffectB.amount / 100);
                        continue;
                     case "xp_bonus_percent":
                        xpBonus = xpBonus + int(xp * tmpEffectB.amount / 100);
                        continue;
                     case "xp_double":
                        level = Central.main.getMainChar().getLevel();
                        switch(Central.main.getMainChar().getBackItem())
                        {
                           case "back459":
                              if(level >= 1 && level <= 10)
                              {
                                 xpBonus = xpBonus + xp;
                              }
                              break;
                           case "back460":
                              if(level >= 11 && level <= 20)
                              {
                                 xpBonus = xpBonus + xp;
                              }
                              break;
                           case "back461":
                              if(level >= 1 && level <= 20)
                              {
                                 xpBonus = xpBonus + xp;
                              }
                              break;
                           default:
                              xpBonus = xpBonus + xp;
                        }
                        continue;
                     default:
                        continue;
                  }
               }
            }
         }
         if(Central.main.getMainChar().getGearset())
         {
            gearObj = Central.main.getMainChar().getGearset();
            for(key in gearObj)
            {
               charGearset = Central.main.GEAR_SET_DATA.find(key);
               for(i = 0; i < gearObj[key] - 1; i++)
               {
                  setEffect = charGearset.effect[i];
                  switch(setEffect.type)
                  {
                     case "xp_bouns":
                        xpBonus = xpBonus + setEffect.amount;
                  }
               }
            }
         }
         if(Data.GRADE_A_MISSION_ARR.indexOf(curMissionID) >= 0 || Data.GRADE_B_MISSION_ARR.indexOf(curMissionID) >= 0 || Data.GRADE_C_MISSION_ARR.indexOf(curMissionID) >= 0)
         {
            if(Central.main.isDoubleXP() > 0)
            {
               xpBonus = xpBonus + xp;
            }
         }
         if(missionData.sp == 0 && missionData.grade != "S")
         {
            if(Central.main.extraData.emblem_xp_bonus_times > 0)
            {
               Central.main.emblem_xp_bonus_amount = NumberUtil.randomInt(15,30) / 100;
               xpBonus = xpBonus + xp * Central.main.emblem_xp_bonus_amount;
            }
         }
         var levelup:Boolean = mainChar.updateXP(xp + xpBonus);
         updateDailyTask(DailyTaskData.TYPE_MISSION,1);
         if(missionData.sp == 0)
         {
            mainChar.saveGold(baseMissionGold + goldBonus);
         }
         tp = int(missionData.tp);
         tp = tp * tpMultiplierBonus;
         if(Central.main.Features.FEATURE_DOUBLE_TP)
         {
            tp = tp * 2;
         }
         mainChar.saveTP(tp);
         mainChar.addMissionRecord(curMissionID,"success");
         if(curMissionID == "msn284")
         {
            tmpCurMissionID = curMissionID;
            Mission.HalloweenComplete2015 = 0;
            trace(Central.main.Halloween2015EnemyList.toString() + Central.main.getMainChar().itemUsedInBattle.toString() + 0);
            Central.main.amfClient.service("HalloweenEvent2015.finishBattle",[Account.getAccountSessionKey(),Central.main.Halloween2015EnemyList,Central.main.getMainChar().itemUsedInBattle,Mission.HalloweenComplete2015,Main.getHash(Central.main.Halloween2015EnemyList.toString() + Central.main.getMainChar().itemUsedInBattle.toString() + 0)],getHalloween2015Response);
         }
         else if(curMissionID == "msn285" || curMissionID == "msn286" || curMissionID == "msn287" || curMissionID == "msn288" || curMissionID == "msn289")
         {
            tmpCurMissionID = curMissionID;
            Central.main.amfClient.service("Anni7th.finishBattle",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,0,Main.getHash(curMissionID + Central.main.getMainChar().itemUsedInBattle.toString() + 0)],get7thResponse);
         }
         else if(missionData.grade == "S")
         {
            tmpCurMissionID = curMissionID;
            Mission.sMissioncomplete = 0;
            Central.main.amfClient.service("SLevelMission.finishMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,Mission.sMissioncomplete,Main.getHash(curMissionID + 0 + Central.main.getMainChar().itemUsedInBattle.toString())],getSGradeResponse);
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp > 0)
         {
            Central.main.amfClient.service("SSTraining.finishSSMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,0,Central.main.getHash(curMissionID + 0)],function(response:Object):*
            {
               response.update_inventory.showPopup = false;
               if(Central.main.validateAmfResponse(response))
               {
                  return;
               }
            });
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp == 0 && missionData.grade != "S")
         {
            Main.getMainChar().updateDB(xp + xpBonus,baseMissionGold + goldBonus,[],curMissionID,0,Mission,stateHash);
            Main.achievement.updateCharStat(Main.achievementData.MISSION_COMPLETED);
            Main.achievement.checkSpecialAchievement(Main.achievementData.SPECIFIC_MISSION_COMPLETED);
         }
         if(missionData.special)
         {
            Main.achievement.updateCharStat(Main.achievementData.SPECIAL_MISSION_COMPLETED);
         }
         if(missionData.daily)
         {
            Main.achievement.updateCharStat(Main.achievementData.DAILY_MISSION_COMPLETED);
         }
         if(curMission.keepParty == false)
         {
            Main.removePartyNpc();
            Main.partyMembers = null;
            Main.emptyRecruitedFriends();
         }
         clearMission();
         Battle.setBattleBg();
         Main.updateMenu();
         Main.gotoMap();
         Main.showMissionComplete(missionData,levelup);
         Main.showAds = true;
      }
      
      private static function getSGradeResponse(response:Object) : void
      {
         var additem:Array = null;
         if(response.update_inventory)
         {
            response.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(response))
         {
            if(Mission.sMissioncomplete == 1)
            {
               return;
            }
            additem = response.update_inventory.add_item_id;
            response.update_inventory.add_item_id = null;
            Main.showSMissionReward = true;
            Main.sMissionRewardItem = additem[0];
            Main.sMissionRewardList = response.reward_list;
            Main.MISSION_DATA[tmpCurMissionID].xp = additem[1].replace("xp","").replace("_1","");
            Main.MISSION_DATA[tmpCurMissionID].gold = additem[2].replace("gold","").replace("_1","");
         }
      }
      
      private static function getHalloween2015Response(response:Object) : void
      {
         var additem:Array = null;
         Central.main.Halloween2015RewardList = [];
         if(response.update_inventory)
         {
            response.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(response))
         {
            if(Mission.HalloweenComplete2015 == 1)
            {
               return;
            }
            additem = response.update_inventory.add_item_id;
            Central.main.showHalloween2015Reward = true;
            Central.main.Halloween2015RewardList = response.update_inventory.add_item_id;
            Main.MISSION_DATA[tmpCurMissionID].xp = additem[0].replace("xp","").replace("_1","");
            Main.MISSION_DATA[tmpCurMissionID].gold = additem[1].replace("gold","").replace("_1","");
         }
      }
      
      private static function get7thResponse(response:Object) : void
      {
         var additem:Array = null;
         if(response.update_inventory)
         {
            response.update_inventory.showPopup = false;
         }
         if(Main.validateAmfResponse(response))
         {
            additem = response.update_inventory.add_item_id;
            Main.MISSION_DATA[tmpCurMissionID].xp = additem[0].replace("xp","");
            Main.MISSION_DATA[tmpCurMissionID].gold = additem[1].replace("gold","");
         }
      }
      
      public static function failMission() : void
      {
         var curMsnSetting:Object = null;
         var isExam:Boolean = false;
         if(Data.EXAM_CHUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_CHUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            isExam = true;
         }
         if(Data.EXAM_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            isExam = true;
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(curMissionID) >= 0)
         {
            Main.tracking.trackExam(Main.tracking.TRACK_EXAM_SPECIAL_JOUNIN,curMissionID,Main.tracking.TRACK_EXAM_FAIL);
            Central.main.getMainChar().foreClearClassSkillListArr();
            isExam = true;
            if(Central.main.oriClassSkill.length > 0)
            {
               Central.main.getMainChar().setClassSkillListArr(Central.main.oriClassSkill[0]);
               Central.main.getMainChar().setSkillList(Central.main.oriClassSkill);
            }
         }
         if(isExam)
         {
            curMsnSetting = getSetting();
            if(curMsnSetting != null)
            {
               if(curMsnSetting.curStage != null)
               {
                  Central.main.tracking.trackExamPart(Central.mission.curMissionID,curMsnSetting.curStage,Central.main.tracking.TRACK_FAIL);
               }
            }
            isExam = false;
            curMsnSetting = {};
         }
         Main.getMainChar().addMissionRecord(curMissionID,"fail");
         var missionData:Object = Main.MISSION_DATA[curMissionID];
         if(curMissionID == "msn284")
         {
            Mission.HalloweenComplete2015 = 1;
            Central.main.amfClient.service("HalloweenEvent2015.finishBattle",[Account.getAccountSessionKey(),Central.main.Halloween2015EnemyList,Central.main.getMainChar().itemUsedInBattle,Mission.HalloweenComplete2015,Main.getHash(Central.main.Halloween2015EnemyList + Central.main.getMainChar().itemUsedInBattle.toString() + 1)],getHalloween2015Response);
         }
         else if(curMissionID == "msn285" || curMissionID == "msn286" || curMissionID == "msn287" || curMissionID == "msn288" || curMissionID == "msn289")
         {
            Central.main.amfClient.service("Anni7th.finishBattle",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,1,Main.getHash(curMissionID + Central.main.getMainChar().itemUsedInBattle.toString() + 1)],getHalloween2015Response);
         }
         else if(missionData.grade == "S")
         {
            Mission.sMissioncomplete = 1;
            Central.main.amfClient.service("SLevelMission.finishMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,Mission.sMissioncomplete,Main.getHash(curMissionID + 1 + Central.main.getMainChar().itemUsedInBattle.toString())],getSGradeResponse);
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp > 0)
         {
            Central.main.amfClient.service("SSTraining.finishSSMission",[Account.getAccountSessionKey(),curMissionID,Central.main.getMainChar().itemUsedInBattle,1,Central.main.getHash(curMissionID + 1)],function(response:Object):*
            {
               if(Central.main.validateAmfResponse(response))
               {
                  return;
               }
            });
            Central.main.getMainChar().itemUsedInBattle = [];
         }
         else if(missionData.sp == 0 && missionData.grade != "S")
         {
            Main.getMainChar().updateDB(0,0,[],curMissionID,1,Mission);
         }
         clearMission();
         Main.showInfo(Central.main.langLib.get(410));
         Main.gotoMap();
         Main.achievement.updateCharStat(Main.achievementData.MISSION_FAILED);
         Main.showDeadPopup();
      }
      
      public static function killMapEnemy() : void
      {
         if(curMission)
         {
            if(enemiesArr == null)
            {
               return;
            }
            if(enemiesArr[currentEnemyIndex] == null)
            {
               return;
            }
            enemiesArr[currentEnemyIndex].died = true;
            if(getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
            {
               curMission.enemiesKilled();
            }
         }
      }
      
      public static function getDailyTask(showPopup:* = true) : Boolean
      {
         var dailyTask:Object = null;
         if(Main.getMainChar().getLevel() >= 20 && checkDailyTaskStatus() == 1)
         {
            dailyTask = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
            if(dailyTask.type == DailyTaskData.TYPE_XP)
            {
               Main.getMainChar().clearInventory(InventoryData.TYPE_DAILY_TASK);
            }
         }
         if((checkDailyTaskStatus() == 0 || checkDailyTaskStatus() == -1) && Main.getMainChar().getLevel() >= 3)
         {
            dailyTask = getRandomDailyTask();
            Main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,dailyTask);
            Main.updateMapSideBtn();
            if(showPopup)
            {
               Main.showDailyTask();
               return true;
            }
            return false;
         }
         return false;
      }
      
      private static function getRandomDailyTask() : Object
      {
         var dailyTask:Object = {};
         var rNum:int = Math.ceil(NumberUtil.randomNumber(0,3.999));
         while(Main.getMainChar().getLevel() >= 15 && rNum == 1)
         {
            rNum = Math.ceil(NumberUtil.randomNumber(0,3.999));
         }
         dailyTask.completeTime = 0;
         dailyTask.amount = 0;
         switch(rNum)
         {
            case 0:
               dailyTask.type = DailyTaskData.TYPE_CHALLENGE;
               dailyTask.total = Main.getMainChar().getLevel();
               if(dailyTask.total < 2)
               {
                  dailyTask.total = 2;
               }
               if(dailyTask.total > 5)
               {
                  dailyTask.total = 5;
               }
               break;
            case 1:
               dailyTask.type = DailyTaskData.TYPE_XP;
               dailyTask.total = Main.getMainChar().getLevel() * 20;
               if(dailyTask.total > 400)
               {
                  dailyTask.total = 400;
               }
               break;
            case 2:
               dailyTask.type = DailyTaskData.TYPE_RECRUIT;
               dailyTask.total = Main.getMainChar().getLevel();
               if(dailyTask.total < 2)
               {
                  dailyTask.total = 2;
               }
               if(dailyTask.total > 6)
               {
                  dailyTask.total = 6;
               }
               break;
            default:
               dailyTask.type = DailyTaskData.TYPE_MISSION;
               dailyTask.total = Main.getMainChar().getLevel();
               if(dailyTask.total < 2)
               {
                  dailyTask.total = 2;
               }
               if(dailyTask.total > 4)
               {
                  dailyTask.total = 4;
               }
         }
         return dailyTask;
      }
      
      public static function updateDailyTask(type:String, amount:int) : void
      {
         var dailyTaskRecord:Object = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         if(dailyTaskRecord != null)
         {
            if(dailyTaskRecord.completeTime == 0)
            {
               if(dailyTaskRecord.type == type)
               {
                  dailyTaskRecord.amount = dailyTaskRecord.amount + amount;
                  if(dailyTaskRecord.amount > dailyTaskRecord.total)
                  {
                     dailyTaskRecord.amount = dailyTaskRecord.total;
                  }
                  Main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,dailyTaskRecord);
                  if(Main.checkGameStatus() == Timeline.MAP)
                  {
                     Main.updateMapSideBtn();
                  }
                  Main.getMainChar().updateDailyTask(dailyTaskRecord);
               }
            }
         }
      }
      
      public static function checkDailyTaskStatus() : int
      {
         var dailyTaskRecord:Object = Main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         if(dailyTaskRecord == null)
         {
            return 0;
         }
         if(dailyTaskRecord.completeTime == 0 && dailyTaskRecord.amount < dailyTaskRecord.total)
         {
            return 1;
         }
         if(dailyTaskRecord.completeTime == 0 && dailyTaskRecord.amount == dailyTaskRecord.total)
         {
            return 2;
         }
         if(dailyTaskRecord.completeTime > 0)
         {
            return -2;
         }
         return -9;
      }
      
      public static function finishDailyTask() : void
      {
         var dailyTask:Object = Central.main.getMainChar().getInventory(InventoryData.TYPE_DAILY_TASK);
         dailyTask.completeTime = Central.main.serverTime;
         Central.main.getMainChar().setInventory(InventoryData.TYPE_DAILY_TASK,dailyTask);
      }
   }
}
