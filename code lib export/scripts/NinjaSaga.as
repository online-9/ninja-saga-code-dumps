package
{
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import flash.text.TextField;
   import flash.ui.ContextMenuItem;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuBuiltInItems;
   import ninjasaga.data.Data;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import com.utils.Out;
   import ninjasaga.data.AppData;
   import ninjasaga.Central;
   import com.adobe.crypto.MD5;
   import flash.events.MouseEvent;
   import ninjasaga.data.Timeline;
   import com.utils.GF;
   import ninjasaga.data.MissionData;
   import com.utils.Mixer;
   import bitemycode.facebook.FBUser;
   import flash.events.TimerEvent;
   import ninjasaga.Account;
   import flash.utils.getDefinitionByName;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import flash.system.Security;
   import flash.display.StageQuality;
   import ninjasaga.data.StaticVariables;
   
   public class NinjaSaga extends MovieClip
   {
      
      public static var swfObj:Object = {};
      
      public static var isTestMode:Boolean = false;
       
      
      private var codeLibrary:MovieClip;
      
      private var networkLibrary:MovieClip;
      
      public var engageMc:MovieClip;
      
      public var mapMc:MovieClip;
      
      public var mapMenuMc:MovieClip;
      
      public var popupMc:MovieClip;
      
      private var validTimer:Timer;
      
      private var devTest:Boolean = false;
      
      private var fpsTxt:TextField;
      
      private var frames:int = 0;
      
      private var curTimer:Number = 0;
      
      private var prevTimer:Number = 0;
      
      public function NinjaSaga()
      {
         var i:uint = 0;
         var security_filename:String = null;
         fpsTxt = new TextField();
         super();
         try
         {
            for(i = 0; i < Data.SECURITY_FILES.length; i++)
            {
               security_filename = Data.SECURITY_FILES[i];
               if(security_filename.indexOf("/crossdomain.xml") >= 0)
               {
                  security_filename = security_filename + ("?x=" + Math.floor(Math.random() * 10000));
               }
               Security.loadPolicyFile(security_filename);
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor(load security files)::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            Security.allowDomain("api.msappspace.com");
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor(Security.allowDomain)::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            if(this.loaderInfo.parameters.client_version)
            {
               Data.BUILD_NO = this.loaderInfo.parameters.client_version;
            }
         }
         catch(e:Error)
         {
         }
         this.setupContextMenu();
         try
         {
            if(AppData.SUPPORTED_LANGUAGE.indexOf(this.loaderInfo.parameters.lang) >= 0)
            {
               AppData.lang = String(this.loaderInfo.parameters.lang);
            }
            else
            {
               NinjaSaga.isTestMode = true;
               AppData.lang = AppData.ZH;
               stage.quality = StageQuality.LOW;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor :: Language Error :: " + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            for(i = 0; i < Data.STATIC_SERVERS.length; i++)
            {
               if(String(this.loaderInfo.loaderURL).indexOf(Data.STATIC_SERVERS[i]) >= 0)
               {
                  Data.STATIC_SERVER = Data.STATIC_SERVERS[i];
                  break;
               }
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         try
         {
            if(String(this.loaderInfo.loaderURL).indexOf("file://") >= 0)
            {
               StaticVariables.loadType = Data.LOAD_TYPE_LOCAL;
            }
            else
            {
               StaticVariables.loadType = Data.LOAD_TYPE_WEB;
            }
         }
         catch(e:Error)
         {
            Out.error(this,"NS Constructor::" + e.getStackTrace());
            Central.main.submitLogDump();
         }
         if(Data.STATIC_SERVER == null && StaticVariables.loadType == Data.LOAD_TYPE_WEB)
         {
            this.stop();
            Out.error(this,"constructor :: host not allowed :: " + this.loaderInfo.loaderURL);
            return;
         }
         try
         {
            this.selfPreloadFinish(null);
         }
         catch(e:Error)
         {
            Out.error(this,"NS Construct selfPreloadFinish::" + e.getStackTrace());
         }
         this.tabEnabled = false;
         this.tabChildren = false;
      }
      
      public function setupContextMenu() : void
      {
         var testVersion:ContextMenuItem = null;
         var amfPath:ContextMenuItem = null;
         var copyrightNotice:ContextMenuItem = null;
         var myContextMenu:ContextMenu = new ContextMenu();
         var defaultItems:ContextMenuBuiltInItems = myContextMenu.builtInItems;
         myContextMenu.hideBuiltInItems();
         if(Data.TEST_VERSION)
         {
            testVersion = new ContextMenuItem("*** Test Version ***");
            myContextMenu.customItems.push(testVersion);
            amfPath = new ContextMenuItem("*** AMF ***");
            myContextMenu.customItems.push(Data.AMF_GATEWAY);
         }
         else
         {
            copyrightNotice = new ContextMenuItem("Build " + Data.BUILD_NO + "." + Data.BUILD_REVIEW);
         }
         myContextMenu.customItems.push(copyrightNotice);
         this.contextMenu = myContextMenu;
      }
      
      private function showLoading(evt:ProgressEvent) : void
      {
         var percentLoaded:Number = evt.bytesLoaded / evt.bytesTotal;
         if(percentLoaded < 0)
         {
            percentLoaded = 0;
         }
         if(percentLoaded > 1)
         {
            percentLoaded = 1;
         }
         this["preloader"].showLoadingProgress(percentLoaded);
      }
      
      private function selfPreloadFinish(evt:Event) : void
      {
         var Desc:String = null;
         Out.debug(this,"selfPreloadFinish :: evt " + evt);
         var i:uint = 0;
         var swfToLoad:Array = [];
         swfToLoad.push("swf/library/code_library.swf");
         swfToLoad.push("swf/library/client_library.swf");
         if(NinjaSaga.isTestMode)
         {
            NinjaSaga.isTestMode = true;
            swfToLoad.push("swf/language/" + AppData.EN + ".swf");
            swfToLoad.push("swf/language/" + AppData.ES + ".swf");
            swfToLoad.push("swf/language/" + AppData.ZH + ".swf");
         }
         else
         {
            swfToLoad.push("swf/language/" + AppData.lang + ".swf");
         }
         swfToLoad.push("swf/library/network_library.swf");
         swfToLoad.push("swf/library/popup.swf");
         if(this.loaderInfo.parameters.fb_uid != null && this.loaderInfo.parameters.fb_at != null && this.loaderInfo.parameters.fb_sig != null)
         {
            AppData.type = AppData.FB;
            swfToLoad.push("swf/sns/facebook_connector.swf");
         }
         if(this.loaderInfo.parameters.orkut_id)
         {
            AppData.type = AppData.OK;
            swfToLoad.push("swf/sns/orkut_connector.swf");
         }
         if(this.loaderInfo.parameters.myspace_id)
         {
            AppData.type = AppData.MP;
            swfToLoad.push("swf/sns/myspace_connector.swf");
         }
         if(this.loaderInfo.parameters.source)
         {
            switch(this.loaderInfo.parameters.source)
            {
               case AppData.RR:
                  AppData.type = AppData.RR;
                  break;
               default:
                  AppData.type = AppData.YM;
            }
         }
         Out.debug(this,"AppData.type " + AppData.type);
         var connectorPath:String = AppData.connectorPath;
         if(connectorPath)
         {
            swfToLoad.push(connectorPath);
         }
         switch(AppData.lang)
         {
            case AppData.CN:
               Desc = "正在初始化......";
               break;
            case AppData.ZH:
               Desc = "正在初始化......";
               break;
            default:
               Desc = "Initializing Game Engine...";
         }
         this["preloader"].loadSwf(swfToLoad,this.preloadFinish,null,Desc);
      }
      
      private function preloadFinish(_swfObj:Object) : void
      {
         var md5HashStr:String = null;
         this.codeLibrary = _swfObj["swf/library/code_library.swf"];
         this.codeLibrary.setMainMc(this);
         this.networkLibrary = _swfObj["swf/library/network_library.swf"];
         this.networkLibrary.init();
         this.popupMc = _swfObj["swf/library/popup.swf"];
         this["popupHolder"].addChild(this.popupMc);
         Central.main.proc.clientLib = _swfObj["swf/library/client_library.swf"];
         Central.main.langLib = _swfObj["swf/language/" + AppData.lang + ".swf"];
         if(NinjaSaga.isTestMode)
         {
            NinjaSaga.swfObj["swf/language/" + AppData.EN + ".swf"] = _swfObj["swf/language/" + AppData.EN + ".swf"];
            NinjaSaga.swfObj["swf/language/" + AppData.ES + ".swf"] = _swfObj["swf/language/" + AppData.ES + ".swf"];
            NinjaSaga.swfObj["swf/language/" + AppData.ZH + ".swf"] = _swfObj["swf/language/" + AppData.ZH + ".swf"];
         }
         if(this.loaderInfo && this.loaderInfo.parameters && this.loaderInfo.parameters.client_debug)
         {
            md5HashStr = MD5.hash(this.loaderInfo.parameters.client_debug);
            if(md5HashStr == "33efb782948d3ef2b812ac77cf881ec7")
            {
               this.devTest = true;
            }
         }
         if(this.devTest == true)
         {
            this.createFPStextField();
            this["fpsTxt"].addEventListener(Event.ENTER_FRAME,this.performFrameTest);
         }
         if(AppData.type == AppData.FB)
         {
            Central.sns.fbConnector = _swfObj["swf/sns/facebook_connector.swf"];
            Central.sns.fbConnector.setAccessToken(this.loaderInfo.parameters.fb_at);
         }
         if(AppData.type == AppData.OK)
         {
            Central.sns.okConnector = _swfObj["swf/sns/orkut_connector.swf"];
            Central.sns.okConnector.conn;
         }
         if(AppData.type == AppData.MP)
         {
            Central.sns.mpConnector = _swfObj["swf/sns/myspace_connector.swf"];
         }
         var connectorPath:String = AppData.connectorPath;
         if(connectorPath)
         {
            Central.sns.getInstance().setConnector(_swfObj[connectorPath]);
         }
         Central.main.addJSCallBack();
         switch(AppData.type)
         {
            case AppData.FB:
            case AppData.OK:
            case AppData.MP:
            case AppData.YM:
            case AppData.RR:
               Central.main.checkFeatureControl();
               this.gotoLogin();
               break;
            default:
               Central.main.checkFeatureControl();
               this.gotoLogin();
         }
      }
      
      public function onClickChooseType(evt:MouseEvent) : void
      {
         Central.main.checkFeatureControl(evt.currentTarget.AppType);
         this["buttonMC1"].visible = false;
         this["buttonMC2"].visible = false;
         this["buttonMC3"].visible = false;
         this.gotoLogin();
      }
      
      public function gotoLogin(evt:Event = null) : void
      {
         this["preloader"].hide();
         this.initSocialPlatform();
      }
      
      private function initSocialPlatform() : void
      {
         if(AppData.type == AppData.FB)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.fb_uid,
               "name":this.loaderInfo.parameters.fb_name,
               "pic_square":Central.sns.FB_GRAPH_API + this.loaderInfo.parameters.fb_uid + "/picture"
            });
            return;
         }
         if(AppData.type == AppData.OK)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.orkut_id,
               "name":this.loaderInfo.parameters.orkut_name,
               "pic_square":this.loaderInfo.parameters.orkut_pic
            });
            return;
         }
         if(AppData.type == AppData.MP)
         {
            this.onFbLogin({
               "uid":this.loaderInfo.parameters.myspace_id,
               "name":this.loaderInfo.parameters.myspace_name,
               "pic_square":this.loaderInfo.parameters.orkut_pic
            });
            return;
         }
         switch(AppData.type)
         {
            case AppData.YM:
            case AppData.RR:
               if(this.loaderInfo.parameters.session_key)
               {
                  this.login(this.loaderInfo.parameters.session_key);
                  return;
               }
               break;
            default:
               if(this.loaderInfo.parameters.session_key)
               {
                  this.login(this.loaderInfo.parameters.session_key);
                  return;
               }
               break;
         }
         this.gotoAndStop(Timeline.LOGIN);
      }
      
      public function gotoSelchar() : void
      {
         this.gotoAndStop(Timeline.SELCHAR);
      }
      
      public function gotoInit(evt:MouseEvent = null) : void
      {
         this.gotoAndStop(Timeline.INIT);
      }
      
      public function gotoMap() : void
      {
         Central.main.updateMusic();
         this.gotoAndPlay(Timeline.MAP);
      }
      
      public function gotoBattle() : void
      {
         this.gotoAndStop(Timeline.BATTLE);
      }
      
      public function gotoPanel() : void
      {
         Central.main.stopMusic();
         this.gotoAndStop(Timeline.PANEL);
      }
      
      public function gotoMCPlayer() : void
      {
         this.gotoAndStop(Timeline.MC_PLAYER);
      }
      
      public function gotoEngage() : void
      {
         this.gotoAndStop(Timeline.ENGAGE);
      }
      
      public function gotoMapMission(evt:Event = null) : void
      {
         this.gotoAndStop(Timeline.MAP_MISSION);
      }
      
      private function onPreloader() : void
      {
         this.stop();
      }
      
      private function onLogin() : void
      {
      }
      
      private function onSelchar() : void
      {
         if(AppData.type != AppData.RR)
         {
            this["rr_selectCharMC"].visible = false;
         }
         else
         {
            this["selectCharMC"].visible = false;
         }
         this.stop();
      }
      
      private function onInit() : void
      {
         this.stop();
         Central.main.preloadData();
      }
      
      private function onMap() : void
      {
         Central.main.callGoogleAnalytics("Login","OnMap",Central.main.getMainChar().getDBChar().character_id);
         this.stop();
         this["mapHolder"].addChild(this.mapMc);
         this["menuHolder"].addChild(this.mapMenuMc);
         Central.main.onEnterMap();
      }
      
      public function onShowAdminMessage() : void
      {
         this["popupAdminMessage"]["text"].text = Central.main.adminMessage;
      }
      
      private function onBattle() : void
      {
         this.stop();
         this["menuHolder"].addChild(this.mapMenuMc);
         this["tutorialHintMc"].visible = false;
      }
      
      private function onPanel() : void
      {
         this.stop();
         Central.main.showPanel();
      }
      
      private function onMCPlayer() : void
      {
         this.stop();
         this["mcHolder"].addChild(Central.main.cinematicsMc);
      }
      
      private function onEngage() : void
      {
         this.stop();
         if(Central.main.MISSION_ENGAGE_RESET == true || Central.main.MISSION_ENGAGE_RESET == null)
         {
            this.engageMc = null;
            GF.removeAllChild(this["engageHolder"]);
            Central.main.MISSION_ENGAGE_RESET = false;
         }
         if(Central.main.MISSION_ENGAGE_BG == null || Central.main.MISSION_ENGAGE_BG == "")
         {
            Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         }
         if(this.engageMc == null)
         {
            Central.main.loadSwf(["swf/library/" + Central.main.MISSION_ENGAGE_BG + ".swf"],this.loadEngageFinish);
         }
         else
         {
            this["engageHolder"].addChild(this.engageMc);
            this.engageMc.show();
         }
      }
      
      private function onMapMission() : void
      {
         this.stop();
      }
      
      public function showError() : void
      {
         var errorCode:* = "";
         var errorMsg:String = "";
         if(int(Central.main.errorCode) > 0)
         {
            errorCode = "(Error " + Central.main.errorCode + ")";
         }
         if(Central.main.errorCode == "1100")
         {
            errorMsg = Central.main.errorMessage;
         }
         else
         {
            errorMsg = Central.main.errorData.getErrorString(Central.main.errorCode);
         }
         if(Central.main.errorCode == "2000")
         {
            MovieClip(this.parent)["errorMc"].show2000(errorCode,errorMsg);
         }
         else
         {
            MovieClip(this.parent)["errorMc"].show(errorCode,errorMsg);
         }
         this.stop();
         Mixer.getInstance().muteAll();
      }
      
      private function loadEngageFinish(swfObj:Object) : void
      {
         if(Central.main.MISSION_ENGAGE_BG == null || Central.main.MISSION_ENGAGE_BG == "")
         {
            Central.main.MISSION_ENGAGE_BG = MissionData.ENGAGE_BG;
         }
         this.engageMc = swfObj["swf/library/" + Central.main.MISSION_ENGAGE_BG + ".swf"];
         this.onEngage();
      }
      
      private function onFBConnect(_msg:String) : void
      {
         Out.debug(this,"sns connected, initializing login info...");
         Central.sns.fbConnector.conn.initData(this.onFbLogin);
      }
      
      private function onFbLogin(_user:Object) : void
      {
         Out.debug(this,"got login info... " + _user + " :: loggin in...");
         if(_user)
         {
            FBUser.uid = _user.uid;
            FBUser.username = _user.name;
            if(_user.pic_square)
            {
               FBUser.pic = _user.pic_square;
            }
            Central.main.amfClient.service("SystemService.requireLogin",[this.loaderInfo.parameters.time,this.loaderInfo.parameters.hash_time,FBUser.uid],this.requireLoginResponse);
            Central.main.callJS("validateDomain");
            this.validTimer = new Timer(8000,1);
            this.validTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.validTimer.start();
         }
         else
         {
            Central.main.onError("0","Oops! Sorry, there is an error connecting to Facebook server. Please refresh this page or try again later.");
         }
      }
      
      private function onTimerComplete(evt:TimerEvent) : void
      {
         if(!Central.main.validLogin)
         {
            Central.main.onError("303","");
         }
         this.validTimer.reset();
         this.validTimer.stop();
         this.validTimer = null;
      }
      
      private function requireLoginResponse(response:Object) : void
      {
         if(!Central.main.validateAmfResponse(response))
         {
            return;
         }
         var salt:String = response.result;
         var strToEncrypt:String = salt + String(FBUser.uid) + AppData.type + String(Data.BUILD_NO) + this.codeLibrary.codec;
         var hash:String = Central.main.getLoginHash(salt,strToEncrypt);
         Central.main.ACCESS_TOKEN = this.loaderInfo.parameters.fb_at;
         Central.main.amfClient.service("SystemService.snsLogin",[FBUser.uid,AppData.type,Data.BUILD_NO,salt,hash,this.loaderInfo.parameters.fb_sig,this.loaderInfo.parameters.fb_at,AppData.lang],this.onAmfLoginResult);
      }
      
      private function login(sessionKey:String) : void
      {
         var salt:String = "";
         var strToEncrypt:String = salt + String(sessionKey) + AppData.type + String(Data.BUILD_NO) + this.codeLibrary.codec;
         var hash:String = Central.main.getLoginHash(salt,strToEncrypt);
         switch(AppData.type)
         {
            case AppData.RR:
               Central.main.amfClient.service("SystemService.snsLogin",[sessionKey,Data.BUILD_NO],this.onAmfLoginResult);
               break;
            default:
               Central.main.amfClient.service("SystemService.snsLogin",[sessionKey,AppData.type,Data.BUILD_NO,salt,hash,AppData.lang],this.onAmfLoginResult);
         }
      }
      
      private function onAmfLoginResult(result:Object) : void
      {
         var swfToLoad:Array = null;
         if(!Central.main.validateAmfResponse(result))
         {
            return;
         }
         var loginResult:Array = result.result as Array;
         var signature:String = result.signature;
         Central.main.country_area = result.country_area;
         Central.main.isNewAccount = result.isNewAccount;
         Central.main.promoteId = result.promote_id;
         if(result.isTrialEmblem == 1)
         {
            Central.main.isTrailEmblem = true;
            if(result.isExpired == 1)
            {
               Central.main.isExpired = true;
            }
         }
         var accountLockObj:Object = result.account_lock as Object;
         if(accountLockObj != null)
         {
            Central.main.paymentStatus = accountLockObj.status;
            Central.main.paymentTitle = accountLockObj.title;
            Central.main.paymentText = accountLockObj.reason;
            Central.main.showLearnMoreBtn = accountLockObj.showLearnMoreBtn;
            switch(AppData.lang)
            {
               case AppData.ZH:
                  Central.main.showNewLockPopup = Central.main.paymentTitle == "賬單出現問題"?true:false;
                  break;
               default:
                  Central.main.showNewLockPopup = Central.main.paymentTitle == "New Payment Cancelled"?true:false;
            }
            if(Central.main.paymentTitle.toLocaleLowerCase().indexOf("title:") == 0)
            {
               Central.main.paymentTitle = Central.main.paymentTitle.substring(6);
            }
            else
            {
               if(String(Central.main.paymentText).length <= 0)
               {
                  Central.main.paymentText = Central.main.langLib.get(953);
               }
               if(Central.main.paymentText.toLocaleLowerCase().indexOf("hack") >= 0)
               {
                  Central.main.paymentTitle = Central.main.langLib.get(1724)[3];
               }
               else
               {
                  Central.main.paymentTitle = Central.main.langLib.get(1724)[2];
               }
            }
         }
         else
         {
            Central.main.paymentStatus = false;
         }
         if(AppData.type == AppData.RR)
         {
            Central.main.RR_SESSION_KEY = this.loaderInfo.parameters.rr_session_key;
            Central.main.ACCESS_TOKEN = Central.main.RR_SESSION_KEY;
         }
         if(Account.setupAccount(loginResult,signature))
         {
            Central.main.dataParser.parseVersionData(result.swf_versions);
            swfToLoad = [];
            swfToLoad.push({
               "path":"swf/language/data_library_" + AppData.lang + ".swf",
               "version":AppData.dataVer
            });
            this["preloader"].loadSwfByVersion(swfToLoad,this.loadDataFinish,null,Central.main.langLib.get(314));
            Central.main.accRegTutStatus = result.account_registered_tutored;
            Central.main.accRegActiveStatus = result.account_registered_password;
         }
         else
         {
            Central.main.showInfo(Central.main.langLib.get(310));
         }
      }
      
      private function loadDataFinish(swfObj:Object) : void
      {
         Central.main.dataLib = swfObj["swf/language/data_library_" + AppData.lang + ".swf"];
         Central.main.checkAmf();
      }
      
      public function getAsset(str:String) : *
      {
         var c:Class = Class(getDefinitionByName(str));
         return new c();
      }
      
      private function createFPStextField() : void
      {
         this.fpsTxt.width = 76;
         this.fpsTxt.height = 32;
         this.fpsTxt.x = 960 - this.fpsTxt.width - 2;
         this.fpsTxt.y = 780 - this.fpsTxt.height - 2;
         this.fpsTxt.name = "fpsTxt";
         this.fpsTxt.text = "";
         var newFormat:TextFormat = new TextFormat();
         newFormat.bold = false;
         newFormat.size = 24;
         newFormat.color = 16711680;
         newFormat.align = TextFormatAlign.LEFT;
         newFormat.font = "Arial";
         this.fpsTxt.defaultTextFormat = newFormat;
         this.addChild(this.fpsTxt);
      }
      
      private function performFrameTest(e:Event) : void
      {
         frames = frames + 1;
         curTimer = getTimer();
         if(curTimer - prevTimer >= 1000)
         {
            this["fpsTxt"].text = String("fps:" + frames);
            prevTimer = curTimer;
            frames = 0;
         }
      }
      
      private function _checkMouseEventTrail($e:MouseEvent) : void
      {
         var p:* = $e.target;
         while(p)
         {
            trace(">>",p.name,": ",p);
            p = p.parent;
         }
      }
   }
}
