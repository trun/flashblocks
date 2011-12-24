package com.flashblocks.blocks.render {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockNotchBottom extends BlockRender {

        public function BlockNotchBottom(color:uint=0xFFFFFF) {
            super(color);

            width = RenderConstants.NOTCH_OFFSET + RenderConstants.NOTCH_WIDTH + 10;
            height = 5;
        }

        override protected function draw():void {
            var g:Graphics = render.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(0, 0);
            g.lineTo(0, render.height);
            g.lineTo(RenderConstants.NOTCH_OFFSET, render.height);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5, render.height + 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5 + RenderConstants.NOTCH_WIDTH, render.height + 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 10 + RenderConstants.NOTCH_WIDTH, render.height);
            g.lineTo(render.width, render.height);
            g.lineTo(render.width, 0);
            g.lineTo(0, 0);
            g.endFill();
        }

    }

}
