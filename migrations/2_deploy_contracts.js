const Roles = artifacts.require("Roles");
const Faculty = artifacts.require("Faculty");
const Department = artifacts.require("Department");
const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");
const Request = artifacts.require("Request");

module.exports = async function (deployer) {
    await deployer.deploy(Roles);
    await deployer.deploy(Faculty, Roles.address);
    await deployer.deploy(Diploma, Roles.address);
    await deployer.deploy(Department, Roles.address);
    await deployer.deploy(Request, Department.address)
    await deployer.deploy(Course, Roles.address);

    const roles = await Roles.deployed()
    await roles.init(Course.address, Department.address, Diploma.address, Faculty.address)

    console.log("\"courseAddress\": \""+Course.address+"\",")
    console.log("\"departmentAddress\": \""+Department.address+"\",")
    console.log("\"diplomaAddress\": \""+Diploma.address+"\",")
    console.log("\"facultyAddress\": \""+Faculty.address+"\",")
    console.log("\"requestAddress\": \""+Request.address+"\",")
    console.log("\"rolesAddress\": \""+Roles.address+"\"")
};
