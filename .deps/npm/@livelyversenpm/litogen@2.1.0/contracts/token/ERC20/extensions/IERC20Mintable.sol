// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v1.0.2)

pragma solidity 0.8.19;

/**
 * @title ERC20 Token Extra Interface
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev
 */

interface IERC20Mintable {

  event Mint(address indexed sender, address indexed account, uint256 amount, uint256 totalSupply);

  function mint(uint256 amount) external;

  function mintTo(address account, uint256 amount) external;
}