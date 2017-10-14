package ninjasaga.asset
{
   import ninjasaga.Central;
   import com.utils.Out;
   import flash.display.MovieClip;
   import ninjasaga.loader.AssetLoader;
   import com.utils.GF;
   
   public class A_Accessory
   {
       
      
      public var acsyId:String;
      
      private var swf:MovieClip;
      
      private var displayList:Array;
      
      private const iconExportName:String = "icon";
      
      private const accessoryExportName:String = "accessory";
      
      public function A_Accessory(_acsyId:String)
      {
         displayList = [];
         super();
         this.acsyId = _acsyId;
         var swfPath:String = getSwfPath(_acsyId);
         new AssetLoader(swfPath,null,null,this.onLoadComplete);
      }
      
      private static function getSwfPath(acsyId:String) : String
      {
         var swfName:String = null;
         var accessoryData:Object = Central.main.ACCESSORY_DATA.find(acsyId);
         if(accessoryData)
         {
            swfName = accessoryData.swfName;
            return "swf/items/" + swfName + ".swf";
         }
         Out.debug("A_Accessory","getSwfPath :: backId >> " + acsyId);
         return null;
      }
      
      private function onLoadComplete(assetLoader:AssetLoader) : void
      {
         this.swf = assetLoader.swf;
         this.refreshDisplay();
      }
      
      private function refreshDisplay() : void
      {
         var iconHolder:MovieClip = null;
         if(null == this.swf)
         {
            return;
         }
         while(this.displayList.length > 0)
         {
            iconHolder = this.displayList.shift();
            try
            {
               GF.removeAllChild(iconHolder);
               iconHolder.addChild(GF.getAsset(this.swf,iconHolder.exportName));
            }
            catch(err:Error)
            {
               Out.error(this,"refreshDisplay :: displayList :: " + err.getStackTrace());
               continue;
            }
         }
      }
      
      public function getDisplay() : MovieClip
      {
         return this.getItem(this.accessoryExportName);
      }
      
      public function getIcon() : MovieClip
      {
         return this.getItem(this.iconExportName,true);
      }
      
      private function getItem(exportName:String, isIcon:Boolean = false) : MovieClip
      {
         var iconHolder:MovieClip = new MovieClip();
         if(isIcon)
         {
            iconHolder = Central.main.getLib("LoadingMc");
         }
         iconHolder.exportName = exportName;
         this.displayList.push(iconHolder);
         this.refreshDisplay();
         return iconHolder;
      }
   }
}
