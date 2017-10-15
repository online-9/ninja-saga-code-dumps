package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	
	
	public class test02Main extends MovieClip {
		
		
		public function test02Main() {
			// constructor code
			addFrameScript(0, this.frame1);
		}
		
		/*var heightz:*=40;
		var widthz:* =150; 
		
		//var in_x:* = 0;
		var in_y:* = 0;
		
		var mc:*;
		var mcCls:*;*/
		
		private var bosses:Array = [[482,483,484],
									[485,486,487],
									[488,489,490],
									[491,492,493],
									[494,495,496],
									[497,498,499] ];
									
		//private var bosses:Array = [[1,2,3],[4,5,6],[7,8,9]];
		
		function frame1():*
		{
			this.stop();
			
			this["test_btn"].addEventListener(MouseEvent.CLICK, this.test03);
			
			//this.mc = this["main_mc"];
		}
		
		function test03(e:MouseEvent=null):void
		{
			trace(this.bosses[0][0]);
		}
		
		/*function test02(e:MouseEvent=null):void
		{
			this.mcCls = new newClass(this.mc,this.in_y);
			this.in_y += 40;
		}*/
		
		/*function addTextBox(e:MouseEvent=null):void{
			
			var mytext:TextField = new TextField();
			mytext.text = "hello world";

			mytext.border = true;
			mytext.borderColor = 0xff0000;

			mytext.width = this.widthz;
			mytext.height = this.heightz;
			
			mytext.y = this.in_y;
			//mc_test.addChild(mytext);
			
			
			//updating statements
			this.in_y += 40;
			//scrollPane.update();
		}*/
	}
	
}
