// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v2.1.0)

pragma solidity 0.8.19;

import "./IERC20Burnable.sol";
import "../ERC20.sol";

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and others.
 */
abstract contract ERC20Burnable is ERC20, IERC20Burnable {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) external virtual {
        _policyInterceptor(this.burn.selector);
        _burn(_msgSender(), _msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) external virtual {
        _policyInterceptor(this.burnFrom.selector);
        _burn(_msgSender(), account, amount);
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
        return interfaceId == type(IERC20Burnable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens
     * - `amount` should be greater than zero
     */
    function _burn(
        address sender,
        address account,
        uint256 amount
    ) internal virtual {
        require(account != address(0), "Invalid Address");
        require(amount > 0, "Invalid Amount");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "Illegal Amount");
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Burn(sender, account, amount, _totalSupply);
    }

     /**
     * @dev Hook that is called before any transactional function of token.
     * it authoriaze transaction sender by Liguard
     */
    function _policyInterceptor(bytes4 funcSelector) internal override virtual {
        super._policyInterceptor(funcSelector);
        if(_owner != address(0) && funcSelector == this.burnFrom.selector || funcSelector == this.burn.selector) {
           _checkOwner();
        }
    }
}
