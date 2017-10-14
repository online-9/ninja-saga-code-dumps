package de.polygonal.ds.sort
{
   import de.polygonal.ds.SListNode;
   
   public function sLinkedMergeSortCmp(node:SListNode, cmp:Function, descending:Boolean = false) : SListNode
   {
      var p:SListNode = null;
      var q:SListNode = null;
      var e:SListNode = null;
      var tail:SListNode = null;
      var nmerges:int = 0;
      var psize:int = 0;
      var qsize:int = 0;
      var i:int = 0;
      if(!node || cmp == null)
      {
         return null;
      }
      var h:SListNode = node;
      var insize:* = 1;
      if(descending)
      {
         while(true)
         {
            p = h;
            h = tail = null;
            nmerges = 0;
            while(p)
            {
               nmerges++;
               i = 0;
               psize = 0;
               q = p;
               while(i < insize)
               {
                  psize++;
                  q = q.next;
                  if(!q)
                  {
                     break;
                  }
                  i++;
               }
               qsize = insize;
               while(psize > 0 || qsize > 0 && q)
               {
                  if(psize == 0)
                  {
                     e = q;
                     q = q.next;
                     qsize--;
                  }
                  else if(qsize == 0 || !q)
                  {
                     e = p;
                     p = p.next;
                     psize--;
                  }
                  else if(cmp(p.data,q.data) >= 0)
                  {
                     e = p;
                     p = p.next;
                     psize--;
                  }
                  else
                  {
                     e = q;
                     q = q.next;
                     qsize--;
                  }
                  if(tail)
                  {
                     tail.next = e;
                  }
                  else
                  {
                     h = e;
                  }
                  tail = e;
               }
               p = q;
            }
            tail.next = null;
            if(nmerges <= 1)
            {
               break;
            }
            insize = insize << 1;
         }
         return h;
      }
      while(true)
      {
         p = h;
         h = tail = null;
         nmerges = 0;
         while(p)
         {
            nmerges++;
            i = 0;
            psize = 0;
            q = p;
            while(i < insize)
            {
               psize++;
               q = q.next;
               if(!q)
               {
                  break;
               }
               i++;
            }
            qsize = insize;
            while(psize > 0 || qsize > 0 && q)
            {
               if(psize == 0)
               {
                  e = q;
                  q = q.next;
                  qsize--;
               }
               else if(qsize == 0 || !q)
               {
                  e = p;
                  p = p.next;
                  psize--;
               }
               else if(cmp(p.data,q.data) <= 0)
               {
                  e = p;
                  p = p.next;
                  psize--;
               }
               else
               {
                  e = q;
                  q = q.next;
                  qsize--;
               }
               if(tail)
               {
                  tail.next = e;
               }
               else
               {
                  h = e;
               }
               tail = e;
            }
            p = q;
         }
         tail.next = null;
         if(nmerges <= 1)
         {
            break;
         }
         insize = insize << 1;
      }
      return h;
   }
}
