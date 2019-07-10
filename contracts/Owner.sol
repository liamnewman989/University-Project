pragma solidity 0.5.8;
import "./Info.sol";
import "./Resource.sol";
import "./Capability.sol";

contract Owner {
    
    /*
    owner_address contains information like name,IP and chain address.
    */
    Info.AddressInfo owner_address;
    
    /*
    black_list, contains all addresses we want not to serve them, 
    after adding, they remain in this list, but __bool__ value, will be true if they should get services,
    and if that value is equal to true, that client isn't in black list any more.
    */
    mapping (address=>bool) black_list;
    
    //resource managment section:==========================================
    /*
    resource_store, saves all resources addresses (chain address).
    
    resources mapping takes resource's address and maps it to a validity  value.
    if that value is true, the resource is still usable and can serve to others.
    
    using resources_info, we can find Resource contract related to resource's chain address,
    this value takes real chain address, points to contract address.
    */
    
    address[] resource_store = new address[](0);
    mapping(address=>bool)resources;
    mapping(address=>Resource)resources_info; 
    
    
    //Capability List and validation section:===========================
    /*
    capability_list, takes client_chain_address and push a Capability to an array related to this client_chain_address.
    */
    mapping (address=>Capability[]) capability_list;
    /*
    capability_validation, takes address of a Capability object and checks if it returns true or false,
    if it's value is true, Capability object is valid, if it's value is false, Capability object is not valid.
    Capability contract(object) also has a variable called, capability_valid. we can use that instead of this variable.
    */
    mapping (address => bool) capability_validation;
    
    //functions defintions start here:=========================
    
    /*   
    Owner's constructor.
    */
    
    constructor(string memory _name,string memory _ip, address _owner_address)
    public
    {
        //name of owner.
        owner_address.name=_name;
        //IP address of Owner.
        owner_address.ip=_ip;
        //owner's chain address.
        owner_address.chain_address=_owner_address;
    }
    
    /*
    getOwnerName, returns owner's name.
    */
    function getOwnerName() 
    public 
    returns(string memory){
        emit printOwnerName(owner_address.name);
        return (owner_address.name);
    }
    
    /*
    getOwnerIP, returns owner's IP address.
    */
    function getOwnerIP() 
    public 
    returns(string memory){
        emit printOwnerIP(owner_address.ip);
        return (owner_address.ip);
    }
    
    /*
    getOwnerAddress,returns owner's chain address.
    */
    function getOwnerAddress() 
    public 
    returns(address){
        emit printOwnerAddress(owner_address.chain_address);
        return (owner_address.chain_address);
    }
    
    //functions to set and get resource properties added by owner:================================
    /*
    function addResource(), adds a Resource to owner's store.
    */
    function addResource(string memory _name, string memory _ip, address _chain_address) 
    public{
        Resource new_instance = new Resource(_name,_ip,_chain_address,owner_address.chain_address);
        //sets that owner has this resource now and usable.
        resources[_chain_address] = true;
        //links resource's chain address to it's contract's address.
        resources_info[_chain_address] = new_instance;
        //adds resource's address to owner's store.
        resource_store.push(_chain_address);
    }
    
    /*
    getResources() retuerns all owner's resorces as events, then we use these events in our front-end program.
    */
    function getResources()
    public
    {
        //temporary resource's name.
        string memory temp_name;
        //temporary resource's IP address.
        string memory temp_ip;
        //temprary resource's chain address.
        address temp_address;
        //loop through resource_store and returns it's values.
        for(uint index = 0; index < resource_store.length; index++){
            //checks if resource is still available or not.
            if(resources[address(resource_store[index])]){
                //using Resource's getResourceInfo() function, we print resources information.
                (temp_name,temp_ip,temp_address) = (resources_info[address(resource_store[index])]).getResourceInfo();
                emit printResourceEvent(temp_name,temp_ip,temp_address);
            }
        }
        
    }
    
    /*
    getResourcesContract() takes resource_chain_address and returns contract linked to this chain address.
    */
    function getResourcesContract(address _resource_chain_address)
    public
    returns (address)
    {
        emit printResourcesContract(address(resources_info[_resource_chain_address]));
        return address(resources_info[_resource_chain_address]);
    }

    /*
    in this section we define functions to add addresses to black_list,
    remove them from black_list and check if an address is in black_list or not.
    */
    
    /*
    addBlackList() adds an address to black_list array, we have no service for addresses in black_list.
    */
    function addToBlackList(address _address_to_block) 
    private 
    returns(bool){
        black_list[_address_to_block] = true;
        emit printAddToBlackList(_address_to_block);
        return true;
    }
    
    /*
    removeFromBlackList() function sets an address's related value to false,
    this means, this address is no longer in black_list.
    */
    function removeFromBlackList(address _unblock_address)
    public
    returns(bool){
        black_list[_unblock_address] = false;
        emit printRemoveFromBlackList(_unblock_address);
        return true;
    }
    /*
    isBlocked() checks black_list and retrns true if an address is in black_list.
    */
    function isBlocked(address _check_address) 
    public 
    returns(bool){
        if(black_list[_check_address]){
            //if given address is in black list, returns true.
            emit printIsInBlackList(_check_address);
            return true;
        }
        else{
            emit printIsNotInBlackList(_check_address);
            return false;
        }
    }
    
    /*
    Here we define functions to add,remove or edit and check Capabilities:
    addCapability() functon, adds a capabilty for a Client.
    */
    
    function giveCapability(address _client_chain_address,address _resource_chain_address, bool read,
    bool write,bool exec)
    public
    returns (Capability){
        
        Capability temp_client_capability = new Capability();
        //set Capability's Properties:
        temp_client_capability.setCapability(owner_address.chain_address,_client_chain_address,_resource_chain_address,
        read,write,exec);//,_read_del,_write_del,_exec_del);
        
        capability_list[_client_chain_address].push(temp_client_capability);
        emit printGiveCapability(address(temp_client_capability));
        return temp_client_capability;
    }
    
    /*
    checkCapability() checks if a Capability exists in array or still valid:
    */
    function checkCapability(Capability _to_be_checked_capability,address _client_address)
    public
    returns (bool){
        Capability [] memory temp_capability_array = capability_list[_client_address];
        
        if(temp_capability_array.length == 0){
            return false;
        }
        
        for(uint256 i=0;i<temp_capability_array.length;i++){
            if(temp_capability_array[i] == _to_be_checked_capability){
                if(Capability(_to_be_checked_capability).getCapabilityValidation()){
                    return true;
                }else{
                    return false;
                }
            }
        }
        //if no one of those conditions, return false.
        return false;
    }
     
    

    //Event Defintions:====================================================================
    event printResourceEvent(string Name, string IP, address ChainAddress);
    event accessDenied(address Subject, address Objesct);
    event printOwnerName(string Owner_Name);
    event printGiveCapability(address Capability_Address);
    event printIsNotInBlackList(address Check_Address);
    event printIsInBlackList(address Check_Address);
    event printRemoveFromBlackList(address Unblocked_Address);
    event printAddToBlackList(address Blocked_Address);
    event printResourcesContract(address Resource_Contract);
    event printOwnerAddress(address Owner_Address);
    event printOwnerIP(string Owner_IP);
}


//ends