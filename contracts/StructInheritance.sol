// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "./ICommon.sol";
import "./LCastingStruct.sol";

contract StrucInheritance {  
  using LCastingStruct for *;

  mapping(bytes32 => ICommon.BaseProposal) internal proposalMaps;
  ICommon.BaseProposal[] internal dynamicArrayProposals;

  ICommon.AuctionProposal  internal  auctionProposal;
  ICommon.ElectionProposal internal  electionProposal;
  ICommon.DecisionProposal internal  decisionProposal;
  
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

    // Get ID 10
    ICommon.DecisionProposal storage decisionTemp = proposalMaps.storageDecision(keccak256(abi.encodePacked(uint(10))), ICommon.ActionType.GET);
    require(decisionTemp.baseProposal.id == 10, "Invalid Id");
    require(decisionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(decisionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(decisionTemp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   
    require(keccak256(abi.encodePacked(decisionTemp.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");

    // Get ID 11
    ICommon.AuctionProposal storage auctionTemp = proposalMaps.storageAuction(keccak256(abi.encodePacked(uint(11))), ICommon.ActionType.GET);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");
        
    // Get ID 12
    ICommon.ElectionProposal storage electionTemp = proposalMaps.storageElection(keccak256(abi.encodePacked(uint(12))), ICommon.ActionType.GET);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
  }
  
  function dynamicArrayTest() public {   
    // Push Auction Proposal
    ICommon.AuctionProposal storage auction = dynamicArrayProposals.pushAuction();
    auction.baseProposal = ICommon.BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ICommon.ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Push Decision Proposal
    ICommon.DecisionProposal storage decision = dynamicArrayProposals.pushDecision();
    decision.baseProposal = ICommon.BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ICommon.ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Push Election Proposal
    ICommon.ElectionProposal storage election = dynamicArrayProposals.pushElection();    
    election.baseProposal = ICommon.BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ICommon.ProposalType.ELECTION
    });
    election.nominators = electionProposal.nominators;


    // Get Auction
    ICommon.AuctionProposal storage auctionTemp = dynamicArrayProposals.getAuction(0);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    // Get Decision
    ICommon.DecisionProposal storage decisionTemp = dynamicArrayProposals.getDecision(1);
    require(decisionTemp.baseProposal.id == 10, "Invalid Id");
    require(decisionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(decisionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(decisionTemp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   
    require(keccak256(abi.encodePacked(decisionTemp.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");
    
    // Get Election 
    ICommon.ElectionProposal storage electionTemp = dynamicArrayProposals.getElection(2);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");

    // Pop Item
    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 2, "Invalid Length");

     // Test Auction
    ICommon.AuctionProposal storage popAuction = dynamicArrayProposals.getAuction(0);
    require(popAuction.baseProposal.id == 11, "Invalid Id");
    require(popAuction.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(popAuction.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(popAuction.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(popAuction.minPrice == 1000, "Invalid Price");
    require(popAuction.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    // Test Decision
    ICommon.DecisionProposal storage popDecision = dynamicArrayProposals.getDecision(1);
    require(popDecision.baseProposal.id == 10, "Invalid Id");
    require(popDecision.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(popDecision.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(popDecision.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");    
    require(keccak256(abi.encodePacked(popDecision.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");


    // Pop Item
    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 1, "Invalid Length");

    popAuction = dynamicArrayProposals.getAuction(0);
    require(popAuction.baseProposal.id == 11, "Invalid Id");
    require(popAuction.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(popAuction.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(popAuction.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(popAuction.minPrice == 1000, "Invalid Price");
    require(popAuction.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");


    // // Test Decision
    // popDecision = dynamicArrayProposals.getDecision(0);
    // require(popDecision.baseProposal.id == 10, "Invalid Id");
    // require(popDecision.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    // require(popDecision.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    // require(popDecision.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");    
    // require(keccak256(abi.encodePacked(popDecision.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");

    // Pop Item
    dynamicArrayProposals.popItem();
    require(dynamicArrayProposals.length == 0, "Invalid Length");
  }

  function memoryTest() public view {
    ICommon.DecisionProposal memory dp = decisionProposal;
    ICommon.AuctionProposal memory ap = auctionProposal;    
    ICommon.ElectionProposal memory ep = electionProposal;

    _validateProposal(dp.baseProposal);
    _validateProposal(ap.baseProposal);
    _validateProposal(ep.baseProposal);
  }

  function _validateProposal(ICommon.BaseProposal memory bp) internal pure {
    if(bp.ptype == ICommon.ProposalType.DECISION) {
      ICommon.DecisionProposal memory dp = LCastingStruct.memoryGetDecision(bp);      
      require(keccak256(abi.encodePacked(dp.choose)) == keccak256(abi.encodePacked("Yes/No Question?")), "Invalid Choose");

    } else if(bp.ptype == ICommon.ProposalType.AUCTION) {
      ICommon.AuctionProposal memory ap = LCastingStruct.memoryGetAuction(bp);
      require(ap.minPrice == 2000, "Invalid MinPrice");
      require(ap.stuffID == keccak256(abi.encodePacked(uint8(101))), "Invalid Stuff ID");

    } else if(bp.ptype == ICommon.ProposalType.ELECTION) {
      ICommon.ElectionProposal memory ep = LCastingStruct.memoryGetElection(bp);
      require(ep.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
    }
  }
}