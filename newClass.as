package
{
	import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
	import flash.net.*;
	
	
	public class newClass extends MovieClip
	{
		public function newClass(arg1:*, in_y:*)
		{
			super();
			mc = arg1;
			inn_y = in_y;
			mc["scrollPane"].source = mc["mc_test"];
			this.function2();
			return;
		}
		
		function function2():void{
			
			//var mytext:TextField = new TextField();
			//mytext.text = "hello world";
			
			this.msg = new TextField();
			this.msg.text = "hello world";
			
			this.msg.border = true;
			this.msg.borderColor = 0xff0000;
			
			this.msg.width = 150;
			this.msg.height = 40;
			
			this.msg.y = inn_y;
			mc["mc_test"].addChild(this.msg);
			
			mc["scrollPane"].update();
			//this.test02();
		}
		
		private var mc:*;
		private var inn_y:*;
		private var msg:*;
	}
}