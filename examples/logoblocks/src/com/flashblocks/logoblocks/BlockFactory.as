package com.flashblocks.logoblocks {
    import com.flashblocks.Workspace;
    import com.flashblocks.blocks.AnchorBlock;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockType;
    import com.flashblocks.blocks.CommandBlock;
    import com.flashblocks.blocks.FactoryBlock;
    import com.flashblocks.blocks.ReporterBlock;
    import com.flashblocks.blocks.SingleLogicBlock;
    import com.flashblocks.blocks.args.ArgumentBlock;
    import com.flashblocks.blocks.args.ColorPickerArgumentBlock;
    import com.flashblocks.blocks.args.StringArgumentBlock;
    import com.flashblocks.blocks.sockets.SocketType;

    import mx.controls.Label;

    public class BlockFactory {

        public static function createBlock(blockDefinition:Object, workspace:Workspace, registerBlock:Boolean=true):Block {
            var block:Block = null;

            if (blockDefinition is Array) {
                block = createBlock(blockDefinition[0], workspace);
                if (blockDefinition.length > 1) {
                    block.connectAfter(createBlock(blockDefinition.slice(1), workspace));
                }
            } else {
                switch (blockDefinition.name) {
                    case "repeat":
                        block = createRepeatBlock();
                        break;
                    case "forward":
                        block = createForwardBlock();
                        break;
                    case "backward":
                        block = createBackwardBlock();
                        break;
                    case "turn-right":
                        block = createTurnRightBlock();
                        break;
                    case "turn-left":
                        block = createTurnLeftBlock();
                        break;
                    case "pen-up":
                        block = createPenUpBlock();
                        break;
                    case "pen-down":
                        block = createPenDownBlock();
                        break;
                    case "set-pen-color":
                        block = createPenColorBlock();
                        break;
                    case "begin-fill":
                        block = createBeginFillBlock();
                        break;
                    case "end-fill":
                        block = createEndFillBlock();
                        break;
                    case "arg-string":
                        block = new StringArgumentBlock(blockDefinition.name, blockDefinition.value);
                        break;
                    case "arg-color-picker":
                        block = new ColorPickerArgumentBlock(blockDefinition.name, blockDefinition.value);
                        break;
                    case "pink":
                        block = createPinkBlock();
                        break;
                    case "blue":
                        block = createBlueBlock();
                        break;
                    case "red":
                        block = createRedBlock();
                        break;
                    case "green":
                        block = createGreenBlock();
                        break;
                    case "random":
                        block = createRandomColorBlock();
                        break;
                }

                if (blockDefinition.inner) {
                    block.connectInner(createBlock(blockDefinition.inner, workspace));
                }

                if (blockDefinition.nested) {
                    var i:uint = 0;
                    for each (var nestedDefinition:Object in blockDefinition.nested) {
                        if (nestedDefinition) {
                            block.connectNested(i, createBlock(nestedDefinition, workspace));
                        }
                        i++;
                    }
                }

                if (blockDefinition.args) {
                    block.removeAllArguments();
                    for each (var argDefitinion:Object in blockDefinition.args) {
                        block.addArgument(createBlock(argDefitinion, workspace, false) as ArgumentBlock);
                    }
                }
            }

            if (block) {
                block.enableConnections = true;
                if (registerBlock) {
                    workspace.registerBlock(block);
                }
            }
            return block;
        }

        //
        // Special Blocks
        //

        public static function createAnchorBlock(label:String):AnchorBlock {
            var block:AnchorBlock = new AnchorBlock(slugify(label));
            block.blockColor = 0x333366;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createFactoryBlock(func:Function, count:int=-1):FactoryBlock {
            return new FactoryBlock(func, count);
        }

        //
        // Movement Commands
        //

        public static function createForwardBlock():CommandBlock {
            return createCommandBlock1("Forward", "20");
        }

        public static function createBackwardBlock():CommandBlock {
            return createCommandBlock1("Backward", "20");
        }

        public static function createTurnRightBlock():CommandBlock {
            return createCommandBlock1("Turn Right", "45");
        }

        public static function createTurnLeftBlock():CommandBlock {
            return createCommandBlock1("Turn Left", "45");
        }

        //
        // Pen Commands
        //

        public static function createPenUpBlock():CommandBlock {
            return createCommandBlock0("Pen Up", 0x6666FF);
        }

        public static function createPenDownBlock():CommandBlock {
            return createCommandBlock0("Pen Down", 0x6666FF);
        }

        public static function createPenColorBlock():CommandBlock {
            var block:CommandBlock = createCommandBlock0("Set Pen Color", 0x6666FF);
            block.addArgument(new ColorPickerArgumentBlock("arg-color-picker"));
            return block;
        }

        public static function createBeginFillBlock():CommandBlock {
            var block:CommandBlock = createCommandBlock0("Begin Fill", 0x6666FF);
            block.addArgument(new ColorPickerArgumentBlock("arg-color-picker"));
            return block;
        }

        public static function createEndFillBlock():CommandBlock {
            var block:CommandBlock = createCommandBlock0("End Fill", 0x6666FF);
            return block;
        }

        //
        // Loops
        //

        public static function createRepeatBlock():SingleLogicBlock {
            var block:SingleLogicBlock = new SingleLogicBlock("repeat");
            block.blockColor = 0x2F6BF6;
            block.addContent(createBlockLabel("Repeat"));
            block.addArgument(new StringArgumentBlock("arg-string", "8"));
            return block;
        }

        //
        // Colors
        //

        public static function createRedBlock():ReporterBlock {
            return createColorBlock("Red", 0xFF0000);
        }

        public static function createGreenBlock():ReporterBlock {
            return createColorBlock("Green", 0x00FF00);
        }

        public static function createBlueBlock():ReporterBlock {
            return createColorBlock("Blue", 0x0000FF);
        }

        public static function createPinkBlock():ReporterBlock {
            return createColorBlock("Pink", 0xFF00FF);
        }

        public static function createRandomColorBlock():ReporterBlock {
            var block:ReporterBlock = new ReporterBlock("random", function():uint {
                return uint(Math.random() * 255)
                        | uint(Math.random() * 255 << 8)
                        | uint(Math.random() * 255 << 16);
            });
            block.socketType = SocketType.ROUND;
            block.blockColor = 0xCCCCCC;
            block.addContent(createBlockLabel("Random"));
            return block;
        }

        //
        // Helpers
        //

        private static function createCommandBlock0(label:String, color:uint=0x999AF8):CommandBlock {
            var block:CommandBlock = new CommandBlock(slugify(label));
            block.blockColor = color;
            block.addContent(createBlockLabel(label));
            return block;
        }

        private static function createCommandBlock1(label:String, arg:String="0", color:uint=0x999AF8):CommandBlock {
            var block:CommandBlock = new CommandBlock(slugify(label));
            block.blockColor = color;
            block.addContent(createBlockLabel(label));
            block.addArgument(new StringArgumentBlock("arg-string", arg));
            return block;
        }

        private static function createColorBlock(label:String, color:uint=0x000000):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(slugify(label), color);
            block.blockColor = color;
            block.addContent(createBlockLabel(label));
            return block;
        }

        private static function createBlockLabel(str:String, size:uint=12):Label {
            var blockLabel:Label = new Label();
            blockLabel.mouseChildren = false;
            blockLabel.text = str;
            blockLabel.setStyle("paddingTop", 2);
            blockLabel.setStyle("fontWeight", "bold");
            blockLabel.setStyle("color", 0xFFFFFF);
            blockLabel.setStyle("fontSize", size);
            return blockLabel;
        }

        private static function slugify(str:String):String {
            return str.split(" ").join("-").toLowerCase();
        }
    }
}
