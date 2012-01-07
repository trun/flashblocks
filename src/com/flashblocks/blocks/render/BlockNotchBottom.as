package com.flashblocks.blocks.render {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockNotchBottom extends BlockRender {

        public function BlockNotchBottom(color:uint=0xFFFFFF, offset:Number=RenderConstants.NOTCH_OFFSET) {
            super(color, offset);

            width = offset + RenderConstants.NOTCH_WIDTH + 10;
            height = 5;
        }

        override protected function draw():void {
            var g:Graphics = render.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(0, 0);
            g.lineTo(0, render.height);
            g.lineTo(offset, render.height);
            g.lineTo(offset + 5, render.height + 5);
            g.lineTo(offset + 5 + RenderConstants.NOTCH_WIDTH, render.height + 5);
            g.lineTo(offset + 10 + RenderConstants.NOTCH_WIDTH, render.height);
            g.lineTo(render.width, render.height);
            g.lineTo(render.width, 0);
            g.lineTo(0, 0);
            g.endFill();
        }

    }

}
