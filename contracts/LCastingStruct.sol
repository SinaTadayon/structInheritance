// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "./ICommon.sol";

/**
 * @title Casting Struct Library
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev These collection functions are designed to manage storage slots and memory pointers of struct types for mapping, 
 * dynamic array, and memory casting. They work in conjunction with struct inheritance over composition.
 *
 */
library LCastingStruct {
  /**
   * @dev Find the storage slot of a derived structure (DecisionProposal) in a mapping data struct using a 
   * key (ProposalId) and the keccak256(h(k) . p) formula. Then, set the found slot as the slot of the 
   * target struct (DecisionProposal), which involves downcasting the base struct (BaseProposal) to 
   * a derived struct (DecisionProposal). Finally, validate it based on the SET/GET action.
   * 
   * The GET action checks the ProposalType of the found Decision structure to ensure compatibility with the found struct itself.
   * The SET action checks checks for empty slots where no Decision structure has already existed.
   */
  function storageDecision(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId, ICommon.ActionType atype)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalId)
      mstore(add(ptr, 0x20), proposalMaps.slot)
      dp.slot := keccak256(ptr, 0x40)
    }
    if(atype == ICommon.ActionType.GET) {
      require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illegal DECISION Proposal");
    } else {
      require( dp.baseProposal.ptype == ICommon.ProposalType.NONE, "Illegal DECISION Proposal");      
    }
  }

  /**
   * @dev it's the same as the storageDecision function with differences in target down-casting struct
   * and related the ProposalType validation
   */
  function storageAuction(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId, ICommon.ActionType atype)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalId)
      mstore(add(ptr, 0x20), proposalMaps.slot)
      ap.slot := keccak256(ptr, 0x40)
    }
    if(atype == ICommon.ActionType.GET) {
      require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illegal AUCTION Proposal");
    } else {
      require(ap.baseProposal.ptype == ICommon.ProposalType.NONE, "Illegal AUCTION Proposal");      
    }
  }

  /**
   * @dev it's the same as the storageDecision function with differences in target down-casting struct 
   * and related the ProposalType validation
   */
  function storageElection(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId, ICommon.ActionType atype)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalId)
      mstore(add(ptr, 0x20), proposalMaps.slot)
      ep.slot := keccak256(ptr, 0x40)
    }
    if(atype == ICommon.ActionType.GET) {
      require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illegal ELECTION Proposal");
    } else {
      require(ep.baseProposal.ptype == ICommon.ProposalType.NONE, "Illegal ELECTION Proposal");      
    }
  }
  
  /**
   * @dev Find the storage slot of a derived struct (DecisionProposal) in a dynamic array using an array index (idx) and 
   * the (keccak256(p) + (index * the size of the largest derived struct)) formula. 
   * In this case, the largest size among all the derived structs is occupied by ElectionProposal, 
   * requiring at least 7 slots, while DecisionProposal requires at least 5 slots. 
   * Set the found slot as the slot of the target struct (DecisionProposal), which involves down-casting 
   * the base struct (BaseProposal) to a derived struct (DecisionProposal). Finally, validate it based on the ProposalType.   
   */
  function getDecision(ICommon.BaseProposal[] storage proposalsExtArray, uint256 idx)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {
    require(idx < proposalsExtArray.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      dp.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illegal DECISION Proposal");
  }

  /**
   * @dev it's the same as the getDecision function with differences in target down-casting struct 
   * and related the ProposalType validation. the AuctionProposal only will occupy 6 slots. 
   */
  function getAuction(ICommon.BaseProposal[] storage proposalsExtArray, uint256 idx)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    require(idx < proposalsExtArray.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      ap.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illegal AUCTION Proposal");
  }

  /**
   * @dev it's the same as the getDecision function with differences in target down-casting struct 
   * and related the ProposalType validation
   */
  function getElection(ICommon.BaseProposal[] storage proposalsExtArray, uint256 idx)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    require(idx < proposalsExtArray.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      ep.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illegal ELECTION Proposal");
  }

  /**
   * @dev Push the derived struct (DecisionProposal) to the Proposals dynamic array. 
   * To find the storage slot of the derived struct within the dynamic array, 
   * use the last index of the array and the (keccak256(p) + (index * the size of the largest derived struct)) formula. 
   * In this case, the largest size among all the derived structs is occupied by ElectionProposal, 
   * requiring at least 7 slots, while DecisionProposal requires at least 5 slots. 
   * Finally, set the found slot as the slot of the target structure (DecisionProposal), 
   * which involves downcasting the base struct (BaseProposal) to a derived struct (DecisionProposal).   
   */
  function pushDecision(ICommon.BaseProposal[] storage proposalsExtArray, ICommon.DecisionProposal memory decisionProposal)
    internal    
    returns (ICommon.DecisionProposal storage dp)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(proposalsExtArray.slot)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      sstore(proposalsExtArray.slot, add(lastIndex, 0x01))
      dp.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    dp.baseProposal = decisionProposal.baseProposal;
    dp.choose = decisionProposal.choose;
  }

  /**
   * @dev it's the same as the pushDecision function with differences in target down-casting struct.
   * The AuctionProposal only will occupy 6 slots. 
   */
  function pushAuction(ICommon.BaseProposal[] storage proposalsExtArray, ICommon.AuctionProposal memory auctionProposal)
    internal    
    returns (ICommon.AuctionProposal storage ap)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(proposalsExtArray.slot)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      sstore(proposalsExtArray.slot, add(lastIndex, 0x01))
      ap.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    ap.baseProposal = auctionProposal.baseProposal;
    ap.minPrice = auctionProposal.minPrice;
    ap.stuffID = auctionProposal.stuffID;
  }

  /**
   * @dev it's the same as the pushDecision function with differences in target down-casting struct.
   */
  function pushElection(ICommon.BaseProposal[] storage proposalsExtArray, ICommon.ElectionProposal memory electionProposal)
    internal    
    returns (ICommon.ElectionProposal storage ep)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(proposalsExtArray.slot)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      sstore(proposalsExtArray.slot, add(lastIndex, 0x01))
      ep.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    ep.baseProposal = electionProposal.baseProposal;
    ep.minNominator = electionProposal.minNominator;
    ep.maxNominator = electionProposal.maxNominator;
    ep.quorumVotes = electionProposal.quorumVotes;
    ep.nominators = electionProposal.nominators; 
  }

  /** 
   * @dev Pop the last item from the Proposals dynamic array. To find the storage slot of one of the derived structs 
   * in the dynamic array, use the last index of the array and 
   * the (keccak256(p) + (index * the size of the largest derived struct)) formula. 
   * In this case, the largest size among all the derived structs is occupied by ElectionProposal, 
   * which requires at least 7 slots. Set the found slot as the slot containing the last derived struct, 
   * which involves down-casting the base struct (BaseProposal) to a derived struct based on the specific ProposalType (Decision, Auction, Election). 
   * Finally, delete elements of the derived struct.
   */
  function popItem(ICommon.BaseProposal[] storage proposalsExtArray) internal { 
    require(proposalsExtArray.length > 0, "Invalid Pop");
    ICommon.BaseProposal storage bp;
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), proposalsExtArray.slot)
      let length := sub(sload(proposalsExtArray.slot), 0x01)      
      sstore(proposalsExtArray.slot, length)
      bp.slot := add(keccak256(ptr, 0x20), mul(length, 7))
    }

    if(bp.ptype == ICommon.ProposalType.DECISION) {
      ICommon.DecisionProposal storage dp;
      assembly { dp.slot := bp.slot }
      delete dp.baseProposal;
      delete dp.choose;

    } else if (bp.ptype == ICommon.ProposalType.AUCTION) {
      ICommon.AuctionProposal storage ap;
      assembly { ap.slot := bp.slot }
      delete ap.baseProposal;
      delete ap.minPrice;
      delete ap.stuffID;

    } else if(bp.ptype == ICommon.ProposalType.ELECTION) {
      ICommon.ElectionProposal storage ep;
      assembly { ep.slot := bp.slot }
      delete ep.baseProposal;
      delete ep.minNominator;
      delete ep.maxNominator;
      delete ep.quorumVotes;
      delete ep.nominators;
    }
  }

  /** 
   * @dev for memory down-casting of the base struct to the derived struct,  
   * it should find a memory address pointer of the derived struct according to the
   * 
   *    (base struct address pointer - (size of memory slot * member counts of derived struct)) formula,
   * 
   * in this case, the difference between the BaseProposal and DecisionProposal address pointers is 2 * 0x20,
   * then the found address is set to a pointer of target derived struct (DecisionProposal)
   * which means down-casting a base struct (BaseProposal) to a derived struct (DecisionProposal).
   * 
   * Note: the mentioned formula is only true when the base struct is the first member defined in the derived struct.
   */
  function memoryGetDecision(ICommon.BaseProposal memory bp) internal pure returns (ICommon.DecisionProposal memory dp) {

    if(bp.ptype == ICommon.ProposalType.DECISION) {
      assembly {
        dp := sub(bp, 0x40)
      }
    } else {
      revert("Invalid DECISION Proposal");
    }
  }

  /**
   * @dev it's the same as the memoryGetDecision function with differences in calculating the downcasting structure formula.
   * Note: member counts of AuctionProposal structure is 3
   */
  function memoryGetAuction(ICommon.BaseProposal memory bp) internal pure returns (ICommon.AuctionProposal memory ap) {
    if(bp.ptype == ICommon.ProposalType.AUCTION) {
      assembly {      
        ap := sub(bp, 0x60)
      }
    } else {
      revert("Invalid AUCTION Proposal");
    }
  }

  /**
   * @dev it's the same as the memoryGetDecision function with differences in calculating the downcasting structure formula.
   * Note: member counts of ElectionProposal structure is 4
   */
  function memoryGetElection(ICommon.BaseProposal memory bp) internal pure returns (ICommon.ElectionProposal memory ep) {
    if(bp.ptype == ICommon.ProposalType.ELECTION) {
      assembly {
        ep := sub(bp, 0xa0)
      }
    } else {
      revert("Invalid ELECTION Proposal");
    }
  }
}