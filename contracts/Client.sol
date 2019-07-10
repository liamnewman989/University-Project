/*
client has a list of Capabilities. what is Capability? it's something like this structure:
|||address of object client wants some service from that| and rights of client on that object.|||
we collect all these Capabilities to capabilitya_list of client.
*/
pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
import "./Capability.sol";
import "./Info.sol";
import "./Agent.sol";
import "./Token.sol";

contract Client{
    
    /*variables:
    client_info: saves all information about client, such as IP, chain address and name.
    */
    Info.AddressInfo client_info;
    
    /*
    agent_addr, saves agent contract address. we use this to interact with Owners.
    */
    address agent_addr ;
    
    /*
    capability_list, takes resource's address and relates a Capability to that .
    when we need to use a resource, we will search this dictionary for resource's address and then return Capability
    related to that resource.
    */
    mapping(address => Capability) capability_list;
    
    /*
    capability_token, takes address of Capability and relates it to token's address.
    */
    mapping(address=>address) capability_token;
    
    /*
    token_validity, takes token's address and relates it to validity of that token. 
    */
    mapping (address=>bool) token_validity;
    
    
    
    constructor(string memory _name,string memory _ip,address _client_address) 
    public{
        //client's name.
        client_info.name = _name;
        //client's IP address.
        client_info.ip=_ip;
        //client's chain address.
        client_info.chain_address = _client_address;
        //agent's contract address.
        agent_addr = msg.sender;
    }
    
    /*
    agent calls this function to add a token to toke's list.
    */
    function addToken(Token _new_token) 
    public 
    returns (bool){
        capability_token[_new_token.getCapability()] = address(_new_token);
        token_validity[address(_new_token)] = true;
        
        return true;
    }
    
    /*
    agent calls this function to revoke a token.
    */
    function removeToken(Token _remove_token)
    public
    returns (bool){
        if(!token_validity[address(_remove_token)]){
            return false;
        }
        token_validity[address(_remove_token)] = false;
        return true;
    }
    
    /*
    addCapability, adds Capabilities to capabilitya_list.
    needs address of resource and relates it to capabilitya_list.
    */
    function addCapability(address _resource_addr, Capability _capability) 
    public 
    returns(bool){
        capability_list[_resource_addr] = _capability;
        return true;
    }
    
    /*
    getResourceCapability, takes address of resource and returns address of Capability.
    */
    function getResourceCapability(address _resource_address) 
    public
    returns (address){
        emit printResourceCapability(_resource_address, address(capability_list[_resource_address]));
        return address(capability_list[_resource_address]);
    }
    
    //This Section Related to Request capability and tokens.====================
    
    /*
    requestCapability, sends request to an agent and requset capability from an owner for 
    a specific resource and 
    */
    function requestCapability(address _owner_chain_address, address _object_chain_address,
    bool _read_request,bool _write_request,bool _exec_request)
    public
    returns (bool){
        Agent my_agent = Agent(agent_addr);
        if(bool(my_agent.requestOwnerCapability(_owner_chain_address,_object_chain_address,
        msg.sender,_read_request ,_write_request,_exec_request))){
            emit capabilityCreated(_object_chain_address);
            requestToken(_object_chain_address);
            return true;
        }else{
            emit capabilityDenied(_object_chain_address);
        }
    }
    
    //when we have Capabilities we can just request for Tokens,
    //Just Agent can create Tokens.
    function requestToken(address _object_address) 
    public{
        Agent my_agent = Agent(agent_addr);
        if(my_agent.requestToken(capability_list[_object_address], client_info.chain_address)){
            emit printTokenCreated(_object_address, address(capability_list[_object_address]));
        }else{
            emit printTokenCreationFailed(_object_address, address(capability_list[_object_address]));
        }
    }
    
    /*
    getClientIP, returns client's IP address.
    */
    
    function getClientIP()
    public
    returns (string memory){
        emit printClientIP(client_info.ip);
        return client_info.ip;
    }
    
    /*
    getClientChainAddress,returns client's chain address.
    */
    function getClientChainAddress()
    public
    returns (address){
        emit printClientChainAddress(client_info.chain_address);
        return client_info.chain_address;
    }
    
    /*
    getClientName, returns client's name.
    */
    function getClientName()
    public
    returns (string memory){
        emit printClientName(client_info.name);
        return (client_info.name);
    }
    
    /*
    getAgent, returns agent's contract address.(for later works).
    */
    function getAgent()
    public
    view
    returns (address){
        return agent_addr;
    }
    
    
    
    
    //EVENTS:==========================================================
    
    event capabilityCreated(address forUsing);
    event capabilityDenied(address);
    event printResourceCapability(address Resource_Address, address Capability_Address);
    event printTokenCreated(address Resource_Address, address Capability_Address);
    event printTokenCreationFailed(address Resource_Address, address Capability_Address);
    event printClientName(string Client_Name);
    event printClientChainAddress(address Client_Chain_Address);
    event printClientIP(string Client_IP);
}
