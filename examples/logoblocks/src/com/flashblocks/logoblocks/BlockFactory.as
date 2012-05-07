package com.flashblocks.logoblocks {
    import com.flashblocks.blocks.AnchorBlock;
    import com.flashblocks.blocks.CommandBlock;
    import com.flashblocks.blocks.CommandBlock;
    import com.flashblocks.blocks.FactoryBlock;
    import com.flashblocks.blocks.ReporterBlock;
    import com.flashblocks.blocks.SingleLogicBlock;
    import com.flashblocks.blocks.args.ColorPickerArgumentBlock;
    import com.flashblocks.blocks.args.StringArgumentBlock;
    import com.flashblocks.blocks.sockets.SocketType;

    import mx.controls.Label;

    public class BlockFactory {

        public static function createAnchorBlock(label:String):AnchorBlock {
            var block:AnchorBlock = new AnchorBlock();
            block.blockColor = 0x333366;
            block.blockName = label;
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
            block.addContent(new ColorPickerArgumentBlock());
            block.blockName = "Set Pen Color";
            return block;
        }

        //
        // Loops
        //

        public static function createRepeatBlock():SingleLogicBlock {
            var block:SingleLogicBlock = new SingleLogicBlock();
            block.blockColor = 0x00CCCC;
            block.blockName = "Repeat";
            block.addContent(createBlockLabel("Repeat"));
            block.addContent(new StringArgumentBlock(5));
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

        //
        // Helpers
        //

        private static function createCommandBlock0(label:String, color:uint=0x336699):CommandBlock {
            var block:CommandBlock = new CommandBlock();
            block.blockColor = color;
            block.blockName = label;
            block.addContent(createBlockLabel(label));
            return block;
        }

        private static function createCommandBlock1(label:String, arg:String="0", color:uint=0x336699):CommandBlock {
            var block:CommandBlock = new CommandBlock();
            block.blockColor = color;
            block.blockName = label;
            block.addContent(createBlockLabel(label));
            block.addContent(new StringArgumentBlock(arg));
            return block;
        }

        private static function createColorBlock(label:String, color:uint=0x000000):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(color);
            block.blockColor = color;
            block.blockName = label;
            block.addContent(createBlockLabel(label));
            return block;
        }

        private static function createBlockLabel(str:String, size:uint=12):Label {
            var blockLabel:Label = new Label();
            blockLabel.mouseChildren = false;
            blockLabel.text = str;
            blockLabel.setStyle("fontWeight", "bold");
            blockLabel.setStyle("color", 0xFFFFFF);
            blockLabel.setStyle("fontSize", size);
            return blockLabel;
        }
    }
}
