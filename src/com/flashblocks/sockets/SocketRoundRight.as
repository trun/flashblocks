package com.flashblocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketRoundRight extends Socket {

        public function SocketRoundRight(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(0, 0);
            g.lineTo(socket.width - 10, 0);
            g.curveTo(socket.width, 0, socket.width, socket.height / 2);
            g.lineTo(socket.width, socket.height / 2);
            g.curveTo(socket.width, socket.height, socket.width - 10, socket.height);
            g.lineTo(0, socket.height);
            g.endFill();
        }

    }

}
