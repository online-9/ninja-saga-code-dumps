package ninjasaga
{
   import flash.display.MovieClip;
   import de.polygonal.ds.HashMap;
   import ninjasaga.data.Timeline;
   import com.utils.Out;
   
   public class Panel
   {
      
      private static var instance:ninjasaga.Panel;
      
      private static var panelObj:Object = {};
       
      
      private var curPanelName:String = "";
      
      private var panelFrame:String;
      
      private var _recruitCharCache:HashMap;
      
      private var _recruitedCharacters:Array;
      
      private var _challengeCharCache:HashMap;
      
      private var _challengedCharacters:Array;
      
      private var _visitCharacterId:uint = 0;
      
      private var _visitFacebookId:String = "";
      
      public function Panel(pKey:SingletonBlocker)
      {
         _recruitCharCache = new HashMap();
         _recruitedCharacters = [];
         _challengeCharCache = new HashMap();
         _challengedCharacters = [];
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Panel.getInstance() instead of new.");
         }
         this.curPanelName = "";
      }
      
      public static function getInstance() : ninjasaga.Panel
      {
         if(instance == null)
         {
            instance = new ninjasaga.Panel(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function hasPanel(_name:String) : Boolean
      {
         var panel:MovieClip = panelObj[_name];
         if(panel != null)
         {
            return true;
         }
         return false;
      }
      
      public function show(_panelName:String, frame:String = null) : void
      {
         if(Main.checkGameStatus() == Timeline.BATTLE)
         {
            Main.showInfo(Main.langLib.get(607));
            return;
         }
         if(Mission.onMission() != null)
         {
            Main.showInfo(Main.langLib.get(608));
            return;
         }
         var prevPanelName:String = this.curPanelName;
         this.curPanelName = _panelName;
         this.panelFrame = frame;
         if(Main.checkGameStatus() == Timeline.PANEL)
         {
            if(prevPanelName == "academy")
            {
               Main.getPanel().stopTrainingTimer();
            }
            Main.removePanel(Main.getPanel());
            this.onShowPanel();
         }
         else
         {
            Main.gotoPanel();
         }
      }
      
      public function onShowPanel() : void
      {
         if(!ninjasaga.Panel.hasPanel(this.curPanelName))
         {
            Main.loadSwf(["swf/panels/" + this.curPanelName + ".swf"],this.onInitFinish);
         }
      }
      
      private function onInitFinish(_swfObj:Object) : void
      {
         var panelSwf:MovieClip = _swfObj["swf/panels/" + this.curPanelName + ".swf"];
         Main.addPanel(panelSwf);
         if(this.panelFrame == null)
         {
            if("show" in panelSwf)
            {
               panelSwf.show();
            }
            else
            {
               Main.onError("302");
            }
         }
         else
         {
            panelSwf.show(this.panelFrame);
         }
      }
      
      public function hide(_panelSwf:MovieClip) : void
      {
         _panelSwf.gotoAndStop(Timeline.IDLE);
         Main.removePanel(_panelSwf);
         Main.gotoMap();
      }
      
      public function reshow() : void
      {
         this.onShowPanel();
      }
      
      public function get curPanel() : MovieClip
      {
         return Main.getPanel();
      }
      
      public function getCurPanelName() : String
      {
         return this.curPanelName;
      }
      
      public function emptyRecruitCharCache() : void
      {
         Out.debug(this,"emptyRecruitCharCache");
         this._recruitCharCache = null;
         this._recruitCharCache = new HashMap();
      }
      
      public function get recruitCharCache() : HashMap
      {
         return this._recruitCharCache;
      }
      
      public function get challengeCharCache() : HashMap
      {
         return this._challengeCharCache;
      }
      
      public function addRecruitCharCache(data:HashMap) : void
      {
         var i:uint = 0;
         var keys:Array = data.getKeySet();
         for(i = 0; i < keys.length; i++)
         {
            Out.debug(this,"addRecruitCharCache :: caching keys[" + i + "] " + keys[i]);
            this._recruitCharCache.insert(String(keys[i]),data.find(keys[i]));
         }
      }
      
      public function addChallengeCharCache(data:HashMap) : void
      {
         var i:uint = 0;
         var keys:Array = data.getKeySet();
         for(i = 0; i < keys.length; i++)
         {
            Out.debug(this,"addChallengeCharCache :: caching keys[" + i + "] " + keys[i]);
            this._challengeCharCache.insert(String(keys[i]),data.find(keys[i]));
         }
      }
      
      public function updateRecruitCharCache(key:String, data:Array) : void
      {
         this._recruitCharCache.insert(key,data);
      }
      
      public function updateChallengeCharCache(key:String, data:Array) : void
      {
         this._challengeCharCache.insert(key,data);
      }
      
      public function get recruitedCharacters() : Array
      {
         return this._recruitedCharacters;
      }
      
      public function setRecruited(charId:uint) : void
      {
         this._recruitedCharacters.push(charId);
      }
      
      public function get challengedCharacters() : Array
      {
         return this._challengedCharacters;
      }
      
      public function setChallenged(charId:uint) : void
      {
         this._challengedCharacters.push(charId);
      }
      
      public function set visitCharacterId(charId:uint) : void
      {
         this._visitCharacterId = charId;
      }
      
      public function get visitCharacterId() : uint
      {
         return this._visitCharacterId;
      }
      
      public function set visitFacebookId(facebookId:String) : void
      {
         this._visitFacebookId = facebookId;
      }
      
      public function get visitFacebookId() : String
      {
         return this._visitFacebookId;
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
