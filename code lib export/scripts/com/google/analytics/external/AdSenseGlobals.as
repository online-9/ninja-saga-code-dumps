package com.google.analytics.external
{
   import com.google.analytics.debug.DebugConfiguration;
   
   public class AdSenseGlobals extends JavascriptProxy
   {
      
      public static var gaGlobal_js:XML = <script>
            <![CDATA[
                function()
                {
                    try
                    {
                        gaGlobal
                    }
                    catch(e)
                    {
                        gaGlobal = {} ;
                    }
                }
            ]]>
        </script>;
       
      
      private var _gaGlobalVerified:Boolean = false;
      
      public function AdSenseGlobals(debug:DebugConfiguration)
      {
         super(debug);
      }
      
      public function set vid(value:String) : void
      {
         if(!isAvailable())
         {
            return;
         }
         _verify();
         setProperty("gaGlobal.vid",value);
      }
      
      public function get hid() : String
      {
         if(!isAvailable())
         {
            return null;
         }
         _verify();
         return getProperty("gaGlobal.hid");
      }
      
      public function set hid(value:String) : void
      {
         if(!isAvailable())
         {
            return;
         }
         _verify();
         setProperty("gaGlobal.hid",value);
      }
      
      public function get dh() : String
      {
         if(!isAvailable())
         {
            return null;
         }
         _verify();
         return getProperty("gaGlobal.dh");
      }
      
      public function get sid() : String
      {
         if(!isAvailable())
         {
            return null;
         }
         _verify();
         return getProperty("gaGlobal.sid");
      }
      
      public function get vid() : String
      {
         if(!isAvailable())
         {
            return null;
         }
         _verify();
         return getProperty("gaGlobal.vid");
      }
      
      private function _verify() : void
      {
         if(!_gaGlobalVerified)
         {
            executeBlock(gaGlobal_js);
            _gaGlobalVerified = true;
         }
      }
      
      public function set sid(value:String) : void
      {
         if(!isAvailable())
         {
            return;
         }
         _verify();
         setProperty("gaGlobal.sid",value);
      }
      
      public function get gaGlobal() : Object
      {
         if(!isAvailable())
         {
            return null;
         }
         _verify();
         return getProperty("gaGlobal");
      }
   }
}
