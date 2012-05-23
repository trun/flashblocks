package com.flashblocks.blocks.args {
import flash.events.Event;

import mx.controls.ColorPicker;

    public class ColorPickerArgumentBlock extends ArgumentBlock {

        private var colorPicker:ColorPicker;

        public function ColorPickerArgumentBlock(blockName:String, defaultValue:uint=0x000000) {
            super(blockName, defaultValue);
        }

        override public function redraw():void {
            super.redraw();

            hbox.removeAllChildren(); // get rid of the default graphic
            hbox.filters = [ ]; // get rid of the filter

            colorPicker = new ColorPicker();
            colorPicker.width = 40;
            colorPicker.selectedColor = blockValue;
            colorPicker.addEventListener(Event.CHANGE, function(e:Event):void {
                blockValue = colorPicker.selectedColor;
            });
            hbox.addChild(colorPicker);
        }

        override public function set blockValue(value:*):void {
            if (colorPicker) {
                colorPicker.selectedColor = value;
            }
            super.blockValue = value;
        }

    }

}
