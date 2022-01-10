const Faculty = artifacts.require('./Faculty.sol')
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract("Faculty", (accounts) => {
    let contract

    before(async () => {
        contract = await Faculty.deployed()
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
    //         assert.equal(name, 'Faculty')
    //     })
    //     it('has a symbol', async () =>{
    //         const symbol = await contract.symbol()
    //         assert.equal(symbol, 'FAC')
    //     })
    // })

    describe("Role functions", async() => {
        it("Grants Rector Role", async() =>{
            await contract.grantRectorRole(accounts[1]).should.not.be.rejected;
        })
        it("Grants Faculty Role", async() =>{
            await contract.grantFacultyRole(accounts[2], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantFacultyRole(accounts[2], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Mints Faculty Token", async() =>{
            await contract.mint("aaa", accounts[0], {from: accounts[1]}).should.be.rejected;//not Faculty
            await contract.mint("aaa", accounts[2], {from: accounts[1]}).should.not.be.rejected;
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


        it("Revokes Faculty Role", async() =>{
            await contract.revokeFacultyRole(accounts[2], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.revokeFacultyRole(accounts[2], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Revokes Department Role", async() =>{
            await contract.revokeDepartmentRole(accounts[3], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.revokeDepartmentRole(accounts[3], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Revokes Instructor Role", async() =>{
            await contract.revokeInstructorRole(accounts[4], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.revokeInstructorRole(accounts[4], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Revokes Student Role", async() =>{
            await contract.revokeStudentRole(accounts[5], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.revokeStudentRole(accounts[5], {from: accounts[1]}).should.not.be.rejected;
        })
    })
})