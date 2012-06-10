package com.flashblocks.blocks.args {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.blocks.SimpleBlock;
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.events.BlockConnectionEvent;

    import flash.filters.BevelFilter;
    import flash.filters.GlowFilter;

    import mx.controls.Spacer;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ArgumentBlock extends SimpleBlock {
        private const BASE_FILTERS:Array = [ new BevelFilter(2, -45) ];

        public function ArgumentBlock(blockName:String, defaultValue:*=null) {
            super(blockName, defaultValue);

            blockColor = 0xFFFFFF;

            blockType = BlockType.ARGUMENT;
            socketType = SocketType.ROUND;

            enableConnections = true;
        }

        override public function redraw():void {
            super.redraw();


            topMidBox.removeAllChildren();
            topMidBox.addChild(new BlockFlatTop(blockColor));

            bottomMidBox.removeAllChildren();
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            var spacer:Spacer = new Spacer();
            spacer.height = 10;
            spacer.width = 10;

            addContent(spacer);

            hbox.filters = BASE_FILTERS;
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

        override public function overInner(block:Block):void {
            hbox.filters = BASE_FILTERS.concat([ new GlowFilter(0x00FFFF, 1.0, 2, 2, 255, 3, true) ]);
        }

        override public function outInner(block:Block):void {
            hbox.filters = BASE_FILTERS;
        }

        private function onBlockDisconnect(e:BlockConnectionEvent):void {
            hbox.visible = hbox.includeInLayout = true;
            inner.removeEventListener(BlockConnectionEvent.DISCONNECT, onBlockDisconnect);
        }
    }

}
