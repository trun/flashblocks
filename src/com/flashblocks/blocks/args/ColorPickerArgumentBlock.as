﻿package com.flashblocks.blocks.args {
    import mx.controls.ColorPicker;

    public class ColorPickerArgumentBlock extends ArgumentBlock {

        private var colorPicker:ColorPicker;

        public function ColorPickerArgumentBlock(defaultValue:uint=0x000000) {
            super(defaultValue);

            hbox.removeAllChildren(); // get rid of the default graphic
            hbox.filters = [ ]; // get rid of the filter

            colorPicker = new ColorPicker();
            colorPicker.width = 40;
            colorPicker.selectedColor = defaultValue;
            hbox.addChild(colorPicker);
        }

        override public function getValue():* {
            return colorPicker.selectedColor;
        }

    }

}
