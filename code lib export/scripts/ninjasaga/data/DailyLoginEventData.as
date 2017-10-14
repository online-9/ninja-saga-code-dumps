package ninjasaga.data
{
   import ninjasaga.Central;
   
   public class DailyLoginEventData
   {
      
      private static var LangArr:Array;
      
      private static const GiftArr:Array = Central.main.DailyLoginEventReward;
      
      private static var ServerFunction:String = "Gashapon.claimDailyLogin";
      
      private static const HideBtn:Boolean = true;
      
      private static const PanelLabel:String = "Event_DailyLogin_Gift";
      
      private static const Location:String = "village";
      
      private static const Location_Village:String = "village";
      
      private static const Location_Panel:String = "";
      
      private static const LoadPanelPath:String = "";
      
      private static const langIndex:int = 1722;
       
      
      public function DailyLoginEventData()
      {
         super();
         LangArr = Central.main.langLib.get(langIndex);
      }
      
      public function get dailyLoginLang() : Array
      {
         return LangArr;
      }
      
      public function get dailyLoginGift() : Array
      {
         return GiftArr;
      }
      
      public function get dailyLoginServerFunction() : String
      {
         return ServerFunction;
      }
      
      public function get dailyLoginLocation() : String
      {
         return Location;
      }
      
      public function get dailyLoginLocation_Village() : String
      {
         return Location_Village;
      }
      
      public function get dailyLoginLocation_Panel() : String
      {
         return Location_Panel;
      }
      
      public function get dailyLoginHideBtn() : Boolean
      {
         return HideBtn;
      }
      
      public function get dailyLoginPanelLabel() : String
      {
         return PanelLabel;
      }
      
      public function get dailyLoginLoadPanelPath() : String
      {
         return LoadPanelPath;
      }
   }
}
