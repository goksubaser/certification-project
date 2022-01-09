const Diploma = artifacts.require('./Diploma.sol')
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract("Diploma", (accounts) => {
    let contract

    before(async() => {
        contract = await Diploma.deployed()
    })

    describe("deployment", async() => {
        it("deploys successfully", async() =>{
            const address = contract.address
            console.log(address)
            assert.notEqual(address, 0x0)
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
        })
        it('has a name', async () =>{
            const name = await contract.name()
            assert.equal(name, 'Diploma')
        })
        it('has a symbol', async () =>{
            const symbol = await contract.symbol()
            assert.equal(symbol, 'DPLM')
        })
    })

    describe('minting', async () => {
        it('creates first token', async () =>{
            const result = await contract.mint('abc', accounts[0])
            //FAILURE: cannot mint same Diploma Link twice
            await contract.mint('abc', accounts[1]).should.be.rejected;
            //FAILURE: cannot mint to same graduate twice
            await contract.mint('abcd', accounts[0]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[0], 'to is correct')
            const diplomaLinks = await contract.getDiplomaLinks()
            assert.deepEqual(diplomaLinks, ["abc"], "diplomaLinks are correct")
        })

        it('creates second token', async () =>{
            const result = await contract.mint('abcd', accounts[1])
            //FAILURES
            await contract.mint('abc', accounts[0]).should.be.rejected;
            await contract.mint('abcd', accounts[1]).should.be.rejected;
            await contract.mint('abcd', accounts[2]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 2, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[1], 'to is correct')
            const diplomaLinks = await contract.getDiplomaLinks()
            assert.deepEqual(diplomaLinks, ["abc", "abcd"], "diplomaLinks are correct")
        })
    })

})