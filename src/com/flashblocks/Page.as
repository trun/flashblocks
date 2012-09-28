package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.util.BlockUtil;

    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.setInterval;

    import mx.containers.Canvas;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponent;
    import mx.events.ScrollEvent;
    import mx.graphics.ImageSnapshot;

    public class Page extends Canvas implements IWorkspaceWidget {

        protected var workspace:Workspace;
        private var hoverChild:Block;
        private var snapshot:UIComponent;

        public function Page() {
            super();

            percentWidth = 100;
            percentHeight = 100;

            setStyle("backgroundColor", 0xFFFFFF);

            verticalScrollPolicy = ScrollPolicy.OFF;
            horizontalScrollPolicy = ScrollPolicy.OFF;

            /*
            // snapshot based scrolling
            snapshot = new Canvas();
            snapshot.width = 50;
            snapshot.height = 100;
            snapshot.includeInLayout = false;
            addChild(snapshot);

            var page:Page = this;
            setInterval(function():void {
                removeChild(snapshot);

                var m:Matrix = new Matrix();
                var sx:Number = snapshot.width / page.width;
                m.scale(sx, sx);
                snapshot.height = page.height * sx;

                var g:Graphics = snapshot.graphics;
                g.clear();
                g.beginBitmapFill(ImageSnapshot.captureBitmapData(page, m));
                g.drawRect(0, 0, snapshot.width, snapshot.height);
                g.endFill();

                snapshot.x = width - snapshot.width - 10;
                snapshot.y = 10;
                addChild(snapshot);
            }, 1000);
            */

            scrollRect = new Rectangle();
            addEventListener(Event.RESIZE, function(e:Event):void {
                scrollRect = new Rectangle(scrollRect.x, scrollRect.y, width, height);
            });
            addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void {
                var calcHeight:Number = 0;
                for each (var block:Block in getAllBlocks()) {
                    calcHeight = Math.max(block.y + block.height, calcHeight);
                }
                var scrollY:Number = verticalScrollPosition - verticalLineScrollSize * e.delta;
                scrollY = Math.max(scrollY, 0);
                scrollY = Math.min(scrollY, calcHeight);
                verticalScrollPosition = scrollY;
            });
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
                cleanConnections(block);

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
                    if (hoverChild)
                        hoverChild.outInner(block);
                    arg.overInner(block);
                    hoverChild = arg;
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
                    if (hoverChild)
                        hoverChild.outNested(i, block);
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
                hoverChild.outNested(0, block);
                hoverChild.outInner(block);
                hoverChild = null;
            }
        }

        public function dragExitBlock(block:Block):void {
            if (hoverChild) {
                hoverChild.outBefore(block);
                hoverChild.outAfter(block);
                hoverChild.outNested(0, block);
                hoverChild.outInner(block);
            }
        }

        public function getAllBlocks():Array {
            return getChildren().filter(function(item:*, index:int, array:Array):Boolean {
                return item is Block;
            });
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void {
            this.workspace = workspace;
        }

    }

}
