package ninjasaga
{
   import ninjasaga.data.AppData;
   import de.polygonal.ds.HashMap;
   import ninjasaga.data.Data;
   import com.utils.Out;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.data.PvPData;
   import flash.utils.getTimer;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.SkillData;
   import flash.utils.getQualifiedClassName;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.StaticVariables;
   import com.utils.Sha1Encrypt;
   import flash.system.Capabilities;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.NPCData;
   
   public final class DataParser
   {
      
      private static var instance:ninjasaga.DataParser;
       
      
      public function DataParser(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use DataParser.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.DataParser
      {
         if(instance == null)
         {
            instance = new ninjasaga.DataParser(new SingletonBlocker());
         }
         return instance;
      }
      
      public function parseSystemData(result:Object) : Boolean
      {
         var key:String = null;
         var i:uint = 0;
         var weaponData:Object = null;
         var itemData:Object = null;
         var hairData:Object = null;
         var essenceData:Object = null;
         var materialData:Object = null;
         var enemyData:Object = null;
         var BackitemData:Object = null;
         var AccessoryData:Object = null;
         var TradingData:Object = null;
         var gearsetData:Object = null;
         var achievementData:Object = null;
         var petData:Object = null;
         var value:Object = null;
         var BLvalue:Object = null;
         var SENvalue:Object = null;
         var ads:Array = null;
         var specialAds:Array = null;
         var wallfeedData:Object = null;
         try
         {
            achievementData = Central.main.dataLib.getAchievement();
            if(AppData.type != AppData.RR)
            {
               wallfeedData = Central.main.dataLib.getWallfeed();
            }
            petData = Central.main.dataLib.getPet();
            Central.main.PET_DATA = new HashMap();
            for(key in petData)
            {
               Central.main.PET_DATA.insert(key,petData[key]);
            }
            if(Data.TEST_VERSION)
            {
               Central.main.SKILL_DATA = result.skill as Object;
               Central.main.BODY_SET_BOY = result.body_set_boy as Object;
               Central.main.BODY_SET_GIRL = result.body_set_girl as Object;
               Central.main.BLOODLINE_DATA = result.bloodline as Object;
               Central.main.BLOODLINE_SKILL_DATA = result.bloodline_skill as Object;
               Central.main.SENJUTSU_DATA = result.senjutsu as Object;
               Central.main.SENJUTSU_SKILL_DATA = result.senjutsu_skill as Object;
               weaponData = result.weapon as Object;
               enemyData = result.enemy as Object;
               itemData = result.item as Object;
               AccessoryData = result.accessory as Object;
               BackitemData = result.back_item as Object;
            }
            else
            {
               Central.main.SKILL_DATA = Central.main.dataLib.getSkill();
               Central.main.BODY_SET_BOY = Central.main.dataLib.getBodySet(0);
               Central.main.BODY_SET_GIRL = Central.main.dataLib.getBodySet(1);
               Central.main.BLOODLINE_DATA = Central.main.dataLib.getBloodline();
               Central.main.BLOODLINE_SKILL_DATA = Central.main.dataLib.getBloodlineSkill();
               Central.main.SENJUTSU_DATA = Central.main.dataLib.getSenjutsu();
               Central.main.SENJUTSU_SKILL_DATA = Central.main.dataLib.getSenjutsuSkill();
               weaponData = Central.main.dataLib.getWeapon();
               enemyData = Central.main.dataLib.getBossEnemy();
               itemData = Central.main.dataLib.getItem();
               hairData = Central.main.dataLib.getHairDetailData();
               AccessoryData = Central.main.dataLib.getAccessory();
               BackitemData = Central.main.dataLib.getBack_item();
               gearsetData = Central.main.dataLib.getGearset();
               Central.main.EnemyData = Central.main.dataLib.getEnemy();
            }
            Central.main.SKILL_DATA_ARR = [];
            for each(value in Central.main.SKILL_DATA)
            {
               Central.main.SKILL_DATA_ARR.push(value);
            }
            Central.main.SKILL_DATA_ARR.sortOn(["level","gold"],[Array.NUMERIC,Array.NUMERIC]);
            Central.main.BLOODLINE_SKILL_DATA_ARR = [];
            for each(BLvalue in Central.main.BLOODLINE_SKILL_DATA)
            {
               Central.main.BLOODLINE_SKILL_DATA_ARR.push(BLvalue);
            }
            Central.main.SENJUTSU_SKILL_DATA_ARR = [];
            for each(SENvalue in Central.main.SENJUTSU_SKILL_DATA)
            {
               Central.main.SENJUTSU_SKILL_DATA_ARR.push(SENvalue);
            }
            Central.main.WEAPON_DATA = new HashMap();
            for(key in weaponData)
            {
               Central.main.WEAPON_DATA.insert(key,weaponData[key]);
            }
            Central.main.ENEMY_DATA = new HashMap();
            for(key in enemyData)
            {
               Central.main.ENEMY_DATA.insert(key,enemyData[key]);
            }
            Central.main.WALLFEED_DATA = new HashMap();
            for(key in wallfeedData)
            {
               Central.main.WALLFEED_DATA.insert(key,wallfeedData[key]);
            }
            Central.main.ITEM_DATA = new HashMap();
            Central.main.ESSENCE_DATA = new HashMap();
            Central.main.MATERIAL_DATA = new HashMap();
            Central.main.CURRENCY_DATA = new HashMap();
            for(key in itemData)
            {
               if(itemData[key].animation == Data.TEXT_MATERIAL)
               {
                  Central.main.MATERIAL_DATA.insert(key,itemData[key]);
               }
               else if(itemData[key].animation == Data.TEXT_ESSENCE)
               {
                  Central.main.ESSENCE_DATA.insert(key,itemData[key]);
               }
               else if(itemData[key].animation == Data.TEXT_CURRENCY)
               {
                  Central.main.CURRENCY_DATA.insert(key,itemData[key]);
               }
               else
               {
                  Central.main.ITEM_DATA.insert(key,itemData[key]);
               }
            }
            Central.main.HAIR_DATA = new HashMap();
            for(key in hairData)
            {
               Central.main.HAIR_DATA.insert(key,hairData[key]);
            }
            Central.main.BACK_ITEM_DATA = new HashMap();
            for(key in BackitemData)
            {
               Central.main.BACK_ITEM_DATA.insert(key,BackitemData[key]);
            }
            Central.main.ACCESSORY_DATA = new HashMap();
            for(key in AccessoryData)
            {
               Central.main.ACCESSORY_DATA.insert(key,AccessoryData[key]);
            }
            Central.main.ACHIEVEMENT_DATA = new HashMap();
            for(key in achievementData)
            {
               Central.main.ACHIEVEMENT_DATA.insert(key,achievementData[key]);
            }
            Central.main.GEAR_SET_DATA = new HashMap();
            for(key in gearsetData)
            {
               Central.main.GEAR_SET_DATA.insert(key,gearsetData[key]);
            }
            Central.main.TRADING_DATA = new HashMap();
            for(key in TradingData)
            {
               Central.main.TRADING_DATA.insert(key,TradingData[key]);
            }
            Central.main.serverTime = result.server_time as int;
            Central.main.currentDate = result.current_date as int;
            Central.main.NEWS = result.news as String;
            if(result.pvp_server_status)
            {
               Central.main.socket.setServer(result.pvp_server_status);
            }
            ads = result.ads_path as Array;
            ads = [{
               "url":"http://d36ck5vhy2kgkk.cloudfront.net/ad/ad4game/Flash_ad_loader_300x250.swf",
               "link":null
            }];
            if(ads && Account.getAccountType() == Account.FREE && AppData.type == AppData.FB)
            {
               Central.main.ads = ads;
               Central.main.showAds = true;
            }
            specialAds = result.special_ads as Array;
            if(specialAds)
            {
               if(specialAds.length > 0)
               {
                  Central.main.proc.specialAds = specialAds;
               }
            }
            return true;
         }
         catch(e:Error)
         {
            Out.error(this,"parseSystemData::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         return false;
      }
      
      public function parseCharacterData(extraData:Object) : Boolean
      {
         var pvpRecord:Object = null;
         var pvpRecordStr:String = null;
         var tmp:Array = null;
         var j:uint = 0;
         var trainingSkillStr:String = null;
         var trainedSkills:Array = null;
         var trainedSkillTypes:HashMap = null;
         var logStr:String = null;
         var i:uint = 0;
         var isSave:Boolean = false;
         var k:int = 0;
         var petData:Array = null;
         var petsStr:String = null;
         var invWeapons:Array = null;
         var invSkills:Array = null;
         var equippedSkills:Array = null;
         var invBodySet:Array = null;
         var bodySetData:Object = null;
         var rouletteAllowed:Boolean = false;
         var extraDataString:String = null;
         var newMail:Boolean = false;
         var arr:Array = null;
         var typesToRemove:Array = null;
         var skillToRemove:Array = null;
         var maxSkillType:uint = 0;
         var type:String = null;
         var typeObj:Object = null;
         var playerPet:DBCharacter = null;
         var petStr:String = null;
         var bodySetId:String = null;
         try
         {
            pvpRecord = extraData.pvp_record as Object;
            pvpRecordStr = "";
            if(!pvpRecord)
            {
               pvpRecord = {};
               pvpRecord[PvPData.PLAY] = 0;
               pvpRecord[PvPData.WIN] = 0;
               pvpRecord[PvPData.LOSE] = 0;
               pvpRecord[PvPData.DISCONNECT] = 0;
               pvpRecord[PvPData.AVERAGE_LEVEL_DIFFERENCE] = 0;
               pvpRecord[PvPData.PVP_CURRENCY] = 0;
               pvpRecord[PvPData.PVP_POINT] = 0;
               pvpRecord[PvPData.PVP_TOURNAMENT_TICKET] = 0;
            }
            else
            {
               pvpRecordStr = String(pvpRecord.play) + "," + String(pvpRecord.win) + "," + String(pvpRecord.lose) + "," + String(pvpRecord.disconnect) + "," + String(pvpRecord.avg_level_diff);
            }
            Central.main.getMainChar().pvpRecord = pvpRecord;
            Central.main.canClaimGiftBag = extraData.canClaimFK;
            Central.main.ShowPopup = extraData.showNotice;
            Central.main.popupText = extraData.noticeText;
            Central.main.claimRemain = extraData.claim_remain;
            Central.main.showFanPage = extraData.showFanPage;
            Central.main.claimTokenStatus = extraData.event_170m_like;
            Central.main.easterCombineBoostTime = extraData.combine_boost_time;
            Central.main.canEasterCombineBoostTime = extraData.combine_boost_time_in_period;
            Central.main.timeGetExtraData = getTimer() / 1000;
            Central.main.easterCombineBoostStartTimeLeft = extraData.combine_boost_time_period_start_left;
            Central.main.easterCombineBoostEndTimeLeft = extraData.combine_boost_time_period_end_left;
            if(extraData.daily_login_data != null)
            {
               Central.main.dailyLoginData = extraData.daily_login_data;
            }
            tmp = [];
            j = 0;
            if(extraData.file_1 != null)
            {
               for(j = 0; j < extraData.file_1.length; j++)
               {
                  tmp = extraData.file_1[j].split("/");
                  Central.main.file_1.push(tmp[tmp.length - 1].replace(".swf",""));
               }
            }
            if(extraData.file_2 != null)
            {
               for(j = 0; j < extraData.file_2.length; j++)
               {
                  tmp = extraData.file_2[j].split("/");
                  Central.main.file_2.push(tmp[tmp.length - 1].replace(".swf",""));
               }
            }
            if(extraData.file_3 != null)
            {
               for(j = 0; j < extraData.file_3.length; j++)
               {
                  tmp = extraData.file_3[j].split("/");
                  Central.main.file_3.push(tmp[tmp.length - 1].replace(".swf",""));
               }
            }
            Central.main.christmasCoin = extraData.christmas_coin;
            Central.main.clanSeason = extraData.seasonNumber;
            Central.main.pvpTimeList = extraData.pvpSchedule;
            Central.main.crewSeason = extraData.seasonNumber_crew;
            tmp = extraData.get_learning_status as Array;
            if(tmp)
            {
               if(tmp.length > 0)
               {
                  Central.main.getMainChar().trainingFdSkill = {};
                  Central.main.getMainChar().trainingFdSkill.target = tmp[0];
                  Central.main.getMainChar().trainingFdSkill.skill = tmp[1];
                  Central.main.getMainChar().trainingFdSkill.skillType = Central.main.SKILL_DATA[tmp[1]].type;
                  Central.main.getMainChar().trainingFdSkill.progress = tmp[2];
                  Central.main.getMainChar().trainingFdSkill.lastVisitTime = tmp[3];
                  Central.main.getMainChar().trainingFdSkill.serverTime = tmp[4];
                  Central.main.getMainChar().trainingFdSkill.trainingTime = Central.main.SKILL_DATA[tmp[1]].train_time * 2;
                  if(Central.main.getMainChar().trainingFdSkill.trainingTime == 0)
                  {
                     Central.main.getMainChar().trainingFdSkill.trainingTime = 1;
                  }
                  Central.main.getMainChar().trainingFdSkill.remainingTime = int(tmp[3]) + int(Central.main.getMainChar().trainingFdSkill.trainingTime) * 60 * 60 - int(tmp[4]);
               }
               else
               {
                  Central.main.getMainChar().trainingFdSkill = null;
               }
            }
            else
            {
               Central.main.getMainChar().trainingFdSkill = null;
            }
            Central.main.getMainChar().trainingSkill = extraData.training_skill as Object;
            trainingSkillStr = "";
            if(extraData.training_skill)
            {
               trainingSkillStr = String(extraData.training_skill.id) + "," + String(extraData.training_skill.time);
            }
            trainedSkills = Central.main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
            trainedSkillTypes = new HashMap();
            logStr = ">> All skill types :: ";
            isSave = false;
            if(trainedSkills)
            {
               for(i = 0; i < trainedSkills.length; i++)
               {
                  if(Central.main.SKILL_DATA[trainedSkills[i]])
                  {
                     type = Central.main.SKILL_DATA[trainedSkills[i]].type;
                     if(SkillData.ALL_NINJUTSU_TYPES.indexOf(type) >= 0)
                     {
                        typeObj = trainedSkillTypes.find(type);
                        if(typeObj == null)
                        {
                           typeObj = {
                              "type":type,
                              "num":1
                           };
                           logStr = logStr + (type + ",");
                        }
                        else
                        {
                           typeObj.num++;
                        }
                        trainedSkillTypes.insert(type,typeObj);
                     }
                  }
               }
               arr = trainedSkillTypes.toArray();
               typesToRemove = [];
               skillToRemove = [];
               arr.sortOn("num",Array.NUMERIC | Array.DESCENDING);
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  maxSkillType = 3;
               }
               else
               {
                  maxSkillType = 2;
               }
               for(i = arr.length - 1; i >= maxSkillType; i--)
               {
                  if(arr[i] == null)
                  {
                     break;
                  }
                  typesToRemove.push(arr[i].type);
               }
               for(i = 0; i < trainedSkills.length; i++)
               {
                  if(Central.main.SKILL_DATA[trainedSkills[i]])
                  {
                     if(typesToRemove.indexOf(Central.main.SKILL_DATA[trainedSkills[i]].type) >= 0 && (Central.main.SKILL_DATA[trainedSkills[i]].type != SkillData.TYPE_TAIJUTSU && Central.main.SKILL_DATA[trainedSkills[i]].type != SkillData.TYPE_GENJUTSU))
                     {
                        skillToRemove.push(trainedSkills[i]);
                     }
                  }
               }
               if(skillToRemove.length > 0)
               {
                  for(i = 0; i < skillToRemove.length; i++)
                  {
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,skillToRemove[i]);
                  }
               }
            }
            if(extraData.sum_1 != null)
            {
               for(k = 0; k < extraData.sum_1.length; k++)
               {
                  Central.main.sum_1.push(extraData.sum_1[k]);
               }
            }
            if(extraData.sum_2 != null)
            {
               for(k = 0; k < extraData.sum_2.length; k++)
               {
                  Central.main.sum_2.push(extraData.sum_2[k]);
               }
            }
            if(extraData.sum_3 != null)
            {
               for(k = 0; k < extraData.sum_3.length; k++)
               {
                  Central.main.sum_3.push(extraData.sum_3[k]);
               }
            }
            petData = extraData.player_pet as Array;
            petsStr = "";
            for(i = 0; i < petData.length; i++)
            {
               if(petData[i].equipped)
               {
                  playerPet = this.parsePetData(petData[i]);
                  Central.main.getMainChar().initPet(playerPet,petData[i].swfName,petData[i].clsName);
               }
               else
               {
                  playerPet = this.parsePetData(petData[i]);
                  Central.main.getMainChar().initStandbyPet(playerPet,petData[i].swfName,petData[i].clsName);
               }
               if(getQualifiedClassName(petData[i].train_status) == "Object")
               {
                  Central.main.getMainChar().getPetById(petData[i].id).training = petData[i].train_status as Object;
               }
               if(petData[i].maturity != null)
               {
                  if(petData[i].maturity > 100)
                  {
                     petData[i].maturity = 100;
                  }
                  Central.main.getMainChar().getPetById(petData[i].id).maturity = petData[i].maturity;
               }
               if(petData[i].ep != null)
               {
                  Central.main.getMainChar().getPetById(petData[i].id).petEP = petData[i].ep;
               }
               petStr = String(petData[i].id) + "," + petData[i].swfName + "," + petData[i].clsName + "," + String(petData[i].level) + "," + String(petData[i].xp) + "," + (!!petData[i].equipped?"1":"0") + ",";
               if(petData[i].skills)
               {
                  petStr = petStr + petData[i].skills.toString();
               }
               if(petsStr == "")
               {
                  petsStr = petStr;
               }
               else
               {
                  petsStr = petsStr + ("," + petStr);
               }
            }
            invWeapons = Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON);
            for(i = 0; i < invWeapons.length; i++)
            {
               if(!Central.main.WEAPON_DATA.containsKey(invWeapons[i]))
               {
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,invWeapons[i]);
               }
            }
            invSkills = Central.main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
            for(i = 0; i < invSkills.length; i++)
            {
               if(Central.main.SKILL_DATA[invSkills[i]] == null)
               {
                  Out.error(this,"skill not exist :: " + invSkills[i]);
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
                  Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
               }
               else if(int(Central.main.SKILL_DATA[invSkills[i]].special_class) > 0)
               {
                  if(int(Central.main.SKILL_DATA[invSkills[i]].special_class) == Central.main.getMainChar().getData(DBCharacterData.CONTROL))
                  {
                     Central.main.getMainChar().setClassSkillListArr(invSkills[i]);
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
                  }
                  else
                  {
                     Out.error(this,"Class Skill not match :: " + invSkills[i]);
                  }
               }
               else if(Central.main.coreData.ADMIN_CHARACTERS.indexOf(int(Central.main.getMainChar().getData(DBCharacterData.ID))) < 0)
               {
                  if(Central.main.SKILL_DATA[invSkills[i]].premium || Central.main.SKILL_DATA[invSkills[i]].level > Central.main.getMainChar().getLevel() || Central.main.SKILL_DATA[invSkills[i]].crystal > 0)
                  {
                     if(trainedSkills)
                     {
                        if(trainedSkills.indexOf(invSkills[i]) < 0)
                        {
                           Out.error(this,"skill error, hack data collected");
                           Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
                           Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
                        }
                     }
                     else
                     {
                        Out.error(this,"skill error, hack data collected");
                        Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,invSkills[i]);
                        Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
                     }
                  }
               }
            }
            equippedSkills = Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS];
            for(i = 0; i < equippedSkills.length; i++)
            {
               if(Central.main.SKILL_DATA[equippedSkills[i]] == null)
               {
                  Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
               }
               else if(Central.main.coreData.ADMIN_CHARACTERS.indexOf(int(Central.main.getMainChar().getData(DBCharacterData.ID))) < 0)
               {
                  if(Central.main.SKILL_DATA[equippedSkills[i]].premium || Central.main.SKILL_DATA[equippedSkills[i]].level > Central.main.getMainChar().getLevel() || Central.main.SKILL_DATA[equippedSkills[i]].crystal > 0)
                  {
                     if(trainedSkills)
                     {
                        if(trainedSkills.indexOf(equippedSkills[i]) < 0)
                        {
                           Out.error(this,"skill error, hack data collected");
                           Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
                        }
                     }
                     else
                     {
                        Out.error(this,"skill error, hack data collected");
                        Central.main.getMainChar().databaseCharacter[DBCharacterData.SKILLS] = [];
                     }
                  }
               }
            }
            if(!Central.main.WEAPON_DATA.containsKey(Central.main.getMainChar().getWeapon()))
            {
               Central.main.getMainChar().databaseCharacter.character_body_parts["weapon"] = "wpn1";
               StaticVariables.weaponStr = Sha1Encrypt.encrypt(String("wpn1"));
            }
            invBodySet = Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET);
            bodySetData = Central.main.getMainChar().getGender() == 0?Central.main.BODY_SET_BOY:Central.main.BODY_SET_GIRL;
            for(i = 0; i < invBodySet.length; i++)
            {
               bodySetId = invBodySet[i];
               if(bodySetData[bodySetId] == null)
               {
                  Out.error(this,"parseCharacterData :: bodySetId >> " + bodySetId + " not exist.");
                  Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,bodySetId);
               }
            }
            Central.main.getMainChar().isFan = extraData.is_fan;
            Central.main.getMainChar().consecutiveDays = extraData.consecutive_days;
            Central.main.getMainChar().Ann_MissionID = extraData.anni_mission_id;
            Central.main.getMainChar().bp_mission_id = extraData.bp_mission_id;
            Central.main.getMainChar().bloodline = [];
            for(i = 0; i < extraData.bloodline.length; i++)
            {
               Central.main.getMainChar().bloodline.push(extraData.bloodline[i]);
            }
            Central.main.getMainChar().senjutsu = [];
            if(extraData.senjutsu)
            {
               for(i = 0; i < extraData.senjutsu.length; i++)
               {
                  Central.main.getMainChar().senjutsu.push(extraData.senjutsu[i]);
               }
               Central.main.getMainChar().setInventory(InventoryData.TYPE_SENJUTSU,extraData.senjutsu);
            }
            Central.main.getMainChar().Add_Dbchar_Senjutsu(Central.main.getMainChar().senjutsu);
            if(extraData.senjutsu_system)
            {
               Central.main.senjutsuSystem = extraData.senjutsu_system;
            }
            Central.main.getMainChar().Add_Dbchar_Bloodline(Central.main.getMainChar().bloodline);
            Central.main.getMainChar().invite_accepted = extraData.invite_accepted;
            Central.main.getMainChar().veteran_return_fk_accepted = extraData.veteran_return_fk_accepted;
            if(extraData.friendship_kunai)
            {
               Central.main.friendship_kunai = extraData.friendship_kunai;
            }
            if(extraData.friend_accept_reward)
            {
               Central.main.friend_accepted_reward = extraData.friend_accept_reward as Array;
            }
            if(extraData.total_friend_accepted)
            {
               Central.main.friend_accepted = extraData.total_friend_accepted;
            }
            if(extraData.new_account_reward)
            {
               Central.main.new_account_reward = extraData.new_account_reward;
            }
            if(extraData.lny_2012_cake)
            {
               Central.main.cny_cake = extraData.lny_2012_cake;
            }
            if(extraData.lny_2012_cake_added)
            {
               Central.main.cny_cake_added = extraData.lny_2012_cake_added;
            }
            if(extraData.premium_daily_token)
            {
               Central.main.premium_daily_token = extraData.premium_daily_token;
            }
            if(extraData.premium_claim_skill_set)
            {
               Central.main.premium_claim_skill_set = extraData.premium_claim_skill_set;
            }
            if(extraData.premium_claim_level)
            {
               Central.main.premium_claim_level = extraData.premium_claim_level;
            }
            rouletteAllowed = extraData.roulette_allowed;
            if(rouletteAllowed)
            {
               Central.main.proc.isShowRoulette = true;
            }
            extraDataString = pvpRecordStr + "," + trainingSkillStr + "," + petsStr + "," + String(extraData.consecutive_days) + "," + (!!extraData.roulette_allowed?"1":"0") + "," + (!!extraData.is_fan?"1":"0");
            if(Central.main.getHash(extraDataString) != extraData.extra_data_hash)
            {
               Central.main.onError();
               return false;
            }
            newMail = extraData.new_mail;
            if(newMail)
            {
               Central.main.proc.newMail = true;
            }
            Central.main.currMail = -1;
            Central.main.newsfeed_material_posted = extraData.newsfeed_material_posted;
            Central.main.newsfeed_easter_2014_posted = extraData.newsfeed_easter_2014_posted;
            if(extraData.character_create_date != "")
            {
               Central.main.char_crate_date = extraData.character_create_date;
               Central.main.charCreateDate = extraData.character_create_date.replace("-","").replace("-","").replace(" ","").replace(":","").replace(":","");
            }
            if(extraData.remaining_skill)
            {
               Central.main.paymentpackage_remain_1 = extraData.remaining_skill;
            }
            if(extraData.reaming_pet)
            {
               Central.main.paymentpackage_remain_2 = extraData.reaming_pet;
            }
            if(extraData.get_hunting_passport)
            {
               Central.main.GetHuntingPassport = extraData.get_hunting_passport;
            }
            if(extraData.DailyReward)
            {
               Central.main.isShowDailyLogin = extraData.DailyReward.allow_to_claim;
            }
            if(extraData.DailyReward)
            {
               Central.main.dailyLogin = extraData.DailyReward.allow_to_claim;
            }
            if(extraData.DailyReward)
            {
               Central.main.DailyLoginResponse = extraData.DailyReward;
            }
            if(extraData.request_list_length)
            {
               Central.main.request_list_length = extraData.request_list_length;
            }
            if(extraData.free_roulette_times)
            {
               Central.main.dailyRoulette_remainTime = extraData.free_roulette_times;
               Central.main.currScartchCard = extraData.free_roulette_times;
            }
            else
            {
               Central.main.currScartchCard = -1;
            }
            if(extraData.dailygift_gift_list)
            {
               Central.main.popup_SendGiftList = extraData.dailygift_gift_list;
            }
            if(extraData.dailygift_request_limit)
            {
               Central.main.popup_SendGift_Remain_Time = extraData.dailygift_request_limit;
            }
            if(extraData.promotion)
            {
               Central.main.free_promotion = extraData.promotion;
            }
            if(extraData.promo_expired)
            {
               Central.main.free_promotion_left_time = extraData.promo_expired;
            }
            if(extraData.daily_login)
            {
               Central.main.daily_login = extraData.daily_login;
            }
            if(extraData.tutorial_expiry_item)
            {
               Central.main.showExpiryTutorial = extraData.tutorial_expiry_item;
            }
            if(extraData.option_data && extraData.option_data.music_index)
            {
               Central.main.currentMusicIndex = extraData.option_data.music_index;
            }
            if(extraData.option_data && extraData.option_data.music_volume)
            {
               Central.main.mixer.setVolume(extraData.option_data.music_volume);
            }
            if(extraData.option_data && extraData.option_data.sound_on)
            {
               Central.main.setAllSoundEffectVolume(extraData.option_data.sound_on);
            }
            if(extraData.lucky_spin_consecutive_day)
            {
               Central.main.currentLoginDay = extraData.lucky_spin_consecutive_day;
            }
            if(extraData.lucky_spin_remaining_spin)
            {
               Central.main.spinChance = extraData.lucky_spin_remaining_spin;
            }
            if(extraData.lucky_spin_show_wheel)
            {
               Central.main.showDailyRoulette = extraData.lucky_spin_show_wheel;
            }
            if(extraData.lucky_spin_multiplier)
            {
               Central.main.dailyRouletteMultiplyArr = extraData.lucky_spin_multiplier;
            }
            if(extraData.is_hard_mode_locked)
            {
               Central.main.lv80examHackerLockHardMode = extraData.is_hard_mode_locked;
            }
            if(extraData.event_daily_login)
            {
               Central.main.DailyLoginEvent = extraData.event_daily_login.daily_login;
               Central.main.DailyLoginEventReward = extraData.event_daily_login.reward;
            }
            if(extraData.event_gift_bag)
            {
               Central.main.GiftBagEvent = extraData.event_gift_bag;
            }
            if(extraData.new_clan_promote)
            {
               if(extraData.new_clan_promote.clan_status)
               {
                  Central.main.ClanStatus = extraData.new_clan_promote.clan_status;
               }
               if(extraData.new_clan_promote.ad_page_max)
               {
                  Central.main.adPageMax = extraData.new_clan_promote.ad_page_max;
               }
            }
            if(extraData.clan_id)
            {
               Central.main.charClanID = extraData.clan_id;
            }
            if(extraData.popup_arr)
            {
               Central.main.ingamePopupBigNewsArr = extraData.popup_arr;
            }
            else
            {
               Central.main.showIngameNotice = false;
            }
            if(extraData.layout)
            {
               Central.main.ingamepopupLayoutArr = extraData.layout;
            }
            else
            {
               Central.main.showIngameNotice = false;
            }
            if(extraData.lucky_draw_case)
            {
               Central.main.showLuckyPuzzleStatus = extraData.lucky_draw_case;
            }
            if(extraData.level_80_exam_reward_list_read)
            {
               Central.main.readRewardList = extraData.level_80_exam_reward_list_read;
            }
            if(extraData.se_day_count_open)
            {
               Central.main.senninExamCountdownStart = extraData.se_day_count_open;
            }
            if(extraData.se_end_date !== undefined)
            {
               Central.main.senninDayLeft = extraData.se_end_date;
            }
            if(extraData.se_end_date_notice)
            {
               Central.main.sennin_notice = extraData.se_end_date_notice;
            }
            if(extraData.lucky_spin_consecutive_day)
            {
               Central.main.currentLoginDay = extraData.lucky_spin_consecutive_day;
            }
            if(extraData.lucky_spin_remaining_spin)
            {
               Central.main.spinChance = extraData.lucky_spin_remaining_spin;
            }
            if(extraData.lucky_spin_show_wheel)
            {
               Central.main.showDailyRoulette = extraData.lucky_spin_show_wheel;
            }
            if(extraData.lucky_spin_multiplier)
            {
               Central.main.dailyRouletteMultiplyArr = extraData.lucky_spin_multiplier;
            }
            Central.main.pvpinvite = extraData.pvp_invite;
            if(extraData.football_2016_claim != null)
            {
               Central.main.WC2016ClaimReward = extraData.football_2016_claim;
            }
            Central.main.requestData = [];
            if(extraData.requests)
            {
               for(i = 0; i < extraData.requests.length; i++)
               {
                  Central.main.requestData.push(extraData.requests[i]);
               }
               Central.main.currRequest = extraData.requests.length;
            }
            else
            {
               Central.main.currRequest = -1;
            }
            Central.main.datetime = extraData.date;
            Central.main.dayleft = int(extraData.sje_end_date);
            Central.main.sje_notice = int(extraData.sje_end_date_notice);
            if(extraData.adsArr)
            {
               Central.main.adsArr = extraData.adsArr as Array;
            }
            if(extraData.newsArr)
            {
               Central.main.newsArr = extraData.newsArr as Array;
            }
            Central.main.newsId = extraData.newsId;
            if(extraData.isGraphic != null)
            {
               Central.main.isGraphic = extraData.isGraphic;
            }
            if(extraData.achievement)
            {
               Central.main.getMainChar().achievement = extraData.achievement as Array;
               for(i = 0; i < Central.main.getMainChar().achievement.length; i++)
               {
                  Central.main.getMainChar().achievement[i] = int(Central.main.getMainChar().achievement[i]);
               }
            }
            if(extraData.achievement_point != null)
            {
               Central.main.getMainChar().achievementPoint = extraData.achievement_point;
            }
            if(extraData.recent_achievement)
            {
               Central.main.getMainChar().recentAchievement = extraData.recent_achievement as Array;
               for(i = 0; i < Central.main.getMainChar().recentAchievement.length; i++)
               {
                  Central.main.getMainChar().recentAchievement[i] = int(Central.main.getMainChar().recentAchievement[i]);
               }
            }
            if(extraData.statistic_battle)
            {
               Central.main.getMainChar().statisticBattle = extraData.statistic_battle as Object;
            }
            if(extraData.char_statistic)
            {
               Central.main.getMainChar().statisticChar = extraData.char_statistic as Object;
            }
            if(extraData.minik_xmas_gift)
            {
               Main.minik_xmas_gift = String(extraData.minik_xmas_gift);
            }
            else
            {
               Main.minik_xmas_gift = null;
            }
            if(extraData.map_key != null)
            {
               Central.main.mapKey = int(extraData.map_key.charAt(0));
               Central.main.mapValue = int(extraData.map_key.charAt(1));
            }
            if(extraData.prestige)
            {
               Central.main.clanPrestige = parseInt(extraData.prestige);
            }
            if(extraData.all_event_login_data)
            {
               Central.main.dailyDragonHuntObject = extraData.all_event_login_data;
            }
            if(extraData.anni5th_tutorial_need_display)
            {
               Central.main.needAnni5thTutorial = extraData.anni5th_tutorial_need_display;
            }
            if(extraData.double_exp)
            {
               Central.main.doubleXPArr = extraData.double_exp;
            }
            Central.main.extraData = extraData;
            if(extraData.dragon_pet_christmas)
            {
               Central.main.dragonPetChristmas = extraData.dragon_pet_christmas;
            }
            else
            {
               Central.main.dragonPetChristmas = 0;
            }
            if(extraData.xmas2014_tutorial_need_display)
            {
               Central.main.xmasTutorialNeedDisplay = extraData.xmas2014_tutorial_need_display;
            }
            else
            {
               Central.main.xmasTutorialNeedDisplay = 0;
            }
            if(extraData.christmas_2014_special_reward)
            {
               Central.main.xmas2014SpecailReward = extraData.christmas_2014_special_reward;
            }
            if(extraData.new_year_2015_clothes)
            {
               Central.main.claimNewYear2015Cloth = true;
            }
            if(extraData.once_gift)
            {
               Central.main.onceGift = extraData.once_gift;
               Central.main.onceGiftLeft = extraData.once_gift.length;
            }
            return true;
         }
         catch(e:Error)
         {
            Out.error(this,"parseCharacterData::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         return false;
      }
      
      public function submitSkillTrainingError(str:String) : void
      {
         var charId:uint = 0;
         if(Central.main.getMainChar())
         {
            if(Central.main.getMainChar().getDBChar())
            {
               charId = Central.main.getMainChar().getDBChar().character_id;
            }
         }
         Central.main.amfClient.service("ReportService.submitSkillTrainingError",[Account.getAccountSessionKey(),charId,str,Capabilities.version,Capabilities.playerType,Capabilities.os,Data.BUILD_NO],this.onSubmitLogDumpResult);
      }
      
      private function onSubmitLogDumpResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
      }
      
      public function parsePetData(pd:Object, hashCheck:Boolean = false) : DBCharacter
      {
         var dbc:DBCharacter = new DBCharacter();
         dbc[DBCharacterData.ID] = pd.id;
         dbc[DBCharacterData.NAME] = pd.name;
         dbc[DBCharacterData.LEVEL] = pd.level;
         dbc[DBCharacterData.XP] = pd.xp;
         if(pd.skills)
         {
            dbc[DBCharacterData.SKILLS] = pd.skills;
         }
         else
         {
            dbc[DBCharacterData.SKILLS] = [0];
         }
         var petStr:String = String(pd.id) + "," + pd.swfName + "," + pd.clsName + "," + pd.level + "," + pd.xp;
         if(hashCheck)
         {
            if(Central.main.getHash(petStr) != pd.hash)
            {
               Central.main.onError();
               return null;
            }
         }
         return dbc;
      }
      
      public function parseRawCharacter(rawCharacter:Object, skipHashCheck:Boolean = false, isMainChar:Boolean = false) : DBCharacter
      {
         var dbChar:DBCharacter = null;
         var skillId:String = null;
         var tempSkills:Array = null;
         var bodySet:Array = null;
         var tempBodySet:Array = null;
         var bodySetId:String = null;
         var item:Array = null;
         var tempItem:Array = null;
         var essence:Array = null;
         var tempEssence:Array = null;
         var materialData:Array = null;
         var materialArr:Array = null;
         var materialTemp:Array = null;
         var j:int = 0;
         var currencyData:Array = null;
         var currencyArr:Array = null;
         var currencyTemp:Array = null;
         var hashStr:String = null;
         var remove_inv_arr:Array = null;
         var add_inv_arr:Array = null;
         var equip_arr:Array = null;
         var remove_equip_arr:Array = null;
         var current_expiry_arr:Array = null;
         var expired_pet_arr:Array = null;
         var hair:Array = null;
         var tempHair:Array = null;
         var weapon:Array = null;
         var tempWeapon:Array = null;
         var weaponId:String = null;
         var backitem:Array = null;
         var tempbackitem:Array = null;
         var backitemId:String = null;
         var accessory:Array = null;
         var tempaccessory:Array = null;
         var accessoryId:String = null;
         var tradingItem:Array = null;
         var temptradingItem:Array = null;
         var tradeId:String = null;
         var learnedSkills:Array = null;
         var tempLearnedSkills:Array = null;
         var missions:Object = null;
         var tempMissions:Array = null;
         var _mission:Array = null;
         var daily:Object = null;
         var magatamaData:Object = null;
         var magatamaArr:Array = null;
         var magatamaTemp:Array = null;
         var activeNpcArr:Array = null;
         var character_pre_hash:String = null;
         var i:uint = 0;
         dbChar = new DBCharacter();
         try
         {
            dbChar[DBCharacterData.ID] = rawCharacter.character_id;
            dbChar[DBCharacterData.NAME] = rawCharacter.character_name;
            dbChar[DBCharacterData.LEVEL] = rawCharacter.character_level;
            dbChar[DBCharacterData.XP] = rawCharacter.character_xp;
            dbChar[DBCharacterData.RANK] = rawCharacter.character_rank;
            dbChar[DBCharacterData.GOLD] = rawCharacter.character_gold;
            dbChar[DBCharacterData.ARMOR] = rawCharacter.character_armor;
            dbChar[DBCharacterData.INVSLOT] = rawCharacter.character_inv_slots;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: get inventory data error :: " + e.getStackTrace());
         }
         var skills:Array = [];
         var senjutsus:Array = [];
         try
         {
            tempSkills = String(rawCharacter.character_equipped_skills).split(",");
            for(i = 0; i < tempSkills.length; i++)
            {
               if(tempSkills[i])
               {
                  if(tempSkills[i] != "" && int(tempSkills[i]) < 3000)
                  {
                     skillId = "skill" + tempSkills[i];
                     skills.push(skillId);
                  }
                  else if(tempSkills[i] != "" && int(tempSkills[i]) >= 3000)
                  {
                     skillId = "senjutsu_skill" + tempSkills[i];
                     senjutsus.push(skillId);
                  }
               }
            }
            dbChar[DBCharacterData.SKILLS] = skills;
            dbChar[DBCharacterData.SENJUTSU] = senjutsus;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: equipped skill error :: " + e.getStackTrace());
            dbChar[DBCharacterData.SKILLS] = [];
            dbChar[DBCharacterData.SENJUTSU] = [];
         }
         try
         {
            if(rawCharacter.character_equipped_weapon)
            {
               dbChar[DBCharacterData.BODY_PARTS]["weapon"] = "wpn" + rawCharacter.character_equipped_weapon;
            }
            else
            {
               dbChar[DBCharacterData.BODY_PARTS]["weapon"] = Data.DEFAULT_WEAPON;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: equipped weapon error :: " + e.getStackTrace());
            dbChar[DBCharacterData.BODY_PARTS]["weapon"] = Data.DEFAULT_WEAPON;
         }
         try
         {
            if(rawCharacter.character_equipped_back_item)
            {
               dbChar[DBCharacterData.BODY_PARTS]["back"] = "back" + rawCharacter.character_equipped_back_item;
            }
            else
            {
               dbChar[DBCharacterData.BODY_PARTS]["back"] = Data.DEFAULT_BACK_ITEM;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: equipped back item error :: " + e.getStackTrace());
            dbChar[DBCharacterData.BODY_PARTS]["back"] = Data.DEFAULT_BACK_ITEM;
         }
         try
         {
            if(rawCharacter.character_equipped_accessory)
            {
               dbChar[DBCharacterData.BODY_PARTS]["accessory"] = "acsy" + rawCharacter.character_equipped_accessory;
            }
            else
            {
               dbChar[DBCharacterData.BODY_PARTS]["accessory"] = Data.DEFAULT_ACCESSORY;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: equipped accessory error :: " + e.getStackTrace());
            dbChar[DBCharacterData.BODY_PARTS]["accessory"] = Data.DEFAULT_ACCESSORY;
         }
         try
         {
            if(rawCharacter.character_equipped_body_set)
            {
               dbChar[DBCharacterData.BODY_SET] = "set" + rawCharacter.character_equipped_body_set;
               bodySet = [];
               tempBodySet = String(rawCharacter.character_body_set).split(",");
               for(i = 0; i < tempBodySet.length; i++)
               {
                  if(tempBodySet[i])
                  {
                     if(tempBodySet[i] != "")
                     {
                        bodySetId = "set" + tempBodySet[i];
                        bodySet.push(bodySetId);
                     }
                  }
               }
               dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_BODY_SET] = bodySet;
            }
            else
            {
               dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_BODY_SET] = [];
            }
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: clothing error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_BODY_SET] = [];
         }
         try
         {
            item = [];
            tempItem = String(rawCharacter.character_item).split(",");
            for(i = 0; i < tempItem.length; i++)
            {
               if(tempItem[i] != "")
               {
                  item.push("item" + tempItem[i]);
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ITEM] = item;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory item error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ITEM] = [];
         }
         try
         {
            essence = [];
            tempEssence = String(rawCharacter.character_ninja_essence).split(",");
            for(i = 0; i < tempEssence.length; i++)
            {
               if(tempEssence[i] != "")
               {
                  essence.push("item" + tempEssence[i]);
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ESSENCE] = essence;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory item error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ESSENCE] = [];
         }
         try
         {
            materialData = [];
            if(rawCharacter.character_material)
            {
               if(String(rawCharacter.character_material).length > 0)
               {
                  materialArr = String(rawCharacter.character_material).split(",");
                  for(i = 0; i < materialArr.length; i++)
                  {
                     if(materialArr[i])
                     {
                        if(String(materialArr[i]).indexOf(":") >= 0)
                        {
                           materialTemp = String(materialArr[i]).split(":");
                           for(j = 0; j < int(materialTemp[1]); j++)
                           {
                              materialData.push("item" + materialTemp[0]);
                           }
                        }
                     }
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MATERIAL] = materialData;
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: magatama error");
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MATERIAL] = [];
         }
         try
         {
            currencyData = [];
            if(rawCharacter.character_common_currency)
            {
               if(String(rawCharacter.character_common_currency).length > 0)
               {
                  currencyArr = String(rawCharacter.character_common_currency).split(",");
                  for(i = 0; i < currencyArr.length; i++)
                  {
                     if(currencyArr[i])
                     {
                        if(String(currencyArr[i]).indexOf(":") >= 0)
                        {
                           currencyTemp = String(currencyArr[i]).split(":");
                           for(j = 0; j < int(currencyTemp[1]); j++)
                           {
                              currencyData.push("item" + currencyTemp[0]);
                           }
                        }
                     }
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_CURRENCY] = currencyData;
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: currenty error");
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_CURRENCY] = [];
         }
         if(Central.main.Features.FEATURE_EXPIRY_ITEM && isMainChar)
         {
            if(rawCharacter.expiry_data.remove_inv_arr)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_INV_ARR] = rawCharacter.expiry_data.remove_inv_arr;
               remove_inv_arr = rawCharacter.expiry_data.remove_inv_arr;
            }
            if(rawCharacter.expiry_data.add_inv_arr)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_ADD_INV_ARR] = rawCharacter.expiry_data.add_inv_arr;
               add_inv_arr = rawCharacter.expiry_data.add_inv_arr;
            }
            if(rawCharacter.expiry_data.equip_arr)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_EQUIP_ARR] = rawCharacter.expiry_data.equip_arr;
               equip_arr = rawCharacter.expiry_data.equip_arr;
            }
            if(rawCharacter.expiry_data.remove_equip_arr)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_REMOVE_EQUIP_ARR] = rawCharacter.expiry_data.remove_equip_arr;
               remove_equip_arr = rawCharacter.expiry_data.remove_equip_arr;
            }
            if(rawCharacter.expiry_data.current_expiry_arr)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR] = rawCharacter.expiry_data.current_expiry_arr;
               current_expiry_arr = rawCharacter.expiry_data.current_expiry_arr;
            }
            if(rawCharacter.expiry_data.expiry_pet_data)
            {
               dbChar[DBCharacterData.EXPIRY_ITEM_EXPIRED_PET_ARR] = rawCharacter.expiry_data.expiry_pet_data;
               expired_pet_arr = rawCharacter.expiry_data.expiry_pet_data;
            }
            if(remove_inv_arr.length > 0 || add_inv_arr.length > 0 || equip_arr.length > 0 || remove_equip_arr.length > 0)
            {
               Central.main.ItemExpiried = true;
            }
            hashStr = remove_inv_arr.join(",") + add_inv_arr.join(",") + equip_arr.join(",") + current_expiry_arr.join(",") + remove_equip_arr.join(",");
            if(Central.main.getHash(String(hashStr)) != rawCharacter.expiry_data.expiry_hash)
            {
               Out.debug(this,"parseRawCharacter :: expiry item error");
               Central.main.onError("1300","");
               return null;
            }
         }
         try
         {
            hair = [];
            if(rawCharacter.character_inv_hair)
            {
               tempHair = String(rawCharacter.character_inv_hair).split(",");
            }
            else
            {
               tempHair = [];
            }
            for(i = 0; i < tempHair.length; i++)
            {
               if(tempHair[i] != "")
               {
                  hair.push("hair" + tempHair[i]);
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_HAIR] = hair;
         }
         catch(e:Error)
         {
            Out.error(this,"paraseRawCharacter :: inventory item error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_HAIR] = [];
         }
         try
         {
            weapon = [];
            tempWeapon = String(rawCharacter.character_weapon).split(",");
            for(i = 0; i < tempWeapon.length; i++)
            {
               if(tempWeapon[i])
               {
                  if(tempWeapon[i] != "")
                  {
                     weaponId = "wpn" + tempWeapon[i];
                     weapon.push(weaponId);
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_WEAPON] = weapon;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory weapon error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_WEAPON] = [];
         }
         try
         {
            backitem = [];
            tempbackitem = String(rawCharacter.character_back_item).split(",");
            for(i = 0; i < tempbackitem.length; i++)
            {
               if(tempbackitem[i])
               {
                  if(tempbackitem[i] != "")
                  {
                     backitemId = "back" + tempbackitem[i];
                     backitem.push(backitemId);
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_BACK_ITEM] = backitem;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory weapon error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_BACK_ITEM] = [];
         }
         try
         {
            accessory = [];
            tempaccessory = String(rawCharacter.character_accessory).split(",");
            for(i = 0; i < tempaccessory.length; i++)
            {
               if(tempaccessory[i])
               {
                  if(tempaccessory[i] != "")
                  {
                     accessoryId = "acsy" + tempaccessory[i];
                     accessory.push(accessoryId);
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ACCESSORY] = accessory;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory accessory error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_ACCESSORY] = [];
         }
         try
         {
            tradingItem = [];
            temptradingItem = String(rawCharacter.character_trade_item).split(",");
            for(i = 0; i < temptradingItem.length; i++)
            {
               if(temptradingItem[i])
               {
                  if(temptradingItem[i] != "")
                  {
                     tradeId = temptradingItem[i];
                     tradingItem.push(tradeId);
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_TRADING] = tradingItem;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: inventory trading item error :: " + e.getStackTrace());
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_TRADING] = [];
         }
         try
         {
            learnedSkills = [];
            tempLearnedSkills = String(rawCharacter.character_skill).split(",");
            for(i = 0; i < tempLearnedSkills.length; i++)
            {
               if(tempLearnedSkills[i])
               {
                  if(tempLearnedSkills[i] != "")
                  {
                     skillId = "skill" + tempLearnedSkills[i];
                     learnedSkills.push(skillId);
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_SKILL] = learnedSkills;
         }
         catch(e:Error)
         {
            Out.error(this,"parseRawCharacter :: learned skill error");
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_SKILL] = [];
         }
         try
         {
            dbChar[DBCharacterData.HAIR_COLOR] = Data.getHairColorArr()[rawCharacter.character_hair_color];
            dbChar[DBCharacterData.GENDER] = rawCharacter.character_gender;
            dbChar[DBCharacterData.SKIN_COLOR] = Data.getSkinColorArr()[rawCharacter.character_skin_color];
            dbChar[DBCharacterData.FACE] = "face_" + rawCharacter.character_face;
            dbChar[DBCharacterData.HAIR] = "hair_" + rawCharacter.character_hair;
            dbChar[DBCharacterData.FIRE] = rawCharacter.character_fire;
            dbChar[DBCharacterData.WATER] = rawCharacter.character_water;
            dbChar[DBCharacterData.WIND] = rawCharacter.character_wind;
            dbChar[DBCharacterData.EARTH] = rawCharacter.character_earth;
            dbChar[DBCharacterData.LIGHTNING] = rawCharacter.character_lightning;
            dbChar[DBCharacterData.TAIJUTSU] = rawCharacter.character_taijutsu;
            dbChar[DBCharacterData.GENJUTSU] = rawCharacter.character_genjutsu;
            dbChar[DBCharacterData.SUMMON] = rawCharacter.character_summon;
            dbChar[DBCharacterData.CONTROL] = rawCharacter.character_control;
            dbChar[DBCharacterData.BLOODLINE] = rawCharacter.character_bloodline;
            dbChar[DBCharacterData.BLOODLINE_SKILL] = rawCharacter.bloodline;
            dbChar[DBCharacterData.SENJUTSU_SS] = rawCharacter.senjutsu_spirit;
            if(rawCharacter.senjutsu)
            {
               dbChar[DBCharacterData.SENJUTSU_SKILL] = rawCharacter.senjutsu;
            }
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: other data error");
         }
         try
         {
            missions = {};
            tempMissions = String(rawCharacter.character_mission).split(",");
            for(i = 0; i < tempMissions.length; i++)
            {
               if(tempMissions[i] != "")
               {
                  _mission = String(tempMissions[i]).split(":");
                  missions["msn" + _mission[0]] = {
                     "success":int(_mission[1]),
                     "fail":int(_mission[2]),
                     "time":int(_mission[3])
                  };
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MISSION] = missions;
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: mission data error");
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MISSION] = {};
         }
         try
         {
            if(rawCharacter.daily)
            {
               daily = rawCharacter.daily as Object;
               daily.amount = int(daily.amount);
               daily.total = int(daily.total);
               dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_DAILY_TASK] = daily;
            }
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: daily task error");
         }
         try
         {
            if(rawCharacter.character_magatama)
            {
               if(String(rawCharacter.character_magatama).length > 0)
               {
                  magatamaData = {};
                  magatamaArr = String(rawCharacter.character_magatama).split(",");
                  for(i = 0; i < magatamaArr.length; i++)
                  {
                     if(magatamaArr[i])
                     {
                        if(String(magatamaArr[i]).indexOf(":") >= 0)
                        {
                           magatamaTemp = String(magatamaArr[i]).split(":");
                           magatamaData[int(magatamaTemp[0])] = int(magatamaTemp[1]);
                        }
                     }
                  }
               }
            }
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MAGATAMA] = magatamaData;
         }
         catch(e:Error)
         {
            Out.debug(this,"parseRawCharacter :: magatama error");
            dbChar[DBCharacterData.INVENTORY][InventoryData.TYPE_MAGATAMA] = null;
         }
         try
         {
            if(rawCharacter.character_npc)
            {
               if(String(rawCharacter.character_npc).length > 0)
               {
                  Central.main.activeNpc = [];
                  activeNpcArr = String(rawCharacter.character_npc).split(",");
                  for(i = 0; i < activeNpcArr.length; )
                  {
                     if(Central.main.activeNpc.length < 2)
                     {
                        Central.main.activeNpc.push(NPCData.npcData[activeNpcArr[i]]);
                        i++;
                        continue;
                     }
                     break;
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace(e);
            Out.debug(this,"parseRawCharacter :: NPC error");
         }
         var character_str:String = String(rawCharacter.character_id) + dbChar[DBCharacterData.LEVEL] + dbChar[DBCharacterData.XP] + dbChar[DBCharacterData.RANK] + rawCharacter.character_gold + rawCharacter.character_armor + rawCharacter.character_equipped_skills + rawCharacter.character_equipped_weapon + rawCharacter.character_equipped_body_set + rawCharacter.character_body_set + rawCharacter.character_item + rawCharacter.character_weapon + rawCharacter.character_skill + rawCharacter.character_magatama + rawCharacter.character_npc + rawCharacter.character_equipped_back_item + rawCharacter.character_back_item + rawCharacter.character_equipped_accessory + rawCharacter.character_accessory + rawCharacter.character_hair_color + rawCharacter.character_gender + rawCharacter.character_skin_color + rawCharacter.character_face + rawCharacter.character_hair + dbChar[DBCharacterData.FIRE] + dbChar[DBCharacterData.WATER] + dbChar[DBCharacterData.WIND] + dbChar[DBCharacterData.EARTH] + dbChar[DBCharacterData.LIGHTNING] + rawCharacter.character_taijutsu + rawCharacter.character_genjutsu + rawCharacter.character_summon + rawCharacter.character_control + rawCharacter.character_bloodline + rawCharacter.character_mission + rawCharacter.character_ninja_essence + rawCharacter.character_material + rawCharacter.character_inv_hair;
         if(rawCharacter.daily)
         {
            character_str = character_str + (String(daily.total) + daily.amount + daily.completeTime + daily.type);
         }
         if(!skipHashCheck)
         {
            if(Central.main.getHash(character_str) != rawCharacter.character_hash)
            {
               Out.error(this,"Character Data Error");
               Central.main.onError();
               return null;
            }
         }
         if(Central.main)
         {
            character_pre_hash = String(rawCharacter.character_level) + "," + String(rawCharacter.character_xp) + "," + String(rawCharacter.character_rank) + "," + String(rawCharacter.character_equipped_skills) + "," + String(rawCharacter.character_fire) + "," + String(rawCharacter.character_water) + "," + String(rawCharacter.character_earth) + "," + String(rawCharacter.character_lightning);
            if(rawCharacter.character_pre_hash != Central.main.getHash(character_pre_hash))
            {
               Out.error(this,"Character Data Error");
               Central.main.onError();
               return null;
            }
         }
         return dbChar;
      }
      
      public function parseVersionData(swfVersions:Array) : void
      {
         var i:uint = 0;
         if(swfVersions)
         {
            for(i = 0; i < swfVersions.length; i++)
            {
               AppData[swfVersions[i].type + "Ver"] = String(swfVersions[i].version);
            }
         }
      }
      
      public function parseHairData(hairData:Array) : void
      {
         Central.main.HAIR_DATA = new HashMap();
         for(var i:uint = 0; i < hairData.length; i++)
         {
            Central.main.HAIR_DATA.insert(hairData[i].id,hairData[i]);
         }
      }
   }
}

class SingletonBlocker
{
    
   
   function SingletonBlocker()
   {
      super();
   }
}
