package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;
    import mx.containers.Canvas;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class Page extends Canvas implements IWorkspaceWidget {

        protected var workspace:Workspace;
        private var hoverChild:Block;

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
            if (block.after) {
                if (block.contains(block.after)) {
                    cleanConnections(block.after);
                } else {
                    block.after = null;
                }
            }

            if (block.before && !block.before.contains(block)) {
                block.before = null;
            }

            if (block.inner) {
                if (block.contains(block.inner)) {
                    cleanConnections(block.inner);
                } else {
                    block.inner = null;
                }
            }

            for (var i:uint = 0; i < block.nested.length; i++) {
                var child:Block = block.nested[i];
                if (child) {
                    if (block.contains(child)) {
                        cleanConnections(child);
                    } else {
                        block.nested[i] = null;
                    }
                }
            }

            for each (var arg:Block in block.getArguments()) {
                cleanConnections(arg);
            }
        }

        private function tryConnection(child:Block, block:Block):Boolean {
            if (!child.enableConnections)
                return false;

            if (child.hasAfter()) {
                if (child.testAfterConnection(block)) {
                    child.connectAfter(block);
                    return true;
                }
            }

            if (child.hasBefore() && child.before == null) {
                if (child.testBeforeConnection(block)) {
                    child.connectBefore(block);
                    return true;
                }
            }

            for each (var arg:Block in child.getArguments()) {
                if (arg.enableConnections && arg.testInnerConnection(block)) {
                    arg.connectInner(block);
                    return true;
                }

                if (arg.inner) {
                    if (tryConnection(arg.inner, block)) {
                        return true;
                    }
                }
            }

            if (child.after != null) {
                if (tryConnection(child.after, block)) {
                    return true;
                }
            }

            for each (var nested:Block in child.nested) {
                if (nested && tryConnection(nested, block)) {
                    return true;
                }
            }

            for (var i:uint = 0; i < child.numNested(); i++) {
                if (child.testNestedConnection(i, block)) {
                    child.connectNested(i, block);
                    return true;
                }
            }

            return false;
        }

        private function tryHoverConnection(child:Block, block:Block):Boolean {
            if (!child.enableConnections)
                return false;

            if (child.hasAfter()) {
                if (child.testAfterConnection(block)) {
                    if (hoverChild)
                        hoverChild.outAfter(block);
                    child.overAfter(block);
                    hoverChild = child;
                    return true;
                }
            }

            if (child.hasBefore() && child.before == null) {
                if (child.testBeforeConnection(block)) {
                    if (hoverChild)
                        hoverChild.outBefore(block);
                    child.overBefore(block);
                    hoverChild = child;
                    return true;
                }
            }

            for each (var arg:Block in child.getArguments()) {
                if (arg.enableConnections && arg.testInnerConnection(block)) {
                    arg.overInner(block);
                    hoverChild = child;
                    return true;
                }

                if (arg.inner) {
                    if (tryHoverConnection(arg.inner, block)) {
                        return true;
                    }
                }
            }

            if (child.after != null) {
                if (tryHoverConnection(child.after, block)) {
                    return true;
                }
            }

            for each (var nested:Block in child.nested) {
                if (nested && tryHoverConnection(nested, block)) {
                    return true;
                }
            }

            for (var i:uint = 0; i < child.numNested(); i++) {
                if (child.testNestedConnection(i, block)) {
                    child.overNested(i, block);
                    hoverChild = child;
                    return true;
                }
            }

            return false;
        }

        public function removeBlock(block:Block):void {
            block.enableConnections = false;
            removeChild(block);
        }

        public function dragEnterBlock(block:Block):void {
            for each (var child:Block in getAllBlocks()) {
                if (tryHoverConnection(child, block)) {
                    return;
                }
            }

            if (hoverChild) {
                hoverChild.outBefore(block);
                hoverChild.outAfter(block);
                hoverChild = null;
            }
        }

        public function dragExitBlock(block:Block):void {
            if (hoverChild) {
                hoverChild.outBefore(block);
                hoverChild.outAfter(block);
            }
            // TODO all out calls
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
