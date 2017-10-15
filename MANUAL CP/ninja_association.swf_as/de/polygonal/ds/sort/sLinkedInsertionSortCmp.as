package de.polygonal.ds.sort 
{
    import de.polygonal.ds.*;
    
    public function sLinkedInsertionSortCmp(arg1:de.polygonal.ds.SListNode, arg2:Function, arg3:Boolean=false):de.polygonal.ds.SListNode
    {
        var loc5:*;
        loc5 = 0;
        var loc6:*;
        loc6 = 0;
        var loc7:*;
        loc7 = undefined;
        var loc1:*;
        loc1 = [];
        var loc2:*;
        loc2 = 0;
        var loc3:*;
        loc3 = arg1;
        var loc4:*;
        loc4 = arg1;
        while (loc4) 
        {
            var loc8:*;
            loc1[(loc8 = loc2++)] = loc4.data;
            loc4 = loc4.next;
        }
        if (arg3)
        {
            if (loc2 <= 1)
            {
                return loc3;
            }
            loc6 = 1;
            while (loc6 < loc2) 
            {
                loc7 = loc1[loc6];
                loc5 = loc6;
                while (loc5 > 0 && arg2(loc1[int((loc5 - 1))], loc7) < 0) 
                {
                    loc1[loc5] = loc1[int((loc5 - 1))];
                    loc5 = (loc5 - 1);
                }
                loc1[loc5] = loc7;
                ++loc6;
            }
        }
        else 
        {
            if (loc2 <= 1)
            {
                return loc3;
            }
            loc6 = 1;
            while (loc6 < loc2) 
            {
                loc7 = loc1[loc6];
                loc5 = loc6;
                while (loc5 > 0 && arg2(loc1[int((loc5 - 1))], loc7) > 0) 
                {
                    loc1[loc5] = loc1[int((loc5 - 1))];
                    loc5 = (loc5 - 1);
                }
                loc1[loc5] = loc7;
                ++loc6;
            }
        }
        loc4 = loc3;
        loc6 = 0;
        while (loc4) 
        {
            loc4.data = loc1[loc6++];
            loc4 = loc4.next;
        }
        return loc3;
    }
}
