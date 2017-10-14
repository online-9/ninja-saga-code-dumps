package br.com.stimuli.loading
{
   import flash.events.ProgressEvent;
   import flash.events.Event;
   
   public class BulkProgressEvent extends ProgressEvent
   {
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
       
      
      public var bytesTotalCurrent:int;
      
      public var _ratioLoaded:Number;
      
      public var _percentLoaded:Number;
      
      public var _weightPercent:Number;
      
      public var itemsLoaded:int;
      
      public var itemsTotal:int;
      
      public var name:String;
      
      public function BulkProgressEvent(name:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(name,bubbles,cancelable);
         this.name = name;
      }
      
      public function setInfo(bytesLoaded:int, bytesTotal:int, bytesTotalCurrent:int, itemsLoaded:int, itemsTotal:int, weightPercent:Number) : void
      {
         this.bytesLoaded = bytesLoaded;
         this.bytesTotal = bytesTotal;
         this.bytesTotalCurrent = bytesTotalCurrent;
         this.itemsLoaded = itemsLoaded;
         this.itemsTotal = itemsTotal;
         this.weightPercent = weightPercent;
         this.percentLoaded = bytesTotal > 0?Number(bytesLoaded / bytesTotal):Number(0);
         ratioLoaded = itemsTotal == 0?Number(0):Number(itemsLoaded / itemsTotal);
      }
      
      override public function clone() : Event
      {
         var b:BulkProgressEvent = new BulkProgressEvent(name,bubbles,cancelable);
         b.setInfo(bytesLoaded,bytesTotal,bytesTotalCurrent,itemsLoaded,itemsTotal,weightPercent);
         return b;
      }
      
      public function loadingStatus() : String
      {
         var names:Array = [];
         names.push("bytesLoaded: " + bytesLoaded);
         names.push("bytesTotal: " + bytesTotal);
         names.push("itemsLoaded: " + itemsLoaded);
         names.push("itemsTotal: " + itemsTotal);
         names.push("bytesTotalCurrent: " + bytesTotalCurrent);
         names.push("percentLoaded: " + BulkLoader.truncateNumber(percentLoaded));
         names.push("weightPercent: " + BulkLoader.truncateNumber(weightPercent));
         names.push("ratioLoaded: " + BulkLoader.truncateNumber(ratioLoaded));
         return "BulkProgressEvent " + names.join(", ") + ";";
      }
      
      public function get weightPercent() : Number
      {
         return _weightPercent;
      }
      
      public function set weightPercent(value:Number) : void
      {
         if(isNaN(value) || !isFinite(value))
         {
            value = 0;
         }
         _weightPercent = value;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function set percentLoaded(value:Number) : void
      {
         if(isNaN(value) || !isFinite(value))
         {
            value = 0;
         }
         _percentLoaded = value;
      }
      
      public function get ratioLoaded() : Number
      {
         return _ratioLoaded;
      }
      
      public function set ratioLoaded(value:Number) : void
      {
         if(isNaN(value) || !isFinite(value))
         {
            value = 0;
         }
         _ratioLoaded = value;
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
   }
}
