// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v2.1.0)

pragma solidity 0.8.19;

import "./IERC20Extra.sol";
import "../ERC20.sol";

/**
 * @dev Extension of {ERC20} that allows extra functionality to token holders
 */
abstract contract ERC20Extra is ERC20, IERC20Extra {

  /**
  * @dev Atomically increases the allowance granted to `spender` by the caller.
  *
  * This is an alternative to {approve} that can be used as a mitigation for
  * problems described in {IERC20-approve}.
  *
  * Emits an {Approval} event indicating the updated allowance.
  *
  * Requirements:
  *
  * - `spender` cannot be the zero address.
  */
  function increaseAllowance(
      address spender,
      uint256 amount
  ) external returns (uint256) {
      _policyInterceptor(this.increaseAllowance.selector);
      address owner = _msgSender();
      uint256 currentAllowance = _allowances[owner][spender] + amount;
      _approve(owner, spender, currentAllowance);
      return currentAllowance;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {IERC20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   * 
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(
      address spender,
      uint256 amount
  ) external returns (uint256) {
      _policyInterceptor(this.decreaseAllowance.selector);
      address owner = _msgSender();
      _spendAllowance(owner, spender, amount);
      return _allowances[owner][spender];
  }

  /**
   * @dev batch transfer tokens from sender to many recipients.
   *
   */
  function batchTransfer(BatchTransferRequest[] calldata requests) external {
    _policyInterceptor(this.batchTransfer.selector);
    for (uint256 i = 0; i < requests.length; i++) {
        _transfer(_msgSender(), requests[i].to, requests[i].amount);
    }
  }

  /**
   * @dev batch transfer tokens from many from addresses to many recipients by one sender
   */
  function batchTransferFrom(BatchTransferFromRequest[] calldata requests) external {
    _policyInterceptor(this.batchTransferFrom.selector);
    for (uint256 i = 0; i < requests.length; i++) {
        _spendAllowance(requests[i].from, _msgSender(), requests[i].amount);
        _transfer(requests[i].from, requests[i].to, requests[i].amount);
    }
  }

  /**
   * @dev Returns true if this contract implements the interface defined by
   * `interfaceId`. See the corresponding
   * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
   * to learn more about how these ids are created.
   *
   * This function call must use less than 30 000 gas.
   */
  function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
      return interfaceId == type(IERC20Extra).interfaceId || super.supportsInterface(interfaceId);
  }

}
