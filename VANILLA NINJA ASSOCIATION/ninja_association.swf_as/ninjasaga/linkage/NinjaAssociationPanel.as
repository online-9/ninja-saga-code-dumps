package ninjasaga.linkage 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import ninjasaga.*;
    import ninjasaga.data.*;
    
    public class NinjaAssociationPanel extends flash.display.MovieClip
    {
        public function NinjaAssociationPanel()
        {
            this.TIMELINE_BUTTONS = ["passportBtn", "exchangeBtn", "claimBtn"];
            this.HELPS = ["passportHelp", "crystalHelp", "bloodlineHelp"];
            super();
            addFrameScript(0, this.frame1, 55, this.frame56, 56, this.frame57, 60, this.frame61, 65, this.frame66, 70, this.frame71);
            return;
        }

        public function show(arg1:String="show"):void
        {
            this.gotoAndPlay(arg1);
			fix_error_302;
            return;
        }

        public function hide(arg1:flash.events.MouseEvent=null):void
        {
            ninjasaga.Central.panel.getInstance().hide(this);
            return;
        }

        private function initSharedButtons():void
        {
            var loc1:*;
            loc1 = 0;
            ninjasaga.Central.main.initButton(this["passportBtn"], this.Event_passportBtn, ninjasaga.data.ButtonData.HQ_EMBLEM);
            ninjasaga.Central.main.initButton(this["exchangeBtn"], this.Event_exchangeBtn, ninjasaga.data.ButtonData.BUYGOLD);
            if (ninjasaga.Central.main.Features.EVENT_MOL_CODE)
            {
                this["claimBtn"].visible = true;
                ninjasaga.Central.main.initButton(this["claimBtn"], this.Event_claimBtn, ninjasaga.Central.main.langLib.get(1860));
            }
            else 
            {
                this["claimBtn"].visible = true;
                ninjasaga.Central.main.disableButton(this["claimBtn"], this.Event_claimBtn, ninjasaga.Central.main.langLib.get(1860));
            }
            this["txt_npc_name"].text = ninjasaga.Central.main.langLib.get(17);
            this["btnExit"].addEventListener(flash.events.MouseEvent.CLICK, this.hide);
            return;
        }

        private function Event_passportBtn(arg1:flash.events.MouseEvent):void
        {
            if (this.currentLabel != ninjasaga.data.Timeline.NA_PASSPORT)
            {
                this.gotoAndStop(ninjasaga.data.Timeline.NA_PASSPORT);
            }
            return;
        }

        private function Event_exchangeBtn(arg1:flash.events.MouseEvent):void
        {
            if (this.currentLabel != ninjasaga.data.Timeline.NA_EXCHANGE)
            {
                this.gotoAndStop(ninjasaga.data.Timeline.NA_EXCHANGE);
            }
            return;
        }

        private function Event_claimBtn(arg1:flash.events.MouseEvent):void
        {
            this.hide();
            ninjasaga.Central.main.loadPopupPanel("popup_4th_claim_code", "ninjasaga.linkage.Anni4_ClaimCode");
            return;
        }

        private function Event_petBtn(arg1:flash.events.MouseEvent):void
        {
            if (this.currentLabel != ninjasaga.data.Timeline.NA_PET)
            {
                this.gotoAndStop(ninjasaga.data.Timeline.NA_PET);
            }
            return;
        }

        private function onButtons(arg1:flash.events.MouseEvent):void
        {
            var loc1:*;
            loc1 = arg1.currentTarget.name;
            switch (loc1) 
            {
                case "passportBtn":
                {
                    if (this.currentLabel != ninjasaga.data.Timeline.NA_PASSPORT)
                    {
                        this.gotoAndStop(ninjasaga.data.Timeline.NA_PASSPORT);
                    }
                    break;
                }
                case "exchangeBtn":
                {
                    if (this.currentLabel != ninjasaga.data.Timeline.NA_EXCHANGE)
                    {
                        this.gotoAndStop(ninjasaga.data.Timeline.NA_EXCHANGE);
                    }
                    break;
                }
                case "claimBtn":
                case "petBtn":
                {
                    if (this.currentLabel != ninjasaga.data.Timeline.NA_PET)
                    {
                        this.gotoAndStop(ninjasaga.data.Timeline.NA_PET);
                    }
                    break;
                }
            }
            return;
        }

        private function onShow():void
        {
            var loc2:*;
            loc2 = 0;
            this.stop();
            this["npcTxt"].text = ninjasaga.Central.main.langLib.get(13);
            var loc1:*;
            loc1 = ninjasaga.Central.main.getMainChar();
            var loc3:*;
            loc3 = loc1.getHead();
            loc3.scaleX = this.CHARACTER_HEAD_SCALING;
            loc3.scaleY = this.CHARACTER_HEAD_SCALING;
            this["headHolder"].addChild(loc3);
            this["nameTxt"].text = loc1.getData(ninjasaga.data.DBCharacterData.NAME);
            this["characteridTxt"].text = loc1.getData(ninjasaga.data.DBCharacterData.ID);
            this["rankIcon"].gotoAndStop(loc1.getData(ninjasaga.data.DBCharacterData.RANK));
            this["rankTxt"].text = String(ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.RankData.RANK_MAP[loc1.getData(ninjasaga.data.DBCharacterData.RANK)]));
            this["crystalTxt"].text = ninjasaga.Account.getAccountBalance();
            if (ninjasaga.Account.getAccountType() != ninjasaga.Account.FREE)
            {
                this["btnApply"].visible = false;
            }
            else 
            {
                ninjasaga.Central.main.initButton(this["btnApply"], this.upgradeAccount, ninjasaga.data.ButtonData.HQ_APPLYNOW);
            }
            this["lbl_NinjaEmblem"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.NINJAEMBLEM) + ":";
            this["lbl_Name"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.NAME) + ":";
            this["lbl_characterid"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.CHARACTERID) + ":";
            this["lbl_Rank"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.RANK) + ":";
            this["lbl_Token"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.TOKEN) + ":";
            this.initSharedButtons();
            return;
        }

        private function showConvertGold(arg1:flash.events.MouseEvent):void
        {
            ninjasaga.Central.main.gotoPaymentGateway();
            return;
        }

        private function onExchange():void
        {
            this.stop();
            this.initSharedButtons();
            ninjasaga.Central.main.initButton(this["convertBtn"], this.showConvertGold, ninjasaga.data.ButtonData.BUYGOLD);
            this["goldTxt"].text = String(ninjasaga.Central.main.getMainChar().getGold());
            this["lbl_ConvertTokentoGold_Title"].text = ninjasaga.Central.main.langLib.get(1367);
            this["npcTxt"].text = ninjasaga.Central.main.langLib.get(1368);
            return;
        }

        private function onBloodline():void
        {
            this.stop();
            this["npcTxt"].text = ninjasaga.Central.main.langLib.get(21);
            this["lbl_bloodline_content"].text = ninjasaga.Central.main.langLib.get(22);
            this.initSharedButtons();
            return;
        }

        private function onPet():void
        {
            this.stop();
            this["npcTxt"].text = "You can link your spirit with a creature pet so that they can trust you and assist you in battle. You need to be Level 20 before you can get your own pet.";
            this.initSharedButtons();
            return;
        }

        private function onClaim():void
        {
            this.stop();
            this.initSharedButtons();
            this["lbl_profile_title"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.CLAIM);
            this["lbl_ConvertTokentoGold_Title"].text = ninjasaga.Central.main.langLib.get(1601)[1];
            this["npcTxt"].text = ninjasaga.Central.main.langLib.get(1601)[0];
            this["renameInput"].maxChars = this.MAX_CHARS;
            ninjasaga.Central.main.initButton(this["claimItemBtn"], this.claimCode, ninjasaga.data.ButtonData.CLAIMITEM);
            return;
        }

        private function claimCode(arg1:flash.events.MouseEvent):void
        {
            if (String(this["renameInput"].text).length <= 0 || String(this["renameInput"].text).length > this.MAX_CHARS || String(this["renameInput"].text).length < this.MAX_CHARS)
            {
                ninjasaga.Central.main.showOk(String(ninjasaga.Central.main.langLib.get(1318)).replace("10", this.MAX_CHARS));
                this["renameInput"].text = "";
                return;
            }
            this.claimC = this["renameInput"].text;
            var loc1:*;
            loc1 = ninjasaga.Central.main.account.getAccountSessionKey();
            var loc2:*;
            loc2 = ninjasaga.Central.main.getHash(this.claimC);
            var loc3:*;
            loc3 = 0;
            var loc4:*;
            loc4 = 0;
            var loc5:*;
            loc5 = 0;
            if (ninjasaga.Central.main.getMainChar().getInventory(ninjasaga.data.InventoryData.TYPE_WEAPON).length + 1 >= ninjasaga.data.Data.INV_SPACE_WEAPON)
            {
                ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1575)[8]);
            }
            else 
            {
                loc3 = 1;
            }
            if (ninjasaga.Central.main.getMainChar().getInventory(ninjasaga.data.InventoryData.TYPE_BACK_ITEM).length + 1 >= ninjasaga.data.Data.INV_SPACE_BACKITEM)
            {
                ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1575)[10]);
            }
            else 
            {
                loc4 = 1;
            }
            if (ninjasaga.Central.main.account.getAccountType() != ninjasaga.Central.main.account.PREMIUM)
            {
                if (ninjasaga.Central.main.getMainChar().getInventory(ninjasaga.data.InventoryData.TYPE_ITEM).length + 6 > ninjasaga.data.Data.INV_SPACE_FREE)
                {
                    ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1575)[12]);
                    return;
                }
                loc5 = 1;
            }
            else 
            {
                if (ninjasaga.Central.main.getMainChar().getInventory(ninjasaga.data.InventoryData.TYPE_ITEM).length + 6 > ninjasaga.data.Data.INV_SPACE_PREMIUM)
                {
                    ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1575)[11]);
                    return;
                }
                loc5 = 1;
            }
            if (this.claimC != "")
            {
                if (loc3 == 1 && loc4 == 1 && loc5 == 1)
                {
                    ninjasaga.Central.main.showAmfLoading();
                    ninjasaga.Central.main.amfClient.service("SpecialReward.molPromotionGift", [loc1, loc2, this.claimC], this.ClaimItemResponse);
                }
            }
            return;
        }

        private function ClaimItemResponse(arg1:Object):void
        {
            var loc1:*;
            loc1 = 0;
            var loc2:*;
            loc2 = 0;
            ninjasaga.Central.main.hideAmfLoading();
            if (ninjasaga.Central.main.validateAmfResponse(arg1))
            {
                if (arg1.result != 1)
                {
                    ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1601)[3]);
                    this["renameInput"].text = "";
                }
                else 
                {
                    this.cardtype = arg1.card_type;
                    var loc3:*;
                    loc3 = this.cardtype;
                    switch (loc3) 
                    {
                        case 1:
                        case 5:
                        {
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 2:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_BACK_ITEM, String("back269"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 3:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_BACK_ITEM, String("back268"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 4:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_WEAPON, String("wpn799"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 6:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_BACK_ITEM, String("back302"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 7:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_BACK_ITEM, String("back303"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        case 8:
                        {
                            ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_WEAPON, String("wpn867"));
                            loc1 = 2;
                            loc2 = 0;
                            while (loc2 < loc1) 
                            {
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item41"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item45"));
                                ninjasaga.Central.main.getMainChar().addInventory(ninjasaga.data.InventoryData.TYPE_ITEM, String("item49"));
                                ++loc2;
                            }
                            if (this["renameInput"].length != 0)
                            {
                                this["popClaim"].gotoAndPlay(ninjasaga.data.Timeline.SHOW);
                            }
                            break;
                        }
                        default:
                        {
                            ninjasaga.Central.main.showOk(ninjasaga.Central.main.langLib.get(1601)[3]);
                            this["renameInput"].text = "";
                            break;
                        }
                    }
                }
            }
            return;
        }

        public function onShowClaim(arg1:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = null;
            var loc2:*;
            loc2 = null;
            var loc3:*;
            loc3 = null;
            var loc4:*;
            loc4 = null;
            var loc5:*;
            loc5 = null;
            var loc6:*;
            loc6 = null;
            var loc7:*;
            loc7 = null;
            var loc8:*;
            loc8 = null;
            arg1.stop();
            if (!arg1["panel"]["closeBtn"].hasEventListener(flash.events.MouseEvent.CLICK))
            {
                arg1["panel"]["closeBtn"].addEventListener(flash.events.MouseEvent.CLICK, this.closeClaimPop);
            }
            loc1 = new LoadingMc();
            loc2 = new LoadingMc();
            loc3 = new LoadingMc();
            loc4 = new LoadingMc();
            var loc9:*;
            loc9 = this.cardtype;
            switch (loc9) 
            {
                case 1:
                case 5:
                {
                    ninjasaga.Item.getItemIcon("item41", loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 2:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getBackItemIcon(String("back269"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_BACKITEM, String("back269"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 3:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getBackItemIcon(String("back268"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_BACKITEM, String("back268"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 4:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getWeaponIcon(String("wpn799"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_WEAPON, String("wpn799"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 6:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getBackItemIcon(String("back302"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_BACKITEM, String("back302"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 7:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getBackItemIcon(String("back303"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_BACKITEM, String("back303"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                case 8:
                {
                    arg1["panel"]["iconGroup"].gotoAndStop("reward2");
                    ninjasaga.Item.getWeaponIcon(String("wpn867"), loc1);
                    arg1["panel"]["iconGroup"]["iconMC1"]["iconHolder"].addChild(loc1);
                    arg1["panel"]["iconGroup"]["ownTxt1"].text = "";
                    ninjasaga.Item.getItemIcon("item41", loc2);
                    arg1["panel"]["iconGroup"]["iconMC2"]["iconHolder"].addChild(loc2);
                    arg1["panel"]["iconGroup"]["ownTxt2"].text = "x2";
                    ninjasaga.Item.getItemIcon("item45", loc3);
                    arg1["panel"]["iconGroup"]["iconMC3"]["iconHolder"].addChild(loc3);
                    arg1["panel"]["iconGroup"]["ownTxt3"].text = "x2";
                    ninjasaga.Item.getItemIcon("item49", loc4);
                    arg1["panel"]["iconGroup"]["iconMC4"]["iconHolder"].addChild(loc4);
                    arg1["panel"]["iconGroup"]["ownTxt4"].text = "x2";
                    loc5 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_WEAPON, String("wpn867"));
                    loc6 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item41"));
                    loc7 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item45"));
                    loc8 = ninjasaga.data.TooltipData.getItemTooltip(ninjasaga.data.TooltipData.TOOLTIP_TYPE_ITEM, String("item49"));
                    arg1["panel"]["titleTxt"].text = ninjasaga.Central.main.langLib.get(1601)[4];
                    arg1["panel"]["descTxt"].text = ninjasaga.Central.main.langLib.get(1601)[2];
                    break;
                }
                default:
                {
                    break;
                }
            }
            ninjasaga.Central.main.initButton(arg1.panel["claimOkBtn"], this.closeClaimPop, ninjasaga.data.ButtonData.CONFIRM);
            ninjasaga.Central.main.showDynamicTooltip(arg1["panel"]["iconGroup"]["iconMC1"], String("<font size=\'16\'>" + loc5 + "</font>"));
            ninjasaga.Central.main.showDynamicTooltip(arg1["panel"]["iconGroup"]["iconMC2"], String("<font size=\'16\'>" + loc6 + "</font>"));
            ninjasaga.Central.main.showDynamicTooltip(arg1["panel"]["iconGroup"]["iconMC3"], String("<font size=\'16\'>" + loc7 + "</font>"));
            if (loc8 != null)
            {
                ninjasaga.Central.main.showDynamicTooltip(arg1["panel"]["iconGroup"]["iconMC4"], String("<font size=\'16\'>" + loc8 + "</font>"));
            }
            return;
        }

        private function closeClaimPop(arg1:flash.events.MouseEvent=null):void
        {
            this.cardtype = 0;
            this["renameInput"].text = "";
            this["popClaim"].gotoAndStop(ninjasaga.data.Timeline.IDLE);
            return;
        }

        private function upgradeAccount(arg1:flash.events.MouseEvent):void
        {
            ninjasaga.Central.main.gotoPaymentGateway();
            return;
        }

        private function updateConvertedGold(arg1:flash.events.Event):void
        {
            if (int(this["crystalTxt"].text) > ninjasaga.Account.getAccountBalance())
            {
                ninjasaga.Central.main.showInfo(ninjasaga.Central.main.langLib.get(19));
                this["crystalTxt"].text = this.crystal;
                return;
            }
            this.crystal = int(this["crystalTxt"].text);
            this["goldTxt"].text = int(this["crystalTxt"].text) * ninjasaga.data.Data.CRYSTAL_TO_GOLD_RATE;
            this["totalGoldTxt"].text = ninjasaga.Central.main.langLib.titleTxt(ninjasaga.data.TitleData.TOTAL) + ":" + String(ninjasaga.Central.main.getMainChar().getGold() + int(this["crystalTxt"].text) * ninjasaga.data.Data.CRYSTAL_TO_GOLD_RATE);
            return;
        }

        private function confirmExchange(arg1:flash.events.MouseEvent):void
        {
            var loc1:*;
            loc1 = null;
            if (int(this["crystalTxt"].text) <= 0)
            {
                ninjasaga.Central.main.showInfo(ninjasaga.Central.main.langLib.get(18));
                return;
            }
            if (int(this["crystalTxt"].text) > ninjasaga.Account.getAccountBalance())
            {
                ninjasaga.Central.main.showInfo(ninjasaga.Central.main.langLib.get(19));
                return;
            }
            if (!this.connectingAmf)
            {
                this.connectingAmf = true;
                ninjasaga.Central.main.showAmfLoading();
                this.crystal = int(this["crystalTxt"].text);
                loc1 = ninjasaga.Central.main.getHash(String(this.crystal));
                ninjasaga.Central.main.amfClient.service("CharacterDAO.convertCrystal", [ninjasaga.Account.getAccountSessionKey(), int(this["crystalTxt"].text), loc1, ninjasaga.Central.main.updateSequence()], this.onExchangeResult);
            }
            return;
        }

        private function onExchangeResult(arg1:Object):void
        {
            var loc1:*;
            loc1 = null;
            if (String(arg1.status) == ninjasaga.data.AMFData.STATUS_ERROR)
            {
                ninjasaga.Central.main.onError(String(arg1.error));
                return;
            }
            if (String(arg1.status) == ninjasaga.data.AMFData.STATUS_SUCCESS)
            {
                ninjasaga.Central.main.showInfo(this.crystal + " " + ninjasaga.Central.main.langLib.get(20));
                ninjasaga.Central.main.getMainChar().updateData(ninjasaga.data.DBCharacterData.GOLD, this.crystal * 20 + ninjasaga.Central.main.getMainChar().getGold());
                ninjasaga.Account.balance = ninjasaga.Account.getAccountBalance() - this.crystal;
                loc1 = "";
                if (this.crystal <= 50)
                {
                    loc1 = "1-50";
                }
                else 
                {
                    if (this.crystal <= 100)
                    {
                        loc1 = "51-100";
                    }
                    else 
                    {
                        if (this.crystal <= 200)
                        {
                            loc1 = "101-200";
                        }
                        else 
                        {
                            if (this.crystal <= 400)
                            {
                                loc1 = "201-400";
                            }
                            else 
                            {
                                if (this.crystal <= 1000)
                                {
                                    loc1 = "401-1000";
                                }
                                else 
                                {
                                    if (this.crystal <= 5000)
                                    {
                                        loc1 = "1001-5000";
                                    }
                                    else 
                                    {
                                        loc1 = "5000+";
                                    }
                                }
                            }
                        }
                    }
                }
                ninjasaga.Central.main.tracking.trackSale(ninjasaga.Central.main.tracking.SALE_CONVERT_TOKEN, loc1, this.crystal);
                this.crystal = 0;
                this["crystalTxt"].text = "0";
                this.onExchange();
                ninjasaga.Central.main.hideAmfLoading();
                this.connectingAmf = false;
            }
            return;
        }

        function frame1():*
        {
            this.stop();
            return;
        }

        function frame56():*
        {
            this.onShow();
            return;
        }

        function frame57():*
        {
            this.onExchange();
            return;
        }

        function frame61():*
        {
            this.onBloodline();
            return;
        }

        function frame66():*
        {
            this.onPet();
            return;
        }

        function frame71():*
        {
            this.onClaim();
            return;
        }

        private const CHARACTER_HEAD_SCALING:Number=4;

        private const TIMELINE_BUTTONS:Array=["passportBtn", "exchangeBtn", "claimBtn"];

        private const HELPS:Array=["passportHelp", "crystalHelp", "bloodlineHelp"];

        public var claimItemBtn:flash.display.MovieClip;

        public var rankIcon:flash.display.MovieClip;

        public var passportBtn:flash.display.MovieClip;

        public var txt_npc_name:flash.text.TextField;

        public var lbl_ConvertTokentoGold_Title:flash.text.TextField;

        public var convertBtn:flash.display.MovieClip;

        public var lbl_Rank:flash.text.TextField;

        public var goldTxt:flash.text.TextField;

        public var exchangeBtn:flash.display.MovieClip;

        public var lbl_Name:flash.text.TextField;

        public var characteridTxt:flash.text.TextField;

        public var npcTxt:flash.text.TextField;

        public var card:flash.display.MovieClip;

        public var renameInput:flash.text.TextField;

        public var lbl_NinjaEmblem:flash.text.TextField;

        public var lbl_characterid:flash.text.TextField;

        public var lbl_pet_content:flash.text.TextField;

        public var btnExit:flash.display.SimpleButton;

        public var lbl_bloodline_content:flash.text.TextField;

        public var lbl_Token:flash.text.TextField;

        public var rankTxt:flash.text.TextField;

        public var headHolder:flash.display.MovieClip;

        public var lbl_profile_title:flash.text.TextField;

        public var popClaim:flash.display.MovieClip;

        public var btnApply:flash.display.MovieClip;

        public var claimBtn:flash.display.MovieClip;

        public var crystalTxt:flash.text.TextField;

        public var nameTxt:flash.text.TextField;

        private var claimC:String;

        private var MAX_CHARS:int=16;

        private var crystal:uint=0;

        private var connectingAmf:Boolean=false;

        private var cardtype:int;

        public static var langLib:flash.display.MovieClip;
    }
}
