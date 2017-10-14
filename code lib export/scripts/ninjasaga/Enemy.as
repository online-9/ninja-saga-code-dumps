package ninjasaga
{
   import ninjasaga.base.CharacterBattle;
   import flash.display.MovieClip;
   import com.utils.GF;
   import flash.utils.getTimer;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.BloodlineData;
   import ninjasaga.data.Timeline;
   import com.utils.Out;
   import com.utils.NumberUtil;
   
   public class Enemy extends CharacterBattle
   {
      
      private static var enemyList:Object = new Object();
      
      private static var enemyMCList:Object = {};
       
      
      private var _enemyObj:Object;
      
      public function Enemy(enemyObj:Object)
      {
         _enemyObj = new Object();
         super();
         this.type = this.TYPE_ENEMY;
         this.battleAction = null;
         this._enemyObj = enemyObj;
         this.actionBase = getEnemySwf(enemyObj);
         if(this.actionBase == null)
         {
            Out.debug(this,"actionBase >>  null");
         }
         Out.debug(this,"actionBase >> " + this.actionBase);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.effectResistance = this.actionBase.getEffectResistance();
         this.swf.addChild(actionBase);
         if(enemyObj.limb)
         {
            this.limb = enemyObj.limb;
         }
         this.dbChar = this.actionBase.dbChar;
         if(enemyObj.PvEID)
         {
            this.dbChar.character_id = enemyObj.PvEID;
         }
         else
         {
            this.dbChar.character_id = Math.round(NumberUtil.randomNumber(0,1000000));
         }
         this.restoreOriginalStatus();
      }
      
      public static function addEnemySwf(swfName:String, swf:MovieClip) : void
      {
         enemyList[swfName] = swf;
      }
      
      public static function getEnemySwf(enemyObj:Object) : MovieClip
      {
         var mc:MovieClip = null;
         var i:uint = 0;
         var init:int = 0;
         var swf:MovieClip = enemyList[enemyObj.swfName];
         var mcArr:Array = enemyMCList[enemyObj.clsName];
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
         while(mc == null)
         {
            mc = GF.getAsset(swf,enemyObj.clsName);
            enemyMCList[enemyObj.clsName] = mcArr;
            if(mc == null)
            {
               init = getTimer();
               while(getTimer() - init < 1000)
               {
               }
            }
         }
         return mc;
      }
      
      public static function hasEnemySwf(_swfName:String) : Boolean
      {
         if(enemyList[_swfName] == null)
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
      
      override public function get maxSP() : uint
      {
         return 0;
      }
      
      public function get rewardGold() : uint
      {
         return this.actionBase.rewardGold;
      }
      
      public function get rewardXP() : uint
      {
         return this.actionBase.rewardXP;
      }
      
      public function get rewardConsumable() : Object
      {
         return this.actionBase.rewardConsumable;
      }
      
      public function get rewardItem() : Object
      {
         return this.actionBase.rewardItem;
      }
      
      override public function setBattleAction(_battleAction:Object = null) : void
      {
         var battleAction:Object = null;
         if(_battleAction)
         {
            this.battleAction = _battleAction;
            if(this.battleAction.effect != null && this.battleAction.effect == "healing")
            {
               this.updateHP(this.battleAction.dmg);
               this.updateBattleFrame();
            }
         }
         else
         {
            if(this.isBattleDebuffActive(BattleData.EFFECT_BUNDLE))
            {
               battleAction = {"action":"pass"};
               this.battleAction = battleAction;
            }
            else if(this.isBattleDebuffActive(BattleData.SKILL_377))
            {
               battleAction = {"action":"pass"};
               this.battleAction = battleAction;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_MERIDIANS_SEAL))
            {
               battleAction = {"action":"pass"};
               this.battleAction = battleAction;
            }
            else if(this.isBattleDebuffActive(BattleData.EFFECT_ECSTATIC_SOUND))
            {
               battleAction = {"action":"pass"};
               this.battleAction = battleAction;
            }
            else if(this.isBattleDebuffActive(BloodlineData.EFFECT_MERIDIAN_BLOCK))
            {
               battleAction = {"action":"pass"};
               this.battleAction = battleAction;
               this.showOverheadNumber(Timeline.WORD,Central.main.langLib.get(743));
            }
            else
            {
               this.battleAction = this.actionBase.getBattleAction();
            }
            switch(this.battleAction.target)
            {
               case "self":
                  Battle.setDefender(this);
            }
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(enemyList[this._enemyObj.swfName],"StaticFullBody");
      }
      
      public function getActionBase() : MovieClip
      {
         return this.actionBase;
      }
      
      public function get enemyObj() : Object
      {
         return this._enemyObj;
      }
      
      private function set enemyObj(newEneObj:Object) : void
      {
         this._enemyObj = newEneObj;
      }
   }
}
