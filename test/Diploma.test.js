const Diploma = artifacts.require('./Diploma.sol')
artifacts.require('./Roles.sol')
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract("Diploma", (accounts) => {
    let contract

    before(async() => {
        contract = await Diploma.deployed()
    })

    // describe("deployment", async() => {
    //     it("deploys successfully", async() =>{
    //         const address = contract.address
    //         assert.notEqual(address, 0x0)
    //         assert.notEqual(address, '')
    //         assert.notEqual(address, null)
    //         assert.notEqual(address, undefined)
    //     })
    //     it('has a name', async () =>{
    //         const name = await contract.name()
    //         assert.equal(name, 'Diploma')
    //     })
    //     it('has a symbol', async () =>{
    //         const symbol = await contract.symbol()
    //         assert.equal(symbol, 'DPLM')
    //     })
    // })
    //
    // describe('minting', async () => {
    //     it('creates first token', async () =>{
    //         const result = await contract.mint('abc', accounts[0])
    //         //FAILURE: cannot mint same Diploma Link twice
    //         await contract.mint('abc', accounts[1]).should.be.rejected;
    //         //FAILURE: cannot mint to same graduate twice
    //         await contract.mint('abcd', accounts[0]).should.be.rejected;
    //         //SUCCESS
    //         const event = result.logs[0].args
    //         assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
    //         assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
    //         assert.equal(event.to, accounts[0], 'to is correct')
    //         const diplomaLinks = await contract.getDiplomaLinks()
    //         assert.deepEqual(diplomaLinks, ["abc"], "diplomaLinks are correct")
    //     })
    //
    //     it('creates second token', async () =>{
    //         const result = await contract.mint('abcd', accounts[1])
    //         //FAILURES
    //         await contract.mint('abc', accounts[0]).should.be.rejected;
    //         await contract.mint('abcd', accounts[1]).should.be.rejected;
    //         await contract.mint('abcd', accounts[2]).should.be.rejected;
    //         //SUCCESS
    //         const event = result.logs[0].args
    //         assert.equal(event.tokenId.toNumber(), 2, 'id is correct')
    //         assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
    //         assert.equal(event.to, accounts[1], 'to is correct')
    //         const diplomaLinks = await contract.getDiplomaLinks()
    //         assert.deepEqual(diplomaLinks, ["abc", "abcd"], "diplomaLinks are correct")
    //     })
    //
    //     it('trying transfer first token', async () =>{//Transfer Prohibition Test
    //         let owner1 = await contract.ownerOf(1);
    //         let owner2 = await contract.ownerOf(2);
    //         assert.equal(owner1, accounts[0])
    //         assert.equal(owner2, accounts[1])
    //         await contract.transferFrom(accounts[0], accounts[2], 1).should.be.rejected;
    //         owner1 = await contract.ownerOf(1);
    //         assert.equal(owner1, accounts[0])
    //         assert.notEqual(owner1, accounts[2])
    //     })
    // })

    describe("Role functions", async() => {
        it("Grants Rector Role", async() =>{
            await contract.mint('abc', accounts[1],{from: accounts[1]}).should.be.rejected;
            await contract.grantRectorRole(accounts[1]).should.not.be.rejected;
            await contract.mint('abc', accounts[0],{from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Faculty Role", async() =>{
            await contract.grantFacultyRole(accounts[2], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantFacultyRole(accounts[2], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[3], {from: accounts[0]}).should.be.rejected;
            await contract.grantDepartmentRole(accounts[3], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Instructor Role", async() =>{
            await contract.grantInstructorRole(accounts[4], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantInstructorRole(accounts[4], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Student Role", async() =>{
            await contract.grantStudentRole(accounts[5], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantStudentRole(accounts[5], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Graduted Role", async() =>{
            await contract.grantGraduatedRole(accounts[5], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantGraduatedRole(accounts[6], {from: accounts[1]}).should.be.rejected;//not Student
            await contract.grantGraduatedRole(accounts[5], {from: accounts[1]}).should.not.be.rejected;
        })
    })

})