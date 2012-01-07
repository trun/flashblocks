package com.flashblocks.blocks {
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
    import mx.containers.Canvas;
    import mx.containers.HBox;
    import mx.containers.VBox;

    /**
     *   _______________________
     *  |_______________________|
     *  ||  |     HBox      |  ||
     *  || V|_______________|__||
     *  || B|     HBox         ||
     *  || o|_______________ __||
     *  || x|     HBox      |  ||
     *  ||__|_______________|__||
     *  |_______________________|
     */
    public class ControlLogicBlock extends Block {

        protected var hbox:HBox;
        protected var leftBox:VBox;
        protected var middleBox:VBox;

        protected var topBox:HBox;
        protected var topVBox:VBox;
        protected var bottomBox:HBox;
        protected var bottomVBox:VBox;
        protected var topTopLineBox:HBox;
        protected var topContentBox:HBox;
        protected var topNestedLineBox:HBox;
        protected var midStretchBox:HBox;
        protected var midLeftBox:VBox;
        protected var bottomNestedLineBox:HBox;
        protected var bottomContentBox:HBox;
        protected var bottomBottomLineBox:HBox;

        protected var leftSocket:Socket;
        protected var rightTopSocket:Socket;
        protected var rightBottomSocket:Socket;

        protected var nestedBlockWatcher:ChangeWatcher;

        public function ControlLogicBlock(socketType:String="square", color:uint=0x999900) {
            super(socketType, "", color);

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

            topContentBox = new HBox();
            topContentBox.percentWidth = 100;
            topContentBox.setStyle("verticalAlign", "middle");
            topContentBox.setStyle("horizontalGap", 5);
            topContentBox.setStyle("backgroundColor", blockColor);
            topVBox.addChild(topContentBox);

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
            ChangeWatcher.watch(this, "socketType", onSocketTypeChange);
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
            if (youngerSibling) {
                youngerSibling.y = hbox.height;
            }
        }

        private function onTopHeightChange(e:Event):void {
            if (nestedBlocks[0]) {
                nestedBlocks[0].y = topBox.height;
            }
        }

        private function onNestedHeightChange(e:Event):void {
            resizeMidBox();
        }

        private function onNestedBlockDisconnect(e:Event):void {
            nestedBlocks[0].removeEventListener(BlockConnectionEvent.DISCONNECT, onNestedBlockDisconnect);
            nestedBlocks = new Array();
            nestedBlockWatcher.unwatch();
            resizeMidBox();
        }

        private function resizeMidBox():void {
            if (nestedBlocks[0]) {
                bottomBox.width = nestedBlocks[0].width + midLeftBox.width;
                midStretchBox.height = nestedBlocks[0].height;
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

        override public function hasOlderSiblingPort():Boolean {
            return true;
        }

        override public function connectOlderSibling(block:Block):void {
            if (olderSibling) {
                olderSibling.connectYoungerSibling(block);
            }

            parent.addChild(block);

            block.x = this.x;
            block.y = this.y - block.height;

            block.connectYoungerSibling(this);
        }

        override public function testOlderSiblingConnection(block:Block):Boolean {
            if (!block.hasYoungerSiblingPort())
                return false;
            if (block.youngerSibling != null)
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this.parent);

            return hbox.hitTestObject(block) && (p.y < this.y);
        }

        //
        // YOUNGER SIBLING CONNECTION
        //

        override public function hasYoungerSiblingPort():Boolean {
            return true;
        }

        override public function testYoungerSiblingConnection(block:Block):Boolean {
            if (!block.hasYoungerSiblingPort())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function connectYoungerSibling(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = hbox.height;

            if (youngerSibling)
                block.connectYoungerSibling(youngerSibling);

            block.olderSibling = this;
            this.youngerSibling = block;
        }

        //
        // NESTED BLOCK CONNECTION
        //

        override public function hasNestedPort():Boolean {
            return true;
        }

        override public function testNestedConnection(block:Block):Boolean {
            if (!block.hasOlderSiblingPort())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > topVBox.height - 10) && (p.y < topVBox.height + 10);
        }

        override public function connectNestedBlock(block:Block):void {
            if (nestedBlocks[0])
                block.connectYoungerSibling(nestedBlocks[0]);

            addChild(block);

            block.x = 30;
            block.y = topBox.height;

            block.olderSibling = this;
            this.nestedBlocks = [ block ];

            nestedBlockWatcher = ChangeWatcher.watch(block, "height", onNestedHeightChange);
            block.addEventListener(BlockConnectionEvent.DISCONNECT, onNestedBlockDisconnect);

            resizeMidBox();
        }

    }

}
