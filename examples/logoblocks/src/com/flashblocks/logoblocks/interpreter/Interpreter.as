package com.flashblocks.logoblocks.interpreter {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.logoblocks.LogoCanvas;

    public class Interpreter {
        private var canvas:LogoCanvas;

        public function Interpreter(canvas:LogoCanvas) {
            this.canvas = canvas;
        }

        public function execute(block:Block):void {
            var val:int;
            switch (block.blockName) {
                case "Forward":
                    val = parseInt(block.getArguments()[0].getValue());
                    canvas.moveForward(val);
                    break;
                case "Backward":
                    val = parseInt(block.getArguments()[0].getValue());
                    canvas.moveBackward(val);
                    break;
                case "Turn Right":
                    val = parseInt(block.getArguments()[0].getValue());
                    canvas.turnRight(val);
                    break;
                case "Turn Left":
                    val = parseInt(block.getArguments()[0].getValue());
                    canvas.turnLeft(val);
                    break;
                case "Set Pen Color":
                    canvas.penColor = block.getArguments()[0].getValue();
                    break;
                case "Pen Up":
                    canvas.penUp = true;
                    break;
                case "Pen Down":
                    canvas.penUp = false;
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
    }
}
