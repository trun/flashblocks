package com.flashblocks {
    import com.flashblocks.blocks.Block;

    /**
     * ...
     * @author ...
     */
    public interface IWorkspaceWidget {

        function registerWorkspace(workspace:Workspace):void;

        function addBlock(block:Block):void;

        function removeBlock(block:Block):void;

        function dragEnterBlock(block:Block):void;

        function dragExitBlock(block:Block):void;

        function getAllBlocks():Array;

    }

}
