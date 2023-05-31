// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ICommon.sol";
import "./LStructCastStorage.sol";

import "hardhat/console.sol";

contract StrucInheritance {  
  using LStructCastStorage for *;

  mapping(bytes32 => ICommon.BaseProposal) internal proposalMaps;
  ICommon.BaseProposal[] internal dynamicArrayProposals;
  ICommon.BaseProposal[3] internal fixedArrayProposals;

  ICommon.DecisionProposal internal  decisionProposal;
  ICommon.AuctionProposal  internal  auctionProposal;
  ICommon.ElectionProposal internal  electionProposal;
  
  constructor() {

    address[] memory candidators = new address[](2);
    candidators[0] = 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9;

    decisionProposal = ICommon.DecisionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 1,
        voteStartAt: uint128(block.timestamp),
        voteEndAt: uint128(block.timestamp) + 1000,
        ptype: ICommon.ProposalType.DECISION
      }),
      choose: "Yes/No Question?"
    });

    auctionProposal = ICommon.AuctionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 2,
        voteStartAt: uint128(block.timestamp) + 100,
        voteEndAt: uint128(block.timestamp) + 10000,
        ptype: ICommon.ProposalType.AUCTION
      }),
      minPrice: 2000,
      stuffID: keccak256(abi.encodePacked(uint8(101)))
    });
    
    electionProposal = ICommon.ElectionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 3,
        voteStartAt: uint128(block.timestamp) + 1000,
        voteEndAt: uint128(block.timestamp) + 100000,
        ptype: ICommon.ProposalType.ELECTION
      }),
      nominators: candidators
    });      
  }
  
  function writeDrivedStructToBaseStructfixedArray() public {
    // Decision Proposal
    ICommon.DecisionProposal storage decision = fixedArrayProposals.downCastingToDecision(0);
    decision.baseProposal = ICommon.BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ICommon.ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Auction Proposal
    ICommon.AuctionProposal storage auction = fixedArrayProposals.downCastingToAuction(1);
    auction.baseProposal = ICommon.BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ICommon.ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Election Proposal
    ICommon.ElectionProposal storage election = fixedArrayProposals.downCastingToElection(2);    
    election.baseProposal = ICommon.BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ICommon.ProposalType.ELECTION
    });
    election.nominators = electionProposal.nominators;


    // console.log("id[0]: %s", fixedArrayProposals[0].id);
    // console.log("voteStartAt[0]: %d", fixedArrayProposals[0].voteStartAt);
    // console.log("voteEndAt[0]: %d", fixedArrayProposals[0].voteEndAt);
    // console.log("ptype[0]: %d", uint(fixedArrayProposals[0].ptype));

    // ICommon.DecisionProposal storage decisionTemp = fixedArrayProposals.downCastingToDecision(0);
    // console.log("decision[0].choose: %s", decisionTemp.choose);
  }

  function castingStructsInMemory() public view {
    ICommon.DecisionProposal memory dp = decisionProposal;
    ICommon.AuctionProposal memory ap = auctionProposal;    
    ICommon.ElectionProposal memory ep = electionProposal;

    validateProposal(dp.baseProposal);
    validateProposal(ap.baseProposal);
    validateProposal(ep.baseProposal);


    // proposalMaps[keccak256(abi.encodePacked(dp.baseProposal.id))] = dp.baseProposal;
    // proposalMaps[keccak256(abi.encodePacked(ap.baseProposal.id))] = ap.baseProposal;
    // proposalMaps[keccak256(abi.encodePacked(ep.baseProposal.id))] = ep.baseProposal;
    // require(bytes(dp.choose).length == bytes("Test").length, "Invalid");
  }

//  function validateProposal(DecisionProposal memory dp) internal pure {
//     // require(bp.id > 0, "Invalid ID");
//     // require(bp.voteStartAt > block.timestamp && bp.voteEndAt > block.timestamp, "Illegal Timestamp");
//     // require(bp.voteStartAt < bp.voteEndAt, "Illegal VoteStartAt");
//     // if(bp.ptype == ProposalType.DECISION) {
//     //   DecisionProposal memory dp = structDownCast(bp);
//       dp.choose = "Test";
//     // } 
//     // else if(bp.ptype == ProposalType.AUCTION) {

//     // } else if(bp.ptype == ProposalType.ELECTION) {

//     // }
//   }

  function validateProposal(ICommon.BaseProposal memory bp) internal pure {
    // require(bp.id > 0, "Invalid ID");
    // require(bp.voteStartAt > block.timestamp && bp.voteEndAt > block.timestamp, "Illegal Timestamp");
    // require(bp.voteStartAt < bp.voteEndAt, "Illegal VoteStartAt");
    if(bp.ptype == ICommon.ProposalType.DECISION) {
      ICommon.DecisionProposal memory dp = decisionProposalStrcutDownCastInMemory(bp);      
      require(bytes(dp.choose).length == bytes("Yes/No Question?").length, "Invalid Choose");

    } else if(bp.ptype == ICommon.ProposalType.AUCTION) {
      ICommon.AuctionProposal memory ap = auctionProposalStrcutDownCastInMemory(bp);
      require(ap.minPrice > 0, "Invalid MinPrice");
      require(ap.stuffID != bytes32(0), "Invalid Stuff ID");

    } else if(bp.ptype == ICommon.ProposalType.ELECTION) {
      ICommon.ElectionProposal memory ep = electionProposalStrcutDownCastInMemory(bp);
      require(ep.nominators.length > 0, "Invalid nominators");
    }
  }

  function decisionProposalStrcutDownCastInMemory(ICommon.BaseProposal memory bp) internal pure returns (ICommon.DecisionProposal memory dp) {

    if(bp.ptype == ICommon.ProposalType.DECISION) {
      assembly {
        // let ptr := mload(0x40)
        // mstore(add(ptr, 0x00), sub(bp, 0x40))
        // dp := mload(ptr)
        dp := sub(bp, 0x40)
      }
    } else {
      revert("Invalid Proposal");
    }
  }

  function auctionProposalStrcutDownCastInMemory(ICommon.BaseProposal memory bp) internal pure returns (ICommon.AuctionProposal memory ap) {
    if(bp.ptype == ICommon.ProposalType.AUCTION) {
      assembly {
        // let ptr := mload(0x40)
        // mstore(add(ptr, 0x00), sub(bp, 0x40))
        // dp := mload(ptr)
        ap := sub(bp, 0x40)
      }
    } else {
      revert("Invalid Proposal");
    }
  }

  function electionProposalStrcutDownCastInMemory(ICommon.BaseProposal memory bp) internal pure returns (ICommon.ElectionProposal memory ep) {
    if(bp.ptype == ICommon.ProposalType.ELECTION) {
      assembly {
        // let ptr := mload(0x40)
        // mstore(add(ptr, 0x00), sub(bp, 0x40))
        // dp := mload(ptr)
        ep := sub(bp, 0x40)
      }
    } else {
      revert("Invalid Proposal");
    }
  }
}