package com.flashblocks.blocks {
    import com.flashblocks.blocks.args.ArgumentBlock;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.events.BlockConnectionEvent;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.blocks.sockets.Socket;
    import com.flashblocks.blocks.sockets.SocketFactory;
    import com.flashblocks.util.BlockUtil;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.geom.Point;
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.HBox;
    import mx.containers.VBox;

    /**
     *   _______________________
     *  |_______________________|
     *  ||  |  HBox | HBox  |  ||
     *  || V|_______|_______|__||
     *  || B|     HBox         ||
     *  || o|_______________ __||
     *  || x|     HBox      |  ||
     *  ||__|_______________|__||
     *  |_______________________|
     */
    public class LogicBlock extends Block {

        protected var hbox:HBox;
        protected var leftBox:VBox;
        protected var middleBox:VBox;

        protected var topBox:HBox;
        protected var topVBox:VBox;
        protected var bottomBox:HBox;
        protected var bottomVBox:VBox;
        protected var topTopLineBox:HBox;
        protected var topMidBox:HBox;
        protected var topContentBox:HBox;
        protected var topArgumentBox:HBox;
        protected var topNestedLineBox:HBox;
        protected var midStretchBox:HBox;
        protected var midLeftBox:VBox;
        protected var bottomNestedLineBox:HBox;
        protected var bottomContentBox:HBox;
        protected var bottomBottomLineBox:HBox;

        protected var leftSocket:Socket;
        protected var rightTopSocket:Socket;
        protected var rightBottomSocket:Socket;

        protected var nestedBlockWidthWatcher:ChangeWatcher;
        protected var nestedBlockHeightWatcher:ChangeWatcher;

        public function LogicBlock(blockName:String) {
            super(blockName);

            blockType = BlockType.LOGIC;
            socketType = SocketType.SQUARE;

            ChangeWatcher.watch(this, "socketType", onSocketTypeChange);
        }

        override public function redraw():void {
            if (hbox) {
                removeChild(hbox);
            }

            hbox = new HBox();
            hbox.buttonMode = true;
            hbox.setStyle("horizontalGap", 0);
            addChild(hbox);

            leftBox = new VBox();
            leftBox.width = 15;
            leftBox.percentHeight = 100;
            leftBox.setStyle("horizontalAlign", "right");
            leftBox.setStyle("verticalGap", 0);
            hbox.addChild(leftBox);

            middleBox = new VBox();
            middleBox.percentHeight = 100;
            middleBox.percentWidth = 100;
            middleBox.setStyle("verticalGap", 0);
            hbox.addChild(middleBox);

            topBox = new HBox();
            topBox.percentWidth = 100;
            topBox.setStyle("horizontalGap", 0);
            middleBox.addChild(topBox);

            topVBox = new VBox();
            topVBox.percentWidth = 100;
            topVBox.setStyle("verticalGap", 0);
            topBox.addChild(topVBox);

            topTopLineBox = new HBox();
            topTopLineBox.percentWidth = 100;
            topTopLineBox.setStyle("horizontalGap", 0);
            topVBox.addChild(topTopLineBox);

            topMidBox = new HBox();
            topMidBox.percentWidth = 100;
            topMidBox.setStyle("verticalAlign", "middle");
            topMidBox.setStyle("horizontalGap", 5);
            topMidBox.setStyle("backgroundColor", blockColor);
            topVBox.addChild(topMidBox);

            topContentBox = new HBox();
            topMidBox.addChild(topContentBox);

            topArgumentBox = new HBox();
            topMidBox.addChild(topArgumentBox);

            topNestedLineBox = new HBox();
            topNestedLineBox.percentWidth = 100;
            topNestedLineBox.setStyle("horizontalGap", 0);
            topVBox.addChild(topNestedLineBox);

            midStretchBox = new HBox();
            midStretchBox.percentWidth = 100;
            midStretchBox.percentHeight = 100;
            midStretchBox.setStyle("horizontalGap", 0);
            middleBox.addChild(midStretchBox);

            midLeftBox = new VBox();
            midLeftBox.width = 15;
            midLeftBox.minHeight = 20;
            midLeftBox.percentHeight = 100;
            midLeftBox.setStyle("backgroundColor", blockColor);
            midStretchBox.addChild(midLeftBox);

            bottomBox = new HBox();
            bottomBox.percentWidth = 100;
            bottomBox.setStyle("horizontalGap", 0);
            middleBox.addChild(bottomBox);

            bottomVBox = new VBox();
            bottomVBox.percentWidth = 100;
            bottomVBox.setStyle("verticalGap", 0);
            bottomBox.addChild(bottomVBox);

            bottomNestedLineBox = new HBox();
            bottomNestedLineBox.percentWidth = 100;
            bottomNestedLineBox.setStyle("horizontalGap", 0);
            bottomVBox.addChild(bottomNestedLineBox);

            bottomContentBox = new HBox();
            bottomContentBox.percentWidth = 100;
            bottomContentBox.minHeight = 10;
            bottomContentBox.setStyle("verticalAlign", "middle");
            bottomContentBox.setStyle("horizontalGap", 5);
            bottomContentBox.setStyle("backgroundColor", blockColor);
            bottomVBox.addChild(bottomContentBox);

            bottomBottomLineBox = new HBox();
            bottomBottomLineBox.percentWidth = 100;
            bottomBottomLineBox.setStyle("horizontalGap", 0);
            bottomVBox.addChild(bottomBottomLineBox);

            leftSocket = SocketFactory.createLeftSocket(socketType, blockColor);
            rightTopSocket = SocketFactory.createRightSocket(socketType, blockColor);
            rightBottomSocket = SocketFactory.createRightSocket(socketType, blockColor);

            rightTopSocket.width = 15;
            rightBottomSocket.width = 15;

            leftBox.addChild(leftSocket);
            topBox.addChild(rightTopSocket);
            bottomBox.addChild(rightBottomSocket);

            hbox.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            hbox.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            hbox.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            hbox.filters = [ new BevelFilter(2) ];

            ChangeWatcher.watch(hbox, "height", onHeightChange);
            ChangeWatcher.watch(topBox, "height", onTopHeightChange);
        }

        override public function addContent(content:DisplayObject):void {
            topContentBox.addChild(content);
        }

        override public function removeContent(content:DisplayObject):void {
            topContentBox.removeChild(content);
        }

        override public function getContent():Array {
            return topContentBox.getChildren();
        }

        override public function addArgument(block:ArgumentBlock):void {
            topArgumentBox.addChild(block);
        }

        override public function removeArgument(block:ArgumentBlock):void {
            topArgumentBox.removeChild(block);
        }

        override public function removeAllArguments():void {
            topArgumentBox.removeAllChildren();
        }

        override public function getArguments():Array {
            return topArgumentBox.getChildren();
        }

        private function onSocketTypeChange(e:Event):void {
            if (leftSocket && leftSocket.parent)
                leftBox.removeChild(leftSocket);
            if (rightTopSocket && rightTopSocket.parent)
                bottomBox.removeChild(rightTopSocket);
            if (rightBottomSocket && rightBottomSocket.parent)
                bottomBox.removeChild(rightBottomSocket);

            leftSocket = SocketFactory.createLeftSocket(socketType, blockColor);
            rightTopSocket = SocketFactory.createRightSocket(socketType, blockColor);
            rightBottomSocket = SocketFactory.createRightSocket(socketType, blockColor);

            leftBox.addChild(leftSocket);
            topBox.addChild(rightTopSocket);
            bottomBox.addChild(rightBottomSocket);
        }

        private function onHeightChange(e:Event):void {
            if (after) {
                after.y = hbox.height;
            }
        }

        private function onTopHeightChange(e:Event):void {
            if (nested[0]) {
                nested[0].y = topBox.height;
            }
        }

        private function onNestedHeightChange(e:Event):void {
            resizeMidBox();
        }

        private function onNestedBlockDisconnect(e:Event):void {
            nested[0].removeEventListener(BlockConnectionEvent.DISCONNECT, onNestedBlockDisconnect);
            nestedBlockWidthWatcher.unwatch();
            nestedBlockHeightWatcher.unwatch();
        }

        private function resizeMidBox():void {
            if (nested[0]) {
                bottomBox.width = nested[0].width + midLeftBox.width;
                midStretchBox.height = nested[0].height;
            } else {
                bottomBox.percentWidth = 100;
                midStretchBox.height = midStretchBox.minHeight;
            }
        }

        //
        // EVENT HANDLERS
        //

        private function onMouseDown(e:MouseEvent):void {
            dispatchEvent(new BlockDragEvent(BlockDragEvent.DRAG_START, false, false, this, this.parent));
        }

        private function onMouseUp(e:MouseEvent):void {
            dispatchEvent(new BlockDragEvent(BlockDragEvent.DRAG_COMPLETE, false, false, this, null));
        }

        private function onMouseMove(e:MouseEvent):void {
            if (isDragging() && !e.buttonDown)
                dispatchEvent(new BlockDragEvent(BlockDragEvent.DRAG_COMPLETE, false, false, this, null));
        }

        //
        // OLDER SIBLING CONNECTION
        //

        override public function hasBefore():Boolean {
            return true;
        }

        override public function connectBefore(block:Block):void {
            if (before) {
                before.connectAfter(block);
            }

            parent.addChild(block);

            block.x = this.x;
            block.y = this.y - block.height;

            block.connectAfter(this);
        }

        override public function testBeforeConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;
            if (block.after != null)
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this.parent);

            return hbox.hitTestObject(block) && (p.y < this.y);
        }

        //
        // YOUNGER SIBLING CONNECTION
        //

        override public function hasAfter():Boolean {
            return true;
        }

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function connectAfter(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = hbox.height;

            if (after)
                block.connectAfter(after);

            block.before = this;
            this.after = block;
        }

        //
        // NESTED BLOCK CONNECTION
        //

        override public function numNested():uint {
            return 1;
        }

        override public function testNestedConnection(level:uint, block:Block):Boolean {
            if (!block.hasBefore())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > topVBox.height - 10) && (p.y < topVBox.height + 10);
        }

        override public function connectNested(level:uint, block:Block):void {
            if (nested[level])
                block.connectAfter(nested[level]);

            addChild(block);

            block.x = 30;
            block.y = topBox.height;

            block.before = this;
            this.nested[level] = block;

            nestedBlockWidthWatcher = ChangeWatcher.watch(block, "width", onNestedHeightChange);
            nestedBlockHeightWatcher = ChangeWatcher.watch(block, "height", onNestedHeightChange);
            block.addEventListener(BlockConnectionEvent.DISCONNECT, onNestedBlockDisconnect);

            resizeMidBox();
        }

        override public function cleanNestedConnections(recursive:Boolean=false):void {
            super.cleanNestedConnections();
            resizeMidBox();
        }

    }

}
