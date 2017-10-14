package de.polygonal.ds.sort.compare
{
   public function compareStringCaseSensitive(a:String, b:String) : int
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
            r = a.charCodeAt(i) - b.charCodeAt(i);
            if(r != 0)
            {
               break;
            }
         }
         return r;
      }
      return a.charCodeAt(0) - b.charCodeAt(0);
   }
}
