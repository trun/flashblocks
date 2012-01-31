package com.flashblocks.blocks.args {
    public class Types {
        public static var STRING:String = "string";
        public static var INT:String = "int";
        public static var UINT:String = "uint";
        public static var BOOL:String = "bool";
        public static var DOUBLE:String = "double";

        public static function cast(type:String, val:*):* {
            switch(type) {
                case STRING:
                    return val.toString();
                case INT:
                    if (typeof(val) == "number")
                        return int(val);
                    return parseInt(val);
                case UINT:
                    if (typeof(val) == "number")
                        return uint(val);
                    return parseInt(val);
                case DOUBLE:
                    if (typeof(val) == "number")
                        return val;
                    return parseFloat(val);
                case BOOL:
                    return val;
                default:
                    return val;
            }
        }
    }
}
