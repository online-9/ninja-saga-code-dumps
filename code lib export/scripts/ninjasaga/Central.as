package ninjasaga
{
   public class Central
   {
      
      private static var _main;
      
      private static var _battle;
      
      private static var _skill;
      
      private static var _panel;
      
      private static var _mission;
      
      private static var _map;
      
      private static var _token;
      
      private static var _sns;
      
      private static var _clan;
      
      private static var _socket;
      
      private static var _client;
       
      
      public function Central()
      {
         super();
      }
      
      public static function set main(m:*) : void
      {
         _main = m;
      }
      
      public static function set battle(b:*) : void
      {
         _battle = b;
      }
      
      public static function set skill(s:*) : void
      {
         _skill = s;
      }
      
      public static function set panel(p:*) : void
      {
         _panel = p;
      }
      
      public static function set mission(m:*) : void
      {
         _mission = m;
      }
      
      public static function set map(m:*) : void
      {
         _map = m;
      }
      
      public static function set token(t:*) : void
      {
         _token = t;
      }
      
      public static function set sns(s:*) : void
      {
         _sns = s;
      }
      
      public static function set clan(c:*) : void
      {
         _clan = c;
      }
      
      public static function set socket(s:*) : void
      {
         _socket = s;
      }
      
      public static function set client(c:*) : void
      {
         _client = c;
      }
      
      public static function get main() : *
      {
         return _main;
      }
      
      public static function get battle() : *
      {
         return _battle;
      }
      
      public static function get skill() : *
      {
         return _skill;
      }
      
      public static function get panel() : *
      {
         return _panel;
      }
      
      public static function get mission() : *
      {
         return _mission;
      }
      
      public static function get map() : *
      {
         return _map;
      }
      
      public static function get token() : *
      {
         return _token;
      }
      
      public static function get sns() : *
      {
         return _sns;
      }
      
      public static function get clan() : *
      {
         return _clan;
      }
      
      public static function get socket() : *
      {
         return _socket;
      }
      
      public static function get client() : *
      {
         return _client;
      }
   }
}
