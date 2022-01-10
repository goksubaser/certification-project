const Course = artifacts.require('./Course.sol')
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract("Course", (accounts) => {
    let contract

    before(async() => {
        contract = await Course.deployed()
    })

    // describe("deployment", async() => {
    //     it("deploys successfully", async() =>{
    //         const address = contract.address
    //         // console.log(address)
    //         assert.notEqual(address, 0x0)
    //         assert.notEqual(address, '')
    //         assert.notEqual(address, null)
    //         assert.notEqual(address, undefined)
    //     })
    //     it('has a name', async () =>{
    //         const name = await contract.name()
    //         assert.equal(name, 'Course')
    //     })
    //     it('has a symbol', async () =>{
    //         const symbol = await contract.symbol()
    //         assert.equal(symbol, 'CRS')
    //     })
    // })
    //
    // describe('minting', async () => { //"abc" Course for Instructor 0
    //     it('creates first token', async () =>{
    //         const result = await contract.mint('abc', accounts[0])
    //         //FAILURE: cannot mint same Course Link twice
    //         await contract.mint('abc', accounts[1]).should.be.rejected;
    //
    //         //SUCCESS
    //         const event = result.logs[0].args
    //         assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
    //         assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
    //         assert.equal(event.to, accounts[0], 'to is correct')
    //         const courseLinks = await contract.getCourseLinks()
    //         assert.deepEqual(courseLinks, ["abc"], "courseLinks are correct")
    //     })
    //
    //     it('creates second token', async () =>{//"abcd" Course for Instructor 1
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
    //         const courseLinks = await contract.getCourseLinks()
    //         assert.deepEqual(courseLinks, ["abc", "abcd"], "courseLinks are correct")
    //     })
    //     it('creates more token', async () =>{
    //         //FAILURES
    //         await contract.mint('abc', accounts[0]).should.be.rejected;
    //         await contract.mint('abcd', accounts[1]).should.be.rejected;
    //         //SUCCESS
    //         await contract.mint('abcde', accounts[0]).should.not.be.rejected;//"abcde" for Instructor 0
    //         await contract.mint('abcdef', accounts[0]).should.not.be.rejected;//"abcdef" for Instructor 0
    //         await contract.mint('abcdefg', accounts[1]).should.not.be.rejected;//"abcdefg" for Instructor 1
    //         await contract.mint('abcdefgh', accounts[1]).should.not.be.rejected;//"abcdefgh" for Instructor 1
    //
    //         const courseLinks = await contract.getCourseLinks()
    //         assert.deepEqual(courseLinks, ["abc", "abcd", "abcde", 'abcdef', 'abcdefg', 'abcdefgh'], "courseLinks are correct")
    //         const givesCoursesCorrect = ["1,3,4","2,5,6"];
    //         for(let i = 0; i<2; i++){
    //             const givesCourses = await contract.getGivesCourses(accounts[i]);
    //             assert.deepEqual(givesCourses.toString(), givesCoursesCorrect[i], "givesCourses are correct")
    //         }
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
        it("Grants Department Role", async() =>{
            await contract.grantDepartmentRole(accounts[3], {from: accounts[0]}).should.be.rejected;
            await contract.grantDepartmentRole(accounts[3], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Grants Instructor Role", async() =>{
            await contract.grantInstructorRole(accounts[4], {from: accounts[0]}).should.be.rejected;//not Rector
            await contract.grantInstructorRole(accounts[4], {from: accounts[1]}).should.not.be.rejected;
        })
        it("Mints Course Token", async() =>{
            await contract.mint("aaa", accounts[0], {from: accounts[1]}).should.be.rejected;//not Instructor
            await contract.mint("aaa", accounts[4], {from: accounts[1]}).should.not.be.rejected;
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