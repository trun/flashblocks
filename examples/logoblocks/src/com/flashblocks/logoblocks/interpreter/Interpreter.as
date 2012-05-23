package com.flashblocks.logoblocks.interpreter {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.logoblocks.LogoCanvas;

    import flash.utils.setTimeout;

    public class Interpreter {
        private var canvas:LogoCanvas;

        public function Interpreter(canvas:LogoCanvas) {
            this.canvas = canvas;
        }

        public function execute(block:Block, context:Object=null, callback:Function=null):void {
            setTimeout(function():void {
                executeDo(block, context, callback);
            }, 100);
        }

        public function executeDo(block:Block, context:Object=null, callback:Function=null):void {
            if (!context) {
                context = new Object();
            }

            if (block.after) {
                var origCallback:Function = callback;
                callback = function():void {
                    execute(block.after, context, origCallback);
                };
            }

            var val:int;
            switch (block.blockName) {
                case "forward":
                    val = parseInt(eval(block.getArgument()));
                    canvas.moveForward(val);
                    break;
                case "backward":
                    val = parseInt(eval(block.getArgument()));
                    canvas.moveBackward(val);
                    break;
                case "turn-right":
                    val = parseInt(eval(block.getArgument()));
                    canvas.turnRight(val);
                    break;
                case "turn-left":
                    val = parseInt(eval(block.getArgument()));
                    canvas.turnLeft(val);
                    break;
                case "set-pen-color":
                    canvas.penColor = eval(block.getArgument());
                    break;
                case "pen-up":
                    canvas.penUp = true;
                    break;
                case "pen-down":
                    canvas.penUp = false;
                    break;
                case "repeat":
                    val = parseInt(eval(block.getArgument()));
                    var doRepeat:Function = function(i:uint):void {
                        if (i > 0) {
                            execute(block.nested[0], context, function():void {
                                doRepeat(i - 1);
                            });
                        } else if (callback != null) {
                            callback();
                        }
                    };
                    doRepeat(val);
                    return;
            }

            if (callback != null) {
                callback();
            }
        }

        public static function eval(block:Block, context:Object=null):* {
            context = context || {};
            if (block.blockType == BlockType.ARGUMENT && block.inner) {
                return eval(block.inner, context);
            }
            switch (block.blockName) {
                case "and":
                    return eval(block.getArgument(0).blockValue, context)
                            && eval(block.getArgument(1).blockValue, context);
                case "or":
                    return eval(block.getArgument(0).blockValue, context)
                            || eval(block.getArgument(1).blockValue, context);
            }
            return block.blockValue;
        }
    }
}
