package com.flashblocks {
    import com.flashblocks.IWorkspaceWidget;
    import com.flashblocks.blocks.Block;

    import mx.containers.HBox;
    import mx.containers.ViewStack;
    import mx.controls.LinkBar;
    import mx.controls.VRule;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class PaletteList extends HBox implements IWorkspaceWidget {

        private var tabStack:LinkBar;
        private var viewStack:ViewStack;
        private var workspace:Workspace;

        public function PaletteList() {
            super();

            setStyle("borderStyle", "solid");
            setStyle("verticalAlign", "middle");
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);

            viewStack = new ViewStack();
            viewStack.width = 200;
            viewStack.percentHeight = 100;

            tabStack = new LinkBar();
            tabStack.percentHeight = 100;
            tabStack.dataProvider = viewStack;
            tabStack.direction = "vertical";
            addChild(tabStack);

            var vrule:VRule = new VRule();
            vrule.percentHeight = 95;
            addChild(vrule);

            addChild(viewStack);
        }

        public function addPalette(palette:Palette):void {
            viewStack.addChild(palette);
        }

        public function registerWorkspace(workspace:Workspace):void {
            this.workspace = workspace;
        }

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

            var palette:Palette;
            for each (palette in viewStack.getChildren()) {
                if (palette.addBlockToFactory(block)) {
                    return;
                }
            }

            for each (palette in viewStack.getChildren()) {
                if (palette.addBlockToPalette(block)) {
                    return;
                }
            }
        }

        public function removeBlock(block:Block):void {
            // do nothing
        }

        public function dragEnterBlock(block:Block):void {
            // TODO: show trash
        }

        public function dragExitBlock(block:Block):void {
            // TODO: hide trash
        }

        public function getAllBlocks():Array {
            var allBlocks:Array = [];
            for each (var palette:Palette in viewStack) {
                allBlocks = allBlocks.concat(palette.getAllBlocks());
            }
            return allBlocks;
        }
    }

}
