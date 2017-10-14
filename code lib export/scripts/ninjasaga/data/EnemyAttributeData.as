package ninjasaga.data
{
   import com.utils.Out;
   
   public final class EnemyAttributeData
   {
      
      public static const HP = "hp";
      
      public static const CP = "cp";
      
      public static const ROUND = "round";
      
      public static const SEAL_GAN = "seal_gan";
      
      public static const OVER = 1;
      
      public static const LESS = 0;
      
      public static const SEAL_BOSS_LIST:Array = ["enemy289","enemy290","enemy291","enemy292","enemy393"];
      
      public static const SEAL_BOSS_LIST_EASTER:Array = ["enemy338","enemy339","enemy340","enemy341","enemy342"];
      
      private static const EnemyAttributeArr:Array = [{},{
         "id":"enemy338",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":30
      },{
         "id":"enemy339",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":20
      },{
         "id":"enemy340",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy341",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy342",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy289",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":30
      },{
         "id":"enemy290",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":20
      },{
         "id":"enemy291",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy292",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      },{
         "id":"enemy393",
         "attribute":EnemyAttributeData.SEAL_GAN,
         "amount_over":0,
         "amount_less":10
      }];
       
      
      public function EnemyAttributeData()
      {
         super();
      }
      
      public static function getEnemyAttributeById(id:String) : Array
      {
         var tmpArr:Array = [];
         for(var i:int = 0; i < EnemyAttributeArr.length; i++)
         {
            if(EnemyAttributeArr[i].id == id)
            {
               tmpArr.push(EnemyAttributeArr[i]);
            }
         }
         if(tmpArr.length == 0)
         {
            Out.error("EnemyAttributeData",id + " not found");
         }
         return tmpArr;
      }
   }
}
