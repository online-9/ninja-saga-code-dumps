package com.google.analytics.core
{
   import com.google.analytics.data.X10;
   import com.google.analytics.utils.Variables;
   
   public class EventInfo
   {
       
      
      private var _ext10:X10;
      
      private var _isEventHit:Boolean;
      
      private var _x10:X10;
      
      public function EventInfo(isEventHit:Boolean, xObject:X10, extObject:X10 = null)
      {
         super();
         _isEventHit = isEventHit;
         _x10 = xObject;
         _ext10 = extObject;
      }
      
      public function toURLString() : String
      {
         var v:Variables = toVariables();
         return v.toString();
      }
      
      public function get utmt() : String
      {
         return "event";
      }
      
      public function get utme() : String
      {
         return _x10.renderMergedUrlString(_ext10);
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         if(_isEventHit)
         {
            variables.utmt = utmt;
         }
         variables.utme = utme;
         return variables;
      }
   }
}
