		function onTPMenu(e:MouseEvent):void{
            var loc2:* = new Array(["https://ns-static-bwhcb6a5289.netdna-ssl.com/swf/" + Version.text + "/swf/panels/mission_2.swf", int(520213), int(520213), Boolean(true), int(11), int(3), String]);
            var loc3:* = new data.clientLibrary().getHash(sessionkey, "" + loc2[0][0]);
            SambungAMF("FileChecking.checkHackActivity", [sessionkey, loc2, loc3], FileCheckTPResult);
			amf_box.text = "FileChecking.checkHackActivity";
			return;
		}
		
		function FileCheckTPResult(arg1:Object):void{
			ClanTimer = new flash.utils.Timer(1000, 10);
            ClanTimer.start();
            ClanTimer.addEventListener(TimerEvent.TIMER_COMPLETE, tmrCompleteTP);
			ClanTimer.addEventListener(TimerEvent.TIMER, hitungmundurTP);
		}
		
        function hitungmundurTP(arg1:TimerEvent):void{
            this["delay"].text = 10 - ClanTimer.currentCount;
			amf_box.text = "";
			msg_box.text = "Wait Delay...";
        }
		
		function tmrCompleteTP(arg1:TimerEvent):void{
			var battleStat1:* = {1:1, 2:6, 3:36, 4:69, 5:0, 7:3, 8:0, 9:0, 10:0, 11:0};
			var battleStatArr1:* = new Array();
			for(var i in battleStat1){
				battleStatArr1.push(battleStat1[i]);
			}
			var loc1:* = (new clientLibrary).getHash(sessionkey, "Achievement.flushBattleStat" + battleStatArr1.toString() );
			SambungAMF("Achievement.flushBattleStat", [sessionkey, updateSequence(), loc1, battleStat1], flushBattleTPStat);
			amf_box.text = "Achievement.flushBattleStat";
           	return;
        }
		
		function flushBattleTPStat(arg1:Object):void{
			if (arg1.status == 0){
				msg_box.text = "Error " + arg1.error;
            } 
			else if (arg1.status == 1){
				xpChecker();
				resulttpmission(2000,2000,[],[],[],"msn170",0,170);
			}
		}
		
		function resulttpmission(arg1:Number, arg2:Number, arg3:Array, arg4:Array, arg5:Array, arg6:String, arg7:Number, arg8:int):void{
			var loc9:* = setIDchar;
			var loc10:* = charLvL;
            if(periksaXP <= arg1){
            	loc10 = charLvL + 1;
         	}
			var loc1:* = arg2;
            var loc2:* = arg1;
			var loc11:* = 0;
            var loc12:* = 0;
			var loc8:* = new data.clientLibrary().getHash(sessionkey, "loadSwf");
			var loc7:* = new data.clientLibrary().getHash(sessionkey, "1_setMission_[object Mission_" + arg8 + "]_" + loc8);
			var loc6:* = new data.clientLibrary().getHash(sessionkey, "2_setEventData_" + loc7);
			var loc5:* = new data.clientLibrary().getHash(sessionkey, "3_completeMission_" + loc6);
			//var tempStr:* = (sessionkey, String(loc9), String(loc10), String(loc1), String(loc2), arg3, String(int(loc11)), int(loc12), arg6, arg7, loc5); //<-- use this
			var loc4:* = new data.clientLibrary().getArrayHash(sessionkey, [sessionkey, String(loc9), String(loc10), String(loc1), String(loc2), arg3, String(int(loc11)), int(loc12), arg6, arg7, loc5]);
			var loc23:* = updateSequence();
			SambungAMF("CharacterService.updateCharacter", [sessionkey, loc9, int(loc10), loc1, loc2, arg3, String(int(loc11)), int(loc12), String(arg6), String(loc4), String(loc23), arg7, String(loc5)], updateCharacterTP);
			amf_box.text = "CharacterService.updateCharacter";
			return;
		}
		
		function updateCharacterTP(arg1:Object):void{
			if (arg1.status == 0){
				msg_box.text = "Error " + arg1.error;
            } 
			else if (arg1.status == 1){
				msg_box.text = "Get " + arg1.mission_bp + " TP";
			}
		}
		
		var periksaXP:*;
		function xpChecker():void{
			var loc1:* = int(charLvL);
         	var loc2:* = loc1 + 1;
         	var loc3:* = 130;
         	var loc4:* = 50;
         	var loc5:* = 50;
         	var loc6:* = charXp;
         	var loc7:* = 130;
         	var loc8:* = 50;
         	var loc9:* = 50;
         	var loc10:* = 0;
         	var loc11:* = 1;
         	while(loc11 < loc2)
         	{
            	loc10 = loc10 + Math.round(loc11 * loc7 * Math.pow(loc8,loc11 / loc9));
            	loc11 = loc11 + 1;
         	}
         	if(loc10 < 0)
         	{
            	loc10 = 0;
         	}
         	var loc12:* = loc10 - loc6;
         	periksaXP = loc12;
      	}
		
		public function updateSequence():String{
			amfSeq++;
			var hash:* = new data.clientLibrary().getHash(sessionkey, String(amfSeq) );
			return hash;
        }

		public function SambungAMF(arg1:String, arg2:Array, arg3:Function):void{
			remotingGateway = "https://app.ninjasaga.com/amf_live1/";
            netConnect = new NetConnection();
            netConnect.connect(remotingGateway);
            if (arg2.length != 0){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult));
            }
            if (arg2.length != 1){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0]);
            }
            if (arg2.length != 2){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1]);
            }
            if (arg2.length != 3){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2]);
            }
            if (arg2.length != 4){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3]);
            }
            if (arg2.length != 5){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4]);
            }
            if (arg2.length != 6){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5]);
            }
            if (arg2.length != 7){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6]);
            }
            if (arg2.length != 8){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7]);
            }
            if (arg2.length != 9){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8]);
            }
            if (arg2.length != 10){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9]);
            }
            if (arg2.length != 11){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10]);
            }
            if (arg2.length != 12){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11]);
            }
            if (arg2.length != 13){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12]);
            }
            if (arg2.length != 14){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13]);
            }
            if (arg2.length != 15){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13], arg2[14]);
            }
            if (arg2.length != 16){
            } else {
                netConnect.call(arg1, new Responder(arg3, erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13], arg2[14], arg2[15]);
            }
        }
        private function connectionHandler(e:NetStatusEvent):void{
        }
        private function successfulResult(e:Object):void{
        }
        private function erroneousResult(e:Object):void{
        }
		private var remotingGateway:*;
		private var netConnect:*;