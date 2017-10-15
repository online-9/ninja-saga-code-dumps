package ninjasaga.data 
{
    import ninjasaga.*;
    
    public final class TooltipData extends Object
    {
        public function TooltipData()
        {
            super();
            return;
        }

        public static function getItemTooltip(arg1:String, arg2:String, arg3:String=""):String
        {
            var loc2:*;
            loc2 = null;
            var loc5:*;
            loc5 = null;
            var loc6:*;
            loc6 = null;
            var loc7:*;
            loc7 = 0;
            var loc8:*;
            loc8 = 0;
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
            var loc14:*;
            loc14 = null;
            var loc15:*;
            loc15 = null;
            var loc16:*;
            loc16 = 0;
            var loc17:*;
            loc17 = 0;
            var loc18:*;
            loc18 = 0;
            var loc19:*;
            loc19 = 0;
            var loc1:*;
            loc1 = "";
            var loc3:*;
            loc3 = "";
            var loc4:*;
            loc4 = false;
            if (String(arg3).length > 0)
            {
                loc4 = true;
            }
            var loc20:*;
            loc20 = arg1;
            switch (loc20) 
            {
                case TOOLTIP_TYPE_HAIR:
                {
                    if (loc2 == ninjasaga.Central.main.HAIR_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (String(loc2.description).length > 0)
                        {
                            loc1 = (loc1 = String("<b>" + loc2.description + "</b>")) + "<br>(" + String(ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.HAIRSTYLE)).replace(":", "") + ")";
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_CLOTHING:
                {
                    loc5 = {};
                    if ((loc5 = ninjasaga.Central.main.getMainChar().getGender() != 0 ? ninjasaga.Central.main.BODY_SET_GIRL : ninjasaga.Central.main.BODY_SET_BOY)[arg2])
                    {
                        loc2 = loc5[arg2];
                    }
                    if (loc2)
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.CLOTHING_TOOLTIP) + ")") + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.LEVEL) + ": " + loc2.level;
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_WEAPON:
                {
                    if (loc2 == ninjasaga.Central.main.WEAPON_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.WEAPON) + ")") + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.LEVEL) + ": " + loc2.level) + "<br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": " + loc2.damage + "</font>";
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_BACKITEM:
                {
                    if (loc2 == ninjasaga.Central.main.BACK_ITEM_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.btnTxt(ninjasaga.data.ButtonData.BACK_ITEM) + ")") + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.LEVEL) + ": " + loc2.level;
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.EFFECT) + ": " + loc2.description;
                            }
                            else 
                            {
                                loc1 = loc1 + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.EFFECT) + ": -";
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_ITEM:
                {
                    if (loc2 == ninjasaga.Central.main.ITEM_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.ITEM) + ")") + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.LEVEL) + ": " + loc2.level;
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_ESSENCE:
                {
                    if (loc2 == ninjasaga.Central.main.ESSENCE_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.NINJA_ESSENCE) + ")";
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_MATERIAL:
                {
                    if (loc2 == ninjasaga.Central.main.MATERIAL_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.MATERIAL) + ")";
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_CURRENCY:
                {
                    if (loc2 == ninjasaga.Central.main.CURRENCY_DATA.find(arg2))
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc1 = String("<b>" + loc2.name + "</b>");
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_SKILL:
                {
                    if (ninjasaga.Central.main.SKILL_DATA[arg2])
                    {
                        loc2 = ninjasaga.Central.main.SKILL_DATA[arg2];
                    }
                    if (loc2)
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(arg3);
                        }
                        else 
                        {
                            loc3 = getSkillTypeName(loc2.type);
                            loc7 = loc2.damage;
                            if (loc2.skill_hit_num >= 2)
                            {
                                loc7 = Math.round(loc2.damage * loc2.skill_hit_num);
                            }
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + loc3 + ")") + "<br><br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.LEVEL) + ": " + loc2.level;
                            if (ninjasaga.Central.main.getMainChar().isBattleDebuffActive(ninjasaga.data.BattleData.SKILL_341) || ninjasaga.Central.main.getMainChar().isBattleDebuffActive(ninjasaga.data.BattleData.EFFECT_CUBE_ILLUSION) || ninjasaga.Central.main.getMainChar().isBattleBuffActive(ninjasaga.data.BattleData.EFFECT_REDUCE_CP_REQUIRE) || ninjasaga.Central.main.getMainChar().isBattleBuffActive(ninjasaga.data.BattleData.EFFECT_PET_SAVE_CP))
                            {
                                loc8 = 0;
                                if (ninjasaga.Central.main.getMainChar().isBattleDebuffActive(ninjasaga.data.BattleData.EFFECT_CUBE_ILLUSION))
                                {
                                    loc8 = Math.round(loc2.cp * 1.4);
                                }
                                if (ninjasaga.Central.main.getMainChar().isBattleDebuffActive(ninjasaga.data.BattleData.SKILL_341))
                                {
                                    loc8 = Math.round(loc2.cp * int(ninjasaga.Central.main.getMainChar().getBattleDebuff()[ninjasaga.data.BattleData.SKILL_341].amount) / 100);
                                }
                                if (ninjasaga.Central.main.getMainChar().isBattleDebuffActive(ninjasaga.data.BloodlineData.EFFECT_EXTRA_CP_USE))
                                {
                                    loc8 = Math.round(loc2.cp * 2);
                                }
                                if (ninjasaga.Central.main.getMainChar().isBattleBuffActive(ninjasaga.data.BattleData.EFFECT_PET_SAVE_CP))
                                {
                                    loc8 = Math.round(loc2.cp * (1 - int(ninjasaga.Central.main.getMainChar().getBattleBuff()[ninjasaga.data.BattleData.EFFECT_PET_SAVE_CP].amount) / 100));
                                }
                                if (ninjasaga.Central.main.getMainChar().isBattleBuffActive(ninjasaga.data.BattleData.EFFECT_REDUCE_CP_REQUIRE))
                                {
                                    loc8 = Math.round(loc2.cp * int(ninjasaga.Central.main.getMainChar().getBattleBuff()[ninjasaga.data.BattleData.EFFECT_REDUCE_CP_REQUIRE].amount) / 100);
                                }
                                loc1 = loc1 + "<br><font color=\'#0000FF\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.CHAKRA) + ": " + loc8 + "</font>";
                            }
                            else 
                            {
                                loc1 = loc1 + "<br><font color=\'#0000FF\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.CHAKRA) + ": " + loc2.cp + "</font>";
                            }
                            if (loc2.effect)
                            {
                                if (loc2.effect.type != ninjasaga.data.SkillData.EFFECT_TYPE_HEAL)
                                {
                                    loc1 = loc1 + "<br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": " + loc7 + "</font>";
                                }
                                else 
                                {
                                    loc1 = loc1 + "<br><font color=\'#00FF00\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.HEAL) + ": " + loc7 + "</font>";
                                }
                            }
                            else 
                            {
                                loc1 = loc1 + "<br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": " + loc7 + "</font>";
                            }
                            loc1 = loc1 + "<br>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.COOLDOWN) + ": " + loc2.cooldown;
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + loc2.description;
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_SENJUTSU:
                {
                    if (ninjasaga.Central.main.SENJUTSU_SKILL_DATA[arg2])
                    {
                        loc2 = ninjasaga.Central.main.SENJUTSU_SKILL_DATA[arg2];
                    }
                    if (loc2)
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(arg3);
                        }
                        else 
                        {
                            loc9 = "";
                            loc10 = "";
                            loc11 = [];
                            loc12 = [];
                            loc13 = [];
                            loc14 = loc2;
                            loc15 = loc2.effect[0];
                            if (arg2 == "senjutsu_skill3000")
                            {
                                loc15.skill_sp = ninjasaga.Central.main.getMainChar().maxSP;
                            }
                            loc1 = String("<b>" + loc14.name + "</b>");
                            if (loc14.senjutsu_type != ninjasaga.data.SenjutsuData.SKILL_TYPE_PASSIVE)
                            {
                                if (loc15.skill_damage != 0)
                                {
                                    loc1 = loc1 + "<br><br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": " + String(loc15.skill_damage) + "</font>";
                                }
                                else 
                                {
                                    loc1 = loc1 + "<br><br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": -</font>";
                                }
                                if (loc15.skill_sp != 0)
                                {
                                    loc1 = loc1 + "<br><font color=\'#FF5300\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.SP) + ": " + String(loc15.skill_sp) + "</font>";
                                }
                                else 
                                {
                                    loc1 = loc1 + "<br><font color=\'#FF5300\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.SP) + ": -</font>";
                                }
                                loc1 = loc1 + "<br><font color=\'#CC9900\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.COOLDOWN) + ": " + String(loc14.cooldown) + "</font>";
                            }
                            else 
                            {
                                loc1 = (loc1 = (loc1 = (loc1 = loc1 + "<br><font color=\'#CC9900\'>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.PASSIVE) + " " + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.SKILL) + ")</font>") + "<br><br><font color=\'#FF0000\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.DAMAGE) + ": -</font>") + "<br><font color=\'#FF5300\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.SP) + ": -</font>") + "<br><font color=\'#CC9900\'>" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.COOLDOWN) + ": -</font>";
                            }
                            loc9 = loc14.tooltip;
                            if (String(loc15.effect_requirement_1).length > 0)
                            {
                                loc11 = loc15.effect_requirement_1.split("|");
                            }
                            if (String(loc15.effect_requirement_2).length > 0)
                            {
                                loc12 = loc15.effect_requirement_2.split("|");
                            }
                            if (String(loc15.effect_requirement_3).length > 0)
                            {
                                loc13 = loc15.effect_requirement_3.split("|");
                            }
                            loc9 = String(loc9).replace("[valCHANCETOEFFECT_1]", Math.abs(loc15.effect_chancetoeffect_1));
                            loc9 = String(loc9).replace("[valCHANCETOEFFECT_2]", Math.abs(loc15.effect_chancetoeffect_2));
                            loc9 = String(loc9).replace("[valCHANCETOEFFECT_3]", Math.abs(loc15.effect_chancetoeffect_3));
                            loc9 = String(loc9).replace("[valCHANCETOHIT_1]", Math.abs(loc15.effect_chancetohit_1));
                            loc9 = String(loc9).replace("[valCHANCETOHIT_2]", Math.abs(loc15.effect_chancetohit_2));
                            loc9 = String(loc9).replace("[valCHANCETOHIT_3]", Math.abs(loc15.effect_chancetohit_3));
                            loc9 = String(loc9).replace("[valAMOUNT_1]", Math.abs(loc15.effect_amount_1));
                            loc9 = String(loc9).replace("[valAMOUNT_2]", Math.abs(loc15.effect_amount_2));
                            loc9 = String(loc9).replace("[valAMOUNT_3]", Math.abs(loc15.effect_amount_3));
                            loc9 = String(loc9).replace("[val100minusAMOUNT_1]", String(100 - Number(loc15.effect_amount_1)));
                            loc9 = String(loc9).replace("[val100minusAMOUNT_2]", String(100 - Number(loc15.effect_amount_2)));
                            loc9 = String(loc9).replace("[val100minusAMOUNT_3]", String(100 - Number(loc15.effect_amount_3)));
                            loc9 = String(loc9).replace("[val100plusAMOUNT_1]", String(100 + Number(loc15.effect_amount_1)));
                            loc9 = String(loc9).replace("[val100plusAMOUNT_2]", String(100 + Number(loc15.effect_amount_2)));
                            loc9 = String(loc9).replace("[val100plusAMOUNT_3]", String(100 + Number(loc15.effect_amount_3)));
                            loc9 = String(loc9).replace("[valTURN_1]", Math.abs((int(loc15.duration_1) - 1)));
                            loc9 = String(loc9).replace("[valTURN_2]", Math.abs((int(loc15.duration_2) - 1)));
                            loc9 = String(loc9).replace("[valTURN_3]", Math.abs((int(loc15.duration_3) - 1)));
                            loc9 = String(loc9).replace("[valDAMAGE]", Math.abs(loc15.skill_damage));
                            loc9 = String(loc9).replace("[valLEVEL]", Math.abs(loc15.skill_level));
                            if (loc11.length > 0)
                            {
                                loc9 = String(loc9).replace("[valreqAMOUNT_1]", Math.abs(loc11[3]));
                            }
                            if (loc12.length > 0)
                            {
                                loc9 = String(loc9).replace("[valreqAMOUNT_2]", Math.abs(loc12[3]));
                            }
                            if (loc13.length > 0)
                            {
                                loc9 = String(loc9).replace("[valreqAMOUNT_3]", Math.abs(loc13[3]));
                            }
                            if (loc9 != "")
                            {
                                loc1 = String("<font size=\'13\'>" + loc1 + "<br>" + loc9 + "</font>");
                            }
                            else 
                            {
                                loc1 = String("<font size=\'13\'>" + loc1 + "</font>");
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_SKILL_CLASS:
                {
                    if (ninjasaga.Central.main.SKILL_DATA[arg2])
                    {
                        loc2 = ninjasaga.Central.main.SKILL_DATA[arg2];
                    }
                    if (loc2)
                    {
                        if (ninjasaga.Central.main.dataFilter(loc2) == false)
                        {
                            return null;
                        }
                        if (loc4)
                        {
                            loc1 = (loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[0])) + "<br>" + arg3 + "</font>";
                        }
                        else 
                        {
                            loc18 = loc2.special_class;
                            loc3 = String(ninjasaga.Central.main.langLib.get(1580)[(loc18 - 1)]);
                            loc20 = arg2;
                            switch (loc20) 
                            {
                                case "skill2004":
                                {
                                    if ((loc16 = int(ninjasaga.Central.main.getMainChar().getLevel()) - 60) < 0)
                                    {
                                        loc16 = 0;
                                    }
                                    loc17 = 700 + loc16 * 64;
                                    break;
                                }
                                case "skill2000":
                                {
                                    if ((loc16 = int(ninjasaga.Central.main.getMainChar().getLevel()) - 60) < 0)
                                    {
                                        loc16 = 0;
                                    }
                                    loc17 = 1000 + loc16 * 70;
                                    break;
                                }
                            }
                            loc1 = (loc1 = String("<b>" + loc2.name + "</b>")) + "<br>(" + loc3 + ")";
                            if (String(loc2.description).length > 0)
                            {
                                loc1 = loc1 + "<br><br>" + String(loc2.description).replace("[valamount]", loc17.toString()).replace("[valamount]", loc17.toString());
                            }
                        }
                    }
                    break;
                }
                case TOOLTIP_TYPE_PET:
                {
                    if (loc6 == ninjasaga.Central.main.PET_DATA.toArray())
                    {
                        if (loc6.length > 0)
                        {
                            loc19 = 0;
                            while (loc19 < loc6.length) 
                            {
                                if (ninjasaga.Central.main.dataFilter(loc6[loc19]) == false)
                                {
                                    return null;
                                }
                                if (loc6[loc19].id == arg2)
                                {
                                    if (loc4)
                                    {
                                        loc1 = (loc1 = String("<b>" + loc6[loc19].name + "</b>")) + "<br><br><font color=\'#00FF99\'>" + String(ninjasaga.Central.main.langLib.get(1605)[5]);
                                    }
                                    loc1 = (loc1 = String("<b>" + loc6[loc19].name + "</b>")) + "<br>(" + ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.PET) + ")";
                                    if (String(loc6[loc19].description).length > 0)
                                    {
                                        loc1 = loc1 + "<br><br>" + String(loc6[loc19].description);
                                    }
                                }
                                ++loc19;
                            }
                        }
                    }
                    break;
                }
            }
            return loc1;
        }

        private static function getSkillTypeName(arg1:String):String
        {
            var loc1:*;
            loc1 = 0;
            loc1 = 0;
            while (loc1 < ALL_NINJUTSU_TYPES.length) 
            {
                if (ALL_NINJUTSU_TYPES[loc1] == arg1)
                {
                    return ninjasaga.Central.main.langLib.btnTxt(SKILL_TYPE_BUTTON_NAME_ARR[loc1]);
                }
                ++loc1;
            }
            return null;
        }

        public static const TOOLTIP_TYPE_HAIR:String="hair";

        public static const TOOLTIP_TYPE_CLOTHING:String="set";

        public static const TOOLTIP_TYPE_WEAPON:String="wpn";

        public static const TOOLTIP_TYPE_BACKITEM:String="backitem";

        public static const TOOLTIP_TYPE_ITEM:String="item";

        public static const TOOLTIP_TYPE_ESSENCE:String="essence";

        public static const TOOLTIP_TYPE_MATERIAL:String="material";

        public static const TOOLTIP_TYPE_CURRENCY:String="currency";

        public static const TOOLTIP_TYPE_SKILL:String="skill";

        public static const TOOLTIP_TYPE_SENJUTSU:String="senjutsu";

        public static const TOOLTIP_TYPE_SKILL_CLASS:String="skill_class";

        public static const TOOLTIP_TYPE_PET:String="pet";

        private static const ALL_NINJUTSU_TYPES:Array=[ninjasaga.data.SkillData.TYPE_WIND, ninjasaga.data.SkillData.TYPE_FIRE, ninjasaga.data.SkillData.TYPE_LIGHTNING, ninjasaga.data.SkillData.TYPE_EARTH, ninjasaga.data.SkillData.TYPE_WATER, ninjasaga.data.SkillData.TYPE_TAIJUTSU, ninjasaga.data.SkillData.TYPE_GENJUTSU];

        private static const SKILL_TYPE_BUTTON_NAME_ARR:Array=[ninjasaga.data.ButtonData.WIND, ninjasaga.data.ButtonData.FIRE, ninjasaga.data.ButtonData.THUNDER, ninjasaga.data.ButtonData.EARTH, ninjasaga.data.ButtonData.WATER, ninjasaga.data.ButtonData.TAIJUTSU, ninjasaga.data.ButtonData.GENJUTSU];
    }
}
