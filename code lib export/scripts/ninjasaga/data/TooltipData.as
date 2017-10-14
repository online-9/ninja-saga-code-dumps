package ninjasaga.data
{
   import ninjasaga.Central;
   
   public final class TooltipData
   {
      
      public static const TOOLTIP_TYPE_HAIR:String = "hair";
      
      public static const TOOLTIP_TYPE_CLOTHING:String = "set";
      
      public static const TOOLTIP_TYPE_WEAPON:String = "wpn";
      
      public static const TOOLTIP_TYPE_BACKITEM:String = "backitem";
      
      public static const TOOLTIP_TYPE_ACCESSORY:String = "accessory";
      
      public static const TOOLTIP_TYPE_ITEM:String = "item";
      
      public static const TOOLTIP_TYPE_ESSENCE:String = "essence";
      
      public static const TOOLTIP_TYPE_MATERIAL:String = "material";
      
      public static const TOOLTIP_TYPE_CURRENCY:String = "currency";
      
      public static const TOOLTIP_TYPE_SKILL:String = "skill";
      
      public static const TOOLTIP_TYPE_SENJUTSU:String = "senjutsu";
      
      public static const TOOLTIP_TYPE_SKILL_CLASS:String = "skill_class";
      
      public static const TOOLTIP_TYPE_PET:String = "pet";
      
      private static const ALL_NINJUTSU_TYPES:Array = [SkillData.TYPE_WIND,SkillData.TYPE_FIRE,SkillData.TYPE_LIGHTNING,SkillData.TYPE_EARTH,SkillData.TYPE_WATER,SkillData.TYPE_TAIJUTSU,SkillData.TYPE_GENJUTSU];
      
      private static const SKILL_TYPE_BUTTON_NAME_ARR:Array = [ButtonData.WIND,ButtonData.FIRE,ButtonData.THUNDER,ButtonData.EARTH,ButtonData.WATER,ButtonData.TAIJUTSU,ButtonData.GENJUTSU];
       
      
      public function TooltipData()
      {
         super();
      }
      
      private static function getEffectDescription(effect:Object) : String
      {
         var amount:* = effect.amount;
         var chance:* = effect.chance;
         var duration:* = effect.duration;
         var tmpStr:* = Central.main.langLib.effectDataTxt(effect.type);
         if(!tmpStr)
         {
            return "[" + effect + "]";
         }
         if(amount < 0)
         {
            tmpStr = "<font color=\'#FF0000\'>" + tmpStr + "</font>";
            amount = amount * -1;
            tmpStr = tmpStr.replace("[increase]","[decrease]");
            tmpStr = tmpStr.replace("[decrease]","[increase]");
            tmpStr = tmpStr.replace("[up]","[down]");
            tmpStr = tmpStr.replace("[down]","[up]");
         }
         else
         {
            tmpStr = "<font color=\'#0000FF\'>" + tmpStr + "</font>";
         }
         tmpStr = tmpStr.replace("[chance]",chance);
         tmpStr = tmpStr.replace("[amount]",amount);
         tmpStr = tmpStr.replace("[100-amount]",100 - amount);
         tmpStr = tmpStr.replace("[duration]",duration - 1);
         tmpStr = tmpStr.replace("[increase]",AppData.lang == AppData.ZH?"增加":"increase");
         tmpStr = tmpStr.replace("[decrease]",AppData.lang == AppData.ZH?"減少":"decrease");
         tmpStr = tmpStr.replace("[up]",AppData.lang == AppData.ZH?"上升":"");
         tmpStr = tmpStr.replace("[down]",AppData.lang == AppData.ZH?"下降":"");
         return tmpStr;
      }
      
      private static function getGearsetEffectDescription(effect:Object) : *
      {
         var effectStr:String = Central.main.langLib.getGearsetText(effect.type);
         if(!effectStr)
         {
            return "";
         }
         effectStr = effectStr.replace("[chance]",effect.chance);
         effectStr = effectStr.replace("[duration]",effect.duration - 1);
         effectStr = effectStr.replace("[amount]",effect.amount);
         return effectStr;
      }
      
      private static function getExtraEffectDescription(effect:Object) : *
      {
         var i:int = 0;
         var effectStr:String = Central.main.langLib.getExtraEffectText(effect.type);
         var enemyName:String = "";
         for(i = 0; i < effect.enemy.length; i++)
         {
            enemyName = enemyName + (enemyName == ""?Central.main.ENEMY_DATA.find(effect.enemy[i]).name:"/" + Central.main.ENEMY_DATA.find(effect.enemy[i]).name);
         }
         if(!effectStr)
         {
            return "";
         }
         effectStr = effectStr.replace("[amount]",effect.amount);
         effectStr = effectStr.replace("[enemy]",enemyName);
         return effectStr;
      }
      
      public static function getItemTooltip(type:String, id:String, _limitedMsg:String = "") : String
      {
         var obj:Object = null;
         var effect:Object = null;
         var i:int = 0;
         var body_set_obj:Object = null;
         var petArr:Array = null;
         var finalDmg:int = 0;
         var _tmpCp:int = 0;
         var ToolTip_curlv:String = null;
         var ToolTip_Final:String = null;
         var ToolTip_Requirement_curlv_arr1:Array = null;
         var ToolTip_Requirement_curlv_arr2:Array = null;
         var ToolTip_Requirement_curlv_arr3:Array = null;
         var SenjutsuskillData:Object = null;
         var SenjutsuskillData_effect:Object = null;
         var levelBouns:int = 0;
         var amount:int = 0;
         var special_class:int = 0;
         var tooltipStr:* = "";
         var skillTypeStr:String = "";
         var effectStr:String = "";
         var isLoginMode:Boolean = NinjaSaga.isTestMode;
         var isLimited:Boolean = false;
         if(String(_limitedMsg).length > 0)
         {
            isLimited = true;
         }
         switch(type)
         {
            case TOOLTIP_TYPE_HAIR:
               obj = Central.main.HAIR_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(String(obj.description).length > 0)
                  {
                     tooltipStr = String("<b>" + obj.description + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + String(Central.main.langLib.titleTxt(TitleData.HAIRSTYLE)).replace(":","") + ")";
                  }
                  if(obj.relate_set && obj.relate_set != "")
                  {
                     tooltipStr = tooltipStr + getGearsetTooltip(obj);
                  }
               }
               break;
            case TOOLTIP_TYPE_CLOTHING:
               body_set_obj = {};
               body_set_obj = Central.main.getMainChar().getGender() == 0?Central.main.BODY_SET_BOY:Central.main.BODY_SET_GIRL;
               if(body_set_obj[id])
               {
                  obj = body_set_obj[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.CLOTHING_TOOLTIP) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
                  if(obj.relate_set && obj.relate_set != "")
                  {
                     tooltipStr = tooltipStr + getGearsetTooltip(obj);
                  }
               }
               break;
            case TOOLTIP_TYPE_WEAPON:
               obj = Central.main.WEAPON_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.WEAPON) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + obj.damage + "</font>";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                     if(obj.relate_set && obj.relate_set != "")
                     {
                        tooltipStr = tooltipStr + getGearsetTooltip(obj);
                     }
                     if(obj.extra_effect && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr = tooltipStr + getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_BACKITEM:
               obj = Central.main.BACK_ITEM_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.btnTxt(ButtonData.BACK_ITEM) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                     if(obj.relate_set && obj.relate_set != "")
                     {
                        tooltipStr = tooltipStr + getGearsetTooltip(obj);
                     }
                     if(obj.extra_effect && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr = tooltipStr + getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ACCESSORY:
               obj = Central.main.ACCESSORY_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.ACCESSORY) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": " + obj.description;
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.EFFECT) + ": -";
                     }
                  }
                  if(obj.relate_set && obj.relate_set != "")
                  {
                     tooltipStr = tooltipStr + getGearsetTooltip(obj);
                  }
                  if(obj.extra_effect && obj.extra_effect != null)
                  {
                     for(i = 0; i < obj.extra_effect.enemy.length; i++)
                     {
                        if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                        {
                           tooltipStr = tooltipStr + getExtraEffectTooltip(obj);
                           break;
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ITEM:
               obj = Central.main.ITEM_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.ITEM) + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_ESSENCE:
               obj = Central.main.ESSENCE_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.NINJA_ESSENCE) + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_MATERIAL:
               obj = Central.main.MATERIAL_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.MATERIAL) + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_CURRENCY:
               obj = Central.main.CURRENCY_DATA.find(id);
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL:
               if(Central.main.SKILL_DATA[id])
               {
                  obj = Central.main.SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(_limitedMsg);
                  }
                  else
                  {
                     skillTypeStr = getSkillTypeName(obj.type);
                     finalDmg = obj.damage;
                     if(obj.skill_hit_num >= 2)
                     {
                        finalDmg = Math.round(obj.damage * obj.skill_hit_num);
                     }
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + skillTypeStr + ")";
                     tooltipStr = tooltipStr + "<br><br>" + Central.main.langLib.titleTxt(TitleData.LEVEL) + ": " + obj.level;
                     if(Central.main.getMainChar().isBattleDebuffActive(BattleData.SKILL_341) || Central.main.getMainChar().isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION) || Central.main.getMainChar().isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE) || Central.main.getMainChar().isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
                     {
                        _tmpCp = 0;
                        if(Central.main.getMainChar().isBattleDebuffActive(BattleData.EFFECT_CUBE_ILLUSION))
                        {
                           _tmpCp = Math.round(obj.cp * 1.4);
                        }
                        if(Central.main.getMainChar().isBattleDebuffActive(BattleData.SKILL_341))
                        {
                           _tmpCp = Math.round(obj.cp * (int(Central.main.getMainChar().getBattleDebuff()[BattleData.SKILL_341].amount) / 100));
                        }
                        if(Central.main.getMainChar().isBattleDebuffActive(BloodlineData.EFFECT_EXTRA_CP_USE))
                        {
                           _tmpCp = Math.round(obj.cp * 2);
                        }
                        if(Central.main.getMainChar().isBattleBuffActive(BattleData.EFFECT_PET_SAVE_CP))
                        {
                           _tmpCp = Math.round(obj.cp * (1 - int(Central.main.getMainChar().getBattleBuff()[BattleData.EFFECT_PET_SAVE_CP].amount) / 100));
                        }
                        if(Central.main.getMainChar().isBattleBuffActive(BattleData.EFFECT_REDUCE_CP_REQUIRE))
                        {
                           _tmpCp = Math.round(obj.cp * (int(Central.main.getMainChar().getBattleBuff()[BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100));
                        }
                        tooltipStr = tooltipStr + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CHAKRA) + ": " + _tmpCp + "</font>";
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#0000FF\'>" + Central.main.langLib.titleTxt(TitleData.CHAKRA) + ": " + obj.cp + "</font>";
                     }
                     if(obj.effect)
                     {
                        if(obj.effect.type == SkillData.EFFECT_TYPE_HEAL)
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#00FF00\'>" + Central.main.langLib.titleTxt(TitleData.HEAL) + ": " + finalDmg + "</font>";
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + finalDmg + "</font>";
                        }
                     }
                     else
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + finalDmg + "</font>";
                     }
                     tooltipStr = tooltipStr + "<br>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + obj.cooldown;
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + obj.description;
                     }
                     if(obj.extra_effect && obj.extra_effect != null)
                     {
                        for(i = 0; i < obj.extra_effect.enemy.length; i++)
                        {
                           if(Central.main.extraData.activeEnemy.indexOf(obj.extra_effect.enemy[i]) >= 0)
                           {
                              tooltipStr = tooltipStr + getExtraEffectTooltip(obj);
                              break;
                           }
                        }
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SENJUTSU:
               if(Central.main.SENJUTSU_SKILL_DATA[id])
               {
                  obj = Central.main.SENJUTSU_SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(_limitedMsg);
                  }
                  else
                  {
                     ToolTip_curlv = "";
                     ToolTip_Final = "";
                     ToolTip_Requirement_curlv_arr1 = [];
                     ToolTip_Requirement_curlv_arr2 = [];
                     ToolTip_Requirement_curlv_arr3 = [];
                     SenjutsuskillData = obj;
                     SenjutsuskillData_effect = obj.effect[0];
                     if(id == "senjutsu_skill3000")
                     {
                        SenjutsuskillData_effect.skill_sp = Central.main.getMainChar().maxSP;
                     }
                     tooltipStr = String("<b>" + SenjutsuskillData.name + "</b>");
                     if(SenjutsuskillData.senjutsu_type == SenjutsuData.SKILL_TYPE_PASSIVE)
                     {
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>(" + Central.main.langLib.titleTxt(TitleData.PASSIVE) + " " + Central.main.langLib.titleTxt(TitleData.SKILL) + ")</font>";
                        tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": -</font>";
                     }
                     else
                     {
                        if(SenjutsuskillData_effect.skill_damage == 0)
                        {
                           tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": -</font>";
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><br><font color=\'#FF0000\'>" + Central.main.langLib.titleTxt(TitleData.DAMAGE) + ": " + String(SenjutsuskillData_effect.skill_damage) + "</font>";
                        }
                        if(SenjutsuskillData_effect.skill_sp == 0)
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": -</font>";
                        }
                        else
                        {
                           tooltipStr = tooltipStr + "<br><font color=\'#FF5300\'>" + Central.main.langLib.titleTxt(TitleData.SP) + ": " + String(SenjutsuskillData_effect.skill_sp) + "</font>";
                        }
                        tooltipStr = tooltipStr + "<br><font color=\'#CC9900\'>" + Central.main.langLib.titleTxt(TitleData.COOLDOWN) + ": " + String(SenjutsuskillData.cooldown) + "</font>";
                     }
                     ToolTip_curlv = SenjutsuskillData.tooltip;
                     if(String(SenjutsuskillData_effect.effect_requirement_1).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr1 = SenjutsuskillData_effect.effect_requirement_1.split("|");
                     }
                     if(String(SenjutsuskillData_effect.effect_requirement_2).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr2 = SenjutsuskillData_effect.effect_requirement_2.split("|");
                     }
                     if(String(SenjutsuskillData_effect.effect_requirement_3).length > 0)
                     {
                        ToolTip_Requirement_curlv_arr3 = SenjutsuskillData_effect.effect_requirement_3.split("|");
                     }
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOEFFECT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetoeffect_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valCHANCETOHIT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_chancetohit_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_1\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_2\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_2));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valAMOUNT_3\]/g,Math.abs(SenjutsuskillData_effect.effect_amount_3));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_1\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_1)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_2\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_2)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100minusAMOUNT_3\]/g,String(100 - Number(SenjutsuskillData_effect.effect_amount_3)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_1\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_1)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_2\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_2)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[val100plusAMOUNT_3\]/g,String(100 + Number(SenjutsuskillData_effect.effect_amount_3)));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_1\]/g,Math.abs(int(SenjutsuskillData_effect.duration_1) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_2\]/g,Math.abs(int(SenjutsuskillData_effect.duration_2) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valTURN_3\]/g,Math.abs(int(SenjutsuskillData_effect.duration_3) - 1));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valDAMAGE\]/g,Math.abs(SenjutsuskillData_effect.skill_damage));
                     ToolTip_curlv = String(ToolTip_curlv).replace(/\[valLEVEL\]/g,Math.abs(SenjutsuskillData_effect.skill_level));
                     if(ToolTip_Requirement_curlv_arr1.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_1\]/g,Math.abs(ToolTip_Requirement_curlv_arr1[3]));
                     }
                     if(ToolTip_Requirement_curlv_arr2.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_2\]/g,Math.abs(ToolTip_Requirement_curlv_arr2[3]));
                     }
                     if(ToolTip_Requirement_curlv_arr3.length > 0)
                     {
                        ToolTip_curlv = String(ToolTip_curlv).replace(/\[valreqAMOUNT_3\]/g,Math.abs(ToolTip_Requirement_curlv_arr3[3]));
                     }
                     if(ToolTip_curlv == "")
                     {
                        tooltipStr = String("<font size=\'13\'>" + tooltipStr + "</font>");
                     }
                     else
                     {
                        tooltipStr = String("<font size=\'13\'>" + tooltipStr + "<br>" + ToolTip_curlv + "</font>");
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_SKILL_CLASS:
               if(Central.main.SKILL_DATA[id])
               {
                  obj = Central.main.SKILL_DATA[id];
               }
               if(obj)
               {
                  if(Central.main.dataFilter(obj) == false)
                  {
                     return null;
                  }
                  if(isLimited)
                  {
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[0]);
                     tooltipStr = tooltipStr + "<br>" + _limitedMsg + "</font>";
                  }
                  else
                  {
                     special_class = obj.special_class;
                     skillTypeStr = String(Central.main.langLib.get(1580)[special_class - 1]);
                     switch(id)
                     {
                        case "skill2004":
                           levelBouns = int(Central.main.getMainChar().getLevel()) - 60;
                           if(levelBouns < 0)
                           {
                              levelBouns = 0;
                           }
                           amount = 700 + levelBouns * 64;
                           break;
                        case "skill2000":
                           levelBouns = int(Central.main.getMainChar().getLevel()) - 60;
                           if(levelBouns < 0)
                           {
                              levelBouns = 0;
                           }
                           amount = 1000 + levelBouns * 70;
                     }
                     tooltipStr = String("<b>" + obj.name + "</b>");
                     tooltipStr = tooltipStr + "<br>(" + skillTypeStr + ")";
                     if(String(obj.description).length > 0)
                     {
                        tooltipStr = tooltipStr + "<br><br>" + String(obj.description).replace("[valamount]",amount.toString()).replace("[valamount]",amount.toString());
                     }
                  }
               }
               break;
            case TOOLTIP_TYPE_PET:
               petArr = Central.main.PET_DATA.toArray();
               if(petArr)
               {
                  if(petArr.length > 0)
                  {
                     for(i = 0; i < petArr.length; i++)
                     {
                        if(Central.main.dataFilter(petArr[i]) == false)
                        {
                           return null;
                        }
                        if(petArr[i].id == id)
                        {
                           if(isLimited)
                           {
                              tooltipStr = String("<b>" + petArr[i].name + "</b>");
                              tooltipStr = tooltipStr + "<br><br><font color=\'#00FF99\'>" + String(Central.main.langLib.get(1605)[5]);
                              break;
                           }
                           tooltipStr = String("<b>" + petArr[i].name + "</b>");
                           tooltipStr = tooltipStr + "<br>(" + Central.main.langLib.titleTxt(TitleData.PET) + ")";
                           if(String(petArr[i].description).length > 0)
                           {
                              tooltipStr = tooltipStr + "<br><br>" + String(petArr[i].description);
                           }
                           break;
                        }
                     }
                  }
               }
         }
         return tooltipStr;
      }
      
      private static function getGearsetTooltip(itemObj:Object) : String
      {
         var i:int = 0;
         var tmpItemData:Object = null;
         var itemType:String = null;
         var equipedItem:String = null;
         var equipedCount:int = 0;
         var tooltipStr:String = "";
         var setObj:Object = Central.main.getMainChar().getGearset();
         var currGearset:String = "gearset" + itemObj.relate_set;
         var setData:Object = Central.main.GEAR_SET_DATA.find(currGearset);
         var totalGearSetNum:int = !!setObj[currGearset]?int(setObj[currGearset]):0;
         var memberList:Array = setData.member_list;
         tooltipStr = tooltipStr + ("<br><br><b>" + setData.name + "(" + totalGearSetNum + "/" + (setData.effect.length + 1) + ")</b></br></br>");
         for(i = 0; i < memberList.length; i++)
         {
            tmpItemData = Central.main.toolkit.getItemDataByID(memberList[i]);
            if(tmpItemData !== null)
            {
               if(!(tmpItemData.gender != null && tmpItemData.gender != Central.main.getMainChar().getGender()))
               {
                  itemType = Central.main.toolkit.getItemType(memberList[i]);
                  equipedItem = "";
                  switch(itemType)
                  {
                     case InventoryData.TYPE_WEAPON:
                        equipedItem = Central.main.getMainChar().getWeapon();
                        break;
                     case InventoryData.TYPE_BACK_ITEM:
                        equipedItem = Central.main.getMainChar().getBackItem();
                        break;
                     case InventoryData.TYPE_HAIR:
                        equipedItem = !!Central.main.HAIR_DATA?Central.main.toolkit.getIDBySubData("swfName",Central.main.getMainChar().getHair().replace("hair_",""),Central.main.HAIR_DATA):"";
                        break;
                     case InventoryData.TYPE_BODY_SET:
                        equipedItem = Central.main.getMainChar().getBodySet();
                        break;
                     case InventoryData.TYPE_ACCESSORY:
                        equipedItem = Central.main.getMainChar().getAccessory();
                  }
                  if(equipedItem == memberList[i])
                  {
                     equipedCount++;
                     tooltipStr = tooltipStr + ("<br><font color=\'#00FF00\'><b>" + tmpItemData.name + "</b></font></br>");
                  }
                  else
                  {
                     tooltipStr = tooltipStr + ("<br><font color=\'#999999\'><b>" + tmpItemData.name + "</b></font></br>");
                  }
               }
            }
         }
         tooltipStr = tooltipStr + ("<br><br><b>" + (AppData.lang == AppData.ZH?"套裝效果(":"Set Effect(s)(") + (equipedCount > 0?equipedCount - 1:0) + "/" + setData.effect.length + ")</b></br></br>");
         for(i = 0; i < setData.effect.length; i++)
         {
            if(equipedCount - 1 > i)
            {
               tooltipStr = tooltipStr + ("<br><font color=\'#00FF00\'><b>" + getGearsetEffectDescription(setData.effect[i]) + "</b></font></br>");
            }
            else
            {
               tooltipStr = tooltipStr + ("<br><font color=\'#999999\'><b>" + getGearsetEffectDescription(setData.effect[i]) + "</b></font></br>");
            }
         }
         return tooltipStr;
      }
      
      private static function getExtraEffectTooltip(itemObj:Object) : String
      {
         var i:int = 0;
         var tooltipStr:String = "";
         var enemyName:String = "";
         tooltipStr = tooltipStr + ("<br><br><b>" + (AppData.lang == AppData.ZH?"額外效果":"Extra Effect") + "</b></br></br>");
         tooltipStr = tooltipStr + ("<br>" + (AppData.lang == AppData.ZH?"有效目標:":"Target Enemy:") + "</br>");
         for(i = 0; i < itemObj.extra_effect.enemy.length; i++)
         {
            enemyName = enemyName + (enemyName == ""?Central.main.ENEMY_DATA.find(itemObj.extra_effect.enemy[i]).name:"/" + Central.main.ENEMY_DATA.find(itemObj.extra_effect.enemy[i]).name);
         }
         tooltipStr = tooltipStr + ("<br>" + enemyName + "</br>");
         tooltipStr = tooltipStr + ("<br><font color=\'#00FF00\'>" + getExtraEffectDescription(itemObj.extra_effect) + "</font></br>");
         tooltipStr = tooltipStr + ("<br><br>**" + (AppData.lang == AppData.ZH?"以上額外效果只在 " + itemObj.extra_effect.event_name + " 期間生效**":"Above extra effect only active during " + itemObj.extra_effect.event_name + " **") + "</br></br>");
         return tooltipStr;
      }
      
      private static function getSkillTypeName(skillType:String) : String
      {
         var i:int = 0;
         for(i = 0; i < ALL_NINJUTSU_TYPES.length; i++)
         {
            if(ALL_NINJUTSU_TYPES[i] == skillType)
            {
               return Central.main.langLib.btnTxt(SKILL_TYPE_BUTTON_NAME_ARR[i]);
            }
         }
         return null;
      }
   }
}
