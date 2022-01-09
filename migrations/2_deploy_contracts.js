const Diploma = artifacts.require("Diploma");
// const Course = artifacts.require("Course")

module.exports = function (deployer) {
    deployer.deploy(Diploma);
    // deployer.deploy(Course);
};