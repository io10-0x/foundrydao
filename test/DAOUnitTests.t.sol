//SDPX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {MyGovernor} from "src/MyGovernor.sol";
import {TimeLockControllerContract} from "src/TimeLockControllerContract.sol";
import {Box} from "src/Box.sol";
import {GovToken} from "src/GovToken.sol";

contract DAOUnitTests is Test {
    Box box;
    GovToken govToken;
    TimeLockControllerContract timeLockControllerContract;
    MyGovernor myGovernor;
    uint256 minDelay = 3600;
    address admin = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        address[] memory proposers = new address[](1);
        address[] memory executors = new address[](1);

        vm.startPrank(admin);
        // Deploy the Box contract
        box = new Box();
        // Deploy the GovToken contract
        govToken = new GovToken(admin);
        govToken.delegate(admin);

        // Deploy the TimeLockControllerContract contract
        timeLockControllerContract = new TimeLockControllerContract(
            minDelay,
            proposers,
            executors,
            admin
        );
        // Deploy the MyGovernor contract
        myGovernor = new MyGovernor(govToken, timeLockControllerContract);
        bytes32 proposerrole = timeLockControllerContract.PROPOSER_ROLE();
        bytes32 executorrole = timeLockControllerContract.EXECUTOR_ROLE();
        bytes32 cancellerrole = timeLockControllerContract.CANCELLER_ROLE();
        timeLockControllerContract.grantRole(proposerrole, address(myGovernor));
        timeLockControllerContract.grantRole(executorrole, address(myGovernor));
        timeLockControllerContract.grantRole(
            cancellerrole,
            address(myGovernor)
        );
        box.transferOwnership(address(timeLockControllerContract));
        vm.stopPrank();
    }

    function testBoxfunctioncall() public {
        vm.expectRevert();
        box.store(10);
    }

    function test_usercanproposeandexecutestorefunction() public {
        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1);
        string memory description = "I want to store a new number";
        targets[0] = address(box);
        values[0] = 0;
        calldatas[0] = abi.encodeWithSignature("store(uint256)", 20);
        vm.startPrank(admin);
        uint256 proposalid = myGovernor.propose(
            targets,
            values,
            calldatas,
            description
        );

        vm.roll(7202);
        console.log(myGovernor.proposalEta(proposalid));
        uint256 votedweight = myGovernor.castVote(proposalid, 1);
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));

        vm.roll(57602);
        myGovernor.queue(targets, values, calldatas, descriptionHash);
        vm.warp(block.timestamp + 3601);
        vm.roll(57603);
        myGovernor.execute(targets, values, calldatas, descriptionHash);
        vm.stopPrank();
        assertEq(box.getValue(), 20);
    }
}
