// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v2.1.0)

pragma solidity 0.8.19;

import "./IERC20Mintable.sol";
import "../ERC20.sol";

/**
 * @dev Extension of {ERC20} that allows token holders to mint both their own
 * tokens and others.
 */
abstract contract ERC20Mintable is ERC20, IERC20Mintable {
  /**
   * @dev Creates `amount` tokens and assigns them to `sender`, increasing
   * the total supply.
   */
  function mint(uint256 amount) external virtual {
    _policyInterceptor(this.mint.selector);
    _mint(_msgSender(), _msgSender(), amount);
  }

  /**
   * @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   */
  function mintTo(address account, uint256 amount) external virtual {
    _policyInterceptor(this.mintTo.selector);
    _mint(_msgSender(), account, amount);
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
      return interfaceId == type(IERC20Mintable).interfaceId || super.supportsInterface(interfaceId);
  }

  /** 
   * @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Mint} event
   *
   * Requirements:
   *
   * - `account` cannot be the zero address.
   * - `amount` should be grater than zero
   */
  function _mint(address sender, address account, uint256 amount) internal virtual {
      require(account != address(0), "Invalid Address");
      require(amount > 0, "Invalid Amount");

      _totalSupply += amount;
      unchecked {
          _balances[account] += amount;
      }
      emit Mint(sender, account, amount, _totalSupply);
  }

  /**
   * @dev Hook that is called before any transactional function of token.
   * it authoriaze transaction sender by Liguard
   */
  function _policyInterceptor(bytes4 funcSelector) internal override virtual {
    super._policyInterceptor(funcSelector);
    if(_owner != address(0) && funcSelector == this.mint.selector || funcSelector == this.mintTo.selector) {
       _checkOwner();
    }
  }
}