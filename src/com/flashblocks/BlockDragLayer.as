package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.util.BlockUtil;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import mx.containers.VBox;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;

    /**
     * ...
     * @author ...
     */
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
            super();

            percentWidth = 100;
            percentHeight = 100;

            //shadowFilter = new DropShadowFilter(6, 45, 0x000000, .4);
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

        /* INTERFACE com.flashblocks.IBlockContainer */

        public function addBlock(block:Block):void {
            startDragBlock(block, block.parent);
            addChild(block);
        }

        public function removeBlock(block:Block):void {
            stopDragBlock(block);
            if (this.contains(block))
                removeChild(block);
        }

        public function getAllBlocks():Array{
            return [ block ];
        }

        /* INTERFACE com.flashblocks.IWorkspaceWidget */

        public function registerWorkspace(workspace:Workspace):void{
            this.workspace = workspace;
            PopUpManager.addPopUp(this, workspace);

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
                if (widget == this)
                    continue;

                var widgetDO:DisplayObject;
                if (!widget is DisplayObject)
                    continue;

                widgetDO = widget as DisplayObject;
                if (!widgetDO.visible)
                    continue;

                if (widgetDO.hitTestObject(block)) {
                    widget.addBlock(block);
                    dropped = true;
                    break;
                }
            }

            if (!dropped) {
                block.x = originalPositionX;
                block.y = originalPositionY;
                (originalParent as IWorkspaceWidget).addBlock(block);
            }

            removeBlock(block);
        }

    }

}
