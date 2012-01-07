package com.flashblocks.events {
    import com.flashblocks.blocks.Block;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockDragEvent extends Event {

        public static const DRAG_START:String = "dragStart";
        public static const DRAG_COMPLETE:String = "dragComplete";
        public static const DRAG_DROP:String = "dragDrop";

        public var block:Block;
        public var parent:DisplayObjectContainer;

        public function BlockDragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, block:Block=null, parent:DisplayObjectContainer=null) {
            super(type, bubbles, cancelable);
            this.block = block;
            this.parent = parent;
        }

        public override function clone():Event {
            return new BlockDragEvent(type, bubbles, cancelable, block, parent);
        }

        public override function toString():String {
            return formatToString("BlockDragEvent", "type", "bubbles", "cancelable", "eventPhase");
        }

    }

}
