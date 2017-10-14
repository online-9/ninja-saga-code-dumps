package ninjasaga
{
   import ninjasaga.data.InventoryData;
   import flash.display.MovieClip;
   import ninjasaga.data.TooltipData;
   import ninjasaga.data.TitleData;
   import ninjasaga.data.Formula;
   import com.utils.Out;
   import ninjasaga.data.Data;
   import ninjasaga.dbclass.DBCharacter;
   import ninjasaga.data.DBCharacterData;
   import de.polygonal.ds.HashMap;
   
   public class Toolkit
   {
      
      private static var loadPetSwfNow:Boolean = false;
      
      private static var loadPetSwf:Array = [];
       
      
      public function Toolkit()
      {
         super();
      }
      
      public static function setRedirect(type:String, item:*) : void
      {
         Central.main.RedirectData = {
            "type":type,
            "item":item
         };
      }
      
      public static function clearRedirect() : void
      {
         Central.main.RedirectData = null;
      }
      
      public static function hasItem(itemId:String) : Boolean
      {
         var iconData:Object = null;
         var type:String = "";
         if(itemId.indexOf("wpn") >= 0)
         {
            type = InventoryData.TYPE_WEAPON;
         }
         else if(itemId.indexOf("back") >= 0)
         {
            type = InventoryData.TYPE_BACK_ITEM;
         }
         else if(itemId.indexOf("set") >= 0)
         {
            type = InventoryData.TYPE_BODY_SET;
         }
         else if(itemId.indexOf("item") >= 0)
         {
            iconData = Toolkit.getDisplayData(itemId);
            if(iconData.type == "item")
            {
               type = InventoryData.TYPE_ITEM;
            }
            else if(iconData.type == "essence")
            {
               type = InventoryData.TYPE_ESSENCE;
            }
            else if(iconData.type == "material")
            {
               type = InventoryData.TYPE_MATERIAL;
            }
            else if(iconData.type == "currency")
            {
               type = InventoryData.TYPE_CURRENCY;
            }
         }
         else if(itemId.indexOf("pet") >= 0)
         {
            type = InventoryData.TYPE_PET;
         }
         else if(itemId.indexOf("hair") >= 0)
         {
            type = InventoryData.TYPE_HAIR;
         }
         else if(itemId.indexOf("skill") >= 0)
         {
            type = InventoryData.TYPE_SKILL;
         }
         else if(itemId.indexOf("ascy") >= 0)
         {
            type = InventoryData.TYPE_ACCESSORY;
         }
         if(type == "")
         {
            return false;
         }
         return Central.main.getMainChar().hasItem(type,itemId,true);
      }
      
      public static function getItemCount(itemId:String) : int
      {
         var iconData:Object = null;
         var type:String = "";
         if(itemId.indexOf("wpn") >= 0)
         {
            type = InventoryData.TYPE_WEAPON;
         }
         else if(itemId.indexOf("back") >= 0)
         {
            type = InventoryData.TYPE_BACK_ITEM;
         }
         else if(itemId.indexOf("set") >= 0)
         {
            type = InventoryData.TYPE_BODY_SET;
         }
         else if(itemId.indexOf("item") >= 0)
         {
            iconData = Toolkit.getDisplayData(itemId);
            if(iconData.type == "item")
            {
               type = InventoryData.TYPE_ITEM;
            }
            else if(iconData.type == "essence")
            {
               type = InventoryData.TYPE_ESSENCE;
            }
            else if(iconData.type == "material")
            {
               type = InventoryData.TYPE_MATERIAL;
            }
            else if(iconData.type == "currency")
            {
               type = InventoryData.TYPE_CURRENCY;
            }
         }
         else if(itemId.indexOf("pet") >= 0)
         {
            type = InventoryData.TYPE_PET;
         }
         else if(itemId.indexOf("hair") >= 0)
         {
            type = InventoryData.TYPE_HAIR;
         }
         else if(itemId.indexOf("skill") >= 0)
         {
            type = InventoryData.TYPE_SKILL;
         }
         else if(itemId.indexOf("acsy") >= 0)
         {
            type = InventoryData.TYPE_ACCESSORY;
         }
         if(type == "")
         {
            return 0;
         }
         return Central.main.getMainChar().getItemCount(type,itemId);
      }
      
      public static function getDisplayData(item:String, petdata:Object = null) : Object
      {
         var iconMc:MovieClip = null;
         var displayFullBodyMc:MovieClip = null;
         var itemData:Object = null;
         var tooltip:String = null;
         var num:int = 0;
         var type:String = null;
         var tmpStr:String = null;
         var tmp:Array = null;
         var loadItem:String = null;
         var petObj:Object = null;
         var loadingIcon:MovieClip = null;
         var maxLength:int = 0;
         var displayMc:MovieClip = Central.main.getLib("LoadingMc");
         var amount:int = 1;
         var percentage:int = 0;
         if(item.indexOf("mgt") >= 0)
         {
            type = "mgt";
            itemData = {
               "id":item,
               "crystal":0
            };
            displayMc = Central.main.getLib(item.replace("mgt","MGT_"));
            displayMc.width = 125;
            displayMc.height = 125;
            displayMc.x = -displayMc.width / 2 * 0.8;
            displayMc.y = -displayMc.height * 0.81;
            if(displayMc["txt"])
            {
               displayMc["txt"].text = "";
            }
            tooltip = "";
         }
         if(item.indexOf("scratch") >= 0)
         {
            type = "dummy";
            itemData = {
               "id":"scratch",
               "crystal":0
            };
            displayMc = Central.main.getLib("scratch_card");
            displayMc["txt"].text = "";
            tooltip = Central.main.langLib.get(1681)[51];
         }
         if(item.indexOf("huntermaster") >= 0)
         {
            type = "dummy";
            itemData = {
               "id":"huntermaster",
               "crystal":0
            };
            displayMc = Central.main.getLib(item);
            tooltip = Central.main.langLib.get(1662)[30];
         }
         if(item.indexOf("emblem") >= 0)
         {
            type = "dummy";
            itemData = {
               "id":"emblem",
               "crystal":0
            };
            displayMc = Central.main.getLib("emblemIcon");
            tooltip = Central.main.langLib.get(1665)[22];
         }
         if(item.indexOf("wpn") >= 0)
         {
            type = "wpn";
            itemData = Central.main.WEAPON_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            Item.getWeaponIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_WEAPON,item);
         }
         if(item.indexOf("set") >= 0)
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
            Item.getClothIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CLOTHING,item);
         }
         if(item.indexOf("acsy") >= 0)
         {
            type = "acsy";
            itemData = Central.main.ACCESSORY_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            Item.getAccessoryIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ACCESSORY,item);
         }
         if(item.indexOf("back") >= 0)
         {
            type = "back";
            itemData = Central.main.BACK_ITEM_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            Item.getBackItemIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_BACKITEM,item);
         }
         if(item.indexOf("hair") >= 0)
         {
            type = "hair";
            itemData = Central.main.HAIR_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            Item.getHairIcon(itemData.id,displayMc);
            tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_HAIR,item);
         }
         if(item.indexOf("item") >= 0 || item.indexOf("material") >= 0)
         {
            itemData = Central.main.ITEM_DATA.find(item);
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            if(itemData)
            {
               type = "item";
               Item.getItemIcon(itemData.id,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ITEM,item);
            }
            if(!itemData)
            {
               itemData = Central.main.ESSENCE_DATA.find(item);
               if(itemData)
               {
                  type = "essence";
                  Item.getEssenceIcon(itemData.id,displayMc);
                  tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_ESSENCE,item);
               }
            }
            if(!itemData)
            {
               tmp = [];
               tmp = item.split("_");
               item = tmp[0];
               itemData = Central.main.CURRENCY_DATA.find(item);
               if(itemData)
               {
                  type = "currency";
                  if(String(item).indexOf("item741") >= 0 || String(item).indexOf("item742") >= 0)
                  {
                     displayMc = Central.main.getLib("item_741");
                     if(tmp[1] != null)
                     {
                        num = int(tmp[1]);
                        displayMc.txt.text = num;
                     }
                     tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,item);
                  }
                  else
                  {
                     Item.getCurrencyIcon(itemData.id,displayMc);
                     tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_CURRENCY,item);
                  }
               }
            }
            if(!itemData)
            {
               if(item.indexOf("material") >= 0)
               {
                  loadItem = String(item).replace("material","item");
               }
               else
               {
                  loadItem = item;
               }
               itemData = Central.main.MATERIAL_DATA.find(loadItem);
               if(itemData)
               {
                  type = "material";
                  Item.getMaterialIcon(itemData.id,displayMc);
                  tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_MATERIAL,loadItem);
               }
            }
         }
         if(item.indexOf("skill") >= 0)
         {
            if(int(item.replace("skill","")) >= 3500)
            {
               type = "senjutsu";
               itemData = Central.main.SENJUTSU_SKILL_DATA["senjutsu_" + item];
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               Item.getSkillIcon(itemData.swf_name,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SENJUTSU,"senjutsu_" + itemData.skill_id);
            }
            else
            {
               type = "skill";
               itemData = Central.main.SKILL_DATA[item];
               if(Central.main.dataFilter(itemData) == false)
               {
                  return null;
               }
               Item.getSkillIcon(itemData.swfName,displayMc);
               tooltip = TooltipData.getItemTooltip(TooltipData.TOOLTIP_TYPE_SKILL,itemData.id);
            }
         }
         if(item.indexOf("pet") >= 0)
         {
            type = "pet";
            petObj = Central.main.PET_DATA.find(item);
            if(petObj)
            {
               itemData = petObj;
            }
            if(Central.main.dataFilter(itemData) == false)
            {
               return null;
            }
            displayFullBodyMc = new MovieClip();
            loadingIcon = Central.main.getLib("LoadingMc");
            loadingIcon.x = 90;
            loadingIcon.y = 100;
            displayFullBodyMc.addChild(loadingIcon);
            Item.getPetModel(itemData.id,displayFullBodyMc);
            Item.getPetIcon(itemData,displayMc);
            tooltip = "<b>" + itemData.name + "</b><br>(" + Central.main.langLib.titleTxt(TitleData.PETS) + ")<br><br>" + itemData.description;
         }
         if(item.indexOf("friendshipkunai") >= 0 || item.indexOf("fk") >= 0)
         {
            type = "friendshipkunai";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("FriendshipKunaiIcon");
            displayMc.txt.text = num;
            tooltip = Central.main.langLib.titleTxt(TitleData.KUNAI) + " x " + num;
         }
         if(item.indexOf("gold") >= 0)
         {
            type = "gold";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("GoldIcon");
            displayMc.txt.text = num;
            maxLength = 5;
            if(displayMc.txt.text.length > maxLength)
            {
               displayMc.txt.text = displayMc.txt.text.replace(/[0-9][0-9][0-9]$/,"k");
            }
            if(displayMc.txt.text.length > maxLength)
            {
               displayMc.txt.text = displayMc.txt.text.replace(/[0-9][0-9][0-9]k$/,"m");
            }
            if(displayMc.txt.text.length > maxLength)
            {
               displayMc.txt.text = displayMc.txt.text.replace(/[0-9][0-9][0-9]m$/,"b");
            }
            if(num > 0)
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.GOLD) + " x " + num;
            }
            else
            {
               displayMc.txt.text = "";
               tooltip = Central.main.langLib.titleTxt(TitleData.GOLD);
            }
         }
         if(item.indexOf("token") >= 0)
         {
            type = "token";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("TokenIcon");
            displayMc.txt.text = num;
            if(num > 0)
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.TOKEN) + " x " + num;
            }
            else
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.TOKEN);
               displayMc.txt.text = "";
            }
         }
         if(item.indexOf("MCoin") >= 0)
         {
            type = "MCoin";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("MCoinIcon");
            displayMc.txt.text = num;
            if(num > 0)
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.MCOIN) + " x " + num;
            }
            else
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.MCOIN);
               displayMc.txt.text = "";
            }
         }
         if(item.indexOf("tp") >= 0)
         {
            type = "tp";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("TPIcon");
            displayMc.txt.text = num;
            if(num > 0)
            {
               tooltip = "TP" + " x " + num;
            }
            else
            {
               tooltip = "TP";
               displayMc.txt.text = "";
            }
         }
         if(item.indexOf("sp") >= 0)
         {
            type = "sp";
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("SPIcon");
            displayMc.txt.text = num;
            if(num > 0)
            {
               tooltip = "SP" + " x " + num;
            }
            else
            {
               tooltip = "SP";
               displayMc.txt.text = "";
            }
         }
         if(item.indexOf("xp") >= 0)
         {
            type = "xp";
            if(item.indexOf("%") >= 0)
            {
               tmpStr = item.replace("%","");
               percentage = int(tmpStr.replace(type,""));
               item = "xp" + (Formula.getXpByLv(Central.main.getMainChar().getLevel() + 1) - Formula.getXpByLv(Central.main.getMainChar().getLevel())) * percentage / 100;
            }
            num = Number(item.replace(type,""));
            itemData = {"id":type};
            amount = num;
            displayMc = Central.main.getLib("XPIcon");
            displayMc.txt.text = percentage > 0?percentage + "%":num;
            if(num > 0)
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.XP) + " x " + num;
            }
            else
            {
               tooltip = Central.main.langLib.titleTxt(TitleData.XP);
               displayMc.txt.text = "";
            }
         }
         if(type == null)
         {
            Out.error("Toolkit :: getDisplayData :: ","type not found :: " + item);
         }
         if(itemData.crystal == null)
         {
            itemData.crystal = itemData.token;
         }
         if(type == "fk")
         {
            displayMc.x = -50;
            displayMc.y = -100;
            displayMc.height = displayMc.width = 120;
         }
         return {
            "mc":displayMc,
            "mcFullBody":displayFullBodyMc,
            "itemData":itemData,
            "type":type,
            "tooltip":tooltip,
            "amount":amount,
            "petdata":petdata
         };
      }
      
      public static function addInventoryByArray(items_arr:Array, petData_arr:Array = null) : void
      {
         var tmpArr:Array = null;
         var itemId:String = null;
         var count:int = 0;
         var iconData:Object = null;
         var i:int = 0;
         var k:int = 0;
         for(var j:int = 0; j < items_arr.length; j++)
         {
            tmpArr = items_arr[j].split("_");
            itemId = tmpArr[0];
            count = tmpArr.length > 1?int(int(tmpArr[1])):1;
            iconData = Toolkit.getDisplayData(itemId);
            for(i = 0; i < count; i++)
            {
               if(itemId.indexOf("pet") >= 0)
               {
                  for(k = 0; k < petData_arr.length; k++)
                  {
                     if("pet" + petData_arr[k].petId == itemId)
                     {
                        iconData.petdata = petData_arr[k];
                        petData_arr.splice(k,1);
                        break;
                     }
                  }
               }
               Toolkit.DisplayDataAddInventory(iconData);
            }
         }
      }
      
      public static function removeInventoryByArray(items_arr:Array, petData_arr:Array = null) : void
      {
         var tmpArr:Array = null;
         var itemId:String = null;
         var count:int = 0;
         var iconData:Object = null;
         var i:int = 0;
         var k:int = 0;
         for(var j:int = 0; j < items_arr.length; j++)
         {
            tmpArr = items_arr[j].split("_");
            itemId = tmpArr[0];
            count = tmpArr.length > 1?int(int(tmpArr[1])):1;
            iconData = Toolkit.getDisplayData(itemId);
            for(i = 0; i < count; i++)
            {
               if(itemId.indexOf("pet") >= 0)
               {
                  for(k = 0; k < petData_arr.length; k++)
                  {
                     if("pet" + petData_arr[k].petId == itemId)
                     {
                        iconData.petdata = petData_arr[k];
                        petData_arr.splice(k,1);
                        break;
                     }
                  }
               }
               switch(iconData.type)
               {
                  case "wpn":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,itemId);
                     break;
                  case "back":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_BACK_ITEM,itemId);
                     break;
                  case "set":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,itemId);
                     break;
                  case "skill":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,itemId);
                     Central.main.getMainChar().removeEquippedSkill(itemId);
                     break;
                  case "essence":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ESSENCE,itemId);
                     break;
                  case "item":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ITEM,itemId);
                     break;
                  case "material":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_MATERIAL,itemId);
                     break;
                  case "currency":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_CURRENCY,itemId);
                     break;
                  case "hair":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_HAIR,itemId);
                     break;
                  case "pet":
                     Central.main.getMainChar().removePet(itemId);
                     break;
                  case "ascy":
                     Central.main.getMainChar().removeInventory(InventoryData.TYPE_ACCESSORY,itemId);
               }
            }
         }
      }
      
      public static function checkInventoryByArray(items_arr:Array) : Boolean
      {
         var i:* = undefined;
         var k:* = undefined;
         var itemId:* = undefined;
         var tmpArr:* = undefined;
         var count:* = undefined;
         var type:* = undefined;
         for(var j:int = 0; j < items_arr.length; j++)
         {
            if(items_arr[j].indexOf("item") >= 0)
            {
               itemId = items_arr[j].split("_")[0];
               items_arr[j] = items_arr[j].replace("item",Toolkit.getDisplayData(itemId).type);
            }
         }
         var types:Object = {};
         for each(i in items_arr)
         {
            tmpArr = i.split("_");
            count = tmpArr.length > 1?int(tmpArr[1]):1;
            type = tmpArr[0].replace(/[0-9]*$/,"");
            if(!types[type])
            {
               types[type] = 0;
            }
            types[type] = types[type] + count;
         }
         for(k in types)
         {
            if(!Toolkit.checkInventory(k,types[k]))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function checkInventory(_type:String = "wpn,set,back,item,material,essence,pet", _num:int = 1) : Boolean
      {
         var tmpArr:Array = _type.split(",");
         for(var i:int = 0; i < tmpArr.length; i++)
         {
            switch(tmpArr[i])
            {
               case "wpn":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_WEAPON).length + _num + 1 > Data.INV_SPACE_WEAPON)
                  {
                     return false;
                  }
                  break;
               case "ascy":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ACCESSORY).length + _num + 1 > Data.INV_SPACE_ACCESSORY)
                  {
                     return false;
                  }
                  break;
               case "set":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BODY_SET).length + _num + 1 > Data.INV_SPACE_BODYSET)
                  {
                     return false;
                  }
                  break;
               case "back":
                  if(Central.main.getMainChar().getBackItem() != "")
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _num + 1 > Data.INV_SPACE_BACKITEM)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_BACK_ITEM).length + _num > Data.INV_SPACE_BACKITEM)
                  {
                     return false;
                  }
                  break;
               case "item":
                  if(Account.getAccountType() == Account.FREE)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _num > Data.INV_SPACE_FREE)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ITEM).length + _num > Data.INV_SPACE_PREMIUM)
                  {
                     return false;
                  }
                  break;
               case "material":
                  if(Account.getAccountType() == Account.PREMIUM)
                  {
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _num > Data.INV_SPACE_MATERIAL_PREMIUM)
                     {
                        return false;
                     }
                  }
                  else if(Central.main.getMainChar().getInventory(InventoryData.TYPE_MATERIAL).length + _num > Data.INV_SPACE_MATERIAL_FREE)
                  {
                     return false;
                  }
                  break;
               case "essence":
                  if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length + _num > Data.INV_SPACE_ESSENCE)
                  {
                     return false;
                  }
                  break;
               case "pet":
                  if(Central.main.getMainChar().pets.length + _num > Data.INV_PETS_MAXNUM)
                  {
                     return false;
                  }
                  break;
            }
         }
         return true;
      }
      
      public static function DisplayDataAddInventory(iconData:Object, needCheckInventory:Boolean = false, _cbFuc:Function = null, _cbArg:Object = null) : void
      {
         var playerPet:DBCharacter = null;
         var i:int = 0;
         if(iconData.type != "xp" && iconData.type != "gold" && iconData.type != "fk" && iconData.type != "token" && iconData.type != "tp" && iconData.type != "sp")
         {
            for(i = 0; i < iconData.amount; i++)
            {
               if(needCheckInventory == true && checkInventory(iconData.type) == false)
               {
                  if(_cbFuc != null)
                  {
                     if(_cbArg != null)
                     {
                        _cbFuc(_cbArg);
                     }
                     else
                     {
                        _cbFuc();
                     }
                  }
                  else
                  {
                     return;
                  }
               }
               switch(iconData.type)
               {
                  case "wpn":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,String(iconData.itemData.id));
                     break;
                  case "set":
                     if(!Central.main.getMainChar().hasItem(InventoryData.TYPE_BODY_SET,String(iconData.itemData.id)) && Central.main.getMainChar().getBodySet() != String(iconData.itemData.id))
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,String(iconData.itemData.id));
                     }
                     break;
                  case "acsy":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_ACCESSORY,String(iconData.itemData.id));
                     break;
                  case "back":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,String(iconData.itemData.id));
                     break;
                  case "item":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_ITEM,String(iconData.itemData.id));
                     break;
                  case "material":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_MATERIAL,String(iconData.itemData.id));
                     break;
                  case "currency":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_CURRENCY,String(iconData.itemData.id));
                     break;
                  case "essence":
                     if(Central.main.getMainChar().getInventory(InventoryData.TYPE_ESSENCE).length < Data.INV_SPACE_ESSENCE)
                     {
                        Central.main.getMainChar().addInventory(InventoryData.TYPE_ESSENCE,String(iconData.itemData.id));
                     }
                     break;
                  case "skill":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_SKILL,String(iconData.itemData.id));
                     break;
                  case "hair":
                     Central.main.getMainChar().addInventory(InventoryData.TYPE_HAIR,String(iconData.itemData.id));
                     break;
                  case "pet":
                     playerPet = Central.main.dataParser.parsePetData(iconData.petdata);
                     Central.main.getMainChar().initStandbyPet(playerPet,iconData.petdata.swfName,iconData.petdata.clsName);
                     if(!Toolkit.loadPetSwfNow)
                     {
                        Toolkit.loadPetSwfNow = true;
                        Central.main.loadSwf(["swf/pets/" + iconData.petdata.swfName + ".swf"],loadPetFinish,{"petdata":iconData.petdata},Central.main.langLib.get(102));
                     }
                     else
                     {
                        Toolkit.loadPetSwf.push([["swf/pets/" + iconData.petdata.swfName + ".swf"],{"petdata":iconData.petdata}]);
                     }
                     break;
                  case "currency":
                     Central.main.addCurrency(iconData.itemData.id);
               }
            }
         }
         else
         {
            switch(iconData.type)
            {
               case "xp":
                  Central.main.getMainChar().showLevelUp(Central.main.getMainChar().updateXP(iconData.amount));
                  break;
               case "gold":
                  Central.main.getMainChar().updateGold(iconData.amount);
                  break;
               case "fk":
                  Central.main.getMainChar().updateKunai(iconData.amount);
                  break;
               case "token":
                  Central.main.account.balance = Central.main.account.getAccountBalance() + iconData.amount;
                  break;
               case "tp":
                  Central.main.getMainChar().updateData(DBCharacterData.BLOODLINE,int(iconData.amount) + int(Central.main.getMainChar().getData(DBCharacterData.BLOODLINE)));
                  break;
               case "sp":
                  Central.main.getMainChar().updateData(DBCharacterData.SENJUTSU_SS,int(iconData.amount) + int(Central.main.getMainChar().getData(DBCharacterData.SENJUTSU_SS)));
            }
         }
      }
      
      private static function loadPetFinish(swfObj:Object = null, params:Object = null) : void
      {
         var petArray:Array = null;
         var i:int = 0;
         var loadSwfParams:Array = null;
         if(swfObj)
         {
            petArray = Central.main.getMainChar().pets;
            for(i = 0; i < petArray.length; i++)
            {
               if(petArray[i].getPetId() == params.petdata.id)
               {
                  petArray[i].loadedSwf = swfObj["swf/pets/" + params.petdata.swfName + ".swf"];
               }
            }
            Central.main.updateMenu();
         }
         if(Toolkit.loadPetSwf.length > 0)
         {
            loadSwfParams = Toolkit.loadPetSwf.shift();
            Central.main.loadSwf(loadSwfParams[0],loadPetFinish,loadSwfParams[1],Central.main.langLib.get(102));
         }
         else
         {
            Toolkit.loadPetSwfNow = false;
         }
      }
      
      public static function addExpiryItem(str:String) : void
      {
         var item:* = Central.main.itemPrototype(str);
         var strArr:Array = str.split("_");
         switch(strArr[0])
         {
            case "wpn":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_WEAPON,item);
               break;
            case "back":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_BACK_ITEM,item);
               break;
            case "set":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_BODY_SET,item);
               break;
            case "skill":
               Central.main.getMainChar().addInventory(InventoryData.TYPE_SKILL,item);
               break;
            case "essence":
               break;
            case "item":
               break;
            case "material":
               break;
            case "currency":
               break;
            case "hair":
         }
      }
      
      public static function removeExpiryItem(str:String) : void
      {
         var item:String = Central.main.itemPrototype(str);
         var strArr:Array = str.split("_");
         switch(strArr[0])
         {
            case "wpn":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_WEAPON,item);
               break;
            case "back":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_BACK_ITEM,item);
               break;
            case "set":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_BODY_SET,item);
               break;
            case "skill":
               Central.main.getMainChar().removeInventory(InventoryData.TYPE_SKILL,item);
               Central.main.getMainChar().removeEquippedSkill(item);
               break;
            case "essence":
               break;
            case "item":
               break;
            case "material":
               break;
            case "hair":
         }
         if(str.indexOf("pet") >= 0)
         {
            Central.main.getMainChar().removePet(item);
         }
      }
      
      public static function equipExpiryItem(str:String) : void
      {
         var addInv:Boolean = false;
         var item:* = Central.main.itemPrototype(str);
         var strArr:Array = str.split("_");
         switch(strArr[0])
         {
            case "wpn":
               Central.main.getMainChar().setWeapon(item,addInv);
               break;
            case "back":
               Central.main.getMainChar().setBackItem(item,addInv);
               break;
            case "set":
               break;
            case "hair":
         }
      }
      
      public static function getItemType(id:String) : String
      {
         if(id.indexOf("wpn") >= 0)
         {
            return InventoryData.TYPE_WEAPON;
         }
         if(id.indexOf("back") >= 0)
         {
            return InventoryData.TYPE_BACK_ITEM;
         }
         if(id.indexOf("hair") >= 0)
         {
            return InventoryData.TYPE_HAIR;
         }
         if(id.indexOf("set") >= 0)
         {
            return InventoryData.TYPE_BODY_SET;
         }
         if(id.indexOf("acsy") >= 0)
         {
            return InventoryData.TYPE_ACCESSORY;
         }
         return "";
      }
      
      public static function getItemDataByID(id:String) : Object
      {
         var itemType:String = Toolkit.getItemType(id);
         switch(itemType)
         {
            case InventoryData.TYPE_WEAPON:
               return Central.main.WEAPON_DATA.find(id);
            case InventoryData.TYPE_BACK_ITEM:
               return Central.main.BACK_ITEM_DATA.find(id);
            case InventoryData.TYPE_HAIR:
               return Central.main.HAIR_DATA.find(id);
            case InventoryData.TYPE_BODY_SET:
               return Central.main.getMainChar().getGender() == 0?Central.main.BODY_SET_BOY[id]:Central.main.BODY_SET_GIRL[id];
            case InventoryData.TYPE_ACCESSORY:
               return Central.main.ACCESSORY_DATA.find(id);
            default:
               return null;
         }
      }
      
      public static function getIDBySubData(subDataOrgName:String, subDataTarget:String, data:HashMap) : String
      {
         var keys:Array = data.getKeySet();
         for(var i:* = 0; i < keys.length; i++)
         {
            if(data.find(keys[i])[subDataOrgName] == subDataTarget)
            {
               return data.find(keys[i]).id;
            }
         }
         return "";
      }
   }
}
