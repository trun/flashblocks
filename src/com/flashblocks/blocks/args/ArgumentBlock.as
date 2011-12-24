package com.flashblocks.blocks.args {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.SimpleBlock;
    import com.flashblocks.events.BlockConnectionEvent;
    import flash.filters.BevelFilter;
    import mx.containers.HBox;
    import mx.controls.Label;
    import mx.controls.Spacer;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ArgumentBlock extends SimpleBlock {

        public function ArgumentBlock(socketType:String="round", blockColor:uint=0xEEEEEE) {
            super(socketType, "", blockColor);

            blockType = BlockType.ARGUMENT;

            topMidBox.addChild(new BlockFlatTop(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            var spacer:Spacer = new Spacer();
            spacer.height = 10;
            spacer.width = 10;

            addContent(spacer);

            hbox.filters = [ new BevelFilter(2, -45) ]; // inset bevel

            enableConnections = true;
        }

        override public function hasInternalPort():Boolean {
            return true;
        }

        override public function testInternalConnection(block:Block):Boolean {
            return hitTestObject(block) && !internalBlock && block.blockType == BlockType.REPORTER;
        }

        override public function connectInternalBlock(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = 0;

            hbox.visible = hbox.includeInLayout = false;
            internalBlock = block;

            block.addEventListener(BlockConnectionEvent.DISCONNECT, onBlockDisconnect);
        }

        private function onBlockDisconnect(e:BlockConnectionEvent):void {
            hbox.visible = hbox.includeInLayout = true;
            internalBlock.removeEventListener(BlockConnectionEvent.DISCONNECT, onBlockDisconnect);
        }

    }

}
