pragma solidity ^0.8.0;

contract userMedical {
   uint256 r = 5;
   uint256 PK_MU;
   uint256 nonce = 12;
   uint256 beta;
   uint256[] del = [1, 30, 13];
   uint256[] S = [97, 98, 62, 90, 67, 68];
   uint256[] normal = [98, 80, 73];
   uint256[] S_updated;
   uint256[] id_updated;
   uint256[] C1;
   uint256[] C2;
   address contractB = 0x9279F54dAc3570d115AdB6083f85D05a4e6F41Ad;


   function ID_update() public {
    require(S.length % 2 == 0, "Array length must be even");

       for(uint256 i = 0; i < S.length; i += 2 ){
           uint256 temp1 = S[i];
           uint256 value = del[i/2];
            uint temp = temp1 + value;
           S_updated.push(temp);
            uint256 temp2 = S[i+1] + del[i/2];
            S_updated.push(temp2);
            id_updated.push(S[i]);
       }
   }

   function getUpdatedS() public view returns (uint256[] memory) {
        return S_updated;
    }

    function getIDnew() public view returns (uint256[] memory) {
        return id_updated;
    }

    function PKmu_calculator() public {
            beta = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % r;
            uint256 temp = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % r;
            uint256 privateKey = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % beta;
            PK_MU = privateKey;
            nonce = temp;
    }

    function C1_and_C2 () public {
        //uint256 N = nonce;
        for(uint256 i = 0; i < id_updated.length; i++){
            uint256 value = id_updated[i];
            uint256 C1_ = uint256(keccak256(abi.encodePacked(value ** r)));
            C1.push(C1_);
            uint256 temp = C1_ +beta + nonce + (i+1);
            uint256 C2_ = uint256( keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 2;
            C2.push(C2_);
        }
    }

    // function bilinear_pairing() public {
    //     for(uint256 i = 0; i < id.length; i++){
    //         uint256 temp = generator[i] ** r;
    //         uint256 map = temp + hashArray[i];
    //         mapArray.push(map);
    //     }
    // }
    
    function getDataFromContractB(address contractB) public view returns (uint256) {
        ContractB b = ContractB(contractB);
        return b.getData();

    }
}