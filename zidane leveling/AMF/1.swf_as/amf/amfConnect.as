package amf 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class amfConnect extends Object
    {
        public function amfConnect()
        {
            super();
            return;
        }

        public function service(arg1:String, arg2:Array, arg3:Function):void
        {
            this.remotingGateway = "https://app.ninjasaga.com/amf_live2/";
            this.netConnect = new flash.net.NetConnection();
            this.netConnect.connect(this.remotingGateway);
            if (arg2.length == 0)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult));
            }
            if (arg2.length == 1)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0]);
            }
            if (arg2.length == 2)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1]);
            }
            if (arg2.length == 3)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2]);
            }
            if (arg2.length == 4)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3]);
            }
            if (arg2.length == 5)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4]);
            }
            if (arg2.length == 6)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5]);
            }
            if (arg2.length == 7)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6]);
            }
            if (arg2.length == 8)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7]);
            }
            if (arg2.length == 9)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8]);
            }
            if (arg2.length == 10)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9]);
            }
            if (arg2.length == 11)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10]);
            }
            if (arg2.length == 12)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11]);
            }
            if (arg2.length == 13)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12]);
            }
            if (arg2.length == 14)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13]);
            }
            if (arg2.length == 15)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13], arg2[14]);
            }
            if (arg2.length == 16)
            {
                this.netConnect.call(arg1, new flash.net.Responder(arg3, this.erroneousResult), arg2[0], arg2[1], arg2[2], arg2[3], arg2[4], arg2[5], arg2[6], arg2[7], arg2[8], arg2[9], arg2[10], arg2[11], arg2[12], arg2[13], arg2[14], arg2[15]);
            }
            return;
        }

        private function connectionHandler(arg1:flash.events.NetStatusEvent):void
        {
            return;
        }

        private function successfulResult(arg1:Object):void
        {
            return;
        }

        private function erroneousResult(arg1:Object):void
        {
            return;
        }

        private var remotingGateway:*;

        private var netConnect:*;
    }
}
