package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.BlockFlatBottom;
    import com.flashblocks.blocks.render.BlockFlatTop;
    import com.flashblocks.blocks.render.BlockNotchBottom;
    import com.flashblocks.blocks.render.RenderConstants;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.events.BlockConnectionEvent;
    import com.flashblocks.util.BlockUtil;

    import flash.events.Event;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    import mx.binding.utils.ChangeWatcher;
    import mx.containers.Canvas;

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
        private var marker:Canvas;
        private var spacer:Canvas;

        private var heightWatcher:ChangeWatcher;
        private var afterHeightWatcher:ChangeWatcher;

        public function AnchorBlock(blockName:String) {
            super(blockName);

            blockType = BlockType.PROCEDURE;
            socketType = SocketType.SLANT;

            addEventListener(Event.ADDED, onParentChange);
            addEventListener(Event.REMOVED, onParentChange);

            marker = new Canvas();
            marker.height = 5;
            marker.setStyle("backgroundColor", 0x00FFFF);

            spacer = new Canvas();
            spacer.height = 200;
            addChild(spacer);

            ChangeWatcher.watch(this, "height", function(e:Event):void {
                repositionSpacer();
            });
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

            if (after) {
                var lastBlock:Block = block;
                while (lastBlock.after != null) {
                    lastBlock = lastBlock.after;
                }
                lastBlock.connectAfter(after);
            }

            afterHeightWatcher = ChangeWatcher.watch(block, "height", function(e:Event):void {
                repositionSpacer();
            });
            block.addEventListener(BlockConnectionEvent.DISCONNECT, function(e:Event):void {
                block.removeEventListener(BlockConnectionEvent.DISCONNECT, arguments.callee);
                if (afterHeightWatcher) {
                    afterHeightWatcher.unwatch();
                    afterHeightWatcher = null;
                }
                repositionSpacer();
            });

            block.before = this;
            this.after = block;
        }

        override public function testAfterConnection(block:Block):Boolean {
            if (!block.hasAfter())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);
            var centerX:Number = p.x + block.width / 2;

            return p.y >= hbox.height && p.y < hbox.height + 20
                    && centerX >= 0 && centerX <= hbox.width;
        }

        override public function overAfter(block:Block):void {
            addChild(marker);
            marker.x = 15;
            marker.y = hbox.height;
            marker.width = hbox.width - 30;
        }

        override public function outAfter(block:Block):void {
            if (marker.parent == this)
                removeChild(marker);
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

        private function repositionSpacer():void {
            spacer.y = (after) ? after.y + after.height : hbox.height;
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
