package ninjasaga
{
   import ninjasaga.base.CharacterBattle;
   import ninjasaga.objects.Pet;
   import flash.geom.Point;
   import flash.display.MovieClip;
   import bitemycode.security.SecureNumber;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.dbclass.DBCharacter;
   import com.utils.Out;
   import flash.display.Sprite;
   import com.utils.GF;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.MissionData;
   import ninjasaga.data.Data;
   import ninjasaga.data.StaticVariables;
   import com.utils.Sha1Encrypt;
   import ninjasaga.data.InventoryData;
   import de.polygonal.ds.HashMap;
   import ninjasaga.data.AMFData;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.SenjutsuData;
   import ninjasaga.data.Formula;
   import ninjasaga.data.RankData;
   import ninjasaga.data.DailyTaskData;
   import flash.events.Event;
   import ninjasaga.data.WeaponData;
   import ninjasaga.data.PositionType;
   
   public class Character extends CharacterBattle
   {
       
      
      private var verifyTrainingPoint_CB:Function;
      
      private var _trainingSkill:Object;
      
      private var _trainingFdSkill:Object;
      
      private var verifyTrainingSkill_CB:Function;
      
      private var verifyTrainingFdSkill_CB:Function;
      
      public var achievement:Array;
      
      public var achievementPoint:int;
      
      public var recentAchievement:Array;
      
      public var statisticBattle:Object;
      
      public var statisticChar:Object;
      
      private var _pvpRecord:Object;
      
      private var _pet:Pet;
      
      private var _standbyPet:Array;
      
      private const runSpeed:uint = 10;
      
      private var onMove:Boolean = false;
      
      private var origPoint:Point;
      
      private var targetPoint:Point;
      
      private var walkDuration:uint = 0;
      
      private var xStep:uint = 0;
      
      private var yStep:uint = 0;
      
      private var hitTestObjectArr:Array;
      
      private var shadow:MovieClip;
      
      public var itemUsedInBattle:Array;
      
      private var xpGainedInMission:SecureNumber;
      
      private var goldGainedInMission:SecureNumber;
      
      private var itemGainedInMission:Array;
      
      private var skillGainedInMission:Array;
      
      public var consecutiveDays:int = 1;
      
      public var isFan:Boolean = false;
      
      public var bloodline:Array;
      
      public var senjutsu:Array;
      
      public var datafileHack:int = 0;
      
      public var Ann_MissionID:int = 0;
      
      public var bp_mission_id:Array;
      
      public var invite_accepted:int = 0;
      
      public var veteran_return_fk_accepted:int = 0;
      
      private var rewardItems:Array;
      
      public var isLevelUp:Boolean = false;
      
      public function Character(dbChar:DBCharacter)
      {
         _standbyPet = [];
         origPoint = new Point(0,0);
         targetPoint = new Point(0,0);
         hitTestObjectArr = new Array();
         itemUsedInBattle = new Array();
         xpGainedInMission = new SecureNumber();
         goldGainedInMission = new SecureNumber();
         itemGainedInMission = [];
         skillGainedInMission = [];
         bloodline = [];
         senjutsu = [];
         bp_mission_id = [];
         rewardItems = [];
         super();
         this.type = this.TYPE_CHARACTER;
         this.dbChar = dbChar;
         if(this.getData(DBCharacterData.ID) == 104)
         {
         }
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         if(Main.coreData.ADMIN_CHARACTERS.indexOf(int(this.getData(DBCharacterData.ID))) >= 0)
         {
            this.addInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         else if(this.dbChar[DBCharacterData.SKILLS].indexOf("skill91") >= 0)
         {
            this.dbChar[DBCharacterData.SKILLS] = [];
         }
         if(this.xp <= 0)
         {
            this.clearInventory(InventoryData.TYPE_SKILL);
         }
         if(this.getData(DBCharacterData.RANK) == 1 && this.checkMissionRecord("msn59").success > 0)
         {
            Main.rankup();
            this.updateData(DBCharacterData.RANK,2);
         }
      }
      
      public static function getConstructor() : *
      {
         return Character.prototype.constructor;
      }
      
      override public function setCharMc(_mc:MovieClip) : void
      {
         var i:* = undefined;
         super.setCharMc(_mc);
         if(_mc != null)
         {
            for(i = 0; i < classSkillList.length; i++)
            {
               if(classSkillList[i] != "skill2003")
               {
                  isClassSkillAvailable[i] = true;
               }
            }
         }
      }
      
      public function get databaseCharacter() : *
      {
         return this.dbChar;
      }
      
      public function setActionBase(actionBase:MovieClip) : void
      {
         this.actionBase = actionBase;
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.shadow = this.actionBase["shadow"];
      }
      
      public function setSkillSwf(skillSwf:MovieClip) : void
      {
         this.skillSwfArr.push(skillSwf);
         skillSwf.setActionFinishCB(this.actionFinish_CB);
         skillSwf.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setClassSkillSwf(skillSwf:MovieClip) : void
      {
         this.classSkillSwfArr.push(skillSwf);
         skillSwf.setActionFinishCB(this.actionFinish_CB);
         skillSwf.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setSenjutsuSwf(skillSwf:MovieClip) : void
      {
         this.senjutsuSwfArr.push(skillSwf);
         skillSwf.setActionFinishCB(this.actionFinish_CB);
         skillSwf.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setEquippedSenjutsuList(newEquippedList:Array, _cbFn:Function = null) : void
      {
         dbChar[DBCharacterData.SENJUTSU] = newEquippedList;
         if(_cbFn != null)
         {
            _cbFn();
         }
      }
      
      public function setSenjutsuList(newSenjutsuList:Array, _cbFn:Function = null) : void
      {
         var i:uint = 0;
         var swfToLoad:Array = null;
         var temp_newSenjutsuList:Array = null;
         var skillList:Array = null;
         if(newSenjutsuList != null)
         {
            swfToLoad = new Array();
            if(newSenjutsuList.length == 0)
            {
               this.dbChar.character_senjutsu = newSenjutsuList;
            }
            temp_newSenjutsuList = [];
            for(i = 0; i < newSenjutsuList.length; i++)
            {
               if(Main.SENJUTSU_SKILL_DATA[newSenjutsuList[i]])
               {
                  temp_newSenjutsuList.push(newSenjutsuList[i]);
               }
            }
            this.dbChar.character_senjutsu = temp_newSenjutsuList;
            this.pendingSkills = null;
            skillList = this.getSenjutsuListArr();
            for(i = 0; i < skillList.length; i++)
            {
               if(!Skill.hasSkill(skillList[i]))
               {
                  swfToLoad.push("swf/skills/" + Main.SENJUTSU_SKILL_DATA[skillList[i]].swf_name + ".swf");
               }
            }
            if(swfToLoad.length > 0)
            {
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  this.pendingSkills = swfToLoad;
                  if(_cbFn != null)
                  {
                     _cbFn();
                  }
               }
               else
               {
                  Main.loadSwf(swfToLoad,this.updateSkillSwf,{"cbFn":_cbFn});
               }
            }
            else
            {
               this.updateSkillSwf(null,{"cbFn":_cbFn});
            }
         }
         else
         {
            this.dbChar.character_senjutsu = null;
         }
      }
      
      public function set pvpRecord(data:Object) : void
      {
         this._pvpRecord = data;
      }
      
      public function get pvpRecord() : Object
      {
         return this._pvpRecord;
      }
      
      public function get pet() : Pet
      {
         return this._pet;
      }
      
      public function getPetById(petId:uint) : Pet
      {
         if(this._pet)
         {
            if(this._pet.petId == petId)
            {
               return this._pet;
            }
         }
         for(var i:* = 0; i < this._standbyPet.length; i++)
         {
            if(this._standbyPet[i].petId == petId)
            {
               return this._standbyPet[i];
            }
         }
         return null;
      }
      
      public function initPet(petData:DBCharacter, swfName:String, clsName:String) : void
      {
         this._pet = new Pet(petData,swfName,clsName);
         this._pet.restoreOriginalStatus();
      }
      
      public function removePet(petId:uint = 0) : void
      {
         var i:* = undefined;
         var current_expiry_arr:Array = null;
         var j:int = 0;
         if(petId == 0)
         {
            if(this.pet)
            {
               this._pet = null;
            }
         }
         else
         {
            if(this.pet)
            {
               if(this._pet.petId == petId)
               {
                  this._pet = null;
                  return;
               }
            }
            for(i = 0; i < this._standbyPet.length; i++)
            {
               if(this._standbyPet[i].petId == petId)
               {
                  this._standbyPet.splice(i,1);
                  break;
               }
            }
         }
         if(Central.main.Features.FEATURE_EXPIRY_ITEM)
         {
            current_expiry_arr = Central.main.getMainChar().getData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR);
            for(j = 0; j < current_expiry_arr.length; j++)
            {
               if(String(current_expiry_arr[j]).indexOf("pet_" + String(petId)) >= 0)
               {
                  current_expiry_arr.splice(j,1);
                  Central.main.getMainChar().updateData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR,current_expiry_arr);
                  break;
               }
            }
         }
      }
      
      public function initStandbyPet(petData:DBCharacter, swfName:String, clsName:String) : void
      {
         var pet:* = new Pet(petData,swfName,clsName);
         pet.restoreOriginalStatus();
         this._standbyPet.push(pet);
      }
      
      public function activatePet(petId:uint) : void
      {
         var _tempArray:Array = null;
         this.deactivatePet();
         for(var i:int = 0; i < this._standbyPet.length; i++)
         {
            if(this._standbyPet[i].getPetId() == petId)
            {
               _tempArray = this._standbyPet.splice(i,1);
               this._pet = Pet(_tempArray[0]);
               break;
            }
         }
      }
      
      public function deactivatePet() : void
      {
         if(this._pet)
         {
            this._standbyPet.push(this._pet);
            this.removePet();
         }
      }
      
      public function get pets() : Array
      {
         var pets:Array = [];
         if(this._pet)
         {
            pets = [this._pet];
            pets = pets.concat(this._standbyPet);
            pets.sortOn("petId",Array.NUMERIC);
         }
         else
         {
            pets = this._standbyPet;
            pets.sortOn("petId",Array.NUMERIC);
         }
         return pets;
      }
      
      public function hasPet(clsName:String) : Boolean
      {
         var pets:Array = this.pets;
         for(var i:* = 0; i < pets.length; i++)
         {
            if(pets[i].clsName == clsName)
            {
               return true;
            }
         }
         return false;
      }
      
      public function customizeCharacter() : void
      {
         var i:uint = 0;
         this.customizeFace();
         this.changeBodySet(this.getBodySet());
         this.changeHair(this.getHair());
         this.changeWeapon(this.getWeapon());
         if(this.getBackItem() != "")
         {
            this.changeBackItem(this.getBackItem());
         }
         else
         {
            this.changeBackItem(null);
         }
         this.customizeHairColor();
      }
      
      private function customizeHairColor() : void
      {
         var hairColor:Array = this.getHairColor();
         this.changeHairColor(hairColor);
      }
      
      private function customizeSkinColor() : void
      {
         var skinColor:Number = this.getSkinColor();
         this.changeSkinColor(skinColor);
      }
      
      private function customizeFace() : void
      {
         var i:int = 0;
         try
         {
            this.setupFace(this.actionBase);
            for(i = 0; i < this.skillSwfArr.length; i++)
            {
               this.setupFace(this.skillSwfArr[i]);
            }
            for(i = 0; i < this.bloodlineSwfArr.length; i++)
            {
               this.setupFace(this.bloodlineSwfArr[i]);
            }
            for(i = 0; i < this.senjutsuSwfArr.length; i++)
            {
               this.setupFace(this.senjutsuSwfArr[i]);
            }
            for(i = 0; i < this.secretSwfArr.length; i++)
            {
               this.setupFace(this.secretSwfArr[i]);
            }
            for(i = 0; i < this.classSkillSwfArr.length; i++)
            {
               this.setupFace(this.classSkillSwfArr[i]);
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace error >> " + e.getStackTrace());
         }
      }
      
      private function setupFace(mc:MovieClip) : void
      {
         Central.main.graphicController.setupFace(mc,this.getFace(),this.getSkinColor());
      }
      
      public function cloneCustomization(_skill:MovieClip) : void
      {
         this.setupFace(_skill);
         _skill.setupHair(Item.getItem(this.getHair()),this.getGender() == 1?true:false);
         this.setupBodySet(_skill);
         _skill.changeHairColor(this.getHairColor(),this.getGender() == 0?false:true);
      }
      
      public function cloneHead(_head:MovieClip) : void
      {
         var face:Sprite = null;
         var backHair:MovieClip = null;
         GF.removeAllChild(_head["face"]);
         GF.removeAllChild(_head["hair"]);
         GF.removeAllChild(_head["back_hair"]);
         try
         {
            face = Main.asset.getFace(this.getFace(),this.getSkinColor());
            _head["face"].addChild(face);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: set face error");
         }
         _head["hair"].addChild(Item.getItem(this.getHair()).getAsset("hair"));
         try
         {
            GF.changeColor(_head["hair"].getChildAt(0)["hair_color_1"],this.getHairColor()[0]);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: hair_color_1 error");
         }
         try
         {
            GF.changeColor(_head["hair"].getChildAt(0)["hair_color_2"],this.getHairColor()[1]);
         }
         catch(e:Error)
         {
            Out.error(this,"cloneHead :: hair_color_2 error");
         }
         if(this.getGender() == 1)
         {
            backHair = Item.getItem(this.getHair()).getAsset("back_hair");
            if(backHair != null)
            {
               if(backHair["hair_color_1"] != null)
               {
                  GF.changeColor(backHair["hair_color_1"],this.getHairColor()[0]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#1");
               }
               if(backHair["hair_color_2"] != null)
               {
                  GF.changeColor(backHair["hair_color_2"],this.getHairColor()[1]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#2");
               }
               if(_head["back_hair"] != null)
               {
                  _head["back_hair"].addChild(backHair);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair");
               }
            }
            else
            {
               Out.error(this,"CLONE: back hair doesn\'t exist");
            }
         }
      }
      
      public function cloneStaticFullBody(_body:MovieClip) : void
      {
         var backHair:MovieClip = null;
         this.setupFace(_body);
         var hair:MovieClip = Item.getItem(this.getHair()).getAsset("hair");
         if(hair != null)
         {
            if(hair["hair_color_1"] != null)
            {
               GF.changeColor(hair["hair_color_1"],this.getHairColor()[0]);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair color layer#1");
            }
            if(hair["hair_color_1"] != null)
            {
               GF.changeColor(hair["hair_color_2"],this.getHairColor()[1]);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair color layer#2");
            }
            if(_body["head"]["hair"] != null)
            {
               GF.removeAllChild(_body["head"]["hair"]);
               _body["head"]["hair"].addChild(hair);
            }
            else
            {
               Out.error(this,"CLONE: cannot clone hair");
            }
         }
         else
         {
            Out.error(this,"CLONE: hair doesn\'t exist");
         }
         if(this.getGender() == 1)
         {
            backHair = Item.getItem(this.getHair()).getAsset("back_hair");
            if(backHair != null)
            {
               if(backHair["hair_color_1"] != null)
               {
                  GF.changeColor(backHair["hair_color_1"],this.getHairColor()[0]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#1");
               }
               if(backHair["hair_color_2"] != null)
               {
                  GF.changeColor(backHair["hair_color_2"],this.getHairColor()[1]);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair color layer#2");
               }
               if(_body["back_hair"] != null)
               {
                  GF.removeAllChild(_body["head"]["back_hair"]);
                  _body["back_hair"].addChild(backHair);
               }
               else
               {
                  Out.error(this,"CLONE: cannot clone back hair");
               }
            }
            else
            {
               Out.error(this,"CLONE: back hair doesn\'t exist");
            }
         }
         this.setupBodySet(_body);
         this.setupWeapon(_body);
         if(this.getBackItem() != "")
         {
            this.setupBackItem(_body);
         }
         else
         {
            this.unSetupBackItem(_body);
         }
      }
      
      public function equipCharacter() : void
      {
         var value:Object = null;
         var i:int = 0;
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            Main.getMainChar().restoreOriginalStatus();
            Main.updateMenu();
         }
         var equippedSkillList:Array = this.getSkillListArr();
         var newEquippedSkillList:Array = [];
         for each(value in equippedSkillList)
         {
            newEquippedSkillList.push(value);
         }
         if(this.dbChar.character_senjutsu.length > 0)
         {
            for(i = 0; i < this.dbChar.character_senjutsu.length; i++)
            {
               newEquippedSkillList.push(this.dbChar.character_senjutsu[i].replace("senjutsu_",""));
            }
         }
         Main.amfClient.service("CharacterDAO.equipCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.getBodySet(),this.getWeapon(),newEquippedSkillList,this.getBackItem(),this.getAccessory()],Main.onAmfResult);
      }
      
      public function updateDB(xp:uint, gold:uint, usedItem:Array, mission_id:String, failed:int, source:Object, stateHash:String = "") : void
      {
         var seqHash:String = null;
         var paramHash:String = null;
         var tempReward:Object = null;
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var allowedSource:Array = [Mission,Battle,Character];
         if(allowedSource.indexOf(source.getConstructor()) >= 0)
         {
            var petData:Object = {};
            if(Mission.onMission())
            {
               if(mission_id)
               {
                  if(this.pet)
                  {
                     petData.id = this.pet.getData(DBCharacterData.ID);
                     petData.level = this.pet.getLevel();
                  }
                  else
                  {
                     petData.id = 0;
                     petData.level = 0;
                  }
                  this.xpGainedInMission.value = this.xpGainedInMission.value + xp;
                  this.goldGainedInMission.value = this.goldGainedInMission.value + gold;
                  if(Central.main.isNewCharByCreate && mission_id == "msn0")
                  {
                     this.resetCacheBattle();
                     tempReward = {
                        "status":1,
                        "error":0,
                        "reward_items":["item1","item2","item3"]
                     };
                     this.updateCharacterResponse(tempReward);
                     return;
                  }
                  seqHash = Main.updateSequence();
                  paramHash = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,petData.id,petData.level,mission_id,failed,stateHash]);
                  Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,petData.id,petData.level,mission_id,paramHash,seqHash,failed,stateHash],this.updateCharacterResponse,this);
                  this.resetCacheBattle();
               }
               else
               {
                  if(MissionData.SPECIAL_MISSION.indexOf(Mission.curMissionID) >= 0)
                  {
                     if(this.xpGainedInMission.value + xp > MissionData.SPECIAL_MISSION_XP_CAP)
                     {
                        if(this.pet)
                        {
                           petData.id = this.pet.getData(DBCharacterData.ID);
                           petData.level = this.pet.getLevel();
                        }
                        else
                        {
                           petData.id = 0;
                           petData.level = 0;
                        }
                        seqHash = Main.updateSequence();
                        paramHash = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,petData.id,petData.level,mission_id,failed,this.datafileHack]);
                        Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,Math.round(this.xpGainedInMission.value),Math.round(this.goldGainedInMission.value),this.itemUsedInBattle,petData.id,petData.level,mission_id,paramHash,seqHash,failed,this.datafileHack],this.updateCharacterResponse,this);
                        this.resetCacheBattle();
                     }
                  }
                  this.xpGainedInMission.value = this.xpGainedInMission.value + xp;
                  this.goldGainedInMission.value = this.goldGainedInMission.value + gold;
               }
            }
            else
            {
               if(this.pet)
               {
                  petData.id = this.pet.getData(DBCharacterData.ID);
                  petData.level = this.pet.getLevel();
               }
               else
               {
                  petData.id = 0;
                  petData.level = 0;
               }
               seqHash = Main.updateSequence();
               paramHash = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,xp,gold,this.itemUsedInBattle,petData.id,petData.level,mission_id,failed,this.datafileHack]);
               Main.amfClient.service("CharacterService.updateCharacter",[Account.getAccountSessionKey(),this.dbChar.character_id,this.dbChar.character_level,xp,gold,this.itemUsedInBattle,petData.id,petData.level,mission_id,paramHash,seqHash,failed,this.datafileHack],this.updateCharacterResponse,this);
               this.itemUsedInBattle = [];
            }
            return;
         }
         Out.error(this,"source.getConstrutor() >> " + source.getConstrutor());
         Main.onError();
      }
      
      private function resetCacheBattle() : void
      {
         this.itemUsedInBattle = [];
         this.itemGainedInMission = [];
         this.skillGainedInMission = [];
         this.xpGainedInMission.value = 0;
         this.goldGainedInMission.value = 0;
      }
      
      private function updateCharacterResponse(response:Object) : void
      {
         this.rewardItems = [];
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            if(response.maintenance)
            {
               Central.main.ShowMainAlertMessage = String(response.maintenance);
            }
            if(response.reward_items)
            {
               this.rewardItems = response.reward_items;
            }
            if(this.rewardItems.length > 0)
            {
               Main.popup.showBonusReward(rewardItems);
            }
            if(Central.main.Features.FEATURE_EXPIRY_ITEM)
            {
               Main.checkExpiryItem();
            }
            Out.debug(this,"Hank character :: bossid >> " + Central.battle.bossId);
            if(Main.getMainChar().getLevel() > 20 && Central.battle.bossId == "")
            {
               Main.amfClient.service("RouletteService.randomAddScatchCard",[Account.getAccountSessionKey()],this.ScratchAddAmfGetResult);
            }
         }
      }
      
      private function ScratchAddAmfGetResult(response:Object) : void
      {
         if(Central.main.validateAmfResponse(response))
         {
            if(response.bango)
            {
               Central.main.loadPopupPanel("daily_login_4","ninjasaga.linkage.daily_login4");
            }
         }
      }
      
      public function updateAP() : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         Main.amfClient.service("CharacterDAO.updateAP",[Account.getAccountSessionKey(),this.dbChar.character_id,[this.dbChar.character_fire,this.dbChar.character_water,this.dbChar.character_wind,this.dbChar.character_earth,this.dbChar.character_lightning]],Main.onAmfResult);
      }
      
      public function updateDailyTask(daily:Object) : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var seqHash:String = Main.updateSequence();
         var paramHash:String = Main.getArrayHash([Account.getAccountSessionKey(),this.dbChar.character_id,daily.total,daily.amount,daily.completeTime,daily.type]);
         Main.amfClient.service("CharacterDAO.updateDailyTask",[Account.getAccountSessionKey(),this.dbChar.character_id,daily,paramHash,seqHash],Main.onAmfResult);
      }
      
      public function completeDailyTask(callback:Function) : void
      {
         if(!Main.getMainChar())
         {
            return;
         }
         if(Main.getMainChar().getData(DBCharacterData.ID) != this.getData(DBCharacterData.ID))
         {
            return;
         }
         var petData:Object = {};
         if(this.pet)
         {
            petData.id = this.pet.getData(DBCharacterData.ID);
            petData.level = this.pet.getLevel();
         }
         else
         {
            petData.id = 0;
            petData.level = 0;
         }
         var seqHash:String = Main.updateSequence();
         var paramHash:String = Main.getHash(String(petData.id) + String(petData.level));
         Main.amfClient.service("CharacterService.completeDailyTask",[Account.getAccountSessionKey(),petData.id,petData.level,paramHash,seqHash],callback);
      }
      
      public function saveGold(_gold:int) : void
      {
         if(_gold != 0)
         {
            this.updateGold(_gold);
            Main.updateMenu();
            return;
         }
      }
      
      public function saveTP(_tp:int) : void
      {
         if(_tp != 0)
         {
            this.updateTP(_tp);
            Main.updateMenu();
            return;
         }
      }
      
      public function saveSS(_ss:int) : void
      {
         if(_ss != 0)
         {
            this.updateSS(_ss);
            Main.updateMenu();
            return;
         }
      }
      
      public function updateSS(_ss:int) : void
      {
         var TotalSS:int = 0;
         TotalSS = int(_ss) + int(this.getData("character_senjutsu"));
         this.updateData(DBCharacterData.SENJUTSU,TotalSS);
      }
      
      public function updateTP(_tp:int) : void
      {
         var TotalTP:int = 0;
         TotalTP = int(_tp) + int(this.getData("character_bloodline"));
         this.updateData(DBCharacterData.BLOODLINE,TotalTP);
      }
      
      public function changeHairColor(_hairColor:Array) : void
      {
         var hasBackHair:Boolean = this.getGender() == 0?false:true;
         this.actionBase.changeHairColor(_hairColor,hasBackHair);
         for(var i:uint = 0; i < this.skillSwfArr.length; i++)
         {
            this.skillSwfArr[i].changeHairColor(_hairColor,hasBackHair);
         }
         for(i = 0; i < this.bloodlineSwfArr.length; i++)
         {
            this.bloodlineSwfArr[i].changeHairColor(_hairColor,hasBackHair);
         }
         for(i = 0; i < this.senjutsuSwfArr.length; i++)
         {
            this.senjutsuSwfArr[i].changeHairColor(_hairColor,hasBackHair);
         }
         for(i = 0; i < this.secretSwfArr.length; i++)
         {
            this.secretSwfArr[i].changeHairColor(_hairColor,hasBackHair);
         }
         for(i = 0; i < this.classSkillSwfArr.length; i++)
         {
            this.classSkillSwfArr[i].changeHairColor(_hairColor,hasBackHair);
         }
      }
      
      public function changeSkinColor(_skinColor:Number) : void
      {
         Central.main.graphicController.setSkinColor(this.actionBase,_skinColor);
         for(var i:uint = 0; i < this.skillSwfArr.length; i++)
         {
            Central.main.graphicController.setSkinColor(this.skillSwfArr[i],_skinColor);
         }
         for(i = 0; i < this.senjutsuSwfArr.length; i++)
         {
            Central.main.graphicController.setSkinColor(this.senjutsuSwfArr[i],_skinColor);
         }
         for(i = 0; i < this.bloodlineSwfArr.length; i++)
         {
            Central.main.graphicController.setSkinColor(this.bloodlineSwfArr[i],_skinColor);
         }
         for(i = 0; i < this.secretSwfArr.length; i++)
         {
            Central.main.graphicController.setSkinColor(this.secretSwfArr[i],_skinColor);
         }
         for(i = 0; i < this.classSkillSwfArr.length; i++)
         {
            Central.main.graphicController.setSkinColor(this.classSkillSwfArr[i],_skinColor);
         }
      }
      
      public function changeBodySet(_set:String, isUpdateSkill:Boolean = true) : void
      {
         var i:uint = 0;
         Central.main.graphicController.setupBodySet(this.actionBase,_set,this.getGender(),this.getSkinColor());
         if(isUpdateSkill)
         {
            for(i = 0; i < this.skillSwfArr.length; i++)
            {
               Central.main.graphicController.setupBodySet(this.skillSwfArr[i],_set,this.getGender(),this.getSkinColor());
            }
            for(i = 0; i < this.senjutsuSwfArr.length; i++)
            {
               Central.main.graphicController.setupBodySet(this.senjutsuSwfArr[i],_set,this.getGender(),this.getSkinColor());
            }
            for(i = 0; i < this.bloodlineSwfArr.length; i++)
            {
               Central.main.graphicController.setupBodySet(this.bloodlineSwfArr[i],_set,this.getGender(),this.getSkinColor());
            }
            for(i = 0; i < this.secretSwfArr.length; i++)
            {
               Central.main.graphicController.setupBodySet(this.secretSwfArr[i],_set,this.getGender(),this.getSkinColor());
            }
            for(i = 0; i < this.classSkillSwfArr.length; i++)
            {
               Central.main.graphicController.setupBodySet(this.classSkillSwfArr[i],_set,this.getGender(),this.getSkinColor());
            }
         }
      }
      
      private function setupBodySet(mc:MovieClip) : void
      {
         Central.main.graphicController.setupBodySet(mc,this.getBodySet(),this.getGender(),this.getSkinColor());
      }
      
      public function changeWeapon(_weapon:String, isUpdateSkill:Boolean = true) : void
      {
         var i:uint = 0;
         Central.main.graphicController.setupWeapon(this.actionBase,_weapon);
         if(isUpdateSkill)
         {
            for(i = 0; i < this.skillSwfArr.length; i++)
            {
               Central.main.graphicController.setupWeapon(this.skillSwfArr[i],_weapon);
            }
            for(i = 0; i < this.senjutsuSwfArr.length; i++)
            {
               Central.main.graphicController.setupWeapon(this.senjutsuSwfArr[i],_weapon);
            }
            for(i = 0; i < this.bloodlineSwfArr.length; i++)
            {
               Central.main.graphicController.setupWeapon(this.bloodlineSwfArr[i],_weapon);
            }
            for(i = 0; i < this.secretSwfArr.length; i++)
            {
               Central.main.graphicController.setupWeapon(this.secretSwfArr[i],_weapon);
            }
            for(i = 0; i < this.classSkillSwfArr.length; i++)
            {
               Central.main.graphicController.setupWeapon(this.classSkillSwfArr[i],_weapon);
            }
         }
      }
      
      private function setupWeapon(mc:MovieClip) : void
      {
         Central.main.graphicController.setupWeapon(mc,this.getWeapon());
      }
      
      public function changeBackItem(_backitem:String, isUpdateSkill:Boolean = true) : void
      {
         var i:uint = 0;
         if(_backitem == null || _backitem == "")
         {
            Central.main.graphicController.unSetupBackItem(this.actionBase);
            if(isUpdateSkill)
            {
               for(i = 0; i < this.skillSwfArr.length; i++)
               {
                  Central.main.graphicController.unSetupBackItem(this.skillSwfArr[i]);
               }
               for(i = 0; i < this.senjutsuSwfArr.length; i++)
               {
                  Central.main.graphicController.unSetupBackItem(this.senjutsuSwfArr[i]);
               }
               for(i = 0; i < this.bloodlineSwfArr.length; i++)
               {
                  Central.main.graphicController.unSetupBackItem(this.bloodlineSwfArr[i]);
               }
               for(i = 0; i < this.secretSwfArr.length; i++)
               {
                  Central.main.graphicController.unSetupBackItem(this.secretSwfArr[i]);
               }
               for(i = 0; i < this.classSkillSwfArr.length; i++)
               {
                  Central.main.graphicController.unSetupBackItem(this.classSkillSwfArr[i]);
               }
            }
         }
         else
         {
            Central.main.graphicController.setupBackItem(this.actionBase,_backitem);
            if(isUpdateSkill)
            {
               for(i = 0; i < this.skillSwfArr.length; i++)
               {
                  Central.main.graphicController.setupBackItem(this.skillSwfArr[i],_backitem);
               }
               for(i = 0; i < this.senjutsuSwfArr.length; i++)
               {
                  Central.main.graphicController.setupBackItem(this.senjutsuSwfArr[i],_backitem);
               }
               for(i = 0; i < this.bloodlineSwfArr.length; i++)
               {
                  Central.main.graphicController.setupBackItem(this.bloodlineSwfArr[i],_backitem);
               }
               for(i = 0; i < this.secretSwfArr.length; i++)
               {
                  Central.main.graphicController.setupBackItem(this.secretSwfArr[i],_backitem);
               }
               for(i = 0; i < this.classSkillSwfArr.length; i++)
               {
                  Central.main.graphicController.setupBackItem(this.classSkillSwfArr[i],_backitem);
               }
            }
         }
      }
      
      private function setupBackItem(mc:MovieClip) : void
      {
         Central.main.graphicController.setupBackItem(mc,this.getBackItem());
      }
      
      private function unSetupBackItem(mc:MovieClip) : void
      {
         Central.main.graphicController.unSetupBackItem(mc);
      }
      
      public function changeHair(_hair:String, _hairColor:Array = null) : void
      {
         var hair:Item = null;
         hair = Item.getItem(_hair);
         if(hair != null)
         {
            this.updateHair(null,{
               "swfName":_hair,
               "hairColor":_hairColor
            });
         }
         else
         {
            Main.loadSwf(["swf/items/" + _hair + ".swf"],this.updateHair,{
               "swfName":_hair,
               "hairColor":_hairColor
            });
         }
      }
      
      private function updateHair(_swfObj:Object, params:Object) : void
      {
         var item:Item = null;
         var swfName:String = params.swfName;
         var hairColor:Array = params.hairColor;
         if(_swfObj != null)
         {
            item = new Item(swfName);
            item.setSwf(_swfObj["swf/items/" + swfName + ".swf"]);
            Item.setItem(item);
         }
         var hair:Item = Item.getItem(swfName);
         var hasBackHair:Boolean = this.getGender() == 0?false:true;
         this.actionBase.setupHair(hair,hasBackHair);
         for(var i:uint = 0; i < this.skillSwfArr.length; i++)
         {
            this.skillSwfArr[i].setupHair(hair,hasBackHair);
         }
         for(i = 0; i < this.senjutsuSwfArr.length; i++)
         {
            this.senjutsuSwfArr[i].setupHair(hair,hasBackHair);
         }
         for(i = 0; i < this.bloodlineSwfArr.length; i++)
         {
            this.bloodlineSwfArr[i].setupHair(hair,hasBackHair);
         }
         for(i = 0; i < this.secretSwfArr.length; i++)
         {
            this.secretSwfArr[i].setupHair(hair,hasBackHair);
         }
         for(i = 0; i < this.classSkillSwfArr.length; i++)
         {
            this.classSkillSwfArr[i].setupHair(hair,hasBackHair);
         }
         if(hairColor != null)
         {
            this.changeHairColor(hairColor);
         }
         else
         {
            this.customizeHairColor();
         }
      }
      
      public function getBodySet() : String
      {
         var bodySet:String = this.dbChar.character_body_set;
         if(bodySet.length <= 0)
         {
            bodySet = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = bodySet;
         }
         var bodySetData:Object = this.getGender() == 0?Main.BODY_SET_BOY:Main.BODY_SET_GIRL;
         if(!bodySetData[bodySet])
         {
            bodySet = Data.DEFAULT_BODY_SET;
            this.dbChar.character_body_set = bodySet;
         }
         return bodySet;
      }
      
      public function getFace() : String
      {
         var face:String = this.dbChar.character_face;
         if(face.length <= 0)
         {
            face = Data.DEFAULT_FACE + "_" + this.getGender();
            this.dbChar.character_face = face;
         }
         return face;
      }
      
      public function getHair() : String
      {
         var hair:String = this.dbChar.character_hair;
         if(hair.length <= 0)
         {
            hair = Data.DEFAULT_HAIR + "_" + this.getGender();
            this.dbChar.character_hair = hair;
         }
         return hair;
      }
      
      override public function getWeapon() : String
      {
         var equippedWeapon:String = this.dbChar.character_body_parts["weapon"];
         if(equippedWeapon == null)
         {
            equippedWeapon = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = equippedWeapon;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(!Main.WEAPON_DATA.containsKey(equippedWeapon))
         {
            equippedWeapon = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = equippedWeapon;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         return equippedWeapon;
      }
      
      override public function getWeaponEffectObj(effectType:String) : Object
      {
         var key:* = undefined;
         var equippedWeapon:String = this.dbChar.character_body_parts["weapon"];
         if(equippedWeapon == null)
         {
            equippedWeapon = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = equippedWeapon;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         if(!Main.WEAPON_DATA.containsKey(equippedWeapon))
         {
            equippedWeapon = Data.DEFAULT_WEAPON;
            this.dbChar.character_body_parts["weapon"] = equippedWeapon;
            StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         }
         var effectObj:* = null;
         Out.debug("Character","(equippedWeapon) = " + equippedWeapon);
         var effectArr:* = Central.main.WEAPON_DATA.find(equippedWeapon).effect;
         Out.debug("Character","(effectArr) = " + GF.printObject(effectArr));
         for(key in effectArr)
         {
            if(effectArr[key].type == effectType)
            {
               effectObj = effectArr[key];
               break;
            }
         }
         return effectObj;
      }
      
      override public function getBackItem() : String
      {
         var equippedBackItem:String = this.dbChar.character_body_parts["back"];
         if(equippedBackItem == null)
         {
            equippedBackItem = Data.DEFAULT_BACK_ITEM;
            return equippedBackItem;
         }
         if(equippedBackItem == null)
         {
            equippedBackItem = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = equippedBackItem;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         if(!Main.BACK_ITEM_DATA.containsKey(equippedBackItem))
         {
            equippedBackItem = Data.DEFAULT_BACK_ITEM;
            this.dbChar.character_body_parts["back"] = equippedBackItem;
            StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         }
         return equippedBackItem;
      }
      
      override public function getAccessory() : String
      {
         var equippedAccessory:String = this.dbChar.character_body_parts["accessory"];
         if(equippedAccessory == null)
         {
            equippedAccessory = Data.DEFAULT_ACCESSORY;
            return equippedAccessory;
         }
         if(equippedAccessory == null)
         {
            equippedAccessory = Data.DEFAULT_ACCESSORY;
            this.dbChar.character_body_parts["accessory"] = equippedAccessory;
            StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         }
         if(!Main.ACCESSORY_DATA.containsKey(equippedAccessory))
         {
            equippedAccessory = Data.DEFAULT_ACCESSORY;
            this.dbChar.character_body_parts["accessory"] = equippedAccessory;
            StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         }
         return equippedAccessory;
      }
      
      override public function getBloodline() : Array
      {
         var i:int = 0;
         var charBloodline:Array = this.dbChar.bloodline;
         var tmpArr:Array = [];
         for(i = 0; i < charBloodline.length; i++)
         {
            if(charBloodline[i].level)
            {
               tmpArr.push(charBloodline[i]);
            }
         }
         return tmpArr;
      }
      
      override public function getBloodlineEffect() : Array
      {
         var i:int = 0;
         var k:int = 0;
         var j:int = 0;
         var MAX_SKILL_EFFECT_LENGTH:int = 3;
         var tmpEffects:Object = {};
         var charBloodline:Array = this.dbChar.bloodline;
         var tmpArr:Array = [];
         var returnArr:Array = [];
         var skillEffect:Object = [];
         var effect:Object = {};
         for(i = 0; i < charBloodline.length; i++)
         {
            if(charBloodline[i].level)
            {
               tmpArr.push(charBloodline[i]);
            }
         }
         for(i = 0; i < tmpArr.length; i++)
         {
            tmpEffects = Central.main.BLOODLINE_SKILL_DATA["bloodline_skill" + tmpArr[i].skill_id].effect;
            skillEffect = tmpEffects[tmpArr[i].level - 1];
            for(j = 1; j < MAX_SKILL_EFFECT_LENGTH + 1; j++)
            {
               effect = {
                  "type":skillEffect["effect_type_" + j],
                  "amount":skillEffect["effect_amount_" + j],
                  "chancetohit":skillEffect["effect_chancetohit_" + j],
                  "chancetoeffect":skillEffect["effect_chancetoeffect_" + j]
               };
               returnArr.push(effect);
            }
         }
         return returnArr;
      }
      
      override public function getGearset() : Object
      {
         var obj:Object = null;
         var setObj:Object = {};
         var dataObj:Object = {
            "wpnData":Main.WEAPON_DATA.find(this.getWeapon()),
            "backData":(this.getBackItem() != ""?Main.BACK_ITEM_DATA.find(this.getBackItem()):null),
            "acsyData":(this.getAccessory() != ""?Main.ACCESSORY_DATA.find(this.getAccessory()):null),
            "hairData":(!!Central.main.HAIR_DATA?Main.HAIR_DATA.find(Toolkit.getIDBySubData("swfName",this.getHair().replace("hair_",""),Central.main.HAIR_DATA)):null),
            "bodyData":(this.getGender() == 0?Main.BODY_SET_BOY[this.getBodySet()]:Main.BODY_SET_GIRL[this.getBodySet()])
         };
         for each(obj in dataObj)
         {
            if(obj && obj.relate_set)
            {
               if(setObj["gearset" + obj.relate_set])
               {
                  setObj["gearset" + obj.relate_set] = setObj["gearset" + obj.relate_set] + 1;
               }
               else
               {
                  setObj["gearset" + obj.relate_set] = 1;
               }
            }
         }
         return setObj;
      }
      
      public function getHairColor() : Array
      {
         var hairColor:Array = Data.DEFAULT_HAIR_COLOR;
         if(this.dbChar.character_hair_color != null)
         {
            if(this.dbChar.character_hair_color.length > 0)
            {
               hairColor = this.dbChar.character_hair_color;
            }
         }
         return hairColor;
      }
      
      public function getSkinColor() : Number
      {
         var skinColor:Number = Data.DEFAULT_SKIN_COLOR;
         skinColor = this.dbChar.character_skin_color;
         return skinColor;
      }
      
      public function setBodySet(_set:String) : void
      {
         var bodySetData:Object = this.getGender() == 0?Main.BODY_SET_BOY:Main.BODY_SET_GIRL;
         if(bodySetData[_set].premium && Account.getAccountType() == Account.FREE)
         {
            Main.showUpgradeAccount(Central.main.langLib.get(380),"Shop");
         }
         else
         {
            this.dbChar.character_body_set = _set;
         }
      }
      
      public function setFace(_face:String) : void
      {
         this.dbChar.character_face = _face;
      }
      
      public function setHair(_hair:String) : void
      {
         this.dbChar.character_hair = _hair;
      }
      
      public function setWeapon(_weapon:String, addInv:Boolean = true) : Boolean
      {
         if(!Main.WEAPON_DATA.containsKey(_weapon))
         {
            return false;
         }
         if(this.getData(DBCharacterData.LEVEL) < Main.WEAPON_DATA.find(_weapon).level)
         {
            Main.showInfo(Central.main.langLib.get(381));
            return false;
         }
         if(Main.WEAPON_DATA.find(_weapon).premium)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Main.provision();
            }
            else
            {
               Main.showUpgradeAccount(Central.main.langLib.get(382),"Shop");
               return false;
            }
         }
         if(addInv)
         {
            this.addInventory(InventoryData.TYPE_WEAPON,this.getWeapon());
         }
         this.dbChar.character_body_parts["weapon"] = _weapon;
         StaticVariables.weaponStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["weapon"]));
         if(!this.securityCheck())
         {
            return false;
         }
         return true;
      }
      
      public function setBackItem(_backitem:String, addInv:Boolean = true) : Boolean
      {
         if(this.getBackItem() == "" && (_backitem == "" || _backitem == null))
         {
            return false;
         }
         if(!Main.BACK_ITEM_DATA.containsKey(_backitem) && _backitem != "")
         {
            return false;
         }
         if(this.getBackItem() == "")
         {
            this.dbChar.character_body_parts["back"] = _backitem;
         }
         else
         {
            if(addInv)
            {
               this.addInventory(InventoryData.TYPE_BACK_ITEM,this.getBackItem());
            }
            this.dbChar.character_body_parts["back"] = _backitem;
         }
         StaticVariables.backitemStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["back"]));
         if(!this.securityCheck())
         {
            return false;
         }
         return true;
      }
      
      public function setAccessory(_accessory:String, addInv:Boolean = true) : Boolean
      {
         if(this.getAccessory() == "" && (_accessory == "" || _accessory == null))
         {
            return false;
         }
         if(!Main.ACCESSORY_DATA.containsKey(_accessory) && _accessory != "")
         {
            return false;
         }
         if(this.getAccessory() == "")
         {
            this.dbChar.character_body_parts["accessory"] = _accessory;
         }
         else
         {
            if(addInv)
            {
               this.addInventory(InventoryData.TYPE_ACCESSORY,this.getAccessory());
            }
            this.dbChar.character_body_parts["accessory"] = _accessory;
         }
         StaticVariables.accessoryStr = Sha1Encrypt.encrypt(String(this.dbChar.character_body_parts["accessory"]));
         if(!this.securityCheck())
         {
            return false;
         }
         return true;
      }
      
      public function setGender(_gender:uint) : void
      {
         if(_gender == 0 || _gender == 1)
         {
            this.dbChar.character_gender = _gender;
         }
      }
      
      public function getHead() : MovieClip
      {
         var mc:MovieClip = GF.getAsset(Main.actionBase,"Head");
         this.cloneHead(mc);
         return mc;
      }
      
      public function getStaticFullBody() : MovieClip
      {
         var mc:MovieClip = GF.getAsset(Main.actionBase,"StaticFullBody");
         this.cloneStaticFullBody(mc);
         return mc;
      }
      
      public function hasItem(_itemType:String, _itemId:String, checkEquipment:Boolean = false) : Boolean
      {
         var itemArr:Array = this.getInventory(_itemType);
         var hasItemInInv:Boolean = false;
         var equipmentId:String = "";
         if(itemArr != null)
         {
            if(itemArr.indexOf(_itemId) >= 0)
            {
               hasItemInInv = true;
            }
         }
         if(hasItemInInv || !checkEquipment)
         {
            return hasItemInInv;
         }
         switch(_itemType)
         {
            case InventoryData.TYPE_BACK_ITEM:
               equipmentId = this.getBackItem();
               break;
            case InventoryData.TYPE_ACCESSORY:
               equipmentId = this.getAccessory();
               break;
            case InventoryData.TYPE_BODY_SET:
               equipmentId = this.getBodySet();
               break;
            case InventoryData.TYPE_WEAPON:
               equipmentId = this.getWeapon();
         }
         return equipmentId == _itemId;
      }
      
      public function setInventory(itemType:String, value:Object) : void
      {
         this.dbChar.character_inventory[itemType] = value;
      }
      
      public function addInventory(_itemType:String, _itemId:String) : void
      {
         if(_itemType == null || _itemId == null)
         {
            return;
         }
         switch(_itemType)
         {
            case InventoryData.TYPE_ITEM:
               if(this.calcInventoryUsage() >= Data.INV_SPACE_FREE && Account.getAccountType() == Account.FREE)
               {
                  Main.showUpgradeAccount(String(String(Central.main.langLib.get(54)).replace("[valInvSpaceFree]",Data.INV_SPACE_FREE.toString())).replace("[valInvSpacePrenium]",Data.INV_SPACE_PREMIUM),"Shop");
                  return;
               }
               if(Account.getAccountType() == Account.PREMIUM)
               {
                  Main.provision();
                  if(this.calcInventoryUsage() >= Data.INV_SPACE_PREMIUM)
                  {
                     Main.showInfo(String(Central.main.langLib.get(51)).replace("[valInvSpacePrenium2]",Data.INV_SPACE_PREMIUM.toString()));
                     return;
                  }
               }
               break;
         }
         var itemArr:Array = this.dbChar.character_inventory[_itemType];
         if(itemArr == null)
         {
            itemArr = new Array();
         }
         itemArr.push(_itemId);
         this.dbChar.character_inventory[_itemType] = itemArr;
      }
      
      public function addInventoryForce(_itemType:String, _itemId:String) : void
      {
         if(_itemType == null || _itemId == null)
         {
            return;
         }
         var itemArr:Array = this.dbChar.character_inventory[_itemType];
         if(itemArr == null)
         {
            itemArr = new Array();
         }
         itemArr.push(_itemId);
         this.dbChar.character_inventory[_itemType] = itemArr;
      }
      
      public function addMagatama(level:int) : void
      {
         var mgtData:Object = this.getInventory(InventoryData.TYPE_MAGATAMA);
         if(mgtData)
         {
            if(mgtData[level])
            {
               mgtData[level] = mgtData[level] + 1;
            }
            else
            {
               mgtData[level] = 1;
            }
         }
         else
         {
            mgtData = {};
            mgtData[level] = 1;
         }
         this.dbChar.character_inventory[InventoryData.TYPE_MAGATAMA] = mgtData;
      }
      
      public function addMissionRecord(_missionId:String, _status:String) : void
      {
         var missionRecord:Object = this.dbChar.character_inventory[InventoryData.TYPE_MISSION];
         if(missionRecord == null)
         {
            missionRecord = {};
         }
         if(missionRecord[_missionId] == null)
         {
            missionRecord[_missionId] = {
               "success":0,
               "fail":0,
               "time":Main.serverTime
            };
         }
         missionRecord[_missionId][_status]++;
         if(_status == "success")
         {
            missionRecord[_missionId].time = Main.serverTime;
         }
         this.dbChar.character_inventory[InventoryData.TYPE_MISSION] = missionRecord;
      }
      
      public function checkMissionRecord(missionId:String) : Object
      {
         var record:Object = this.getData(DBCharacterData.INVENTORY)[InventoryData.TYPE_MISSION];
         if(record == null)
         {
            record = {};
         }
         if(record[missionId] == null)
         {
            record[missionId] = {
               "success":0,
               "fail":0,
               "time":0
            };
         }
         else if(record[missionId].time == null)
         {
            record[missionId].time = 0;
         }
         return record[missionId];
      }
      
      public function removeInventory(_itemType:String, _itemId:String) : void
      {
         var itemArr:Array = this.dbChar.character_inventory[_itemType];
         if(itemArr != null)
         {
            if(itemArr.indexOf(_itemId) >= 0)
            {
               itemArr.splice(itemArr.indexOf(_itemId),1);
            }
            else
            {
               new Error(this + " :: removeInventory :: item not found >> " + _itemId);
            }
         }
      }
      
      public function getInventory(_itemType:String) : *
      {
         var i:int = 0;
         var itemArr:* = this.dbChar.character_inventory[_itemType];
         if(itemArr == null)
         {
            if(_itemType == InventoryData.TYPE_MISSION)
            {
               itemArr = {
                  "success":0,
                  "fail":0
               };
            }
            else
            {
               if(_itemType == InventoryData.TYPE_DAILY_TASK)
               {
                  return null;
               }
               if(_itemType == InventoryData.TYPE_MAGATAMA)
               {
                  return null;
               }
               itemArr = [];
            }
         }
         if(_itemType == InventoryData.TYPE_PET)
         {
            itemArr = [];
            for(i = 0; i < this.pets.length; i++)
            {
               itemArr.push("pet" + this.pets[i].id);
            }
         }
         if(_itemType != InventoryData.TYPE_MISSION && _itemType != InventoryData.TYPE_DAILY_TASK && _itemType != InventoryData.TYPE_MAGATAMA)
         {
            itemArr.sort();
         }
         return itemArr;
      }
      
      public function clearInventory(_itemType:String) : void
      {
         this.dbChar.character_inventory[_itemType] = null;
      }
      
      public function getItemCount(_itemType:String, _itemId:String) : uint
      {
         var itemArr:Array = this.getInventory(_itemType);
         var itemCount:uint = 0;
         for(var i:int = 0; i < itemArr.length; i++)
         {
            if(itemArr[i] == _itemId)
            {
               itemCount++;
            }
         }
         return itemCount;
      }
      
      public function calcInventoryUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_ITEM);
         return itemArr.length;
      }
      
      public function calcMaterialInventoryUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_MATERIAL);
         return itemArr.length;
      }
      
      public function calcEssenceInventoryUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_ESSENCE);
         return itemArr.length;
      }
      
      public function calcWeaponUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_WEAPON);
         return itemArr.length + 1;
      }
      
      public function calcBodySetUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_BODY_SET);
         return itemArr.length + 1;
      }
      
      public function calcBackItemUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_BACK_ITEM);
         if(this.getBackItem() && this.getBackItem() != "")
         {
            return itemArr.length + 1;
         }
         return itemArr.length;
      }
      
      public function calcAccessoryUsage() : uint
      {
         var itemArr:Array = this.getInventory(InventoryData.TYPE_ACCESSORY);
         if(this.getAccessory() && this.getAccessory() != "")
         {
            return itemArr.length + 1;
         }
         return itemArr.length;
      }
      
      public function setClassSkillListArr(skillId:String) : void
      {
         if(this.classSkillList.indexOf(skillId) < 0)
         {
            this.classSkillList.push(skillId);
         }
      }
      
      public function clearClassSkillListArr(skillId:String) : void
      {
         var id:int = 0;
         if(this.classSkillList.indexOf(skillId) >= 0)
         {
            id = this.classSkillList.indexOf(skillId);
            this.classSkillList.splice(id,1);
         }
      }
      
      public function foreClearClassSkillListArr() : void
      {
         this.classSkillList = [];
      }
      
      public function getClassSkillListArr() : Array
      {
         return this.classSkillList;
      }
      
      public function setSkillList(_arr:Array, _cbFn:Function = null) : void
      {
         var i:uint = 0;
         var swfToLoad:Array = null;
         var skillList:Array = null;
         var classSkillList:Array = null;
         if(_arr != null)
         {
            swfToLoad = new Array();
            if(_arr.length == 0)
            {
               this.dbChar.character_skills = _arr;
            }
            for(i = 0; i < _arr.length; i++)
            {
               if(Main.SKILL_DATA[_arr[i]])
               {
                  if(Main.SKILL_DATA[_arr[i]].special_class == 0)
                  {
                     this.dbChar.character_skills = _arr;
                     break;
                  }
               }
            }
            this.pendingSkills = null;
            skillList = this.getSkillListArr();
            for(i = 0; i < skillList.length; i++)
            {
               if(!Skill.hasSkill(skillList[i]))
               {
                  swfToLoad.push("swf/skills/" + Main.SKILL_DATA[skillList[i]].swfName + ".swf");
               }
            }
            classSkillList = this.getClassSkillListArr();
            for(i = 0; i < classSkillList.length; i++)
            {
               if(!Skill.hasClassSkill(classSkillList[i]))
               {
                  swfToLoad.push("swf/skills/" + Main.SKILL_DATA[classSkillList[i]].swfName + ".swf");
               }
            }
            if(swfToLoad.length > 0)
            {
               if(this.getCharacterId() == Main.getMainChar().getCharacterId())
               {
                  this.pendingSkills = swfToLoad;
                  if(_cbFn != null)
                  {
                     _cbFn();
                  }
               }
               else
               {
                  Main.loadSwf(swfToLoad,this.updateSkillSwf,{"cbFn":_cbFn});
               }
            }
            else
            {
               this.updateSkillSwf(null,{"cbFn":_cbFn});
            }
         }
         else
         {
            this.dbChar.character_skills = null;
            this.skillSwfArr = null;
         }
      }
      
      public function updateSkillSwf(_swfObj:Object = null, params:Object = null) : void
      {
         var skillMc:MovieClip = null;
         var senjutsuNumIdStr:String = null;
         var senjutsuMc:MovieClip = null;
         var BloodlineMc:MovieClip = null;
         var SecretMc:MovieClip = null;
         this.skillCheck();
         var skillList:Array = this.dbChar.character_skills;
         var i:uint = 0;
         this.skillSwfArr = [];
         for(i = 0; i < skillList.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Skill.hasSkill(skillList[i]))
               {
                  Skill.setSkill(skillList[i],_swfObj["swf/skills/" + Main.SKILL_DATA[skillList[i]].swfName + ".swf"]);
               }
            }
            skillMc = Skill.getSkill(skillList[i]);
            this.setSkillSwf(skillMc);
         }
         this.classSkillSwfArr = [];
         for(i = 0; i < this.classSkillList.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Skill.hasClassSkill(classSkillList[i]))
               {
                  Skill.setClassSkill(classSkillList[i],_swfObj["swf/skills/" + Main.SKILL_DATA[classSkillList[i]].swfName + ".swf"]);
               }
            }
            skillMc = Skill.getClassSkill(classSkillList[i]);
            this.setClassSkillSwf(skillMc);
         }
         this.senjutsuSwfArr = [];
         var senjutsu_skill_arr:Array = this.dbChar.character_senjutsu;
         for(i = 0; i < senjutsu_skill_arr.length; i++)
         {
            senjutsuNumIdStr = senjutsu_skill_arr[i].replace("senjutsu_skill","");
            if(_swfObj != null)
            {
               if(!Skill.hasSkill("skill" + senjutsuNumIdStr))
               {
                  Skill.setSkill("skill" + senjutsuNumIdStr,_swfObj["swf/skills/" + Main.SENJUTSU_SKILL_DATA[senjutsu_skill_arr[i]].swf_name + ".swf"]);
               }
            }
            senjutsuMc = Skill.getSenjutsu(senjutsuNumIdStr);
            senjutsuMc.name = Main.SENJUTSU_SKILL_DATA[senjutsu_skill_arr[i]].swf_name;
            this.setSenjutsuSwf(senjutsuMc);
         }
         var bloodline_skill_arr:Array = this.getBloodlineListArr();
         this.bloodlineSwfArr = [];
         for(i = 0; i < bloodline_skill_arr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Skill.hasSkill("skill" + bloodline_skill_arr[i].skill_id))
               {
                  Skill.setSkill("skill" + bloodline_skill_arr[i].skill_id,_swfObj["swf/skills/" + Main.BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[i].skill_id].swf_name + ".swf"]);
               }
            }
            BloodlineMc = Skill.getBloodline(bloodline_skill_arr[i].skill_id);
            this.setBloodlineSwf(BloodlineMc);
         }
         var Secret_skill_arr:Array = this.getSecretListArr();
         this.secretSwfArr = [];
         for(i = 0; i < Secret_skill_arr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Skill.hasSkill("skill" + Secret_skill_arr[i].skill_id))
               {
                  Skill.setSkill("skill" + Secret_skill_arr[i].skill_id,_swfObj["swf/skills/" + Main.BLOODLINE_SKILL_DATA["bloodline_skill" + Secret_skill_arr[i].skill_id].swf_name + ".swf"]);
               }
            }
            SecretMc = Skill.getBloodline(Secret_skill_arr[i].skill_id);
            this.setSecretSwf(SecretMc);
         }
         this.customizeCharacter();
         if(params != null)
         {
            if(params.cbFn != null)
            {
               params.cbFn();
            }
         }
         Main.proc.addState(this.validateSkill,60000,true);
      }
      
      public function getSkillSwfArr() : Array
      {
         return this.skillSwfArr;
      }
      
      public function getClassSkillSwfArr() : Array
      {
         return this.classSkillSwfArr;
      }
      
      public function clearClassSkillSwfArr() : void
      {
         this.classSkillSwfArr = [];
      }
      
      public function getSkillTypes(ninjutsuOnly:Boolean = false) : HashMap
      {
         var skillList:Array = null;
         var i:uint = 0;
         var type:String = null;
         var record:uint = 0;
         var skillTypes:HashMap = new HashMap();
         skillList = this.getInventory(InventoryData.TYPE_SKILL);
         for(i = 0; i < skillList.length; i++)
         {
            try
            {
               type = Main.SKILL_DATA[skillList[i]].type;
            }
            catch(e:Error)
            {
               Out.debug(this,"i=" + i);
               Out.debug(this,"skillList[i]=" + skillList[i]);
               Out.debug(this,"skillList[i]=" + GF.printObject(skillList[i]));
               Out.debug(this,"Main.SKILL_DATA[skillList[i]]" + Main.SKILL_DATA[skillList[i]]);
               Out.debug(this,"Main.SKILL_DATA[skillList[i]]" + GF.printObject(Main.SKILL_DATA[skillList[i]]));
               throw e;
            }
            if(type != "taijutsu" && type != "genjutsu" || !ninjutsuOnly)
            {
               record = skillTypes.find(type);
               record++;
               skillTypes.insert(type,record);
            }
         }
         return skillTypes;
      }
      
      public function skillCheck() : void
      {
         var skillTypes:Array = this.getSkillTypes(true).toArray();
         if(skillTypes.length <= Data.FREE_JUTSU_NUMBER)
         {
            return;
         }
         if(skillTypes.length > Data.PREMIUM_JUTSU_NUMBER)
         {
            this.dbChar.character_skills = [];
            this.clearInventory(InventoryData.TYPE_SKILL);
            Out.data(this,"skill error :: number of ninjutsu types " + skillTypes.length);
            Main.submitData();
         }
         if(skillTypes.length > Data.FREE_JUTSU_NUMBER && skillTypes.length <= Data.PREMIUM_JUTSU_NUMBER)
         {
            if(Account.getAccountType() == Account.PREMIUM)
            {
               Central.main.provision();
            }
            else
            {
               if(Main.getMainChar().getData("character_id") != this.getData("character_id"))
               {
                  return;
               }
               this.dbChar.character_skills = [];
               this.clearInventory(InventoryData.TYPE_SKILL);
               Out.data(this,"skill error :: number of ninjutsu types " + skillTypes.length);
               Main.submitData();
            }
         }
      }
      
      public function removeEquippedSkill(skillId:String) : void
      {
         var equippedSkills:Array = this.getSkillListArr();
         if(equippedSkills)
         {
            if(equippedSkills.length > 0)
            {
               if(equippedSkills.indexOf(skillId) >= 0)
               {
                  equippedSkills.splice(equippedSkills.indexOf(skillId),1);
                  this.dbChar.character_skills = equippedSkills;
               }
            }
         }
      }
      
      public function pvpSecurityCheck() : void
      {
         Out.debug(this,"pvpSecurityCheck");
         Main.proc.addState(this.validateSkill,60000,true);
      }
      
      private function validateSkill() : void
      {
         Out.debug(this,"validateSkill");
         if(this.getCharacterId() != Main.getMainChar().getCharacterId())
         {
            return;
         }
         Main.proc.removeState(this.validateSkill);
         if(Central.main.isNewChar)
         {
            return;
         }
         var strToHash:String = "CharacterValidation.validateSkill" + this.dbChar.character_skills.toString();
         var signature:String = Main.getHash(strToHash);
         Main.amfClient.service("CharacterValidation.validateSkill",[Account.getAccountSessionKey(),signature,this.dbChar.character_skills],this.validateSkillResponse,this);
      }
      
      private function validateSkillResponse(response:Object) : void
      {
         var strToHash:String = null;
         try
         {
            if(Main.validateAmfResponse(response))
            {
               strToHash = "CharacterValidation.validateSkill" + response.equipped_skill.toString() + response.status;
               if(response.signature == Main.getHash(strToHash))
               {
               }
            }
         }
         catch(e:Error)
         {
            Main.onError(Main.errorData.CODE_CHARACTER_SKILL_INVALID);
         }
      }
      
      public function hasSkill(skillId:String) : Boolean
      {
         var skills:Array = this.getInventory(InventoryData.TYPE_SKILL);
         if(skills.indexOf(skillId) >= 0)
         {
            return true;
         }
         return false;
      }
      
      public function hasSkillType(type:String) : Boolean
      {
         var skillTypes:HashMap = this.getSkillTypes();
         if(skillTypes.containsKey(type))
         {
            return true;
         }
         return false;
      }
      
      public function get apInvested() : uint
      {
         var ap:uint = 0;
         var i:uint = 0;
         for(i = 0; i < DBCharacterData.ALL_ATTRIBUTE_POINTS.length; i++)
         {
            ap = ap + this.getData(DBCharacterData.ALL_ATTRIBUTE_POINTS[i]);
         }
         return ap;
      }
      
      public function resetAP(reason:uint) : void
      {
         var i:uint = 0;
         for(i = 0; i < DBCharacterData.ALL_ATTRIBUTE_POINTS.length; i++)
         {
            this.updateData(DBCharacterData.ALL_ATTRIBUTE_POINTS[i],0);
         }
         Main.amfClient.service("CharacterDAO.saveResetAP",[Account.getAccountSessionKey(),reason],this.saveResetAPResult);
      }
      
      public function saveResetAPResult(result:Object) : void
      {
      }
      
      public function get trainingSkill() : Object
      {
         return _trainingSkill;
      }
      
      public function set trainingSkill(obj:Object) : void
      {
         if(this._trainingSkill == null || obj == null)
         {
            this._trainingSkill = obj;
         }
      }
      
      public function get trainingFdSkill() : Object
      {
         return _trainingFdSkill;
      }
      
      public function set trainingFdSkill(obj:Object) : void
      {
         if(this._trainingFdSkill == null || obj == null)
         {
            this._trainingFdSkill = obj;
         }
      }
      
      public function verifyTrainingSkill(cbFn:Function) : void
      {
         if(this._trainingSkill == null)
         {
            cbFn();
         }
         else
         {
            Out.debug(this,"CharacterXX.verifyTrainingSkill");
            this.verifyTrainingSkill_CB = cbFn;
            Main.showAmfLoading();
            Main.amfClient.service("CharacterDAO.verifyTrainingSkill",[Account.getAccountSessionKey(),this._trainingSkill.id],this.verifyTrainingSkillResult);
         }
      }
      
      private function verifyTrainingSkillResult(result:Object) : void
      {
         var skillId:String = null;
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(result.error));
            return;
         }
         var tempFix:int = result.recall as int;
         if(tempFix == 1)
         {
            return;
         }
         var remainingTime:int = result.result as int;
         if(remainingTime == 0)
         {
            skillId = this._trainingSkill.id;
            this._trainingSkill = null;
            this.addNewSkill(skillId,this.verifyTrainingSkill_CB);
         }
         else
         {
            this._trainingSkill = {
               "id":this._trainingSkill.id,
               "time":remainingTime
            };
            if(this.verifyTrainingSkill_CB != null)
            {
               this.verifyTrainingSkill_CB();
               this.verifyTrainingSkill_CB = null;
            }
         }
         Main.hideAmfLoading();
      }
      
      public function verifyTrainingFdSkill(cbFn:Function = null) : void
      {
         if(this._trainingFdSkill == null)
         {
            cbFn();
         }
         else
         {
            this.verifyTrainingFdSkill_CB = cbFn;
            Main.showAmfLoading();
            Main.amfClient.service("VisitFriendService.getLearningStatus",[Account.getAccountSessionKey()],verifyTrainingFdSkillResult);
         }
      }
      
      private function verifyTrainingFdSkillResult(result:Object) : void
      {
         var hash:String = null;
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Out.error(this,"onAmfGetLearningStatusResult :: error code " + String(result.error));
            return;
         }
         var tmp:Array = result.result as Array;
         if(tmp)
         {
            this._trainingFdSkill = {};
            this._trainingFdSkill.target = tmp[0];
            this._trainingFdSkill.skill = tmp[1];
            this._trainingFdSkill.skillType = Central.main.SKILL_DATA[this._trainingFdSkill.skill].type;
            this._trainingFdSkill.progress = tmp[2];
            this._trainingFdSkill.lastVisitTime = tmp[3];
            this._trainingFdSkill.serverTime = tmp[4];
            this._trainingFdSkill.trainingTime = Central.main.SKILL_DATA[this._trainingFdSkill.skill].train_time * 2;
            if(this._trainingFdSkill.trainingTime == 0)
            {
               this._trainingFdSkill.trainingTime = 1;
            }
            this._trainingFdSkill.remainingTime = int(this._trainingFdSkill.lastVisitTime) + int(this._trainingFdSkill.trainingTime) * 60 * 60 - int(this._trainingFdSkill.serverTime);
            hash = Central.main.getHash(tmp[0] + "," + tmp[1] + "," + tmp[2] + "," + tmp[3] + "," + tmp[4]);
            if(hash != result.hash)
            {
               Out.error(this,"h.error");
               Central.main.onError();
               return;
            }
         }
         else
         {
            this._trainingFdSkill = null;
         }
         if(this.verifyTrainingFdSkill_CB != null)
         {
            this.verifyTrainingFdSkill_CB();
            this.verifyTrainingFdSkill_CB = null;
         }
         Main.hideAmfLoading();
      }
      
      public function addNewSenjutsu(newSenjutsuData:Object, _cb:Function = null, equip:Boolean = false) : void
      {
         var value:Object = null;
         var learnedSenjutsuList:Array = this.getSenjutsuListArr();
         var isNewSenjutsu:Boolean = true;
         for each(value in learnedSenjutsuList)
         {
            if(value.skill_id == newSenjutsuData.skill_id)
            {
               isNewSenjutsu = false;
               break;
            }
         }
         if(isNewSenjutsu)
         {
            learnedSenjutsuList.push(newSenjutsuData);
         }
         this.dbChar[DBCharacterData.SENJUTSU_SKILL] = learnedSenjutsuList;
         senjutsu = learnedSenjutsuList;
         if(equip == true && this.dbChar[DBCharacterData.SENJUTSU].indexOf(newSenjutsuData.skill_id) < 0)
         {
            this.dbChar[DBCharacterData.SENJUTSU].push("senjutsu_skill" + newSenjutsuData.skill_id);
         }
         if(_cb != null)
         {
            _cb();
         }
      }
      
      public function loadEquippedSenjutsuSwf() : void
      {
         var temp_char_equipped_senjutsu:Array = this.dbChar[DBCharacterData.SENJUTSU];
         var swfToLoad:Array = new Array();
         for(var i:int = 0; i < temp_char_equipped_senjutsu.length; i++)
         {
            if(!Central.skill.hasSkill(temp_char_equipped_senjutsu[i].replace("senjutsu_","")))
            {
               swfToLoad.push("swf/skills/" + Central.main.SENJUTSU_SKILL_DATA[temp_char_equipped_senjutsu[i]].swf_name + ".swf");
            }
         }
         if(swfToLoad.length > 0)
         {
            Central.main.loadSwf(swfToLoad,updateEquippedSenjutsuSwf);
         }
      }
      
      public function updateEquippedSenjutsuSwf(_swfObj:Object = null, params:Object = null) : void
      {
         var senjutsuMc:MovieClip = null;
         this.senjutsuSwfArr = [];
         var senjutsu_skill_arr:Array = this.dbChar[DBCharacterData.SENJUTSU];
         for(var i:int = 0; i < senjutsu_skill_arr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Skill.hasSkill(senjutsu_skill_arr[i].replace("senjutsu_","")))
               {
                  Skill.setSkill(senjutsu_skill_arr[i].replace("senjutsu_",""),_swfObj["swf/skills/" + Main.SENJUTSU_SKILL_DATA[senjutsu_skill_arr[i]].swf_name + ".swf"]);
               }
            }
            senjutsuMc = Skill.getSenjutsu(senjutsu_skill_arr[i].replace("senjutsu_skill",""));
            senjutsuMc.name = Main.SENJUTSU_SKILL_DATA[senjutsu_skill_arr[i]].swf_name;
            this.setSenjutsuSwf(senjutsuMc);
         }
         if(params != null)
         {
            if(params.cbFn != null)
            {
               params.cbFn();
            }
         }
      }
      
      public function addNewSkill(skillId:String, cb:Function = null) : void
      {
         var skillList:Array = null;
         if(!this.hasSkill(skillId))
         {
            Main.showInfo(String(Central.main.langLib.get(383)).replace("[valskillname]",Main.SKILL_DATA[skillId].name));
            this.checkSkill(skillId);
            SNS.publishFeed(SNSData.FEED_SKILL,Main.SKILL_DATA[skillId].name);
            this.addInventory(InventoryData.TYPE_SKILL,skillId);
            skillList = this.getSkillListArr();
            if(skillList.length < 8)
            {
               if(Central.main.SKILL_DATA[skillId].level < this.getLevel())
               {
                  skillList.push(skillId);
                  if(cb == null)
                  {
                     this.setSkillList(skillList);
                  }
                  else
                  {
                     this.setSkillList(skillList,cb);
                  }
               }
               else if(cb != null)
               {
                  cb();
               }
            }
            else if(cb != null)
            {
               cb();
            }
         }
         else
         {
            cb();
         }
         Main.achievement.checkSpecialAchievement(Main.achievementData.SKILL_TRAINED);
         Main.achievement.checkSpecialAchievement(Main.achievementData.KINJUTSU_TRAINED);
      }
      
      public function checkSkill(skillId:String) : void
      {
         if(!Central.main.isTrailEmblem)
         {
            return;
         }
         var skillType:* = Main.SKILL_DATA[skillId].type;
         var skillTypes:HashMap = this.getSkillTypes(true);
         if(skillTypes.toArray().length + 1 == 3 || skillTypes.toArray().length == 3)
         {
            if(!Central.main.getMainChar().hasSkillType(skillType))
            {
               Main.amfClient.service("CharacterDAO.addTrialEmblemThirdSkillType",[Account.getAccountSessionKey(),skillType],new Function());
            }
         }
      }
      
      public function resetSkill(skillType:String, cb:Function = null) : void
      {
         this.removeInventory(InventoryData.TYPE_SKILL,skillType);
      }
      
      public function addEventSkill(skillId:String, cb:Function = null) : void
      {
         var skillList:Array = null;
         if(!this.hasSkill(skillId))
         {
            this.addInventory(InventoryData.TYPE_SKILL,skillId);
            skillList = this.getSkillListArr();
            if(skillList.length < 8)
            {
               skillList.push(skillId);
               if(cb == null)
               {
                  this.setSkillList(skillList);
               }
               else
               {
                  this.setSkillList(skillList,cb);
               }
            }
            else if(cb != null)
            {
               cb();
            }
         }
         this.updateDB(0,0,[],null,0,Character);
      }
      
      public function setPlayerCommand(action:String, data:* = null, skilldata:* = null) : Boolean
      {
         var skillList:Array = null;
         var skillData:Object = null;
         var skillStr:* = undefined;
         var skillEffectStr:String = null;
         var fiveElenemtArr:Array = null;
         var blockElementObj:Object = null;
         var BloodLineDataObj:Object = null;
         var BLeffect:Object = null;
         var strToHash:String = null;
         var DLdmg:int = 0;
         var SenjutsuDataObj:Object = null;
         var Senjutsueffect:Object = null;
         var SENdmg:int = 0;
         lastBattleAction = this.battleAction;
         if(!this.securityCheck())
         {
            Main.disconnect();
            Main.onError();
            return false;
         }
         var AttackerBattleBuff:Object = this.getBattleBuff();
         var AttackerBattleDebuff:Object = this.getBattleDebuff();
         switch(action)
         {
            case "weapon_attack":
               this.battleAction = {"action":action};
               break;
            case "charge":
               this.battleAction = {
                  "action":action,
                  "animation":action
               };
               break;
            case "skill":
               skillList = this.getSkillListArr();
               skillData = Main.SKILL_DATA[skillList[data]];
               skillStr = String(skillData["id"]) + skillData["dbid"] + skillData["gold"] + skillData["crystal"] + skillData["prestige"] + skillData["pvp_point"] + skillData["merit"] + skillData["damage"] + skillData["rarity"] + skillData["cp"] + skillData["cooldown"] + skillData["level"] + skillData["premium"] + skillData["vendor"] + skillData["train_time"];
               if(skillData["hash"] != Sha1Encrypt.encrypt(skillStr) && !Data.TEST_VERSION)
               {
                  Out.error(this,"Error: " + Main.coreData.SKILL_DATA_ERROR);
                  Main.onError();
                  return false;
               }
               skillEffectStr = String(skillData.id) + String(skillData.effect.type) + String(skillData["effect"]["duration"]) + String(skillData["effect"]["amount"]) + String(skillData.swfName);
               if(this.isBattleSkillCooldown(skillData.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",skillData.name)).replace("[valcooldoen]",this.battleSkillCooldown[skillData.id]));
                  return false;
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  if(this.cp < skillData.cp * 1.4)
                  {
                     Main.showInfo(Central.main.langLib.get(680));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  if(this.cp < Math.round(skillData.cp * (1 + int(AttackerBattleDebuff[BattleData.SKILL_341].amount) / 100)))
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     trace("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~1");
                     return false;
                  }
               }
               if(this.cp < skillData.cp)
               {
                  if(!this.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                  {
                     if(this.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
                     {
                        if(this.cp < Math.round(skillData.cp * (int(getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100)))
                        {
                        }
                     }
                     else
                     {
                        Main.showInfo(Central.main.langLib.get(385));
                        return false;
                     }
                  }
               }
               fiveElenemtArr = ["fire","wind","earth","water","lightning"];
               blockElementObj = {
                  "fire":"wind",
                  "wind":"lightning",
                  "lightning":"earth",
                  "earth":"water",
                  "water":"fire"
               };
               if(fiveElenemtArr.indexOf(String(skillData.type)) >= 0)
               {
                  if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
                  {
                     Main.showInfo(Central.main.langLib.get(386));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.SKILL_377))
                  {
                     Main.showInfo(Central.main.langLib.get(386));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
                  {
                     Main.showInfo(Central.main.langLib.get(526));
                     return false;
                  }
                  if(this.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
                  {
                     Main.showInfo(Central.main.langLib.get(610));
                     return false;
                  }
                  if(String(skillData.type).indexOf(blockElementObj[String(Central.battle.getBattleBackground().name)]) >= 0)
                  {
                     switch(blockElementObj[String(Central.battle.getBattleBackground().name)])
                     {
                        case "fire":
                           Main.showInfo(Central.main.langLib.get(1842)[0]);
                           break;
                        case "wind":
                           Main.showInfo(Central.main.langLib.get(1842)[1]);
                           break;
                        case "lightning":
                           Main.showInfo(Central.main.langLib.get(1842)[2]);
                           break;
                        case "earth":
                           Main.showInfo(Central.main.langLib.get(1842)[3]);
                           break;
                        case "water":
                           Main.showInfo(Central.main.langLib.get(1842)[4]);
                     }
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(this.isBattleBuffActive(BloodlineData.EFFECT_SKIP_DEAD_CLEAR_DEBUFF))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               Main.showInfo(skillData.name);
               if(!Central.main.isNewChar)
               {
                  if(this.getCharacterId() == Main.getMainChar().getCharacterId())
                  {
                     Main.achievement.updateBattleStat(Main.achievementData.USE_SKILL,1);
                  }
               }
               try
               {
                  if(skillData.type && skillData.id)
                  {
                     if(Central.battle.type != Central.battle.TYPE_NETWORK)
                     {
                        Main.tracking.trackSkillUsed(skillData.type,skillData.id);
                     }
                     else
                     {
                        Main.tracking.generalTrack(Central.main.tracking.TRACK_PVP,skillData.id,Central.main.tracking.TRACK_PVP_SKILL_USED + skillData.type);
                     }
                  }
               }
               catch(err:Error)
               {
                  Out.error(this,"TRACKING :: skillData not found! :: " + err.message);
               }
               switch(skillData.target)
               {
                  case SkillData.TARGET_SELF:
                     Battle.setDefender(this);
               }
               this.battleAction = {
                  "action":action,
                  "skillId":skillData.id
               };
               return true;
            case "item":
               this.battleAction = {
                  "action":action,
                  "item":data
               };
               return true;
            case "pass":
               this.battleAction = {"action":action};
               return true;
            case "dodge":
               this.battleAction = {"action":action};
               return true;
            case "class_skill":
               this.battleAction = {
                  "action":action,
                  "skillId":data
               };
               return true;
            case "bloodline":
               BloodLineDataObj = skilldata.skillData;
               BLeffect = {};
               strToHash = String(BloodLineDataObj.effect["skill_level"]) + String(BloodLineDataObj.effect["skill_cp"]) + String(BloodLineDataObj.effect["skill_damage"]) + String(BloodLineDataObj.effect["duration_1"]) + String(BloodLineDataObj.effect["effect_target_1"]) + String(BloodLineDataObj.effect["effect_amount_1"]) + String(BloodLineDataObj.effect["effect_chancetohit_1"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_1"]) + String(BloodLineDataObj.effect["duration_2"]) + String(BloodLineDataObj.effect["effect_target_2"]) + String(BloodLineDataObj.effect["effect_amount_2"]) + String(BloodLineDataObj.effect["effect_chancetohit_2"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_2"]) + String(BloodLineDataObj.effect["duration_3"]) + String(BloodLineDataObj.effect["effect_target_3"]) + String(BloodLineDataObj.effect["effect_amount_3"]) + String(BloodLineDataObj.effect["effect_chancetohit_3"]) + String(BloodLineDataObj.effect["effect_chancetoeffect_3"]);
               if(BloodLineDataObj.effect.hash != Sha1Encrypt.encrypt(strToHash))
               {
                  Out.error(this,"Error: " + Main.coreData.SKILL_EFFECT_ERROR);
                  Main.onError();
                  return false;
               }
               if(this.isBattleSkillCooldown(BloodLineDataObj.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",BloodLineDataObj.name)).replace("[valcooldoen]",this.battleSkillCooldown[BloodLineDataObj.id]));
                  return false;
               }
               if(this.isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
               {
                  if(this.cp < BloodLineDataObj.cp)
                  {
                     Main.showInfo(Central.main.langLib.get(680));
                     return false;
                  }
               }
               if(this.isBattleDebuffActive(BattleData.SKILL_341))
               {
                  if(this.cp < BloodLineDataObj.cp)
                  {
                     Main.showInfo(Central.main.langLib.get(385));
                     return false;
                  }
               }
               if(this.cp < BloodLineDataObj.cp)
               {
                  if(!this.isBattleBuffActive(BattleData.EFFECT_EXCITATION_CP))
                  {
                     if(this.isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
                     {
                        if(this.cp < Math.round(BloodLineDataObj.cp * (int(getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100)))
                        {
                        }
                     }
                     else
                     {
                        Main.showInfo(Central.main.langLib.get(385));
                        return false;
                     }
                  }
               }
               if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
               {
                  Main.showInfo(Central.main.langLib.get(798));
                  return false;
               }
               if(this.isBattleDebuffActive(SenjutsuData.EFFECT_SS_BUNDLE_TALENT))
               {
                  Main.showInfo(Central.main.langLib.get(2001)[7]);
                  return false;
               }
               Main.showInfo(BloodLineDataObj.name);
               DLdmg = Main.calcSkillDamage(this,BloodLineDataObj);
               BLeffect = BloodLineDataObj.effect;
               if(DLdmg != 0)
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":BloodLineDataObj.posType,
                     "cp":BloodLineDataObj.cp,
                     "dmg":DLdmg,
                     "effect":BLeffect,
                     "BLSKILLID":BloodLineDataObj.id,
                     "BLTYPE":BloodLineDataObj.bloodline_type
                  };
               }
               else
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":BloodLineDataObj.posType,
                     "cp":BloodLineDataObj.cp,
                     "effect":BLeffect,
                     "BLSKILLID":BloodLineDataObj.id,
                     "BLTYPE":BloodLineDataObj.bloodline_type
                  };
               }
               this.battleSkillCooldown[BloodLineDataObj.id] = BloodLineDataObj.cooldown;
               return true;
            case "senjutsu":
               SenjutsuDataObj = skilldata.skillData;
               Senjutsueffect = {};
               if(this.isBattleSkillCooldown(SenjutsuDataObj.id))
               {
                  Main.showInfo(String(String(Central.main.langLib.get(384)).replace("[valskillname]",SenjutsuDataObj.name)).replace("[valcooldoen]",this.battleSkillCooldown[SenjutsuDataObj.id]));
                  return false;
               }
               if(this.sp < SenjutsuDataObj.sp)
               {
                  Main.showInfo(Central.main.langLib.get(1862)[1]);
                  return false;
               }
               Main.showInfo(SenjutsuDataObj.name);
               SENdmg = Main.calcSkillDamage(this,SenjutsuDataObj);
               Senjutsueffect = SenjutsuDataObj.effect;
               if(SENdmg != 0)
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":SenjutsuDataObj.posType,
                     "sp":SenjutsuDataObj.sp,
                     "dmg":SENdmg,
                     "effect":Senjutsueffect,
                     "SENSKILLID":SenjutsuDataObj.id
                  };
               }
               else
               {
                  this.battleAction = {
                     "action":action,
                     "skillId":data,
                     "posType":SenjutsuDataObj.posType,
                     "sp":SenjutsuDataObj.sp,
                     "effect":Senjutsueffect,
                     "SENSKILLID":SenjutsuDataObj.id
                  };
               }
               this.battleSkillCooldown[SenjutsuDataObj.id] = SenjutsuDataObj.cooldown;
               return true;
            case "event_action":
               this.battleAction = {"action":action};
         }
         return false;
      }
      
      private function getDamage() : int
      {
         var equippedWeapon:String = this.getWeapon();
         var weapon:Object = Main.WEAPON_DATA.find(equippedWeapon);
         return Formula.calcDamage(weapon);
      }
      
      private function checkCoolDown(outputSkill:Object) : *
      {
         var skillList:Array = null;
         var i:int = 0;
         var skillData:Object = null;
         if(outputSkill.skill_cooldown_group != 0 && outputSkill.skill_cooldown_group)
         {
            skillList = this.getSkillListArr();
            for(i = 0; i < skillList.length; i++)
            {
               skillData = Main.SKILL_DATA[skillList[i]];
               if(skillData.skill_cooldown_group == outputSkill.skill_cooldown_group)
               {
                  this.battleSkillCooldown[skillData.id] = outputSkill.cooldown;
               }
            }
         }
         else
         {
            this.battleSkillCooldown[outputSkill.id] = outputSkill.cooldown;
         }
      }
      
      public function getDBChar() : DBCharacter
      {
         return this.dbChar;
      }
      
      public function getGender() : uint
      {
         return this.dbChar.character_gender;
      }
      
      public function isLevelCap() : Boolean
      {
         if(this.getData(DBCharacterData.RANK) == RankData.GENIN && this.getLevel() >= RankData.GENIN_LEVEL_CAP)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.CHUNIN && this.getLevel() >= RankData.CHUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.JOUNIN)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.JOUNIN && this.getLevel() >= RankData.JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.SPECIAL_JOUNIN)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN && this.getLevel() >= RankData.SPECIAL_JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.TUTOR)
         {
            return true;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && this.getLevel() >= RankData.TUTOR_LEVEL_CAP)
         {
            return true;
         }
         return false;
      }
      
      public function updateXP(_xp:int, isAddPetXP:Boolean = true, tutorAddXp:Boolean = false) : Boolean
      {
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().getData(DBCharacterData.ID))
         {
            return false;
         }
         if(_xp < 0)
         {
            _xp = 0;
         }
         if(isAddPetXP)
         {
            if(this.pet)
            {
               if(this.pet.getLevel() < this.getLevel())
               {
                  this.pet.updateXP(Math.round(_xp * 0.2));
               }
            }
         }
         if(Central.main.getMainChar().getData(DBCharacterData.RANK) >= RankData.TUTOR && (Central.battle && Central.battle.subType != BattleData.SUBTYPE_BOSS && this.getData(DBCharacterData.ID) == Central.main.getMainChar().getData(DBCharacterData.ID)) && !Central.main.addingXPInGashapon)
         {
            _xp = 0;
         }
         if(this.getData(DBCharacterData.RANK) == RankData.GENIN && this.getLevel() >= RankData.GENIN_LEVEL_CAP)
         {
            _xp = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.CHUNIN && this.getLevel() >= RankData.CHUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.JOUNIN)
         {
            _xp = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.JOUNIN && this.getLevel() >= RankData.JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.SPECIAL_JOUNIN)
         {
            _xp = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN && this.getLevel() >= RankData.SPECIAL_JOUNIN_LEVEL_CAP && this.getData(DBCharacterData.RANK) < RankData.TUTOR)
         {
            _xp = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && this.getLevel() >= RankData.TUTOR_LEVEL_CAP)
         {
            _xp = 0;
            return false;
         }
         if(this.getData(DBCharacterData.RANK) >= RankData.TUTOR && !tutorAddXp)
         {
            _xp = 0;
            return false;
         }
         if(!this.securityCheck())
         {
            return false;
         }
         this.dbChar.character_xp = this.dbChar.character_xp + _xp;
         Mission.updateDailyTask(DailyTaskData.TYPE_XP,_xp);
         StaticVariables.xpStr = Sha1Encrypt.encrypt(String(this.xp));
         var level:uint = Formula.getLvByXp(this.xp);
         if(level > this.dbChar.character_level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            Main.tracking.trackLevelUp();
            return true;
         }
         if(this.dbChar.character_level > level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
         }
         return false;
      }
      
      private function verifyLevel() : void
      {
         var level:uint = Formula.getLvByXp(this.xp);
         if(level != this.dbChar.character_level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
         }
      }
      
      public function get xp() : int
      {
         return this.dbChar.character_xp;
      }
      
      public function checkLvUpReward() : void
      {
         if(int(this.getLevel()) <= 9)
         {
            Central.main.amfClient.service("SpecialReward.getLvUpReward",[Central.main.account.getAccountSessionKey()],this.getLvUpRewardResponse);
         }
      }
      
      private function getLvUpRewardResponse(response:Object) : void
      {
         var res:Object = null;
         if(Central.main.validateAmfResponse(response))
         {
            res = response.result;
            Central.main.hasLvUpReward = res.haslvupreward;
            Central.main.lvUpRewardType = int(res.lvuprewardtype);
            Central.main.lvUpTokenClaimed = res.lvuptokenclaimed;
            if(Central.main.hasLvUpReward)
            {
               Central.main.showGuide(Central.main.hasLvUpReward);
            }
         }
      }
      
      public function hasEnoughGold(_gold:uint) : Boolean
      {
         if(this.getGold() - _gold >= 0)
         {
            return true;
         }
         return false;
      }
      
      public function getGold() : uint
      {
         return this.dbChar.character_gold;
      }
      
      public function setGold(_num:int) : void
      {
         this.dbChar.character_gold = _num;
      }
      
      public function setXp(_num:int, _num_pet:int) : void
      {
         Mission.updateDailyTask(DailyTaskData.TYPE_XP,_num - this.xp);
         this.dbChar.character_xp = _num;
         StaticVariables.xpStr = Sha1Encrypt.encrypt(String(_num));
         var level:uint = Formula.getLvByXp(_num);
         var character_level:* = this.dbChar.character_level;
         if(level != character_level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            if(level > character_level)
            {
               Main.tracking.trackLevelUp();
            }
         }
         if(_num_pet)
         {
            this.pet.updateXP(_num_pet - this.pet.xp);
         }
      }
      
      public function updateGold(_gold:int) : void
      {
         this.dbChar.character_gold = this.dbChar.character_gold + _gold;
         if(this.getCharacterId() == Main.getMainChar().getCharacterId())
         {
            Main.achievement.updateCharStat(Main.achievementData.GOLD_OBTAINED,_gold);
         }
      }
      
      public function walkTo(point:Point) : *
      {
         Out.debug("","swf x = " + this.swf.x);
         Out.debug("","swf y = " + this.swf.y);
         this.origPoint.x = this.swf.x;
         this.origPoint.y = this.swf.y;
         Out.debug("","targetPoint x = " + point.x);
         Out.debug("","targetPoint y = " + point.y);
         this.targetPoint.x = point.x;
         this.targetPoint.y = point.y;
         this.walkDuration = Math.ceil(Math.sqrt(Math.pow(point.x - this.swf.x,2) + Math.pow(point.y - this.swf.y,2)) * runSpeed / 100);
         this.walkDuration = this.walkDuration <= 0?uint(1):uint(this.walkDuration);
         this.xStep = 0;
         this.yStep = 0;
         if(this.origPoint.x < this.targetPoint.x)
         {
            this.faceRight();
         }
         else
         {
            this.faceLeft();
         }
         if(!this.onMove)
         {
            this.onMove = true;
            this.playRun();
         }
         this.swf.addEventListener(Event.ENTER_FRAME,this.onEnterWalk);
      }
      
      private function onEnterWalk(evt:Event) : *
      {
         var startPoint:Point = null;
         var enemiesArr:Array = null;
         var s:uint = 0;
         var i:uint = 0;
         var _tmp:Boolean = false;
         var linkMc:MovieClip = null;
         var blockArea:MovieClip = null;
         var npcMc:MovieClip = null;
         var k:* = undefined;
         var nextY:* = undefined;
         var j:* = undefined;
         if((this.xStep <= this.walkDuration || this.yStep <= this.walkDuration) && this.onMove)
         {
            startPoint = new Point(this.swf.x,this.swf.y);
            this.swf.x = this.linearTween(this.xStep,this.origPoint.x,this.targetPoint.x - this.origPoint.x,this.walkDuration);
            this.swf.y = this.linearTween(this.yStep,this.origPoint.y,this.targetPoint.y - this.origPoint.y,this.walkDuration);
            enemiesArr = Mission.getMapMissionEnemies();
            for(s = 0; s < enemiesArr.length; s++)
            {
               if(enemiesArr[s].died == null || enemiesArr[s].died != true)
               {
                  if(enemiesArr[s].enemy.isHitObject(this.hitArea))
                  {
                     GF.removeAllChild(MovieClip(this.swf.parent));
                     enemiesArr[s].enemy.removeParent();
                     this.onMove = false;
                     this.playStand();
                     this.swf.removeEventListener(Event.ENTER_FRAME,this.onEnterWalk);
                     Mission.setCurrentEnemy(s);
                     Mission.getSetting().charPos = new Point(this.swf.x,this.swf.y);
                     Mission.getSetting().charDir = this.swf.scaleX / Math.abs(this.swf.scaleX);
                     Main.setEnemy(enemiesArr[s].enemies);
                     return;
                  }
               }
            }
            if(Central.main.checkGameStatus() == Timeline.MISSION)
            {
               if(Mission.getMapMissionExit())
               {
                  if(this.hitArea.hitTestObject(Mission.getMapMissionExit()))
                  {
                     this.stopWalk();
                     Main.showConfirmation(Central.main.langLib.get(387),Mission.failMission,new Function());
                  }
               }
            }
            _tmp = true;
            if(Mission.getMapMissionType() == MissionData.MAP_TYPE_MULTIPLE)
            {
               linkMc = Mission.getCurrentMap()["linkAreaMc"];
               if(linkMc)
               {
                  for(i = 0; i < linkMc.numChildren; i++)
                  {
                     if(this.shadow.hitTestObject(MovieClip(linkMc.getChildAt(i))))
                     {
                        this.stopWalk();
                        Mission.hitMapMissionLink(i);
                        break;
                     }
                  }
               }
               blockArea = Mission.getCurrentMap()["blockAreaMc"];
               if(blockArea != null)
               {
                  if(blockArea.numChildren > 0)
                  {
                     for(k = 0; k < blockArea.numChildren; k++)
                     {
                        if(this.shadow.hitTestObject(blockArea.getChildAt(k)))
                        {
                           _tmp = false;
                           break;
                        }
                     }
                  }
               }
               npcMc = Mission.getCurrentMap()["npcMc"];
               if(npcMc != null)
               {
                  if(npcMc.numChildren > 0)
                  {
                     for(i = 0; i < npcMc.numChildren; i++)
                     {
                        if(this.swf.hitTestObject(npcMc.getChildAt(i)))
                        {
                           if(Mission.hitMapObject(MovieClip(npcMc.getChildAt(i)).name))
                           {
                              this.stopWalk();
                              break;
                           }
                        }
                     }
                  }
               }
            }
            if(!_tmp)
            {
               nextY = this.swf.y;
               this.swf.y = startPoint.y;
               _tmp = true;
               for(i = 0; i < blockArea.numChildren; i++)
               {
                  if(this.shadow.hitTestObject(blockArea.getChildAt(i)))
                  {
                     _tmp = false;
                     break;
                  }
               }
               if(!_tmp)
               {
                  this.swf.x = startPoint.x;
                  this.swf.y = nextY;
                  _tmp = true;
                  for(j = 0; j < blockArea.numChildren; j++)
                  {
                     if(this.shadow.hitTestObject(blockArea.getChildAt(j)))
                     {
                        _tmp = false;
                        break;
                     }
                  }
                  if(!_tmp)
                  {
                     this.swf.x = startPoint.x;
                     this.swf.y = startPoint.y;
                     this.stopWalk();
                  }
                  else if(this.yStep <= this.walkDuration)
                  {
                     this.yStep++;
                  }
               }
               else if(this.xStep <= this.walkDuration)
               {
                  this.xStep++;
               }
            }
            else
            {
               if(this.xStep <= this.walkDuration)
               {
                  this.xStep++;
               }
               if(this.yStep <= this.walkDuration)
               {
                  this.yStep++;
               }
            }
            if(Math.round(startPoint.x) == Math.round(this.swf.x) && Math.round(startPoint.y) == Math.round(this.swf.y) && (this.xStep > 1 || this.yStep > 1))
            {
               this.stopWalk();
            }
         }
         else
         {
            this.stopWalk();
         }
      }
      
      private function linearTween(t:*, b:*, c:*, d:*) : *
      {
         return c * t / d + b;
      }
      
      public function stopWalk() : void
      {
         this.onMove = false;
         this.playStand();
         this.swf.removeEventListener(Event.ENTER_FRAME,this.onEnterWalk);
      }
      
      public function gotoPoint(pos:Point) : void
      {
         this.swf.x = pos.x;
         this.swf.y = pos.y;
      }
      
      public function faceLeft() : *
      {
         this.swf.scaleX = Math.abs(this.swf.scaleX);
      }
      
      public function faceRight() : *
      {
         this.swf.scaleX = 0 - Math.abs(this.swf.scaleX);
      }
      
      override public function getSwf() : MovieClip
      {
         return super.getSwf();
      }
      
      public function addUsedBattleItem(itemId:String) : void
      {
         this.itemUsedInBattle.push(itemId);
      }
      
      public function securityCheck() : Boolean
      {
         var weapon:String = null;
         var weaponData:Object = null;
         var weaponStr:String = null;
         var petData:Object = null;
         var petStr:String = null;
         if(Main.getMainChar() == null)
         {
            return true;
         }
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().getData(DBCharacterData.ID))
         {
            return true;
         }
         if(Main.coreData.ADMIN_CHARACTERS.indexOf(int(this.getData(DBCharacterData.ID))) >= 0)
         {
            return true;
         }
         if(Account.getAccountType() == Account.PREMIUM)
         {
            Main.provision();
         }
         var _xpSha1String:String = Sha1Encrypt.encrypt(String(this.xp));
         if(_xpSha1String != StaticVariables.xpStr)
         {
            Main.saveLog(1,String(this.xp));
            Main.onError();
            return false;
         }
         if(this.getLevel() <= 0)
         {
            Main.onError();
            return false;
         }
         this.verifyLevel();
         var _weaponStr:String = Sha1Encrypt.encrypt(String(this.dbChar[DBCharacterData.BODY_PARTS]["weapon"]));
         if(_weaponStr != StaticVariables.weaponStr)
         {
            Main.saveLog(2,String(this.dbChar[DBCharacterData.BODY_PARTS]["weapon"]));
            Main.onError();
            return false;
         }
         if(Main.WEAPON_DATA)
         {
            weapon = this.dbChar[DBCharacterData.BODY_PARTS]["weapon"];
            weaponData = Main.WEAPON_DATA.find(weapon);
            if(weaponData)
            {
               if(weaponData.level > this.getLevel() || weaponData[WeaponData.PREMIUM] && Account.getAccountType() == Account.FREE)
               {
                  this.dbChar[DBCharacterData.BODY_PARTS]["weapon"] = "wpn1";
                  StaticVariables.weaponStr = Sha1Encrypt.encrypt("wpn1");
                  Main.saveCharacter(true);
                  Main.saveLog(3,weapon);
                  Main.onError();
                  return false;
               }
               weaponStr = String(weaponData["id"]) + weaponData["gold"] + weaponData["crystal"] + weaponData["sellable"] + weaponData["damage"] + weaponData["rarity"] + weaponData["level"] + weaponData["premium"] + weaponData["agility"] + weaponData["dodge"] + weaponData["critical"] + weaponData["fire"] + weaponData["wind"] + weaponData["lightning"] + weaponData["earth"] + weaponData["water"] + weaponData["vendor"];
            }
         }
         if(this._pet)
         {
            petData = Main.PET_DATA.find(this._pet.id);
            if(petData)
            {
               petStr = String(weaponData["id"]) + petData["swfName"] + petData["clsName"] + petData["type"] + petData["attack_rate"] + petData["defend_rate"] + petData["support_rate"] + petData["gold"] + petData["token"] + petData["premium"] + petData["vendor"] + petData["forge_material"] + petData["forge_base"] + petData["forge_group_id"] + petData["expiry_hour"] + petData["expiry_group_id"] + petData["expiry_token"];
               if(Sha1Encrypt.encrypt(petStr) != petData["hash"] && !Data.TEST_VERSION)
               {
                  Main.onError();
               }
            }
         }
         if(int(this.getData(DBCharacterData.MAX_HP)) != 100)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         if(int(this.getData(DBCharacterData.MAX_CP)) != 100)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         if(int(this.getData(DBCharacterData.AGILITY)) != 10)
         {
            Main.saveCharacter(true);
            Main.onError();
            return false;
         }
         while(this.hasItem(InventoryData.TYPE_SKILL,"skill91"))
         {
            this.removeInventory(InventoryData.TYPE_SKILL,"skill91");
         }
         var equippedSkills:Array = this.getSkillListArr();
         if(equippedSkills.indexOf("skill91") >= 0)
         {
            Main.onError();
            return false;
         }
         return true;
      }
      
      public function getSenjutsuSwfArr() : Array
      {
         return this.senjutsuSwfArr;
      }
      
      public function getSecretListArr() : Array
      {
         var i:int = 0;
         var value3:Object = null;
         var bloodline_skill_obj:Object = null;
         var bloodline_header_obl:Object = null;
         var SecretList:Array = [];
         if(this.dbChar.bloodline == null)
         {
            return [];
         }
         for each(value3 in this.dbChar.bloodline)
         {
            if(Main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id] && Main.BLOODLINE_DATA["bloodline" + value3.bloodline_id])
            {
               bloodline_skill_obj = Main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id];
               bloodline_header_obl = Main.BLOODLINE_DATA["bloodline" + value3.bloodline_id];
               if(bloodline_skill_obj.bloodline_type == BloodlineData.SKILL_TYPE_ACTIVE && bloodline_header_obl.type == BloodlineData.SKILL_TYPE_SECRET)
               {
                  SecretList.push(value3);
               }
            }
         }
         return SecretList;
      }
      
      public function getPassiveListArr() : Array
      {
         var i:int = 0;
         var value3:Object = null;
         var bloodline_skill_obj:Object = null;
         var bloodline_header_obl:Object = null;
         var value:Object = null;
         var senjutsu_skill_obj:Object = null;
         var passiveList:Array = [];
         if(this.dbChar.bloodline != null)
         {
            for each(value3 in this.dbChar.bloodline)
            {
               if(Main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id] && Main.BLOODLINE_DATA["bloodline" + value3.bloodline_id])
               {
                  bloodline_skill_obj = Main.BLOODLINE_SKILL_DATA["bloodline_skill" + value3.skill_id];
                  bloodline_header_obl = Main.BLOODLINE_DATA["bloodline" + value3.bloodline_id];
                  if(bloodline_skill_obj.bloodline_type == BloodlineData.SKILL_TYPE_PASSIVE)
                  {
                     if(Central.battle.type == Central.battle.TYPE_NETWORK)
                     {
                        if(Central.main.resurrection == true)
                        {
                           if(!(!this.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && value3.bloodline_id == 1))
                           {
                              passiveList.push(value3);
                           }
                        }
                        else
                        {
                           passiveList.push(value3);
                        }
                     }
                     else if(!(!this.isBattleBuffActive(BloodlineData.EFFECT_COPY_JUTSU + ".skill1023") && value3.bloodline_id == 1))
                     {
                        passiveList.push(value3);
                     }
                  }
               }
            }
         }
         if(this.dbChar.senjutsu != null)
         {
            for each(value in this.dbChar.senjutsu)
            {
               if(Main.SENJUTSU_SKILL_DATA["senjutsu_skill" + value.skill_id] && Main.SENJUTSU_DATA["senjutsu" + value.senjutsu_id])
               {
                  senjutsu_skill_obj = Main.SENJUTSU_SKILL_DATA["senjutsu_skill" + value.skill_id];
                  if(senjutsu_skill_obj.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                  {
                     passiveList.push(value);
                  }
               }
            }
         }
         return passiveList;
      }
      
      public function getBloodlineSwfArr() : Array
      {
         return this.bloodlineSwfArr;
      }
      
      public function getSecretSwfArr() : Array
      {
         return this.secretSwfArr;
      }
      
      public function setBloodlineSwf(BloodlineSwf:MovieClip) : void
      {
         this.bloodlineSwfArr.push(BloodlineSwf);
         BloodlineSwf.setActionFinishCB(this.actionFinish_CB);
         BloodlineSwf.setAttackHitCB(this.attackHit_CB);
      }
      
      public function setSecretSwf(SecretSwf:MovieClip) : void
      {
         this.secretSwfArr.push(SecretSwf);
         SecretSwf.setActionFinishCB(this.actionFinish_CB);
         SecretSwf.setAttackHitCB(this.attackHit_CB);
      }
      
      public function playClassSkill(_battleAction:Object, _attackPoint:Point) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         Out.debug(this,"_battleAction.skillId >> " + _battleAction.skillId);
         if(handleAgsinstSkillMemHack(_battleAction.skillId))
         {
            return;
         }
         var skillMc:MovieClip = this.classSkillSwfArr[this.getClassSkillListArr().indexOf(_battleAction.skillId)];
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
         this.swf.addChild(skillMc);
         skillMc.playAnimation(_battleAction,_attackPoint);
      }
      
      public function playSkill(_battleAction:Object, _attackPoint:Point) : void
      {
         this.isPlayingAnimation = true;
         this.clearSwf();
         if(handleAgsinstSkillMemHack(_battleAction.skillId))
         {
            return;
         }
         var skillMc:MovieClip = this.skillSwfArr[this.getSkillListArr().indexOf(_battleAction.skillId)];
         if(skillMc == null)
         {
            skillMc = Central.skill.getSkill(_battleAction.skillId);
            this.cloneCustomization(skillMc);
            skillMc.setActionFinishCB(this.actionFinish_CB);
            skillMc.setAttackHitCB(this.attackHit_CB);
         }
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
         this.swf.addChild(skillMc);
         skillMc.playAnimation(_battleAction,_attackPoint);
      }
      
      override protected function initSkill2003Lv() : void
      {
         var battleFrame:MovieClip = MovieClip(this.charMc.parent);
         if(battleFrame["skill_2003_storage"])
         {
            battleFrame["skill_2003_storage"].visible = false;
            this.skill_2003_lv = -1;
         }
         for(var i:* = 0; i < classSkillList.length; i++)
         {
            if(classSkillList[i] == "skill2003")
            {
               isClassSkillAvailable[i] = false;
            }
         }
      }
      
      public function updateSkill2003Lv() : void
      {
         var battleFrame:MovieClip = null;
         Out.debug(this,this.getCharacterName() + " :: updateSkill2003Lv :: classSkillList >> " + this.classSkillList + " :: skill_2003_lv >> " + this.skill_2003_lv);
         var skill2003Exist:Boolean = false;
         for(var i:* = 0; i < classSkillList.length; i++)
         {
            if(classSkillList[i] == "skill2003")
            {
               if(!isClassSkillAvailable[i])
               {
                  battleFrame = MovieClip(this.charMc.parent);
                  if(battleFrame["skill_2003_storage"])
                  {
                     if(this.skill_2003_lv == 0)
                     {
                        battleFrame["skill_2003_storage"].visible = false;
                     }
                     this.skill_2003_lv++;
                     if(this.skill_2003_lv <= 7)
                     {
                        if(this.skill_2003_lv == 7)
                        {
                           isClassSkillAvailable[i] = true;
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function setBattleBuff(effect:Object) : Boolean
      {
         var tmpEffect:Object = null;
         var characterWeapon:Object = null;
         super.setBattleBuff(effect);
         if(Central.battle.type != Central.battle.TYPE_NETWORK)
         {
            if(this.getWeapon())
            {
               characterWeapon = Central.main.WEAPON_DATA.find(this.getWeapon());
               if(characterWeapon && int(effect.duration) < 100)
               {
                  for each(tmpEffect in characterWeapon.effect)
                  {
                     switch(tmpEffect.type)
                     {
                        case BattleData.EFFECT_ADD_HP_CP_RECIEVE_BUFF:
                           this.updateHP(Math.round(this.maxHP * (tmpEffect.amount * 0.01)));
                           this.updateCP(Math.round(this.maxCP * (tmpEffect.amount * 0.01)));
                           this.showOverheadNumber(Timeline.WORD,"+" + Math.round(this.maxHP * (tmpEffect.amount * 0.01)) + " HP");
                           this.showOverheadNumber(Timeline.WORD,"+" + Math.round(this.maxCP * (tmpEffect.amount * 0.01)) + " CP");
                           return false;
                        default:
                           continue;
                     }
                  }
               }
            }
         }
         return true;
      }
      
      public function showLevelUp(boolean:Boolean) : *
      {
         if(!isLevelUp)
         {
            isLevelUp = boolean;
         }
      }
      
      private function handleAgsinstSkillMemHack(skillId:String) : Boolean
      {
         var skillData:Object = Main.SKILL_DATA[skillId];
         var skillStr:* = String(skillData["id"]) + skillData["dbid"] + skillData["gold"] + skillData["crystal"] + skillData["prestige"] + skillData["pvp_point"] + skillData["merit"] + skillData["damage"] + skillData["rarity"] + skillData["cp"] + skillData["cooldown"] + skillData["level"] + skillData["premium"] + skillData["vendor"] + skillData["train_time"];
         if(skillData["hash"] != Sha1Encrypt.encrypt(skillStr))
         {
            Main.onError("304");
            return true;
         }
         var skillEffectStr:String = String(skillData.id) + String(skillData.effect.type) + String(skillData["effect"]["duration"]) + String(skillData["effect"]["amount"]) + String(skillData.swfName);
         if(skillData["effect"]["hash"] != Sha1Encrypt.encrypt(skillEffectStr))
         {
            Main.onError("304");
            return true;
         }
         return false;
      }
   }
}
