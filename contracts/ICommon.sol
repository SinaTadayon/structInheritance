// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract ICommon {
  enum ProposalType {
    DECISION,
    AUCTION,
    ELECTION
  }

  struct BaseProposal {
    uint256  id;   
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
    address[] nominators;
  }
}