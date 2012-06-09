package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.*;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;

    import flash.events.Event;
    import flash.geom.Point;

    import mx.binding.utils.ChangeWatcher;
    import mx.containers.Canvas;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class CommandBlock extends SimpleBlock {

        private var marker:Canvas;
        private var widthWatcher:ChangeWatcher;

        public function CommandBlock(blockName:String) {
            super(blockName);

            socketType = SocketType.SQUARE;
            blockType = BlockType.COMMAND;

            marker = new Canvas();
            marker.height = 5;
            marker.setStyle("backgroundColor", 0x00FFFF);
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

            if (after) {
                var lastBlock:Block = block;
                while (lastBlock.after != null) {
                    lastBlock = lastBlock.after;
                }
                lastBlock.connectAfter(after);
            }

            block.before = this;
            this.after = block;
        }

        override public function overBefore(block:Block):void {
            addChild(marker);
            marker.x = 0;
            marker.y = 0;
            marker.width = hbox.width;
        }

        override public function overAfter(block:Block):void {
            addChild(marker);
            marker.x = 0;
            marker.y = hbox.height;
            marker.width = hbox.width;
        }

        override public function outBefore(block:Block):void {
            if (marker.parent == this)
                removeChild(marker);
        }

        override public function outAfter(block:Block):void {
            if (marker.parent == this)
                removeChild(marker);
        }

        override public function testBeforeConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;
            if (block.after != null)
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this.parent);
            var centerX:Number = p.x + block.width / 2;
            var bottomY:Number = p.y + block.height;

            return bottomY < this.y && bottomY > this.y - 20
                    && centerX >= x && centerX <= x + hbox.width;
        }

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);
            var centerX:Number = p.x + block.width / 2;

            return p.y >= hbox.height && p.y < hbox.height + 20
                    && centerX >= 0 && centerX <= hbox.width;
        }

        override public function hasBefore():Boolean {
            return true;
        }

        override public function hasAfter():Boolean {
            return true;
        }

    }

}
