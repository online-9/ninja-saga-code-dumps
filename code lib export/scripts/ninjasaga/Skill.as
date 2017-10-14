package ninjasaga
{
   import flash.display.MovieClip;
   import com.utils.GF;
   
   public class Skill
   {
      
      private static var skillList:Object = new Object();
      
      private static var classSkillList:Object = new Object();
      
      private static var senjutsuList:Object = new Object();
       
      
      public function Skill()
      {
         super();
      }
      
      public static function getBloodline(_skillName:String) : MovieClip
      {
         var BLskillName:String = "bloodline_skill" + _skillName;
         var clsName:String = String(Central.main.BLOODLINE_SKILL_DATA[BLskillName].swf_name).substr(0,1).toUpperCase() + String(Central.main.BLOODLINE_SKILL_DATA[BLskillName].swf_name).substring(1,String(Central.main.BLOODLINE_SKILL_DATA[BLskillName].swf_name).length);
         _skillName = "skill" + _skillName;
         var _mc:MovieClip = GF.getAsset(skillList[_skillName],clsName);
         _mc.skillId = _skillName;
         return _mc;
      }
      
      public static function getSenjutsu(_skillName:String) : MovieClip
      {
         var SENskillName:String = "senjutsu_skill" + _skillName;
         var clsName:String = String(Central.main.SENJUTSU_SKILL_DATA[SENskillName].swf_name).substr(0,1).toUpperCase() + String(Central.main.SENJUTSU_SKILL_DATA[SENskillName].swf_name).substring(1,String(Central.main.SENJUTSU_SKILL_DATA[SENskillName].swf_name).length);
         _skillName = "skill" + _skillName;
         var _mc:MovieClip = GF.getAsset(skillList[_skillName],clsName);
         _mc.skillId = _skillName;
         return _mc;
      }
      
      public static function setSkill(_skillName:String, _mc:MovieClip) : void
      {
         skillList[_skillName] = _mc;
      }
      
      public static function getSkill(_skillName:String) : MovieClip
      {
         var clsName:String = String(Central.main.SKILL_DATA[_skillName].swfName).substr(0,1).toUpperCase() + String(Central.main.SKILL_DATA[_skillName].swfName).substring(1,String(Central.main.SKILL_DATA[_skillName].swfName).length);
         var _mc:MovieClip = GF.getAsset(skillList[_skillName],clsName);
         _mc.skillId = _skillName;
         return _mc;
      }
      
      public static function hasSkill(_skillName:String) : Boolean
      {
         var _mc:MovieClip = skillList[_skillName];
         if(_mc != null)
         {
            return true;
         }
         return false;
      }
      
      public static function hasClassSkill(_skillName:String) : Boolean
      {
         var _mc:MovieClip = classSkillList[_skillName];
         if(_mc != null)
         {
            return true;
         }
         return false;
      }
      
      public static function setClassSkill(_skillName:String, _mc:MovieClip) : void
      {
         classSkillList[_skillName] = _mc;
      }
      
      public static function getClassSkill(_skillName:String) : MovieClip
      {
         var clsName:String = String(Central.main.SKILL_DATA[_skillName].swfName).substr(0,1).toUpperCase() + String(Central.main.SKILL_DATA[_skillName].swfName).substring(1,String(Central.main.SKILL_DATA[_skillName].swfName).length);
         var _mc:MovieClip = GF.getAsset(classSkillList[_skillName],clsName);
         _mc.skillId = _skillName;
         return _mc;
      }
      
      public static function getSpecialEffect(skillName:String) : MovieClip
      {
         var _mc:MovieClip = new MovieClip();
         if(skillList[skillName] != null)
         {
            _mc = GF.getAsset(skillList[skillName],"specialEffect");
         }
         else if(classSkillList[skillName] != null)
         {
            _mc = GF.getAsset(classSkillList[skillName],"specialEffect");
         }
         else
         {
            _mc = GF.getAsset(senjutsuList[skillName],"specialEffect");
         }
         return _mc;
      }
   }
}
