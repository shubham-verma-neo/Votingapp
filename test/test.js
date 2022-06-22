const VotingApp = artifacts.require("VotingApp");


contract("VotingApp", accounts => {
    let instance;
    before(async () => {
        console.log("Before");
        instance = await VotingApp.deployed();
        console.log(instance.address);
    });

    it("Should deployed Voting Aapp properly.", async () => {
        assert(instance.address !== '');
    })

    it("Voting period should be 30seconds.", async () => {
        let _startTime = await instance.startTime();
        let _endTime = await instance.endTime();
        // console.log(_startTime);
        // console.log(_endTime);
        assert((_endTime - _startTime) == "30");
    })

    it("Election Tie between Trump & Biden", async () => {
        let _winner = await instance.showMeWinner();
        // console.log(_winner , "Biden");
            assert(_winner == "Election tie between Trump and Biden.");
    })

    // it("Voting should not start yet.", async () => {
    //     // let instance = await VotingApp.deployed();
    //     let notStarted= await instance.VoteForTrump({ from: accounts[0] }).then().catch(reason => { });
    //     let winner= await instance.showMeWinner({ from: accounts[0] }).then().catch(reason => { });
    //     console.log(winner ,  "winner");
    //     console.log(notStarted ,  "notStarted");
    //     // assert(notStarted == "Voting not stared yet.");
    // })

    it("Total votes should be 9.", async () => {
        // console.log('Deployed', new Date().toISOString());
        let timesTrump = 3;
        let timesBiden = 6;
        let _vote = await vote(12, instance, accounts, timesTrump, timesBiden);
        if (await _vote) {
            let tVotes = await instance.totalVote();
            // console.log(tVotes);
            assert(tVotes == (timesTrump + timesBiden));
        }
    })


    it("Biden should be the winner of elections.", async () => {
        let _winner = await instance.showMeWinner();
        // console.log(_winner , "Biden");
            assert(_winner == "Biden is the winner of elections by 3 votes.");
    })
})


async function vote(_secs, _instance, _accounts, _timesTrump, _timesBiden) {
    return new Promise(async (res, rej) => {
        let _delay = setTimeout(async () => {
            // console.log(_timesTrump);
            // console.log(_timesBiden);
            // console.log('Start', new Date().toISOString());
            var i = 0;
            for (; i < _timesTrump; i++) {
                // console.log(i);
                await _instance.VoteForTrump({ from: _accounts[i] });
            }
            _timesBiden = i + _timesBiden - 1;
            for (; i < _timesBiden; i++) {
                // console.log(i);
                await _instance.VoteForBiden({ from: _accounts[i] });
            }
            // console.log(_timesBiden);
            res(await _instance.VoteForBiden({ from: _accounts[_timesBiden] }));
            // console.log('End', new Date().toISOString());
        }, _secs * 1000)
    })
}

async function delay(_secs, _instance, _accounts) {
    return new Promise(async (res, rej) => {
        let _delay = setTimeout(async () => {
            console.log('Start', new Date().toISOString());
            let winner = await _instance.showMeWinner({ from: _accounts[0] });
            res(await winner);
            console.log('End', new Date().toISOString());
        }, _secs * 1000)
    })
}