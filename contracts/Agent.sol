/*
agent works between client and owner.each time a client needs a capability, agent sends client's reques to 
owner, and gives data back to client.
*/
pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
import "./Owner.sol";
import "./Client.sol";
import "./Resource.sol";
import "./Capability.sol";
import "./Token.sol";

contract Agent{
    
    /*
    client_information maps client's chain address to it's created Client contract's address.
    */
    mapping(address=>address) clients_information;
    address [] clients_store = new address[](0);
    
    /*
    owner_information maps owner's chain address to it's created Owner contract's address.
    */
    mapping(address=>address) owners_information;
    address [] owners_store = new address[](0);
    
    //This section related to creating and returning client and owner:===========================
    
    /*
    createClient, creates an instance of Client Contract and links client's chain address to Client Contract address.
    */
    function createClient(string memory _name,string memory _ip) 
    public{
        address temp_client_address = msg.sender;
        Client new_client = new Client(_name,_ip,temp_client_address);
        clients_information[temp_client_address] = address(new_client);
        clients_store.push(temp_client_address);
        emit printContractAddress(temp_client_address,address(new_client));
    }
    
    /*
    createOwner, creates an instance of Owner Contract and links owner's chain address to Owner Contract address.
    */
    function createOwner(string memory _name, string memory _ip) 
    public{
        address temp_owner_address = msg.sender;
        Owner new_owner = new Owner(_name,_ip,temp_owner_address);
        owners_information[temp_owner_address] = address(new_owner);
        owners_store.push(temp_owner_address);
        emit printContractAddress(temp_owner_address,address(new_owner));
    }
    
    /*
    getOwnerContractAddress, returns Owner Contract's address linked to Owner chain address.
    */
    function getOwnerContractAddress(address _owner_chain_address) 
    public 
    view 
    returns(address){
        return owners_information[_owner_chain_address];
    }
    
    /*
    getCient, returns Client Contract's address, linked to client chain address.
    */
    function getCientContractAddress(address _client_chain_address) 
    public 
    view 
    returns(address){
        return clients_information[_client_chain_address];
    }
    
    /*
    getOwnerList, prints all owners as event on blockchain.
    */
    function getOwnersList()
    public{
        for(uint256 i = 0 ; i < owners_store.length ; i++){
            emit printOwnerAddress(address(owners_store[i]));
        }
    }

    
    /*
    getClientsList, prints all Clients as event on blockchain.
    */
    function getClientsList()
    public{
        for(uint256 j = 0 ; j < clients_store.length ; j++){
            emit printClientAddress(address(clients_store[j]));
        }
    }

    //Steps to respond Clients and Owners:==============================================
    
    /*
    requestOwnerCapability, responses to requests from Clients for Capability.
    */
    function requestOwnerCapability(address _owner_chain_address,
    address _object_chain_address,address _client_chain_address,bool _read_request,
    bool _write_request,bool _exec_request)
    public
    returns (bool){
        Owner temp_contract_owner = Owner(owners_information[_owner_chain_address]);
        address client_contract_address = msg.sender;
        //check: is client's address and it's related contract valid?
        if(clients_information[_client_chain_address] != client_contract_address){
            return false;
        }
        Client temp_client_contract = Client(msg.sender);
        Capability temp_capability;
        if(!temp_contract_owner.isBlocked(_client_chain_address)){
            temp_capability = Capability(temp_contract_owner.giveCapability(_client_chain_address,_object_chain_address,_read_request,
            _write_request,_exec_request));
            
            temp_client_contract.addCapability(_object_chain_address, temp_capability);
            emit capabilityCreationSuccess(_client_chain_address,_object_chain_address);
            return true;
        }
    }
    
    //requestToken() responses to requests for Creating Token from clients:
    //
    function requestToken(Capability _subject_capability, address _client_chain_address) 
    public
    returns (bool){
        uint256 default_timer = 600; //10 minutes.
        //check: is capability valid?
        address temp_owner_address = _subject_capability.getParrentNode();
        // address temp_resource_address = _subject_capability.getResourceAddress(); //for Future
        Owner temp_owner_contract = Owner(owners_information[temp_owner_address]);
        /*Code Here, use Owner*/
        if(temp_owner_contract.checkCapability(_subject_capability,_client_chain_address)){
            Token new_token = new Token(_subject_capability,now+default_timer,address(this));
            emit printToken(_client_chain_address,new_token);
            return true;
        }
        
    }
    
    
    
    
    //Event:=======================================================================================
    event printContractAddress(address Chain_Address, address Contract_Address);
    event capabilityCreationFailed(address,address);
    event capabilityCreationSuccess(address Client_Chian_Address,address Resource_Chain_Address);
    event printToken(address Client, Token Created_Token);
    event printOwnerAddress(address Owner_Address);
    event printClientAddress(address Client_Address);
    
}