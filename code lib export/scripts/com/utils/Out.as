package com.utils
{
   import de.polygonal.ds.LinkedQueue;
   
   public final class Out
   {
      
      public static const QUEUE_SIZE:uint = 50;
      
      public static var logger:LinkedQueue = new LinkedQueue();
      
      private static var _dataLogger:LinkedQueue = new LinkedQueue();
       
      
      public function Out()
      {
         super();
      }
      
      public static function debug(src:*, msg:String) : void
      {
         trace("Out :: Debug :: " + src + " :: " + msg);
      }
      
      public static function error(src:*, msg:String) : void
      {
         var logTrace:String = "Out :: Error :: " + src + " :: " + msg;
         if(logger.size < QUEUE_SIZE)
         {
            logger.enqueue(logTrace);
         }
         else
         {
            logger.dequeue();
            logger.enqueue(logTrace);
         }
         trace(logTrace);
      }
      
      public static function data(src:*, msg:String) : void
      {
         var logTrace:String = "Out :: Data :: " + src + " :: " + msg;
         if(_dataLogger.size < QUEUE_SIZE)
         {
            _dataLogger.enqueue(logTrace);
         }
         else
         {
            _dataLogger.dequeue();
            _dataLogger.enqueue(logTrace);
         }
      }
      
      public static function getLoggerDump() : String
      {
         return logger.dump();
      }
      
      public static function get dataLogger() : String
      {
         return _dataLogger.dump();
      }
   }
}
