package ninjasaga.data 
{
    import flash.text.*;
    import ninjasaga.*;
    
    public final class BattleData extends Object
    {
        public function BattleData()
        {
            super();
            return;
        }

        public static function displaySpecialText(arg1:Object, arg2:flash.text.TextField, arg3:flash.text.TextField):void
        {
            var loc1:*;
            loc1 = String(arg1.damage);
            if (arg1.skill_hit_num >= 2)
            {
                loc1 = String(int(loc1) * int(arg1.skill_hit_num));
            }
            var loc2:*;
            loc2 = String((int(arg1.effect.duration) - 1));
            var loc3:*;
            loc3 = String(arg1.effect.amount);
            var loc4:*;
            loc4 = ninjasaga.data.AppData.lang;
            switch (loc4) 
            {
                case ninjasaga.data.AppData.EN:
                {
                    loc4 = arg1.effect.type;
                    switch (loc4) 
                    {
                        case EFFECT_STUN:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Stun(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_SLEEP:
                        {
                            arg2.text = "Sleep(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DAMAGE_REDUCTION:
                        {
                            arg2.text = "Damage(-" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DAMAGE_BONUS:
                        {
                            arg2.text = "Damage(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_AGILITY_BONUS:
                        {
                            arg2.text = "Agility(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DODGE_BONUS:
                        case EFFECT_PET_DODGE_BONUS:
                        {
                            arg2.text = "Dodge(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_CRITICAL_CHANCE_BONUS:
                        {
                            arg2.text = "Critical(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_REGENERATE_CHAKRA:
                        {
                            arg2.text = "Regenerate CP(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_REGENERATE_HP:
                        {
                            arg2.text = "Regenerate HP(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_COMBUSTION:
                        {
                            arg2.text = "Combustion +" + loc1 + "% damage (" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_PURIFY:
                        {
                            arg2.text = "Purify (remove all negative effect)";
                            break;
                        }
                        case EFFECT_REACTIVE_FORCE:
                        {
                            arg2.text = "Reactive Force (return " + loc1 + "% damage) (" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BLEEDING:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Bleeding(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BURN:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Burning(3%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BLIND:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Blind(70%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BUNDLE:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Restriction(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DRAIN_CHAKRA:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Drain CP(15%)";
                            break;
                        }
                        case EFFECT_DRAIN_HP:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Drain HP(15%)";
                            break;
                        }
                        case EFFECT_MERIDIANS_SEAL:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "Restrict skills & charge";
                            break;
                        }
                        default:
                        {
                            arg3.text = "Damage: " + loc1;
                            arg2.text = "-";
                            break;
                        }
                    }
                    break;
                }
                case ninjasaga.data.AppData.ES:
                {
                    loc4 = arg1.effect.type;
                    switch (loc4) 
                    {
                        case EFFECT_STUN:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Aturdir(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_SLEEP:
                        {
                            arg2.text = "Drmir(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DAMAGE_REDUCTION:
                        {
                            arg2.text = "Daño(-" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DAMAGE_BONUS:
                        {
                            arg2.text = "Daño(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_AGILITY_BONUS:
                        {
                            arg2.text = "Agilidad(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DODGE_BONUS:
                        case EFFECT_PET_DODGE_BONUS:
                        {
                            arg2.text = "Evadido(+" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_CRITICAL_CHANCE_BONUS:
                        {
                            arg2.text = "Critico(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_REGENERATE_CHAKRA:
                        {
                            arg2.text = "Regenera CP(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_REGENERATE_HP:
                        {
                            arg2.text = "Regenera HP(" + loc3 + "%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_COMBUSTION:
                        {
                            arg2.text = "Combustion +" + loc1 + "% daño (" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_PURIFY:
                        {
                            arg2.text = "Purificar (elimina el efecto negativo)";
                            break;
                        }
                        case EFFECT_REACTIVE_FORCE:
                        {
                            arg2.text = "Reactiva la fuerza (return " + loc1 + "% daño) (" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BLEEDING:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Sangrando(25%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BURN:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Burning(3%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BLIND:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Incendiar(70%)(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_BUNDLE:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Restriccion(" + loc2 + " turns)";
                            break;
                        }
                        case EFFECT_DRAIN_CHAKRA:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Reduce CP(15%)";
                            break;
                        }
                        case EFFECT_DRAIN_HP:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Reduce HP(15%)";
                            break;
                        }
                        case EFFECT_MERIDIANS_SEAL:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "Restrict skills & charge";
                            break;
                        }
                        default:
                        {
                            arg3.text = "Daño: " + loc1;
                            arg2.text = "-";
                            break;
                        }
                    }
                    break;
                }
                case ninjasaga.data.AppData.ZH:
                {
                    loc4 = arg1.effect.type;
                    switch (loc4) 
                    {
                        case EFFECT_STUN:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "暈眩(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_SLEEP:
                        {
                            arg2.text = "睡眠(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_DAMAGE_REDUCTION:
                        {
                            arg2.text = "傷害(-" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_DAMAGE_BONUS:
                        {
                            arg2.text = "傷害(+" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_AGILITY_BONUS:
                        {
                            arg2.text = "敏捷(+" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_DODGE_BONUS:
                        case EFFECT_PET_DODGE_BONUS:
                        {
                            arg2.text = "閃避率(+" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_CRITICAL_CHANCE_BONUS:
                        {
                            arg2.text = "暴擊率(+" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_REGENERATE_CHAKRA:
                        {
                            arg2.text = "回復CP(" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_REGENERATE_HP:
                        {
                            arg2.text = "回復HP(" + loc3 + "%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_COMBUSTION:
                        {
                            arg2.text = "燃燒(+" + loc1 + "% 傷害 (" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_PURIFY:
                        {
                            arg2.text = "淨化(除去所有負面狀態)";
                            break;
                        }
                        case EFFECT_REACTIVE_FORCE:
                        {
                            arg2.text = "傷害反彈(反彈 " + loc1 + "% 傷害) (" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_BLEEDING:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "出血(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_BURN:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "灼傷(3%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_BLIND:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "致盲(70%)(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_BUNDLE:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "束縛(" + loc2 + " 回合)";
                            break;
                        }
                        case EFFECT_DRAIN_CHAKRA:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "吸收CP(15%)";
                            break;
                        }
                        case EFFECT_DRAIN_HP:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "吸收HP(15%)";
                            break;
                        }
                        case EFFECT_MERIDIANS_SEAL:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "封脈:無法使用忍術及蓄力";
                            break;
                        }
                        default:
                        {
                            arg3.text = "傷害: " + loc1;
                            arg2.text = "-";
                            break;
                        }
                    }
                    break;
                }
            }
            return;
        }

        public static function getFadeText(arg1:String):String
        {
            var loc1:*;
            loc1 = arg1;
            switch (loc1) 
            {
                case ninjasaga.data.BattleData.EFFECT_REACTIVE_DEBUFF:
                {
                    return ninjasaga.Central.main.langLib.get(906) + " " + ninjasaga.Central.main.langLib.get(647);
                }
            }
            return "";
        }

        public static const WEAPON_ATTACK:String="weapon_attack";

        public static const ACTION_SKILL:String="skill";

        public static const ACTION_CLASS_SKILL:String="class_skill";

        public static const CHAKRA_NATURAL_REGENERATION:Number=0.05;

        public static const CHAKRA_RECOVER_CHARGE:Number=0.25;

        public static const BASE_CRITICAL_CHANCE:Number=0.05;

        public static const BASE_DODGE_CHANCE:Number=0.05;

        public static const BASE_CRITICAL_MULTIPLIER:Number=1.5;

        public static const BATTLE_RUN_CHANGE:Number=0.5;

        public static const PVP_TURN_TIME:uint=20;

        public static const DAMAGE_LIMIT:uint=4000;

        public static const EFFECT_STUN:String="stun";

        public static const EFFECT_SLEEP:String="sleep";

        public static const EFFECT_DAMAGE_REDUCTION:String="damage_reduction";

        public static const EFFECT_DAMAGE_BONUS:String="damage_bonus";

        public static const EFFECT_AGILITY_BONUS:String="agility_bonus";

        public static const EFFECT_DODGE_BONUS:String="dodge_bonus";

        public static const EFFECT_PET_DODGE_BONUS:String="pet_dodge_bonus";

        public static const EFFECT_CRITICAL_CHANCE_BONUS:String="critical_chance_bonus";

        public static const EFFECT_REGENERATE_CHAKRA:String="regen_chakra";

        public static const EFFECT_REGENERATE_HP:String="regen_hp";

        public static const EFFECT_COMBUSTION:String="combustion";

        public static const EFFECT_PURIFY:String="purify";

        public static const EFFECT_REACTIVE_FORCE:String="reactive_force";

        public static const EFFECT_BLEEDING:String="bleeding";

        public static const EFFECT_BURN:String="burn";

        public static const EFFECT_BLIND:String="blind";

        public static const EFFECT_BUNDLE:String="bundle";

        public static const EFFECT_DRAIN_CHAKRA:String="drain_chakra";

        public static const EFFECT_DRAIN_HP:String="drain_hp";

        public static const EFFECT_POISON:String="poison";

        public static const EFFECT_GATE_OPENING:String="gate_opening";

        public static const EFFECT_FEAR:String="fear";

        public static const EFFECT_SOUL_CHAINS_BUNDLE:String="soul_chain_bundle";

        public static const EFFECT_PARASITE:String="parasite";

        public static const EFFECT_CHAKRA_SUCKER:String="chakra_sucker";

        public static const EFFECT_BURNING:String="burning";

        public static const EFFECT_HEAL:String="heal";

        public static const EFFECT_FEAR_WEAKEN:String="fear_weaken";

        public static const EFFECT_RESTORE_CP:String="restore_cp";

        public static const EFFECT_MERIDIANS_SEAL:String="meridians_seal";

        public static const EFFECT_PET_BURN:String="pet_burn";

        public static const EFFECT_PET_FEAR_WEAKEN:String="pet_fear_weaken";

        public static const EFFECT_FRENZY:String="frenzy";

        public static const EFFECT_BURN_CP:String="burn_cp";

        public static const EFFECT_MANA_SHIELD:String="mana_shield";

        public static const EFFECT_HEAL_OVER_TIME:String="heal_overtime";

        public static const EFFECT_COOLDOWN_REDUCTION:String="cooldown_reduction";

        public static const EFFECT_BERSERKER_MODE:String="berserker_mode";

        public static const EFFECT_THUNDERSTORM_MODE:String="thunderstorm_mode";

        public static const EFFECT_WIND_PEACE:String="wind_peace";

        public static const EFFECT_WIND_PEACE_2:String="wind_peace_2";

        public static const EFFECT_WIND_PEACE_3:String="wind_peace_3";

        public static const EFFECT_WIND_PEACE_4:String="wind_peace_4";

        public static const EFFECT_FIRE_ENERGY_EXCITATION:String="fire_energy_excitation";

        public static const EFFECT_EXCITATION_CP:String="excitation_cp";

        public static const EFFECT_EXCITATION_CHARGE:String="excitation_charge";

        public static const EFFECT_LIGHTING_BUNDLE:String="lighting_bundle";

        public static const EFFECT_LIGHTING_BUNDLE_2:String="lighting_bundle_2";

        public static const EFFECT_LIGHTING_BUNDLE_3:String="lighting_bundle_3";

        public static const EFFECT_LIGHTING_BUNDLE_4:String="lighting_bundle_4";

        public static const EFFECT_AMONG_ROCKS:String="among_rocks";

        public static const EFFECT_COLLIDING_WAVE:String="colliding_wave";

        public static const EFFECT_REDUCE_HP_CP:String="reduce_hp_cp";

        public static const EFFECT_SERENE_MIND:String="serene_mind";

        public static const EFFECT_INTERNAL_INJURY:String="battle_internal_injury";

        public static const EFFECT_CALM_TARGET:String="calm_target";

        public static const EFFECT_DARK_CURSE:String="dark_curse";

        public static const EFFECT_GUARD:String="guard";

        public static const EFFECT_CUBE_ILLUSION:String="cube_illusion";

        public static const EFFECT_SILVER_CHAIN_BUNDLE:String="silver_chain_bundle";

        public static const EFFECT_BLOOD_FEED:String="blood_feed";

        public static const EFFECT_ACCURATE_WEAPON:String="accurate";

        public static const EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:String="critical_chance_bonus_weapon";

        public static const EFFECT_DAMAGE_BONUS_WEAPON:String="damage_bonus_weapon";

        public static const EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:String="critical_damage_bonus_weapon";

        public static const EFFECT_BLOOD_DRINKER:String="blood_drinker";

        public static const EFFECT_REWIND:String="rewind";

        public static const EFFECT_PET_DRAIN_HP:String="pet_drain_hp";

        public static const EFFECT_PET_DRAIN_CP:String="pet_drain_cp";

        public static const EFFECT_ADD_COOLDOWN:String="add_cooldown";

        public static const EFFECT_BLOODLUST_DEDICATION:String="bloodlust_dedication";

        public static const EFFECT_REACTIVE_DEBUFF:String="reactive_debuff";

        public static const EFFECT_PETRIFICATION:String="effect_petrification";

        public static const EFFECT_EXTRA_CP_RECOVER:String="effect_extra_cp_recover";

        public static const EFFECT_DARKNESS:String="effect_darkness";

        public static const EFFECT_PET_ATTENTION:String="pet_attention";

        public static const EFFECT_PET_DAMAGE_BONUS:String="pet_damage_bonus";

        public static const EFFECT_PET_WEAKEN:String="pet_weaken";

        public static const EFFECT_CATALYTIC_MATTER:String="catalytic_matter";

        public static const EFFECT_DISMANTLE:String="dismantle";

        public static const EFFECT_PET_FREEZE:String="pet_freeze";

        public static const EFFECT_PET_DAMAGE_REDUCTION:String="pet_damage_reduction";

        public static const EFFECT_PET_DAMAGE_TO_CP:String="pet_damage_to_cp";

        public static const EFFECT_PET_BLEEDING:String="pet_bleeding";

        public static const EFFECT_STUN_RANDOM:String="stun_random";

        public static const EFFECT_PET_SAVE_CP:String="pet_save_cp";

        public static const EFFECT_PET_LIGHTNING:String="pet_lightning";

        public static const EFFECT_PET_DRAIN_HP_KEKKAI:String="pet_drain_hp_kekkai";

        public static const EFFECT_INTERNAL_INJURY_RANDOM:String="internal_injury_random";

        public static const EFFECT_BURN_HP:String="burn_hp";

        public static const EFFECT_COMPLETE_GUARD:String="complete_guard";

        public static const EFFECT_PET_BLIND:String="pet_blind";

        public static const EFFECT_CHAOS:String="chaos";

        public static const EFFECT_PET_DEBUFF_RESIST:String="pet_debuff_resist";

        public static const EFFECT_PET_HEAL:String="pet_heal";

        public static const EFFECT_PET_REDUCE_CHARGE:String="pet_reduce_charge";

        public static const EFFECT_BURN_CP_HP:String="burn_cp_hp";

        public static const EFFECT_FLAME_EATER:String="flame_eater";

        public static const EFFECT_PET_REFLECT_ATTACK:String="pet_reflect_attack";

        public static const EFFECT_CLEAR_BUFF:String="clear_buff";

        public static const EFFECT_BUNNY_FRENZY:String="bunny_frenzy";

        public static const EFFECT_ATTACK_MODE:String="attack_mode";

        public static const EFFECT_DEFENCE_MODE:String="defence_mode";

        public static const EFFECT_DRAIN_HP_CP:String="drain_hp_cp";

        public static const EFFECT_WAKE_UP:String="wake_up";

        public static const EFFECT_RANDOM_SLEEP:String="random_sleep";

        public static const EFFECT_PET_DISORIENTED:String="pet_disoriented";

        public static const EFFECT_PET_ENERGIZE:String="pet_energize";

        public static const EFFECT_LIGHT_IMPLUSE:String="light_impluse";

        public static const EFFECT_DODGE_REDUCTION:String="dodge_reduction";

        public static const EFFECT_DISTRACT:String="distract";

        public static const EFFECT_HAMSTRING:String="hamstring";

        public static const EFFECT_ECSTATIC_SOUND:String="ecstatic_sound";

        public static const EFFECT_PROFUSION_OF_GHOSTS:String="profusion_of_ghosts";

        public static const EFFECT_PET_RANDOM_EFFECT_ON_DEFENDER:String="pet_random_effect_on_defender";

        public static const EFFECT_PET_RANDOM_EFFECT_ON_MASTER:String="pet_random_effect_on_master";

        public static const EFFECT_ACCURATE:String="effect_accurate";

        public static const EFFECT_CLEAR_BUFF_NO_RANDOM:String="clear_buff_no_random";

        public static const SKILL_307:String="skill_307";

        public static const SKILL_310:String="skill_310";

        public static const SKILL_311:String="skill_311";

        public static const SKILL_312:String="skill_312";

        public static const EFFECT_RESTRICT_CHARGE:String="restrict_charge";

        public static const EFFECT_CRIT_CHANCE_DMG:String="crit_chance_dmg";

        public static const MONSTER_HP1:String="monster_hp1";

        public static const EFFECT_CLEARBUFF_DODGEREDUCTION:String="clearbuff_dodgereduction";

        public static const EFFECT_CLEARBUFF_DAMAGEREDUCTION:String="clearbuff_damagereduction";

        public static const EFFECT_HALFHP_DAMAGE_REDUCTION:String="halfhp_damage_reduction";

        public static const SKILL_285:String="skill_285";

        public static const SKILL_287:String="skill_287";

        public static const SKILL_234:String="skill_234";

        public static const SKILL_236:String="skill_236";

        public static const SKILL_302:String="skill_302";

        public static const SKILL_304:String="skill_304";

        public static const SKILL_251:String="skill_251";

        public static const SKILL_253:String="skill_253";

        public static const SKILL_268:String="skill_268";

        public static const SKILL_268_2:String="skill_268_2";

        public static const SKILL_270:String="skill_270";

        public static const SKILL_2000:String="skill_2000";

        public static const SKILL_2001:String="skill_2001";

        public static const SKILL_2002:String="skill_2002";

        public static const SKILL_2003:String="skill_2003";

        public static const SKILL_2004:String="skill_2004";

        public static const EFFECT_DECREASE_CRITICAL_CHANCE:String="effect_decrease_critical_chance";

        public static const SKILL_335:String="skill_335";

        public static const EFFECT_HEAL_OVER_TIME_NPC:String="effect_heal_overtime_npc";

        public static const SKILL_342:String="skill_342";

        public static const SKILL_345:String="skill_345";

        public static const EFFECT_DAMAGE_BONUS_FIX_NUM:String="dmgbonus_fix_num";

        public static const SKILL_359:String="skill_359";

        public static const SKILL_368:String="skill_368";

        public static const SKILL_369:String="skill_369";

        public static const SKILL_336:String="skill_336";

        public static const SKILL_501:String="skill_501";

        public static const EFFECT_PUMPKIN_POWER:String="effect_pumpkin_power";

        public static const SKILL_377:String="skill_377";

        public static const EFFECT_DOT_HP:String="dot_hp";

        public static const SKILL_341:String="skill_341";

        public static const EFFECT_CLEARBUFF:String="clearbuff";

        public static const EFFECT_CLEARBUFF_STUN:String="clearbuff_stun";

        public static const INSTANT_KILL:String="instant_kill";

        public static const INSTANT_CUT_HALF_HP:String="cut_half_hp";

        public static const EFFECT_ADD_PURIFY_CHANCE:String="add_purify_chance";

        public static const EFFECT_WEAPON_CHAOS_PERCENT:String="chaos_percent";

        public static const EFFECT_REDUCE_CP_REQUIRE:String="reduce_cp_require";

        public static const EFFECT_PURIFY_RESTORE_HP:String="purify_restore_hp";

        public static const EFFECT_ADD_CRITICAL_CHANCE:String="add_critical_chance";

        public static const EFFECT_ADD_DODGE_BONUS:String="add_dodge_bonus";

        public static const EFFECT_ADD_DAMAGE_BONUS:String="add_damage_bonus";

        public static const EFFECT_ADD_DODGE_RANDOM:String="add_dodge_random";

        public static const EFFECT_ADD_DODGE_REDUCTION:String="add_dodge_reduction";

        public static const EFFECT_ADD_DODGERE_ABOVE_HP:String="add_dodge_reduction_above_hp";

        public static const EFFECT_INSTANT_KILL_BELOW_HP:String="instant_kill_below_hp";

        public static const EFFECT_REDUCE_DAMAGE_BONUS:String="reduce_damage_bonus";

        public static const EFFECT_ATTACKER_BLIND:String="attacker_blind";

        public static const EFFECT_WEAPON_MANA_SHIELD:String="weapon_mana_shield";

        public static const EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:String="reduce_damage_bonus_present";

        public static const EFFECT_REDUCE_DAMAGE_AMOUNT:String="reduce_damage_amount";

        public static const EFFECT_ADD_FEEDBACK_CHANCE:String="add_feedback_chance";

        public static const EFFECT_REDUCE_TARGET_CP:String="reduce_target_cp";

        public static const EFFECT_GUARD_BELOW_DAMAGE:String="guard_below_damage";

        public static const EFFECT_WEAPON_FULL_GUARD:String="weapon_full_guard";

        public static const EFFECT_RECIEVE_DAMAGE_CP:String="recieve_damage_cp";

        public static const EFFECT_ADD_HP_AMOUNT:String="add_hp_amount";

        public static const EFFECT_ADD_HP_AMOUNT_PRESENT:String="add_hp_amount_present";

        public static const EFFECT_ADD_CP_AMOUNT_PRESENT:String="add_cp_amount_present";

        public static const EFFECT_ADD_CP_BELOW_CP:String="add_cp_below_cp";

        public static const EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:String="dodge_success_damage_bonus";

        public static const EFFECT_CP_CONSUME_TO_HP:String="cp_consume_to_hp";

        public static const EFFECT_ATTACKER_RESTORE_HP:String="attacker_restore_hp";

        public static const EFFECT_ATTACKER_RESTORE_CP:String="attacker_restore_cp";

        public static const EFFECT_DEFENDER_DAMAGE_CP:String="defender_damage_cp";

        public static const EFFECT_DEBUFF_RESTORE_HP_PRESENT:String="debuff_restore_hp_present";

        public static const EFFECT_DEBUFF_RESTORE_CP_PRESENT:String="debuff_restore_cp_present";

        public static const EFFECT_DEFENDER_BURNING:String="defender_burning";

        public static const EFFECT_DEFENDER_BUNDLE:String="defender_bundle";

        public static const EFFECT_DEFENDER_POISON:String="defender_poison";

        public static const EFFECT_ATTACKER_DAMAGE_REDUCTION:String="attacker_damage_reduction";

        public static const EFFECT_ATTACKER_DAMAGE_BONUS:String="attacker_damage_bonus";

        public static const EFFECT_DEFENDER_CLEAR_BUFF:String="defender_clear_buff";

        public static const EFFECT_ATTACKER_REDUCE_COOLDOWN:String="attack_reduce_cooldown";

        public static const EFFECT_DEFENDER_FREEZE:String="defender_freeze";

        public static const EFFECT_DEFENDER_CRITICAL_CHANCE:String="defender_critical_chance";

        public static const EFFECT_DEFENDER_RESTORE_HP_PRESENT:String="defender_restore_hp_present";

        public static const EFFECT_ATTACKER_BLEEDING:String="attacker_bleeding";

        public static const EFFECT_ADD_CP_AMOUNT:String="add_cp_amount";

        public static const EFFECT_REDUCE_DODGE_RANDOM:String="reduce_dodge_random";

        public static const EFFECT_ITEM_RESTORE_BONUS:String="item_restore_bonus";

        public static const EFFECT_ITEM_RESTORE_BONUS_PRESENT:String="item_restore_bonus_present";

        public static const EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:String="item_restore_cp_bonus_present";

        public static const EFFECT_CHARGE_CP_BONUS:String="charge_cp_bonus";

        public static const EFFECT_ATTACKER_FREEZE:String="attacker_freeze";

        public static const EFFECT_ABSORB_ATTACKER_HP_PRESENT:String="absorb_attacker_hp_present";

        public static const EFFECT_ATTACK_BUNDLE:String="attacker_bundle";

        public static const EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:String="attacker_critical_damage_bonus";

        public static const EFFECT_CONVERT_FULLDMG_TO_HP:String="convert_fulldmg_to_hp";

        public static const EFFECT_HEAL_OVER_TIME_FIX_NUM:String="heal_overtime_fix_num";

        public static const EFFECT_ADD_COMBUSTION_CHANCE:String="add_combustion_chance";

        public static const EFFECT_ALL_CP_DODGE_BONUS:String="all_cp_dodge_bonus";

        public static const EFFECT_ALL_CP_DRAIN_HP:String="all_cp_drain_hp";

        public static const EFFECT_ALL_CP_BLIND:String="all_cp_blind";

        public static const EFFECT_ALL_CP_GUARD_RESIST:String="all_cp_guard_resist";

        public static const EFFECT_ALL_CP_HEAL:String="all_cp_heal";

        public static const EFFECT_HUNDRED_PERCENT_ATTACK:String="hundred_percent_attack";

        public static const EFFECT_REDUCE_PURIFY_CHANCE:String="reduce_purify_chance";

        public static const EFFECT_BURN_CP_FIX_NUM:String="burn_cp_fix_num";

        public static const EFFECT_CLEARBUFF_REDUCE_HP_CP:String="clearbuff_reduce_hp_cp";

        public static const EFFECT_CHARGE_RECOVER_HP:String="charge_recover_hp";

        public static const EFFECT_ADD_ALL_COOLDOWN:String="add_all_cooldown";

        public static const EFFECT_BLEEDING_FIX_NUM:String="bleeding_fix_num";

        public static const EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:String="damage_bonus_weapon_fix_num";

        public static const EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:String="cri_dmg_bonus_wpn_fix_num";

        public static const EFFECT_MAX_HP:String="effect_max_hp";

        public static const EFFECT_MAX_HP_PRESENT:String="effect_max_hp_present";

        public static const EFFECT_MAX_CP:String="effect_max_cp";

        public static const EFFECT_MAX_CP_PRESENT:String="effect_max_cp_present";

        public static const EFFECT_BURN_FIX_NUM:String="burn_fix_num";

        public static const EFFECT_PET_WEAKEN_FIX_NUM:String="pet_weaken_fix_num";

        public static const EFFECT_REDUCE_HP_PRESENT:String="reduce_hp_present";

        public static const EFFECT_DAMAGE_HP_FIX_NUM:String="damage_hp_fix_num";

        public static const ITEM_SMOKE:String="smoke";

        public static const ITEM_RESTORE_HP:String="restore_hp";

        public static const ITEM_RESTORE_CP:String="restore_cp";

        public static const ITEM_SPECIAL_RUNE_SCROLL:String="special_rune_scroll";

        public static const ITEM_PERCENT_HP:String="restore_percent_hp";

        public static const ITEM_PERCENT_CP:String="restore_percent_cp";

        public static const ITEM_PERCENT_HPCP:String="restore_percent_hpcp";

        public static const ITEM_DAMAGE_BONUS_N_REDUCTION:String="damage_bonus_n_reduction";

        public static const ITEM_DODGE_BONUS_N_CRITICAL_CHANCE:String="dodge_bonus_n_critical_chance";

        public static const ITEM_DODGE_BONUS_N_PURIFY_CHANCE:String="dodge_bonus_n_purify_chance";

        public static const ITEM_CRITICAL_CHANCE_N_PURIFY_CHANCE:String="critical_chance_n_purify_chance";

        public static const ITEM_DAMAGE_BONUS_N_ACCURATE:String="damage_bonus_n_accurate";

        public static const ITEM_CLEARDEBUFF_RESIST:String="clearbuff_resist";

        public static const ITEM_STRENGTHEN_N_BLEEDING:String="strengthen_n_bleeding";

        public static const ITEM_BOTH_DAMAGE_REDUCTION:String="both_damage_reduction";

        public static const EFFECT_RESIST_OVERTIME:String="resist_overtime";

        public static const ITEM_EFFECT_SEAL_GAN:String="seal_gan";

        public static const ITEM_EFFECT_SPY_CP:String="spy_cp";

        public static const EFFECT_BURN_PROTECTION:String="burn_protection";

        public static const EFFECT_BURN_CP_CLEAR_BUFF:String="burn_cp_clear_buff";

        public static const EFFECT_BURN_CP_CLEAR_BUFF_WEAK:String="burn_cp_clear_buff_weak";

        public static const EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:String="battle_internal_injury_fear";

        public static const EFFECT_INTERNAL_INJURY_DARKNESS:String="battle_internalinjury_darkness";

        public static const EFFECT_HEAL_OVER_TIME_FIX_NUM_DARKNESS:String="battle_heal_over_time_darkness";

        public static const EFFECT_DAMAGE_DELAY:String="damage_delay";

        public static const EFFECT_DAMAGE_DELAY_INJURY:String="damage_delay_injury";

        public static const EFFECT_HEAL_MEMBER:String="heal_member";

        public static const EFFECT_PET_PERSEVERANCE_MASTER:String="pet_perseverance";

        public static const EFFECT_SENJUTSU_RECOVER_HP_CP:String="senjutsu_restore_hp_cp";

        public static const EFFECT_BACKITEM_RECOVER_TURN_SP:String="add_sp_amount_present";

        public static const EFFECT_WEAPON_SENJUTSU_DMG_BONUS:String="seninjutsu_damage_bonus";

        public static const CONSUMABLE_LIMIT:uint=5;

        public static const SIDE_FRIENDLY:uint=1;

        public static const SIDE_HOSTILE:uint=2;

        public static const SUBTYPE_NORMAL:uint=0;

        public static const SUBTYPE_CLAN:uint=1;

        public static const SUBTYPE_BOSS:uint=2;

        public static const SUBTYPE_RANDOM:uint=3;

        public static const SUBTYPE_CHALLENGEFRIEND:uint=4;

        public static const SUBTYPE_FRIENDBATTLE:uint=5;

        public static const REDUCETYPE_ALL:int=0;

        public static const REDUCETYPE_SKILL:int=1;

        public static const REDUCETYPE_TALENT:int=2;

        public static const WIND_PEACE_ARR:Array=[BattleData.EFFECT_WIND_PEACE, BattleData.EFFECT_WIND_PEACE_2, BattleData.EFFECT_WIND_PEACE_3, BattleData.EFFECT_WIND_PEACE_4];
    }
}
