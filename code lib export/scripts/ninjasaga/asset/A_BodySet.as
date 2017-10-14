package ninjasaga.asset
{
   import ninjasaga.Central;
   import com.utils.Out;
   import flash.display.MovieClip;
   import ninjasaga.loader.AssetLoader;
   import com.utils.GF;
   import flash.display.Sprite;
   
   public class A_BodySet
   {
       
      
      public var setId:String;
      
      private var gender:int;
      
      private var swf:MovieClip;
      
      private var displayList:Array;
      
      private var displayIconList:Array;
      
      private const iconExportName:String = "icon";
      
      public function A_BodySet(setId:String, gender:int)
      {
         displayList = [];
         displayIconList = [];
         super();
         this.setId = setId;
         this.gender = gender;
         var swfPath:String = getSwfPath(setId,this.gender);
         new AssetLoader(swfPath,null,null,this.onLoadComplete);
      }
      
      private static function getSwfPath(setId:String, gender:int) : String
      {
         var swfName:String = null;
         var BODY_SET_DATA:Object = gender == 0?Central.main.BODY_SET_BOY:Central.main.BODY_SET_GIRL;
         var bodySetData:Object = BODY_SET_DATA[setId];
         if(bodySetData)
         {
            swfName = bodySetData.swfName;
            return "swf/items/" + swfName + ".swf";
         }
         Out.debug("A_BodySet","getSwfPath :: setId >> " + setId);
         return null;
      }
      
      private function onLoadComplete(assetLoader:AssetLoader) : void
      {
         this.swf = assetLoader.swf;
         this.refreshDisplay();
      }
      
      private function refreshDisplay() : void
      {
         var bodyPart:BodyPart = null;
         var iconHolder:MovieClip = null;
         if(null == this.swf)
         {
            return;
         }
         while(this.displayList.length > 0)
         {
            bodyPart = this.displayList.shift();
            bodyPart.setSwf(this.swf);
         }
         while(this.displayIconList.length > 0)
         {
            iconHolder = this.displayIconList.shift();
            try
            {
               GF.removeAllChild(iconHolder);
               iconHolder.addChild(GF.getAsset(this.swf,this.iconExportName));
            }
            catch(err:Error)
            {
               Out.error(this,"refreshDisplay :: displayIconList :: " + err.getStackTrace());
               continue;
            }
         }
      }
      
      public function getPart(part:String, skinColor:Number = -1) : Sprite
      {
         var bodyPart:BodyPart = new BodyPart(part,skinColor);
         this.displayList.push(bodyPart);
         this.refreshDisplay();
         return bodyPart;
      }
      
      public function getIcon() : MovieClip
      {
         var iconHolder:MovieClip = Central.main.getLib("LoadingMc");
         this.displayIconList.push(iconHolder);
         this.refreshDisplay();
         return iconHolder;
      }
   }
}

import flash.display.Sprite;
import flash.display.MovieClip;
import com.utils.GF;
import com.utils.Out;

class BodyPart extends Sprite
{
    
   
   private var partName:String;
   
   private var skinColor:Number = -1;
   
   private var displayObj:MovieClip;
   
   function BodyPart(part:String, skinColor:Number)
   {
      super();
      this.partName = part;
      this.skinColor = skinColor;
   }
   
   public function setSwf(swf:MovieClip) : void
   {
      try
      {
         this.displayObj = GF.getAsset(swf,this.partName);
         this.setColor(this.skinColor);
         this.addChild(this.displayObj);
      }
      catch(e:Error)
      {
         Out.error(this,"BodyPart :: " + e.getStackTrace());
      }
   }
   
   public function setColor(skinColor:Number) : void
   {
      if(this.displayObj && this.skinColor > 0)
      {
         if(this.displayObj["skin_color"])
         {
            GF.changeColor(this.displayObj["skin_color"],skinColor);
         }
      }
   }
}
