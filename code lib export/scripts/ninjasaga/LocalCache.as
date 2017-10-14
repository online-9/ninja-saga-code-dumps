package ninjasaga
{
   import de.polygonal.ds.HashMap;
   
   public final class LocalCache
   {
      
      private static var instance:ninjasaga.LocalCache;
      
      private static var petStorage:HashMap = new HashMap();
       
      
      private var storage:HashMap;
      
      public function LocalCache(pKey:SingletonBlocker)
      {
         storage = new HashMap();
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use LocalCache.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : ninjasaga.LocalCache
      {
         if(instance == null)
         {
            instance = new ninjasaga.LocalCache(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function hasPet(swfName:String) : Boolean
      {
         if(petStorage.containsKey(swfName))
         {
            return true;
         }
         return false;
      }
      
      public function get(swfPath:String) : *
      {
         return this.storage.find(swfPath);
      }
      
      public function set(swfPath:String, item:*) : void
      {
         this.storage.insert(swfPath,item);
      }
   }
}

class SingletonBlocker
{
    
   
   function SingletonBlocker()
   {
      super();
   }
}
