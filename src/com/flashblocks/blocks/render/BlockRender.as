package com.flashblocks.blocks.render {
    import flash.events.Event;
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.VBox;
    import mx.core.UIComponent;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockRender extends VBox {

        protected var color:uint;
        protected var offset:Number;
        protected var render:UIComponent;

        public function BlockRender(color:uint, offset:Number=RenderConstants.NOTCH_OFFSET) {
            this.color = color;
            this.offset = offset;

            render = new UIComponent();
            render.percentWidth = 100;
            render.percentHeight = 100;
            addChild(render);

            ChangeWatcher.watch(render, "width", onSizeChange);
            ChangeWatcher.watch(render, "height", onSizeChange);
        }

        protected function draw():void {
            // override in children
        }

        private function onSizeChange(e:Event):void{
            draw();
        }

    }

}
