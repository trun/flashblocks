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
    import flash.geom.Rectangle;

    import mx.binding.utils.ChangeWatcher;

    import mx.containers.Canvas;

    import mx.containers.HBox;
    import mx.containers.HDividedBox;

    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
import mx.controls.HSlider;
import mx.controls.Label;
import mx.core.UIComponent;
    import mx.events.FlexEvent;

    public class LogoBlocks extends Panel {
        private var workspace:Workspace;
        private var dragLayer:BlockDragLayer;
        private var interpreter:Interpreter;
        private var anchorBlock:Block;
        private var turtleCanvas:Panel;

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

            anchorBlock = BlockFactory.createAnchorBlock("LogoBlocks");
            var page:Page = new Page();
            page.width = 300;
            page.percentHeight = 100;
            page.addBlock(anchorBlock);
            divBox.addChild(page);
            workspace.registerWidget(page);

            var vBox:VBox = new VBox();
            vBox.percentWidth = 100;
            vBox.percentHeight = 100;
            divBox.addChild(vBox);

            turtleCanvas = new Panel();
            turtleCanvas.percentWidth = 100;
            turtleCanvas.percentHeight = 100;
            turtleCanvas.setStyle("horizontalAlign", "center");
            turtleCanvas.setStyle("verticalAlign", "middle");
            vBox.addChild(turtleCanvas);

            var controlBox:HBox = new HBox();
            controlBox.percentWidth = 100;
            controlBox.setStyle("horizontalGap", 10);
            vBox.addChild(controlBox);

            ChangeWatcher.watch(turtleCanvas, "width", onTurtleCanvasResize);
            ChangeWatcher.watch(turtleCanvas, "height", onTurtleCanvasResize);

            var drawingCanvas:LogoCanvas = new LogoCanvas();
            turtleCanvas.addChild(drawingCanvas);

            interpreter = new Interpreter(drawingCanvas);

            var resetBtn:Button = createControlButton("Reset");
            resetBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                drawingCanvas.reset();
            });

            var runBtn:Button = createControlButton("Run");
            runBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                runBtn.enabled = false;
                resetBtn.enabled = false;
                interpreter.execute(anchorBlock, null, function():void {
                    runBtn.enabled = true;
                    resetBtn.enabled = true;
                });
            });

            var jsonBtn:Button = createControlButton("JSON");
            jsonBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                var code:Array = [];
                for each (var block:Block in page.getAllBlocks()) {
                    code.push(block.toJSON());
                }
                trace(code);
            });

            var timeoutFasterLabel:Label = new Label();
            timeoutFasterLabel.text = "Faster";

            var timeoutSlowerLabel:Label = new Label();
            timeoutSlowerLabel.text = "Slower";

            var timeoutSlider:HSlider = new HSlider();
            timeoutSlider.maximum = 1000;
            timeoutSlider.minimum = 10;
            timeoutSlider.value = interpreter.timeout;
            timeoutSlider.snapInterval = 10;
            timeoutSlider.tickValues = [10, 50, 100, 250, 500, 1000];
            timeoutSlider.addEventListener(Event.CHANGE, function(e:Event):void {
                interpreter.timeout = timeoutSlider.value;
            });

            controlBox.addChild(resetBtn);
            controlBox.addChild(runBtn);
            controlBox.addChild(timeoutFasterLabel);
            controlBox.addChild(timeoutSlider);
            controlBox.addChild(timeoutSlowerLabel);
            //controlBox.addChild(jsonBtn);

            // drag layer must be registered on creation complete
            // otherwise the pop up layer will not be visible
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onTurtleCanvasResize(e:Event):void {
            turtleCanvas.scrollRect = new Rectangle(0, 0, turtleCanvas.width, turtleCanvas.height);
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

        private static function createControlButton(label:String):Button {
            var btn:Button = new Button();
            btn.percentHeight = 100;
            btn.percentWidth = 100;
            btn.label = label;
            btn.setStyle("backgroundColor", 0xCCCCCC);
            return btn;
        }
    }
}
