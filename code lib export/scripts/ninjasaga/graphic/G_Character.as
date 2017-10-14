package ninjasaga.graphic
{
   import ninjasaga.Asset;
   import flash.display.MovieClip;
   import com.utils.Out;
   import com.utils.GF;
   
   public class G_Character implements GI_Character
   {
       
      
      private var asset:Asset;
      
      private const BODY_PART_ARRAY = ["upper_body","lower_body","left_upper_arm","left_lower_arm","left_hand","left_upper_leg","left_lower_leg","left_shoe","right_upper_arm","right_lower_arm","right_hand","right_upper_leg","right_lower_leg","right_shoe"];
      
      public function G_Character()
      {
         super();
         this.asset = Asset.getInstance();
      }
      
      public function setupFace(mc:MovieClip, faceId:String, skinColor:Number) : void
      {
         var faceMc:MovieClip = null;
         var face:* = undefined;
         try
         {
            faceMc = mc["head"]["face"];
            if(faceMc.numChildren > 0)
            {
               face = faceMc.getChildAt(0);
               if(face != null)
               {
                  if(faceId == face.faceId)
                  {
                     face.setColor(skinColor);
                     return;
                  }
               }
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace :: 1 :: " + mc + " :: " + faceId + " :: " + e.getStackTrace());
         }
         try
         {
            GF.removeAllChild(faceMc);
            faceMc.addChild(this.asset.getFace(faceId,skinColor));
         }
         catch(e:Error)
         {
            Out.error(this,"setupFace :: 2 :: " + mc + " :: " + faceId + " :: " + e.getStackTrace());
         }
      }
      
      public function setFaceColor(mc:MovieClip, skinColor:Number) : void
      {
         var faceMc:MovieClip = null;
         try
         {
            faceMc = mc["head"]["face"].getChildAt(0).setColor(skinColor);
         }
         catch(e:Error)
         {
            Out.error(this,"setFaceColor :: " + mc + " :: " + skinColor + " :: " + e.getStackTrace());
         }
      }
      
      public function setupBodySet(mc:MovieClip, setId:String, gender:int, skinColor:Number) : void
      {
         var bodyPartArr:Array = null;
         var i:uint = 0;
         try
         {
            bodyPartArr = BODY_PART_ARRAY;
            for(i = 0; i < bodyPartArr.length; i++)
            {
               GF.removeAllChild(mc[bodyPartArr[i]]);
               mc[bodyPartArr[i]].addChild(this.asset.getBodyPart(setId,gender,bodyPartArr[i],skinColor));
            }
            if(gender == 1)
            {
               GF.removeAllChild(mc["skirt"]);
               mc["skirt"].addChild(this.asset.getBodyPart(setId,gender,"skirt",skinColor));
            }
         }
         catch(e:Error)
         {
            Out.error(this,"setupBodySet :: " + mc + " :: " + setId + " :: " + skinColor + " :: " + e.getStackTrace());
         }
      }
      
      public function setBodySetColor(mc:MovieClip, skinColor:Number) : void
      {
         var bodyPartArr:Array = BODY_PART_ARRAY;
         for(var i:uint = 0; i < bodyPartArr.length; i++)
         {
            mc[bodyPartArr[i]].getChildAt(0).setColor(skinColor);
         }
      }
      
      public function setupWeapon(mc:MovieClip, wpnId:String) : void
      {
         try
         {
            GF.removeAllChild(mc["weapon"]);
            mc["weapon"].addChild(this.asset.getWeaponGraphic(wpnId));
         }
         catch(e:Error)
         {
            Out.error(this,"setupWeapon :: " + mc + " :: " + wpnId + " :: " + e.getStackTrace());
         }
      }
      
      public function setupBackItem(mc:MovieClip, backId:String) : void
      {
         try
         {
            GF.removeAllChild(mc["back"]);
            mc["back"].addChild(this.asset.getBackItemGraphic(backId));
         }
         catch(e:Error)
         {
            Out.error(this,"setupBackItem :: " + mc + " :: " + backId + " :: " + e.getStackTrace());
         }
      }
      
      public function unSetupBackitem(mc:MovieClip) : void
      {
         try
         {
            GF.removeAllChild(mc["back"]);
         }
         catch(e:Error)
         {
            Out.error(this,"unSetupBackitem :: " + mc + " :: " + e.getStackTrace());
         }
      }
   }
}

import flash.display.MovieClip;

interface GI_Character
{
    
   
   function setupFace(param1:MovieClip, param2:String, param3:Number) : void;
}
