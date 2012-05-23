package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockCapTop;
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockNotchBottom;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;
    import mx.containers.VBox;
    import mx.controls.Spacer;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ProcedureBlock extends SimpleBlock {

        protected var connectionTarget:VBox;

        public function ProcedureBlock(blockName:String) {
            super(blockName);

            blockType = BlockType.PROCEDURE;
            socketType = SocketType.ROUND;

            topMidBox.addChild(new BlockCapTop(blockColor));

            bottomMidBox.addChild(new BlockNotchBottom(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            var leftSpacer:Spacer = new Spacer();
            leftSpacer.height = 10;
            leftBox.addChildAt(leftSpacer, 0);

            var rightSpacer:Spacer = new Spacer();
            rightSpacer.height = 10;
            rightBox.addChildAt(rightSpacer, 0);

            //centerMidBox.setStyle("paddingRight", 15);
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

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function hasAfter():Boolean {
            return true;
        }

    }

}
