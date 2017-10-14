package com.google.analytics.utils
{
   import flash.net.URLVariables;
   
   public dynamic class Variables
   {
       
      
      public var post:Array;
      
      public var URIencode:Boolean;
      
      public var pre:Array;
      
      public var sort:Boolean = true;
      
      public function Variables(source:String = null, pre:Array = null, post:Array = null)
      {
         pre = [];
         post = [];
         super();
         if(source)
         {
            decode(source);
         }
         if(pre)
         {
            this.pre = pre;
         }
         if(post)
         {
            this.post = post;
         }
      }
      
      private function _join(vars:Variables) : void
      {
         var prop:* = null;
         if(!vars)
         {
            return;
         }
         for(prop in vars)
         {
            this[prop] = vars[prop];
         }
      }
      
      public function join(... variables) : void
      {
         var l:int = variables.length;
         for(var i:int = 0; i < l; i++)
         {
            if(variables[i] is Variables)
            {
               _join(variables[i]);
            }
         }
      }
      
      public function toString() : String
      {
         var value:String = null;
         var p:* = null;
         var component:String = null;
         var i:int = 0;
         var j:int = 0;
         var priority:String = null;
         var last:String = null;
         var data:Array = [];
         for(p in this)
         {
            value = this[p];
            if(URIencode)
            {
               value = encodeURI(value);
            }
            data.push(p + "=" + value);
         }
         if(sort)
         {
            data.sort();
         }
         if(pre.length > 0)
         {
            pre.reverse();
            for(i = 0; i < pre.length; i++)
            {
               priority = pre[i];
               for(j = 0; j < data.length; j++)
               {
                  component = data[j];
                  if(component.indexOf(priority) == 0)
                  {
                     data.unshift(data.splice(j,1)[0]);
                  }
               }
            }
            pre.reverse();
         }
         if(post.length > 0)
         {
            for(i = 0; i < post.length; i++)
            {
               last = post[i];
               for(j = 0; j < data.length; j++)
               {
                  component = data[j];
                  if(component.indexOf(last) == 0)
                  {
                     data.push(data.splice(j,1)[0]);
                  }
               }
            }
         }
         return data.join("&");
      }
      
      public function decode(source:String) : void
      {
         var data:Array = null;
         var prop:String = null;
         var name:String = null;
         var value:String = null;
         var tmp:Array = null;
         if(source == "")
         {
            return;
         }
         if(source.indexOf("&") > -1)
         {
            data = source.split("&");
         }
         else
         {
            data = [source];
         }
         for(var i:int = 0; i < data.length; i++)
         {
            prop = data[i];
            if(prop.indexOf("=") > -1)
            {
               tmp = prop.split("=");
               name = tmp[0];
               value = decodeURI(tmp[1]);
               this[name] = value;
            }
         }
      }
      
      public function toURLVariables() : URLVariables
      {
         var p:* = null;
         var urlvars:URLVariables = new URLVariables();
         for(p in this)
         {
            urlvars[p] = this[p];
         }
         return urlvars;
      }
   }
}
