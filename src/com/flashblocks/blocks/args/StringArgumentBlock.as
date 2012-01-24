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

        public function StringArgumentBlock(defaultValue:*="", socketType:String="round", blockColor:uint=0xEEEEEE) {
            super(socketType, blockColor);

            hbox.removeAllChildren(); // get rid of the default graphic
            hbox.filters = [ ];

            textInput = new TextInput();
            textInput.text = String(defaultValue);
            textInput.width = MIN_WIDTH;
            textInput.addEventListener(Event.CHANGE, updateWidth);
            hbox.addChild(textInput);
        }

        private function updateWidth(e:Event = null):void {
            textInput.width = Math.max(MIN_WIDTH, textInput.textWidth + 20);
        }

        override public function getValue():* {
            if (inner) {
                return null; // TODO
            }
            return textInput.text;
        }

    }

}
