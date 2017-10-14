package ninjasaga.data
{
   public final class NPCData
   {
      
      private static var _npcData:Object;
      
      private static var _npcDataArr:Array;
      
      private static var _npcEventFreeData:Object;
      
      private static var _npcEventFreeDataArr:Array;
       
      
      public function NPCData()
      {
         super();
      }
      
      public static function get npcData() : Object
      {
         var npcDataObject:NpcDataLang = null;
         if(_npcData == null)
         {
            _npcData = {};
            _npcData[1] = {
               "id":1,
               "swfName":"npc_3",
               "clsName":"Npc_3",
               "name":"Ryuma",
               "level":20,
               "vendor":true,
               "token":20,
               "premium":false,
               "description":"",
               "character_xp":84931,
               "character_level":20,
               "character_gender":0,
               "icon":"NpcIcon_1",
               "character_rank":1
            };
            _npcData[2] = {
               "id":2,
               "swfName":"npc_4",
               "clsName":"Npc_4",
               "name":"Gekko",
               "level":20,
               "vendor":true,
               "token":20,
               "premium":false,
               "description":"",
               "character_xp":84931,
               "character_level":20,
               "character_gender":0,
               "icon":"NpcIcon_2",
               "character_rank":1
            };
            _npcData[3] = {
               "id":3,
               "swfName":"npc_5",
               "clsName":"Npc_5",
               "name":"Shuji",
               "level":40,
               "vendor":true,
               "token":40,
               "premium":false,
               "description":"",
               "character_xp":1115790,
               "character_level":40,
               "character_gender":0,
               "icon":"NpcIcon_3",
               "character_rank":3
            };
            _npcData[4] = {
               "id":4,
               "swfName":"npc_6",
               "clsName":"Npc_6",
               "name":"Kazuya",
               "level":40,
               "vendor":true,
               "token":40,
               "premium":false,
               "description":"",
               "character_xp":1115790,
               "character_level":40,
               "character_gender":0,
               "icon":"NpcIcon_4",
               "character_rank":3
            };
            _npcData[5] = {
               "id":5,
               "swfName":"npc_7",
               "clsName":"Npc_7",
               "name":"Masaki",
               "level":60,
               "vendor":false,
               "token":60,
               "premium":false,
               "description":"",
               "character_xp":9032494,
               "character_level":60,
               "character_gender":0,
               "icon":"NpcIcon_5",
               "character_rank":5
            };
            _npcData[6] = {
               "id":6,
               "swfName":"npc_8",
               "clsName":"Npc_8",
               "name":"Keisuke",
               "level":60,
               "vendor":false,
               "token":60,
               "premium":false,
               "description":"",
               "character_xp":9032494,
               "character_level":60,
               "character_gender":0,
               "icon":"NpcIcon_6",
               "character_rank":5
            };
            _npcData[7] = {
               "id":7,
               "swfName":"npc_9",
               "clsName":"Npc_9",
               "name":"Mabuki",
               "level":80,
               "vendor":false,
               "token":150,
               "premium":false,
               "description":"",
               "character_xp":61173262,
               "character_level":80,
               "character_gender":0,
               "icon":"NpcIcon_9",
               "character_rank":7
            };
            npcDataObject = new NpcDataLang();
            npcDataObject.NpcDataLang_Process(_npcData);
         }
         return _npcData;
      }
      
      public static function get npcForceArr() : Array
      {
         var value:Object = null;
         _npcData = null;
         var data:Object = npcData;
         _npcDataArr = [];
         for each(value in data)
         {
            _npcDataArr.push(value);
         }
         return _npcDataArr;
      }
      
      public static function get npcArr() : Array
      {
         var data:Object = null;
         var value:Object = null;
         if(_npcDataArr == null)
         {
            data = npcData;
            _npcDataArr = [];
            for each(value in data)
            {
               _npcDataArr.push(value);
            }
         }
         return _npcDataArr;
      }
   }
}
