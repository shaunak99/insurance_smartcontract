const CarInsurance = artifacts.require("./CarInsurance.sol");

contract("CarInsurance", function(accounts) {

    it("initializes with insurer balance and zero cars", async () => {
        const instance = await CarInsurance.deployed();
        const count = await instance.carCount();
        const balance = await instance.getContractBalance();

        assert.equal(count, 0);
        assert.equal(balance, 5000);
    });

    it("adds two cars to chain and receive payment", async () => {
        const instance = await CarInsurance.deployed();
        
        //Adding 2 cars with names and payment of 100
        await instance.addCar("Tesla",{from: accounts[0], value: "100"});
        await instance.addCar("Lamborghini",{from: accounts[0], value: "100"});

        //Get carCount and balance of contract
        const count =  await instance.carCount();
        const balance = await instance.getContractBalance();
        
        assert.equal(count, 2);
        assert.equal(balance, 5200);
    });

    it("updates miles travelled", async () => {
        const instance = await CarInsurance.deployed();
        
        //Update the miles travelled of each car
        await instance.updateMiles(1, 42);
        await instance.updateMiles(2, 59);

        const car1 =  await instance.cars(1);
        const car2 = await instance.cars(2);

        //Get miles travelled by each
        const miles1 =  await car1.miles;
        const miles2 = await car2.miles;
        
        assert.equal(miles1, 42);
        assert.equal(miles2, 59);
    });

    it("claims money if insurace is valid", async () => {
        const instance = await CarInsurance.deployed();

        //Check if difference before and after claim is equal to money transfered for claim
        const balance = await instance.getContractBalance();
        await instance.claim(1);
        const newBalance = await instance.getContractBalance();

        assert.equal(balance - newBalance, 500);
    });

    it("renew fails if insurance still valid", async () => {
        const instance = await CarInsurance.deployed();
        
        //Renew should throw error since validity should be there for another year
        var val;
        try {
            val = await instance.renew(2);
        } catch(err){
            val = false;
        }
        assert.equal(val,false);
    });
});