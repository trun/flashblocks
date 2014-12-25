package com.flashblocks.logoblocks.interpreter {
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.logoblocks.LogoCanvas;

    import flash.utils.setTimeout;

    public class Interpreter {
        private var canvas:LogoCanvas;

        private var lastBlock:Block;
        private var nextBlock:Block;
        private var nextContext:Object;
        private var nextCallback:Function;

        private var _timeout:uint = 100;

        public function Interpreter(canvas:LogoCanvas) {
            this.canvas = canvas;
        }

        public function get timeout():uint {
            return _timeout;
        }

        public function set timeout(value:uint):void {
            _timeout = value;
        }

        public function reset():void {
            canvas.reset();
            if (lastBlock) {
                lastBlock.highlight = false;
                lastBlock = null;
            }
        }

        public function execute(block:Block, context:Object=null, callback:Function=null):void {
            nextBlock = block;
            nextContext = context;
            nextCallback = callback;
            setTimeout(function():void {
                executeNext();
            }, timeout);
        }

        private function executeNext():void {
            var block:Block = nextBlock;
            var context:Object = nextContext || new Object();
            var callback:Function = nextCallback;

            if (block.after) {
                var origCallback:Function = callback;
                callback = function():void {
                    execute(block.after, context, origCallback);
                };
            }

            if (lastBlock) {
                lastBlock.highlight = false;
            }
            block.highlight = true;
            lastBlock = block;

            var val:Number;
            switch (block.blockName) {
                case "forward":
                    val = parseFloat(eval(block.getArgument()));
                    canvas.moveForward(val);
                    break;
                case "backward":
                    val = parseFloat(eval(block.getArgument()));
                    canvas.moveBackward(val);
                    break;
                case "turn-right":
                    val = parseFloat(eval(block.getArgument()));
                    canvas.turnRight(val);
                    break;
                case "turn-left":
                    val = parseFloat(eval(block.getArgument()));
                    canvas.turnLeft(val);
                    break;
                case "set-pen-color":
                    canvas.penColor = eval(block.getArgument());
                    break;
                case "begin-fill":
                    canvas.beginFill(eval(block.getArgument()));
                    break;
                case "end-fill":
                    canvas.endFill();
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
            var val:* = block.blockValue;
            if (val is Function) {
                return val();
            }
            return val;
        }

    }
}
