package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.*;

    /**
     * A control logic block for logic statements with a single inner stack,
     * such as "if" or "while". More complex examples such as "if-else" or
     * "switch" require a more complex block construction.
     */
    public class SingleLogicBlock extends LogicBlock {

        public function SingleLogicBlock(blockName:String) {
            super(blockName);
        }

        override public function redraw():void {
            super.redraw();

            topTopLineBox.removeAllChildren();
            topTopLineBox.addChild(new BlockNotchTop(blockColor));
            topTopLineBox.addChild(new BlockFlatTop(blockColor));

            bottomBottomLineBox.removeAllChildren();
            bottomBottomLineBox.addChild(new BlockNotchBottom(blockColor));
            bottomBottomLineBox.addChild(new BlockFlatBottom(blockColor));

            var flatBottom:BlockRender = new BlockFlatBottom(blockColor);
            flatBottom.width = 30;
            topNestedLineBox.removeAllChildren();
            topNestedLineBox.addChild(flatBottom);
            topNestedLineBox.addChild(new BlockNotchBottom(blockColor));
            topNestedLineBox.addChild(new BlockFlatBottom(blockColor));

            var flatTop:BlockRender = new BlockFlatTop(blockColor);
            flatTop.width = 30;
            bottomNestedLineBox.removeAllChildren();
            bottomNestedLineBox.addChild(flatTop);
            bottomNestedLineBox.addChild(new BlockNotchTop(blockColor));
            bottomNestedLineBox.addChild(new BlockFlatTop(blockColor));
        }

    }

}
