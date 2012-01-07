package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.events.BlockDragEvent;

    import flash.events.Event;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;

    [Event(name="dragStart", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragComplete", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragDrop", type="com.flashblocks.events.BlockDragEvent")]
    public class Workspace extends UIComponent {
        private var widgets:Array;

        public function Workspace() {
            widgets = new Array();
        }

        // Widgets

        public function registerWidget(widget:IWorkspaceWidget):void {
            if (widgets.indexOf(widget) != -1) {
                return; // TODO: throw exception
            }
            widget.registerWorkspace(this);
            widgets.push(widget);
        }

        public function deregisterWidget(widget:IWorkspaceWidget):void {
            var index:int = widgets.indexOf(widget);
            if (index == -1) {
                return; // TODO: throw exception
            }
            widgets.splice(index, 1);
        }

        public function getWidgets():Array {
            return widgets.concat();
        }

        // Blocks

        public function registerBlock(block:Block):void {
            block.addEventListener(BlockDragEvent.DRAG_START, rebroadcastEvent);
            block.addEventListener(BlockDragEvent.DRAG_COMPLETE, rebroadcastEvent);
        }

        public function deregisterBlock(block:Block):void {
            block.removeEventListener(BlockDragEvent.DRAG_START, rebroadcastEvent);
            block.removeEventListener(BlockDragEvent.DRAG_COMPLETE, rebroadcastEvent);
        }

        //
        // Event handling
        //

        public function rebroadcastEvent(e:Event):void {
            dispatchEvent(e);
        }
    }
}
