package ninjasaga.data
{
   public final class NpcDataLang
   {
       
      
      public var textArr:Array;
      
      public function NpcDataLang()
      {
         textArr = [];
         super();
      }
      
      public function NpcDataLang_Process(_npcData:Object) : *
      {
         switch(AppData.lang)
         {
            case AppData.PT:
               _npcData[1].name = "Ryuma";
               _npcData[2].name = "Gekko";
               _npcData[3].name = "Shuji";
               _npcData[4].name = "Kazuya";
               _npcData[5].name = "Masaki";
               _npcData[6].name = "Keisuke";
               _npcData[7].name = "Mabuki";
               break;
            case AppData.ZH:
               _npcData[1].name = "月光";
               _npcData[2].name = "龍馬";
               _npcData[3].name = "修司";
               _npcData[4].name = "和哉";
               _npcData[5].name = "正樹";
               _npcData[6].name = "惠介";
               _npcData[7].name = "麻吹";
               break;
            case AppData.CN:
               _npcData[1].name = "月光";
               _npcData[2].name = "龙马";
               _npcData[3].name = "修司";
               _npcData[4].name = "和哉";
               _npcData[5].name = "正树";
               _npcData[6].name = "惠介";
               _npcData[7].name = "麻吹";
               break;
            case AppData.DE:
               _npcData[1].name = "Ryuma";
               _npcData[2].name = "Gekko";
               _npcData[3].name = "Shuji";
               _npcData[4].name = "Kazuya";
               _npcData[5].name = "Masaki";
               _npcData[6].name = "Keisuke";
               _npcData[7].name = "Mabuki";
               break;
            case AppData.ES:
               _npcData[1].name = "Ryuma";
               _npcData[2].name = "Gekko";
               _npcData[3].name = "Shuji";
               _npcData[4].name = "Kazuya";
               _npcData[5].name = "Masaki";
               _npcData[6].name = "Keisuke";
               _npcData[7].name = "Mabuki";
               break;
            default:
               _npcData[1].name = "Ryuma";
               _npcData[2].name = "Gekko";
               _npcData[3].name = "Shuji";
               _npcData[4].name = "Kazuya";
               _npcData[5].name = "Masaki";
               _npcData[6].name = "Keisuke";
               _npcData[7].name = "Mabuki";
         }
      }
   }
}
