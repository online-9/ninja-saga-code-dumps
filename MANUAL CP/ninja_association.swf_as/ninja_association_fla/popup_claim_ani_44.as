package ninja_association_fla 
{
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.globalization.*;
    import flash.media.*;
    import flash.net.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.system.*;
    import flash.text.*;
    import flash.text.engine.*;
    import flash.text.ime.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;
    
    public dynamic class popup_claim_ani_44 extends flash.display.MovieClip
    {
        public function popup_claim_ani_44()
        {
            super();
            addFrameScript(0, this.frame1, 6, this.frame7, 25, this.frame26);
            return;
        }

        function frame1():*
        {
            this.stop();
            return;
        }

        function frame7():*
        {
            flash.display.MovieClip(parent).onShowClaim(this);
            return;
        }

        function frame26():*
        {
            this.gotoAndStop("idle");
            return;
        }

        public var panel:flash.display.MovieClip;
    }
}
