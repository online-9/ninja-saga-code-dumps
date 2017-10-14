package com.google.analytics.core
{
   import com.google.analytics.utils.Variables;
   
   public class Organic
   {
      
      public static var throwErrors:Boolean = false;
       
      
      private var _sourcesCache:Array;
      
      private var _sourcesEngine:Array;
      
      private var _ignoredKeywords:Array;
      
      private var _ignoredReferralsCache:Object;
      
      private var _ignoredReferrals:Array;
      
      private var _ignoredKeywordsCache:Object;
      
      private var _sources:Array;
      
      public function Organic()
      {
         super();
         _sources = [];
         _sourcesCache = [];
         _sourcesEngine = [];
         _ignoredReferrals = [];
         _ignoredReferralsCache = {};
         _ignoredKeywords = [];
         _ignoredKeywordsCache = {};
      }
      
      public static function getKeywordValueFromPath(keyword:String, path:String) : String
      {
         var value:String = null;
         var vars:Variables = null;
         if(path.indexOf(keyword + "=") > -1)
         {
            if(path.charAt(0) == "?")
            {
               path = path.substr(1);
            }
            path = path.split("+").join("%20");
            vars = new Variables(path);
            value = vars[keyword];
         }
         return value;
      }
      
      public function isIgnoredKeyword(keyword:String) : Boolean
      {
         if(_ignoredKeywordsCache.hasOwnProperty(keyword))
         {
            return true;
         }
         return false;
      }
      
      public function getKeywordValue(or:OrganicReferrer, path:String) : String
      {
         var keyword:String = or.keyword;
         return getKeywordValueFromPath(keyword,path);
      }
      
      public function isIgnoredReferral(referrer:String) : Boolean
      {
         if(_ignoredReferralsCache.hasOwnProperty(referrer))
         {
            return true;
         }
         return false;
      }
      
      public function clear() : void
      {
         clearEngines();
         clearIgnoredReferrals();
         clearIgnoredKeywords();
      }
      
      public function get count() : int
      {
         return _sources.length;
      }
      
      public function get ignoredKeywordsCount() : int
      {
         return _ignoredKeywords.length;
      }
      
      public function match(name:String) : Boolean
      {
         if(name == "")
         {
            return false;
         }
         name = name.toLowerCase();
         if(_sourcesEngine[name] != undefined)
         {
            return true;
         }
         return false;
      }
      
      public function clearIgnoredKeywords() : void
      {
         _ignoredKeywords = [];
         _ignoredKeywordsCache = {};
      }
      
      public function addSource(engine:String, keyword:String) : void
      {
         var orgref:OrganicReferrer = new OrganicReferrer(engine,keyword);
         if(_sourcesCache[orgref.toString()] == undefined)
         {
            _sources.push(orgref);
            _sourcesCache[orgref.toString()] = _sources.length - 1;
            if(_sourcesEngine[orgref.engine] == undefined)
            {
               _sourcesEngine[orgref.engine] = [_sources.length - 1];
            }
            else
            {
               _sourcesEngine[orgref.engine].push(_sources.length - 1);
            }
         }
         else if(throwErrors)
         {
            throw new Error(orgref.toString() + " already exists, we don\'t add it.");
         }
      }
      
      public function clearEngines() : void
      {
         _sources = [];
         _sourcesCache = [];
         _sourcesEngine = [];
      }
      
      public function get ignoredReferralsCount() : int
      {
         return _ignoredReferrals.length;
      }
      
      public function addIgnoredReferral(referrer:String) : void
      {
         if(_ignoredReferralsCache[referrer] == undefined)
         {
            _ignoredReferrals.push(referrer);
            _ignoredReferralsCache[referrer] = _ignoredReferrals.length - 1;
         }
         else if(throwErrors)
         {
            throw new Error("\"" + referrer + "\" already exists, we don\'t add it.");
         }
      }
      
      public function clearIgnoredReferrals() : void
      {
         _ignoredReferrals = [];
         _ignoredReferralsCache = {};
      }
      
      public function getReferrerByName(name:String) : OrganicReferrer
      {
         var index:int = 0;
         if(match(name))
         {
            index = _sourcesEngine[name][0];
            return _sources[index];
         }
         return null;
      }
      
      public function addIgnoredKeyword(keyword:String) : void
      {
         if(_ignoredKeywordsCache[keyword] == undefined)
         {
            _ignoredKeywords.push(keyword);
            _ignoredKeywordsCache[keyword] = _ignoredKeywords.length - 1;
         }
         else if(throwErrors)
         {
            throw new Error("\"" + keyword + "\" already exists, we don\'t add it.");
         }
      }
      
      public function get sources() : Array
      {
         return _sources;
      }
   }
}
