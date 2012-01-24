package com.flashblocks.logoblocks {
    import com.flashblocks.BlockDragLayer;
    import com.flashblocks.Page;
    import com.flashblocks.Palette;
    import com.flashblocks.PaletteList;
    import com.flashblocks.Workspace;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.FactoryBlock;
    import com.flashblocks.logoblocks.BlockFactory;
    import com.flashblocks.logoblocks.interpreter.Interpreter;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.containers.Canvas;

    import mx.containers.HBox;
    import mx.containers.HDividedBox;

    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;

    public class LogoBlocks extends Panel {
        private var workspace:Workspace;
        private var dragLayer:BlockDragLayer;
        private var interpreter:Interpreter;
        private var anchorBlock:Block;

        public function LogoBlocks() {
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
            var colorPalette:Palette = addPalette("Colors", paletteList);

            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createForwardBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createBackwardBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createTurnLeftBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createTurnRightBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createRepeatBlock), palette);

            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenUpBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenDownBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenColorBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createRedBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createGreenBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createBlueBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPinkBlock), colorPalette);

            var vBox:VBox = new VBox();
            vBox.width = 300;
            vBox.percentHeight = 100;
            divBox.addChild(vBox);

            anchorBlock = BlockFactory.createAnchorBlock("LogoBlocks");
            var page:Page = new Page();
            page.percentWidth = 100;
            page.percentHeight = 100;
            page.addBlock(anchorBlock);
            vBox.addChild(page);
            workspace.registerWidget(page);

            var controlBox:HBox = new HBox();
            controlBox.percentWidth = 100;
            controlBox.height = 50;
            controlBox.setStyle("horizontalGap", 0);
            vBox.addChild(controlBox);

            var runBtn:Button = createControlButton("Run");
            runBtn.addEventListener(MouseEvent.CLICK, onRunClick);

            controlBox.addChild(createControlButton("Reset"));
            controlBox.addChild(runBtn);
            controlBox.addChild(createControlButton("Run All"));

            var turtleCanvas:Panel = new Panel();
            turtleCanvas.percentWidth = 100;
            turtleCanvas.percentHeight = 100;
            turtleCanvas.setStyle("backgroundColor", 0x000000);
            divBox.addChild(turtleCanvas);

            var drawingCanvas:UIComponent = new UIComponent();
            drawingCanvas.percentWidth = 100;
            drawingCanvas.percentHeight = 100;
            turtleCanvas.addChild(drawingCanvas);

            interpreter = new Interpreter(drawingCanvas);

            // drag layer must be registered on creation complete
            // otherwise the pop up layer will not be visible
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onRunClick(e:MouseEvent):void {
            interpreter.execute(anchorBlock);
        }

        private function onCreationComplete(e:Event):void {
            dragLayer.registerContainer(this);
        }

        private function addBlock(block:Block, palette:Palette):Block {
            workspace.registerBlock(block);
            palette.addBlock(block);
            return block;
        }

        private function addPalette(name:String, paletteList:PaletteList):Palette {
            var palette:Palette = new Palette();
            palette.name = palette.label = name;
            paletteList.addPalette(palette);
            workspace.registerWidget(palette);
            return palette;
        }

        private function createControlButton(label:String):Button {
            var btn:Button = new Button();
            btn.percentHeight = 100;
            btn.percentWidth = 100;
            btn.label = label;
            btn.setStyle("backgroundColor", 0xCCCCCC);
            return btn;
        }
    }
}
