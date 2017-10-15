//--------------
//	To to list
//--------------
//	+ static variables to keep game link in string
//	+to keep panel size (clan panel total byte size)
//	Fix the load char error by putting a maximum of 5 tries(refer desktop cp script)


package  {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.*;
	import data.*;
	import amf.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class cp extends Object{
		
		//-----------
		//	Restore
		//-----------
		public function restore(mc:MovieClip, rank:*):* {
			this.mc = mc;
			this.rank = rank;
			mc["m_"+String(rank)]["temp"].text = mc["m_"+String(rank)]["char_status"].text;
			mc["m_"+String(rank)]["char_status"].text = "Restore";
		}
		
		function charRestore():void {
			(new amfConnect).service("ClanService.buyStamina", [this.sessionkey], this.RestoreStaminaResponse);
		}
		function RestoreStaminaResponse(e:Object):void {
			if (e.status == 1) {
				if (int(mc["m_"+String(this.rank)]["char_stamina_rolls"].text) > 0) {
					//	use onigiri
					mc["m_"+String(this.rank)]["char_stamina_rolls"].text = int(mc["m_"+String(this.rank)]["char_stamina_rolls"].text) - int(1);
					mc["m_"+String(this.rank)]["char_msg"].text = "You used stamina rolls!";
				}
				else {
					//	use token
					mc["m_"+String(this.rank)]["char_msg"].text = "You used token to restore!";
				}
				mc["m_"+String(this.rank)]["char_status"].text = "Attacking";
				this.startAttack();
			}
			else {
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
				mc["m_"+String(this.rank)]["char_msg"].text = "Error "+e.error;
			}
		}
		//--------------
		//	Stopping cp
		//--------------
		public function stopcp(mc:MovieClip, rank:*):* {
			this.mc = mc;
			this.rank = rank;
			mc["m_"+String(rank)]["char_status"].text = "Idle";
		}
		
		//--------------
		//	Starting cp
		//--------------
		public function startcp(mc:MovieClip, rank:*, enemyclan:*):* {
			this.enemy_clan_id = enemyclan;
			this.mc = mc;
			this.rank = rank;
			this.sessionkey = mc["m_"+String(rank)]["sessionkey"].text;
			mc["m_"+String(rank)]["char_rep"].text = "0";
			mc["m_"+String(rank)]["char_status"].text = "Attacking";
			this.amfSeq = mc["m_"+String(rank)]["amf"].text;
			if ( mc["m_"+String(rank)]["char_stamina"].text == String("0/100") ){
				this.waitStamina();
			}
			else {
				this.startAttack();
			}
			
		}
		//-----------------
		//	Get panel size
		//-----------------
		private var PanelSize:int=907672;
		/*private var loaders:Loader;
		
		function getPanelSize():void{
			this.loaders = new Loader();
			this.loaders.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress); 
			this.loaders.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompletePanelSize);
			this.loaders.load(new URLRequest(String("https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/"+String(this.mc["m_"+String(this.rank)]["version"].text)+"/swf/panels/clan_panel.swf")));
		}
		function onProgress(e:ProgressEvent):void{
			PanelSize=e.bytesTotal; 
			//e.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loaders.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
		}
		function onCompletePanelSize(e:Event):void {
			trace(PanelSize);
			this.loaders.contentLoaderInfo.removeEventListener(Event.COMPLETE, onProgress);
		}*/
		
		//---------------------
		//	Loading characters
		//---------------------
		public function loadchar(mc:MovieClip, sessionkey:*, rank:*, status:*, ns_ver:*, amf:*):* {
			this.amfSeq = amf;
			this.rank = rank;
			this.mc = mc;
			this.status = status;
			this.sessionkey = sessionkey;
			mc["m_"+String(rank)]["sessionkey"].text = sessionkey;
			//mc["m_"+String(rank)]["sessionkey"].visible = false;
			mc["m_"+String(rank)]["version"].text = ns_ver;
			mc["m_"+String(rank)]["rank"].text = rank;
			//this.getPanelSize();
			this.loadcharInfo();
		}
		
		private function loadcharInfo():void {
			
			(new amfConnect).service("CharacterDAO.getCharactersList", [this.sessionkey], this.getCharbyID);
		}
		
		private function getCharbyID(e:Object):void
		{
			if(e.status == 0)
			{
				//this.messageProc("Error has occured!");
				mc["m_"+String(this.rank)]["char_msg"].text = "Error has occured!";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			else{
				this.char_id = e.result[0][0];
				(new amfConnect).service("CharacterDAO.getCharacterById", [this.sessionkey, int(this.char_id)], this.loadClanz);
			}
		}
		
		function loadClanz(e:Object):void
		{
			mc["m_"+String(this.rank)]["char_name"].text = e.result.character_name;
			mc["m_"+String(this.rank)]["char_level"].text = e.result.character_level;
			//this.messageProc("Loaded");
			mc["m_"+String(this.rank)]["char_msg"].text = "Loaded";
			this.loadClanzz();
		}
		
		function loadClanzz():void
		{
			 mc["m_"+String(this.rank)]["char_msg"].text = "ClanService.getClanStatus";
			(new amfConnect).service("ClanService.getClanStatus", [this.sessionkey], this.getClanStatusResult);
		}
		
		function getClanStatusResult(e:Object):void
		{
			if( e.status != 1) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error " + String(e.error);
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else {
				//this.messageProc("ClanService.getClan");
				mc["m_"+String(this.rank)]["char_msg"].text = "ClanService.getClan";
				(new amfConnect).service("ClanService.getClan", [this.sessionkey], this.getClanResult);
			}
		}
		
		function getClanResult(e:Object):void
		{
			if(e.status == 0){
				//this.messageProc("Error 100");
				mc["m_"+String(this.rank)]["char_msg"].text = "Error 100";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.result == 0){
				mc["m_"+String(this.rank)]["char_msg"].text = "Character do not have clan";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.server_time > "1483142400"){
				mc["m_"+String(this.rank)]["char_msg"].text = "Expired";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.result == 1){
				if(e.clan_data.id == "84563" || e.clan_data.id == "100196"){
					this.stamina = e.clan_data.character_stamina;
					this.max_stamina = e.clan_data.character_max_stamina;
					mc["m_"+String(this.rank)]["char_stamina"].text = String(this.stamina) + "/" + String(this.max_stamina);
					mc["m_"+String(this.rank)]["char_clan_name"].text = e.clan_data.name;
					mc["m_"+String(this.rank)]["char_stamina_rolls"].text = e.stamina_item;
					this.fileCheck();
				}else{
					mc["m_"+String(this.rank)]["char_msg"].text = "Error";
					mc["m_"+String(this.rank)]["char_status"].text = "Error";
				}
			}
		}
		
		function fileCheck():void
		{
			var loc1:* = mc["m_"+String(rank)]["version"].text;
			var fileCheckArray:* = new Array([(("https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/" + loc1) + "/swf/panels/clan_panel.swf"), int(PanelSize),int(PanelSize), Boolean(true), int(10), int(3), Object]);
			var loc2:* = (new clientLibrary).getHash(this.sessionkey, "" + fileCheckArray[0][0]);
			(new amfConnect).service("FileChecking.checkHackActivity", [this.sessionkey, fileCheckArray, loc2], this.fileCheckResult1);
		}
		
		function fileCheckResult1(e:Object):void{
			if(e.status == 0){
				mc["m_"+String(this.rank)]["char_msg"].text = "Error occured..";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else{
				mc["m_"+String(this.rank)]["char_msg"].text = "Initialize complete";
				mc["m_"+String(this.rank)]["char_status"].text = "Idle";
			}
		}

		
		private var mc:*; // char_holder mc
		private var rank:*; // 0,1,2,3,4,5,6,7,8,9
		private var status:*; // Idle or Attacking or Error
		var char_id:*;
		var sessionkey:*;
		
		//-----------------------------------------------------
		var stamina:*;
		var max_stamina:*;
		//var character_name:*;
		var reputation_gain:*;
		var timer:Timer;
		var amfSeq = 0;
		var enemy_clan_id:*;
		var enemy_clan:*;
		var enemyChar:*
		
		function updateSequence():String{
			this.amfSeq++;
			var hash:* = (new clientLibrary).getHash(this.sessionkey, String(this.amfSeq) );
			return hash;
		}
		
		function startAttack():void{
			if ( mc["m_"+String(this.rank)]["char_status"].text == "Idle" ) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Stopped..";
				mc["m_"+String(rank)]["amf"].text = this.amfSeq;
				this.timer.stop();
				this.timer = null;
			}
			else if ( mc["m_"+String(this.rank)]["char_status"].text == "Restore") {
				//	go to restore script
				this.charRestore();
			}
			else if (mc["m_"+String(this.rank)]["char_status"].text == "Attacking")  {
				if (!(this.stamina < 10)) {
					(new amfConnect).service("ClanService.getWarList", [this.sessionkey], this.searchClan);
				}
			}
			else{
				this.waitStamina();
			}
		}
		
		
		function waitStamina():void {
			mc["m_"+String(this.rank)]["char_msg"].text = "No stamina left..Waiting for next restore..";
			mc["m_"+String(this.rank)]["char_status"].text = "Attacking";
			this.timer = new Timer(1000,300);
			this.timer.addEventListener(TimerEvent.TIMER, this.timerRun);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.checkStam);
			this.timer.start();
			mc["m_"+String(this.rank)]["char_msg"].text = int("300");
		}
		
		function timerRun(e:TimerEvent):void {
			var sec:* = mc["m_"+String(this.rank)]["char_msg"].text;
			var left:*=sec-1;
			mc["m_"+String(this.rank)]["char_msg"].text = String(left);
		}
		
		function checkStam(e:TimerEvent){ this.loadClanzz1(); }
		
		function loadClanzz1():void
		{
			 mc["m_"+String(this.rank)]["char_msg"].text = "ClanService.getClanStatus";
			(new amfConnect).service("ClanService.getClanStatus", [this.sessionkey], this.getClanStatusResult1);
		}
		
		function getClanStatusResult1(e:Object):void
		{
			mc["m_"+String(this.rank)]["char_msg"].text = "ClanService.getClan";
			(new amfConnect).service("ClanService.getClan", [this.sessionkey], this.getClanResult1);
		}
		
		function getClanResult1(e:Object):void
		{
			if(e.status == 0){
				//this.messageProc("Error 100");
				mc["m_"+String(this.rank)]["char_msg"].text = "Error 100";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.result == 0){
				mc["m_"+String(this.rank)]["char_msg"].text = "Character do not have clan";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.server_time > "1483142400"){
				mc["m_"+String(this.rank)]["char_msg"].text = "Expired";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.result == 1){
				if(e.clan_data.id == "84563"|| e.clan_data.id == "100196"){
					this.stamina = e.clan_data.character_stamina;
					this.max_stamina = e.clan_data.character_max_stamina;
					mc["m_"+String(this.rank)]["char_stamina"].text = String(this.stamina) + "/" + String(this.max_stamina);
					mc["m_"+String(this.rank)]["char_clan_name"].text = e.clan_data.name;
					mc["m_"+String(this.rank)]["char_stamina_rolls"].text = e.stamina_item;
					this.fileCheck1();
				}
				else{
					mc["m_"+String(this.rank)]["char_msg"].text = "Error";
					mc["m_"+String(this.rank)]["char_status"].text = "Error";
				}
			}
		}
		
		function fileCheck1():void
		{
			var loc1:* = mc["m_"+String(rank)]["version"].text;
			var fileCheckArray:* = new Array([(("https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/" + loc1) + "/swf/panels/clan_panel.swf"), int(PanelSize),int(PanelSize), Boolean(true), int(10), int(3), Object]);
			var loc2:* = (new clientLibrary).getHash(this.sessionkey, "" + fileCheckArray[0][0]);
			(new amfConnect).service("FileChecking.checkHackActivity", [this.sessionkey, fileCheckArray, loc2], this.fileCheckResult11);
		}
		
		function fileCheckResult11(e:Object):void{
			if(e.status == 0){
				mc["m_"+String(this.rank)]["char_msg"].text = "Error occured..";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else{
				mc["m_"+String(this.rank)]["char_msg"].text = "Waiting for next restore";
				mc["m_"+String(this.rank)]["char_status"].text = "Attacking";
				this.startAttack();
			}
		}
		
		function searchClan(e:Object):void{
			this.stamina = e.character_stamina;
			mc["m_"+String(this.rank)]["char_stamina"].text = String(this.stamina);
			var loc1:* = this.enemy_clan_id;
			var loc2:* = (new clientLibrary).getHash(this.sessionkey, loc1);
			mc["m_"+String(this.rank)]["char_msg"].text = "ClanWar.searchClan";
			(new amfConnect).service("ClanWar.searchClan", [this.sessionkey,loc2,loc1], this.getMemberList);
		}
		
		function getMemberList(e:Object):void{
			if (e.status != 1) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error " + String(e.error);
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else{
				this.enemy_clan = new Array(e.war_list[0]);
				mc["m_"+String(this.rank)]["char_msg"].text = "ClanWar.getMemberList";
				(new amfConnect).service("ClanWar.getMemberList", [this.sessionkey], this.getBattleDefender);
			}
		}
		
		function getBattleDefender(e:Object):void{
			if (e.status != 1) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error " + String(e.error);
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else{
				this.stamina = String(int(this.stamina) - int(10));
				mc["m_"+String(this.rank)]["char_stamina"].text = String(this.stamina);
				var loc1:* = String(this.enemy_clan[0].id) + "" + this.sessionkey;
         		var loc2:* = (new clientLibrary).getHash(this.sessionkey, loc1+String(PanelSize)); //loc1+swfsize
				mc["m_"+String(this.rank)]["char_msg"].text = "ClanWar.getBattleDefender";
				(new amfConnect).service("ClanWar.getBattleDefender", [this.sessionkey, this.updateSequence(), loc2, int(this.enemy_clan[0].id), String(this.enemy_clan[0].name), "", false], this.Defender01);
			}
		}
		
		function Defender01(e:Object):void{
			//remove shit if its not working
			if ( e.error == 292 ) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error 292";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.error == 307){
				mc["m_"+String(this.rank)]["char_msg"].text = "Error 307";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.error == 100){
				mc["m_"+String(this.rank)]["char_msg"].text = "Error 100";
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			if(e.result == 2){
				mc["total_rep"].text = String(int(mc["total_rep"].text) + int(e.rep_gain));
				if(e.battle_result == 1){
					mc["m_"+String(this.rank)]["char_msg"].text = "Enemy is bleeding";
					mc["m_"+String(this.rank)]["char_rep"].text = String(int (e.rep_gain) + int (mc["m_"+String(this.rank)]["char_rep"].text));
					this.startQtimer();
				}
				if(e.battle_result == 2){
					mc["m_"+String(this.rank)]["char_msg"].text = "Enemy is not bleeding";
					mc["m_"+String(this.rank)]["char_rep"].text = String(int (e.rep_gain) + int (mc["m_"+String(this.rank)]["char_rep"].text));
					this.startQtimer();
				}
			}
			this.enemyChar = new Array(e.defenders[0],e.defenders[1],e.defenders[2]);
			(new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[0])], this.Defender02);
		}
		
		function startQtimer():void{
			this.timer = new Timer(1000,4);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, endQtimer);
			this.timer.start();
		}
		
		function endQtimer(e:TimerEvent):void{
			this.startAttack();
		}
		
		function Defender02(arg1:Object):void{
            (new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[1])], this.Defender03);
        }

        function Defender03(arg1:Object):void{
            (new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[2])], this.ManualTimer);
        }
		
		function ManualTimer(e:Object):void{
			mc["m_"+String(this.rank)]["char_msg"].text = "Waiting for delay..";
			this.timer = new Timer(1000,70);
			this.timer.addEventListener(TimerEvent.TIMER, this.timerRun);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, generateBattleResult);
			this.timer.start();
			mc["m_"+String(this.rank)]["char_msg"].text = int("70");
		}
		
		function generateBattleResult(e:TimerEvent):void{
            var sig:* = (new clientLibrary).getHash(this.sessionkey, String("1") + "" + this.sessionkey);
			(new amfConnect).service("ClanWar.generateBattleResult",[this.sessionkey, this.updateSequence(), String("1"), "", sig], flushBattleStat);
		}
		
		function flushBattleStat(e:Object):void{
			if (e.status != 1) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error " + String(e.error);
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}else{
				mc["m_"+String(this.rank)]["char_msg"].text = String("You got ") + String(e.rep_gain) + String(" rep");
				mc["total_rep"].text = String(int(mc["total_rep"].text) + int(e.rep_gain));
				mc["m_"+String(this.rank)]["char_rep"].text = String(int (e.rep_gain) + int (mc["m_"+String(this.rank)]["char_rep"].text));
				var battleStat:* = {1:1, 2:6, 3:36, 4:69, 5:0, 7:3, 8:0, 9:0, 10:0, 11:0};
				var battleStatArr:* = new Array();
				for(var i in battleStat){
					battleStatArr.push(battleStat[i]);
				}
				var loc1:* = (new clientLibrary).getHash(this.sessionkey, "Achievement.flushBattleStat" + battleStatArr.toString() );
				(new amfConnect).service("Achievement.flushBattleStat", [this.sessionkey, this.updateSequence(), loc1, battleStat], flushBattleStatdone);
				mc["m_"+String(this.rank)]["amf"].text = int(this.amfSeq);
			}
		}
		
		function flushBattleStatdone(e:Object):void{
			if (e.status != 1) {
				mc["m_"+String(this.rank)]["char_msg"].text = "Error " + String(e.error);
				mc["m_"+String(this.rank)]["char_status"].text = "Error";
			}
			else{
				this.timer = new Timer(1000,5);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.tmrComplete);
				this.timer.start();
			}
		}
		
		function tmrComplete(e:TimerEvent):void{this.startAttack();}

	}
	
}
