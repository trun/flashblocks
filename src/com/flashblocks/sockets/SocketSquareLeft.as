package com.flashblocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketSquareLeft extends Socket {

        public function SocketSquareLeft(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(socket.width, 0);
            g.lineTo(5, 0);
            g.curveTo(0, 0, 0, 5);
            g.lineTo(0, socket.height - 5);
            g.curveTo(0, socket.height, 5, socket.height);
            g.lineTo(socket.width, socket.height);
            g.endFill();
        }

    }

}
