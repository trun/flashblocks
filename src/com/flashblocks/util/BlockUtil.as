package com.flashblocks.util {
    import com.flashblocks.blocks.Block;
    import flash.display.DisplayObject;
    import flash.geom.Point;

    import mx.core.Container;

    /**
     * ...
     * @author Trevor Rundell
     */
    public class BlockUtil {

        public static function positionGlobalToLocal(block:Block, obj:DisplayObject):Point {
            var p:Point = block.parent ? new Point(block.x, block.y) : new Point(0, 0);
            if (obj is Container) {
                var c:Container = obj as Container;
                p.x += c.horizontalScrollPosition;
                p.y += c.verticalScrollPosition;
            }
            return obj.globalToLocal(p);
        }

        public static function positionLocalToGlobal(block:Block, obj:DisplayObject):Point {
            if (!block.parent)
                return new Point(0, 0);
            var p:Point = obj.localToGlobal(new Point(block.x, block.y));
            if (obj is Container) {
                var c:Container = obj as Container;
                p.x -= c.horizontalScrollPosition;
                p.y -= c.verticalScrollPosition;
            }
            return p;
        }

        public static function positionLocalToLocal(block:Block, obj1:DisplayObject, obj2:DisplayObject):Point {
            var p:Point = obj2.globalToLocal(positionLocalToGlobal(block, obj1));
            if (obj2 is Container) {
                var c:Container = obj2 as Container;
                p.x += c.horizontalScrollPosition;
                p.y += c.verticalScrollPosition;
            }
            return p;
        }

    }

}
