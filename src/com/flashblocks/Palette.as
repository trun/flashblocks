package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.FactoryBlock;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;
    import mx.containers.VBox;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class Palette extends VBox implements IWorkspaceWidget {

        private var workspace:Workspace;

        public function Palette() {
            super();

            percentWidth = 100;
            percentHeight = 100;
            clipContent = true;
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);
            setStyle("backgroundColor", "#FFFFFF");
            setStyle("verticalGap", 10);
        }

        /* INTERFACE com.flashblocks.IBlockContainer */

        public function addBlock(block:Block):void {
            // unstack after blocks
            if (block.after) {
                addBlock(block.after);
            }

            // unstack nested blocks
            var i:uint;
            for (i = 0; i < block.numNested(); i++) {
                if (block.nested[i]) {
                    addBlock(block.nested[i]);
                }
            }

            // unstack arguments
            for each (var arg:Block in block.getArguments()) {
                if (arg.inner) {
                    addBlock(arg.inner);
                }
            }

            // replenish block factories
            if (addBlockToFactory(block)) {
                return;
            }

            addBlockToPalette(block);
        }

        public function removeBlock(block:Block):void {
            removeChild(block);
        }

        public function dragEnterBlock(block:Block):void {
            // TODO
        }

        public function dragExitBlock(block:Block):void {
            // TODO
        }

        public function getAllBlocks():Array{
            return getChildren();
        }

        public function addBlockToFactory(block:Block):Boolean {
            for each (var child:Block in getAllBlocks()) {
                if (child is FactoryBlock && child.blockName == block.blockName) {
                    (child as FactoryBlock).incrementCount();
                    block.parent.removeChild(block);
                    workspace.deregisterBlock(block);
                    return true;
                }
            }

            return false;
        }

        public function addBlockToPalette(block:Block):Boolean {
            // insert block into display list at estimated position
            if (block.parent) {
                var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

                for (var i:uint = 0; i < numChildren; i++) {
                    if (p.y <= getChildAt(i).y) {
                        return addChildAt(block, i) as Boolean;
                    }
                }
            }

            // insert block into display list at end
            return addChild(block) as Boolean;
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void{
            this.workspace = workspace;
        }

    }

}
