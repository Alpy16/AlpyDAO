//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IAlpyStaking {function getVotes(address user) external view returns (uint256);}


     contract AlpyDAO {


    IAlpyStaking public staking;
    uint256 public votingPeriod;
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    event Voted(address indexed voter, uint256 indexed proposalId, bool support, uint256 weight);
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, string description);
    event ProposalExecuted(uint256 indexed proposalId, address indexed executor);
    

    struct Proposal {
        address proposer;
        address target;
        uint256 value; //eth to  send 
        bytes calldataPayload;
        string description;
        uint256 votesFor;
        uint256 votesAgainst; 
        uint256 deadline;
        bool executed;
    }

    constructor(address stakingContract, uint256 _votingPeriod) {
        staking = IAlpyStaking(stakingContract);
        votingPeriod = _votingPeriod;
    }

    function createProposal(address target,uint256 value,bytes calldata calldataPayload,string calldata description) external returns (uint256) {
        require(staking.getVotes(msg.sender) > 0, "Only stakers can create proposals");
        proposals[proposalCount].proposer = msg.sender;
        proposals[proposalCount].target = target;
        proposals[proposalCount].value = value;
        proposals[proposalCount].calldataPayload = calldataPayload;
        proposals[proposalCount].description = description;
        proposals[proposalCount].deadline = block.timestamp + votingPeriod;
        proposals[proposalCount].votesFor = 0;
        proposals[proposalCount].votesAgainst = 0;
        proposals[proposalCount].executed = false;

        proposalCount++;

        emit ProposalCreated(proposalCount - 1, msg.sender, description);
        return proposalCount - 1;
    }

    function vote(uint256 proposalId, bool support) public {
        require(proposalId < proposalCount, "Invalid proposal ID");
        require(block.timestamp < proposals[proposalId].deadline, "Voting period has ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        uint256 votes = staking.getVotes(msg.sender);
        if (support) {proposals[proposalId].votesFor += votes;} 
        else {proposals[proposalId].votesAgainst += votes;}
        hasVoted[proposalId][msg.sender] = true;
        emit Voted(msg.sender, proposalId, support, votes);
        }

    function executeProposal(uint256 proposalId) external {
        require(proposalId < proposalCount, "Invalid proposal ID");
        require(block.timestamp >= proposals[proposalId].deadline, "Voting period has not ended");
        require(!proposals[proposalId].executed, "Proposal already executed");
        require(proposals[proposalId].votesFor > proposals[proposalId].votesAgainst, "Proposal did not pass");
        address target = proposals[proposalId].target;
        uint256 value = proposals[proposalId].value;
        bytes memory payload = proposals[proposalId].calldataPayload;

        (bool success, ) = target.call{value: value}(payload);
        require(success, "Call execution failed");
        proposals[proposalId].executed = true;

        }

    
}