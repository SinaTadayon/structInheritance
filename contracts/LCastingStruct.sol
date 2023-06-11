// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

import "./ICommon.sol";

/**
 * @title Casting Struct Library
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev Collection functions to manage storage slots and memory pointers of structure types 
 * for mapping, dynamic array, and memory casting in conjunction with structure inheritance over composition
 *
 */
library LCastingStruct {
  /**
   * @dev it finds a storage slot of a derived structure (DecisionProposal) in a mapping data structure 
   * by a key (ProposalId) according to the keccak256(h(k) . p) formula,    
   * then the found slot is set to a slot of target structure (DecisionProposal) 
   * which means downcasting a base struct (BaseProposal) to a derived structure (DecisionProposal), 
   * and finally validates it by considering the SET/GET action.
   *
   * The Get action checks only the ProposalType of the found Decision structure 
   * which is compatible with the found struct itself.
   *
   * The Set action checks two conditions at the same time, the first one is 
   *
   *    dp.baseProposal.ptype == ICommon.ProposalType.NONE 
   *
   * for checking empty slots if any Decision structure hasn't already existed 
   *
   * The second one is 
   *
   *    dp.baseProposal.ptype == ICommon.ProposalType.DECISION 
   *
   * for checking the slots that have had the Decision structure that wants to update it.
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
      require(
        dp.baseProposal.ptype == ICommon.ProposalType.NONE || 
        dp.baseProposal.ptype == ICommon.ProposalType.DECISION, 
        "Illegal DECISION Proposal"
      );      
    }
  }

  /**
   * @dev it's the same as the storageDecision function with differences in target downcasting structure 
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
      require(
        ap.baseProposal.ptype == ICommon.ProposalType.NONE || 
        ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, 
        "Illegal AUCTION Proposal"
      );      
    }
  }

  /**
   * @dev it's the same as the storageDecision function with differences in target downcasting structure 
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
      require(
        ep.baseProposal.ptype == ICommon.ProposalType.NONE || 
        ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, 
        "Illegal ELECTION Proposal"
      );      
    }
  }
  
  /**
   * @dev it finds a storage slot of a derived structure (DecisionProposal) in a dynamic array data structure
   * by an index of array (idx) according to the (keccak256(p) + (index * the biggest size of derived structure)) formula,
   * in this case, the biggest size of the derived structure among all derived structures is ElectionProposal 
   * which will occupy 7 slots at least, meanwhile the DecisionProposal will occupy 5 slots at least.
   * then the found slot is set to a slot of target structure (DecisionProposal) 
   * which means downcasting a base struct (BaseProposal) to a derived structure (DecisionProposal), 
   * and finally validates it by the ProposalType.
   */
  function getDecision(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 idx)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {
    require(idx < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      dp.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illegal DECISION Proposal");
  }

  /**
   * @dev it's the same as the getDecision function with differences in target downcasting structure 
   * and related the ProposalType validation. the AuctionProposal only will occupy 6 slots. 
   */
  function getAuction(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 idx)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    require(idx < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      ap.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illegal AUCTION Proposal");
  }

  /**
   * @dev it's the same as the getDecision function with differences in target downcasting structure 
   * and related the ProposalType validation
   */
  function getElection(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 idx)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    require(idx < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      ep.slot := add(keccak256(ptr, 0x20), mul(idx, 7))
    }    

    require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illegal ELECTION Proposal");
  }

  /**
   * @dev push derived structure to the Proposals dynamic array.
   * it finds a storage slot of a derived structure (DecisionProposal) in a dynamic array data structure
   * by the last index of the array according to the (keccak256(p) + (index * the biggest size of derived structure)) formula,
   * in this case, the biggest size of the derived structure among all derived structures is ElectionProposal 
   * which will occupy 7 slots at least, meanwhile the DecisionProposal will occupy 5 slots at least.
   * finally the found slot is set to a slot of target structure (DecisionProposal) 
   * which means downcasting a base struct (BaseProposal) to a derived structure (DecisionProposal). 
   */
  function pushDecision(ICommon.BaseProposal[] storage dynamicArrayProposals, ICommon.DecisionProposal memory decisionProposal)
    internal    
    returns (ICommon.DecisionProposal storage dp)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      dp.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    dp.baseProposal = decisionProposal.baseProposal;
    dp.choose = decisionProposal.choose;
  }

  /**
   * @dev it's the same as the pushDecision function with differences in target downcasting structure.
   * The AuctionProposal only will occupy 6 slots. 
   */
  function pushAuction(ICommon.BaseProposal[] storage dynamicArrayProposals, ICommon.AuctionProposal memory auctionProposal)
    internal    
    returns (ICommon.AuctionProposal storage ap)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      ap.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    ap.baseProposal = auctionProposal.baseProposal;
    ap.minPrice = auctionProposal.minPrice;
    ap.stuffID = auctionProposal.stuffID;
  }

  /**
   * @dev it's the same as the pushDecision function with differences in target downcasting structure.
   */
  function pushElection(ICommon.BaseProposal[] storage dynamicArrayProposals, ICommon.ElectionProposal memory electionProposal)
    internal    
    returns (ICommon.ElectionProposal storage ep)
  {    
    assembly {
      let ptr := mload(0x40)
      let lastIndex := sload(dynamicArrayProposals.slot)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      sstore(dynamicArrayProposals.slot, add(lastIndex, 0x01))
      ep.slot := add(keccak256(ptr, 0x20), mul(lastIndex, 7))
    }
    ep.baseProposal = electionProposal.baseProposal;
    ep.minNominator = electionProposal.minNominator;
    ep.maxNominator = electionProposal.maxNominator;
    ep.quorumVotes = electionProposal.quorumVotes;
    ep.nominators = electionProposal.nominators; 
  }

  /** 
   * @dev pop last item from the Proposals dynamic array. 
   * it finds a storage slot of a one of the derived structure in a dynamic array data structure
   * by the last index of the array according to the (keccak256(p) + (index * the biggest size of derived structure)) formula,
   * in this case, the biggest size of the derived structure among all derived structures is ElectionProposal 
   * which will occupy 7 slots at least.
   * then the found slot is set to a slot of has gotten the last derived structure 
   * which means downcasting a base struct (BaseProposal) to a derived structure (DecisionProposal), 
   * finally delete elemnets of derived structure according to specific the ProposalType.  
   */
  function popItem(ICommon.BaseProposal[] storage dynamicArrayProposals) 
    internal 
    returns (ICommon.BaseProposal storage bp)
  { 
    require(dynamicArrayProposals.length > 0, "Invalid Pop");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let length := sub(sload(dynamicArrayProposals.slot), 0x01)      
      sstore(dynamicArrayProposals.slot, length)
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
   * @dev for memory downcasting of base structure to derived structure,  
   * it should find a memory address pointer of the derived structure according to the
   *
   *    (base struct address pointer - (0x20 * member counts of derived struct)) formula,
   *
   * in this case, the difference between the BaseProposal and DecisionProposal address pointers is 2 * 0x20,
   * then the found address is set to a pointer of target derived structure (DecisionProposal)
   * which means downcasting a base struct (BaseProposal) to a derived structure (DecisionProposal).
   *
   * Note: the mentioned formula is only true when the base structure is the first member defined in the derived structure.
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