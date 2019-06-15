/*
agent works between client and owner.each time a client needs a capability, agent sends client's reques to 
owner, and gives data back to client.
*/
pragma solidity 0.5.8;
pragma experimental ABIEncoderV2;
import "./Owner.sol";
import "./Client.sol";

contract Agent{
    //Variables Definition:
    //client_information maps address of a client to it's created Client contract's address.
    mapping(address=>address) client_information;
    //owner_information maps owner's address to it's crested Owner contract's address.
    mapping(address=>address) owner_information;
    
    //Function Definition:
    
    function createClient(string memory name,string memory ip) public{
        Client new_client = new Client(name,ip);
        client_information[msg.sender] = address(new_client);
        emit printContractAddress(address(new_client));
        getCient(msg.sender);
    }
    
    function createOwner(string memory name, string memory ip) public{
        Owner new_owner = new Owner(name,ip);
        owner_information[msg.sender] = address(new_owner);
        emit printContractAddress(address(new_owner));
        getOwner(msg.sender);
    }
    
    function getOwner(address _addr) public view returns(address){
        return owner_information[_addr];
    }
    
    function getCient(address _addr) public view returns(address){
        return client_information[_addr];
    }
    
    //Event:
    event printContractAddress(address Object);
    
    
    
    
    
}