// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v1.0.2)

pragma solidity 0.8.19;

/**
 * @title ERC20 Token Extra Interface
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev
 *
 */
interface IERC20Extra {
  struct BatchTransferRequest {
    address to;
    uint256 amount;
  }

  struct BatchTransferFromRequest {
    address from;
    address to;
    uint256 amount;
  }

  function increaseAllowance(address spender, uint256 amount) external returns (uint256);

  function decreaseAllowance(address spender, uint256 amount) external returns (uint256);

  function batchTransfer(BatchTransferRequest[] calldata request) external;

  function batchTransferFrom(BatchTransferFromRequest[] calldata request) external;
}
