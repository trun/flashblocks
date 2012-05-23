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
            textInput.addEventListener(Event.CHANGE, updateWidth);
            hbox.addChild(textInput);
        }

        private function updateWidth(e:Event = null):void {
            blockValue = textInput.text;
            textInput.width = Math.max(MIN_WIDTH, textInput.textWidth + 20);
        }

    }

}
