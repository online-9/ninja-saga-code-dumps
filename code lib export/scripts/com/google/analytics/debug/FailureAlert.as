package com.google.analytics.debug
{
   public class FailureAlert extends Alert
   {
       
      
      public function FailureAlert(debug:DebugConfiguration, text:String, actions:Array)
      {
         var alignement:Align = Align.bottomLeft;
         var stickToEdge:Boolean = true;
         var actionOnNextLine:Boolean = false;
         if(debug.verbose)
         {
            text = "<u><span class=\"uiAlertTitle\">Failure</span>" + spaces(18) + "</u>\n\n" + text;
            alignement = Align.center;
            stickToEdge = false;
            actionOnNextLine = true;
         }
         super(text,actions,"uiFailure",Style.failureColor,alignement,stickToEdge,actionOnNextLine);
      }
   }
}
