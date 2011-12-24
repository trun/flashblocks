package com.flashblocks.sockets {
    import flash.events.Event;
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.VBox;
    import mx.core.UIComponent;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class Socket extends VBox {

        protected var color:uint;
        protected var socket:UIComponent;

        public function Socket(color:uint=0xFFFFFF) {
            super();

            this.color = color;
            this.percentWidth = 100;
            this.percentHeight = 100;

            socket = new UIComponent();
            socket.percentWidth = 100;
            socket.percentHeight = 100;
            addChild(socket);

            ChangeWatcher.watch(socket, "width", onSizeChange);
            ChangeWatcher.watch(socket, "height", onSizeChange);
        }

        protected function draw():void {
            // should be overridden
        }

        private function onSizeChange(e:Event):void {
            draw();
        }

    }

}
