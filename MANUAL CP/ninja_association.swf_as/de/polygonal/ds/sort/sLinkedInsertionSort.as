package de.polygonal.ds.sort 
{
    import de.polygonal.ds.*;
    
    public function sLinkedInsertionSort(arg1:de.polygonal.ds.SListNode, arg2:Boolean=false):de.polygonal.ds.SListNode
    {
        var loc5:*;
        loc5 = 0;
        var loc6:*;
        loc6 = NaN;
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
        if (loc2 <= 1)
        {
            return loc3;
        }
        var loc7:*;
        loc7 = 1;
        while (loc7 < loc2) 
        {
            loc6 = loc1[loc7];
            loc5 = loc7;
            while (loc5 > 0 && loc1[int((loc5 - 1))] > loc6) 
            {
                loc1[loc5] = loc1[int((loc5 - 1))];
                loc5 = (loc5 - 1);
            }
            loc1[loc5] = loc6;
            ++loc7;
        }
        loc4 = loc3;
        loc7 = 0;
        while (loc4) 
        {
            loc4.data = loc1[loc7++];
            loc4 = loc4.next;
        }
        return loc3;
    }
}
