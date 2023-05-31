// SPDX-License-Identifier: MIT

import "hardhat/console.sol";

pragma solidity 0.8.19;

contract Test {
  enum ProposalType {
    DECISION,
    AUCTION,
    ELECTION
  }

  struct BaseProposal {
    uint256  id;   
    uint256 voteStartAt;
    uint256 voteEndAt;
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

  mapping(bytes32 => BaseProposal) internal proposalMaps;
  BaseProposal[] internal dynamicArrayProposals;
  BaseProposal[3] internal fixedArrayProposals;
  BaseProposal[8] internal proposals;

  DecisionProposal internal  decisionProposal;
  AuctionProposal  internal  auctionProposal;
  ElectionProposal internal  electionProposal;


  constructor() {
    // address[] memory candidators = new address[](2);
    // candidators[0] = 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9;

    // DecisionProposal memory dp = DecisionProposal({
    //   baseProposal: BaseProposal({
    //     id: 1,
    //     voteStartAt: block.timestamp,
    //     voteEndAt: block.timestamp + 100,
    //     ptype: ProposalType.DECISION
    //   }),
    //   choose: "Yes/No Question?"
    // });

    // AuctionProposal memory ap = AuctionProposal({
    //   baseProposal: BaseProposal({
    //     id: 2,
    //     voteStartAt: block.timestamp + 100,
    //     voteEndAt: block.timestamp + 1000,
    //     ptype: ProposalType.AUCTION
    //   }),
    //   minPrice: 2000,
    //   stuffID: keccak256(abi.encodePacked(uint8(101)))
    // });
    
    // ElectionProposal memory ep = ElectionProposal({
    //   baseProposal: BaseProposal({
    //     id: 1,
    //     voteStartAt: block.timestamp + 1000,
    //     voteEndAt: block.timestamp + 100000,
    //     ptype: ProposalType.ELECTION
    //   }),
    //   nominators: candidators
    // });


    // // proposalMaps[keccak256(abi.encodePacked(dp.baseProposal.id))] = dp;
    // // proposalMaps[keccak256(abi.encodePacked(ap.baseProposal.id))] = ap;
    // // proposalMaps[keccak256(abi.encodePacked(ep.baseProposal.id))] = ep;

    // validateProposal(dp.baseProposal);
  }

  function downcastingArrayStructs() public {
     uint128 start = uint128(block.timestamp) + 200;
     uint128 end = uint128(block.timestamp) + 2000;
    DecisionProposal storage decision = downCastingToDecision(0);
    decision.baseProposal = BaseProposal({
      id: 10,
      voteStartAt: start,
      voteEndAt: end,
      ptype: ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    require(fixedArrayProposals[0].id == 10, "Invalid Id");
    require(fixedArrayProposals[0].voteStartAt == start, "Invalid Start");
    require(fixedArrayProposals[0].voteEndAt == end, "Invalid End");
    require(fixedArrayProposals[0].ptype == ProposalType.DECISION, "Invalid Type");
    
    DecisionProposal storage decisionTemp = downCastingToDecision(0);
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");
  }

   function downcastingDynamicArrayStructs() public {
     uint128 start = uint128(block.timestamp) + 200;
     uint128 end = uint128(block.timestamp) + 2000;
    DecisionProposal storage decision = downCastingToDecision2(0);
    decision.baseProposal = BaseProposal({
      id: 10,
      voteStartAt: start,
      voteEndAt: end,
      ptype: ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    require(dynamicArrayProposals[0].voteStartAt == start, "Invalid Start");
    require(dynamicArrayProposals[0].voteEndAt == end, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ProposalType.DECISION, "Invalid Type");
    
    DecisionProposal storage decisionTemp = downCastingToDecision2(0);
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");
  }


  function storeArray() public {    
    proposals[0] = BaseProposal({
      id: 1,
      voteStartAt: uint128(block.timestamp),
      voteEndAt: uint128(block.timestamp) + 1000,
      ptype: ProposalType.AUCTION
    });     

    proposals[1] = BaseProposal({
      id: 2,
      voteStartAt: uint128(block.timestamp) + 2,
      voteEndAt: uint128(block.timestamp) + 10,
      ptype: ProposalType.ELECTION
    });     
  }

  function validateProposal(BaseProposal memory bp) internal view {
    require(bp.id > 0, "Invalid ID");
    require(bp.voteStartAt > block.timestamp && bp.voteEndAt > block.timestamp, "Illegal Timestamp");
    require(bp.voteStartAt < bp.voteEndAt, "Illegal VoteStartAt");
    if(bp.ptype == ProposalType.DECISION) {
      DecisionProposal memory dp = structDownCast(bp);
      dp.choose = "Test";
    } 
    // else if(bp.ptype == ProposalType.AUCTION) {

    // } else if(bp.ptype == ProposalType.ELECTION) {

    // }
  }

  function structDownCast(BaseProposal memory bp) internal pure returns (DecisionProposal memory dp) {

    if(bp.ptype == ProposalType.DECISION) {
      assembly {
        // let ptr := mload(0x40)
        // mstore(ptr, bp)
        dp := bp
      }
    } else {
      revert("Invalid Proposal");
    }
  }

  function downCastingToDecision(uint256 index)
    internal
    view
    returns (DecisionProposal storage ep)
  {
    BaseProposal storage bp = fixedArrayProposals[index];
    if (bp.ptype == ProposalType.DECISION) {
      assembly {
        // let ptr := mload(0x40)
        ep.slot := bp.slot
        // mstore(add(ptr, 0x00), proposalId)
        // mstore(add(ptr, 0x20), add(fixedArrayProposals.slot, 8))
        // ep.slot := keccak256(ptr, 0x40)
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

   function downCastingToDecision2(uint256 index)
    internal
    view
    returns (DecisionProposal storage ep)
  {
    BaseProposal storage bp = dynamicArrayProposals[index];
    if (bp.ptype == ProposalType.DECISION) {
      assembly {
        // let ptr := mload(0x40)
        ep.slot := bp.slot
        // mstore(add(ptr, 0x00), proposalId)
        // mstore(add(ptr, 0x20), add(fixedArrayProposals.slot, 8))
        // ep.slot := keccak256(ptr, 0x40)
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

}