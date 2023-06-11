// SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 < 0.9.0;

contract ICommon {
  enum ProposalType {
    NONE,
    DECISION,
    AUCTION,
    ELECTION
  }

  enum ActionType {
    SET,
    GET
  }

  /*
   * Base Struct
   */
  struct BaseProposal {
    uint256 id;   
    uint128 voteStartAt;
    uint128 voteEndAt;
    ProposalType ptype;
  }

  /*
   * Derived Structs
   */
  struct DecisionProposal {
    BaseProposal baseProposal;
    string choose;
  }

  struct AuctionProposal {
    BaseProposal baseProposal;
    uint256 minPrice;
    bytes32 stuffID;
  }

  struct ElectionProposal {
    BaseProposal baseProposal;
    uint32 minNominator;
    uint32 maxNominator;
    uint256 quorumVotes;
    address[] nominators;
  }
}