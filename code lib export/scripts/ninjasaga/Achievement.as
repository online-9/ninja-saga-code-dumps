package ninjasaga
{
   import com.utils.GF;
   import com.utils.Out;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.AppData;
   import ninjasaga.data.SNSData;
   
   public class Achievement
   {
      
      private static var instance:ninjasaga.Achievement;
       
      
      private var battleStat:Object;
      
      private var charStat:Object;
      
      public var gotAchievement:Array;
      
      public var wallfeedQueue:Array;
      
      public var wallfeedProcessing:Boolean = false;
      
      public function Achievement(pKey:SingletonBlocker)
      {
         gotAchievement = [];
         wallfeedQueue = [];
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Achievement.getInstance() instead of new.");
         }
         this.initBattleStat();
         this.initCharStat();
      }
      
      public static function getInstance() : ninjasaga.Achievement
      {
         if(instance == null)
         {
            instance = new ninjasaga.Achievement(new SingletonBlocker());
         }
         return instance;
      }
      
      public function updateBattleStat(type:int, value:int, forceFlush:Boolean = false) : void
      {
         this.battleStat[type] = this.battleStat[type] + value;
         var typeName:String = Main.achievementData.getAchievementTypeData(type);
         Main.getMainChar().statisticBattle[typeName] = int(Main.getMainChar().statisticBattle[typeName]) + value;
         var achievementId:int = this.checkAchievement(type,int(Main.getMainChar().statisticBattle[typeName]));
         if(achievementId > 0 || forceFlush == true)
         {
            this.flushBattleStat();
         }
      }
      
      public function flushBattleStat() : void
      {
         var hash:String = Main.getHash("Achievement.flushBattleStat" + GF.objectToArray(this.battleStat).toString());
         Main.amfClient.service("Achievement.flushBattleStat",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),hash,this.battleStat],this.flushBattleStatResponse);
         this.initBattleStat();
      }
      
      private function flushBattleStatResponse(response:Object) : void
      {
         var i:uint = 0;
         var type:int = 0;
         var typeName:String = null;
         var achievementId:int = 0;
         if(Main.validateAmfResponse(response))
         {
            for(i = 0; i < Main.achievementData.ALL_BATTLE_STAT.length; i++)
            {
               type = Main.achievementData.ALL_BATTLE_STAT[i];
               typeName = Main.achievementData.getAchievementTypeData(type);
               achievementId = this.checkAchievement(type,int(Main.getMainChar().statisticBattle[typeName]));
               if(achievementId > 0)
               {
                  Out.debug(this,"going to validate achievement >> " + achievementId);
                  this.validateAchievement(achievementId);
               }
            }
         }
      }
      
      private function initBattleStat() : void
      {
         var i:uint = 0;
         var stat:int = 0;
         this.battleStat = {};
         for(i = 0; i < Main.achievementData.ALL_BATTLE_STAT.length; i++)
         {
            stat = Main.achievementData.ALL_BATTLE_STAT[i];
            this.battleStat[stat] = 0;
         }
      }
      
      public function updateCharStat(type:int, value:int = 1, forceFlush:Boolean = false) : void
      {
         this.charStat[type] = this.charStat[type] + value;
         var typeName:String = Main.achievementData.getAchievementTypeData(type);
         Main.getMainChar().statisticChar[typeName] = int(Main.getMainChar().statisticChar[typeName]) + value;
         var statValue:int = Main.getMainChar().statisticChar[typeName];
         var achievementId:int = this.checkAchievement(type,statValue);
         if(int(this.charStat[Main.achievementData.GOLD_OBTAINED]) >= Main.getMainChar().getLevel() * 50)
         {
            forceFlush = true;
         }
         if(int(this.charStat[Main.achievementData.FRIEND_VISITED]) >= 2)
         {
            forceFlush = true;
         }
         if(int(this.charStat[Main.achievementData.CHALLENGE_DONE]) >= 1)
         {
            forceFlush = true;
         }
         if(int(this.charStat[Main.achievementData.FRIEND_RECRUITED]) >= 2)
         {
            forceFlush = true;
         }
         if(int(this.charStat[Main.achievementData.WALLFEED_POSTED]) >= 1)
         {
            forceFlush = true;
         }
         if(achievementId > 0 || forceFlush == true)
         {
            this.flushCharStat();
         }
      }
      
      public function flushCharStat() : void
      {
         var str:String = GF.objectToArray(this.charStat).toString();
         Out.debug(this,"flushCharStat :: str >> " + str);
         var hash:String = Main.getHash("Achievement.flushCharStat" + str);
         Main.amfClient.service("Achievement.flushCharStat",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),hash,this.charStat],this.flushCharStatResponse);
         this.initCharStat();
      }
      
      private function flushCharStatResponse(response:Object) : void
      {
         var i:uint = 0;
         var type:int = 0;
         var typeName:String = null;
         var statValue:int = 0;
         var achievementId:int = 0;
         if(Main.validateAmfResponse(response))
         {
            for(i = 0; i < Main.achievementData.ALL_CHAR_STAT.length; i++)
            {
               type = Main.achievementData.ALL_CHAR_STAT[i];
               typeName = Main.achievementData.getAchievementTypeData(type);
               statValue = Main.getMainChar().statisticChar[typeName];
               achievementId = this.checkAchievement(type,statValue);
               if(achievementId > 0)
               {
                  this.validateAchievement(achievementId);
               }
            }
         }
      }
      
      private function initCharStat() : void
      {
         var i:uint = 0;
         var stat:int = 0;
         this.charStat = {};
         for(i = 0; i < Main.achievementData.ALL_CHAR_STAT.length; i++)
         {
            stat = Main.achievementData.ALL_CHAR_STAT[i];
            this.charStat[stat] = 0;
         }
      }
      
      private function checkAchievement(type:int, statValue:int) : int
      {
         var achievementData:Object = null;
         var achievementReq:int = 0;
         var achievementArr:Array = this.getAchievementByType(type);
         var previousReq:int = 0;
         var achievementId:int = 0;
         for(var i:int = 0; i < achievementArr.length; i++)
         {
            achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
            achievementReq = achievementData.requirement;
            if(achievementReq > previousReq && statValue >= achievementReq)
            {
               if(Main.getMainChar().achievement.indexOf(achievementData.id) >= 0)
               {
                  achievementId = 0;
               }
               else
               {
                  previousReq = achievementReq;
                  achievementId = achievementData.id;
               }
            }
         }
         return achievementId;
      }
      
      public function getProgress(type:int, statValue:int, char:Object = null) : Object
      {
         var mainChar:* = undefined;
         var achievementData:Object = null;
         var achievementReq:int = 0;
         if(char == null)
         {
            mainChar = Main.getMainChar();
         }
         else
         {
            mainChar = char;
         }
         var achievementArr:Array = this.getAchievementByType(type);
         var previousReq:int = 0;
         var achievementId:int = 0;
         var progressValue:int = 0;
         for(var i:int = 0; i < achievementArr.length; i++)
         {
            achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
            achievementReq = achievementData.requirement;
            if((previousReq > achievementReq || previousReq == 0) && mainChar.achievement.indexOf(achievementData.id) < 0)
            {
               achievementId = achievementData.id;
               progressValue = achievementReq - statValue;
               previousReq = achievementReq;
            }
         }
         var rtnObj:Object = {};
         rtnObj.achievementId = achievementId;
         rtnObj.progressValue = progressValue;
         return rtnObj;
      }
      
      public function checkSpecialAchievement(type:int) : void
      {
         var invSkill:Array = null;
         var i:int = 0;
         var k:int = 0;
         var achievementArr:Array = null;
         var achievementData:Object = null;
         var invMission:Object = null;
         var kinjutsu:int = 0;
         var skillData:Object = null;
         var missionRequired:Array = null;
         var achievementId:int = 0;
         switch(type)
         {
            case Main.achievementData.SKILL_TRAINED:
               invSkill = Main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
               achievementId = this.checkAchievement(type,invSkill.length);
               break;
            case Main.achievementData.NINJA_EMBLEM:
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  achievementArr = this.getAchievementByType(Main.achievementData.NINJA_EMBLEM);
                  for(i = 0; i < achievementArr.length; i++)
                  {
                     achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
                     if(Main.getMainChar().achievement.indexOf(achievementData.id) < 0)
                     {
                        achievementId = achievementData.id;
                     }
                  }
               }
               break;
            case Main.achievementData.KINJUTSU_TRAINED:
               invSkill = Main.getMainChar().getInventory(InventoryData.TYPE_SKILL);
               kinjutsu = 0;
               for(i = 0; i < invSkill.length; i++)
               {
                  skillData = Main.SKILL_DATA[invSkill[i]];
                  if(skillData.rarity == 4 || skillData.rarity == 5)
                  {
                     kinjutsu++;
                  }
               }
               achievementId = this.checkAchievement(type,kinjutsu);
               break;
            case Main.achievementData.SPECIFIC_MISSION_COMPLETED:
               invMission = Main.getMainChar().getInventory(InventoryData.TYPE_MISSION);
               achievementArr = this.getAchievementByType(Main.achievementData.SPECIFIC_MISSION_COMPLETED);
               for(i = 0; i < achievementArr.length; i++)
               {
                  achievementData = Main.ACHIEVEMENT_DATA.find(achievementArr[i]);
                  if(Main.getMainChar().achievement.indexOf(achievementData.id) < 0)
                  {
                     missionRequired = String(achievementData.requirement).split(",");
                     for(k = 0; k < missionRequired.length; k++)
                     {
                        if(invMission["msn" + missionRequired[k]] != null)
                        {
                           if(invMission["msn" + missionRequired[k]].success)
                           {
                              achievementId = achievementData.id;
                              break;
                           }
                        }
                     }
                  }
               }
         }
         if(achievementId > 0)
         {
            this.validateAchievement(achievementId);
         }
      }
      
      public function checkOfflineAchievement() : void
      {
         var achievementId:int = this.checkAchievement(Main.achievementData.FRIEND_INVITED,int(Main.getMainChar().statisticChar[Main.achievementData.getAchievementTypeData(Main.achievementData.FRIEND_INVITED)]));
         this.validateAchievement(achievementId);
         achievementId = 0;
         achievementId = this.checkAchievement(Main.achievementData.DAYS_PLAYED,int(Main.getMainChar().statisticChar[Main.achievementData.getAchievementTypeData(Main.achievementData.DAYS_PLAYED)]));
         this.validateAchievement(achievementId);
      }
      
      private function validateAchievement(achievementId:int) : void
      {
         var hash:String = null;
         if(Central.main.getMainChar().getLevel() >= 2)
         {
            if(achievementId > 0)
            {
               trace("achievementId--->" + achievementId);
               hash = Main.getHash("Achievement.validate" + String(achievementId));
               Main.amfClient.service("Achievement.validate",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),hash,achievementId],this.validateResponse);
            }
         }
      }
      
      private function validateResponse(response:Object) : void
      {
         var achievementId:int = 0;
         var achievementData:Object = null;
         var extraAchievement:Array = null;
         var i:int = 0;
         if(Main.validateAmfResponse(response))
         {
            if(response.achievement_id != null)
            {
               achievementId = response.achievement_id;
               Main.getMainChar().achievement.push(achievementId);
               this.gotAchievement.push(achievementId);
               Main.popup.showAchievement();
               achievementData = Main.ACHIEVEMENT_DATA.find(achievementId);
               Main.getMainChar().achievementPoint = Main.getMainChar().achievementPoint + achievementData.achievement_point;
               if(response.extra_achievement)
               {
                  extraAchievement = response.extra_achievement;
                  for(i = 0; i < extraAchievement.length; i++)
                  {
                     Main.getMainChar().achievement.push(int(extraAchievement[i]));
                  }
               }
               if(response.recent_achievement)
               {
                  Main.getMainChar().recentAchievement = response.recent_achievement as Array;
               }
               if(this.wallfeedQueue.length < 3 && AppData.type == AppData.FB)
               {
                  this.wallfeedQueue.push(achievementId);
                  this.procWallfeedQueue();
               }
            }
         }
      }
      
      private function procWallfeedQueue() : void
      {
         var achievementId:int = 0;
         var achievementData:Object = null;
         if(this.wallfeedProcessing == false && this.wallfeedQueue.length > 0)
         {
            this.wallfeedProcessing = true;
            achievementId = this.wallfeedQueue.shift();
            achievementData = Main.ACHIEVEMENT_DATA.find(achievementId);
            SNS.publishFeed(SNSData.FEED_ACHIEVEMENT_GAIN,"ach_" + achievementData.id,achievementData.name,String(achievementData.description).toLowerCase(),this.shareWallfeedCallback);
         }
      }
      
      private function shareWallfeedCallback() : void
      {
         this.wallfeedProcessing = false;
         this.procWallfeedQueue();
      }
      
      private function getAchievementByType(achievementType:int) : Array
      {
         var achievementArr:Array = [];
         var allAchArr:Array = Main.ACHIEVEMENT_DATA.toArray();
         for(var i:int = 0; i < allAchArr.length; i++)
         {
            if(allAchArr[i].type == achievementType)
            {
               achievementArr.push(allAchArr[i].id);
            }
         }
         return achievementArr;
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
