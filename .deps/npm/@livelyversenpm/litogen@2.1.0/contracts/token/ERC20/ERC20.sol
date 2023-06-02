// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v2.1.0)

pragma solidity 0.8.19;

import "./IERC20.sol";
import "./extensions/IERC20Metadata.sol";
import "../../utils/Address.sol";
import "../../utils/ERC165.sol";
import "../../access/Ownable.sol";
import "../../access/IProfileACL.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 */
contract ERC20 is Ownable, ERC165, IERC20, IERC20Metadata {  
    string constant internal _LITOGEN_VERSION = "v2.1.0-Litogen";
     

    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;
    uint256 internal _totalSupply;
    address internal _acl;
    string internal _profileName;
    string private _name;
    string private _symbol;
    uint8 private _decimal;
    

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(
        string memory name_, 
        string memory symbol_, 
        string memory profileName_,
        uint8 decimal_        
    ) {
        require(bytes(name_).length >= 4, "Invalid Name");
        require(bytes(symbol_).length >= 3, "Invalid Symbol");
     
        _name = name_;
        _symbol = symbol_;
        _decimal = decimal_;
        _profileName = profileName_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the version of the Litogen.
     */
    function version() public view virtual override returns (string memory) {
        return _LITOGEN_VERSION;
    }

    /**
     * @dev Returns the ACL of the token.
     */
    function acl() external view returns (address) {
        return _acl;
    }

    /**
     * @dev Returns the Profile ID of the token.
     */
    function profile() external view returns (string memory) {
        return _profileName;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimal;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
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
        return interfaceId == type(IERC20).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Change the Profile of the token.
     */
    function setProfile(string memory profileName) external {
        _policyInterceptor(this.setProfile.selector);
        emit ProfileUpdated(_msgSender(), _profileName, profileName);
        _profileName = profileName;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _policyInterceptor(this.transfer.selector);
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _policyInterceptor(this.approve.selector);
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        _policyInterceptor(this.transferFrom.selector);
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0) && to != address(0), "Invalid From/To Address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Illegal Amount");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0) && spender != address(0), "Invalid Owner/Spender Address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Illegal Allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}


    /**
     * @dev Hook that is called before any transactional function of token.
     * it authoriaze transaction sender by Liguard
     */
    function _policyInterceptor(bytes4 funcSelector) internal virtual {
      if(_acl != address(0)) { 
        IProfileACL.ProfileAuthorizationStatus status = IProfileACL(_acl).profileHasAccountAccess(keccak256(abi.encodePacked(_profileName)), address(this), funcSelector, _msgSender());
        if (status != IProfileACL.ProfileAuthorizationStatus.PERMITTED) revert IProfileACL.ProfileACLActionForbidden(status);
      } else if(funcSelector == this.setProfile.selector || funcSelector == this.transferOwnership.selector){
        _checkOwner();
      }
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal override virtual {        
       _policyInterceptor(this.transferOwnership.selector);
      address oldOwner = _owner;
      address oldAcl = _acl;
      if (Address.isContract(newOwner)) {
        if (!IERC165(newOwner).supportsInterface(type(IProfileACL).interfaceId)) {
          revert("Illegal ACL");                    
        }
        _acl = newOwner;
        _owner = address(0);  
      } else {        
        _owner = newOwner;
        _acl = address(0);
      }         
      
      emit OwnershipTransferred(oldOwner != address(0) ? oldOwner : oldAcl, newOwner);
    }

    // solhint-disable-next-line
    receive() external payable {}

    // solhint-disable-next-line
    fallback() external payable {}

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawBalance(address recepient) public {
        _policyInterceptor(this.withdrawBalance.selector);
        payable(recepient).transfer(address(this).balance);
    }

}
