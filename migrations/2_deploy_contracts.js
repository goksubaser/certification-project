const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");
const Roles = artifacts.require("Roles");
const Faculty = artifacts.require("Faculty");
const Department = artifacts.require("Department");


module.exports = function (deployer) {
    deployer.deploy(Roles);
    deployer.deploy(Course);
    deployer.deploy(Department);
    deployer.deploy(Diploma);
    deployer.deploy(Faculty);
};