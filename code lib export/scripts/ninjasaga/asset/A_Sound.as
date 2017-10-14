package ninjasaga.asset
{
   import flash.display.MovieClip;
   import com.utils.GF;
   import flash.media.Sound;
   import com.utils.Mixer;
   import ninjasaga.loader.AssetLoader;
   import ninjasaga.data.Data;
   
   public class A_Sound
   {
       
      
      private var swfName:String;
      
      private var className:String;
      
      private var callback:Function;
      
      private var swf:MovieClip;
      
      public function A_Sound(swfName:String, className:String, callback:Function)
      {
         var path:String = null;
         super();
         this.swfName = swfName;
         this.className = className;
         this.callback = callback;
         path = Data.genSwfFilePath("sound",this.swfName);
         new AssetLoader(path,null,null,this.onLoadComplete);
      }
      
      public function play() : void
      {
         var sound:Sound = GF.getAsset(this.swf,this.className);
         var soundArr:Array = [];
         soundArr.push(sound);
         Mixer.getInstance().playMusic(soundArr);
      }
      
      public function stop() : void
      {
         Mixer.getInstance().stopMusic();
      }
      
      private function onLoadComplete(assetLoader:AssetLoader) : void
      {
         this.swf = assetLoader.swf;
         this.callback(this);
      }
   }
}
