package com.google.analytics.data
{
   import com.google.analytics.core.Buffer;
   
   public class UTMCookie implements Cookie
   {
       
      
      protected var inURL:String;
      
      protected var name:String;
      
      private var _creation:Date;
      
      private var _expiration:Date;
      
      public var proxy:Buffer;
      
      protected var fields:Array;
      
      private var _timespan:Number;
      
      public function UTMCookie(name:String, inURL:String, fields:Array, timespan:Number = 0)
      {
         super();
         this.name = name;
         this.inURL = inURL;
         this.fields = fields;
         _timestamp(timespan);
      }
      
      public function isEmpty() : Boolean
      {
         var field:String = null;
         var empty:int = 0;
         for(var i:int = 0; i < fields.length; i++)
         {
            field = fields[i];
            if(this[field] is Number && isNaN(this[field]))
            {
               empty++;
            }
            else if(this[field] is String && this[field] == "")
            {
               empty++;
            }
         }
         if(empty == fields.length)
         {
            return true;
         }
         return false;
      }
      
      public function resetTimestamp(timespan:Number = NaN) : void
      {
         if(!isNaN(timespan))
         {
            _timespan = timespan;
         }
         _creation = null;
         _expiration = null;
         _timestamp(_timespan);
      }
      
      protected function update() : void
      {
         resetTimestamp();
         if(proxy)
         {
            proxy.update(name,toSharedObject());
         }
      }
      
      public function reset() : void
      {
         var field:String = null;
         for(var i:int = 0; i < fields.length; i++)
         {
            field = fields[i];
            if(this[field] is Number)
            {
               this[field] = NaN;
            }
            else if(this[field] is String)
            {
               this[field] = "";
            }
         }
         resetTimestamp();
         update();
      }
      
      public function fromSharedObject(data:Object) : void
      {
         var field:String = null;
         var len:int = fields.length;
         for(var i:int = 0; i < len; i++)
         {
            field = fields[i];
            if(data[field])
            {
               this[field] = data[field];
            }
         }
         if(data.creation)
         {
            this.creation = data.creation;
         }
         if(data.expiration)
         {
            this.expiration = data.expiration;
         }
      }
      
      private function _timestamp(timespan:Number) : void
      {
         creation = new Date();
         _timespan = timespan;
         if(timespan > 0)
         {
            expiration = new Date(creation.valueOf() + timespan);
         }
      }
      
      public function isExpired() : Boolean
      {
         var current:Date = new Date();
         var diff:Number = expiration.valueOf() - current.valueOf();
         if(diff <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function set expiration(value:Date) : void
      {
         _expiration = value;
      }
      
      public function get creation() : Date
      {
         return _creation;
      }
      
      public function valueOf() : String
      {
         var field:String = null;
         var value:* = undefined;
         var data:Array = [];
         for(var i:int = 0; i < fields.length; i++)
         {
            field = fields[i];
            value = this[field];
            if(value is String)
            {
               if(value == "")
               {
                  value = "-";
                  data.push(value);
               }
               else
               {
                  data.push(value);
               }
            }
            else if(value is Number)
            {
               if(value == 0)
               {
                  data.push(value);
               }
               else if(isNaN(value))
               {
                  value = "-";
                  data.push(value);
               }
               else
               {
                  data.push(value);
               }
            }
         }
         return "" + data.join(".");
      }
      
      public function toURLString() : String
      {
         return inURL + "=" + valueOf();
      }
      
      public function get expiration() : Date
      {
         if(_expiration)
         {
            return _expiration;
         }
         return new Date(new Date().valueOf() + 1000);
      }
      
      public function toSharedObject() : Object
      {
         var field:String = null;
         var value:* = undefined;
         var data:Object = {};
         for(var i:int = 0; i < fields.length; i++)
         {
            field = fields[i];
            value = this[field];
            if(value is String)
            {
               data[field] = value;
            }
            else if(value == 0)
            {
               data[field] = value;
            }
            else if(!isNaN(value))
            {
               data[field] = value;
            }
         }
         data.creation = creation;
         data.expiration = expiration;
         return data;
      }
      
      public function toString(showTimestamp:Boolean = false) : String
      {
         var field:String = null;
         var value:* = undefined;
         var data:Array = [];
         var len:int = fields.length;
         for(var i:int = 0; i < len; i++)
         {
            field = fields[i];
            value = this[field];
            if(value is String)
            {
               data.push(field + ": \"" + value + "\"");
            }
            else if(value == 0)
            {
               data.push(field + ": " + value);
            }
            else if(!isNaN(value))
            {
               data.push(field + ": " + value);
            }
         }
         var str:* = name.toUpperCase() + " {" + data.join(", ") + "}";
         if(showTimestamp)
         {
            str = str + (" creation:" + creation + ", expiration:" + expiration);
         }
         return str;
      }
      
      public function set creation(value:Date) : void
      {
         _creation = value;
      }
   }
}
