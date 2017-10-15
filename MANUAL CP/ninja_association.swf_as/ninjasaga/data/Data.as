package ninjasaga.data 
{
    import bitemycode.facebook.*;
    
    public final class Data extends Object
    {
        public function Data()
        {
            super();
            return;
        }

        public static function get AMF_GATEWAY():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.RR:
                {
                    return "http://220.181.49.220/com.ninjasaga.renren/amf/";
                }
                case ninjasaga.data.AppData.YM:
                {
                    return "http://50.57.98.180/amf/";
                }
                default:
                {
                    return "https://app.ninjasaga.com/amf_live2/";
                }
            }
        }

        public static function getBodyPartArr():Array
        {
            if (bodyPartArr == null)
            {
                bodyPartArr = ["upper_body", "lower_body", "left_upper_arm", "left_lower_arm", "left_hand", "left_upper_leg", "left_lower_leg", "left_shoe", "right_upper_arm", "right_lower_arm", "right_hand", "right_upper_leg", "right_lower_leg", "right_shoe"];
            }
            return bodyPartArr;
        }

        public static function getHairColorArr():Array
        {
            if (hairColorArr == null)
            {
                hairColorArr = new Array();
                hairColorArr.push([1973790, 1381653]);
                hairColorArr.push([10747904, 6684672]);
                hairColorArr.push([16757169, 16737123]);
                hairColorArr.push([16749351, 15759360]);
                hairColorArr.push([10710872, 7293500]);
                hairColorArr.push([16763904, 16750848]);
                hairColorArr.push([23387, 13107]);
                hairColorArr.push([12927265, 10751488]);
                hairColorArr.push([4786437, 3145728]);
                hairColorArr.push([9319279, 7668029]);
                hairColorArr.push([2192527, 1262419]);
                hairColorArr.push([14610175, 10867199]);
                hairColorArr.push([12040155, 8421568]);
                hairColorArr.push([5460902, 3816052]);
                hairColorArr.push([9145227, 5789784]);
                hairColorArr.push([15921906, 13948116]);
                hairColorArr.push([15828225, 15357696]);
                hairColorArr.push([16777113, 15125863]);
                hairColorArr.push([12767958, 11116708]);
                hairColorArr.push([9265949, 7614720]);
            }
            return hairColorArr;
        }

        public static function getHairColorArr_create():Array
        {
            if (hairColorArr_arr == null)
            {
                hairColorArr_arr = new Array();
                hairColorArr_arr.push([16777113, 15125863, 17]);
                hairColorArr_arr.push([16763904, 16750848, 5]);
                hairColorArr_arr.push([9265949, 7614720, 19]);
                hairColorArr_arr.push([10710872, 7293500, 4]);
                hairColorArr_arr.push([9145227, 5789784, 14]);
                hairColorArr_arr.push([10747904, 6684672, 1]);
                hairColorArr_arr.push([9319279, 7668029, 9]);
                hairColorArr_arr.push([1973790, 1381653, 0]);
            }
            return hairColorArr_arr;
        }

        public static function getSkinColorArr():Array
        {
            if (skinColorArr == null)
            {
                skinColorArr = new Array();
                skinColorArr.push(13557484);
                skinColorArr.push(10074585);
                skinColorArr.push(4817850);
                skinColorArr.push(3366536);
                skinColorArr.push(14019773);
                skinColorArr.push(10540396);
                skinColorArr.push(8175672);
                skinColorArr.push(4883008);
                skinColorArr.push(15230291);
                skinColorArr.push(13382701);
                skinColorArr.push(15586246);
                skinColorArr.push(15976390);
                skinColorArr.push(14132383);
                skinColorArr.push(16173743);
                skinColorArr.push(15640730);
                skinColorArr.push(16764323);
                skinColorArr.push(15315843);
                skinColorArr.push(13929590);
                skinColorArr.push(10184275);
                skinColorArr.push(5782064);
            }
            return skinColorArr;
        }

        public static function getSkinColorArr_create():Array
        {
            if (skinColorArr_arr == null)
            {
                skinColorArr_arr = new Array();
                skinColorArr_arr.push([15976390, 11]);
                skinColorArr_arr.push([16173743, 13]);
                skinColorArr_arr.push([16764323, 15]);
                skinColorArr_arr.push([15315843, 16]);
                skinColorArr_arr.push([15640730, 14]);
                skinColorArr_arr.push([13929590, 17]);
                skinColorArr_arr.push([10184275, 18]);
                skinColorArr_arr.push([5782064, 19]);
            }
            return skinColorArr_arr;
        }

        public static function getMissionGradeArr():Array
        {
            if (missionGradeArr == null)
            {
                missionGradeArr = new Array();
                missionGradeArr.push({"id":"A", "name":"Grade A", "level":1});
                missionGradeArr.push({"id":"B", "name":"Grade B", "level":40});
                missionGradeArr.push({"id":"C", "name":"Grade C", "level":40});
                missionGradeArr.push({"id":"D", "name":"Grade D", "level":20});
                missionGradeArr.push({"id":"E", "name":"Grade E", "level":1});
            }
            return missionGradeArr;
        }

        public static function get HIDDEN_HAIR():Array
        {
            var loc1:*;
            loc1 = ["hair_9_0", "hair_9_1", "hair_32_0", "hair_32_1"];
            return loc1;
        }

        public static function get EARN_TOKEN_URL():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.FB:
                {
                    return "http://apps.facebook.com/ninjasaga/earn-token.php";
                }
                case ninjasaga.data.AppData.OK:
                {
                    return "http://www.orkut.com/Main#Application.aspx?appId=296934529951&appParams=%7B%22page%22%3A%22earn-token%22%7D";
                }
                case ninjasaga.data.AppData.MP:
                {
                    return "http://www.ninjasaga.com/myspace/earn-token.php?uid=" + bitemycode.facebook.FBUser.uid;
                }
                default:
                {
                    return "";
                }
            }
        }

        public static function get PAYMENT_GATEWAY():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.FB:
                {
                    loc1 = ninjasaga.data.AppData.lang;
                    switch (loc1) 
                    {
                        case ninjasaga.data.AppData.EN:
                        {
                            return "http://apps.facebook.com/ninjasaga/fb_buy_token.php";
                        }
                        case ninjasaga.data.AppData.ES:
                        {
                            return "http://apps.facebook.com/ninjasaga_es/fb_buy_token.php";
                        }
                        case ninjasaga.data.AppData.ZH:
                        {
                            return "http://apps.facebook.com/ninjasaga_zh/fb_buy_token.php";
                        }
                        default:
                        {
                            return "http://apps.facebook.com/ninjasaga/fb_buy_token.php";
                        }
                    }
                }
                case ninjasaga.data.AppData.OK:
                {
                    return "http://payment.ninjasaga.com/payment.php?id=";
                }
                case ninjasaga.data.AppData.MP:
                {
                    return "http://payment.ninjasaga.com/payment.php?id=";
                }
                case ninjasaga.data.AppData.YM:
                {
                    return "http://50.57.98.180/payment/mycard.php?session_key=" + sessionKey;
                }
                default:
                {
                    return "";
                }
            }
        }

        public static function get PAYMENT_PHP():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.FB:
                {
                    return "http://apps.facebook.com/ninjasaga/fb_buy_token.php";
                }
                case ninjasaga.data.AppData.YM:
                {
                    return "http://50.57.98.180/payment/mycard.php?session_key=" + sessionKey;
                }
                default:
                {
                    return "";
                }
            }
        }

        public static function get APPLICATION_URL():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.FB:
                {
                    return "http://apps.facebook.com/ninjasaga/";
                }
                case ninjasaga.data.AppData.OK:
                {
                    return "http://www.orkut.com/Main#Application.aspx?appId=229085262055";
                }
                case ninjasaga.data.AppData.MP:
                {
                    return "http://www.myspace.com/492304361";
                }
                default:
                {
                    return "http://www.ninjasaga.com/";
                }
            }
        }

        public static function get FAQ_URL_CLAN():String
        {
            return "http://www.ninjasaga.com/support/clan_join_faq.php";
        }

        public static function get FAQ_URL_PET():String
        {
            return "http://www.ninjasaga.com/support/pet_faq.php";
        }

        public static function get FAQ_URL_BLACKSMITH():String
        {
            return "http://www.ninjasaga.com/support/account_faq.php";
        }

        public static function get FAQ_URL_LEARNSKILLFROMFRIEND():String
        {
            return "http://www.ninjasaga.com/support/learn_skill_faq.php";
        }

        public static function genSwfFilePath(arg1:String, arg2:String):String
        {
            var loc1:*;
            loc1 = null;
            if (ninjasaga.data.StaticVariables.loadType == LOAD_TYPE_LOCAL || String(arg2).indexOf("http://") >= 0 || String(arg2).indexOf("https://") >= 0)
            {
                loc1 = "swf/" + arg1 + "/" + arg2 + ".swf";
            }
            else 
            {
                loc1 = STATIC_SERVER + "swf/" + BUILD_NO + "/swf/" + arg1 + "/" + arg2 + ".swf";
            }
            return loc1;
        }

        
        {
            BUILD_NO = "3.1.00005";
            INV_SPACE_FREE = 40;
            INV_SPACE_PREMIUM = 80;
            INV_SPACE_COMMON = 200;
            INV_SPACE_WEAPON = 200;
            INV_SPACE_BODYSET = 200;
            INV_SPACE_BACKITEM = 200;
            INV_SPACE_ESSENCE = 200;
            INV_SPACE_MATERIAL_FREE = 200;
            INV_SPACE_MATERIAL_PREMIUM = 400;
            INV_SPACE_FREE_CURNUM = 0;
            INV_SPACE_PREMIUM_CURNUM = 0;
            INV_SPACE_COMMON_CURNUM = 0;
            INV_SPACE_WEAPON_FREE_CURNUM = 0;
            INV_SPACE_WEAPON_PREMIUM_CURNUM = 0;
            INV_SPACE_BODYSET_FREE_CURNUM = 0;
            INV_SPACE_BODYSET_PREMIUM_CURNUM = 0;
            INV_SPACE_BACKITEM_FREE_CURNUM = 0;
            INV_SPACE_BACKITEM_PREMIUM_CURNUM = 0;
            INV_SPACE_ESSENCE_FREE_CURNUM = 0;
            INV_SPACE_ESSENCE_PREMIUM_CURNUM = 0;
            INV_SPACE_MATERIAL_FREE_CURNUM = 0;
            INV_SPACE_MATERIAL_PREMIUM_CURNUM = 0;
            MISSION_COMPLETE_PATH = "swf/panels/mission_complete.swf";
            REWAED_ALERT_PATH = "swf/panels/reward_alert.swf";
        }

        public static const BUILD_REVIEW:String="0";

        public static const TEST_VERSION:Boolean=false;

        public static const FRAME_RATE:uint=24;

        public static const GAME_WIDTH:uint=960;

        public static const GAME_HEIGTH:uint=550;

        public static const GAME_HEIGTH_FULL:uint=780;

        public static const PARTY_SERVER:String="dev.bitemycode.com";

        public static const PARTY_SERVER_PORT:uint=9191;

        public static const STATIC_SERVERS:Array=["http://static.ninjasaga.com/", "http://cdn.ninjasaga.com/", "http://cdntest.ninjasaga.com/", "http://cdn.static.ninjasaga.com/", "http://cdntest.static.ninjasaga.com/", "http://static.dev.ninajsaga.com/", "http://220.181.49.220/", "http://aka.static.ninjasaga.com/", "https://aka.static.ninjasaga.com/", "https://cdn.static.ninjasaga.com/", "https://static.ninjasaga.com/"];

        public static const LOCAL_CONNECTION_NAME:String="_com_ninjasaga_";

        public static const LOAD_TYPE_LOCAL:String="load_type_local";

        public static const LOAD_TYPE_WEB:String="load_type_web";

        public static const MAX_NAME_CHAR:uint=20;

        public static const SECURITY_FILES:Array=["http://profile.ak.facebook.com/crossdomain.xml", "xmlsocket://74.86.119.18:843", "http://app.ninjasaga.com/crossdomain.xml", "xmlsocket://8.19.33.107:843", "xmlsocket://8.19.33.107:844", "xmlsocket://8.19.33.107:845", "xmlsocket://8.19.33.107:846", "http://:8001/crossdomain.xml"];

        public static const LEVEL_HACK_SKIP:Array=["msn59"];

        public static const EXAM_CHUNIN_ARR:Array=["msn55", "msn56", "msn57", "msn58", "msn59"];

        public static const EXAM_JOUNIN_ARR:Array=["msn132", "msn133", "msn134", "msn135", "msn136"];

        public static const EXAM_SPECIAL_JOUNIN_ARR:Array=["msn200", "msn205", "msn202", "msn206", "msn203", "msn207", "msn204", "msn208", "msn201", "msn209", "msn210", "msn211", "msn212"];

        public static const EXAM_SPECIAL_JOUNIN_ARR_EASY:Array=["msn226", "msn227", "msn228", "msn229", "msn230", "msn231", "msn232", "msn233", "msn234", "msn235", "msn236", "msn237", "msn238"];

        public static const EXAM_SENNIN_ARR:Array=["msn266", "msn259", "msn267", "msn260", "msn268", "msn261", "msn270", "msn262", "msn269", "msn263", "msn264", "msn265"];

        public static const EXAM_SENNIN_ARR_EASY:Array=["msn250", "msn252", "msn249", "msn253", "msn248", "msn254", "msn247", "msn255", "msn251", "msn256", "msn257", "msn258"];

        public static const TEXT_ESSENCE:String="essence";

        public static const TEXT_MATERIAL:String="material";

        public static const TEXT_CURRENCY:String="currency";

        public static const TEXT_ITEM_MC_NAME:String="ItemIconMc";

        public static const TEXT_ITEM:String="item";

        public static const TEXT_ITEM_HP:String="hp";

        public static const TEXT_ITEM_CP:String="cp";

        public static const TEXT_ITEM_SMOKE:String="smoke";

        public static const TEXT_ITEM_SPECIAL:String="special";

        public static const ITEM_HALLOWEEN_2011:Array=["item55", "item56", "item57", "item58", "item59", "item60", "item61", "item62", "item63"];

        public static const TEXT_GOLD_MC_NAME:String="GoldIcon";

        public static const TEXT_TOKEN_MC_NAME:String="TokenIcon";

        public static const TEXT_XP_MC_NAME:String="XPIcon";

        public static const NEW_CONSUMABLE_ARR:Array=["item41", "item42", "item43", "item44", "item45", "item46", "item47", "item48", "item49", "item50", "item51", "item52", "item55", "item56", "item57", "item58", "item59", "item60", "item61", "item62", "item63", "item64", "item65", "item66", "item67", "item68"];

        public static const MAX_SKILL_NUMBER:uint=8;

        public static const INV_SPACE_FREE_ADD:uint=5;

        public static const INV_SPACE_PREMIUM_ADD:uint=5;

        public static const INV_SPACE_COMMON_ADD:uint=200;

        public static const INV_SPACE_WEAPON_ADD:uint=10;

        public static const INV_SPACE_BODYSET_ADD:uint=10;

        public static const INV_SPACE_BACKITEM_ADD:uint=10;

        public static const INV_SPACE_ESSENCE_ADD:uint=10;

        public static const INV_SPACE_MATERIAL_FREE_ADD:uint=10;

        public static const INV_SPACE_MATERIAL_PREMIUM_ADD:uint=10;

        public static const INV_SPACE_FREE_MAX:uint=100;

        public static const INV_SPACE_PREMIUM_MAX:uint=200;

        public static const INV_SPACE_COMMON_MAX:uint=200;

        public static const INV_SPACE_WEAPON_FREE_MAX:uint=300;

        public static const INV_SPACE_WEAPON_PREMIUM_MAX:uint=600;

        public static const INV_SPACE_BODYSET_FREE_MAX:uint=300;

        public static const INV_SPACE_BODYSET_PREMIUM_MAX:uint=600;

        public static const INV_SPACE_BACKITEM_FREE_MAX:uint=300;

        public static const INV_SPACE_BACKITEM_PREMIUM_MAX:uint=600;

        public static const INV_SPACE_ESSENCE_FREE_MAX:uint=300;

        public static const INV_SPACE_ESSENCE_PREMIUM_MAX:uint=600;

        public static const INV_SPACE_MATERIAL_FREE_MAX:uint=300;

        public static const INV_SPACE_MATERIAL_PREMIUM_MAX:uint=600;

        public static const INV_SPACE_FREE_MAXNUM:uint=12;

        public static const INV_SPACE_PREMIUM_MAXNUM:uint=24;

        public static const INV_SPACE_COMMON_MAXNUM:uint=10;

        public static const INV_SPACE_WEAPON_FREE_MAXNUM:uint=10;

        public static const INV_SPACE_WEAPON_PREMIUM_MAXNUM:uint=30;

        public static const INV_SPACE_BODYSET_FREE_MAXNUM:uint=10;

        public static const INV_SPACE_BODYSET_PREMIUM_MAXNUM:uint=30;

        public static const INV_SPACE_BACKITEM_FREE_MAXNUM:uint=10;

        public static const INV_SPACE_BACKITEM_PREMIUM_MAXNUM:uint=30;

        public static const INV_SPACE_ESSENCE_FREE_MAXNUM:uint=10;

        public static const INV_SPACE_ESSENCE_PREMIUM_MAXNUM:uint=30;

        public static const INV_SPACE_MATERIAL_FREE_MAXNUM:uint=10;

        public static const INV_SPACE_MATERIAL_PREMIUM_MAXNUM:uint=20;

        public static const INV_PETS_MAXNUM:uint=99;

        public static const BATTLE_CHAR_SCALE:Number=0.5;

        public static const BATTLE_HEAD_SCALE:Number=0.5;

        public static const BATTLE_ATB_ACTION_TIME:Number=FRAME_RATE * 2;

        public static const BATTLE_ATB_CHAR_SCALE:Number=0.2;

        public static const BATTLE_REWARDS_CONSUMABLE_LEVEL_RESTRICTION:uint=3;

        public static const BATTLE_REWARDS_ITEM_LEVEL_RESTRICTION:uint=3;

        public static const DEFAULT_HAIR_COLOR:Array=[0, 0];

        public static const DEFAULT_SKIN_COLOR:Number=16307137;

        public static const DEFAULT_EYE_COLOR:Number=0;

        public static const DEFAULT_HAIR:String="hair_01";

        public static const DEFAULT_FACE:String="face_01";

        public static const DEFAULT_BODY_SET:String="set1";

        public static const DEFAULT_WEAPON:String="wpn1";

        public static const DEFAULT_BACK_ITEM:String="";

        public static const SKILL_CLOSEUP_SCALE:Number=5;

        public static const ICON_SCALE:Number=0.4;

        public static const XP_BASE:uint=100;

        public static const XP_TO_LEVEL_MODIFIER:Number=1.4;

        public static const LEVEL_INC_HP:uint=40;

        public static const LEVEL_INC_CP:uint=40;

        public static const LEVEL_INC_AGILITY:uint=1;

        public static const NEWLINE:String="\n";

        public static const CRYSTAL_TO_GOLD_RATE:uint=20;

        public static const FREE_JUTSU_NUMBER:uint=2;

        public static const PREMIUM_JUTSU_NUMBER:uint=3;

        public static const CHAT_INPUT_COOLDOWN:uint=2;

        public static const CHAT_INPUT_MAX_CHARACTERS:uint=50;

        public static const CHAT_MAX_DISPLAY_CHARACTERS:uint=5000;

        public static const FB_APPLICATION_PAGE:String="http://www.facebook.com/apps/application.php?id=137827210650";

        public static const FB_INVITE_PAGE:String="http://apps.facebook.com/ninjasaga/invite_friends.php";

        public static const MENU_PATH:String="swf/library/menu.swf";

        public static const ACHIEVEMENT_PANEL_PATH:String="swf/panels/achievement.swf";

        public static var sessionKey:String;

        public static var bodyPartArr:Array;

        public static var hairColorArr:Array;

        public static var hairColorArr_arr:Array;

        public static var skinColorArr:Array;

        public static var skinColorArr_arr:Array;

        public static var missionGradeArr:Array;

        public static var hairDataArr:Array;

        public static var BUILD_NO:String="3.1.00005";

        public static var STATIC_SERVER:String;

        public static var INV_SPACE_FREE:uint=40;

        public static var INV_SPACE_PREMIUM:uint=80;

        public static var INV_SPACE_COMMON:uint=200;

        public static var INV_SPACE_WEAPON:uint=200;

        public static var INV_SPACE_BODYSET:uint=200;

        public static var INV_SPACE_BACKITEM:uint=200;

        public static var INV_SPACE_ESSENCE:uint=200;

        public static var INV_SPACE_MATERIAL_FREE:uint=200;

        public static var INV_SPACE_MATERIAL_PREMIUM:uint=400;

        public static var INV_SPACE_FREE_CURNUM:uint=0;

        public static var INV_SPACE_PREMIUM_CURNUM:uint=0;

        public static var INV_SPACE_COMMON_CURNUM:uint=0;

        public static var INV_SPACE_WEAPON_FREE_CURNUM:uint=0;

        public static var INV_SPACE_WEAPON_PREMIUM_CURNUM:uint=0;

        public static var INV_SPACE_BODYSET_FREE_CURNUM:uint=0;

        public static var INV_SPACE_BODYSET_PREMIUM_CURNUM:uint=0;

        public static var INV_SPACE_BACKITEM_FREE_CURNUM:uint=0;

        public static var INV_SPACE_BACKITEM_PREMIUM_CURNUM:uint=0;

        public static var INV_SPACE_ESSENCE_FREE_CURNUM:uint=0;

        public static var INV_SPACE_ESSENCE_PREMIUM_CURNUM:uint=0;

        public static var INV_SPACE_MATERIAL_FREE_CURNUM:uint=0;

        public static var INV_SPACE_MATERIAL_PREMIUM_CURNUM:uint=0;

        public static var MISSION_COMPLETE_PATH:String="swf/panels/mission_complete.swf";

        public static var REWAED_ALERT_PATH:String="swf/panels/reward_alert.swf";
    }
}
