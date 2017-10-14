package ninjasaga
{
   import com.google.analytics.AnalyticsTracker;
   import flash.filters.ColorMatrixFilter;
   import flash.display.MovieClip;
   import de.polygonal.ds.HashMap;
   import com.utils.AssociateArray;
   import ninjasaga.objects.AntiMemoryHack;
   import com.utils.Mixer;
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.Event;
   import com.utils.TextFilter;
   import ninjasaga.data.LanguageData;
   import ninjasaga.data.Data;
   import flash.system.Security;
   import ninjasaga.data.AppData;
   import ninjasaga.data.DBCharacterData;
   import com.utils.GF;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.data.StaticVariables;
   import ninjasaga.objects.Npc;
   import com.utils.Out;
   import ninjasaga.data.Timeline;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.GameEvents;
   import ninjasaga.data.InventoryData;
   import ninjasaga.data.DailyLoginEventData;
   import bitemycode.facebook.FBUser;
   import com.google.analytics.GATracker;
   import flash.events.MouseEvent;
   import ninjasaga.data.RankData;
   import ninjasaga.data.Formula;
   import com.utils.NumberUtil;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.TitleData;
   import gs.TweenLite;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   import ninjasaga.data.AMFData;
   import com.adobe.utils.StringUtil;
   import ninjasaga.core.CoreData;
   import ninjasaga.data.AchievementData;
   import ninjasaga.data.ErrorData;
   import flash.external.ExternalInterface;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   import com.utils.CreateFilter;
   import ninjasaga.data.MissionData;
   
   public final class Main
   {
      
      public static var tracker:AnalyticsTracker;
      
      public static const ACC_REG_TUT_STATUS_NONE:int = 0;
      
      public static const ACC_REG_TUT_STATUS_READ:int = 1;
      
      public static const ACC_REG_ACTIVE_STATUS_NOT_REGISTERED:int = 0;
      
      public static const ACC_REG_ACTIVE_STATUS_ACTIVE:int = 1;
      
      private static var dimFilter:ColorMatrixFilter = CreateFilter.getSaturationFilter(0);
      
      public static var friendship_kunai:int = 0;
      
      public static var friend_accepted:int = 0;
      
      public static var friend_accepted_reward:Array = new Array();
      
      public static var Theme_Halloween:Boolean = false;
      
      public static var Theme_dailyLogin:Boolean = false;
      
      public static var gameLockout:Boolean = false;
      
      private static var _errorCode:String;
      
      private static var _errorMessage:String;
      
      public static var _errorRecover:Boolean = false;
      
      public static var _errorRecoverObj:Object = null;
      
      private static var mainChar:ninjasaga.Character;
      
      private static var previewChar:ninjasaga.Character;
      
      private static var mainMc:MovieClip;
      
      private static var lib:MovieClip;
      
      public static var dataLib:MovieClip;
      
      public static var langLib:MovieClip;
      
      public static var proc:MainProcess;
      
      private static var enemyArr:Array;
      
      private static var aiCharArr:Array;
      
      private static var battleCharacters:Array;
      
      public static var isNewChar:Boolean = false;
      
      public static var isNewCharByCreate:Boolean = false;
      
      public static var tutorialMsnStep:int = 0;
      
      public static var exitFromTutorial:Boolean = false;
      
      public static var cinematicsMc:MovieClip;
      
      public static var WEAPON_DATA:HashMap;
      
      public static var BACK_ITEM_DATA:HashMap;
      
      public static var ACCESSORY_DATA:HashMap;
      
      public static var TRADING_DATA:HashMap;
      
      public static var GEAR_SET_DATA:HashMap;
      
      public static var actionBase:MovieClip;
      
      public static var SKILL_DATA:Object;
      
      public static var SKILL_DATA_ARR:Array;
      
      public static var BLOODLINE_DATA:Object;
      
      public static var BLOODLINE_SKILL_DATA:Object;
      
      public static var BLOODLINE_SKILL_DATA_ARR:Array;
      
      public static var SENJUTSU_DATA:Object;
      
      public static var SENJUTSU_SKILL_DATA:Object;
      
      public static var SENJUTSU_SKILL_DATA_ARR:Object;
      
      public static var senjutsuFeature:Boolean = false;
      
      public static var senjutsuSystem:int = -1;
      
      public static var senjutsuSlot:uint = 0;
      
      public static const SENJUTSU_BUTTON_ENABLE_ORDER:Array = [3,4,5,6,2,7,1,8];
      
      public static var BODY_SET_BOY:Object = {"set1":{"swfName":"set_01_0"}};
      
      public static var BODY_SET_GIRL:Object = {"set1":{"swfName":"set_01_1"}};
      
      public static var ITEM_DATA:HashMap;
      
      public static var ESSENCE_DATA:HashMap;
      
      public static var MATERIAL_DATA:HashMap;
      
      public static var CURRENCY_DATA:HashMap;
      
      public static var GetHuntingPassport:Boolean = false;
      
      public static var ENEMY_DATA:HashMap;
      
      public static var PET_DATA:HashMap;
      
      public static var MISSION_DATA:Object;
      
      public static var MISSION_DATA_AA:AssociateArray;
      
      public static var HAIR_DATA:HashMap;
      
      public static var WALLFEED_DATA:HashMap;
      
      public static var ACHIEVEMENT_DATA:HashMap;
      
      public static var NEWS:String;
      
      public static var newsArr:Array = [];
      
      public static var newsId:int = -1;
      
      public static var isGraphic:Boolean = false;
      
      public static var client;
      
      public static var tutorialArr:Array;
      
      private static var loadingChars:Array;
      
      private static var loadCharFinish_CB:Function;
      
      public static var challengeFriendUID:String;
      
      public static var challengedFriends:Array = [];
      
      private static var _partyMembers:Array = [];
      
      private static var _recruitedFriends:Array;
      
      private static var recruitFriend_CB:Function;
      
      public static var recruitFriendTmpData:Array = [];
      
      private static var hasLoadRecruitFriends:Boolean = false;
      
      public static const PAY_TOKEN:String = "token";
      
      public static const PAY_GOLD:String = "gold";
      
      public static var activeNpc:Array;
      
      public static var partyNpc:Array = [];
      
      private static var loadNpc_CB:Function;
      
      private static var usermap:HashMap = new HashMap();
      
      public static var serverTime:int;
      
      public static var currentDate:int;
      
      public static var selectedPvpServer;
      
      private static var chatInputArr:Array = [];
      
      private static var chatInputTime:Number;
      
      public static var MISSION_RETRY:Object = {
         "msn155":0,
         "msn156":0
      };
      
      public static var MISSION_ENGAGE_BG:String = MissionData.ENGAGE_BG;
      
      public static var MISSION_ENGAGE_RESET:Boolean = false;
      
      public static var isShowMainAlert:Boolean = true;
      
      public static var ShowMainAlertMessage:String = "";
      
      public static var ads:Array;
      
      private static var _showAds:Boolean = false;
      
      public static var amfSeq:int = 0;
      
      public static var socket;
      
      public static var EnemyData;
      
      public static var paymentStatus:Boolean;
      
      public static var paymentTitle:String;
      
      public static var paymentText:String;
      
      public static var showLearnMoreBtn:Boolean;
      
      public static const LOCK_PAYMENT = "payment";
      
      public static const LOCK_HACK = "hack";
      
      public static var lockType:String;
      
      public static var hasLvUpReward:Boolean = false;
      
      public static var lvUpRewardType:int;
      
      public static var lvUpTokenClaimed:Boolean = true;
      
      public static var validLogin:Boolean = false;
      
      public static var pvpDebugTime:int = 0;
      
      public static var villageMap:String = "swf/maps/map_halloween2016.swf";
      
      public static var villageNormalMap:String = "swf/maps/map_halloween2016.swf";
      
      private static var achievementPanel:MovieClip;
      
      public static var adsArr:Array = [];
      
      public static var pvpstatus:Object = {"status":true};
      
      public static var datetime:String = "";
      
      public static var isShowMsnADs:Boolean = false;
      
      public static var showSJExamPanel:Boolean = false;
      
      public static var oriClassSkill:Array = [];
      
      public static var dayleft:int = -1;
      
      public static var sje_notice:int = 0;
      
      public static var senninDayLeft:int = -1;
      
      public static var sennin_notice:int = 0;
      
      public static var senninExamCountdownStart:int = 0;
      
      public static var senninExamShowZeroDayConfirm:Boolean = true;
      
      public static var senninModeBtn:MovieClip = null;
      
      public static const sageHillWorking:Boolean = false;
      
      public static var friendData:Array = [];
      
      public static var isShowDailyLogin:Boolean = false;
      
      public static var dailyLogin:Boolean = true;
      
      public static var dailyRoulette_remainTime:int = 0;
      
      public static var dailyRoulette_spc_remainTime:int = 0;
      
      public static var dailyLoginData:Array = [];
      
      public static var isShowCPMStarAds:Boolean = true;
      
      public static var battleRuleArr:Array = [];
      
      public static var actionChecker:Boolean = true;
      
      public static var petExtraDmg:Boolean = false;
      
      public static var petExtraDmgAmount:int = 0;
      
      public static var claimTokenStatus:Array = [];
      
      public static var file_1:Array = [];
      
      public static var file_2:Array = [];
      
      public static var file_3:Array = [];
      
      public static var tokenskill:Object = null;
      
      public static var upgradeGroupID:int = 0;
      
      private static var _PvpPlayerPost:String;
      
      public static var PvpGameId:String;
      
      public static var PvpRoomId:String;
      
      public static var PvpPassword:String;
      
      public static var PvpZoneId:String;
      
      public static var PvPTargetId:String;
      
      public static var closePanel:Boolean = false;
      
      public static var PvpOnArena:Boolean = false;
      
      public static var PvphavePlayerDisconnect:Boolean = false;
      
      private static var _PvpBattleType:String;
      
      public static var openArenaAfterTimetable:Boolean = false;
      
      public static var enterPvpFromMap = false;
      
      private static var _PvpPlayerPlace:String;
      
      private static var _pvpPlayerStatus:String;
      
      public static var PvpTeamA:Array = [];
      
      public static var PvpTeamB:Array = [];
      
      public static var PvpTeamAPost:Array = [];
      
      public static var PvpTeamBPost:Array = [];
      
      public static var PvpAllPlayer:Array = [];
      
      public static var PvpPVMode:int = 1;
      
      public static var PvpQMMode:int = 1;
      
      public static var PvpTournamentMode:int = 1;
      
      public static var loadedPvpCharacter:int = 0;
      
      public static var Pvp_Ip:String = "";
      
      public static var PvpPRTeamA:Object = {};
      
      public static var PvpPRTeamB:Object = {};
      
      public static var ramPvpPrTeamA:Object = {};
      
      public static var ramPvpPrTeamB:Object = {};
      
      public static var willChangeTA:Array = [];
      
      public static var willChangeTB:Array = [];
      
      public static var pvpPlayerMap:HashMap = new HashMap();
      
      public static var resurrection:Boolean = false;
      
      public static var PvpMainCharMc:String = "playerMc_1";
      
      public static var PvpBackUpCharObj:Object = {};
      
      public static var PvpPRHostId:String = "";
      
      public static var PvpShuffleMode:Boolean = false;
      
      public static var charAccountType:Object = {};
      
      public static var adminMessage:String = "";
      
      public static var paymentpackage_remain_1:int = 0;
      
      public static var paymentpackage_remain_2:int = 0;
      
      public static var newsfeed_material_posted:Boolean = true;
      
      public static var newsfeed_easter_2014_posted:Boolean = true;
      
      public static var char_crate_date:String = "";
      
      private static var eventPopupPanel_CB:Function;
      
      public static var pvpinvite:Boolean = false;
      
      public static var WC2016ClaimReward:int = -1;
      
      public static var clanSeason:String = "00";
      
      public static var crewSeason:String = "00";
      
      public static var premium_daily_token:Boolean = false;
      
      public static var premium_daily_token_display:Boolean = true;
      
      public static var premium_claim_skill_set:Boolean = false;
      
      public static var premium_claim_level:Boolean = false;
      
      public static var claimFatherDay:Boolean = false;
      
      public static var FatherEventIn:Boolean = false;
      
      public static var Anni3BattleMethod:String = "";
      
      public static var Vday2013BattleMethod:String = "";
      
      public static var eventBattleMethod:String = "";
      
      public static var canClaimGiftBag:Boolean;
      
      public static var mainMapChange:Boolean = false;
      
      public static var mainMapStatus:int = 1;
      
      public static var mainMapObject:Object = new Object();
      
      public static var preloader_status:int = 0;
      
      public static var christmasCoin:int = 0;
      
      public static var easterCoin:int = 0;
      
      public static var isEventEnd = false;
      
      public static var isOldHunting = false;
      
      public static var hasClickPuzzleButton:Boolean = false;
      
      public static var clickedLuckyDrawButton:String;
      
      public static var gotoStoryPage:String = "";
      
      public static var battleToPage:String = "Panel_Easter_2014_Battle";
      
      public static var sealFailTitle:String;
      
      public static var sealFailHint:String;
      
      public static var changeExpiryItemBtn:Boolean = false;
      
      public static var ItemExpiried:Boolean = false;
      
      public static var daily_login:Boolean = false;
      
      public static var showExpiryTutorial:Boolean = false;
      
      public static var stampRed2X:int = 0;
      
      public static var stampRed3X:int = 0;
      
      public static var stampRed4X:int = 0;
      
      public static var stampYellow:int = 0;
      
      public static var stampBlue:int = 0;
      
      public static var cheese:int = 0;
      
      public static var Mission240_Level:int = 6;
      
      public static var isPopupType:String;
      
      public static var requestData:Array = [];
      
      public static var buyPet:Boolean = false;
      
      public static var popup_SendGiftList:Array;
      
      public static var popup_SendGift_Remain_Time:int;
      
      public static var claimRemain:int = 0;
      
      public static var minik_xmas_gift:String;
      
      public static var minik_xmas_gift_type:String;
      
      public static var isShowMedal:Boolean = false;
      
      public static var medalDay:Boolean = false;
      
      public static var medalReward:Array = [];
      
      public static var sum_1:Array = [];
      
      public static var sum_2:Array = [];
      
      public static var sum_3:Array = [];
      
      public static var country_area:int = 2;
      
      private static var testBuild:Array = ["0.0.1000","0.0.1001","i.m.peChe5TEga58W6TraCha","alan_test_XB42DFH","0.0.1004"];
      
      public static var DailyLoginEvent:Boolean = false;
      
      public static var DailyLoginEventReward:Array = [];
      
      public static var isDisplayDailyLogin:Boolean = false;
      
      public static var DailyLoginEventLangIndex:int;
      
      public static var GiftBagEvent:Array = [];
      
      public static var ShowPopup:Boolean = true;
      
      public static var isShowPopup:Boolean = true;
      
      public static var ShowPopupLangIndex:int;
      
      public static var popupText:Array = [];
      
      public static var showFanPage:Boolean = true;
      
      public static var showClothingPopup:Boolean = false;
      
      public static var ClanStatus:int = 0;
      
      public static var adPageMax:int = 0;
      
      public static var isShowEarthquakePanel:Boolean = true;
      
      public static const EVENT_MIN_LV:int = 5;
      
      public static var logRewardList:Boolean = true;
      
      public static var logHints:Boolean = true;
      
      public static var showVDailyLogin:Boolean = true;
      
      public static var showVdayNotice:Boolean = true;
      
      public static var checkLogVdayEventButton:Array = [true,true,true,true,true,true,true];
      
      public static var mapKey:int = 0;
      
      public static var mapValue:int = 0;
      
      private static var enterMapCounter:int = 0;
      
      private static var adShown:int = 0;
      
      public static var inGameShowZodiacClothing:Boolean = true;
      
      public static var showIngameNotice:Boolean = true;
      
      public static var dailyToken:Boolean = true;
      
      public static var ingamePopupBigNewsArr:Array = [];
      
      public static var ingamepopupLayoutArr:Array;
      
      public static var isShowDailyTask:Boolean = true;
      
      public static var showLuckyPuzzleStatus:int = 0;
      
      public static const DISPLAY_LEVEL_LIMIT_NORMAL:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_LUCKY_DRAW:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_GAHAPON:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_SAKURA:int = 9;
      
      public static const DISPLAY_LEVEL_LIMIT_EVENT_EASTER:int = 5;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_TALENT:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_CLASS:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUTTON_PET:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_NORMAL:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_HUNTING_HOUSE:int = 5;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_TALENT:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_CLAN:int = 10;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_PET_SHOP:int = 20;
      
      public static const DISPLAY_LEVEL_LIMIT_BUILDING_SNEJUTSU_HILL:int = 80;
      
      public static const CHAR_CREATE_DATE:Number = 20140312030000;
      
      public static var EasterHints:Boolean = false;
      
      public static var charCreateDate:String = "";
      
      public static var charClanID:int = 0;
      
      public static var currAISkillId:uint;
      
      public static var showNewLockPopup:Boolean = false;
      
      public static var blnConditionTest:Boolean = true;
      
      public static var battleModeSpecial:Boolean = false;
      
      public static var battleModeSelected:String = "";
      
      public static var battleId:String = "";
      
      public static var petData:Array;
      
      public static var isExpired:Boolean = false;
      
      public static var isTrailEmblem:Boolean = false;
      
      public static var isShowTrial:Boolean = true;
      
      public static var showDoubleCrewWarReward:Boolean = false;
      
      public static var crewDamage:int = 0;
      
      public static var emblem_xp_bonus_amount:Number = 0;
      
      public static var dragonBallList:Array = [[{
         "id":"775",
         "amount":0
      },{
         "id":"776",
         "amount":0
      },{
         "id":"777",
         "amount":0
      },{
         "id":"778",
         "amount":0
      },{
         "id":"779",
         "amount":0
      },{
         "id":"780",
         "amount":0
      },{
         "id":"781",
         "amount":0
      }],[{
         "id":"782",
         "amount":0
      },{
         "id":"783",
         "amount":0
      },{
         "id":"784",
         "amount":0
      },{
         "id":"785",
         "amount":0
      },{
         "id":"786",
         "amount":0
      },{
         "id":"787",
         "amount":0
      },{
         "id":"788",
         "amount":0
      }],[{
         "id":"789",
         "amount":0
      },{
         "id":"790",
         "amount":0
      },{
         "id":"791",
         "amount":0
      },{
         "id":"792",
         "amount":0
      },{
         "id":"793",
         "amount":0
      },{
         "id":"794",
         "amount":0
      },{
         "id":"795",
         "amount":0
      }],[{
         "id":"796",
         "amount":0
      },{
         "id":"797",
         "amount":0
      },{
         "id":"798",
         "amount":0
      },{
         "id":"799",
         "amount":0
      },{
         "id":"800",
         "amount":0
      },{
         "id":"801",
         "amount":0
      },{
         "id":"802",
         "amount":0
      }],[{
         "id":"803",
         "amount":0
      },{
         "id":"804",
         "amount":0
      },{
         "id":"805",
         "amount":0
      },{
         "id":"806",
         "amount":0
      },{
         "id":"807",
         "amount":0
      },{
         "id":"808",
         "amount":0
      },{
         "id":"809",
         "amount":0
      }]];
      
      public static var bPvpUsingRoomList:Boolean = false;
      
      public static var pvpSelectedRoomIdFromRoomList:int = 0;
      
      public static var pvpSelectedRoomLockedFromRoomList:Boolean = false;
      
      public static var onCallCheckHackFunction:Boolean = true;
      
      public static var checkUseTokenInsteadItem:Boolean = false;
      
      private static var antiMemoryHackTrap1:AntiMemoryHack = AntiMemoryHack.copyInstance(AntiMemoryHack.ANTIMEMORYHACK_SECURITY_TYPE_1000);
      
      private static var antiMemoryHackTrap2:AntiMemoryHack = AntiMemoryHack.copyInstance(AntiMemoryHack.ANTIMEMORYHACK_SECURITY_TYPE_2464A3A2);
      
      public static var itfInvGetBackNum:uint = 0;
      
      public static var itpInvGetBackNum:uint = 0;
      
      public static var comInvGetBackNum:uint = 0;
      
      public static var wpnInvGetBackNum:uint = 0;
      
      public static var setInvGetBackNum:uint = 0;
      
      public static var bakInvGetBackNum:uint = 0;
      
      public static var essInvGetBackNum:uint = 0;
      
      public static var mtfInvGetBackNum:uint = 0;
      
      public static var mtpInvGetBackNum:uint = 0;
      
      public static var InvGetBackNum:Array;
      
      public static var isDisplayRegTut:Boolean = true;
      
      public static var Features:ninjasaga.FeatureControl;
      
      public static var ACCESS_TOKEN:String;
      
      public static var mixer:Mixer;
      
      public static var isNewAccount:Boolean;
      
      public static var promoteId:int = 0;
      
      public static var cls:String = "";
      
      public static var accRegTutStatus:int = ACC_REG_TUT_STATUS_NONE;
      
      public static var accRegActiveStatus:int = ACC_REG_ACTIVE_STATUS_NOT_REGISTERED;
      
      public static var easterCombineBoostTime:int = 0;
      
      public static var petBoostLastUpdate:int = 0;
      
      public static var canEasterCombineBoostTime:int = 0;
      
      public static var easterCombineBoostStartTimeLeft:int = 0;
      
      public static var easterCombineBoostEndTimeLeft:int = 0;
      
      public static var currentMusicIndex:int = 0;
      
      public static const MUSIC_PLAY_LIST:Array = ["MainMusic","expiredMainMusic","BattleBGM"];
      
      public static var soundOn:int = 1;
      
      public static var readRewardList:int = 0;
      
      public static var showDailyRoulette:uint = 1;
      
      public static var dailyRouletteMultiplyArr:Array = [];
      
      public static var spinChance:int = 0;
      
      public static var currentLoginDay:uint = 1;
      
      public static var lv80examHackerLockHardMode = -1;
      
      public static var clanPrestige:int = 0;
      
      public static var showWelcomePackageAfterShop:int = 1;
      
      public static var showWelcomePackagePage:int = 1;
      
      public static var noExpOverLv80:Boolean = true;
      
      public static var backToEventPanelArr:Array = ["",""];
      
      public static var eventWallFeed:String = "";
      
      public static var needAnni5thTutorial:int = 0;
      
      public static var extraData:Object;
      
      public static var noBattlePetNotice:Boolean = false;
      
      public static var gotoSanbiPopup:Boolean = false;
      
      public static var showHint:Boolean = true;
      
      public static var doubleXPArr:Array = [];
      
      public static var timeGetExtraData:int = 0;
      
      public static var dailyDragonHuntObject;
      
      public static var dragonPetChristmas:Number = 0;
      
      public static var xmasTutorialNeedDisplay:Number = 0;
      
      public static var addingXPInGashapon:Boolean = false;
      
      public static var xmas2014SpecailReward:Object;
      
      public static var claimNewYear2015Cloth:Boolean = false;
      
      public static var onceGift:Array;
      
      public static var onceGiftLeft:int = 0;
      
      public static var eventName:String = "";
      
      public static var prevNpcArr:Array;
      
      public static var prevPartyMemberArr:Array;
      
      public static var facebookPermissionUserFriends = false;
      
      private static var friendListObserverList:Array = [];
      
      private static var friendPermissionObserverList:Array = [];
      
      public static var showSMissionReward:Boolean = false;
      
      public static var sMissionRewardItem:String = "";
      
      public static var sMissionRewardList:Array = [];
      
      public static var isNewClanWar:Boolean = false;
      
      public static var selectedNewClanWar:int = 0;
      
      public static var selectCastle:int = 0;
      
      public static var recruitedMembers:Array = [];
      
      public static var tmpParty:Array = [];
      
      public static var tmpPartyMembers:Array = [];
      
      public static var showHalloween2015Reward:Boolean = false;
      
      public static var Halloween2015EnemyList:Array = [];
      
      public static var Halloween2015RewardList:Array = [];
      
      public static var loader:BulkLoader;
      
      public static var hashReturnStr:String = "";
      
      public static var pveCurrEnemyLevel:int = 0;
      
      public static var intiedLimbNum:int = 0;
      
      public static var IsBackToPanel:String = "";
      
      private static var iconCanShow:int = 5;
      
      private static var post:int;
      
      private static var canShow:Boolean;
      
      private static var isShowing:int;
      
      private static var pressLimit:int = 0;
      
      private static var canPress:Boolean = true;
      
      private static var rIconCanShow:int = 5;
      
      private static var rPost:int;
      
      private static var rCanShow:Boolean;
      
      private static var rIsShowing:int;
      
      private static var rPressLimit:int = 0;
      
      private static var rCanPress:Boolean = true;
      
      private static var setupRightIconX:Boolean = true;
      
      private static var rightIconOriX:uint = 100;
      
      private static var showIconArr:Array = [];
      
      private static var showLIconArr:Array = [];
      
      private static var backUpShowIconArr:Array = [];
      
      private static var lMaxY:uint;
      
      private static var rMaxY:uint;
      
      private static var lMinY:uint;
      
      private static var rMinY:uint;
      
      private static var ALL_LEFT_BTN_ARR:Array = ["welcome2014Btn","chuninexamBtn","jouninexamBtn","examBtn","senninExamBtn","TrialEmblemBtn","Halloween2016Btn","skill723Btn","Anni7thEventBtn","Skill703Btn","legendarySkill2016Btn","limitOfferHairBtn","skill671Btn","skill669Btn","newYearPackage2016Btn","Skill710Btn","IronMan2016Btn","memorialDay2016Btn","newEmaDrawBtn","isLearnSkillBtn"];
      
      private static var ALL_RIGHT_BTN_ARR:Array = ["dailyScartchBtn","emblemDailygiftBtn","dailyLoginBtn","rouletteBtn","dailyWallfeedMc","dailyTaskMc","giftBtn","inviteFriendBtn","mailboxBtn","requestPopupBtn"];
      
      public static var currScartchCard:int;
      
      public static var currRequest:int;
      
      public static var currMail:int;
      
      public static const SHIFT_X_RIGHT:String = "X_right";
      
      public static const SHIFT_X_LEFT:String = "X_left";
      
      public static const SHIFT_Y_DOWN:String = "Y_down";
      
      public static const SHIFT_Y_UP:String = "Y_up";
      
      public static const SHIFT_X_RIGHT_TO_LEFT:String = "X_right_to_left";
      
      private static var _enemyRobotSeq:Array = [];
      
      private static var _charSeq:Array = [];
      
      private static var _charSeqStr:String = "";
       
      
      public function Main()
      {
         super();
      }
      
      public static function get errorCode() : String
      {
         return _errorCode;
      }
      
      public static function get errorMessage() : String
      {
         return _errorMessage;
      }
      
      public static function getLoginHash(salt:String, str:String) : String
      {
         return proc.clientLib.getLoginHash(salt,str);
      }
      
      public static function generateHash(salt:String, str:String) : String
      {
         return proc.clientLib.generateHash(salt,str);
      }
      
      public static function getHash(str:String) : String
      {
         return proc.clientLib.getHash(Account.getAccountSessionKey(),str);
      }
      
      public static function getArrayHash(arrayObject:Array) : String
      {
         return proc.clientLib.getArrayHash(Account.getAccountSessionKey(),arrayObject);
      }
      
      public static function getHashStr(obj:*, str:String, callBack:Function) : void
      {
         hashReturnStr = str;
         loader = BulkLoader.createUniqueNamedLoader();
         loader.add(obj.loaderInfo.url);
         loader.addEventListener(BulkLoader.COMPLETE,function(evt:Event):void
         {
            hashReturnStr = hashReturnStr + loader.getMovieClip(obj.loaderInfo.url).loaderInfo.bytesTotal;
            callBack(proc.clientLib.getHash(Account.getAccountSessionKey(),hashReturnStr));
         });
         loader.start();
      }
      
      public static function updateSequence() : String
      {
         amfSeq++;
         return getHash(String(amfSeq));
      }
      
      public static function setMainMc(_mainMc:MovieClip) : void
      {
         var security_filename:String = null;
         mainMc = _mainMc;
         proc = new MainProcess(mainMc);
         Central.main = Main;
         Central.battle = Battle;
         Central.skill = Skill;
         Central.panel = Panel;
         Central.map = Map;
         Central.mission = Mission;
         Central.token = Token;
         Central.sns = SNS;
         Central.clan = Clan;
         Central.main.toolkit = Toolkit;
         TextFilter.dictionaryList = LanguageData.foulLanguage;
         SNS.initFBJSListener();
         for(var i:int = 0; i < Data.SECURITY_FILES.length; i++)
         {
            security_filename = Data.SECURITY_FILES[i];
            if(security_filename.indexOf("/crossdomain.xml") >= 0)
            {
               security_filename = security_filename + ("?x=" + Math.floor(Math.random() * 10000));
            }
            Security.loadPolicyFile(security_filename);
         }
         mixer = Mixer.getInstance();
      }
      
      public static function getMainMc() : MovieClip
      {
         return mainMc;
      }
      
      public static function checkFeatureControl(type:String = null) : void
      {
         Features = new ninjasaga.FeatureControl();
         Features.checkFeatureControl(type);
         switch(AppData.type)
         {
            case AppData.YM:
               break;
            case AppData.RR:
               break;
            case AppData.FB:
            case AppData.MP:
            case AppData.OK:
               callJS("sizeChangeCallback");
         }
      }
      
      public static function initRank() : void
      {
         if(Central.sns.friendList != null)
         {
            return;
         }
         MovieClip(mainMc.parent)["rankMc"].init();
         proc.addState(initRank,30 * 1000,true,"initRank");
      }
      
      public static function preloadData() : void
      {
         var i:uint = 0;
         var swfToLoad:Array = new Array();
         if(mainChar.xp == 0)
         {
            isNewChar = true;
            mainChar.updateCP(-60);
         }
         else
         {
            isNewChar = false;
            Main.MISSION_DATA_AA.removeById("msn0");
         }
         swfToLoad.push("swf/library/library.swf");
         if(actionBase == null)
         {
            swfToLoad.push("swf/actions/action_base.swf");
         }
         var pendingSkills:Array = getMainChar().pendingSkills;
         var skillListArr:Array = mainChar.getSkillListArr();
         var classSkillListArr:Array = mainChar.getClassSkillListArr();
         var senjutsuListArr:Array = mainChar.getData(DBCharacterData.SENJUTSU);
         if(pendingSkills == null)
         {
            pendingSkills = [];
         }
         for(i = 0; i < skillListArr.length; i++)
         {
            if(!Skill.hasSkill(skillListArr[i]))
            {
               pendingSkills.push("swf/skills/" + SKILL_DATA[skillListArr[i]].swfName + ".swf");
            }
         }
         getMainChar().pendingSkills = pendingSkills;
         for(i = 0; i < senjutsuListArr.length; i++)
         {
            if(!Skill.hasSkill(senjutsuListArr[i].replace("senjutsu_","")))
            {
               swfToLoad.push("swf/skills/" + SENJUTSU_SKILL_DATA[senjutsuListArr[i]].swf_name + ".swf");
            }
         }
         for(i = 0; i < classSkillListArr.length; i++)
         {
            if(!Skill.hasClassSkill(classSkillListArr[i]))
            {
               swfToLoad.push("swf/skills/" + SKILL_DATA[classSkillListArr[i]].swfName + ".swf");
            }
         }
         var bloodline_skill_arr:Array = mainChar.getBloodlineListArr();
         for(i = 0; i < bloodline_skill_arr.length; i++)
         {
            if(!Skill.hasSkill("skill" + bloodline_skill_arr[i].skill_id))
            {
               swfToLoad.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[i].skill_id].swf_name + ".swf");
            }
         }
         var secret_skill_arr:Array = mainChar.getSecretListArr();
         for(i = 0; i < secret_skill_arr.length; i++)
         {
            if(!Skill.hasSkill("skill" + secret_skill_arr[i].skill_id))
            {
               swfToLoad.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + secret_skill_arr[i].skill_id].swf_name + ".swf");
            }
         }
         if(!Item.hasItem(mainChar.getHair()))
         {
            swfToLoad.push("swf/items/" + mainChar.getHair() + ".swf");
         }
         for(i = 0; i < mainChar.pets.length; i++)
         {
            if(mainChar.pets[i].isEquipped())
            {
               swfToLoad.push("swf/pets/" + mainChar.pets[i].swfName + ".swf");
            }
         }
         if(AppData.type == AppData.RR)
         {
            swfToLoad.push(villageNormalMap);
         }
         else
         {
            swfToLoad.push(villageMap);
         }
         swfToLoad.push(Data.MENU_PATH);
         swfToLoad.push(Data.ACHIEVEMENT_PANEL_PATH);
         swfToLoad.push(Data.MISSION_COMPLETE_PATH);
         swfToLoad.push(Data.REWAED_ALERT_PATH);
         if(AppData.type == AppData.YM)
         {
         }
         if(isNewChar)
         {
            swfToLoad.push("swf/mission/mission_01.swf");
         }
         loadSwf(swfToLoad,preloadFinish,null,langLib.get(205));
      }
      
      private static function preloadFinish(_swfObj:Object) : void
      {
         var item:Item = null;
         var pet:* = undefined;
         var npcStr:String = null;
         var i:uint = 0;
         lib = _swfObj["swf/library/library.swf"];
         if(actionBase == null)
         {
            actionBase = _swfObj["swf/actions/action_base.swf"];
         }
         mainChar.setActionBase(GF.getAsset(actionBase,"ActionBase"));
         var skillListArr:Array = mainChar.getSkillListArr();
         var classSkillListArr:Array = mainChar.getClassSkillListArr();
         for(i = 0; i < skillListArr.length; i++)
         {
            if(!Skill.hasSkill(skillListArr[i]))
            {
               Skill.setSkill(skillListArr[i],_swfObj["swf/skills/" + SKILL_DATA[skillListArr[i]].swfName + ".swf"]);
            }
         }
         for(i = 0; i < classSkillListArr.length; i++)
         {
            if(!Skill.hasClassSkill(classSkillListArr[i]))
            {
               Skill.setClassSkill(classSkillListArr[i],_swfObj["swf/skills/" + SKILL_DATA[classSkillListArr[i]].swfName + ".swf"]);
            }
         }
         var senjutsuListArr:Array = mainChar.getData(DBCharacterData.SENJUTSU);
         for(i = 0; i < senjutsuListArr.length; i++)
         {
            if(!Skill.hasSkill(senjutsuListArr[i].replace("senjutsu_","")))
            {
               Skill.setSkill(senjutsuListArr[i].replace("senjutsu_",""),_swfObj["swf/skills/" + SENJUTSU_SKILL_DATA[senjutsuListArr[i]].swf_name + ".swf"]);
            }
         }
         var bloodline_skill_arr:Array = mainChar.getBloodlineListArr();
         for(i = 0; i < bloodline_skill_arr.length; i++)
         {
            if(!Skill.hasSkill("skill" + bloodline_skill_arr[i].skill_id))
            {
               Skill.setSkill("skill" + bloodline_skill_arr[i].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[i].skill_id].swf_name + ".swf"]);
            }
         }
         var secret_skill_arr:Array = mainChar.getSecretListArr();
         for(i = 0; i < secret_skill_arr.length; i++)
         {
            if(!Skill.hasSkill("skill" + secret_skill_arr[i].skill_id))
            {
               Skill.setSkill("skill" + secret_skill_arr[i].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + secret_skill_arr[i].skill_id].swf_name + ".swf"]);
            }
         }
         if(!Item.hasItem(mainChar.getHair()))
         {
            item = new Item(mainChar.getHair());
            item.setSwf(_swfObj["swf/items/" + mainChar.getHair() + ".swf"]);
            Item.setItem(item);
         }
         for(i = 0; i < mainChar.pets.length; i++)
         {
            if(mainChar.pets[i].isEquipped())
            {
               pet = mainChar.pets[i];
               pet.loadedSwf = _swfObj["swf/pets/" + pet.swfName + ".swf"];
            }
         }
         mainChar.customizeCharacter();
         if(AppData.type == AppData.RR)
         {
            mainMc.mapMc = _swfObj[villageNormalMap];
         }
         else
         {
            mainMc.mapMc = _swfObj[villageMap];
            Main.mainMapObject[villageMap] = _swfObj[villageMap];
         }
         mainMc.mapMenuMc = _swfObj[Data.MENU_PATH];
         achievementPanel = _swfObj[Data.ACHIEVEMENT_PANEL_PATH];
         popup.mcToPopup(_swfObj[Data.MISSION_COMPLETE_PATH],"missionComplete02","achievementMc");
         popup.mcToPopup(_swfObj[Data.REWAED_ALERT_PATH],"rewardalert","achievementMc");
         if(isNewChar)
         {
            Mission.setMission("msn0",_swfObj["swf/mission/mission_01.swf"]);
         }
         if(activeNpc)
         {
            npcStr = activeNpc.toString();
            setNpcParty(activeNpc,startGame,{
               "status":"1",
               "signature":getHash("1" + npcStr + Account.getAccountBalance()),
               "npc_id":npcStr,
               "old_recruit":true
            });
         }
         else
         {
            startGame();
         }
      }
      
      public static function setMainChar(dbChar:DBCharacter) : void
      {
         StaticVariables.xpStr = proc.encrypt(String(dbChar[DBCharacterData.XP]));
         StaticVariables.weaponStr = proc.encrypt(String(dbChar.character_body_parts["weapon"]));
         mainChar = new ninjasaga.Character(dbChar);
         mainChar.securityCheck();
      }
      
      public static function getMainChar() : ninjasaga.Character
      {
         return mainChar;
      }
      
      public static function getDBChar() : DBCharacter
      {
         if(mainChar)
         {
            return mainChar.getDBChar();
         }
         return null;
      }
      
      public static function saveCharacter(instantSave:Boolean = false) : void
      {
      }
      
      public static function saveCharacter_CB() : void
      {
         if(mapMenu)
         {
            mapMenu.displayStatus("");
         }
      }
      
      public static function setPreviewChar() : void
      {
         previewChar = new ninjasaga.Character(new DBCharacter());
      }
      
      public static function getPreviewChar() : ninjasaga.Character
      {
         return previewChar;
      }
      
      public static function showDialogue(dialogueFlow:Array, _eventStep:uint) : void
      {
         Central.main.stopMusic();
         mainMc["dialogueMc"].show(dialogueFlow,_eventStep);
      }
      
      public static function setDialogueCB(_cb:Function) : void
      {
         mainMc["dialogueMc"].setDialogueCB(_cb);
      }
      
      public static function replaceText(_text:String) : String
      {
         return _text.replace("[playername]",mainChar.getCharacterName());
      }
      
      public static function setNpcParty(npcArr:Array, _partyNpc_CB:Function, response:Object) : void
      {
         var i:uint = 0;
         var signature:String = null;
         var tokenRequired:int = 0;
         var npcData:Object = null;
         if(Central.main.validateAmfResponse(response))
         {
            signature = response.signature;
            if(signature != getHash(response.status + response.npc_id + Account.getAccountBalance()))
            {
               onError("120");
               return;
            }
            if(response.old_recruit != true)
            {
               for(i = 0; i < npcArr.length; i++)
               {
                  npcData = npcArr[i];
                  tokenRequired = tokenRequired + (npcData.token as int);
                  tracking.trackSale(tracking.SALE_NPC,npcData.token,npcData.id);
               }
               Account.balance = Account.getAccountBalance() - tokenRequired;
               Central.main.tracking.trackRecruitNpc(2);
            }
            showAmfLoading();
            loadNpc_CB = _partyNpc_CB;
            var swfToLoad:Array = [];
            activeNpc = npcArr;
            for(i = 0; i < activeNpc.length; i++)
            {
               if(!Npc.hasNpcSwf(activeNpc[i].swfName))
               {
                  if(swfToLoad.indexOf("swf/npc/" + activeNpc[i].swfName + ".swf") < 0)
                  {
                     swfToLoad.push("swf/npc/" + activeNpc[i].swfName + ".swf");
                  }
               }
            }
            if(swfToLoad.length > 0)
            {
               loadSwf(swfToLoad,loadNpcFinish);
            }
            else
            {
               loadNpcFinish(null);
            }
            return;
         }
      }
      
      public static function loadNpcFinish(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var npcDataId:int = 0;
         var member:Object = null;
         if(partyNpc == null)
         {
            partyNpc = [];
         }
         for(i = 0; i < activeNpc.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Npc.hasNpcSwf(activeNpc[i].swfName))
               {
                  Npc.addNpcSwf(activeNpc[i].swfName,_swfObj["swf/npc/" + activeNpc[i].swfName + ".swf"]);
               }
            }
            npcDataId = 0;
            if(activeNpc[i].id != null)
            {
               npcDataId = activeNpc[i].id;
            }
            activeNpc[i].npcDataId = npcDataId;
            member = new Npc(activeNpc[i]);
            partyNpc.push(member);
         }
         activeNpc = null;
         hideAmfLoading();
         if(loadNpc_CB != null)
         {
            loadNpc_CB();
            loadNpc_CB = null;
         }
      }
      
      public static function setMissionNpc(missionStep:int, missionEvt:String) : void
      {
         switch(Mission.curMissionID)
         {
            case "msn59":
               if(partyNpc == null || partyNpc.length == 0)
               {
                  if(missionStep == 0)
                  {
                     setFreeNpcParty([{
                        "name":"Shin",
                        "swfName":"npc_1",
                        "clsName":"Npc_1"
                     },{
                        "name":"Genzu",
                        "swfName":"npc_2",
                        "clsName":"Npc_2"
                     }],null);
                  }
               }
         }
      }
      
      private static function setFreeNpcParty(npcArr:Array, _partyNpc_CB:Function) : void
      {
         var i:uint = 0;
         showAmfLoading();
         loadNpc_CB = _partyNpc_CB;
         var swfToLoad:Array = [];
         _partyMembers = npcArr;
         for(i = 0; i < _partyMembers.length; i++)
         {
            if(!Npc.hasNpcSwf(_partyMembers[i].swfName))
            {
               if(swfToLoad.indexOf("swf/npc/" + _partyMembers[i].swfName + ".swf") < 0)
               {
                  swfToLoad.push("swf/npc/" + _partyMembers[i].swfName + ".swf");
               }
            }
         }
         if(swfToLoad.length > 0)
         {
            loadSwf(swfToLoad,loadFreeNpcFinish);
         }
         else
         {
            loadFreeNpcFinish(null);
         }
      }
      
      public static function loadFreeNpcFinish(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var npcDataId:int = 0;
         for(i = 0; i < _partyMembers.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Npc.hasNpcSwf(_partyMembers[i].swfName))
               {
                  Npc.addNpcSwf(_partyMembers[i].swfName,_swfObj["swf/npc/" + _partyMembers[i].swfName + ".swf"]);
               }
            }
            npcDataId = 0;
            if(_partyMembers[i].id != null)
            {
               npcDataId = _partyMembers[i].id;
            }
            _partyMembers[i] = new Npc(_partyMembers[i]);
            _partyMembers[i].npcDataId = npcDataId;
         }
         hideAmfLoading();
         if(loadNpc_CB != null)
         {
            loadNpc_CB();
            loadNpc_CB = null;
         }
      }
      
      public static function setEventFreeNpc(npcID:int, _partyNpc_CB:Function) : void
      {
         loadNpc_CB = _partyNpc_CB;
         switch(Main.eventName)
         {
            case "Vday2015":
               partyNpc = null;
               if(npcID == 0)
               {
                  setFreeNpcParty([{
                     "name":"Cupid",
                     "swfName":"npc_11",
                     "clsName":"Npc_11"
                  }],loadNpc_CB);
               }
               else if(npcID == 1)
               {
                  setFreeNpcParty([{
                     "name":"Venus",
                     "swfName":"npc_12",
                     "clsName":"Npc_12"
                  }],loadNpc_CB);
               }
               else if(npcID == 2)
               {
                  setFreeNpcParty([{
                     "name":"Rose Knight",
                     "swfName":"npc_13",
                     "clsName":"Npc_13"
                  }],loadNpc_CB);
               }
               else
               {
                  setFreeNpcParty([{
                     "name":"Ryuma",
                     "swfName":"npc_3",
                     "clsName":"Npc_3"
                  }],loadNpc_CB);
               }
         }
      }
      
      public static function getCharRank(level:int) : int
      {
         if(level <= 20)
         {
            return 1;
         }
         if(level <= 40)
         {
            return 3;
         }
         if(level <= 60)
         {
            return 5;
         }
         if(level <= 80)
         {
            return 7;
         }
         return 9;
      }
      
      public static function checkPetEP() : void
      {
         if(mainChar.pet.petEP <= 0 && mainChar.pet.petMaxEp > 0)
         {
            Central.main.showOk(AppData.lang == AppData.ZH?"你現在裝備的寵物能量不足, 請卸下有關寵物!":"Your Pet\'s energy point is not enough, please unequip!",function():*
            {
            });
            return;
         }
      }
      
      public static function setEnemy(_enemyArr:Array) : void
      {
         var i:uint = 0;
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         var swfToLoad:Array = [];
         aiCharArr = null;
         enemyArr = _enemyArr;
         if(Central.mission.curMissionID == "msn205" || Central.mission.curMissionID == "msn227")
         {
            Central.main.tracking.trackExamPart(Central.mission.curMissionID,Central.mission.curMission.curStage,Central.main.tracking.TRACK_START);
         }
         for(i = 0; i < _enemyArr.length; i++)
         {
            if(_enemyArr[i])
            {
               if(!Enemy.hasEnemySwf(_enemyArr[i].swfName))
               {
                  if(swfToLoad.indexOf("swf/enemies/" + _enemyArr[i].swfName + ".swf") < 0)
                  {
                     swfToLoad.push("swf/enemies/" + _enemyArr[i].swfName + ".swf");
                  }
               }
            }
            else
            {
               Out.error("Main","_enemyArr >> " + _enemyArr);
            }
         }
         var pendingSkills:Array = getMainChar().pendingSkills;
         if(pendingSkills)
         {
            for(i = 0; i < pendingSkills.length; i++)
            {
               swfToLoad.push(pendingSkills[i]);
            }
         }
         if(swfToLoad.length > 0)
         {
            loadSwf(swfToLoad,startBattle);
         }
         else
         {
            startBattle();
         }
      }
      
      public static function setPvEEnemy(_enemyArr:Array) : void
      {
         var i:int = 0;
         enemyArr = _enemyArr;
         var swfToLoad:Array = [];
         for(i = 0; i < _enemyArr.length; i++)
         {
            if(_enemyArr[i])
            {
               if(!Enemy.hasEnemySwf(_enemyArr[i].swfName))
               {
                  if(swfToLoad.indexOf("swf/enemies/" + _enemyArr[i].swfName + ".swf") < 0)
                  {
                     swfToLoad.push("swf/enemies/" + _enemyArr[i].swfName + ".swf");
                  }
               }
            }
            else
            {
               Out.error("Main","_enemyArr >> " + _enemyArr);
            }
         }
         if(swfToLoad.length > 0)
         {
            loadSwf(swfToLoad,loadedPveEnemyCB);
         }
      }
      
      public static function loadedPveEnemyCB(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         for(i = 0; i < enemyArr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Enemy.hasEnemySwf(enemyArr[i].swfName))
               {
                  Enemy.addEnemySwf(enemyArr[i].swfName,_swfObj["swf/enemies/" + enemyArr[i].swfName + ".swf"]);
               }
            }
         }
      }
      
      public static function startBattle(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var skillList:Array = null;
         var classSkillList:Array = null;
         var senjutsuListArr:Array = null;
         var bloodline_skill_arr:Array = null;
         var secret_skill_arr:Array = null;
         var pendingSkills:Array = null;
         for(i = 0; i < enemyArr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Enemy.hasEnemySwf(enemyArr[i].swfName))
               {
                  Enemy.addEnemySwf(enemyArr[i].swfName,_swfObj["swf/enemies/" + enemyArr[i].swfName + ".swf"]);
               }
            }
         }
         if(_swfObj != null)
         {
            skillList = getMainChar().getSkillListArr();
            if(skillList != null)
            {
               for(i = 0; i < skillList.length; i++)
               {
                  if(!Skill.hasSkill(skillList[i]))
                  {
                     Skill.setSkill(skillList[i],_swfObj["swf/skills/" + SKILL_DATA[skillList[i]].swfName + ".swf"]);
                  }
               }
            }
            classSkillList = getMainChar().getClassSkillListArr();
            if(classSkillList != null)
            {
               for(i = 0; i < classSkillList.length; i++)
               {
                  if(!Skill.hasClassSkill(classSkillList[i]))
                  {
                     Skill.setClassSkill(classSkillList[i],_swfObj["swf/skills/" + SKILL_DATA[classSkillList[i]].swfName + ".swf"]);
                  }
               }
            }
            senjutsuListArr = getMainChar().getData(DBCharacterData.SENJUTSU);
            if(senjutsuListArr != null)
            {
               for(i = 0; i < senjutsuListArr.length; i++)
               {
                  if(!Skill.hasSkill(senjutsuListArr[i].replace("senjutsu_","")))
                  {
                     Skill.setSkill(senjutsuListArr[i].replace("senjutsu_",""),_swfObj["swf/skills/" + SENJUTSU_SKILL_DATA[senjutsuListArr[i]].swf_name + ".swf"]);
                  }
               }
            }
            bloodline_skill_arr = mainChar.getBloodlineListArr();
            for(i = 0; i < bloodline_skill_arr.length; i++)
            {
               if(!Skill.hasSkill("skill" + bloodline_skill_arr[i].skill_id))
               {
                  Skill.setSkill("skill" + bloodline_skill_arr[i].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[i].skill_id].swf_name + ".swf"]);
               }
            }
            secret_skill_arr = mainChar.getSecretListArr();
            for(i = 0; i < secret_skill_arr.length; i++)
            {
               if(!Skill.hasSkill("skill" + secret_skill_arr[i].skill_id))
               {
                  Skill.setSkill("skill" + secret_skill_arr[i].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + secret_skill_arr[i].skill_id].swf_name + ".swf"]);
               }
            }
            if(skillList != null || classSkillList != null || bloodline_skill_arr != null || secret_skill_arr != null)
            {
               pendingSkills = getMainChar().pendingSkills;
               if(pendingSkills)
               {
                  getMainChar().pendingSkills = null;
                  getMainChar().updateSkillSwf();
               }
            }
         }
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "ready";
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function gotoBattle() : void
      {
         if(checkGameStatus() == Timeline.BATTLE && Battle.type == Battle.TYPE_NETWORK)
         {
            Central.battle.resetBattleSetting();
            Central.battle.deleteBattleLikeFinish();
            Central.battle.callMcToReload();
         }
         else
         {
            mainMc.gotoBattle();
         }
      }
      
      public static function addOpponent(_dbChar:DBCharacter, petData:Object) : void
      {
         var pvpChar:* = new PvPCharacter(_dbChar);
         if(petData)
         {
            pvpChar.initPet(dataParser.parsePetData(petData),petData.swfName,petData.clsName);
         }
         battleCharacters.push(pvpChar);
      }
      
      public static function removeOpponent(_id:int) : void
      {
         for(var i:uint = 0; i < battleChars.length; i++)
         {
            if(battleChars[i].getData(DBCharacterData.ID) == _id)
            {
               battleChars.splice(i,1);
            }
         }
      }
      
      public static function resetOpponent() : void
      {
         battleCharacters = [];
      }
      
      public static function get battleChars() : Array
      {
         return battleCharacters;
      }
      
      public static function initPvPBattle() : void
      {
         Main.achievement.updateBattleStat(achievementData.LIVE_BATTLE,1);
         Battle.type = Battle.TYPE_NETWORK;
         loadCharacterSwf(battleCharacters,pvpBattleLoadFinish);
      }
      
      private static function pvpBattleLoadFinish() : void
      {
         socket.loadBattleCompelete();
      }
      
      public static function initChallenge(chars:Array, uid:String = null) : void
      {
         var i:uint = 0;
         var aiChar:AICharacter = null;
         if(uid)
         {
            challengeFriendUID = uid;
         }
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         enemyArr = null;
         aiCharArr = [];
         Main.achievement.updateCharStat(Main.achievementData.CHALLENGE_DONE,chars.length);
         for(i = 0; i < chars.length; i++)
         {
            aiChar = new AICharacter(chars[i].dbChar);
            if(chars[i].petData)
            {
               aiChar.initPet(dataParser.parsePetData(chars[i].petData),chars[i].petData.swfName,chars[i].petData.clsName);
            }
            aiCharArr.push(aiChar);
         }
         loadCharacterSwf(aiCharArr,challengeLoadFinish);
      }
      
      public static function initAnni3Challenge(chars:Array) : void
      {
         var i:uint = 0;
         var aiChar:AICharacter = null;
         Battle.type = Battle.TYPE_LOCAL;
         Central.client.getInstance().joinRoom();
         enemyArr = null;
         aiCharArr = [];
         for(i = 0; i < chars.length; i++)
         {
            aiChar = new AICharacter(chars[i]);
            aiCharArr.push(aiChar);
         }
         loadCharacterSwf(aiCharArr,challengeLoadFinish);
      }
      
      private static function challengeLoadFinish() : void
      {
         var dataObj:Object = {};
         dataObj.event = "info";
         dataObj.state = "ready";
         Central.client.getInstance().sendData(dataObj);
      }
      
      public static function loadCharacterSwf(chars:Array, cbFn:Function) : void
      {
         var i:uint = 0;
         var char:ninjasaga.Character = null;
         var skillListArr:Array = null;
         var j:uint = 0;
         var classSkillListArr:Array = null;
         var bloodline_skill_arr:Array = null;
         var secret_skill_arr:Array = null;
         var senjutsu_skill_arr:Array = null;
         var bodySetData:Object = null;
         var equippiedWeapon:String = null;
         var equippiedBackItem:String = null;
         loadingChars = chars;
         loadCharFinish_CB = cbFn;
         var swfToLoad:Array = new Array();
         for(i = 0; i < loadingChars.length; i++)
         {
            Out.debug("loadCharacterSwf :: ","loadingChars >> " + loadingChars);
            char = loadingChars[i];
            skillListArr = char.getSkillListArr();
            for(j = 0; j < skillListArr.length; j++)
            {
               if(!Skill.hasSkill(skillListArr[j]))
               {
                  if(SKILL_DATA[skillListArr[j]])
                  {
                     swfToLoad.push("swf/skills/" + SKILL_DATA[skillListArr[j]].swfName + ".swf");
                  }
                  else
                  {
                     Out.error("Main","loadCharacterSwf :: skill data error :: " + skillListArr[j]);
                  }
               }
            }
            classSkillListArr = char.getClassSkillListArr();
            for(j = 0; j < classSkillListArr.length; j++)
            {
               if(!Skill.hasClassSkill(classSkillListArr[j]))
               {
                  swfToLoad.push("swf/skills/" + SKILL_DATA[classSkillListArr[j]].swfName + ".swf");
               }
            }
            bloodline_skill_arr = char.getBloodlineListArr();
            for(j = 0; j < bloodline_skill_arr.length; j++)
            {
               if(!Skill.hasSkill("skill" + bloodline_skill_arr[j].skill_id))
               {
                  swfToLoad.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[j].skill_id].swf_name + ".swf");
               }
            }
            secret_skill_arr = char.getSecretListArr();
            for(j = 0; j < secret_skill_arr.length; j++)
            {
               if(!Skill.hasSkill("skill" + secret_skill_arr[j].skill_id))
               {
                  swfToLoad.push("swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + secret_skill_arr[j].skill_id].swf_name + ".swf");
               }
            }
            senjutsu_skill_arr = char.getSenjutsuListArr();
            for(j = 0; j < senjutsu_skill_arr.length; j++)
            {
               if(!Skill.hasSkill("skill" + senjutsu_skill_arr[j].skill_id))
               {
                  swfToLoad.push("swf/skills/" + SENJUTSU_SKILL_DATA["senjutsu_skill" + senjutsu_skill_arr[j].skill_id].swf_name + ".swf");
               }
            }
            if(!Item.hasItem(char.getFace()))
            {
               swfToLoad.push("swf/items/" + char.getFace() + ".swf");
            }
            if(!Item.hasItem(char.getHair()))
            {
               swfToLoad.push("swf/items/" + char.getHair() + ".swf");
            }
            bodySetData = char.getGender() == 0?BODY_SET_BOY:BODY_SET_GIRL;
            if(bodySetData[char.getBodySet()])
            {
               if(!Item.hasItem(bodySetData[char.getBodySet()].swfName))
               {
                  swfToLoad.push("swf/items/" + bodySetData[char.getBodySet()].swfName + ".swf");
               }
            }
            else
            {
               Out.error("Main","loadCharacterSwf :: clothing data error :: " + char.getBodySet());
            }
            equippiedWeapon = char.getWeapon();
            if(WEAPON_DATA.containsKey(equippiedWeapon))
            {
               if(!Item.hasItem(equippiedWeapon))
               {
                  swfToLoad.push("swf/items/" + WEAPON_DATA.find(equippiedWeapon).swfName + ".swf");
               }
            }
            equippiedBackItem = char.getBackItem();
            if(BACK_ITEM_DATA.containsKey(equippiedBackItem))
            {
               if(!Item.hasItem(equippiedBackItem))
               {
                  swfToLoad.push("swf/items/" + BACK_ITEM_DATA.find(equippiedBackItem).swfName + ".swf");
               }
            }
            if(char.pet)
            {
               swfToLoad.push("swf/pets/" + char.pet.swfName + ".swf");
            }
         }
         var pendingSkills:Array = getMainChar().pendingSkills;
         if(pendingSkills)
         {
            for(i = 0; i < pendingSkills.length; i++)
            {
               swfToLoad.push(pendingSkills[i]);
            }
         }
         if(swfToLoad.length == 0)
         {
            loadCharacterSwfFinish(null);
         }
         else
         {
            loadSwf(swfToLoad,loadCharacterSwfFinish);
         }
      }
      
      private static function loadCharacterSwfFinish(_swfObj:Object) : void
      {
         var char:ninjasaga.Character = null;
         var skillListArr:Array = null;
         var j:uint = 0;
         var classSkillList:Array = null;
         var senjutsuListArr:Array = null;
         var bloodline_skill_arr:Array = null;
         var secret_skill_arr:Array = null;
         var item:Item = null;
         var bodySetData:Object = null;
         var equippiedWeapon:String = null;
         var equippiedBackItem:String = null;
         var mainCharSkillList:Array = null;
         var i:uint = 0;
         for(i = 0; i < loadingChars.length; i++)
         {
            char = loadingChars[i];
            char.setActionBase(GF.getAsset(actionBase,"ActionBase"));
            skillListArr = char.getSkillListArr();
            for(j = 0; j < skillListArr.length; j++)
            {
               if(!Skill.hasSkill(skillListArr[j]))
               {
                  if(SKILL_DATA[skillListArr[j]])
                  {
                     Skill.setSkill(skillListArr[j],_swfObj["swf/skills/" + SKILL_DATA[skillListArr[j]].swfName + ".swf"]);
                  }
               }
            }
            classSkillList = char.getClassSkillListArr();
            if(classSkillList != null)
            {
               for(j = 0; j < classSkillList.length; j++)
               {
                  if(!Skill.hasClassSkill(classSkillList[j]))
                  {
                     Out.debug("loadCharacterSwfFinish :: ","classSkillList[j] >> " + classSkillList[j]);
                     Skill.setClassSkill(classSkillList[j],_swfObj["swf/skills/" + SKILL_DATA[classSkillList[j]].swfName + ".swf"]);
                  }
               }
            }
            senjutsuListArr = char.getSenjutsuListArr();
            if(senjutsuListArr != null)
            {
               for(j = 0; j < senjutsuListArr.length; j++)
               {
                  if(!Skill.hasSkill("skill" + senjutsuListArr[j].skill_id))
                  {
                     Skill.setSkill("skill" + senjutsuListArr[j].skill_id,_swfObj["swf/skills/" + SENJUTSU_SKILL_DATA["senjutsu_skill" + senjutsuListArr[j].skill_id].swf_name + ".swf"]);
                  }
               }
            }
            bloodline_skill_arr = char.getBloodlineListArr();
            for(j = 0; j < bloodline_skill_arr.length; j++)
            {
               if(!Skill.hasSkill("skill" + bloodline_skill_arr[j].skill_id))
               {
                  Skill.setSkill("skill" + bloodline_skill_arr[j].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + bloodline_skill_arr[j].skill_id].swf_name + ".swf"]);
               }
            }
            secret_skill_arr = char.getSecretListArr();
            for(j = 0; j < secret_skill_arr.length; j++)
            {
               if(!Skill.hasSkill("skill" + secret_skill_arr[j].skill_id))
               {
                  Skill.setSkill("skill" + secret_skill_arr[j].skill_id,_swfObj["swf/skills/" + BLOODLINE_SKILL_DATA["bloodline_skill" + secret_skill_arr[j].skill_id].swf_name + ".swf"]);
               }
            }
            if(!Item.hasItem(char.getFace()))
            {
               item = new Item(char.getFace());
               item.setSwf(_swfObj["swf/items/" + char.getFace() + ".swf"]);
               Item.setItem(item);
            }
            if(!Item.hasItem(char.getHair()))
            {
               item = new Item(char.getHair());
               item.setSwf(_swfObj["swf/items/" + char.getHair() + ".swf"]);
               Item.setItem(item);
            }
            bodySetData = char.getGender() == 0?BODY_SET_BOY:BODY_SET_GIRL;
            if(bodySetData[char.getBodySet()])
            {
               if(!Item.hasItem(bodySetData[char.getBodySet()].swfName))
               {
                  item = new Item(bodySetData[char.getBodySet()].swfName);
                  item.setSwf(_swfObj["swf/items/" + bodySetData[char.getBodySet()].swfName + ".swf"]);
                  Item.setItem(item);
               }
            }
            equippiedWeapon = char.getWeapon();
            if(WEAPON_DATA.containsKey(equippiedWeapon))
            {
               if(!Item.hasItem(equippiedWeapon))
               {
                  item = new Item(equippiedWeapon);
                  item.setSwf(_swfObj["swf/items/" + WEAPON_DATA.find(equippiedWeapon).swfName + ".swf"]);
                  Item.setItem(item);
               }
            }
            equippiedBackItem = char.getBackItem();
            if(BACK_ITEM_DATA.containsKey(equippiedBackItem))
            {
               if(!Item.hasItem(equippiedBackItem))
               {
                  item = new Item(equippiedBackItem);
                  item.setSwf(_swfObj["swf/items/" + BACK_ITEM_DATA.find(equippiedBackItem).swfName + ".swf"]);
                  Item.setItem(item);
               }
            }
            char.updateSkillSwf();
            if(char.pet)
            {
               char.pet.loadedSwf = _swfObj["swf/pets/" + char.pet.swfName + ".swf"];
            }
         }
         var pendingSkills:Array = getMainChar().pendingSkills;
         if(pendingSkills != null)
         {
            mainCharSkillList = getMainChar().getSkillListArr();
            if(mainCharSkillList != null)
            {
               for(i = 0; i < mainCharSkillList.length; i++)
               {
                  if(!Skill.hasSkill(mainCharSkillList[i]))
                  {
                     Skill.setSkill(mainCharSkillList[i],_swfObj["swf/skills/" + SKILL_DATA[mainCharSkillList[i]].swfName + ".swf"]);
                  }
               }
            }
            if(mainCharSkillList != null)
            {
               if(pendingSkills)
               {
                  getMainChar().pendingSkills = null;
                  getMainChar().updateSkillSwf();
               }
            }
         }
         loadingChars = null;
         loadCharFinish_CB();
      }
      
      public static function createCharacter(dbChar:DBCharacter) : ninjasaga.Character
      {
         return new ninjasaga.Character(dbChar);
      }
      
      public static function createEnemy(data:Object) : Enemy
      {
         return new Enemy(data);
      }
      
      public static function getEnemy() : Array
      {
         return enemyArr;
      }
      
      public static function getAIChars() : Array
      {
         return aiCharArr;
      }
      
      public static function battleWin() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.killMapEnemy();
            mainMc.gotoMapMission();
            return;
         }
         switch(Mission.onMission())
         {
            case Mission.TYPE_ENGAGE:
               mainMc.gotoEngage();
               return;
            case Mission.TYPE_MAP_MISSION:
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            mainMc.gotoPanel();
         }
         else if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function battleRun() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.failMission();
            return;
         }
         if(Mission.dispatchGameEvent(GameEvents.BATTLE_LOSE))
         {
            Central.main.showDeadPopup();
            return;
         }
         Main.showInfo(langLib.get(206));
         if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            Central.main.showDeadPopup();
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function battleLose() : void
      {
         if(Mission.isOnMapMission())
         {
            Mission.failMission();
            return;
         }
         if(Mission.dispatchGameEvent(GameEvents.BATTLE_LOSE))
         {
            Central.main.showDeadPopup();
            return;
         }
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            mainMc.gotoPanel();
            return;
         }
         if(Battle.subType == BattleData.SUBTYPE_CLAN)
         {
            Battle.subType = BattleData.SUBTYPE_NORMAL;
            mainChar.restoreOriginalStatus();
            if(mainChar.pet)
            {
               mainChar.pet.restoreOriginalStatus();
            }
            mainMc.gotoPanel();
         }
         else
         {
            Main.showInfo(langLib.get(207));
            Central.main.showDeadPopup();
            mainMc.gotoMap();
         }
         Battle.subType = BattleData.SUBTYPE_NORMAL;
      }
      
      public static function playBattleEffect(_mc:MovieClip) : void
      {
         if(checkGameStatus() == Timeline.BATTLE)
         {
            mainMc["battleEffectMc"].addChild(_mc);
            _mc.gotoAndPlay(2);
         }
      }
      
      public static function removeBattleEffect() : void
      {
         if(checkGameStatus() == Timeline.BATTLE)
         {
            GF.removeAllChild(mainMc["battleEffectMc"]);
         }
      }
      
      public static function initMapMission() : void
      {
         var i:uint = 0;
         var mapEnemyArr:Array = Mission.getMapMissionEnemies();
         var swfToLoad:Array = [];
         for(i = 0; i < mapEnemyArr.length; i++)
         {
            if(!Enemy.hasEnemySwf(mapEnemyArr[i].enemies[0].swfName))
            {
               swfToLoad.push("swf/enemies/" + mapEnemyArr[i].enemies[0].swfName + ".swf");
            }
         }
         if(swfToLoad.length > 0)
         {
            loadSwf(swfToLoad,startMapMission);
         }
         else
         {
            startMapMission();
         }
      }
      
      private static function startMapMission(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var mapEnemyArr:Array = Mission.getMapMissionEnemies();
         for(i = 0; i < mapEnemyArr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Enemy.hasEnemySwf(mapEnemyArr[i].enemies[0].swfName))
               {
                  Enemy.addEnemySwf(mapEnemyArr[i].enemies[0].swfName,_swfObj["swf/enemies/" + mapEnemyArr[i].enemies[0].swfName + ".swf"]);
               }
            }
            mapEnemyArr[i].enemy = new Enemy(mapEnemyArr[i].enemies[0]);
         }
         mainMc.gotoMapMission();
      }
      
      public static function loadMapEnemies() : void
      {
         var i:uint = 0;
         var mapEnemyArr:Array = Mission.getMapMissionEnemies();
         var swfToLoad:Array = [];
         for(i = 0; i < mapEnemyArr.length; i++)
         {
            if(!Enemy.hasEnemySwf(mapEnemyArr[i].enemies[0].swfName))
            {
               swfToLoad.push("swf/enemies/" + mapEnemyArr[i].enemies[0].swfName + ".swf");
            }
         }
         if(swfToLoad.length > 0)
         {
            loadSwf(swfToLoad,loadMapEnemiesFinish);
         }
         else
         {
            loadMapEnemiesFinish();
         }
      }
      
      private static function loadMapEnemiesFinish(_swfObj:Object = null) : void
      {
         var i:uint = 0;
         var mapEnemyArr:Array = Mission.getMapMissionEnemies();
         for(i = 0; i < mapEnemyArr.length; i++)
         {
            if(_swfObj != null)
            {
               if(!Enemy.hasEnemySwf(mapEnemyArr[i].enemies[0].swfName))
               {
                  Enemy.addEnemySwf(mapEnemyArr[i].enemies[0].swfName,_swfObj["swf/enemies/" + mapEnemyArr[i].enemies[0].swfName + ".swf"]);
               }
            }
            mapEnemyArr[i].enemy = new Enemy(mapEnemyArr[i].enemies[0]);
         }
         Mission.reshowMap();
      }
      
      public static function recruitFriends(chars:Array, cb:Function = null) : void
      {
         var i:uint = 0;
         var member:Object = null;
         var aiChar:AICharacter = null;
         if(_partyMembers == null)
         {
            _partyMembers = [];
         }
         for(i = 0; i < chars.length; i++)
         {
            aiChar = new AICharacter(chars[i]);
            aiChar.friendly = true;
            aiChar.restoreOriginalStatus();
            aiChar.isDead = false;
            _partyMembers.push(aiChar);
         }
         recruitFriend_CB = cb;
         loadCharacterSwf(_partyMembers,recruitFriendsLoadFinish);
      }
      
      private static function recruitFriendsLoadFinish() : void
      {
         if(recruitFriend_CB != null)
         {
            recruitFriend_CB();
         }
      }
      
      public static function getRecruitedFriends() : Array
      {
         if(_recruitedFriends == null)
         {
            return [];
         }
         return _recruitedFriends;
      }
      
      public static function setRecruitedFriends(data:String) : void
      {
         if(_recruitedFriends != null)
         {
            _recruitedFriends.push(data);
         }
         else
         {
            _recruitedFriends = [];
            _recruitedFriends.push(data);
         }
      }
      
      public static function emptyRecruitedFriends() : void
      {
         _recruitedFriends = [];
      }
      
      public static function get partyMembers() : Array
      {
         if(_partyMembers == null)
         {
            return [];
         }
         return _partyMembers;
      }
      
      public static function set partyMembers(arr:Array) : void
      {
         _partyMembers = arr;
      }
      
      public static function getPartyNpc() : Array
      {
         return partyNpc;
      }
      
      public static function removePartyNpc() : void
      {
         partyNpc = null;
      }
      
      public static function getItemAmount(itemName:String) : int
      {
         var arr:Array = null;
         var amount:int = 0;
         if(Central.main.ITEM_DATA.find(itemName))
         {
            arr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM);
         }
         else if(Central.main.ESSENCE_DATA.find(itemName))
         {
            arr = Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE);
         }
         else
         {
            arr = Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL);
         }
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == itemName)
            {
               amount++;
            }
         }
         return amount;
      }
      
      public static function initEngage() : void
      {
         mainMc.gotoEngage();
      }
      
      public static function resetEngage() : void
      {
         mainMc.engageMc.pause();
         mainMc.engageMc.hide();
      }
      
      public static function restoreEngageChar() : void
      {
         mainMc.engageMc.addMainChar();
      }
      
      public static function showDeleteConfirmation(_msg:String, _yesCallback:Function, _noCallback:Function, _otherPanel:String = null) : void
      {
         mainMc["confirmationMc"].showDeleteConfirmation(_msg,_yesCallback,_noCallback,_otherPanel);
      }
      
      public static function showIconData(mc:*, id:String, num:String = "1", isNew:Boolean = false) : void
      {
         if(!mc["skillIcon"] || !mc["rewardIcon"])
         {
            trace("skillicon or rewardicon not ex");
            return;
         }
         GF.removeAllChild(mc["skillIcon"]["iconHolder"]);
         GF.removeAllChild(mc["rewardIcon"]["iconHolder"]);
         id = id.replace("_","");
         var iconData:Object = Toolkit.getDisplayData(id);
         if(id.indexOf("skill") == -1)
         {
            mc["rewardIcon"].visible = true;
            mc["skillIcon"].visible = false;
            mc["rewardIcon"]["iconHolder"].addChild(iconData.mc);
         }
         else
         {
            mc["rewardIcon"].visible = false;
            mc["skillIcon"].visible = true;
            mc["skillIcon"]["iconHolder"].addChild(iconData.mc);
         }
         if(mc["amountTxt"])
         {
            mc["amountTxt"].text = num == "1"?"":"x" + num;
         }
         if(mc["newMc"])
         {
            mc["newMc"].visible = isNew;
         }
         Central.main.showDynamicTooltip(mc,String("<font size=\'16\'>" + iconData.tooltip + "</font>"));
      }
      
      public static function showDynamicTooltip(mc:*, msg:String, _fullHeight:Boolean = false, useDefaultFontSize:Boolean = false) : void
      {
         if(useDefaultFontSize)
         {
            msg = "<font size =\'16\'> " + msg + " </font>";
         }
         mainMc["confirmationMc"].showDynamicTooltip(mc,msg,_fullHeight);
      }
      
      public static function hideDynamicTooltip(mc:*) : void
      {
         mainMc["confirmationMc"].hideDynamicTooltip(mc);
      }
      
      public static function showRenameConfirmation(_msg:String, _yesCallback:Function, _noCallback:Function, _token_f:int, _token_p:int, _btnTxt:String) : void
      {
         mainMc["confirmationMc"].showRenameConfirmation(_msg,_yesCallback,_noCallback,_token_f,_token_p,_btnTxt);
      }
      
      public static function showConfirmation(_msg:String, _yesCallback:Function, _noCallback:Function, _useHtml:Boolean = true) : void
      {
         mainMc["confirmationMc"].showConfirmation(_msg,_yesCallback,_noCallback,_useHtml);
      }
      
      public static function showSecurityPasswordConfirmation(_msg:String, _yesCallback:Function, _noCallback:Function, _useHtml:Boolean = true) : void
      {
         mainMc["confirmationMc"].showPasswordPopup(_msg,_yesCallback,_noCallback,_useHtml);
      }
      
      public static function showSecurityPasswordSignupInvitation(_msg:String, _yesCallback:Function, _noCallback:Function, _useHtml:Boolean = true, _useLeaveButton:Boolean = false) : void
      {
         mainMc["confirmationMc"].showPasswordSignupInvitationPopup(_msg,_yesCallback,_noCallback,_useHtml,_useLeaveButton);
      }
      
      public static function showPvpInfoBox(_msg:String, _okCallback:Function, _yesCallback:Function, _noCallback:Function) : void
      {
         mainMc["confirmationMc"].showPvpInfoBox(_msg,_okCallback,_yesCallback,_noCallback);
      }
      
      public static function showPvpScheduleBox(isOver:Boolean, _okCallback:Function = null) : void
      {
         if(_okCallback == null)
         {
            _okCallback = new Function();
         }
         mainMc["confirmationMc"].showPvpScheduleBox(_okCallback,isOver);
      }
      
      public static function showEnemyHP(_okCallback:Function) : void
      {
         mainMc["confirmationMc"].showEnemyHP(_okCallback);
      }
      
      public static function showRefreshConfirmation(_title:String, _msg:String, _yesCallback:Function, _btnTxt:String) : void
      {
         mainMc["confirmationMc"].showRefreshConfirmation(_title,_msg,_yesCallback,_btnTxt);
      }
      
      public static function showResetSkillConfirmation(_msg:String, _yesCallback:Function, _noCallback:Function, _type:String, _token:String) : void
      {
         mainMc["confirmationMc"].showResetSkillConfirmation(_msg,_yesCallback,_noCallback,_type,_token);
      }
      
      public static function showNoticeBoard(_title:String, _msg:String, _yesCallback:Function, _noCallback:Function, _type:String, _value:Object = null) : void
      {
         mainMc["confirmationMc"].showNoticeBoard(_title,_msg,_yesCallback,_noCallback,_type,_value);
      }
      
      public static function getGoldToken(_msg:String, _yesCallback:Function, _type:String) : void
      {
         mainMc["confirmationMc"].getGoldToken(_msg,_yesCallback,_type);
      }
      
      public static function showOk(_msg:String, _okCallback:Function = null, _useHtml:Boolean = true) : void
      {
         if(_okCallback == null)
         {
            _okCallback = new Function();
         }
         mainMc["confirmationMc"].showOk(_msg,_okCallback,_useHtml);
      }
      
      public static function showPopup(_title:String, _msg:String, _okCallback1:Function = null, _okCallback2:Function = null) : void
      {
         if(_okCallback1 == null)
         {
            _okCallback1 = new Function();
         }
         if(_okCallback2 == null)
         {
            _okCallback2 = new Function();
         }
         mainMc["confirmationMc"].showPopup(_title,_msg,_okCallback1,_okCallback2);
      }
      
      public static function showPopupSpecialHpBar(_data:Object) : void
      {
         mainMc["confirmationMc"].showPopupSpecialHpBar(_data);
      }
      
      public static function hidePopupSpecialHpBar() : void
      {
         mainMc["confirmationMc"].hidePopupSpecialHpBar();
      }
      
      public static function showPopupSealFail(_title:String, _msg:String, _okCallback1:Function = null) : void
      {
         if(_okCallback1 == null)
         {
            _okCallback1 = new Function();
         }
         mainMc["confirmationMc"].showPopupSealFail(_title,_msg,_okCallback1);
      }
      
      public static function showShareBox(_msg:String, _yesCallback:Function, _noCallback:Function) : void
      {
         mainMc["confirmationMc"].showShareBox(_msg,_yesCallback,_noCallback);
      }
      
      public static function showShareBoxNew(_feedTitle:String, _msg:String, _icon:String, _btnTxt:String, _yesCallback:Function, _noCallback:Function) : void
      {
         mainMc["confirmationMc"].showShareBoxNew(_feedTitle,_msg,_icon,_btnTxt,_yesCallback,_noCallback);
      }
      
      public static function showFAQ(_title:String, _subTitle1:String, _contents1:String, _subTitle2:String, _contents2:String, _subTitle3:String, _contents3:String) : void
      {
         mainMc["confirmationMc"].showFAQ(_title,_subTitle1,_contents1,_subTitle2,_contents2,_subTitle3,_contents3);
      }
      
      public static function showPayTokenConfirm(_msg:String, _token:int, _yesCallback:Function, _panelName:String = "") : void
      {
         mainMc["confirmationMc"].showPayTokenConfirm(_msg,_token,_yesCallback,_panelName);
      }
      
      public static function showPayGoldConfirm(_msg:String, _gold:int, _yesCallback:Function, _panelName:String = "") : void
      {
         mainMc["confirmationMc"].showPayGoldConfirm(_msg,_gold,_yesCallback,_panelName);
      }
      
      public static function showGuide(_islvup:Boolean) : void
      {
         mainMc["confirmationMc"].showGuide(_islvup);
      }
      
      public static function showDeadPopup() : void
      {
         mainMc["confirmationMc"].gotoAndPlay("deadPopup");
      }
      
      public static function showTrainSkillConfirm(_msg:String, _skill_id:String, _yesCallback:Function, _noCallback:Function) : void
      {
         mainMc["confirmationMc"].showTrainSkillConfirm(_msg,_skill_id,_yesCallback,_noCallback);
      }
      
      public static function showGeneralNotice(_title:String, _msg:String, _btnTxt:String, _okCallback:Function = null) : void
      {
         if(_okCallback == null)
         {
            _okCallback = new Function();
         }
         mainMc["confirmationMc"].showGeneralNotice(_title,_msg,_btnTxt,_okCallback);
      }
      
      public static function showMedal(_location:String) : void
      {
         mainMc["confirmationMc"].showMedal(_location);
      }
      
      public static function showEventDailyLoginGift(_location:String, _dailyLoginEvent:DailyLoginEventData) : void
      {
         mainMc["confirmationMc"].showEventDailyLoginGift(_location,_dailyLoginEvent);
      }
      
      public static function showEventGiftBag(giftBagObj:Object) : void
      {
         mainMc["confirmationMc"].showEventGiftBag(giftBagObj);
      }
      
      public static function showEventDailyTicket(_location:String, titleTxt:String = "", subTitle:String = "", displayTxt:String = "", btnTxt:String = "") : void
      {
         mainMc["confirmationMc"].showEventDailyTicket(_location,titleTxt,subTitle,displayTxt,btnTxt);
      }
      
      public static function showGetHuntingPassport() : void
      {
         mainMc["confirmationMc"].showHuntingPassport();
      }
      
      public static function showRewardAlert(rewardArr:Array, titleTxt:String = "", callback:Function = null) : void
      {
         popup.showRewardAlert(rewardArr,titleTxt,callback);
      }
      
      public static function initAmf() : void
      {
         amfClient.initAmf();
         DBCharacter.register();
      }
      
      public static function showAmfLoading() : void
      {
         if(mainMc["amfLoader"])
         {
            mainMc["amfLoader"].show();
         }
      }
      
      public static function hideAmfLoading() : void
      {
         if(mainMc["amfLoader"])
         {
            mainMc["amfLoader"].hide();
         }
      }
      
      public static function checkAmf() : void
      {
         var signature:String = Central.main.getHash(Central.main.cls);
         Central.main.showAmfLoading();
         Central.main.amfClient.service("SystemService.checkAmf",[Data.BUILD_NO,Central.main.cls,signature,Central.main.account.getAccountSessionKey()],checkAmfResponse);
      }
      
      private static function checkAmfResponse(response:Object) : void
      {
         if(Central.main.validateAmfResponse(response))
         {
            switch(response.status)
            {
               case 0:
                  Main.onError("30201");
                  break;
               case 1:
                  mainMc.gotoSelchar();
            }
            Central.main.hideAmfLoading();
         }
      }
      
      public static function onError(code:String = "0", msg:String = "") : void
      {
         gameLockout = true;
         mainChar = null;
         if(_errorCode == null)
         {
            _errorCode = code;
            _errorMessage = msg;
         }
         Out.error("Main","onError :: code " + code + " :: _errorCode " + _errorCode + " :: _error_message " + _errorMessage);
         Main.tracking.trackErrorCode(code);
         callGoogleAnalytics("Error",code,FBUser.uid);
         if(mainMc)
         {
            mainMc.showError();
         }
         mainMc = null;
      }
      
      public static function gotoMap() : void
      {
         Main.showMapCoin(true);
         mainMc.gotoMap();
      }
      
      public static function callGoogleAnalytics(category:String, detail:String, uid:String) : void
      {
         tracker = new GATracker(mainMc,"UA-63895237-7","AS3",false);
         tracker.trackEvent(category,detail,uid);
      }
      
      public static function get mapMenu() : MovieClip
      {
         return mainMc["mapMenuMc"];
      }
      
      public static function enableMenu() : void
      {
         mapMenu.enable();
      }
      
      public static function disableMenu() : void
      {
         mapMenu.disable();
      }
      
      public static function enableGearBtn() : void
      {
         mapMenu.enableGearBtn();
      }
      
      public static function disableGearBtn() : void
      {
         mapMenu.disableGearBtn();
      }
      
      public static function updateMenu(updateDisplay:Boolean = true) : void
      {
         mapMenu.update(updateDisplay);
         if(mainMc.currentLabel == Timeline.MAP)
         {
            showHints();
         }
      }
      
      public static function showMapCoin(bool:Boolean) : void
      {
         if(bool)
         {
            mapMenu.enableMRelate();
         }
         else
         {
            mapMenu.disableMRelate();
         }
      }
      
      public static function hideMenu() : void
      {
         mapMenu.hide();
      }
      
      public static function updateLvStatusBar() : void
      {
         mapMenu.updateLvStatusBar();
      }
      
      public static function hideLvStatusBar() : void
      {
         mapMenu.hideLvStatusBar();
      }
      
      private static function showHints() : void
      {
         var mc:MovieClip = null;
         var key:* = undefined;
         GF.removeAllChild(mainMc["hintsMc"]);
         var hintsCount:uint = 0;
         if(mainChar.apInvested < mainChar.getLevel())
         {
            mc = GF.getAsset(mainMc,"Hint");
            mc.name = "profileHint";
            mc["hintIcon"]["icon"].gotoAndStop(2);
            mc["txt"].text = langLib.get(208);
            mc.addEventListener(MouseEvent.CLICK,clickHint);
            mc.buttonMode = true;
            mainMc["hintsMc"].addChild(mc);
            hintsCount++;
         }
         if(mainChar.getInventory(InventoryData.TYPE_ITEM).length == 0)
         {
            mc = GF.getAsset(mainMc,"Hint");
            mc.name = "itemHint";
            mc["hintIcon"]["icon"].gotoAndStop(1);
            mc["txt"].text = langLib.get(209);
            mc.addEventListener(MouseEvent.CLICK,clickHint);
            mc.buttonMode = true;
            mainMc["hintsMc"].addChild(mc);
            mc.y = mc.y - 30 * hintsCount;
            hintsCount++;
         }
         if(mainChar.getData(DBCharacterData.RANK) == RankData.GENIN && int(mainChar.getLevel()) == 20)
         {
            mc = GF.getAsset(mainMc,"Hint");
            mc.name = "chuninExamHint";
            mc["hintIcon"]["icon"].gotoAndStop(1);
            mc["txt"].text = langLib.get(210);
            mc.addEventListener(MouseEvent.CLICK,clickHint);
            mc.buttonMode = true;
            mainMc["hintsMc"].addChild(mc);
            mc.y = mc.y - 30 * hintsCount;
            hintsCount++;
         }
         var record:Object = Main.getMainChar().getData(DBCharacterData.INVENTORY)[InventoryData.TYPE_MISSION];
         var len:uint = 0;
         for(key in record)
         {
            if(key != null && record[key].success)
            {
               len++;
            }
            if(len >= 2)
            {
               break;
            }
         }
         if(len == 1)
         {
            mc = GF.getAsset(mainMc,"Hint");
            mc.name = "firstMissionHint";
            mc["txt"].text = langLib.get(697);
            mc.addEventListener(MouseEvent.CLICK,clickHint);
            mc.buttonMode = true;
            mainMc["hintsMc"].addChild(mc);
            mc.y = mc.y - 30 * hintsCount;
            hintsCount++;
         }
      }
      
      private static function clickHint(evt:MouseEvent) : void
      {
         var name:String = evt.currentTarget.name;
         switch(name)
         {
            case "profileHint":
               mapMenu.show(Timeline.PROFILE);
               break;
            case "itemHint":
               onClickShop();
               break;
            case "chuninExamHint":
               onClickMission();
               break;
            case "firstMissionHint":
               onClickMission();
         }
      }
      
      public static function updateMenuDT() : void
      {
      }
      
      public static function hideMenuDT() : void
      {
      }
      
      public static function onEnterMap() : void
      {
         var payment_rNum:int = 0;
         dispatchGameEvent(GameEvents.MAP_ENTER);
         if(isNewChar)
         {
            MISSION_DATA_AA.removeById("msn0");
         }
         if(int(Main.getMainChar().getData(DBCharacterData.RANK)) >= RankData.TUTOR)
         {
            senjutsuFeature = true;
            senjutsuSlot = Formula.getSenjutsuSlot(int(Main.getMainChar().getData(DBCharacterData.LEVEL)));
            if(mapMenu["characterStatus"].currentFrameLabel != "status2")
            {
               mapMenu.init();
            }
         }
         else
         {
            senjutsuFeature = false;
            if(mapMenu["characterStatus"].currentFrameLabel != "status1")
            {
               mapMenu.init();
            }
         }
         mainChar.restoreOriginalStatus();
         if(mainChar.pet)
         {
            mainChar.pet.restoreOriginalStatus();
         }
         GF.removeAllChild(mainMc["mapHolder"]);
         mainMc.mapMc = Main.mainMapObject[Main.villageMap];
         mainMc["mapHolder"].addChild(mainMc.mapMc);
         initMapButtons();
         updateMenu();
         enableMenu();
         if(mainChar.trainingSkill)
         {
            if(mainChar.trainingSkill.time == 0)
            {
               Out.debug("main","Main >> onEnterMap");
               mainChar.verifyTrainingSkill(null);
            }
         }
         mainMc["attentionBtn"].visible = false;
         Central.main.initButton(mainMc["attentionBtn"],proc.showPaymentStatus,null);
         if(paymentStatus)
         {
            mainMc["attentionBtn"].visible = true;
            Central.main.showDynamicTooltip(mainMc["attentionBtn"],String("<font size=\'12\'>" + Central.main.langLib.get(953) + "</font>"));
            payment_rNum = NumberUtil.randomInt(0,1000);
            if(payment_rNum <= 500)
            {
               proc.showPaymentStatus();
            }
         }
         if(Main.getMainChar().getLevel() <= 2)
         {
            mainMc["mapMc"]["btnMission"]["missionBtn1"].visible = false;
            mainMc["mapMc"]["btnMission"]["missionBtn2"].visible = true;
         }
         else
         {
            mainMc["mapMc"]["btnMission"]["missionBtn1"].visible = true;
            mainMc["mapMc"]["btnMission"]["missionBtn2"].visible = false;
         }
         if(tutorialArr != null)
         {
            popup.showTutorial();
         }
         else if(AppData.type == AppData.FB && Main.recruitFriendTmpData && Main.recruitFriendTmpData.length > 0 && !Main.hasLoadRecruitFriends)
         {
            Main.recruitFriends(Main.recruitFriendTmpData,Main.loadRecruitFriendFinish);
         }
         else
         {
            Main.proc.streamStartEvents();
         }
         if(!Main.hasLoadRecruitFriends)
         {
            Main.hasLoadRecruitFriends = true;
         }
         invisibleMapSideBtn();
         if(tutorialArr == null)
         {
            updateMapSideBtn();
            if(Main.daily_login)
            {
               Main.daily_login = false;
               try
               {
                  Main.tracking.generalTrack(Central.main.tracking.TRACK_LOGIN_WEAPON,Main.getMainChar().getData(DBCharacterData.LEVEL),Main.getMainChar().getWeapon());
               }
               catch(err:Error)
               {
                  Out.error("Main","TRACK_LOGIN_WEAPON >> " + err.message);
               }
            }
         }
         if(IsBackToPanel != "")
         {
            Panel.getInstance().show(IsBackToPanel);
            IsBackToPanel = "";
         }
      }
      
      private static function loadRecruitFriendFinish() : void
      {
         Main.updateMenu();
         Main.proc.streamStartEvents();
      }
      
      public static function checkPVPinvite() : void
      {
         var pvpmsg:String = null;
         if(pvpstatus != null)
         {
            if(pvpstatus.status)
            {
               Out.debug("Main","checkPVPinvite");
               Central.panel.getInstance().show("arena");
            }
            else
            {
               pvpmsg = "";
               if(pvpstatus["status_" + AppData.lang] != null)
               {
                  pvpmsg = pvpstatus["status_" + AppData.lang];
               }
               else
               {
                  pvpmsg = pvpstatus.status_en;
               }
               showGeneralNotice("",String(pvpmsg),ButtonData.OK,new Function());
            }
         }
         else
         {
            Out.error("Main","pvpstatus is null!");
         }
      }
      
      public static function showCPMStarAd() : void
      {
         Out.debug("Main","showCPMStarAd");
         popup.showCPMStarAd();
      }
      
      public static function invisibleMapSideBtn() : void
      {
         var i:uint = 0;
         Main.hideLvStatusBar();
         for(i = 0; i < ALL_LEFT_BTN_ARR.length; i++)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[i]])
            {
               mainMc[ALL_LEFT_BTN_ARR[i]].stop();
               mainMc[ALL_LEFT_BTN_ARR[i]].visible = false;
               if(AppData.type != AppData.RR)
               {
                  if(mainMc[ALL_LEFT_BTN_ARR[i]]["numMC"])
                  {
                     mainMc[ALL_LEFT_BTN_ARR[i]]["numMC"].visible = false;
                  }
               }
            }
         }
         for(i = 0; i < ALL_RIGHT_BTN_ARR.length; i++)
         {
            if(mapMenu[ALL_RIGHT_BTN_ARR[i]])
            {
               mapMenu[ALL_RIGHT_BTN_ARR[i]].stop();
               mapMenu[ALL_RIGHT_BTN_ARR[i]].visible = false;
               if(AppData.type != AppData.RR)
               {
               }
            }
         }
      }
      
      public static function visibleMapSideBtn() : void
      {
         var i:uint = 0;
         Main.updateLvStatusBar();
         for(i = 0; i < ALL_LEFT_BTN_ARR.length; i++)
         {
            mainMc[ALL_LEFT_BTN_ARR[i]].visible = true;
         }
         for(i = 0; i < ALL_RIGHT_BTN_ARR.length; i++)
         {
            mapMenu[ALL_RIGHT_BTN_ARR[i]].visible = true;
         }
      }
      
      public static function shiftPosMapSideBtn() : void
      {
         var seq:uint = 0;
         var i:uint = 0;
         seq = 0;
         for(i = 0; i < ALL_LEFT_BTN_ARR.length; i++)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[i]].visible == true)
            {
               mainMc[ALL_LEFT_BTN_ARR[i]].y = 105 + seq * 70;
               seq++;
            }
         }
         seq = 0;
         for(i = 0; i < ALL_RIGHT_BTN_ARR.length; i++)
         {
            if(mapMenu[ALL_RIGHT_BTN_ARR[i]].visible == true)
            {
               mapMenu[ALL_RIGHT_BTN_ARR[i]].y = 105 + seq * 70;
               seq++;
            }
         }
      }
      
      private static function clickMapSideBtn(evt:MouseEvent) : void
      {
         if(evt.currentTarget == null)
         {
            return;
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            switch(String(evt.currentTarget.name))
            {
               case "isLearnSkillBtn":
                  Out.debug("main","Main >> clickMapSideBtn");
                  Main.getMainChar().verifyTrainingSkill(Main.checkisLearnSkill);
                  break;
               case "dailyLoginBtn":
                  Main.loadPopupPanel("daily_login","ninjasaga.linkage.Roulette2");
                  break;
               case "dailyScartchBtn":
                  Main.loadPopupPanel("daily_login_3","ninjasaga.linkage.daily_login3");
                  break;
               case "requestPopupBtn":
                  Panel.getInstance().show("requestBox");
                  break;
               case "inviteFriendBtn":
                  Main.loadPopupPanel("invitFrdReward","ninjasaga.linkage.InviteInstantReward");
                  break;
               case "emblemDailygiftBtn":
                  if(Central.main.extraData.emblem_type == 2 || Account.getAccountType() == Account.FREE)
                  {
                     Central.main.loadPopupPanel("popup_emblemClaim_other","ninjasaga.linkage.EmblemClaim");
                  }
                  else
                  {
                     Central.main.loadPopupPanel("popup_emblemClaim","ninjasaga.linkage.EmblemUserDailyLoginGift");
                  }
                  break;
               case "TrialEmblemBtn":
                  Main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel");
                  break;
               case "limitOfferHairBtn":
                  Central.main.gotoPaymentGateway();
                  break;
               case "legendarySkill2016Btn":
                  Main.loadPopupPanel("Popup_Limiter_Package_2016","ninjasaga.linkage.LimitSkill2016");
                  break;
               case "Skill703Btn":
                  Panel.getInstance().show("Popup_thorPackage_2016_Menu");
                  break;
               case "IronMan2016Btn":
                  Panel.getInstance().show("Popup_IronManPackage_2016_Menu");
                  break;
               case "Anni7thEventBtn":
                  Panel.getInstance().show("panel_7th_main_menu");
                  break;
               case "memorialDay2016Btn":
                  Panel.getInstance().show("Popup_ArmyPackage_2016_Menu");
                  break;
               case "MiniGameWhackAMoleBtn":
                  Panel.getInstance().show("Panel_2016_MinigameCover_1");
                  break;
               case "newYearPackage2016Btn":
                  Panel.getInstance().show("Enemytest");
                  break;
               case "Skill710Btn":
                  Main.loadPopupPanel("Popup_skill710_Package","ninjasaga.linkage.Skill710_Package");
                  break;
               case "skill671Btn":
                  Main.loadPopupPanel("Popup_7th_skill672_Package","ninjasaga.linkage.Skill672_package");
                  break;
               case "newEmaDrawBtn":
                  Panel.getInstance().show("Panel_Sixth_Anniversary_2015_lucky_ema2");
                  break;
               case "skill669Btn":
                  Central.main.loadPopupPanel("Popup_7th_skill669_Package","ninjasaga.linkage.Skill669_package");
                  break;
               case "dailyRouletteBtn":
                  Main.loadPopupPanel("Popup_LuckyDraw_2014","ninjasaga.linkage.LuckyRoulette2014");
                  break;
               case "welcome2014Btn":
                  Main.loadPopupPanel("popup_welcome_package_2014","ninjasaga.linkage.WelcomePackage2014");
                  break;
               case "Halloween2016Btn":
                  Panel.getInstance().show("Halloween_2016");
                  break;
               case "skill723Btn":
                  Main.loadPopupPanel("Popup_skill723_2016_Package","ninjasaga.linkage.Skill723_Package");
            }
         }
      }
      
      public static function checkisLearnSkill() : void
      {
         if(Main.getMainChar().trainingSkill != null)
         {
            Main.loadPopupPanel("popup_skill_progress","ninjasaga.linkage.SkillReduceProgress");
         }
         else
         {
            updateMapSideBtn();
         }
      }
      
      public static function checkExpiryItem() : void
      {
         var expiryItemArr:Array = null;
         var tempArr:Array = null;
         var curDate:Date = null;
         var curTime:int = 0;
         var promptHour:int = 0;
         if(Mission.curMissionID == null)
         {
            if(Main.checkGameStatus() == Timeline.MAP)
            {
               expiryItemArr = Main.getMainChar().getData(DBCharacterData.EXPIRY_ITEM_CURRENT_EXPIRY_ARR);
               tempArr = [];
               curDate = new Date();
               curTime = curDate.time / 1000;
               promptHour = 12;
               if(expiryItemArr.length > 0)
               {
                  tempArr = String(expiryItemArr[0]).split(":");
                  if(curTime + promptHour * 3600 >= int(tempArr[1]))
                  {
                     Main.changeExpiryItemBtn = true;
                  }
                  else
                  {
                     Main.changeExpiryItemBtn = false;
                  }
                  if(curTime >= int(tempArr[1]))
                  {
                     Main.loadPopupPanel("popup_expired_item","ninjasaga.linkage.ExpiryItemPopupPanel");
                  }
               }
               else
               {
                  Main.changeExpiryItemBtn = false;
               }
            }
         }
      }
      
      public static function updateMapSideBtn() : void
      {
         var skillIcon:MovieClip = null;
         if(Battle.bossId == "")
         {
         }
         if(Mission.curMissionID == null)
         {
            if(Main.checkGameStatus() == Timeline.MAP)
            {
               invisibleMapSideBtn();
               mainMc["leftIconUp"].visible = true;
               mainMc["leftIconUp"].addEventListener(MouseEvent.CLICK,leftIconUp);
               mainMc["leftIconDown"].visible = true;
               mainMc["leftIconDown"].addEventListener(MouseEvent.CLICK,leftIconDown);
               mainMc["rightIconUp"].visible = true;
               mainMc["rightIconUp"].addEventListener(MouseEvent.CLICK,rightIconUp);
               mainMc["rightIconDown"].visible = true;
               mainMc["rightIconDown"].addEventListener(MouseEvent.CLICK,rightIconDown);
               if(AppData.type == AppData.RR || AppData.type == AppData.YM)
               {
                  mainMc["leftIconUp"].visible = false;
                  mainMc["leftIconDown"].visible = false;
                  mainMc["rightIconUp"].visible = false;
                  mainMc["rightIconDown"].visible = false;
               }
               if(mainMc["yahooXmasDailyGiftBtn"])
               {
                  mainMc["yahooXmasDailyGiftBtn"].visible = false;
               }
               if(mainMc["minikPromoBtn"])
               {
                  mainMc["minikPromoBtn"].visible = false;
               }
               if(Main.getMainChar().getLevel() < 80 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.SPECIAL_JOUNIN)
               {
                  mainMc["senninExamBtn"].visible = true;
                  Main.initButton(mainMc["senninExamBtn"],proc.showSenninExam,null);
                  Main.showDynamicTooltip(mainMc["senninExamBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "80" + "</font>");
               }
               else if(Main.getMainChar().getLevel() >= 80 && Main.getMainChar().getData(DBCharacterData.RANK) < RankData.TUTOR)
               {
                  mainMc["senninExamBtn"].visible = true;
                  Main.showDynamicTooltip(mainMc["senninExamBtn"],"<font size =\'16\'>" + Main.langLib.get(1848)[49] + "</font>");
                  Main.initButton(mainMc["senninExamBtn"],proc.showSenninExam,null);
               }
               else
               {
                  mainMc["senninExamBtn"].stop();
                  mainMc["senninExamBtn"].visible = false;
               }
               if(Features.EXAM_S_JOUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() < 60 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.JOUNIN)
                  {
                     mainMc["examBtn"].visible = true;
                     Main.initButton(mainMc["examBtn"],proc.showExam,null);
                     Main.showDynamicTooltip(mainMc["examBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "60" + "</font>");
                  }
                  else if(Main.getMainChar().getLevel() >= 60)
                  {
                     if(Central.main.dayleft == 0 && Main.getMainChar().getData(DBCharacterData.CONTROL) > 0 && Central.main.sje_notice == 0)
                     {
                        Central.main.showOk(Central.main.langLib.get(1437)[33],SJENoticeOk);
                     }
                     Main.showDynamicTooltip(mainMc["examBtn"],"<font size =\'16\'>" + Main.langLib.get(1422) + "</font>");
                     if(Main.getMainChar().getData(DBCharacterData.RANK) == 6 && Main.getMainChar().getData(DBCharacterData.CONTROL) > 0 && Central.main.dayleft != 0)
                     {
                        mainMc["examBtn"].visible = true;
                        Main.initButton(mainMc["examBtn"],confirmActivateHM,null);
                     }
                     else if(Main.getMainChar().getData(DBCharacterData.CONTROL) <= 0)
                     {
                        mainMc["examBtn"].visible = true;
                        Main.initButton(mainMc["examBtn"],confirmActivateHM,null);
                     }
                     else
                     {
                        mainMc["examBtn"].stop();
                        mainMc["examBtn"].visible = false;
                     }
                  }
               }
               if(Features.EXAM_JOUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() < 40 && Main.getMainChar().getData(DBCharacterData.RANK) >= 2)
                  {
                     mainMc["jouninexamBtn"].visible = true;
                     Main.initButton(mainMc["jouninexamBtn"],proc.showjouninExamPage,null);
                     Main.showDynamicTooltip(mainMc["jouninexamBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.REQUIREMENT) + ": " + langLib.titleTxt(TitleData.LV) + "40" + "</font>");
                  }
                  else if(Main.getMainChar().getLevel() >= 40 && Main.getMainChar().getData(DBCharacterData.RANK) >= RankData.CHUNIN && Main.getMainChar().getData(DBCharacterData.RANK) < RankData.JOUNIN)
                  {
                     mainMc["jouninexamBtn"].visible = true;
                     Main.initButton(mainMc["jouninexamBtn"],proc.showjouninExamPage,null);
                     Main.showDynamicTooltip(mainMc["jouninexamBtn"],"<font size =\'16\'>" + String(Main.langLib.get(1593)[0]) + "</font>");
                  }
               }
               if(Features.FEATURE_ESSENCE)
               {
                  if(Main.getMainChar().trainingSkill != null)
                  {
                     mainMc["isLearnSkillBtn"].visible = true;
                     Main.initButton(mainMc["isLearnSkillBtn"],clickMapSideBtn,null);
                     Main.showDynamicTooltip(mainMc["isLearnSkillBtn"],"<font size =\'16\'><b>" + Main.langLib.get(1615)[15] + "</b><br><br>" + String(Central.main.SKILL_DATA[Central.main.getMainChar().trainingSkill.id].name) + "</font>");
                  }
               }
               if(!Features.FEATURE_PAYMENT_PACKAGE)
               {
               }
               if(Main.getMainChar().getLevel() <= 20 && Account.getAccountType() == 1 && AppData.type == AppData.FB)
               {
                  mainMc["welcome2014Btn"].visible = true;
                  mainMc["welcome2014Btn"]["newMc"].visible = true;
                  mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(2);
                  if(AppData.type == AppData.ZH)
                  {
                     mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(3);
                  }
                  else if(Main.getMainChar().getLevel() <= 10)
                  {
                     mainMc["welcome2014Btn"]["giftBoxMc"]["txtMc"].gotoAndStop(1);
                  }
                  Main.initButton(mainMc["welcome2014Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["welcome2014Btn"],"<font size =\'16\'> " + String(Main.langLib.get(1863)[0]) + " </font>");
               }
               else
               {
                  mainMc["welcome2014Btn"].visible = false;
                  mainMc["welcome2014Btn"]["newMc"].visible = false;
                  Main.disableButton(mainMc["welcome2014Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["newEmaDrawBtn"].visible = true;
                  mainMc["newEmaDrawBtn"].filters = null;
                  Main.initButton(mainMc["newEmaDrawBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["newEmaDrawBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"限時繪馬抽獎":"Limited Gacha - Ema Draw") + " </font>");
               }
               else
               {
                  mainMc["newEmaDrawBtn"].visible = false;
                  Main.disableButton(mainMc["newEmaDrawBtn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["skill669Btn"].visible = true;
                  mainMc["skill669Btn"].filters = null;
                  Main.initButton(mainMc["skill669Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["skill669Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"禁術：分身查克拉拳":"Kinjutsu: Bunshin Chakra Fist") + " </font>");
               }
               else
               {
                  mainMc["skill669Btn"].visible = false;
                  Main.disableButton(mainMc["skill669Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER && Central.main.account.getAccountType() == Central.main.account.FREE || Central.main.isTrailEmblem)
               {
                  mainMc["TrialEmblemBtn"].visible = true;
                  mainMc["TrialEmblemBtn"].filters = null;
                  Main.initButton(mainMc["TrialEmblemBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["TrialEmblemBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"試用忍者紋章":"Trial Emblem") + " </font>");
               }
               else
               {
                  mainMc["TrialEmblemBtn"].visible = false;
                  Main.disableButton(mainMc["TrialEmblemBtn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER && Central.main.extraData.special_may_2016_package)
               {
                  mainMc["limitOfferHairBtn"].visible = true;
                  mainMc["limitOfferHairBtn"].filters = null;
                  Main.initButton(mainMc["limitOfferHairBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["limitOfferHairBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"限時優惠":"Limited Offer") + " </font>");
               }
               else
               {
                  mainMc["limitOfferHairBtn"].visible = false;
                  Main.disableButton(mainMc["limitOfferHairBtn"],clickMapSideBtn,null);
               }
               if(Main.extraData && (Main.extraData.memorial_day_2016 === undefined || Main.extraData.memorial_day_2016 === true) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["memorialDay2016Btn"].visible = true;
                  mainMc["memorialDay2016Btn"].filters = null;
                  Main.initButton(mainMc["memorialDay2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["memorialDay2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"受勳日":"Decoration Day") + " </font>");
               }
               else
               {
                  mainMc["memorialDay2016Btn"].visible = false;
                  Main.disableButton(mainMc["memorialDay2016Btn"],clickMapSideBtn,null);
               }
               if((Toolkit.hasItem("wpn9999999") || Toolkit.hasItem("wpn9999")) && NinjaSaga.isTestMode)
               {
                  mainMc["newYearPackage2016Btn"].visible = true;
                  mainMc["newYearPackage2016Btn"].filters = null;
                  Main.initButton(mainMc["newYearPackage2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["newYearPackage2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"2016":"2016") + " </font>");
               }
               else
               {
                  mainMc["newYearPackage2016Btn"].visible = false;
                  Main.disableButton(mainMc["newYearPackage2016Btn"],clickMapSideBtn,null);
               }
               if(Main.extraData && (Main.extraData.olympus_package_2016 === undefined || Main.extraData.olympus_package_2016 === true) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["Skill710Btn"].visible = true;
                  mainMc["Skill710Btn"].filters = null;
                  Main.initButton(mainMc["Skill710Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Skill710Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"禁術：奧林匹斯之刃":"Kinjutsu: Olympus Blade") + " </font>");
               }
               else
               {
                  mainMc["Skill710Btn"].visible = false;
                  Main.disableButton(mainMc["Skill710Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["skill671Btn"].visible = true;
                  mainMc["skill671Btn"].filters = null;
                  Main.initButton(mainMc["skill671Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["skill671Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"禁術：爆炸符分身":"Kinjutsu: Explosive Tag Bunshin") + " </font>");
               }
               else
               {
                  mainMc["skill671Btn"].visible = false;
                  Main.disableButton(mainMc["skill671Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["IronMan2016Btn"].visible = true;
                  mainMc["IronMan2016Btn"].filters = null;
                  Main.initButton(mainMc["IronMan2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["IronMan2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"限時優惠 - 戰鬥靈魂":"Limited Offer - Battle Soul") + " </font>");
               }
               else
               {
                  mainMc["IronMan2016Btn"].visible = false;
                  Main.disableButton(mainMc["IronMan2016Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["Anni7thEventBtn"].visible = true;
                  mainMc["Anni7thEventBtn"].filters = null;
                  Main.initButton(mainMc["Anni7thEventBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Anni7thEventBtn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"七週年活動":"7th Anniversary Event") + " </font>");
               }
               else
               {
                  mainMc["Anni7thEventBtn"].visible = false;
                  Main.disableButton(mainMc["Anni7thEventBtn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_BUILDING_HUNTING_HOUSE && Central.main.extraData.legendary_limit_skill_package)
               {
                  mainMc["legendarySkill2016Btn"].visible = true;
                  mainMc["legendarySkill2016Btn"]["newMc"].visible = true;
                  mainMc["legendarySkill2016Btn"].filters = null;
                  Main.initButton(mainMc["legendarySkill2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["legendarySkill2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"傳奇忍術套裝":"Legendary Skill Package") + " </font>");
               }
               else
               {
                  mainMc["legendarySkill2016Btn"].visible = false;
                  Main.disableButton(mainMc["legendarySkill2016Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_BUILDING_HUNTING_HOUSE)
               {
                  mainMc["Skill703Btn"].visible = true;
                  mainMc["Skill703Btn"]["newMc"].visible = true;
                  mainMc["Skill703Btn"].filters = null;
                  Main.initButton(mainMc["Skill703Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Skill703Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"限時優惠":"Limited Offer") + " </font>");
               }
               else
               {
                  mainMc["Skill703Btn"].visible = false;
                  Main.disableButton(mainMc["Skill703Btn"],clickMapSideBtn,null);
               }
               if(Features.EXAM_CHUNIN_PANEL)
               {
                  if(Main.getMainChar().getLevel() == 20 && Main.getMainChar().getData(DBCharacterData.RANK) == 1)
                  {
                     mainMc["chuninexamBtn"].visible = true;
                     Main.initButton(mainMc["chuninexamBtn"],proc.showchuninExamPage,null);
                     Main.showDynamicTooltip(mainMc["chuninexamBtn"],"<font size =\'16\'>" + String(Main.langLib.get(1594)[0]) + "</font>");
                  }
                  else
                  {
                     mainMc["chuninexamBtn"].visible = false;
                  }
               }
               if(!Features.EVENT_HALLOWEEN_2012)
               {
               }
               if(!Features.EVENT_THANKSGIVING_2012)
               {
               }
               if(Main.extraData && (Main.extraData.skill723 === undefined || Main.extraData.skill723 === true) && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["skill723Btn"].visible = true;
                  mainMc["skill723Btn"].filters = null;
                  Main.initButton(mainMc["skill723Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["skill723Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"活死人突擊":"Deadman Assault") + " </font>");
                  if(mainMc["skill723Btn"] && mainMc["skill723Btn"].newMc)
                  {
                     if(Main.extraData.skill723New === false)
                     {
                        mainMc["skill723Btn"].newMc.visible = false;
                     }
                     else
                     {
                        mainMc["skill723Btn"].newMc.visible = true;
                     }
                  }
               }
               else
               {
                  mainMc["skill723Btn"].visible = false;
                  Main.disableButton(mainMc["skill723Btn"],clickMapSideBtn,null);
               }
               if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_EASTER)
               {
                  mainMc["Halloween2016Btn"].visible = true;
                  mainMc["Halloween2016Btn"].filters = null;
                  Main.initButton(mainMc["Halloween2016Btn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mainMc["Halloween2016Btn"],"<font size =\'16\'> " + (AppData.lang == AppData.ZH?"2016 萬聖節活動":"Halloween Event 2016") + " </font>");
               }
               else
               {
                  mainMc["Halloween2016Btn"].visible = false;
                  Main.disableButton(mainMc["Halloween2016Btn"],clickMapSideBtn,null);
               }
               if(Features.FEATURE_ROULETTE)
               {
                  Main.initButton(mapMenu["rouletteBtn"],proc.showRoulette,null);
                  if(proc.isShowRoulette)
                  {
                     mapMenu["rouletteBtn"].visible = true;
                     Main.showDynamicTooltip(mapMenu["rouletteBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.DAILYLUCKYDRAW) + "</font>");
                  }
                  else
                  {
                     mapMenu["rouletteBtn"].visible = false;
                     mapMenu["rouletteBtn"].removeEventListener(MouseEvent.CLICK,proc.showRoulette);
                  }
               }
               if(Main.showDailyRoulette > 0 && Main.checkGameStatus() == Timeline.MAP && Main.spinChance > 0)
               {
                  mapMenu["dailyRouletteBtn"].visible = true;
                  mapMenu["dailyRouletteBtn"].mouseEnabled = true;
                  mapMenu["dailyRouletteBtn"].addEventListener(MouseEvent.CLICK,clickMapSideBtn);
                  Main.showDynamicTooltip(mapMenu["dailyRouletteBtn"],"<font size =\'16\'>" + String(langLib.get(1859)[8]) + "</font>");
               }
               else
               {
                  mapMenu["dailyRouletteBtn"].visible = false;
                  mapMenu["dailyRouletteBtn"].mouseEnabled = false;
                  mapMenu["dailyRouletteBtn"].removeEventListener(MouseEvent.CLICK,clickMapSideBtn);
               }
               if(Features.FEATURE_DAILY_LOGIN)
               {
                  if(Central.main.dailyLogin)
                  {
                     Main.initButton(mapMenu["dailyLoginBtn"],clickMapSideBtn,null);
                     mapMenu["dailyLoginBtn"].visible = true;
                     mapMenu["dailyLoginBtn"]["newMc"].visible = false;
                     Main.showDynamicTooltip(mapMenu["dailyLoginBtn"],"<font size =\'16\'>" + String(langLib.titleTxt(TitleData.DAILY_LOGIN_TITLE)) + "</font>");
                  }
                  else
                  {
                     Main.disableButton(mapMenu["dailyLoginBtn"],clickMapSideBtn,null);
                     mapMenu["dailyLoginBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_DAILY_SCRATCH)
               {
                  if(Main.getMainChar().getLevel() <= 20)
                  {
                     Main.initButton(mapMenu["dailyScartchBtn"],clickMapSideBtn,null);
                     mapMenu["dailyScartchBtn"].visible = true;
                     mapMenu["dailyScartchBtn"]["newMc"].visible = false;
                     if(Main.currScartchCard > 0)
                     {
                        mapMenu["dailyScartchBtn"]["numMC"].visible = true;
                        mapMenu["dailyScartchBtn"]["numMC"]["numTxt"].text = Main.currScartchCard;
                     }
                     else
                     {
                        mapMenu["dailyScartchBtn"]["numMC"].visible = false;
                        mapMenu["dailyScartchBtn"]["numMC"]["numTxt"].text = "";
                     }
                     Main.showDynamicTooltip(mapMenu["dailyScartchBtn"],"<font size =\'16\'>" + String(langLib.get(1630)[0]) + "</font>");
                  }
                  else
                  {
                     Main.disableButton(mapMenu["dailyScartchBtn"],clickMapSideBtn,null);
                     mapMenu["dailyScartchBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_DAILY_TASK)
               {
                  if(Central.mission.checkDailyTaskStatus() > 0)
                  {
                     if(Central.mission.checkDailyTaskStatus() == 1)
                     {
                        mapMenu["dailyTaskMc"]["starMC"].visible = false;
                     }
                     if(Central.mission.checkDailyTaskStatus() == 2)
                     {
                        mapMenu["dailyTaskMc"]["starMC"].visible = true;
                     }
                     mapMenu["dailyTaskMc"].visible = true;
                     Main.initButton(mapMenu["dailyTaskMc"],showDailyTask,null);
                     Main.showDynamicTooltip(mapMenu["dailyTaskMc"],"<font size =\'16\'>" + langLib.get(402) + "</font>");
                     mapMenu["dailyTaskMc"]["newMc"].visible = false;
                  }
               }
               if(Features.FEATURE_GIFT)
               {
                  mapMenu["giftBtn"].visible = true;
                  mapMenu["giftBtn"]["newMc"].visible = false;
                  mapMenu["giftBtn"]["numMC"].visible = false;
                  mapMenu["giftBtn"]["numMC"]["numTxt"].text = "";
                  Main.initButton(mapMenu["giftBtn"],gotoSendGift,null);
                  Main.showDynamicTooltip(mapMenu["giftBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.NEW_FREE_GIFT) + "</font>");
               }
               if(Features.FEATURE_INVITE_REWARD)
               {
                  if(Features.FEATURE_INVITE_INSTANT_REWRAD)
                  {
                     mapMenu["inviteFriendBtn"].visible = true;
                     mapMenu["inviteFriendBtn"]["newMc"].visible = false;
                     Main.initButton(mapMenu["inviteFriendBtn"],clickMapSideBtn,null);
                     Main.showDynamicTooltip(mapMenu["inviteFriendBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.INVITEREWARDTITLE) + "</font>");
                  }
               }
               if(Features.FEATURE_MAIL)
               {
                  if(Main.currMail != 0)
                  {
                     mapMenu["mailboxBtn"].visible = true;
                     if(proc.newMail)
                     {
                        mapMenu["mailboxBtn"]["starMC"].visible = true;
                     }
                     else
                     {
                        mapMenu["mailboxBtn"]["starMC"].visible = false;
                     }
                     mapMenu["mailboxBtn"].gotoAndStop(2);
                     Main.initButton(mapMenu["mailboxBtn"],popup.showMailbox,null);
                     Main.showDynamicTooltip(mapMenu["mailboxBtn"],"<font size =\'16\'>" + langLib.titleTxt(TitleData.MAILBOX) + "</font>");
                  }
                  else
                  {
                     mapMenu["mailboxBtn"].visible = false;
                  }
               }
               if(Features.FEATURE_EMBLEM_DAILY_GIFT)
               {
                  mapMenu["emblemDailygiftBtn"].visible = true;
                  mapMenu["emblemDailygiftBtn"]["newMc"].visible = Central.main.extraData.emblem_type == 1;
                  Main.initButton(mapMenu["emblemDailygiftBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mapMenu["emblemDailygiftBtn"],"<font size =\'16\'>" + String(langLib.get(1634)[0]) + "</font>");
               }
               if(Features.FEATURE_REQUEST)
               {
                  mapMenu["requestPopupBtn"].visible = true;
                  if(Main.currRequest > 0)
                  {
                     mapMenu["requestPopupBtn"]["numMC"].visible = true;
                     mapMenu["requestPopupBtn"]["numMC"]["numTxt"].text = Main.currRequest;
                  }
                  else
                  {
                     mapMenu["requestPopupBtn"]["numMC"].visible = false;
                     mapMenu["requestPopupBtn"]["numMC"]["numTxt"].text = "";
                  }
                  Main.initButton(mapMenu["requestPopupBtn"],clickMapSideBtn,null);
                  Main.showDynamicTooltip(mapMenu["requestPopupBtn"],"<font size =\'16\'>" + Main.langLib.get(1615)[1] + "</font>");
               }
               shiftPosMapSideBtn();
               setIconPost();
               setRightIconPost();
               Main.updateLvStatusBar();
               if(!Main.Theme_Halloween)
               {
               }
            }
         }
      }
      
      public static function setIconPost() : void
      {
         var i:uint = 0;
         iconCanShow = 5;
         post = 0;
         canShow = false;
         isShowing = 0;
         canPress = true;
         showLIconArr = new Array();
         var setupIconPost:int = 0;
         for(i = 0; i < ALL_LEFT_BTN_ARR.length; i++)
         {
            if(mainMc[ALL_LEFT_BTN_ARR[i]].visible == true)
            {
               showLIconArr.push(ALL_LEFT_BTN_ARR[i]);
               mainMc[showLIconArr[setupIconPost]].post = setupIconPost;
               if(mainMc[showLIconArr[setupIconPost]].post >= iconCanShow || mainMc[showLIconArr[setupIconPost]].post < 0)
               {
                  TweenLite.to(mainMc[showLIconArr[setupIconPost]],0,{
                     "scaleX":0,
                     "scaleY":0
                  });
               }
               else
               {
                  TweenLite.to(mainMc[showLIconArr[setupIconPost]],0,{
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               setupIconPost++;
               isShowing++;
            }
         }
         if(isShowing - iconCanShow > 1)
         {
            lMaxY = mainMc[showLIconArr[iconCanShow + 1]].y;
            lMinY = mainMc[showLIconArr[0]].y;
            pressLimit = isShowing - iconCanShow;
         }
         else if(isShowing - iconCanShow > 0)
         {
            lMaxY = mainMc[showLIconArr[iconCanShow]].y;
            lMinY = mainMc[showLIconArr[0]].y;
            pressLimit = isShowing - iconCanShow;
         }
         else
         {
            mainMc["leftIconUp"].visible = false;
            mainMc["leftIconDown"].visible = false;
         }
      }
      
      public static function setRightIconPost() : void
      {
         var i:uint = 0;
         rIconCanShow = 5;
         rPost = 0;
         rCanShow = false;
         rIsShowing = 0;
         rCanPress = true;
         showIconArr = new Array();
         var setupIconPost:int = 0;
         for(i = 0; i < ALL_RIGHT_BTN_ARR.length; i++)
         {
            if(setupRightIconX)
            {
               mapMenu[ALL_RIGHT_BTN_ARR[i]].rightIconOriX = mapMenu[ALL_RIGHT_BTN_ARR[i]].x;
            }
            if(mapMenu[ALL_RIGHT_BTN_ARR[i]].visible == true)
            {
               showIconArr.push(ALL_RIGHT_BTN_ARR[i]);
               if(mapMenu[showIconArr[setupIconPost]].rPost == -1)
               {
                  mapMenu[showIconArr[setupIconPost]].x = mapMenu[showIconArr[setupIconPost]].x - 80;
               }
               mapMenu[showIconArr[setupIconPost]].rPost = setupIconPost;
               if(mapMenu[showIconArr[setupIconPost]].rPost >= rIconCanShow || mapMenu[showIconArr[setupIconPost]].rPost < 0)
               {
                  TweenLite.to(mapMenu[showIconArr[setupIconPost]],0,{
                     "scaleX":0,
                     "scaleY":0
                  });
               }
               else
               {
                  TweenLite.to(mapMenu[showIconArr[setupIconPost]],0,{
                     "scaleX":1,
                     "scaleY":1
                  });
               }
               setupIconPost++;
               rIsShowing++;
            }
         }
         setupRightIconX = false;
         if(rIsShowing - rIconCanShow > 1)
         {
            rMaxY = mapMenu[showIconArr[rIconCanShow + 1]].y;
            rMinY = mapMenu[showIconArr[0]].y;
            rPressLimit = rIsShowing - rIconCanShow;
         }
         else if(rIsShowing - rIconCanShow > 0)
         {
            rMaxY = mapMenu[showIconArr[rIconCanShow]].y;
            rMinY = mapMenu[showIconArr[0]].y;
            rPressLimit = rIsShowing - rIconCanShow;
         }
         else
         {
            mainMc["rightIconUp"].visible = false;
            mainMc["rightIconDown"].visible = false;
         }
      }
      
      public static function leftIconUp(evt:MouseEvent) : void
      {
         var seq:uint = 0;
         var i:uint = 0;
         if(canPress == true)
         {
            canPress = false;
            for(i = 0; i < showLIconArr.length; i++)
            {
               mainMc[showLIconArr[i]].post--;
               if(mainMc[showLIconArr[i]].post == 0 - pressLimit)
               {
                  if(isShowing != 6)
                  {
                     mainMc[showLIconArr[i]].post = showLIconArr.length - pressLimit;
                     mainMc[showLIconArr[i]].y = lMaxY;
                  }
               }
               if(mainMc[showLIconArr[i]].post >= iconCanShow)
               {
                  TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[i]].y - 70,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[i]].post < 0)
               {
                  if(isShowing == 6)
                  {
                     TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "y":mainMc[showLIconArr[i]].y - 15,
                        "onComplete":checkCanPress,
                        "onCompleteParams":[true,mainMc[showLIconArr[i]]]
                     });
                  }
                  else
                  {
                     TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "y":mainMc[showLIconArr[i]].y - 15,
                        "onComplete":checkCanPress
                     });
                  }
               }
               if(mainMc[showLIconArr[i]].post < iconCanShow && mainMc[showLIconArr[i]].post >= 0)
               {
                  TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                     "scaleX":1,
                     "scaleY":1,
                     "y":mainMc[showLIconArr[i]].y - 70,
                     "onComplete":checkCanPress
                  });
               }
            }
         }
      }
      
      public static function leftIconDown(evt:MouseEvent) : void
      {
         var seq:uint = 0;
         var i:uint = 0;
         var fromZero:Boolean = false;
         if(canPress == true)
         {
            canPress = false;
            for(i = 0; i < showLIconArr.length; i++)
            {
               if(mainMc[showLIconArr[i]].post == -1)
               {
                  mainMc[showLIconArr[i]].post = showLIconArr.length - 1;
               }
               if(mainMc[showLIconArr[i]].post == showLIconArr.length - 1)
               {
                  fromZero = true;
               }
               mainMc[showLIconArr[i]].post++;
               if(mainMc[showLIconArr[i]].post == showLIconArr.length)
               {
                  mainMc[showLIconArr[i]].post = 0;
                  mainMc[showLIconArr[i]].y = lMinY - 15;
               }
               if(mainMc[showLIconArr[i]].post >= iconCanShow)
               {
                  TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[i]].y + 70,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[i]].post < 0)
               {
                  TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "y":mainMc[showLIconArr[i]].y + 15,
                     "onComplete":checkCanPress
                  });
               }
               if(mainMc[showLIconArr[i]].post < iconCanShow && mainMc[showLIconArr[i]].post >= 0)
               {
                  if(fromZero)
                  {
                     TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mainMc[showLIconArr[i]].y + 15,
                        "onComplete":checkCanPress
                     });
                     fromZero = false;
                  }
                  else
                  {
                     TweenLite.to(mainMc[showLIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mainMc[showLIconArr[i]].y + 70,
                        "onComplete":checkCanPress
                     });
                  }
               }
            }
         }
      }
      
      public static function rightIconUp(evt:MouseEvent) : void
      {
         var seq:uint = 0;
         var i:uint = 0;
         var fromMax:Boolean = false;
         if(rCanPress == true)
         {
            rCanPress = false;
            for(i = 0; i < showIconArr.length; i++)
            {
               if(mapMenu[showIconArr[i]].rPost == rIconCanShow)
               {
                  fromMax = true;
               }
               mapMenu[showIconArr[i]].rPost--;
               if(mapMenu[showIconArr[i]].rPost == 0 - rPressLimit)
               {
                  if(rIsShowing == 6)
                  {
                     mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].rightIconOriX;
                  }
                  else
                  {
                     mapMenu[showIconArr[i]].y = rMaxY;
                     mapMenu[showIconArr[i]].rPost = showIconArr.length - rPressLimit;
                     mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].x - 80;
                     mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].rightIconOriX;
                  }
               }
               if(mapMenu[showIconArr[i]].rPost >= rIconCanShow)
               {
                  mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].x + 80;
                  TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[i]].x - 80,
                     "y":mapMenu[showIconArr[i]].y - 70,
                     "onComplete":checkCanRpress
                  });
               }
               if(mapMenu[showIconArr[i]].rPost < 0)
               {
                  if(rIsShowing == 6)
                  {
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "x":mapMenu[showIconArr[i]].x + 80,
                        "y":mapMenu[showIconArr[i]].y - 15,
                        "onComplete":checkCanRpress,
                        "onCompleteParams":[false,mapMenu[showIconArr[i]],true]
                     });
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":0,
                        "scaleY":0,
                        "x":mapMenu[showIconArr[i]].x + 80,
                        "y":mapMenu[showIconArr[i]].y - 15,
                        "onComplete":checkCanRpress
                     });
                  }
               }
               if(mapMenu[showIconArr[i]].rPost < rIconCanShow && mapMenu[showIconArr[i]].rPost >= 0)
               {
                  if(fromMax)
                  {
                     mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].x + 80;
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "x":mapMenu[showIconArr[i]].x - 80,
                        "y":mapMenu[showIconArr[i]].y - 70,
                        "onComplete":checkCanRpress
                     });
                     fromMax = false;
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mapMenu[showIconArr[i]].y - 70,
                        "onComplete":checkCanRpress
                     });
                  }
               }
            }
         }
      }
      
      public static function rightIconDown(evt:MouseEvent) : void
      {
         var seq:uint = 0;
         var i:uint = 0;
         var fromZero:Boolean = false;
         if(rCanPress == true)
         {
            rCanPress = false;
            for(i = 0; i < showIconArr.length; i++)
            {
               if(mapMenu[showIconArr[i]].rPost == -1)
               {
                  mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].x - 80;
                  mapMenu[showIconArr[i]].rPost = showIconArr.length - 1;
               }
               if(mapMenu[showIconArr[i]].rPost == showIconArr.length - 1)
               {
                  fromZero = true;
               }
               mapMenu[showIconArr[i]].rPost++;
               if(mapMenu[showIconArr[i]].rPost == showIconArr.length)
               {
                  mapMenu[showIconArr[i]].y = rMinY - 30;
                  mapMenu[showIconArr[i]].rPost = 0;
               }
               if(mapMenu[showIconArr[i]].rPost >= rIconCanShow)
               {
                  TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[i]].x + 80,
                     "y":mapMenu[showIconArr[i]].y + 70,
                     "onComplete":checkCanRpress,
                     "onCompleteParams":[true,mapMenu[showIconArr[i]]]
                  });
               }
               if(mapMenu[showIconArr[i]].rPost <= -1)
               {
                  TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                     "scaleX":0,
                     "scaleY":0,
                     "x":mapMenu[showIconArr[i]].x - 80,
                     "y":mapMenu[showIconArr[i]].y + 30,
                     "onComplete":checkCanRpress
                  });
               }
               if(mapMenu[showIconArr[i]].rPost < rIconCanShow && mapMenu[showIconArr[i]].rPost >= 0)
               {
                  if(fromZero)
                  {
                     mapMenu[showIconArr[i]].x = mapMenu[showIconArr[i]].x + 80;
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "x":mapMenu[showIconArr[i]].x - 80,
                        "y":mapMenu[showIconArr[i]].y + 30,
                        "onComplete":checkCanRpress
                     });
                     fromZero = false;
                  }
                  else
                  {
                     TweenLite.to(mapMenu[showIconArr[i]],0.5,{
                        "scaleX":1,
                        "scaleY":1,
                        "y":mapMenu[showIconArr[i]].y + 70,
                        "onComplete":checkCanRpress
                     });
                  }
               }
            }
         }
      }
      
      public static function checkCanPress(move:Boolean = false, mc:MovieClip = null) : void
      {
         canPress = true;
         if(move)
         {
            mc.post = showLIconArr.length - pressLimit;
            mc.y = lMaxY;
         }
      }
      
      public static function checkCanRpress(move:Boolean = false, mc:MovieClip = null, extra:Boolean = false) : void
      {
         rCanPress = true;
         if(move)
         {
            mc.x = mc.x - 80;
         }
         if(extra)
         {
            mc.rPost = showIconArr.length - rPressLimit;
            mc.y = rMaxY;
            mc.x = mc.x - 80;
         }
      }
      
      public static function addInventoryYM() : void
      {
         if(Main.minik_xmas_gift != null)
         {
            switch(Main.minik_xmas_gift_type)
            {
               case "back":
                  Main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,Main.minik_xmas_gift);
                  break;
               case "set":
                  Main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,Main.minik_xmas_gift);
                  break;
               case "wpn":
                  Main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,Main.minik_xmas_gift);
                  break;
               case "skill":
                  Central.main.getMainChar().addNewSkill(Main.minik_xmas_gift,new Function());
                  break;
               case "token":
                  Main.account.balance = Main.account.getAccountBalance() + 100;
                  Main.updateMenu();
            }
            Main.minik_xmas_gift = null;
         }
      }
      
      private static function SJENoticeOk() : void
      {
         Central.main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.watchSJENotice",[Central.main.account.getAccountSessionKey()],onSJENoticeResult);
      }
      
      public static function onSJENoticeResult(response:Object) : void
      {
         if(validateAmfResponse(response))
         {
            Main.sje_notice++;
         }
         Central.main.hideAmfLoading();
      }
      
      private static function confirmActivateHM(evt:MouseEvent) : void
      {
         var i:int = 0;
         var displayTxt:String = null;
         var playB4:Boolean = false;
         var tempMsnRecord:Object = null;
         if(Main.dayleft < 0)
         {
            playB4 = false;
            for(i = 0; i < Data.EXAM_SPECIAL_JOUNIN_ARR.length; i++)
            {
               tempMsnRecord = Main.getMainChar().checkMissionRecord(Data.EXAM_SPECIAL_JOUNIN_ARR[i]);
               if(tempMsnRecord.success > 0 || tempMsnRecord.fail > 0)
               {
                  playB4 = true;
                  break;
               }
            }
            if(playB4)
            {
               displayTxt = String(Main.langLib.get(1437)[32]);
            }
            else
            {
               displayTxt = String(Main.langLib.get(1437)[31]);
            }
            Main.showConfirmation(displayTxt,confirmStartSJExam,new Function());
         }
         else
         {
            Main.proc.showExam();
         }
      }
      
      public static function confirmStartSJExam() : void
      {
         Main.showAmfLoading();
         Main.amfClient.service("CharacterService.startSJExam",[Central.main.account.getAccountSessionKey()],responseStartSJExam);
      }
      
      public static function responseStartSJExam(response:Object) : void
      {
         Main.hideAmfLoading();
         if(validateAmfResponse(response))
         {
            Main.dayleft = response.sje_end_date as int;
            Main.proc.showExam();
         }
      }
      
      public static function initMapButtons() : void
      {
         mainMc["mapMc"].initBuildings();
      }
      
      private static function onClickShop(evt:MouseEvent = null) : void
      {
         Panel.getInstance().show("shop_new");
      }
      
      private static function onClickMission(evt:MouseEvent = null) : void
      {
         Panel.getInstance().show("mission_2");
      }
      
      private static function gotoSendGift(evt:MouseEvent = null) : void
      {
         Central.main.loadPopupPanel("popup_sendGift","ninjasaga.linkage.popup_sendGift");
      }
      
      private static function showJouninExam(e:MouseEvent) : void
      {
         Panel.getInstance().show("jounin_exam");
      }
      
      public static function showNinjaAssociation(frame:String) : void
      {
         Panel.getInstance().show("ninja_association",frame);
      }
      
      public static function highlightMap(frameNumber:uint) : void
      {
         mainMc["mapMc"]["highlightMc"].gotoAndStop(frameNumber);
      }
      
      public static function onClickRandomBattle() : void
      {
         var i:uint = 0;
         var enemyData:Object = null;
         tracking.trackStartAction(Central.main.tracking.SA_PRACTICE_BATTLE);
         Mission.clearMission();
         var enemyArr:Array = EnemyData.getInstance().arr;
         var rNum:Number = NumberUtil.randomNumber(1,3.999);
         var eNum:uint = Math.floor(rNum);
         var randomEnemies:Array = [];
         var rEnemies:Array = [];
         for(i = 0; i < enemyArr.length; i++)
         {
            enemyData = enemyArr[i];
            if(enemyData.randomBattle && getMainChar().getLevel() >= enemyData.minLevel)
            {
               randomEnemies.push(enemyData);
            }
         }
         for(i = 0; i < eNum; i++)
         {
            rEnemies.push(randomEnemies[Math.floor(NumberUtil.randomNumber(0,randomEnemies.length))]);
         }
         setEnemy(rEnemies);
         Battle.setBattleBg(MovieClip(getLib("practice_bg")));
      }
      
      public static function gotoPanel() : void
      {
         mainMc.gotoPanel();
      }
      
      public static function addPanel(_panel:MovieClip) : void
      {
         mainMc["panelHolder"].addChild(_panel);
      }
      
      public static function getPanel() : MovieClip
      {
         if(checkGameStatus() == Timeline.PANEL)
         {
            if(mainMc["panelHolder"].numChildren > 0)
            {
               return mainMc["panelHolder"].getChildAt(0);
            }
            return null;
         }
         return null;
      }
      
      public static function removePanel(_panel:MovieClip) : void
      {
         mainMc["panelHolder"].removeChild(_panel);
      }
      
      public static function showPanel() : void
      {
         if(Battle.type == Battle.TYPE_NETWORK)
         {
            Battle.type = null;
            Panel.getInstance().reshow();
         }
         else
         {
            Panel.getInstance().onShowPanel();
         }
      }
      
      public static function showAchievement(evt:MouseEvent = null) : void
      {
         var mc:MovieClip = null;
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
            mc = GF.getAsset(achievementPanel,"ninjasaga.linkage.panel.Achievement");
            mainMc["overlayHolder"].addChild(mc);
            mc.show();
         }
      }
      
      public static function removeOverlayPanel() : void
      {
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
         }
      }
      
      public static function showMinikPromotion(evt:MouseEvent = null) : void
      {
         var mc:MovieClip = null;
         if(mainMc["overlayHolder"])
         {
            GF.removeAllChild(mainMc["overlayHolder"]);
            mc = GF.getAsset(mainMc,"ninjasaga.linkage.panel.MinikPromotion");
            mainMc["overlayHolder"].addChild(mc);
            mc.show();
         }
      }
      
      public static function onAdminMessage(message:String) : void
      {
         Out.debug("","Rex: testing onAdminMessage");
         adminMessage = message;
         mainMc["popupAdminMessage"].gotoAndPlay("show");
      }
      
      public static function loadPopupPanel(_swfName:String, _clsName:String, _cbFn:Function = null) : void
      {
         Main.showAmfLoading();
         if(!Item.hasItem(_swfName))
         {
            Main.loadSwf(["swf/panels/" + _swfName + ".swf"],showPopupPanel,{
               "swfName":_swfName,
               "clsName":_clsName,
               "cbFn":_cbFn
            });
         }
         else
         {
            showPopupPanel(null,{
               "swfName":_swfName,
               "clsName":_clsName,
               "cbFn":_cbFn
            });
         }
      }
      
      private static function showPopupPanel(_swfObj:Object, params:Object) : void
      {
         var panel:Item = null;
         var mc:MovieClip = null;
         Main.hideAmfLoading();
         if(params != null)
         {
            if(_swfObj != null)
            {
               if(!Item.hasItem(params.swfName))
               {
                  panel = new Item(params.swfName);
                  panel.setSwf(_swfObj["swf/panels/" + params.swfName + ".swf"]);
                  Item.setItem(panel);
               }
            }
            if(params.cbFn == null)
            {
               if(mainMc["eventPopupHolder"])
               {
                  GF.removeAllChild(mainMc["eventPopupHolder"]);
                  panel = Item.getItem(params.swfName);
                  mc = panel.getAsset(params.clsName);
                  mainMc["eventPopupHolder"].addChild(mc);
                  mc.show();
               }
            }
            else
            {
               Main.eventPopupPanel_CB = params.cbFn;
               Main.eventPopupPanel_CB();
            }
         }
      }
      
      public static function removeEventPopupPanel() : void
      {
         if(mainMc["eventPopupHolder"])
         {
            GF.removeAllChild(mainMc["eventPopupHolder"]);
         }
      }
      
      public static function playCinematics(mc:MovieClip) : void
      {
         if(mainMc.currentLabel == Timeline.MC_PLAYER)
         {
            mainMc["mcHolder"].addChild(mc);
         }
         else
         {
            cinematicsMc = mc;
            mainMc.gotoMCPlayer();
         }
      }
      
      public static function removeMC() : void
      {
         GF.removeAllChild(mainMc["mcHolder"]);
      }
      
      public static function loadSwf(_arr:Array, _onComplete:Function, params:Object = null, displayText:String = null) : void
      {
         trace("loadSwf: " + _arr);
         if(_arr.length == 1)
         {
            if(_arr[0].indexOf("/mission/") >= 0)
            {
               Mission.stateHash = getHash("loadSwf");
            }
         }
         mainMc["preloader"].loadSwf(_arr,_onComplete,params,displayText);
      }
      
      public static function loadSwfByVersion(_arr:Array, _onComplete:Function, params:Object = null, displayText:String = null) : void
      {
         mainMc["preloader"].loadSwfByVersion(_arr,_onComplete,params,displayText);
      }
      
      public static function dynamicLoad(path:String, cb:Function) : void
      {
         mainMc["preloader"].dynamicLoad(path,cb);
      }
      
      public static function loadBossSwf(eneNames:Array, cb:Function, cbParams:Object = null) : Boolean
      {
         var BossSwf:String = null;
         var i:int = 0;
         var returnValue:Boolean = false;
         var swfArr:Array = [];
         var params:Object = new Object();
         try
         {
            for(i = 0; i < eneNames.length; i++)
            {
               if(!Item.hasItem(Central.main.ENEMY_DATA.find(eneNames[i]).swfName))
               {
                  swfArr.push("swf/enemies/" + Central.main.ENEMY_DATA.find(eneNames[i]).swfName + ".swf");
               }
            }
            if(swfArr.length > 0)
            {
               params.eneNames = eneNames;
               params.cb = cb;
               params.cbParams = cbParams;
               Central.main.loadSwf(swfArr,Main.loadDisplayBossFinish,params);
            }
            else
            {
               returnValue = true;
            }
         }
         catch(err:Error)
         {
            Out.error("Main","Can not loadSwf :: " + err.message);
         }
         return returnValue;
      }
      
      public static function loadDisplayBossFinish(swfObj:Object, params:Object) : void
      {
         var item:Item = null;
         var i:int = 0;
         try
         {
            for(i = 0; i < params.eneNames.length; i++)
            {
               if(!Item.hasItem(Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName))
               {
                  item = new Item(Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName);
                  item.setSwf(swfObj["swf/enemies/" + Central.main.ENEMY_DATA.find(params.eneNames[i]).swfName + ".swf"]);
                  Item.setItem(item);
               }
            }
         }
         catch(err:Error)
         {
            Out.error("Main","Can not setItem :: " + err.message);
         }
         if(params.cbParams == null)
         {
            params.cb();
         }
         else
         {
            params.cb(params.cbParams);
         }
      }
      
      private static function startGame() : void
      {
         mapMenu.init();
         if(isNewChar)
         {
            Main.updateMenu();
            Mission.start();
         }
         else
         {
            mainMc.gotoMap();
         }
         if(isNewChar == true)
         {
            return;
         }
         achievement.checkSpecialAchievement(achievementData.NINJA_EMBLEM);
         achievement.checkSpecialAchievement(achievementData.SKILL_TRAINED);
         achievement.checkSpecialAchievement(achievementData.KINJUTSU_TRAINED);
         achievement.checkOfflineAchievement();
      }
      
      public static function startInit() : void
      {
         MISSION_DATA = dataLib.getMissionDetail();
         MISSION_DATA_AA = new AssociateArray(MISSION_DATA,"level",Array.NUMERIC);
         Features.setFeatureControl();
         Mission.clearMission();
         mainMc.gotoInit();
      }
      
      public static function selectChar() : void
      {
         mainMc.gotoSelchar();
      }
      
      public static function login(evt:Event = null) : void
      {
         mainMc.gotoLogin();
      }
      
      public static function checkGameStatus() : String
      {
         return mainMc.currentLabel;
      }
      
      public static function restoreMapMissionChar() : void
      {
         mainMc["mapMissionMc"].restoreMainChar();
      }
      
      public static function canVisit() : Boolean
      {
         return !(mainMc["preloader"].isLoading || Mission.curMissionID != null);
      }
      
      public static function dispatchGameEvent(_evt:String) : Boolean
      {
         if(Mission.dispatchGameEvent(_evt))
         {
            return true;
         }
         return false;
      }
      
      public static function get popup() : MovieClip
      {
         return mainMc.popupMc;
      }
      
      public static function showInfo(_msg:String) : void
      {
         popup.showInfo(_msg);
      }
      
      public static function showMissionComplete(_data:Object, _levelup:Boolean) : void
      {
         popup.showMissionComplete(_data,_levelup);
      }
      
      public static function showUpgradeAccount(msg:String, place:String) : void
      {
         popup.showUpgradeAccount(msg,place);
      }
      
      public static function showReportBugForm(evt:MouseEvent) : void
      {
         popup.showBugReportForm();
      }
      
      public static function showLevelUp(cbFn:Function = null) : void
      {
         popup.showLevelUp(cbFn);
      }
      
      public static function showTokenEmblemSelection(type:uint, hairId:String = null) : void
      {
         popup.showTokenEmblemSelection(type,hairId);
      }
      
      public static function showGetDailyTask() : void
      {
         mainMc["dailyTaskMc"].gotoGet();
      }
      
      public static function showDailyTask(evt:MouseEvent = null) : void
      {
         if(checkGameStatus() == Timeline.MAP)
         {
            mainMc["dailyTaskMc"].gotoShow();
         }
         else
         {
            showInfo(langLib.get(211));
         }
      }
      
      public static function getLib(_cls:String) : *
      {
         var holder:MovieClip = null;
         if(String(_cls).indexOf("skill_") >= 0 || String(_cls).indexOf("Skill_") >= 0)
         {
            _cls = String(_cls).toLowerCase();
            holder = new MovieClip();
            Item.getSkillIcon(_cls,holder);
            return holder;
         }
         return GF.getAsset(lib,_cls);
      }
      
      public static function gotoPaymentGateway(evt:MouseEvent = null) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               callJS("PopupPurchase");
               break;
            case AppData.OK:
               gotoURL(Data.PAYMENT_GATEWAY + Account.getAccountId() + "&lang=" + AppData.lang,"_blank");
               break;
            case AppData.MP:
               gotoURL(Data.PAYMENT_GATEWAY + Account.getAccountId() + "&lang=" + AppData.lang,"_blank");
               break;
            case AppData.RR:
               gotoURL(Data.PAYMENT_GATEWAY,"_blank");
               break;
            default:
               gotoURL(Data.PAYMENT_PHP,"_blank");
         }
      }
      
      public static function gotoTokenExGold(evt:MouseEvent = null) : void
      {
         Central.main.loadPopupPanel("popup_tokenbuygold","ninjasaga.linkage.TokenBuyGold");
      }
      
      public static function buyCrystal(evt:MouseEvent = null) : void
      {
         gotoURL(Data.EARN_TOKEN_URL,"_blank");
      }
      
      public static function gotoEmblemDetail(evt:MouseEvent = null) : void
      {
         gotoURL("http://www.ninjasaga.com/ninja-emblem/","_blank");
      }
      
      public static function gotoEarnTokenPage(evt:MouseEvent = null) : void
      {
         gotoURL("http://www.ninjasaga.com/earn-token/","_blank");
      }
      
      public static function gotoURL(url:String, target:String = "_self") : void
      {
         switch(target)
         {
            case "_self":
               navigateToURL(new URLRequest(url),"_top");
               break;
            case "_blank":
               navigateToURL(new URLRequest(url),"_blank");
         }
      }
      
      public static function getAppFBFriends(cbFn:Function, noCache:Boolean = false) : void
      {
         if(AppData.type != AppData.FB)
         {
            return;
         }
         SNS.getAppFriends(cbFn,noCache);
      }
      
      public static function saveChallengeRecord(charId:uint, result:uint) : void
      {
         var resultStr:String = null;
         switch(result)
         {
            case 0:
               resultStr = "win";
               break;
            case 1:
               resultStr = "lose";
               break;
            case 2:
               resultStr = "run";
               break;
            case 3:
               resultStr = "run";
               break;
            default:
               resultStr = "";
         }
         amfClient.service("FacebookService.saveChallengeRecord",[Account.getAccountSessionKey(),challengeFriendUID,charId,resultStr],saveChallengeRecordResult);
      }
      
      private static function saveChallengeRecordResult(result:Object) : void
      {
         if(!validateAmfResponse(result))
         {
            onError(String(result.error));
         }
      }
      
      public static function saveRecruitRecord(sourceId:String, charId:uint, level:uint) : void
      {
         if(AppData.type == AppData.RR)
         {
            amfClient.service("SocialNetwork.saveRecruitRecord",[Account.getAccountSessionKey(),sourceId,charId,level],saveRecruitRecordResult);
         }
         else
         {
            amfClient.service("FacebookService.saveRecruitRecord",[Account.getAccountSessionKey(),sourceId,charId,level],saveRecruitRecordResult);
         }
      }
      
      private static function saveRecruitRecordResult(result:Object) : void
      {
         if(!validateAmfResponse(result))
         {
            onError(String(result.error));
         }
      }
      
      public static function submitLogDump() : void
      {
         gameLockout = true;
         var charId:uint = 0;
         if(Main.getMainChar())
         {
            if(Main.getMainChar().getDBChar())
            {
               charId = Main.getMainChar().getDBChar().character_id;
            }
         }
         amfClient.service("ReportService.reportLogDump",[Account.getAccountSessionKey(),charId,Out.getLoggerDump(),Capabilities.version,Capabilities.playerType,Capabilities.os,Data.BUILD_NO],onSubmitLogDumpResult);
      }
      
      public static function submitData() : void
      {
         gameLockout = true;
         var charId:uint = 0;
         if(Main.getMainChar())
         {
            if(Main.getMainChar().getDBChar())
            {
               charId = Main.getMainChar().getDBChar().character_id;
            }
         }
         amfClient.service("ReportService.submitData",[Account.getAccountSessionKey(),charId,Out.dataLogger,Capabilities.version,Capabilities.playerType,Capabilities.os,Data.BUILD_NO],onSubmitLogDumpResult);
      }
      
      private static function onSubmitLogDumpResult(result:Object) : void
      {
         Main.onError();
      }
      
      public static function provision() : void
      {
      }
      
      private static function onProvisionResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            onError();
            return;
         }
         var arr:Array = result.result as Array;
         var check:int = (arr[0] % 7 + 1) * (arr[0] % 1024 + arr[0] % 512 + arr[0] % 11);
         if(check != arr[1])
         {
            Main.onError();
         }
         if(Account.getAccountTypeNoVerify() % 2 != arr[0] % 2)
         {
            Main.onError();
         }
      }
      
      public static function saveLog(securityType:uint, clientValue:String) : void
      {
         amfClient.service("ReportService.saveLog",[Account.getAccountSessionKey(),String(securityType),clientValue],saveLogResult);
      }
      
      public static function saveLogResult(result:Object) : void
      {
      }
      
      public static function selectServer(serverId:uint) : void
      {
         selectedPvpServer = serverId;
      }
      
      public static function connect() : void
      {
         Out.debug("Main","Hank 1.2.1.1 :: connect");
         if(socket.isConnected())
         {
            Out.debug("Main","Hank 1.2.1.2 :: is Connected");
            if(Central.main.PvpPlayerPlace == "PVE")
            {
               trace("Main connect :: Central.main.PvpPlayerPlace == PVE");
               Central.panel.getInstance().curPanel.play();
            }
            else
            {
               trace("Main connect :: Central.main.PvpPlayerPlace != PVE");
            }
         }
         else
         {
            Out.debug("Main","Hank 1.2.1.3 :: not Connected");
            socket.connect();
         }
         getMainChar().pvpSecurityCheck();
      }
      
      public static function gotReadyInfo(charId:uint) : void
      {
         if(charId == getMainChar().getData(DBCharacterData.ID))
         {
            return;
         }
         if(checkGameStatus() == Timeline.BATTLE)
         {
            if(Battle.type == Battle.TYPE_NETWORK && (Central.main.PvpPlayerPost == "quick" || Central.main.PvpPlayerPost == "tournament"))
            {
               if(mainMc["battleMc"])
               {
                  if(mainMc["battleMc"].currentLabel == "pvp_win" || mainMc["battleMc"].currentLabel == "pvp_lose")
                  {
                     Battle.showRematch(charId);
                  }
               }
            }
         }
      }
      
      public static function loadDBChar(charId:uint) : void
      {
      }
      
      public static function loadDBCharForBattle(charId:uint) : void
      {
         showAmfLoading();
         amfClient.service("CharacterDAO.getPvpCharacter",[Account.getAccountSessionKey(),charId],onAmfGetCharacterForBattleResult);
      }
      
      private static function onAmfGetCharacterForBattleResult(result:Object) : void
      {
         var tempSkills:Array = null;
         var i:int = 0;
         Out.debug("Main","onAmfGetCharacterForBattleResult , result " + GF.printObject(result));
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            onError(String(result.error));
            return;
         }
         var _dbChar:DBCharacter = dataParser.parseRawCharacter(result.result,true);
         Out.debug("","_dbChar " + _dbChar.character_id + " = " + GF.printObject(_dbChar));
         tempSkills = String(result.result.character_skill).split(",");
         for(i = 0; i < tempSkills.length; i++)
         {
            try
            {
               if(SKILL_DATA[tempSkills[i]])
               {
                  if(int(SKILL_DATA[tempSkills[i]].special_class) > 0)
                  {
                     getMainChar().setClassSkillListArr(tempSkills[i]);
                  }
               }
            }
            catch(err:Error)
            {
               Out.error("onAmfGetCharacterForBattleResult : ","Do not have SKILL_DATA " + tempSkills[i]);
            }
         }
         if(usermap.containsKey(_dbChar.character_id))
         {
            usermap.remove(_dbChar.character_id);
            usermap.insert(_dbChar.character_id,_dbChar);
         }
         else
         {
            usermap.insert(_dbChar.character_id,_dbChar);
         }
         Out.debug("","usermap = " + GF.printObject(usermap));
         var petData:Object = result.pet_data as Object;
         if(loadedPvpCharacter == 0)
         {
            resetOpponent();
         }
         Out.debug("","~~PvpPlayerPlace = " + PvpPlayerPlace);
         if(PvpPlayerPlace == "quick")
         {
            if(loadedPvpCharacter >= PvpQMMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "tournament")
         {
            Out.debug("","get character pvp result");
            if(loadedPvpCharacter >= PvpTournamentMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "private")
         {
            if(loadedPvpCharacter >= PvpPVMode * 2 - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         else if(PvpPlayerPlace == "PVE")
         {
            if(loadedPvpCharacter >= PvpTeamA.length - 1)
            {
               resetOpponent();
               loadedPvpCharacter = 0;
            }
         }
         addOpponent(_dbChar,petData);
         getMainChar().restoreOriginalStatus();
         loadedPvpCharacter++;
         trace("number tracker PvpQMMode = " + PvpQMMode + ", PvpTournamentMode = " + PvpTournamentMode);
         if(PvpPlayerPlace == "quick")
         {
            trace("load quick complete~~~");
            if(loadedPvpCharacter >= PvpQMMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "tournament")
         {
            trace("load tournament complete~~~");
            if(loadedPvpCharacter >= PvpTournamentMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "private")
         {
            if(loadedPvpCharacter >= PvpPVMode * 2 - 1)
            {
               socket.loadDBCompleted();
            }
         }
         else if(PvpPlayerPlace == "PVE")
         {
            if(loadedPvpCharacter >= PvpTeamA.length - 1)
            {
               socket.loadDBCompleted();
            }
         }
      }
      
      public static function getDBCharFromMap(charId:uint) : DBCharacter
      {
         if(usermap.containsKey(charId))
         {
            return usermap.find(charId);
         }
         return null;
      }
      
      public static function getCharNameFromMap(charId:uint) : String
      {
         if(usermap.containsKey(charId))
         {
            return usermap.find(charId).character_name;
         }
         return null;
      }
      
      public static function isDBCharExist(charId:*) : Boolean
      {
         return usermap.containsKey(charId);
      }
      
      public static function disconnect() : void
      {
         Central.main.socket.logout();
      }
      
      public static function verifyChatInput(str:String) : String
      {
         var curTime:Number = new Date().time;
         str = StringUtil.trim(str);
         if(str.length == 0)
         {
            return "";
         }
         if(str.length > Data.CHAT_INPUT_MAX_CHARACTERS)
         {
            showInfo(String(langLib.get(216)).replace("[valmaxchar]",String(Data.CHAT_INPUT_MAX_CHARACTERS)));
            return "";
         }
         if(chatInputTime)
         {
            if(curTime < chatInputTime + Data.CHAT_INPUT_COOLDOWN * 1000)
            {
               showInfo(String(langLib.get(217)).replace("[valinputcooldown]",String(Data.CHAT_INPUT_COOLDOWN)));
               return "";
            }
         }
         if(chatInputArr.indexOf(str.toLowerCase()) >= 0)
         {
            showInfo(langLib.get(218));
            return "";
         }
         chatInputTime = curTime;
         while(chatInputArr.length >= 3)
         {
            chatInputArr.shift();
         }
         chatInputArr.push(str.toLowerCase());
         return str;
      }
      
      public static function rankup() : void
      {
         amfClient.service("CharacterDAO.rankup",[Account.getAccountSessionKey()],rankupResult);
      }
      
      private static function rankupResult(_result:Object) : void
      {
         if(String(_result.status) == AMFData.STATUS_ERROR)
         {
            Out.error("Main","rankupResult :: error code " + String(_result.error));
            onError(String(_result.error));
            return;
         }
      }
      
      public static function get tracking() : TrackingSystem
      {
         return TrackingSystem.getInstance();
      }
      
      public static function get dataParser() : DataParser
      {
         return DataParser.getInstance();
      }
      
      public static function get achievement() : Achievement
      {
         return Achievement.getInstance();
      }
      
      public static function get amfClient() : AMFConnector
      {
         return AMFConnector.getInstance();
      }
      
      public static function onAmfResult(response:Object) : void
      {
         if(!validateAmfResponse(response))
         {
            onError();
         }
      }
      
      public static function reportServiceResponse(response:Object) : void
      {
         if(!validateAmfResponse(response))
         {
            onError();
         }
      }
      
      public static function validateAmfResponse(response:Object) : Boolean
      {
         var characterLevel:int = 0;
         if(response == null)
         {
            onError();
            return false;
         }
         if(response.status == null)
         {
            onError();
            return false;
         }
         if(String(response.status) == AMFData.STATUS_ERROR)
         {
            if(String(response.error) == "1100")
            {
               if(response.recover)
               {
                  _errorRecover = response.recover;
                  _errorRecoverObj = {};
                  _errorRecoverObj.character_id = response.character_id;
                  _errorRecoverObj.character_name = response.character_name;
                  _errorRecoverObj.character_level = response.character_level;
               }
               onError(String(response.error),String(response.error_message));
            }
            else
            {
               onError(String(response.error));
            }
            return false;
         }
         if(String(response.status) != AMFData.STATUS_SUCCESS)
         {
            onError(String(response.error));
            return false;
         }
         var update_inventory:* = response.update_inventory;
         if(update_inventory)
         {
            characterLevel = Central.main.getMainChar().getLevel();
            if(update_inventory.add_item_id && update_inventory.add_item_id.length > 0)
            {
               Toolkit.addInventoryByArray(update_inventory.add_item_id,!!update_inventory.add_pet_data?update_inventory.add_pet_data:null);
               if(update_inventory.showPopup !== false)
               {
                  Central.main.showInfo(AppData.lang == AppData.ZH?"獲得獎勵":AppData.lang == AppData.EN?"Get Reward":"Consigue Premio");
                  mainMc["confirmationMc"].showGetReward(update_inventory.add_item_id);
               }
            }
            if(update_inventory.remove_item_id && update_inventory.remove_item_id.length > 0)
            {
               Toolkit.removeInventoryByArray(update_inventory.remove_item_id,!!update_inventory.remove_pet_data?update_inventory.remove_pet_data:null);
            }
            if(update_inventory.xp !== undefined)
            {
               Central.main.getMainChar().setXp(update_inventory.xp,update_inventory.pet_xp);
            }
            if(Central.main.getMainChar().getLevel() > characterLevel)
            {
               Central.main.showLevelUp();
               Central.main.updateLvStatusBar();
               Central.main.initMapButtons();
            }
            if(update_inventory.gold !== undefined)
            {
               Central.main.getMainChar().setGold(update_inventory.gold);
            }
            if(update_inventory.token !== undefined)
            {
               Account.balance = update_inventory.token;
            }
            if(update_inventory.MCoin !== undefined)
            {
               Central.main.extraData.MCoin = update_inventory.MCoin;
            }
            Central.main.updateMenu();
            if(update_inventory.totalMCoin !== undefined)
            {
               Central.main.extraData.totalMCoin = update_inventory.totalMCoin;
            }
            Central.main.updateMenu();
         }
         if(response.reduce_xp_bonus_time)
         {
            Central.main.extraData.emblem_xp_bonus_times--;
         }
         return true;
      }
      
      public static function get formula() : Class
      {
         return Formula;
      }
      
      public static function get account() : *
      {
         return Account;
      }
      
      public static function get coreData() : Class
      {
         return CoreData;
      }
      
      public static function get achievementData() : *
      {
         return AchievementData;
      }
      
      public static function get errorData() : Class
      {
         return ErrorData;
      }
      
      public static function get asset() : Asset
      {
         return Asset.getInstance();
      }
      
      public static function get localCache() : LocalCache
      {
         return LocalCache.getInstance();
      }
      
      public static function get graphicController() : GraphicController
      {
         return GraphicController.getInstance();
      }
      
      public static function get showAds() : Boolean
      {
         return _showAds;
      }
      
      public static function set showAds(b:Boolean) : void
      {
         if(getMainChar() == null)
         {
            _showAds = false;
         }
         if(getMainChar().getLevel() >= 6)
         {
            _showAds = b;
         }
         else
         {
            _showAds = false;
         }
      }
      
      public static function set PvpPlayerPlace(newState:String) : void
      {
         _PvpPlayerPlace = newState;
      }
      
      public static function get PvpPlayerPlace() : String
      {
         return _PvpPlayerPlace;
      }
      
      public static function set PvpPlayerPost(newState:String) : void
      {
         _PvpPlayerPost = newState;
      }
      
      public static function get PvpPlayerPost() : String
      {
         return _PvpPlayerPost;
      }
      
      public static function set PvpBattleType(newState:String) : void
      {
         _PvpBattleType = newState;
      }
      
      public static function get PvpBattleType() : String
      {
         return _PvpBattleType;
      }
      
      public static function set pvpPlayerStatus(newState:String) : void
      {
         _pvpPlayerStatus = newState;
      }
      
      public static function get pvpPlayerStatus() : String
      {
         return _pvpPlayerStatus;
      }
      
      public static function visitFriend(charId:uint, sourceId:String) : void
      {
         if(canVisit() != true)
         {
            showInfo(Main.langLib.get(565));
            return;
         }
         if(checkGameStatus() == Timeline.BATTLE)
         {
            showInfo(Main.langLib.get(532));
            return;
         }
         if(Mission.onMission() != null)
         {
            showInfo(Main.langLib.get(532));
            return;
         }
         if(Panel.getInstance().curPanel)
         {
            Panel.getInstance().curPanel.hide();
         }
         Panel.getInstance().visitCharacterId = charId;
         Panel.getInstance().visitFacebookId = sourceId;
         if(Features.PANEL_VISIT_FRIEND_1)
         {
            Panel.getInstance().show("visit_friend");
         }
         else if(Features.PANEL_VISIT_FRIEND_2)
         {
            Panel.getInstance().show("visit_friend_2");
         }
         if(charId != Main.getMainChar().getCharacterId())
         {
            Main.achievement.updateCharStat(Main.achievementData.FRIEND_VISITED,1);
         }
      }
      
      public static function showInviteFriend() : void
      {
         switch(AppData.type)
         {
            case AppData.YM:
            case AppData.FB:
            case AppData.RR:
               callJS("showInviteDialog");
         }
      }
      
      public static function fileCheck(fileData:Array) : void
      {
         var hashData:String = null;
         var i:int = 0;
         if(fileData != null || fileData.length > 0)
         {
            if(fileData[0][0].indexOf("file://") >= 0)
            {
               return;
            }
         }
         if(Central.main.proc == null)
         {
            return;
         }
         if(Central.main.proc.clientLib == null)
         {
            return;
         }
         if(Account.getAccountSessionKey() == null)
         {
            return;
         }
         if(fileData[0][0].indexOf("/panels/") >= 0)
         {
            checkPanelFile(fileData);
         }
         var needCallServer:Boolean = false;
         for(var j:int = 0; j < fileData.length; j++)
         {
            if(fileData[0][0].indexOf("/panels/") >= 0 || fileData[0][0].indexOf("/mission/") >= 0 || fileData[0][0].indexOf("/enemies/") >= 0)
            {
               needCallServer = true;
               break;
            }
         }
         if(needCallServer)
         {
            hashData = "";
            for(i = 0; i < fileData.length; i++)
            {
               hashData = hashData + fileData[1];
            }
            hashData = Central.main.getHash(hashData);
            Central.main.showAmfLoading();
            Central.main.amfClient.service("FileChecking.checkHackActivity",[Central.main.account.getAccountSessionKey(),fileData,hashData],Central.main.getFileCheckResponse);
         }
      }
      
      private static function checkPanelFile(fileData:Array) : void
      {
         var tmp1:Array = null;
         var tmp2:Array = null;
         var panelName:String = null;
         var index:int = 0;
         var sum:int = 0;
         var tmp3:Array = null;
         if(fileData[0][0].indexOf("file://") < 0 && testBuild.indexOf(Data.BUILD_NO) < 0)
         {
            tmp1 = [];
            tmp2 = [];
            switch(Central.main.mapKey)
            {
               case 1:
                  tmp1 = Central.main.file_1;
                  break;
               case 2:
                  tmp1 = Central.main.file_2;
                  break;
               case 3:
                  tmp1 = Central.main.file_3;
                  break;
               default:
                  Main.onError("30202");
            }
            switch(Central.main.mapValue)
            {
               case 1:
                  tmp2 = Central.main.sum_1;
                  break;
               case 2:
                  tmp2 = Central.main.sum_2;
                  break;
               case 3:
                  tmp2 = Central.main.sum_3;
                  break;
               default:
                  Main.onError("30203");
            }
            panelName = String(fileData[0][0]).split("/").pop();
            index = tmp1.indexOf(panelName);
            sum = int(fileData[1]);
            if(index < 0)
            {
               Central.main.file_1.push(panelName);
               Central.main.file_2.push(panelName);
               Central.main.file_3.push(panelName);
               tmp3 = [sum];
               Central.main.sum_1.push(tmp3);
               Central.main.sum_2.push(tmp3);
               Central.main.sum_3.push(tmp3);
            }
            else if(tmp2[index].indexOf(sum) < 0)
            {
               Main.onError("30204");
            }
         }
      }
      
      private static function getFileCheckResponse(response:Object) : void
      {
         if(Central.main.validateAmfResponse(response))
         {
            Central.main.hideAmfLoading();
         }
      }
      
      public static function dataFilter(_data:Object) : Boolean
      {
         if(testBuild.indexOf(Data.BUILD_NO) >= 0)
         {
            return true;
         }
         if(_data == null)
         {
            return true;
         }
         if(_data.development == null)
         {
            return true;
         }
         if(_data.development == 0)
         {
            return true;
         }
         Main.onError("106");
         return false;
      }
      
      public static function callJS(fn:String, ... parameters) : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.call(fn,parameters);
         var wallfeedFn:Array = ["publishFeed","showFeed","feedDailyTask","showRankupFeed"];
         if(wallfeedFn.indexOf(fn) >= 0)
         {
            achievement.updateCharStat(achievementData.WALLFEED_POSTED);
         }
      }
      
      public static function addJSCallBack() : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         ExternalInterface.addCallback("getNewsfeedReward",getNewsfeedReward);
         ExternalInterface.addCallback("closeNewsfeed",closeNewsfeed);
         ExternalInterface.addCallback("requestPermissionCallback",requestPermissionCallback);
         ExternalInterface.addCallback("checkWhatPermissionCallback",checkWhatPermissionCallback);
         try
         {
            Security.allowDomain("app.ninjasaga.com");
            ExternalInterface.addCallback("domainResponse",Main.domainResponse);
         }
         catch(err:Error)
         {
         }
      }
      
      public static function requestPermissionCallback(permissionRequested:String, isGranted:Boolean) : void
      {
         if(!isGranted)
         {
            return;
         }
         getAppFBFriends(gotAppFriends,true);
      }
      
      public static function checkWhatPermissionCallback(permissionExists:Array) : void
      {
         var hasFBUserFriend:Boolean = false;
         if(permissionExists.indexOf("user_friends") >= 0)
         {
            hasFBUserFriend = true;
            if(hasFBUserFriend != Central.main.facebookPermissionUserFriends)
            {
               notifyFriendPermissionObserverList(hasFBUserFriend);
               Central.main.facebookPermissionUserFriends = hasFBUserFriend;
            }
         }
      }
      
      public static function gotAppFriends(friends:Array) : void
      {
         notifyFriendListObserverList(friends);
         Central.main.callJS("checkWhatPermissions");
      }
      
      public static function domainResponse(value:Boolean) : void
      {
         Central.main.validLogin = value;
      }
      
      public static function getNewsfeedReward(value:int) : void
      {
         Central.main.getMainChar().updateGold(value);
         Central.main.updateMenu();
         Main.amfClient.service("CharacterService.getNewsfeedReward",[Central.main.account.getAccountSessionKey(),Central.main.getMainChar().getData(DBCharacterData.ID),value],getNewsfeedRewardResponse);
      }
      
      public static function getNewsfeedRewardResponse(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Central.main.onError(String(result.error));
            return;
         }
         Central.main.proc.hideNewsfeedRewardPopup();
      }
      
      public static function closeNewsfeed() : void
      {
         Central.main.proc.hideNewsfeedRewardPopup();
      }
      
      public static function getTitle(title:String) : String
      {
         return langLib.titleTxt(title);
      }
      
      public static function initButton(btn:*, fn:Function, txt:String = null) : void
      {
         var btnTxt:String = null;
         if(btn == null)
         {
            Out.error("Main","initButton :: btn is null :: txt " + txt);
            return;
         }
         if(fn == null)
         {
            Out.error("Main","initButton :: fn is null :: txt " + txt);
            return;
         }
         btn.stop();
         btn.gotoAndStop(1);
         if(btn["clickMask"])
         {
            btn["clickMask"].buttonMode = true;
         }
         else
         {
            Out.error("Main","initButton :: clickMask is not found :: txt " + txt);
         }
         btn.addEventListener(MouseEvent.CLICK,fn);
         btn.addEventListener(MouseEvent.MOUSE_OUT,mouseOutFn);
         btn.addEventListener(MouseEvent.MOUSE_OVER,mouseOverFn);
         if(txt != null)
         {
            btnTxt = langLib.btnTxt(txt);
            if(btnTxt != null)
            {
               btn["txt"].text = btnTxt;
            }
            else
            {
               btn["txt"].text = txt;
            }
         }
      }
      
      public static function disableButton(btn:*, fn:Function, txt:String = null) : void
      {
         var btnTxt:String = null;
         if(btn == null)
         {
            Out.error("Main","disableButton :: btn is null :: txt " + txt);
            return;
         }
         if(fn == null)
         {
            Out.error("Main","disableButton :: fn is null :: txt " + txt);
            return;
         }
         btn.stop();
         btn.gotoAndStop(1);
         if(btn["clickMask"])
         {
            btn["clickMask"].buttonMode = false;
         }
         else
         {
            Out.error("Main","disableButton :: clickMask is not found :: txt " + txt);
         }
         btn.removeEventListener(MouseEvent.CLICK,fn);
         btn.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutFn);
         btn.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverFn);
         if(txt != null)
         {
            btnTxt = Central.main.langLib.btnTxt(txt);
            if(btnTxt != null)
            {
               btn["txt"].text = btnTxt;
            }
            else
            {
               btn["txt"].text = txt;
            }
         }
      }
      
      public static function mouseOutFn(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(1);
      }
      
      public static function mouseOverFn(evt:MouseEvent) : void
      {
         evt.currentTarget.gotoAndStop(2);
      }
      
      public static function calcSkillDamage(char:*, skillData:Object) : uint
      {
         var typeValue:int = 0;
         var damage:int = skillData.damage;
         var buff:Object = char.getBattleBuff();
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
         var typeBonus:Number = damage * (typeValue / coreData.SKILL_TYPE_BONUS);
         var fireBonus:int = Math.round(damage * (int(char.getData(DBCharacterData.FIRE)) * 4 / 1000));
         var combustionBonus:int = 0;
         if(buff[BattleData.EFFECT_COMBUSTION])
         {
            if(buff[BattleData.EFFECT_COMBUSTION].duration > 0)
            {
               combustionBonus = Math.round(damage * 0.3);
            }
         }
         damage = damage + (Math.round(typeBonus) + fireBonus + combustionBonus);
         damage = Formula.randomizeValue(damage);
         return damage;
      }
      
      public static function shiftBtnPos(sourceMc:MovieClip, btnArr:Array, shiftType:String, offSet:Number = 0, fixedStartPoint:Object = null) : void
      {
         var TEMP_MENU_BTN_WIDTH:int = 0;
         if(sourceMc == null)
         {
            return;
         }
         if(btnArr == null)
         {
            return;
         }
         if(btnArr.length <= 0)
         {
            return;
         }
         var i:int = 0;
         var countOffSet:int = 0;
         var startPoint:Number = 0;
         var tmpStartPoint:Number = 0;
         if(fixedStartPoint)
         {
            if(fixedStartPoint.startPoint)
            {
               startPoint = fixedStartPoint.startPoint;
            }
         }
         else
         {
            switch(shiftType)
            {
               case SHIFT_X_RIGHT:
                  startPoint = sourceMc[btnArr[0]].x;
                  break;
               case SHIFT_X_LEFT:
                  startPoint = sourceMc[btnArr[btnArr.length - 1]].x;
                  break;
               case SHIFT_Y_DOWN:
                  startPoint = sourceMc[btnArr[0]].y;
                  break;
               case SHIFT_Y_UP:
                  startPoint = sourceMc[btnArr[btnArr.length - 1]].y;
                  break;
               case SHIFT_X_RIGHT_TO_LEFT:
                  startPoint = sourceMc[btnArr[btnArr.length - 1]].x;
            }
         }
         tmpStartPoint = startPoint;
         switch(shiftType)
         {
            case SHIFT_X_RIGHT:
               for(i = 0; i < btnArr.length; i++)
               {
                  tmpStartPoint = tmpStartPoint + (sourceMc[btnArr[i]].width * i + i * offSet);
                  sourceMc[btnArr[i]].x = tmpStartPoint;
                  tmpStartPoint = startPoint;
               }
               break;
            case SHIFT_X_LEFT:
               for(i = 0; i < btnArr.length; i++)
               {
                  tmpStartPoint = tmpStartPoint - (sourceMc[btnArr[i]].width * (btnArr.length - 1 - i) - i * offSet);
                  sourceMc[btnArr[i]].x = tmpStartPoint;
                  tmpStartPoint = startPoint;
               }
               break;
            case SHIFT_Y_DOWN:
               for(i = 0; i < btnArr.length; i++)
               {
                  tmpStartPoint = tmpStartPoint + (sourceMc[btnArr[i]].height * i + i * offSet);
                  sourceMc[btnArr[i]].y = tmpStartPoint;
                  tmpStartPoint = startPoint;
               }
               break;
            case SHIFT_Y_UP:
               for(i = 0; i < btnArr.length; i++)
               {
                  tmpStartPoint = tmpStartPoint - (sourceMc[btnArr[i]].height * (btnArr.length - 1 - i) - i * offSet);
                  sourceMc[btnArr[i]].y = tmpStartPoint;
                  tmpStartPoint = startPoint;
               }
               break;
            case SHIFT_X_RIGHT_TO_LEFT:
               TEMP_MENU_BTN_WIDTH = 49;
               for(i = 0; i < btnArr.length; i++)
               {
                  tmpStartPoint = tmpStartPoint - (TEMP_MENU_BTN_WIDTH * i + i * offSet);
                  sourceMc[btnArr[btnArr.length - 1 - i]].x = tmpStartPoint;
                  tmpStartPoint = startPoint;
               }
         }
      }
      
      public static function getInstance() : MainProcess
      {
         return proc;
      }
      
      public static function itemPrototype(str:String) : String
      {
         var strArr:Array = str.split("_");
         if(strArr != null)
         {
            switch(strArr[0])
            {
               case "pet":
               case "petxp":
               case "xp":
               case "gold":
                  return strArr[1];
               case "skill":
               case "back":
               case "item":
               case "material":
               case "wpn":
               case "set":
               case "hair":
                  return strArr[0] + strArr[1];
               default:
                  return strArr[0] + strArr[1];
            }
         }
         else
         {
            Out.error("itemPrototype","parameter type not match");
            return null;
         }
      }
      
      public static function addCurrency(currencyId:String) : void
      {
         var i:* = undefined;
         var j:int = 0;
         var tmpId:String = null;
         switch(currencyId)
         {
            case "item750":
               Main.christmasCoin++;
               break;
            case "item772":
               Main.christmasCoin++;
               break;
            case "item773":
               Main.easterCoin++;
            default:
               tmpId = currencyId.replace("item","");
               for(i = 0; i < 5; i++)
               {
                  for(j = 0; j < 7; j++)
                  {
                     if(tmpId == Main.dragonBallList[i][j].id)
                     {
                        Main.dragonBallList[i][j].amount++;
                        break;
                     }
                  }
               }
         }
      }
      
      public static function reduceCurrency(currencyId:String) : void
      {
         switch(currencyId)
         {
            case "item750":
               Main.christmasCoin--;
               if(Main.christmasCoin < 0)
               {
                  Main.christmasCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
               break;
            case "item772":
               Main.christmasCoin--;
               if(Main.christmasCoin < 0)
               {
                  Main.christmasCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
               break;
            case "item773":
               Main.easterCoin--;
               if(Main.easterCoin < 0)
               {
                  Main.easterCoin = 0;
                  Out.error("reduceCurrency","christmas coin can\'t be less than zero");
               }
         }
      }
      
      public static function recruitFriendPrice(recruitLv:int) : Object
      {
         var payType:String = null;
         var recruitPrice:int = 0;
         var charLv:* = Main.getMainChar().getLevel();
         var lvDiff:* = Math.abs(recruitLv - charLv);
         if(recruitLv <= charLv)
         {
            payType = Main.PAY_GOLD;
            recruitPrice = Math.ceil(1 / (1 + lvDiff) * 5 * Math.pow(charLv,1.68363));
         }
         else
         {
            payType = Main.PAY_TOKEN;
            recruitPrice = Math.ceil(lvDiff * Math.sqrt(recruitLv) / 4);
         }
         return {
            "payType":payType,
            "recruitPrice":recruitPrice
         };
      }
      
      public static function checkHackTimerListener(evt:TimerEvent) : void
      {
         if(AntiMemoryHack.check() == false)
         {
            onError("305","");
            evt.target.stop();
            evt.target.removeEventListener(TimerEvent.TIMER,checkHackTimerListener);
         }
      }
      
      public static function playMusic(musicName:String) : void
      {
         var soundArr:Array = [];
         var music:Sound = Sound(Main.getLib(musicName));
         soundArr.push(music);
         Central.main.mixer.playMusic(soundArr);
      }
      
      public static function updateMusic() : void
      {
         if(currentMusicIndex < MUSIC_PLAY_LIST.length && currentMusicIndex >= 0)
         {
            playMusic(MUSIC_PLAY_LIST[currentMusicIndex]);
         }
      }
      
      public static function setAllSoundEffectVolume(_volume:Number) : void
      {
         var soundTransform:SoundTransform = SoundMixer.soundTransform;
         soundTransform.volume = _volume;
         SoundMixer.soundTransform = soundTransform;
      }
      
      public static function getMusicLength(_musicName:String) : Number
      {
         var music:Sound = Sound(Main.getLib(_musicName));
         return music.length;
      }
      
      public static function stopMusic() : void
      {
         Central.main.mixer.stopMusic();
      }
      
      public static function showUpgradePet(petClsName:String) : void
      {
         mapMenu.preSelectClsName = petClsName;
         mapMenu.gotoAndStop(Timeline.PET);
      }
      
      public static function confirmPlayerReadRegAccNotice() : void
      {
         Central.main.amfClient.service("CharacterDAO.AccRegTutNoticeRead",[Account.getAccountSessionKey()],new Function());
      }
      
      public static function getPetMaturity(petId:uint) : int
      {
         var pet:* = Central.main.getMainChar().getPetById(petId);
         return pet.maturity;
      }
      
      public static function logHuntingMission(isStart:Boolean, winLoss:Boolean = false) : void
      {
         var enemyDataLog:Array = null;
         var enemy:Enemy = null;
         var enemyDataStr:String = null;
         var tmpEnemyData:Object = null;
         var rand:int = 0;
         var functionName:String = null;
         var hash:String = null;
         var level:int = 0;
         var enemyId:int = 0;
         var randWinLossDigitBefore:Boolean = false;
         if(Central.battle.subType != BattleData.SUBTYPE_BOSS)
         {
            return;
         }
         var charLevel:int = Central.main.getMainChar().getData(DBCharacterData.LEVEL);
         if(charLevel < 5 || charLevel > 10)
         {
            return;
         }
         enemyDataLog = new Array();
         var battleEnemyArr:Array = Central.battle.getEnemyArr();
         for each(enemy in battleEnemyArr)
         {
            level = enemy.getData(DBCharacterData.LEVEL);
            enemyId = parseInt(String(enemy.enemyObj.id).replace("enemy",""));
            enemyDataLog.push([enemyId,level]);
            Out.debug("Main","enemyId=" + enemyId + ", level=" + level);
         }
         enemyDataStr = "";
         for each(tmpEnemyData in enemyDataLog)
         {
            enemyDataStr = enemyDataStr + tmpEnemyData[0];
            enemyDataStr = enemyDataStr + tmpEnemyData[1];
         }
         rand = int(Math.random() * (int.MAX_VALUE - 2));
         functionName = "CharacterDAO.startHunting";
         if(!isStart)
         {
            functionName = "CharacterDAO.finishHunting";
         }
         if(!isStart)
         {
            randWinLossDigitBefore = rand % 9 % 2 == 1;
            if(randWinLossDigitBefore != winLoss)
            {
               rand++;
               randWinLossDigitBefore = rand % 9 % 2 == 1;
               if(randWinLossDigitBefore != winLoss)
               {
                  rand++;
               }
            }
         }
         hash = Central.main.getHash(enemyDataStr + rand);
         Central.main.amfClient.service(functionName,[Account.getAccountSessionKey(),enemyDataLog,rand,hash],function(response:Object):*
         {
            if(Central.main.validateAmfResponse(response))
            {
               return;
            }
         });
      }
      
      public static function eneSeqLength() : int
      {
         return _enemyRobotSeq.length;
      }
      
      public static function setEnemyRobotSeq(eneSeq:String) : void
      {
         var start:int = 0;
         var i:int = 0;
         start = parseInt(eneSeq.substr(0,3));
         eneSeq = eneSeq.substr(3 + 10,eneSeq.length - (3 + 10));
         _enemyRobotSeq = [];
         for(i = start % 33; i < eneSeq.length; i++)
         {
            switch(parseInt(eneSeq.charAt(i)))
            {
               case 0:
               case 7:
                  _enemyRobotSeq.push(Number(2));
                  break;
               case 1:
               case 8:
                  _enemyRobotSeq.push(Number(1));
                  break;
               case 2:
               case 9:
                  _enemyRobotSeq.push(Number(0));
            }
         }
      }
      
      public static function getEnemyRobotSeq(round:int) : int
      {
         return _enemyRobotSeq[round % _enemyRobotSeq.length];
      }
      
      public static function getEnemyRobotSeqHash() : String
      {
         var seqStr:String = null;
         seqStr = _enemyRobotSeq.join("");
         return Central.main.getHash(seqStr + "RCGHRjWphyFOmOJGGW4B8TUt");
      }
      
      public static function clearCharSeq() : void
      {
         _charSeq = [];
      }
      
      public static function setCharSeq(charBtn:String) : void
      {
         _charSeq.push(charBtn);
      }
      
      public static function getCharSeq() : Array
      {
         return _charSeq;
      }
      
      public static function getCharSeqStr() : String
      {
         var i:int = 0;
         _charSeqStr = "";
         for(i = 0; i < _charSeq.length; i++)
         {
            _charSeqStr = _charSeqStr + String(_charSeq[i]);
         }
         return _charSeqStr;
      }
      
      public static function isDoubleXP() : int
      {
         var timeSinceExtraData:int = 0;
         var j:int = 0;
         timeSinceExtraData = getTimer() / 1000 - Central.main.timeGetExtraData;
         for(j = 0; j < Central.main.doubleXPArr.length; j++)
         {
            if(timeSinceExtraData >= Central.main.doubleXPArr[j].start && timeSinceExtraData < Central.main.doubleXPArr[j].end)
            {
               return Central.main.doubleXPArr[j].end - timeSinceExtraData;
            }
            if(timeSinceExtraData < Central.main.doubleXPArr[j].start && timeSinceExtraData < Central.main.doubleXPArr[j].end)
            {
               return timeSinceExtraData - Central.main.doubleXPArr[j].start;
            }
         }
         return 0;
      }
      
      public static function addFriendListObserver(friendListObserverObj:Object) : void
      {
         var notifyMethodName:String = null;
         if(!friendListObserverObj)
         {
            Out.error("Main::addFriendListObserver","Object null");
            return;
         }
         notifyMethodName = "notifyFriendListUpdate";
         if(!(notifyMethodName in friendListObserverObj))
         {
            Out.error("Main::addFriendListObserver","notifyMethodName not founnd in object:" + friendListObserverObj.name);
            return;
         }
         if(friendListObserverList.indexOf(friendListObserverObj) >= 0)
         {
            Out.error("Main::addFriendListObserver","Object has already been added to the observer list:" + friendListObserverObj.name);
            return;
         }
         Central.main.friendListObserverList.push(friendListObserverObj);
      }
      
      private static function notifyFriendListObserverList(_friends:Array) : void
      {
         var observerObj:Object = null;
         for each(observerObj in friendListObserverList)
         {
            observerObj.notifyFriendListUpdate(_friends);
         }
      }
      
      public static function addFriendPermissionObserver(friendPermissionObserverObj:Object) : void
      {
         var notifyMethodName:String = null;
         if(!friendPermissionObserverObj)
         {
            Out.error("Main::addFriendListObserver","Object null");
            return;
         }
         notifyMethodName = "notifyFriendPermissionUpdate";
         if(!(notifyMethodName in friendPermissionObserverObj))
         {
            Out.error("Main::addFriendListObserver","notifyMethodName not founnd in object:" + friendPermissionObserverObj.name);
            return;
         }
         if(Central.main.friendPermissionObserverList.indexOf(friendPermissionObserverObj) >= 0)
         {
            Out.error("Main::addFriendListObserver","Object has already been added to the observer list:" + friendPermissionObserverObj.name);
            return;
         }
         Central.main.friendPermissionObserverList.push(friendPermissionObserverObj);
      }
      
      private static function notifyFriendPermissionObserverList(_hasFBUserFriend:Boolean) : void
      {
         var observerObj:Object = null;
         for each(observerObj in friendPermissionObserverList)
         {
            observerObj.notifyFriendPermissionUpdate(_hasFBUserFriend);
         }
      }
   }
}

import flash.display.MovieClip;
import flash.utils.Timer;
import ninjasaga.Main;
import bitemycode.security.Obfuscated;
import flash.events.TimerEvent;
import com.utils.Out;
import ninjasaga.data.DailyLoginEventData;
import ninjasaga.data.AppData;
import ninjasaga.Central;
import ninjasaga.data.DBCharacterData;
import ninjasaga.data.RankData;
import ninjasaga.Mission;
import flash.events.MouseEvent;
import ninjasaga.data.SNSData;
import ninjasaga.data.Timeline;
import ninjasaga.Panel;
import ninjasaga.data.Data;
import bitemycode.loader.DynamicLoader;

class MainProcess
{
    
   
   private var mainMc:MovieClip;
   
   private var onGameStart:Boolean = true;
   
   public var isShowRoulette:Boolean = false;
   
   public var rouletteShown:Boolean = true;
   
   public var newMail:Boolean = false;
   
   public var hasShownPopup:Boolean = false;
   
   private var DailyLoginResponse:Object;
   
   private var isShowDailyLuckyDraw:Boolean = true;
   
   private var isShowDailyScratch:Boolean = true;
   
   private var isShowPVPTimetable:Boolean = false;
   
   private var pvpTimeList:Array;
   
   private var isShowAnni3EventPage:Boolean = true;
   
   private var isShowPromote:Boolean = true;
   
   private var isShowRequestBox:Boolean = true;
   
   private var WCInGameClaimReward:Boolean = true;
   
   private var isShowNewYearClothing2015:Boolean = true;
   
   public var fbInviteRecord:Object;
   
   public var clientLib:MovieClip;
   
   public var specialAds:Array;
   
   private var stateMachine:Timer;
   
   private var gameTick:int = 0;
   
   private var stateArr:Array;
   
   private var stateRemovalArray;
   
   public var updateClanTimer:Function;
   
   public var updateEnergyTimer:Function;
   
   private var checkHackTimer:Timer = null;
   
   function MainProcess(_mainMc:MovieClip)
   {
      pvpTimeList = [];
      stateArr = [];
      stateRemovalArray = [];
      super();
      this.mainMc = _mainMc;
      this.initConstant();
      this.initStateMachine();
   }
   
   private function initConstant() : void
   {
      Main.coreData.obfus = new Obfuscated();
      Main.coreData.obfus.ZERO_NUMBER = this.minus(59.23,59.23);
      Main.coreData.obfus.BASE_CRITICAL_CHANCE = this.multiply(0.025,2);
      Main.coreData.obfus.BASE_DODGE_CHANCE = this.multiply(0.025,2);
      Main.coreData.obfus.BASE_CRITICAL_MULTIPLIER = this.multiply(0.5,3);
      Main.coreData.obfus.DAMAGE_LIMIT = this.multiply(2500,4);
      Main.coreData.obfus.SKILL_TYPE_BONUS = this.multiply(20.001,5.001);
   }
   
   private function multiply(a:Number, b:Number) : Number
   {
      return a * b;
   }
   
   private function minus(a:Number, b:Number) : Number
   {
      return a - b;
   }
   
   private function initStateMachine() : void
   {
      this.stateMachine = new Timer(1000 / 2);
      this.stateMachine.addEventListener(TimerEvent.TIMER,this.updateStateMachine);
      this.stateMachine.start();
   }
   
   private function updateStateMachine(tmEvt:TimerEvent) : void
   {
      var i:uint = 0;
      var constructedStateArr:Array = null;
      var evt:Object = null;
      this.gameTick++;
      if(this.gameTick >= 2 * 60 * 10)
      {
         this.gameTick = 0;
      }
      constructedStateArr = [];
      for(i = 0; i < this.stateArr.length; i++)
      {
         evt = this.stateArr[i];
         if(this.gameTick % evt.tick == 0)
         {
            Out.debug(this,"stateMachine :: calling >> " + evt.refName);
            try
            {
               evt.fn();
               if(evt.once == false)
               {
                  constructedStateArr.push(evt);
               }
            }
            catch(err:Error)
            {
               Out.error(this,"updateStateMachine :: err >> " + err);
            }
         }
         else
         {
            constructedStateArr.push(evt);
         }
      }
      this.stateArr = constructedStateArr;
      if(this.gameTick % (15 * 2) == 0)
      {
         if(this.updateClanTimer != null)
         {
            this.updateClanTimer();
         }
      }
   }
   
   public function addState(fn:Function, tick:int = 0, once:Boolean = false, refName:String = null) : void
   {
      var i:uint = 0;
      var stateObj:Object = null;
      var evt:Object = null;
      Out.debug(this,"addState :: tick >> " + tick);
      if(tick != 0)
      {
         tick = tick / 1000 * 2;
         tick = tick + Math.round(this.gameTick % tick);
         Out.debug(this,"addState :: new tick >> " + tick);
      }
      stateObj = {};
      stateObj.fn = fn;
      stateObj.tick = tick;
      stateObj.once = once;
      stateObj.refName = refName;
      for(i = 0; i < this.stateArr.length; i++)
      {
         evt = this.stateArr[i];
         if(fn == this.stateArr[i].fn)
         {
            this.stateArr[i] = stateObj;
            return;
         }
      }
      this.stateArr.push(stateObj);
   }
   
   public function removeState(fn:Function) : void
   {
      var i:uint = 0;
      var newStateArr:Array = null;
      var evt:Object = null;
      newStateArr = [];
      for(i = 0; i < this.stateArr.length; i++)
      {
         evt = this.stateArr[i];
         Out.debug(this,"removeState :: prototype >> " + fn.prototype);
         if(fn == this.stateArr[i].fn)
         {
            Out.debug(this,"removeState :: fn >> " + fn + " found and removed.");
         }
         else
         {
            newStateArr.push(this.stateArr[i]);
         }
      }
      this.stateArr = newStateArr;
   }
   
   public function encrypt(str:String) : String
   {
      return this.clientLib.encrypt(str);
   }
   
   public function streamStartEvents() : void
   {
      var giftBagObj:Object = null;
      var totalSenconds:int = 0;
      var caledNum:int = 0;
      var rouletteMc:MovieClip = null;
      var dailyLoginEvent:DailyLoginEventData = null;
      if(!this.onGameStart)
      {
         return;
      }
      if(this.hasShownPopup)
      {
         return;
      }
      if(Main.exitFromTutorial)
      {
         return;
      }
      if(AppData.FB || AppData.MP || AppData.OK)
      {
         Main.isShowDailyLogin = false;
      }
      if(checkHackTimer == null)
      {
         checkHackTimer = new Timer(3000);
         checkHackTimer.addEventListener(TimerEvent.TIMER,Main.checkHackTimerListener);
         checkHackTimer.start();
      }
      if(Main.Features.FEATURE_DAILY_SCRATCH && this.isShowDailyScratch && Main.dailyRoulette_remainTime > 0 && Main.getMainChar().getLevel() >= 8 && Main.getMainChar().getLevel() <= 20)
      {
         Central.main.loadPopupPanel("daily_login_3","ninjasaga.linkage.daily_login3");
         this.isShowDailyScratch = false;
      }
      else if(Main.onceGiftLeft > 0)
      {
         Main.loadPopupPanel("Popup_special_reward_100token","ninjasaga.linkage.xmas2014SpecialReward");
      }
      else if(Main.claimNewYear2015Cloth)
      {
         Main.claimNewYear2015Cloth = false;
         Main.loadPopupPanel("Popup_NewYear_2015","ninjasaga.linkage.newYearClothing2015");
      }
      else if(Main.GiftBagEvent.length > 0 && Main.getMainChar().getLevel() >= 5)
      {
         giftBagObj = Main.GiftBagEvent.shift();
         Main.showEventGiftBag(giftBagObj);
      }
      else if(Main.showIngameNotice)
      {
         Main.showIngameNotice = false;
         Main.loadPopupPanel("Popup_IngameNotice_Menu_2014","ninjasaga.linkage.IngameNoticeMenu2014");
      }
      else if(Central.main.extraData.trial_emblem_expire_time && Main.isShowTrial)
      {
         totalSenconds = int(Central.main.extraData.trial_emblem_expire_time);
         caledNum = Math.round(totalSenconds / (24 * 60 * 60));
         Main.isShowTrial = false;
         if(caledNum <= 7)
         {
            Central.main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel");
         }
      }
      else if(Central.main.extraData.claim_fowte == 1 && Main.isShowTrial)
      {
         Main.isShowTrial = false;
         Central.main.loadPopupPanel("popup_trial_emblem","ninjasaga.linkage.TrialEmblemPanel");
      }
      else if(Central.main.extraData.bank_system_tutorial)
      {
         Central.main.extraData.bank_system_tutorial = false;
         Main.loadPopupPanel("Popup_tutorialbank","ninjasaga.linkage.TutorialBank");
      }
      else if(Central.main.extraData.iphone_2015 > 0)
      {
         Central.main.extraData.iphone_2015 = 0;
         Main.loadPopupPanel("popup_luckydraw_iphone_2015","ninjasaga.linkage.LuckydrawIphone2015PS4");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && Main.Features.FEATURE_DAILY_LOGIN && Main.isShowDailyLogin && Main.dailyLogin)
      {
         Main.isShowDailyLogin = false;
         Main.loadPopupPanel("daily_login","ninjasaga.linkage.Roulette2");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_EVENT_LUCKY_DRAW && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && this.isShowRoulette && this.rouletteShown && Main.Features.FEATURE_ROULETTE)
      {
         this.rouletteShown = false;
         rouletteMc = this.mainMc.getAsset("ninjasaga.linkage.Roulette");
         mainMc["rouletteHolder"].addChild(rouletteMc);
         rouletteMc.show();
      }
      else if(Main.getMainChar().getLevel() < Main.DISPLAY_LEVEL_LIMIT_NORMAL || Mission.getDailyTask(false))
      {
         Mission.getDailyTask(true);
      }
      else if(this.specialAds)
      {
         Main.popup.showAds(this.specialAds);
         this.specialAds = null;
      }
      else if(Main.getMainChar().invite_accepted > 0)
      {
         Main.proc.showInviteFrdEventPopup();
      }
      else if(Main.getMainChar().veteran_return_fk_accepted > 0)
      {
         Main.proc.showVeteranReturnEventPopup();
      }
      else if(Main.showLuckyPuzzleStatus == 2 && Main.showFanPage)
      {
         Main.showFanPage = false;
         Main.showPopup(Central.main.langLib.get(1776)[0],Central.main.langLib.get(1776)[1],this.callback1,this.callback2);
      }
      else if(Main.ItemExpiried && Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN)
      {
         Main.loadPopupPanel("popup_expired_item","ninjasaga.linkage.ExpiryItemPopupPanel");
      }
      else if(Main.getMainChar().getLevel() >= Main.DISPLAY_LEVEL_LIMIT_NORMAL && Central.main.getMainChar().getData(DBCharacterData.RANK) > RankData.GENIN && Main.DailyLoginEvent && Main.DailyLoginEventReward.length > 0 && Main.isDisplayDailyLogin && Main.getMainChar().getLevel() >= 3)
      {
         Main.isDisplayDailyLogin = false;
         dailyLoginEvent = new DailyLoginEventData();
         Main.showEventDailyLoginGift(dailyLoginEvent.dailyLoginLocation,dailyLoginEvent);
      }
      else if(Central.main.accRegTutStatus == Central.main.ACC_REG_TUT_STATUS_NONE && Central.main.accRegActiveStatus == Central.main.ACC_REG_ACTIVE_STATUS_NOT_REGISTERED && Central.main.isDisplayRegTut && Central.main.getMainChar().getData(DBCharacterData.RANK) >= 2)
      {
         Main.isDisplayRegTut = false;
         Main.loadPopupPanel("Popup_Password_2014","ninjasaga.linkage.AccRegNotice");
      }
      else if(Central.main.extraData.amazing_draw_2014_redraw_ask && Central.main.extraData.amazing_draw_2014_redraw_ask != 0)
      {
         Central.main.showConfirmation(Central.main.langLib.get(1880),this.redTicketYes,this.redTicketNo);
      }
      else if(Central.main.extraData.emblem_type_upgrade_display)
      {
         Central.main.extraData.emblem_type_upgrade_display = !Central.main.extraData.emblem_type_upgrade_display;
         Central.main.loadPopupPanel("popup_newemblem","ninjasaga.linkage.EmblemClaimChange");
      }
      else
      {
         this.onGameStart = false;
         this.hasShownPopup = true;
      }
   }
   
   private function redTicketYes() : void
   {
      var iWantIt:Boolean = false;
      iWantIt = true;
      Central.main.showInfo(Central.main.langLib.get(1833)[10]);
      Central.main.amfClient.service("SmallEvent.replyAmazingDraw2014",[Central.main.account.getAccountSessionKey(),iWantIt],function(response:Object):*
      {
         if(Central.main.validateAmfResponse(response))
         {
            return;
         }
      });
   }
   
   private function redTicketNo() : void
   {
      var iDontWantIt:Boolean = false;
      iDontWantIt = false;
      Central.main.amfClient.service("SmallEvent.replyAmazingDraw2014",[Central.main.account.getAccountSessionKey(),iDontWantIt],function(response:Object):*
      {
         if(Central.main.validateAmfResponse(response))
         {
            return;
         }
      });
   }
   
   public function callback1(evt:MouseEvent = null) : void
   {
      var fanPageUrl:String = null;
      fanPageUrl = "";
      switch(AppData.lang)
      {
         case AppData.ZH:
            fanPageUrl = "http://www.ninjasaga.com/event_lucky_draw/?lang=zh";
            break;
         default:
            fanPageUrl = "http://www.ninjasaga.com/event_lucky_draw/?lang=en";
      }
      Main.gotoURL(fanPageUrl,"_blank");
   }
   
   public function callback2(evt:MouseEvent = null) : void
   {
      Central.sns.publishFeedById(SNSData.FEED_24,"","","",true);
   }
   
   public function showPaymentStatus(evt:MouseEvent = null) : void
   {
      var attentionMc:MovieClip = null;
      attentionMc = this.mainMc.getAsset("ninjasaga.linkage.PaymentStatus");
      mainMc["attentionHolder"].addChild(attentionMc);
      attentionMc.show();
   }
   
   public function showRoulette(evt:MouseEvent) : void
   {
      var rouletteMc:MovieClip = null;
      rouletteMc = this.mainMc.getAsset("ninjasaga.linkage.Roulette");
      mainMc["rouletteHolder"].addChild(rouletteMc);
      rouletteMc.show();
   }
   
   public function dailyRouletteRotation(_mc:MovieClip) : void
   {
      if(Main.spinChance <= 0)
      {
         _mc.gotoAndStop(1);
      }
   }
   
   public function displayRouletteButton() : void
   {
      if(Main.checkGameStatus() == Timeline.MAP && Main.showDailyRoulette > 0 && Main.spinChance > 0)
      {
         Main.mapMenu["dailyRouletteBtn"].visible = true;
         Main.mapMenu["dailyRouletteBtn"].mouseEnabled = true;
      }
      else
      {
         Main.mapMenu["dailyRouletteBtn"].visible = false;
         Main.mapMenu["dailyRouletteBtn"].mouseEnabled = false;
      }
   }
   
   public function showInviteReward(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Central.main.tracking.trackBuildingSelect("InviteReward");
         Panel.getInstance().show("invitFrdPanel");
      }
   }
   
   public function showSpecialReward(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         this.mainMc["specialRewardMc"].show();
      }
   }
   
   public function showSenninExam(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("Panel_lv80exam_battle");
      }
   }
   
   public function showExam(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("special_exam");
      }
   }
   
   public function showjouninExamPage(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("jouninPanel_exam");
      }
   }
   
   public function showchuninExamPage(evt:MouseEvent = null) : void
   {
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Panel.getInstance().show("chuninPanel_exam");
      }
   }
   
   public function showInviteFrdEventPopup(evt:MouseEvent = null) : void
   {
      var invite_accept:int = 0;
      invite_accept = Main.getMainChar().invite_accepted;
      Main.getMainChar().invite_accepted = 0;
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Main.popup.showInviteFrdDailyLogin(invite_accept);
      }
   }
   
   public function showVeteranReturnEventPopup(evt:MouseEvent = null) : void
   {
      var veteran_return_fk_accepted:int = 0;
      veteran_return_fk_accepted = Main.getMainChar().veteran_return_fk_accepted;
      Main.getMainChar().veteran_return_fk_accepted = 0;
      if(Main.checkGameStatus() == Timeline.MAP)
      {
         Main.popup.showVeteranReturnDailyLogin(veteran_return_fk_accepted);
      }
   }
   
   public function showInviteFriendPopup(evt:MouseEvent = null) : void
   {
      Main.popup.showInviteFriendPopup();
   }
   
   public function showNewsfeedRewardPopup(evt:MouseEvent = null) : void
   {
      Main.popup.showNewsfeedRewardPopup();
   }
   
   public function hideNewsfeedRewardPopup(evt:MouseEvent = null) : void
   {
      Main.popup.hideNewsfeedRewardPopup();
   }
   
   public function showInviteFriendReminderPopup(evt:MouseEvent = null) : void
   {
      Main.popup.showInviteFriendReminderPopup();
   }
   
   public function hideInviteFriendReminderPopup(evt:MouseEvent = null) : void
   {
      Main.popup.hideInviteFriendReminderPopup();
   }
   
   public function loadIcon(swfName:String, holder:MovieClip, cls:String = null, cbfn:Function = null) : void
   {
      var path:String = null;
      path = Data.genSwfFilePath("icons",swfName);
      DynamicLoader.load(path,holder,cls,cbfn);
   }
   
   public function loadAd(swfName:String, holder:MovieClip, cls:String = null, cbfn:Function = null) : void
   {
      var path:String = null;
      path = Data.genSwfFilePath("ads",swfName + "_" + AppData.EN);
      DynamicLoader.load(path,holder,cls,cbfn,true);
   }
}
