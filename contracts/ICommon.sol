// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

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

  struct BaseProposal {
    uint256 id;   
    uint128 voteStartAt;
    uint128 voteEndAt;
    ProposalType ptype;
  }

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