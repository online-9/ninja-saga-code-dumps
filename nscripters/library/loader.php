<?php
//setup the environment
	set_time_limit(0);
	session_start();

//account loader class
	require_once __DIR__."/account_loader.php";
//game client_library clone in php
	require_once __DIR__."/client_library.php";
//AMF client
	require_once __DIR__.'/AMF/loader.php';

//some functions
	function cout($ob){
		echo "<pre>";
		print_r($ob);
		echo "</pre>";
		 ob_flush();
		 flush();
	}
	
	function cantLogin($email){
		echo "Email: ".$email." -> Couldnt login<br><br>";
	}
	
?>