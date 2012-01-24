﻿package com.flashblocks.sandbox {
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
            var block:AnchorBlock = new AnchorBlock(SocketType.SLANT, 0x333366);
            block.addContent(createBlockLabel(label, 14, "center"));
            block.blockName = label;
            return block;
        }

        public static function createBinaryMathReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(SocketType.ANGLE, 0x333366);
            block.addContent(new StringArgumentBlock(0));
            block.addContent(createBlockLabel(label, 14, "center"));
            block.addContent(new StringArgumentBlock(0));
            block.blockName = label;
            return block;
        }

        public static function createUnaryMathReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(SocketType.ANGLE, 0x666699);
            block.addContent(createBlockLabel(label, 14, "center"));
            block.addContent(new StringArgumentBlock(0));
            block.blockName = label;
            return block;
        }

        public static function createPositionReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(SocketType.ANGLE, 0xCC00CC);
            block.addContent(createBlockLabel(label));
            block.blockName = label;
            return block;
        }

        public static function createBooleanReporterBlock(label:String):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(SocketType.ROUND, 0x990099);
            block.addContent(createBlockLabel(label));
            block.blockName = label;
            return block;
        }

        public static function createColorReporterBlock(label:String, color:uint):ReporterBlock {
            var block:ReporterBlock = new ReporterBlock(SocketType.ANGLE, color);
            block.addContent(createBlockLabel(label));
            block.blockName = label;
            return block;
        }

        public static function createMovementCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x9999FF);
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock());
            block.blockName = label;
            return block;
        }

        public static function createPenCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x6666FF);
            block.addContent(createBlockLabel(label));
            block.blockName = label;
            return block;
        }

        public static function createPenArgCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x6666FF);
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock());
            block.blockName = label;
            return block;
        }

        public static function createPenNumCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x6666FF);
            block.addContent(createBlockLabel(label));
            block.addContent(new StringArgumentBlock());
            block.blockName = label;
            return block;
        }

        public static function createPenAltCommandBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x6666FF);
            block.addContent(createBlockLabel(label));
            block.addContent(new ColorPickerArgumentBlock());
            block.blockName = label;
            return block;
        }

        public static function createMoveBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x9999FF);
            block.addContent(createBlockLabel(label));
            block.blockName = label;
            return block;
        }

        public static function createTurnBlock(label:String):CommandBlock {
            var block:CommandBlock = new CommandBlock(SocketType.SQUARE, 0x9999FF);
            block.addContent(createBlockLabel(label));
            block.addContent(new ArgumentBlock());
            block.blockName = label;
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