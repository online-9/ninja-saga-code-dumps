package ninjasaga
{
   import de.polygonal.ds.HashMap;
   import flash.display.Sprite;
   import ninjasaga.asset.A_Face;
   import ninjasaga.asset.A_BodySet;
   import flash.display.MovieClip;
   import ninjasaga.asset.A_Weapon;
   import ninjasaga.asset.A_BackItem;
   import ninjasaga.asset.A_Accessory;
   import ninjasaga.asset.A_Sound;
   
   public class Asset
   {
      
      private static var instance:ninjasaga.Asset;
       
      
      private var bodySetStorage:HashMap;
      
      private var weaponStroage:HashMap;
      
      private var backitemStroage:HashMap;
      
      private var accessoryStroage:HashMap;
      
      public function Asset(pKey:SingletonBlocker)
      {
         bodySetStorage = new HashMap();
         weaponStroage = new HashMap();
         backitemStroage = new HashMap();
         accessoryStroage = new HashMap();
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Asset.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.Asset
      {
         if(instance == null)
         {
            instance = new ninjasaga.Asset(new SingletonBlocker());
         }
         return instance;
      }
      
      public function getFace(faceId:String, skinColor:Number = -1) : Sprite
      {
         return new A_Face(faceId,skinColor);
      }
      
      private function getClothing(setId:String, gender:int) : A_BodySet
      {
         var aBodySet:A_BodySet = null;
         var key:String = setId + "_" + gender;
         if(this.bodySetStorage.containsKey(key))
         {
            aBodySet = this.bodySetStorage.find(key);
         }
         else
         {
            aBodySet = new A_BodySet(setId,gender);
            this.bodySetStorage.insert(key,aBodySet);
         }
         return aBodySet;
      }
      
      public function getBodyPart(setId:String, gender:int, part:String, skinColor:Number = -1) : Sprite
      {
         return this.getClothing(setId,gender).getPart(part,skinColor);
      }
      
      public function getClothingIcon(setId:String) : MovieClip
      {
         var gender:int = Central.main.getMainChar().getGender();
         if(setId != "set1")
         {
            if(Central.main.BODY_SET_BOY[setId] == null)
            {
               gender = 1;
            }
            else
            {
               gender = 0;
            }
         }
         return this.getClothing(setId,gender).getIcon();
      }
      
      private function getWeaponStroage(wpnId:String) : A_Weapon
      {
         var aWeapon:A_Weapon = null;
         var key:String = wpnId;
         if(this.weaponStroage.containsKey(key))
         {
            aWeapon = this.weaponStroage.find(key);
         }
         else
         {
            aWeapon = new A_Weapon(wpnId);
            this.weaponStroage.insert(key,aWeapon);
         }
         return aWeapon;
      }
      
      public function getWeaponGraphic(wpnId:String) : MovieClip
      {
         return this.getWeaponStroage(wpnId).getDisplay();
      }
      
      public function getWeaponIcon(wpnId:String) : MovieClip
      {
         return this.getWeaponStroage(wpnId).getIcon();
      }
      
      private function getBackItemStroage(backId:String) : A_BackItem
      {
         var aBackItem:A_BackItem = null;
         var key:String = backId;
         if(this.backitemStroage.containsKey(key))
         {
            aBackItem = this.backitemStroage.find(key);
         }
         else
         {
            aBackItem = new A_BackItem(backId);
            this.backitemStroage.insert(key,aBackItem);
         }
         return aBackItem;
      }
      
      public function getBackItemGraphic(backId:String) : MovieClip
      {
         return this.getBackItemStroage(backId).getDisplay();
      }
      
      public function getBackItemIcon(backId:String) : MovieClip
      {
         return this.getBackItemStroage(backId).getIcon();
      }
      
      private function getAccessoryStroage(acsyId:String) : A_Accessory
      {
         var aAccessory:A_Accessory = null;
         var key:String = acsyId;
         if(this.accessoryStroage.containsKey(key))
         {
            aAccessory = this.accessoryStroage.find(key);
         }
         else
         {
            aAccessory = new A_Accessory(acsyId);
            this.accessoryStroage.insert(key,aAccessory);
         }
         return aAccessory;
      }
      
      public function getAccessoryGraphic(acsyId:String) : MovieClip
      {
         return this.getAccessoryStroage(acsyId).getDisplay();
      }
      
      public function getAccessoryIcon(acsyId:String) : MovieClip
      {
         return this.getAccessoryStroage(acsyId).getIcon();
      }
      
      public function loadSound(swfName:String, className:String, callback:Function) : void
      {
         new A_Sound(swfName,className,callback);
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
