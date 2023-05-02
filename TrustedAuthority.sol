pragma solidity ^0.8.0;

contract Solution {
    uint256 public a;
    uint256 public r;
    uint256[] del;
    uint256[] rangePHI = [97, 99, 60, 100, 63, 83]; //temperature, heart rate, weight (assumption 6 ft person)
    uint256[] normal = [98, 80, 73];
    uint256[] generator; 
    uint256[] id;
    uint256[] hashArray;
    uint256[] finalHash;
    uint256[] mapArray;
    uint256[] C_i;
    address contractB = 0xC588fFb141b4cFc405BD87BB4793C49eAA4E9Bf5;

    function intializeA() public {
        a = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 24;
    }

    function intializeR () public {
        r = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 24;
    }

    function del_calculator() public {
        require(rangePHI.length % 2 == 0, "Array length must be even");
        for (uint256 i = 0; i < rangePHI.length; i += 2) {
            uint256 temp_del =  uint256(keccak256(abi.encodePacked(block.timestamp, i, block.difficulty))) % (rangePHI[i+1] - rangePHI[i]);
            del.push(temp_del);
            id.push(rangePHI[i]);
        }
    }

    function getID() public view returns (uint256[] memory) {
        return id;
    }

    function getDelta() public view returns (uint256[] memory) {
        return del;
    }

    function getPHIrange() public view returns (uint256[] memory) {
        return rangePHI;
    }

    function getGenerator() public view returns (uint256[] memory) {
        return generator;
    }

    function getHash() public view returns (uint256[] memory) {
        return hashArray;
    }

    function getBilinearPairing() public view returns (uint256[] memory) {
        return mapArray;
    }

    function getFinalHash() public view returns (uint256[] memory) {
        return finalHash;
    }

    function getC_i() public view returns (uint256[] memory) {
        return C_i;
    }

    function gen_calculator() public {
        require(del.length > 0, "First call the del_calculator function");

        for (uint256 i = 0; i < del.length; i++) {
            uint256 temp_gen = uint256(keccak256(abi.encodePacked(block.timestamp, i, block.difficulty))) % r;
            generator.push(temp_gen);
        }
    }

    function hash_and_id () public {
        for (uint256 i = 0; i < id.length; i++) {
            uint256 value = id[i];
            uint256 hashValue = uint256(keccak256(abi.encodePacked(value ** a)));
            hashArray.push(uint256(hashValue));
        }
    }

    function bilinear_pairing() public {
        for(uint256 i = 0; i < id.length; i++){
            uint256 temp = generator[i] ** r;
            uint256 map = temp + hashArray[i];
            mapArray.push(map);
        }
    }

    function final_Hash() public {
        for(uint256 i = 0; i < id.length; i++){
            uint256 hashResult = uint256(keccak256(abi.encodePacked(mapArray[i])));
            finalHash.push(hashResult);
        }
    }

   function calculating_Ci() public {
       for(uint i = 0; i < finalHash.length; i++){
           uint256 result = finalHash[i] ^ normal[i];
           C_i.push(result);
       }
   }
}
    
//    function getDataFromContractB(address contractB) public view returns (uint256) {
//         ContractB b = ContractB(contractB);
//         return b.getData();
    
// }
