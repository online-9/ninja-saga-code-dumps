package com.google.analytics.data
{
   public class X10
   {
       
      
      private var _delimEnd:String = ")";
      
      private var _minimum:int;
      
      private var _delimSet:String = "*";
      
      private var _escapeChar:String = "\'";
      
      private var _delimBegin:String = "(";
      
      private var _delimNumValue:String = "!";
      
      private var _key:String = "k";
      
      private var _set:Array;
      
      private var _hasData:int;
      
      private var _escapeCharMap:Object;
      
      private var _projectData:Object;
      
      private var _value:String = "v";
      
      public function X10()
      {
         _set = [_key,_value];
         super();
         _projectData = {};
         _escapeCharMap = {};
         _escapeCharMap[_escapeChar] = "\'0";
         _escapeCharMap[_delimEnd] = "\'1";
         _escapeCharMap[_delimSet] = "\'2";
         _escapeCharMap[_delimNumValue] = "\'3";
         _minimum = 1;
      }
      
      private function _setInternal(projectId:Number, type:String, num:Number, value:String) : void
      {
         if(!hasProject(projectId))
         {
            _projectData[projectId] = {};
         }
         if(_projectData[projectId][type] == undefined)
         {
            _projectData[projectId][type] = [];
         }
         _projectData[projectId][type][num] = value;
         _hasData = _hasData + 1;
      }
      
      private function _renderProject(project:Object) : String
      {
         var i:int = 0;
         var data:Array = null;
         var result:String = "";
         var needTypeQualifier:Boolean = false;
         var l:int = _set.length;
         for(i = 0; i < l; i++)
         {
            data = project[_set[i]];
            if(data)
            {
               if(needTypeQualifier)
               {
                  result = result + _set[i];
               }
               result = result + _renderDataType(data);
               needTypeQualifier = false;
            }
            else
            {
               needTypeQualifier = true;
            }
         }
         return result;
      }
      
      public function hasProject(projectId:Number) : Boolean
      {
         return _projectData[projectId];
      }
      
      public function clearKey(projectId:Number) : void
      {
         _clearInternal(projectId,_key);
      }
      
      private function _renderDataType(data:Array) : String
      {
         var str:String = null;
         var i:int = 0;
         var result:Array = [];
         for(i = 0; i < data.length; i++)
         {
            if(data[i] != undefined)
            {
               str = "";
               if(i != _minimum && data[i - 1] == undefined)
               {
                  str = str + i.toString();
                  str = str + _delimNumValue;
               }
               str = str + _escapeExtensibleValue(data[i]);
               result.push(str);
            }
         }
         return _delimBegin + result.join(_delimSet) + _delimEnd;
      }
      
      public function getKey(projectId:Number, num:Number) : String
      {
         return _getInternal(projectId,_key,num) as String;
      }
      
      public function hasData() : Boolean
      {
         return _hasData > 0;
      }
      
      public function renderMergedUrlString(extObject:X10 = null) : String
      {
         var projectId:* = null;
         if(!extObject)
         {
            return renderUrlString();
         }
         var result:Array = [extObject.renderUrlString()];
         for(projectId in _projectData)
         {
            if(hasProject(Number(projectId)) && !extObject.hasProject(Number(projectId)))
            {
               result.push(projectId + _renderProject(_projectData[projectId]));
            }
         }
         return result.join("");
      }
      
      public function setValue(projectId:Number, num:Number, value:Number) : Boolean
      {
         if(Math.round(value) != value || isNaN(value) || value == Infinity)
         {
            return false;
         }
         _setInternal(projectId,_value,num,value.toString());
         return true;
      }
      
      public function renderUrlString() : String
      {
         var projectId:* = null;
         var result:Array = [];
         for(projectId in _projectData)
         {
            if(hasProject(Number(projectId)))
            {
               result.push(projectId + _renderProject(_projectData[projectId]));
            }
         }
         return result.join("");
      }
      
      private function _getInternal(projectId:Number, type:String, num:Number) : Object
      {
         if(hasProject(projectId) && _projectData[projectId][type] != undefined)
         {
            return _projectData[projectId][type][num];
         }
         return undefined;
      }
      
      public function setKey(projectId:Number, num:Number, value:String) : Boolean
      {
         _setInternal(projectId,_key,num,value);
         return true;
      }
      
      public function clearValue(projectId:Number) : void
      {
         _clearInternal(projectId,_value);
      }
      
      private function _clearInternal(projectId:Number, type:String) : void
      {
         var isEmpty:Boolean = false;
         var i:int = 0;
         var l:int = 0;
         if(hasProject(projectId) && _projectData[projectId][type] != undefined)
         {
            _projectData[projectId][type] = undefined;
            isEmpty = true;
            l = _set.length;
            for(i = 0; i < l; i++)
            {
               if(_projectData[projectId][_set[i]] != undefined)
               {
                  isEmpty = false;
                  break;
               }
            }
            if(isEmpty)
            {
               _projectData[projectId] = undefined;
               _hasData = _hasData - 1;
            }
         }
      }
      
      public function getValue(projectId:Number, num:Number) : *
      {
         var value:* = _getInternal(projectId,_value,num);
         if(value == null)
         {
            return null;
         }
         return Number(value);
      }
      
      private function _escapeExtensibleValue(value:String) : String
      {
         var i:int = 0;
         var c:String = null;
         var escaped:String = null;
         var result:String = "";
         for(i = 0; i < value.length; i++)
         {
            c = value.charAt(i);
            escaped = _escapeCharMap[c];
            if(escaped)
            {
               result = result + escaped;
            }
            else
            {
               result = result + c;
            }
         }
         return result;
      }
   }
}
