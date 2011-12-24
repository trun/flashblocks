package com.flashblocks.util {
    import com.flashblocks.blocks.Block;
    import flash.display.DisplayObject;
    import flash.geom.Point;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockUtil {

        public static function positionGlobalToLocal(block:Block, obj:DisplayObject):Point {
            if (!block.parent)
                return new Point(0, 0);
            return obj.globalToLocal(new Point(block.x, block.y));
        }

        public static function positionLocalToGlobal(block:Block, obj:DisplayObject):Point {
            if (!block.parent)
                return new Point(0, 0);
            return obj.localToGlobal(new Point(block.x, block.y));
        }

        public static function positionLocalToLocal(block:Block, obj1:DisplayObject, obj2:DisplayObject):Point {
            return obj2.globalToLocal(positionLocalToGlobal(block, obj1));
        }

    }

}
