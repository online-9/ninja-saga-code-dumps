package com.google.analytics.debug
{
   import flash.display.Graphics;
   
   public class Background
   {
       
      
      public function Background()
      {
         super();
      }
      
      public static function drawRounded(target:*, g:Graphics, width:uint = 0, height:uint = 0) : void
      {
         var W:uint = 0;
         var H:uint = 0;
         var R:uint = Style.roundedCorner;
         if(width > 0 && height > 0)
         {
            W = width;
            H = height;
         }
         else
         {
            W = target.width;
            H = target.height;
         }
         if(target.stickToEdge && target.alignement != Align.none)
         {
            switch(target.alignement)
            {
               case Align.top:
                  g.drawRoundRectComplex(0,0,W,H,0,0,R,R);
                  break;
               case Align.topLeft:
                  g.drawRoundRectComplex(0,0,W,H,0,0,0,R);
                  break;
               case Align.topRight:
                  g.drawRoundRectComplex(0,0,W,H,0,0,R,0);
                  break;
               case Align.bottom:
                  g.drawRoundRectComplex(0,0,W,H,R,R,0,0);
                  break;
               case Align.bottomLeft:
                  g.drawRoundRectComplex(0,0,W,H,0,R,0,0);
                  break;
               case Align.bottomRight:
                  g.drawRoundRectComplex(0,0,W,H,R,0,0,0);
                  break;
               case Align.left:
                  g.drawRoundRectComplex(0,0,W,H,0,R,0,R);
                  break;
               case Align.right:
                  g.drawRoundRectComplex(0,0,W,H,R,0,R,0);
                  break;
               case Align.center:
                  g.drawRoundRect(0,0,W,H,R,R);
            }
         }
         else
         {
            g.drawRoundRect(0,0,W,H,R,R);
         }
      }
   }
}
