<?php
	
//AMF client
	require_once __DIR__.'/Client.php';

	
	class AMF{
		private static $r="";
		public static function service($server,$amf,$array){
			self::$r=(object)(new \NScripters_Client($server))->sendRequest($amf,$array);
			
			
			if(property_exists(AMF::response(),"error")){
				if(AMF::response()->error=="102"){
					$_SESSION['swf_version']=AMF::response()->sv;
					die("<script> top.location.href=top.location.href; </script>");
				}
			}
			
			return self::$r;
		}
		public static function response(){
			return self::$r;
		}
	}

?>