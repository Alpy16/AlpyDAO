AlpyDAO
AlpyDAO is a minimal, functional on-chain DAO integrated with staking and ERC20-based rewards. The system is built for clarity, modularity, and extensibility. The DAO controls critical staking parameters (like reward rate) via governance proposals. Staking is the sole source of voting power.

What’s Included
AlpyToken: A standard ERC20 token used both for staking and rewards.

AlpyStaking: A staking contract that tracks deposits, distributes rewards over time, and determines voting power.

AlpyDAO: A governance contract that lets stakers create, vote on, and execute proposals.

DeployAll.s.sol: A Foundry script that deploys the full stack (Token, Staking, DAO).

SubmitProposal.s.sol: A sample script that creates a proposal to update the staking reward rate.

Broadcast-compatible Anvil setup for local testing.

Why This Exists
This is a real-world governance architecture stripped down to its core components. The goal is to make on-chain governance tangible: staking-based voting, encoded proposals, decentralized execution, and dynamic updates to protocol parameters without needing contract redeployments.

It's structured like a protocol with token economics but remains developer-focused and readable.

System Overview
Staking (AlpyStaking):
Users stake AlpyToken to gain voting power and earn AlpyToken rewards over time. The reward rate is controlled by the DAO.

Governance (AlpyDAO):
Users with a non-zero stake can create proposals to call arbitrary functions on whitelisted contracts. Proposals are voted on using current stake amounts. A proposal passes if votesFor > votesAgainst at the deadline.

Token (AlpyToken):
Basic ERC20. Minted once to the deployer. Used for both staking and as the reward asset.

Deployment (Anvil + Foundry)
Step 1: Launch Anvil
anvil

Step 2: Deploy All Contracts
forge script script/DeployAll.s.sol --broadcast --fork-url http://127.0.0.1:8545

This deploys:

AlpyToken

AlpyStaking

AlpyDAO

It also sets DAO address inside staking and stakes 1000 tokens from deployer

Step 3: Submit Proposal
forge script script/SubmitProposal.s.sol --broadcast --fork-url http://127.0.0.1:8545

This creates a proposal inside AlpyDAO to update the reward rate on the staking contract.

Step 4 (Manual): Vote & Execute
Once the voting period (1 day) passes, run:

cast send <dao_address> "vote(uint256,bool)" <proposalId> true --rpc-url http://127.0.0.1:8545 --private-key <key>
cast send <dao_address> "executeProposal(uint256)" <proposalId> --rpc-url http://127.0.0.1:8545 --private-key <key>

Or implement those in a script if preferred.

Project Structure
src/
├── AlpyDAO.sol
├── AlpyStaking.sol
├── AlpyToken.sol

script/
├── DeployAll.s.sol
├── SubmitProposal.s.sol

test/
└── AlpyDAOTest.t.sol (optional; excluded from GitHub if not finished)

Notes
No vote delegation is implemented—only direct staking power counts.

Proposal calldata is raw and can include any encoded function call.

setRewardRate() is restricted to only callable via DAO (msg.sender == address(this)).

All contracts are compatible with local testing and simulation (Anvil, Foundry).

Built With
Solidity ^0.8.19

Foundry (Forge + Anvil)

OpenZeppelin Contracts