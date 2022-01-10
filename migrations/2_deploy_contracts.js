const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");
const Roles = artifacts.require("Roles");


module.exports = function (deployer) {
    deployer.deploy(Diploma);
    deployer.deploy(Course);
    deployer.deploy(Roles);
};