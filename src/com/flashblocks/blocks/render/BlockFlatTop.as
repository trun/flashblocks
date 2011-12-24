package com.flashblocks.blocks.render {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockFlatTop extends BlockRender {

        public function BlockFlatTop(color:uint=0xFFFFFF) {
            super(color);

            percentWidth = 100;
            height = 5;
        }

        override protected function draw():void {
            var g:Graphics = render.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(0, 0);
            g.lineTo(render.width, 0);
            g.lineTo(render.width, render.height);
            g.lineTo(0, render.height);
            g.endFill();
        }
    }

}
