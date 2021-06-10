// SPDX-License-Identifier: MIT
pragma solidity >0.5.12;
/**
One of the largest industries in the world is the Insurance Market.
With the future in the hands of IoT and Blockchain Technology, the insurance market may als utilize these technologies to their full potential.
Cars are starting to become highly integrated with IoT devices to moniter system health and other parameters. By utlizing this we, may also 
use this data coming from these IoT devices to keep a track of data which aids in pricing insurance for vehicles, removing any data 
manipulations and middle-person free transactions.

This contract is a simple implementiation for CarInsurances. It holds data about the cars such as name, owner, distance/miles travelled, 
duration of insurance, number of times insurance has been claimed. This data is assumed to be automatically retreived with the help of
the IoT devices installed in the cars. The miles for example can be emitted by the car every month and captured by the contract. This data is 
then saved onto the blockchain making it immutable. The insurance company can access it at any time and quote a fair price. Transactions too 
happen instantlty, without any intermediaries if all the conditions are met.
This is a most likely future for insurance.
*/
contract CarInsurance {

    //Structure for car details
    struct Car {
        string name;        //Brand name
        address owner;      //car owner address
        uint miles;         //distance covered
        uint validity;      //date till valid
        uint claims;        //number of times insurance has been claimed
    }
    
    mapping (uint => Car) public cars;      //mapping containing list of cars
    
    uint public carCount;                   //number of cars in list; helps to navigate list
    address payable public insurer;         //address of insurer and owner of this contract

    //Events
    event NewCar(string alert);
    event Miles(string alert, uint256 amount);
    event Claim(string alert);
    event Renewed(string alert);
    
    constructor() payable {
        insurer = payable(address(this));   //insurer assigned
        insurer.transfer(msg.value);        //initliazed with a balance of 5000
    }

    //function to add a car and transfer money to buy insurance
    function addCar(string memory _name) public payable {
        require(msg.value >= 100, "Enter 100 wei value as Payment");    //Ensures sufficient money is sent
        
        //Update count, store car details as struct and transfer money
        carCount++;
        cars[carCount] = Car(_name, msg.sender, 0, (block.timestamp + 52 weeks), 0);
        insurer.transfer(msg.value);
        
        //New Car Event emitted 
        emit NewCar("New Car added");
    }

    //Update miles covered for a particular
    //For simplicity, index in list has been used
    function updateMiles(uint index, uint _miles) public {
        require(index <= carCount);

        cars[index].miles += _miles;
        
        emit Miles("Miles Updated", _miles);
    }

    //Claim insurance money
    function claim(uint index) public payable returns (bool){
        require(index <= carCount);                                                              //verify valid index
        require(block.timestamp < cars[index].validity, "Insurance Expired. Cannot Claim.");    //Checks current time with expiration time

        //Update claims and transfer money
        cars[index].claims++;
        payable(msg.sender).transfer(500);
        
        //Claim event emitted
        emit Claim("Insurance Claimed");
        return true;
    }

    //Renew insurance 
    function renew(uint index) public payable returns (bool){
        require(index <= carCount);                                                  //verify valid index
        require(block.timestamp > cars[index].validity, "Insurance Still Valid");   //Verify if insurance has expired or not
        
        //Transfer money
        insurer.transfer(msg.value);
        
        //Update validity by 1 year
        cars[index].validity += 52 weeks;
        
        //Renewed event emitted
        emit Renewed("Insurance Renewed");
        return true;
    }

    //Get contract Balance
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    //Functions to receive payments;
    receive() external payable{}
    fallback() external payable{}
}