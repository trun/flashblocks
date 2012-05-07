package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.*;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class CommandBlock extends SimpleBlock {

        public function CommandBlock() {
            super();

            socketType = SocketType.SQUARE;
            blockType = BlockType.COMMAND;
        }

        override public function redraw():void {
            super.redraw();

            topMidBox.removeAllChildren();
            topMidBox.addChild(new BlockNotchTop(blockColor));
            topMidBox.addChild(new BlockFlatTop(blockColor));

            bottomMidBox.removeAllChildren();
            bottomMidBox.addChild(new BlockNotchBottom(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));
        }

        override public function connectBefore(block:Block):void {
            if (before) {
                before.connectAfter(block);
            } else {
                parent.addChild(block);
                block.x = this.x;
                block.y = this.y - block.height;
            }

            block.connectAfter(this);
        }

        override public function connectAfter(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = hbox.height;

            if (after)
                block.connectAfter(after);

            block.before = this;
            this.after = block;
        }

        override public function testBeforeConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;
            if (block.after != null)
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this.parent);

            return hbox.hitTestObject(block) && (p.y < this.y);
        }

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function hasBefore():Boolean {
            return true;
        }

        override public function hasAfter():Boolean {
            return true;
        }

    }

}
