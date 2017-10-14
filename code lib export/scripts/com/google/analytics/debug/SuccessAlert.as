package com.google.analytics.debug
{
   public class SuccessAlert extends Alert
   {
       
      
      public function SuccessAlert(debug:DebugConfiguration, text:String, actions:Array)
      {
         var alignement:Align = Align.bottomLeft;
         var stickToEdge:Boolean = true;
         var actionOnNextLine:Boolean = false;
         if(debug.verbose)
         {
            text = "<u><span class=\"uiAlertTitle\">Success</span>" + spaces(18) + "</u>\n\n" + text;
            alignement = Align.center;
            stickToEdge = false;
            actionOnNextLine = true;
         }
         super(text,actions,"uiSuccess",Style.successColor,alignement,stickToEdge,actionOnNextLine);
      }
   }
}
