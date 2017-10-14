package ninjasaga
{
   import de.polygonal.ds.HashMap;
   import bitemycode.net.zendamf.ZendAMFClient;
   import flash.events.ErrorEvent;
   import ninjasaga.data.Data;
   import com.utils.Out;
   import ninjasaga.data.DBCharacterData;
   
   public class AMFConnector
   {
      
      private static var instance:ninjasaga.AMFConnector;
       
      
      private var restrictedServices:HashMap;
      
      public var lastService:String;
      
      public function AMFConnector(pKey:SingletonBlocker)
      {
         restrictedServices = new HashMap();
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use AMFConnector.getInstance() instead of new.");
         }
         this.restrictedServices.insert("CharacterService.updateCharacter",[Character]);
         this.restrictedServices.insert("Achievement.updateData",[Battle]);
         this.restrictedServices.insert("CharacterValidation.validateSkill",[Character]);
      }
      
      public static function getInstance() : ninjasaga.AMFConnector
      {
         if(instance == null)
         {
            instance = new ninjasaga.AMFConnector(new SingletonBlocker());
         }
         return instance;
      }
      
      public function initAmf() : void
      {
         var client:ZendAMFClient = ZendAMFClient.getInstance();
         client.addEventListener(ErrorEvent.ERROR,this.onFault);
         if(!client.isConnected())
         {
            client.connect(Data.AMF_GATEWAY);
         }
      }
      
      private function onFault(fault:ErrorEvent) : void
      {
         Out.error(this," AMF Client :: " + fault.text);
         Main.hideAmfLoading();
         Main.onError("2000");
         var charId:* = 0;
         if(Central.main.getMainChar())
         {
            charId = Central.main.getMainChar().getData(DBCharacterData.ID);
         }
         this.service("ReportService.reportAmfError2",[Central.main.account.getAccountSessionKey(),Central.main.account.getAccountId(),charId,this.lastService,fault.text.substring(0,fault.text.length > 2000?Number(2000):Number(fault.text.length))],Central.main.reportServiceResponse);
      }
      
      public function service(_serviceName:String, _args:Array, _callBackFn:Function, _source:Object = null) : void
      {
         var i:int = 0;
         var allowed:Boolean = false;
         var allowedSource:Array = null;
         Main.tracking.trackAmfService(_serviceName);
         this.lastService = _serviceName;
         var serviceKeys:Array = this.restrictedServices.getKeySet();
         if(_source == null)
         {
            if(serviceKeys.indexOf(_serviceName) >= 0)
            {
               Out.error(this,"service :: cannot connect >> " + _serviceName);
               Main.onError("2001");
               return;
            }
            ZendAMFClient.getInstance().service(_serviceName,_args,_callBackFn);
         }
         else if(serviceKeys.indexOf(_serviceName) >= 0)
         {
            allowed = false;
            allowedSource = this.restrictedServices.find(_serviceName);
            if(_source.constructor)
            {
               for(i = 0; i < allowedSource.length; i++)
               {
                  if(allowedSource[i] == _source.constructor)
                  {
                     allowed = true;
                     break;
                  }
               }
            }
            if(allowed == true)
            {
               ZendAMFClient.getInstance().service(_serviceName,_args,_callBackFn);
            }
            else
            {
               Out.error(this,"service :: cannot connect (" + _source + ") >> " + _serviceName);
               Main.onError("2001");
               return;
            }
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
