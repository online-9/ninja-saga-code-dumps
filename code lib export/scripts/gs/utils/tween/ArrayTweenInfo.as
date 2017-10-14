package gs.utils.tween
{
   public class ArrayTweenInfo
   {
       
      
      public var index:uint;
      
      public var start:Number;
      
      public var change:Number;
      
      public function ArrayTweenInfo($index:uint, $start:Number, $change:Number)
      {
         super();
         this.index = $index;
         this.start = $start;
         this.change = $change;
      }
   }
}
