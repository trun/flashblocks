package com.flashblocks.blocks.args {
    import com.flashblocks.blocks.Block;

    import flash.events.Event;
    import flash.filters.GlowFilter;

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
                _blockValue = colorPicker.selectedColor;
            });
            hbox.addChild(colorPicker);
        }

        override public function set blockValue(value:*):void {
            if (colorPicker) {
                colorPicker.selectedColor = value;
            }
            _blockValue = value;
        }

        override public function overInner(block:Block):void {
            hbox.filters = [ new GlowFilter(0x00FFFF, 1.0, 2, 2, 255, 3, true) ];
        }

        override public function outInner(block:Block):void {
            hbox.filters = [ ];
        }

    }

}
