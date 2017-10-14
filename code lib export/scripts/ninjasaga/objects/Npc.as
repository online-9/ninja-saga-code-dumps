package ninjasaga.objects
{
   import ninjasaga.base.CharacterBattle;
   import flash.display.MovieClip;
   import com.utils.GF;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.Timeline;
   import ninjasaga.Central;
   import com.utils.NumberUtil;
   
   public class Npc extends CharacterBattle
   {
      
      private static var npcList:Object = new Object();
      
      private static var npcMCList:Object = {};
       
      
      private var _npcObj:Object;
      
      private var _npcDataId:int = 0;
      
      private var _pet:ninjasaga.objects.Pet;
      
      public function Npc(npcObj:Object)
      {
         _npcObj = new Object();
         super();
         this.type = this.TYPE_NPC;
         this._npcObj = npcObj;
         this.actionBase = getNpcSwf(npcObj);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.swf.addChild(actionBase);
         this.dbChar = this.actionBase.dbChar;
         this.dbChar.character_id = Math.round(NumberUtil.randomNumber(0,1000000));
         this.restoreOriginalStatus();
      }
      
      public static function addNpcSwf(swfName:String, swf:MovieClip) : void
      {
         npcList[swfName] = swf;
      }
      
      public static function getNpcSwf(npcObj:Object) : MovieClip
      {
         var mc:MovieClip = null;
         var i:uint = 0;
         var swf:MovieClip = npcList[npcObj.swfName];
         var mcArr:Array = npcMCList[npcObj.clsName];
         if(mcArr == null)
         {
            mcArr = [];
         }
         else
         {
            for(i = 0; i < mcArr.length; i++)
            {
               if(mcArr[i].parent == null)
               {
                  mc = mcArr[i];
                  break;
               }
            }
         }
         if(mc == null)
         {
            mc = GF.getAsset(swf,npcObj.clsName);
            npcMCList[npcObj.clsName] = mcArr;
         }
         return mc;
      }
      
      public static function hasNpcSwf(_swfName:String) : Boolean
      {
         if(npcList[_swfName] == null)
         {
            return false;
         }
         return true;
      }
      
      override public function get maxHP() : uint
      {
         return this.dbChar.character_max_hp;
      }
      
      override public function get maxCP() : uint
      {
         return this.dbChar.character_max_cp;
      }
      
      override public function setBattleAction(_battleAction:Object = null) : void
      {
         var battleAction:Object = null;
         if(_battleAction)
         {
            this.battleAction = _battleAction;
         }
         else if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
         {
            battleAction = {"action":"pass"};
            this.battleAction = battleAction;
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
         }
         else if(this.isBattleDebuffActive(BattleData.SKILL_377))
         {
            battleAction = {"action":"pass"};
            this.battleAction = battleAction;
            this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(325));
         }
         else
         {
            this.battleAction = this.actionBase.getBattleAction();
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(npcList[this._npcObj.swfName],"StaticFullBody");
      }
      
      public function get pet() : ninjasaga.objects.Pet
      {
         return this._pet;
      }
      
      public function get npcObj() : Object
      {
         return _npcObj;
      }
      
      private function set npcObj(newValue:Object) : void
      {
         _npcObj = newValue;
      }
      
      public function get npcDataId() : int
      {
         return _npcDataId;
      }
      
      public function set npcDataId(newValue:int) : void
      {
         _npcDataId = newValue;
      }
   }
}
