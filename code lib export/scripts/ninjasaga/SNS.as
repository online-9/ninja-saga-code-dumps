package ninjasaga
{
   import flash.display.MovieClip;
   import flash.net.LocalConnection;
   import de.polygonal.ds.HashMap;
   import com.utils.Out;
   import com.utils.Delegate;
   import ninjasaga.data.AppData;
   import ninjasaga.data.SNSData;
   import ninjasaga.data.ButtonData;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.SkillData;
   import ninjasaga.data.Data;
   import flash.events.MouseEvent;
   import bitemycode.facebook.FBUser;
   import com.utils.NumberUtil;
   
   public final class SNS
   {
      
      public static var fbConnector:MovieClip;
      
      public static var okConnector:MovieClip;
      
      public static var mpConnector:MovieClip;
      
      public static var challengeFriendName:String;
      
      private static var _isPublish:Boolean = false;
      
      private static var _cb:Function;
      
      private static var fbjsConnection:LocalConnection = new LocalConnection();
      
      public static var fbFeedGold:int = 0;
      
      public static var fbFeedIcon:int = 0;
      
      private static var savedFeedId:uint = 0;
      
      public static var friendsData:Array;
      
      public static var friendList:Array;
      
      public static var friendListHash:HashMap;
      
      public static var friendListRetry:int = 0;
      
      private static var getAppFriendsCallback:Function;
      
      public static var FB_GRAPH_API:String = "https://graph.facebook.com/";
      
      private static var instance:ninjasaga.SNS;
       
      
      private var connector:MovieClip;
      
      public function SNS(_key:InstanceBlocker)
      {
         super();
         if(_key == null)
         {
            throw new Error("Error: [SNS] Instantiation failed: Use SNS.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.SNS
      {
         if(instance == null)
         {
            instance = new ninjasaga.SNS(new InstanceBlocker());
         }
         return instance;
      }
      
      public static function get isPublish() : Boolean
      {
         if(_isPublish)
         {
            _isPublish = false;
            return true;
         }
         return false;
      }
      
      public static function set isPublish(b:Boolean) : void
      {
         _isPublish = b;
      }
      
      public static function replaceMsg(msg:String, p1:String = "", p2:String = "", p3:String = "") : String
      {
         msg = String(msg).replace("[p1]",p1).replace("[p2]",p2).replace("[p3]",p3);
         return msg;
      }
      
      public static function publishFeedById(fid:String, p1:String = "", p2:String = "", p3:String = "", popDirect:Boolean = false, cb:Function = null) : void
      {
         var title:String = null;
         var promptMsg:String = null;
         var icon:String = null;
         var btnTxt:String = null;
         Out.debug("SNS","publishFeedById :: " + fid + " :: " + p1 + " :: " + p2 + " :: " + p3);
         var wallfeedObj:Object = Central.main.WALLFEED_DATA.find(fid);
         if(wallfeedObj == null)
         {
            Out.error("SNS","WALLFEED NOT FOUND IN DATA LIBRARIES!");
            return;
         }
         _cb = cb;
         var type:String = String(wallfeedObj.type);
         switch(AppData.type)
         {
            case AppData.FB:
               if(popDirect)
               {
                  confirmPublishFeedById(type,p1,p2,p3);
               }
               else
               {
                  title = "";
                  promptMsg = "";
                  icon = "";
                  btnTxt = "";
                  title = replaceMsg(String(wallfeedObj.title),p1,p2,p3);
                  promptMsg = replaceMsg(String(wallfeedObj.content),p1,p2,p3);
                  icon = String(wallfeedObj.image);
                  btnTxt = replaceMsg(String(wallfeedObj.button),p1,p2,p3);
                  Main.showShareBoxNew(title,promptMsg,icon,btnTxt,Delegate.create(null,confirmPublishFeedById,type,p1,p2,p3),rejectPublishFeed);
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            case AppData.YM:
               Main.callJS("publishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            default:
               publishCallback();
         }
      }
      
      public static function publishFeed(type:String, p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         var promptMsg:String = null;
         var title:String = null;
         var icon:String = null;
         var btnTxt:String = null;
         Out.debug("SNS","publishFeed :: " + type + " :: " + p1 + " :: " + p2 + " :: " + p3);
         _cb = cb;
         switch(AppData.type)
         {
            case AppData.FB:
               switch(type)
               {
                  case SNSData.FEED_NEW_CHAR:
                     promptMsg = Central.main.langLib.get(388);
                     fbFeedGold = 300;
                     fbFeedIcon = 5;
                     generatedFeed(340);
                     break;
                  case SNSData.FEED_GENIN:
                     promptMsg = Central.main.langLib.get(389);
                     fbFeedGold = 500;
                     fbFeedIcon = 14;
                     generatedFeed(330);
                     break;
                  case SNSData.FEED_SPECIAL_MISSION:
                     generatedFeed(220);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_CHALLENGE_WON:
                     promptMsg = String(Central.main.langLib.get(391)).replace("[valp1]",p1);
                     fbFeedIcon = 11;
                     generatedFeed(210);
                     break;
                  case SNSData.FEED_CHARACTER_CUSTOMIZED:
                     promptMsg = Central.main.langLib.get(392);
                     fbFeedIcon = 14;
                     generatedFeed(310);
                     break;
                  case SNSData.FEED_SKILL:
                     if(p2 == "trainfromother" && p2 != null && p2 != "")
                     {
                        promptMsg = String(Central.main.langLib.get(592)).replace("[valp1]",p1);
                     }
                     else
                     {
                        promptMsg = String(Central.main.langLib.get(393)).replace("[valp1]",p1);
                     }
                     fbFeedIcon = 10;
                     generatedFeed(230);
                     break;
                  case SNSData.FEED_CLOTH_SET:
                     promptMsg = String(Central.main.langLib.get(394)).replace("[valp1]",p1);
                     fbFeedIcon = 1;
                     generatedFeed(350);
                     break;
                  case SNSData.FEED_WEAPON:
                     promptMsg = String(Central.main.langLib.get(395)).replace("[valp1]",p1);
                     fbFeedIcon = 4;
                     generatedFeed(370);
                     break;
                  case SNSData.FEED_PET:
                     promptMsg = String(Central.main.langLib.get(396)).replace("[valp1]",p1);
                     fbFeedIcon = 3;
                     generatedFeed(360);
                     break;
                  case SNSData.FEED_FIRST_NINJUTSU:
                     promptMsg = String(Central.main.langLib.get(393)).replace("[valp1]",p3);
                     fbFeedGold = 400;
                     fbFeedIcon = 10;
                     generatedFeed(320);
                     break;
                  case SNSData.FEED_ROULETTE:
                     if(int(p1) == 1)
                     {
                        promptMsg = String(Central.main.langLib.get(481)).replace("[token]",p2);
                        fbFeedIcon = 13;
                        generatedFeed(280);
                     }
                     if(int(p1) == 2)
                     {
                        promptMsg = String(Central.main.langLib.get(480)).replace("[gold]",p2);
                        promptMsg = promptMsg.replace("[gold]",p2);
                        fbFeedIcon = 12;
                        generatedFeed(240);
                     }
                     if(int(p1) == 3)
                     {
                        promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_ROULETTE).xpconfirmmsg;
                        promptMsg = promptMsg.replace("[amount]",p2);
                        promptMsg = promptMsg.replace("[amount]",p2);
                        fbFeedIcon = 22;
                        generatedFeed(1050);
                     }
                     break;
                  case SNSData.FEED_BOSS_DEFEATED:
                     promptMsg = Central.main.langLib.get(491);
                     generatedFeed(270);
                     break;
                  case SNSData.FEED_WEAPON_UPGRADE:
                     promptMsg = Central.main.langLib.get(492);
                     generatedFeed(290);
                     break;
                  case SNSData.FEED_GIFT_SEND:
                     generatedFeed(380);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_GIFT_RECEIVE:
                     promptMsg = String(Central.main.langLib.get(558)).replace("[valreward]",p2);
                     generatedFeed(390);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_1:
                     generatedFeed(400);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_2:
                     generatedFeed(410);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_3:
                     generatedFeed(420);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_4:
                     generatedFeed(430);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_JOUNIN_EXAM_PART_5:
                     generatedFeed(440);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_MISSION_PHOTO_HUNT:
                     generatedFeed(890);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_MISSION_MEMORY_GAME:
                     generatedFeed(900);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_MISSION_SPEED:
                     generatedFeed(910);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_MISSION_TREASURE_BOX:
                     generatedFeed(920);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_DUMMY_BOSS:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_DUMMY_BOSS).confirmmsg;
                     fbFeedIcon = 21;
                     generatedFeed(930);
                     break;
                  case SNSData.FEED_CLAIM_PREMIUM_SET:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_CLAIM_PREMIUM_SET).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(940);
                     break;
                  case SNSData.FEED_CLAIM_DUMMY_PET:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_CLAIM_DUMMY_PET).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(950);
                     break;
                  case SNSData.FEED_BADGE_CLOTH:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_CLOTH).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(960);
                     break;
                  case SNSData.FEED_BADGE_WEAPON:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_WEAPON).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(970);
                     break;
                  case SNSData.FEED_BADGE_BACK_ITEM:
                     promptMsg = Central.main.langLib.FeedDataText(SNSData.FEED_BADGE_BACK_ITEM).confirmmsg;
                     fbFeedIcon = 19;
                     generatedFeed(980);
                     break;
                  case SNSData.FEED_LUCKYDRAW_EMBLEM:
                     fbFeedIcon = 18;
                     generatedFeed(990);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_LUCKYDRAW_TOKENS:
                     fbFeedIcon = 18;
                     generatedFeed(1000);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_LUCKYDRAW_PET:
                     fbFeedIcon = 18;
                     generatedFeed(1010);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_LUCKYDRAW_TOKENS2:
                     generatedFeed(1020);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_LUCKYDRAW_GOLD:
                     fbFeedIcon = 18;
                     generatedFeed(1030);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_LUCKYDRAW_MAGATAMA:
                     fbFeedIcon = 18;
                     generatedFeed(1040);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_ACHIEVEMENT_GAIN:
                     title = String(Central.main.langLib.get(1086)).replace("[achievement_name]",p2);
                     promptMsg = String(Central.main.langLib.get(1087)).replace("[achievement_desc]",p3);
                     icon = p1;
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SJ_NORMAL:
                     title = String(Central.main.langLib.get(1440)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     promptMsg = String(Central.main.langLib.get(1442)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     icon = "wf_77";
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SJ_TENSAI:
                     title = String(Central.main.langLib.get(1441)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     promptMsg = String(Central.main.langLib.get(1443)).replace("[playername]",Central.main.getMainChar().getCharacterName());
                     icon = "wf_78";
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_SPECIAL_JOUNIN_EXAM:
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FORTUNE_CARD:
                     title = String(Central.main.langLib.get(1617)[18]);
                     promptMsg = String(Central.main.langLib.get(1617)[19]);
                     icon = "wf_85";
                     btnTxt = ButtonData.SHARE;
               }
               if(promptMsg)
               {
                  if(type == SNSData.FEED_SKILL && p2 == "trainfromother" && p2 != null && p2 != "")
                  {
                     Main.showShareBox(promptMsg,Delegate.create(null,confirmPublishFeed,type,p1,p2,p3),rejectPublishFeed2);
                  }
                  else if(type == SNSData.FEED_ACHIEVEMENT_GAIN || type == SNSData.FEED_SJ_TENSAI || type == SNSData.FEED_SJ_NORMAL)
                  {
                     Main.showShareBoxNew(title,promptMsg,icon,btnTxt,Delegate.create(null,confirmPublishFeed,type,p1,p2,p3),rejectPublishFeed);
                  }
                  else if(type == SNSData.FEED_FORTUNE_CARD)
                  {
                     Main.showShareBoxNew(title,promptMsg,icon,btnTxt,Delegate.create(null,confirmPublishFeed,type,p1,p2,p3),rejectPublishFeed);
                  }
                  else
                  {
                     Main.showShareBox(promptMsg,Delegate.create(null,confirmPublishFeed,type,p1,p2,p3),rejectPublishFeed);
                  }
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            case AppData.YM:
               Out.debug("SNS","YM :: publishFeed :: type >> " + type);
               Main.callJS("publishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            case AppData.RR:
               Out.debug("SNS","YM :: publishFeed :: type >> " + type);
               Central.main.proc.showNewsfeedRewardPopup();
               Main.callJS("publishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            default:
               publishCallback();
         }
      }
      
      public static function publishShareFeed(type:String, p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         var promptMsg:String = null;
         var title:String = null;
         var icon:String = null;
         var btnTxt:String = null;
         Out.debug("SNS","publishShareFeed :: " + type + " :: " + p1 + " :: " + p2 + " :: " + p3);
         _cb = cb;
         switch(AppData.type)
         {
            case AppData.FB:
               switch(type)
               {
                  case SNSData.FEED_FR_FIRST_SP:
                     title = Central.main.langLib.get(698);
                     promptMsg = Central.main.langLib.get(699);
                     icon = "wf_3";
                     btnTxt = ButtonData.SHAREXP;
                     generatedFeed(1050);
                     break;
                  case SNSData.FEED_FR_SP_XP:
                     title = Central.main.langLib.get(700);
                     promptMsg = String(Central.main.langLib.get(701)).replace("[value]",p2);
                     icon = "wf_4";
                     btnTxt = ButtonData.SHAREXP;
                     generatedFeed(1060);
                     break;
                  case SNSData.FEED_FR_SP_GOLD:
                     title = Central.main.langLib.get(702);
                     promptMsg = String(Central.main.langLib.get(703)).replace("[value]",p2);
                     icon = "wf_1";
                     btnTxt = ButtonData.SHAREGOLD;
                     generatedFeed(1070);
                     break;
                  case SNSData.FEED_FR_SP_TOKEN:
                     title = Central.main.langLib.get(704);
                     promptMsg = String(Central.main.langLib.get(705)).replace("[value]",p2);
                     icon = "wf_2";
                     btnTxt = ButtonData.SHARETOKEN;
                     generatedFeed(1080);
                     break;
                  case SNSData.FEED_FR_SP_CLOTHING:
                     title = Central.main.langLib.get(706);
                     promptMsg = Central.main.langLib.get(707);
                     icon = "wf_20";
                     btnTxt = ButtonData.SHARECLOTHING;
                     generatedFeed(1090);
                     break;
                  case SNSData.FEED_FR_SP_WEAPON:
                     title = Central.main.langLib.get(708);
                     promptMsg = Central.main.langLib.get(709);
                     icon = "wf_12";
                     btnTxt = ButtonData.SHAREWEAPON;
                     generatedFeed(1100);
                     break;
                  case SNSData.FEED_FR_SP_BACKITEM:
                     title = Central.main.langLib.get(710);
                     promptMsg = Central.main.langLib.get(711);
                     icon = "wf_9";
                     btnTxt = ButtonData.SHAREBACK;
                     generatedFeed(1110);
                     break;
                  case SNSData.FEED_FR_DT_XP:
                     generatedFeed(1120);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_DT_GOLD:
                     generatedFeed(1130);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_DT_TOKEN:
                     generatedFeed(1140);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_DT_CLOTHING:
                     generatedFeed(1150);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_DT_WEAPON:
                     generatedFeed(1160);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_DT_BACKITEM:
                     generatedFeed(1170);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_XP:
                     title = Central.main.langLib.get(724);
                     promptMsg = String(Central.main.langLib.get(725)).replace("[value]",p2);
                     icon = "wf_14";
                     btnTxt = ButtonData.SHAREXP;
                     generatedFeed(1180);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_GOLD:
                     title = Central.main.langLib.get(726);
                     promptMsg = String(Central.main.langLib.get(727)).replace("[value]",p2);
                     icon = "wf_1";
                     btnTxt = ButtonData.SHAREGOLD;
                     generatedFeed(1190);
                     break;
                  case SNSData.FEED_FR_LUCKY_DRAW_TOKEN:
                     title = Central.main.langLib.get(728);
                     promptMsg = String(Central.main.langLib.get(729)).replace("[value]",p2);
                     icon = "wf_2";
                     btnTxt = ButtonData.SHARETOKEN;
                     generatedFeed(1200);
                     break;
                  case SNSData.FEED_FR_DISCOVER_BLOODLINE:
                     generatedFeed(1210);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_FR_UPGRADE_BLOODLINE:
                     generatedFeed(1220);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_SEND_DAILY_GIFT:
                     generatedFeed(1310);
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_THANKSGIVING_BALLOON:
                     title = Central.main.langLib.titleTxt(TitleData.CLAIM_BALLOON);
                     promptMsg = Central.main.langLib.get(896);
                     icon = "wf_28";
                     btnTxt = ButtonData.SHARE;
                     generatedFeed(1320);
                     break;
                  case SNSData.FEED_TURKEY_PET:
                     title = Central.main.langLib.titleTxt(TitleData.CLAIM_TURKEY);
                     promptMsg = Central.main.langLib.get(897);
                     icon = "wf_29";
                     btnTxt = ButtonData.SHARE;
                     generatedFeed(1330);
                     break;
                  case SNSData.FEED_XMAS_POSTWALL:
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_XMAS_SET_CLAIM:
                     icon = "wf_92";
                     title = Central.main.langLib.get(1621)[61];
                     promptMsg = String(Central.main.langLib.get(1621)[62]).replace("[reward]",p2);
                     btnTxt = ButtonData.SHARE;
                     break;
                  case "newyearcloth":
                  case "xmasluckydraw":
                  case "dailyscratch":
                     title = p1;
                     promptMsg = p2;
                     icon = p3;
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_NEW_YEAR_SKILL:
                     icon = "wf_94";
                     title = Central.main.langLib.get(1628)[8];
                     promptMsg = String(Central.main.langLib.get(1628)[11]);
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_VDAY_COLLECT_MAILER:
                  case SNSData.FEED_VDAY_COLLECT_STAINEDPAPER:
                     confirmPublishFeed(type,p1,p2,p3);
                     break;
                  case SNSData.FEED_VDAY_COLLECT_SET_CLAIM:
                     icon = "wf_102";
                     title = p1;
                     promptMsg = String(p2).replace("[item_name]",p3);
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_VDAY_COLLECT_SET_CLAIM_ALL:
                     icon = "wf_101";
                     title = p1;
                     promptMsg = p2;
                     btnTxt = ButtonData.SHARE;
                     break;
                  case SNSData.FEED_HUNTING_BOSS_MATERIAL:
                  case SNSData.FEED_EASTEREVENT2012:
                  case SNSData.FEED_HOLLOWEEN2012:
                  case SNSData.FEED_HEARTOFKRI:
                  case SNSData.FEED_DRAGONBALL_EASTEREVENT2014:
                     confirmPublishFeed(type,p1,p2,p3);
               }
               if(promptMsg)
               {
                  Central.main.showShareBoxNew(title,promptMsg,icon,btnTxt,Delegate.create(null,confirmPublishFeed,type,p1,p2,p3),rejectPublishFeed);
               }
               break;
            case AppData.MP:
               Main.callJS("publishActivity",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            case AppData.RR:
               Out.debug("SNS","YM :: publishShareFeed->publishFeed :: type >> " + type);
               Main.callJS("publishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
            default:
               publishCallback();
         }
      }
      
      public static function sendRequestNotify(p1:String = "", p2:String = "", p3:String = "", p4:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","sendRequestNotify :: requestListShowDialog :: " + p1 + " :: " + p2 + " :: " + p3 + " :: " + p4);
         Main.callJS("requestListShowDialog",p1,p2,p3,p4);
      }
      
      public static function deleteRequestNotify(p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","deleteRequestNotify :: requestShowDialog :: " + p1 + " :: " + p2 + " :: " + p3);
         Main.callJS("deleteRequest",p1);
      }
      
      public static function deleteRequestNotifyArr(p1:Array = null, p2:String = "", p3:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","deleteRequestNotifyArr :: deleteRequestByRequestId :: " + p1 + " :: " + p2 + " :: " + p3);
         if(p1 == null)
         {
            p1 = new Array();
         }
         Main.callJS("deleteRequestByRequestId",p1);
      }
      
      public static function confirmRequestNotify(p1:String = "", p2:String = "", p3:String = "", p4:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","confirmRequestNotify :: requestShowDialog :: " + p1 + " :: " + p2 + " :: " + p3 + " :: " + p4);
         Main.callJS("requestShowDialog",p1,p2,p3,p4);
      }
      
      public static function sendRequestNotification(p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","sendRequest :: " + p1 + " :: " + p2 + " :: " + p3);
         Main.callJS("sendRequest",p1,p2,p3);
      }
      
      public static function deleteRequestNotification(p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","deleteRequest :: " + p1 + " :: " + p2 + " :: " + p3);
         Main.callJS("deleteRequest",p1);
      }
      
      public static function confirmRequestNotification(p1:String = "", p2:String = "", p3:String = "", cb:Function = null) : void
      {
         Out.debug("SNS","confirmRequest :: " + p1 + " :: " + p2 + " :: " + p3);
         Main.callJS("confirmRequest",p1,p2,p3);
      }
      
      private static function confirmPublishFeedById(type:String, p1:String, p2:String, p3:String) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               Out.debug("SNS","confirmPublishFeedById");
               Main.callJS("newPublishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
         }
      }
      
      private static function confirmPublishFeed(type:String, p1:String, p2:String, p3:String) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
            case AppData.RR:
               Main.callJS("publishFeed",type,Main.getMainChar().getCharacterName(),p1,p2,p3);
               publishCallback();
               break;
            case AppData.MP:
         }
      }
      
      private static function rejectPublishFeed() : void
      {
         fbFeedGold = 0;
         publishCallback();
      }
      
      private static function rejectPublishFeed2() : void
      {
         fbFeedGold = 0;
         Central.main.showOk(Central.main.langLib.get(645),new Function());
      }
      
      public static function publishLevelupFeed() : void
      {
         var promptMsg:String = null;
         switch(AppData.type)
         {
            case AppData.FB:
               promptMsg = String(Central.main.langLib.get(398)).replace("[vallevel]",Main.getMainChar().getLevel());
               Main.showShareBox(promptMsg,confirmPublishLevelup,rejectPublishFeed);
               fbFeedIcon = 7;
               generatedFeed(10);
               break;
            case AppData.MP:
               confirmPublishLevelup();
               break;
            case AppData.OK:
               promptMsg = String(Central.main.langLib.get(398)).replace("[vallevel]",Main.getMainChar().getLevel());
               Main.showConfirmation(promptMsg,confirmPublishLevelup,new Function());
               break;
            case AppData.RR:
               confirmPublishLevelup();
         }
      }
      
      private static function confirmPublishLevelup() : void
      {
         var desc:String = null;
         var gender:String = Main.getMainChar().getGender() == 0?"male":"female";
         var level:String = String(Main.getMainChar().getLevel());
         var fire:Boolean = false;
         var water:Boolean = false;
         var lightning:Boolean = false;
         var wind:Boolean = false;
         var earth:Boolean = false;
         var taijutsu:Boolean = false;
         var genjutsu:Boolean = false;
         var skillTypes:HashMap = Main.getMainChar().getSkillTypes();
         if(skillTypes.containsKey(SkillData.TYPE_FIRE))
         {
            fire = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_WATER))
         {
            water = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_LIGHTNING))
         {
            lightning = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_WIND))
         {
            wind = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_EARTH))
         {
            earth = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_TAIJUTSU))
         {
            taijutsu = true;
         }
         if(skillTypes.containsKey(SkillData.TYPE_GENJUTSU))
         {
            genjutsu = true;
         }
         switch(AppData.type)
         {
            case AppData.FB:
               Main.callJS("showFeed",gender,level,fire,water,lightning,wind,earth,taijutsu,genjutsu);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","levelup",Main.getMainChar().getCharacterName(),gender,level,fire,water,lightning,wind,earth,taijutsu,genjutsu);
               break;
            case AppData.OK:
               desc = Central.main.langLib.get(400);
               desc = String(desc).replace("[valapplicationurl]",Data.APPLICATION_URL);
               desc = String(desc).replace("[valcharactername]",Central.main.getMainChar().getCharacterName());
               desc = String(desc).replace("[valcharacterlevel]",Central.main.getMainChar().getLevel());
               okConnector.conn.createActivity(Central.main.langLib.get(399),desc);
               break;
            case AppData.RR:
               Main.callJS("publishFeed",SNSData.FEED_LEVEL_UP,Main.getMainChar().getCharacterName(),level);
         }
      }
      
      public static function publishDailyTask(taskMsg:*, rewardType:*, rewardMsg:*) : void
      {
         var promptMsg:String = null;
         switch(AppData.type)
         {
            case AppData.FB:
               promptMsg = Central.main.langLib.get(401);
               confirmPublishDailyTask(taskMsg,rewardType,rewardMsg);
               generatedFeed(250);
               break;
            case AppData.MP:
               confirmPublishDailyTask(taskMsg,rewardType,rewardMsg);
               break;
            case AppData.OK:
               promptMsg = Central.main.langLib.get(401);
               Main.showConfirmation(promptMsg,Delegate.create(null,confirmPublishDailyTask,taskMsg,rewardType,rewardMsg),new Function());
               break;
            case AppData.RR:
               confirmPublishDailyTask(taskMsg,rewardType,rewardMsg);
         }
      }
      
      private static function confirmPublishDailyTask(taskMsg:*, rewardType:*, rewardMsg:*) : void
      {
         var gender:String = null;
         var desc:String = null;
         if(Main.getMainChar().getGender() == 0)
         {
            gender = "male";
         }
         else
         {
            gender = "female";
         }
         switch(AppData.type)
         {
            case AppData.FB:
               Main.callJS("feedDailyTask",gender,Main.getMainChar().getCharacterName(),taskMsg,rewardType,rewardMsg);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","daily_task",Main.getMainChar().getCharacterName(),taskMsg,rewardType,rewardMsg);
               break;
            case AppData.OK:
               desc = Central.main.langLib.get(403);
               desc = String(desc).replace("[valapplicationurl]",Data.APPLICATION_URL);
               desc = String(desc).replace("[valcharactername]",Main.getMainChar().getCharacterName());
               okConnector.conn.createActivity(Central.main.langLib.get(402),desc);
               break;
            case AppData.RR:
               Main.callJS("publishFeed",Main.getMainChar().getCharacterName(),taskMsg,rewardType,rewardMsg);
         }
      }
      
      public static function sendNotification(_msg:String, _users:Array, _type:String = "user_to_user") : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               fbConnector.sendNotification(_msg,_users,_type);
               break;
            case AppData.OK:
               okConnector.conn.sendMessage(_users,Central.main.langLib.get(404),_msg);
               break;
            case AppData.MP:
               mpConnector.conn.sendNotification(_users,_msg);
         }
      }
      
      public static function publishRankup(rank:uint) : void
      {
         switch(AppData.type)
         {
            case AppData.FB:
               generatedFeed(300);
               Main.callJS("showRankupFeed",Main.getMainChar().getCharacterName(),rank);
               break;
            case AppData.MP:
               Main.callJS("publishActivity","rankup",Main.getMainChar().getCharacterName(),rank);
               break;
            case AppData.RR:
               Main.callJS("publishFeed","rankup",Main.getMainChar().getCharacterName(),rank);
         }
      }
      
      public static function togglePublish(evt:MouseEvent) : void
      {
         if(MovieClip(evt.currentTarget.parent).currentLabel == "unchecked")
         {
            MovieClip(evt.currentTarget.parent).gotoAndStop("checked");
            isPublish = true;
         }
         else
         {
            MovieClip(evt.currentTarget.parent).gotoAndStop("unchecked");
            isPublish = false;
         }
      }
      
      private static function publishCallback() : void
      {
         if(_cb != null)
         {
            _cb();
         }
      }
      
      public static function callFBJS(methodName:String, ... parameters) : void
      {
      }
      
      public static function initFBJSListener() : void
      {
      }
      
      private static function generatedFeed(feedId:uint) : *
      {
         var seqHash:String = Main.updateSequence();
         Central.main.amfClient.service("Tracking.generated",[Account.getAccountSessionKey(),feedId,seqHash],Main.onAmfResult);
         savedFeedId = feedId;
      }
      
      private static function postedFeed() : *
      {
         var seqHash:String = null;
         if(savedFeedId > 0)
         {
            seqHash = Main.updateSequence();
            Central.main.amfClient.service("Tracking.posted",[Account.getAccountSessionKey(),savedFeedId,seqHash],Main.onAmfResult);
            savedFeedId = 0;
         }
      }
      
      public static function visitRandomFriend() : void
      {
         if(AppData.type != AppData.FB)
         {
            Out.debug("SNS","visitRandomFriend :: not Facebook application");
            return;
         }
         if(friendsData == null)
         {
            Out.debug("SNS","visitRandomFriend :: no friend or character");
            return;
         }
         if(friendsData.length <= 0)
         {
            Out.debug("SNS","visitRandomFriend :: no friend or character");
            return;
         }
         var friendCharArr:Array = [];
         for(var i:int = 0; i < friendsData.length; i++)
         {
            if(friendsData[i])
            {
               if(friendsData[i].source_id != FBUser.uid)
               {
                  friendCharArr.push(friendsData[i]);
               }
            }
         }
         var rNum:int = NumberUtil.randomInt(0,friendCharArr.length - 1);
         if(friendCharArr[rNum])
         {
            if(friendCharArr[rNum].character_id)
            {
               Main.visitFriend(friendCharArr[rNum].character_id,FBUser.uid);
               return;
            }
         }
         Out.error("SNS","visitRandomFriend :: friendCharArr[" + rNum + "] is null :: friendCharArr.length >> " + friendCharArr.length);
      }
      
      public static function getAppFriends(cbFn:Function, ignoreCache:Boolean = false) : void
      {
         if(friendList && !ignoreCache)
         {
            cbFn(friendList);
            return;
         }
         if(friendListRetry >= 3)
         {
            Main.showConfirmation("Sorry! We are unable to connect to the Facebook server to acquire your friend list.",new Function(),new Function());
            return;
         }
         if(friendListRetry == 0)
         {
            fbConnector.getAppFriends(cbFn);
         }
         else
         {
            getAppFriendsCallback = cbFn;
            Main.amfClient.service("FacebookService.getFriendList",[Main.ACCESS_TOKEN],getFriendListResponse);
         }
         friendListRetry++;
      }
      
      public static function getRenRenAppFriends(cbFn:Function) : void
      {
         if(friendList == null)
         {
            getAppFriendsCallback = cbFn;
            Main.amfClient.service("SocialNetwork.getFriends",[Data.sessionKey,Central.main.RR_SESSION_KEY],getRenRenFriendListResponse);
         }
         else
         {
            cbFn(friendList);
         }
      }
      
      private static function getRenRenFriendListResponse(response:Object) : *
      {
         var characterCache:HashMap = null;
         var characterRecruitCache:HashMap = null;
         var friendList:Array = null;
         var charList:Array = null;
         var i:* = undefined;
         var k:int = 0;
         var constructedFriendList:Array = null;
         var constructedCharList:Array = null;
         var userObj:Object = null;
         var charObj:Object = null;
         var uid:String = null;
         var charArr:Array = null;
         if(Main.validateAmfResponse(response))
         {
            if(response.friend_list == null || response.char_list == null)
            {
               if(getAppFriendsCallback != null)
               {
                  getAppFriendsCallback(charList);
               }
               return;
            }
            friendListHash = new HashMap();
            characterCache = new HashMap();
            characterRecruitCache = new HashMap();
            friendList = response.friend_list;
            charList = response.char_list;
            constructedFriendList = [];
            constructedCharList = [];
            for(i = 0; i < friendList.length; i++)
            {
               userObj = {};
               userObj.uid = friendList[i].id;
               userObj.name = friendList[i].name;
               userObj.pic_square = friendList[i].pic_square;
               constructedFriendList.push(userObj);
               friendListHash.insert(userObj.uid,userObj);
            }
            Central.sns.friendList = constructedFriendList;
            for(i = 0; i < charList.length; i++)
            {
               charObj = {};
               charObj.source_id = charList[i].source_id;
               charObj.character_id = charList[i].character_id;
               charObj.character_name = charList[i].character_name;
               charObj.character_level = charList[i].character_level;
               charObj.character_xp = charList[i].character_xp;
               charObj.character_gender = charList[i].character_gender;
               charObj.account_type = charList[i].account_type;
               charObj.character_rank = uint(charList[i].character_rank);
               charObj.server_time = charList[i].server_time;
               charObj.thumbnail_url = charList[i].thumbnail_url;
               charObj.server_time = charList[i].display_name;
               charObj.achievement_point = charList[i].achievement_point;
               charObj.recruited_time = charList[i].recruited_time;
               constructedCharList.push(charObj);
            }
            for(i = 0; i < constructedFriendList.length; i++)
            {
               uid = String(constructedFriendList[i].uid);
               charArr = [];
               for(k = 0; k < constructedCharList.length; k++)
               {
                  if(String(constructedCharList[k].source_id) == uid)
                  {
                     characterRecruitCache.insert(constructedCharList[k].character_id,constructedCharList[k]);
                     charArr.push(constructedCharList[k]);
                  }
               }
               characterCache.insert(uid,charArr);
            }
            Central.panel.getInstance().addChallengeCharCache(characterCache);
            Central.panel.getInstance().addRecruitCharCache(characterRecruitCache);
            Central.main.friendData = Central.panel.getInstance().recruitCharCache.toArray();
            if(getAppFriendsCallback != null)
            {
               getAppFriendsCallback(charList);
            }
         }
      }
      
      private static function getFriendListResponse(response:Object) : *
      {
         var friendList:Array = null;
         var i:int = 0;
         var constructedFriendList:Array = null;
         var userObj:Object = null;
         if(Main.validateAmfResponse(response))
         {
            if(response.friend_list == null)
            {
               return;
            }
            friendList = response.friend_list;
            constructedFriendList = [];
            for(i = 0; i < friendList.length; i++)
            {
               userObj = {};
               userObj.uid = friendList[i].id;
               userObj.name = friendList[i].name;
               userObj.pic_square = FB_GRAPH_API + friendList[i].id + "/picture?access_token=" + Main.ACCESS_TOKEN;
               constructedFriendList.push(userObj);
            }
            if(getAppFriendsCallback != null)
            {
               getAppFriendsCallback(constructedFriendList);
            }
         }
      }
      
      public static function getFriendList(cb:Function) : void
      {
         getInstance().getFriendList(cb);
      }
      
      public function setConnector(c:MovieClip) : void
      {
         this.connector = c;
      }
      
      public function getFriendList(cb:Function) : void
      {
         if(AppData.type == AppData.RR)
         {
            getRenRenAppFriends(cb);
         }
         else
         {
            if(this.connector == null)
            {
               cb([]);
               return;
            }
            this.connector.getFriendList(cb);
         }
      }
   }
}

class InstanceBlocker
{
    
   
   function InstanceBlocker()
   {
      super();
   }
}
