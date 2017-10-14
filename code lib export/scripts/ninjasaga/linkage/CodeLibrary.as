package ninjasaga.linkage
{
   import flash.display.MovieClip;
   import ninjasaga.Main;
   
   public class CodeLibrary extends MovieClip
   {
       
      
      public const codec:String = "85224034668";
      
      public function CodeLibrary()
      {
         super();
      }
      
      public function setMainMc(mainMc:MovieClip) : void
      {
         Main.setMainMc(mainMc);
         Main.initAmf();
         Main.cls = String(this.loaderInfo.bytesLoaded);
      }
   }
}
