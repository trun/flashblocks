package com.flashblocks.logoblocks.interpreter {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.args.ArgumentBlock;

    import flash.display.Graphics;

    import mx.core.UIComponent;

    public class Interpreter {
        private var graphics:Graphics;
        private var x:Number, y:Number, rotation:int;
        private var penUp:Boolean;

        public function Interpreter(canvas:UIComponent) {
            this.graphics = canvas.graphics;
            this.graphics.lineStyle(2, 0xffffff);
            this.x = canvas.width / 2;
            this.y = canvas.height / 2;
            this.penUp = false;
        }

        public function execute(block:Block):void {
            var val:int;
            trace("executing... " + block.blockName);
            switch (block.blockName) {
                case "Forward":
                    val = parseInt(block.getArguments()[0].getValue());
                    x += Math.cos(rad(rotation)) * val;
                    y += Math.sin(rad(rotation)) * val;
                    draw();
                    break;
                case "Backward":
                    val = parseInt(block.getArguments()[0].getValue());
                    x -= Math.cos(rad(rotation)) * val;
                    y -= Math.sin(rad(rotation)) * val;
                    draw();
                    break;
                case "Turn Right":
                    val = parseInt(block.getArguments()[0].getValue());
                    rotation += val % 360;
                    break;
                case "Turn Left":
                    val = parseInt(block.getArguments()[0].getValue());
                    rotation -= val % 360;
                    break;
                case "Set Pen Color":
                    this.graphics.lineStyle(2, block.getArguments()[0].getValue());
                    break;
                case "Pen Up":
                    penUp = true;
                    break;
                case "Pen Down":
                    penUp = false;
                    break;
                case "Repeat":
                    val = parseInt(block.getArguments()[0].getValue());
                    for (var i:uint = 0; i < val; i++) {
                        execute(block.nested[0]);
                    }
                    break;
            }

            if (block.after) {
                execute(block.after);
            }
        }

        private function draw():void {
            if (penUp) {
                graphics.moveTo(x, y);
            } else {
                graphics.lineTo(x, y);
            }
        }

        private static function rad(deg:int):Number {
            return deg * Math.PI / 180;
        }
    }
}
