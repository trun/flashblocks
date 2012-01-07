package com.flashblocks.blocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketRoundLeft extends Socket {

        public function SocketRoundLeft(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(socket.width, 0);
            g.lineTo(10, 0);
            g.curveTo(0, 0, 0, socket.height / 2);
            g.lineTo(0, socket.height / 2);
            g.curveTo(0, socket.height, 10, socket.height);
            g.lineTo(socket.width, socket.height);
            g.endFill();
        }

    }

}
