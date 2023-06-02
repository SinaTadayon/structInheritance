// SPDX-License-Identifier: MIT
// Litogen Contracts (last updated v1.1.0)

pragma solidity 0.8.19;

import "../IERC20.sol";

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 * @author Sina Tadayon, https://github.com/SinaTadayon
 *
 */
interface IERC20Metadata is IERC20 {

    event ProfileUpdated(address indexed sender, string indexed oldProfile, string indexed newProfile);

    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the version of the token.
     */
    function version() external view returns (string memory);

    /**
     * @dev Returns the ACL of the token.
     */
    function acl() external view returns (address);

    /**
     * @dev Returns the Profile ID of the token.
     */
    function profile() external view returns (string memory);

    /**
     * @dev Change the Profile of the token.
     */
    function setProfile(string memory profile) external;
}
