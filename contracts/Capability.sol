pragma solidity 0.5.8;
// import "./Info.sol";
contract Capability{
    struct Cap{
        address subject_address;
        address object_address;
        bool read_right;
        bool write_right;
        bool exec_right;
        
    }
}