package ninjasaga
{
   import flash.display.MovieClip;
   import com.utils.GF;
   import com.utils.Out;
   import ninjasaga.data.Data;
   import bitemycode.loader.DynamicLoader;
   import ninjasaga.data.TooltipData;
   
   public class Item
   {
      
      private static var itemList:Object = new Object();
       
      
      private var itemSwf:MovieClip;
      
      public var itemId:String;
      
      public function Item(itemId:String)
      {
         super();
         this.itemId = itemId;
      }
      
      public static function setItem(item:Item) : void
      {
         itemList[item.itemId] = item;
      }
      
      public static function getItem(itemId:String) : Item
      {
         var item:Item = itemList[itemId];
         return item;
      }
      
      public static function hasItem(itemId:String) : Boolean
      {
         var item:Item = itemList[itemId];
         if(item != null)
         {
            return true;
         }
         return false;
      }
      
      public static function getWeaponIcon(itemId:String, holder:MovieClip) : void
      {
         GF.removeAllChild(holder);
         holder.addChild(Central.main.asset.getWeaponIcon(itemId));
      }
      
      public static function getClothIcon(itemId:String, holder:MovieClip) : void
      {
         GF.removeAllChild(holder);
         holder.addChild(Central.main.asset.getClothingIcon(itemId));
      }
      
      public static function getBackItemIcon(itemId:String, holder:MovieClip) : void
      {
         GF.removeAllChild(holder);
         holder.addChild(Central.main.asset.getBackItemIcon(itemId));
      }
      
      public static function getAccessoryIcon(itemId:String, holder:MovieClip) : void
      {
         GF.removeAllChild(holder);
         holder.addChild(Central.main.asset.getAccessoryIcon(itemId));
      }
      
      public static function getHairIcon(hairId:String, holder:MovieClip) : void
      {
         var data:Object = Central.main.HAIR_DATA.find(hairId);
         if(Central.main.dataFilter(data) == false)
         {
            return;
         }
         var path:* = "swf/items/hair_" + data.swfName + ".swf";
         new IconLoader(path,holder);
      }
      
      public static function getItemIcon(itemId:String, holder:MovieClip) : void
      {
         GF.removeAllChild(holder);
         var data:Object = Central.main.ITEM_DATA.find(itemId);
         if(Central.main.dataFilter(data) == false)
         {
            return;
         }
         var clsName:String = data.swfName;
         holder.addChild(Central.main.getLib(clsName));
      }
      
      public static function getEssenceIcon(itemId:String, holder:MovieClip) : void
      {
         var clsName:String = null;
         var itemData:Object = Central.main.ESSENCE_DATA.find(itemId);
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         clsName = itemData.swfName;
         if(clsName)
         {
            GF.removeAllChild(holder);
            holder.addChild(Central.main.getLib(clsName));
         }
      }
      
      public static function getCurrencyIcon(itemId:String, holder:MovieClip) : void
      {
         var clsName:String = null;
         var itemData:Object = Central.main.CURRENCY_DATA.find(itemId);
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         clsName = itemData.swfName;
         if(clsName)
         {
            GF.removeAllChild(holder);
            holder.addChild(Central.main.getLib(clsName));
         }
      }
      
      public static function getMaterialIcon(itemId:String, holder:MovieClip) : void
      {
         var clsName:String = null;
         var itemData:Object = Central.main.MATERIAL_DATA.find(itemId);
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         clsName = itemData.swfName;
         if(clsName)
         {
            GF.removeAllChild(holder);
            holder.addChild(Central.main.getLib(clsName));
         }
      }
      
      public static function getSkillIcon(itemId:String, holder:MovieClip) : void
      {
         Out.debug("Item","getSkillIcon :: itemId >> " + itemId);
         var max:int = 0;
         var min:int = 0;
         var skillId:String = String(itemId).slice(6);
         var remain:int = int(skillId) % 10;
         var result:int = int(skillId) / 10;
         if(remain == 0)
         {
            max = int(skillId);
            min = int(max - 9);
         }
         else
         {
            max = int((result + 1) * 10);
            min = int(max - 9);
         }
         Out.debug("Item","getSkillIcon Hank :: >> " + min.toString() + "-" + max.toString());
         var path:String = Data.genSwfFilePath("library/icons",String("skill_icon_" + min.toString() + "-" + max.toString()));
         DynamicLoader.load(path,holder,itemId,null,true);
      }
      
      public static function getWeaponModel(itemId:String, holder:MovieClip, cb_Fn:Function = null) : void
      {
         var itemData:Object = Central.main.WEAPON_DATA.find(itemId);
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         var path:* = "swf/items/" + itemData.swfName + ".swf";
         new ModelLoader(path,"weapon",itemId,holder,cb_Fn);
      }
      
      public static function getBackItemModel(itemId:String, holder:MovieClip, cb_Fn:Function = null) : void
      {
         var itemData:Object = Central.main.BACK_ITEM_DATA.find(itemId);
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         var path:* = "swf/items/" + itemData.swfName + ".swf";
         new ModelLoader(path,"back_item",itemId,holder,cb_Fn);
      }
      
      public static function getBodySetModel(gender:uint, itemId:String, holder:MovieClip, cb_Fn:Function = null) : void
      {
         var path:* = null;
         var itemData:Object = gender == 0?Central.main.BODY_SET_BOY:Central.main.BODY_SET_GIRL;
         if(Central.main.dataFilter(itemData[itemId]) == false)
         {
            return;
         }
         if(itemData[itemId])
         {
            path = "swf/items/" + itemData[itemId].swfName + ".swf";
            new ModelLoader(path,"icon",itemId,holder,cb_Fn);
         }
      }
      
      public static function getPetModel(itemId:String, holder:MovieClip, cb_Fn:Function = null) : void
      {
         var petSwf:String = null;
         var petObj:Object = Central.main.PET_DATA.find("pet" + String(itemId));
         if(petObj)
         {
            petSwf = petObj.swfName;
         }
         var itemData:Object = petObj;
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         var path:* = "swf/pets/" + petSwf + ".swf";
         new ModelLoader(path,"StaticFullBody",itemId,holder,cb_Fn);
      }
      
      public static function getDisplayData(item:String) : Object
      {
         var itemData:Object = null;
         var tooltip:String = null;
         var num:int = 0;
         var type:String = null;
         var pet:* = undefined;
         var loadItem:String = null;
         var petSwf:String = null;
         var idArr:Array = null;
         var petObj:Object = null;
         var path:* = null;
         var petObj1:Object = null;
         var displayMc:MovieClip = Central.main.getLib("LoadingMc");
         var displayFullBodyMc:MovieClip = Central.main.getLib("LoadingMc");
         if(item == "emblem")
         {
            type = "emblem";
            itemData = new Object();
            GF.removeAllChild(displayMc);
            displayMc = Central.main.getLib("emblemIcon");
            tooltip = Central.main.langLib.get(307);
         }
         else if(item.indexOf("trainslot") >= 0)
         {
            type = "trainslot";
            itemData = new Object();
            GF.removeAllChild(displayMc);
            displayMc = Central.main.getLib("trainSlotIcon");
            tooltip = "";
         }
         else if(item.indexOf("gold") >= 0)
         {
            type = "gold";
            itemData = new Object();
            GF.removeAllChild(displayMc);
            displayMc = Central.main.getLib("GoldIcon");
            displayMc["txt"].text = String(item).replace(type,"");
            tooltip = String(item).replace(type,"") + " " + Central.main.langLib.get(1389);
            itemData.name = tooltip;
         }
         else if(item.indexOf("token") >= 0)
         {
            type = "token";
            itemData = new Object();
            GF.removeAllChild(displayMc);
            displayMc = Central.main.getLib("TokenIcon");
            displayMc["txt"].text = String(item).replace(type,"");
            tooltip = String(item).replace(type,"") + " " + Central.main.langLib.get(1390);
            itemData.name = tooltip;
         }
         else if(item.indexOf("MCoin") >= 0)
         {
            type = "MCoin";
            itemData = new Object();
            GF.removeAllChild(displayMc);
            displayMc = Central.main.getLib("MCoinIcon");
            displayMc["txt"].text = String(item).replace(type,"");
            tooltip = String(item).replace(type,"") + " " + Central.main.langLib.get(1390);
            itemData.name = tooltip;
         }
         else if(item.indexOf("wpn") >= 0)
         {
            type = "wpn";
            itemData = Central.main.WEAPON_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getWeaponIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,item);
         }
         else if(item.indexOf("set") >= 0)
         {
            type = "set";
            itemData = Central.main.BODY_SET_BOY[item];
            if(itemData == null)
            {
               itemData = Central.main.BODY_SET_GIRL[item];
            }
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getClothIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,item);
         }
         else if(item.indexOf("back") >= 0)
         {
            type = "back";
            itemData = Central.main.BACK_ITEM_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getBackItemIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,item);
         }
         else if(item.indexOf("acsy") >= 0)
         {
            type = "acsy";
            itemData = Central.main.ACCESSORY_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getAccessoryIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ACCESSORY,item);
         }
         else if(item.indexOf("hair") >= 0)
         {
            type = "hair";
            itemData = Central.main.HAIR_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getHairIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_HAIR,item);
         }
         else if(item.indexOf("item") >= 0 || item.indexOf("material") >= 0)
         {
            if(item.indexOf("material") >= 0)
            {
               loadItem = String(item).replace("material","item");
            }
            else
            {
               loadItem = item;
            }
            type = "item";
            if(itemData = Central.main.ITEM_DATA.find(loadItem))
            {
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               getItemIcon(itemData.id,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,loadItem);
            }
            else if(itemData = Central.main.ESSENCE_DATA.find(loadItem))
            {
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               getEssenceIcon(itemData.id,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,loadItem);
            }
            else if(itemData = Central.main.MATERIAL_DATA.find(loadItem))
            {
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               getMaterialIcon(itemData.id,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_MATERIAL,loadItem);
            }
            else if(itemData = Central.main.CURRENCY_DATA.find(loadItem))
            {
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               getCurrencyIcon(itemData.id,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,loadItem);
            }
         }
         else if(item.indexOf("petskill") >= 0)
         {
            type = "petskill";
            idArr = item.split("_");
            num = int(idArr[1]);
            petObj = Central.main.PET_DATA.find("pet" + String(num));
            if(petObj)
            {
               petSwf = pet.swfName;
               itemData = petObj;
            }
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            path = "swf/pets/" + petSwf + ".swf";
            new ModelLoader(path,"Skill_" + idArr[2],String(num),displayMc);
         }
         else if(item.indexOf("skill") >= 0)
         {
            type = "skill";
            itemData = Central.main.SKILL_DATA[item];
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            displayMc = Central.main.getLib(itemData.swfName);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,itemData.id);
         }
         else if(item.indexOf("pet") >= 0)
         {
            type = "pet";
            petObj1 = Central.main.PET_DATA.find(item);
            if(petObj1)
            {
               itemData = petObj1;
            }
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            getPetModel(itemData.id,displayFullBodyMc);
            getPetIcon(itemData,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_PET,String(itemData.id));
         }
         if(type == null)
         {
         }
         if(itemData.crystal == null)
         {
            itemData.crystal = itemData.token;
         }
         return {
            "mc":displayMc,
            "mcFullBody":displayFullBodyMc,
            "itemData":itemData,
            "type":type,
            "tooltip":tooltip
         };
      }
      
      public static function getPetIcon(itemData:Object, holder:MovieClip) : void
      {
         if(Central.main.dataFilter(itemData) == false)
         {
            return;
         }
         var path:* = "swf/pets/" + itemData.swfName + ".swf";
         new IconLoader(path,holder);
      }
      
      public function setSwf(swf:MovieClip) : void
      {
         this.itemSwf = swf;
      }
      
      public function getAsset(_clsName:String) : MovieClip
      {
         var cls:Class = null;
         try
         {
            cls = Class(this.itemSwf.loaderInfo.applicationDomain.getDefinition(_clsName));
         }
         catch(e:Error)
         {
            Out.error("Item",_clsName + " not found :: " + e.message);
         }
         if(cls == null)
         {
            return null;
         }
         return MovieClip(new cls());
      }
   }
}

import flash.display.MovieClip;
import com.utils.GF;
import ninjasaga.Central;

class IconLoader
{
    
   
   private var holder:MovieClip;
   
   function IconLoader(path:String, holder:MovieClip)
   {
      super();
      this.holder = holder;
      Central.main.dynamicLoad(path,this.loadCallback);
   }
   
   private function loadCallback(mc:MovieClip) : void
   {
      GF.removeAllChild(this.holder);
      var icon:MovieClip = GF.getAsset(mc,"icon");
      if(icon)
      {
         this.holder.addChild(icon);
      }
   }
}

import flash.display.MovieClip;
import com.utils.GF;
import ninjasaga.Central;

class ModelLoader
{
    
   
   private var holder:MovieClip;
   
   private var modelName:String;
   
   private var cb_fn:Function;
   
   private var itemId:String;
   
   function ModelLoader(path:String, modelName:String, itemId:String, holder:MovieClip, cb_fn:Function = null)
   {
      super();
      this.holder = holder;
      this.modelName = modelName;
      this.cb_fn = cb_fn;
      this.itemId = itemId;
      var loadingIcon:MovieClip = new MovieClip();
      loadingIcon = Central.main.getLib("LoadingMc");
      holder.addChild(loadingIcon);
      Central.main.dynamicLoad(path,this.loadCallback);
   }
   
   private function loadCallback(mc:MovieClip) : void
   {
      GF.removeAllChild(this.holder);
      var icon:MovieClip = GF.getAsset(mc,this.modelName);
      if(this.cb_fn != null)
      {
         this.cb_fn(mc,holder,itemId);
         return;
      }
      if(icon)
      {
         this.holder.addChild(icon);
      }
   }
}
