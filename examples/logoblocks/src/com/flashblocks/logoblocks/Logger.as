package com.flashblocks.logoblocks {
    import flash.external.ExternalInterface;

    public class Logger {

        public static function log(msg:String):void {
            ExternalInterface.call("console.log('" + msg + "')");
        }

    }
}
