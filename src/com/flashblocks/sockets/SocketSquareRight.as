package com.flashblocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketSquareRight extends Socket {

        public function SocketSquareRight(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.lineTo(socket.width - 5, 0);
            g.curveTo(socket.width, 0, socket.width, 5);
            g.lineTo(socket.width, socket.height - 5);
            g.curveTo(socket.width, socket.height, socket.width - 5, socket.height);
            g.lineTo(0, socket.height);
            g.endFill();
        }

    }

}
