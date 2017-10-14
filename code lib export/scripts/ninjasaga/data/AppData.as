package ninjasaga.data
{
   public final class AppData
   {
      
      public static const FB:String = "facebook";
      
      public static const OK:String = "orkut";
      
      public static const MP:String = "myspace";
      
      public static const YM:String = "minik";
      
      public static const RR:String = "renren";
      
      public static const EN:String = "en";
      
      public static const ZH:String = "zh";
      
      public static const ES:String = "es";
      
      public static const DE:String = "de";
      
      public static const CN:String = "cn";
      
      public static const PT:String = "pt";
      
      public static const TH:String = "th";
      
      public static const SUPPORTED_LANGUAGE:Array = [EN,ZH,ES,DE,CN,PT,TH];
      
      public static const FANPAGE_EN:String = "https://www.facebook.com/pages/Ninja-Saga/315390295169855";
      
      public static const FANPAGE_ES:String = "https://www.facebook.com/pages/Ninja-Saga-Espa%C3%B1ol/245425318867553";
      
      public static const FANPAGE_ZH:String = "https://www.facebook.com/pages/%E5%BF%8D%E8%80%85%E5%82%B3%E8%AA%AA/155835877865597";
      
      private static var applicationType:String;
      
      private static var applicationLanguage:String;
      
      public static var dataVer:String;
       
      
      public function AppData()
      {
         super();
      }
      
      public static function set type(_type:String) : void
      {
         applicationType = _type;
      }
      
      public static function get type() : String
      {
         return applicationType;
      }
      
      public static function set lang(_lang:String) : void
      {
         applicationLanguage = _lang;
      }
      
      public static function get lang() : String
      {
         return applicationLanguage;
      }
      
      public static function get connectorPath() : String
      {
         switch(AppData.type)
         {
            case AppData.YM:
               return "swf/sns/minik_connector.swf";
            default:
               return null;
         }
      }
   }
}
