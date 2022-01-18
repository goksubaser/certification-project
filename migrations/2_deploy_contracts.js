const Roles = artifacts.require("Roles");
const Faculty = artifacts.require("Faculty");
const Department = artifacts.require("Department");
const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");
const Request = artifacts.require("Request");

module.exports = function (deployer) {
    deployer.deploy(Roles);
    deployer.deploy(Department).then(() => {deployer.deploy(Request, Department.address)});
    deployer.deploy(Faculty);
    deployer.deploy(Diploma);
    deployer.deploy(Course).then(() => {
        console.log("const courseAddress = \""+Course.address+"\";")
        console.log("const departmentAddress = \""+Department.address+"\";")
        console.log("const diplomaAddress = \""+Diploma.address+"\";")
        console.log("const facultyAddress = \""+Faculty.address+"\";")
        console.log("const requestAddress = \""+Request.address+"\";")
    });


};
