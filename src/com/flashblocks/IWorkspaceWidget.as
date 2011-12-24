package com.flashblocks {
    import com.flashblocks.blocks.Block;
    import flash.display.DisplayObjectContainer;
    import mx.core.IUIComponent;

    /**
     * ...
     * @author ...
     */
    public interface IWorkspaceWidget {

        function registerWorkspace(workspace:Workspace):void;

        function addBlock(block:Block):void;

        function removeBlock(block:Block):void;

        function getAllBlocks():Array;

    }

}
