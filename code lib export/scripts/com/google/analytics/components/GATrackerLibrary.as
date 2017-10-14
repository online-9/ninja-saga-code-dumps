package com.google.analytics.components
{
   import flash.display.MovieClip;
   import com.google.analytics.utils.Version;
   import com.google.analytics.API;
   
   public class GATrackerLibrary extends MovieClip
   {
      
      public static var version:Version = API.version;
       
      
      public function GATrackerLibrary()
      {
         super();
      }
   }
}
