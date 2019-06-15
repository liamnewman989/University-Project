/*
client has a list of Capabilities. what is Capability? it's something like this structure:
|||address of object, client wants some service| and rights of client on that object.|||
we collect all these Capabilities to capabilitya_list of client.
*/
pragma solidity 0.5.8;
pragma experimental ABIEncoderV2;
import "./Capability.sol";
import "./Info.sol";

contract Client{
    //variable declarations:
    //client_info: information of client.
    Info.AddressInfo client_info;
    
    //a dictionary that takes an object address and returns Capability related to that object.
    //using mapping make it easy to update capability list.
    mapping(address => Capability.Cap) capabilitya_list;
    
    constructor(string memory _name,string memory _ip) public{
        client_info.name = _name;
        client_info.ip=_ip;
        client_info.chain_address = tx.origin;
    }
    
    //functions declarations:
    //addCapability, adds a Capability to capabilitya_list.
    function addCapability(address resource, Capability.Cap memory capab_ticket) public returns(bool){
        capabilitya_list[resource] = capab_ticket;
        return true;
    }
    
    //getCapability returns capability related to an object
    function getCapability(address resource) public view returns(Capability.Cap memory){
        return capabilitya_list[resource];
    }
    
    
  
}
