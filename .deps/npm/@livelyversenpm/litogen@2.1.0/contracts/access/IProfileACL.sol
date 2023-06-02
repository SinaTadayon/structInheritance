// SPDX-License-Identifier: MIT
// Liguard Contracts (last updated v3.1.0)

pragma solidity 0.8.19;

/**
 * @title Access Control Interface
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev
 *
 */
interface IProfileACL {
  enum ProfileAuthorizationStatus {
    PERMITTED,
    UNAUTHORIZED,
    POLICY_FORBIDDEN,
    PROFILE_CALL_FORBIDDEN,
    MEMBER_CALL_FORBIDDEN,
    ROLE_SCOPE_FORBIDDEN,
    MEMBER_NOT_FOUND,
    ROLE_NOT_FOUND,
    TYPE_NOT_FOUND,
    FUNCTION_NOT_FOUND,
    CONTEXT_NOT_FOUND,
    REALM_NOT_FOUND,
    DOMAIN_NOT_FOUND,
    MEMBER_ACTIVITY_FORBIDDEN,
    ROLE_ACTIVITY_FORBIDDEN,
    TYPE_ACTIVITY_FORBIDDEN,
    FUNCTION_ACTIVITY_FORBIDDEN,
    CONTEXT_ACTIVITY_FORBIDDEN,
    REALM_ACTIVITY_FORBIDDEN,
    DOMAIN_ACTIVITY_FORBIDDEN,
    UNIVERSE_ACTIVITY_FORBIDDEN,
    PROFILE_ACTIVITY_FORBIDDEN
  }

  error ProfileACLUnauthorized();
  error ProfileACLPolicyForbidden();
  error ProfileACLCallForbidden();
  error ProfileACLRoleScopeForbidden();
  error ProfileACLMemberCallForbidden();
  error ProfileACLMemberNotFound();
  error ProfileACLRoleNotFound();
  error ProfileACLTypeNotFound();
  error ProfileACLFunctionNotFound();
  error ProfileACLContextNotFound();
  error ProfileACLRealmNotFound();
  error ProfileACLDomainNotFound();
  error ProfileACLMemberActivityForbidden();
  error ProfileACLRoleActivityForbidden();
  error ProfileACLTypeActivityForbidden();
  error ProfileACLFunctionActivityForbidden();
  error ProfileACLContextActivityForbidden();
  error ProfileACLRealmActivityForbidden();
  error ProfileACLDomainActivityForbidden();
  error ProfileACLUniverseActivityForbidden();
  error ProfileACLProfileActivityForbidden();

  error ProfileACLActionForbidden(ProfileAuthorizationStatus);

  enum ProfileAdminAccessStatus {
    PERMITTED,
    NOT_PERMITTED,
    POLICY_FORBIDDEN,
    ROLE_NOT_FOUND,
    TYPE_NOT_FOUND,
    FUNCTION_NOT_FOUND,
    ROLE_ACTIVITY_FORBIDDEN,
    TYPE_ACTIVITY_FORBIDDEN
  }

  error ProfileAdminAccessNotPermitted();
  error ProfileAdminAccessPolicyForbidden();
  error ProfileAdminAccessRoleNotFound();
  error ProfileAdminAccessTypeNotFound();
  error ProfileAdminAccessFunctionNotFound();
  error ProfileAdminAccessRoleActivityForbidden();
  error ProfileAdminAccessTypeActivityForbidden();

  error ProfileSetAdminForbidden(ProfileAdminAccessStatus);

  function profileHasAccess(bytes32 profileId, bytes32 functionId) external returns (ProfileAuthorizationStatus);

  function profileHasMemberAccess(
    bytes32 profileId,
    bytes32 functionId,
    bytes32 memberId
  ) external returns (ProfileAuthorizationStatus);

  function profileHasCSAccess(
    bytes32 profileId,
    address contractId,
    bytes4 selector
  ) external returns (ProfileAuthorizationStatus);

  function profileHasAccountAccess(
    bytes32 profileId,
    address contractId,
    bytes4 selector,
    address accountId
  ) external returns (ProfileAuthorizationStatus);
}
