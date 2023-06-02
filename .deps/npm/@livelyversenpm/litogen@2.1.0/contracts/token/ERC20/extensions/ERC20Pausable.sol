// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v2.1.0)

pragma solidity 0.8.19;

import "./IERC20Pausable.sol";
import "../ERC20.sol";
import "../../../utils/structs/EnumerableSet.sol";

/**
 * @dev ERC20 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug, or freeze specific account to prevent token transfer
 */
abstract contract ERC20Pausable is ERC20, IERC20Pausable {
  using EnumerableSet for EnumerableSet.AddressSet;
  
  EnumerableSet.AddressSet internal _pausedList;
  bool internal _isPaused;

  /**
   * @dev Returns true if the contract is paused, and false otherwise.
   */
  function paused() public view virtual returns (bool) {
    return _isPaused;
  }

  /**
   * @dev freeze account which prevents to transfer tokens
   */
  function pause(address account) external {
    _policyInterceptor(this.pause.selector);
    require(account != address(0), "Invalid Address");
    require(!_pausedList.contains(account), "Already Paused");
    _pausedList.add(account);
    emit Paused(_msgSender(), account);
  }

  /**
   * @dev unfreeze account which permits to transfer tokens
   */
  function unpause(address account) external {
    _policyInterceptor(this.unpause.selector);
    require(account != address(0), "Invalid Address");
    require(_pausedList.contains(account), "Not Found");
    _pausedList.remove(account);
    emit Unpaused(_msgSender(), account);
  }

  /**
   * @dev Triggers stopped state.
   */
  function pauseAll() external {
    _policyInterceptor(this.pauseAll.selector);
    _isPaused = true;
    emit PausedAll(_msgSender());
  }

  /**
   * @dev Returns to normal state.
   */    
  function unpauseAll() external {
    _policyInterceptor(this.unpauseAll.selector);
    _isPaused = false;
    emit UnpausedAll(_msgSender());
  }

  function isPaused(address account) external view returns (bool) {
    return account != address(0) && _isAccountPaused(account);
  }

  function _isAccountPaused(address account) internal view returns (bool) {
    return _pausedList.contains(account);
  }

  function isPausedAll() external view returns (bool) {
    return _isPaused;
  }

  function pausedAccounts(uint256 offset) external view returns (address[] memory) {
    uint length = _pausedList.length();  
    address[] memory result = new address[](length > 100 ? 100 : length);
    for(uint256 i = 0; i + offset < result.length && i < 100; i++) {
      result[i] = _pausedList.at(i + offset);
    }
    return result;
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
      return interfaceId == type(IERC20Pausable).interfaceId || super.supportsInterface(interfaceId);
  }

  /**
   * @dev Hook that is called before any transactional function of token.
   * it authoriaze transaction sender by Liguard
   */
  function _policyInterceptor(bytes4 funcSelector) internal override virtual {
    super._policyInterceptor(funcSelector);
    if(_owner != address(0) &&
      (funcSelector == this.pause.selector || 
      funcSelector == this.unpause.selector || 
      funcSelector == this.pauseAll.selector || 
      funcSelector == this.unpauseAll.selector) 
    ) {
       _checkOwner();
    }
  }
}
