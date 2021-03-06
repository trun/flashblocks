﻿package com.flashblocks.blocks.sockets {
    import flash.display.Graphics;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketSlantRight extends Socket {

        public function SocketSlantRight(color:uint=0xFFFFFF) {
            super(color);
        }

        override protected function draw():void {
            var g:Graphics = socket.graphics;

            g.clear();
            g.beginFill(color);
            g.moveTo(0, 0);
            g.lineTo(socket.width, 0);
            g.lineTo(0, socket.height);
            g.endFill();
        }

    }

}
