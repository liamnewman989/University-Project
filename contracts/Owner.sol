pragma solidity 0.5.8;
import "./Info.sol";
import "./Resource.sol";

contract Owner is Info {
    AddressInfo owner_address;
    Resource[] resources = new Resource[](0);
    //functions to setup and get owner Information:
    //setOwnerAddress function sets the ip and nae an blockchain address of owner:
    //@param _name: real name of owner.
    //@param _ip: IP address of owner.
    //@param _chain_address retrieved from msg.sender.
    function setOwnerAddress(string memory _name,string memory _ip)
    public
    {
        owner_address.name=_name;
        owner_address.ip=_ip;
        owner_address.chain_address=msg.sender;
    }
    
    function getOwnerAddress() 
    public 
    view 
    returns(string memory, string memory,address){
        return (owner_address.name, owner_address.ip, owner_address.chain_address);
    }
    
    //functions to set and get resource properties:
    function addResource(string memory name, string memory ip, address chain_address) public{
        Resource new_instance = new Resource(name,ip,chain_address);
        resources.push(new_instance);
    }
    
    function getResources()
    view
    public
    returns(string memory,string memory,address){
        (string memory name, string memory ip,address addr) = resources[0].getResourceInfo();
        return(name,ip,addr);
    }
}

//in this section we create Events:





//ends