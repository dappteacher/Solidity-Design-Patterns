// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MultiSigWallet.sol";

/**
 * @title MultiSigWalletTest
 * @dev A test suite for the MultiSigWallet contract using Foundry.
 */
contract MultiSigWalletTest is Test {
    MultiSigWallet multiSigWallet;
    address[] owners;
    address owner1 = address(1);
    address owner2 = address(2);
    address owner3 = address(3);
    uint requiredConfirmations = 2;

    /**
     * @dev Sets up the test environment by initializing the MultiSigWallet contract with three owners and two required confirmations.
     */
    function setUp() public {
        owners.push(owner1);
        owners.push(owner2);
        owners.push(owner3);
        multiSigWallet = new MultiSigWallet(owners, requiredConfirmations);
    }

    /**
     * @dev Tests the submission of a transaction.
     * @notice This test checks if a transaction can be submitted and its details are correctly stored.
     */
    function testSubmitTransaction() public {
        vm.startPrank(owner1);
        multiSigWallet.submitTransaction(address(this), 1 ether, "");
        (address to, uint value, , , ) = multiSigWallet.getTransaction(0);
        assertEq(to, address(this));
        assertEq(value, 1 ether);
        vm.stopPrank();
    }

    /**
     * @dev Tests the confirmation of a transaction.
     * @notice This test checks if a transaction can be confirmed by an owner and the number of confirmations is updated.
     */
    function testConfirmTransaction() public {
        vm.startPrank(owner1);
        multiSigWallet.submitTransaction(address(this), 1 ether, "");
        vm.stopPrank();

        vm.startPrank(owner2);
        multiSigWallet.confirmTransaction(0);
        (, , , , uint numConfirmations) = multiSigWallet.getTransaction(0);
        assertEq(numConfirmations, 1);
        vm.stopPrank();
    }

    /**
     * @dev Tests the execution of a confirmed transaction.
     * @notice This test checks if a transaction can be executed once it has the required number of confirmations, and verifies that the transaction was executed.
     */
    function testExecuteTransaction() public {
        vm.deal(address(multiSigWallet), 2 ether);

        vm.startPrank(owner1);
        multiSigWallet.submitTransaction(address(this), 1 ether, "");
        vm.stopPrank();

        vm.startPrank(owner2);
        multiSigWallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(owner3);
        multiSigWallet.confirmTransaction(0);
        vm.stopPrank();

        vm.startPrank(owner1);
        multiSigWallet.executeTransaction(0);
        (, , , bool executed, ) = multiSigWallet.getTransaction(0);
        assertTrue(executed);
        assertEq(address(this).balance, 1 ether);
        vm.stopPrank();
    }

    /**
     * @dev Tests the revocation of a confirmation for a transaction.
     * @notice This test checks if a confirmation can be revoked by an owner and verifies that the number of confirmations is updated.
     */
    function testRevokeConfirmation() public {
        vm.startPrank(owner1);
        multiSigWallet.submitTransaction(address(this), 1 ether, "");
        vm.stopPrank();

        vm.startPrank(owner2);
        multiSigWallet.confirmTransaction(0);
        multiSigWallet.revokeConfirmation(0);
        (, , , , uint numConfirmations) = multiSigWallet.getTransaction(0);
        assertEq(numConfirmations, 0);
        vm.stopPrank();
    }

    /**
     * @dev Allows the contract to receive Ether.
     * @notice This function is required for testing purposes to ensure the contract can receive Ether.
     */
    receive() external payable {}
}
