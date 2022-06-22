//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Strings.sol";

contract VotingApp {
    using String for uint256;

    //Owner of the contract
    address public owner;

    //Voting starting time
    uint256 public startTime;

    //Voting end time
    uint256 public endTime;

    //Numbers of voters voted for Trump
    uint256 voteForTrump;

    //Numbers of voters voted for Biden
    uint256 voteForBiden;

    //To track voter allready voted or not
    mapping(address => bool) alreadyVoted;

    /**
     * @dev Sets the value for {Voting Start Time} and {Voting End Time}
     *
     * Value will beconsider as seconds.
     *
     * Requierments
     * @param _startTime - Voting will start after '_startTime' seconds.
     * @param _endTime - Voiting will be end at '_endTime' seconds
     *
     */
    constructor(uint256 _startTime, uint256 _endTime) {
        require(
            _endTime > _startTime,
            "End time should be greater than Start time."
        );
        owner = msg.sender;
        startTime = block.timestamp + _startTime;
        endTime = startTime + _endTime;
    }

    /**
     * @dev Emitted when voters successfully voted for 'Trump' or 'Biden'.
     */
    event VotedSuccessfully(address voter, string votedFor);

    /**
     * @dev Sets the 'Voter' vote for 'Trump'.
     *
     * Emits an {VotedSuccessfully} event.
     *
     * Requirements:
     *
     * - `block. timestamp` cannot be the less the Voting Start Time.
     * - `block.timestamp` cannot be the greater then Voting End Time.
     * - `voter` not voted before.
     */
    function VoteForTrump() public {
        require(block.timestamp >= startTime, "Voting not stared yet.");
        require(block.timestamp <= endTime, "Voting time ended.");
        require(alreadyVoted[msg.sender] == false, "You already Voted.");
        alreadyVoted[msg.sender] = true;
        voteForTrump++;
        emit VotedSuccessfully(msg.sender, "You Successfully Voted for Trump.");
    }

    /**
     * @dev Sets the 'Voter' vote for 'Biden'.
     *
     * Emits an {VotedSuccessfully} event.
     *
     * Requirements:
     *
     * - `block. timestamp` cannot be the less the Voting Start Time.
     * - `block.timestamp` cannot be the greater then Voting End Time.
     * - `voter` not voted before.
     */
    function VoteForBiden() public {
        require(block.timestamp >= startTime, "Voting not stared yet.");
        require(block.timestamp <= endTime, "Voting time ended.");
        require(alreadyVoted[msg.sender] == false, "You already Voted.");
        alreadyVoted[msg.sender] = true;
        voteForBiden++;
        emit VotedSuccessfully(msg.sender, "You Successfully Voted for Biden.");
    }

    /**
     * @dev check total numbers of votes
     *
     * @return TotalVotes
     */
    function totalVote() public view returns (uint256 TotalVotes) {
        return (voteForTrump + voteForBiden);
    }

    /**
     * @dev show the winner of elections
     *
     * @return Results - winner by how many votes
     */
    function showMeWinner() public view returns (string memory Results) {
        // require(
        //     block.timestamp >= endTime,
        //     "Winner will be announce after Voting Ends"
        // );
        if (voteForTrump == voteForBiden)
            return ("Election tie between Trump and Biden.");
        else if (voteForTrump > voteForBiden)
            return
                string(
                    abi.encodePacked(
                        "Trump is the winner of elections by ",
                        (voteForTrump - voteForBiden).toString(),
                        " votes."
                    )
                );
        else
            return
                string(
                    abi.encodePacked(
                        "Biden is the winner of elections by ",
                        (voteForBiden - voteForTrump).toString(),
                        " votes."
                    )
                );
    }
}
