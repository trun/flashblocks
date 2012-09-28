package com.flashblocks.logoblocks {
    import com.adobe.serialization.json.JSON;
    import com.flashblocks.BlockDragLayer;
    import com.flashblocks.Page;
    import com.flashblocks.Palette;
    import com.flashblocks.PaletteList;
    import com.flashblocks.Workspace;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.logoblocks.interpreter.Interpreter;
    import com.flashblocks.logoblocks.render.ImageAssets;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    import flash.net.SharedObject;

    import mx.binding.utils.ChangeWatcher;
    import mx.containers.HBox;
    import mx.containers.HDividedBox;
    import mx.containers.Panel;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.HSlider;
    import mx.controls.Image;
    import mx.controls.Label;
    import mx.events.FlexEvent;
    import mx.graphics.ImageSnapshot;
    import mx.graphics.ImageSnapshot;

    public class LogoBlocks extends VBox {
        private var workspace:Workspace;
        private var dragLayer:BlockDragLayer;
        private var interpreter:Interpreter;
        private var anchorBlock:Block;
        private var turtleCanvas:Panel;
        private var isOwner:Boolean = true;

        public function LogoBlocks() {
            percentWidth = 100;
            percentHeight = 100;
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);
            setStyle("backgroundColor", 0xffffff);

            workspace = Workspace.getInstance();

            dragLayer = new BlockDragLayer();
            workspace.registerWidget(dragLayer);

            var divBox:HBox = new HBox();
            divBox.percentWidth = 100;
            divBox.percentHeight = 100;
            addChild(divBox);

            var paletteList:PaletteList = new PaletteList();
            paletteList.percentHeight = 100;
            workspace.registerWidget(paletteList);
            divBox.addChild(paletteList);

            var palette:Palette = addPalette("Movement", paletteList);
            var colorPalette:Palette = addPalette("Colors", paletteList);

            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createRepeatBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createForwardBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createBackwardBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createTurnLeftBlock), palette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createTurnRightBlock), palette);

            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenUpBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenDownBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPenColorBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createRedBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createGreenBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createBlueBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createPinkBlock), colorPalette);
            addBlock(BlockFactory.createFactoryBlock(BlockFactory.createRandomColorBlock), colorPalette);

            var hDivBox:HDividedBox = new HDividedBox();
            hDivBox.percentWidth = 100;
            hDivBox.percentHeight = 100;
            divBox.addChild(hDivBox);

            anchorBlock = BlockFactory.createAnchorBlock("LogoBlocks");
            var page:Page = new Page();
            page.width = 300;
            page.percentHeight = 100;
            page.addBlock(anchorBlock);
            hDivBox.addChild(page);
            workspace.registerWidget(page);

            var vBox:VBox = new VBox();
            vBox.percentWidth = 100;
            vBox.percentHeight = 100;
            hDivBox.addChild(vBox);

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

            // zoom controls
            turtleCanvas.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void {
                if (e.delta > 0 && drawingCanvas.scaleX < 2) {
                    drawingCanvas.scaleX += .1;
                    drawingCanvas.scaleY += .1;
                } else if (e.delta < 0 && drawingCanvas.scaleY > .5) {
                    drawingCanvas.scaleX -= .1;
                    drawingCanvas.scaleY -= .1;
                }
            });

            // pan controls
            var panCanvas:Boolean = false;
            turtleCanvas.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
                panCanvas = true;
            });

            turtleCanvas.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
                panCanvas = false;
            });

            var turtleMouseX:int;
            var turtleMouseY:int;
            turtleCanvas.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {
                var turleMouseDeltaX:int = e.localX - turtleMouseX;
                var turleMouseDeltaY:int = e.localY - turtleMouseY;
                if (e.buttonDown && panCanvas) {
                    drawingCanvas.x += turleMouseDeltaX;
                    drawingCanvas.y += turleMouseDeltaY;
                } else {
                    panCanvas = false;
                }
                turtleMouseX = e.localX;
                turtleMouseY = e.localY;
            });

            interpreter = new Interpreter(drawingCanvas);

            var lockIcon:Image = new Image();
            lockIcon.toolTip = 'You own this program';
            lockIcon.data = ImageAssets.LOCK_ICON;

            var resetBtn:Button = new Button();
            resetBtn.width = 50;
            resetBtn.toolTip = "Reset";
            resetBtn.buttonMode = true;
            resetBtn.setStyle("icon", ImageAssets.RESET_ICON);
            resetBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                interpreter.reset();
            });

            var runBtn:Button = new Button();
            runBtn.width = 50;
            runBtn.toolTip = "Run";
            runBtn.buttonMode = true;
            runBtn.setStyle("icon", ImageAssets.PLAY_ICON);
            runBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                runBtn.enabled = false;
                resetBtn.enabled = false;
                interpreter.execute(anchorBlock, null, function():void {
                    runBtn.enabled = true;
                    resetBtn.enabled = true;
                    if (ExternalInterface.available && isOwner) {
                        ExternalInterface.call("logoblocksCanvasDrawComplete");
                    }
                });
            });

            var saveBtn:Button = new Button();
            saveBtn.buttonMode = true;
            saveBtn.toolTip = 'Save this program';
            saveBtn.setStyle("icon", ImageAssets.SAVE_ICON);
            saveBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                if (ExternalInterface.available) {
                    ExternalInterface.call("logoblocksCanvasUpdate");
                }
            });

            var forkBtn:Button = new Button();
            forkBtn.buttonMode = true;
            forkBtn.toolTip = 'Fork this program';
            forkBtn.setStyle("icon", ImageAssets.FORK_ICON);
            forkBtn.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                if (ExternalInterface.available) {
                    ExternalInterface.call("logoblocksCanvasFork");
                }
            });

            var timeoutFasterLabel:Label = new Label();
            timeoutFasterLabel.text = "Faster";

            var timeoutSlowerLabel:Label = new Label();
            timeoutSlowerLabel.text = "Slower";

            var timeoutSlider:HSlider = new HSlider();
            timeoutSlider.percentWidth = 100;
            timeoutSlider.maximum = 1000;
            timeoutSlider.minimum = 10;
            timeoutSlider.value = interpreter.timeout;
            timeoutSlider.snapInterval = 10;
            timeoutSlider.tickValues = [10, 50, 100, 250, 500, 1000];
            timeoutSlider.liveDragging = true;
            timeoutSlider.addEventListener(Event.CHANGE, function(e:Event):void {
                interpreter.timeout = timeoutSlider.value;
            });

            controlBox.addChild(saveBtn);
            controlBox.addChild(forkBtn);
            controlBox.addChild(resetBtn);
            controlBox.addChild(runBtn);
            controlBox.addChild(timeoutFasterLabel);
            controlBox.addChild(timeoutSlider);
            controlBox.addChild(timeoutSlowerLabel);
            controlBox.addChild(lockIcon);

            // ExternalInterface callbacks
            if (ExternalInterface.available) {
                ExternalInterface.addCallback('getBlocksJSON', function():String {
                    return JSON.encode(getBlocks());
                });
                ExternalInterface.addCallback('setBlocksJSON', function(s:String):void {
                    setBlocks(JSON.decode(s));
                });
                ExternalInterface.addCallback('setOwner', function(val:Boolean):void {
                    saveBtn.enabled = val;
                    isOwner = val;
                    if (!val) {
                        lockIcon.toolTip = 'You do NOT own this program';
                        lockIcon.data = ImageAssets.UNLOCK_ICON;
                    } else {
                        lockIcon.toolTip = 'You own this program';
                        lockIcon.data = ImageAssets.LOCK_ICON;
                    }
                });
                ExternalInterface.addCallback('getSnapshot', function():String {
                    return ImageSnapshot.encodeImageAsBase64(drawingCanvas.snapshot());
                });
                ExternalInterface.call('logoblocksCanvasReady');
            }

            // drag layer must be registered on creation complete
            // otherwise the pop up layer will not be visible
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function getBlocks():Object {
            var code:Object = anchorBlock.toJSON();
            if (code is Array) {
                code = code.slice(1);
            } else {
                code = [];
            }
            return code;
        }

        private function setBlocks(code:Object):void {
            // clear existing program
            if (anchorBlock.after) {
                anchorBlock.removeChild(anchorBlock.after);
                anchorBlock.cleanAfterConnections();
            }

            anchorBlock.connectAfter(BlockFactory.createBlock(code, workspace));
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
