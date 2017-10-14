package ninjasaga
{
   import ninjasaga.data.Data;
   
   public class TrackingSystem
   {
      
      private static var instance:ninjasaga.TrackingSystem;
      
      public static var trackingCache:Object = {};
       
      
      private const MIN_CHAR_LEVEL:int = 1;
      
      private const MAX_CHAR_LEVEL:int = 100;
      
      private var charLevel:int;
      
      private var startActionTracked:int = 0;
      
      private const MAX_ACTION_TRACK:int = 8;
      
      public const TRACK2_CREATE_ACCOUNT:String = "ca";
      
      public const TRACK2_DAILY_LOGIN:String = "dl";
      
      public const TRACK2_CREATE_CHAR:String = "cc";
      
      public const TRACK2_TUTORIAL:String = "tu";
      
      public const TRACK2_LEVEL_UP:String = "lu";
      
      public const TRACK2_NEWS_PANEL:String = "np";
      
      public const TRACK2_EVENT_START:String = "EvtStart";
      
      public const TRACK2_EVENT_COMPLETE:String = "EvtCpt";
      
      public const TRACK2_CLICK_DIALOG_1:String = "ClkDia1";
      
      public const TRACK2_CLICK_DIALOG_2:String = "ClkDia2";
      
      public const TRACK2_CLICK_DIALOG_3:String = "ClkDia3";
      
      public const TRACK2_CLICK_DIALOG_4:String = "ClkDia4";
      
      public const TRACK2_CLICK_ATTACK:String = "ClkAtt";
      
      public const TRACK2_CLICK_CHARGE:String = "ClkCha";
      
      public const TRACK2_CLICK_SKILL:String = "ClkSki";
      
      public const TRACK2_CLICK_BONUS:String = "ClkBonus";
      
      public const TRACK2_CLICK_SUCCESS:String = "ClkSucc";
      
      public const TRACK2_CLICK_RANDOM:String = "ClkRandom";
      
      public const TRACK2_CLICK_CREATE:String = "ClkCreate";
      
      public const TRACK2_CLICK_CLOSE:String = "ClkClose";
      
      public const TRACK2_CHOOSE_SKILL:String = "ChooseSkill";
      
      public const TRACK_CREATE_CHAR:String = "CreateChar";
      
      public const TRACK_TUTORIAL:String = "Tutorial";
      
      public const TRACK_LEVLEUP:String = "LevelUp";
      
      public const TRACK_BUILDINGSELECT:String = "BuildingSelect";
      
      public const TRACK_START_ACTION:String = "StartAction";
      
      public const SA_MISSION:String = "Mission";
      
      public const SA_TRAIN_SKILL:String = "TrainSkill";
      
      public const SA_BUY_ITEM:String = "BuyItem";
      
      public const SA_SELL_ITEM:String = "SellItem";
      
      public const SA_CHANGE_APPEARANCE:String = "ChangeAppearance";
      
      public const SA_CONVERT_TOKEN:String = "ConvertToken";
      
      public const SA_BUY_PET:String = "BuyPet";
      
      public const SA_DISCOVER_TALENT:String = "DiscoverTalent";
      
      public const SA_LIVE_PVP:String = "LivePvP";
      
      public const SA_HUNT_BOSS:String = "HuntBoss";
      
      public const SA_RECRUIT_FRIEND:String = "RecruitFriend";
      
      public const SA_PRACTICE_BATTLE:String = "PracticeBattle";
      
      public const SA_CHALLENGE_FRIEND:String = "ChallengeFriend";
      
      public const SA_DAILY_GIFT:String = "DailyGift";
      
      public const SA_CHECK_MAIL:String = "CheckMail";
      
      public const SA_CONVERT_TP:String = "ConvertTP";
      
      public const SA_TRAIN_TALENT:String = "TrainTalent";
      
      public const SA_PET_SKILL:String = "PetSkill";
      
      public const SA_LUCKY_DRAW:String = "LuckyDraw";
      
      public const SA_INVITE_REWARD:String = "InviteReward";
      
      public const SA_VISIT_FRIEND:String = "StartVisitFriend";
      
      public const SA_INVITE_RANK:String = "InviteRank";
      
      public const SA_DAILY_CLAIM:String = "DailyClaim";
      
      public const TRACK_SALE:String = "Sale";
      
      public const SALE_SKILL:String = "Skill";
      
      public const SALE_WEAPON:String = "Weapon";
      
      public const SALE_CLOTHING:String = "Clothing";
      
      public const SALE_BACK_ITEM:String = "BackItem";
      
      public const SALE_CONSUMABLE:String = "Consumable";
      
      public const SALE_HAIR_STYLE:String = "HairStyle";
      
      public const SALE_WEAPON_UPGRADE:String = "WeaponUpgrade";
      
      public const SALE_CONVERT_TOKEN:String = "ConvertToken";
      
      public const SALE_NPC:String = "RecruitNPC";
      
      public const SALE_PET:String = "Pet";
      
      public const SALE_BLOODLINE:String = "Bloodline";
      
      public const SALE_CONVERT_TP:String = "ConvertTP";
      
      public const TRACK_SALE_BY_LEVEL:String = "SaleByLevel";
      
      public const TRACK_MISSION:String = "MissionSuccess";
      
      public const TRACK_ERROR_CODE:String = "ErrorCode";
      
      public const TRACK_CLAN:String = "Clan";
      
      public const CLAN_BATTLE_MANUAL:String = "clan_battle_manual";
      
      public const CLAN_BATTLE_QUICK:String = "clan_battle_quick";
      
      public const TRACK_STAMINA:String = "stamina";
      
      public const TRACK_UPGRADE:String = "upgrade";
      
      public const TRACK_REFILL:String = "refill";
      
      public const TRACK_LVUPREWARD:String = "LvUpReward";
      
      public const LVUPREWARD_CLOSE:String = "closeBtn";
      
      public const LVUPREWARD_GOTO:String = "goBtn";
      
      public const TRACK_GET_TOKEN:String = "GetToken";
      
      public const TRACK_GET_GOLD:String = "GetGold";
      
      public const TRACK_PURCHASE:String = "Purchase";
      
      public const TRACK_GO:String = "Go";
      
      public const TRACK_CLOSE:String = "Close";
      
      public const TRACK_PREMIUM:String = "Premium";
      
      public const TRACK_FREE:String = "Free";
      
      public const TRACK_LOGIN:String = "Login";
      
      public const TRACK_UNIQUE:String = "Unique";
      
      public const TRACK_LONGIN_LV:String = "LoginByLevel_FreeUnique";
      
      public const TRACK_SHOP:String = "Shop";
      
      public const TRACK_BUY:String = "Buy";
      
      public const TRACK_BUY_WEAPON:String = "WeaponBuy";
      
      public const TRACK_BUY_CLOTH:String = "ClothBuy";
      
      public const TRACK_BUY_BACKITEM:String = "BackitemBuy";
      
      public const TRACK_BUY_ITEM:String = "ItemBuy";
      
      public const TRACK_BUY_PACKAGE:String = "PackageBuy";
      
      public const TRACK_PURCHASE_WEAPON:String = "PurchaseWea";
      
      public const TRACK_PURCHASE_CLOTH:String = "PurchaseClo";
      
      public const TRACK_PURCHASE_BACKITEM:String = "PurchaseBac";
      
      public const TRACK_PURCHASE_ITEM:String = "PurchaseIte";
      
      public const TRACK_PURCHASE_PACKAGE:String = "PurchasePac";
      
      public const TRACK_GET_TOKEN_WEAPON:String = "GetTokenWea";
      
      public const TRACK_GET_TOKEN_CLOTH:String = "GetTokenClo";
      
      public const TRACK_GET_TOKEN_BACKITEM:String = "GetTokenBac";
      
      public const TRACK_GET_TOKEN_ITEM:String = "GetTokenIte";
      
      public const TRACK_GET_TOKEN_PACKAGE:String = "GetTokenPac";
      
      public const TRACK_GET_GOLD_WEAPON:String = "GetGoldWea";
      
      public const TRACK_GET_GOLD_CLOTH:String = "GetGoldClo";
      
      public const TRACK_GET_GOLD_BACKITEM:String = "GetGoldBac";
      
      public const TRACK_GET_GOLD_ITEM:String = "GetGoldIte";
      
      public const TRACK_GET_GOLD_PACKAGE:String = "GetGoldPac";
      
      public const TRACK_SELL:String = "Sell";
      
      public const TRACK_SELL_CONFIRM:String = "ConfirmSell";
      
      public const TRACK_BLACKSMITH:String = "Blacksmith";
      
      public const TRACK_FORGE:String = "Forge";
      
      public const TRACK_FORGE_TOKEN:String = "ForgeToken";
      
      public const TRACK_RECRUIT:String = "Recruit";
      
      public const TRACK_RECRUIT_FRD:String = "RecruitFrd";
      
      public const TRACK_RECRUIT_NPC:String = "RecruitNPC";
      
      public const TRACK_PURCHASE_FRD:String = "PurchaseFrd";
      
      public const TRACK_PURCHASE_NPC:String = "PurchaseNPC";
      
      public const TRACK_TALENT:String = "Talent";
      
      public const TRACK_EXTREME:String = "Extreme";
      
      public const TRACK_SECRET:String = "Secret";
      
      public const TRACK_DISCOVER_EXTREME:String = "DiscoverExt";
      
      public const TRACK_DISCOVER_SECRET:String = "DiscoverSec";
      
      public const TRACK_GET_TOKEN_EXTREME:String = "GetTokenExt";
      
      public const TRACK_GET_GOLD_EXTREME:String = "GetGoldExt";
      
      public const TRACK_GET_TOKEN_SECRET:String = "GetTokenSec";
      
      public const TRACK_GET_GOLD_SECRET:String = "GetGoldSec";
      
      public const TRACK_DEAD_FAIL:String = "DeadFail";
      
      public const TRACK_PET_SHOP:String = "PetShop";
      
      public const TRACK_PREVIEW_PET:String = "PreviewPet_";
      
      public const TRACK_PURCHASE_PET:String = "PurchasePet_";
      
      public const TRACK_GET_TOKEN_PET:String = "GetTokenPet";
      
      public const TRACK_GET_GOLD_PET:String = "GetGoldPet";
      
      public const TRACK_APP_LANG:String = "AppLanguage";
      
      public const TRACK_ACADEMY:String = "Academy";
      
      public const TRACK_PURCHASE_SKILL:String = "PurchaseSkill_";
      
      public const TRACK_INVITE:String = "InviteFrd";
      
      public const TRACK_EMBLEM_PAGE:String = "EmblemPage";
      
      public const TRACK_RESET_SKILL:String = "ResetSkill";
      
      public const TRACK_RESET_SKILL_PRICE_FREE:int = 1000;
      
      public const TRACK_RESET_SKILL_PRICE_PREMIUM:int = 200;
      
      public const TRACK_RESET_TALENT:String = "ResetTalent";
      
      public const TRACK_RESET:String = "Reset_";
      
      public const TRACK_VISIT_FRIEND:String = "VisitFriend";
      
      public const TRACK_VISIT_NUMBER:String = "NumberOfVisiting";
      
      public const TRACK_VISIT_TOTAL:String = "Total";
      
      public const TRACK_VISIT_CLICK:String = "Clicks";
      
      public const TRACK_VISIT_ADVERTISEMENT:String = "Advertisment";
      
      public const TRACK_VISIT_PROFILE:String = "Profile";
      
      public const TRACK_VISIT_LEARNSKILLS:String = "LearnSkills";
      
      public const SALE_TALENT:String = "Talent";
      
      public const TRACK_SALE_GOLD:String = "SaleGold";
      
      public const TRACK_ITEMS:String = "Items";
      
      public const TRACK_EXAM_SUCCESS_FREE = "ExamSuccessFree";
      
      public const TRACK_EXAM_SUCCESS_PREMIUM = "ExamSuccessPremium";
      
      public const TRACK_EXAM_START_PREMIUM = "ExamStartPremium";
      
      public const TRACK_EXAM_FAIL_FREE = "ExamFailFree";
      
      public const TRACK_EXAM_FAIL_PREMIUM = "ExamFailPremium";
      
      public const TRACK_CORRECT = "Correct";
      
      public const TRACK_WRONG = "Wrong";
      
      public const TRACK_PASS = "Pass";
      
      public const TRACK_SPECIAL_JOUNIN_CLASS:String = "SpecialJouninClass";
      
      public const TRACK_EVENT:String = "Event";
      
      public const TRACK_RECRUIT_FROM_MISSION = "FromMission";
      
      public const TRACK_RECRUIT_FROM_RECRUIT = "FromRecruit";
      
      public const TRACK_DAILY_LOGIN = "Daily_login";
      
      public const TRACK_DAY = "Day";
      
      public const TRACK_NEW_CONSUMABLE_FREE = "New_Consumable_Free";
      
      public const TRACK_NEW_CONSUMABLE_PREMIUM = "New_Consumable_Premium";
      
      public const TRACK_TOKEN_CONSUMABLE_USED = "Token_Consumable_Used";
      
      public const TRACK_HUNTING_HOUSE = "Hunting_House";
      
      public const TRACK_CONSUMABLE_USE_MISSION = "Mission";
      
      public const TRACK_REDUCE_TRAINING_TIME = "Reduce_Training_Time";
      
      public const TRACK_REDUCE_CONFIRM = "Reduce_Confirm";
      
      public const TRACK_REDUCE_ACCEPT = "Reduce_Accept";
      
      public const TRACK_REDUCE_INGORE = "Reduce_Ingore";
      
      public const TRACK_REDUCE_REJECT = "Reduce_Reject";
      
      public const TRACK_ADD_BATTLE_HEART = "Add_Battle_Heart";
      
      public const TRACK_ADD_CRYSTAL_KARI = "Add_Crystal_Kari";
      
      public const TRACK_ADD_FRIENDSHIP_KUNAI = "Add_friendship_kunai";
      
      public const TRACK_TOKEN_SOURCE = "Token_Source";
      
      public const TRACK_FRIENDSHIP_KUNAI = "Friendship_Kunai";
      
      public const SA_NEW_DAILY_SCRATCH = "New_Daily_Scratch";
      
      public const TRACK_DAILY_SCRATCH = "Daily_Scratch";
      
      public const TRACK_DAILY_TOKEN_SOURCES = "Daily_Token_Sources";
      
      public const TRACK_DAILY_LOGIN_SCRATCH = "Daily_Login_Scratch";
      
      public const TRACK_TOTAL_SCRATCH = "Total_Scratch";
      
      public const TRACK_FREE_SCRATCH = "Free_Scratch";
      
      public const TRACK_LEVEL_CAP = "Level_Cap";
      
      public const TRACK_NOT_LEVEL_CAP = "Not_Level_Cap";
      
      public const TRACK_FREE_STAGE_FIRST_CLAIM = "Free_Stage_FirstClaim";
      
      public const TRACK_SALE_PREMIUM = "Sale_Premium";
      
      public const TRACK_SALE_FREE = "Sale_FREE";
      
      public const TRACK_XMAX_EVENT = "Christmas";
      
      public const TRACK_CHRISTMAS_EVENT = "Christmas 2011";
      
      public const TRACK_CHRISTMAX_PACKAGE = "Pakage";
      
      public const TRACK_CHRISTMAX_HAIR = "Hair";
      
      public const TRACK_CHRISTMAX_CLOTHING = "Clothing";
      
      public const TRACK_CHRISTMAX_WEAPON = "Weapon";
      
      public const TRACK_CHRISTMAX_BACKITEM = "Back Item";
      
      public const TRACK_CHRISTMAX_COLLECTION_A = "Collection_A_Claim";
      
      public const TRACK_CHRISTMAX_COLLECTION_B = "Collection_B_Claim";
      
      public const TRACK_CHRISTMAX_COLLECTION_SKILL = "Collection_Skill_Claim";
      
      public const TRACK_CHRISTMAX_SALE_A = "Collection_A_Sale";
      
      public const TRACK_CHRISTMAX_SALE_B = "Collection_B_Sale";
      
      public const TRACK_CHRISTMAX_SALE_SKILL = "Collection_Skill_Sale";
      
      public const TRACK_CHRISTMAX_LUCKY_DRAW = "Lucky_Draw";
      
      public const TRACK_CHRISTMAX_LUCKY_DRAW_TOKEN = "Token_Draw";
      
      public const TRACK_CHRISTMAX_LUCKY_DRAW_TICKET = "Ticket_Draw";
      
      public const TRACK_NEW_YEAR = "2012 New Year";
      
      public const TRACK_NEW_YEAR_CLOTH = "Clothing";
      
      public const TRACK_NEW_YEAR_SKILL_TOKEN = "Skill_Token";
      
      public const TRACK_NEW_YEAR_SKILL_CLAIM = "Skill_Claim";
      
      public const TRACK_PVP = "PVP_NEW";
      
      public const TRACK_PVP_PRIVATE_ROOM = "Private_Room";
      
      public const TRACK_PVP_SKILL_USED = "SkillsUsed_";
      
      public const TRACK_ITEM_USED = "ConsumableUsed";
      
      public const TRACK_WEAPON_TAKEN = "WeaponTaken";
      
      public const TRACK_PVP_ELEMENTS = "PVPelements";
      
      public const TRACK_PVP_QUICK_MATCH_START = "QuickMatch_Start";
      
      public const TRACK_PVP_QUICK_MATCH_FINISH = "QuickMatch_Finish";
      
      public const TRACK_PVP_PRIVATE_START = "Private_Start";
      
      public const TRACK_PVP_PRIVATE_FINISH = "Private_Finish";
      
      public const TRACK_PVP_CREATE_ROOM = "Create_room";
      
      public const TRACK_PVP_QUICK_MATCH_JOIN = "QuickMatch_Join";
      
      public const TRACK_COMPLETE = "Complete";
      
      public const TRACK_SKILL_UPGRADE = "Skill_Upgrade";
      
      public const TRACK_SPECIAL_SKILL_UPGRADE = "Special_Skill_Upgrade";
      
      public const TRACK_EXAM:String = "Exam_new";
      
      public const TRACK_EXAM_CHUNIN:String = "ExamChunin";
      
      public const TRACK_EXAM_JOUNIN:String = "ExamJounin";
      
      public const TRACK_EXAM_SPECIAL_JOUNIN:String = "ExamSpecialJounin";
      
      public const TRACK_EXAM_SENNIN:String = "ExamSennin";
      
      public const TRACK_EXAM_START:String = "ExamsStart";
      
      public const TRACK_EXAM_FAIL:String = "ExamFail";
      
      public const TRACK_EXAM_SUCCESS:String = "ExamSuccess";
      
      public const TRACK_EXAM_SALE:String = "ExamSale";
      
      public const TRACK_TRY:String = "Try";
      
      public const TRACK_SKILL_USED:String = "SkillsUsed";
      
      public const TRACK_CONSUMABLE_USED:String = "ConsumableUsed";
      
      public const TRACK_BATTLE_WEAPON:String = "BattleWeapon";
      
      public const TRACK_AC_BALANCE:String = "AccountBalance";
      
      public const TRACK_GOLD:String = "Gold";
      
      public const TRACK_GOLD_RANGE1:String = "3K";
      
      public const TRACK_GOLD_RANGE2:String = "10K";
      
      public const TRACK_GOLD_RANGE3:String = "50K";
      
      public const TRACK_GOLD_RANGE4:String = "100K";
      
      public const TRACK_GOLD_RANGE5:String = "150K";
      
      public const TRACK_GOLD_RANGE6:String = "250K";
      
      public const TRACK_GOLD_RANGE7:String = "500K";
      
      public const TRACK_GOLD_RANGE8:String = "750K";
      
      public const TRACK_GOLD_RANGE9:String = "1M";
      
      public const TRACK_GOLD_RANGE10:String = "Over1M";
      
      public const TRACK_TOKEN:String = "Token";
      
      public const TRACK_HUNT_BOSS:String = "HuntBoss";
      
      public const TRACK_START:String = "Start";
      
      public const TRACK_SUCCESS:String = "Success";
      
      public const TRACK_FAIL:String = "Fail";
      
      public const TRACK_EMBLEM_DAILY = "Emblem_daily";
      
      public const TRACK_EMBLEM_DAILY_LEVEL_UP = "LevelUp";
      
      public const TRACK_EMBLEM_DAILY_BOOK = "Book";
      
      public const TRACK_EMBLEM_DAILY_BOOKUSED = "BookUsed";
      
      public const TRACK_EMBLEM_DAILY_CLAIMSET = "ClaimSet";
      
      public const TRACK_PET_UPGRADE:String = "PetUpgrade";
      
      public const TRACK_BUY_ROOM:String = "BuyRoom";
      
      public const TRACK_MATERIAL_MARKET:String = "Material_Market_2012";
      
      public const TRACK_HUNTING_HOUSE_2012:String = "HuntingHouse_2012";
      
      public const TRACK_SPECIAL_ITEM_CLAIM:String = "Special_Item_Claim";
      
      public const TRACK_LOGIN_WEAPON:String = "Login_Weapon";
      
      public function TrackingSystem(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use TrackingSystem.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.TrackingSystem
      {
         if(instance == null)
         {
            instance = new ninjasaga.TrackingSystem(new SingletonBlocker());
         }
         return instance;
      }
      
      private function isTracked(_fnName:String, _step1:String) : Boolean
      {
         if(trackingCache[_fnName] == null)
         {
            trackingCache[_fnName] = [];
         }
         if(trackingCache[_fnName].indexOf(String(_step1)) < 0)
         {
            trackingCache[_fnName].push(String(_step1));
            return true;
         }
         return false;
      }
      
      public function generalTrack(_eventName:String, _trackValue:String = "", _subType1:String = "", _subType2:String = "", _unitPrice:int = 0, _charLv:Boolean = true, _type:String = null) : void
      {
         if(_unitPrice < 0)
         {
            _unitPrice = 0;
         }
         if(_trackValue == "" || _trackValue == null)
         {
            _trackValue = "null";
         }
         if(_subType1 == "")
         {
            _subType1 = "null";
         }
         if(_type == null)
         {
            if(_charLv)
            {
               Main.callJS("eventTracking",_trackValue,_eventName,_subType1,_subType2,_unitPrice,Main.getMainChar().getLevel(),Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
            else
            {
               Main.callJS("eventTracking",_trackValue,_eventName,_subType1,_subType2,_unitPrice,0,0,Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function infoPlayTrack(_eventName:String, _trackValue:String = "", _subType1:String = "", _subType2:String = "", _unitPrice:int = 0, _charLv:Boolean = false, _type:String = null) : void
      {
      }
      
      public function trackLevelUp() : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking","",TRACK_LEVLEUP,charLevel.toString(),"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackBuildingSelect(_step1:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking","",TRACK_BUILDINGSELECT,_step1,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackStartAction(action:String) : void
      {
         if(this.startActionTracked < this.MAX_ACTION_TRACK)
         {
            this.startActionTracked++;
            charLevel = Main.getMainChar().getLevel();
            if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
            {
               Main.callJS("eventTracking",action,"Action_" + String(this.startActionTracked),TRACK_START_ACTION,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackAmfService(serviceName:String) : void
      {
         switch(serviceName)
         {
            case "CharacterDAO.trainSkill":
               this.trackStartAction(SA_TRAIN_SKILL);
               break;
            case "CharacterDAO.buyItem":
               this.trackStartAction(SA_BUY_ITEM);
               break;
            case "CharacterDAO.sellItem":
               this.trackStartAction(SA_SELL_ITEM);
               break;
            case "CharacterDAO.changeAppearance":
               this.trackStartAction(SA_CHANGE_APPEARANCE);
               break;
            case "CharacterDAO.convertCrystal":
               this.trackStartAction(SA_CONVERT_TOKEN);
               break;
            case "CharacterDAO.buyPet":
               this.trackStartAction(SA_BUY_PET);
               break;
            case "BloodlineService.discoverBloodline":
               this.trackStartAction(SA_DISCOVER_TALENT);
               break;
            case "FacebookService.getChallengeRecord":
               this.trackStartAction(SA_CHALLENGE_FRIEND);
               break;
            case "FriendReward.publishDailyFeed":
               this.trackStartAction(SA_DAILY_GIFT);
               break;
            case "MailService.getMail":
               this.trackStartAction(SA_CHECK_MAIL);
               break;
            case "BloodlineService.convertBP":
               this.trackStartAction(SA_CONVERT_TP);
               break;
            case "BloodlineService.skillUpdate":
               this.trackStartAction(SA_TRAIN_TALENT);
               break;
            case "CharacterDAO.trainPetSkill":
               this.trackStartAction(SA_PET_SKILL);
               break;
            case "RouletteService.getReward":
               this.trackStartAction(SA_LUCKY_DRAW);
               break;
            case "FacebookService.claimInviteReward":
               this.trackStartAction(SA_INVITE_REWARD);
               break;
            case "VisitFriendService.getLearningStatus":
               this.trackStartAction(SA_VISIT_FRIEND);
               break;
            case "GiftService.confirmDailyItemReward":
               this.trackStartAction(SA_DAILY_CLAIM);
               break;
            case "RouletteService.getNewReward":
               this.trackStartAction(SA_NEW_DAILY_SCRATCH);
         }
      }
      
      public function trackSale(type:String, itemPrice:String, itemId:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking",itemId,TRACK_SALE,type,"",int(itemPrice),charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackMission(msnData:Object) : void
      {
         if(msnData)
         {
            charLevel = Main.getMainChar().getLevel();
            if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
            {
               Main.callJS("eventTracking","",TRACK_MISSION,msnData.id,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackExam(examLv:String, msnId:String, type:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
            {
               Main.callJS("eventTracking",type + TRACK_PREMIUM,TRACK_EXAM,msnId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
            else
            {
               Main.callJS("eventTracking",type + TRACK_FREE,TRACK_EXAM,msnId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackExamPart(msnId:String, question:String, type:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            if(Central.mission.curMissionID == "msn55" || Central.mission.curMissionID == "msn202" || Central.mission.curMissionID == "msn228" || Central.mission.curMissionID == "msn204" || Central.mission.curMissionID == "msn232" || Central.mission.curMissionID == "msn201" || Central.mission.curMissionID == "msn234")
            {
               Main.callJS("eventTracking","Q" + question + type,TRACK_EXAM,msnId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
            if(Central.mission.curMissionID == "msn200" || Central.mission.curMissionID == "msn226" || Central.mission.curMissionID == "msn205" || Central.mission.curMissionID == "msn227" || Central.mission.curMissionID == "msn203" || Central.mission.curMissionID == "msn230")
            {
               Main.callJS("eventTracking","Part" + question + type,TRACK_EXAM,msnId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackExamTry(msnId:String, times:int) : void
      {
         var range:String = null;
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            range = "";
            if(times <= 0)
            {
               range = "0";
            }
            else if(times == 1)
            {
               range = "1";
            }
            else if(times == 2)
            {
               range = "2";
            }
            else if(times == 3)
            {
               range = "3";
            }
            else if(times == 4)
            {
               range = "4";
            }
            else if(times == 5)
            {
               range = "5";
            }
            else if(times > 5)
            {
               range = "6 over";
            }
            if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
            {
               range = range + "_" + TRACK_PREMIUM;
            }
            else
            {
               range = range + "_" + TRACK_FREE;
            }
            Main.callJS("eventTracking",TRACK_TRY + range,TRACK_EXAM,msnId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackExamPay(msnId:String, question:String, type:String = "", amount:String = "") : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            if(Data.EXAM_SPECIAL_JOUNIN_ARR.indexOf(msnId) >= 0 || Data.EXAM_SPECIAL_JOUNIN_ARR_EASY.indexOf(msnId) >= 0)
            {
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Main.callJS("eventTracking","Q" + question + TRACK_PREMIUM,TRACK_EXAM_SALE,msnId,"",30,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
               else
               {
                  Main.callJS("eventTracking","Q" + question + TRACK_FREE,TRACK_EXAM_SALE,msnId,"",30,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
            }
            if(msnId == "msn55")
            {
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Main.callJS("eventTracking","Q" + question + TRACK_PREMIUM,TRACK_EXAM_SALE,msnId,"",30,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
               else
               {
                  Main.callJS("eventTracking","Q" + question + TRACK_FREE,TRACK_EXAM_SALE,msnId,"",30,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
            }
            if(msnId == "msn134")
            {
               if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
               {
                  Main.callJS("eventTracking","Q" + question + type + TRACK_PREMIUM,TRACK_EXAM_SALE,msnId,"",amount,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
               else
               {
                  Main.callJS("eventTracking","Q" + question + type + TRACK_FREE,TRACK_EXAM_SALE,msnId,"",amount,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
               }
            }
         }
      }
      
      public function trackClick(type:String, _click:String) : void
      {
         if(type == this.TRACK_LOGIN || type == this.TRACK_EMBLEM_PAGE)
         {
            Main.callJS("eventTracking","",type,_click,"",0,0,0,Main.account.getAccountType(),Main.char_crate_date);
         }
         else
         {
            charLevel = Main.getMainChar().getLevel();
            if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
            {
               Main.callJS("eventTracking","",type,_click,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackClick2(type:String, _click:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking","",type,_click,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackResetSkill() : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
            {
               Main.callJS("eventTracking","",TRACK_RESET_SKILL,TRACK_PREMIUM,"",TRACK_RESET_SKILL_PRICE_PREMIUM,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
            else
            {
               Main.callJS("eventTracking","",TRACK_RESET_SKILL,TRACK_FREE,"",TRACK_RESET_SKILL_PRICE_FREE,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackSkillUsed(element:String, skillId:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking",skillId,TRACK_SKILL_USED,element,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackConsumableUsed(itemId:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking","",TRACK_CONSUMABLE_USED,itemId,"",0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackHuntBoss(bossId:String, type:String) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            if(Central.main.account.getAccountType() == Central.main.account.PREMIUM)
            {
               Main.callJS("eventTracking",type,TRACK_HUNT_BOSS,TRACK_PREMIUM,bossId,0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
            else
            {
               Main.callJS("eventTracking",type,TRACK_HUNT_BOSS,TRACK_FREE,bossId,0,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
            }
         }
      }
      
      public function trackClanStamina(type:String, trackToken:int) : void
      {
         charLevel = Main.getMainChar().getLevel();
         if(charLevel >= this.MIN_CHAR_LEVEL && charLevel <= this.MAX_CHAR_LEVEL)
         {
            Main.callJS("eventTracking",TRACK_STAMINA + "_" + type,TRACK_CLAN,TRACK_STAMINA,"",trackToken,charLevel,Main.getMainChar().getCharacterId(),Main.account.getAccountType(),Main.char_crate_date);
         }
      }
      
      public function trackErrorCode(code:String) : void
      {
      }
      
      public function trackRecruitNpc(status:int) : void
      {
      }
      
      public function trackAppLang(type:String) : void
      {
      }
      
      public function trackACBalance(type:String) : void
      {
      }
      
      public function trackBattleWeapon() : void
      {
      }
      
      public function trackClanBattle(actionType:String, recruitMembers:String) : void
      {
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
