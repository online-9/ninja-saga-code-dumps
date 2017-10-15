<?php
//###############################################################################################################
//#                                                                                                             #
//#        README                                                                                               #
//#                                                                                                             #
//#        This script needs to login your facebook account to get ninja saga's character info                  #
//#        and uses this info to connect to ninja saga game. For the first time you will use this script        #
//#        facebook account probably will get locked, you need to login and click "This was me" in order        #
//#        to allow php script to login your facebook account and do its job.                                   #
//#                                                                                                             #
//#        *When loaded it firstly gets some basic data from ninja saga game , this takes 5 seconds             #
//#        After that it starts getting characters data , in an asynchronous manner , this takes 5 more seconds #
//#                                                                                                             #
//#                                                                                                             #
//#        *This scripts gets your ninja saga game informations from your facebook account                      #
//#                                                                                                             #
//#                                                                                                             #
//#        *There are 3 ways to use this informations :                                                         #
//#                                                                                                             #
//#                                                                                                             #
//#                                                                                                             #
//#        1. Use them to do AMF calls into ninja saga game server                                              #
//#           Script:                                                                                           #
//#                AMF Call :     AMF::service($account->amf[0],"amf service",[sending data]);                  #
//#            AMF Response :     AMF::response();                                                              #
//#                                                                                                             #
//#                                                                                                             #
//#        2. Use them to load ninja saga game by loading ninja_saga.swf file                                   #
//#              This method will result in error 303 (domain validation)                                       #
//#              To make this work you need to use Fiddler or Charles                                           #
//#              With a fixed ninja_saga.swf or code_library.swf                                                #
//#           Script:                                                                                           #
//#                               $loader::loadGame($account);                                                  #
//#                                                                                                             #
//#                                                                                                             #
//#        3. Use them to load ninja saga game from their website (app.ninjasaga.com) , so there is no error    #
//#           Script:                                                                                           #
//#                               $loader::loadIframe($account);                                                #
//#                                                                                                             #
//#                                                                                                             #
//#                                                                                                             #
//#        **Remember you can use only one of them at a time                                                    #
//#                                                                                                             #
//#                                                                                                             #
//#                                                                                                             #
//#        If you want to output an object's or array's data in screen you can use cout function                #
//#                               cout($variable)                                                               #
//#                                                                                                             #
//#                                                                                                             #
//#                                                                                                             #
//#        Please feel free to use this script for whatever you need it , just do not remove this               #
//#                                                                                                             #
//#        Creator : Flash NSc (NScripters)                                                                     #
//#                                                                                                             #
//###############################################################################################################

//include library
	require_once "library/loader.php";

	
//account loader, needed to load facebook accounts and get game data
	$loader=new accountLoader();
	$loader
		->addAccount("account1","pass1")
		->addAccount("account2","pass2")
		//->addAccount("account3","pass3")
		//...

		->getAccountData(function($account){ global $loader;
			if($account->error!="0"){
				cantLogin($account->email);
			}else{
				//cout($account); <-- outputs accounts informations
				echo "Account: ".$account->email."<br>";


				//Usage 1 : (AMF Calls)
				AMF::service($account->amf[0],"SystemService.requireLogin",[$account->time, $account->hash_time, $account->fb_uid]);
				cout(AMF::response());

				AMF::service($account->amf[0],"SystemService.snsLogin",[$account->fb_uid, $account->platform, $account->swf_version, AMF::response()->result,
					client_library::getLoginHash(AMF::response()->result,AMF::response()->result.$account->fb_uid.$account->platform.$account->swf_version.$account->codec)
					, $account->fb_sig, $account->fb_at, $account->lang]);
				cout(AMF::response());

				//you can add more amf calls in here
				//...



				//Usage 2 : (Game load by loading ninja_saga.swf)
				//$loader::loadIframe($account);



				//Usage 3 : (Game load from their website (app.ninjasaga.com))
				//$loader::loadGame($account);
			}
		}
	);

?>

