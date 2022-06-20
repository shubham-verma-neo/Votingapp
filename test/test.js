const VotingApp = artifacts.require("VotingApp");

contract("VotingApp", accounts => {
    it("Should deployed Voting Aapp properly.", async () => {
        let instance = await VotingApp.deployed();
        // console.log(instance.address);
        assert(instance.address !== '');
    })
    it("Time for voting should be 30seconds.", async () => {
        let instance = await VotingApp.deployed();
        let _startTime = await instance.startTime();
        let _endTime = await instance.endTime();
        // console.log(_startTime);
        // console.log(_endTime);
        assert((_endTime - _startTime) == "30");
    })
    

})
