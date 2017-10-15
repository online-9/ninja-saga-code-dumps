package ninjasaga.data 
{
    public final class AppData extends Object
    {
        public function AppData()
        {
            super();
            return;
        }

        public static function set type(arg1:String):void
        {
            applicationType = arg1;
            return;
        }

        public static function get type():String
        {
            return applicationType;
        }

        public static function set lang(arg1:String):void
        {
            applicationLanguage = arg1;
            return;
        }

        public static function get lang():String
        {
            return applicationLanguage;
        }

        public static function get connectorPath():String
        {
            var loc1:*;
            loc1 = ninjasaga.data.AppData.type;
            switch (loc1) 
            {
                case ninjasaga.data.AppData.YM:
                {
                    return "swf/sns/minik_connector.swf";
                }
            }
            return null;
        }

        public static const FB:String="facebook";

        public static const OK:String="orkut";

        public static const MP:String="myspace";

        public static const YM:String="minik";

        public static const RR:String="renren";

        public static const EN:String="en";

        public static const ZH:String="zh";

        public static const ES:String="es";

        public static const DE:String="de";

        public static const CN:String="cn";

        public static const PT:String="pt";

        public static const TH:String="th";

        public static const SUPPORTED_LANGUAGE:Array=[EN, ZH, ES, DE, CN, PT, TH];

        public static const FANPAGE_EN:String="https://www.facebook.com/pages/Ninja-Saga/315390295169855";

        public static const FANPAGE_ES:String="https://www.facebook.com/pages/Ninja-Saga-Espa%C3%B1ol/245425318867553";

        public static const FANPAGE_ZH:String="https://www.facebook.com/pages/%E5%BF%8D%E8%80%85%E5%82%B3%E8%AA%AA/155835877865597";

        private static var applicationType:String;

        private static var applicationLanguage:String;

        public static var dataVer:String;
    }
}
