package ninjasaga 
{
    import bitemycode.loader.*;
    import com.utils.*;
    import flash.display.*;
    import ninjasaga.data.*;
    
    public class Item extends Object
    {
        public function Item(arg1:String)
        {
            super();
            this.itemId = arg1;
            return;
        }

        public function setSwf(arg1:flash.display.MovieClip):void
        {
            this.itemSwf = arg1;
            return;
        }

        public function getAsset(arg1:String):flash.display.MovieClip
        {
            var _clsName:String;
            var cls:Class;

            var loc1:*;
            _clsName = arg1;
            cls = null;
            try
            {
                cls = Class(this.itemSwf.loaderInfo.applicationDomain.getDefinition(_clsName));
            }
            catch (e:Error)
            {
                com.utils.Out.error("Item", _clsName + " not found :: " + undefined.message);
            }
            if (cls == null)
            {
                return null;
            }
            return flash.display.MovieClip(new cls());
        }

        public static function setItem(arg1:ninjasaga.Item):void
        {
            itemList[arg1.itemId] = arg1;
            return;
        }

        public static function getItem(arg1:String):ninjasaga.Item
        {
            var loc1:*;
            loc1 = itemList[arg1];
            return loc1;
        }

        public static function hasItem(arg1:String):Boolean
        {
            var loc1:*;
            loc1 = itemList[arg1];
            if (loc1 != null)
            {
                return true;
            }
            return false;
        }

        public static function getWeaponIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            com.utils.GF.removeAllChild(arg2);
            arg2.addChild(ninjasaga.Central.main.asset.getWeaponIcon(arg1));
            return;
        }

        public static function getClothIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            com.utils.GF.removeAllChild(arg2);
            arg2.addChild(ninjasaga.Central.main.asset.getClothingIcon(arg1));
            return;
        }

        public static function getBackItemIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            com.utils.GF.removeAllChild(arg2);
            arg2.addChild(ninjasaga.Central.main.asset.getBackItemIcon(arg1));
            return;
        }

        public static function getHairIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = ninjasaga.Central.main.HAIR_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            var loc2:*;
            loc2 = "swf/items/hair_" + loc1.swfName + ".swf";
            new IconLoader(loc2, arg2);
            return;
        }

        public static function getItemIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            com.utils.GF.removeAllChild(arg2);
            var loc1:*;
            loc1 = ninjasaga.Central.main.ITEM_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            var loc2:*;
            loc2 = loc1.swfName;
            arg2.addChild(ninjasaga.Central.main.getLib(loc2));
            return;
        }

        public static function getEssenceIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = ninjasaga.Central.main.ESSENCE_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            if (loc2 == loc1.swfName)
            {
                com.utils.GF.removeAllChild(arg2);
                arg2.addChild(ninjasaga.Central.main.getLib(loc2));
            }
            return;
        }

        public static function getCurrencyIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = ninjasaga.Central.main.CURRENCY_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            if (loc2 == loc1.swfName)
            {
                com.utils.GF.removeAllChild(arg2);
                arg2.addChild(ninjasaga.Central.main.getLib(loc2));
            }
            return;
        }

        public static function getMaterialIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = ninjasaga.Central.main.MATERIAL_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            if (loc2 == loc1.swfName)
            {
                com.utils.GF.removeAllChild(arg2);
                arg2.addChild(ninjasaga.Central.main.getLib(loc2));
            }
            return;
        }

        public static function getSkillIcon(arg1:String, arg2:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = 0;
            var loc3:*;
            loc3 = String(arg1).slice(6);
            var loc4:*;
            loc4 = int(loc3) % 10;
            var loc5:*;
            loc5 = int(loc3) / 10;
            if (loc4 != 0)
            {
                loc1 = int((loc5 + 1) * 10);
                loc2 = int(loc1 - 9);
            }
            else 
            {
                loc1 = int(loc3);
                loc2 = int(loc1 - 9);
            }
            var loc6:*;
            loc6 = ninjasaga.data.Data.genSwfFilePath("library/icons", String("skill_icon_" + loc2.toString() + "-" + loc1.toString()));
            bitemycode.loader.DynamicLoader.load(loc6, arg2, arg1, null, true);
            return;
        }

        public static function getWeaponModel(arg1:String, arg2:flash.display.MovieClip, arg3:Function=null):void
        {
            var loc1:*;
            loc1 = ninjasaga.Central.main.WEAPON_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            var loc2:*;
            loc2 = "swf/items/" + loc1.swfName + ".swf";
            new ModelLoader(loc2, "weapon", arg1, arg2, arg3);
            return;
        }

        public static function getBackItemModel(arg1:String, arg2:flash.display.MovieClip, arg3:Function=null):void
        {
            var loc1:*;
            loc1 = ninjasaga.Central.main.BACK_ITEM_DATA.find(arg1);
            if (ninjasaga.Central.main.dataFilter(loc1) == false)
            {
                return;
            }
            var loc2:*;
            loc2 = "swf/items/" + loc1.swfName + ".swf";
            new ModelLoader(loc2, "back_item", arg1, arg2, arg3);
            return;
        }

        public static function getBodySetModel(arg1:uint, arg2:String, arg3:flash.display.MovieClip, arg4:Function=null):void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = arg1 != 0 ? ninjasaga.Central.main.BODY_SET_GIRL : ninjasaga.Central.main.BODY_SET_BOY;
            if (ninjasaga.Central.main.dataFilter(loc1[arg2]) == false)
            {
                return;
            }
            if (loc1[arg2])
            {
                loc2 = "swf/items/" + loc1[arg2].swfName + ".swf";
                new ModelLoader(loc2, "icon", arg2, arg3, arg4);
            }
            return;
        }

        public static function getPetModel(arg1:String, arg2:flash.display.MovieClip, arg3:Function=null):void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            if (loc2 == ninjasaga.Central.main.PET_DATA.find("pet" + String(arg1)))
            {
                loc1 = loc2.swfName;
            }
            var loc3:*;
            loc3 = loc2;
            if (ninjasaga.Central.main.dataFilter(loc3) == false)
            {
                return;
            }
            var loc4:*;
            loc4 = "swf/pets/" + loc1 + ".swf";
            new ModelLoader(loc4, "StaticFullBody", arg1, arg2, arg3);
            return;
        }

        public static function getDisplayData(arg1:String):Object
        {
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = null;
            var loc5:*;
            loc5 = 0;
            var loc6:*;
            loc6 = null;
            var loc7:*;
            loc7 = undefined;
            var loc8:*;
            loc8 = null;
            var loc9:*;
            loc9 = null;
            var loc10:*;
            loc10 = null;
            var loc11:*;
            loc11 = null;
            var loc12:*;
            loc12 = null;
            var loc13:*;
            loc13 = null;
            var loc1:*;
            loc1 = ninjasaga.Central.main.getLib("LoadingMc");
            var loc2:*;
            loc2 = ninjasaga.Central.main.getLib("LoadingMc");
            if (arg1 != "emblem")
            {
                if (arg1.indexOf("trainslot") >= 0)
                {
                    loc6 = "trainslot";
                    loc3 = new Object();
                    com.utils.GF.removeAllChild(loc1);
                    loc1 = ninjasaga.Central.main.getLib("trainSlotIcon");
                    loc4 = "";
                }
                else 
                {
                    if (arg1.indexOf("gold") >= 0)
                    {
                        loc6 = "gold";
                        loc3 = new Object();
                        com.utils.GF.removeAllChild(loc1);
                        loc1 = ninjasaga.Central.main.getLib("GoldIcon");
                        loc1["txt"].text = String(arg1).replace(loc6, "");
                        loc4 = String(arg1).replace(loc6, "") + " " + ninjasaga.Central.main.langLib.get(1389);
                        loc3.name = loc4;
                    }
                    else 
                    {
                        if (arg1.indexOf("token") >= 0)
                        {
                            loc6 = "token";
                            loc3 = new Object();
                            com.utils.GF.removeAllChild(loc1);
                            loc1 = ninjasaga.Central.main.getLib("TokenIcon");
                            loc1["txt"].text = String(arg1).replace(loc6, "");
                            loc4 = String(arg1).replace(loc6, "") + " " + ninjasaga.Central.main.langLib.get(1390);
                            loc3.name = loc4;
                        }
                        else 
                        {
                            if (arg1.indexOf("wpn") >= 0)
                            {
                                loc6 = "wpn";
                                loc3 = ninjasaga.Central.main.WEAPON_DATA.find(arg1);
                                if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                {
                                    return null;
                                }
                                getWeaponIcon(loc3.id, loc1);
                                loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_WEAPON, arg1);
                            }
                            else 
                            {
                                if (arg1.indexOf("set") >= 0)
                                {
                                    loc6 = "set";
                                    if ((loc3 = ninjasaga.Central.main.BODY_SET_BOY[arg1]) == null)
                                    {
                                        loc3 = ninjasaga.Central.main.BODY_SET_GIRL[arg1];
                                    }
                                    if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                    {
                                        return null;
                                    }
                                    getClothIcon(loc3.id, loc1);
                                    loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_CLOTHING, arg1);
                                }
                                else 
                                {
                                    if (arg1.indexOf("back") >= 0)
                                    {
                                        loc6 = "back";
                                        loc3 = ninjasaga.Central.main.BACK_ITEM_DATA.find(arg1);
                                        if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                        {
                                            return null;
                                        }
                                        getBackItemIcon(loc3.id, loc1);
                                        loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_BACKITEM, arg1);
                                    }
                                    else 
                                    {
                                        if (arg1.indexOf("hair") >= 0)
                                        {
                                            loc6 = "hair";
                                            loc3 = ninjasaga.Central.main.HAIR_DATA.find(arg1);
                                            if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                            {
                                                return null;
                                            }
                                            getHairIcon(loc3.id, loc1);
                                            loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_HAIR, arg1);
                                        }
                                        else 
                                        {
                                            if (arg1.indexOf("item") >= 0 || arg1.indexOf("material") >= 0)
                                            {
                                                if (arg1.indexOf("material") >= 0)
                                                {
                                                    loc8 = String(arg1).replace("material", "item");
                                                }
                                                else 
                                                {
                                                    loc8 = arg1;
                                                }
                                                loc6 = "item";
                                                var loc14:*;
                                                loc3 = loc14 = ninjasaga.Central.main.ITEM_DATA.find(loc8);
                                                if (loc14)
                                                {
                                                    if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                    {
                                                        return null;
                                                    }
                                                    getItemIcon(loc3.id, loc1);
                                                    loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, loc8);
                                                }
                                                else 
                                                {
                                                    loc3 = loc14 = ninjasaga.Central.main.ESSENCE_DATA.find(loc8);
                                                    if (loc14)
                                                    {
                                                        if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                        {
                                                            return null;
                                                        }
                                                        getEssenceIcon(loc3.id, loc1);
                                                        loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ESSENCE, loc8);
                                                    }
                                                    else 
                                                    {
                                                        loc3 = loc14 = ninjasaga.Central.main.MATERIAL_DATA.find(loc8);
                                                        if (loc14)
                                                        {
                                                            if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                            {
                                                                return null;
                                                            }
                                                            getMaterialIcon(loc3.id, loc1);
                                                            loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_MATERIAL, loc8);
                                                        }
                                                        else 
                                                        {
                                                            loc3 = loc14 = ninjasaga.Central.main.CURRENCY_DATA.find(loc8);
                                                            if (loc14)
                                                            {
                                                                if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                                {
                                                                    return null;
                                                                }
                                                                getCurrencyIcon(loc3.id, loc1);
                                                                loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_CURRENCY, loc8);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            else 
                                            {
                                                if (arg1.indexOf("petskill") >= 0)
                                                {
                                                    loc6 = "petskill";
                                                    loc10 = arg1.split("_");
                                                    loc5 = int(loc10[1]);
                                                    if (loc11 == ninjasaga.Central.main.PET_DATA.find("pet" + String(loc5)))
                                                    {
                                                        loc9 = loc7.swfName;
                                                        loc3 = loc11;
                                                    }
                                                    if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                    {
                                                        return null;
                                                    }
                                                    loc12 = "swf/pets/" + loc9 + ".swf";
                                                    new ModelLoader(loc12, "Skill_" + loc10[2], String(loc5), loc1);
                                                }
                                                else 
                                                {
                                                    if (arg1.indexOf("skill") >= 0)
                                                    {
                                                        loc6 = "skill";
                                                        loc3 = ninjasaga.Central.main.SKILL_DATA[arg1];
                                                        if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                        {
                                                            return null;
                                                        }
                                                        loc1 = ninjasaga.Central.main.getLib(loc3.swfName);
                                                        loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_SKILL, loc3.id);
                                                    }
                                                    else 
                                                    {
                                                        if (arg1.indexOf("pet") >= 0)
                                                        {
                                                            loc6 = "pet";
                                                            if (loc13 == ninjasaga.Central.main.PET_DATA.find(arg1))
                                                            {
                                                                loc3 = loc13;
                                                            }
                                                            if (ninjasaga.Central.main.dataFilter(loc3) == false)
                                                            {
                                                                return null;
                                                            }
                                                            getPetModel(loc3.id, loc2);
                                                            getPetIcon(loc3, loc1);
                                                            loc4 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_PET, String(loc3.id));
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else 
            {
                loc6 = "emblem";
                loc3 = new Object();
                com.utils.GF.removeAllChild(loc1);
                loc1 = ninjasaga.Central.main.getLib("emblemIcon");
                loc4 = ninjasaga.Central.main.langLib.get(307);
            }
            if (loc6 != null)
            {
            };
            if (loc3.crystal == null)
            {
                loc3.crystal = loc3.token;
            }
            return {"mc":loc1, "mcFullBody":loc2, "itemData":loc3, "type":loc6, "tooltip":loc4};
        }

        public static function getPetIcon(arg1:Object, arg2:flash.display.MovieClip):void
        {
            if (ninjasaga.Central.main.dataFilter(arg1) == false)
            {
                return;
            }
            var loc1:*;
            loc1 = "swf/pets/" + arg1.swfName + ".swf";
            new IconLoader(loc1, arg2);
            return;
        }

        
        {
            itemList = new Object();
        }

        private var itemSwf:flash.display.MovieClip;

        public var itemId:String;

        private static var itemList:Object;
    }
}

import com.utils.*;
import flash.display.*;


class IconLoader extends Object
{
    public function IconLoader(arg1:String, arg2:flash.display.MovieClip)
    {
        super();
        this.holder = arg2;
        ninjasaga.Central.main.dynamicLoad(arg1, this.loadCallback);
        return;
    }

    private function loadCallback(arg1:flash.display.MovieClip):void
    {
        com.utils.GF.removeAllChild(this.holder);
        var loc1:*;
        loc1 = com.utils.GF.getAsset(arg1, "icon");
        if (loc1)
        {
            this.holder.addChild(loc1);
        }
        return;
    }

    private var holder:flash.display.MovieClip;
}

class ModelLoader extends Object
{
    public function ModelLoader(arg1:String, arg2:String, arg3:String, arg4:flash.display.MovieClip, arg5:Function=null)
    {
        super();
        this.holder = arg4;
        this.modelName = arg2;
        this.cb_fn = arg5;
        this.itemId = arg3;
        var loc1:*;
        loc1 = new flash.display.MovieClip();
        loc1 = ninjasaga.Central.main.getLib("LoadingMc");
        arg4.addChild(loc1);
        ninjasaga.Central.main.dynamicLoad(arg1, this.loadCallback);
        return;
    }

    private function loadCallback(arg1:flash.display.MovieClip):void
    {
        com.utils.GF.removeAllChild(this.holder);
        var loc1:*;
        loc1 = com.utils.GF.getAsset(arg1, this.modelName);
        if (this.cb_fn != null)
        {
            this.cb_fn(arg1, this.holder, this.itemId);
            return;
        }
        if (loc1)
        {
            this.holder.addChild(loc1);
        }
        return;
    }

    private var holder:flash.display.MovieClip;

    private var modelName:String;

    private var cb_fn:Function;

    private var itemId:String;
}