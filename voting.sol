// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Voting {
    IERC20 public token;

    struct Proposal {
        string description;
        uint256 voteCount;
        mapping(address => bool) voted;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter);

    constructor(IERC20 _token) {
        token = _token;
    }

    function createProposal(string memory description) external {
        proposals.push();
        Proposal storage newProposal = proposals[proposals.length - 1];
        newProposal.description = description;

        emit ProposalCreated(proposals.length - 1, description);
    }

    function vote(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.voted[msg.sender], "Already voted");
        require(token.balanceOf(msg.sender) > 0, "Must hold tokens to vote");

        proposal.voted[msg.sender] = true;
        proposal.voteCount++;

        emit Voted(proposalId, msg.sender);
    }

    function getProposalVoteCount(uint256 proposalId) external view returns (uint256) {
        return proposals[proposalId].voteCount;
    }
}