// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "./ICommon.sol";
import "./LCastingStruct.sol";

/**
 * @title the structure inheritance over composition sample
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev it contains functions to test down-casting base structure
 * to derived structure in mapping, dynamic array storages, and memory area.
 *
 */
contract StructInheritance {  
  using LCastingStruct for *;

  /*
   * storage slot number of variables as follow: 
   * proposalExtMaps is 0
   * proposalsExtArray is 1
   * auctionProposal is 2
   * electionProposal is 8
   * decisionProposal is 15
   */
  mapping(bytes32 => ICommon.BaseProposal) internal proposalExtMaps;
  ICommon.BaseProposal[] internal proposalsExtArray;

  ICommon.AuctionProposal  internal  auctionProposal;
  ICommon.ElectionProposal internal  electionProposal;
  ICommon.DecisionProposal internal  decisionProposal;
  
  /**
   * @dev initialize auctionProposal, electionProposal, and decisionProposal variables
   */
  constructor() {

    address[] memory candidators = new address[](2);
    candidators[0] = 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9;

    // initialize decisionProposal
    decisionProposal = ICommon.DecisionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 1,
        voteStartAt: uint128(block.timestamp),
        voteEndAt: uint128(block.timestamp) + 1000,
        ptype: ICommon.ProposalType.DECISION
      }),
      choose: "Yes/No Question?"
    });

    // initialize auctionProposal
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
    
    // initialize electionProposal
    electionProposal = ICommon.ElectionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 3,
        voteStartAt: uint128(block.timestamp) + 1000,
        voteEndAt: uint128(block.timestamp) + 100000,
        ptype: ICommon.ProposalType.ELECTION
      }),
      minNominator: 1,
      maxNominator: 7,
      quorumVotes: 750,
      nominators: candidators
    });          
  }

  /**
   * @dev extendedMappingTest() tests upcasting base structure (BaseProposal) from derived structures (DecisionProposal, etc) and 
   * downcasting base structure to derived structures as well.
   */
  function extendedMappingTest() public {
     // Decision Proposal
    ICommon.DecisionProposal storage decision = proposalExtMaps.storageDecision(keccak256(abi.encodePacked(uint(10))), ICommon.ActionType.SET);
    decision.baseProposal = ICommon.BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ICommon.ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Auction Proposal
    ICommon.AuctionProposal storage auction = proposalExtMaps.storageAuction(keccak256(abi.encodePacked(uint(11))), ICommon.ActionType.SET);
    auction.baseProposal = ICommon.BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ICommon.ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Election Proposal
    ICommon.ElectionProposal storage election = proposalExtMaps.storageElection(keccak256(abi.encodePacked(uint(12))), ICommon.ActionType.SET);
    election.baseProposal = ICommon.BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ICommon.ProposalType.ELECTION
    });
    election.minNominator = 3;
    election.maxNominator = 10;
    election.quorumVotes = 1000;
    election.nominators = electionProposal.nominators;

    // Get ID 10
    ICommon.BaseProposal storage baseProposal = proposalExtMaps[keccak256(abi.encodePacked(uint(10)))];
    require(baseProposal.id == 10, "Invalid Id");
    require(baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   

    ICommon.DecisionProposal storage decisionTemp = proposalExtMaps.storageDecision(keccak256(abi.encodePacked(uint(10))), ICommon.ActionType.GET);
    require(keccak256(abi.encodePacked(decisionTemp.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");

    // Get ID 11
    ICommon.AuctionProposal storage auctionTemp = proposalExtMaps.storageAuction(keccak256(abi.encodePacked(uint(11))), ICommon.ActionType.GET);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");
        
    // Get ID 12
    ICommon.ElectionProposal storage electionTemp = proposalExtMaps.storageElection(keccak256(abi.encodePacked(uint(12))), ICommon.ActionType.GET);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.minNominator == 3, "Invalid minNominator");
    require(electionTemp.maxNominator == 10, "Invalid maxNominator");
    require(electionTemp.quorumVotes == 1000, "Invalid quorumVotes");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
  }
  
   /**
   * @dev extendedArrayTest() tests upcasting base structure (BaseProposal)
   * from derived structures (DecisionProposal, etc) and downcasting base structure to derived structures as well.
   * it also uses pushXXX, popItem, and getXXX functions which defined in the library for each derived structure.
   *
   * Note: Don't use the default push, pop functions, and [] operator of the dynamic array, 
   * because they couldn't manage storage slots of the derived structure behind of downcasting action properly.
   */
  function extendedArrayTest() public {   
    // Push Auction Proposal
    proposalsExtArray.pushAuction(ICommon.AuctionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 21,
        voteStartAt: uint128(block.timestamp) + 300,
        voteEndAt: uint128(block.timestamp) + 3000,
        ptype: ICommon.ProposalType.AUCTION
      }),
      minPrice: 1000,
      stuffID: keccak256(abi.encodePacked(uint8(200)))
    }));

    // Push Decision Proposal
    proposalsExtArray.pushDecision(ICommon.DecisionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 22,
        voteStartAt: uint128(block.timestamp) + 200,
        voteEndAt: uint128(block.timestamp) + 2000,
        ptype: ICommon.ProposalType.DECISION
      }),
      choose: "Choose One?"
    }));

    // Push Election Proposal
    proposalsExtArray.pushElection(ICommon.ElectionProposal({
      baseProposal: ICommon.BaseProposal({
        id: 23,
        voteStartAt: uint128(block.timestamp) + 400,
        voteEndAt: uint128(block.timestamp) + 4000,
        ptype: ICommon.ProposalType.ELECTION
      }),
      minNominator: 5,
      maxNominator: 15,
      quorumVotes: 900,
      nominators: electionProposal.nominators
    }));    

    // Get Auction
    ICommon.AuctionProposal storage auctionTemp = proposalsExtArray.getAuction(0);
    require(auctionTemp.baseProposal.id == 21, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    // Get Decision
    ICommon.DecisionProposal storage decisionTemp = proposalsExtArray.getDecision(1);
    require(decisionTemp.baseProposal.id == 22, "Invalid Id");
    require(decisionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(decisionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(decisionTemp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");   
    require(keccak256(abi.encodePacked(decisionTemp.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");
    
    // Get Election 
    ICommon.ElectionProposal storage electionTemp = proposalsExtArray.getElection(2);
    require(electionTemp.baseProposal.id == 23, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.minNominator == 5, "Invalid minNominator");
    require(electionTemp.maxNominator == 15, "Invalid maxNominator");
    require(electionTemp.quorumVotes == 900, "Invalid quorumVotes");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");

    // Pop Item
    proposalsExtArray.popItem();
    require(proposalsExtArray.length == 2, "Invalid Length");

     // Test Auction
    ICommon.AuctionProposal storage popAuction = proposalsExtArray.getAuction(0);
    require(popAuction.baseProposal.id == 21, "Invalid Id");
    require(popAuction.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(popAuction.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(popAuction.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(popAuction.minPrice == 1000, "Invalid Price");
    require(popAuction.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    // Test Decision
    ICommon.DecisionProposal storage popDecision = proposalsExtArray.getDecision(1);
    require(popDecision.baseProposal.id == 22, "Invalid Id");
    require(popDecision.baseProposal.voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(popDecision.baseProposal.voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(popDecision.baseProposal.ptype == ICommon.ProposalType.DECISION, "Invalid Type");    
    require(keccak256(abi.encodePacked(popDecision.choose)) == keccak256(abi.encodePacked("Choose One?")), "Invalid Choose");


    // Pop Item
    proposalsExtArray.popItem();
    require(proposalsExtArray.length == 1, "Invalid Length");    

    popAuction = proposalsExtArray.getAuction(0);
    require(popAuction.baseProposal.id == 21, "Invalid Id");
    require(popAuction.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(popAuction.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(popAuction.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Invalid Type");
    require(popAuction.minPrice == 1000, "Invalid Price");
    require(popAuction.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    // Pop Item
    proposalsExtArray.popItem();
    require(proposalsExtArray.length == 0, "Invalid Length");
  }

  /**
   * @dev extendedFunctionTest() tests upcasting base structure (BaseProposal) from derived structures (DecisionProposal, etc) and 
   * downcasting base structure to derived structures in the memory area as well.
   */
  function extendedFunctionTest() public view {
    ICommon.DecisionProposal memory dp = decisionProposal;
    ICommon.AuctionProposal memory ap = auctionProposal;    
    ICommon.ElectionProposal memory ep = electionProposal;

    validateProposal(dp.baseProposal);
    validateProposal(ap.baseProposal);
    validateProposal(ep.baseProposal);
  }

  /**
   * @dev validate proposal types
   */
  function validateProposal(ICommon.BaseProposal memory bp) public pure {
    if(bp.ptype == ICommon.ProposalType.DECISION) {
      ICommon.DecisionProposal memory dp = LCastingStruct.memoryGetDecision(bp);      
      require(keccak256(abi.encodePacked(dp.choose)) == keccak256(abi.encodePacked("Yes/No Question?")), "Invalid Choose");

    } else if(bp.ptype == ICommon.ProposalType.AUCTION) {
      ICommon.AuctionProposal memory ap = LCastingStruct.memoryGetAuction(bp);
      require(ap.minPrice == 2000, "Invalid MinPrice");
      require(ap.stuffID == keccak256(abi.encodePacked(uint8(101))), "Invalid Stuff ID");

    } else if(bp.ptype == ICommon.ProposalType.ELECTION) {
      ICommon.ElectionProposal memory ep = LCastingStruct.memoryGetElection(bp);
      require(ep.minNominator == 1, "Invalid minNominator");
      require(ep.maxNominator == 7, "Invalid maxNominator");
      require(ep.quorumVotes == 750, "Invalid quorumVotes");
      require(ep.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
    }
  }
}