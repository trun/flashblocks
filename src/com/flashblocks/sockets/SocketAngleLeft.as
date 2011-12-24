package com.flashblocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketAngleLeft extends Socket {

        public function SocketAngleLeft(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(socket.width, 0);
            g.lineTo(0, socket.height / 2);
            g.lineTo(socket.width, socket.height);
            g.endFill();
        }

    }

}
