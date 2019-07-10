pragma solidity 0.5.8;
import "./utils.sol";
contract Capability{
    Util Utility = new Util();
    /*
    create structure of nodes:
    */
    struct Node{
        address parrent_node;
        address client_node_address;
        address [] path_from_root;
    }
    
    /*
    all attributes are optional for this work. but keep in mind tha i must define an array af attributes 
    for client who has this capability, to indiacte which attributes client can give others.
    */
    
    /*
    attribute array, is for attribute based encryptions.
    you add attributes to this araay,after that if you want to share some files with someone else,
    you can use this attributes to control who can access which data by using attribute based encryptions and decryptions.
    */
    string[] attributes;
    
    
    
    /*
    address of resource that this capability is created to use that.(chain address)
    */
    address resource_address;
    
    /*
    accesses to a specific resource.
    */
    bool read_access = false;
    bool write_access = false;
    bool exec_access = false;
    
    /*
    Delegation value shows, client of this capability can delegate this capability or not
    false shows he/she can't delegate and true shows he/she can.
    default value of this variable is false. this variable only can be set by owner and agent.
    agent request from owner, but owner can directly change this value.
    */
    bool delegation = false;
    
    /*
    delegation rights that can be delegate to others.
    if delegation is equal false, these values are not important.
    also these values will be set only by agent and owner.
    */
    
    bool read_delegation = false;
    bool write_delegaation = false;
    bool exec_delegation = false;
    
    /*
    hash value of parrent's path.
    */
    bytes32 parrent_path_hash;
    
    /*
    capability validation bit.
    */
    bool capability_valid = true;
    
     //sha256 hash of this node address:
    bytes converted_address = bytes(Utility.addressToByte(node_info.client_node_address));
    bytes32 client_address_hash = sha256(converted_address);
    
    Node node_info;
    
    
//Functions:==============================================================
    function setCapability(address _parrenet,address _client_address, address _resource_address, 
    bool _read_access, bool _write_access, bool _exec_access) 
    public
    returns (bool){
        node_info.parrent_node = _parrenet;
        node_info.client_node_address = _client_address;
        read_access = _read_access;
        write_access = _write_access;
        exec_access = _exec_access;
        resource_address = _resource_address;
        node_info.path_from_root.push(_parrenet);
        parrent_path_hash = parrentsHash();
        
        return true;
    }
    
    //parrentsHash returns all parrent nodes from root to parrent who gave this Capability address hash,
    function parrentsHash() 
    public
    returns (bytes32){

        bytes32 temp_hash ;//= sha256(Utility.addressToByte(node_info.path_from_root[0]));
        for(uint256 i = 0;i<node_info.path_from_root.length;i++){
            temp_hash = (sha256(Utility.addressToByte(node_info.path_from_root[i])) ^ temp_hash);
        }
        
        emit printHash(temp_hash);
        return temp_hash;
    }
    
    function getClientHash() 
    public 
    returns(bytes32){
        emit printHash(client_address_hash);
        return client_address_hash;
    } 
    
    function getParrentHash()
    public
    returns (bytes32){
        emit printHash(parrent_path_hash);
        return parrent_path_hash;
    }
    
    function getParrentPath()
    public
    returns (address[] memory)
    {
        for(uint i = 0; i<node_info.path_from_root.length; i++){
            emit printAddress(node_info.path_from_root[i], i);
        }
        return node_info.path_from_root;
    }
    
    //getParrentNode returns address of Node that gave this capability.
    function getParrentNode()
    public
    view
    returns (address){
        return node_info.parrent_node;
    }
    
    //getNode Returns address of current node.
    function getNode()
    public
    view
    returns(address){
        return node_info.client_node_address;
    }
    
    /*
    setDelegation, sets value of delegation value.
    */
    function setDelegation(bool _delegation)
    public
    returns (bool){
        delegation = _delegation;
        return true;
    }
    
    /*
    setDelegationRights, sets rights a client can give them as an access right to others.
    */
    function setDelegationRights(bool _read_delegation, bool _write_delegation , bool _exec_delegation)
    public
    returns (bool){
        read_delegation = _read_delegation;
        write_delegaation = _write_delegation;
        exec_delegation = _exec_delegation;
        
        return true;
    }
    /*
    getDelegation, returns false or true if a client can delegate something or not.
    */
    function getDelegation()
    public
    view
    returns (bool){
        return delegation;
    }
    /*
    getDelegationRights, returns right a client can give them to others.
    */
    function getDelegationRights()
    public
    returns(bool,bool,bool){
        emit printDelegationRights(read_delegation, write_delegaation, exec_delegation);
        return (read_delegation,write_delegaation,exec_delegation);
    }
    
    /*
    setCapabilityValidatoin:
    */
    function setCapabilityValidatoin(bool _capability_valid)
    public
    returns (bool){
        capability_valid = _capability_valid;
    }
    
    /*
    getCapabilityValidation:
    */
    function getCapabilityValidation()
    public
    returns (bool){
        emit printIsCapabilityValid(capability_valid);
        return capability_valid;
    }
    
    /*
    addAttribute, adds attribute to attributes array:
    */
    function addAttribute(string memory _attr)
    public
    returns (bool){
        attributes.push(_attr);
        return true;
    }
    
    /*
    getAttribute function, returns all attributes related to this capability.
    */
    function getAttribute() 
    public{
        for(uint i=0; i<attributes.length; i++){
            emit printAttributes(address(this), attributes[i]);
        }
    }
    
    /*
    getResourceAddress, returns resource's chain address.
    */
    function getResourceAddress()
    public
    returns (address){
        emit printResourceAddress(resource_address);
        return resource_address;
    }
    
    
    //Events Definitions:======================================
    event printHash(bytes32 Hashed_Value);
    event printAddress(address Address, uint Node_Number);
    event printAccess(bool Read,bool Write,bool Execution);
    event printDelegationRights(bool Read,bool Write,bool Execution);
    event printIsCapabilityValid(bool IsCapabilityValid);
    event printAttributes(address Capability_Address, string Attribute);
    event printResourceAddress(address Resource_Address);
}