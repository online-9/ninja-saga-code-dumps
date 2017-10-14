package bitemycode.net.zendamf
{
   import flash.events.EventDispatcher;
   import flash.net.NetConnection;
   import de.polygonal.ds.HashMap;
   import flash.utils.Timer;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ErrorEvent;
   import flash.net.Responder;
   import flash.events.TimerEvent;
   import flash.events.Event;
   
   public class ZendAMFClient extends EventDispatcher
   {
      
      private static var instance:bitemycode.net.zendamf.ZendAMFClient;
      
      private static var gateway:String;
      
      private static var connection:NetConnection;
      
      private static var serviceArr:Array = [];
      
      private static var curService:Object = null;
      
      private static var onService:Boolean = false;
      
      private static var sendAgain:Boolean = false;
      
      private static var lastService:Object = [];
      
      private static var retryNum:int = 0;
       
      
      private var _serviceQueue:HashMap;
      
      private var _onQueuedService:Boolean = false;
      
      private var _queuedServiceTimer:Timer;
      
      private var retryServiceTimer:Timer;
      
      public function ZendAMFClient(pKey:SingletonBlocker)
      {
         _serviceQueue = new HashMap();
         _queuedServiceTimer = new Timer(10000,1);
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use ZendAMFClient.getInstance() instead of new.");
         }
         gateway = "";
         connection = new NetConnection();
      }
      
      public static function getInstance() : bitemycode.net.zendamf.ZendAMFClient
      {
         if(instance == null)
         {
            instance = new bitemycode.net.zendamf.ZendAMFClient(new SingletonBlocker());
         }
         return instance;
      }
      
      public function connect(_gateway:String) : void
      {
         gateway = _gateway;
         try
         {
            connection.connect(gateway);
            connection.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
            connection.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         }
         catch(err:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
         }
      }
      
      public function queuedService(_serviceName:String, _args:Array, _callBackFn:Function) : void
      {
         try
         {
            _serviceQueue.insert(_serviceName,{
               "serviceName":_serviceName,
               "args":_args,
               "callBackFn":_callBackFn
            });
            runQueue();
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"queuedServie Error:" + e.getStackTrace()));
         }
      }
      
      public function service(_serviceName:String, _args:Array, _callBackFn:Function) : void
      {
         serviceArr.push({
            "serviceName":_serviceName,
            "args":_args,
            "callBackFn":_callBackFn
         });
         if(!onService)
         {
            process();
         }
      }
      
      private function localCallBack(result:Object) : void
      {
         curService.callBackFn(result);
         process();
      }
      
      private function process() : void
      {
         var _serviceName:String = null;
         var _args:Array = null;
         var responder:Responder = null;
         var args:Array = null;
         if(gateway == "")
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
         }
         else if(serviceArr.length > 0)
         {
            onService = true;
            curService = serviceArr.shift();
            lastService = curService;
            _serviceName = curService.serviceName;
            _args = curService.args;
            responder = new Responder(localCallBack,onFault);
            args = new Array(_serviceName,responder);
            try
            {
               connection.call.apply(null,args.concat(_args));
            }
            catch(err:Error)
            {
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Error:" + err.message));
            }
         }
         else
         {
            onService = false;
            retryNum = 0;
         }
      }
      
      private function runQueue() : void
      {
         try
         {
            if(gateway == "")
            {
               dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"Connection not available"));
            }
            else if(!this._onQueuedService)
            {
               this._onQueuedService = true;
               this._queuedServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processQueuedService);
               this._queuedServiceTimer.start();
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"runQueue Error:" + e.getStackTrace()));
         }
      }
      
      private function processQueuedService(evt:TimerEvent) : void
      {
         var qServiceArr:Array = null;
         var i:uint = 0;
         var obj:Object = null;
         try
         {
            this._queuedServiceTimer.stop();
            this._queuedServiceTimer.reset();
            if(this._serviceQueue.size > 0)
            {
               qServiceArr = this._serviceQueue.toArray();
               this._serviceQueue.clear();
               this._onQueuedService = false;
               for(i = 0; i < qServiceArr.length; i++)
               {
                  obj = qServiceArr[i];
                  this.service(obj.serviceName,obj.args,obj.callBackFn);
               }
            }
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processQueuedService Error:" + e.getStackTrace()));
         }
      }
      
      public function isConnected() : Boolean
      {
         return gateway == ""?false:true;
      }
      
      private function onFault(fault:Object) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,fault.description));
         process();
      }
      
      override public function dispatchEvent(evt:Event) : Boolean
      {
         if(hasEventListener(evt.type) || evt.bubbles)
         {
            return super.dispatchEvent(evt);
         }
         return true;
      }
      
      public function netStatusHandler(evt:NetStatusEvent) : void
      {
         var random:int = 0;
         if((evt.info.description.indexOf("503") > -1 || evt.info.description.indexOf("502") > -1) && retryNum < 4)
         {
            onService = false;
            retryNum++;
            random = Math.floor(Math.random() * (7000 - 3000 + 1)) + 3000;
            retryServiceTimer = new Timer(random,1);
            retryServiceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processRetryService);
            retryServiceTimer.start();
         }
         else
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"NetStatus Error:" + evt.info.code));
            process();
         }
      }
      
      private function processRetryService(evt:TimerEvent) : void
      {
         try
         {
            this.retryServiceTimer.stop();
            service(lastService.serviceName,lastService.args,lastService.callBackFn);
         }
         catch(e:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"processRetryService Error:" + e.getStackTrace()));
         }
      }
      
      public function securityErrorHandler(evt:SecurityErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Security Error:" + evt.text));
         process();
      }
      
      public function ioErrorHandler(evt:IOErrorEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"IO Error:" + evt.text));
         process();
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
