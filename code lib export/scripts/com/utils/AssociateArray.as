package com.utils
{
   public class AssociateArray
   {
       
      
      private var storedObj:Object;
      
      private var storedArr:Array;
      
      public function AssociateArray(_obj:Object = null, _sortBy:Object = null, _sortOptions:Object = null)
      {
         var value:* = undefined;
         storedArr = [];
         super();
         if(_obj == null)
         {
            this.storedObj = {};
         }
         else
         {
            this.storedObj = _obj;
            for each(value in this.storedObj)
            {
               this.storedArr.push(value);
            }
            if(_sortBy)
            {
               this.sortOn(_sortBy,_sortOptions);
            }
         }
      }
      
      public function contains(_id:*) : Boolean
      {
         if(this.storedObj[_id])
         {
            return true;
         }
         return false;
      }
      
      public function addItem(_id:*, _value:*) : void
      {
         this.storedObj[_id] = _value;
         this.storedArr.push(_value);
      }
      
      public function getById(_id:*) : *
      {
         return this.storedObj[_id];
      }
      
      public function getByPos(_pos:uint) : *
      {
         return this.storedArr[_pos];
      }
      
      public function removeById(_id:*) : *
      {
         var arrayIndex:uint = 0;
         if(this.contains(_id))
         {
            arrayIndex = this.storedArr.indexOf(this.storedObj[_id]);
            this.storedObj[_id] = null;
            return this.storedArr.splice(arrayIndex,1)[0];
         }
         return null;
      }
      
      public function removeByPos(_pos:uint) : *
      {
         var value:* = undefined;
         var key:* = undefined;
         if(this.storedArr.length <= _pos)
         {
            value = this.storedArr[_pos];
            for(key in this.storedObj)
            {
               if(this.storedObj[key] == value)
               {
                  this.storedObj[key] = null;
               }
            }
            return this.storedArr.splice(_pos,1)[0];
         }
         return null;
      }
      
      public function sort() : void
      {
         this.storedArr.sort();
      }
      
      public function sortOn(_sortBy:Object, _sortOptions:Object = null) : void
      {
         this.storedArr.sortOn(_sortBy,_sortOptions);
      }
      
      public function get arr() : Array
      {
         return this.storedArr;
      }
      
      public function get obj() : Object
      {
         return this.storedObj;
      }
      
      public function get length() : uint
      {
         return this.storedArr.length;
      }
   }
}
