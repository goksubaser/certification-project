const fs = require('fs')

const Roles = artifacts.require("Roles");
const Faculty = artifacts.require("Faculty");
const Department = artifacts.require("Department");
const Diploma = artifacts.require("Diploma");
const Course = artifacts.require("Course");
const Request = artifacts.require("Request");

module.exports = async function (deployer) {
    await deployer.deploy(Roles);
    await deployer.deploy(Faculty, Roles.address);
    await deployer.deploy(Department, Roles.address, Faculty.address);
    await deployer.deploy(Request, Department.address, Roles.address);
    await deployer.deploy(Diploma, Roles.address, Request.address);
    await deployer.deploy(Course, Roles.address, Request.address);

    const roles = await Roles.deployed()
    await roles.init(Course.address, Department.address, Diploma.address, Faculty.address)

    let envPath = 'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\env.json'
    fs.writeFile(envPath, "{\"courseAddress\": \""+Course.address+"\",\"departmentAddress\": \""+Department.address+"\",\"diplomaAddress\": \""+Diploma.address+"\",\"facultyAddress\": \""+Faculty.address+"\",\"requestAddress\": \""+Request.address+"\",\"rolesAddress\": \""+Roles.address+"\"}", err => {
        if (err) {
            console.error(err)
            return
        }
    })

    //Testing Environment Setup
    console.log("Faculties are being created...")
    const faculty = await Faculty.deployed();
    await faculty.mint("Mühendislik Fakültesi", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    await faculty.mint("Fen Edebiyat Fakültesi", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")

    console.log("Departments are being created...")
    const department = await Department.deployed();
    await department.mint("Computer Engineering", "0x3950C702C288aE4f210952Fc75444134fA2D46aA", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    await department.mint("Philosophy", "0x9979e393F2aA3284C243d04C72F8ab738893c69C", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")
    await department.mint("Industrial Engineering", "0x203485A51cDf5c5Cac271790fD45002060f8b842", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    // await department.mint("Felsefe", "0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")

    // console.log("Instructors are being created...")
    // await department.setInstructors(1,["0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92"], "0x0000000000000000000000000000000000000000")
    // await department.setInstructors(2,["0x5ED0FD501C775603D388dbA83155DBF80E919f37"], "0x0000000000000000000000000000000000000000")
    // await department.setInstructors(3,["0xfA9F999f088B88808397B7312F9a4792B9dcB13D"], "0x0000000000000000000000000000000000000000")
    // await department.setInstructors(2,["0x5ED0FD501C775603D388dbA83155DBF80E919f37", "0xd032570cf5189A7793780c079544DFD2E9F379ae"], "0x0000000000000000000000000000000000000000")

    // console.log("Course Requests are being created...")
    // const request = await Request.deployed()
    // await request.createCourseRequest("0", "0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92", {from: "0x3950C702C288aE4f210952Fc75444134fA2D46aA"})//Instructor0 Department1
    // await request.createCourseRequest("1", "0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92", {from: "0x3950C702C288aE4f210952Fc75444134fA2D46aA"})//Instructor0 Department1
    // await request.createCourseRequest("2", "0x5ED0FD501C775603D388dbA83155DBF80E919f37", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Instructor1 Department2
    // await request.createCourseRequest("3", "0x5ED0FD501C775603D388dbA83155DBF80E919f37", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Instructor1 Department2
    // await request.createCourseRequest("4", "0xfA9F999f088B88808397B7312F9a4792B9dcB13D", {from: "0x203485A51cDf5c5Cac271790fD45002060f8b842"})//Instructor2 Department3
    // await request.createCourseRequest("5", "0xfA9F999f088B88808397B7312F9a4792B9dcB13D", {from: "0x203485A51cDf5c5Cac271790fD45002060f8b842"})//Instructor2 Department3
    // await request.createCourseRequest("6", "0xd032570cf5189A7793780c079544DFD2E9F379ae", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Instructor3 Department2
    // await request.createCourseRequest("7", "0xd032570cf5189A7793780c079544DFD2E9F379ae", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Instructor3 Department2

    console.log("Students are being created...")
    await department.setStudents(1,["0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92"], "0x0000000000000000000000000000000000000000")
    await department.setStudents(2,["0x5ED0FD501C775603D388dbA83155DBF80E919f37"], "0x0000000000000000000000000000000000000000")
    await department.setStudents(3,["0xfA9F999f088B88808397B7312F9a4792B9dcB13D"], "0x0000000000000000000000000000000000000000")
    await department.setStudents(2,["0x5ED0FD501C775603D388dbA83155DBF80E919f37", "0xd032570cf5189A7793780c079544DFD2E9F379ae"], "0x0000000000000000000000000000000000000000")

    console.log("Diploma Requests are being created...")
    const request = await Request.deployed()
    await request.createDiplomaRequest("0", "0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92", {from: "0x3950C702C288aE4f210952Fc75444134fA2D46aA"})//Student0 Department1
    await request.createDiplomaRequest("1", "0x5ED0FD501C775603D388dbA83155DBF80E919f37", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Student0 Department2
    await request.createDiplomaRequest("2", "0xfA9F999f088B88808397B7312F9a4792B9dcB13D", {from: "0x203485A51cDf5c5Cac271790fD45002060f8b842"})//Student0 Department3
    await request.createDiplomaRequest("3", "0xd032570cf5189A7793780c079544DFD2E9F379ae", {from: "0x9979e393F2aA3284C243d04C72F8ab738893c69C"})//Student0 Department2


    //Copy Abi's to frontend
    let abiSourcePaths = [
        './build/contracts/Course.json',
        './build/contracts/Department.json',
        './build/contracts/Diploma.json',
        './build/contracts/Faculty.json',
        './build/contracts/Request.json',
        './build/contracts/Roles.json',
    ]
    let abiDestinationPaths = [
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Course.json',
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Department.json',
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Diploma.json',
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Faculty.json',
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Request.json',
        'C:\\Users\\asus\\Desktop\\Dersler\\CMPE492\\certification-project-react-github\\src\\abis\\Roles.json',
    ]
    for(var i = 0; i< abiSourcePaths.length; i++){
        fs.copyFile(abiSourcePaths[i], abiDestinationPaths[i], err => {
            if (err) {
                console.error(err)
                return
            }
        })
    }

};
