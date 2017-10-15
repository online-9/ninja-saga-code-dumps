//--------------
//	To to list
//--------------
//	+function to check if char is error
//	loop a function to check if char message stopped
//	+function to check how many char is loaded
//	+force reload character
package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import data.*;
	import amf.*;
	
	
	public class main extends MovieClip {
		
		public var AMF:*;
		public function main() {
			addFrameScript(4, this.frame5);
			AMF = new amfConnect();
		}
		
		function amf(s:String,d:Array,f:Function):void{
			AMF.service(s,d,f);
		}
		
		function frame5():* {
			this.stop();
			this["load_char_btn"].addEventListener(MouseEvent.CLICK, loadChar);
			this["load_char_btn"].visible = false;
			
			this["single_stop_btn"].addEventListener(MouseEvent.CLICK, single_stop);
			this["single_attack_btn"].addEventListener(MouseEvent.CLICK, single_attack);
			this["single_char_select"].text = "";
			
			this["multi_stop_btn"].addEventListener(MouseEvent.CLICK, multi_stop);
			this["multi_attack_btn"].addEventListener(MouseEvent.CLICK, multi_attack);
			this["multi_min_char"].text = "";
			this["multi_max_char"].text = "";
			
			this["manual_load_nr"].text = "0";
			this["manual_load_fbat"].text = "";
			//this["manual_load_fbuid"].text = "";
			this["manual_load_fbsig"].text = "";
			this["manual_load_btn"].addEventListener(MouseEvent.CLICK, manual_load);
			
			this["single_restore_btn"].addEventListener(MouseEvent.CLICK, this.single_restore);
			this["multi_restore_btn"].addEventListener(MouseEvent.CLICK, this.multi_restore);
			
			
			//this["target_clan_id"].text = "";
			this["ns_version"].text = "3.3.00205";
			this["dev_msg"].text = "";
		}
		
		
		
		function loadChar(e:MouseEvent=null):void {
			//(new cp).loadchar(char_holder,0);
			
		}
		
		// For now just use full fb_sig
		// in the future scripts, fb_sig remains the same, and only hash_time changes ( fb_sig + hash_time)
		
		// Login to char and send sessionkey to cp
		
		function manual_load(e:MouseEvent=null):void {
			this.manual_load2();
		}
		function manual_load2():void {
			var ns_ver:* = this["ns_version"].text;
			var nr:* = this["manual_load_nr"].text;
			var fb_at:* = this["manual_load_fbat"].text;
			var fb_uid:* = this["manual_load_fbuid"].text;
			var fb_sig:* = this["manual_load_fbsig"].text;
			
			if ( nr == "" || fb_at == ""|| fb_uid == "" || fb_sig == "" || ns_ver == "") {
				this["dev_msg"].text = "Empty fields";
			}
			else if ( nr > 25 ) {
				this["dev_msg"].text = "NR cannot be more than 25";
			}
			else {
				if ( this["char_holder"]["m_"+String(nr)]["char_status"].text == "Attacking" || 
					this["char_holder"]["m_"+String(nr)]["char_status"].text == "Idle") {
					this["dev_msg"].text = "NR " + nr + " is already occupied";
				}
				else {
					//login script to char and send sessionkey to cp get ready to attack
					var codec:* = "85224034668";
					var req:* = "1304047085571a381c6ddad5.30414228";
					var loc1:* = req+String(fb_uid)+"facebook"+String(ns_ver)+codec;
					var loc2:* = (new clientLibrary).getLoginHash(req,loc1);
					amf("SystemService.snsLogin",[fb_uid,"facebook",ns_ver,req,loc2,fb_sig,fb_at,"en"], this.snsLoginResult);
					this["char_holder"]["m_"+String(nr)]["sessionkey"].visible = false;
					this["char_holder"]["m_"+String(nr)]["amf"].visible = false;
					this["char_holder"]["m_"+String(nr)]["version"].visible = false;
					this["char_holder"]["m_"+String(nr)]["temp"].visible = false;
				}
			}
		}
		
		function snsLoginResult(e:Object):void {
			if(e.error == 102) {
				AMF.setServer("https://app.ninjasaga.com/amf_live2/");
				this.manual_load2();
			}
			if ( e.error == 308) {
				this["dev_msg"].text ="Get new data for nr " + String(this["manual_load_nr"].text);
			}
			else {
				(new cp).loadchar(char_holder,e.result[3],this["manual_load_nr"].text,"Idle",this["ns_version"].text,0);
				this["manual_load_nr"].text = int (this["manual_load_nr"].text) + int("1") ;
				this["manual_load_fbat"].text = "";
				this["manual_load_fbuid"].text = "";
				this["manual_load_fbsig"].text = "";
			}
		}
		
		// single char functions
		function single_stop(e:MouseEvent=null):void {
			if ( this["single_char_select"].text == "") {
				this["dev_msg"].text = "Empty fields";
			}
			else {
				if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["sessionkey"].text == ""){
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " is empty";
				}
				else {
					(new cp).stopcp(char_holder,this["single_char_select"].text);
				}
			}
		}
		function single_attack(e:MouseEvent=null):void {
			if ( this["single_char_select"].text == "" || this["target_clan_id"].text == "") {
				this["dev_msg"].text = "Empty fields / No enemy clan ID";
			}
			else {
				if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["sessionkey"].text == ""){
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " is empty";
				}
				else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_status"].text == "Error") {
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " Error";
				}
				else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_status"].text == "Attacking") {
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " Attacking";
				}
				//else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_stamina"].text == "0"){
				//	this["dev_msg"].text = "Character has no stamina";
				//}
				else {
					(new cp).startcp(char_holder,this["single_char_select"].text, this["target_clan_id"].text);
				}
			}
		}
		
		function single_restore(e:MouseEvent=null):void {
			if ( this["single_char_select"].text == "") {
				this["dev_msg"].text = "Empty fields";
			}
			else {
				if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["sessionkey"].text == ""){
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " is empty";
				}
				else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_status"].text == "Error") {
					this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " Error";
				}
				//else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_status"].text == "Attacking") {
					//this["dev_msg"].text = "NR " + String(this["single_char_select"].text) + " Attacking";
				//}
				//else if (this["char_holder"]["m_"+String(this["single_char_select"].text)]["char_stamina"].text == "0"){
				//	this["dev_msg"].text = "Character has no stamina";
				//}
				else {
					(new cp).restore(char_holder,this["single_char_select"].text);
				}
			}
		}
		
		// multi char functions
		function multi_stop(e:MouseEvent=null):void {
			var x:* = this["multi_min_char"].text;
			var y:* = this["multi_max_char"].text;
			if (x == "" || y == 0 ){
				this["dev_msg"].text = "Empty fields";
			}
			else {
				//for ( var i=x; x<=y ; i++) {
				for ( x; x<=y ; x++) {
					// send the idle signal to cp to stop attacking
					if (this["char_holder"]["m_"+String(x)]["sessionkey"].text == ""){
						this["dev_msg"].text = "NR " + String(x) + " is empty";
						continue;
					}
					else {
						(new cp).stopcp(char_holder,x);
					}
				}
			}
		}
		function multi_attack(e:MouseEvent=null):void {
			var x:* = this["multi_min_char"].text;
			var y:* = this["multi_max_char"].text;
			if (x == "" || y == "" || this["target_clan_id"].text == ""){
				this["dev_msg"].text = "Empty fields / No enemy clan ID";
			}
			else if ( x > 25 || y > 25 ) {
				this["dev_msg"].text = "NR cannot be more than 25";
			}
			else {
				for (x ; x<=y; x++) {
					if (this["char_holder"]["m_"+String(x)]["sessionkey"].text == ""){
						this["dev_msg"].text = "NR " + String(x) + " is empty";
						continue;
					}
					else if (this["char_holder"]["m_"+String(x)]["char_status"].text == "Error") {
						this["dev_msg"].text = "NR " + String(x) + " Error";
					}
					else if (this["char_holder"]["m_"+String(x)]["char_status"].text == "Attacking") {
						this["dev_msg"].text = "NR " + String(x) + " Attacking";
					}
					//else if (this["char_holder"]["m_"+String(x)]["char_stamina"].text == "0") {
						//this["dev_msg"].text = "Character has no stamina";
					//}
					else { 
						(new cp).startcp(char_holder, x, this["target_clan_id"].text);
					}
				}
			}
		}
		
		function multi_restore(e:MouseEvent=null):void {
			var x:* = this["multi_min_char"].text;
			var y:* = this["multi_max_char"].text;
			if (x == "" || y == "" ){
				this["dev_msg"].text = "Empty fields";
			}
			else if ( x > 25 || y > 25 ) {
				this["dev_msg"].text = "NR cannot be more than 25";
			}
			else {
				for (x ; x<=y; x++) {
					if (this["char_holder"]["m_"+String(x)]["sessionkey"].text == ""){
						this["dev_msg"].text = "NR " + String(x) + " is empty";
						continue;
					}
					else if (this["char_holder"]["m_"+String(x)]["char_status"].text == "Error") {
						this["dev_msg"].text = "NR " + String(x) + " Error";
					}
					//else if (this["char_holder"]["m_"+String(x)]["char_status"].text == "Attacking") {
						//this["dev_msg"].text = "NR " + String(x) + " Attacking";
					//}
					//else if (this["char_holder"]["m_"+String(x)]["char_stamina"].text == "0") {
						//this["dev_msg"].text = "Character has no stamina";
					//}
					else { 
						(new cp).restore(char_holder, x);
					}
				}
			}
		}
		
		public var char_holder:MovieClip;
		
		
	}
	
}
