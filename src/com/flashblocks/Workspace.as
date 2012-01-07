﻿package com.flashblocks {
    import com.flashblocks.blocks.args.ArgumentBlock;
    import com.flashblocks.blocks.args.StringArgumentBlock;
    import com.flashblocks.blocks.Block;
    import com.flashblocks.blocks.BlockFactory;
    import com.flashblocks.blocks.CommandBlock;
    import com.flashblocks.blocks.ControlLogicBlock;
    import com.flashblocks.blocks.ProcedureBlock;
    import com.flashblocks.blocks.ReporterBlock;
    import com.flashblocks.blocks.SingleLogicBlock;
    import com.flashblocks.events.BlockDragEvent;
    import com.flashblocks.blocks.sockets.SocketType;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.binding.utils.BindingUtils;
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.HBox;
    import mx.containers.HDividedBox;
    import mx.containers.Panel;
    import mx.containers.TitleWindow;
    import mx.containers.VBox;
    import mx.controls.Label;
    import mx.controls.Spacer;
    import mx.core.IFlexDisplayObject;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;

    /**
     * ...
     * @author Trevor Rundell
     */

    [Event(name="dragStart", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragComplete", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragDrop", type="com.flashblocks.events.BlockDragEvent")]
    public class Workspace extends Panel {

        private var divBox:HBox;

        private var paletteHolder:PaletteHolder;
        private var pageHolder:PageHolder;
        private var dragLayer:BlockDragLayer;

        private var widgets:Array;

        public function Workspace() {
            super();

            title = "Flashblocks - Demo Workspace";

            percentWidth = 100;
            percentHeight = 100;
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);

            widgets = new Array();

            dragLayer = new BlockDragLayer(); // popup
            registerWidget(dragLayer);

            divBox = new HBox();
            divBox.percentWidth = 100;
            divBox.percentHeight = 100;
            this.addChild(divBox);

            paletteHolder = new PaletteHolder();
            paletteHolder.percentHeight = 100;
            divBox.addChild(paletteHolder);

            pageHolder = new PageHolder();
            pageHolder.percentWidth = 100;
            pageHolder.percentHeight = 100;
            divBox.addChild(pageHolder);

            var palette:Palette = addPalette("Movement");
            var logicPalette:Palette = addPalette("Logic");
            var mathPalette:Palette = addPalette("Math");
            var procedurePalette:Palette = addPalette("Procedure");
            var colorPalette:Palette = addPalette("Colors");

            addPage("Page 1");
            addPage("Page 2");
            addPage("Page 3");
            addPage("Page 4");

            var block:Block;

            block = new ProcedureBlock(SocketType.SQUARE, 0x993333);
            block.addContent(blockLabel("Navigation"));
            registerBlock(block);
            procedurePalette.addBlock(block);

            var spacer:Spacer = new Spacer();
            spacer.width = 25;
            block = new SingleLogicBlock(SocketType.SQUARE, 0xCC3300);
            block.addContent(blockLabel("If"));
            block.addContent(spacer);
            block.addContent(new ArgumentBlock());
            registerBlock(block);
            logicPalette.addBlock(block);

            block = new SingleLogicBlock(SocketType.SQUARE, 0x3366FF);
            block.addContent(blockLabel("Forever"));
            registerBlock(block);
            logicPalette.addBlock(block);

            block = BlockFactory.createMoveBlock("Move Forward");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createMoveBlock("Move Backward");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createTurnBlock("Turn To");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("North");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("South");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("East");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("East");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createPositionReporterBlock("West");
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBooleanReporterBlock("Facing?");
            block.addContent(new ArgumentBlock());
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBooleanReporterBlock("Not");
            block.addContent(new ArgumentBlock());
            registerBlock(block);
            palette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("+");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("-");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("x");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("/");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("^");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("&");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("|");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("mod");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock("<<");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createBinaryMathReporterBlock(">>");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createUnaryMathReporterBlock("-");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createUnaryMathReporterBlock("~");
            registerBlock(block);
            mathPalette.addBlock(block);

            block = BlockFactory.createPenCommandBlock("Set Pen Color");
            registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createAltPenCommandBlock("Set Pen Color");
            registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Red", 0x990000);
            registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Green", 0x009900);
            registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Blue", 0x0000FF);
            registerBlock(block);
            colorPalette.addBlock(block);

            block = BlockFactory.createColorReporterBlock("Pink", 0xFF00FF);
            registerBlock(block);
            colorPalette.addBlock(block);

            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }

        private function onCreationComplete(e:FlexEvent):void {
            dragLayer.registerWorkspace(this);
        }

        public function addPage(name:String):Page {
            var page:Page = new Page();
            page.name = page.label = name;
            pageHolder.addChild(page);
            registerWidget(page);
            return page;
        }

        public function addPalette(name:String):Palette {
            var palette:Palette = new Palette();
            palette.name = palette.label = name;
            paletteHolder.addPalette(palette);
            registerWidget(palette);
            return palette;
        }

        public function registerWidget(widget:IWorkspaceWidget):void {
            widget.registerWorkspace(this);
            widgets.push(widget);
        }

        public function registerBlock(block:Block):void {
            block.addEventListener(BlockDragEvent.DRAG_START, rebroadcastEvent);
            block.addEventListener(BlockDragEvent.DRAG_COMPLETE, rebroadcastEvent);
        }

        public function getWidgets():Array {
            return widgets.concat();
        }

        //
        // EVENT REBROADCASTING
        //

        public function rebroadcastEvent(e:Event):void {
            dispatchEvent(e);
        }

        //
        // BLOCK BUILDING HELPER METHODS
        //

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
