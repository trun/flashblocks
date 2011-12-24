package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.util.BlockUtil;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import mx.containers.VBox;
    import mx.core.Container;
    import mx.core.DragSource;
    import mx.effects.Move;
    import mx.events.DragEvent;
    import mx.managers.DragManager;

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
            var inserted:Boolean = false;

            if (block.parent) {
                var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

                for (var i:uint = 0; i < numChildren; i++) {
                    if (p.y <= getChildAt(i).y) {
                        inserted = true;
                        addChildAt(block, i);
                        break;
                    }
                }
            }

            if (!inserted)
                addChild(block);
        }

        public function removeBlock(block:Block):void {
            removeChild(block);
        }

        public function getAllBlocks():Array{
            return getChildren();
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void{
            this.workspace = workspace;
        }

    }

}
