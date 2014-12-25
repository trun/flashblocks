package com.flashblocks.sandbox {
    import com.flashblocks.blocks.*;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.blocks.args.*;
    import mx.controls.Label;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockFactory {

        public static function createAnchorBlock(label:String):AnchorBlock {
            var block:AnchorBlock = new AnchorBlock(label);
            block.blockColor = 0x333366;
            block.addContent(createBlockLabel(label, 14, "center"));
            return block;
        }

        public static function createBinaryMathReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(label);
            block.blockColor = 0x333366;
            block.addContent(new StringArgumentBlock("arg0", "0"));
            block.addContent(createBlockLabel(label, 14, "center"));
            block.addContent(new StringArgumentBlock("arg1", "0"));
            return block;
        }

        public static function createUnaryMathReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(label);
            block.blockColor = 0x666699;
            block.addContent(createBlockLabel(label, 14, "center"));
            block.addContent(new StringArgumentBlock("arg0", "0"));
            return block;
        }

        public static function createPositionReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(label);
            block.blockColor = 0xCC00CC;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createBooleanReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(label);
            block.blockColor = 0x990099;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createColorReporterBlock(label:String, color:uint):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(label);
            block.blockColor = color;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createMovementCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x9999FF;
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock("arg0"));
            return block;
        }

        public static function createPenCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x6666FF;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createPenArgCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x6666FF;
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock("arg0"));
            return block;
        }

        public static function createPenNumCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x6666FF;
            block.addContent(createBlockLabel(label));
            block.addContent(new StringArgumentBlock("arg0"));
            return block;
        }

        public static function createPenAltCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x6666FF;
            block.addContent(createBlockLabel(label));
            block.addContent(new ColorPickerArgumentBlock("arg0"));
            return block;
        }

        public static function createMoveBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x9999FF;
            block.addContent(createBlockLabel(label));
            return block;
        }

        public static function createTurnBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(label);
            block.blockColor = 0x9999FF;
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock("arg0"));
            return block;
        }

        private static function createBlockLabel(label:String, size:uint=12, align:String="left"):Label {
            var blockLabel:Label = new Label();
            blockLabel.mouseChildren = false;
            blockLabel.text = label;
            blockLabel.setStyle("fontWeight", "bold");
            blockLabel.setStyle("fontSize", size);
            blockLabel.setStyle("textAlign", align);
            blockLabel.setStyle("color", 0xFFFFFF);
            return blockLabel;
        }

    }

}
