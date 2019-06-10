pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
import "./Info.sol";

contract Resource is Info{
    AddressInfo resource_address;
    constructor(string memory _name,string memory _ip, address _chain_address) 
    public{
        resource_address.name = _name;
        resource_address.ip = _ip;
        resource_address.chain_address = _chain_address;
    }
    
    function setResourceAddress(string memory _name,string memory _ip, address _chain_address) 
    public{
        resource_address.name = _name;
        resource_address.ip = _ip;
        resource_address.chain_address = _chain_address;
    }
    
    function getResourceInfo()
    public
    view
    returns(string memory, string memory , address) {
        return(resource_address.name, resource_address.ip, resource_address.chain_address);
    }

}






