// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public arrSimpleStorage;

    function createSimpleStorageContract() public {
        SimpleStorage objSimpleStorage = new SimpleStorage();
        arrSimpleStorage.push(objSimpleStorage);
    }
    function sfStore(uint256 _favoriteNumber, uint256 index) public {
        //SimpleStorage obj = arrSimpleStorage[index];
        SimpleStorage obj = SimpleStorage(address(arrSimpleStorage[index]));
        obj.store(_favoriteNumber);
    }
    function sfRetrieve(uint256 index) public view returns(uint256) {
        SimpleStorage  obj = SimpleStorage(address(arrSimpleStorage[index]));
        return obj.retrieve();
    }
}
