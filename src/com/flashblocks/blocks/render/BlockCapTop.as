package com.flashblocks.blocks.render {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockCapTop extends BlockRender {

        public function BlockCapTop(color:uint) {
            super(color);

            percentWidth = 100;
            minWidth = 50;
            height = 15;
        }

        override protected function draw():void {
            var g:Graphics = render.graphics;

            g.clear();
            g.moveTo(0, render.height);
            g.beginFill(color);
            g.lineTo(0, render.height - 5);
            g.lineTo(render.width, render.height - 5);
            g.lineTo(render.width, render.height);
            g.endFill();

            g.beginFill(color);
            g.moveTo(0, render.height - 5);
            g.curveTo(render.width/2, -render.height/2, render.width, render.height - 5);
            g.endFill();
        }

    }

}
