package com.flashblocks.blocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketSlantLeft extends Socket {

        public function SocketSlantLeft(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(socket.width, 0);
            g.lineTo(0, 0);
            g.lineTo(socket.width, socket.height);
            g.endFill();
        }

    }

}
