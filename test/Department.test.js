const Department = artifacts.require('./Department.sol')
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract("Department", (accounts) => {
    let contract

    before(async () => {
        contract = await Department.deployed()
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
    //         assert.equal(name, 'Department')
    //     })
    //     it('has a symbol', async () =>{
    //         const symbol = await contract.symbol()
    //         assert.equal(symbol, 'DEP')
    //     })
    // })

    describe("Role functions", async() => {
        it("Grants Rector Role", async() =>{
            await contract.grantRectorRole(accounts[1]).should.not.be.rejected;
        })
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[2], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantDepartmentRole(accounts[2], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[3], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[4], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[5], {from: accounts[1]}).should.not.be.rejected;
        })


    })
    describe('minting', async () => {
        it('creates first token', async () => {
            const result = await contract.mint('abc', accounts[2], {from: accounts[1]})
            //FAILURE: cannot mint same Department Link twice
            await contract.mint('abc', accounts[2]).should.be.rejected;
            //FAILURE: cannot mint to un-Department
            await contract.mint('abcd', accounts[1]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[2], 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "abc", "departmentName is correct")
            await contract.getDepartmentID(departmentName).should.not.be.rejected;
        })

        it('creates second token', async () => {
            const result = await contract.mint('abcd', accounts[3], {from: accounts[1]})
            //FAILURES
            await contract.mint('abc', accounts[3]).should.be.rejected;
            await contract.mint('abcd', accounts[3]).should.be.rejected;
            await contract.mint('abcd', accounts[2]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 2, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[3], 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "abcd", "departmentName is correct")
        })
        it('burns first token', async () => {
            const result = await contract.burn("abc", {from: accounts[1]})
            //FAILURES
            await contract.burn("abc", {from: accounts[1]}).should.be.rejected;//Cannot burn again
            await contract.burn("abcde", {from: accounts[1]}).should.be.rejected;//Cannot burn has not minted one
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
            assert.equal(event.from, undefined, 'from is correct')
            assert.equal(event.to, undefined, 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "", "departmentName is deleted")
        })
        it('mints former first token again to another account', async () => {
            const result = await contract.mint('abc', accounts[4], {from: accounts[1]})
            //FAILURE: cannot mint same Department Link twice
            await contract.mint('abc', accounts[4]).should.be.rejected;
            //FAILURE: cannot mint to un-Department
            await contract.mint('abc', accounts[1]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 3, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[4], 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "abc", "departmentName is correct")
        })
        it('burns first token again newly 3rd token', async () => {
            const result = await contract.burn("abc", {from: accounts[1]})
            //FAILURES
            await contract.burn("abc", {from: accounts[1]}).should.be.rejected;//Cannot burn again
            await contract.burn("abcde", {from: accounts[1]}).should.be.rejected;//Cannot burn has not minted one
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 3, 'id is correct')
            assert.equal(event.from, undefined, 'from is correct')
            assert.equal(event.to, undefined, 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "", "departmentName is deleted")
        })
        it('mints former 3rd token again to same account', async () => {
            const result = await contract.mint('abc', accounts[4], {from: accounts[1]})
            //FAILURE: cannot mint same Department Link twice
            await contract.mint('abc', accounts[4]).should.be.rejected;
            //FAILURE: cannot mint to un-Department
            await contract.mint('abc', accounts[1]).should.be.rejected;
            //SUCCESS
            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(), 4, 'id is correct')
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
            assert.equal(event.to, accounts[4], 'to is correct')
            const departmentName = await contract.getDepartmentName(event.tokenId.toNumber())
            assert.deepEqual(departmentName, "abc", "departmentName is correct")
        })

        // it('trying transfer first token', async () => {//Transfer Prohibition Test
        //     let owner1 = await contract.ownerOf(1);
        //     let owner2 = await contract.ownerOf(2);
        //     assert.equal(owner1, accounts[2])
        //     assert.equal(owner2, accounts[3])
        //     await contract.transferFrom(accounts[2], accounts[3], 1).should.be.rejected;
        //     owner1 = await contract.ownerOf(1);
        //     assert.equal(owner1, accounts[2])
        //     assert.notEqual(owner1, accounts[3])
        // })
    })
})