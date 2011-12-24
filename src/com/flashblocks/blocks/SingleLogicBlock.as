package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.*;

    /**
     * A control logic block for logic statements with a single inner stack,
     * such as "if" or "while". More complex examples such as "if-else" or
     * "switch" require a more complex block construction.
     */
    public class SingleLogicBlock extends ControlLogicBlock {

        public function SingleLogicBlock(socketType:String="square", color:uint=0xCCCC00) {
            super(socketType, color);

            blockType = BlockType.CONTROL;

            topTopLineBox.addChild(new BlockNotchTop(blockColor));
            topTopLineBox.addChild(new BlockFlatTop(blockColor));

            bottomBottomLineBox.addChild(new BlockNotchBottom(blockColor));
            bottomBottomLineBox.addChild(new BlockFlatBottom(blockColor));

            var flatBottom:BlockRender = new BlockFlatBottom(blockColor)
            flatBottom.width = 30;
            topNestedLineBox.addChild(flatBottom);
            topNestedLineBox.addChild(new BlockNotchBottom(blockColor));
            topNestedLineBox.addChild(new BlockFlatBottom(blockColor));

            var flatTop:BlockRender = new BlockFlatTop(blockColor)
            flatTop.width = 30;
            bottomNestedLineBox.addChild(flatTop);
            bottomNestedLineBox.addChild(new BlockNotchTop(blockColor));
            bottomNestedLineBox.addChild(new BlockFlatTop(blockColor));
        }

    }

}
