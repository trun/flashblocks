package com.flashblocks.blocks.args {
    import mx.controls.ColorPicker;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class ColorPickerArgumentBlock extends ArgumentBlock {

        private var colorPicker:ColorPicker;

        public function ColorPickerArgumentBlock(defaultValue:uint=0x000000, socketType:String="round", blockColor:uint=0xEEEEEE) {
            super(socketType, blockColor);

            hbox.removeAllChildren(); // get rid of the default graphic
            hbox.filters = [ ]; // get rid of the filter

            colorPicker = new ColorPicker();
            colorPicker.width = 40;
            colorPicker.selectedColor = defaultValue;
            hbox.addChild(colorPicker);
        }

    }

}
