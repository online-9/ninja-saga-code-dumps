package ninjasaga.data
{
   import ninjasaga.Central;
   
   public final class EffectLangData
   {
       
      
      public function EffectLangData()
      {
         super();
      }
      
      public static function getEffectNameByType(effectType:String) : String
      {
         var baseBLEffectType:String = null;
         var BLSplitArray:Array = null;
         var baseSENEffectType:String = null;
         var SENSplitArray:Array = null;
         var overHeadString:String = "";
         if(String(effectType).indexOf("bl_") == 0)
         {
            if(String(effectType).indexOf(".") > 0)
            {
               BLSplitArray = String(effectType).split(".");
               baseBLEffectType = BLSplitArray[0];
            }
            else
            {
               baseBLEffectType = effectType;
            }
            switch(baseBLEffectType)
            {
               case BloodlineData.EFFECT_COPY_JUTSU:
                  overHeadString = Central.main.langLib.get(760);
                  break;
               case BloodlineData.EFFECT_RESURRECTION:
                  overHeadString = Central.main.langLib.get(759);
                  break;
               case BloodlineData.EFFECT_REFLECT_GENJUTSU:
                  overHeadString = Central.main.langLib.get(752);
                  break;
               case BloodlineData.EFFECT_CAPTURE:
                  overHeadString = Central.main.langLib.get(736);
                  break;
               case BloodlineData.EFFECT_CLEAR_BUFF:
                  overHeadString = Central.main.langLib.get(877);
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_HP:
                  overHeadString = Central.main.langLib.get(739);
                  break;
               case BloodlineData.EFFECT_CONVERT_DMG_CP:
                  overHeadString = Central.main.langLib.get(738);
                  break;
               case BloodlineData.EFFECT_CRITICAL:
                  overHeadString = Central.main.langLib.get(740);
                  break;
               case BloodlineData.EFFECT_DODGE:
                  overHeadString = Central.main.langLib.get(741);
                  break;
               case BloodlineData.EFFECT_ACCURATE:
                  overHeadString = Central.main.langLib.get(735);
                  break;
               case BloodlineData.EFFECT_MAX_CP:
                  overHeadString = "";
                  break;
               case BloodlineData.EFFECT_MAX_CP_RECOVER:
                  overHeadString = Central.main.langLib.get(742);
                  break;
               case BloodlineData.EFFECT_MAX_HP:
                  overHeadString = "";
                  break;
               case BloodlineData.EFFECT_MERIDIAN_BLOCK:
                  overHeadString = Central.main.langLib.get(743);
                  break;
               case BloodlineData.EFFECT_MODIFY_COOLDOWN:
                  overHeadString = Central.main.langLib.get(744);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_ALL:
                  overHeadString = Central.main.langLib.get(745);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_BYTYPE:
                  overHeadString = Central.main.langLib.get(746);
                  break;
               case BloodlineData.EFFECT_MODIFY_DAMAGE_CRITICAL:
                  overHeadString = Central.main.langLib.get(747);
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_ALL:
                  overHeadString = Central.main.langLib.get(748);
                  break;
               case BloodlineData.EFFECT_MODIFY_DEFENCE_BYTYPE:
                  overHeadString = Central.main.langLib.get(748);
                  break;
               case BloodlineData.EFFECT_REFLECT_DAMAGE:
                  overHeadString = Central.main.langLib.get(751);
                  break;
               case BloodlineData.EFFECT_SPEED:
                  overHeadString = "EFFECT101";
                  break;
               case BloodlineData.EFFECT_STUN:
                  overHeadString = Central.main.langLib.get(281);
                  break;
               case BloodlineData.EFFECT_UPDATE_CP:
                  overHeadString = "";
                  break;
               case BloodlineData.EFFECT_UPDATE_HP:
                  overHeadString = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_ATTACKER:
                  overHeadString = Central.main.langLib.get(749);
                  break;
               case BloodlineData.EFFECT_REACTIVE_DEBUFF_DEFENDER:
                  overHeadString = Central.main.langLib.get(750);
                  break;
               case BloodlineData.EFFECT_BUNDLE:
                  overHeadString = Central.main.langLib.get(325);
                  break;
               case BloodlineData.EFFECT_RESTRICT_CHARGE:
                  overHeadString = Central.main.langLib.get(754);
                  break;
               case BloodlineData.EFFECT_EXTRA_CHARGE_RECOVER:
                  overHeadString = Central.main.langLib.get(755);
                  break;
               case BloodlineData.EFFECT_RESIST_DEBUFF:
                  overHeadString = Central.main.langLib.get(756);
                  break;
               case BloodlineData.EFFECT_DRAIN_HP:
                  overHeadString = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_MODIFY_TAIJUTSU_SELFHIT:
                  overHeadString = Central.main.langLib.get(758);
                  break;
               case BloodlineData.EFFECT_INTERNAL_INJURY:
                  overHeadString = Central.main.langLib.get(648);
                  break;
               case BloodlineData.EFFECT_TITAN:
                  overHeadString = Central.main.langLib.get(761);
                  break;
               case BloodlineData.EFFECT_EXTRA_CP_USE:
                  overHeadString = Central.main.langLib.get(805);
                  break;
               case BloodlineData.EFFECT_EXTREME:
                  overHeadString = Central.main.langLib.get(763);
                  break;
               case BloodlineData.EFFECT_HALLUCINATIONS:
                  overHeadString = Central.main.langLib.get(734);
                  break;
               case BloodlineData.EFFECT_UPDATE_HP_CP:
                  overHeadString = Central.main.langLib.get(1363);
                  break;
               case BloodlineData.EFFECT_PET_FREEZE:
                  overHeadString = Central.main.langLib.get(820);
                  break;
               case BloodlineData.EFFECT_REDUCE_CP:
                  overHeadString = Central.main.langLib.get(1657);
                  break;
               case BloodlineData.EFFECT_PASSIVE_STUN:
                  overHeadString = Central.main.langLib.get(2062);
                  break;
               case BloodlineData.EFFECT_CPDMG_STUN:
                  overHeadString = Central.main.langLib.get(2062);
                  break;
               case BloodlineData.EFFECT_CPDMG:
                  overHeadString = Central.main.langLib.get(2061);
                  break;
               default:
                  overHeadString = "";
            }
         }
         else if(String(effectType).indexOf("senjutsu_") == 0)
         {
            if(String(effectType).indexOf(".") > 0)
            {
               SENSplitArray = String(effectType).split(".");
               baseSENEffectType = SENSplitArray[0];
            }
            else
            {
               baseSENEffectType = effectType;
            }
            switch(baseSENEffectType)
            {
               case SenjutsuData.EFFECT_SENNIN_MODE:
                  overHeadString = Central.main.langLib.get(1862)[0];
                  break;
               case SenjutsuData.EFFECT_SS_MAX_HP:
                  overHeadString = "";
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE:
                  overHeadString = "";
                  break;
               case SenjutsuData.EFFECT_SS_MAX_CP_CHANGE_EXTRA:
                  overHeadString = "";
                  break;
               default:
                  overHeadString = "";
            }
         }
         else
         {
            switch(effectType)
            {
               case BattleData.EFFECT_DODGE_BONUS:
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
               case BattleData.EFFECT_PET_DODGE_BONUS:
                  overHeadString = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                  overHeadString = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_REGENERATE_HP:
                  overHeadString = Central.main.langLib.get(490);
                  break;
               case BattleData.EFFECT_SOUL_CHAINS_BUNDLE:
                  overHeadString = Central.main.langLib.get(329);
                  break;
               case BattleData.EFFECT_STUN:
                  overHeadString = Central.main.langLib.get(281);
                  break;
               case BattleData.EFFECT_REDUCE_AGILITY:
                  overHeadString = Central.main.langLib.get(2001)[0];
                  break;
               case BattleData.EFFECT_SLEEP:
                  overHeadString = Central.main.langLib.get(280);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
               case BattleData.EFFECT_FEAR_WEAKEN:
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  overHeadString = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_BUNDLE:
               case BattleData.SKILL_377:
                  overHeadString = Central.main.langLib.get(325);
                  break;
               case BattleData.EFFECT_HEAL:
                  overHeadString = "";
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  overHeadString = Central.main.langLib.get(350);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  overHeadString = Central.main.langLib.get(598);
                  break;
               case BattleData.EFFECT_PET_BURN:
                  overHeadString = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_BLIND:
               case BattleData.EFFECT_ALL_CP_BLIND:
                  overHeadString = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  overHeadString = String(Central.main.langLib.get(799));
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS:
                  overHeadString = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  overHeadString = Central.main.langLib.get(688);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  overHeadString = Central.main.langLib.get(619);
                  break;
               case BattleData.EFFECT_POISON:
                  overHeadString = Central.main.langLib.get(321);
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
               case BattleData.EFFECT_EXCITATION_CP:
               case BattleData.EFFECT_EXCITATION_CHARGE:
                  overHeadString = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY:
                  overHeadString = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_DAMAGE_DELAY_INJURY:
                  overHeadString = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_DAMAGE_REDUCTION:
                  overHeadString = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_AGILITY_BONUS:
                  overHeadString = Central.main.langLib.get(282);
                  break;
               case BattleData.EFFECT_DODGE_BONUS:
                  overHeadString = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_REGENERATE_CHAKRA:
                  overHeadString = Central.main.langLib.get(324);
                  break;
               case BattleData.EFFECT_COMBUSTION:
                  overHeadString = Central.main.langLib.get(363);
                  break;
               case BattleData.EFFECT_PURIFY:
                  overHeadString = Central.main.langLib.get(356);
                  break;
               case BattleData.EFFECT_REACTIVE_FORCE:
                  overHeadString = Central.main.langLib.get(533);
                  break;
               case BattleData.EFFECT_BLEEDING:
                  overHeadString = Central.main.langLib.get(286);
                  break;
               case BattleData.EFFECT_BURN:
                  overHeadString = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_DRAIN_CHAKRA:
                  overHeadString = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_DRAIN_HP:
                  overHeadString = Central.main.langLib.get(757);
                  break;
               case BattleData.EFFECT_POISON:
                  overHeadString = Central.main.langLib.get(321);
                  break;
               case BattleData.EFFECT_GATE_OPENING:
                  overHeadString = Central.main.langLib.get(296);
                  break;
               case BattleData.EFFECT_FEAR:
                  overHeadString = Central.main.langLib.get(304);
                  break;
               case BattleData.EFFECT_PARASITE:
                  overHeadString = Central.main.langLib.get(319);
                  break;
               case BattleData.EFFECT_CHAKRA_SUCKER:
                  overHeadString = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_BURNING:
                  overHeadString = Central.main.langLib.get(357);
                  break;
               case BattleData.EFFECT_FEAR_WEAKEN:
                  overHeadString = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_RESTORE_CP:
                  overHeadString = "EFFECT2";
                  break;
               case BattleData.EFFECT_MERIDIANS_SEAL:
                  overHeadString = Central.main.langLib.get(527);
                  break;
               case BattleData.EFFECT_PET_FEAR_WEAKEN:
                  overHeadString = Central.main.langLib.get(305);
                  break;
               case BattleData.EFFECT_FRENZY:
                  overHeadString = Central.main.langLib.get(834);
                  break;
               case BattleData.EFFECT_BURN_CP:
                  overHeadString = "EFFECT3";
                  break;
               case BattleData.EFFECT_MANA_SHIELD:
                  overHeadString = Central.main.langLib.get(594);
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME:
                  overHeadString = Central.main.langLib.get(596);
                  break;
               case BattleData.EFFECT_COOLDOWN_REDUCTION:
                  overHeadString = Central.main.langLib.get(598);
                  break;
               case BattleData.EFFECT_BERSERKER_MODE:
                  overHeadString = Central.main.langLib.get(599);
                  break;
               case BattleData.EFFECT_THUNDERSTORM_MODE:
                  overHeadString = Central.main.langLib.get(601);
                  break;
               case BattleData.EFFECT_WIND_PEACE:
                  overHeadString = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_2:
                  overHeadString = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_3:
                  overHeadString = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_WIND_PEACE_4:
                  overHeadString = Central.main.langLib.get(611);
                  break;
               case BattleData.EFFECT_FIRE_ENERGY_EXCITATION:
                  overHeadString = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_EXCITATION_CP:
                  overHeadString = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_EXCITATION_CHARGE:
                  overHeadString = Central.main.langLib.get(613);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE:
                  overHeadString = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_2:
                  overHeadString = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_3:
                  overHeadString = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_LIGHTING_BUNDLE_4:
                  overHeadString = Central.main.langLib.get(615);
                  break;
               case BattleData.EFFECT_AMONG_ROCKS:
                  overHeadString = Central.main.langLib.get(617);
                  break;
               case BattleData.EFFECT_COLLIDING_WAVE:
                  overHeadString = Central.main.langLib.get(619);
                  break;
               case BattleData.EFFECT_REDUCE_HP_CP:
                  overHeadString = Central.main.langLib.get();
                  break;
               case BattleData.EFFECT_SERENE_MIND:
                  overHeadString = Central.main.langLib.get(622);
                  break;
               case BattleData.EFFECT_CALM_TARGET:
                  overHeadString = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_DARK_CURSE:
                  overHeadString = Central.main.langLib.get(649);
                  break;
               case BattleData.EFFECT_GUARD:
                  overHeadString = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_CUBE_ILLUSION:
                  overHeadString = Central.main.langLib.get(673);
                  break;
               case BattleData.EFFECT_SILVER_CHAIN_BUNDLE:
                  overHeadString = Central.main.langLib.get(676);
                  break;
               case BattleData.EFFECT_BLOOD_FEED:
                  overHeadString = Central.main.langLib.get(638);
                  break;
               case BattleData.EFFECT_ACCURATE_WEAPON:
                  overHeadString = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_CRITICAL_CHANCE_BONUS_WEAPON:
                  overHeadString = "EFFECT4";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_WEAPON:
                  overHeadString = "EFFECT6";
                  break;
               case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON:
                  overHeadString = "EFFECT5";
                  break;
               case BattleData.EFFECT_BLOOD_DRINKER:
                  overHeadString = Central.main.langLib.get(819);
                  break;
               case BattleData.EFFECT_REWIND:
                  overHeadString = Central.main.langLib.get(800);
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP:
                  overHeadString = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_PET_DRAIN_CP:
                  overHeadString = Central.main.langLib.get(349);
                  break;
               case BattleData.EFFECT_ADD_COOLDOWN:
                  overHeadString = Central.main.langLib.get(744);
                  break;
               case BattleData.EFFECT_BLOODLUST_DEDICATION:
                  overHeadString = Central.main.langLib.get(356);
                  break;
               case BattleData.EFFECT_REACTIVE_DEBUFF:
                  overHeadString = Central.main.langLib.get(749);
                  break;
               case BattleData.EFFECT_PETRIFICATION:
                  overHeadString = Central.main.langLib.get(954);
                  break;
               case BattleData.EFFECT_EXTRA_CP_RECOVER:
                  overHeadString = Central.main.langLib.get(755);
                  break;
               case BattleData.EFFECT_DARKNESS:
                  overHeadString = Central.main.langLib.get(1088);
                  break;
               case BattleData.EFFECT_PET_ATTENTION:
                  overHeadString = Central.main.langLib.get(807);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_BONUS:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_PET_WEAKEN:
                  overHeadString = Central.main.langLib.get(801);
                  break;
               case BattleData.EFFECT_CATALYTIC_MATTER:
                  overHeadString = Central.main.langLib.get(814);
                  break;
               case BattleData.EFFECT_DISMANTLE:
                  overHeadString = Central.main.langLib.get(797);
                  break;
               case BattleData.EFFECT_PET_FREEZE:
                  overHeadString = Central.main.langLib.get(820);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_REDUCTION:
                  overHeadString = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_PET_DAMAGE_TO_CP:
                  overHeadString = Central.main.langLib.get(832);
                  break;
               case BattleData.EFFECT_PET_BLEEDING:
                  overHeadString = Central.main.langLib.get(286);
                  break;
               case BattleData.EFFECT_STUN_RANDOM:
                  overHeadString = Central.main.langLib.get(281);
                  break;
               case BattleData.EFFECT_PET_SAVE_CP:
                  overHeadString = Central.main.langLib.get(805);
                  break;
               case BattleData.EFFECT_PET_LIGHTNING:
                  overHeadString = Central.main.langLib.get(875);
                  break;
               case BattleData.EFFECT_PET_DRAIN_HP_KEKKAI:
                  overHeadString = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_RANDOM:
                  overHeadString = Central.main.langLib.get(648);
                  break;
               case BattleData.EFFECT_BURN_HP:
                  overHeadString = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_COMPLETE_GUARD:
                  overHeadString = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_PET_BLIND:
                  overHeadString = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_CHAOS:
                  overHeadString = Central.main.langLib.get(734);
                  break;
               case BattleData.EFFECT_PET_DEBUFF_RESIST:
                  overHeadString = Central.main.langLib.get(822);
                  break;
               case BattleData.EFFECT_PET_HEAL:
                  overHeadString = Central.main.langLib.get(830);
                  break;
               case BattleData.EFFECT_PET_REDUCE_CHARGE:
                  overHeadString = Central.main.langLib.get(804);
                  break;
               case BattleData.EFFECT_BURN_CP_HP:
                  overHeadString = Central.main.langLib.get(288);
                  break;
               case BattleData.EFFECT_FLAME_EATER:
                  overHeadString = Central.main.langLib.get(482);
                  break;
               case BattleData.EFFECT_PET_REFLECT_ATTACK:
                  overHeadString = Central.main.langLib.get(873);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF:
                  overHeadString = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_BUNNY_FRENZY:
                  overHeadString = Central.main.langLib.get(834);
                  break;
               case BattleData.EFFECT_BATTLE_BUNNY_FRENZY:
                  overHeadString = Central.main.langLib.get(1871);
                  break;
               case BattleData.EFFECT_ATTACK_MODE:
                  overHeadString = Central.main.langLib.get(881);
                  break;
               case BattleData.EFFECT_DRAIN_HP_CP:
                  overHeadString = "EFFECT7";
                  break;
               case BattleData.EFFECT_WAKE_UP:
                  overHeadString = Central.main.langLib.get(890);
                  break;
               case BattleData.EFFECT_RANDOM_SLEEP:
                  overHeadString = Central.main.langLib.get(280);
                  break;
               case BattleData.EFFECT_PET_DISORIENTED:
                  overHeadString = Central.main.langLib.get(891);
                  break;
               case BattleData.EFFECT_PET_ENERGIZE:
                  overHeadString = Central.main.langLib.get(893);
                  break;
               case BattleData.EFFECT_LIGHT_IMPLUSE:
                  overHeadString = Central.main.langLib.get(651);
                  break;
               case BattleData.EFFECT_DODGE_REDUCTION:
                  overHeadString = Central.main.langLib.get(799);
                  break;
               case BattleData.EFFECT_DISTRACT:
                  overHeadString = Central.main.langLib.get(670);
                  break;
               case BattleData.EFFECT_HAMSTRING:
                  overHeadString = Central.main.langLib.get(688);
                  break;
               case BattleData.EFFECT_ECSTATIC_SOUND:
                  overHeadString = Central.main.langLib.get(609);
                  break;
               case BattleData.EFFECT_PROFUSION_OF_GHOSTS:
                  overHeadString = Central.main.langLib.get(744);
                  break;
               case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_DEFENDER:
                  overHeadString = "EFFECT8";
                  break;
               case BattleData.EFFECT_PET_RANDOM_EFFECT_ON_MASTER:
                  overHeadString = "EFFECT9";
                  break;
               case BattleData.EFFECT_ACCURATE:
                  overHeadString = Central.main.langLib.get(735);
                  break;
               case BattleData.EFFECT_CLEAR_BUFF_NO_RANDOM:
                  overHeadString = Central.main.langLib.get(877);
                  break;
               case BattleData.SKILL_307:
                  overHeadString = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_310:
                  overHeadString = "EFFECT10";
                  break;
               case BattleData.SKILL_311:
                  overHeadString = "EFFECT11";
                  break;
               case BattleData.SKILL_312:
                  overHeadString = "EFFECT12";
                  break;
               case BattleData.EFFECT_RESTRICT_CHARGE:
                  overHeadString = Central.main.langLib.get(754);
                  break;
               case BattleData.EFFECT_CRIT_CHANCE_DMG:
                  overHeadString = "EFFECT13";
                  break;
               case BattleData.MONSTER_HP1:
                  overHeadString = "EFFECT14";
                  break;
               case BattleData.EFFECT_CLEARBUFF_DODGEREDUCTION:
                  overHeadString = Central.main.langLib.get(877);
                  break;
               case BattleData.EFFECT_CLEARBUFF_DAMAGEREDUCTION:
                  overHeadString = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_DECREASE_CRITICAL_CHANCE:
                  overHeadString = Central.main.langLib.get(670);
                  break;
               case BattleData.SKILL_234:
                  overHeadString = Central.main.langLib.get(807);
                  break;
               case BattleData.SKILL_236:
                  overHeadString = Central.main.langLib.get(799);
                  break;
               case BattleData.SKILL_302:
                  overHeadString = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_304:
                  overHeadString = Central.main.langLib.get(1359);
                  break;
               case BattleData.SKILL_251:
                  overHeadString = Central.main.langLib.get(1366);
                  break;
               case BattleData.SKILL_253:
                  overHeadString = Central.main.langLib.get(1361);
                  break;
               case BattleData.SKILL_268:
                  overHeadString = Central.main.langLib.get(1363);
                  break;
               case BattleData.SKILL_268_2:
                  overHeadString = Central.main.langLib.get(1363);
                  break;
               case BattleData.SKILL_270:
                  overHeadString = Central.main.langLib.get(1364);
                  break;
               case BattleData.SKILL_335:
                  overHeadString = Central.main.langLib.get(1369);
                  break;
               case BattleData.SKILL_2000:
                  overHeadString = "EFFECT15";
                  break;
               case BattleData.SKILL_2001:
                  overHeadString = "EFFECT16";
                  break;
               case BattleData.SKILL_2002:
                  overHeadString = "EFFECT17";
                  break;
               case BattleData.SKILL_2003:
                  overHeadString = "EFFECT18";
                  break;
               case BattleData.SKILL_2004:
                  overHeadString = "EFFECT19";
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_NPC:
                  overHeadString = Central.main.langLib.get(596);
                  break;
               case BattleData.SKILL_342:
                  overHeadString = Central.main.langLib.get(1361);
                  break;
               case BattleData.SKILL_345:
                  overHeadString = "EFFECT20";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_FIX_NUM:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.SKILL_359:
                  overHeadString = Central.main.langLib.get(305);
                  break;
               case BattleData.SKILL_368:
                  overHeadString = "EFFECT21";
                  break;
               case BattleData.SKILL_369:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.SKILL_336:
                  overHeadString = "EFFECT22";
                  break;
               case BattleData.SKILL_501:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_PUMPKIN_POWER:
                  overHeadString = Central.main.langLib.get(1603);
                  break;
               case BattleData.SKILL_377:
                  overHeadString = Central.main.langLib.get(369);
                  break;
               case BattleData.EFFECT_DOT_HP:
                  overHeadString = "EFFECT23";
                  break;
               case BattleData.SKILL_341:
                  overHeadString = Central.main.langLib.get(817);
                  break;
               case BattleData.EFFECT_CLEARBUFF:
                  overHeadString = Central.main.langLib.get(877);
                  break;
               case BattleData.EFFECT_CLEARBUFF_STUN:
                  overHeadString = Central.main.langLib.get(737);
                  break;
               case BattleData.INSTANT_KILL:
                  overHeadString = "EFFECT24";
                  break;
               case BattleData.INSTANT_CUT_HALF_HP:
                  overHeadString = "EFFECT25";
                  break;
               case BattleData.EFFECT_ADD_PURIFY_CHANCE:
                  overHeadString = Central.main.langLib.get(1688);
                  break;
               case BattleData.EFFECT_REDUCE_CP_REQUIRE:
                  overHeadString = "EFFECT26";
                  break;
               case BattleData.EFFECT_PURIFY_RESTORE_HP:
                  overHeadString = "EFFECT27";
                  break;
               case BattleData.EFFECT_ADD_CRITICAL_CHANCE:
                  overHeadString = Central.main.langLib.get(292);
                  break;
               case BattleData.EFFECT_ADD_DODGE_BONUS:
                  overHeadString = Central.main.langLib.get(741);
                  break;
               case BattleData.EFFECT_ADD_DAMAGE_BONUS:
                  overHeadString = Central.main.langLib.get(330);
                  break;
               case BattleData.EFFECT_ADD_DODGE_RANDOM:
                  overHeadString = Central.main.langLib.get(741);
                  break;
               case BattleData.EFFECT_ADD_DODGE_REDUCTION:
                  overHeadString = Central.main.langLib.get(332);
                  break;
               case BattleData.EFFECT_ADD_DODGERE_ABOVE_HP:
                  overHeadString = "EFFECT28";
                  break;
               case BattleData.EFFECT_INSTANT_KILL_BELOW_HP:
                  overHeadString = "EFFECT29";
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_BONUS:
                  overHeadString = "EFFECT30";
                  break;
               case BattleData.EFFECT_ATTACKER_BLIND:
                  overHeadString = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_WEAPON_MANA_SHIELD:
                  overHeadString = Central.main.langLib.get(594);
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_BONUS_PRESENT:
                  overHeadString = "EFFECT31";
                  break;
               case BattleData.EFFECT_REDUCE_DAMAGE_AMOUNT:
                  overHeadString = "EFFECT32";
                  break;
               case BattleData.EFFECT_ADD_FEEDBACK_CHANCE:
                  overHeadString = Central.main.langLib.get(533);
                  break;
               case BattleData.EFFECT_REDUCE_TARGET_CP:
                  overHeadString = "EFFECT33";
                  break;
               case BattleData.EFFECT_GUARD_BELOW_DAMAGE:
                  overHeadString = "EFFECT34";
                  break;
               case BattleData.EFFECT_WEAPON_FULL_GUARD:
                  overHeadString = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_RECIEVE_DAMAGE_CP:
                  overHeadString = "EFFECT35";
                  break;
               case BattleData.EFFECT_ADD_HP_AMOUNT:
                  overHeadString = "EFFECT36";
                  break;
               case BattleData.EFFECT_ADD_HP_AMOUNT_PRESENT:
                  overHeadString = "EFFECT37";
                  break;
               case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                  overHeadString = "EFFECT38";
                  break;
               case BattleData.EFFECT_ADD_CP_BELOW_CP:
                  overHeadString = "EFFECT39";
                  break;
               case BattleData.EFFECT_DODGE_SUCCESS_DAMAGE_BONUS:
                  overHeadString = "EFFECT40";
                  break;
               case BattleData.EFFECT_CP_CONSUME_TO_HP:
                  overHeadString = "EFFECT41";
                  break;
               case BattleData.EFFECT_ATTACKER_RESTORE_HP:
                  overHeadString = "EFFECT42";
                  break;
               case BattleData.EFFECT_ATTACKER_RESTORE_CP:
                  overHeadString = "EFFECT43";
                  break;
               case BattleData.EFFECT_DEFENDER_DAMAGE_CP:
                  overHeadString = "EFFECT44";
                  break;
               case BattleData.EFFECT_DEBUFF_RESTORE_HP_PRESENT:
                  overHeadString = "EFFECT45";
                  break;
               case BattleData.EFFECT_DEBUFF_RESTORE_CP_PRESENT:
                  overHeadString = "EFFECT46";
                  break;
               case BattleData.EFFECT_DEFENDER_BURNING:
                  overHeadString = "EFFECT47";
                  break;
               case BattleData.EFFECT_DEFENDER_BUNDLE:
                  overHeadString = "EFFECT48";
                  break;
               case BattleData.EFFECT_DEFENDER_POISON:
                  overHeadString = "EFFECT49";
                  break;
               case BattleData.EFFECT_ATTACKER_DAMAGE_REDUCTION:
                  overHeadString = "EFFECT50";
                  break;
               case BattleData.EFFECT_ATTACKER_DAMAGE_BONUS:
                  overHeadString = "EFFECT51";
                  break;
               case BattleData.EFFECT_DEFENDER_CLEAR_BUFF:
                  overHeadString = "EFFECT52";
                  break;
               case BattleData.EFFECT_ATTACKER_REDUCE_COOLDOWN:
                  overHeadString = "EFFECT53";
                  break;
               case BattleData.EFFECT_DEFENDER_FREEZE:
                  overHeadString = "EFFECT54";
                  break;
               case BattleData.EFFECT_DEFENDER_CRITICAL_CHANCE:
                  overHeadString = "EFFECT55";
                  break;
               case BattleData.EFFECT_DEFENDER_RESTORE_HP_PRESENT:
                  overHeadString = "EFFECT56";
                  break;
               case BattleData.EFFECT_ATTACKER_BLEEDING:
                  overHeadString = "EFFECT57";
                  break;
               case BattleData.EFFECT_ADD_CP_AMOUNT_PRESENT:
                  overHeadString = "EFFECT58";
                  break;
               case BattleData.EFFECT_REDUCE_DODGE_RANDOM:
                  overHeadString = "EFFECT59";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_BONUS:
                  overHeadString = "EFFECT60";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_BONUS_PRESENT:
                  overHeadString = "EFFECT61";
                  break;
               case BattleData.EFFECT_ITEM_RESTORE_CP_BONUS_PRESENT:
                  overHeadString = "EFFECT62";
                  break;
               case BattleData.EFFECT_CHARGE_CP_BONUS:
                  overHeadString = "EFFECT63";
                  break;
               case BattleData.EFFECT_ATTACKER_FREEZE:
                  overHeadString = "EFFECT64";
                  break;
               case BattleData.EFFECT_ABSORB_ATTACKER_HP_PRESENT:
                  overHeadString = "EFFECT65";
                  break;
               case BattleData.EFFECT_ATTACK_BUNDLE:
                  overHeadString = "EFFECT66";
                  break;
               case BattleData.EFFECT_ATTACKER_CRITICAL_DAMAGE_BONUS:
                  overHeadString = "EFFECT67";
                  break;
               case BattleData.EFFECT_CONVERT_FULLDMG_TO_HP:
                  overHeadString = "EFFECT68";
                  break;
               case BattleData.EFFECT_HEAL_OVER_TIME_FIX_NUM:
                  overHeadString = "EFFECT69";
                  break;
               case BattleData.EFFECT_ADD_COMBUSTION_CHANCE:
                  overHeadString = "EFFECT70";
                  break;
               case BattleData.EFFECT_ALL_CP_DODGE_BONUS:
                  overHeadString = Central.main.langLib.get(306);
                  break;
               case BattleData.EFFECT_ALL_CP_DRAIN_HP:
                  overHeadString = Central.main.langLib.get(878);
                  break;
               case BattleData.EFFECT_ALL_CP_BLIND:
                  overHeadString = Central.main.langLib.get(287);
                  break;
               case BattleData.EFFECT_ALL_CP_GUARD_RESIST:
                  overHeadString = Central.main.langLib.get(636);
                  break;
               case BattleData.EFFECT_ALL_CP_HEAL:
                  overHeadString = Central.main.langLib.get(408);
                  break;
               case BattleData.EFFECT_HUNDRED_PERCENT_ATTACK:
                  overHeadString = "EFFECT71";
                  break;
               case BattleData.EFFECT_REDUCE_PURIFY_CHANCE:
                  overHeadString = Central.main.langLib.get(1361);
                  break;
               case BattleData.EFFECT_BURN_CP_FIX_NUM:
                  overHeadString = "EFFECT72";
                  break;
               case BattleData.EFFECT_CLEARBUFF_REDUCE_HP_CP:
                  overHeadString = Central.main.langLib.get(737);
                  break;
               case BattleData.EFFECT_CHARGE_RECOVER_HP:
                  overHeadString = "EFFECT73";
                  break;
               case BattleData.EFFECT_ADD_ALL_COOLDOWN:
                  overHeadString = "EFFECT74";
                  break;
               case BattleData.EFFECT_BLEEDING_FIX_NUM:
                  overHeadString = "EFFECT75";
                  break;
               case BattleData.EFFECT_DAMAGE_BONUS_WEAPON_FIX_NUM:
                  overHeadString = "EFFECT76";
                  break;
               case BattleData.EFFECT_CRITICAL_DAMAGE_BONUS_WEAPON_FIX_NUM:
                  overHeadString = "EFFECT77";
                  break;
               case BattleData.EFFECT_MAX_HP:
                  overHeadString = "EFFECT78";
                  break;
               case BattleData.EFFECT_MAX_HP_PRESENT:
                  overHeadString = "EFFECT79";
                  break;
               case BattleData.EFFECT_MAX_CP:
                  overHeadString = "EFFECT80";
                  break;
               case BattleData.EFFECT_MAX_CP_PRESENT:
                  overHeadString = "EFFECT80";
                  break;
               case BattleData.EFFECT_BURN_FIX_NUM:
                  overHeadString = "EFFECT81";
                  break;
               case BattleData.EFFECT_PET_WEAKEN_FIX_NUM:
                  overHeadString = "EFFECT82";
                  break;
               case BattleData.EFFECT_REDUCE_HP_PRESENT:
                  overHeadString = "EFFECT83";
                  break;
               case BattleData.EFFECT_DAMAGE_HP_FIX_NUM:
                  overHeadString = "EFFECT84";
                  break;
               case BattleData.EFFECT_RESIST_OVERTIME:
                  overHeadString = Central.main.langLib.get(822);
                  break;
               case BattleData.ITEM_EFFECT_SEAL_GAN:
                  overHeadString = Central.main.langLib.get(1725)[0];
                  break;
               case BattleData.ITEM_EFFECT_SPY_CP:
                  overHeadString = Central.main.langLib.get(1725)[1];
                  break;
               case BattleData.EFFECT_BURN_PROTECTION:
                  overHeadString = Central.main.langLib.get(322);
                  break;
               case BattleData.EFFECT_BURN_CP_CLEAR_BUFF:
                  overHeadString = Central.main.langLib.get(1366);
                  break;
               case BattleData.EFFECT_INTERNAL_INJURY_FEAR_WEAKEN:
                  overHeadString = Central.main.langLib.get(305);
                  break;
               default:
                  overHeadString = "";
            }
         }
         return overHeadString;
      }
   }
}
