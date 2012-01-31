package com.flashblocks.logoblocks.interpreter {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.logoblocks.LogoCanvas;

    import flash.utils.setTimeout;

    public class Interpreter {
        private var canvas:LogoCanvas;

        public function Interpreter(canvas:LogoCanvas) {
            this.canvas = canvas;
        }

        public function execute(block:Block, callback:Function=null):void {
            setTimeout(function():void {
                executeDo(block, callback);
            }, 100);
        }

        public function executeDo(block:Block, callback:Function=null):void {
            if (block.after) {
                var origCallback:Function = callback;
                callback = function():void {
                    execute(block.after, origCallback);
                };
            }

            var val:int;
            switch (block.blockName) {
                case "Forward":
                    val = parseInt(block.getArgument().getValue());
                    canvas.moveForward(val);
                    break;
                case "Backward":
                    val = parseInt(block.getArgument().getValue());
                    canvas.moveBackward(val);
                    break;
                case "Turn Right":
                    val = parseInt(block.getArgument().getValue());
                    canvas.turnRight(val);
                    break;
                case "Turn Left":
                    val = parseInt(block.getArgument().getValue());
                    canvas.turnLeft(val);
                    break;
                case "Set Pen Color":
                    canvas.penColor = block.getArgument().getValue();
                    break;
                case "Pen Up":
                    canvas.penUp = true;
                    break;
                case "Pen Down":
                    canvas.penUp = false;
                    break;
                case "Repeat":
                    val = parseInt(block.getArgument().getValue());
                    var repeat:Function = function(i:uint):void {
                        if (i > 0) {
                            execute(block.nested[0], function():void {
                                repeat(i - 1);
                            });
                        } else if (callback) {
                            callback();
                        }
                    };
                    repeat(val);
                    return;
            }

            if (callback) {
                callback();
            }
        }

        public function eval(block:Block, context:Object):* {
            var val:* = block.getValue();
            if (val is Block) {
                return eval(val,  context);
            }
            return val;
        }
    }
}
