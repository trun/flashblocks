package com.flashblocks.events {
    import flash.events.Event;

    /**
     * ...
     * @author ...
     */
    public class BlockConnectionEvent extends Event {

        public static const CONNECT:String = "connect";
        public static const DISCONNECT:String = "disconnect";

        public function BlockConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }

        public override function clone():Event {
            return new BlockConnectionEvent(type, bubbles, cancelable);
        }

        public override function toString():String {
            return formatToString("BlockConnectionEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

    }

}
