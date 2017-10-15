package com.utils 
{
    import de.polygonal.ds.*;
    
    public final class Out extends Object
    {
        public function Out()
        {
            super();
            return;
        }

        public static function debug(arg1:*, arg2:String):void
        {
            trace("Out :: Debug :: " + arg1 + " :: " + arg2);
            return;
        }

        public static function error(arg1:*, arg2:String):void
        {
            var loc1:*;
            loc1 = "Out :: Error :: " + arg1 + " :: " + arg2;
            if (logger.size < QUEUE_SIZE)
            {
                logger.enqueue(loc1);
            }
            else 
            {
                logger.dequeue();
                logger.enqueue(loc1);
            }
            trace(loc1);
            return;
        }

        public static function data(arg1:*, arg2:String):void
        {
            var loc1:*;
            loc1 = "Out :: Data :: " + arg1 + " :: " + arg2;
            if (_dataLogger.size < QUEUE_SIZE)
            {
                _dataLogger.enqueue(loc1);
            }
            else 
            {
                _dataLogger.dequeue();
                _dataLogger.enqueue(loc1);
            }
            return;
        }

        public static function getLoggerDump():String
        {
            return logger.dump();
        }

        public static function get dataLogger():String
        {
            return _dataLogger.dump();
        }

        
        {
            logger = new de.polygonal.ds.LinkedQueue();
            _dataLogger = new de.polygonal.ds.LinkedQueue();
        }

        public static const QUEUE_SIZE:uint=50;

        public static var logger:de.polygonal.ds.LinkedQueue;

        private static var _dataLogger:de.polygonal.ds.LinkedQueue;
    }
}
