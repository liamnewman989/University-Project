pragma solidity 0.5.8;
import "./Info.sol";
import "./Resource.sol";
import "./Capability.sol";

contract Owner {
    //owner_address is owner of resourcs.
    Info.AddressInfo owner_address;
    
    //a mapping to save addressws we do not want to use our services:
    //when an address added to list, it's value will change to true,
    //we wo'nt delete any item from mapping, for removing an address from list
    //it's value wll chnage to false.
    mapping (address=>bool) black_list;
    
    //resources mapping keeps address of an object,
    //if owner has that object, it's value goes to true,
    //else the vlaue is equal to false or address is not in resources mapping.
    //resources_info mapping helps us to find all information about
    //existing object's address;
    address[] resource_index = new address[](0);
    mapping(address=>bool)resources;
    mapping(address=>Resource)resources_info;
    
    //Capability List;
    mapping(address => Capability.Cap) capability_list;
    
    
    //functions defintions start here:=========================
    
    //functions to setup and get owner Information:
    //setOwnerAddress function sets the ip and nae an blockchain address of owner:
    //@param _name: real name of owner.
    //@param _ip: IP address of owner.
    //@param _chain_address retrieved from msg.sender.
    constructor(string memory _name,string memory _ip)
    public
    {
        owner_address.name=_name;
        owner_address.ip=_ip;
        owner_address.chain_address=tx.origin;
    }
    
    function getOwnerAddress() 
    public 
    view 
    returns(string memory, string memory,address){
        return (owner_address.name, owner_address.ip, owner_address.chain_address);
    }
    
    //functions to set and get resource properties added by owner:
    //function addResource()
    //
    function addResource(string memory name, string memory ip, address chain_address) public{
        Resource new_instance = new Resource(name,ip,chain_address);
        resources[chain_address] = true;
        resources_info[chain_address] = new_instance;
        resource_index.push(chain_address);
        
    }
    //this function retuerns all ownr's resorces as events,
    //then we use these evnts in our front-end program.
    function getResources()
    public
    {
        string memory name;
        string memory ip;
        address _addr;
        for(uint128 index=0;index<resource_index.length;index++){
            address _resource_temp_addr = resource_index[index];
            if(resources[_resource_temp_addr]){
                (name,ip,_addr) = (resources_info[_resource_temp_addr]).getResourceInfo();
                emit printResourceEvent(name,ip,_addr);
            }
        }
        
    }

    //in this section we define functions to add addresses to black_list,
    //remove them from black_list and check if an address is in black_list or not.
    
    //this functin adds addresses to black_list array, we have no service for black listed adresses.
    function addBlackList(address blocked) 
    private 
    returns(bool){
        //@param blocked: address
        black_list[blocked] = true;
        return true;
    }
    
    //removeBlackList function sets a address value to false,
    //this means, this address is no longer in black_list.
    function removeBlackList(address unblock) 
    private 
    returns(bool){
        //@param unblock: address
        black_list[unblock] = false;
        return true;
    }
    
    //this function checks black_list and retrns true
    //if an addressexists in black_list
    
    function isBlocked(address _addr) 
    private 
    view 
    returns(bool){
        if(black_list[_addr]){
            return true;
        }
        else{
            return false;
        }
    }
    
    //Here we define functions to add,remove or edit Capabilities:
    //addCapability() functon, adds a capabilty for a subject.
    
    function addCapability(address subject_addr,address object_addr, bool read, bool write,bool exec) private{
        //@param subject_addr: this is address of a subject w wnt to give it capablit.
        //@param object_addr: this is address of a object that subject wants to use it.
        //@param read: indicates if a subject has read permission or not.
        //@param write: indicates if a subject has write permission or not.
        //@param exec: indicates if a subject has execution permission or not.
        if(!isBlocked(subject_addr)){
            Capability.Cap memory subject_capability;
            subject_capability.subject_address = subject_addr;
            subject_capability.object_address = object_addr;
            subject_capability.read_right = read;
            subject_capability.write_right = write;
            subject_capability.exec_right = exec;
            capability_list[subject_addr] = subject_capability;
        }
        else{
            emit accessDenied(subject_addr,object_addr);
        }
        
 
    }
    
    // function checkCapability(){
        
    // }
    
    
    
    
    
    
    //Event Defintions:====================================================================
    event printResourceEvent(string Name, string IP, address ChainAddress);
    event accessDenied(address Subject, address Objesct);
}







//ends