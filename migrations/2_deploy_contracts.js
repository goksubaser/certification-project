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
    await deployer.deploy(Diploma, Roles.address);
    await deployer.deploy(Department, Roles.address, Faculty.address);
    await deployer.deploy(Request, Department.address, Roles.address)
    await deployer.deploy(Course, Roles.address);

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
    const faculty = await Faculty.deployed();
    await faculty.mint("Mühendislik", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    await faculty.mint("Fen Edebiyat", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")
    const department = await Department.deployed();
    await department.mint("Cmpe", "0x3950C702C288aE4f210952Fc75444134fA2D46aA", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    await department.mint("Çeviri", "0x9979e393F2aA3284C243d04C72F8ab738893c69C", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")
    await department.mint("Endüstri", "0x203485A51cDf5c5Cac271790fD45002060f8b842", "0xCeB49eCc57F96bbA3bB39Be41dd54dE57D01318d")
    // await department.mint("Felsefe", "0x9aB9157db62e8C4eE0Bd0924B0A3bB7868070a92", "0x5CA7f50D4d36c29F2C4f44fb6682EC668d036E0e")

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
