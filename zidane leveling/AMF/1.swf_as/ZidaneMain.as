package 
{
    import amf.*;
    import bitemycode.facebook.*;
    import data.*;
    import fl.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class ZidaneMain extends flash.display.MovieClip
    {
        public function ZidaneMain()
        {
            super();
            addFrameScript(0, this.frame1);
            return;
        }

        function frame1():*
        {
            this.stop();
            this.load_chars();
            this.ClanTimer = new flash.utils.Timer(100);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER, this.go);
            this.ClanTimer.start();
            this.loginBtn.label = "Enter";
            this["loginBtn"].addEventListener(flash.events.MouseEvent.CLICK, this.loginpanel);
            this.allBtn.label = "Load";
            this["allBtn"].addEventListener(flash.events.MouseEvent.CLICK, this.checkingchar);
            this.attackBtn.label = "(A)";
            this["attackBtn"].addEventListener(flash.events.MouseEvent.CLICK, this.SerangKabeh);
            this.restoreBtn.label = "Restore";
            this["restoreBtn"].addEventListener(flash.events.MouseEvent.CLICK, this.restoresemuapasukan);
            this["hostclanid"].addEventListener(flash.events.Event.CHANGE, this.changeidhost);
            this["passwordtxt"].text = "DF";
            this["hostclanid"].text = "";
            this["ns_version"].text = "3.2.00199";
            this["randomtext"].text = "fb_sig[2]";
            this["pilihserang"].text = "";
            this["hashtime"].text = "";
            this["hashtime2"].text = "";
            this["hashtime3"].text = "";
            this["hashtime4"].text = "";
            this["hashtime5"].text = "";
            this["hashtime6"].text = "";
            this["hashtime7"].text = "";
            this["hashtime8"].text = "";
            this["hashtime9"].text = "";
            this["hashtime10"].text = "";
            this["hostclanid"].visible = false;
            this["ns_version"].visible = false;
            this["randomtext"].visible = false;
            this["pilihserang"].visible = false;
            this["hashtime"].visible = false;
            this["hashtime2"].visible = false;
            this["hashtime3"].visible = false;
            this["hashtime4"].visible = false;
            this["hashtime5"].visible = false;
            this["hashtime6"].visible = false;
            this["hashtime7"].visible = false;
            this["hashtime8"].visible = false;
            this["hashtime9"].visible = false;
            this["hashtime10"].visible = false;
            this["allBtn"].visible = false;
            this["attackBtn"].visible = false;
            this["restoreBtn"].visible = false;
            this["pilihserang"].visible = false;
            this["hostclanid"].visible = false;
            this["a1"].visible = false;
            this["a2"].visible = false;
            this["a3"].visible = false;
            this["a4"].visible = false;
            this["a5"].visible = false;
            this["bot"].visible = false;
            this["loginBtn"].visible = false;
            this["passwordtxt"].visible = false;
            this["passwordtittle"].visible = false;
            return;
        }

        private function load_chars():void
        {
            var loc1:*;
            loc1 = new flash.net.URLVariables();
            var loc2:*;
            loc2 = new flash.net.URLRequest("http://cdn-darkfantasia.zz.vc/PanelBuatExpired/SunagakureHostDekstop.php");
            loc2.method = flash.net.URLRequestMethod.POST;
            loc2.data = loc1;
            var loc3:*;
            loc3 = new flash.net.URLLoader();
            loc3.dataFormat = flash.net.URLLoaderDataFormat.VARIABLES;
            loc3.addEventListener(flash.events.Event.COMPLETE, this.completeHandle);
            loc1.myrequest = "get_time";
            loc3.load(loc2);
            return;
        }

        function completeHandle(arg1:flash.events.Event):void
        {
            if (arg1.target.data.returnStr <= "Matikan")
            {
                this["pesantext"].text = "Masa Aktif Anda Kadaluarsa ! ";
                this["hostclanid"].visible = false;
                this["ns_version"].visible = false;
                this["randomtext"].visible = false;
                this["pilihserang"].visible = false;
                this["hashtime"].visible = false;
                this["hashtime2"].visible = false;
                this["hashtime3"].visible = false;
                this["hashtime4"].visible = false;
                this["hashtime5"].visible = false;
                this["hashtime6"].visible = false;
                this["hashtime7"].visible = false;
                this["hashtime8"].visible = false;
                this["hashtime9"].visible = false;
                this["hashtime10"].visible = false;
                this["allBtn"].visible = false;
                this["attackBtn"].visible = false;
                this["restoreBtn"].visible = false;
                this["pilihserang"].visible = false;
                this["hostclanid"].visible = false;
                this["a1"].visible = false;
                this["a2"].visible = false;
                this["a3"].visible = false;
                this["a4"].visible = false;
                this["a5"].visible = false;
                this["bot"].visible = false;
                this["loginBtn"].visible = false;
                this["passwordtxt"].visible = false;
                this["passwordtittle"].visible = false;
                return;
            }
            this["pesantext"].text = "Checking Data ....";
            this.ClanTimer = new flash.utils.Timer(1000, 3);
            this.ClanTimer.start();
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.gette);
            return;
        }

        function gette(arg1:flash.events.TimerEvent):void
        {
            this["pesantext"].text = "Masa Aktif Anda Aktif !";
            this["loginBtn"].visible = true;
            this["passwordtxt"].visible = true;
            this["passwordtittle"].visible = true;
            return;
        }

        function SerangKabeh(arg1:flash.events.MouseEvent):void
        {
            if (this["pilihserang"].text == "Quick")
            {
                this.attackallchar1();
                return;
            }
            if (this["pilihserang"].text == "Manual")
            {
                this.manualhost1();
                return;
            }
            this["pesantext"].text = "Masukan Quick Atau Manual !";
            return;
        }

        function checkingchar(arg1:flash.events.MouseEvent=null):void
        {
            this.char1sns();
            return;
        }

        function char1sns():void
        {
            this.amfSeq = 0;
            var loc1:*;
            loc1 = "100001057070703";
            var loc2:*;
            loc2 = "3a97ff3c22d4f5d2e74934ed69cddda9" + this["hashtime"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAHba0O8iWfVP4XS63phyyQ9Nez1bOWPdvrMndTZA58X7ytKBILipZA2bfKpRgjfpd7g7xniGJmDcV8qZAW1HctE1pdyObQfrMwnrlz7L4KvvLKGnZCilq8lI3sCfmR3dzdkZBDRr0fN5pQbvBJVmKBZCeJDXjxUoyNKjns6NjuFW3m0vK9wOB9TPvD0TFqE0zEuN54x8fK84cKtVutILsZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult1);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char2sns():void
        {
            this.amfSeq2 = 0;
            var loc1:*;
            loc1 = "100003722374630";
            var loc2:*;
            loc2 = "5f9aa5a58a9f72b671b97d92b38a7fb6" + this["hashtime2"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAMwmeNcONm3VObt3t88KrZAnUgqcvRSYmgroZBl6S2mtQ7dg6WZCI8b01t77q6kpZA7ZBuzr7n79Cm18f1ohsNZACLqQI53ASl5r9vjmwa68ZA7ZCHmOJWAcQygBZA4Ltvu1dXU7rK8LEjQzae20ybF7ZBAyoZB4mqKvIJ3jd6WOPl0MNd8bh5ZAQO6kv433eZAIecPvJWqsRTR694RNKfRpQebQZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult2);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char3sns():void
        {
            this.amfSeq3 = 0;
            var loc1:*;
            loc1 = "100001499510905";
            var loc2:*;
            loc2 = "da032162efeb4f626c835209793045a5" + this["hashtime3"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBACnVi4x7PNjdcrsZCGSCryN8AcEMK03LGA73ZB2ZAgpkq2VToYC5YDFCBZAicP8pxiGtOS7sFzNHdyuLCpdoaUN2mupxG3DeBArdaMZARZBGP3hJgCxsuqCP4fD8YHZBSI1GzIe0zNU6ABpgLfyncqbzfSkhhZCTYCNfW0Aw6mxZAOwKI2lWvePk5LNrMcQVmf2UTutmeTKadCyf6WT54HRkZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult3);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char4sns():void
        {
            this.amfSeq4 = 0;
            var loc1:*;
            loc1 = "100003507955947";
            var loc2:*;
            loc2 = "dc2eb21ecf09c255b2c2499c6653e308" + this["hashtime4"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBABrntZAapKPqpRPfZBFmVFBoWQTjlgO11OCFOATyglRE84sWjj3BPxIV0EXNTHCW37hgUG6iINWZCWPPACiT7JuaYCh0GYv75GlyeWJktzoKU4cyTWBPX7FsnUjwPgNcLssn4U7JV1zB5Hksm3NaEdDS1ZClyCIpSde1D9ZC095yqlmY1P665nRSjN2ql7p5L6fW5iBic2s61YeITwYMZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult4);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char5sns():void
        {
            this.amfSeq5 = 0;
            var loc1:*;
            loc1 = "100003620940369";
            var loc2:*;
            loc2 = "6fc9f3f366efadc670ceaf224f760bd6" + this["hashtime5"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAAdpnkfO9ZCkb6vdpggrQ7eXuvTsQzxRdUYgVluGgDOszWuZBCw1xrR4hzJN3pyyLa3P0ZAWSeh34KgCLZC2ToXK2BjEqyIUrZBInVhs7PGg15ZACMKcrJHLFUFNEOyRP0qJZCpfdgZATfjdAKEkYCI15ZA5jZCZADmijo8uvckAXZBKXCSsRV2K3GbONprzXJENWZA6A9n100NMHGxNZCa8QoZCwQZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult5);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char6sns():void
        {
            this.amfSeq6 = 0;
            var loc1:*;
            loc1 = "100003632245049";
            var loc2:*;
            loc2 = "1e27e9962d16dbc92a4ea2a1cb1aadbb" + this["hashtime6"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAPXyZALX4vRZAVZCnDA3IiwuyQkTABZAfKDqaYTk24dWjboxr2Hz39iLXkjW4iHcuHwnlZAk41jemWVRUk2bjmggmj6dZAjoFIMeR4c8I0HLjIwJZAxtZBXzl918tCaQJ4mwhZC2i8Pqp9QFfkqXZA2OSomXz9VE8vVMtSG9r8XZCZBluyMIGaVokWPsdXMQqZCow5B8qKZA2Telc61hkDakfZBkYgZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult6);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char7sns():void
        {
            this.amfSeq7 = 0;
            var loc1:*;
            loc1 = "100001994365837";
            var loc2:*;
            loc2 = "2c8f9418f17171214f82a23af1c92d84" + this["hashtime7"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBALVKaJBlegr77FtxZA8TJKosrSHeiZBd0JZBePTv9kDfq1NBSzjvzAV2xaDPaXdh6VK6DEMDVmMEO9mlgpjJsaiVNUJJzuygeC2Da5ZCgX45QLZCn2c1Yp71jqEpm1ZAo90sxlSztCjtZAM5i10rGXaYAVAdkL6KwBE5Pcn5lZBZAarEznxSp6KbZB3U7nbkrWs6JdU6IFZCW1o1UZBqPRiujaMZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult7);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char8sns():void
        {
            this.amfSeq8 = 0;
            var loc1:*;
            loc1 = "100003673080118";
            var loc2:*;
            loc2 = "bf00b1d0d69a842aed6beb3e2266da20" + this["hashtime8"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAJFS7p86be04X1eZCeDtiQnZBffXZBJVWzCUADlESUGo9xBEdrqKaKfFQD1hLMvTQX0PhI6BgHWbN4HaeRZCxEuaAA9iguGj0dXy9KcBHKFYZB1vyvReMxn42A1eWR7xcPJUgvzYrPEeLVcn6h7DuZC3QvsqWsJoaxpPlTxRZCaUg5W1ZCuVnbDMqXCaqcQxkkacbsVU7dX6RA01F3cllf4ZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult8);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char9sns():void
        {
            this.amfSeq9 = 0;
            var loc1:*;
            loc1 = "100003695953838";
            var loc2:*;
            loc2 = "3a2b3e23dfd850c070850efc16a489cc" + this["hashtime9"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAFun8ErGVzjmfoPALrfkZACIHDzgY4W0Hg3WrHbqei8AZC1Qqs3FD8fBw1UGmZBKyZASGmZBSUZCKZAvqkD7FhPZBSDH1jvOSMapZAZBIazZAKzIfhSxRzlwLVU5HSAZALH4epQ8Hni2FjsjZCPgAYzEKmVqZAipmZCEZCLRKneljXPIwDc5GxZC9CWS8bzDjhYCJixoRIGRzLFZCnEG8yNaqIrV1m4FYZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult9);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function char10sns():void
        {
            this.amfSeq10 = 0;
            var loc1:*;
            loc1 = "100003830231514";
            var loc2:*;
            loc2 = "31d219cc4cdb6b4bbd0bad72d629bc55" + this["hashtime10"].text;
            var loc3:*;
            loc3 = "CAAAAIBckVZAoBAFBpPXvpQPl5WzAI2zlhtD2EenZAoeJknfVhvQd5BKCc84PELIRg4FyyW9ZCRwDx7MjxqhXDTlY8OirE8CDKUkDzGrjXuK5KMINxw69vNjAV1nFcP5tBuCbBTJgL9QG8wDIihI4BWQdAnjF6CUqiuBcjx5fFbnMf2WL3KstJZAUmZBFYCVRZCeKfzSJMXbAVBLVc6vzrIYKQEkoZAYEd4ZD";
            var loc4:*;
            loc4 = this["ns_version"].text;
            var loc5:*;
            loc5 = "85224034668";
            var loc6:*;
            var loc7:*;
            loc7 = (loc6 = "6501883134e7857e7cccc07.84600174") + String(loc1) + "facebook" + String(loc4) + loc5;
            var loc8:*;
            loc8 = new data.clientLibrary().getLoginHash(loc6, loc7);
            new amf.amfConnect().service("SystemService.snsLogin", [loc1, "facebook", loc4, loc6, loc8, loc2, loc3, "en"], this.mySnsResult10);
            this["statusamf"].text = "SystemService.snsLogin";
            return;
        }

        function mySnsResult1(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[1] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar1 = arg1.result[2];
                this.hashsession1 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession1, "27306930"], this.myCharacterById1);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult2(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[2] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar2 = arg1.result[2];
                this.hashsession2 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession2, "46823424"], this.myCharacterById2);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult3(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[3] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar3 = arg1.result[2];
                this.hashsession3 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession3, "17732777"], this.myCharacterById3);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult4(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[4] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar4 = arg1.result[2];
                this.hashsession4 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession4, "45775614"], this.myCharacterById4);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult5(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[5] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar5 = arg1.result[2];
                this.hashsession5 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession5, "45775817"], this.myCharacterById5);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult6(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[6] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar6 = arg1.result[2];
                this.hashsession6 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession6, "46630492"], this.myCharacterById6);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult7(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[7] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar7 = arg1.result[2];
                this.hashsession7 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession7, "26319399"], this.myCharacterById7);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult8(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[8] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar8 = arg1.result[2];
                this.hashsession8 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession8, "48135786"], this.myCharacterById8);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult9(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[9] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar9 = arg1.result[2];
                this.hashsession9 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession9, "51306691"], this.myCharacterById9);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function mySnsResult10(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "[10] Login Failed ! " + " Error " + String(arg1.error);
                return;
            }
            if (arg1.status == 1)
            {
                this.tokendarichar10 = arg1.result[2];
                this.hashsession10 = arg1.result[3];
                new amf.amfConnect().service("CharacterDAO.getCharacterById", [this.hashsession10, "48774959"], this.myCharacterById10);
                this["statusamf"].text = "CharacterDAO.getCharacterById";
                return;
            }
            return;
        }

        function myCharacterById1(arg1:Object):void
        {
            this["pesantext"].text = "[1] Character " + arg1.result.character_name + " Active";
            this.namachar1 = arg1.result.character_name;
            this["hashtime"].text = this.namachar1;
            this["token"].text = this.tokendarichar1;
            this["randomtext"].text = "Charname";
            this.char2sns();
            return;
        }

        function myCharacterById2(arg1:Object):void
        {
            this["pesantext"].text = "[2] Character " + arg1.result.character_name + " Active";
            this.namachar2 = arg1.result.character_name;
            this["hashtime2"].text = this.namachar2;
            this["token2"].text = this.tokendarichar2;
            this.char3sns();
            return;
        }

        function myCharacterById3(arg1:Object):void
        {
            this["pesantext"].text = "[3] Character " + arg1.result.character_name + " Active";
            this.namachar3 = arg1.result.character_name;
            this["hashtime3"].text = this.namachar3;
            this["token3"].text = this.tokendarichar3;
            this.char4sns();
            return;
        }

        function myCharacterById4(arg1:Object):void
        {
            this["pesantext"].text = "[4] Character " + arg1.result.character_name + " Active";
            this.namachar4 = arg1.result.character_name;
            this["hashtime4"].text = this.namachar4;
            this["token4"].text = this.tokendarichar4;
            this.char5sns();
            return;
        }

        function myCharacterById5(arg1:Object):void
        {
            this["pesantext"].text = "[5] Character " + arg1.result.character_name + " Active";
            this.namachar5 = arg1.result.character_name;
            this["hashtime5"].text = this.namachar5;
            this["token5"].text = this.tokendarichar5;
            this.char6sns();
            return;
        }

        function myCharacterById6(arg1:Object):void
        {
            this["pesantext"].text = "[6] Character " + arg1.result.character_name + " Active";
            this.namachar6 = arg1.result.character_name;
            this["hashtime6"].text = this.namachar6;
            this["token6"].text = this.tokendarichar6;
            this.char7sns();
            return;
        }

        function myCharacterById7(arg1:Object):void
        {
            this["pesantext"].text = "[7] Character " + arg1.result.character_name + " Active";
            this.namachar7 = arg1.result.character_name;
            this["hashtime7"].text = this.namachar7;
            this["token7"].text = this.tokendarichar7;
            this.char8sns();
            return;
        }

        function myCharacterById8(arg1:Object):void
        {
            this["pesantext"].text = "[8] Character " + arg1.result.character_name + " Active";
            this.namachar8 = arg1.result.character_name;
            this["hashtime8"].text = this.namachar8;
            this["token8"].text = this.tokendarichar8;
            this.char9sns();
            return;
        }

        function myCharacterById9(arg1:Object):void
        {
            this["pesantext"].text = "[9] Character " + arg1.result.character_name + " Active";
            this.namachar9 = arg1.result.character_name;
            this["hashtime9"].text = this.namachar9;
            this["token9"].text = this.tokendarichar9;
            this.char10sns();
            return;
        }

        function myCharacterById10(arg1:Object):void
        {
            this["pesantext"].text = "[10] Character " + arg1.result.character_name + " Active";
            this.namachar10 = arg1.result.character_name;
            this["hashtime10"].text = this.namachar10;
            this["token10"].text = this.tokendarichar10;
            this.prepareattack1();
            return;
        }

        function prepareattack1():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession1], this.getClanStatusResult1);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack2():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession2], this.getClanStatusResult2);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack3():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession3], this.getClanStatusResult3);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack4():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession4], this.getClanStatusResult4);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack5():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession5], this.getClanStatusResult5);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack6():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession6], this.getClanStatusResult6);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack7():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession7], this.getClanStatusResult7);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack8():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession8], this.getClanStatusResult8);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack9():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession9], this.getClanStatusResult9);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function prepareattack10():void
        {
            new amf.amfConnect().service("ClanService.getClanStatus", [this.hashsession10], this.getClanStatusResult10);
            this["statusamf"].text = "ClanService.getClanStatus";
            return;
        }

        function getClanStatusResult1(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession1], this.getClanResult1);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult2(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession2], this.getClanResult2);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult3(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession3], this.getClanResult3);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult4(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession4], this.getClanResult4);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult5(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession5], this.getClanResult5);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult6(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession6], this.getClanResult6);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult7(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession7], this.getClanResult7);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult8(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession8], this.getClanResult8);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult9(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession9], this.getClanResult9);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanStatusResult10(arg1:Object):void
        {
            new amf.amfConnect().service("ClanService.getClan", [this.hashsession10], this.getClanResult10);
            this["statusamf"].text = "ClanService.getClan";
            return;
        }

        function getClanResult1(arg1:Object):void
        {
            this.rollX1 = arg1.stamina_item;
            this["sr"].text = this.rollX1;
            this.filecheckhosting1();
            return;
        }

        function getClanResult2(arg1:Object):void
        {
            this.rollX2 = arg1.stamina_item;
            this["sr2"].text = this.rollX2;
            this.filecheckhosting2();
            return;
        }

        function getClanResult3(arg1:Object):void
        {
            this.rollX3 = arg1.stamina_item;
            this["sr3"].text = this.rollX3;
            this.filecheckhosting3();
            return;
        }

        function getClanResult4(arg1:Object):void
        {
            this.rollX4 = arg1.stamina_item;
            this["sr4"].text = this.rollX4;
            this.filecheckhosting4();
            return;
        }

        function getClanResult5(arg1:Object):void
        {
            this.rollX5 = arg1.stamina_item;
            this["sr5"].text = this.rollX5;
            this.filecheckhosting5();
            return;
        }

        function getClanResult6(arg1:Object):void
        {
            this.rollX6 = arg1.stamina_item;
            this["sr6"].text = this.rollX6;
            this.filecheckhosting6();
            return;
        }

        function getClanResult7(arg1:Object):void
        {
            this.rollX7 = arg1.stamina_item;
            this["sr7"].text = this.rollX7;
            this.filecheckhosting7();
            return;
        }

        function getClanResult8(arg1:Object):void
        {
            this.rollX8 = arg1.stamina_item;
            this["sr8"].text = this.rollX8;
            this.filecheckhosting8();
            return;
        }

        function getClanResult9(arg1:Object):void
        {
            this.rollX9 = arg1.stamina_item;
            this["sr9"].text = this.rollX9;
            this.filecheckhosting9();
            return;
        }

        function getClanResult10(arg1:Object):void
        {
            this.rollX10 = arg1.stamina_item;
            this["sr10"].text = this.rollX10;
            this.filecheckhosting10();
            return;
        }

        function filecheckhosting1():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession1, loc3, loc2], this.responsefilehost1);
            return;
        }

        function filecheckhosting2():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession2, loc3, loc2], this.responsefilehost2);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting3():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession3, loc3, loc2], this.responsefilehost3);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting4():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession4, loc3, loc2], this.responsefilehost4);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting5():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession5, loc3, loc2], this.responsefilehost5);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting6():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession6, loc3, loc2], this.responsefilehost6);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting7():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession7, loc3, loc2], this.responsefilehost7);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting8():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession8, loc3, loc2], this.responsefilehost8);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting9():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession9, loc3, loc2], this.responsefilehost9);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function filecheckhosting10():void
        {
            var loc1:*;
            loc1 = undefined;
            var loc2:*;
            loc2 = undefined;
            loc1 = this["ns_version"].text;
            var loc3:*;
            loc3 = new Array(["https://cdn.static.ninjasaga.com/swf/" + loc1 + "/swf/panels/clan_panel.swf", int(888362), int(888362), true, int(10), int(3), Object]);
            loc2 = new data.clientLibrary().getHash(this.hashsession10, loc3[1]);
            new amf.amfConnect().service("FileChecking.checkHackActivity", [this.hashsession10, loc3, loc2], this.responsefilehost10);
            this["statusamf"].text = "FileChecking.checkHackActivity";
            return;
        }

        function responsefilehost1(arg1:Object):void
        {
            this.prepareattack2();
            return;
        }

        function responsefilehost2(arg1:Object):void
        {
            this.prepareattack3();
            return;
        }

        function responsefilehost3(arg1:Object):void
        {
            this.prepareattack4();
            return;
        }

        function responsefilehost4(arg1:Object):void
        {
            this.prepareattack5();
            return;
        }

        function responsefilehost5(arg1:Object):void
        {
            this.prepareattack6();
            return;
        }

        function responsefilehost6(arg1:Object):void
        {
            this.prepareattack7();
            return;
        }

        function responsefilehost7(arg1:Object):void
        {
            this.prepareattack8();
            return;
        }

        function responsefilehost8(arg1:Object):void
        {
            this.prepareattack9();
            return;
        }

        function responsefilehost9(arg1:Object):void
        {
            this.prepareattack10();
            return;
        }

        function responsefilehost10(arg1:Object):void
        {
            this["pesantext"].text = "Semua Char Siap Menyerang !";
            this["attackBtn"].visible = true;
            this["restoreBtn"].visible = true;
            return;
        }

        function loginpanel(arg1:flash.events.MouseEvent=null):void
        {
            if (this["passwordtxt"].text != "DF")
            {
                if (this["passwordtxt"].text != "")
                {
                    this["pesantext"].text = "Password Salah";
                }
                else 
                {
                    this["pesantext"].text = "Masukan Password Terlebih Dahulu";
                }
            }
            else 
            {
                this["loginBtn"].visible = false;
                this["passwordtxt"].visible = false;
                this["passwordtittle"].visible = false;
                this["pesantext"].text = "Welcome Sunagakure Ninjaz Clan ! Enjoy ";
                this["hostclanid"].visible = true;
                this["ns_version"].visible = true;
                this["randomtext"].visible = true;
                this["pilihserang"].visible = true;
                this["hashtime"].visible = true;
                this["hashtime2"].visible = true;
                this["hashtime3"].visible = true;
                this["hashtime4"].visible = true;
                this["hashtime5"].visible = true;
                this["hashtime6"].visible = true;
                this["hashtime7"].visible = true;
                this["hashtime8"].visible = true;
                this["hashtime9"].visible = true;
                this["hashtime10"].visible = true;
                this["allBtn"].visible = true;
                this["pilihserang"].visible = true;
                this["hostclanid"].visible = true;
                this["a1"].visible = true;
                this["a2"].visible = true;
                this["a3"].visible = true;
                this["a4"].visible = true;
                this["a5"].visible = true;
                this["bot"].visible = true;
            }
            return;
        }

        function manualhost1():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession1], this.jalanhost1);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost2():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession2], this.jalanhost2);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost3():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession3], this.jalanhost3);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost4():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession4], this.jalanhost4);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost5():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession5], this.jalanhost5);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost6():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession6], this.jalanhost6);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost7():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession7], this.jalanhost7);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost8():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession8], this.jalanhost8);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost9():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession9], this.jalanhost9);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function manualhost10():void
        {
            new amf.amfConnect().service("ClanService.getWarList", [this.hashsession10], this.jalanhost10);
            this["statusamf"].text = "ClanService.getWarList";
            return;
        }

        function jalanhost1(arg1:Object):void
        {
            this.staminahost = arg1.character_stamina;
            this["stamina"].text = this.staminahost;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession1], this.lanjutinhost1);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost2(arg1:Object):void
        {
            this.staminahost2 = arg1.character_stamina;
            this["stamina2"].text = this.staminahost2;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession2], this.lanjutinhost2);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost3(arg1:Object):void
        {
            this.staminahost3 = arg1.character_stamina;
            this["stamina3"].text = this.staminahost3;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession3], this.lanjutinhost3);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost4(arg1:Object):void
        {
            this.staminahost4 = arg1.character_stamina;
            this["stamina4"].text = this.staminahost4;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession4], this.lanjutinhost4);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost5(arg1:Object):void
        {
            this.staminahost5 = arg1.character_stamina;
            this["stamina5"].text = this.staminahost5;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession5], this.lanjutinhost5);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost6(arg1:Object):void
        {
            this.staminahost6 = arg1.character_stamina;
            this["stamina6"].text = this.staminahost6;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession6], this.lanjutinhost6);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost7(arg1:Object):void
        {
            this.staminahost7 = arg1.character_stamina;
            this["stamina7"].text = this.staminahost7;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession7], this.lanjutinhost7);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost8(arg1:Object):void
        {
            this.staminahost8 = arg1.character_stamina;
            this["stamina8"].text = this.staminahost8;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession8], this.lanjutinhost8);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost9(arg1:Object):void
        {
            this.staminahost9 = arg1.character_stamina;
            this["stamina9"].text = this.staminahost9;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession9], this.lanjutinhost9);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function jalanhost10(arg1:Object):void
        {
            this.staminahost10 = arg1.character_stamina;
            this["stamina10"].text = this.staminahost10;
            new amf.amfConnect().service("ClanWar.getMemberList", [this.hashsession10], this.lanjutinhost10);
            this["statusamf"].text = "ClanWar.getMemberList";
            return;
        }

        function lanjutinhost1(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost == 0)
            {
                this["stamina"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession1;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession1, this.updateSequence(), loc2, this.idhost, "", "", false], this.getrephostX1);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost2(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost2 == 0)
            {
                this["stamina2"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost2 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession2;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession2, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession2, this.updateSequence2(), loc2, this.idhost, "", "", false], this.getrephostX2);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost3(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost3 == 0)
            {
                this["stamina3"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost3 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession3;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession3, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession3, this.updateSequence3(), loc2, this.idhost, "", "", false], this.getrephostX3);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost4(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost4 == 0)
            {
                this["stamina4"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost4 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession4;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession4, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession4, this.updateSequence4(), loc2, this.idhost, "", "", false], this.getrephostX4);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost5(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost5 == 0)
            {
                this["stamina5"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost5 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession5;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession5, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession5, this.updateSequence5(), loc2, this.idhost, "", "", false], this.getrephostX5);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost6(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost6 == 0)
            {
                this["stamina6"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost6 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession6;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession6, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession6, this.updateSequence6(), loc2, this.idhost, "", "", false], this.getrephostX6);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost7(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost7 == 0)
            {
                this["stamina7"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost7 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession7;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession7, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession7, this.updateSequence7(), loc2, this.idhost, "", "", false], this.getrephostX7);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost8(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost8 == 0)
            {
                this["stamina8"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost8 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession8;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession8, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession8, this.updateSequence8(), loc2, this.idhost, "", "", false], this.getrephostX8);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost9(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost9 == 0)
            {
                this["stamina9"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost9 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession9;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession9, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession9, this.updateSequence9(), loc2, this.idhost, "", "", false], this.getrephostX9);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        function lanjutinhost10(arg1:Object):void
        {
            if (this.idhost == 0)
            {
                this["statusamf"].text = "Please Input ID Clan~";
                return;
            }
            if (this.staminahost10 == 0)
            {
                this["stamina10"].text = "Auto";
                if (this["bot"].text == "yes")
                {
                    this["pesantext"].text = "Sisa " + this.staminahost10 + " Stamina!";
                    this.manualhost1();
                    return;
                }
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession10;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession10, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession10, this.updateSequence10(), loc2, this.idhost, "", "", false], this.getrephostX10);
            this["statusamf"].text = "ClanWar.getBattleDefender";
            return;
        }

        public function updateSequence():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq + 1);
            loc2.amfSeq = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession1, String(this.amfSeq));
            return loc1;
        }

        public function updateSequence2():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq2 + 1);
            loc2.amfSeq2 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession2, String(this.amfSeq2));
            return loc1;
        }

        public function updateSequence3():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq3 + 1);
            loc2.amfSeq3 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession3, String(this.amfSeq3));
            return loc1;
        }

        public function updateSequence4():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq4 + 1);
            loc2.amfSeq4 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession4, String(this.amfSeq4));
            return loc1;
        }

        public function updateSequence5():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq5 + 1);
            loc2.amfSeq5 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession5, String(this.amfSeq5));
            return loc1;
        }

        public function updateSequence6():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq6 + 1);
            loc2.amfSeq6 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession6, String(this.amfSeq6));
            return loc1;
        }

        public function updateSequence7():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq7 + 1);
            loc2.amfSeq7 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession7, String(this.amfSeq7));
            return loc1;
        }

        public function updateSequence8():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq8 + 1);
            loc2.amfSeq8 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession8, String(this.amfSeq8));
            return loc1;
        }

        public function updateSequence9():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq9 + 1);
            loc2.amfSeq9 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession9, String(this.amfSeq9));
            return loc1;
        }

        public function updateSequence10():String
        {
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).amfSeq10 + 1);
            loc2.amfSeq10 = loc3;
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession10, String(this.amfSeq10));
            return loc1;
        }

        function getrephostX1(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[1] " + this["hashtime"].text + " Attacked Manual";
                this.generatechar1();
                this["stamina"].text = this.staminahost - int(10);
                return;
            }
            this["pesantext"].text = "[1] " + this["hashtime"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX2(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[2] " + this["hashtime2"].text + " Attacked Manual";
                this.generatecharx1();
                this["stamina2"].text = this.staminahost2 - int(10);
                return;
            }
            this["pesantext"].text = "[2] " + this["hashtime2"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX3(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[3] " + this["hashtime3"].text + " Attacked Manual";
                this.generatecharx3();
                this["stamina3"].text = this.staminahost3 - int(10);
                return;
            }
            this["pesantext"].text = "[3] " + this["hashtime3"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX4(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[4] " + this["hashtime4"].text + " Attacked Manual";
                this.generatecharx6();
                this["stamina4"].text = this.staminahost4 - int(10);
                return;
            }
            this["pesantext"].text = "[4] " + this["hashtime4"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX5(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[5] " + this["hashtime5"].text + " Attacked Manual";
                this.generatecharx9();
                this["stamina5"].text = this.staminahost5 - int(10);
                return;
            }
            this["pesantext"].text = "[5] " + this["hashtime5"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX6(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[6] " + this["hashtime6"].text + " Attacked Manual";
                this.generatecharx12();
                this["stamina6"].text = this.staminahost6 - int(10);
                return;
            }
            this["pesantext"].text = "[6] " + this["hashtime6"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX7(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[7] " + this["hashtime7"].text + " Attacked Manual";
                this.generatecharx15();
                this["stamina7"].text = this.staminahost7 - int(10);
                return;
            }
            this["pesantext"].text = "[7] " + this["hashtime7"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX8(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[8] " + this["hashtime8"].text + " Attacked Manual";
                this.generatecharx18();
                this["stamina8"].text = this.staminahost8 - int(10);
                return;
            }
            this["pesantext"].text = "[8] " + this["hashtime8"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX9(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[9] " + this["hashtime9"].text + " Attacked Manual";
                this.generatecharx21();
                this["stamina9"].text = this.staminahost9 - int(10);
                return;
            }
            this["pesantext"].text = "[9] " + this["hashtime9"].text + String(arg1.rep_gain);
            return;
        }

        function getrephostX10(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                return;
            }
            if (arg1.result == 1)
            {
                this["pesantext"].text = "[10] " + this["hashtime10"].text + " Attacked Manual";
                this.generatecharx24();
                this["stamina10"].text = this.staminahost10 - int(10);
                return;
            }
            this["pesantext"].text = "[10] " + this["hashtime10"].text + String(arg1.rep_gain);
            return;
        }

        function generatechar1():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession1, Number("196790")], this.listcharhost1);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhost1(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession1, Number("382280")], this.listcharhost2);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhost2(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession1, Number("1342039")], this.listcharhost3);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx1():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession2, Number("196790")], this.listcharhostx1);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx1(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession2, Number("382280")], this.listcharhostx2);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx2(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession2, Number("1342039")], this.listcharhost4);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx3():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession3, Number("196790")], this.listcharhostx4);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx4(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession3, Number("382280")], this.listcharhostx5);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx5(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession3, Number("1342039")], this.listcharhost5);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx6():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession4, Number("196790")], this.listcharhostx7);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx7(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession4, Number("382280")], this.listcharhostx8);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx8(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession4, Number("1342039")], this.listcharhost6);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx9():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession5, Number("196790")], this.listcharhostx10);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx10(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession5, Number("382280")], this.listcharhostx11);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx11(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession5, Number("1342039")], this.listcharhost7);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx12():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession6, Number("196790")], this.listcharhostx13);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx13(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession6, Number("382280")], this.listcharhostx14);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx14(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession6, Number("1342039")], this.listcharhost8);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx15():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession7, Number("196790")], this.listcharhostx16);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx16(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession7, Number("382280")], this.listcharhostx17);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx17(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession7, Number("1342039")], this.listcharhost9);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx18():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession8, Number("196790")], this.listcharhostx19);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx19(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession8, Number("382280")], this.listcharhostx20);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx20(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession8, Number("1342039")], this.listcharhost10);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx21():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession9, Number("196790")], this.listcharhostx22);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx22(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession9, Number("382280")], this.listcharhostx23);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx23(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession9, Number("1342039")], this.listcharhost11);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function generatecharx24():void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession10, Number("196790")], this.listcharhostx25);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx25(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession10, Number("382280")], this.listcharhostx26);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhostx26(arg1:Object):void
        {
            new amf.amfConnect().service("CharacterDAO.getCharacterProfileById", [this.hashsession10, Number("1342039")], this.listcharhost12);
            this["statusamf"].text = "CharacterDAO.getCharacterProfileById";
            return;
        }

        function listcharhost3(arg1:Object):void
        {
            this.manualhost2();
            return;
        }

        function listcharhost4(arg1:Object):void
        {
            this.manualhost3();
            return;
        }

        function listcharhost5(arg1:Object):void
        {
            this.manualhost4();
            return;
        }

        function listcharhost6(arg1:Object):void
        {
            this.manualhost5();
            return;
        }

        function listcharhost7(arg1:Object):void
        {
            this.manualhost6();
            return;
        }

        function listcharhost8(arg1:Object):void
        {
            this.manualhost7();
            return;
        }

        function listcharhost9(arg1:Object):void
        {
            this.manualhost8();
            return;
        }

        function listcharhost10(arg1:Object):void
        {
            this.manualhost9();
            return;
        }

        function listcharhost11(arg1:Object):void
        {
            this.manualhost10();
            return;
        }

        function listcharhost12(arg1:Object):void
        {
            this.ClanTimer = new flash.utils.Timer(1000, 60);
            this.ClanTimer.start();
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.selesaihost1);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER, this.hitungval);
            return;
        }

        function hitungval(arg1:flash.events.TimerEvent):void
        {
            this["pesantext"].text = 60 - this.ClanTimer.currentCount + " Seconds ...";
            return;
        }

        function selesaihost1(arg1:flash.events.TimerEvent):void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession1, String("1") + "" + this.hashsession1);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession1, this.updateSequence(), String("1"), "", loc1], this.flushBattleStat);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost2():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession2, String("1") + "" + this.hashsession2);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession2, this.updateSequence2(), String("1"), "", loc1], this.flushBattleStat2);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost3():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession3, String("1") + "" + this.hashsession3);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession3, this.updateSequence3(), String("1"), "", loc1], this.flushBattleStat3);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost4():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession4, String("1") + "" + this.hashsession4);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession4, this.updateSequence4(), String("1"), "", loc1], this.flushBattleStat4);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost5():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession5, String("1") + "" + this.hashsession5);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession5, this.updateSequence5(), String("1"), "", loc1], this.flushBattleStat5);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost6():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession6, String("1") + "" + this.hashsession6);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession6, this.updateSequence6(), String("1"), "", loc1], this.flushBattleStat6);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost7():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession7, String("1") + "" + this.hashsession7);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession7, this.updateSequence7(), String("1"), "", loc1], this.flushBattleStat7);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost8():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession8, String("1") + "" + this.hashsession8);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession8, this.updateSequence8(), String("1"), "", loc1], this.flushBattleStat8);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost9():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession9, String("1") + "" + this.hashsession9);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession9, this.updateSequence9(), String("1"), "", loc1], this.flushBattleStat9);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function selesaihost10():void
        {
            var loc1:*;
            loc1 = new data.clientLibrary().getHash(this.hashsession10, String("1") + "" + this.hashsession10);
            new amf.amfConnect().service("ClanWar.generateBattleResult", [this.hashsession10, this.updateSequence10(), String("1"), "", loc1], this.flushBattleStat10);
            this["statusamf"].text = "ClanWar.generateBattleResult";
            return;
        }

        function flushBattleStat(arg1:Object):void
        {
            this["pesantext"].text = "[1] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost2();
            return;
        }

        function flushBattleStat2(arg1:Object):void
        {
            this["pesantext"].text = "[2] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost3();
            return;
        }

        function flushBattleStat3(arg1:Object):void
        {
            this["pesantext"].text = "[3] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost4();
            return;
        }

        function flushBattleStat4(arg1:Object):void
        {
            this["pesantext"].text = "[4] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost5();
            return;
        }

        function flushBattleStat5(arg1:Object):void
        {
            this["pesantext"].text = "[5] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost6();
            return;
        }

        function flushBattleStat6(arg1:Object):void
        {
            this["pesantext"].text = "[6] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost7();
            return;
        }

        function flushBattleStat7(arg1:Object):void
        {
            this["pesantext"].text = "[7] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost8();
            return;
        }

        function flushBattleStat8(arg1:Object):void
        {
            this["pesantext"].text = "[8] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost9();
            return;
        }

        function flushBattleStat9(arg1:Object):void
        {
            this["pesantext"].text = "[9] You Got +" + arg1.rep_gain + " Reputations";
            this.selesaihost10();
            return;
        }

        function flushBattleStat10(arg1:Object):void
        {
            this["pesantext"].text = "[10] You Got +" + arg1.rep_gain + " Reputations";
            this.manualhost1();
            return;
        }

        function go(arg1:flash.events.TimerEvent):void
        {
            this.updateTime();
            return;
        }

        function updateTime():void
        {
            this.date = new Date();
            this.seconds = this.date.getSeconds();
            this.minutes = this.date.getMinutes();
            this.hours = this.date.getHours();
            this["jam"].text = this.pad(this.hours) + " : " + this.pad(this.minutes) + " : " + this.pad(this.seconds);
            return;
        }

        function pad(arg1:Number):*
        {
            var loc1:*;
            loc1 = String(arg1);
            if (loc1.length < 2)
            {
                loc1 = "0" + loc1;
            }
            return loc1;
        }

        function changeidhost(arg1:flash.events.Event):void
        {
            this.idhost = int(this["hostclanid"].text);
            return;
        }

        function restoresemuapasukan(arg1:flash.events.MouseEvent=null):void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession1], this.RestoreStaminaResponse1);
            return;
        }

        function restoresemuapasukan2():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession2], this.RestoreStaminaResponse2);
            return;
        }

        function restoresemuapasukan3():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession3], this.RestoreStaminaResponse3);
            return;
        }

        function restoresemuapasukan4():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession4], this.RestoreStaminaResponse4);
            return;
        }

        function restoresemuapasukan5():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession5], this.RestoreStaminaResponse5);
            return;
        }

        function restoresemuapasukan6():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession6], this.RestoreStaminaResponse6);
            return;
        }

        function restoresemuapasukan7():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession7], this.RestoreStaminaResponse7);
            return;
        }

        function restoresemuapasukan8():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession8], this.RestoreStaminaResponse8);
            return;
        }

        function restoresemuapasukan9():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession9], this.RestoreStaminaResponse9);
            return;
        }

        function restoresemuapasukan10():void
        {
            new amf.amfConnect().service("ClanService.buyStamina", [this.hashsession10], this.RestoreStaminaResponse10);
            return;
        }

        function RestoreStaminaResponse1(arg1:Object):void
        {
            this.staminahost = int(this.staminahost + int(50));
            this.tokendarichar1 = int(this.tokendarichar1) - int(20);
            this["stamina"].text = String(this.staminahost);
            this["token"].text = this.tokendarichar1;
            this.restoresemuapasukan2();
            return;
        }

        function RestoreStaminaResponse2(arg1:Object):void
        {
            this.staminahost2 = int(this.staminahost2 + 50);
            this.tokendarichar2 = int(this.tokendarichar2) - int(20);
            this["stamina2"].text = String(this.staminahost2);
            this["token2"].text = this.tokendarichar2;
            this.restoresemuapasukan3();
            return;
        }

        function RestoreStaminaResponse3(arg1:Object):void
        {
            this.staminahost3 = int(this.staminahost3 + 50);
            this.tokendarichar3 = int(this.tokendarichar3) - int(20);
            this["stamina3"].text = String(this.staminahost3);
            this["token3"].text = this.tokendarichar3;
            this.restoresemuapasukan4();
            return;
        }

        function RestoreStaminaResponse4(arg1:Object):void
        {
            this.staminahost4 = int(this.staminahost4 + 50);
            this.tokendarichar4 = int(this.tokendarichar4) - int(20);
            this["stamina4"].text = String(this.staminahost4);
            this["token4"].text = this.tokendarichar4;
            this.restoresemuapasukan5();
            return;
        }

        function RestoreStaminaResponse5(arg1:Object):void
        {
            this.staminahost5 = int(this.staminahost5 + 50);
            this.tokendarichar5 = int(this.tokendarichar5) - int(20);
            this["stamina5"].text = String(this.staminahost5);
            this["token5"].text = this.tokendarichar5;
            this.restoresemuapasukan6();
            return;
        }

        function RestoreStaminaResponse6(arg1:Object):void
        {
            this.staminahost6 = int(this.staminahost6 + 50);
            this.tokendarichar6 = int(this.tokendarichar6) - int(20);
            this["stamina6"].text = String(this.staminahost6);
            this["token6"].text = this.tokendarichar6;
            this.restoresemuapasukan7();
            return;
        }

        function RestoreStaminaResponse7(arg1:Object):void
        {
            this.staminahost7 = int(this.staminahost7 + 50);
            this.tokendarichar7 = int(this.tokendarichar7) - int(20);
            this["stamina7"].text = String(this.staminahost7);
            this["token7"].text = this.tokendarichar7;
            this.restoresemuapasukan8();
            return;
        }

        function RestoreStaminaResponse8(arg1:Object):void
        {
            this.staminahost8 = int(this.staminahost8 + 50);
            this.tokendarichar8 = int(this.tokendarichar8) - int(20);
            this["stamina8"].text = String(this.staminahost8);
            this["token8"].text = this.tokendarichar8;
            this.restoresemuapasukan9();
            return;
        }

        function RestoreStaminaResponse9(arg1:Object):void
        {
            this.staminahost9 = int(this.staminahost9 + 50);
            this.tokendarichar9 = int(this.tokendarichar9) - int(20);
            this["stamina9"].text = String(this.staminahost9);
            this["token9"].text = this.tokendarichar9;
            this.restoresemuapasukan10();
            return;
        }

        function RestoreStaminaResponse10(arg1:Object):void
        {
            this.staminahost10 = int(this.staminahost10 + 50);
            this.tokendarichar10 = int(this.tokendarichar10) - int(20);
            this["stamina10"].text = String(this.staminahost10);
            this["token10"].text = this.tokendarichar10;
            this["pesantext"].text = "Semua Char Bershasil Restore !";
            return;
        }

        function attackallchar1():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina"].text == int(0))
            {
                this["stamina"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession1;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession1, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession1, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp1);
            return;
        }

        function attackallchar2():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina2"].text == int(0))
            {
                this["stamina2"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession2;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession2, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession2, this.updateSequence2(), loc2, this.idhost, "", "", false], this.attackallresp2);
            return;
        }

        function attackallchar3():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina3"].text == int(0))
            {
                this["stamina3"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession3;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession3, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession3, this.updateSequence3(), loc2, this.idhost, "", "", false], this.attackallresp3);
            return;
        }

        function attackallchar4():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina4"].text == int(0))
            {
                this["stamina4"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession4;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession4, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession4, this.updateSequence4(), loc2, this.idhost, "", "", false], this.attackallresp4);
            return;
        }

        function attackallchar5():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina5"].text == int(0))
            {
                this["stamina5"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession5;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession5, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession5, this.updateSequence5(), loc2, this.idhost, "", "", false], this.attackallresp5);
            return;
        }

        function attackallchar6():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina6"].text == int(0))
            {
                this["stamina6"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession6;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession6, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession6, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp6);
            return;
        }

        function attackallchar7():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina7"].text == int(0))
            {
                this["stamina7"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession7;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession7, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession7, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp7);
            return;
        }

        function attackallchar8():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina8"].text == int(0))
            {
                this["stamina8"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession8;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession8, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession8, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp8);
            return;
        }

        function attackallchar9():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina9"].text == int(0))
            {
                this["stamina9"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession9;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession9, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession9, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp9);
            return;
        }

        function attackallchar10():void
        {
            if (this.idhost == 0)
            {
                this["pesantext"].text = "Please Input ID Clan~";
                return;
            }
            if (this["stamina"].text == int(0))
            {
                this["stamina10"].text = "Done";
                return;
            }
            var loc1:*;
            loc1 = String(this.idhost) + "" + this.hashsession10;
            var loc2:*;
            loc2 = new data.clientLibrary().getHash(this.hashsession10, loc1);
            new amf.amfConnect().service("ClanWar.getBattleDefender", [this.hashsession10, this.updateSequence(), loc2, this.idhost, "", "", false], this.attackallresp10);
            return;
        }

        function attackallresp1(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[1] " + this["hashtime"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[1] " + this["hashtime"].text + " Attacked Quick";
            }
            this.staminahost = String(int(this.staminahost) - int(10));
            this["stamina"].text = this.staminahost;
            this.attackallchar2();
            return;
        }

        function attackallresp2(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[2] " + this["hashtime2"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[2] " + this["hashtime2"].text + " Attacked Quick";
            }
            this.staminahost2 = String(int(this.staminahost2) - int(10));
            this["stamina2"].text = this.staminahost2;
            this.attackallchar3();
            return;
        }

        function attackallresp3(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[3] " + this["hashtime3"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[3] " + this["hashtime3"].text + " Attacked Quick";
            }
            this.staminahost3 = String(int(this.staminahost3) - int(10));
            this["stamina3"].text = this.staminahost3;
            this.ClanTimer = new flash.utils.Timer(1000, 1);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.showBtnAllChar);
            this.ClanTimer.start();
            return;
        }

        function showBtnAllChar(arg1:flash.events.TimerEvent):void
        {
            this.attackallchar4();
            return;
        }

        function attackallresp4(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[4] " + this["hashtime4"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[4] " + this["hashtime4"].text + " Attacked Quick";
            }
            this.staminahost4 = String(int(this.staminahost4) - int(10));
            this["stamina4"].text = this.staminahost4;
            this.attackallchar5();
            return;
        }

        function attackallresp5(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[5] " + this["hashtime5"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[5] " + this["hashtime5"].text + " Attacked Quick";
            }
            this.staminahost5 = String(int(this.staminahost5) - int(10));
            this["stamina5"].text = this.staminahost5;
            this.ClanTimer = new flash.utils.Timer(1000, 1);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.showBtnAllCharX);
            this.ClanTimer.start();
            return;
        }

        function showBtnAllCharX(arg1:flash.events.TimerEvent):void
        {
            this.attackallchar6();
            return;
        }

        function attackallresp6(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[6] " + this["hashtime6"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[6] " + this["hashtime6"].text + " Attacked Quick";
            }
            this.staminahost6 = String(int(this.staminahost6) - int(10));
            this["stamina6"].text = this.staminahost6;
            this.attackallchar7();
            return;
        }

        function attackallresp7(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[7] " + this["hashtime7"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[7] " + this["hashtime7"].text + " Attacked Quick";
            }
            this.staminahost7 = String(int(this.staminahost7) - int(10));
            this["stamina7"].text = this.staminahost7;
            this.attackallchar8();
            return;
        }

        function attackallresp8(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[8] " + this["hashtime8"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[8] " + this["hashtime8"].text + " Attacked Quick";
            }
            this.staminahost8 = String(int(this.staminahost8) - int(10));
            this["stamina8"].text = this.staminahost8;
            this.ClanTimer = new flash.utils.Timer(1000, 1);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.XX1);
            this.ClanTimer.start();
            return;
        }

        function XX1(arg1:flash.events.TimerEvent):void
        {
            this.attackallchar9();
            return;
        }

        function attackallresp9(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[9] " + this["hashtime9"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[9] " + this["hashtime9"].text + " Attacked Quick";
            }
            this.staminahost9 = String(int(this.staminahost9) - int(10));
            this["stamina9"].text = this.staminahost9;
            this.attackallchar10();
            return;
        }

        function attackallresp10(arg1:Object):void
        {
            if (arg1.status == 0)
            {
                this["pesantext"].text = "Error !";
                return;
            }
            if (arg1.result != 1)
            {
                if (arg1.result == 2)
                {
                    this["pesantext"].text = "[10] " + this["hashtime10"].text + " +" + String(arg1.rep_gain) + " Rep";
                }
            }
            else 
            {
                this["pesantext"].text = "[10] " + this["hashtime10"].text + " Attacked Quick";
            }
            this.staminahost10 = String(int(this.staminahost10) - int(10));
            this["stamina10"].text = this.staminahost10;
            this.ClanTimer = new flash.utils.Timer(1000, 1);
            this.ClanTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.XX2);
            this.ClanTimer.start();
            return;
        }

        function XX2(arg1:flash.events.TimerEvent):void
        {
            this.attackallchar1();
            return;
        }

        public var pilihserang:flash.text.TextField;

        public var sr4:flash.text.TextField;

        public var token9:flash.text.TextField;

        public var restoreBtn:fl.controls.Button;

        public var sr5:flash.text.TextField;

        public var allBtn:fl.controls.Button;

        public var hashtime10:flash.text.TextField;

        public var stamina10:flash.text.TextField;

        public var sr10:flash.text.TextField;

        public var sr6:flash.text.TextField;

        public var passwordtxt:flash.text.TextField;

        public var sr7:flash.text.TextField;

        public var sr8:flash.text.TextField;

        public var a1:flash.text.TextField;

        public var sr9:flash.text.TextField;

        public var sr:flash.text.TextField;

        public var a2:flash.text.TextField;

        public var passwordtittle:flash.text.TextField;

        public var stamina9:flash.text.TextField;

        public var token10:flash.text.TextField;

        public var a3:flash.text.TextField;

        public var randomtext:flash.text.TextField;

        public var hashtime:flash.text.TextField;

        public var attackBtn:fl.controls.Button;

        public var stamina8:flash.text.TextField;

        public var a4:flash.text.TextField;

        public var ns_version:flash.text.TextField;

        public var a5:flash.text.TextField;

        public var hostclanid:flash.text.TextField;

        public var hashtime8:flash.text.TextField;

        public var stamina7:flash.text.TextField;

        public var token2:flash.text.TextField;

        public var token:flash.text.TextField;

        public var hashtime9:flash.text.TextField;

        public var bot:flash.text.TextField;

        public var stamina6:flash.text.TextField;

        public var token3:flash.text.TextField;

        public var hashtime6:flash.text.TextField;

        public var stamina5:flash.text.TextField;

        public var token4:flash.text.TextField;

        public var hashtime7:flash.text.TextField;

        public var statusamf:flash.text.TextField;

        public var jam:flash.text.TextField;

        public var stamina4:flash.text.TextField;

        public var token5:flash.text.TextField;

        public var hashtime4:flash.text.TextField;

        public var stamina3:flash.text.TextField;

        public var token6:flash.text.TextField;

        public var hashtime5:flash.text.TextField;

        public var loginBtn:fl.controls.Button;

        public var stamina2:flash.text.TextField;

        public var sr2:flash.text.TextField;

        public var token7:flash.text.TextField;

        public var hashtime2:flash.text.TextField;

        public var stamina:flash.text.TextField;

        public var sr3:flash.text.TextField;

        public var token8:flash.text.TextField;

        public var hashtime3:flash.text.TextField;

        public var pesantext:flash.text.TextField;

        public var amfSeq:*;

        public var amfSeq2:*;

        public var amfSeq3:*;

        public var amfSeq4:*;

        public var amfSeq5:*;

        public var amfSeq6:*;

        public var amfSeq7:*;

        public var amfSeq8:*;

        public var amfSeq9:*;

        public var amfSeq10:*;

        public var tokendarichar1:*;

        public var tokendarichar2:*;

        public var tokendarichar3:*;

        public var tokendarichar4:*;

        public var tokendarichar5:*;

        public var tokendarichar6:*;

        public var tokendarichar7:*;

        public var tokendarichar8:*;

        public var tokendarichar9:*;

        public var tokendarichar10:*;

        public var hashsession1:*;

        public var hashsession2:*;

        public var hashsession3:*;

        public var hashsession4:*;

        public var hashsession5:*;

        public var hashsession6:*;

        public var hashsession7:*;

        public var hashsession8:*;

        public var hashsession9:*;

        public var hashsession10:*;

        public var namachar1:*;

        public var namachar2:*;

        public var namachar3:*;

        public var namachar4:*;

        public var namachar5:*;

        public var namachar6:*;

        public var namachar7:*;

        public var namachar8:*;

        public var namachar9:*;

        public var namachar10:*;

        public var rollX1:*;

        public var rollX2:*;

        public var rollX3:*;

        public var rollX4:*;

        public var rollX5:*;

        public var rollX6:*;

        public var rollX7:*;

        public var rollX8:*;

        public var rollX9:*;

        public var rollX10:*;

        public var staminahost:*;

        public var staminahost2:*;

        public var staminahost3:*;

        public var staminahost4:*;

        public var staminahost5:*;

        public var staminahost6:*;

        public var staminahost7:*;

        public var staminahost8:*;

        public var staminahost9:*;

        public var staminahost10:*;

        public var idhost:*;

        public var ClanTimer:*;

        public var date:*;

        public var seconds:*;

        public var minutes:*;

        public var hours:*;
    }
}
