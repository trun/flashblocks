package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockCapTop;
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockNotchBottom;
    import com.flashblocks.blocks.render.RenderConstants;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;

    import mx.containers.Canvas;
    import mx.containers.VBox;
    import mx.controls.Spacer;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ProcedureBlock extends SimpleBlock {
        private var marker:Canvas;

        public function ProcedureBlock(blockName:String) {
            super(blockName);

            blockType = BlockType.PROCEDURE;
            socketType = SocketType.ROUND;

            marker = new Canvas();
            marker.height = 5;
            marker.setStyle("backgroundColor", 0x00FFFF);
        }

        override public function redraw():void {
            super.redraw();

            topMidBox.addChild(new BlockCapTop(blockColor));

            bottomMidBox.addChild(new BlockNotchBottom(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            var leftSpacer:Spacer = new Spacer();
            leftSpacer.height = 10;
            leftBox.addChildAt(leftSpacer, 0);

            var rightSpacer:Spacer = new Spacer();
            rightSpacer.height = 10;
            rightBox.addChildAt(rightSpacer, 0);
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

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);
            var centerX:Number = p.x + RenderConstants.NOTCH_OFFSET + RenderConstants.NOTCH_OFFSET / 2;

            return p.y >= hbox.height && p.y < hbox.height + 20
                    && centerX >= -30 && centerX <= hbox.width;
        }

        override public function overAfter(block:Block):void {
            addChild(marker);
            marker.x = 15;
            marker.y = hbox.height;
            marker.width = hbox.width - 30;
        }

        override public function outAfter(block:Block):void {
            if (marker.parent == this)
                removeChild(marker);
        }

        override public function hasAfter():Boolean {
            return true;
        }

    }

}
