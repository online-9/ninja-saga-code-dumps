package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedInsertionSort(node:SListNode, descending:Boolean = false) : SListNode
   {
      var j:int = 0;
      var val:Number = NaN;
      var a:Array = [];
      var k:int = 0;
      var h:SListNode = node;
      var n:SListNode = node;
      while(n)
      {
         a[k++] = n.data;
         n = n.next;
      }
      if(k <= 1)
      {
         return h;
      }
      for(var i:int = 1; i < k; i++)
      {
         val = a[i];
         j = i;
         while(j > 0 && a[int(j - 1)] > val)
         {
            a[j] = a[int(j - 1)];
            j--;
         }
         a[j] = val;
      }
      n = h;
      i = 0;
      while(n)
      {
         n.data = a[i++];
         n = n.next;
      }
      return h;
   }
}
