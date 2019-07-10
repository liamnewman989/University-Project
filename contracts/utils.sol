pragma solidity 0.5.8;
// pragma experimental ABIEncoderV2;
contract Util{

    function addressToString(address _address) public pure returns (string memory) {
        //addressToString function, takes an address and returns string form of this address.
        //using this function to use hash functions in smart contracts.
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            b[i] = byte(uint8(uint(_address) / (2**(8*(19 - i)))));
        }
        return string(b);
    }
  
    
    function addressToByte(address _address) public pure returns (bytes memory) {
        //addressToString function, takes an address and returns string form of this address.
        //using this function to use hash functions in smart contracts.
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            b[i] = byte(uint8(uint(_address) / (2**(8*(19 - i)))));
        }
        return b;
    }
    
    // function bytesToAddress (bytes memory _address) public pure returns (address) {
    //     uint result = 0;
    //     for (uint i = 0; i < _address.length; i++) {
    //         uint c = uint(_address[i]);
    //         if (c >= 48 && c <= 57) {
    //             result = result * 16 + (c - 48);
    //         }
    //         if(c >= 65 && c<= 90) {
    //             result = result * 16 + (c - 55);
    //         }
    //         if(c >= 97 && c<= 122) {
    //             result = result * 16 + (c - 87);
    //         }
    //     }
    // return address(result);
    // }
}