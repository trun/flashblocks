package com.flashblocks {
    import mx.containers.HBox;
    import mx.containers.ViewStack;
    import mx.controls.LinkBar;
    import mx.controls.VRule;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class PaletteList extends HBox {

        private var tabStack:LinkBar;
        private var viewStack:ViewStack;

        public function PaletteList() {
            super();

            setStyle("borderStyle", "solid");
            setStyle("verticalAlign", "middle");
            setStyle("paddingLeft", 10);
            setStyle("paddingRight", 10);
            setStyle("paddingTop", 10);
            setStyle("paddingBottom", 10);

            viewStack = new ViewStack();
            viewStack.width = 200;
            viewStack.percentHeight = 100;

            tabStack = new LinkBar();
            tabStack.percentHeight = 100;
            tabStack.dataProvider = viewStack;
            tabStack.direction = "vertical";
            addChild(tabStack);

            var vrule:VRule = new VRule();
            vrule.percentHeight = 95;
            addChild(vrule);

            addChild(viewStack);
        }

        public function addPalette(palette:Palette):void {
            viewStack.addChild(palette);
        }

    }

}
