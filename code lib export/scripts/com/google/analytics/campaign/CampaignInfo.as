package com.google.analytics.campaign
{
   import com.google.analytics.utils.Variables;
   
   public class CampaignInfo
   {
       
      
      private var _new:Boolean;
      
      private var _empty:Boolean;
      
      public function CampaignInfo(empty:Boolean = true, newCampaign:Boolean = false)
      {
         super();
         _empty = empty;
         _new = newCampaign;
      }
      
      public function toURLString() : String
      {
         var v:Variables = toVariables();
         return v.toString();
      }
      
      public function isNew() : Boolean
      {
         return _new;
      }
      
      public function get utmcn() : String
      {
         return "1";
      }
      
      public function isEmpty() : Boolean
      {
         return _empty;
      }
      
      public function toVariables() : Variables
      {
         var variables:Variables = new Variables();
         variables.URIencode = true;
         if(!isEmpty() && isNew())
         {
            variables.utmcn = utmcn;
         }
         if(!isEmpty() && !isNew())
         {
            variables.utmcr = utmcr;
         }
         return variables;
      }
      
      public function get utmcr() : String
      {
         return "1";
      }
   }
}
