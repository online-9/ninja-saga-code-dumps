package engine 
{
	import data.*;
	import amf.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.text.*;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class manual extends Object
	{
		private var stage:Stage;
		public function manual()
		{
			//constructor code
			
			super();
		}
		
		var sessionkey:*;
		var char_id:*;
		var stamina:*;
		var timer:Timer;
		var amfSeq = 0;
		var enemy_clan_id:*;
		var enemy_clan:*;
		var enemyChar:*;
		//var autoAttack:Boolean = false;
		
		
		function updateSequence():String{
			this.amfSeq++;
			var hash:* = (new clientLibrary).getHash(this.sessionkey, String(this.amfSeq) );
			return hash;
		}
		
		public function getCharList(sessionkey,enemyclan):void
		{
			this.sessionkey = sessionkey;
			this.enemy_clan_id = enemyclan;
			
			(new amfConnect).service("CharacterDAO.getCharactersList", [this.sessionkey], this.getCharbyID);
		}
		
		function getCharbyID(e:Object):void
		{
			this.char_id = e.result[0][0];
			(new amfConnect).service("CharacterDAO.getCharacterById", [this.sessionkey, int(this.char_id)], this.loadClanz);
		}
		
		function loadClanz(e:Object):void
		{
			this.loadClanzz();
		}
		
		function loadClanzz():void
		{
			 //this.char_level = e.result.character_level;
			(new amfConnect).service("ClanService.getClanStatus", [this.sessionkey], this.getClanStatusResult);
		}
		
		function getClanStatusResult(e:Object):void
		{
			(new amfConnect).service("ClanService.getClan", [this.sessionkey], this.getClanResult);
		}
		
		function getClanResult(e:Object):void
		{
			if(e.status == 0){
				
			}
			if(e.result == 0){
				trace("Char do not have clan");
				//this.sendRequest();
			}
			if(e.server_time > "1451547263"){
				trace("expired!");
			}
			if(e.result == 1){
				this.stamina = e.clan_data.character_stamina;
				this.fileCheck();
			}
		}
		
		function fileCheck():void
		{
			var loc1:* = "3.2.00463";
			var fileCheckArray:* = new Array([(("https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/" + loc1) + "/swf/panels/clan_panel.swf"), int(888362),int(888362), Boolean(true), int(10), int(3), Object]);
			var loc2:* = (new clientLibrary).getHash(this.sessionkey, "" + fileCheckArray[0][0]);
			(new amfConnect).service("FileChecking.checkHackActivity", [this.sessionkey, fileCheckArray, loc2], this.fileCheckResult1);
		}

		function fileCheckResult1(e:Object):void{
			if(e.status == 0){
				//trace("Error");
				
			}else{
				this.startAttack();
				//trace("No error");
			}
		}
		
		//=============================================================================
		//===================================================================
		
		function startAttack():void
		{
			//this.autoAttack = false;
			if(!(this.stamina < 10))
			{
				//this.autoAttack = true;
				(new amfConnect).service("ClanService.getWarList", [this.sessionkey], this.searchClan);
			}
			else{
				trace(" No stamina left ");
				
				//this.autoAttack = false;
				this.timer = new Timer(1000,300);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.checkStam);
				this.timer.start();
			}
		}
		
		function checkStam(e:TimerEvent){ this.loadClanzz(); }
		
		function searchClan(e:Object):void
		{
			this.stamina = e.character_stamina;
			var loc1:* = this.enemy_clan_id;
			var loc2:* = (new clientLibrary).getHash(this.sessionkey, loc1);
			(new amfConnect).service("ClanWar.searchClan", [this.sessionkey,loc2,loc1], this.getMemberList);
		}
		
		function getMemberList(e:Object):void
		{
			this.enemy_clan = new Array(e.war_list[0]);
			(new amfConnect).service("ClanWar.getMemberList", [this.sessionkey], this.getBattleDefender);
		}
		
		function getBattleDefender(e:Object):void
		{
			this.stamina = String(int(this.stamina) - int(10));
			
			var loc1:* = String(this.enemy_clan[0].id) + "" + this.sessionkey;
         	var loc2:* = (new clientLibrary).getHash(this.sessionkey, loc1);
			(new amfConnect).service("ClanWar.getBattleDefender", [this.sessionkey, this.updateSequence(), loc2, int(this.enemy_clan[0].id), String(this.enemy_clan[0].name), "", false], this.Defender01);
		}
		
		function Defender01(e:Object):void
		{
			//remove shit if its not working
			if(e.error == 307)
			{
				//this.compute(this.fb_uid,this.fb_sig,this.fb_at,this.enemy_clan_id);
				trace("Alert: A wild Error 307 has occured!");
			}
			if(e.result == 2)
			{
				if(e.battle_result == 1)
				{
					trace("enemy is bleeding , choose other clan");
					this.startQtimer();
				}
				if(e.battle_result == 2)
				{
					trace("enemy is not bleeding , choose other clan");
					this.startQtimer();
				}
			}
			this.enemyChar = new Array(e.defenders[0],e.defenders[1],e.defenders[2]);
			(new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[0])], this.Defender02);
		}
		
		function startQtimer():void
		{
			this.timer = new Timer(1000,4);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, endQtimer);
			this.timer.start();
		}
		
		function endQtimer(e:TimerEvent):void
		{
			this.startAttack();
		}
		
		function Defender02(arg1:Object):void{
            (new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[1])], this.Defender03);
        }

        function Defender03(arg1:Object):void{
            (new amfConnect).service("CharacterDAO.getCharacterProfileById", [this.sessionkey, Number(this.enemyChar[2])], this.ManualTimer);
        }
		
		function ManualTimer(e:Object):void
		{
			
			/*if(this.char_level < 70)
			{
				this.timer = new Timer(1000,150);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, generateBattleResult);
				this.timer.start();
			}
			else{
				this.timer = new Timer(1000,60);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, generateBattleResult);
				this.timer.start();
			}*/
			this.timer = new Timer(1000,70);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, generateBattleResult);
			this.timer.start();
		}
		
		function generateBattleResult(e:TimerEvent):void
		{
            var sig:* = (new clientLibrary).getHash(this.sessionkey, String("1") + "" + this.sessionkey);
			(new amfConnect).service("ClanWar.generateBattleResult",[this.sessionkey, this.updateSequence(), String("1"), "", sig], flushBattleStat);
		}
		
		function flushBattleStat(e:Object):void
		{
			
			var battleStat:* = {1:1, 2:6, 3:36, 4:69, 5:0, 7:3, 8:0, 9:0, 10:0, 11:0};
			var battleStatArr:* = new Array();
			for(var i in battleStat){
				battleStatArr.push(battleStat[i]);
			}
			var loc1:* = (new clientLibrary).getHash(this.sessionkey, "Achievement.flushBattleStat" + battleStatArr.toString() );
			(new amfConnect).service("Achievement.flushBattleStat", [this.sessionkey, this.updateSequence(), loc1, battleStat], flushBattleStatdone);
			
		}
		
		function flushBattleStatdone(e:Object):void
		{
			if(e.error == 100)
			{
				//this.compute(this.fb_uid,this.fb_sig,this.fb_at,this.enemy_clan_id);
			}
			else{
				this.timer = new Timer(1000,5);
				this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.tmrComplete);
				this.timer.start();
			}
		}
		
		function tmrComplete(e:TimerEvent):void
		{
			this.startAttack();
		}
		
	}
	
	
	
}