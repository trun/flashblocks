package com.flashblocks.blocks.render {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockNotchTop extends BlockRender {

        public function BlockNotchTop(color:uint=0xFFFFFF) {
            super(color);

            width = RenderConstants.NOTCH_OFFSET + RenderConstants.NOTCH_WIDTH + 10;
            height = 5;
        }

        override protected function draw():void {
            var g:Graphics = render.graphics;

            g.clear();
            g.beginFill(color);
            g.lineTo(RenderConstants.NOTCH_OFFSET, 0);
            g.lineTo(RenderConstants.NOTCH_OFFSET, render.height);
            g.lineTo(0, render.height);
            g.endFill();

            g.beginFill(color);
            g.moveTo(RenderConstants.NOTCH_OFFSET, 0);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5, 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5, render.height);
            g.lineTo(RenderConstants.NOTCH_OFFSET, render.height);
            g.endFill();

            g.beginFill(color);
            g.moveTo(RenderConstants.NOTCH_OFFSET + 5, 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5 + RenderConstants.NOTCH_WIDTH, 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5 + RenderConstants.NOTCH_WIDTH, render.height);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5, render.height);
            g.endFill();

            g.beginFill(color);
            g.moveTo(RenderConstants.NOTCH_OFFSET + 5 + RenderConstants.NOTCH_WIDTH, 5);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 10 + RenderConstants.NOTCH_WIDTH, 0);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 10 + RenderConstants.NOTCH_WIDTH, render.height);
            g.lineTo(RenderConstants.NOTCH_OFFSET + 5 + RenderConstants.NOTCH_WIDTH, render.height);
            g.endFill();
        }

    }

}
