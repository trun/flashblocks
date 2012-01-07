package com.flashblocks {
    import com.flashblocks.blocks.AnchorBlock;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockFactory;
    import com.flashblocks.util.BlockUtil;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import mx.containers.Canvas;
    import mx.containers.VBox;
    import mx.core.Container;
    import mx.events.DragEvent;
    import mx.managers.DragManager;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class Page extends Canvas implements IWorkspaceWidget {

        protected var workspace:Workspace;

        public function Page() {
            super();

            percentWidth = 100;
            percentHeight = 100;

            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);
            setStyle("backgroundColor", "#FFFFFF");
        }

        /* INTERFACE com.flashblocks.IBlockContainer */

        public function addBlock(block:Block):void {
            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            block.enableConnections = true;

            var child:Block;
            for each (child in getAllBlocks()) {
                cleanConnections(child);
            }

            var connected:Boolean = false;
            if (block.enableConnections) {
                for each (child in getAllBlocks()) {
                    if (tryConnection(child, block)) {
                        connected = true;
                        break;
                    }
                }
            }

            if (!connected) {
                addChild(block);

                if (p.x < 0)
                    p.x = 0;
                if (p.y < 0)
                    p.y = 0;

                block.x = p.x;
                block.y = p.y;
            }
        }

        private function cleanConnections(block:Block):void {
            if (block.youngerSibling) {
                if (block.contains(block.youngerSibling)) {
                    cleanConnections(block.youngerSibling);
                } else {
                    block.youngerSibling = null;
                }
            }

            if (block.olderSibling && !block.olderSibling.contains(block)) {
                block.olderSibling = null;
            }

            if (block.internalBlock) {
                if (block.contains(block.internalBlock)) {
                    cleanConnections(block.internalBlock);
                } else {
                    block.internalBlock = null;
                }
            }

            var nestedBlocks:Array = new Array();
            for (var i:uint = 0; i < block.nestedBlocks.length; i++) {
                var child:Block = block.nestedBlocks[i];
                if (child) {
                    if (block.contains(child)) {
                        cleanConnections(child);
                        nestedBlocks[i] = child;
                    } else {
                        nestedBlocks[i] = null;
                    }
                }
            }
            block.nestedBlocks = nestedBlocks;

            for each (var arg:Block in block.getArguments()) {
                cleanConnections(arg);
            }
        }

        private function tryConnection(child:Block, block:Block):Boolean {
            if (!child.enableConnections)
                return false;

            if (child.hasYoungerSiblingPort()) {
                if (child.testYoungerSiblingConnection(block)) {
                    child.connectYoungerSibling(block);
                    return true;
                }
            }

            if (child.hasOlderSiblingPort() && child.olderSibling == null) {
                if (child.testOlderSiblingConnection(block)) {
                    child.connectOlderSibling(block);
                    return true;
                }
            }

            for each (var arg:Block in child.getArguments()) {
                if (arg.enableConnections && arg.testInternalConnection(block)) {
                    arg.connectInternalBlock(block);
                    return true;
                }

                if (arg.internalBlock) {
                    if (tryConnection(arg.internalBlock, block)) {
                        return true;
                    }
                }
            }

            if (child.youngerSibling != null) {
                if (tryConnection(child.youngerSibling, block)) {
                    return true;
                }
            }

            for each (var nested:Block in child.nestedBlocks) {
                if (tryConnection(nested, block)) {
                    return true;
                }
            }

            if (child.hasNestedPort()) {
                if (child.testNestedConnection(block)) {
                    child.connectNestedBlock(block);
                    return true;
                }
            }

            return false;
        }

        public function removeBlock(block:Block):void {
            block.enableConnections = false;
            removeChild(block);
        }

        public function getAllBlocks():Array {
            return getChildren();
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void {
            this.workspace = workspace;
        }

    }

}
