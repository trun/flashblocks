package com.flashblocks.blocks {
    import com.flashblocks.blocks.render.*;
    import com.flashblocks.blocks.sockets.SocketType;
    import com.flashblocks.util.BlockUtil;
    import flash.geom.Point;
    import mx.binding.utils.BindingUtils;
    import mx.containers.VBox;
    import mx.controls.Label;
    import mx.core.UIComponent;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class CommandBlock extends SimpleBlock {

        public function CommandBlock(socketType:String="square", blockColor:uint=0x66FF66) {
            super(socketType, "", blockColor);

            blockType = BlockType.COMMAND;

            topMidBox.addChild(new BlockNotchTop(blockColor));
            topMidBox.addChild(new BlockFlatTop(blockColor));

            bottomMidBox.addChild(new BlockNotchBottom(blockColor));
            bottomMidBox.addChild(new BlockFlatBottom(blockColor));
        }

        override public function connectOlderSibling(block:Block):void {
            if (olderSibling) {
                olderSibling.connectYoungerSibling(block);
            } else {
                parent.addChild(block);
                block.x = this.x;
                block.y = this.y - block.height;
            }

            block.connectYoungerSibling(this);
        }

        override public function connectYoungerSibling(block:Block):void {
            addChild(block);

            block.x = 0;
            block.y = hbox.height;

            if (youngerSibling)
                block.connectYoungerSibling(youngerSibling);

            block.olderSibling = this;
            this.youngerSibling = block;
        }

        override public function testOlderSiblingConnection(block:Block):Boolean {
            if (!block.hasYoungerSiblingPort())
                return false;
            if (block.youngerSibling != null)
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this.parent);

            return hbox.hitTestObject(block) && (p.y < this.y);
        }

        override public function testYoungerSiblingConnection(block:Block):Boolean {
            if (!block.hasYoungerSiblingPort())
                return false;

            var p:Point = BlockUtil.positionLocalToLocal(block, block.parent, this);

            return hbox.hitTestObject(block) && (p.y > hbox.height - 10);
        }

        override public function hasOlderSiblingPort():Boolean {
            return true;
        }

        override public function hasYoungerSiblingPort():Boolean {
            return true;
        }

    }

}
