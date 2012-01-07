package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ReporterBlock extends SimpleBlock {

        public function ReporterBlock(socketType:String="angle", blockColor:uint = 0xFFFFFF) {
            super(socketType, "", blockColor);

            blockType = BlockType.REPORTER;

            topMidBox.addChild(new BlockFlatTop(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));
        }

    }

}
