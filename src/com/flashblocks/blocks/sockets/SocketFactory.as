package com.flashblocks.blocks.sockets {

    /**
     * ...
     * @author Trevor Rundell
     */
    public class SocketFactory {

        public static function createLeftSocket(type:String, color:uint=0xFFFFFF):Socket {
            switch (type) {
                case SocketType.ANGLE:
                    return new SocketAngleLeft(color);
                case SocketType.ROUND:
                    return new SocketRoundLeft(color);
                case SocketType.SQUARE:
                    return new SocketSquareLeft(color);
            }
            return null;
        }

        public static function createRightSocket(type:String, color:uint = 0xFFFFFF):Socket {
            switch (type) {
                case SocketType.ANGLE:
                    return new SocketAngleRight(color);
                case SocketType.ROUND:
                    return new SocketRoundRight(color);
                case SocketType.SQUARE:
                    return new SocketSquareRight(color);
            }
            return null;
        }

    }

}
