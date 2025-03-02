// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "src/ImplementationV1.sol";
import "src/ImplementationV2.sol";
import "src/ProxyContract.sol";

contract StakingProxyTestContract is Test {
    ImplementationV1 wrongStakeContract;
    ImplementationV2 rightStakeContract;
    ProxyContract c;

    function setUp() public {
        wrongStakeContract = new ImplementationV1();
        rightStakeContract = new ImplementationV2();
        c = new ProxyContract(address(wrongStakeContract));
    }

    function testStake() public {
        uint value = 10 ether;
        vm.deal(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f, value);
        vm.prank(0x587EFaEe4f308aB2795ca35A27Dff8c1dfAF9e3f);
        (bool success, ) = address(c).call{value: value}(
            abi.encodeWithSignature("stake(uint256)", value)
        );
        assert(success);
        (bool success2, bytes memory data) = address(c).delegatecall(
            abi.encodeWithSignature("getTotalStaked()")
        );
        assert(success2);
        console.logBytes(data);
        uint currentStake = abi.decode(data, (uint256));
        console.log(currentStake);
        assert(currentStake == value);
    }
}
