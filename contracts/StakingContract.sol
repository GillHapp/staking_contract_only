// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is ERC20 {
    using SafeERC20 for IERC20;

    IERC20 public immutable bslToken; // Reference to the BSL token

    // Event to log staking and unstaking
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor(IERC20 _bslToken) ERC20("Staked BSL", "stBSL") {
        require(address(_bslToken) != address(0), "Invalid BSL token address");
        bslToken = _bslToken;
    }

    /**
     * @notice Stake BSL tokens to receive stBSL tokens.
     * @param amount The amount of BSL tokens to stake.
     */
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer BSL tokens from the user to the contract
        bslToken.safeTransferFrom(msg.sender, address(this), amount);

        // Mint stBSL tokens to the user
        _mint(msg.sender, amount);

        emit Staked(msg.sender, amount);
    }

    /**
     * @notice Unstake stBSL tokens to redeem BSL tokens.
     * @param amount The amount of stBSL tokens to unstake.
     */
    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient stBSL balance");

        // Burn the stBSL tokens from the user
        _burn(msg.sender, amount);

        // Transfer BSL tokens back to the user
        bslToken.safeTransfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }

    /**
     * @notice Get the total BSL tokens staked in the contract.
     * @return The total BSL token balance held by the contract.
     */
    function totalStaked() external view returns (uint256) {
        return bslToken.balanceOf(address(this));
    }
}
