// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./ICommon.sol";

/**
 * @title Cast Storage Library
 * @author Sina Tadayon, https://github.com/SinaTadayon
 * @dev
 *
 */
library LStructCastStorage {
  function mapCastToDecision(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {
    ICommon.BaseProposal storage bp = proposalMaps[proposalId];
    if (bp.ptype == ICommon.ProposalType.DECISION) {
      assembly {
        let ptr := mload(0x40)
        mstore(add(ptr, 0x00), proposalId)
        mstore(add(ptr, 0x20), add(proposalMaps.slot, 8))
        dp.slot := keccak256(ptr, 0x40)
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

  function mapCastToAuction(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    ICommon.BaseProposal storage bp = proposalMaps[proposalId];
    if (bp.ptype == ICommon.ProposalType.AUCTION) {
      assembly {
        let ptr := mload(0x40)
        mstore(add(ptr, 0x00), proposalId)
        mstore(add(ptr, 0x20), add(proposalMaps.slot, 8))
        ap.slot := keccak256(ptr, 0x40)
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

  function mapCastToElection(mapping(bytes32 => ICommon.BaseProposal) storage proposalMaps, bytes32 proposalId)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    ICommon.BaseProposal storage bp = proposalMaps[proposalId];
    if (bp.ptype == ICommon.ProposalType.ELECTION) {
      assembly {
        let ptr := mload(0x40)
        mstore(add(ptr, 0x00), proposalId)
        mstore(add(ptr, 0x20), add(proposalMaps.slot, 8))
        ep.slot := keccak256(ptr, 0x40)
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

  function getDecision(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.DecisionProposal storage dp)
  {    
    ICommon.BaseProposal storage bp = fixedArrayProposals[index];
    if (bp.ptype == ICommon.ProposalType.DECISION) {
      assembly {        
        dp.slot := bp.slot
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

  function getAuction(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.AuctionProposal storage ap)
  {
    ICommon.BaseProposal storage bp = fixedArrayProposals[index];
    if (bp.ptype == ICommon.ProposalType.AUCTION) {
      assembly {        
        ap.slot := bp.slot
      }    
    } else {
      revert("Illeagl Proposal");
    }
  }

  function getElection(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
    internal
    view
    returns (ICommon.ElectionProposal storage ep)
  {
    ICommon.BaseProposal storage bp = fixedArrayProposals[index];
    if (bp.ptype == ICommon.ProposalType.ELECTION) {
      assembly {        
        ep.slot := bp.slot
      }    
    } else {
      revert("Illeagl Proposal");
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

    require(dp.baseProposal.ptype == ICommon.ProposalType.DECISION, "Illegal Proposal");
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

    require(ap.baseProposal.ptype == ICommon.ProposalType.AUCTION, "Illegal Proposal");
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

    require(ep.baseProposal.ptype == ICommon.ProposalType.ELECTION, "Illegal Proposal");
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

}