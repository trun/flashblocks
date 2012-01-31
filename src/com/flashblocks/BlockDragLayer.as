package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.util.BlockUtil;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.filters.BitmapFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;

    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;

    public class BlockDragLayer extends UIComponent implements IWorkspaceWidget {
        private var workspace:Workspace;

        private var block:Block;
        private var originalParent:DisplayObjectContainer;
        private var originalPositionX:Number;
        private var originalPositionY:Number;

        private var lastMouseX:Number;
        private var lastMouseY:Number;

        private var shadowFilter:BitmapFilter;

        public function BlockDragLayer() {
            percentWidth = 100;
            percentHeight = 100;

            shadowFilter = new GlowFilter(0x000000, 0.5, 12, 12);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(e:Event):void {
            if (block && block.isDragging()) {
                var xDiff:Number = mouseX - lastMouseX;
                var yDiff:Number = mouseY - lastMouseY;

                block.x += xDiff;
                block.y += yDiff;

                lastMouseX = mouseX;
                lastMouseY = mouseY;
            }
        }

        public function registerContainer(container:DisplayObject):void {
            PopUpManager.addPopUp(this, container);
        }

        /* INTERFACE com.flashblocks.IBlockContainer */

        public function addBlock(block:Block):void {
            startDragBlock(block, block.parent);
            addChild(block);
        }

        public function removeBlock(block:Block):void {
            stopDragBlock(block);
            if (this.contains(block)) {
                removeChild(block);
            }
        }

        public function getAllBlocks():Array {
            if (block) {
                return [ block ];
            }
            return [ ];
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void{
            this.workspace = workspace;

            workspace.addEventListener(BlockDragEvent.DRAG_START, onBlockDragStart);
            workspace.addEventListener(BlockDragEvent.DRAG_COMPLETE, onBlockDragComplete);
        }

        private function startDragBlock(block:Block, originalParent:DisplayObjectContainer):void {
            var p:Point = BlockUtil.positionLocalToLocal(block, originalParent, this);

            block.x = originalPositionX = p.x;
            block.y = originalPositionY = p.y;
            block.setDragging(true);

            lastMouseX = mouseX;
            lastMouseY = mouseY;

            block.filters = block.filters.concat( [ shadowFilter ] );

            this.block = block;
            this.originalParent = originalParent;
        }

        private function stopDragBlock(block:Block):void {
            var filters:Array = new Array();
            for each (var filter:BitmapFilter in block.filters)
                if (filter != shadowFilter)
                    filters.push(filter);
            block.filters = filters;
            block.setDragging(false);
        }

        //
        // Drag Events
        //

        private function onBlockDragStart(e:BlockDragEvent):void {
            addBlock(e.block);
        }

        private function onBlockDragComplete(e:BlockDragEvent):void {
            if (block != e.block)
                return;

            var dropped:Boolean = false;

            for each (var widget:IWorkspaceWidget in workspace.getWidgets()) {
                // skip the drag layer
                if (widget == this)
                    continue;

                // skip widgets that are not DisplayObjects
                var widgetDO:DisplayObject;
                if (!widget is DisplayObject)
                    continue;

                // skip invisible widgets
                widgetDO = widget as DisplayObject;
                if (!widgetDO.visible)
                    continue;

                if (widgetDO.hitTestObject(block)) {
                    if (originalParent is Block) {
                        (originalParent as Block).cleanConnections();
                    }
                    widget.addBlock(block);
                    dropped = true;
                    break;
                }
            }

            // Return block to original state
            // TODO: remember block connection so we can clean connections prior to dropping the block
            if (!dropped) {
                block.x = originalPositionX;
                block.y = originalPositionY;
                if (originalParent is IWorkspaceWidget) {
                    (originalParent as IWorkspaceWidget).addBlock(block);
                } else if (originalParent is Block) {
                    var originalParentBlock:Block = originalParent as Block;
                    if (originalParentBlock.after == block) {
                        originalParentBlock.after = null;
                        originalParentBlock.connectAfter(block);
                    } else if (originalParentBlock.before == block) {
                        originalParentBlock.before = null;
                        originalParentBlock.connectBefore(block);
                    } else if (originalParentBlock.inner == block) {
                        originalParentBlock.inner = null;
                        originalParentBlock.connectInner(block);
                    } else {
                        for (var i:uint = 0; i < originalParentBlock.nested.length; i++) {
                            trace('testing nested... ' + i);
                            trace(' - original parent... ' + originalParentBlock.nested[i]);
                            if (originalParentBlock.nested[i] == block) {
                                originalParentBlock.nested[i] = null;
                                originalParentBlock.connectNested(i, block);
                                break;
                            }
                        }
                    }
                    originalParentBlock.cleanConnections();
                }
            }

            removeBlock(block);
        }

    }

}
