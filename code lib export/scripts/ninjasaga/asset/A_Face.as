package ninjasaga.asset
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import com.utils.GF;
   import ninjasaga.loader.AssetLoader;
   
   public class A_Face extends Sprite
   {
       
      
      public var faceId:String;
      
      private var swfPath:String;
      
      private var skinColor:Number = -1;
      
      private var displayMc:MovieClip;
      
      private var exportName:String = "face";
      
      public function A_Face(faceId:String, skinColor:Number)
      {
         super();
         this.faceId = faceId;
         this.skinColor = skinColor;
         this.swfPath = getSwfPath(this.faceId);
         new AssetLoader(this.swfPath,this,this.exportName,this.onLoadComplete);
      }
      
      public static function getSwfPath(faceId:String) : String
      {
         var swfName:String = faceId;
         return "swf/items/" + swfName + ".swf";
      }
      
      public function setColor(skinColor:Number) : void
      {
         this.skinColor = skinColor;
         if(this.displayMc && this.skinColor > 0)
         {
            GF.changeColor(this.displayMc["skin_color"],this.skinColor);
         }
      }
      
      private function onLoadComplete(assetLoader:AssetLoader) : void
      {
         this.displayMc = assetLoader.displayObj;
         this.setColor(this.skinColor);
      }
   }
}
