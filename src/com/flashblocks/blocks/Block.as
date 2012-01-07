package com.flashblocks.blocks {
    import com.flashblocks.events.BlockConnectionEvent;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import mx.containers.Canvas;
    import mx.effects.Resize;
    import mx.events.PropertyChangeEvent;

    /**
     * ...
     * @author Trevor Rundell
     */

    [Event(name="dragStart", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragComplete", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="dragDrop", type="com.flashblocks.events.BlockDragEvent")]
    [Event(name="connect", type="com.flashblocks.events.BlockConnectionEvent")]
    [Event(name="disconnect", type="com.flashblocks.events.BlockConnectionEvent")]
    public class Block extends Canvas {

        private var _socketType:String;
        private var _blockType:String;
        private var _blockName:String;
        private var _blockLabel:String;
        private var _blockColor:uint;
        private var _enableConnections:Boolean;

        private var _olderSibling:Block;
        private var _youngerSibling:Block;
        private var _nestedBlocks:Array;
        private var _internalBlock:Block;

        protected var dragging:Boolean = false;

        public function Block(socketType:String="round", blockLabel:String="", blockColor:uint=0x66FF66) {
            super();

            this.socketType = socketType;
            this.blockLabel = blockLabel;
            this.blockColor = blockColor;

            this.nestedBlocks = new Array();

            this.clipContent = false;

            var resizeEffect:Resize = new Resize(this);
            resizeEffect.duration = 500;

            setStyle("verticalGap", 0);

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        }

        //
        // Bindable Getters / Setters
        //

        [Bindable(event="propertyChange")]
        public function get socketType():String { return _socketType; }

        public function set socketType(value:String):void {
            _socketType = value;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
        }

        [Bindable(event="propertyChange")]
        public function get blockType():String { return _blockType; }

        public function set blockType(value:String):void {
            _blockType = value;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
        }

        [Bindable(event="propertyChange")]
        public function get blockName():String { return _blockName; }

        public function set blockName(value:String):void {
            _blockName = value;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
        }

        [Bindable(event="propertyChange")]
        public function get blockLabel():String { return _blockLabel; }

        public function set blockLabel(value:String):void {
            _blockLabel = value;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
        }

        [Bindable(event="propertyChange")]
        public function get blockColor():uint { return _blockColor; }

        public function set blockColor(value:uint):void {
            _blockColor = value;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
        }

        // non-bindable properties

        public function get enableConnections():Boolean { return _enableConnections; }

        public function set enableConnections(value:Boolean):void {
            _enableConnections = value;
        }

        public function get olderSibling():Block { return _olderSibling; }

        public function set olderSibling(value:Block):void {
            _olderSibling = value;
        }

        public function get youngerSibling():Block { return _youngerSibling; }

        public function set youngerSibling(value:Block):void {
            _youngerSibling = value;
        }

        public function get nestedBlocks():Array { return _nestedBlocks ? _nestedBlocks : [ ]; }

        public function set nestedBlocks(value:Array):void {
            _nestedBlocks = value;
        }

        public function get internalBlock():Block { return _internalBlock; }

        public function set internalBlock(value:Block):void {
            _internalBlock = value;
        }

        //
        // CONTENT METHODS - Adding and removing content to a block. This
        //   includes argument blocks as well as any labels, text or icons.
        //

        public function addContent(content:DisplayObject):void {
            // override
        }

        public function removeContent(content:DisplayObject):void {
            // override
        }

        public function getContent():Array {
            return [ ];
        }

        public function getArguments():Array {
            var args:Array = new Array();
            for each (var child:DisplayObject in getContent()) {
                if (child is Block) {
                    args.push(child);
                }
            }
            return args;
        }

        //
        // PORT EXISTENCE TESTS -- Test if a block as a particular port.
        //
        //   Older Sibling Port -- Notch at top of block
        //   Younger Sibling Port -- Notch at bottom of block
        //   Nested Port -- Sideways connection for control logic
        //   Internal Port -- Connection for argument blocks that allow drops
        //

        public function hasOlderSiblingPort():Boolean {
            return false; // override
        }

        public function hasYoungerSiblingPort():Boolean {
            return false; // override
        }

        public function hasNestedPort():Boolean {
            return false; // override
        }

        public function hasInternalPort():Boolean {
            return false; // override
        }

        //
        // CONNECTION TESTS -- Test if two blocks are able to connect at
        //   specific ports. Some possible conditions for comparison are
        //   port locations, block position, current connections, socket
        //   types or custom connection rules.
        //

        public function testOlderSiblingConnection(block:Block):Boolean {
            return false; // override
        }

        public function testYoungerSiblingConnection(block:Block):Boolean {
            return false; // override
        }

        public function testNestedConnection(block:Block):Boolean {
            return false; // override
        }

        public function testInternalConnection(block:Block):Boolean {
            return false; // override
        }

        //
        // CONNECTION METHODS -- Connect blocks together at specific ports.
        //

        public function connectOlderSibling(block:Block):void {
            // override
        }

        public function connectYoungerSibling(block:Block):void {
            // override
        }

        public function connectNestedBlock(block:Block):void {
            // override
        }

        public function connectInternalBlock(block:Block):void {
            // override
        }

        //
        // Dragging Methods
        //

        public function isDragging():Boolean {
            return dragging;
        }

        public function setDragging(value:Boolean):void {
            if (canDrag())
                dragging = value;
            if (value)
                dispatchEvent(new BlockConnectionEvent(BlockConnectionEvent.DISCONNECT));
        }

        public function canDrag():Boolean {
            return true; // override
        }

        public function canDrop(block:Block):Boolean {
            return false; // override
        }

        //
        // MOUSE HANDLERS -- Prevents progagation of mouse events to avoid
        //   dragging a parent block when the child is being used.
        //

        private function onMouseMove(e:MouseEvent):void {
            e.stopPropagation();
        }

        private function onMouseUp(e:MouseEvent):void {
            e.stopPropagation();
        }

        private function onMouseDown(e:MouseEvent):void {
            e.stopPropagation();
        }

    }

}
