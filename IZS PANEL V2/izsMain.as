package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import data.*;
	import amf.*;
	import engine.manual;
	
	
	public class izsMain extends MovieClip {
		
		
		public function izsMain() {
			// constructor code
			addFrameScript(4, this.loginFB);
			
		}
		
		function loginFB():*
		{
			this.stop();
			this["load_btn"].addEventListener(MouseEvent.CLICK, this.load_NS_data);
			this["attack_btn"].addEventListener(MouseEvent.CLICK, this.attack);
			this["clan_id"].text = "";
			this["msg_box"].text = "";
		}
		
		function load_NS_data(e:MouseEvent=null):void
		{
			
			var variables:URLVariables = new URLVariables();
			var varSend:URLRequest = new URLRequest("http://localhost/izs1/");
			
			varSend.method = URLRequestMethod.POST;
			varSend.data = variables;
			
			var varLoader:URLLoader = new URLLoader();
			varLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			varLoader.addEventListener(Event.COMPLETE, this.completeHandle);
			variables.myrequest = "requestInfo";
			varLoader.load(varSend);
		}
		
		function completeHandle(e:Event):void
		{
			if(e.target.data.result == "" ){
				this["msg_box"].text = "Error retrieving data from server";
			}else{
				this.character_inf = e.target.data.result.split("@lau@");
				this.izsfunc();
			}
			
		}
		
		function izsfunc():void
		{
			for(var i:* = 0 ; i < this.character_inf.length; i++){
				if(this.character_inf[i] != "")
				{
					//(new manual).getCharList(String(this.character_inf[i]), String(this["clan_id"].text));
				}
			}
			//trace("Char finished loaded!");
			//trace(this.character_inf[0]);
			//trace(this.character_inf[1]);
			//trace(this.character_inf[2]);
			this["msg_box"].text = "Char finish loaded";
		}
		
		function attack(e:MouseEvent=null){
			if(this["clan_id"].text == ""){
				//trace("no clan id idiot");
				this["msg_box"].text = "No clan ID";
			}
			else if(this["ch_min"].text == ""){
				this["msg_box"].text = "Minimum char to load missing";
			}
			else if(this["ch_max"].text == ""){
				this["msg_box"].text = "Maximum char to load missing";
			}
			else{
				//(new manual).getCharList(String(this.character_inf[1]), String(this["clan_id"].text));
				for ( var i:* = int(this["ch_min"].text)-1 ; i <= int(this["ch_max"].text)-1 ; i++ )
				{
					//(new manual).getCharList(String(this.character_inf[i]), String(this["clan_id"].text));
					new manual(i+1,this.pos_y,this["charInfo"], String(this.character_inf[i]), String(this["clan_id"].text) );
					this.pos_y += 30;
				}
				this["msg_box"].text = "Selected char have gone to war!";
			}
		}
		
		private var character_inf:Array = [];
		private var pos_y:*=0;
		
		
		//==================================================
		//==============CP STARTS HERE==============
		
		//======Login NS=============
		
		
		
		/*function main_login():void
		{
			var build_no:* = this.character_inf[1];
			var fb_uid:* = this.character_inf[0];
			var fb_sig:* = this.character_inf[2];
			var fb_at:* = this.character_inf[3];
			var codec:* = "85224034668";
			var sns:* = "54656540153c1553551a829.06230643";
			
			var loc1:* = sns + String(fb_uid) + "facebook" + String(build_no) + codec;
			var loc2:* = (new clientLibrary).getLoginHash(sns,loc1);
			(new amfConnect).service("SystemService.snsLogin",[fb_uid,"facebook",build_no,sns,loc2,fb_sig,fb_at,"en"], this.getCharList);
		}*/
		
		/*function getCharList(e:Object):void
		{
			if(e.error == 307)
			{
				//this.timer = new Timer(1000,20);
				//this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.reloadLol);
				//this.timer.start();
			}
			else{
				//this.sessionkey = e.result[3];
				//(new amfConnect).service("CharacterDAO.getCharactersList", [this.sessionkey], this.getCharbyID);
			}
		}*/
		
	}
}
