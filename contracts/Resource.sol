pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
import "./Info.sol";

contract Resource is Info{
    //Variable Decleration:
    //resource_address contains resource chain_address and IP and a name.
    //we will put options to manipulate IP by DNS Smart Contract,
    //but changing name and chain address will be changed just by Owner.
    AddressInfo resource_address;
    
    //Owner contains Owner's address. 
    address owner_contract = msg.sender;
    
    //Functions Definitions:
    //constructor of Resource Object
    constructor(string memory _name,string memory _ip, address _chain_address) 
    public{
        resource_address.name = _name;
        resource_address.ip = _ip;
        resource_address.chain_address = _chain_address;
    }
    
    //still we use this function to edit object properties,
    //but in furure  i think, i'm gonna split this function to set IP by DNS Smart Contracts
    //and a function, just owner can change object address.
    function setResourceAddress(string memory _name,string memory _ip, address _chain_address) 
    public{
        resource_address.name = _name;
        resource_address.ip = _ip;
        resource_address.chain_address = _chain_address;
    }
    
    //getResourceInfo, returns name,IP and address of an object
    function getResourceInfo()
    public
    view
    returns(string memory, string memory , address) {
        return(resource_address.name, resource_address.ip, resource_address.chain_address);
        
    }
    //getResourceOwner returns just Owner's address of this object,
    //then using this address to request for accessing and controlling Subjects.
    function getResourceContract()
    public
    view
    returns(address) {
        return(owner_contract);
    }
    //

}






