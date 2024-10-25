const MyToken = artifacts.require("MyToken");
const Staking = artifacts.require("Staking");
const Marketplace = artifacts.require("Marketplace");
const Voting = artifacts.require("Voting");

module.exports = async function (deployer) {
    await deployer.deploy(MyToken, 1000000 * (10 ** 18));
    const tokenInstance = await MyToken.deployed();

    await deployer.deploy(Staking, tokenInstance.address);
    await deployer.deploy(Marketplace, tokenInstance.address);
    await deployer.deploy(Voting, tokenInstance.address);
};