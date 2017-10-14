package ninjasaga
{
   import ninjasaga.data.AMFData;
   import ninjasaga.data.TokenData;
   import ninjasaga.data.DBCharacterData;
   import ninjasaga.data.Timeline;
   import com.utils.Out;
   import ninjasaga.data.InventoryData;
   
   public final class Token
   {
      
      private static var instance:ninjasaga.Token;
      
      private static var buyHairId:String;
       
      
      public function Token(pKey:SingletonBlocker)
      {
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Token.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.Token
      {
         if(instance == null)
         {
            instance = new ninjasaga.Token(new SingletonBlocker());
         }
         return instance;
      }
      
      public function resetAP() : void
      {
         Main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.resetAPbyToken",[Account.getAccountSessionKey(),Account.getAccountBalance()],this.resetAPResult);
      }
      
      private function resetAPResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(result.error));
            return;
         }
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_RESET_AP;
         for(var i:int = 0; i < DBCharacterData.ALL_ATTRIBUTE_POINTS.length; i++)
         {
            Main.getMainChar().updateData(DBCharacterData.ALL_ATTRIBUTE_POINTS[i],0);
         }
         if(Main.checkGameStatus() == Timeline.MAP)
         {
            Main.getMainChar().restoreOriginalStatus();
         }
         Main.mapMenu.refreshAP();
         Main.updateMenu();
         Main.hideAmfLoading();
      }
      
      public function recustomization() : void
      {
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_RECUSTOMIZATION;
         Panel.getInstance().curPanel.finalizeCustomization();
         Panel.getInstance().curPanel.saveAppearance();
      }
      
      public function instantTrain() : void
      {
         if(Main.checkGameStatus() == Timeline.PANEL)
         {
            Out.debug("token","Token.as >> stopTrainingTimer :: PANEL");
            Panel.getInstance().curPanel.stopTrainingTimer();
         }
         else
         {
            Out.debug("token","Token.as >> stopTrainingTimer :: mapMenu");
            Main.mapMenu.stopTrainingTimer();
         }
         Main.showAmfLoading();
         Main.amfClient.service("CharacterDAO.instantTrainByToken",[Account.getAccountSessionKey(),Account.getAccountBalance(),Main.getMainChar().trainingSkill.id],this.instantTrainResult);
      }
      
      private function instantTrainResult(result:Object) : void
      {
         if(String(result.status) == AMFData.STATUS_ERROR)
         {
            Main.onError(String(result.error));
            return;
         }
         Account.balance = Account.getAccountBalance() - TokenData.TOKEN_FOR_INSTANT_TRAINING;
         if(Central.main.Features.FEATURE_ESSENCE)
         {
            if(Main.isPopupType == "village")
            {
               Main.hideAmfLoading();
               Main.getMainChar().verifyTrainingSkill(this.callback);
            }
            else if(Main.isPopupType == "gear")
            {
               Main.hideAmfLoading();
               Main.getMainChar().verifyTrainingSkill(this.callback);
            }
            else if(Main.checkGameStatus() == Timeline.PANEL)
            {
               Panel.getInstance().curPanel.finalizeInstantTrain();
            }
            else
            {
               Main.mapMenu.finalizeInstantTrain();
               Main.updateMenu();
            }
         }
         else if(Main.checkGameStatus() == Timeline.PANEL)
         {
            Panel.getInstance().curPanel.finalizeInstantTrain();
         }
         else
         {
            Main.mapMenu.finalizeInstantTrain();
            Main.updateMenu();
         }
      }
      
      private function callback() : void
      {
         Main.updateMapSideBtn();
      }
      
      public function buyHair(_buyHairId:String) : void
      {
         Main.showAmfLoading();
         buyHairId = _buyHairId;
         var signature:String = Central.main.getHash(buyHairId);
         Main.amfClient.service("CharacterManagement.buyHair",[Account.getAccountSessionKey(),Central.main.updateSequence(),signature,buyHairId],this.buyHairResponse);
      }
      
      private function buyHairResponse(response:Object) : void
      {
         var hairObj:Object = null;
         Main.hideAmfLoading();
         if(Main.validateAmfResponse(response))
         {
            Central.main.showInfo(Central.main.langLib.get(26));
            hairObj = Central.main.HAIR_DATA.find(buyHairId);
            Account.balance = Account.getAccountBalance() - hairObj.token;
            Main.getMainChar().setHair("hair_" + hairObj.swfName);
            Main.getMainChar().changeHair(Main.getMainChar().getHair());
            Main.getMainChar().addInventory(InventoryData.TYPE_HAIR,buyHairId);
            Panel.getInstance().curPanel.invHair.push(buyHairId);
            Panel.getInstance().curPanel.updateHairDisplay();
            Panel.getInstance().curPanel.updateGoldDisplay();
            Central.main.tracking.trackSale(Central.main.tracking.SALE_HAIR_STYLE,hairObj.token,buyHairId);
         }
      }
      
      public function saveHairChange(hairId:String) : void
      {
         var signature:String = Central.main.getHash(hairId);
         Main.amfClient.service("CharacterManagement.changeHair",[Central.main.account.getAccountSessionKey(),Main.updateSequence(),signature,hairId],this.saveHairChangeResponse);
      }
      
      private function saveHairChangeResponse(response:Object) : void
      {
         if(!Central.main.validateAmfResponse(response))
         {
         }
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
