pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
import "./Info.sol";
import "./Token.sol";

contract Resource {
    /*
    Variable Decleration:
    resource_address contains resource chain_address and IP and a name.
    we will put options to manipulate IP by DNS Smart Contract,
    but changing name and chain address will be done just by Owner.
    */
    
    Info.AddressInfo resource_address;
    /*
    owner_address, contains owner's chain address.
    */
    address owner_address;
    
    /*
    owner_contract, contains contract's address related to owner's chain address.
    in other word, this variable contains address of Owner contract instance.
    */
    address owner_contract;
    
    //Lists to save Tokens:
    //An array to save all, and a mapping structure to save validation of tokens.
    mapping(address=>bool) token_validation;
    Token[] token_list = new Token[](0);
    
    //Functions Definitions:
    //constructor of Resource Object
    constructor(string memory _name,string memory _ip, address _chain_address, address _owner_address) 
    public{
        //set name used to identify by owner.
        resource_address.name = _name;
        //set IP address of this resource in real network.
        resource_address.ip = _ip;
        //set chain address of this resource
        resource_address.chain_address = _chain_address;
        //set owner's chain address.
        owner_address = _owner_address;
        //set owner's contract chain address.
        owner_contract = msg.sender;
    }
    
    /*
    setResourceAddress, we use this function to edit resource properties,
    but in future  i think, i'm gonna split this function to set IP by DNS Smart Contracts
    and another function, just owner can change object address.
    */
    function setResourceAddress(string memory _name,string memory _ip, address _chain_address) 
    public{
        resource_address.name = _name;
        resource_address.ip = _ip;
        resource_address.chain_address = _chain_address;
    }
    
    /*
    getResourceInfo, returns name,IP and address of an object and sends a an event on Blockchain.
    */
    function getResourceInfo()
    public
    returns(string memory, string memory , address) {
        emit printResourceAddress(resource_address.name, resource_address.ip, resource_address.chain_address);
        return(resource_address.name, resource_address.ip, resource_address.chain_address);
    }
    
    /*
    getResourceOwner returns just Owner's Contract address of this resource,
    then using this address to request for accessing and controlling Subjects.
    */
    function getResourceOwnerContract()
    public
    returns(address) {
        emit printResourceOwnerContract(address(owner_contract));
        return address(owner_contract);
    }
    
    /*
    getResourceOwnerAddress, returns owner's chain address:
    */
    function getResourceOwnerAddress() 
    public 
    returns(address){
        emit printResourceOwnerAddress(address(owner_address));
        return address(owner_address);
    }
    
    /*
    addToken, takes a new created token and saves that in token_list array.
    this function is a helper, and used JUST by OWNER. agent create a Token
    and will send that token to owner, and owner adds that token to token_list using this function.
    */
    function addToken(Token _new_token)
    public 
    returns (bool){
        token_list.push(_new_token);
        token_validation[address(_new_token)] = true;
        return true;
    }
    
    /*
    removeToken, sets validation of a token to false.
    */
    function removeToken(Token _token_to_remove) 
    public 
    returns (bool){
        for(uint256 i = 0; i<token_list.length; i++){
            if (token_list[i] == _token_to_remove && token_validation[address(_token_to_remove)] == true){
                token_validation[address(_token_to_remove)]=false;
                return true;
            }
        }
        emit printFaild("Can not find token.");
        return false;
    }
    
    /*
    renewToken, if a token is expired, and if the client who has this token is not 
    in our blacklist, the token can be renewed by owner.
    owner will use this function to serve agent's request.
    */
    function renewToken(Token _token_to_renew) 
    public 
    returns (bool){
        for(uint256 i = 0; i<token_list.length; i++){
            if (token_list[i] == _token_to_renew){
                token_validation[address(_token_to_renew)]=true;
                return true;
            }
        }
        emit printFaild("Can not find token.");
        return false;
    }
    
    //Events:================================================================
    event printResourceAddress(string Resource_Name, string Resource_IP, address Resource_Address);
    event printResourceOwnerContract(address Owner_Contract_Address);
    event printResourceOwnerAddress(address Owner_Chain_Address);
    event printFaild(string Message);

}
