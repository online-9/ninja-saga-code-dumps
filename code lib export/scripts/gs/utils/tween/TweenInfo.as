package gs.utils.tween
{
   public class TweenInfo
   {
       
      
      public var target:Object;
      
      public var property:String;
      
      public var start:Number;
      
      public var change:Number;
      
      public var name:String;
      
      public var isPlugin:Boolean;
      
      public function TweenInfo($target:Object, $property:String, $start:Number, $change:Number, $name:String, $isPlugin:Boolean)
      {
         super();
         this.target = $target;
         this.property = $property;
         this.start = $start;
         this.change = $change;
         this.name = $name;
         this.isPlugin = $isPlugin;
      }
   }
}
