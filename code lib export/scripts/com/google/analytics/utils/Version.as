package com.google.analytics.utils
{
   public class Version
   {
       
      
      private var _revision:uint;
      
      private var _maxBuild:uint = 255;
      
      private var _maxMinor:uint = 15;
      
      private var _maxMajor:uint = 15;
      
      private var _separator:String = ".";
      
      private var _maxRevision:uint = 65535;
      
      private var _build:uint;
      
      private var _major:uint;
      
      private var _minor:uint;
      
      public function Version(major:uint = 0, minor:uint = 0, build:uint = 0, revision:uint = 0)
      {
         var v:Version = null;
         super();
         if(major > _maxMajor && minor == 0 && build == 0 && revision == 0)
         {
            v = Version.fromNumber(major);
            major = v.major;
            minor = v.minor;
            build = v.build;
            revision = v.revision;
         }
         this.major = major;
         this.minor = minor;
         this.build = build;
         this.revision = revision;
      }
      
      public static function fromString(value:String = "", separator:String = ".") : Version
      {
         var values:Array = null;
         var v:Version = new Version();
         if(value == "" || value == null)
         {
            return v;
         }
         if(value.indexOf(separator) > -1)
         {
            values = value.split(separator);
            v.major = parseInt(values[0]);
            v.minor = parseInt(values[1]);
            v.build = parseInt(values[2]);
            v.revision = parseInt(values[3]);
         }
         else
         {
            v.major = parseInt(value);
         }
         return v;
      }
      
      public static function fromNumber(value:Number = 0) : Version
      {
         var v:Version = new Version();
         if(isNaN(value) || value == 0 || value < 0 || value == Number.MAX_VALUE || value == Number.POSITIVE_INFINITY || value == Number.NEGATIVE_INFINITY)
         {
            return v;
         }
         v.major = value >>> 28;
         v.minor = (value & 251658240) >>> 24;
         v.build = (value & 16711680) >>> 16;
         v.revision = value & 65535;
         return v;
      }
      
      public function toString(fields:int = 0) : String
      {
         var arr:Array = null;
         if(fields <= 0 || fields > 4)
         {
            fields = getFields();
         }
         switch(fields)
         {
            case 1:
               arr = [major];
               break;
            case 2:
               arr = [major,minor];
               break;
            case 3:
               arr = [major,minor,build];
               break;
            case 4:
            default:
               arr = [major,minor,build,revision];
         }
         return arr.join(_separator);
      }
      
      public function set revision(value:uint) : void
      {
         _revision = Math.min(value,_maxRevision);
      }
      
      public function get revision() : uint
      {
         return _revision;
      }
      
      public function set build(value:uint) : void
      {
         _build = Math.min(value,_maxBuild);
      }
      
      public function set minor(value:uint) : void
      {
         _minor = Math.min(value,_maxMinor);
      }
      
      public function get build() : uint
      {
         return _build;
      }
      
      public function set major(value:uint) : void
      {
         _major = Math.min(value,_maxMajor);
      }
      
      public function get minor() : uint
      {
         return _minor;
      }
      
      private function getFields() : int
      {
         var f:int = 4;
         if(revision == 0)
         {
            f--;
         }
         if(f == 3 && build == 0)
         {
            f--;
         }
         if(f == 2 && minor == 0)
         {
            f--;
         }
         return f;
      }
      
      public function valueOf() : uint
      {
         return major << 28 | minor << 24 | build << 16 | revision;
      }
      
      public function get major() : uint
      {
         return _major;
      }
      
      public function equals(o:*) : Boolean
      {
         if(!(o is Version))
         {
            return false;
         }
         if(o.major == major && o.minor == minor && o.build == build && o.revision == revision)
         {
            return true;
         }
         return false;
      }
   }
}
