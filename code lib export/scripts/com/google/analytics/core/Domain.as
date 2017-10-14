package com.google.analytics.core
{
   import com.google.analytics.debug.DebugConfiguration;
   import com.google.analytics.debug.VisualDebugMode;
   
   public class Domain
   {
       
      
      private var _mode:com.google.analytics.core.DomainNameMode;
      
      private var _debug:DebugConfiguration;
      
      private var _name:String;
      
      public function Domain(mode:com.google.analytics.core.DomainNameMode = null, name:String = "", debug:DebugConfiguration = null)
      {
         super();
         _debug = debug;
         if(mode == null)
         {
            mode = com.google.analytics.core.DomainNameMode.auto;
         }
         _mode = mode;
         if(mode == com.google.analytics.core.DomainNameMode.custom)
         {
            this.name = name;
         }
         else
         {
            _name = name;
         }
      }
      
      public function get mode() : com.google.analytics.core.DomainNameMode
      {
         return _mode;
      }
      
      public function set mode(value:com.google.analytics.core.DomainNameMode) : void
      {
         _mode = value;
         if(_mode == com.google.analytics.core.DomainNameMode.none)
         {
            _name = "";
         }
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(value:String) : void
      {
         if(value.charAt(0) != "." && _debug)
         {
            _debug.warning("missing leading period \".\", cookie will only be accessible on " + value,VisualDebugMode.geek);
         }
         _name = value;
      }
   }
}
