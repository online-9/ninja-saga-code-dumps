package ninjasaga.data
{
   public final class HairData
   {
      
      private static var hairDataArr:Array;
      
      private static var hairCreateDataArr:Array;
       
      
      public function HairData()
      {
         super();
      }
      
      public static function getData() : Array
      {
         if(hairDataArr == null)
         {
            hairDataArr = [];
            hairDataArr[0] = [];
            hairDataArr[0].push("hair_01_0");
            hairDataArr[0].push("hair_02_0");
            hairDataArr[0].push("hair_03_0");
            hairDataArr[0].push("hair_04_0");
            hairDataArr[0].push("hair_05_0");
            hairDataArr[0].push("hair_06_0");
            hairDataArr[0].push("hair_07_0");
            hairDataArr[0].push("hair_08_0");
            hairDataArr[0].push("hair_9_0");
            hairDataArr[0].push("hair_10_0");
            hairDataArr[0].push("hair_11_0");
            hairDataArr[0].push("hair_12_0");
            hairDataArr[0].push("hair_13_0");
            hairDataArr[0].push("hair_14_0");
            hairDataArr[0].push("hair_16_0");
            hairDataArr[0].push("hair_17_0");
            hairDataArr[0].push("hair_18_0");
            hairDataArr[0].push("hair_19_0");
            hairDataArr[0].push("hair_20_0");
            hairDataArr[0].push("hair_32_0");
            hairDataArr[1] = [];
            hairDataArr[1].push("hair_01_1");
            hairDataArr[1].push("hair_02_1");
            hairDataArr[1].push("hair_03_1");
            hairDataArr[1].push("hair_04_1");
            hairDataArr[1].push("hair_05_1");
            hairDataArr[1].push("hair_06_1");
            hairDataArr[1].push("hair_07_1");
            hairDataArr[1].push("hair_08_1");
            hairDataArr[1].push("hair_9_1");
            hairDataArr[1].push("hair_10_1");
            hairDataArr[1].push("hair_11_1");
            hairDataArr[1].push("hair_12_1");
            hairDataArr[1].push("hair_13_1");
            hairDataArr[1].push("hair_14_1");
            hairDataArr[1].push("hair_16_1");
            hairDataArr[1].push("hair_17_1");
            hairDataArr[1].push("hair_18_1");
            hairDataArr[1].push("hair_19_1");
            hairDataArr[1].push("hair_20_1");
            hairDataArr[1].push("hair_32_1");
         }
         return hairDataArr;
      }
      
      public static function getCreateData() : Array
      {
         if(hairCreateDataArr == null)
         {
            hairCreateDataArr = [];
            hairCreateDataArr[0] = [];
            hairCreateDataArr[0].push("hair_01_0");
            hairCreateDataArr[0].push("hair_03_0");
            hairCreateDataArr[0].push("hair_04_0");
            hairCreateDataArr[0].push("hair_05_0");
            hairCreateDataArr[0].push("hair_9_0");
            hairCreateDataArr[0].push("hair_11_0");
            hairCreateDataArr[0].push("hair_12_0");
            hairCreateDataArr[0].push("hair_13_0");
            hairCreateDataArr[0].push("hair_14_0");
            hairCreateDataArr[0].push("hair_17_0");
            hairCreateDataArr[0].push("hair_19_0");
            hairCreateDataArr[0].push("hair_32_0");
            hairCreateDataArr[1] = [];
            hairCreateDataArr[1].push("hair_01_1");
            hairCreateDataArr[1].push("hair_02_1");
            hairCreateDataArr[1].push("hair_03_1");
            hairCreateDataArr[1].push("hair_04_1");
            hairCreateDataArr[1].push("hair_05_1");
            hairCreateDataArr[1].push("hair_9_1");
            hairCreateDataArr[1].push("hair_10_1");
            hairCreateDataArr[1].push("hair_12_1");
            hairCreateDataArr[1].push("hair_13_1");
            hairCreateDataArr[1].push("hair_14_1");
            hairCreateDataArr[1].push("hair_17_1");
            hairCreateDataArr[1].push("hair_32_1");
         }
         return hairCreateDataArr;
      }
      
      public static function getCreateHairData(param1:uint) : Array
      {
         var _loc2_:Array = HairData.getCreateData();
         return _loc2_[param1];
      }
   }
}
