// SPDX-License-Identifier: MIT

import "hardhat/console.sol";

pragma solidity 0.8.19;

contract Test {
  enum ProposalType {
    NONE,
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
  DecisionProposal[] internal dynamicArrayProposals1;
  BaseProposal[3] internal fixedArrayProposals;
  BaseProposal[8] internal proposals;

  DecisionProposal internal  decisionProposal;
  AuctionProposal  internal  auctionProposal;
  ElectionProposal internal  electionProposal;


  constructor() {
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
    address[] memory candidators = new address[](2);
    candidators[0] = 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9;
    // Decision Proposal
    DecisionProposal storage decision = appendDecision();
    decision.baseProposal = BaseProposal({
      id: 10,
      voteStartAt: uint128(block.timestamp) + 200,
      voteEndAt: uint128(block.timestamp) + 2000,
      ptype: ProposalType.DECISION
    });
    decision.choose = "Choose One?";

    // Auction Proposal
    AuctionProposal storage auction = appendAuction();
    auction.baseProposal = BaseProposal({
      id: 11,
      voteStartAt: uint128(block.timestamp) + 300,
      voteEndAt: uint128(block.timestamp) + 3000,
      ptype: ProposalType.AUCTION
    });
    auction.minPrice = 1000;
    auction.stuffID = keccak256(abi.encodePacked(uint8(200)));

    // Election Proposal
    ElectionProposal storage election = appendElection();    
    election.baseProposal = BaseProposal({
      id: 12,
      voteStartAt: uint128(block.timestamp) + 400,
      voteEndAt: uint128(block.timestamp) + 4000,
      ptype: ProposalType.ELECTION
    });
    election.nominators = candidators;


    // Test 0 index
    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    require(dynamicArrayProposals[0].voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    require(dynamicArrayProposals[0].voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ProposalType.DECISION, "Invalid Type");
    
    DecisionProposal storage decisionTemp = downCastingToDecision2(0);
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");


    // Test 1 index
    AuctionProposal storage auctionTemp = downCastingToAuction2(1);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");
    
    
    // Test 2 index
    ElectionProposal storage electionTemp = downCastingToElection2(2);
    require(electionTemp.baseProposal.id == 12, "Invalid Id");
    require(electionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 400, "Invalid Start");
    require(electionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 4000, "Invalid End");
    require(electionTemp.baseProposal.ptype == ProposalType.ELECTION, "Invalid Type");
    require(electionTemp.nominators[0] == 0xb95D435df3f8b2a8D8b9c2b7c8766C9ae6ED8cc9, "Invalid Nom");
  }

  function popTest() public {
    popElement();
    require(dynamicArrayProposals.length == 2, "Invalid Length");

    // // Test 0 index
    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    // require(dynamicArrayProposals[0].voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    // require(dynamicArrayProposals[0].voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ProposalType.DECISION, "Invalid Type");
    
    DecisionProposal storage decisionTemp = downCastingToDecision2(0);
    require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");

     // Test 1 index
    AuctionProposal storage auctionTemp = downCastingToAuction2(1);
    require(auctionTemp.baseProposal.id == 11, "Invalid Id");
    // require(auctionTemp.baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
    // require(auctionTemp.baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
    require(auctionTemp.baseProposal.ptype == ProposalType.AUCTION, "Invalid Type");
    require(auctionTemp.minPrice == 1000, "Invalid Price");
    require(auctionTemp.stuffID == keccak256(abi.encodePacked(uint8(200))), "Invalid SuffID");

    popElement();
    require(dynamicArrayProposals.length == 1, "Invalid Length");
    // // Test 0 index
    require(dynamicArrayProposals[0].id == 10, "Invalid Id");
    // require(dynamicArrayProposals[0].voteStartAt == uint128(block.timestamp) + 200, "Invalid Start");
    // require(dynamicArrayProposals[0].voteEndAt == uint128(block.timestamp) + 2000, "Invalid End");
    require(dynamicArrayProposals[0].ptype == ProposalType.DECISION, "Invalid Type");
    
    DecisionProposal storage decisionTemp1 = downCastingToDecision2(0);
    require(bytes(decisionTemp1.choose).length == bytes("Choose One?").length, "Invalid Choose");

    popElement();
    require(dynamicArrayProposals.length == 0, "Invalid Length");
  }

  //  function downcastingDynamicArrayStructs() public {
  //   //  dynamicArrayProposals = new BaseProposal[](5);
  //    uint128 start = uint128(block.timestamp) + 200;
  //    uint128 end = uint128(block.timestamp) + 2000;
  //   // DecisionProposal storage decision = downCastingToDecision2(0);
    
  //   DecisionProposal storage decision = appendTo2();
  //   decision.baseProposal = BaseProposal({
  //     id: 10,
  //     voteStartAt: start,
  //     voteEndAt: end,
  //     ptype: ProposalType.DECISION
  //   });
  //   decision.choose = "Choose One?";


  //   DecisionProposal storage decision1 = appendTo2();
  //   decision1.baseProposal = BaseProposal({
  //     id: 11,
  //     voteStartAt: uint128(block.timestamp) + 300,
  //     voteEndAt: uint128(block.timestamp) + 3000,
  //     ptype: ProposalType.DECISION
  //   });
  //   decision1.choose = "Choose One 1?";



  //   require(dynamicArrayProposals1[0].baseProposal.id == 10, "Invalid Id");
  //   require(dynamicArrayProposals1[0].baseProposal.voteStartAt == start, "Invalid Start");
  //   require(dynamicArrayProposals1[0].baseProposal.voteEndAt == end, "Invalid End");
  //   require(dynamicArrayProposals1[0].baseProposal.ptype == ProposalType.DECISION, "Invalid Type");


  //   require(dynamicArrayProposals1[1].baseProposal.id == 11, "Invalid Id");
  //   require(dynamicArrayProposals1[1].baseProposal.voteStartAt == uint128(block.timestamp) + 300, "Invalid Start");
  //   require(dynamicArrayProposals1[1].baseProposal.voteEndAt == uint128(block.timestamp) + 3000, "Invalid End");
  //   require(dynamicArrayProposals1[1].baseProposal.ptype == ProposalType.DECISION, "Invalid Type");

  //   // DecisionProposal storage decisionTemp = downCastingToDecision2(0);
  //   // require(bytes(decisionTemp.choose).length == bytes("Choose One?").length, "Invalid Choose");
  // }


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
    returns (DecisionProposal storage dp)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      dp.slot := add(arraySlot, mul(index, 6))
    }    

    require(dp.baseProposal.ptype == ProposalType.DECISION, "Illegal Proposal");
  }

  function downCastingToAuction2(uint256 index)
    internal
    view
    returns (AuctionProposal storage ap)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      ap.slot := add(arraySlot, mul(index, 6))
    }    

    require(ap.baseProposal.ptype == ProposalType.AUCTION, "Illegal Proposal");
  }

  function downCastingToElection2(uint256 index)
    internal
    view
    returns (ElectionProposal storage ep)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      ep.slot := add(arraySlot, mul(index, 6))
    }    

    require(ep.baseProposal.ptype == ProposalType.ELECTION, "Illegal Proposal");
  }


  function appendDecision()
    internal    
    returns (DecisionProposal storage dp)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      let arraySlot := keccak256(ptr, 0x20)
      dp.slot := add(arraySlot, mul(lastIndex, 6))
    }
  }

  function appendAuction()
    internal    
    returns (AuctionProposal storage ap)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      let arraySlot := keccak256(ptr, 0x20)
      ap.slot := add(arraySlot, mul(lastIndex, 6))
    }
  }

  function appendElection()
    internal    
    returns (ElectionProposal storage ep)
  {        
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      let arraySlot := keccak256(ptr, 0x20)
      ep.slot := add(arraySlot, mul(lastIndex, 6))
    }
  }

  function popElement() internal {
    BaseProposal storage bp;
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let length := sub(sload(dynamicArrayProposals.slot), 0x01)      
      sstore(dynamicArrayProposals.slot, length)
      let arraySlot := keccak256(ptr, 0x20)
      bp.slot := add(arraySlot, mul(length, 6))
    }

    if(bp.ptype == ProposalType.DECISION) {
      DecisionProposal storage dp;
      assembly { dp.slot := bp.slot }
      delete dp.baseProposal;
      delete dp.choose;

    } else if (bp.ptype == ProposalType.AUCTION) {
      AuctionProposal storage ap;
      assembly { ap.slot := bp.slot }
      delete ap.baseProposal;
      delete ap.minPrice;
      delete ap.stuffID;

    } else if(bp.ptype == ProposalType.ELECTION) {
      ElectionProposal storage ep;
      assembly { ep.slot := bp.slot }
      delete ep.baseProposal;
      delete ep.nominators;
    }
  }

  // function appendTo2()
  //   internal    
  //   returns (DecisionProposal storage dp)
  // {    
  //   dynamicArrayProposals1.push();
  //   uint last = dynamicArrayProposals1.length - 1;
  //   assembly {
  //     let ptr := mload(0x40)
  //     mstore(add(ptr, 0x00), dynamicArrayProposals1.slot)
  //     let arraySlot := keccak256(ptr, 0x20)
  //     dp.slot := add(arraySlot, mul(last, 5))
  //   }
  // }

}