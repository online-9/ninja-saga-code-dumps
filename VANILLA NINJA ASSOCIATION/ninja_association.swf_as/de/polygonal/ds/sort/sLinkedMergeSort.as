package de.polygonal.ds.sort 
{
    import de.polygonal.ds.*;
    
    public function sLinkedMergeSort(arg1:de.polygonal.ds.SListNode, arg2:Boolean=false):de.polygonal.ds.SListNode
    {
        var loc2:*;
        loc2 = null;
        var loc3:*;
        loc3 = null;
        var loc4:*;
        loc4 = null;
        var loc5:*;
        loc5 = null;
        var loc7:*;
        loc7 = 0;
        var loc8:*;
        loc8 = 0;
        var loc9:*;
        loc9 = 0;
        var loc10:*;
        loc10 = 0;
        if (!arg1)
        {
            return null;
        }
        var loc1:*;
        loc1 = arg1;
        var loc6:*;
        loc6 = 1;
        if (arg2)
        {
            for (;;) 
            {
                loc2 = loc1;
                var loc11:*;
                loc5 = loc11 = null;
                loc1 = loc11;
                loc7 = 0;
                while (loc2) 
                {
                    ++loc7;
                    loc10 = 0;
                    loc8 = 0;
                    loc3 = loc2;
                    while (loc10 < loc6) 
                    {
                        ++loc8;
                        if (!(loc3 = loc3.next))
                        {
                            break;
                        }
                        ++loc10;
                    }
                    loc9 = loc6;
                    while (loc8 > 0 || loc9 > 0 && loc3) 
                    {
                        if (loc8 != 0)
                        {
                            if (loc9 == 0 || !loc3)
                            {
                                loc4 = loc2;
                                loc2 = loc2.next;
                                loc8 = (loc8 - 1);
                            }
                            else 
                            {
                                if (loc2.data - loc3.data >= 0)
                                {
                                    loc4 = loc2;
                                    loc2 = loc2.next;
                                    loc8 = (loc8 - 1);
                                }
                                else 
                                {
                                    loc4 = loc3;
                                    loc3 = loc3.next;
                                    loc9 = (loc9 - 1);
                                }
                            }
                        }
                        else 
                        {
                            loc4 = loc3;
                            loc3 = loc3.next;
                            loc9 = (loc9 - 1);
                        }
                        if (loc5)
                        {
                            loc5.next = loc4;
                        }
                        else 
                        {
                            loc1 = loc4;
                        }
                        loc5 = loc4;
                    }
                    loc2 = loc3;
                }
                loc5.next = null;
                if (loc7 <= 1)
                {
                    return loc1;
                }
                loc6 = loc6 << 1;
            }
        }
        for (;;) 
        {
            loc2 = loc1;
            loc5 = loc11 = null;
            loc1 = loc11;
            loc7 = 0;
            while (loc2) 
            {
                ++loc7;
                loc10 = 0;
                loc8 = 0;
                loc3 = loc2;
                while (loc10 < loc6) 
                {
                    ++loc8;
                    if (!(loc3 = loc3.next))
                    {
                        break;
                    }
                    ++loc10;
                }
                loc9 = loc6;
                while (loc8 > 0 || loc9 > 0 && loc3) 
                {
                    if (loc8 != 0)
                    {
                        if (loc9 == 0 || !loc3)
                        {
                            loc4 = loc2;
                            loc2 = loc2.next;
                            loc8 = (loc8 - 1);
                        }
                        else 
                        {
                            if (loc2.data - loc3.data <= 0)
                            {
                                loc4 = loc2;
                                loc2 = loc2.next;
                                loc8 = (loc8 - 1);
                            }
                            else 
                            {
                                loc4 = loc3;
                                loc3 = loc3.next;
                                loc9 = (loc9 - 1);
                            }
                        }
                    }
                    else 
                    {
                        loc4 = loc3;
                        loc3 = loc3.next;
                        loc9 = (loc9 - 1);
                    }
                    if (loc5)
                    {
                        loc5.next = loc4;
                    }
                    else 
                    {
                        loc1 = loc4;
                    }
                    loc5 = loc4;
                }
                loc2 = loc3;
            }
            loc5.next = null;
            if (loc7 <= 1)
            {
                return loc1;
            }
            loc6 = loc6 << 1;
        }
        return null;
    }
}
