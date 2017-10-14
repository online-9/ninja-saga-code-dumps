package com.utils
{
   public class Delegate
   {
       
      
      public function Delegate()
      {
         super();
      }
      
      public static function create(scope_obj:Object, func:Function, ... userArguments_array) : Function
      {
         var returnObject:Object = function():*
         {
            var self:Object = arguments.callee;
            var arguments_array:Array = arguments;
            var scope_obj:Object = self.scope_obj;
            var func:Function = self.func;
            var userArguments_array:Array = self.userArguments_array;
            return func.apply(scope_obj,arguments_array.concat(userArguments_array));
         };
         returnObject.scope_obj = scope_obj;
         returnObject.func = func;
         returnObject.userArguments_array = userArguments_array;
         var returnFunction:Function = returnObject as Function;
         return returnFunction;
      }
   }
}
