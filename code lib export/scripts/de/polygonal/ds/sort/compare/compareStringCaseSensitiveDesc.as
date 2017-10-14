package de.polygonal.ds.sort.compare
{
   public function compareStringCaseSensitiveDesc(a:String, b:String) : int
   {
      var r:int = 0;
      var k:int = 0;
      var i:int = 0;
      if(a.length + b.length > 2)
      {
         r = 0;
         k = a.length > b.length?int(a.length):int(b.length);
         for(i = 0; i < k; i++)
         {
            r = b.charCodeAt(i) - a.charCodeAt(i);
            if(r != 0)
            {
               break;
            }
         }
         return r;
      }
      return b.charCodeAt(0) - a.charCodeAt(0);
   }
}
