package ninjasaga 
{
    public class Central extends Object
    {
        public function Central()
        {
            super();
            return;
        }

        public static function get main():*
        {
            return _main;
        }

        public static function set token(arg1:*):void
        {
            _token = arg1;
            return;
        }

        public static function get panel():*
        {
            return _panel;
        }

        public static function get sns():*
        {
            return _sns;
        }

        public static function set panel(arg1:*):void
        {
            _panel = arg1;
            return;
        }

        public static function get mission():*
        {
            return _mission;
        }

        public static function get skill():*
        {
            return _skill;
        }

        public static function get clan():*
        {
            return _clan;
        }

        public static function set mission(arg1:*):void
        {
            _mission = arg1;
            return;
        }

        public static function get map():*
        {
            return _map;
        }

        public static function set skill(arg1:*):void
        {
            _skill = arg1;
            return;
        }

        public static function set clan(arg1:*):void
        {
            _clan = arg1;
            return;
        }

        public static function set battle(arg1:*):void
        {
            _battle = arg1;
            return;
        }

        public static function set main(arg1:*):void
        {
            _main = arg1;
            return;
        }

        public static function set sns(arg1:*):void
        {
            _sns = arg1;
            return;
        }

        public static function get battle():*
        {
            return _battle;
        }

        public static function get token():*
        {
            return _token;
        }

        public static function set map(arg1:*):void
        {
            _map = arg1;
            return;
        }

        private static var _panel:Object;

        private static var _token:Object;

        private static var _mission:Object;

        private static var _skill:Object;

        private static var _battle:Object;

        private static var _sns:Object;

        private static var _map:Object;

        private static var _main:Object;

        private static var _clan:Object;
    }
}
