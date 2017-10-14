package ninjasaga
{
   import ninjasaga.graphic.G_Character;
   import flash.display.MovieClip;
   
   public final class GraphicController
   {
      
      private static var instance:ninjasaga.GraphicController;
       
      
      private var gCharacter:G_Character;
      
      public function GraphicController(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use GraphicController.getInstance() instead of new.");
         }
         this.gCharacter = new G_Character();
      }
      
      public static function getInstance() : ninjasaga.GraphicController
      {
         if(instance == null)
         {
            instance = new ninjasaga.GraphicController(new SingletonBlocker());
         }
         return instance;
      }
      
      public function setupFace(mc:MovieClip, faceId:String, skinColor:Number) : void
      {
         this.gCharacter.setupFace(mc,faceId,skinColor);
      }
      
      public function setSkinColor(mc:MovieClip, skinColor:Number) : void
      {
         this.gCharacter.setFaceColor(mc,skinColor);
         this.gCharacter.setBodySetColor(mc,skinColor);
      }
      
      public function setupBodySet(mc:MovieClip, setId:String, gender:int, skinColor:Number) : void
      {
         this.gCharacter.setupBodySet(mc,setId,gender,skinColor);
      }
      
      public function setupWeapon(mc:MovieClip, wpnId:String) : void
      {
         this.gCharacter.setupWeapon(mc,wpnId);
      }
      
      public function setupBackItem(mc:MovieClip, backId:String) : void
      {
         this.gCharacter.setupBackItem(mc,backId);
      }
      
      public function unSetupBackItem(mc:MovieClip) : void
      {
         this.gCharacter.unSetupBackitem(mc);
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
