const Roles = artifacts.require("Roles");
const Faculty = artifacts.require("Faculty");
const Department = artifacts.require("Department");
const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");

module.exports = function (deployer) {
    deployer.deploy(Roles);
    deployer.deploy(Department);
    deployer.deploy(Faculty);
    deployer.deploy(Diploma);
    deployer.deploy(Course);
};