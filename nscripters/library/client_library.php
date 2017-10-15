<?php

	class client_library{
		private static $key="";

		public function getLoginHash($sessionkey, $string){
			if(self::$key=="") die("client_library is missing its encryption key.");
			return self::generateHash($sessionkey, $string.self::$key);
		}
		public function getHash($sessionkey, $string){
			if(self::$key=="") die("client_library is missing its encryption key.");
			return self::generateHash($sessionkey, $string.self::$key.$sessionkey);
		}
		public function getArrayHash($arg1, $arg2){
			if(self::$key=="") die("client_library is missing its encryption key.");
			$loc1 = implode(",", $arg2);
			$loc3 = $loc1.self::$key.$arg1;
			return self::generateHash($arg1, $loc3);
		}
		public function generateHash($arg1, $arg2){
			$loc2 = intval("0x" + substr($arg1, 1, 1), 16);
			$loc3 = sha1($arg2);
			$loc4 = substr($loc3, $loc2, 12);
			return $loc4;
		}
		public static function setKey($key){
			self::$key=$key;
		}
	}

?>