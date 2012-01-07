package com.flashblocks.blocks {
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.blocks.sockets.Socket;
    import com.flashblocks.blocks.sockets.SocketFactory;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.HBox;
    import mx.containers.VBox;
    import mx.controls.Label;
    import mx.events.MoveEvent;
    import mx.events.ResizeEvent;

    /**
     * A simple block layout.
     *
     * Three VBox components laid out horizontally. The middle VBox
     *   consists of three HBox components.
     *
     * The top and bottom borders of the block should go in the upper
     *   and lower children of the middle VBox.
     *
     * The left and right sockets go in the outer VBox components.
     *
     * The content (arguments, labels, etc) should go in the center HBox.
     *   _______________________
     *  |_______________________|
     *  ||  |     HBox      |  ||
     *  || V|_______________|V ||
     *  || B|     HBox      |B ||
     *  || o|_______________|o ||
     *  || x|     HBox      |x ||
     *  ||__|_______________|__||
     *  |_______________________|
     * @author Trevor Rundell
     */
    public class SimpleBlock extends Block {

        protected var hbox:HBox;
        protected var leftBox:VBox;
        protected var middleBox:VBox;
        protected var rightBox:VBox;

        protected var topMidBox:HBox;
        protected var centerMidBox:HBox;
        protected var bottomMidBox:HBox;

        protected var leftSocket:Socket;
        protected var rightSocket:Socket;

        public function SimpleBlock(socketType:String="round", blockLabel:String="", blockColor:uint=0x66FF66) {
            super(socketType, blockLabel, blockColor);

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

            rightBox = new VBox();
            rightBox.width = 15;
            rightBox.percentHeight = 100;
            rightBox.setStyle("horizontalAlign", "left");
            rightBox.setStyle("verticalGap", 0);
            hbox.addChild(rightBox);

            topMidBox = new HBox();
            topMidBox.percentWidth = 100;
            topMidBox.setStyle("horizontalGap", 0);
            middleBox.addChild(topMidBox);

            centerMidBox = new HBox();
            centerMidBox.percentWidth = 100;
            centerMidBox.setStyle("verticalAlign", "middle");
            centerMidBox.setStyle("horizontalGap", 5);
            centerMidBox.setStyle("backgroundColor", blockColor);
            middleBox.addChild(centerMidBox);

            bottomMidBox = new HBox();
            bottomMidBox.percentWidth = 100;
            bottomMidBox.setStyle("horizontalGap", 0);
            middleBox.addChild(bottomMidBox);

            leftSocket = SocketFactory.createLeftSocket(socketType, blockColor);
            rightSocket = SocketFactory.createRightSocket(socketType, blockColor);

            leftBox.addChild(leftSocket);
            rightBox.addChild(rightSocket);

            hbox.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            hbox.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            hbox.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

            hbox.filters = [ new BevelFilter(2) ];

            ChangeWatcher.watch(hbox, "height", onHeightChange);
            ChangeWatcher.watch(this, "socketType", onSocketTypeChange);
        }

        override public function addContent(content:DisplayObject):void {
            centerMidBox.addChild(content);
        }

        override public function removeContent(content:DisplayObject):void {
            centerMidBox.removeChild(content);
        }

        override public function getContent():Array {
            return centerMidBox.getChildren();
        }

        private function onSocketTypeChange(e:Event):void {
            if (leftSocket && leftSocket.parent)
                leftBox.removeChild(leftSocket);
            if (rightSocket && rightSocket.parent)
                rightBox.removeChild(rightSocket);

            leftSocket = SocketFactory.createLeftSocket(socketType, blockColor);
            rightSocket = SocketFactory.createRightSocket(socketType, blockColor);

            leftBox.addChild(leftSocket);
            rightBox.addChild(rightSocket);
        }


        private function onHeightChange(e:Event):void{
            if (youngerSibling)
                youngerSibling.y = hbox.height;
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

    }

}
