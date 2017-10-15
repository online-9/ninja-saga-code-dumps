package de.polygonal.ds.sort.compare 
{
    public function compareStringCaseInSensitive(arg1:String, arg2:String):int
    {
        var loc1:*;
        loc1 = 0;
        var loc2:*;
        loc2 = 0;
        var loc3:*;
        loc3 = 0;
        arg1 = arg1.toLowerCase();
        arg2 = arg2.toLowerCase();
        if (arg1.length + arg2.length > 2)
        {
            loc1 = 0;
            loc2 = arg1.length > arg2.length ? arg1.length : arg2.length;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                loc1 = arg1.charCodeAt(loc3) - arg2.charCodeAt(loc3);
                if (loc1 != 0)
                {
                    break;
                }
                ++loc3;
            }
            return loc1;
        }
        return arg1.charCodeAt(0) - arg2.charCodeAt(0);
    }
}
