package com.flashblocks.sandbox {
    import com.flashblocks.BlockDragLayer;
    import com.flashblocks.Page;
    import com.flashblocks.Palette;
    import com.flashblocks.PaletteList;
    import com.flashblocks.Workspace;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.sandbox.BlockFactory;
    import com.flashblocks.blocks.ProcedureBlock;
    import com.flashblocks.blocks.SingleLogicBlock;
    import com.flashblocks.blocks.args.ArgumentBlock;
    import com.flashblocks.blocks.args.StringArgumentBlock;
    import com.flashblocks.blocks.sockets.SocketType;

    import flash.events.Event;

    import mx.containers.HBox;

    import mx.containers.Panel;
    import mx.controls.Label;
    import mx.controls.Spacer;
    import mx.events.FlexEvent;

    public class Sandbox extends Panel {
        private var workspace:Workspace;
        private var dragLayer:BlockDragLayer;

        public function Sandbox() {
            percentWidth = 100;
            percentHeight = 100;
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);

            workspace = Workspace.getInstance();

            dragLayer = new BlockDragLayer();
            workspace.registerWidget(dragLayer);

            var divBox:HBox = new HBox();
            divBox.percentWidth = 100;
            divBox.percentHeight = 100;
            addChild(divBox);

            var paletteList:PaletteList = new PaletteList();
            paletteList.percentHeight = 100;
            divBox.addChild(paletteList);

            var palette:Palette = addPalette("Movement", paletteList);
            var logicPalette:Palette = addPalette("Logic", paletteList);
            var mathPalette:Palette = addPalette("Math", paletteList);
            var procedurePalette:Palette = addPalette("Procedure", paletteList);
            var colorPalette:Palette = addPalette("Colors", paletteList);

            var page:Page = new Page();
            page.percentWidth = 100;
            page.percentHeight = 100;
            page.addBlock(BlockFactory.createAnchorBlock("MyProgram"));
            divBox.addChild(page);
            workspace.registerWidget(page);

            var block:Block;
            block = new ProcedureBlock();
            block.blockColor = 0x993333;
            block.addContent(blockLabel("Navigation"));
            workspace.registerBlock(block);
            procedurePalette.addBlock(block);

            var spacer:Spacer = new Spacer();
            spacer.width = 25;
            block = new SingleLogicBlock();
            block.blockColor = 0xCC3300;
            block.addContent(blockLabel("If"));
            block.addContent(spacer);
            block.addContent(new ArgumentBlock());
            workspace.registerBlock(block);
            logicPalette.addBlock(block);

            block = new SingleLogicBlock();
            block.blockColor = 0xCC3300;
            block.addContent(blockLabel("Repeat"));
            block.addContent(new StringArgumentBlock());
            workspace.registerBlock(block);
            logicPalette.addBlock(block);

            block = new SingleLogicBlock();
            block.blockColor = 0x3366FF;
            block.addContent(blockLabel("Forever"));
            workspace.registerBlock(block);
            logicPalette.addBlock(block);

            block = BlockFactory.createMoveBlock("Move Forward");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createMoveBlock("Move Backward");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createTurnBlock("Turn To");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("North");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("South");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("East");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("East");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("West");
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBooleanReporterBlock("Facing?");
            block.addContent(new ArgumentBlock());
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBooleanReporterBlock("Not");
            block.addContent(new ArgumentBlock());
            workspace.registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("+");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("-");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("x");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("/");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("^");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("&");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("|");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("mod");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("<<");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock(">>");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createUnaryMathReporterBlock("-");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createUnaryMathReporterBlock("~");
            workspace.registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Forward");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Forward");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Forward");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Backward");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Left");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Right");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenNumCommandBlock("Right");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenCommandBlock("Pen Up");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenCommandBlock("Pen Down");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenArgCommandBlock("Set Pen Color");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createPenAltCommandBlock("Set Pen Color");
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Red", 0x990000);
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Green", 0x009900);
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Blue", 0x0000FF);
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Pink", 0xFF00FF);
            workspace.registerBlock(block);
            colorPalette.addBlock(block);

            // drag layer must be registered on creation complete
            // otherwise the pop up layer will not be visible
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(e:Event):void {
            dragLayer.registerContainer(this);
        }

        public function addPalette(name:String, paletteList:PaletteList):Palette {
            var palette:Palette = new Palette();
            palette.name = palette.label = name;
            paletteList.addPalette(palette);
            workspace.registerWidget(palette);
            return palette;
        }

        private function blockLabel(str:String, size:uint=12):Label {
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
