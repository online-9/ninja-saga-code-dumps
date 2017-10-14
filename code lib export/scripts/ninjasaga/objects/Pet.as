package ninjasaga.objects
{
   import ninjasaga.base.CharacterBattle;
   import flash.display.MovieClip;
   import com.utils.Out;
   import com.utils.GF;
   import ninjasaga.Main;
   import ninjasaga.data.BattleData;
   import ninjasaga.data.Timeline;
   import ninjasaga.Central;
   import ninjasaga.data.DBCharacterData;
   import com.utils.Sha1Encrypt;
   import ninjasaga.data.Formula;
   import ninjasaga.dbclass.DBCharacter;
   
   public class Pet extends CharacterBattle
   {
       
      
      public var id:uint;
      
      public var swfName:String;
      
      public var clsName:String;
      
      private var _loadedSwf:MovieClip;
      
      private var petXpStr:String;
      
      private var _training:Object;
      
      private var verifyTrainingPet_CB:Function;
      
      private var _maturity:int;
      
      private var _requiredMaturity:int;
      
      private var _requiredLevel:int;
      
      private var _requirement:String;
      
      private var _petEP:int;
      
      public function Pet(petCharData:DBCharacter, swfName:String, clsName:String)
      {
         super();
         this.type = this.TYPE_PET;
         this.dbChar = petCharData;
         this.dbChar[DBCharacterData.LEVEL] = Formula.getPetLvByXp(this.dbChar[DBCharacterData.XP]);
         this.swfName = swfName;
         this.clsName = clsName;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var petArr:Array = Central.main.PET_DATA.toArray();
         for(var i:int = 0; i < petArr.length; i++)
         {
            if(petArr[i].swfName == this.swfName)
            {
               this.id = uint(petArr[i].id);
               this.dbChar[DBCharacterData.PET_MAX_EP] = uint(petArr[i].ep_max);
               break;
            }
         }
      }
      
      public function set loadedSwf(loadedSwf:MovieClip) : void
      {
         var i:uint = 0;
         Out.debug(this,this.getCharacterId() + " :: loadedSwf");
         this._loadedSwf = loadedSwf;
         this.actionBase = GF.getAsset(this._loadedSwf,this.clsName);
         Out.debug(this,"loadedSwf=" + this._loadedSwf + ", clsName=" + this.clsName);
         this.actionBase.setActionFinishCB(this.actionFinish_CB);
         this.actionBase.setAttackHitCB(this.attackHit_CB);
         this.setupAvailableSkills();
         this.setupDamage();
         var skillData:Array = this.actionBase.skillData;
         for(i = 0; i < skillData.length; i++)
         {
            if(skillData[i])
            {
               if(Number(skillData[i].damageBonus) > Main.coreData.PET_MAX_DAMAGE_BONUS)
               {
                  Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                  Main.onError();
               }
            }
         }
      }
      
      override public function setBattleAction(_battleAction:Object = null) : void
      {
         var battleAction:Object = null;
         if(this.securityCheck())
         {
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
               this.battleAction = this.actionBase.getBattleAction(this.petId);
            }
         }
         if(this.battleAction)
         {
            if(this.battleAction.dmg)
            {
               if(Main.petExtraDmg)
               {
                  if(Math.abs(int(this.battleAction.dmg)) > Math.round(Main.coreData.PET_MAX_DAMAGE_PER_LEVEL * this.getLevel() + Main.petExtraDmgAmount) || this.isEquipped() && this.getLevel() > Main.getMainChar().getLevel())
                  {
                     Main.petExtraDmgAmount = 0;
                     Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                     Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                     Main.onError("2974","");
                  }
               }
               else if(Math.abs(int(this.battleAction.dmg)) > Math.round(Main.coreData.PET_MAX_DAMAGE_PER_LEVEL * this.getLevel()) || this.isEquipped() && this.getLevel() > Main.getMainChar().getLevel())
               {
                  Out.error(this,"Error >> " + Main.coreData.PET_DAMAGE_ERROR);
                  Main.getMainChar().datafileHack = Main.coreData.PET_DAMAGE_ERROR;
                  Main.onError("2974","");
               }
            }
         }
      }
      
      public function getStaticFullBody() : MovieClip
      {
         return GF.getAsset(this._loadedSwf,"StaticFullBody");
      }
      
      public function getPetIcon() : MovieClip
      {
         return GF.getAsset(this._loadedSwf,"icon");
      }
      
      public function get xp() : uint
      {
         return this.getData(DBCharacterData.XP);
      }
      
      public function trainUpdateXP(_xp:uint) : Boolean
      {
         if(_xp < 0)
         {
            _xp = 0;
         }
         if(_xp == 0)
         {
            return false;
         }
         this.dbChar.character_xp = this.dbChar.character_xp + _xp;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var level:uint = Formula.getPetLvByXp(this.xp);
         if(level > this.dbChar.character_level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            return true;
         }
         if(this.dbChar.character_level > level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            Main.saveCharacter();
         }
         return false;
      }
      
      public function updateXP(_xp:uint) : Boolean
      {
         if(Main.getMainChar().pet == null)
         {
            return false;
         }
         if(this.getData(DBCharacterData.ID) != Main.getMainChar().pet.getData(DBCharacterData.ID))
         {
            return false;
         }
         if(_xp < 0)
         {
            _xp = 0;
         }
         if(_xp == 0)
         {
            return false;
         }
         if(!this.securityCheck())
         {
            return false;
         }
         this.dbChar.character_xp = this.dbChar.character_xp + _xp;
         this.petXpStr = Sha1Encrypt.encrypt(String(this.xp));
         var level:uint = Formula.getPetLvByXp(this.xp);
         if(level > this.dbChar.character_level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            this.setupDamage();
            return true;
         }
         if(this.dbChar.character_level > level)
         {
            this.dbChar.character_level = level;
            this.restoreOriginalStatus();
            Main.saveCharacter();
         }
         return false;
      }
      
      public function get skillData() : Array
      {
         Out.debug("Pet",".actionBase >> " + this.actionBase);
         return this.actionBase.skillData;
      }
      
      public function getSkillIcon(id:uint) : MovieClip
      {
         return GF.getAsset(this._loadedSwf,this.skillData[id].cls);
      }
      
      public function setupAvailableSkills() : void
      {
         this.actionBase.setupAvailableSkills(this.getData(DBCharacterData.SKILLS));
      }
      
      public function setupDamage() : void
      {
         this.actionBase.setupDamage(this.getLevel());
      }
      
      public function getDamage() : int
      {
         return this.actionBase.getDamage();
      }
      
      public function getPetId() : uint
      {
         return this.dbChar.character_id;
      }
      
      public function get petId() : uint
      {
         return this.dbChar.character_id;
      }
      
      public function isEquipped() : Boolean
      {
         if(Main.getMainChar().pet)
         {
            if(Main.getMainChar().pet.petId == this.dbChar.character_id)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function securityCheck() : Boolean
      {
         var _xpSha1String:String = Sha1Encrypt.encrypt(String(this.xp));
         if(_xpSha1String != this.petXpStr)
         {
            Main.saveLog(1,String(this.xp));
            Main.onError();
            return false;
         }
         return true;
      }
      
      public function resetSkillCooldown() : void
      {
         this.actionBase.resetSkillCooldown();
      }
      
      public function get training() : Object
      {
         return _training;
      }
      
      public function set training(obj:Object) : void
      {
         this._training = obj;
      }
      
      public function get maturity() : int
      {
         return _maturity;
      }
      
      public function set maturity(gp:int) : void
      {
         this._maturity = gp;
      }
      
      public function get requiredMaturity() : int
      {
         return _requiredMaturity;
      }
      
      public function set requiredMaturity(rgp:int) : void
      {
         this._requiredMaturity = rgp;
      }
      
      public function get requiredLevel() : int
      {
         return _requiredLevel;
      }
      
      public function set requiredLevel(lv:int) : void
      {
         this._requiredLevel = lv;
      }
      
      public function get requirement() : String
      {
         return _requirement;
      }
      
      public function set requirement(r:String) : void
      {
         this._requirement = r;
      }
      
      public function get petEP() : int
      {
         return this._petEP;
      }
      
      public function set petEP(ep:int) : void
      {
         this._petEP = ep;
      }
      
      public function decRemainTimer() : Boolean
      {
         if(this._training)
         {
            if(this._training.remainTimer)
            {
               if(this._training.remainTimer > 0)
               {
                  this._training.remainTimer--;
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getPetClassName() : String
      {
         return this.clsName;
      }
   }
}
