package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.sockets.SocketType;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ReporterBlock extends SimpleBlock {

        public function ReporterBlock(blockName:String, blockValue:*=null) {
            super(blockName, blockValue);

            socketType = SocketType.ANGLE;
            blockType = BlockType.REPORTER;
        }

        override public function redraw():void {
            super.redraw();

            topMidBox.addChild(new BlockFlatTop(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));
        }

    }

}
