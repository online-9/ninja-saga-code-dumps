package bitemycode.security
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   public dynamic class Obfuscated extends Proxy
   {
       
      
      private var _multiples:Object;
      
      private var _additives:Object;
      
      private var _subtractives:Object;
      
      private var _values:Object;
      
      public function Obfuscated()
      {
         _multiples = {};
         _additives = {};
         _subtractives = {};
         _values = {};
         super();
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         return _hasProperty(name);
      }
      
      private function _hasProperty(name:*) : Boolean
      {
         var n:* = null;
         var propfound:Boolean = false;
         for(n in _multiples)
         {
            if(n == name)
            {
               propfound = true;
               break;
            }
         }
         return propfound;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         if(value is int == false && value is Number == false)
         {
            return;
         }
         if(_hasProperty(name) == false)
         {
            _multiples[name] = Math.random() < 0.5?2:3;
            _additives[name] = Math.floor(Math.random() * 100);
            _subtractives[name] = Math.floor(Math.random() * 100000);
         }
         _values[name] = value * _multiples[name] + _additives[name] - _subtractives[name];
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var fn:* = undefined;
         if(_hasProperty(name) == false)
         {
            return 0;
         }
         fn = _values[name];
         fn = fn + _subtractives[name];
         fn = fn - _additives[name];
         fn = fn / _multiples[name];
         return fn;
      }
   }
}
