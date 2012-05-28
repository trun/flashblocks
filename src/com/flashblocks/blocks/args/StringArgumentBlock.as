package com.flashblocks.blocks.args {
    import flash.events.Event;
    import mx.controls.TextInput;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class StringArgumentBlock extends ArgumentBlock {

        private var textInput:TextInput;
        private var MIN_WIDTH:Number = 30;

        public function StringArgumentBlock(blockName:String, defaultValue:*="") {
            super(blockName, defaultValue);
        }

        override public function redraw():void {
            super.redraw();

            hbox.removeAllChildren(); // get rid of the default graphic
            hbox.filters = [ ];

            textInput = new TextInput();
            textInput.text = String(blockValue);
            textInput.width = MIN_WIDTH;
            textInput.addEventListener(Event.CHANGE, function(e:Event):void {
                _blockValue = textInput.text;
                textInput.width = Math.max(MIN_WIDTH, textInput.textWidth + 20);
            });
            hbox.addChild(textInput);
        }

        override public function set blockValue(value:*):void {
            if (textInput) {
                textInput.text = String(blockValue);
            }
            _blockValue = value;
        }

    }

}
