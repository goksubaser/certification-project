// const Course = artifacts.require('./Course.sol')
// require('chai')
//     .use(require('chai-as-promised'))
//     .should()
//
// contract("Course", (accounts) => {
//     let contract
//
//     before(async() => {
//         contract = await Course.deployed()
//     })
//
//     describe("deployment", async() => {
//         it("deploys successfully", async() =>{
//             const address = contract.address
//             console.log(address)
//             assert.notEqual(address, 0x0)
//             assert.notEqual(address, '')
//             assert.notEqual(address, null)
//             assert.notEqual(address, undefined)
//         })
//         it('has a name', async () =>{
//             const name = await contract.name()
//             assert.equal(name, 'Course')
//         })
//         it('has a symbol', async () =>{
//             const symbol = await contract.symbol()
//             assert.equal(symbol, 'CRS')
//         })
//     })
//
// })