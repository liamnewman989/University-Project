//Token Contract .....
pragma solidity 0.5.8;
import "./Capability.sol";
contract Token {
    Capability usable_capability;
    uint256 valid_period;
    address agent;
    
    constructor(Capability _created_cap,uint256 timer,address agent_creater)
    public{
        usable_capability = _created_cap;
        valid_period = now + timer;
        agent = agent_creater;
    }
    /*
    setTimer used just for renewing the token.
    */
    function setTimer(uint256 _valid_period) 
    public
    returns (bool){
        valid_period = now + _valid_period;
        return true;
    }
    /*
    getTimer returns a uint256 value, used for checking if token is valid or not
    */
    function getTimer()
    public
    returns (uint256){
        emit printTimer(valid_period);
        return valid_period;
    }
    
    function getCapability()
    public
    returns (address){
        emit printCapabilityAddress(address(usable_capability));
        return address(usable_capability);
    }
    
    //Events:============================================================
    event printTimer(uint256 Valid_Timer);
    event printCapabilityAddress(address Capability_Address);
}