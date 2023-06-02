// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ICommon.sol";
import "./LStructCastStorage.sol";

import "hardhat/console.sol";

contract StrucInheritance {  
  using LStructCastStorage for *;

  mapping(bytes32 => ICommon.BaseProposal) internal proposalMaps;
  ICommon.BaseProposal[] internal dynamicArrayProposals;

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

  function mappingTest() public {
     // Decision Proposal
    ICommon.DecisionProposal storage decision = proposalMaps.storageDecision(keccak256(abi.encodePacked(uint(10))), ICommon.ActionType.SET);
    decision.baseProposal = ICommon.BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ICommon.ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Auction Proposal
    ICommon.AuctionProposal storage auction = proposalMaps.storageAuction(keccak256(abi.encodePacked(uint(11))), ICommon.ActionType.SET);
    auction.baseProposal = ICommon.BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ICommon.ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Election Proposal
    ICommon.ElectionProposal storage election = proposalMaps.storageElection(keccak256(abi.encodePacked(uint(12))), ICommon.ActionType.SET);
    election.baseProposal = ICommon.BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ICommon.ProposalType.ELECTION
    });
    election.nominators = electionProposal.nominators;

    // Test 0 index
    ICommon.DecisionProposal storage decisionTemp = proposalMaps.storageDecision(keccak256(abi.encodePacked(uint(10))), ICommon.ActionType.GET);
    require(decisionTemp.baseProposal.id == 10, "Invalid Id");
    require(decisionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(decisionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(decisionTemp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");

    // Test 1 index
    ICommon.AuctionProposal storage auctionTemp = proposalMaps.storageAuction(keccak256(abi.encodePacked(uint(11))), ICommon.ActionType.GET);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");
        
    // Test 2 index
    ICommon.ElectionProposal storage electionTemp = proposalMaps.storageElection(keccak256(abi.encodePacked(uint(12))), ICommon.ActionType.GET);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
  }
  
  function dynamicArrayTest() public {
    // Decision Proposal
    ICommon.DecisionProposal storage decision = dynamicArrayProposals.pushDecision();
    decision.baseProposal = ICommon.BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ICommon.ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Auction Proposal
    ICommon.AuctionProposal storage auction = dynamicArrayProposals.pushAuction();
    auction.baseProposal = ICommon.BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ICommon.ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Election Proposal
    ICommon.ElectionProposal storage election = dynamicArrayProposals.pushElection();    
    election.baseProposal = ICommon.BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ICommon.ProposalType.ELECTION
    });
    election.nominators = electionProposal.nominators;


    // Test 0 index
    ICommon.DecisionProposal storage decisionTemp = dynamicArrayProposals.getDecision(0);
    require(decisionTemp.baseProposal.id == 10, "Invalid Id");
    require(decisionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(decisionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(decisionTemp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");

    // Test 1 index
    ICommon.AuctionProposal storage auctionTemp = dynamicArrayProposals.getAuction(1);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");
        
    // Test 2 index
    ICommon.ElectionProposal storage electionTemp = dynamicArrayProposals.getElection(2);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
  }

   function popTest() public {
    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 2, "Invalid Length");

    // // Test 0 index
    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    // require(dynamicArrayProposals[0].voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    // require(dynamicArrayProposals[0].voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ICommon.ProposalType.DECISION, "Invalid Type");
    
    ICommon.DecisionProposal storage decisionTemp = dynamicArrayProposals.getDecision(0);
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");

     // Test 1 index
    ICommon.AuctionProposal storage auctionTemp = dynamicArrayProposals.getAuction(1);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    // require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    // require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 1, "Invalid Length");
    // // Test 0 index
    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    // require(dynamicArrayProposals[0].voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    // require(dynamicArrayProposals[0].voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ICommon.ProposalType.DECISION, "Invalid Type");
    
    ICommon.DecisionProposal storage decisionTemp1 = dynamicArrayProposals.getDecision(0);
    require(bytes(decisionTemp1.choose).length == bytes("Choose One?").length, "Invalid Choose");

    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 0, "Invalid Length");
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