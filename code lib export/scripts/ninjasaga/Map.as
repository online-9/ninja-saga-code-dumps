package ninjasaga
{
   import flash.display.MovieClip;
   
   public final class Map
   {
      
      private static var _map:MovieClip;
       
      
      public function Map()
      {
         super();
      }
      
      public static function get map() : MovieClip
      {
         return _map;
      }
      
      public static function set map(mc:MovieClip) : void
      {
         _map = mc;
      }
   }
}
