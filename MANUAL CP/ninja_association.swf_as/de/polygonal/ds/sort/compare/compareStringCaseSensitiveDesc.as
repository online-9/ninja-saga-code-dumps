package de.polygonal.ds.sort.compare 
{
    public function compareStringCaseSensitiveDesc(arg1:String, arg2:String):int
    {
        var loc1:*;
        loc1 = 0;
        var loc2:*;
        loc2 = 0;
        var loc3:*;
        loc3 = 0;
        if (arg1.length + arg2.length > 2)
        {
            loc1 = 0;
            loc2 = arg1.length > arg2.length ? arg1.length : arg2.length;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                loc1 = arg2.charCodeAt(loc3) - arg1.charCodeAt(loc3);
                if (loc1 != 0)
                {
                    break;
                }
                ++loc3;
            }
            return loc1;
        }
        return arg2.charCodeAt(0) - arg1.charCodeAt(0);
    }
}
