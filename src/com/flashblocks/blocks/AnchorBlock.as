package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.render.BlockNotchBottom;
    import com.flashblocks.blocks.render.RenderConstants;
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

        public function AnchorBlock(socketType:String="slant", blockColor:uint=0x993333) {
            super(socketType, "", blockColor);

            blockType = BlockType.PROCEDURE;

            hbox.buttonMode = false;

            topMidBox.addChild(new BlockFlatTop(blockColor));

            bottomMidBox.addChild(new BlockNotchBottom(blockColor, RenderConstants.NOTCH_OFFSET + 15));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));

            addEventListener(Event.ADDED, onParentChange);
            addEventListener(Event.REMOVED, onParentChange);
        }

        //
        // Connection testing
        //

        override public function connectYoungerSibling(block:Block):void {
            addChild(block);

            block.x = 15;
            block.y = hbox.height;

            if (youngerSibling)
                block.connectYoungerSibling(youngerSibling);

            block.olderSibling = this;
            this.youngerSibling = block;
        }

        override public function testYoungerSiblingConnection(block:Block):Boolean {
            if (!block.hasYoungerSiblingPort())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function hasYoungerSiblingPort():Boolean {
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
            }
        }

        private function onResize(e:Event):void {
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
