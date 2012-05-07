package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.render.BlockNotchBottom;
    import com.flashblocks.blocks.render.RenderConstants;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;

    import flash.events.Event;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.binding.utils.ChangeWatcher;

    /**
     * Anchored block that is fixed in its parent and cannot be moved.
     *
     * The anchor block is used to indicate the start of a program. It is
     * usually fixed to the top of a widget and does not respond to mouse
     * events that would normally be used to drag the block. Additionally
     * the anchor block resizes to fill the entire width of the parent.
     * Children attached to the younger sibling port are offset 15 pixels
     * to further indicate that the anchor block is the "top level".
     */
    public class AnchorBlock extends SimpleBlock {
        private var widthWatcher:ChangeWatcher;

        public function AnchorBlock() {
            super();

            blockType = BlockType.PROCEDURE;
            socketType = SocketType.SLANT;

            addEventListener(Event.ADDED, onParentChange);
            addEventListener(Event.REMOVED, onParentChange);
        }

        override public function redraw():void {
            super.redraw();

            hbox.buttonMode = false;

            topMidBox.addChild(new BlockFlatTop(blockColor));

            bottomMidBox.addChild(new BlockNotchBottom(blockColor, RenderConstants.NOTCH_OFFSET + 15));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));
        }

        //
        // Connection testing
        //

        override public function connectAfter(block:Block):void {
            addChild(block);

            block.x = 15;
            block.y = hbox.height;

            if (after)
                block.connectAfter(after);

            block.before = this;
            this.after = block;
        }

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function hasAfter():Boolean {
            return true;
        }

        //
        // Resize handlers
        //

        private function onParentChange(e:Event):void {
            if (widthWatcher) {
                widthWatcher.unwatch();
            }
            if (parent) {
                widthWatcher = ChangeWatcher.watch(parent, "width", onResize);
                onResize(); // force resize
            }
        }

        private function onResize(e:Event=null):void {
            hbox.width = parent.width;
        }

        //
        // Mouse event handlers -- overrides to do nothing
        //

        override protected function onMouseDown(e:MouseEvent):void {
            // do nothing
        }

        override protected function onMouseUp(e:MouseEvent):void {
            // do nothing
        }

        override protected function onMouseMove(e:MouseEvent):void {
            // do nothing
        }

    }

}
