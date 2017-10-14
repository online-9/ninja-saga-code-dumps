package com.google.analytics.campaign
{
   import com.google.analytics.utils.Variables;
   
   public class CampaignTracker
   {
       
      
      public var content:String;
      
      public var source:String;
      
      public var clickId:String;
      
      public var name:String;
      
      public var term:String;
      
      public var medium:String;
      
      public var id:String;
      
      public function CampaignTracker(id:String = "", source:String = "", clickId:String = "", name:String = "", medium:String = "", term:String = "", content:String = "")
      {
         super();
         this.id = id;
         this.source = source;
         this.clickId = clickId;
         this.name = name;
         this.medium = medium;
         this.term = term;
         this.content = content;
      }
      
      public function isValid() : Boolean
      {
         if(id != "" || source != "" || clickId != "")
         {
            return true;
         }
         return false;
      }
      
      public function toTrackerString() : String
      {
         var data:Array = [];
         _addIfNotEmpty(data,"utmcsr=",source);
         _addIfNotEmpty(data,"utmccn=",name);
         _addIfNotEmpty(data,"utmcmd=",medium);
         _addIfNotEmpty(data,"utmctr=",term);
         _addIfNotEmpty(data,"utmcct=",content);
         _addIfNotEmpty(data,"utmcid=",id);
         _addIfNotEmpty(data,"utmgclid=",clickId);
         return data.join(CampaignManager.trackingDelimiter);
      }
      
      private function _addIfNotEmpty(arr:Array, field:String, value:String) : void
      {
         if(value != "")
         {
            value = value.split("+").join("%20");
            value = value.split(" ").join("%20");
            arr.push(field + value);
         }
      }
      
      public function fromTrackerString(tracker:String) : void
      {
         var data:String = tracker.split(CampaignManager.trackingDelimiter).join("&");
         var vars:Variables = new Variables(data);
         if(vars.hasOwnProperty("utmcid"))
         {
            this.id = vars["utmcid"];
         }
         if(vars.hasOwnProperty("utmcsr"))
         {
            this.source = vars["utmcsr"];
         }
         if(vars.hasOwnProperty("utmccn"))
         {
            this.name = vars["utmccn"];
         }
         if(vars.hasOwnProperty("utmcmd"))
         {
            this.medium = vars["utmcmd"];
         }
         if(vars.hasOwnProperty("utmctr"))
         {
            this.term = vars["utmctr"];
         }
         if(vars.hasOwnProperty("utmcct"))
         {
            this.content = vars["utmcct"];
         }
         if(vars.hasOwnProperty("utmgclid"))
         {
            this.clickId = vars["utmgclid"];
         }
      }
   }
}
