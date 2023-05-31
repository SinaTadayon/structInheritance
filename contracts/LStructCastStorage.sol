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

  function downCastingToDecision(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
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

  function downCastingToAuction(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
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

  function downCastingToElection(ICommon.BaseProposal[3] storage fixedArrayProposals, uint256 index)
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
}