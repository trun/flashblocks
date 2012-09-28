package com.flashblocks.blocks.args {
    import com.flashblocks.blocks.Block;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.filters.GlowFilter;

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
            textInput.setStyle("cornerRadius", 5);
            textInput.setStyle("borderStyle", "solid");
            textInput.addEventListener(Event.CHANGE, function(e:Event):void {
                _blockValue = textInput.text;
                textInput.width = Math.max(MIN_WIDTH, textInput.textWidth + 20);
            });
            textInput.addEventListener(FocusEvent.FOCUS_IN, function(e:Event):void {
                textInput.setSelection(0, textInput.text.length);
            });
            hbox.addChild(textInput);
        }

        override public function set blockValue(value:*):void {
            if (textInput) {
                textInput.text = String(blockValue);
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
