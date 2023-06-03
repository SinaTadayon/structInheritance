// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./ICommon.sol";

/**
 * @title Casting Struct Library
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev
 *
 */
library LCastingStruct {
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
      require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illeagl DECISION Proposal");
    } else {
      require(
        dp.baseProposal.ptype == ICommon.ProposalType.NONE || 
        dp.baseProposal.ptype == ICommon.ProposalType.DECISION, 
        "Illeagl DECISION Proposal"
      );      
    }
  }

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
      require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illeagl AUCTION Proposal");
    } else {
      require(
        ap.baseProposal.ptype == ICommon.ProposalType.NONE || 
        ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, 
        "Illeagl AUCTION Proposal"
      );      
    }
  }

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
      require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illeagl ELECTION Proposal");
    } else {
      require(
        ep.baseProposal.ptype == ICommon.ProposalType.NONE || 
        ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, 
        "Illeagl ELECTION Proposal"
      );      
    }
  }
  
  function getDecision(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      dp.slot := add(arraySlot, mul(index, 6))
    }    

    require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illegal DECISION Proposal");
  }

  function getAuction(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      ap.slot := add(arraySlot, mul(index, 6))
    }    

    require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illegal AUCTION Proposal");
  }

  function getElection(ICommon.BaseProposal[] storage dynamicArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    require(index < dynamicArrayProposals.length, "Invalid Index");
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let arraySlot := keccak256(ptr, 0x20)
      ep.slot := add(arraySlot, mul(index, 6))
    }    

    require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illegal ELECTION Proposal");
  }


  function pushDecision(ICommon.BaseProposal[] storage dynamicArrayProposals)
    internal    
    returns (ICommon.DecisionProposal storage dp)
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

  function pushAuction(ICommon.BaseProposal[] storage dynamicArrayProposals)
    internal    
    returns (ICommon.AuctionProposal storage ap)
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

  function pushElection(ICommon.BaseProposal[] storage dynamicArrayProposals)
    internal    
    returns (ICommon.ElectionProposal storage ep)
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

  function popItem(ICommon.BaseProposal[] storage dynamicArrayProposals) internal {
    ICommon.BaseProposal storage bp;
    assembly {
      let ptr := mload(0x40)
      mstore(add(ptr, 0x00), dynamicArrayProposals.slot)
      let length := sub(sload(dynamicArrayProposals.slot), 0x01)      
      sstore(dynamicArrayProposals.slot, length)
      let arraySlot := keccak256(ptr, 0x20)
      bp.slot := add(arraySlot, mul(length, 6))
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
      delete ep.nominators;
    }
  }

   function memoryGetDecision(ICommon.BaseProposal memory bp) internal pure returns (ICommon.DecisionProposal memory dp) {

    if(bp.ptype == ICommon.ProposalType.DECISION) {
      assembly {
        dp := sub(bp, 0x40)
      }
    } else {
      revert("Invalid DECISION Proposal");
    }
  }

  function memoryGetAuction(ICommon.BaseProposal memory bp) internal pure returns (ICommon.AuctionProposal memory ap) {
    if(bp.ptype == ICommon.ProposalType.AUCTION) {
      assembly {      
        ap := sub(bp, 0x60)
      }
    } else {
      revert("Invalid AUCTION Proposal");
    }
  }

  function memoryGetElection(ICommon.BaseProposal memory bp) internal pure returns (ICommon.ElectionProposal memory ep) {
    if(bp.ptype == ICommon.ProposalType.ELECTION) {
      assembly {
        ep := sub(bp, 0x40)
      }
    } else {
      revert("Invalid ELECTION Proposal");
    }
  }

}