﻿package com.flashblocks.blocks.args {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.blocks.SimpleBlock;
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.events.BlockConnectionEvent;

    import flash.filters.BevelFilter;
    import flash.utils.getQualifiedClassName;

    import mx.controls.Spacer;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ArgumentBlock extends SimpleBlock {

        public function ArgumentBlock(defaultValue:*=null) {
            super(defaultValue);

            blockType = BlockType.ARGUMENT;
            socketType = SocketType.ROUND;

            topMidBox.addChild(new BlockFlatTop(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            var spacer:Spacer = new Spacer();
            spacer.height = 10;
            spacer.width = 10;

            addContent(spacer);

            hbox.filters = [ new BevelFilter(2, -45) ]; // inset bevel

            enableConnections = true;
        }

        override public function hasInner():Boolean {
            return true;
        }

        override public function testInnerConnection(block:Block):Boolean {
            return hitTestObject(block) && !inner && block.blockType == BlockType.REPORTER;
        }

        override public function connectInner(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = 0;

            hbox.visible = hbox.includeInLayout = false;
            inner = block;

            block.addEventListener(BlockConnectionEvent.DISCONNECT, onBlockDisconnect);
        }

        override public function toJSON():Object {
            var o:Object = {
                name: getQualifiedClassName(this)
            };
            if (inner) {
                o.value = inner.toJSON();
                o.type = 'block';
            } else {
                o.value = getValue();
                o.type = typeof(o.value);
            }
            return o;
        }

        private function onBlockDisconnect(e:BlockConnectionEvent):void {
            hbox.visible = hbox.includeInLayout = true;
            inner.removeEventListener(BlockConnectionEvent.DISCONNECT, onBlockDisconnect);
        }
    }

}
