package stuff  {
	
	//	External
	import amf.*;
	import data.*;
	import stuff.*;
	
	public class char extends main{

		//	Login
		private var fb_at:*;
		private var fb_sig:*;
		private var fb_uid:*;
		private var ns_ver:*;
		private var clan_code:*;
		private var sessionkey:*;
		
		//	Character 
		private var char_name:*;
		private var char_token:*;
		
		//	Clan
		private var clan_name:*;
		private var clan_id:*;
		private var stamina:*;
		private var max_stamina:*;
		private var stamina_rolls:*;
		private var rep_gain:*;
		private var enemy_clan_id:*;
		private var enemy_clan_arr:*;
		private var enemyChar:*;
		private var autoAttack:Boolean=false;
		
		//	Crew
		
		//	Misc
		private var isError:Boolean=false;
		private var errorNum:int = 2000;
		private var messages:String="Hello world!";
		
		//	Getter
		public function getIsError():Boolean {
			return isError;
		}
		public function getErrorNum():int{
			return errorNum;
		}
		public function getMessages():String {
			return messages;
		}
		
		//	Constructor
		public function char(fb_at:*, fb_sig:*, fb_uid:*, amf:*, clan_code:*, ns_ver:*) {
			this.fb_at = fb_at;
			this.fb_sig = fb_sig;
			this.fb_uid = fb_uid;
			this.clan_code = clan_code;
			this.ns_ver = ns_ver;
			AMF = new amfConnect();
			if ( amf == 2 ) {
				AMF.setServer("https://app.ninjasaga.com/amf_live2/");
			}
		}
		function amf(s:String,d:Array,f:Function):void{
			AMF.service(s,d,f);
		}
		public function loginChar():void {
			var codec:* = "85224034668";
			var req:* = "1304047085571a381c6ddad5.30414228";
			var loc1:* = req+String(this.fb_uid)+"facebook"+String(this.ns_ver)+codec;
			var loc2:* = (new clientLibrary).getLoginHash(req,loc1);
			amf("SystemService.snsLogin",[this.fb_uid,"facebook",this.ns_ver,req,loc2,this.fb_sig,this.fb_at,"en"], this.snsLoginResult);
		}
		function snsLoginResult(e:Object):void {
			if(e.error == 102) {
				AMF.setServer("https://app.ninjasaga.com/amf_live2/");
				//this.manual_load2();
			}
			if ( e.error == 308) {
				//this["dev_msg"].text ="Get new data for nr " + String(this["manual_load_nr"].text);
			}
			else {
				this.sessionkey = e.result[3];
			}
		}
	}
}
