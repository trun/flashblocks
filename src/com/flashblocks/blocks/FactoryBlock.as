package com.flashblocks.blocks {
    import com.flashblocks.Workspace;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.util.BlockUtil;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.binding.utils.ChangeWatcher;
    import mx.containers.HBox;
    import mx.controls.Label;

    /**
     * Not to be confused with a BlockFactory. A FactoryBlock can generate
     * new blocks of a specific type. Instead of manipulating this block
     * directly, user interactions such as dragging will cause a new block
     * to be created and placed on to the drag layer.
     */
    public class FactoryBlock extends Block {
        protected var blockFunction:Function;
        protected var blockCount:int;

        protected var hbox:HBox;
        protected var countLabel:Label;

        protected var placeholderBlock:Block;

        public function FactoryBlock(blockFunction:Function, blockCount:int=-1) {
            this.blockFunction = blockFunction;
            this.blockCount = blockCount;

            hbox = new HBox();
            hbox.buttonMode = true;
            hbox.setStyle("horizontalGap", 0);
            hbox.mouseChildren = false;
            addChild(hbox);

            placeholderBlock = blockFunction();
            hbox.addChild(placeholderBlock);

            countLabel = new Label();
            countLabel.setStyle("fontWeight", "bold");
            countLabel.setStyle("fontSize", "18");
            updateCountLabel();
            addChild(countLabel);

            ChangeWatcher.watch(hbox, "width", onResize);
            ChangeWatcher.watch(hbox, "height", onResize);
            ChangeWatcher.watch(countLabel, "width", onResize);
            ChangeWatcher.watch(countLabel, "height", onResize);

            hbox.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }

        override public function get blockName():String {
            return placeholderBlock.blockName;
        }

        public function incrementCount():void {
            if (blockCount != -1) {
                blockCount++;
                updateCountLabel();
            }
        }

        public function decrementCount():void {
            if (blockCount != -1) {
                blockCount--;
                updateCountLabel();
            }
        }

        private function updateCountLabel():void {
            countLabel.text = blockCount == -1 ? String.fromCharCode(0x221e) : "" + blockCount;
        }

        //
        // EVENT HANDLERS
        //

        private function onResize(e:Event):void {
            countLabel.x = hbox.width + 5;
            countLabel.y = hbox.height / 2 - countLabel.height / 2;
        }

        protected function onMouseDown(e:MouseEvent):void {
            if (blockCount == 0) {
                return; // no available blocks
            }
            decrementCount();
            var block:Block = blockFunction();

            // position block on parent widget
            var point:Point = BlockUtil.positionLocalToLocal(placeholderBlock, hbox, parent);
            parent.addChild(block);
            block.x = point.x;
            block.y = point.y;

            // register block with workspace
            Workspace.getInstance().registerBlock(block);

            // drag block
            dispatchEvent(new BlockDragEvent(BlockDragEvent.DRAG_START, false, false, block, block.parent));
        }
    }
}
